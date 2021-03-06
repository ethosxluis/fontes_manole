#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDEPARA  �Autor  �Leandro Duarte      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela de para                                                ���
���          �essa rotina servira para manuten��o futura DE PARA com  Vtex���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function MNDePara()
Private cCadastro := "Cadastro de DE PARA"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","u_MNDPVIS()",0,2} ,;
					{"Incluir","u_MNDPINCL()",0,3} ,;
					{"Alterar","u_MNDPALT()",0,4} ,;
					{"Excluir","u_MNDPDEL()",0,5} ,;
					{"Nova Vers�o","u_MNDPVER()",0,6}  ,;
					{"Legenda","u_MNLegnd()",0,6} }

Private aCores := {	{"UA1_STATUS == '1'", "BR_VERDE"   },;	// ATIVO
					{"UA1_STATUS == '2'", "BR_VERMELHO"}} 	// DESATIVO


Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cAlias := "UA1"
Private lWin 	:= file('c:\windows')
Private cArqPed := iif(lWin,"\imp_vtex\"+dtos(date())+replace(time(),':','')+".txt","/imp_vtex/"+dtos(date())+replace(time(),':','')+".txt")
Private oGet
makedir("\imp_vtex\")
dbSelectArea("UA1")
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias,,,,,,aCores )
ferase(cArqPed)
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPINCL  �Autor  �LEANDRO DUARTE      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA MODELO 2 PARA CRIA��O DOS CAMPOS DE PARA COM A VTEX  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNDPINCL()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 3
Local aButtons := {}
Private oComboBo1
Private nComboBo1 := 1
Private aCombo := {"Cliente","Cab.Pedido","Det.Pedido"}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= GETSXENUM("UA1","UA1_COD")
Private cDesc	:= SPACE(50)
Private cVers	:= "0001"
Private cTipo	:= '1'
ConfirmSX8()
                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )
aAdd( aButtons, {"SDUSETDEL",{|| u_MNSxb01() },"Listar Campos", "Listar" } )

