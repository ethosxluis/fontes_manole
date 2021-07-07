#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CD010MNU  ºAutor  ³lEANDRO DUARTE      º Data ³  02/24/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA COLOCAR O BOTÃO DE COPIA DE CONTRATO            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CD010MNU()
aadd(aRotina,{ "Cópia","U_CDACOPI('P04',P04->(RECNO()),4)"	,0,4,6,NIL})
RETURN(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CDACOPI   ºAutor  ³Leandro Duarte      º Data ³  02/24/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para efetuar a Copia do Contrato do direitos autoraisº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CDACOPI(cAlias,nReg,nOpc)
Local aSize := {}
Local aObjects := {}
Local aInfo := {}
Local aPosObj := {}
Local nOpca     := 0
Local cAliasAux
Local lGravaOk  := .T.
Local lLiber    := .F.
Local oDlg
Local nSavRegP05
Local cSeek     := ""
Local cWhile    := ""
Local nCnt		:= 0
Local aEditFld	:= {}
Local nOpc		:= 4
Local cQuery	:= "" 

PRIVATE oGetd
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nUsado      := 0
PRIVATE nNumLin     := 0 
PRIVATE nCampos     := 0
PRIVATE lContinua
PRIVATE lTab        := .F.
PRIVATE aItemExist  := {}
PRIVATE aHeader		:= {}
PRIVATE aCols		:= {}
PRIVATE aTela[0][0]
PRIVATE aGets[0]
private cNroContr
Private xRec		:= 0
Private lCopia		:= .T.	   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta na filial correta                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF P04_FILIAL != xFilial()
	Help(" ",1,"A000FI")
	Return (.T.)
Endif  
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
RegToMemory("P04",.F.)
  
if EMPTY(M->P04_SEQCON)
M->P04_SEQCON := "01"
ENDIF
M->P04_VALADI	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader e aCols                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias1 	:= "P05"
nSavRegP05	:= Recno()
cSeek		:= xFilial("P05")+P04->P04_PRODUT+P04->P04_FORNEC+P04->P04_LOJAFO
cWhile		:= "P05->P05_FILIAL+P05->P05_PRODUT+P05->P05_FORNEC+P05->P05_LOJAFO"
FillGetDados(nOpc,cAlias1,1,cSeek,{|| &cWhile },{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/)

dbSelectArea("SB1")
dbSeek(xFilial("SB1")+P04->P04_PRODUT)
M->P04_DESCPR := SB1->B1_DESC

dbSelectArea("SA2")
dbSeek( xFilial("SA2") + P04->P04_FORNEC + P04->P04_LOJAFO )
M->P04_NOMEAU := SA2->A2_NOME
cNroContr := GETSXENUM("P04","P04_CONTRA")
M->P04_CONTRA := cNroContr

cQuery	:= " select count(*) AS QTD from "+Retsqlname("P04")+" A WHERE A.P04_PRODUT = '"+M->P04_PRODUT+"' AND P04_FORNEC = '"+M->P04_FORNEC+"' AND A.D_E_L_E_T_ = ' ' AND A.P04_FILIAL = '"+XfILIAL("P04")+"' "
cQuery := ChangeQuery(cQuery)
IIF(SELECT("SQL1")>0,SQL1->(DBCLOSEAREA()),NIL)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL1", .F., .T.)
WHILE SQL1->QTD > 0
	cNroContr := GETSXENUM("P04","P04_CONTRA")
	M->P04_CONTRA := cNroContr
	cQuery	:= " select count(*) AS QTD from "+Retsqlname("P04")+" A WHERE A.P04_CONTRA = '"+M->P04_CONTRA+"' AND P04_SEQCON = '"+M->P04_SEQCON+"' AND A.D_E_L_E_T_ = ' ' AND A.P04_FILIAL = '"+XfILIAL("P04")+"' "
	cQuery := ChangeQuery(cQuery)
	IIF(SELECT("SQL1")>0,SQL1->(DBCLOSEAREA()),NIL)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL1", .F., .T.)
END	


aSize := MsAdvSize(,.F.,400)
aObjects := {} 

AAdd( aObjects, { 100, 100 , .T., .T. } )
AAdd( aObjects, { 100, 100 , .T., .T. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
aPosObj := MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5]  OF oMainWnd	PIXEL

EnChoice("P04",nReg,nOpc,,,,,aPosObj[1],,3)
nCnt  := Len(aCols)
lTab  := .T.
//oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_CD010LinOk","u_CD010TudOk","+P05_ITEM",.T.)
oGetd := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_CD010LinOk","U_CD010TudOk","")

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(oGetd:TudoOk() .and. CDADUPLI(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()})	

IF nOpcA == 1
	Begin Transaction
		CD010Grava("P04","P05",.F.)
		EvalTrigger()
		If __lSX8
			If cNroContr == M->P04_CONTRA
				ConfirmSX8()
			Else
		      RollBackSX8()
			Endif
		EndIf
	
	End Transaction  
	alert("Contrato Copiado para o numero: "+cNroContr)
	If ExistBlock("CD010CONT")
		ExecBlock("CD010CONT",.F.,.F.)
	EndIf
	
Elseif nOpca == 3 .or. nOpca == 0
	If __lSX8
		RollBackSX8()
	EndIf
Endif

dbSelectArea(cAlias)

Return nOpca

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CD010Grava³ Autor ³ Cristiano G. Cunha    ³ Data ³ 04/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava as informacoes do contrato                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CDAA010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CD010Grava(cAlias,cAlias1,lLiber)
Local i         := 0
Local nX        := 0
Local nMaxArray := 0
Local nCntItem  := 1
Local nCntDel   := 0
Local cChave    := ""
Local aAnterior := {}
Local ny        := 0
Local bCampo
Local dPerAnt   
Inclui := .t.
bCampo := {|nCPO| Field(nCPO)}
lLiber := IIF(lLiber == NIL,.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o ultimo elemento do array esta em branco        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(aCols)
For nx = 1 to Len(aHeader)
	If Empty(aCols[nMaxArray][nx]) .And. (Trim(aHeader[nx][2]) == "P05_FXFINA")
		nMaxArray--
		Exit
	Endif
Next nx
   
If nMaxArray <= 0
	Return .F.
Endif
   
For nx=1 to nMaxArray
	If aCols[nx][Len(aCols[nx])]
		nCntDel++
	Endif
Next nx
   
If nCntDel >= nMaxArray 
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava arquivo P04 (Cabecalho do contrato)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
If Inclui
	cChave := M->P04_CONTRA+M->P04_SEQCON//+M->P04_PRODUT+M->P04_FORNEC+M->P04_LOJAFO
Else
	cChave := P04->P04_CONTRA+P04->P04_SEQCON+P04->P04_PRODUT+P04->P04_FORNEC+P04->P04_LOJAFO
EndIf	
dPerAnt := (cAlias)->P04_PERIOD

If Inclui
	P04->(dbSetOrder(3))
	P05->(dbSetOrder(2))
	While .T.
		If P04->(dbSeek(xFilial("P04")+cChave)) .OR. P05->(dbSeek(xFilial(cAlias1)+cChave))
			cNroContr := GETSXENUM("P04","P04_CONTRA")
			M->P04_CONTRA	:= cNroContr
			cChave := M->P04_CONTRA+M->P04_SEQCON
			ConfirmSX8()
		else
			Exit
		Endif
	End
Endif
	
RecLock("P04",IIF(inclui,.T.,.F.))
   
For i := 1 TO FCount()
	If "FILIAL" $ Field(i)
		FieldPut(i,xFilial("P04"))
	Else
		FieldPut(i,M->&(EVAL(bCampo,i)))
	EndIf
Next i
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para alteracao da data da Proxima Prestacao   |
//| p/os contratos que tiverem o periodo alterado            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Inclui .And. dPerAnt <>M->P04_PERIOD  
	dbSelectArea("AH6")
	dbSetOrder(1)
	If dbSeek(xFilial("AH6")+cChave) 
		While !Eof().And. cChave == AH6->AH6_PRODUT+AH6->AH6_FORNEC+AH6->AH6_LOJAFO .And. !Empty(AH6->AH6_DTPRXD)
			If (cAlias)->P04_DTULTP == AH6->AH6_DTULTI .And. !Empty(AH6->AH6_DTPRXD)
				RecLock("AH6",.F.)
				AH6->AH6_DTPRXD := CD010DtPrx(CTOD(SPACE(08)),M->P04_PRODUT,M->P04_FORNEC)
				MsUnLock()  
			 EndIf
			 
			dbSelectArea("AH6")
			dbSkip()	
		End	
    EndIf
Endif     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava arquivo P05 (itens do contrato)               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias1)
dbsetorder(2)
dbSeek(xFilial(cAlias1)+cChave)
IF Found()
	While !Eof() .And. P05_FILIAL+P05_PRODUT+P05_FORNEC+P05_LOJAFO == ;
		xFilial("P05")+cChave
		AADD(aAnterior,RecNo())
 		dbSkip()
	End
Endif

dbSelectArea("P05")
nItem := 1
For nx = 1 to nMaxArray

	If Len(aAnterior) >= nx
		If !Inclui
			Go aAnterior[nx]
		EndIf	
		RecLock(cAlias1,.F.)
	Else 
		RecLock(cAlias1,.T.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If aCols[nx][Len(aCols[nx])] 
		RecLock("P05",.F.,.T.)
		dbDelete()
		nCntDel++
	Else 
		P05_FILIAL := xFilial("P05")
		P05_PRODUT := P04->P04_PRODUT
        P05_FORNEC := P04->P04_FORNEC
        P05_LOJAFO := P04->P04_LOJAFO
		P05_CONTRA := P04->P04_CONTRA
		P05_SEQCON := P04->P04_SEQCON
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza dados da regra.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny = 1 to Len(aHeader)
			cVar := Trim(aHeader[ny][2])
			If aHeader[ny][10] # "V" .And. AllTrim(aHeader[ny][2]) # "P05_ITEM"
				&cVar := aCols[nx][ny]
			ElseIf AllTrim(aHeader[ny][2]) == "P05_ITEM"
				P05_ITEM := StrZero(nItem,2)
				nItem++
			Endif
		Next ny

		dbSelectArea("P05")
		nCntItem++
	Endif
    MsUnlockAll()
    xRec := P04->(RECNO())
Next nx
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se deletou algum na alteracao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nCntDel > 0		
	dbSelectArea("SX2")
	dbSeek("P05")
	RecLock("SX2",.F.)
	X2_DELET := X2_DELET+nCntDel
Endif
Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CDADUPLI  ºAutor  ³Leandro Duarte      º Data ³  06/27/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para saber se pode gravar o registro pois não existe º±±
±±º          ³o Fornecedor com o Produto                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CDADUPLI()
Local lRet		:= .T.
Local cQuery	:= "select count(*) AS QTD from "+Retsqlname("P04")+" A WHERE A.P04_PRODUT = '"+M->P04_PRODUT+"' AND P04_FORNEC = '"+M->P04_FORNEC+"' AND A.D_E_L_E_T_ = ' ' AND A.P04_FILIAL = '"+XfILIAL("P04")+"' "

cQuery := ChangeQuery(cQuery)
IIF(SELECT("SQL1")>0,SQL1->(DBCLOSEAREA()),NIL)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL1", .F., .T.)
IF SQL1->QTD > 0
	lRet := .F.
	Aviso("Atenção","Ja existe um contrato com essas informações de Fornecedor e de Produto",{"Ok"})
ENDIF	
RETURN(lRet)