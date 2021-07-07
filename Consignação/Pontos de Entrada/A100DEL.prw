

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A100DEL   ºAutor  ³TOTVS               º Data ³  10/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada utilizado para validar o estorno das notas º±±
±±º          ³de devolucao que já possuem faturamento amarrado.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			// COLOQUEI A INFORMAÇÃO DO POSICIONE PARA QUE O MESMO LISTE NA BASE DE DADOS SE O PEDIDO JA EXISTE NA TABELA SC5! BY LEANDRO DUARTE 08/03/2017
			If !Empty(SZ1->Z1_PEDIDO) .AND. POSICIONE("SC5",1,XFILIAL("SC5")+SZ1->Z1_PEDIDO,"C5_NUM")== SZ1->Z1_PEDIDO
				Aviso(OemToAnsi('A100DEL'), 'Este documento nao pode ser excluído, pois já existe pedido de faturamento de consignacao '+;
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
