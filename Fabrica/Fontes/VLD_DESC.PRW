#include "Protheus.ch"

//----------------------------------------------------------------------------
// Fun��o criada para for�ar a atualizar��o do c�lculo do desconto do pedido.
// Essa rotina e chamad por alguns gatilhos, tanto no cabe�alho quanto no item
// do pedido, ap�s ter sido informafo um novo valor.
//----------------------------------------------------------------------------
User Function VLD_DESC()
Local _xRet
Local _lVldCab   := SubStr(ReadVar(),1,5) == "M->C5"

//-----------------------------------
// Obtem o conte�do do campo atual.
//-----------------------------------
_xRET := &(READVAR())

//----------------------------------------------------------------------
// Verifica se o gatilho est� sendo executado pelo cabe�alho do pedido.
//----------------------------------------------------------------------

If _lVldCab
	A410RECALC()
Else
	_nPosDesc	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_DESCONT"})
	_nDesc 		:= aCols[n][_nPosDesc]
	A410MultT("C6_DESCONT",_nDesc,.F.)
EndIf

Return(_xRet)

