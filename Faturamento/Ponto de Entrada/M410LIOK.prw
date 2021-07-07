#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410LIOK  บAutor  ณTOTVS               บ Data ณ 22/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na validacao do pedido de remessa de       บฑฑ
ฑฑบ          ณproduto em consignacao.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// SONIA - 17/03/14 - C5_XTPCON = "R", aceitar poder terceiro = "R"        //
//                  - C5_XTPCON <> "R", aceitar poder terceiro <> "R"      //
// SONIA - 02/04/14 - C5_XTPCON == "N", nao aceitar poder de terceiro      //
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M410LIOK()
Local aArea   := GetArea()
Local aAreaSB2:= SB2->(GetArea())
local lRet    := .T.

Local nPosNfOriC  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XNFORCO"})
Local nPosSerOriC := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XSERCON"})
Local nPosItOric  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XITCON" })

Local nPosQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
Local nPosPreco   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN" })
Local nPosTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"  })
Local nPosTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"  })   // SONIA - 17/03/14

Local cProduto := GdFieldGet("C6_PRODUTO",n)

Local nQuant   := GdFieldGet("C6_QTDVEN",n)
Local nPreco   := GdFieldGet("C6_PRCVEN",n)
Local nTotal   := GdFieldGet("C6_TOTAL",n)

Local cNotaOri := GdFieldGet("C6_XNFORCO",n)
Local cSerOri  := GdFieldGet("C6_XSERCON",n)
Local cItemOri := GdFieldGet("C6_XITCON" ,n)
Local nQuantPv := GdFieldGet("C6_QTDVEN" ,n)


Local cNotaDev := GdFieldGet("C6_XDOCDEV",n)
Local cSerDev  := GdFieldGet("C6_XSERDEV",n)
Local cItemDev := GdFieldGet("C6_XITDEV" ,n)

Local nQuantCon:= 0
Local nEstoque := 0
Local lValida := GetMv("MV_XVLDSLD",,.T.)// Criar Parametro de validacao de qtd zerada ou esgotada.
Local cTESRC1 := GetMv("MN_TES_RC1")			// N๚mero da TES utilizada para Remessa em Consigna็ใo referente ao sistema antigo

Local cAlmoxRet := GetMv("MV_XALMOXC")
Local cAlmox    := GdFieldGet("C6_LOCAL" ,n)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณC5_XTPCON = R -> Remessa          ณ
//ณC5_XTPCON = D -> Devolucao        ณ
//ณC5_XTPCON = V -> Venda Consignacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aCols[n][Len(aCols[n])]//Linha Deletada nao faz validacao
	Return (lRet)
EndIf
/*
N-> Pedidos Normais.
D-> Pedidos para Devolu็ใo de Compras.
(Excl. Brasil)
C-> Compl. Pre็os.(Excl. Brasil)
P-> Compl. de IPI. (Excl. Brasil)
I-> Compl. de ICMS. (Excl. Brasil)
B-> Apres. Fornec. qdo material p/Ben
*/


SF4->(DBSETORDER(1))  // SONIA - 17/03/14
SF4->(DBSEEK(XFILIAL("SF4") + aCols[n,nPosTES]) ) // SONIA - 17/03/14 - POSICIONA NO CADASTRO DA TES

