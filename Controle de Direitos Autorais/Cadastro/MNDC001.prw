#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDC001   � Autor �LEANDRO DUARTE      � Data �  15/06/16   ���
�������������������������������������������������������������������������͹��
���Descricao � CADASTRO DE ARQUIVO X CONTRATO X LOCAL DO ARQUIVO          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MNDC001()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "UA7"

dbSelectArea("UA7")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Contrato X Arquivo Word",cVldExc,cVldAlt)

Return
