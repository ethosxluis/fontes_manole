#include "Protheus.ch"

user function tstlele()
Local cQuery := ""

cQuery := "  SELECT R_E_C_N_O_ AS REC  "
cQuery += "    FROM SC6010 A  "
cQuery += "   WHERE A.C6_FILIAL = '01'  "
cQuery += "     AND A.D_E_L_E_T_ = ' '  "
cQuery += "     AND A.C6_VTEX <> ' '  "
cQuery += "     AND A.C6_NUM IN  ('V00412','V0045J','V003XK','V003XG','V003XA','V003R1','V003VW','V003V9','V003V7','V003V4','V003V6','V003V3','V003V8','V003X8','V003WV')  "
IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
TRBU->(DBGOTOP())
WHILE TRBU->(!EOF())
	SC6->(DBGOTO(TRBU->REC))
	cQuery := " SELECT COUNT(*) AS QTD "
	cQuery += "   FROM "+retsqlname("SC9")+" A  "
	cQuery += "  WHERE A.C9_PEDIDO = '"+SC6->C6_NUM+"'  "
	cQuery += "    AND A.C9_PRODUTO = '"+SC6->C6_PRODUTO+"'  "
	cQuery += "    AND A.D_E_L_E_T_ = ' '  "
	cQuery += "    AND A.C9_FILIAL = '"+xFilial("SC9")+"' "
	IiF(SELECT("GETSC9")>0,GETSC9->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC9", .T., .T.)
	IF GETSC9->QTD <= 0
		MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,,,.T.,.T.,.T.,.F.)
		// FONTANELLI
        RecLock("SC9",.F.)
        SC9->C9_XTIPO := Posicione("SB1",1, xFIlial("SB1")+SC6->C6_PRODUTO , "B1_XTIPO")
        MsUnLock()
        // FIM
	ENDIF
	TRBU->(DBSKIP())
END
return()