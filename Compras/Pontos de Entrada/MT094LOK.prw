#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097LOK  �Autor  �Edmar Mendes do Prado � Data � 03/05/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o pedido de Compras foi liberado anteriormente ���
���          � para ASSINATURAS					                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MT094LOK() 

Local aAreaSC7 := SC7->(GetArea())
Local lRetorno := .T. 

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+SCR->CR_NUM,.T.)

If !(Alltrim(SC7->C7_XSTATUS)) == '' .And. !(Alltrim(SC7->C7_XSTATUS)) == 'CONCLUIDO'

	MsgAlert('Pedido N�O conclu�do com as assinaturas no DocuSign !')
	lRetorno := .F.
	
EndIf


Return(  lRetorno )