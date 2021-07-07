#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUCONTR  �Autor  �Leandro Duarte      � Data �  06/21/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para conferir se pode alterar o produto, codigo do   ���
���          �contrato ou o autor no cadastro do contrato                 ���
�������������������������������������������������������������������������͹��
���Uso       � P12 e P11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			Help('',1,'Altera��o Invalida','AltContrato','N�o � possivel alterar o contrato no campo:'+cCpo+', pois o mesmo existe pagamento futuro calculado!',3,1)
		ENDIF
	endif	
endif
Return(lRet)
