

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100DEL   �Autor  �TOTVS               � Data �  10/11/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada utilizado para validar o estorno das notas ���
���          �de devolucao que j� possuem faturamento amarrado.           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A100DEL()
Local aArea  := GetArea()
Local cChave := SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
Local lRet   := .T.

If SF1->F1_TIPO == 'B'
	DbSelectArea("SZ1")
	DbSetOrder(1)
	If DbSeek(xFilial("SZ1")+cChave)
		While !Eof().And. cChave == SZ1->Z1_CLIENTE+SZ1->Z1_LOJA+SZ1->Z1_DOC+SZ1->Z1_SERIE
			// COLOQUEI A INFORMA��O DO POSICIONE PARA QUE O MESMO LISTE NA BASE DE DADOS SE O PEDIDO JA EXISTE NA TABELA SC5! BY LEANDRO DUARTE 08/03/2017
			If !Empty(SZ1->Z1_PEDIDO) .AND. POSICIONE("SC5",1,XFILIAL("SC5")+SZ1->Z1_PEDIDO,"C5_NUM")== SZ1->Z1_PEDIDO
				Aviso(OemToAnsi('A100DEL'), 'Este documento nao pode ser exclu�do, pois j� existe pedido de faturamento de consignacao '+;
				' amarrado ao mesmo. ' , {'Ok'})
				lRet := .F.
				Exit
			EndIf
			SZ1->(DbSkip())
		EndDo
	EndIf
EndIf

RestArea(aArea)
Return(lRet)
