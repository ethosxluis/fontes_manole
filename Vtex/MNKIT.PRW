#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNKIT     �Autor  �Leandro Duarte      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela de para                                                ���
���          �essa rotina servira para manuten��o futura DE PARA com  Vtex���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function MNKIT01()
LOCAL cFiltra	:= " UA3_ITEM == '01' "
Private cCadastro := "Cadastro de de Kit de Vendas"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","u_MNKTVIS()",0,2} ,;
					{"Incluir","u_MNKTINCL()",0,3} ,;
					{"Alterar","u_MNKTALT()",0,4} ,;
					{"Excluir","u_MNKTDEL()",0,5}  }
Private sString := "UA3"
Private aIndexUA3 := {}
Private bFiltraBrw:= { || FilBrowse(sString,@aIndexUA3,@cFiltra) }
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cAlias := "UA3"
Private oGet
dbSelectArea("UA3")
dbSetOrder(1)
Eval(bFiltraBrw)
mBrowse( 6,1,22,75,cAlias )
EndFilBrw(sString,aIndexUA3)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNKTINCL  �Autor  �LEANDRO DUARTE      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA MODELO 2 PARA CRIA��O DOS CAMPOS DE PARA COM A VTEX  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNKTINCL()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 3
Local aButtons := {}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= SPACE(TAMSX3("UA3_CODKIT")[1])
Private cDesc	:= SPACE(150)
Private cSkuid	:= SPACE(TAMSX3("UA3_SKUID")[1])
EndFilBrw(sString,aIndexUA3)
                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )


