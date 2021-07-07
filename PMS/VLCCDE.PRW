#include 'protheus.ch'





USER FUNCTION VLCCDE()


		lRet := .T.
		cCc  := alltrim(M->DE_CC)


cquery :=  " SELECT AF9_PROJET,AF9_CCUSTO "
cquery +=  " FROM " +RetSqlName("AF9")
cquery +=  " WHERE D_E_L_E_T_ <> '*' "
cquery +=  " AND AF9_CCUSTO <> '' "
cquery +=  " AND AF9_CCUSTO = '"+cCc+"'"
cquery +=  " AND AF9_FILIAL + AF9_PROJET IN(SELECT AF8_FILIAL + AF8_PROJET FROM AF8990 WHERE D_E_L_E_T_ <> '*' AND AF8_ENCPRJ <> '1') "

 cQuery := ChangeQuery(cQuery)
   	
   		
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
if eof("TRB")
	lRet := .F.
	msgstop("CC inválido, por favor, escolha um centro de custo de um projeto em andamento  ")
endif


return(lRet) 
	