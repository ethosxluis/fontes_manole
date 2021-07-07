#INCLUDE"RWMAKE.CH"
#INCLUDE"TOPCONN.CH"

USER FUNCTION AJIRT01(cdatafech)
LOCAL CQUERY := ""
LOCAL NVALAC := 0
LOCAL ATABELA := {}
LOCAL NVALLIQ := 0
LOCAL nValIRRF := 0

CQUERY := " SELECT E2.R_E_C_N_O_ REGE2, E2_NUM, E2_FORNECE, E2_EMISSAO, E2_VALOR, E2_IRRF, E2_VLCRUZ, E2_SALDO "
CQUERY += " , E2_BASEIRF "
CQUERY += " , A2_TIPO "
CQUERY += " ,  E2_VALOR + E2_IRRF VALBRUT "
CQUERY += " , SUM(AH5_VALORD) , ROUND(SUM(AH5_VALORD),2) VALCALC "
CQUERY += " , ABS(E2_VALOR - ROUND(SUM(AH5_VALORD),2) + E2_IRRF) DIVERGEN "
CQUERY += " FROM SE2010 E2, AH6010 AH6, AH5010 AH5, SA2010 A2 "
CQUERY += " WHERE AH6.D_E_L_E_T_ <> '*' "
CQUERY += " AND AH5.D_E_L_E_T_ <> '*' "
CQUERY += " AND E2.D_E_L_E_T_ <> '*' "
CQUERY += " AND A2.D_E_L_E_T_ <> '*' "
CQUERY += " AND E2_EMISSAO = '"+cdatafech+"' AND E2_BAIXA = '        ' "
CQUERY += " AND E2_PREFIXO = 'RYI' "
CQUERY += " AND E2_FORNECE = AH6_FORNEC "
CQUERY += " AND E2_LOJA = AH6_LOJAFO "
CQUERY += " AND E2_FORNECE = A2_COD "
CQUERY += " AND E2_LOJA = A2_LOJA "
CQUERY += " AND A2_TIPO = 'F' "
CQUERY += " AND E2_EMISSAO = AH6_DTPRES "
CQUERY += " AND AH6_FORNEC = AH5_FORNEC "
CQUERY += " AND AH6_LOJAFO = AH5_LOJAFO "
CQUERY += " AND AH6_PRODUT = AH5_PRODUT "
CQUERY += " AND AH6_DTPRES = AH5_DTPRES "
CQUERY += " GROUP BY E2.R_E_C_N_O_ , E2_NUM, E2_FORNECE, E2_EMISSAO, E2_VALOR, E2_IRRF, E2_VLCRUZ, E2_SALDO, E2_BASEIRF, A2_TIPO "
CQUERY += " ORDER BY E2_FORNECE "

IF SELECT("TRBA")<>0
DBSELECTAREA("TRBA")
TRBA->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS TRBA

DBSELECTAREA("TRBA")
TRBA->(DBGOTOP())
DBSELECTAREA("SE2")
aTabela := CD040AbrIR()

WHILE !TRBA->(EOF())


nValAc  := ROUND(TRBA->VALCALC,2)
For i := 1 To Len(aTabela)
	If nValAc <= aTabela[i][1]
		nValIRRF := (nValAc * aTabela[i][2]/100) - aTabela[i][3]
		Exit
	Endif
Next
nValIRRF := ROUND(Iif(nValIRRF < 0,0,nValIRRF),2)
NVALLIQ  := ROUND(nValAc,2) - ROUND(nValIRRF,2)

SE2->(DBGOTO(TRBA->REGE2))
RECLOCK("SE2",.F.)
IF NVALLIQ <> SE2->E2_VALOR
SE2->E2_VALOR := NVALLIQ
SE2->E2_SALDO := NVALLIQ
ENDIF

IF nValIRRF <> SE2->E2_IRRF
SE2->E2_IRRF := nValIRRF
ENDIF

IF nValAc <> SE2->E2_BASEIRF
SE2->E2_BASEIRF := nValAc
ENDIF

SE2->(MSUNLOCK())
TRBA->(DBSKIP())
END



//ALERT("CONCLUIDO")
RETURN()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CD040AbrIR³ Autor ³ Elizabeth A. Eguni    ³ Data ³ 27/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que le o arquivo de I.R.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := CD040AbrIR()                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 := array com a tabela do I.R. pessoa fisica          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CDAA040                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CD040AbrIR()
Local nBytes := 0, nHdlIrf
Local aTabela  := {}, cArquivo, nTamArq, xBuffer

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Leitura do arquivo configurador                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo:="SIGAADV.IRF"
IF !FILE(cArquivo)
	Help(" ",1,"CD040NTab")
	Return aTabela
Else
	nHdlIrf:=FOPEN(cArquivo,0+64)
EndIF

nTamArq:=FSEEK(nHdlIrf,0,2)	// Verifica tamanho do arquivo
FSEEK(nHdlIrf,0,0)	     	// Volta para inicio do arquivo

While nBytes<nTamArq
	
	xBuffer:=Space(40)
	FREAD(nHdlIrf,@xBuffer,40)
	IF Empty(xBuffer)
		AADD(aTabela, { 0, 0, 0 } )
	Else
		AADD(aTabela,{ Val(SubStr(xBuffer,01,15)), Val(SubStr(xBuffer,17,6)), ;
		Val(SubStr(xBuffer,24,15)) } )
	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Este IF Len( aTabela ) == 5 foi implementado pelo fato  ³
	//³ de que a grava‡Æo feita pelo for windows dava uma       ³
	//³ diferen‡a de 1 byte na grava‡Æo do final do arquivo.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len( aTabela ) == 5
		Exit
	Endif
	nBytes+=40
EndDO
Return aTabela


