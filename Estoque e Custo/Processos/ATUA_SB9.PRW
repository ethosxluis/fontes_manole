#include "Protheus.ch"
//#define CRLF CHR(13)+CHR(10)

User Function ATUA_SB9()

DbSelectArea("SB2")
DbSetOrder(1)
SB1->(DBGOTOP())

DbSelectArea("SB9")
SB0->(DBGOTOP())

//rotina de deleção. Passada pelo Anderson/Totvs
While  !SB9->(eof())
	Reclock("SB9",.F.)
	DBDelete()
	Msunlock()
	SB9->(DBSkip())
End

While  !SB2->(eof())
	
	Reclock("SB9",.T.)
	SB9->B9_FILIAL  := SB2->B2_FILIAL
	SB9->B9_COD     := SB2->B2_COD
	SB9->B9_LOCAL    := SB2->B2_LOCAL
	SB9->B9_DATA    := CTOD("30/11/12")   
	SB9->B9_QINI    := SB2->B2_QATU
	_VINI1          := POSICIONE("SB1",1,xFILIAL("SB1")+SB2->B2_COD,"SB1->B1_CUSTD")
	//SB9->B9_VINI1   := _VINI1 * 0.25 * SB2->B2_QATU
	SB9->B9_VINI1   := _VINI1 * SB2->B2_QATU

	Msunlock()
	SB2->(DbSkip())
	
end
return
