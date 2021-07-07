#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CDAM030  ³ Autor ³ ANDERSON CIRIACO      ³ Data ³09.10.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Manutenção de Resultados da apuracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CdaM030()

Private aRotina 	:= MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro 	:= "Manutenção de calculo dos direitos autorais"
Private cAlias1		:= "AH5"	// Alias de detalhe
Private lSemItens	:= .T.		// Permite a nao existencia de itens
Private cChave			:= "AH4_PRODUT+AH4_FORNEC+AH4_LOJAFO+DTOS(AH4_DATCAL)"
Private cChave1		:= "AH5_PRODUT+AH5_FORNEC+AH5_LOJAFO+DTOS(AH5_DATCAL)"
Private cFilter :=   ""
Public ACHAVES

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("AH6_LICITA")
If SX3->X3_BROWSE = "S"
	dbSeek("AH6_LICITA")
	RecLock("SX3",.F.)
	SX3->X3_BROWSE := " "
	MsUnlock()
	dbSeek("AH6_DTPRES")
	RecLock("SX3",.F.)
	SX3->X3_BROWSE := "S"
	SX3->X3_USADO := "€€€€€€€€€€€€€€ "
	MsUnlock()
	dbSeek("AH6_SALADI")
	RecLock("SX3",.F.)
	SX3->X3_BROWSE := "S"
	SX3->X3_USADO := "€€€€€€€€€€€€€€ "
	MsUnlock()
	dbSeek("AH6_DESCIR")
	RecLock("SX3",.F.)
	SX3->X3_BROWSE := "S"
	SX3->X3_USADO := "€€€€€€€€€€€€€€ "
	MsUnlock()
	dbSeek("AH6_VALORD")
	RecLock("SX3",.F.)
	SX3->X3_BROWSE := "S"
	SX3->X3_USADO := "€€€€€€€€€€€€€€ "
	MsUnlock()
	dbSeek("AH6_NOTITU")
	RecLock("SX3",.F.)
	SX3->X3_BROWSE := "S"
	SX3->X3_USADO := "€€€€€€€€€€€€€€ "
	MsUnlock()
	
	dbSeek("AH6_DTPRXD")
	RecLock("SX3",.F.)
	SX3->X3_TITULO := "Dt.Prx.Prest."
	MsUnlock()
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mBrowse(6,1,22,75,"AH4",,,,,,,,,,,,,,cFilter)

CdaPrivate()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()

Private aRotina 	:= { 	{ "Pesquisar"	,"AxPesqui"  	,0,1,0,.F.},;
{ "Excluir"		,"CdaModelo"  	,0,5,0,.F.},;
{ "Visualiza"	,"u_CdaMod4"  	,0,2,0,.F.},;
{ "Incluir"		,"u_CdaMod4"  	,0,3,0,.F.},;
{ "Manutenção"	,"u_CdaMod4"	,0,4,0,NIL} }


Return(aRotina)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CdaModelo ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 20/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para visualizacao em formato Modelo 2 ou 3          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CdaModelo(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CdaMod4(cAlias,nReg,nOpc)


Local nOpca 	:=	0
Local nCpoTela	:=	0
Local nOrdSx3 	:=	Sx3->(IndexOrd())
Local cContador	:=	""
Local cCpoMod2  :=	""
Local cAlias1   :=	""
Local cSeek		:=	""
Local cWhile	:=	""

Local lInclui	:=	.F.
Local lAltera	:=	.T.
Local lExclui	:=	.F.
Local lModelo2	:=	(cAlias1 = cAlias)
//nOpc := 4
IF NOPC == 3 //CASO DE INCLUSÃO
	lInclui	:=	.T.
	lAltera	:=	.F.
	lExclui	:=	.F.
ENDIF


cAlias1  := If(Type("cAlias1") = "U" .Or. cAlias1 = Nil, cAlias, cAlias1)
Private oDlg, oGetD
If Type("aSize") = "U" .Or. aSize = Nil
	Private aSize		:= MsAdvSize(,.F.,430)
	Private aObjects 	:= {}
	Private aPosObj  	:= {}
	Private aSizeAut 	:= MsAdvSize()
	
	If lModelo2
		AAdd( aObjects, { 315, aPosTela[1][2] + 20, .T., .T. } )
		AAdd( aObjects, { 100, 430 - aPosTela[1][2] - 20, .T., .T. } )
	Else
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 315,  70, .T., .T. } )
	Endif
	
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	
	aPosObj := MsObjSize( aInfo, aObjects )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)

IF ! lInclui .And. LastRec() == 0
	Help(" ",1,"A000FI")
	Return (.T.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta' na filial correta                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! lInclui .And. xFilial(cAlias) != &(cAlias + "_FILIAL")
	Help(" ",1,"A000FI")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	:= {}
PRIVATE aCols	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAltera .Or. lExclui
	SoftLock(cAlias)
Endif

CdaMemory(cAlias,lInclui)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader e aCols                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeek	:= xFilial("AH4")+AH4->AH4_PRODUT+AH4->AH4_FORNEC+AH4->AH4_LOJAFO+DTOS(AH4->AH4_DATCAL)
cWhile	:= "AH5->AH5_FILIAL+AH5->AH5_PRODUT+AH5->AH5_FORNEC+AH5->AH5_LOJAFO+DTOS(AH5->AH5_DATCAL)"
cAlias1	:= "AH5"
FillGetDados(nOpc,cAlias1,1,cSeek,{|| &cWhile },{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,lInclui)

If !lInclui .AND. ((Type("lSemItens") = "U" .Or. lSemItens = Nil) .Or. !lSemItens)	// Indica se verifica existencia
	If (len(aCols) = 0) .OR. (len(aCols) > 0 .AND. Empty(aCols[1][1]))				// dos itens
		Help(" ",1,"CA10SEMREG")
		Return .T.
	Endif
Endif

If FieldPos(cAlias1 + "_ITEM") > 0
	cContador := "+" + cAlias1 + "_ITEM"
Endif

If Type("cLinhaOk") = "U" .Or. cLinhaOk = Nil
	cLinhaOk := "U_CDM30LIOK"
Endif

If Type("cTudoOk") = "U" .Or. cTudoOk = Nil
	cTudoOk := "U_CDM30TOK"
Endif

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1], , 3, , , , , , .T. )

