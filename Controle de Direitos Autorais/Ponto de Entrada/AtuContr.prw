#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUCONTR  บAutor  ณLeandro Duarte      บ Data ณ  06/21/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para conferir se pode alterar o produto, codigo do   บฑฑ
ฑฑบ          ณcontrato ou o autor no cadastro do contrato                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P12 e P11                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AtuContr(cCpo)
Local xValorAnt := ""
Local xValorDep := ""
Local lRet		:= .T.
Local cQuery	:= ""
Local lAnaCopia	:= iif(type("lCopia")<> "U",.F.,.T.)

if altera .and. lAnaCopia
	xValorAnt := &('AH1->'+cCpo)
	xValorDep := &('M->'+cCpo)
	if  xValorAnt <> xValorDep
		cQuery	:= " SELECT COUNT(*) as QTD "
		cQuery	+= "   FROM "+retsqlname("AH4")+" A "
		cQuery	+= "  WHERE A.AH4_DTPRES >= TO_CHAR(SYSDATE,'YYYYMMDD')  "
		cQuery	+= "    AND A.D_E_L_E_T_ = ' ' "
		cQuery	+= "    AND A.AH4_PRODUT = '"+AH1->AH1_PRODUT+"' "
		cQuery	+= "    AND A.AH4_FORNEC = '"+AH1->AH1_FORNEC+"' "
		cQuery	+= "    AND A.AH4_LOJAFO = '"+AH1->AH1_LOJAFO+"' " 
		IIF(SELECT("AH1TRB")>0,AH1TRB->(DBCLOSEAREA()),NIL)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"AH1TRB",.F.,.T.)
		IF AH1TRB->QTD > 0
			lRet := .f.
			Help('',1,'Altera็ใo Invalida','AltContrato','Nใo ้ possivel alterar o contrato no campo:'+cCpo+', pois o mesmo existe pagamento futuro calculado!',3,1)
		ENDIF
	endif	
endif
Return(lRet)
