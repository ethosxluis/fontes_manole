#include 'protheus.ch'
#include 'parmtype.ch'


USER FUNCTION LP650039()

    _ret := 0



    _cust := Posicione('SB1',1,xFilial('SB1') + SC7->C7_XISBN,'B1_CUSTEI')

    if _cust == 'S'
       _ret := SD1->D1_TOTAL
    endif


RETURN(_ret)

 
