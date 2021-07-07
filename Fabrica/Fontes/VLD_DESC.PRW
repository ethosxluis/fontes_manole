#include "Protheus.ch"

//----------------------------------------------------------------------------
// Função criada para forçar a atualizarção do cálculo do desconto do pedido.
// Essa rotina e chamad por alguns gatilhos, tanto no cabeçalho quanto no item
// do pedido, após ter sido informafo um novo valor.
//----------------------------------------------------------------------------
User Function VLD_DESC()
Local _xRet
Local _lVldCab   := SubStr(ReadVar(),1,5) == "M->C5"

//-----------------------------------
// Obtem o conteúdo do campo atual.
//-----------------------------------
_xRET := &(READVAR())

//----------------------------------------------------------------------
// Verifica se o gatilho está sendo executado pelo cabeçalho do pedido.
//----------------------------------------------------------------------

If _lVldCab
	A410RECALC()
Else
	_nPosDesc	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_DESCONT"})
	_nDesc 		:= aCols[n][_nPosDesc]
	A410MultT("C6_DESCONT",_nDesc,.F.)
EndIf

Return(_xRet)

