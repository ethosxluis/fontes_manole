//|=====================================================================|
//|Programa: F050IRF.PRW   |Autor: Marciane Gennari   | Data: 22/11/10  |
//|=====================================================================|
//|Descricao: Ponto de entrada para gravar histórico no titulo de IRRF  |
//|           Código da Retenção e Gera Dirf SIM.                       |
//|=====================================================================|
//|Sintaxe:                                                             |
//|=====================================================================|
//|Uso: Ponto de entrada da rotina FINA050                              |
//|=====================================================================|
//|       ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             |
//|---------------------------------------------------------------------|
//|=====================================================================|
#Include "rwmake.ch"

User Function F050IRF()
/*
  Local _cRotina  := Alltrim(FunName())
  Local _cCnpj    := ""
  Local _cMes     := "" 
  Local _cAno     := "" 
  
  If _cRotina == "FINA050" .or. _cRotina == "MATA103" .or. _cRotina == "FINA750" .Or. _cRotina == "CDAA040"
     
      _cMes     := Subs(Dtos(SE2->E2_VENCREA),5,2) 
      _cAno     := Subs(Dtos(SE2->E2_VENCREA),1,4) 
                                                                                     
      
      //--- Retornar o CNPJ da Matriz - sempre 01 é Matriz.
      //---  1o. parametro: 02 - CNPJ
      //---  2o. parametro: 01 - Filial 01
     // _cCnpj   :=  u_dadosSM0("02","01") 
 
     
     RECLOCK("SE2",.F.)
     If Empty(Alltrim(SE2->E2_CODRET))
        SE2->E2_CODRET  := "1708"
     EndIf
     SE2->E2_DIRF        := "1"
     SE2->E2_XCNPJC   := _cCnpj
     SE2->E2_XCONTR  := SM0->M0_NOMECOM   
     SE2->E2_E_APUR  := (CTOD("01"+"/"+_cMes+"/"+_cAno)-1)  //-- Competencia mes/ano - Ultimo dia do mes anterior a data do vencimento do imposto

//	 Alteração Edmar Mendes do Prado - 28/02/2014
//     SE2->E2_HIST       := _cRotina+" "+SE2->E2_CODRET
     SE2->E2_HIST       := U_GrvHisTx(ParamIxb, "IRRF " + SE2->E2_CODRET )
          
     MSUNLOCK()               
  
//  Else
//     RECLOCK("SE2",.F.)                          
//     SE2->E2_HIST       := U_GrvHisTx(ParamIxb, "IRRF " + SE2->E2_CODRET )
//     MSUNLOCK()               
  
  EndIf

*/

RETURN   