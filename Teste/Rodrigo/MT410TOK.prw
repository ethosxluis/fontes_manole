#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT410TOK  ºAutor  ³TOTVS               º Data ³ 13/10/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no TUDOOK do pedido de vendas para validar º±±
±±º          ³a inclusao e exclusao de pedido de consignacao.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT410TOK()

Local aArea  := GetArea()
Local nOpcao := PARAMIXB[1]
Local nPosNfOriC  := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XNFORCO"})
Local nPosSerOriC := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XSERCON"})
Local nPosItOric  := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XITCON" })
Local nPosProd    := aScan(aHeader,{|x| AllTrim(x[2])== "C6_PRODUTO" })
Local nPosQuant   := aScan(aHeader,{|x| AllTrim(x[2])== "C6_QTDVEN" })

Local nPosNfDev   := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XDOCDEV"})
Local nPosSerDev  := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XSERDEV"})
Local nPosItDev   := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XITDEV" })

Local lRet  := .T.

DbSelectArea("SZ1")
DbSetOrder(1)

If nOpcao == 3// Inclusao
	For nY := 1 To Len(aCols)
		If DbSeek(xFilial("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nY,nPosNfDev]+aCols[nY,nPosSerDev]+aCols[nY,nPosProd]+aCols[nY,nPosItDev])
			RecLock("SZ1",.F.)
			//SZ1->Z1_SLDFAT -= aCols[nY,nPosQuant]
			SZ1->Z1_PEDIDO := M->C5_NUM
			MsUnlock()
		EndIf
	Next nY
ElseIf nOpcao == 1// 1 Exclusao; 4 Alteracao
	For nY := 1 To Len(aCols)
		If DbSeek(xFilial("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nY,nPosNfDev]+aCols[nY,nPosSerDev]+aCols[nY,nPosProd]+aCols[nY,nPosItDev])
			RecLock("SZ1",.F.)
			//SZ1->Z1_SLDFAT += aCols[nY,nPosQuant]
			SZ1->Z1_PEDIDO := ''
			MsUnlock()
		EndIf
	Next nY
EndIf

// -----------------------------------------------------
// INICIO FONTANELLI INICIO VALIDA LIMITE DE CONSIGNAÇÃO
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
		lRet:= .F.
	   	if MsgInfo(;
	   			+Chr(13)+SPACE(5)+ "----------------------------------------";
				+Chr(13)+SPACE(5)+ " EXCEDIDO Limite de Consignação         ";
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
	   			,"ATENÇÃO" )
  	   endif
	endif
endif
// --------------------------------------------------
// FIM FONTANELLI INICIO VALIDA LIMITE DE CONSIGNAÇÃO
// --------------------------------------------------

RestArea(aArea)
Return(lRet)