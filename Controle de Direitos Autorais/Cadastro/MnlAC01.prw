#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNLAC01   ºAutor  ³LEANDRO DUARTE      º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina modelo 2 para o cadastro                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNLAC01()
Private cCadastro := "Alçada de Assinaturas"
Private aRotina := {}
Private aButtons	:= {}
Private cFiltro  := "UA6->UA6_SEQUEN =='01'"
Private aIndexSYP := {}
Private bFiltraBrw:= { || FilBrowse("UA6",@aIndexSYP,@cFiltro) }
  
					
AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
AADD( aRotina, {"Visualizar" ,'U_MnlAC02',0,2})
AADD( aRotina, {"Incluir" ,'U_MnlAC03',0,3})
AADD( aRotina, {"Alterar" ,'U_MnlAC02',0,4})
AADD( aRotina, {"Excluir" ,'U_MnlAC02',0,5})

dbSelectArea("UA6")
dbSetOrder(1)
dbGoTop()

Eval(bFiltraBrw)
MBrowse(,,,,"UA6",,,,,,)
EndFilBrw("UA6",aIndexSYP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MnlAC01   ºAutor  ³Leandro Duarte      º Data ³  03/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     rotina de inclusão                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MnlAC03( cAlias, nReg, nOpc )
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Private cCodigo		:= GETSXENUM("UA6","UA6_GRUPO")
Private cNome		:= space(tamsx3("UA6_DESC")[1])
Private N			:= 1
Private aObj		:= {}
Private aHeader		:= {}
Private aCOLS		:= {}
Private aREG		:= {}
Private inclui		:= iif(nOpc==4,.f.,.t.)
Private altera		:= iif(nOpc==4,.t.,.f.)
ConfirmSX8()
EndFilBrw(cAlias,aIndexSYP)
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
oGet := MSGetDados():New(0,0,0,0,nOpc,"U_MnlacLok()",".T.","+UA6_SEQUEN",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

@ 4, 006 SAY "Grupo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 070 SAY "Descrição:" SIZE 70,7 PIXEL OF oTPanel1

@ 3, 030 MSGET cCodigo  PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 3, 105 MSGET cNome PICTURE "@!"  SIZE 350,7 PIXEL OF oTPanel1

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_MnlAcTOk(), (Mod2GrvI(),oDlg:End()), NIL  )},{|| (RollbackSx8(),oDlg:End()) },,)
Eval(bFiltraBrw)
Return
//+--------------------------------------------------------------------+
//| Rotina | MnlA001 | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
User Function MnlAC02( cAlias, nReg, nOpc )
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Private aObj := {}
Private cCodigo		:= UA6->UA6_GRUPO
Private cNome		:= UA6->UA6_DESC
Private N	  		:= 1
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private inclui		:= iif(nOpc==4,.f.,.t.)
Private altera		:= iif(nOpc==4,.t.,.f.)
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
	oGet := MSGetDados():New(0,0,0,0,nOpc,"U_MnlacLok()",".T.","+UA6_SEQUEN",.T.)
Else
	oGet := MSGetDados():New(0,0,0,0,nOpc,,,.T.)
Endif
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

@ 4, 006 SAY "Grupo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 030 SAY "Descrição:" SIZE 70,7 PIXEL OF oTPanel1

@ 3, 030 MSGET cCodigo  PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 3, 105 MSGET cNome PICTURE "@!"  SIZE 350,7 PIXEL OF oTPanel1

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| ( IIF( nOpc==4 .AND. U_MnlAcTOk(), Mod2GrvA(), IIF( nOpc==5 .AND. U_MnlAcTOk(), Mod2GrvE(), oDlg:End() ) ), oDlg:End() ) },{|| oDlg:End() },,)
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
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .and. !(alltrim(X3_CAMPO) $ 'UA6_GRUPO,UA6_DESC')
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
Local cChave := UA6->UA6_FILIAL+UA6->UA6_GRUPO
Local nI := 0
Local nPos	:= ascan(aHeader,{|x| alltrim(x[2]) == "UA6_USR" })
If nOpc <> 3
	dbSelectArea( cAlias )
	dbSetOrder(1)
	dbSeek( cChave )
	While !EOF() .And. UA6->( UA6_FILIAL + UA6->UA6_GRUPO  ) == cChave
		AADD( aREG, UA6->( RecNo() ) )
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V" .and. alltrim(aHeader[nI,2]) == "UA6_USRD" 
				aCOLS[Len(aCOLS),nI] := UsrFullName(aCOLS[Len(aCOLS)][nPos]) 
			elseif aHeader[nI,10] == "V" 
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
	End
