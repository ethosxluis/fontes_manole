#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RICUSER1  � Autor � Edmar Mendes Prado �Data �  30/08/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorno para o campo especifico SF2.F2_XUSER               ���
���          � Inicializador Browse U_RICUSER1()                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Manole                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Para documentos de Entrada

User Function RICUSER1()                       

Local cNomUsr1 := ''

cNomUsr1	:=	USRFULLNAME(SUBSTR(EMBARALHA(SF1->F1_USERLGI,1),3,6)) //Embaralha(SF1->F1_USERLGI,1)

Return(cNomUsr1)




///Para documentos de Sa�da
User Function RICUSER2()
                         
Local cNomUsr2 := ''

cNomUsr2	:=	USRFULLNAME(SUBSTR(EMBARALHA(SF2->F2_USERLGI,1),3,6)) //Embaralha(SF1->F1_USERLGI,1)

Return(cNomUsr2)