#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUCONS   ºAutor  ³TOTVS               º Data ³ 16/11/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para atualizar os acumuladores de Consignacao da     º±±
±±º          ³tabela SZ2.                                                 º±±
±±º          ³Opcoes:                                                     º±±
±±º          ³CI - Consignacao Inclusao                                   º±±
±±º          ³CE - Consignacao Estorno                                    º±±
±±º          ³DI - Devolucao Inclusao                                     º±±
±±º          ³DE - Devolucao Estorno                                      º±±
±±º          ³SI - Simbolico Inclusao                                     º±±
±±º          ³SE - Simbolico Estorno                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AtuCons(cCliente,cLoja,cProd,cEvento,cOpcao,nQuant)
Local aArea := GetArea()

DbSelectArea("SZ2")
DbSetOrder(1)//Cliente + Loja + Produto + Vendedor + Evento
If !DbSeek(xFilial("SZ2")+cCliente+cLoja+cProd+cEvento)
	RecLock("SZ2",.T.)
	SZ2->Z2_FILIAL  := xFilial("SZ2")
	SZ2->Z2_CLIENTE := cCliente
	SZ2->Z2_LOJA    := cLoja
	SZ2->Z2_PRODUTO := cProd
	SZ2->Z2_EVENTO  := cEvento
	
	If cOpcao == "CI" // Inclusao Remessa Consignacao
		SZ2->Z2_QTDCON += nQuant
	EndIf
	MsUnLock()
	
Else
	RecLock("SZ2",.F.)
	If cOpcao == "CI"
		SZ2->Z2_QTDCON += nQuant
	ElseIf cOpcao == "CE"
		SZ2->Z2_QTDCON -= nQuant
	ElseIf cOpcao == "DI"
		SZ2->Z2_DEVFIS += nQuant
	ElseIf cOpcao == "DE"
		SZ2->Z2_DEVFIS -= nQuant
	ElseIf cOpcao == "SI"
		SZ2->Z2_DEVSIMB += nQuant
	ElseIf cOpcao == "SE"
		SZ2->Z2_DEVSIMB -= nQuant
	ElseIf cOpcao == "FI" //
		SZ2->Z2_FATCON += nQuant
	ElseIf cOpcao == "FE" //
		SZ2->Z2_FATCON -= nQuant
	EndIf
	
	MsUnLock()
	
EndIf

RestArea(aArea)

Return
