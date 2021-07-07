#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RFINR20  º Autor ³ Rodrigo Franco     º Data ³  24/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Extrato Manole                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EDITORA MANOLE                                             º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFINR20


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Extrato Manole"
Local cPict          := ""
Local titulo         := "Relatorio Extrato Manole"
Local nLin           := 80

Local Cabec1       := "  Nome                          Data de Vencimento            Valor         Efetivado    Tipo  Prefixo Numero          Parc Natureza                            Serviço         "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFINR20" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RFIR20"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFINR20" // Coloque aqui o nome do arquivo usado para impressao em disco
Private Li       := 80
Private lImp     := .F.

Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(3)

AjustaSX1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  24/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Local cQuery    := ""
Local ENTERL    := CHR(13)+CHR(10)  

WDIR_ARQ  := ALLTRIM(MV_PAR07) + IIF(RIGHT(ALLTRIM(MV_PAR07),1) <> "/", "/", "") + ALLTRIM(MV_PAR08) 
WNOME_PRO := WDIR_ARQ + ".CSV" 
nHdl_PRO  := FCreate( WNOME_PRO )  
IF EMPTY(WDIR_ARQ)
	MSGALERT(ALLTRIM(CUSERNAME) + ", PARAMETROS PARA GERACAO DO ARQUIVO EXCEL EM BRANCO !!!")
ELSE

	   W_CLIENTE := ": " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02)

	If nHdl_PRO >= 0
		FWrite( nHdl_PRO, 'Relatorio Extrato Manole ' + W_CLIENTE + CRLF ) 
		FWrite( nHdl_PRO, "NOME; DATA VENCIMENTO; VALOR; EFETIVADO; TIPO; PREFIXO; NUMERO; PARCELA; NATUREZA; SERVICO" + CRLF )
	ELSE
		MSGALERT(ALLTRIM(CUSERNAME) + ", NÃO FOI POSSIVEL CRIAR AS INFORMACOES PARA O EXCELL: " + WNOME_CLI )
	ENDIF
ENDIF