dbSelectArea( "UA3" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, 0, nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,110 SAY "Descri��o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,330 SAY "Sku Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,40 MSGET cCod PICTURE "@!" WHEN .T. SIZE TAMSX3("UA3_CODKIT")[1]*4,7 PIXEL OF oTPanel1
@ 4,140 MSGET cDesc PICTURE "@!"  SIZE 178,7 PIXEL OF oTPanel1 
@ 4,360 MSGET cSkuid PICTURE "@!"  SIZE TAMSX3("UA3_SKUID")[1]*4,7 PIXEL OF oTPanel1 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_KIT2LOk()",".T.","+UA3_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_KITTOk(),( Processa({|| grvUA3(nOpc,aCOLS,aHeader) },"Efetuando a Grava��o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() },,aButtons)
Eval(bFiltraBrw)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNKTALT   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera��o dos dados DEPARA                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNKTALT()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 4
Local aButtons := {}
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA3->UA3_CODKIT
Private cDesc	:= UA3->UA3_DESCRI
Private cSkuid	:= UA3->UA3_SKUID
EndFilBrw(sString,aIndexUA3)

aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )


dbSelectArea( "UA3" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA3->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,110 SAY "Descri��o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,330 SAY "Sku Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,40 MSGET cCod PICTURE "@!" WHEN .F. SIZE TAMSX3("UA3_CODKIT")[1]*4,7 PIXEL OF oTPanel1
@ 4,140 MSGET cDesc PICTURE "@!"  SIZE 178,7 PIXEL OF oTPanel1 
@ 4,360 MSGET cSkuid PICTURE "@!" WHEN .F. SIZE TAMSX3("UA3_SKUID")[1]*4,7 PIXEL OF oTPanel1 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_KIT2LOk()",".T.","+UA3_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_KITTOk(),( Processa({|| grvUA3(nOpc,aCOLS,aHeader) },"Efetuando a Altera��o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() },,aButtons)
Eval(bFiltraBrw)
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNKTDEL   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �DELETAR dos dados DEPARA                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNKTDEL()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 5
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA3->UA3_CODKIT
Private cDesc	:= UA3->UA3_DESCRI
Private cSkuid	:= UA3->UA3_SKUID
EndFilBrw(sString,aIndexUA3)

                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

dbSelectArea( "UA3" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA3->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,110 SAY "Descri��o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,330 SAY "Sku Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,40 MSGET cCod PICTURE "@!" WHEN .F. SIZE TAMSX3("UA3_CODKIT")[1]*4,7 PIXEL OF oTPanel1
@ 4,140 MSGET cDesc PICTURE "@!"  SIZE 178,7 PIXEL OF oTPanel1 
@ 4,360 MSGET cSkuid PICTURE "@!" WHEN .F. SIZE TAMSX3("UA3_SKUID")[1]*4,7 PIXEL OF oTPanel1 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_KIT2LOk()",".T.","+UA3_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_KITTOk(),( Processa({|| grvUA3(nOpc,aCOLS,aHeader) },"Efetuando a Exclus�o","aguarde"), oDlg:End() ), NIL  )},{|| oDlg:End() })
Eval(bFiltraBrw)
Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNKTVIS   �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �VISUALIZAR dos dados DEPARA                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNKTVIS()
Local oDlg
Local oTPanel1
Local oTPAnel2
Local nOpc	:= 2
Private aSize := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aObj := {}
Private cCod	:= UA3->UA3_CODKIT
Private cDesc	:= UA3->UA3_DESCRI
Private cSkuid	:= UA3->UA3_SKUID
EndFilBrw(sString,aIndexUA3)
                   
aSize := MsAdvSize()
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
aPObj := MsObjSize( aInfo, aObj )
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

dbSelectArea( "UA3" )
dbSetOrder(1)
Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, UA3->(RECNO()), nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP
@ 4,6 SAY "C�digo Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,110 SAY "Descri��o:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,330 SAY "Sku Kit:" SIZE 70,7 PIXEL OF oTPanel1
@ 4,40 MSGET cCod PICTURE "@!" WHEN .F. SIZE TAMSX3("UA3_CODKIT")[1]*4,7 PIXEL OF oTPanel1
@ 4,140 MSGET cDesc PICTURE "@!"  SIZE 178,7 PIXEL OF oTPanel1 
@ 4,360 MSGET cSkuid PICTURE "@!" WHEN .F. SIZE TAMSX3("UA3_SKUID")[1]*4,7 PIXEL OF oTPanel1 
oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_KIT2LOk()",".T.","+UA3_ITEM",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||  oDlg:End() },{|| oDlg:End() })
Eval(bFiltraBrw)
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
SX3->(Dbseek("UA3_ITEM"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_PRODUT"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_DESPRO"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_VALOR"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_PERDLI"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_CODPER"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_GANHLI"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
SX3->(Dbseek("UA3_CODGAN"))
SX3->(Aadd(aHeader,{ alltrim( X3Titulo() ),AllTrim(X3_CAMPO),X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } ))
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
Local cChave	:= xFilial( cAlias ) + UA3->UA3_CODKIT + UA3->UA3_SKUID 
Local aArea		:= UA3->(GETAREA())
Local nI		:= 0
if nOpc == 3
	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		IF ALLTRIM(aHeader[NI][2]) == "UA3_ITEM"
			aCOLS[1, nI] := "01"
		ELSEIF aHeader[NI][8] == "N"
			aCOLS[1, nI] := 0
		ELSE
			aCOLS[1, nI] := space( aHeader[nI, 4] )
		ENDIF
	Next nI
	aCOLS[1, Len( aHeader )+1 ] := .F.	
else
	dbSelectArea( cAlias )
	dbSetOrder(1)
	dbSeek( xFilial( cAlias ) + UA3->UA3_CODKIT + UA3->UA3_SKUID  )
	While !EOF() .And. UA3->( UA3_FILIAL + UA3_CODKIT + UA3->UA3_SKUID  ) == cChave
			AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
			aCOLS[Len(aCOLS),1] := UA3->UA3_ITEM
			aCOLS[Len(aCOLS),2] := UA3->UA3_PRODUT
			aCOLS[Len(aCOLS),3] := POSICIONE("SB1",1,XFILIAL("SB1")+UA3->UA3_PRODUT,"B1_DESC")
			aCOLS[Len(aCOLS),4] := UA3->UA3_VALOR
			aCOLS[Len(aCOLS),5] := UA3->UA3_PERDLI
			aCOLS[Len(aCOLS),6] := UA3->UA3_CODPER
			aCOLS[Len(aCOLS),7] := UA3->UA3_GANHLI
			aCOLS[Len(aCOLS),8] := UA3->UA3_CODGAN
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		UA3->(dbSkip())
	End
endif
Restarea(aArea)
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KIT2LOk   �Autor  �LEANDRO DUARTE      � Data �  08/19/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA DE VALIDA��O DE LINHA DIGITADA                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION KIT2LOk()
Local lRet	:= .t.
if !aCOLS[n,Len(aHeader)+1]
	if empty(acols[n][2])
		MsgStop('Por Favor Preenche o Produto: '+acols[n][1])
		lRet	:= .f.
	endif
	xValor1	:= alltrim(acols[n][2])
	nLin	:= aScan(acols,{|z| alltrim(z[2]) == xValor1 .and. z[1] <> acols[n][1] })
	if nLin > 0 .and. !acols[nLin][Len(aHeader)+1]
		MsgStop('Registro Duplicado no item: '+acols[nLin][1])
		lRet	:= .f.
	endif
endif
RETURN(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KITTOk   �Autor  �leandro duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �executa a analise de verifica��o de duplicidades em todo o  ���
���          �acols                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function KITTOk()
Local nx	:= n
Local lRet	:= .t.
Local ny	:= 0

For ny := 1 to len(aCols)
	n := nY 
	lRet	:= u_KIT2LOk()
next ny

n := nx

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �grvUA3    �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a grava��o dos dados na tabela DEPARA                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function grvUA3(nOpc,aCOLS,aHeader,cTipo)
Local cCodKit	:= UA3->UA3_CODKIT 
Local cCodSku	:= UA3->UA3_SKUID
Local nFor		:= 0
Local lSeek		:= .t.
UA3->(DBSETORDER(1))
Procregua(len(aCOLS))
BeginTran() 
if nOpc == 3 // inclus�o
	for nFor := 1 to len(aCOLS)
		incproc("Efetuando a grava��o")
		Reclock("UA3",.T.)
		UA3->UA3_FILIAL := XFILIAL("UA3")
		UA3->UA3_CODKIT	:= cCod
		UA3->UA3_DESCRI	:= cDesc
		UA3->UA3_SKUID	:= cSkuid
		if !aCOLS[nFor][Len(aHeader)+1]
			UA3->UA3_ITEM	:= aCOLS[nFor][1]
			UA3->UA3_PRODUT	:= aCOLS[nFor][2]
			UA3->UA3_VALOR  := aCOLS[nFor][4]
			UA3->UA3_PERDLI	:= aCOLS[nFor][5]
			UA3->UA3_CODPER	:= aCOLS[nFor][6]
			UA3->UA3_GANHLI	:= aCOLS[nFor][7]
			UA3->UA3_CODGAN	:= aCOLS[nFor][8]
		endif
		Msunlock()
	Next NFor
elseif nOpc == 4 //altera��o
	incproc("Efetuando a altera��o")
	for nFor := 1 to len(aCOLS)
		lSeek	:= !UA3->(DBSEEK(XFILIAL("UA3")+cCodKit+cCodSku+aCOLS[nFor][1]))
		Reclock("UA3",lSeek)
		UA3->UA3_FILIAL := XFILIAL("UA3")
		UA3->UA3_CODKIT	:= cCod
		UA3->UA3_DESCRI	:= cDesc
		UA3->UA3_SKUID	:= cSkuid
		incproc("Efetuando a grava��o")
		if !aCOLS[nFor][Len(aHeader)+1]
			UA3->UA3_ITEM	:= aCOLS[nFor][1]
			UA3->UA3_PRODUT	:= aCOLS[nFor][2]
			UA3->UA3_VALOR  := aCOLS[nFor][4]
			UA3->UA3_PERDLI	:= aCOLS[nFor][5]
			UA3->UA3_CODPER	:= aCOLS[nFor][6]
			UA3->UA3_GANHLI	:= aCOLS[nFor][7]
			UA3->UA3_CODGAN	:= aCOLS[nFor][8]
		endif
		Msunlock()
	next nFor
elseif nOpc == 5 // exclus�o
	incproc("Efetuando a Exclus�o")
	WHILE UA3->(!EOF()) .AND. UA3->UA3_FILIAL+UA3->UA3_CODKIT+UA3->UA3_SKUID == XFILIAL("UA3")+cCodKit+cCodSku
		Reclock("UA3",.F.)
		UA3->(DBDELETE())
		Msunlock()
		UA3->(DBSKIP())
	end
endif
EndTran()
MsUnlockAll()
Return()
