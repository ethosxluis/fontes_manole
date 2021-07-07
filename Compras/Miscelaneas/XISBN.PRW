User Function XISBN()

	Local cDesc := ""

    //-> Posiciona na tabela SB1 e retorna o conteudo do campo B1_DESC.
	cDesc := POSICIONE("SB1", 1, xFilial("SB1") + SC7->C7_XISBN, "B1_DESC")

Return