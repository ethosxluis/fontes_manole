#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} QIEIMPRL

Ponto de Entrada utilizando integração com QIE. Após inclusão do Documento de Entrada.

/*/
//-------------------------------------------------------------------
User Function QIEIMPRL()

	Local aArea    := GetArea()
	Local aAreaSF1 := SF1->(GetArea())
	Local aAreaSD1 := SD1->(GetArea())
	Local CodEvent := ''
	Local cChave   := xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	//ApMsgInfo("QIEIMPRL")

	//If SF1->F1_TIPO == 'B' // Retorno de Consignacao o tipo é beneficiamento.
	If SF1->F1_TIPO == 'B' .OR. NFDEVFATC()// Retorno de Consignacao o tipo é beneficiamento.

		DbSelectArea("SD1")
		DbSetOrder(1)
		If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

			While SD1->(!Eof()) .And. xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChave
				///
				Distribui()
				///
				SD1->(DbSkip())
			EndDo

		EndIf
	EndIf

Return


///-------------------------------------------------------------------------------------------
/// Função para executar o endereçamento automática de estoque de produtos localizados
/// no armazém 10.
///-------------------------------------------------------------------------------------------
Static Function Distribui()
///-------------------------------------------------------------------------------------------
	Local aAreaDst	:= GETAREA()
	Local cProd 	:= SD1->D1_COD
	Local cLocal	:= SD1->D1_LOCAL
	Local cNumSeq 	:= SD1->D1_NUMSEQ
	Local cDoc 	:= SD1->D1_DOC
	Local cSerie 	:= SD1->D1_SERIE
	Local cForne 	:= SD1->D1_FORNECE
	Local cLoja 	:= SD1->D1_LOJA
	Local cEnd		:= "TESTE          "

///	If LOCALIZA(cProd) .and. cLocal == "10" // SK - 02/06/15 - INCLUIR O ALMOXARIFADO 9
	If LOCALIZA(cProd) .and. ( cLocal == "10" .OR.  cLocal == "9 " ) // SK - 02/06/15 - INCLUIR O ALMOXARIFADO 9
		If !Empty(cProd) .and. !Empty(cNumSeq) .and. !Empty(cDoc) .and. !Empty(cForne)
			dbSelectArea("SDA")
			dbSetOrder(1)
			If dbSeek(xFilial("SDA")+cProd+cLocal+cNumSeq+cDoc+cSerie+cForne+cLoja)
				/// Função padrão de endereçamento automático.
				If a100Distri(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_NUMSEQ,SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,cEnd,Nil,SDA->DA_SALDO,SDA->DA_LOTECTL,SDA->DA_NUMLOTE)
					//APMSGINFO("A100DISTRI")
				Else
					ApMsgInfo("Ocorreu falha no endereçamento automático do produto " + Alltrim(SDA->DA_PRODUTO) + " !" )
				EndIf
				///
			EndIf
			RestArea(aAreaDst)
		EndIf
	EndIf

Return

//-------------------------------------------------------------------
//Verifica se a nota é uma devolução de faturamento de consignação
//-------------------------------------------------------------------
Static Function NFDEVFATC()

Local aArea		:= GetArea()
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())
Local lRet		:= .F.


DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

	While SD1->(!Eof()) .AND. xFilial("SD1") == xFilial("SF1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA
		If SF1->F1_TIPO == 'D' .AND. ALLTRIM(SD1->D1_XOPER) == "CS" .AND. !EMPTY(SD1->D1_NFORI) .AND. !EMPTY(SD1->D1_SERIORI) .AND. !EMPTY(SD1->D1_ITEMORI)
			lRet := .T.
			Exit
		EndIf
		SD1->(DbSkip())
	EndDo
EndIf

RestArea(aAreaSD1)
RestArea(aAreaSF1)
RestArea(aArea)

Return lRet