#include "Protheus.ch"

//--------------------------------------------------------------------------------
// Fun��o criada para Verifica se existe nova Edi��o para Publica��o.
// Essa rotina e chamada por um gatilho, no item do pedido, ap�s ter sido o ISBN.
// Ele retorna uma mensagem informando o usuario sobre a nova Edi��o.
//--------------------------------------------------------------------------------
User Function VLD_EDIC()
Local _xRet

//-----------------------------------
// Obtem o conte�do do campo atual.
//-----------------------------------
_xRET := &(READVAR())
                                  
//----------------------------------------------------------------------
// Verifica se existe nova Edi��o para Publica��o
//----------------------------------------------------------------------  
DbSelectArea("SB1")
DbSetOrder(1)
If dbSeek(xFilial("SB1")+_xRET)
	If !EMPTY(B1_XCDPRED)
		MSGINFO("Existe uma Edi��o mais nova desta Publica��o, com o ISBN: " + B1_XCDPRED)
	EndIf
EndIf 
                  
Return(_xRet)                   