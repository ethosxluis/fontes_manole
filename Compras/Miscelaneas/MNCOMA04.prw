#include 'protheus.ch'
#include 'parmtype.ch'

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} MNCOMA04
Rotina utilizada para atualizar status do pedido de compras, quando o mesmo for aprovado. 

@author    Cláudio Macedo
@version   1.0
@since     20/02/2018
/*/
//------------------------------------------------------------------------------------------

User Function MNCOMA04(cAlias,nReg,nOpc)

Local cPedido  := SC7->C7_NUM

If MsgYesNo("Confirma a atualizacao de status para Concluido ? ")

	SC7->(DbSeek(xFilial("SC7") + cPedido))
	While !(Eof()) .AND. SC7->C7_NUM == cPedido
		SC7->(RecLock("SC7",.F.))		
		SC7->C7_XSTATUS := 'CONCLUIDO'		
		SC7->(MsUnLock())
		SC7->(DbSkip())
	Enddo
Endif 

Return