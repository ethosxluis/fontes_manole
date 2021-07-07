#include 'protheus.ch'
#include 'parmtype.ch'

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} MNCOMA01
Rotina utilizada para liberar um pedido de compras, quando o mesmo for um contrato de 
prestação de serviços. 

@author    Cláudio Macedo
@version   1.0
@since     20/02/2018
/*/
//------------------------------------------------------------------------------------------

User Function MNCOMA01(cAlias,nReg,nOpc)

Local aArea    := GetArea()
Local cPedido  := Alltrim(SC7->C7_NUM)

If MsgYesNo("Confirma a liberação do pedido de compra ?")

	dbSelectArea('SC7')
	SC7->( dbSetOrder(1) )
	SC7->(DbSeek(xFilial("SC7") + cPedido))
	
	While !(Eof()) .AND. SC7->C7_NUM == cPedido
		SC7->(RecLock("SC7",.F.))		
			SC7->C7_XSTATUS := 'LIBERADO'		
		SC7->(MsUnLock())
		SC7->(DbSkip())
	Enddo
Endif 

RestArea(aArea)
Return

/*
Local aArea    := GetArea()
Local aCpos1   := {}	// Campos editáveis
Local aCpos2   := {}
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}
Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lFreeze   := .F.
Local nGetLin  := 0
Local nOpcA    := 0
Local nI  := 0
Local nColFreeze:= 1
Local cArqQry  := "SC7"
Local cCadastro:= OemToAnsi("Liberaçäo de Contrato") 
Local oGetdLocal
Local oDlgLocal 
Local bCond     := {|| .T. }
Local bAction1  := {|| .T. }	
Local bAction2  := {|| .T. }
Local cSeek     := ""
Local aNoFields := {}		// Campos que nao devem entrar no aHeader e aCols
Local bWhile    := {|| }
Local cQuery    := ""        
Local bCancel   := {||oDlg:End()} 
Local bOk		:= {||Confirmar()}
Local aButtons  := {}
Local aAcho  	:= {'NOUSER','C7_NUM', 'C7_EMISSAO','C7_FORNECE','C7_COND'}*/

PRIVATE aTELA[0][0],aGETS[0]
PRIVATE cPedido  := SC7->C7_NUM
PRIVATE aHeader	 := {}
PRIVATE aCols	 := {}
PRIVATE aHeadFor := {}
PRIVATE aColsFor := {}
PRIVATE N        := 1

Inclui := .F.
Altera := .F.					// Inicializa a Variaveis da Enchoice.                  
RegToMemory( "SC7", .F., .F. )	// Filtros para montagem do aCols                       

dbSelectArea("SC7")
dbSetOrder(1)
#IFDEF TOP	
	lQuery  := .T.	
	cQuery := "SELECT * "	
	cQuery += "FROM "+RetSqlName("SC7")+" SC7 "	
	cQuery += "WHERE SC7.C7_FILIAL='"+xFilial("SC7")+"' AND "	
	cQuery += "SC7.C7_NUM='"+cPedido+"' AND "	
	cQuery += "SC7.D_E_L_E_T_<>'*' "	
	cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey()))	
	dbSelectArea("SC7")	
	dbCloseArea()
#ENDIF
cSeek  := xFilial("SC7")+cPedido
bWhile := {|| C7_FILIAL+cPedido }// Montagem do aHeader e aCols                           
FillGetDados(5,"SC7",1,cSeek,bWhile,{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,/*bafterCols*/,/*bBeforeCols*/,/*bAfterHeader*/,"SC7")"

If lQuery	
	dbSelectArea("SC7")	
	dbCloseArea()	
	ChkFile("SC7",.F.)
EndIf
For nI := 1 To Len(aHeader)	
	If aHeader[nI][8] == "M"		
		aadd(aCpos1,aHeader[nI][2])	
	EndIf
Next // Caso nao ache nenhum item , abandona rotina.         

If ( Len(aCols) == 0 )	
	ApMsgAlert("Não achou os itens do pedido")	
	lContinua := .F.
EndIf

If ( lContinua )	// Faz o calculo automatico de dimensoes de objetos     	
	aSize := MsAdvSize()	
	aObjects := {}	
	AAdd( aObjects, { 100, 100, .t., .t. } )	
	AAdd( aObjects, { 100, 100, .t., .t. } )	
	AAdd( aObjects, { 100, 020, .t., .f. } )	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }	
	aPosObj := MsObjSize( aInfo, aObjects )	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )	
		
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL	// Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      	
	
	EnChoice( cAlias, nReg, nOpc, , , ,aAcho, aPosObj[1],aCpos2,3)	
	oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,,,,,,,lFreeze)		
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bOk, bCancel, ,aButtons) 
EndIf
	
Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} Confirmar()
Rotina utilizada para mudar a fase do pedido de venda para "2" (Aguardando análise da Gerência). 

@author    Cláudio Macedo
@version   1.0
@since     08/02/2018
/*/
//------------------------------------------------------------------------------------------

Static Function Confirmar()


	dbSelectArea('SC7')
	SC7->( dbSetOrder(1) )
	SC7->(DbSeek(xFilial("SC7") + cPedido))

	While !(Eof()) .AND. SC7->C7_NUM == cPedido
	SC7->(RecLock("SC7",.F.))		
	SC7->C7_XSTATUS := 'LIBERADO'		
	SC7->(MsUnLock())
	SC7->(DbSkip())
Enddo

oDlg:End()

Return
