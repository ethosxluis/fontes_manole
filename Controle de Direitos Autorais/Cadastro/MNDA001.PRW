#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNDA001   ºAutor  ³LEANDRO DUARTE      º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina modelo 2 para o cadastro                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNDA001()
Local cDesc			:= "LINK EXTERNO PARA QUE O USUARIO RECEBA O E-MAIL E CLICK NELE PARA ABRIR O CONTRATO"
Local cCnt			:= "http://10.10.1.3:89"
Local cParam		:= "MV_LINKCDA"
Private cCadastro := "Autor X Produto X Contrato"
Private aRotina := {}
Private aButtons	:= {}
Private cFiltro  := "UA2->UA2_ITEM =='001'"
Private aIndexSYP := {}
Private cLink		:= getnewpar("MV_LINKCDA","http://10.10.1.3:89")
Private bFiltraBrw:= { || FilBrowse("UA2",@aIndexSYP,@cFiltro) }
Private aCores 		:= {{"UA2_STATUS == '1'", "BR_VERDE"},;
						{"UA2_STATUS == '2'", "BR_AMARELO"},;	
						{"UA2_STATUS == '3'", "BR_AZUL"},; 		
						{"UA2_STATUS == '4'", "BR_VERMELHO"},;
						{"UA2_STATUS == '5'", "BR_LARANJA"},; 	
						{"UA2_STATUS == '6'", "BR_PRETO"}}      
If !ExisteSX6(cParam)
	CriarSX6(cParam,"C",cDesc,cCnt)
Endif					
AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
AADD( aRotina, {"Visualizar" ,'U_MnlA001',0,2})
AADD( aRotina, {"Incluir" ,'U_MnlA002',0,3})
AADD( aRotina, {"Alterar" ,'U_MnlA001',0,4})
AADD( aRotina, {"Excluir" ,'U_MnlA001',0,5})
AADD( aRotina, {"Legenda" ,'U_Mnlb001',0,4})
AADD( aRotina, {"Contrato" ,'U_Mnlc001',0,4})
AADD( aRotina, {"Inf. Assinatura" ,'U_Mnld001',0,4})
AADD( aRotina, {"Envia Contrato" ,'MSAGUARDE({|| U_Mnle001() },"Aguarde","Enviando email para os Autores")',0,4})

dbSelectArea("UA7")
dbSetOrder(1)

dbSelectArea("UA2")
dbSetOrder(1)
dbGoTop()

Eval(bFiltraBrw)
MBrowse(,,,,"UA2",,,,,,aCores)
EndFilBrw("UA2",aIndexSYP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MnlA002   ºAutor  ³Leandro Duarte      º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     rotina de inclusão                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MnlA002( cAlias, nReg, nOpc )
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Private cCodigo	:= GETSXENUM("AH1","AH1_CONTRA")
Private cNome		:= space(tamsx3("UA2_DCONTR")[1])
Private cXSeq		:= "01"
Private cTipo		:= SPACE(TAMSX3("UA2_TIPOCO")[1])
Private aObj		:= {}
Private aHeader		:= {}
Private aCOLS		:= {}
Private aREG		:= {}
Private cGrupo		:= SPACE(TAMSX3("UA2_GRUPO")[1])
pRIVATE DGrupo		:= SPACE(TAMSX3("UA6_DESC")[1])
Private INCLUI 		:= .T.
EndFilBrw(cAlias,aIndexSYP)
dbSelectArea( cAlias )
dbSetOrder(1)

AH1->(dbSetOrder(3))
AH2->(dbSetOrder(2))
cChave := cCodigo+cXSeq
While .T.
	If AH1->(dbSeek(xFilial("AH1")+cChave)) .OR. AH2->(dbSeek(xFilial("AH2")+cChave))
		cCodigo := GETSXENUM("AH1","AH1_CONTRA")
		cChave := cCodigo+cXSeq
		ConfirmSX8()
	else
		Exit
	Endif
End
dbSelectArea( cAlias )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, nReg, nOpc )

aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM 
oGet := MSGetDados():New(0,0,0,0,nOpc,"U_MnlLok()",".T.","+UA2_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

@ 4, 006 SAY "Contrato:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 070 SAY "Sequencia:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 130 SAY "Descrição:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 600 SAY "Tipo:" SIZE 70,7 PIXEL OF oTPanel1

@ 3, 030 MSGET cCodigo  PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 3, 105 MSGET cXSeq  PICTURE "@!"  when .f. SIZE 15,7 PIXEL OF oTPanel1
@ 3, 170 MSGET cNome PICTURE "@!"  SIZE 350,7 PIXEL OF oTPanel1
@ 3, 620 MSGET cTipo PICTURE "@!" F3 "U2" VALID ExistCpo("SX5", "U2" + cTipo) SIZE 15,7 PIXEL OF oTPanel1


@ 4, 006 SAY "Grupo de Aprovadores:" SIZE 170,7 PIXEL OF oTPanel2
@ 3, 070 MSGET cGrupo  PICTURE "@!" F3 "UA6" SIZE 030,7 PIXEL OF oTPanel2
@ 3, 170 MSGET DGrupo PICTURE "@!" WHEN .F. SIZE 350,7 PIXEL OF oTPanel2

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_MnlATOk(), (Mod2GrvI(),oDlg:End()), NIL  )},{|| oDlg:End() },,)
Eval(bFiltraBrw)
Return
//+--------------------------------------------------------------------+
//| Rotina | MnlA001 | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
User Function MnlA001( cAlias, nReg, nOpc )
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Private aObj := {}
Private cCodigo	:= UA2->UA2_CONTRA
Private cNome		:= UA2->UA2_DCONTR
Private cXSeq		:= UA2->UA2_SEQCON
Private cTipo		:= UA2->UA2_TIPOCO
Private cGrupo		:= UA2->UA2_GRUPO
Private DGrupo		:= POSICIONE("UA6",1,XFILIAL("UA6")+UA2->UA2_GRUPO,"UA6_DESC")
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private INCLUI := .F.
EndFilBrw(cAlias,aIndexSYP)
dbSelectArea( cAlias )
dbGoTo( nReg )

Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, nReg, nOpc )

aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM
If nOpc == 4
	oGet := MSGetDados():New(0,0,0,0,nOpc,"U_MnlLok()",".T.","+UA2_ITEM",.T.)
Else
	oGet := MSGetDados():New(0,0,0,0,nOpc,,,,.T.)
Endif
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT 

@ 4, 006 SAY "Contrato:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 070 SAY "Sequencia:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 130 SAY "Descrição:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 600 SAY "Tipo:" SIZE 70,7 PIXEL OF oTPanel1

@ 3, 030 MSGET cCodigo  PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 3, 105 MSGET cXSeq  PICTURE "@!"  when .f. SIZE 15,7 PIXEL OF oTPanel1
@ 3, 170 MSGET cNome PICTURE "@!"  SIZE 350,7 PIXEL OF oTPanel1
@ 3, 620 MSGET cTipo PICTURE "@!" F3 "U2" VALID ExistCpo("SX5", "U2" + cTipo) SIZE 15,7 PIXEL OF oTPanel1


@ 4, 006 SAY "Grupo de Aprovadores:" SIZE 170,7 PIXEL OF oTPanel2
@ 3, 070 MSGET cGrupo  PICTURE "@!" F3 "UA6" SIZE 030,7 PIXEL OF oTPanel2
@ 3, 170 MSGET DGrupo PICTURE "@!" WHEN .F. SIZE 350,7 PIXEL OF oTPanel2

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| ( IIF( nOpc==4, Mod2GrvA(), IIF( nOpc==5, Mod2GrvE(), oDlg:End() ) ), oDlg:End() ) },{|| oDlg:End() },,)
Eval(bFiltraBrw)
Return
//+--------------------------------------------------------------------+
//| Rotina | Mod2aHeader | Autor | Robson Luiz (rleg) |Data|01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function Mod2aHeader( cAlias )
Local aArea := GetArea()
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .and. !(alltrim(X3_CAMPO) $ 'UA2_CONTRA,UA2_DCONTR,UA2_SEQCON,UA2_TIPOCO,UA2_STATUS,UA2_DTASSI,UA2_IPASSI,UA2_HSASSI,UA2_LCASSI,UA2_NMASSI,UA2_STAINT,UA2_GRUPO')
		AADD( aHeader, { Trim( X3Titulo() ),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,;
		X3_DECIMAL,;
		X3_VALID,;
		X3_USADO,;
		X3_TIPO,;
		X3_ARQUIVO,;
		X3_CONTEXT})
	Endif
	dbSkip()