Else
	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[1, GdFieldPos("UA6_SEQUEN")] := "01"
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
dbSelectArea("UA6")
dbSetOrder(1)
For nI := 1 To Len( aCOLS )
	If ! aCOLS[nI,Len(aHeader)+1]
		RecLock("UA6",.T.)
		UA6->UA6_FILIAL := xFilial("UA6")
		UA6->UA6_GRUPO  := cCodigo
		UA6->UA6_DESC   := cNome
		For nX := 1 To Len( aHeader )
			FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
		Next nX
   		UA6->UA6_SEQUEN := STRZERO(nI,2)
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
dbSelectArea("UA6")
For nI := 1 To Len( aREG )
	If nI <= Len( aREG )
		dbGoTo( aREG[nI] )
		RecLock("UA6",.F.)
		If aCOLS[nI, Len(aHeader)+1]
			dbDelete()
		Endif
	Else
		RecLock("UA6",.T.)
	Endif
	If !aCOLS[nI, Len(aHeader)+1]
		nS += 1
		UA6->UA6_FILIAL := xFilial("UA6")
		UA6->UA6_GRUPO  := cCodigo
		UA6->UA6_DESC   := cNome
		For nX := 1 To Len( aHeader )
			FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
		Next nX
		UA6->UA6_SEQUEN := STRZERO(nS,2)
	Endif
	MsUnLock()
Next nI
RestArea( aArea )
ny := nI
nI := 0
nX := 0
nPos1	:= aScan(aHeader,{|x| alltrim(x[2]) == "UA6_SEQUEN"})
nPos2	:= aScan(aHeader,{|x| alltrim(x[2]) == "UA6_USR"})
dbSelectArea("UA6")
UA6->(DBSETORDER(1))
For nI := ny To Len( aColS )
	lSeek := !UA6->(DBSEEK(XfILIAL("UA6")+cCodigo+aCOLS[nI, nPos1]+aCOLS[nI, nPos2]))
	RECLOCK("UA6",lSeek)
	If !aCOLS[nI, Len(aHeader)+1]
		nS += 1
		UA6->UA6_FILIAL := xFilial("UA6")
		UA6->UA6_GRUPO  := cCodigo
		UA6->UA6_DESC   := cNome
		For nX := 1 To Len( aHeader )
			FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
		Next nX
		UA6->UA6_SEQUEN := STRZERO(nS,2)
	ELSE
		dbDelete()
	Endif
	MsUnLock()
Next nI
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
dbSelectArea("UA6")
For nI := 1 To Len( aCOLS )
	dbGoTo(aREG[nI])
	RecLock("UA6",.F.)
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
User Function MnlACLok()
Local lRet := .T.
Local cMensagem := "Por Favor Preencher o Cadastro do Usuario"
If !aCOLS[n, Len(aHeader)+1]
	If Empty(aCOLS[n,GdFieldPos("UA6_USR")])
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
User Function MnlACTOk()
Local lRet := .T.
Local nI := 0
Local cMensagem := "Não será permitido linhas sem o usuario preenchido."
For nI := 1 To Len( aCOLS )
	If aCOLS[nI, Len(aHeader)+1]
		Loop
	Endif
	If !aCOLS[nI, Len(aHeader)+1]
		If Empty(aCOLS[nI,GdFieldPos("UA6_USR")])
			MsgAlert(cMensagem,cCadastro)
			lRet := .F.
			Exit
		Endif
	Endif
Next nI
Return( lRet )
