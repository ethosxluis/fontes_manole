//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} PEDVTEX
Relatório - Rel. Pedidos de Vendas VTEX   
@author CRIAREL
@since 24/04/2020
@version 1.0
	@example
	u_PEDVTEX()
	@obs Função gerada pelo CRIAREL()
/*/
	
User Function PEDVTEX()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := "PEDVTEX"
	
	//Definições da pergunta
//	cPerg := "PEDVTEX   "
	
	//Se a pergunta não existir, zera a variável
//	DbSelectArea("SX1")
//	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
//	If ! SX1->(DbSeek(cPerg))
//		cPerg := Nil
//	EndIf
	
	
AjustaSX1()
Pergunte(cPerg,.F.)


	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"PEDVTEX",;		//Nome do Relatório
								"Rel. Pedidos de Vendas VTEX",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ITEM", "QRY_AUX", "Item", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRC_UNITARIO", "QRY_AUX", "Prc_unitario", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VLR_TOTAL", "QRY_AUX", "Vlr_total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OPERACAO", "QRY_AUX", "Operacao", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TES", "QRY_AUX", "Cod. Atend.", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFOP", "QRY_AUX", "Cfop", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ARMAZEM", "QRY_AUX", "Armazem", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRC_LISTA", "QRY_AUX", "Prc_lista", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA_FISCAL", "QRY_AUX", "Nota_fiscal", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENTREGA", "QRY_AUX", "Entrega", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_VTEX", "QRY_AUX", "Cod_vtex", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT SC6.C6_NUM AS PEDIDO,"		+ STR_PULA
	cQryAux += "SC6.C6_CLI AS CLIENTE,"		+ STR_PULA
	cQryAux += "SC6.C6_LOJA AS LOJA,"		+ STR_PULA
	cQryAux += "SC6.C6_ITEM AS ITEM,"		+ STR_PULA
	cQryAux += "SC6.C6_PRODUTO AS PRODUTO, "		+ STR_PULA
	cQryAux += "SC6.C6_DESCRI AS DESCRICAO,"		+ STR_PULA
	cQryAux += "SC6.C6_QTDVEN AS QUANTIDADE,"		+ STR_PULA
	cQryAux += "SC6.C6_PRCVEN AS PRC_UNITARIO,"		+ STR_PULA
	cQryAux += "SC6.C6_VALOR AS VLR_TOTAL,"		+ STR_PULA
	cQryAux += "SC6.C6_XOPER AS OPERACAO,"		+ STR_PULA
	cQryAux += "SC6.C6_TES AS TES,"		+ STR_PULA
	cQryAux += "SC6.C6_CF AS CFOP, "		+ STR_PULA
	cQryAux += "SC6.C6_LOCAL AS ARMAZEM,"		+ STR_PULA
	cQryAux += "SC6.C6_PRUNIT AS PRC_LISTA,"		+ STR_PULA
	cQryAux += "SC6.C6_NOTA AS NOTA_FISCAL,"		+ STR_PULA
	cQryAux += "SC6.C6_ENTREG AS ENTREGA,"		+ STR_PULA
	cQryAux += "SC6.C6_VTEX AS COD_VTEX,"		+ STR_PULA
	cQryAux += "CASE SB1.B1_XTIPO "		+ STR_PULA
    cQryAux += "WHEN '1' THEN 'LIVRO' "		+ STR_PULA
    cQryAux += "WHEN '2' THEN 'CURSO' "		+ STR_PULA
    cQryAux += "WHEN '3' THEN 'OUTROS' "		+ STR_PULA
    cQryAux += "WHEN '4' THEN 'EBOOK' "		+ STR_PULA
    cQryAux += "ELSE ' ' "		+ STR_PULA
    cQryAux += "END AS TIPO"		+ STR_PULA
	cQryAux += "FROM SC6010 SC6 "		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 SB1"	+ STR_PULA
	cQryAux += "ON SB1.B1_FILIAL = SC6.C6_FILIAL"	+ STR_PULA
	cQryAux += "AND SB1.B1_COD = SC6.C6_PRODUTO"	+ STR_PULA
	cQryAux += "AND SB1.D_E_L_E_T_ <> '*'"	+ STR_PULA
	cQryAux += "WHERE "		+ STR_PULA
	// Filtro Faturado SIM ou NÃO 
If mv_par03 == 1 // SIM
	cQryAux += " SC6.C6_NOTA <> '         ' and "		+ STR_PULA
ElseIf mv_par03 == 2 // NÃO
	cQryAux += " SC6.C6_NOTA = '         '  and "	+ STR_PULA
Elseif mv_par03 == 3 // AMBOS

EndIf 

If mv_par06 == 1	// LIVRO
	cQryAux += " SB1.B1_XTIPO = '1' and "	+ STR_PULA
ElseIf mv_par06 == 2	// CURSO
	cQryAux += " SB1.B1_XTIPO = '2'  and "	+ STR_PULA
Elseif mv_par06 == 3	// OUTROS
	cQryAux += " SB1.B1_XTIPO = '3'  and "	+ STR_PULA
Elseif mv_par06 == 4	// EBOOK
	cQryAux += " SB1.B1_XTIPO = '4'  and "	+ STR_PULA
Elseif mv_par06 == 5	// TODOS
	
EndIf 
	cQryAux += "SC6.D_E_L_E_T_ = ' ' AND "		+ STR_PULA
	cQryAux += "SC6.C6_VTEX <> ' ' and "		+ STR_PULA
	cQryAux += "SC6.C6_ENTREG >= '"+Dtos(MV_PAR01)+"' AND SC6.C6_ENTREG <= '"+Dtos(MV_PAR02)+"' AND  "		+ STR_PULA
	cQryAux += "SC6.C6_NUM >= '"+MV_PAR04+"' AND SC6.C6_NUM <= '"+MV_PAR05+"'  "		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return

/*
-----------------------------------------------------------------------------------------------------
	Funcao     - AjustaSX1
	Autor      - Edmar Mendes do Prado
	Descricao  - Ajuste das Perguntas no SX1
	Data       - 04/07/2018
-----------------------------------------------------------------------------------------------------	
*/
Static Function AjustaSX1(cPerg)
	Local aArea := GetArea()

	PutSx1(cPerg,"01", "Da Dt. Emissao ?"	,"","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01")
	PutSx1(cPerg,"02", "Ate Dt. Entrada ?"	,"","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02")
	PutSx1(cPerg,"03","FATURADO ?"			,"","","mv_ch3","C",01,0,0,"G","","","","","mv_par03","SIM","SIM","SIM","","NÃO","NÃO","NÃO","","","","","","","","","","")
	PutSx1(cPerg,"04", "Pedido de?"			,"","","mv_ch4","C",06,0,0,"G","","","","","MV_PAR04")
	PutSx1(cPerg,"05", "Pedido Ate?"		,"","","mv_ch5","C",06,0,0,"G","","","","","MV_PAR05")
	PutSx1(cPerg,"06", "Tipo Produto?"		,"","","mv_ch6","C",01,0,0,"G","","","","","MV_PAR06")
	//PutSx1(cPerg,"07", "Tipo Pedido?"		,"","","mv_ch7","C",06,0,0,"G","","","","","MV_PAR07")
	RestArea(aArea)
Return Nil
