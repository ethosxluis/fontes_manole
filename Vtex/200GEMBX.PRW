#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �200GEMBX  �Autor  �Leandro Duarte      � Data �  12/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para colocar o nosso numero antes de efetuar a pesqui���
���          �sa e a baixa do titulo do CNAB via cobran�a sem Registro    ���
�������������������������������������������������������������������������͹��
���Uso       � p12                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user Function 200GEMBX()
Local cQuery 	:= ""
Local aAreaSE1	:= SE1->(GETAREA())
dBaixa 			:= paramixb[1][2]
cTipo 			:= paramixb[1][3]
cNsNum 			:= paramixb[1][4]
nDespes 		:= paramixb[1][5]
nDescont 		:= paramixb[1][6]
nAbatim 		:= paramixb[1][7]
nValRec 		:= paramixb[1][8]
nJuros 			:= paramixb[1][9]
nMulta 			:= paramixb[1][10]
nVaLOutrD 		:= paramixb[1][11]
nValCc 			:= paramixb[1][12]
dDataCred 		:= paramixb[1][13]
cOcorr 			:= paramixb[1][14]
cMotBan 		:= paramixb[1][15]
xBuffer 		:= paramixb[1][16]
dDtVc 			:= paramixb[1][17]
aBuffer 		:= paramixb[1][18]
IF AT(' ',cNsNum)>0
	cNsNum1			:= Right(cNsNum,7)
	cNsNum1			:= Left(cNsNum1,6)
	if !empty(cNsNum1)
		cQuery 	:= " SELECT R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_FILIAL = '"+xFilial("SE1")+"' AND A.D_E_L_E_T_ = ' ' AND A.E1_NOSSVTX = '"+cNsNum1+"' "
		Iif(Select("TMPLOG") > 0,TMPLOG->(dbCloseArea()),nil)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPLOG", .F., .T.)
		IF TMPLOG->(!EOF())
			SE1->(dbgoto(TMPLOG->REC))
			RECLOCK("SE1",.F.)
			SE1->E1_NUMBCO  := STRZERO(VAL(cNsNum),12)
			SE1->E1_IDCNAB	:= STRZERO(VAL(cNsNum),10)
			MSUNLOCK()
			cNumTit 	:= SE1->E1_IDCNAB
		ENDIF
	endif
ENDIF
RestArea(aAreaSE1)
REturn()
