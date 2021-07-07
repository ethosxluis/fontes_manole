#INCLUDE "PROTHEUS.CH"

// Função para importação do pedido de venda.

User Function VFATX001()

Local aArea     := GetArea()
Local lContinua := .T.
Local lFirst    := .T.
Local cMarca    := ""
Local cFiltro   := ""
Local nOpc      := 0
Local nX        := 0
Local lMarca    := .F.
Local aListSZ1  := {}

Local aTamX3  := TamSX3("Z1_QUANT")//Z1_SLDFAT era este antes.
Local aCampos := {"",AllTrim(RetTitle("Z1_PRODUTO")),AllTrim(RetTitle("Z1_DOCORI")),AllTrim(RetTitle("Z1_SERIEOR")),;
AllTrim(RetTitle("Z1_ITEMORI")),AllTrim(RetTitle("Z1_EVENTO")), AllTrim(RetTitle("Z1_DOC")),;
AllTrim(RetTitle("Z1_SERIE")),AllTrim(RetTitle("Z1_ITEME")),"Saldo"  }

// Acrescentar campo de evento de Faturamento.
Local oOk     := LoadBitMap(GetResources(), "LBOK")
Local oNo     := LoadBitMap(GetResources(), "LBNO")

Local ENTERL  := CHR(13)+CHR(10)
Local nPosNfOri
Local nPosSerOri
Local nPosItOri
Local nPosQuant
Local nPosEvent

Local nPosNfDev
Local nPosSerDev
Local nPosItDev

Local cTes
Local cProduto
Local cEvento
Local lContinua := .T.
Local cAliasNew := ""

_xName := Alltrim(Funname())
If _xName $ "U_GRPVFTC6"
	Return(.T.)
EndIf

nPosNfOri := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XNFORCO"})
nPosSerOri:= aScan(aHeader,{|x| AllTrim(x[2])== "C6_XSERCON"})
nPosItOri := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XITCON"})
nPosQuant := aScan(aHeader,{|x| AllTrim(x[2])== "C6_QTDVEN"})
nPosEvent := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XEVENTO"})

nPosNfDev := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XDOCDEV"})
nPosSerDev:= aScan(aHeader,{|x| AllTrim(x[2])== "C6_XSERDEV"})
nPosItDev := aScan(aHeader,{|x| AllTrim(x[2])== "C6_XITDEV"})

cTes      := GdFieldGet("C6_TES",n)
cProduto  := GdFieldGet("C6_PRODUTO",n)
cEvento   := M->C5_XEVENTO

lContinua := Iif(Empty(cTes),.F.,.T.)

If M->C5_XTPCON == "F" .And. Inclui.And. lContinua

	cAliasNew:= GetNextAlias()
	cQuery := "SELECT SZ1.Z1_PRODUTO, SZ1.Z1_DOCORI,SZ1.Z1_SERIEOR,SZ1.Z1_ITEMORI, SZ1.Z1_QUANT AS AFAT, SZ1.Z1_EVENTO, " +ENTERL
	cQuery += " SZ1.Z1_DOC, SZ1.Z1_SERIE,SZ1.Z1_ITEME " +ENTERL
	cQuery += "FROM " +ENTERL
	cQuery += RetSqlName("SZ1") + " SZ1 "+ENTERL
	cQuery += " WHERE SZ1.Z1_FILIAL  = '"+xFilial("SZ1")+"' "+ENTERL
	cQuery += " AND SZ1.Z1_CLIENTE = '"+M->C5_CLIENTE + "' AND SZ1.Z1_LOJA = '"+M->C5_LOJACLI+"' "+ENTERL
	cQuery += " AND SZ1.Z1_PRODUTO = '"+ cProduto + "' "+ ENTERL

	//Allan Bonfim - 05/05/2016
