#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPVDS   �Autor  �Leandro Duarte      � Data �  08/29/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para listar os registros com problema referente a    ���
���          �doa��o                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MNDPVDS()
Local cUpdate := " DROP TABLE SB2_"+STOD(DATE())
TCSQLEXEC(cUpdate)
cUpdate := " CREATE TABLE SB2_"+STOD(DATE())+" AS SELECT * FROM "+retsqlname("SB2")
TCSQLEXEC(cUpdate)
cUpdate := " UPDATE "+retsqlname("SB2")+" A SET B2_QNPT = 0, B2_QTER = 0  "
cUpdate += "  WHERE A.B2_QNPT < 0  "
cUpdate += "     OR A.B2_QTER < 0  "
TCSQLEXEC(cUpdate)
AVISO('Aten��o','Processo Finalizado com sucesso!',{'Ok'})
Return()