End
RestArea(aArea)
Return
//+--------------------------------------------------------------------+
//| Rotina | Mod2aCOLS | Autor | Robson Luiz (rleg) |Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aCOLS. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function Mod2aCOLS( cAlias, nReg, nOpc )
Local aArea := GetArea()
Local cChave := UA2->UA2_CONTRA+UA2->UA2_SEQCON+UA2->UA2_TIPOCO
Local nI := 0
If nOpc <> 3
	dbSelectArea( cAlias )
	(cAlias)->(dbSetOrder(2))
	(cAlias)->(dbSeek( xFilial( cAlias ) + cChave ))
	While !EOF() .And. UA2->( UA2_FILIAL + UA2->UA2_CONTRA + UA2->UA2_SEQCON + UA2->UA2_TIPOCO ) == xFilial( cAlias ) + cChave
		AADD( aREG, UA2->( RecNo() ) )
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		(cAlias)->(dbSkip())
	End
Else
	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[1, GdFieldPos("UA2_ITEM")] := "001"
	aCOLS[1, Len( aHeader )+1 ] := .F.
Endif
Restarea( aArea )
Return

//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvI | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na inclusão. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function Mod2GrvI()
Local aArea := GetArea()
Local nI := 0
Local nX := 0
dbSelectArea("UA2")
dbSetOrder(1)
For nI := 1 To Len( aCOLS )
	If ! aCOLS[nI,Len(aHeader)+1]
		RecLock("UA2",.T.)
		UA2->UA2_FILIAL := xFilial("UA2")
		UA2->UA2_CONTRA := cCodigo
		UA2->UA2_SEQCON := cXSeq
		UA2->UA2_TIPOCO := cTipo
		UA2->UA2_DCONTR := cNome
		UA2->UA2_STATUS := '1'
		For nX := 1 To Len( aHeader )
			FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
		Next nX
   		UA2->UA2_ITEM := STRZERO(nI,3)
   		UA2->UA2_GRUPO := cGrupo
		MsUnLock()
	Endif
Next nI
RestArea(aArea)
Return
//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvA | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function Mod2GrvA()
Local aArea := GetArea()
Local nI := 0
Local nX := 0
Local nS := 0
dbSelectArea("UA2")
For nI := 1 To Len( aREG )
	If nI <= Len( aREG )
		dbGoTo( aREG[nI] )
		RecLock("UA2",.F.)
		If aCOLS[nI, Len(aHeader)+1]
			dbDelete()
		Endif
	Else
		RecLock("UA2",.T.)
	Endif
	If !aCOLS[nI, Len(aHeader)+1]
		nS += 1
		UA2->UA2_FILIAL := xFilial("UA2")
		UA2->UA2_CONTRA := cCodigo
		UA2->UA2_SEQCON := cXSeq
		UA2->UA2_TIPOCO := cTipo
		UA2->UA2_DCONTR := cNome
		UA2->UA2_STATUS := '1' 
		For nX := 1 To Len( aHeader )
			FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
		Next nX
		UA2->UA2_ITEM := STRZERO(nS,3)
   		UA2->UA2_GRUPO := cGrupo
	Endif
	MsUnLock()