//| Cria filtro temporario
// mv_par11 = 1 - Loja; 2 = Evento ; 3 = Ambos.
cAliasNew := GetNextAlias()

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())
IF mv_par04 <> 4
	IF mv_par05 == 4
		IF mv_par06 == 2
			cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_FORNECE, E2_LOJA, E2_VENCREA, E2_VALOR, E2_BAIXA, E2_SALDO, E2_NATUREZ, E2_NOMFOR, E2_ORIGEM, E2_TIPO "+ ENTERL
			
			cQuery += " FROM SE2010 E2 " +ENTERL
			
			cQuery += " WHERE E2_FILIAL  = '"+ xFilial("SE2")+"' AND "+ENTERL
			cQuery += " E2_VENCREA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
			IF !Empty(mv_par03)
				cQuery += " E2_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
			ENDIF
			IF mv_par04 = 1
				cQuery += " E2_SALDO > 0 AND " + ENTERL
			ELSEIF mv_par04 = 2
				cQuery += " E2_SALDO = 0 AND " + ENTERL
			ENDIF
			
			cQuery += " E2.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
			
			cQuery += " ORDER BY E2_VENCREA, E2_VALOR" + ENTERL
			
		ELSE
			cQuery := " SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_RECPAG, E5_PARCELA, E5_DATA, E5_NATUREZ, E5_BENEF, E5_HISTOR, E5_VALOR "+ ENTERL
			
			cQuery += " FROM SE5010A E5 " +ENTERL
			
			cQuery += " WHERE E5_FILIAL  = '"+ xFilial("SE5")+"' AND "+ENTERL
			cQuery += " E5_RECPAG = 'P' AND " + ENTERL
			cQuery += " E5_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
			IF !Empty(mv_par03)
				cQuery += " E5_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
			ENDIF
			
			cQuery += " E5.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
			
			cQuery += " ORDER BY E5_DATA, E5_VALOR" + ENTERL
		ENDIF
	ELSE
		IF mv_par06 == 2
		
			cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_FORNECE, E2_LOJA, E2_VENCREA, E2_VALOR, E2_BAIXA, E2_SALDO, E2_NATUREZ, E2_NOMFOR, E2_ORIGEM, E2_TIPO "+ ENTERL
			
			cQuery += " FROM SE2010 E2 " +ENTERL
			
			cQuery += " WHERE E2_FILIAL  = '"+ xFilial("SE2")+"' AND "+ENTERL
			cQuery += " E2_VENCREA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
			IF !Empty(mv_par03)
				cQuery += " E2_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
			ENDIF
			IF mv_par04 = 1
				cQuery += " E2_SALDO > 0 AND " + ENTERL
			ELSEIF mv_par04 = 2
				cQuery += " E2_SALDO = 0 AND " + ENTERL
			ENDIF
			
			cQuery += " E2.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1 
						
			cQuery += " UNION ALL " + ENTERL  // INCLUIR TABELA SB1
			
			cQuery += " SELECT E1_FILIAL E2_FILIAL, E1_PREFIXO E2_PREFIXO, E1_NUM E2_NUM, E1_PARCELA E2_PARCELA, E1_CLIENTE E2_FORNECE, E1_LOJA E2_LOJA, E1_VENCREA E2_VENCREA, E1_VALOR E2_VALOR, E1_BAIXA E2_BAIXA, E1_SALDO E2_SALDO, E1_NATUREZ E2_NATUREZ, E1_NOMCLI E2_NOMFOR, E1_ORIGEM E2_ORIGEM, E1_TIPO E2_TIPO"+ ENTERL
			cQuery += " FROM SE1010 E1 " +ENTERL
		
			cQuery += " WHERE E1_FILIAL  = '"+ xFilial("SE1")+"' AND "+ENTERL
			cQuery += " E1_VENCREA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
			IF !Empty(mv_par03)
				cQuery += " E1_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
			ENDIF
			IF mv_par05 = 1
				cQuery += " E1_SALDO > 0 AND " + ENTERL
			ELSEIF mv_par05 = 2
				cQuery += " E1_SALDO = 0 AND " + ENTERL
			ENDIF
		
			cQuery += " E1.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
			
			cQuery += " ORDER BY E2_VENCREA, E2_VALOR" + ENTERL 
			
		ELSE
			cQuery := " SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_RECPAG, E5_PARCELA, E5_DATA, E5_NATUREZ, E5_BENEF, E5_HISTOR, E5_VALOR "+ ENTERL
			
			cQuery += " FROM SE5010A E5 " +ENTERL
			
			cQuery += " WHERE E5_FILIAL  = '"+ xFilial("SE5")+"' AND "+ENTERL
			cQuery += " E5_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
			IF !Empty(mv_par03)
				cQuery += " E5_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
			ENDIF
			
			cQuery += " E5.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
			
			cQuery += " ORDER BY E5_DATA, E5_VALOR" + ENTERL
		ENDIF
	ENDIF
ElseIF mv_par05 <> 4
	IF mv_par06 == 2   
		cQuery := " SELECT E1_FILIAL E2_FILIAL, E1_PREFIXO E2_PREFIXO, E1_NUM E2_NUM, E1_PARCELA E2_PARCELA, E1_CLIENTE E2_FORNECE, E1_LOJA E2_LOJA, E1_VENCREA E2_VENCREA, E1_VALOR E2_VALOR, E1_BAIXA E2_BAIXA, E1_SALDO E2_SALDO, E1_NATUREZ E2_NATUREZ, E1_NOMCLI E2_NOMFOR, E1_ORIGEM E2_ORIGEM, E1_TIPO E2_TIPO"+ ENTERL
		cQuery += " FROM SE1010 E1 " +ENTERL
		
		cQuery += " WHERE E1_FILIAL  = '"+ xFilial("SE1")+"' AND "+ENTERL
		cQuery += " E1_VENCREA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
		IF !Empty(mv_par03)
			cQuery += " E1_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
		ENDIF
		IF mv_par05 = 1
			cQuery += " E1_SALDO > 0 AND " + ENTERL
		ELSEIF mv_par05 = 2
			cQuery += " E1_SALDO = 0 AND " + ENTERL
		ENDIF
		
		cQuery += " E1.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
		
		cQuery += " ORDER BY E1_VENCREA, E1_VALOR" + ENTERL
	ELSE
		cQuery := " SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_RECPAG, E5_PARCELA, E5_DATA, E5_NATUREZ, E5_BENEF, E5_HISTOR, E5_VALOR "+ ENTERL
		
		cQuery += " FROM SE5010A E5 " +ENTERL
		
		cQuery += " WHERE E5_FILIAL  = '"+ xFilial("SE5")+"' AND "+ENTERL
		cQuery += " E5_RECPAG = 'R' AND " + ENTERL
		cQuery += " E5_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' AND " + ENTERL
		IF !Empty(mv_par03)
			cQuery += " E5_NATUREZ = '" + mv_par03 + "' AND " + ENTERL
		ENDIF
		
		cQuery += " E5.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
		
		cQuery += " ORDER BY E5_DATA, E5_VALOR" + ENTERL
	ENDIF
