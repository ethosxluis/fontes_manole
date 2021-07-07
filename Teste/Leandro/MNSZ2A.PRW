#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNSZ2A    ºAutor  ³LEANDRO DUARTE      º Data ³  08/20/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA DE AJUSTES DA TABELA SZ2 COM BASE NAS SAIDAS E ENTRADAS±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MNSZ2A()
Processa({|| MNSZ2B()},"Aguarde Processando SZ2","Processando SZ2...")
REturn()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNSZ2A    ºAutor  ³Microsiga           º Data ³  08/20/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function MNSZ2B()
Local cQuery := ""
Local nFor	 := 0
Local bQuery := bQuery	:= {|aX|  Iif(Select("TMP_QUE") > 0, TMP_QUE->(dbCloseArea()),Nil ),dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP_QUE", .F., .T.),dbSelectArea("TMP_QUE"),TMP_QUE->(dbGoTop()),ab:= aX,TMP_QUE->(dbEval({|| aadd(ab,{TMP_QUE->CGC,TMP_QUE->CLIENTE,TMP_QUE->LOJA,TMP_QUE->PRODUTO,TMP_QUE->QUANT,TMP_QUE->TOTAL,TMP_QUE->EVENTO})},,)),TMP_QUE->(dbCloseArea()) }
Local cForne := ""
Local cClien := ""
Local nVolta := 0
Local lNExist1 := .F.
Local lNExist2 := .F.
Private aEntrada := {}
Private aSaida := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query de Saida para listar se esta na SZ2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "    SELECT D.A1_CGC as CGC, B.F2_CLIENTE as CLIENTE, B.F2_LOJA AS LOJA, A.D2_COD AS PRODUTO, SUM(A.D2_QUANT) AS QUANT, SUM(A.D2_TOTAL) AS TOTAL, E.C5_XEVENTO AS EVENTO "+CRLF
cQuery += "      FROM "+RETSQLNAME("SD2")+" A, "+RETSQLNAME("SF2")+" B, "+RETSQLNAME("SF4")+" C, "+RETSQLNAME("SA1")+" D, "+RETSQLNAME("SC5")+" E   "+CRLF
cQuery += "     WHERE A.D2_FILIAL = '"+xFilial("SD2")+"'   "+CRLF
cQuery += "       AND B.F2_FILIAL = '"+xFilial("SF2")+"'   "+CRLF
cQuery += "       AND C.F4_FILIAL = '"+xFilial("SF4")+"'   "+CRLF
cQuery += "       AND D.A1_FILIAL = '"+xFilial("SA1")+"'   "+CRLF
cQuery += "       AND E.C5_FILIAL = '"+xFilial("SC5")+"'   "+CRLF
cQuery += "       AND A.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND B.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND C.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND D.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND E.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND A.D2_DOC = B.F2_DOC   "+CRLF
cQuery += "       AND A.D2_SERIE = B.F2_SERIE   "+CRLF
cQuery += "       AND A.D2_TES = C.F4_CODIGO   "+CRLF
cQuery += "       AND D.A1_COD = B.F2_CLIENTE   "+CRLF
cQuery += "       AND D.A1_LOJA = B.F2_LOJA   "+CRLF
cQuery += "       AND E.C5_NUM = A.D2_PEDIDO   "+CRLF
cQuery += "       AND A.D2_CLIENTE = B.F2_CLIENTE   "+CRLF
cQuery += "       AND E.C5_CLIENTE = B.F2_CLIENTE   "+CRLF
cQuery += "       AND E.C5_LOJACLI = B.F2_LOJA   "+CRLF
cQuery += "       AND A.D2_LOJA = B.F2_LOJA   "+CRLF
cQuery += "       AND C.F4_CODIGO IN ('500','510')   "+CRLF
cQuery += "       AND B.F2_EMISSAO >= '20160701'   "+CRLF
cQuery += "     GROUP BY D.A1_CGC, B.F2_CLIENTE, B.F2_LOJA, A.D2_COD, E.C5_XEVENTO "+CRLF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄ
//³Bloco de Comando para rodar o select e gravar no Array passado por Parametro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄ
EVAL(bQuery,aSaida)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query de entrada para listar se esta na SZ2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
cQuery := "    SELECT D.A1_CGC as CGC, B.F1_FORNECE AS CLIENTE, B.F1_LOJA AS LOJA, A.D1_COD AS PRODUTO, SUM(A.D1_QUANT) AS QUANT, SUM(A.D1_TOTAL) AS TOTAL, ' ' AS EVENTO  "+CRLF
cQuery += "      FROM "+RETSQLNAME("SD1")+" A, "+RETSQLNAME("SF1")+" B, "+RETSQLNAME("SF4")+" C, "+RETSQLNAME("SA1")+" D   "+CRLF
cQuery += "     WHERE A.D1_FILIAL = '"+xFilial("SD2")+"'   "+CRLF
cQuery += "       AND B.F1_FILIAL = '"+xFilial("SF2")+"'   "+CRLF
cQuery += "       AND C.F4_FILIAL = '"+xFilial("SF4")+"'   "+CRLF
cQuery += "       AND D.A1_FILIAL = '"+xFilial("SA1")+"'   "+CRLF
cQuery += "       AND A.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND B.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND C.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND D.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND A.D1_DOC = B.F1_DOC   "+CRLF
cQuery += "       AND A.D1_SERIE = B.F1_SERIE   "+CRLF
cQuery += "       AND A.D1_FORNECE = B.F1_FORNECE   "+CRLF
cQuery += "       AND A.D1_LOJA = B.F1_LOJA   "+CRLF
cQuery += "       AND A.D1_TES = C.F4_CODIGO   "+CRLF
cQuery += "       AND D.A1_COD = B.F1_FORNECE   "+CRLF
cQuery += "       AND D.A1_LOJA = B.F1_LOJA   "+CRLF
cQuery += "       AND B.F1_EMISSAO >= '20160701'   "+CRLF
cQuery += "       AND C.F4_CODIGO IN ('001','370','460','900')   "+CRLF
cQuery += "    GROUP BY D.A1_CGC, B.F1_FORNECE, B.F1_LOJA, A.D1_COD   "+CRLF
*/


cQuery := "    SELECT D.A1_CGC as CGC, B.F1_FORNECE AS CLIENTE, B.F1_LOJA AS LOJA, A.D1_COD AS PRODUTO, SUM(A.D1_QUANT) AS QUANT, SUM(A.D1_TOTAL) AS TOTAL, E.D2_XEVENTO AS EVENTO  "+CRLF
cQuery += "      FROM "+RETSQLNAME("SD1")+" A, "+RETSQLNAME("SF1")+" B, "+RETSQLNAME("SF4")+" C, "+RETSQLNAME("SA1")+" D, "+RETSQLNAME("SD2")+" E   "+CRLF
cQuery += "     WHERE A.D1_FILIAL = '"+xFilial("SD2")+"'   "+CRLF
cQuery += "       AND B.F1_FILIAL = '"+xFilial("SF2")+"'   "+CRLF
cQuery += "       AND C.F4_FILIAL = '"+xFilial("SF4")+"'   "+CRLF
cQuery += "       AND D.A1_FILIAL = '"+xFilial("SA1")+"'   "+CRLF
cQuery += "       AND E.D2_FILIAL = '"+xFilial("SD2")+"'   "+CRLF
cQuery += "       AND A.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND B.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND C.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND D.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND E.D_E_L_E_T_ = ' '   "+CRLF
cQuery += "       AND A.D1_DOC = B.F1_DOC   "+CRLF
cQuery += "       AND A.D1_SERIE = B.F1_SERIE   "+CRLF
cQuery += "       AND A.D1_FORNECE = B.F1_FORNECE   "+CRLF
cQuery += "       AND A.D1_LOJA = B.F1_LOJA   "+CRLF
cQuery += "       AND A.D1_TES = C.F4_CODIGO   "+CRLF
cQuery += "       AND D.A1_COD = B.F1_FORNECE   "+CRLF
cQuery += "       AND D.A1_LOJA = B.F1_LOJA   "+CRLF
cQuery += "       AND B.F1_DTDIGIT >= '20160701'   "+CRLF
cQuery += "       AND C.F4_CODIGO IN ('001','370','460','900')   "+CRLF
cQuery += "       AND E.D2_DOC = A.D1_NFORI "+CRLF
cQuery += "       AND E.D2_SERIE = A.D1_SERIORI "+CRLF
cQuery += "       AND E.D2_CLIENTE = A.D1_FORNECE "+CRLF
cQuery += "       AND E.D2_LOJA = A.D1_LOJA "+CRLF
cQuery += "       AND E.D2_COD = A.D1_COD "+CRLF
cQuery += "       AND E.D2_ITEM = A.D1_ITEMORI "+CRLF
cQuery += "     GROUP BY D.A1_CGC, B.F1_FORNECE, B.F1_LOJA, A.D1_COD, E.D2_XEVENTO   "+CRLF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄ
//³Bloco de Comando para rodar o select e gravar no Array passado por Parametro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄ
EVAL(bQuery,aEntrada)
Procregua(len(aEntrada)+Len(aSaida))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo de transaction para caso tenha queda de conexãou ou por alguma eventualidade o sistema não processo somente a saida ou somente a entrada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginTran()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄ
//³Processo de Loop para correr toda a entrada se não existir grava na tabela SZ2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄ
SZ2->(DbSetOrder(1))
SA2->(DbSetOrder(3)) // POR CGC
SA1->(DbSetOrder(3)) // POR CGC
For nFor := 1 to len(aSaida)
	nVolta := nFor
	IncProc("Processando de "+cValtoChar(nVolta)+" até "+cValtoChar(len(aEntrada)+Len(aSaida)))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Regra para Saber se existe o cliente na saida como fornecedor na entrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if SA2->(Dbseek(xFilial("SA2")+aSaida[nFor][1]))
		cForne := SA2->(A2_COD+A2_LOJA)
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa se existe o Registro de Saida ja informado na tabela SZ2      ³
	//³Caso ja exista analise se as regras de Evento é a mesma para atualizar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if SZ2->(DbSeek(xFilial("SZ2")+aSaida[nFor][2]+aSaida[nFor][3]+aSaida[nFor][4]+aSaida[nFor][7]))
		lNExist1 := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso não encontre como Cliente Busque no registro como Fornecedor³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	elseif SZ2->(DbSeek(xFilial("SZ2")+cForne+aSaida[nFor][4]+aSaida[nFor][7]))
		lNExist2 := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso não encontre como nenhuma informação Grava o Novo Registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	endif
	if !lNExist1 .and. !lNExist2
		RECLOCK("SZ2",.T.)
		SZ2->Z2_FILIAL  := xFilial("SZ2")
		SZ2->Z2_CLIENTE := aSaida[nFor][2]
		SZ2->Z2_LOJA    := aSaida[nFor][3]
		SZ2->Z2_PRODUTO := aSaida[nFor][4]
		SZ2->Z2_EVENTO  := aSaida[nFor][7]
		SZ2->Z2_QTDCON  := aSaida[nFor][5]
		SZ2->Z2_DEVSIMB := 0
		SZ2->Z2_DEVFIS  := 0
		SZ2->Z2_FATCON  := 0
		MSUNLOCK()
	else
		RECLOCK("SZ2",.F.)
		SZ2->Z2_QTDCON  += aSaida[nFor][5]
		MSUNLOCK()
	endif
	lNExist1 := .F.
	lNExist2 := .F.
Next nFor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop para rodar a Entradas das notas para dimunuir os valores da Tabela SZ2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nFor := 1 to len(aEntrada)
	nVolta++
	IncProc("Processando de "+cValtoChar(nVolta)+" até "+cValtoChar(len(aEntrada)+Len(aSaida)))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Regra para Saber se existe o cliente na saida como fornecedor na entrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if SA1->(Dbseek(xFilial("SA1")+aEntrada[nFor][1]))
		cClien := SA1->(A1_COD+A1_LOJA)
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa se existe o Registro de Saida ja informado na tabela SZ2      ³
	//³Caso ja exista analise se as regras de Evento é a mesma para atualizar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	// if SZ2->(DbSeek(xFilial("SZ2")+aEntrada[nFor][2]+aEntrada[nFor][3]+aEntrada[nFor][4]))
	if SZ2->(DbSeek(xFilial("SZ2")+aEntrada[nFor][2]+aEntrada[nFor][3]+aEntrada[nFor][4]+aEntrada[nFor][7] ))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Regra para saber se pode descontar a quantidade total em um só registro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		// 	FONTANELLI
		RECLOCK("SZ2",.F.)
		SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
		MSUNLOCK()

		/*
		IF (SZ2->Z2_QTDCON-aEntrada[nFor][5]) >= 0
			RECLOCK("SZ2",.F.)
			SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
			MSUNLOCK()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8¿
		//³Caso Contrario descontar em Varios Registros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8Ù
		ELSE
			while SZ2->(!EOF()) .and.  xFilial("SZ2")+aEntrada[nFor][2]+aEntrada[nFor][3]+aEntrada[nFor][4] == SZ2->(Z2_FILIAL+Z2_CLIENTE+Z2_LOJA+Z2_PRODUTO) .AND. aEntrada[nFor][5] > 0
				IF (SZ2->Z2_QTDCON-aEntrada[nFor][5]) >= 0
					RECLOCK("SZ2",.F.)
					SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
					MSUNLOCK()
				ELSE
					aEntrada[nFor][5] -= SZ2->Z2_QTDCON
					RECLOCK("SZ2",.F.)
					SZ2->Z2_QTDCON  := 0
					MSUNLOCK()
				ENDIF
				SZ2->(DBSKIP())
			END
		ENDIF
		*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso não encontre como Fornecedor Busque no registro como Cliente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	elseif SZ2->(DbSeek(xFilial("SZ2")+cClien+aEntrada[nFor][4]))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Regra para saber se pode descontar a quantidade total em um só registro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		// 	FONTANELLI
		RECLOCK("SZ2",.F.)
		SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
		MSUNLOCK()

		/*
		IF (SZ2->Z2_QTDCON-aEntrada[nFor][5]) >= 0
			RECLOCK("SZ2",.F.)
			SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
			MSUNLOCK()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8¿
		//³Caso Contrario descontar em Varios Registros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8Ù
		ELSE
			while SZ2->(!EOF()) .and.  xFilial("SZ2")+cClien+aEntrada[nFor][4] == SZ2->(Z2_FILIAL+Z2_CLIENTE+Z2_LOJA+Z2_PRODUTO) .AND. aEntrada[nFor][5] > 0
				IF (SZ2->Z2_QTDCON-aEntrada[nFor][5]) >= 0
					RECLOCK("SZ2",.F.)
					SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
					MSUNLOCK()
				ELSE
					aEntrada[nFor][5] -= SZ2->Z2_QTDCON
					RECLOCK("SZ2",.F.)
					SZ2->Z2_QTDCON  := 0
					MSUNLOCK()
				ENDIF
				SZ2->(DBSKIP())
			END
		ENDIF
		*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso não encontre como nenhuma informação Grava o Novo Registro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		RECLOCK("SZ2",.T.)
		SZ2->Z2_FILIAL  := xFilial("SZ2")
		SZ2->Z2_CLIENTE := iif(empty(cClien),aEntrada[nFor][2],substr(cClien,1,6))
		SZ2->Z2_LOJA    := iif(empty(cClien),aEntrada[nFor][3],substr(cClien,7,2))
		SZ2->Z2_PRODUTO := aEntrada[nFor][4]
		SZ2->Z2_EVENTO  := aEntrada[nFor][7]
		SZ2->Z2_QTDCON  := aEntrada[nFor][5]*(-1)
		SZ2->Z2_DEVSIMB := 0
		SZ2->Z2_DEVFIS  := 0
		SZ2->Z2_FATCON  := 0
		MSUNLOCK()
	endif
	cClien := ""
Next nFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desarma a transação caso seja concluida a rotina sem problemas de quedas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndTran()

AVISO("Termino","O processo Foi Concluido com sucesso"+CRLF+"Pro Favor verifique o Mapa!!",{"OK"})
RETURN()
