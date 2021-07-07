#include "Protheus.ch"
/*
+-----------------------------------------------------------------------------+
|Programa  : PAGARSAFRA                                                       |
|Descrição : Função única para o SAFRA                                        |
+-----------------------------------------------------------------------------+
|Autor     : 							                                      | 
|Observacao:                                                                  |
|                                                                             |
+-------------------------------------------------+--------+------------------+
|Alterado                                         |Em      | Por              |
|                                                 |DD/MM/AA|                  |                                                                                                                             |
+-----------------------------------------------------------------------------+

FORNECEDORES
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| CODIGO AGENCIA       |   PP001  |                     
| VALOR PAGTO          |   PP002  |                     
| VALOR DESCONTO       |   PP003  |                   
| VALOR ACRESCIMO      |   PP004  |                   
| DV CODIGO DE BARRAS  |   PP005  |                     
| FATOR VENCTO E VALOR |   PP006  |                     
| CAMPO LIVRE (CODBAR) |   PP007  |                     
+----------------------+----------+

TRIBUTOS
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| TIPO DO IMPOSTO  |   PT000  |                     
| DADOS DARF / GPS   / DARF SIMPLES / FGTS / IPVA / DPVAT  |   PT001  |                     
+----------------------+----------+

*/

User Function PagarSafra(_cOpcao)   

Local  _cTipo     := ""
Local  _cRetorno  := ""
Local  _cConta    := ""
Local  _cCampo    := ""
Local  _TtAbat    := 0.00
Local  _Liqui     := 0.00

_cTipo    := Alltrim(Upper(_cOpcao))

