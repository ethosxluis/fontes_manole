#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA060QRY  �Autor  �Leandro Duarte      � Data �  04/20/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para filtrar os titulos da Vtex no CNAB              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function FA060QRY()
Local cRet		:= " E1_NOSSVTX = ' ' and E1_NATUREZ <> '21000'"
return(cRet)