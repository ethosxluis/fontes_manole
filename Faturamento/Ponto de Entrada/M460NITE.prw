#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460NITE  �Autor  �Microsiga           � Data �  02/22/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para cria��o da variavel piblica para devo���
���          �ver o valor do frete para daca pedido de vendas             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460NITE()
Local nRet := a460NumIt("A")
Public aM460Num		:= {}
Return(nRet)