Endif

MEMOWRITE ("RFINR20.TXT",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif 
_nValCre := 0
_nValDeb := 0
_nValtot := 0   

(cAliasNew)->(dbGoTop())
DO While (cAliasNew)->(!Eof())
	
	IF mv_par06 = 2
		_cFilial := (cAliasNew)->E2_FILIAL
		_cPrefix := (cAliasNew)->E2_PREFIXO
		_cNum    := (cAliasNew)->E2_NUM  
		_cParc   := (cAliasNew)->E2_PARCELA  
		_cFornec := (cAliasNew)->E2_FORNECE
		_cLoja   := (cAliasNew)->E2_LOJA
		_dVencRe := (cAliasNew)->E2_VENCREA 
		_cOrigem := (cAliasNew)->E2_ORIGEM 
		_cTipo   := (cAliasNew)->E2_TIPO 
		_nValor  := (cAliasNew)->E2_VALOR 		
		_dBaixa  := (cAliasNew)->E2_BAIXA
		_nSaldo  := (cAliasNew)->E2_SALDO
		_cNature := (cAliasNew)->E2_NATUREZ
		_Nome    := (cAliasNew)->E2_NOMFOR
		_cCod 	 := ""
		_cDesc	 := ""
		_cNomNat := "" 
		_cTipoPR := "R"
		IF ALLTRIM(_cOrigem) == "MATA100"
			IF _cTipo == "NF "
				_cTipoPR := "P"   
				_nValor  := _nValor * -1
		    ENDIF
		ELSEIF ALLTRIM(_cOrigem) == "FINA050" .OR. ALLTRIM(_cOrigem) == "FINA290" .OR. ALLTRIM(_cOrigem) == "CDAA040"
			_cTipoPR := "P"   
			_nValor  := _nValor * -1
		ENDIF                      
		
		IF _cTipoPR == "P"
			dbSelectArea("SD1")
			dbSetOrder(1)
			If dbSeek(xFilial("SD1")+ _cNum + _cPrefix + _cFornec + _cLoja)
				_cCod := D1_COD
			Endif
		ELSE
			dbSelectArea("SD2")
			dbSetOrder(3)
			If dbSeek(xFilial("SD2")+ _cNum + _cPrefix + _cFornec + _cLoja)
				_cCod := D2_COD
			Endif
		ENDIF	
		
		
		If !EMPTY(_cCod)
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+ _cCod)
				_cDesc := B1_DESC
			Endif
		Endif
	ELSE
		_cFilial := (cAliasNew)->E5_FILIAL 
		_cPrefix := (cAliasNew)->E5_PREFIXO
		_cNum    := (cAliasNew)->E5_NUMERO  
		_cParc   := (cAliasNew)->E5_PARCELA
		_dVencRe := (cAliasNew)->E5_DATA
		_nValor  := (cAliasNew)->E5_VALOR
		_dBaixa  := (cAliasNew)->E5_DATA
		_nSaldo  := 0
		_cNature := (cAliasNew)->E5_NATUREZ
		_Nome    := (cAliasNew)->E5_BENEF
		_cCod 	 := ""
		_cDesc	 := (cAliasNew)->E5_HISTOR
		_cNomNat := ""
		_cTipoPR := (cAliasNew)->E5_RECPAG  
		IF _cTipoPR == "P"
			_nValor  := _nValor * -1 
		ENDIF
		
	ENDIF
	
	dbSelectArea("SED")
	dbSetOrder(1)
	If dbSeek(xFilial("SED")+ _cNature)
		_cNomNat := ED_DESCRIC
	Endif
	
	@ Li, 002 PSay _Nome                                 			//(cAliasNew)->B1_XDTLANC  //LEFT( Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_XDTLANC"), 25) // LIMITADO A 25
	@ Li, 035 PSay Stod(_dVencRe)                         	        //STRZERO(DAY(W_EMISSAO),2) + "/" + STRZERO(MONTH(W_EMISSAO),2) + "/" + RIGHT(STRZERO(YEAR(W_EMISSAO),4),2)
	@ Li, 057 PSay _nValor Picture "@E 99,999,999.99"                  // left( AllTrim(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_DESC")), 34)
	IF _nSaldo == 0
		@ Li, 076 PSay Stod(_dBaixa)
	Else
		@ Li, 076 PSay "a baixar"
	Endif
	@ Li, 091 PSay _cTipoPR
	@ Li, 095 PSay _cPrefix
	@ Li, 103 PSay _cNum   
	@ Li, 119 PSay _cParc   
	@ Li, 124 PSay alltrim(SUBSTR(_cNomNat,1,32))
	@ Li, 160 PSay alltrim(_cDesc)
	
	If _nValor > 0
		_nValCre := _nValCre + _nValor
	Else
		_nValDeb := _nValDeb + _nValor
	Endif
	_nValTot := _nValTot + _nValor
	
	IF _nSaldo == 0
		_cBX := Stod(_dBaixa) 
	Else
		_cBX := "a baixar"   
	Endif
	
	_dVencRe1 := Stod(_dVencRe)  
	_cBX1 := STRZERO(DAY(_cBX),2) + "/" + STRZERO(MONTH(_cBX),2) + "/" + RIGHT(STRZERO(YEAR(_cBX),4),2)
	FWrite( nHdl_PRO,;
   	_Nome + ";" + ;
	STRZERO(DAY(_dVencRe1),2) + "/" + STRZERO(MONTH(_dVencRe1),2) + "/" + RIGHT(STRZERO(YEAR(_dVencRe1),4),2) + ";" + ;    
	STR(_nValor) + ";" + ;  
	_cBX1 + ";" + ;
	_cTipoPR + ";" + ;    
	_cPrefix + ";" + ; 
	_cNum + ";" + ;  
	_cParc + ";" + ; 
	alltrim(SUBSTR(_cNomNat,1,32)) + ";" + ;   
	alltrim(_cDesc) + ";" + ; 
	CRLF )
	
	Li++
	
	lImp   := .T.
	
	(cAliasNew)->(dbSkip())
	
	If Li > 51 //.And. !TRB->(Eof())
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//		Li++
		//		@ Li,000 Psay __PrtThinLine()
		//		Li++
		//		Cabec1()
	Endif
	
