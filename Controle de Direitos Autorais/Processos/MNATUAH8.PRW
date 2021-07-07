#INCLUDE "PROTHEUS.CH"

USER FUNCTION MNATUAH8()
PRIVATE cQuery := ""
MsgRun("Carregando as Tabelas de Produtos no Master","Produtos",{||  rodarun()  })
RETURN()

Static Function rodarun()
Local lSeek := .T.
cQuery := " SELECT B.B1_COD, B.B1_DESC "
cQuery += "   FROM "+retsqlname("SB1")+" B "
cQuery += "  WHERE B.B1_COD NOT IN (SELECT A.AH8_CODPRO "
cQuery += "                           FROM "+retsqlname("AH8")+" A "
cQuery += "                          WHERE A.AH8_FILIAL = '"+xFilial("AH1")+"' "
cQuery += "                            AND A.D_E_L_E_T_ = ' ') "
cQuery += "    AND B.D_E_L_E_T_ = ' ' "
cQuery += "    AND B.B1_XTIPO = '1' "
IIF(SELECT("AH8TRB")>0,AH8TRB->(DBCLOSEAREA()),NIL)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"AH8TRB",.F.,.T.)

AH8->(dbsetorder(1))

WHILE AH8TRB->(!EOF())
	lSeek := !(AH8->(DBSEEK(XFILIAL("AH8")+AH8TRB->B1_COD )))
	reclock("AH8",lSeek)
	AH8->AH8_FILIAL := xFilial("AH8")
	AH8->AH8_PRODUT	:= AH8TRB->B1_COD
	AH8->AH8_DESCMA	:= AH8TRB->B1_DESC
	AH8->AH8_CODPRO	:= AH8TRB->B1_COD
	AH8->AH8_QTDACU	:= 0
	AH8->AH8_QTDINI	:= 0
	MSUNLOCK()
	AH8TRB->(DBSKIP())
END


RETURN()