Next nI
RestArea( aArea )
Return
//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvE | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para excluir os registros. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function Mod2GrvE()
Local nI := 0
dbSelectArea("UA2")
For nI := 1 To Len( aCOLS )
	dbGoTo(aREG[nI])
	RecLock("UA2",.F.)
	dbDelete()
	MsUnLock()
Next nI
Return
//+--------------------------------------------------------------------+
//| Rotina | MnlLok | Autor | Robson Luiz (rleg) | Data |01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
User Function MnlLok()
Local lRet := .T.
Local cMensagem := "Não será permitido linhas sem o Autor e Produto."
If !aCOLS[n, Len(aHeader)+1]
	If Empty(aCOLS[n,GdFieldPos("UA2_FORNEC")]) .OR. Empty(aCOLS[n,GdFieldPos("UA2_PRODUT")])
		MsgAlert(cMensagem,cCadastro)
		lRet := .F.
	Endif
Endif
Return( lRet )
//+--------------------------------------------------------------------+
//| Rotina | MnlATOk | Autor | Robson Luiz (rleg) | Data |01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar toda as linhas de dados. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
User Function MnlATOk()
Local lRet := .T.
Local nI := 0
Local cMensagem := "Não será permitido linhas sem o Autor e Produto."
For nI := 1 To Len( aCOLS )
	If aCOLS[nI, Len(aHeader)+1]
		Loop
	Endif
	If !aCOLS[nI, Len(aHeader)+1]
		If Empty(aCOLS[nI,GdFieldPos("UA2_FORNEC")]) .OR. Empty(aCOLS[nI,GdFieldPos("UA2_PRODUT")])
			MsgAlert(cMensagem,cCadastro)
			lRet := .F.
			Exit
		Endif
	Endif
Next nI
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNDA001   ºAutor  ³Microsiga           º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function Mnlb001()
	BrwLegenda("Legenda","Status do Contrato",{	{ "BR_VERDE"   , "Aberto"},;
												{ "BR_AMARELO" , "Enviado por E-mail"},; 
												{ "BR_AZUL", "E-mail Lido"},; 
												{ "BR_VERMELHO", "Assinado"},;  
												{ "BR_LARANJA", "Autores Pendente"},;  
												{ "BR_PRETO", "Fechado"}})  
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNDA001   ºAutor  ³Microsiga           º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mnlc001()
Local cCtrato		:= UA2->UA2_CONTRA
Local cRtina		:= ""

DBSELECTAREA("UA7")
UA7->(DBSETORDER(1))
UA2->(DBSETORDER(1))
WHILE UA2->UA2_CONTRA == cCtrato .and. UA2->(!eof())
	IF UA7->(DBSEEK(XFILIAL("UA7")+UA2->UA2_CODCTR))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³CHAMA A ROTINA DA IMPRESSÃO DE CONTRATO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !EMPTY(UA7_FUNCAO)
			cRtina := IIF("()"$iif("U_"$UA7_FUNCAO,UA7_FUNCAO,"U_"+UA7_FUNCAO),iif("U_"$UA7_FUNCAO,UA7_FUNCAO,"U_"+UA7_FUNCAO),iif("U_"$UA7_FUNCAO,UA7_FUNCAO,"U_"+UA7_FUNCAO)+"()")
			cRtina := UPPER(cRtina)
			&(cRtina)
		ELSE
			ALERT("CONTRATO NÃO POSSUI ROTINA PARA EXECUTAR O WORD.DOT")
		ENDIF
	ENDIF
	UA2->(DBSKIP())