Do Case
	
    Case _cTipo == "PT001"	                           
 
         _cRetorno := ""                       
         
         //  Dados DARF  
         If SEA->EA_MODELO == "16"    
   
            // Posicao 021 a 022: Identificacao do Tributo 02-Darf 03-Darf Simples
            // _cRetorno := "02"                         

            // Posicao 056 a 085: Nome do Contribuinte                 
            If !Empty(SE2->E2_CNPJRET)
               _cRetorno += Subs(SE2->E2_NOMERET,1,30)
               If Empty(SE2->E2_NOMERET)
                  MsgAlert('Nome do Contribuinte não informado para a DARF - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
               EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      

			//Posicao 086 a 089: DDD Telefone
			_cRetorno += Space(04)
			
			//Posicao 090 a 097: Telefone
			_cRetorno += Space(08)

            // Posicao 098 a 098: Tp Identificador F-FISICA  /  J-JURIDICA               
           	If !Empty(SE2->E2_CNPJRET)
             	_cRetorno += Iif (len(alltrim(SE2->E2_CNPJRET))>11,"J","F")
           	Else               
            	_cRetorno += "J"       
           	EndIf

            // Posicao 099 a 112: N Inscricao  //--- CNPJ/CPF do Contribuinte
            If !Empty(SE2->E2_CNPJRET)
               _cRetorno += Strzero(Val(SE2->E2_CNPJRET),14)
            Else
               _cRetorno += Subs(SM0->M0_CGC,1,14)
            EndIf

            // Posicao 113 a 120: Periodo Apuracao
            _cRetorno += GravaData(SE2->E2_DTAPUR,.F.,5) 

            // Posicao 121 a 137: Referencia   
            _cRetorno +=  Strzero(Val(SE2->E2_NROREF),17)

            // Posicao 138 a 141: Codigo da Receita                                 
            _cRetorno += If(!Empty(SE2->E2_CODRET),STRZERO(Val(SE2->E2_CODRET),4),STRZERO(Val(SE2->E2_CODRET),4))
  
            // Posicao 142 a 156: Valor Principal
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 157 a 171: Multa             
            _cRetorno += STRZERO(SE2->E2_XMULTA*100,14)         
            
            // Posicao 172 a 186: Juros        
            _cRetorno += Strzero(SE2->E2_E_JUROS*100,14)          

            // Posicao 187 a 194: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 195 a 294: Observacoes
            _cRetorno += Subs(SE2->E2_TITPAI,1,99)           

            // Posicao 295 a 311: Compl.Registro                          
            _cRetorno += Space(16)                                                   
                                                          
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(SE2->E2_DTAPUR)                              
        
               MsgAlert('Tributo sem Data de Apuracao. Informe o campo Apuracao no titulo: '+Alltrim(SE2->E2_PREFIXO)+" "+Alltrim(SE2->E2_NUM)+" "+Alltrim(SE2->E2_PARCELA)+" Tipo: "+Alltrim(SE2->E2_TIPO)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
  
  
  
  /*
            
         // Dados GPS
         ElseIf (SEA->EA_MODELO == "17")   
   

            // Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
            //_cRetorno := "01"                                                       

            // Posicao 020 a 023: Codigo Pagamento                                 
            _cRetorno +=  STRZERO(Val(SE2->E2_CODREC),4)  
                                                 
            // Posicao 024 a 029: Competencia   MMAAAA  
            _cRetorno += STRZERO(MONTH(SE2->E2_E_APUR),2)+STRZERO(YEAR(SE2->E2_E_APUR),4)
            
            // Posicao 030 a 043: N Identificacao  //--- CNPJ/CPF do Contribuinte        
            If !Empty(SE2->E2_XCONTR)
                 If Empty(SE2->E2_XCNPJC)
     
                     MsgAlert('O titulo de tributo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+' do fornecedor '+alltrim(se2->e2_fornece)+" "+alltrim(se2->e2_loja)+' está sem o CNPJ/CPF do Contribuinte. Atualize os dados no titulo e execute esta rotina novamente.')
                 EndIf
               _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
           Else
                _cRetorno += Strzero(Val(SM0->M0_CGC),14)
           EndIf
  
            // Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)
            //Edmar em 24/08/2017 _cRetorno += Strzero((SE2->E2_SALDO-SE2->E2_E_VLENT)*100,14)                               
            _cRetorno += Strzero((SE2->E2_SALDO)*100,14)                               
            
            // Posicao 058 a 071: Valor Outras Entidades
            _cRetorno += Strzero(SE2->E2_E_VLENT*100,14)            
            
            // Posicao 072 a 085: Multa        
            _cRetorno += Strzero(SE2->E2_XMULTA+SE2->E2_E_JUROS*100,14)            
            
            // Posicao 086 a 099: Valor Total (Principal + Multa)
            _cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_E_JUROS)*100,14)              

            // Posicao 100 a 107: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                             

            // Posicao 108 a 115: Compl.Registro                          
            _cRetorno += Space(8)                                                   

            // Posicao 116 a 165: Informacoes Complementares              
            _cRetorno += Space(50)                                                  

            // Posicao 166 a 195: Nome do Contribuinte                                                  
            If !Empty(SE2->E2_XCNPJC)
               _cRetorno += Subs(SE2->E2_XCONTR,1,30)
               If Empty(SE2->E2_XCONTR)
                  MsgAlert('Nome do Contribuinte não informado para a GPS - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
               EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(se2->e2_e_apur)                             
        
               MsgAlert('Tributo sem Competencia. Informe o campo Apuração no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
                                                             

         //----- DARF SIMPLES
         ElseIf  SEA->EA_MODELO == "18"   
                                                                     
            // Posicao 018 a 019: Identificacao do Tributo  03-Darf Simples
            //_cRetorno := "03"                          

            // Posicao 020 a 023: Codigo da Receita  - Para DARF Simples - fixar código 6106
             _cRetorno += "6106"
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
            If !Empty(SE2->E2_XCNPJC)
                _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
            Else               
              _cRetorno += "2"       
            EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            If !Empty(SE2->E2_XCNPJC)
               _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
            Else
               _cRetorno += Subs(SM0->M0_CGC,1,14)
            EndIf
                                                 
            // Posicao 039 a 046: Periodo Apuracao
            _cRetorno += GravaData(SE2->E2_E_APUR,.F.,5) 
            
            // Posicao 047 a 055: Valor da Receita Bruta Acumulada
            _cRetorno += Repl("0",9) 
            
            // Posicao 056 a 059: % sobre a Receita Bruta Acumulada
            _cRetorno += Repl("0",4) 
            
            // Posicao 060 a 063: Compl.Registro                          
            _cRetorno += Space(4)                                                   

            // Posicao 064 a 077: Valor Principal
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 078 a 091: Multa             
            _cRetorno += STRZERO(SE2->E2_XMULTA*100,14)         
            
            // Posicao 092 a 105: Juros        
            _cRetorno += STRZERO(SE2->E2_E_JUROS*100,14)         
            
            // Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_E_JUROS)*100,14)           

            // Posicao 120 a 127: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 128 a 135: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 136 a 165: Compl.Registro                          
            _cRetorno += Space(30)                                                   

            // Posicao 166 a 195: Nome do Contribuinte                 
            If !Empty(SE2->E2_XCNPJC)
               _cRetorno += Subs(SE2->E2_XCONTR,1,30)
               If Empty(SE2->E2_XCONTR)
                  MsgAlert('Nome do Contribuinte não informado para a DARF Simples - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
               EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(se2->e2_e_apur)                              
        
               MsgAlert('Tributo sem Data de Apuracao. Informe o campo Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
  

         //--- GARE ICMS SP                  
         ElseIf SEA->EA_MODELO == "22" //--- GARE ICMS - SP
 
            // Posicao 018 a 019: Identificacao do Tributo  05-ICMS
            //_cRetorno := "05"                          

            // Posicao 020 a 023: Codigo da Receita                                 
            _cRetorno +=  STRZERO(Val(SE2->E2_CODREC),4)  
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
            _cRetorno += "2"       
            
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            _cRetorno +=  Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) //--- Funcao u_dadosSM0 está no fonte PAGAR356.PRW                               
  
            //--- Posicao 039 a 050: Inscricao Estadual-  
            _cRetorno +=  Strzero(Val(u_dadosSM0("01",SE2->E2_FILIAL)),12)   //--- Funcao u_dadosSM0 está no fonte PAGAR356.PRW                              
 
            //--- Posicao 051 a 063: Divida Ativa / Etiqueta  
            _cRetorno +=  Strzero(Val(SE2->E2_XDIVID),13)                               

            //--- Posicao 064 a 069: Periodo de Referencia (Mes/Ano)  Formato MMAAAA 
            _cRetorno += Strzero(Month(SE2->E2_E_APUR),2)+Strzero(Year(SE2->E2_E_APUR),4)  

            //--- Posicao 070 a 082: N. Parcela / Notificação  
            _cRetorno +=  Strzero(Val(SE2->E2_XPARCE),13)                               

            //--- Posicao 083 a 096: Valor da Receita (Principal) 
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)
     
            //--- Posicao 097 a 110: Valor Juros/Encargos 
            _cRetorno += Strzero(SE2->E2_E_JUROS*100,14)                              

            //--- Posicao 111 a 124: Valor da Multa              
            _cRetorno += Strzero(SE2->E2_XMULTA*100,14)     
            
            //--- Posicao 125 a 138: Valor do Pagamento              
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_E_JUROS)*100,14)           
            
            //--- Posicao 139 a 146: Data de Vencimento   Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCTO,.F.,5)                               

            //--- Posicao 147 a 154: Data de Pagamento-  Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCREA,.F.,5)                               

            //--- Posicao 155 a 165: Brancos                                   
            _cRetorno += Space(11)                                                      

            //--- Posicao 166 a 195: Nome do Contribuinte                                   
            If !Empty(SE2->E2_XCNPJC)
                _cRetorno += Subs(SE2->E2_XCONTR,1,30)
                If Empty(SE2->E2_XCONTR)
                  MsgAlert('Nome do Contribuinte não informado para o segmento N - GARE ICMS - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
                EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf   
  
         //--- 25 - IPVA SP   
         //--- 26 - Licenciamento
         //--- 27 - DPVAT              
         ElseIf SEA->EA_MODELO == "25"  .or. SEA->EA_MODELO == "26" .or. SEA->EA_MODELO == "27" 
   
              //--- Posicao 018 a 019: Identificacao do Tributo  07-IPVA e 08-DPVAT
              _cRetorno := If(SEA->EA_MODELO=="25","07","08")  
              
              //--- Posicao 020 a 023 - Brancos
              _cRetorno += Space(4)                        
    
              // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
              If !Empty(SE2->E2_XCNPJC)
                  _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
              Else               
                _cRetorno += "2"       
              EndIf
  
              // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
              If !Empty(SE2->E2_XCNPJC)
                 _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
              Else
                 _cRetorno += Subs(SM0->M0_CGC,1,14)
              EndIf
                                                 
              //--- Posicao 039 a 042 - Exercicio Ano Base  
              _cRetorno += Strzero(SE2->E2_ANOBAS,4)                               

              //--- Posicao 043 a 051 - Renavam  
              _cRetorno +=  Strzero(Val(SE2->E2_RENAV),9)                               
                                                                           
              //--- Posicao 052 a 053 - Unidade Federação   
             _cRetorno +=  Upper(SE2->E2_IPVUF)                               

             //--- Posicao 054 a 058 - Codigo do Municipio  
             _cRetorno += Strzero(Val(SE2->E2_CODMUN),5)    

             //--- Posicao 059 a 065 - Placa   
             _cRetorno +=  SE2->E2_PLACA                              

             //--- Posicao 066 a 066 - Opção de Pagamento - Para DPVAT sempre opção 0
             If SEA->EA_MODELO == "25"
                _cRetorno += Alltrim(SE2->E2_OPCAO)
            Else
                  _cRetorno += "0"   //--- Para 27-DPVAT e 26-Licenciamento é obrigatório utilizar o código 0.
            EndIf
     
            //--- Posicao 067 a 080 - Valor do IPVA/DPVAT  
            _cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
     
            //--- Posicao 081 a 094 - Valor do Desconto                         
            _cRetorno += Strzero(SE2->E2_DECRESC*100,14)                              

            //--- Posicao 095 a 108 - Valor do Pagamento               
            _cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,14)     
 
            //--- Posicao 109 a 116: Data de Vencimento   Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCTO,.F.,5)                               

            //--- Posicao 117 a 124: Data de Pagamento-  Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCREA,.F.,5)                               

            //--- Posicao 125 a 165: Brancos                                   
            _cRetorno += Space(41)                                                      

            //--- Posicao 166 a 195: Nome do Contribuinte                                   
            If !Empty(SE2->E2_XCNPJC)
                _cRetorno += Subs(SE2->E2_XCONTR,1,30)
                If Empty(SE2->E2_XCONTR)
                  MsgAlert('Nome do Contribuinte não informado para o segmento N (IPVA/DPVAT)- Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
                EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf   
 
         //--- 35 - FGTS              
         ElseIf SEA->EA_MODELO == "35" 

            // Posicao 018 a 019: Identificacao do Tributo  11-FGTS-GFIP
            _cRetorno := "11"                          

            // Posicao 020 a 023: Codigo da Receita  
            _cRetorno +=  STRZERO(Val(SE2->E2_CODREC),4)  
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
            If !Empty(SE2->E2_XCNPJC)
                _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
            Else               
              _cRetorno += "2"       
            EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            If !Empty(SE2->E2_XCNPJC)
               _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
            Else
               _cRetorno += Subs(SM0->M0_CGC,1,14)
            EndIf
                                                 
            // Posicao 039 a 086: Codigo de Barras
            _cRetorno += SE2->E2_CODBAR 
            
            // Posicao 087 a 102: Identificador do FGTS
            _cRetorno += Strzero(Val(SE2->E2_IDENT),16)                           
            
            // Posicao 103 a 111: Lacre de Conectividade Social
            _cRetorno += Strzero(Val(SE2->E2_LACRE),9)
             
            // Posicao 112 a 113: Digito do Lacre de Conectividade Social
            _cRetorno += Strzero(Val(SE2->E2_DGLACR),2)
             
            // Posicao 114 a 143: Nome do Contribuinte                 
            If !Empty(SE2->E2_XCNPJC)
               _cRetorno += Subs(SE2->E2_XCONTR,1,30)
               If Empty(SE2->E2_XCONTR)
                  MsgAlert('Nome do Contribuinte não informado para o FGTS - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
               EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
            
            // Posicao 144 a 151: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 152 a 165: Valor do Pagamento
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_E_JUROS-SE2->E2_DECRESC)*100,14)           

            // Posicao 166 a 195: Compl.Registro                          
            _cRetorno += Space(30)                                                   
         */
         
         EndIf     
  
  
    Otherwise  //  Parametro não existente
      
	 MsgAlert('Não foi encontrado o Parametro '+ _cTipo + "."+;
                  'Solicite à informática para verificar o fonte PAGARSAFRA, ou o arquivo de configuração do CNAB.')

EndCase		      

return(_cRetorno)


