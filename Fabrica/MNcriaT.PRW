#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNCRIAT   �Autor  �Leandro Duarte      � Data �  05/15/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para criar os indices daa tabelas na versao 12       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function MNcriaT()
Local cQuery := "SELECT A.TABLE_NAME AS TTB FROM ALL_TABLES A WHERE A.OWNER = 'UDBP12'   AND A.TABLE_NAME LIKE '%010'   AND LENGTH(TRIM(A.TABLE_NAME)) = 6"
IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
TRBU->(DBGOTOP())
WHILE TRBU->(!EOF())
	CHKFILE(TRBU->TTB)	
	TRBU->(DBSKIP())
END
Return()