END

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNDA001   ºAutor  ³Microsiga           º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mnld001()
Local oButton1
Local oFolder1
Local oSButton1
Static oDlg
Private aItens	:= {}
Private aRegsAt	:= {}
listautor(UA2->UA2_CONTRA,UA2->UA2_SEQCON, UA2->UA2_TIPOCO)


  DEFINE MSDIALOG oDlg TITLE "Assinatura dos Autores" FROM 000, 000  TO 700, 800 COLORS 0, 16777215 PIXEL
	oFolder1 := TFolder():New( 004, 004, aItens, , oDlg,,,, .T., , 391, 322 )
    FOR nFor := 1 to len(aItens)
		SetPrvt("oGet1"+cValtochar(nFor)+",cGet1"+cValtochar(nFor)+",cGet0"+cValtochar(nFor)+",oButton"+cValtochar(nFor)+",oSay"+cValtochar(nFor)+",oScroll"+cValtochar(nFor))
		SetPrvt("oGet2"+cValtochar(nFor)+",cGet2"+cValtochar(nFor))
		SetPrvt("oGet3"+cValtochar(nFor)+",cGet3"+cValtochar(nFor))
		SetPrvt("oGet4"+cValtochar(nFor)+",cGet4"+cValtochar(nFor))
		SetPrvt("oGet5"+cValtochar(nFor)+",cGet5"+cValtochar(nFor))
		SetPrvt("oGet6"+cValtochar(nFor)+",cGet6"+cValtochar(nFor))
		SetPrvt("oGet7"+cValtochar(nFor)+",cGet7"+cValtochar(nFor))
		SetPrvt("oGet8"+cValtochar(nFor)+",cGet8"+cValtochar(nFor))
		SetPrvt("oGet9"+cValtochar(nFor)+",cGet9"+cValtochar(nFor))
		&("cGet0"+cvaltochar(nFor)) := aRegsAt[nFor][1]
		&("cGet1"+cvaltochar(nFor)) := aRegsAt[nFor][2]
		&("cGet2"+cvaltochar(nFor)) := aRegsAt[nFor][3]
		&("cGet3"+cvaltochar(nFor)) := aRegsAt[nFor][4]
		&("cGet4"+cvaltochar(nFor)) := aRegsAt[nFor][5]
		&("cGet5"+cvaltochar(nFor)) := aRegsAt[nFor][6]
		&("cGet6"+cvaltochar(nFor)) := aRegsAt[nFor][7]
		&("cGet7"+cvaltochar(nFor)) := aRegsAt[nFor][8]
		&("cGet8"+cvaltochar(nFor)) := aRegsAt[nFor][9]
		&("cGet9"+cvaltochar(nFor)) := aRegsAt[nFor][10]
	    &("oScroll"+cvaltochar(nFor)):= TScrollBox():New(oFolder1:aDialogs[nFor],002,001,310, 380,.T.,.T.,.T.)
		@ 011, 009 SAY oSay1 PROMPT "Autor" SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010, 060 MSGET &("oGet1"+cvaltochar(nFor)) VAR &("cGet1"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	:= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Produto" SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet2"+cvaltochar(nFor)) VAR &("cGet2"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Descric" SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet3"+cvaltochar(nFor)) VAR &("cGet3"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Data Ass." SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet4"+cvaltochar(nFor)) VAR &("cGet4"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "IP Ass." SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet5"+cvaltochar(nFor)) VAR &("cGet5"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Hora Ass." SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet6"+cvaltochar(nFor)) VAR &("cGet6"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Local Ass." SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet7"+cvaltochar(nFor)) VAR &("cGet7"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Maquina Ass." SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet8"+cvaltochar(nFor)) VAR &("cGet8"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		nLinha	+= 30
		@ 011+nLinha, 009 SAY oSay1 PROMPT "Status" SIZE 025, 007 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 PIXEL
		@ 010+nLinha, 060 MSGET &("oGet9"+cvaltochar(nFor)) VAR &("cGet9"+cvaltochar(nFor))  SIZE 250, 010 OF &("oScroll"+cvaltochar(nFor)) COLORS 0, 16777215 READONLY PIXEL
		@ 290, 333 BUTTON &("oButton"+cvaltochar(nFor)) PROMPT "Enviar Contrato" SIZE 037, 012 OF &("oScroll"+cvaltochar(nFor)) PIXEL ACTION(Mnle002(UA2->UA2_CONTRA,UA2->UA2_SEQCON,UA2->UA2_TIPOCO,strzero(nFor,3),&("cGet0"+cvaltochar(nFor)),&("cGet2"+cvaltochar(nFor)) ))
	next nFor  
	nFor := 0
	x:=0
	cString := "nFor:= IIF(oFolder1:nOption=0,1,oFolder1:nOption),"
	aeval(oFolder1:ADIALOGS,{|z| x++,  cString+="oFolder1:ADIALOGS["+cvaltochar(x)+"]:refresh(),oGet1"+cvaltochar(x)+":refresh(),oGet2"+cvaltochar(x)+":refresh(),oGet3"+cvaltochar(x)+":refresh(),oGet4"+cvaltochar(x)+":refresh(),oGet5"+cvaltochar(x)+":refresh(),oGet6"+cvaltochar(x)+":refresh(),oGet7"+cvaltochar(x)+":refresh(),oGet8"+cvaltochar(x)+":refresh(),oGet9"+cvaltochar(x)+":refresh(),oScroll"+cvaltochar(x)+":refresh()," })
	cString := substr(cString,1,len(cString)-1)+",oFolder1:refresh()"
	cString := "{|| "+cString+" } "
	FOR NS := 1 TO LEN(oFolder1:ADIALOGS)
		oFolder1:ADIALOGS[NS]:BGOTFOCUS  := &(cString)
	NEXT NS
	oFolder1:bSetOption := &(cString)
	oFolder1:bCHANGE := &(cString)
	oFolder1:BGOTFOCUS  := &(cString)
	if len(aItens)>1
		oFolder1:ShowPage(2)
		eval(&(cString))
	endif
	oFolder1:ShowPage(1)
	eval(&(cString))
	nFor:= 1
	oDlg:refresh()
	oGet11:Setfocus()
    DEFINE SBUTTON oSButton1 FROM 331, 159 TYPE 01 OF oDlg ENABLE action (oDlg:end())

  ACTIVATE MSDIALOG oDlg CENTERED

REturn()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³listautor ºAutor  ³Leandro duarte      º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function listautor(cContrato, cXSeq, cTipo)
lOCAL cChave := UA2->( UA2->UA2_CONTRA + UA2->UA2_SEQCON + UA2->UA2_TIPOCO )
UA2->(dbSetOrder(2))
dbSeek( xFilial( "UA2" ) + cChave )
nqtd := 0
While !EOF() .And. UA2->( UA2_FILIAL + UA2->UA2_CONTRA + UA2->UA2_SEQCON + UA2->UA2_TIPOCO ) == xFilial( "UA2" ) + cChave
	nqtd += 1
	aadd(aItens,cvaltochar(nqtd))
	AADD(aRegsAt,{UA2->UA2_FORNEC,;
				POSICIONE("SA2",1,XFILIAL("SA2")+UA2->UA2_FORNEC,"A2_NOME"),;
				UA2->UA2_PRODUT,;
				POSICIONE("SB1",1,XFILIAL("SB1")+UA2->UA2_PRODUT,"B1_DESC"),;
				UA2->UA2_DTASSI,;
				UA2->UA2_IPASSI,;
				UA2->UA2_HSASSI,;
				UA2->UA2_LCASSI,;
				UA2->UA2_NMASSI,;
				UA2->UA2_STAINT})
	UA2->(dbSkip())
END
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mnle001   ºAutor  ³Leandro Duarte      º Data ³  03/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dispara o e-mail para os autores junto com o contrato digital±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function Mnle001()
Local cPara			:= ""
Local cAssunto		:= "" 
Local cMsg			:= ""
Local lRet			:= .T.
lOCAL cChave := UA2->( UA2->UA2_CONTRA + UA2->UA2_SEQCON + UA2->UA2_TIPOCO )
UA2->(dbSetOrder(2))
dbSeek( xFilial( "UA2" ) + cChave )
While !EOF() .And. UA2->( UA2_FILIAL + UA2->UA2_CONTRA + UA2->UA2_SEQCON + UA2->UA2_TIPOCO ) == xFilial( "UA2" ) + cChave
	cPara		:= 'leandro.duarte@gmail.com'//POSICIONE("SA2",1,XFILIAL("SA2")+UA2->UA2_FORNEC,"A2_EMAIL")
	cAssunto	:= "Contrato de Direitos Autorais"
	cMsg		:= "Caro senhor(a) <b>"+POSICIONE("SA2",1,XFILIAL("SA2")+UA2->UA2_FORNEC,"ALLTRIM(SA2->A2_NOME)")+"</b><br>Você esta recebendo o link do contrato para ser analisado e assinado do contrato do Direitos autorais.<br>Por click no link e leie atentamente o Contrato Eletronico<br>"
	cMsg		+= '<a href="'+cLink+'/u_contrato.apw?cCT='+u_trocar(alltrim(UA2->UA2_CONTRA),2)+'&cXSeq='+u_trocar(alltrim(UA2->UA2_SEQCON),2)+'&cTPO='+u_trocar(alltrim(UA2->UA2_TIPOCO),2)+'&cAt='+u_trocar(alltrim(UA2->UA2_FORNEC),2)+'">Contrato: '+UA2->UA2_CONTRA+'</a>'
	lRet := u_EmailEnv(cPara,cAssunto,cMsg)
	if lRet
		reclock("UA2",.F.)
		UA2->UA2_STATUS := '2'
		UA2->UA2_STAINT := 'DISPARO DO E-MAIL REALIZADO '+DTOC(DDATABASE)+" Hora: "+time()
		Msunlock()
		UA2->(dbSkip())
	endif
END

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNDA001   ºAutor  ³Microsiga           º Data ³  03/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function trocar(cRa,cOpc)
Local cRet := ""
// opc 1 troca a informa?o que vio pelo ra
if cOpc == 1
	For nFor := 1 to len(cRa) step 2
		cRet += CHR(VAL(substr(cRa,nFor,2)))
	next nFor
elseif cOpc == 2
	//opc2 troca o ra por criptografia
	FOR nFor := 1 to len(cRa)
		cRet += cValtochar(ASC(substr(cRa,nFor,1)))
	next nFor
endif
return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNDA001   ºAutor  ³Microsiga           º Data ³  03/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
sTATIC function Mnle002(cContr,cXSeq,cTipo,cItem,cForne,cProd)
Local cPara			:= ""
Local cAssunto		:= "" 
Local cMsg			:= ""
UA2->(dbSetOrder(2))
if UA2->(dbSeek( xFilial( "UA2" ) + cContr + cXSeq + cTipo + cItem + cForne + cProd ))
	cPara		:= POSICIONE("SA2",1,XFILIAL("SA2")+UA2->UA2_FORNEC,"A2_EMAIL")
	cAssunto	:= "Contrato de Direitos Autorais"
	cMsg		:= "Caro senhor(a) <b>"+ALLTRIM(SA2->A2_NOME)+"</b><br>Você esta recebendo o link do contrato para ser analisado e assinado do contrato do Direitos autorais.<br>Por click no link e leie atentamente o Contrato Eletronico<br>"
	cMsg		+= '<a href="'+cLink+'/u_contrato.apw?cCT='+u_trocar(alltrim(UA2->UA2_CONTRA),2)+'&cXSeq='+u_trocar(alltrim(UA2->UA2_SEQCON),2)+'&cTPO='+u_trocar(alltrim(UA2->UA2_TIPOCO),2)+'&cAt='+u_trocar(alltrim(UA2->UA2_FORNEC),2)+">Contrato: "+UA2->UA2_CONTRA+'</a>'
	lRet := u_EmailEnv(cPara,cAssunto,cMsg)
	if lRet
		reclock("UA2",.F.)
		UA2->UA2_STATUS := '2'
		UA2->UA2_STAINT := 'DISPARO DO E-MAIL REALIZADO '+DTOC(DDATABASE)+" Hora: "+time()
		Msunlock()
		UA2->(dbSkip())
	endif
ENDIF

Return() 