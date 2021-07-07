#include "Protheus.ch"

//--------------------------------------------------------------------------------
// Função criada para Verifica se existe nova Edição para Publicação.
// Essa rotina e chamada por um gatilho, no item do pedido, após ter sido o ISBN.
// Ele retorna uma mensagem informando o usuario sobre a nova Edição.
//--------------------------------------------------------------------------------
User Function VLD_EDIC()
Local _xRet

//-----------------------------------
// Obtem o conteúdo do campo atual.
//-----------------------------------
_xRET := &(READVAR())
                                  
//----------------------------------------------------------------------
// Verifica se existe nova Edição para Publicação
//----------------------------------------------------------------------  
DbSelectArea("SB1")
DbSetOrder(1)
If dbSeek(xFilial("SB1")+_xRET)
	If !EMPTY(B1_XCDPRED)
		MSGINFO("Existe uma Edição mais nova desta Publicação, com o ISBN: " + B1_XCDPRED)
	EndIf
EndIf 
                  
Return(_xRet)                   