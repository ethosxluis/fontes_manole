#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M440SC9I  ºAutor  ³FONTANELLI          º Data ³  16/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ATUALIZAR CAMPO C9_XTIPO                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11      treteer                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function M440SC9I()

Local _aArea	:= GetArea()
Local _aAreaC9 	:= SC9->(GetArea())
Local _aAreaA1 	:= SA1->(GetArea())
Local _aAreaC5 	:= SC5->(GetArea())
Local _aAreaC6 	:= SC6->(GetArea())
Local lDiverg 	:= .F.
Local cErItNgC	:= "ecommerce@manole.com.br;lazaro@manole.com.br;financeiro.cr@manole.com.br;cobrancas@manole.com.br; wallace.pereira@ethosx.com;"
Local cErItNgL	:= "ecommerce@manole.com.br;lazaro@manole.com.br;wallace.pereira@ethosx.com;"

RecLock("SC9",.F.)
	SC9->C9_XTIPO   := Posicione("SB1",1, xFilial("SB1") + SC9->C9_PRODUTO , "B1_XTIPO")
	SC9->C9_XPESSOA := Posicione("SA1",1, xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA, "A1_PESSOA")
MsUnlock("SC9")

//Edmar Mendes do Prado
//28/06/2018
//Se o item estiver com valor negativo, enviar email

If SC9->C9_PRCVEN < 0
	If SC9->C9_XTIPO == "2"	
		Conout("** Enviando e-mail de Curso " + DtoC(Date()) + " - " + Time() + " **")
		U_EXPMAIL(cErItNgC , "CURSO VTEX COM VALORES NEGATIVOS, ALTERE: " + SC9->C9_PEDIDO, " ALTERE O PEDIDO " + SC9->C9_PEDIDO + " - " + SC9->C9_PRODUTO + " - " + cValToChar(SC9->C9_PRCVEN) + " para ser faturado com os valores corretos. ")
	Else
		Conout("** Enviando e-mail de Livro " + DtoC(Date()) + " - " + Time() + " **")
		U_EXPMAIL(cErItNgC , "LIVRO VTEX COM VALORES NEGATIVOS, ALTERE: " + SC9->C9_PEDIDO, " ALTERE O PEDIDO " + SC9->C9_PEDIDO + " - " + SC9->C9_PRODUTO + " - " + cValToChar(SC9->C9_PRCVEN) + " para ser faturado com os valores corretos. ")
	EndIf
EndIF								


//Edmar Mendes do Prado
//19/02/2019
//Se o item for bloqueado sem estoque, enviar email
/*
If SC9->C9_BLEST == '02'
	Conout("** Enviando e-mail de Livro sem saldo " + DtoC(Date()) + " - " + Time() + " **")
	U_EXPMAIL("wallace.pereira@ethosx.com" , "Produto sem saldo: " + SC9->C9_PRODUTO, " VERIFIQUE O PEDIDO " + SC9->C9_PEDIDO + " , o Produto " + SC9->C9_PRODUTO + " não tem saldo. ")	
EndIf
*/

/*
DbSelectArea("SC6")
SC6->( dbSetOrder(1) )
SC6->( dbSeek( SC5->C5_FILIAL + SC5->C5_NUM, .T.) )
while ! SC6->( EOF() ) .and. SC6->C6_FILIAL == SC5->C5_FILIAL .and. SC6->C6_NUM == SC5->C5_NUM .AND. !SC5->C5_TIPO $ 'C,I,P' 
			
	If SC6->C6_PRCVEN < 0 .OR. SC6->C6_VALOR < 0 .OR. SC6->C6_PRUNIT < 0
		lDiverg := .T.
	EndIf
		
	SC6->( dbSkip() )	
		
End

//Se algum dos itens estiver com o valor negativo, bloqueia o pedido
If lDiverg
	RecLock("SC5", .F.)
		SC5->C5_BLQ := "1"
	MsUnlock()
			
	Conout("** M440SC9I - Enviando e-mail de Pedido Bloqueado " + DtoC(Date()) + " - " + Time() + " **")
	U_EXPMAIL("wallace.pereira@ethosx.com" , "PEDIDO BLOQUEADO POR ITENS COM VALORES NEGATIVOS, CORRIJA: " + SC5->C5_NUM, " Altere os itens do pedido " + SC5->C5_NUM + " conforme a Vtex para ser faturado com os valores corretos. ")
	//U_EXPMAIL("wallace.pereira@ethosx.com" , "PEDIDO BLOQUEADO POR ITENS COM VALORES NEGATIVOS, CORRIJA: " + SC5->C5_NUM, " Altere os itens do pedido " + SC5->C5_NUM + " conforme a Vtex para ser faturado com os valores corretos. ")		
		
EndIf
*/
	

RestArea(_aAreaC9)
RestArea(_aAreaA1)
RestArea(_aAreaC5)
RestArea(_aAreaC6)
RestArea(_aArea)

Return()