oGetd := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(oGetd:TudoOk(),oDlg:End(),nOpca := 0) }, { || oDlg:End() })

If nOpca = 1 .And. nOpc # 2
	BEGIN TRANSACTION
	
	If nOpc = 5 .And. (Type("cPodeExcluir") = "U" .Or. Empty(cPodeExcluir) .Or.;
		&(cPodeExcluir))
		DelModelo(cAlias, cAlias1)
	ElseIf nOpc # 5
		GrvModelo(cAlias, cAlias1,lInclui)
	Endif
	IF AH5->AH5_FILIAL <> XFILIAL("AH5")
		RECLOCK("AH5",.F.)
		Replace AH5_FILIAL With xFilial("AH5")
		AH5->(MSUNLOCK())
	ENDIF
	For _i := 1 to Len(aCols)
		NREC :=  ACOLS[_i,nPosRec:= Ascan(aHeader,{|x|Alltrim(x[2]) == "AH5_REC_WT"})]
		IF NREC <> 0
			AH5->(DBGOTO(NREC))
		ENDIF
		IF AH5->AH5_FILIAL <> XFILIAL("AH5")
			RECLOCK("AH5",.F.)
			Replace AH5_FILIAL With xFilial("AH5")
			AH5->(MSUNLOCK())
		ENDIF
	next _i
	END TRANSACTION
Endif

dbSelectArea(cAlias)

Return nOpca

User Function CDM30LIOK()
Local nPos		:= 0
Local nI		:= 0
Local aColsX	:= aclone(acols[1])
Local i := 0
Local nValord := 0
Local nValacu := 0
Local nQtdAcu := 0
Local nPosDel    := Len( aHeader ) + 1

For i := 1 to Len(aCols)
	If !aCols[i][nPosDel]
		nQtdAcu := nQtdAcu + aCols[i][aScan(aHeader,{|x| x[2] == "AH5_QTDACU"})]
		nValacu := nValacu + aCols[i][aScan(aHeader,{|x| x[2] == "AH5_BASEDA"})]
		nValord := nValord + aCols[i][aScan(aHeader,{|x| x[2] == "AH5_VALORD"})]
	endif
Next i
M->AH4_VALORD := nValord
M->AH4_VALACU := nValacu
M->AH4_QTDACU := nQtdAcu

oDlg:Refresh()

Return(.t.)


User Function CDM30TOK()
Local nPos		:= 0
Local nI		:= 0
Local aColsX	:= aclone(acols[n])
Local i := 0
Local nValord := 0
Local nValacu := 0
Local nQtdAcu := 0



Return(.t.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvModelo ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 21/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao em formato Modelo 2 ou 3          	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GrvModelo(cPar1, cPar2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpC1 = Alias detalhe do arquivo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GrvModelo(cAlias,cAlias1,lInclui)

Local nCampos, nHeader, nMaxArray, bCampo, aAnterior:={}, nItem := 1
Local lModelo2 := cAlias = cAlias1
Local nChaves := 0
bCampo := {|nCPO| Field(nCPO) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o ultimo elemento do array esta em branco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(aCols)

If ! lModelo2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava arquivo PRINCIPAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	
	RecLock(cAlias,lInclui)
	
	For nCampos := 1 TO FCount()
		If "FILIAL"$Field(nCampos)
			FieldPut(nCampos,xFilial(cAlias))
		Else
			FieldPut(nCampos,M->&(EVAL(bCampo,nCampos)))
		EndIf
	Next
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega ja gravados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias1)
If ! lInclui .And. MsSeek(xFilial(cAlias1)+&(cChave))
	While !Eof() .And. xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
		Aadd(aAnterior,RecNo())
		dbSkip()
	Enddo
Endif

dbSelectArea(cAlias1)
nItem := 1

For nCampos := 1 to nMaxArray
	
	If Len(aAnterior) >= nCampos
		If ! lInclui
			DbGoto(aAnterior[nCampos])
		EndIf
		RecLock(cAlias1,.F.)
	Else
		RecLock(cAlias1,.T.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[nCampos][Len(aCols[nCampos])]
		RecLock(cAlias1,.F.,.T.)
		dbDelete()
	Else
		For nHeader := 1 to Len(aHeader)
			(CALIAS1)->(CALIAS1+"_FILIAL") := xFilial(CALIAS1)
			If aHeader[nHeader][10] # "V" .And. ! "_ITEM" $ AllTrim(aHeader[nHeader][2])
				Replace &(Trim(aHeader[nHeader][2])) With aCols[nCampos][nHeader]
			ElseIf "_ITEM" $ AllTrim(aHeader[nHeader][2])
				Replace &(AllTrim(aHeader[nHeader][2])) With StrZero(nItem ++,;
				Len(&(AllTrim(aHeader[nHeader][2]))))
			Endif
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza as chaves de itens ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Type("aChaves") # "U" .Or. aChaves # Nil
			Replace &(cAlias1 + "_FILIAL") With xFilial(cAlias1)
			For nChaves := 1 To Len(aChaves)
				Replace &(aChaves[nChaves][1]) With &(aChaves[nChaves][2])
			Next
		Endif
		
		dbSelectArea(cAlias1)
	Endif
	
Next nCampos

Return .T.