dbSelectArea( "UA1" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, 0, nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,70 SAY "Nome:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,190 SAY "Vers�o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,26 MSGET cCod PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 4,90 MSGET cDesc PICTURE "@!"  SIZE 78,7 PIXEL OF oTPanel1
@ 4,212 MSGET cVers PICTURE "@!" WHEN .F. SIZE 40,7 PIXEL OF oTPanel1
oComboBo1:= tComboBox():New(4,272,{|u|if(PCount()>0,nComboBo1:=u,nComboBo1)},aCombo,100,20,oDlg,,{|| EXISTUA1(nComboBo1) },,,,.T.,,,,,,,,,'nComboBo1') 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","+C7_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_Mod2TOk(),( Processa({|| grvUa1(nOpc,aCOLS,aHeader,nComboBo1) },"Efetuando a Grava��o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() },,aButtons)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPALT   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera��o dos dados DEPARA                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNDPALT()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 4
Local aButtons := {}
Private oComboBo1
Private nComboBo1 := VAL(UA1->UA1_ROTINA)
Private aCombo := {"Cliente","Cab.Pedido","Det.Pedido"}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA1->UA1_COD
Private cDesc	:= UA1->UA1_DESC
Private cVers	:= UA1->UA1_VERSAO
Private cTipo	:= UA1->UA1_ROTINA

cNomeArqu := UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
if file(cNomeArqu+'.dtc')
	aviso("Aviso","Aten��o ja existe uma tabela com essa vers�o sendo utilizada, Por Favor utiliza a rotina de Nova vers�o",{"Ok"})
endif

aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

aAdd( aButtons, {"SDUSETDEL",{|| u_MNSxb01() },"Listar Campos", "Listar" } )

dbSelectArea( "UA1" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA1->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,70 SAY "Nome:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,190 SAY "Vers�o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,26 MSGET cCod WHEN .F.PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 4,90 MSGET cDesc PICTURE "@!"  SIZE 78,7 PIXEL OF oTPanel1
@ 4,212 MSGET cVers WHEN .F.PICTURE "@!" SIZE 40,7 PIXEL OF oTPanel1
oComboBo1:= tComboBox():New(4,272,{|u|if(PCount()>0,nComboBo1:=u,nComboBo1)},aCombo,100,20,oDlg,,{|| EXISTUA1(nComboBo1) },,,,.T.,,,,{|| .f.},,,,,'nComboBo1') 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","+C7_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_Mod2TOk(),( Processa({|| grvUa1(nOpc,aCOLS,aHeader,nComboBo1) },"Efetuando a Altera��o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() },,aButtons)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPDEL   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �DELETAR dos dados DEPARA                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNDPDEL()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 5
Private oComboBo1
Private nComboBo1 := VAL(UA1->UA1_ROTINA)
Private aCombo := {"Cliente","Cab.Pedido","Det.Pedido"}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA1->UA1_COD
Private cDesc	:= UA1->UA1_DESC
Private cVers	:= UA1->UA1_VERSAO
Private cTipo	:= UA1->UA1_ROTINA

                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

dbSelectArea( "UA1" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA1->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,70 SAY "Nome:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,190 SAY "Vers�o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,26 MSGET cCod WHEN .F.PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 4,90 MSGET cDesc WHEN .F.PICTURE "@!"  SIZE 78,7 PIXEL OF oTPanel1
@ 4,212 MSGET cVers WHEN .F.PICTURE "@!" SIZE 40,7 PIXEL OF oTPanel1
oComboBo1:= tComboBox():New(4,272,{|u|if(PCount()>0,nComboBo1:=u,nComboBo1)},aCombo,100,20,oDlg,,{|| EXISTUA1(nComboBo1) },,,,.T.,,,,{|| .f.},,,,,'nComboBo1') 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","+C7_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_Mod2TOk(),( Processa({|| grvUa1(nOpc,aCOLS,aHeader,nComboBo1) },"Efetuando a Exclus�o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() })

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPVIS   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �VISUALIZAR dos dados DEPARA                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNDPVIS()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 2
Private oComboBo1
Private nComboBo1 := VAL(UA1->UA1_ROTINA)
Private aCombo := {"Cliente","Cab.Pedido","Det.Pedido"}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA1->UA1_COD
Private cDesc	:= UA1->UA1_DESC
Private cVers	:= UA1->UA1_VERSAO
Private cTipo	:= UA1->UA1_ROTINA

                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

dbSelectArea( "UA1" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA1->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,70 SAY "Nome:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,190 SAY "Vers�o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,26 MSGET cCod WHEN .F.PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 4,90 MSGET cDesc WHEN .F.PICTURE "@!"  SIZE 78,7 PIXEL OF oTPanel1
@ 4,212 MSGET cVers WHEN .F.PICTURE "@!" SIZE 40,7 PIXEL OF oTPanel1
oComboBo1:= tComboBox():New(4,272,{|u|if(PCount()>0,nComboBo1:=u,nComboBo1)},aCombo,100,20,oDlg,,{|| EXISTUA1(nComboBo1) },,,,.T.,,,,{|| .T.},,,,,'nComboBo1') 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","+C7_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||  oDlg:End() },{|| oDlg:End() })

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPVER   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �versao dos dados DEPARA                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNDPVER()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 4
Local aButtons := {}
Private oComboBo1
Private nComboBo1 := VAL(UA1->UA1_ROTINA)
Private aCombo := {"Cliente","Cab.Pedido","Det.Pedido"}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA1->UA1_COD
Private cDesc	:= UA1->UA1_DESC
Private cVers	:= soma1(UA1->UA1_VERSAO)
Private cTipo	:= UA1->UA1_ROTINA
Private cVersold	:= UA1->UA1_VERSAO


//������������������������������Ŀ
//�analisa se existe outra vers�o�
//��������������������������������
if !analver(xfilial("UA1"),cCod,cVersold)
	REturn()
endif
                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

aAdd( aButtons, {"SDUSETDEL",{|| u_MNSxb01() },"Listar Campos", "Listar" } )
dbSelectArea( "UA1" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA1->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,70 SAY "Nome:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,190 SAY "Vers�o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,26 MSGET cCod WHEN .F.PICTURE "@!" WHEN .F. SIZE 030,7 PIXEL OF oTPanel1
@ 4,90 MSGET cDesc PICTURE "@!"  SIZE 78,7 PIXEL OF oTPanel1
@ 4,212 MSGET cVers WHEN .F.PICTURE "@!" SIZE 40,7 PIXEL OF oTPanel1
oComboBo1:= tComboBox():New(4,272,{|u|if(PCount()>0,nComboBo1:=u,nComboBo1)},aCombo,100,20,oDlg,,{|| EXISTUA1(nComboBo1) },,,,.T.,,,,{|| .f.},,,,,'nComboBo1') 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","+C7_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_Mod2TOk(),( Processa({|| grvUa1(6,aCOLS,aHeader,nComboBo1) },"Gravando a Npva vers�o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() },,aButtons)


Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mod2aHeader�Autor  �Leandro Duarte     � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria��o da rotina para a leitura da estrutura do aCols      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mod2aHeader(ctab)
SX3->(DbSetorder(2))
SX3->(Dbseek("C7_ITEM"))
SX3->(Aadd(aHeader,{ "ITEM", x3_campo, x3_picture,x3_tamanho, x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } ))
SX3->(Dbseek("B1_DESC"))
SX3->(Aadd(aHeader,{ "CAMPO_VTEX", x3_campo, x3_picture,2550, x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } ))
SX3->(Dbseek("A1_NOME"))
SX3->(Aadd(aHeader,{ "CAMPO_PROTHEUS", x3_campo, x3_picture,2550, x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } ))
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mod2aCOLS �Autor  �Leandro Duarte      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para capturar os alores de para do protheus X Vtex   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mod2aCOLS( cAlias, nReg, nOpc )
Local cChave	:= xFilial( cAlias ) + UA1->UA1_COD + UA1->UA1_VERSAO 
Local aArea		:= UA1->(GETAREA())
Local ni		:= 0
if nOpc == 3
	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		IF ALLTRIM(aHeader[NI][2]) == "C7_ITEM"
			aCOLS[1, nI] := "0001"
		ELSE
			aCOLS[1, nI] := space( aHeader[nI, 4] )
		ENDIF
	Next nI
	aCOLS[1, Len( aHeader )+1 ] := .F.	
else
	dbSelectArea( cAlias )
	dbSetOrder(1)
	dbSeek( xFilial( cAlias ) + UA1->UA1_COD + UA1->UA1_VERSAO )
	While !EOF() .And. UA1->( UA1_FILIAL + UA1_COD + UA1_VERSAO ) == cChave
		cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
		WHILE AT('|',cMemo) >0
			AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
			cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
			aCOLS[Len(aCOLS),1] := SUBSTR(cMemo,1,AT(';',cMemo)-1)
			cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
			aCOLS[Len(aCOLS),2] := SUBSTR(cMemo,1,AT(';',cMemo)-1)+space(2550-len(alltrim(aCOLS[Len(aCOLS),2])))
			cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
			aCOLS[Len(aCOLS),3] := SUBSTR(cMemo,1,AT('|',cMemo)-1)+space(250-len(alltrim(aCOLS[Len(aCOLS),3])))
			cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		END
		UA1->(dbSkip())
	End
endif
Restarea(aArea)
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mod2LOk   �Autor  �LEANDRO DUARTE      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA DE VALIDA��O DE LINHA DIGITADA                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION Mod2LOk()
Local lRet	:= .t.
if !aCOLS[n,Len(aHeader)+1]
	xValor1	:= alltrim(acols[n][2])
	xValor2	:= alltrim(acols[n][3])
	nLin	:= aScan(acols,{|z| alltrim(z[2]) == xValor1 .and. z[1] <> acols[n][1] .and. alltrim(z[3]) == xValor2 })
	if nLin > 0 .and. !acols[nLin][Len(aHeader)+1]
		MsgStop('Registro Duplicado no item: '+acols[nLin][1])
		lRet	:= .f.
	endif
endif
//����������������������������������������������������������������Ŀ
//�analisa se existe o campo na coluna protheus na estrutura do SX3�
//������������������������������������������������������������������
if lRet
   IF !aCOLS[n,Len(aHeader)+1]
		aSx3Area := SX3->(getarea())
		SX3->(DBSETORDER(2))
		IF SX3->(DBSEEK(padr(aCOLS[n,Len(aHeader)],10))) .and. SX3->X3_CONTEXT == 'V'
			MsgStop('Campo '+alltrim(aCOLS[n,Len(aHeader)])+' � Virtual, por favor escolher campo real')
			lRet	:= .f.
		ELSEIF !SX3->(DBSEEK(padr(aCOLS[n,Len(aHeader)],10)))
			MsgStop('Campo n�o existe na estrutura: '+alltrim(aCOLS[n,Len(aHeader)]))
			lRet	:= .f.
		ENDIF
		Restarea(aSx3Area)
	ENDIF
endif

if lRet
	EXISTUA1(nComboBo1)
endif
RETURN(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mod2TOk   �Autor  �leandro duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �executa a analise de verifica��o de duplicidades em todo o  ���
���          �acols                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function Mod2TOk()
Local nx	:= n
Local lRet	:= .t.
Local nY	:= 0

For nY := 1 to len(aCols)
	n	:=	nY
	lRet	:= u_Mod2LOk()
next nY

n := nx

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXISTUA1  �Autor  �LEANDRO DUARTE      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �NALISA SE EXISTE A INFORMA��O DA UA1 JA CADASTRADA          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION EXISTUA1(nComboBo1)
Local nOpcoa 	:= ascan(aCombo,nComboBo1)
Local aArea 	:= UA1->(GETAREA())
Local lRet		:= .t.

UA1->(DBSETORDER(2))

IF UA1->(DBSEEK(XFILIAL("UA1")+cvaltochar(nOpcoa)))
	ALERT("Ja existe o cadastro da op��o "+nComboBo1+". "+CRLF+"Por favor Localize o registre e altere a informa��o desejada!")
	lRet		:= .F.
ENDIF

RESTAREA(aArea)
RETURN(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �grvUa1    �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a grava��o dos dados na tabela DEPARA                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function grvUa1(nOpc,aCOLS,aHeader,cTipo)
Local cMemo	:= ""
Local xTipo	:= iif(valtype(cTipo)=='N',CVALTOCHAR(cTipo),IIF(valtype(cTipo)=='U','1',cTipo))
Local nFor	:= 0

Procregua(len(aCOLS))
BeginTran() 
if nOpc == 3 .or. nOpc == 6 // inclus�o ou nova versao
	if nopc == 6 
		if UA1->(dbSeek( xFilial( cAlias ) + UA1->UA1_COD + cVersold ))
			Reclock("UA1",.F.)
				UA1->UA1_STATUS := '2'
			Msunlock()
	    endif	
	endif
	Reclock("UA1",.T.)
		UA1->UA1_FILIAL := XFILIAL("UA1")
		UA1->UA1_COD	:= cCod
		UA1->UA1_DESC	:= cDesc
		UA1->UA1_VERSAO	:= cVers
		UA1->UA1_ROTINA	:= xTipo
		UA1->UA1_STATUS := '1'	
		for nFor := 1 to len(aCOLS)
			if nOpc == 6
				incproc("Gravando a nova vers�o")
			else
				incproc("Efetuando a grava��o")
			endif
			if !aCOLS[nFor][Len(aHeader)+1]
				cMemo	+= ';'+alltrim(aCOLS[nFor][1])
				cMemo	+= ';'+alltrim(aCOLS[nFor][2])
				cMemo	+= ';'+alltrim(aCOLS[nFor][3])+"|" 
			endif
		Next NFor
		UA1->UA1_DEPARA	:= cMemo	
	Msunlock()
elseif nOpc == 4 //altera��o
	incproc("Efetuando a altera��o")
	Reclock("UA1",.F.)
	for nFor := 1 to len(aCOLS)
		if !aCOLS[nFor][Len(aHeader)+1]
			cMemo	+= ';'+alltrim(aCOLS[nFor][1])
			cMemo	+= ';'+alltrim(aCOLS[nFor][2])
			cMemo	+= ';'+alltrim(aCOLS[nFor][3])+"|" 
		endif
		UA1->UA1_DEPARA	:= cMemo	
	next nFor
	Msunlock()
elseif nOpc == 5 // exclus�o
	incproc("Efetuando a Exclus�o")
	aArea := UA1->(GETAREA())
	cVersold	:= strzero(val(cVers)-1,4)
	cCod		:= UA1->UA1_COD
	if !analver(xfilial("UA1"), cCod, cVers, "N�o possibilitando a sua Exclus�o!" )
		DisarmTransaction()
		MsUnlockAll()
		return()
	endif
	if UA1->(dbSeek( xFilial( cAlias ) + cCod + cVersold ))
		Reclock("UA1",.F.)
			UA1->UA1_STATUS := '1'
		Msunlock()
	else
		cVersold	:= strzero(val(cVersold)-1,4)
		while !UA1->(dbSeek( xFilial( cAlias ) + cCod + cVersold )) .and. cVersold>= '0000'
			cVersold	:= strzero(val(cVersold)-1,4)
		end
		if UA1->(dbSeek( xFilial( cAlias ) + cCod + cVersold )) .and. cVersold>= '0000'
			Reclock("UA1",.F.)
			UA1->UA1_STATUS := '1'
			Msunlock()
		endif
	endif	
	Restarea(aArea)
	Reclock("UA1",.F.)
	UA1->(DBDELETE())
	Msunlock()
endif
EndTran()
MsUnlockAll()
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNLegnd   �Autor  �Leandro duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de legenda de ativo e desativo                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function MNLegnd

Local aLegenda	:= {{"BR_VERDE"   ,"Registro Ativo"},;	// "Nao Processado"
{"BR_VERMELHO",	"Registro Desativado" }} 	// "Processado Fase"

BrwLegenda("De - Psra","Legenda",aLegenda) // "Processo Seletivo" , "Legenda"

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �analiver  �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Analisa se existe uma vers�o ativa superior a que ele esta  ���
���          �querendo gerar nova vers�o                                  ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION analver(xFilx, cCod, xVerx, cMsg )
Local aArea	:= UA1->(GETAREA())
Local lRet	:= .t.
Local cVer1	:= soma1(xVerx)
Default cMsg	:= ""
UA1->(dbsetorder(1))
if UA1->(DbSeek(xFilx+cCod+cVer1))
	aviso("Aten��o","J� existe uma nova vers�o desse cadastro. "+cMsg,{"ok"})	
	lRet	:= .F.
endif
RESTAREA(aArea)
Return(lRet)

