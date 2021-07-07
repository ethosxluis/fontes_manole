//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} MNRELFAT
Relatório - Relatorio de Faturamento      
@author zReport
@since 19/01/2021
@version 1.0
	@example
	u_MNRELFAT()
	@obs Função gerada pelo zReport()
/*/
	
User Function MNRELFAT()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := "MNRELFAT"
	
		
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
	oReport := TReport():New(	"MNRELFAT",;		//Nome do Relatório
								"Relatorio de Faturamento",;		//Título
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
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 180, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX", "Quantidade", /*Picture*/, 11, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UN_MED", "QRY_AUX", "Un_med", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRECO", "QRY_AUX", "Preco", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL", "QRY_AUX", "Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TES", "QRY_AUX", "Tes", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PIS", "QRY_AUX", "Pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COFINS", "QRY_AUX", "Cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ICMS", "QRY_AUX", "Icms", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ICMS_RET", "QRY_AUX", "Icms_ret", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CSLL", "QRY_AUX", "Csll", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFOP", "QRY_AUX", "Cfop", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SERIE", "QRY_AUX", "Serie", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 210, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ESTADO", "QRY_AUX", "Estado", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MUNICIPIO", "QRY_AUX", "Municipio", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT D2.D2_FILIAL AS FILIAL,"  + STR_PULA
	cQryAux += "D2.D2_COD AS PRODUTO,"		+ STR_PULA
	cQryAux += "B1.B1_DESC AS DESCRICAO,"		+ STR_PULA
	cQryAux += "D2.D2_QUANT AS QUANTIDADE,"		+ STR_PULA
	cQryAux += "D2.D2_UM AS UN_MED,"		+ STR_PULA
	cQryAux += "D2.D2_PRCVEN AS PRECO,"		+ STR_PULA
	cQryAux += "D2.D2_TOTAL AS TOTAL,"		+ STR_PULA
	cQryAux += "D2.D2_VALIMP5 AS PIS,"		+ STR_PULA
	cQryAux += "D2.D2_VALIMP6 AS COFINS,"		+ STR_PULA
	cQryAux += "D2.D2_VALICM AS ICMS,"		+ STR_PULA
	cQryAux += "D2.D2_ICMSRET AS ICMS_RET,"		+ STR_PULA
	cQryAux += "D2.D2_VALCSL AS CSLL,"		+ STR_PULA
	cQryAux += "D2.D2_CF AS CFOP,"		+ STR_PULA
	cQryAux += "D2.D2_DOC AS NOTA,"		+ STR_PULA
	cQryAux += "D2.D2_SERIE AS SERIE,"		+ STR_PULA
	cQryAux += "D2.D2_CLIENTE AS CLIENTE,"		+ STR_PULA
	cQryAux += "D2.D2_LOJA AS LOJA,"		+ STR_PULA
	cQryAux += "A1.A1_NOME AS NOME,"		+ STR_PULA
	cQryAux += "A1.A1_EST AS ESTADO,"		+ STR_PULA
	cQryAux += "A1.A1_MUN AS MUNICIPIO,"		+ STR_PULA
	cQryAux += "D2.D2_TES AS TES,"		+ STR_PULA
	cQryAux += " CASE WHEN LENGTH(D2.D2_EMISSAO)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(D2.D2_EMISSAO,7,2) || '/' || SUBSTR(D2.D2_EMISSAO,5,2) || '/' || SUBSTR(D2.D2_EMISSAO,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(D2.D2_EMISSAO)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(D2.D2_EMISSAO,1,2) || '/' || SUBSTR(D2.D2_EMISSAO,4,2) || '/' || SUBSTR(D2.D2_EMISSAO,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "EMISSAO"		+ STR_PULA
	cQryAux += "FROM SD2010 D2"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 B1"	+ STR_PULA
	cQryAux += "ON B1.B1_FILIAL = D2.D2_FILIAL"	+ STR_PULA
	cQryAux += "AND B1.B1_COD = D2.D2_COD"	+ STR_PULA
	cQryAux += "AND B1.D_E_L_E_T_ <> '*'"	+ STR_PULA
	cQryAux += "INNER JOIN SF4010 F4"	+ STR_PULA
	cQryAux += "ON F4.F4_FILIAL = D2.D2_FILIAL"	+ STR_PULA
	cQryAux += "AND F4.F4_CODIGO = D2.D2_TES"	+ STR_PULA
	cQryAux += "AND F4.D_E_L_E_T_ <> '*'"	+ STR_PULA
	cQryAux += "INNER JOIN SA1010 A1"	+ STR_PULA
	cQryAux += "ON A1.A1_COD = D2.D2_CLIENTE"	+ STR_PULA
	cQryAux += "AND D2.D2_LOJA = A1.A1_LOJA"		+ STR_PULA
	cQryAux += "AND A1.D_E_L_E_T_ <> '*'"	+ STR_PULA
	cQryAux += "WHERE 
	If mv_par11 == 1 // SIM
		cQryAux += "   F4.F4_DUPLIC = 'S' "		+ STR_PULA
	ElseIf mv_par11 == 2 // NÃO
		cQryAux += "   F4.F4_DUPLIC = 'N'  "	+ STR_PULA
	Elseif mv_par11 == 3 // AMBOS
		cQryAux += "F4_DUPLIC  IN ('S','N') "		+ STR_PULA
	EndIf	
	cQryAux += "AND D2.D2_FILIAL >= '"+MV_PAR01+"' AND D2_FILIAL <= '"+MV_PAR02+"'  "		+ STR_PULA
	cQryAux += "AND D2.D2_EMISSAO >= '"+Dtos(MV_PAR03)+"' AND D2.D2_EMISSAO <= '"+Dtos(MV_PAR04)+"' "		+ STR_PULA
	cQryAux += "AND D2.D2_DOC >= '"+MV_PAR05+"' AND D2.D2_DOC <= '"+MV_PAR06+"'  "		+ STR_PULA
	cQryAux += "AND D2.D2_CLIENTE >= '"+MV_PAR07+"' AND D2_CLIENTE <= '"+MV_PAR08+"'  "		+ STR_PULA
	cQryAux += "AND D2.D2_CF >= '"+MV_PAR09+"' AND D2.D2_CF <= '"+MV_PAR10+"'   "		+ STR_PULA
	cQryAux += "ORDER BY D2.D2_EMISSAO, D2.D2_DOC, D2.D2_SERIE"		+ STR_PULA
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

	PutSx1(cPerg,"01", "Filial de?"				,"","","mv_ch4","C",02,0,0,"G","","","","","MV_PAR01")
	PutSx1(cPerg,"02", "Filial de?"				,"","","mv_ch4","C",02,0,0,"G","","","","","MV_PAR02")
	PutSx1(cPerg,"03", "Da Dt. Emissao ?"		,"","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR03")
	PutSx1(cPerg,"04", "Ate Dt. Entrada ?"		,"","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR04")
	PutSx1(cPerg,"05", "Nota Fiscal de?"		,"","","mv_ch4","C",09,0,0,"G","","","","","MV_PAR05")
	PutSx1(cPerg,"06", "Nota Fiscla Ate?"		,"","","mv_ch5","C",09,0,0,"G","","","","","MV_PAR06")
	PutSx1(cPerg,"07", "Cliente De?"			,"","","mv_ch6","C",06,0,0,"G","","","","","MV_PAR07")
	PutSx1(cPerg,"08", "Cliente Até?"			,"","","mv_ch6","C",06,0,0,"G","","","","","MV_PAR08")
	PutSx1(cPerg,"09", "CFOP De?"				,"","","mv_ch6","C",04,0,0,"G","","","","","MV_PAR09")
	PutSx1(cPerg,"10", "CFOP Até ?"				,"","","mv_ch4","C",04,0,0,"G","","","","","MV_PAR10")
	PutSx1(cPerg,"11", "FATURADO ?"				,"","","mv_ch3","C",01,0,0,"C","","","","","mv_par11","SIM","SIM","SIM","","NÃO","NÃO","NÃO","AMBOS","AMBOS","AMBOS","","","","","","","")
	 
	RestArea(aArea)
Return Nil

