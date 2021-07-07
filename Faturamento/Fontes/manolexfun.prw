#include "Protheus.ch"
user function TotPed(cPed)
Local aArea := SC5->(GETAREA())
Local cQuery := "SELECT SUM(B.C6_VALOR) AS TOTPD FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B WHERE A.C5_NUM = B.C6_NUM AND A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND A.C5_NUM = '"+cPed+"' "
Private nTotPed	:= 0

Iif(Select("TMPLOG") > 0,TMPLOG->(dbCloseArea()),nil)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPLOG", .F., .T.)
if TMPLOG->(!eof())
	nTotPed	:= TMPLOG->TOTPD
endif
RestArea(aArea)
Return(nTotPed)