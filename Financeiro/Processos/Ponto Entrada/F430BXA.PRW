#INCLUDE"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH"



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F650VAR   �Autor  �ANDERSON CIRIACO    � Data �  02/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �TRATAMENTO DE DATA NA RECEP��O DE ARQUIVO PAGFOR - BRADESCO
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION F430BXA()
PUBLIC dBaixa
IF ALLTRIM(DTOS(dBaixa)) == ""
	RECLOCK("SE2",.F.)
	dBaixa := CTOD(SUBSTR(CDATE,7,2)+"/"+SUBSTR(CDATE,5,2)+"/"+SUBSTR(CDATE,1,4))
	SE2->E2_BAIXA := dBaixa
	SE2->(MSUNLOCK())  
	RECLOCK("SE5",.F.)
//	SE5->E5_DATA	:= dBaixa  //ALTERACAO SOLICITADA ANDRESON - 08/02/2013
	SE5->E5_DATA	:= SE2->E2_BAIXA
	SE5->E5_DTDISPO	:= SE2->E2_BAIXA
	SE5->(MSUNLOCK())
ENDIF

RETURN()