EndDo   
FClose( nHdl_PRO )
_nValDeb := _nValDeb * -1
Li++
Li++ 
@ Li, 033 PSay "Total Creditos:"
@ Li, 056 PSay _nValCre Picture "@E 999,999,999.99"
Li++                     
@ Li, 033 PSay "Total Debitos:"
@ Li, 056 PSay _nValDeb Picture "@E 999,999,999.99"  
Li++ 
Li++ 
@ Li, 033 PSay "Saldo Final:"
@ Li, 056 PSay _nValTot Picture "@E 999,999,999.99"

//U_GRV_NHDL(SPACE(1), SPACE(1), "TOTAL GERAL", STR(WT_ANALITICO), "0", STR(WT_VALOR), "TOT", .T., WT_PENDENTE ) //


//FClose( nHdl ) //

//FClose( nHdl_CLI ) //

If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

(cAliasNew)->(DbCloseArea())

If lEnd
	@ Li, 000 PSay cCancel
	Return
Endif

If 	lImp
	If Li <> 80
		Roda(cbCont,cbTxt,Tamanho)//Impressao de Rodape padrao.
	Endif
	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
Else
	MsgStop ("Nao existem dados a serem visualizados!, Verifique os parametros" )
EndIf

Ms_Flush()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    ºData  ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para incluir os grupos de perguntas OMSC01           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

