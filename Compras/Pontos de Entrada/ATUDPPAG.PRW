#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUDPPAG  �Autor  �Leandro Duarte      � Data �  07/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para alinhar o campo e2_iss referente a duplicidade  ���
���          �do calculo de iss                                           ���
�������������������������������������������������������������������������͹��
���Uso       � p11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION ATUDPPAG()

if SE2->E2_ISS == (SE2->E2_VRETISS*2)
	SE2->E2_ISS 		:= SE2->E2_VRETISS
	SE2->E2_VALOR		+= SE2->E2_ISS
	SE2->E2_VLCRUZ		+= SE2->E2_ISS
	SE2->E2_SALDO		:= SE2->E2_VALOR
ENDIF

RETURN()