#INCLUDE"RWMAKE.CH"
#INCLUDE"TOPCONN.CH"


USER FUNCTION OM010PRC()
LOCAL NRET := SB1->B1_PRV1
IF FUNNAME()=="MATA410"
	NRET := acols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT" })]
	if nret == 0
		nret := 	U_BUSCPRC()
		if nret == 0 .AND. EMPTY(M->C5_TABELA)
			nret := SB1->B1_PRV1
		ENDIF
	ENDIF
ENDIF
RETURN(NRET)

USER FUNCTION A410TAB()
LOCAL NRET := SB1->B1_PRV1
IF FUNNAME()=="MATA410"
	NRET := acols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT" })]
	if nret == 0
		nret := 	U_BUSCPRC()
		if nret == 0 .AND. EMPTY(M->C5_TABELA)
			nret := SB1->B1_PRV1
		ENDIF
	ENDIF
ENDIF
RETURN(NRET)



USER FUNCTION BUSCPRC()
LOCAL CQUERY := ""
LOCAL NRET := acols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT" })]
local cprod := acols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })]
local cqtdven := acols[n,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })]

CQUERY := " SELECT DA1_PRCVEN PRCVEN "
CQUERY += " FROM DA1010  DA1 "
CQUERY += " WHERE "
CQUERY += " DA1.DA1_FILIAL = '"+XFILIAL("DA1")+"' AND "
CQUERY += " DA1.DA1_CODTAB = '"+M->C5_TABELA+"' AND "
CQUERY += " DA1.DA1_CODPRO = '"+SB1->B1_COD+"' AND "
CQUERY += " DA1.DA1_QTDLOT >= "+str(cqtdven)+" AND "
CQUERY += " DA1.DA1_ATIVO = '1' AND  "
CQUERY += " DA1.D_E_L_E_T_ <> '*' "

IF SELECT("TRBA")<>0
	DBSELECTAREA("TRBA")
	TRBA->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS TRBA

DBSELECTAREA("TRBA")
TRBA->(DBGOTOP())

IF VALTYPE(TRBA->PRCVEN)=="N"
	IF TRBA->PRCVEN <> 0
		NRET :=  TRBA->PRCVEN
	ENDIF
	
ENDIF

RETURN(NRET)