PutSx1(cPerg, '01', 'Vencimento de   ?'    , 'Vencimento de   ?'    , 'Vencimento de   ?'    , 'mv_ch1', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par01', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '02', 'Vencimento ate  ?'    , 'Vencimento ate  ?'    , 'Vencimento ate  ?'    , 'mv_ch2', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par02', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '03', 'Natureza        ?'    , 'Natureza        ?'    , 'Natureza        ?'    , 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SED', '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'A pagar / Pagas ?'    , 'A pagar / Pagas ?'    , 'A pagar / Pagas ?'    , 'mv_ch4', 'N', 1, 0, 2, 'C', '', ''   , '', '', 'mv_par04', 'A Pagar','A Pagar','A Pagar', '', 'Pagas','Pagas','Pagas','Ambos','Ambos','Ambos','Nenhuma','Nenhuma','Nenhuma','','','','')
PutSx1(cPerg, '05', 'A Receber/Receb ?'    , 'A Receber/Receb ?'    , 'A Receber/Receb ?'    , 'mv_ch5', 'N', 1, 0, 2, 'C', '', ''   , '', '', 'mv_par05', 'A Receber','A Receber','A Receber', '', 'Recebidas','Recebidas','Recebidas','Ambos','Ambos','Ambos','Nenhuma','Nenhuma','Nenhuma','','','','')
PutSx1(cPerg, '06', 'Pagamen/Recebim ?'    , 'Pagamen/Recebim ?'    , 'Pagamen/Recebim ?'    , 'mv_ch6', 'N', 1, 0, 2, 'C', '', ''   , '', '', 'mv_par06', 'Efetivos','Efetivos','Efetivos', '', 'Titulos','Titulos','Titulos','','','','','','','','','','')
PutSx1(cPerg, '07', 'Pasta arquivo Excel ?', 'Pasta arquivo Excel ?', 'Pasta arquivo Excel ?', 'mv_ch7', 'C',50, 0, 0, 'G', '', ''   , '', '', 'mv_par07', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '08', 'Nome arquivo Excel ?' , 'Nome arquivo Excel ?' , 'Nome arquivo Excel ?' , 'mv_ch8', 'C',20, 0, 0, 'G', '', ''   , '', '', 'mv_par08', '', '', '', '', '', '', '','','','','','','','','','','')

/*
PutSx1(cPerg, '08', 'Evento de       ?', 'Evento de      ?', 'Evento de     ?', 'mv_ch8', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par08', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '09', 'Evento ate      ?', 'Evento ate     ?', 'Evento ate    ?', 'mv_ch9', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par09', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '10','Tipo de impressao?','Tipo de impressao?','Tipo de impressao?', 'mv_chA', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par10',	 'Clientes','Clientes','Clientes', '', 'Deposito Externo','Deposito Externo','Deposito Externo','Ambos','Ambos','Ambos','','','','','','','') // SONIA - 02/07/15
PutSx1(cPerg, '11', 'Pasta arquivo Excel?', 'Pasta arquivo Excel    ?', 'Pasta arquivo Excel   ?', 'mv_chb', 'C',50, 0, 0, 'G', '', ''   , '', '', 'mv_par11', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '12', 'Nome arquivo Excel?', 'Nome arquivo Excel    ?', 'Nome arquivo Excel   ?', 'mv_chc', 'C',20, 0, 0, 'G', '', ''   , '', '', 'mv_par12', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '03', 'Cliente de       ?', 'Cliente de      ?', 'Cliente de     ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'Cliente ate      ?', 'Cliente ate     ?', 'Cliente ate    ?', 'mv_ch4', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '05', 'Loja de          ?', 'Loja de         ?', 'Loja de        ?', 'mv_ch5', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '06', 'Loja Ate         ?', 'Loja Ate        ?', 'Loja Ate       ?', 'mv_ch6', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '07', 'Emissao de       ?', 'Emissao de      ?', 'Emissao de     ?', 'mv_ch7', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par05', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '08', 'Emissao ate      ?', 'Emissao ate     ?', 'Emissao ate    ?', 'mv_ch8', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par06', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '09','Tipo Frete        ?', 'Tipo Frete      ?','Tipo Frete      ?', 'mv_ch9', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par05',	 'Cif',	'Cif','Cif', '', 'Fob',	'Fob','Fob','Ambos','Ambos','Ambos','','','','','','','')
*/
Return     