IF !M->C5_TIPO $ "I|C|P"
	If M->C5_XTPCON == 'R'.And.Inclui

		lRet := U_VFATX002(M->C5_CLIENTE,M->C5_LOJACLI)

		//If  SF4->F4_ESTOQUE # 'S' .Or. SF4->F4_PODER3 # 'R'
		If  !(SF4->F4_CODIGO $ cTESRC1) .AND. (SF4->F4_ESTOQUE # 'S' .Or. SF4->F4_PODER3 # 'R')
			Aviso(OemToAnsi('M410LIOK'), 'Para Pedidos de Remessa Consignacao a TES deve controlar Estoque e Poder Terceiros', {'Ok'})
			lRet := .F.
		EndIf
		If !(SF4->F4_CODIGO $ cTESRC1) .AND. (lValida .And. lRet)// Para validar o nivel de estoque dos produtos.
			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+GdFieldGet("C6_PRODUTO",n)+SB1->B1_LOCPAD)
				nEstoque := SaldoSb2()//SaldoSB2(.F.,.F.,,.F.,.F.,,0,0,.T.,)PARA ABATER A RESERVA.
				If nEstoque < SB1->B1_XESGOT
					Aviso(OemToAnsi('M410LIOK'), 'Produto Esgotado por isso nใo pode ser consignado', {'Ok'})
					lRet := .F.
				ElseIf nEstoque < SB1->B1_XZERADO .And. lRet
					Aviso(OemToAnsi('M410LIOK'), 'Produto Zerado por isso nใo pode ser consignado', {'Ok'})
					lRet := .F.
				EndIf
			EndIf
		EndIf
	ElseIf M->C5_XTPCON == 'F' // Faturamento de Consignacao.

		If (Empty(aCols[n,nPosNfOriC]).Or.Empty(aCols[n,nPosItOric]))
			Aviso(OemToAnsi('M410LIOK'), ;
			'Para Pedidos de Venda de Consignacao, deve ser preenchido o campo de Nota Original de Consignacao.', {'Ok'})
			lRet := .F.
		EndIf

		If !Empty(aCols[n,nPosNfOriC]).And.!Empty(aCols[n,nPosSerOriC]).And.!Empty(aCols[n,nPosItOric])
			//Posicione("SZ1",2,xFilial("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI+ cNotaOri+ cSerOri+cProduto +cItemOri,"Z1_QUANT")
			DbSelectArea("SZ1")
			DbSetOrder(1)
			If DbSeek(xFilial("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI+ cNotaDev+ cSerDev+cProduto +cItemDev)
				nQuantCon := SZ1->Z1_QUANT
				If nQuantPv <> nQuantCon
					Aviso(OemToAnsi('M410LIOK'), 'A quantidade digitada ้ diferente que o saldo a faturar desta Nota Fiscal.'+;
					" o saldo a faturar ้ de " +Alltrim(Str(nQuantCon))+" unidades.", {'Ok'})
					lRet := .F.
				Endif
			EndIf
		EndIf

		If SF4->F4_PODER3 == 'R'
			Aviso(OemToAnsi('M410LIOK'), ;
			'Para Pedidos de Venda de Consignacao,a Tes nใo deve controlar Poder de terceiros.', {'Ok'})
			lRet := .F.
		Endif

		//VALIDAR ALMOXARIFADO DO FATURAMENTO SIMBOLICO.
		If cAlmox # cAlmoxRet
			Aviso(OemToAnsi('M410LIOK'), ;
			'Para Pedidos de Venda de Consignacao,o almoxarifado deve ser o mesmo do retorno simbolico ' +cAlmoxRet, {'Ok'})
			lRet := .F.
		EndIf

		If GdFieldGet("C6_XEVENTO",n) # M->C5_XEVENTO
			Aviso(OemToAnsi('M410LIOK'), ;
			'Todos os eventos dos itens devem ser igual ao do cabe็alho do pedido ' , {'Ok'})
			lRet := .F.
		EndIf
	EndIf
ELSE
	ACOLS[N,nPosTotal] := ACOLS[N,nPosPreco]
	LRET := .T.
ENDIF

IF M->C5_XTPCON == 'N' .AND. SF4->F4_PODER3 <> "N" // SONIA - 02/04/14 - SE O TIPO FOR N, A TES UTILIZADA NAO PODE TER CONTROLE DE PODER DE TERCEIROS
	Aviso(OemToAnsi('M410LIOK'), ;
	'Para o Tp Consigna็ใo = "N", a TES nao pode ter controle de poder de terceiros ' , {'Ok'})
	lRet := .F.
ENDIF


// -----------------------------------------------------
// INICIO FONTANELLI INICIO VALIDA LIMITE DE CONSIGNAวรO
// -----------------------------------------------------
lConsignacao := .F.
nPosDel := Len(aHeader) + 1
For nI := 1 to Len(aCols)
     If !aCols[nI,nPosDel] // Linha nao Deletada
		DbSelectArea("SF4")
		SF4->(DbSetOrder(1))
		if SF4->(DbSeek(xFilial("SF4")+gdFieldGet("C6_TES",nI)))
		   if ALLTRIM(SF4->F4_CF) $ '5917/6917'
			   lConsignacao := .T.
		   endif
		endif
	 endif
Next

if lRet .and. lConsignacao

	nLimite := 0
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	if SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
		nLimite := SA1->A1_LCONSIG
	endif

	nConsignado := 0
	cQuery := "SELECT NVL(SUM(VLR),0) VALOR"
	cQuery += "  FROM ("
	cQuery += "       SELECT B6_SALDO*B6_PRUNIT VLR FROM "+RetSQLName("SB6")+" SB6, "+RetSQLName("SF4")+" SF4"
	cQuery += "        WHERE B6_FILIAL = '"+xFILIAL("SB6")+"'"
	cQuery += "          AND B6_EMISSAO > '20131231'"
	cQuery += "          AND B6_CLIFOR = '"+M->C5_CLIENTE+"'"
	cQuery += "          AND B6_LOJA = '"+M->C5_LOJACLI+"'"
	cQuery += "          AND B6_SALDO > 0"
	cQuery += "          AND B6_ESTOQUE = 'S'"
	cQuery += "          AND B6_PODER3 = 'R'"
	cQuery += "          AND SB6.D_E_L_E_T_ = ' '"
	cQuery += "          AND F4_FILIAL = '"+xFILIAL("SF4")+"'"
	cQuery += "          AND F4_CODIGO = B6_TES "
	cQuery += "          AND F4_CF IN ('5917','6917') "
	cQuery += "          AND SF4.D_E_L_E_T_ = ' '"
	cQuery += "       ) TMP"
	TcQuery cQuery Alias TSB6 New
	TSB6->(dbGoTop())
	nConsignado := TSB6->VALOR
	TSB6->(dbCloseArea())

	nConsignar := 0
	nPosDel := Len(aHeader) + 1
	For nI := 1 to Len(aCols)
	     If !aCols[nI,nPosDel] // Linha nao Deletada
			DbSelectArea("SF4")
			SF4->(DbSetOrder(1))
			if SF4->(DbSeek(xFilial("SF4")+gdFieldGet("C6_TES",nI)))
			   if ALLTRIM(SF4->F4_CF) $ '5917/6917'
				   nConsignar += gdFieldGet("C6_QTDVEN",nI) * gdFieldGet("C6_PRCVEN",nI)
			   endif
			endif
		 endif
	Next

	nSaldo := nLimite - (nConsignado + nConsignar)

	cQuery := "SELECT NVL(MAX(SC6A.C6_DATFAT),' ') DATFAT FROM "+RetSQLName("SC6")+" SC6A"
	cQuery += " WHERE SC6A.C6_FILIAL = '"+xFILIAL("SC6")+"'"
	cQuery += "   AND SC6A.C6_CLI = '"+M->C5_CLIENTE+"'"
	cQuery += "   AND SC6A.C6_LOJA = '"+M->C5_LOJACLI+"'"
	cQuery += "   AND SC6A.C6_CF IN ('5113','6113')"
	cQuery += "   AND SC6A.D_E_L_E_T_ = ' '"
	TcQuery cQuery Alias TSC6 New
	TSC6->(dbGoTop())
	cDataFat := TSC6->DATFAT
	TSC6->(dbCloseArea())

	cQuery := "SELECT NVL(MAX(C6_NOTA),' ') NOTA FROM "+RetSQLName("SC6")+" SC6B"
	cQuery += " WHERE SC6B.C6_FILIAL = '"+xFILIAL("SC6")+"'"
	cQuery += "   AND SC6B.C6_CLI = '"+M->C5_CLIENTE+"'"
	cQuery += "   AND SC6B.C6_LOJA = '"+M->C5_LOJACLI+"'"
	cQuery += "   AND SC6B.C6_CF IN ('5113','6113')"
	cQuery += "   AND SC6B.C6_DATFAT = '"+cDataFat+"'"
	cQuery += "   AND SC6B.D_E_L_E_T_ = ' '"
	TcQuery cQuery Alias TSC6 New
	TSC6->(dbGoTop())
	cNota := TSC6->NOTA
	TSC6->(dbCloseArea())

	cQuery := "SELECT NVL(SUM(VLR),0) VALOR"
	cQuery += "  FROM ("
	cQuery += "        SELECT C6_QTDVEN*C6_PRCVEN VLR FROM "+RetSQLName("SC6")+" SC6C"
	cQuery += "         WHERE SC6C.C6_FILIAL = '"+xFILIAL("SC6")+"'"
	cQuery += "           AND SC6C.C6_CLI = '"+M->C5_CLIENTE+"'"
	cQuery += "           AND SC6C.C6_LOJA = '"+M->C5_LOJACLI+"'"
	cQuery += "           AND SC6C.C6_CF IN ('5113','6113')"
	cQuery += "           AND SC6C.C6_DATFAT = '"+cDataFat+"'"
	cQuery += "           AND SC6C.C6_NOTA = '"+cNota+"'"
	cQuery += "           AND SC6C.D_E_L_E_T_ = ' '"
	cQuery += "      ) TMP"
	TcQuery cQuery Alias TSC6 New
	TSC6->(dbGoTop())
	nValor := TSC6->VALOR
	TSC6->(dbCloseArea())

	if nSaldo < 0
	   	if MsgInfo(;
	   			+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " EXCEDIDO Limite de Consigna็ใo         ";
				+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " Limite: "+ AllTrim(TRANSFORM(nLimite,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ " Consignado: "+ AllTrim(TRANSFORM(nConsignado,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ " a Consiginar: "+ AllTrim(TRANSFORM(nConsignar,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ " Saldo Restante: "+ AllTrim(TRANSFORM(nSaldo,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " Ultimo Acerto                          ";
				+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " Data: "+ AllTrim(DTOC(STOD(cDataFat))) ;
				+Chr(13)+SPACE(5)+ " Nota: "+ AllTrim(cNota) ;
				+Chr(13)+SPACE(5)+ " Valor: "+ AllTrim(TRANSFORM(nValor,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ "----------------------------------------";
	   			+chr(13)+SPACE(5)+ "Desbloqueio Depto Financeiro            ";
				+Chr(13)+SPACE(5)+ "----------------------------------------";
	   			,"ATENวรO" )
		endif
	elseif n == 1
	   	if MsgInfo(;
	   			+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " AVISO - Limite de Consigna็ใo          ";
				+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " Limite: "+ AllTrim(TRANSFORM(nLimite,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ " Consignado: "+ AllTrim(TRANSFORM(nConsignado,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ " a Consiginar: "+ AllTrim(TRANSFORM(nConsignar,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ " Saldo Restante: "+ AllTrim(TRANSFORM(nSaldo,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " Ultimo Acerto                          ";
				+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " Data: "+ AllTrim(DTOC(STOD(cDataFat))) ;
				+Chr(13)+SPACE(5)+ " Nota: "+ AllTrim(cNota) ;
				+Chr(13)+SPACE(5)+ " Valor: "+ AllTrim(TRANSFORM(nValor,"@E 99,999,999.99")) ;
				+Chr(13)+SPACE(5)+ "----------------------------------------";
	   			+chr(13)+SPACE(5)+ "Desbloqueio Depto Financeiro            ";
				+Chr(13)+SPACE(5)+ "----------------------------------------";
	   			,"ATENวรO" )
		endif
	endif
endif
// --------------------------------------------------
// FIM FONTANELLI INICIO VALIDA LIMITE DE CONSIGNAวรO
// --------------------------------------------------


RestArea(aAreaSB2)
RestArea(aArea)
Return(lRet)
