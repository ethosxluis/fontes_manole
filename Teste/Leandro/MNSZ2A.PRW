#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNSZ2A    �Autor  �LEANDRO DUARTE      � Data �  08/20/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA DE AJUSTES DA TABELA SZ2 COM BASE NAS SAIDAS E ENTRADAS�
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MNSZ2A()
Processa({|| MNSZ2B()},"Aguarde Processando SZ2","Processando SZ2...")
REturn()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNSZ2A    �Autor  �Microsiga           � Data �  08/20/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�����������������������������������������Ŀ
//�Query de Saida para listar se esta na SZ2�
//�������������������������������������������
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
//�����������������������������������������������������������������������������x�
//�Bloco de Comando para rodar o select e gravar no Array passado por Parametro�
//�����������������������������������������������������������������������������x�
EVAL(bQuery,aSaida)

//�������������������������������������������Ŀ
//�Query de entrada para listar se esta na SZ2�
//���������������������������������������������
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


//�����������������������������������������������������������������������������x�
//�Bloco de Comando para rodar o select e gravar no Array passado por Parametro�
//�����������������������������������������������������������������������������x�
EVAL(bQuery,aEntrada)
Procregua(len(aEntrada)+Len(aSaida))
//�������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
//�Processo de transaction para caso tenha queda de conex�ou ou por alguma eventualidade o sistema n�o processo somente a saida ou somente a entrada�
//���������������������������������������������������������������������������������������������������������������������������������������������������
BeginTran()

//������������������������������������������������������������������������������x�
//�Processo de Loop para correr toda a entrada se n�o existir grava na tabela SZ2�
//������������������������������������������������������������������������������x�
SZ2->(DbSetOrder(1))
SA2->(DbSetOrder(3)) // POR CGC
SA1->(DbSetOrder(3)) // POR CGC
For nFor := 1 to len(aSaida)
	nVolta := nFor
	IncProc("Processando de "+cValtoChar(nVolta)+" at� "+cValtoChar(len(aEntrada)+Len(aSaida)))
	//������������������������������������������������������������������������Ŀ
	//�Regra para Saber se existe o cliente na saida como fornecedor na entrada�
	//��������������������������������������������������������������������������
	if SA2->(Dbseek(xFilial("SA2")+aSaida[nFor][1]))
		cForne := SA2->(A2_COD+A2_LOJA)
	endif

	//����������������������������������������������������������������������Ŀ
	//�Analisa se existe o Registro de Saida ja informado na tabela SZ2      �
	//�Caso ja exista analise se as regras de Evento � a mesma para atualizar�
	//������������������������������������������������������������������������
	if SZ2->(DbSeek(xFilial("SZ2")+aSaida[nFor][2]+aSaida[nFor][3]+aSaida[nFor][4]+aSaida[nFor][7]))
		lNExist1 := .T.
	//�����������������������������������������������������������������Ŀ
	//�Caso n�o encontre como Cliente Busque no registro como Fornecedor�
	//�������������������������������������������������������������������
	elseif SZ2->(DbSeek(xFilial("SZ2")+cForne+aSaida[nFor][4]+aSaida[nFor][7]))
		lNExist2 := .T.
	//���������������������������������������������������������������Ŀ
	//�Caso n�o encontre como nenhuma informa��o Grava o Novo Registro�
	//�����������������������������������������������������������������
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

//���������������������������������������������������������������������������Ŀ
//�Loop para rodar a Entradas das notas para dimunuir os valores da Tabela SZ2�
//�����������������������������������������������������������������������������
For nFor := 1 to len(aEntrada)
	nVolta++
	IncProc("Processando de "+cValtoChar(nVolta)+" at� "+cValtoChar(len(aEntrada)+Len(aSaida)))
	//������������������������������������������������������������������������Ŀ
	//�Regra para Saber se existe o cliente na saida como fornecedor na entrada�
	//��������������������������������������������������������������������������
	if SA1->(Dbseek(xFilial("SA1")+aEntrada[nFor][1]))
		cClien := SA1->(A1_COD+A1_LOJA)
	endif

	//����������������������������������������������������������������������Ŀ
	//�Analisa se existe o Registro de Saida ja informado na tabela SZ2      �
	//�Caso ja exista analise se as regras de Evento � a mesma para atualizar�
	//������������������������������������������������������������������������


	// if SZ2->(DbSeek(xFilial("SZ2")+aEntrada[nFor][2]+aEntrada[nFor][3]+aEntrada[nFor][4]))
	if SZ2->(DbSeek(xFilial("SZ2")+aEntrada[nFor][2]+aEntrada[nFor][3]+aEntrada[nFor][4]+aEntrada[nFor][7] ))

		//�����������������������������������������������������������������������Ŀ
		//�Regra para saber se pode descontar a quantidade total em um s� registro�
		//�������������������������������������������������������������������������

		// 	FONTANELLI
		RECLOCK("SZ2",.F.)
		SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
		MSUNLOCK()

		/*
		IF (SZ2->Z2_QTDCON-aEntrada[nFor][5]) >= 0
			RECLOCK("SZ2",.F.)
			SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
			MSUNLOCK()
		//���������������������������������������������8�
		//�Caso Contrario descontar em Varios Registros�
		//���������������������������������������������8�
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
		//�����������������������������������������������������������������Ŀ
		//�Caso n�o encontre como Fornecedor Busque no registro como Cliente�
		//�������������������������������������������������������������������
	elseif SZ2->(DbSeek(xFilial("SZ2")+cClien+aEntrada[nFor][4]))
		//�����������������������������������������������������������������������Ŀ
		//�Regra para saber se pode descontar a quantidade total em um s� registro�
		//�������������������������������������������������������������������������

		// 	FONTANELLI
		RECLOCK("SZ2",.F.)
		SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
		MSUNLOCK()

		/*
		IF (SZ2->Z2_QTDCON-aEntrada[nFor][5]) >= 0
			RECLOCK("SZ2",.F.)
			SZ2->Z2_QTDCON  -= aEntrada[nFor][5]
			MSUNLOCK()
		//���������������������������������������������8�
		//�Caso Contrario descontar em Varios Registros�
		//���������������������������������������������8�
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
		//���������������������������������������������������������������Ŀ
		//�Caso n�o encontre como nenhuma informa��o Grava o Novo Registro�
		//�����������������������������������������������������������������
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
//������������������������������������������������������������������������Ŀ
//�Desarma a transa��o caso seja concluida a rotina sem problemas de quedas�
//��������������������������������������������������������������������������
EndTran()

AVISO("Termino","O processo Foi Concluido com sucesso"+CRLF+"Pro Favor verifique o Mapa!!",{"OK"})
RETURN()
