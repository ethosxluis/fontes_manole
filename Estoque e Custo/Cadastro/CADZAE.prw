#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZAE � Autor � FONTANELLI            � Data �  19/12/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Sub-Categoria                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANOLE                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                               

User Function CADZAE()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." 
Local cVldExc := ".T." 

Private cString := "ZAE"

dbSelectArea("ZAE")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Sub-Categoria",cVldExc,cVldAlt)

Return