//	cQuery += " AND SZ1.Z1_PEDIDO  = ' ' "+ENTERL
	cQuery += " AND (SZ1.Z1_PEDIDO  = ' ' "+ENTERL
	cQuery += " 	OR EXISTS(SELECT C6_NUM, C6_PRODUTO, C6_NOTA, C6_SERIE, C6_ITEM, C6_XNFORCO, C6_XSERCON, C6_XITCON, D1_DOC, D1_SERIE, D1_ITEM "+ENTERL
	cQuery += " 		FROM "+RetSqlName("SC6") + " SC6 "+ENTERL
	cQuery += " 		INNER JOIN "+RetSqlName("SD1") + " SD1 "+ENTERL
	cQuery += " 		ON (C6_NOTA = D1_NFORI AND C6_SERIE = D1_SERIORI AND C6_ITEM = D1_ITEMORI AND SD1.D_E_L_E_T_ = '') "+ENTERL
	cQuery += " 		WHERE C6_NUM = SZ1.Z1_PEDIDO "+ENTERL
	cQuery += " 		AND SC6.D_E_L_E_T_ = '' "+ENTERL
	cQuery += " 		AND D1_XOPER = 'CS' "+ENTERL
	cQuery += " 		) "+ENTERL
	cQuery += "		) "+ENTERL

	// Filtro por Evento no Faturamento
	cQuery += " AND SZ1.Z1_EVENTO = '"+ cEvento + "' "+ ENTERL
	cQuery += " AND SZ1.Z1_TIPO = 'S' AND SZ1.D_E_L_E_T_ <> '*' "+ENTERL
	cQuery += " ORDER BY SZ1.Z1_DOCORI,SZ1.Z1_SERIEOR "
	//cQuery += " GROUP BY Z1_PRODUTO, Z1_DOCORI,Z1_SERIEOR,Z1_ITEMORI "

	//cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
	MEMOWRITE ("VFATX001.TXT",cQuery)

	(cAliasNew)->(dbGoTop())

	While (cAliasNew)->(!Eof())
		aAdd(aListSZ1,{lMarca,(cAliasNew)->Z1_PRODUTO,(cAliasNew)->Z1_DOCORI,(cAliasNew)->Z1_SERIEOR,;
		(cAliasNew)->Z1_ITEMORI,(cAliasNew)->Z1_EVENTO,(cAliasNew)->Z1_DOC,;
		(cAliasNew)->Z1_SERIE,(cAliasNew)->Z1_ITEME,(cAliasNew)->AFAT} )
		(cAliasNew)->(dbSkip())
	EndDo
	(cAliasNew)->(DbCloseArea())

	If !Empty(aListSZ1)
		aSort(aListSZ1,,,{|x,y| x[2] < y[2]})
		DEFINE MSDIALOG oDlg FROM 60,50 TO 350,950 TITLE "Saldo de Consignacao a Faturar" Of oMainWnd PIXEL //"Selecione o empenho - Item"
		oListBox := TWBrowse():New(05,4,243,86,,aCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aListSZ1)
		oListBox:bLDblClick := {|| aListSZ1[oListBox:nAt,1] := !aListSZ1[oListBox:nAt,1]}
		oListBox:bLine := {|| {If(aListSZ1[oListBox:nAt,1],oOk,oNo),aListSZ1[oListBox:nAT,2],;
		aListSZ1[oListBox:nAT,3],;
		aListSZ1[oListBox:nAT,4],;
		aListSZ1[oListBox:nAT,5],;
		aListSZ1[oListBox:nAT,6],;
		aListSZ1[oListBox:nAT,7],;
		aListSZ1[oListBox:nAT,8],;
		aListSZ1[oListBox:nAT,9],;
		Str(aListSZ1[oListBox:nAT,10],aTamX3[1],aTamX3[2]) }}

		//Str(aListSZ1[oListBox:nAT,10],aTamX3[1],aTamX3[2]) }}

		oListBox:Align := CONTROL_ALIGN_ALLCLIENT
		//ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,oDlg:End())},{||(nOpc := 0,oDlg:End())})
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,ValidLin(aListSZ1))},{||(nOpc := 0,oDlg:End())})

	Else
		Aviso(OemToAnsi('Consignação'), 'Nao ha dados para exibir deste Cliente, Produto e Evento, Por favor verifique os dados da remessa', {'Ok'})
	EndIf

	If nOpc == 1

		For nX := 1 To Len(aListSZ1)
			If aListSZ1[nX,1] == .F.
				Loop
			EndIf
			aCols[n,nPosNfOri] := aListSZ1[nX,3]//Num Nota Fiscal Original
			aCols[n,nPosSerOri]:= aListSZ1[nX,4]//Serie Nota Fiscal Original
			aCols[n,nPosItOri] := aListSZ1[nX,5]//Item Nota Fiscal Original
			aCols[n,nPosEvent] := aListSZ1[nX,6]//Evento
			aCols[n,nPosNfDev] := aListSZ1[nX,7]//Num Nota Fiscal Original
			aCols[n,nPosSerDev]:= aListSZ1[nX,8]//Serie Nota Fiscal Original
			aCols[n,nPosItDev] := aListSZ1[nX,9]//Item Nota Fiscal Original
			aCols[n,nPosQuant] := aListSZ1[nX,10]//Saldo do SZ1
		Next nX
	EndIf

Else
	Aviso(OemToAnsi('Consignação'), 'Este campo só deve ser preenchido para pedidos de Faturamento de Consignação '+;
	"ou a Tes está em branco", {'Ok'})
EndIf
RestArea(aArea)
Return (.T.)


///////////////////////////////////////////////////
//Valida a quantidade Itens marcados pelo Usuario//
///////////////////////////////////////////////////

Static Function ValidLin(aListSZ1)
Local nCount := 0

For nX := 1 To Len(aListSZ1)
	If aListSZ1[nX,1] == .T.
		nCount ++
	EndIf
Next nX

If nCount > 1
	Aviso(OemToAnsi('Consignação'), 'Marque apenas uma linha por vez!', {'Ok'})
Else
	oDlg:End()
EndIf

Return

