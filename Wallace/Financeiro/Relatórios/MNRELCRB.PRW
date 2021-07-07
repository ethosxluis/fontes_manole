//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} MNRELCRB
Relatório - Rel Titulos Baixados C Receber
@author Wallace José Pereira
@since 14/10/2020
@version 1.0
	@example
	u_MNRELCRB()
/*/
	
User Function MNRELCRB()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "MNRELCRB"
	
	//Se a pergunta não existir, zera a variável
	//DbSelectArea("SX1")
	//SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	//If ! SX1->(DbSeek(cPerg))
		//cPerg := Nil
	//EndIf
	
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
	oReport := TReport():New(	"MNRELCRB",;		//Nome do Relatório
								"Rel Titulos Baixados C Receber",;		//Título
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
	TRCell():New(oSectDad, "E1_PREFIXO", "QRY_AUX", "Prefixo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_NUM", "QRY_AUX", "No. Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_PARCELA", "QRY_AUX", "Parcela", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_TIPO", "QRY_AUX", "Tipo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_NATUREZ", "QRY_AUX", "Natureza", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_NOMCLI", "QRY_AUX", "Nome Cliente", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VALOR", "QRY_AUX", "Vlr.Titulo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_BASEIRF", "QRY_AUX", "Base Impost.", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_IRRF", "QRY_AUX", "IRRF", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_ISS", "QRY_AUX", "ISS", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_SALDO", "QRY_AUX", "Saldo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VENCTO", "QRY_AUX", "Vencimento", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VENCREA", "QRY_AUX", "Vencto real", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_BAIXA", "QRY_AUX", "DT Baixa", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_DESCONT", "QRY_AUX", "Desconto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_MULTA", "QRY_AUX", "Multa", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_JUROS", "QRY_AUX", "Juros", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VALLIQ", "QRY_AUX", "Vlr.Liq Baix", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VENCORI", "QRY_AUX", "Vencto Orig", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_PEDIDO", "QRY_AUX", "No. Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VLCRUZ", "QRY_AUX", "Vlr R$", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_NUMNOTA", "QRY_AUX", "Nota Fiscal", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_SERIE", "QRY_AUX", "Serie", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_CSLL", "QRY_AUX", "CSLL", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_COFINS", "QRY_AUX", "COFINS", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_PIS", "QRY_AUX", "PIS/PASEP", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_BASEPIS", "QRY_AUX", "Base Pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_BASECOF", "QRY_AUX", "Base Cof", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_BASECSL", "QRY_AUX", "Base Csll", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_TITPAI", "QRY_AUX", "Tit.Pai PCC", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_NFELETR", "QRY_AUX", "NF Eletr", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_PGVTTID", "QRY_AUX", "Vertex TID", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_NOSSVTX", "QRY_AUX", "Nosso N Vtex", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT E1_PREFIXO, "		+ STR_PULA
	cQryAux += "E1_NUM, "		+ STR_PULA
	cQryAux += "E1_PARCELA, "		+ STR_PULA
	cQryAux += "E1_TIPO, "		+ STR_PULA
	cQryAux += "E1_NATUREZ,"		+ STR_PULA
	cQryAux += "E1_CLIENTE,"		+ STR_PULA
	cQryAux += "E1_LOJA,"		+ STR_PULA
	cQryAux += "E1_NOMCLI,"		+ STR_PULA
	cQryAux += "E1_VALOR, "		+ STR_PULA
	cQryAux += "E1_BASEIRF,"		+ STR_PULA
	cQryAux += "E1_IRRF,"		+ STR_PULA
	cQryAux += "E1_ISS,"		+ STR_PULA
	cQryAux += "E1_SALDO,"		+ STR_PULA
	cQryAux += " CASE WHEN LENGTH(E1_EMISSAO)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_EMISSAO,7,2) || '/' || SUBSTR(E1_EMISSAO,5,2) || '/' || SUBSTR(E1_EMISSAO,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(E1_EMISSAO)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_EMISSAO,1,2) || '/' || SUBSTR(E1_EMISSAO,4,2) || '/' || SUBSTR(E1_EMISSAO,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "E1_EMISSAO,"		+ STR_PULA
	cQryAux += "  CASE WHEN LENGTH(E1_VENCTO)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_VENCTO,7,2) || '/' || SUBSTR(E1_VENCTO,5,2) || '/' || SUBSTR(E1_VENCTO,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(E1_VENCTO)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_VENCTO,1,2) || '/' || SUBSTR(E1_VENCTO,4,2) || '/' || SUBSTR(E1_VENCTO,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "E1_VENCTO,"		+ STR_PULA
	cQryAux += "  CASE WHEN LENGTH(E1_VENCREA)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_VENCREA,7,2) || '/' || SUBSTR(E1_VENCREA,5,2) || '/' || SUBSTR(E1_VENCREA,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(E1_VENCREA)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_VENCREA,1,2) || '/' || SUBSTR(E1_VENCREA,4,2) || '/' || SUBSTR(E1_VENCREA,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "E1_VENCREA,"		+ STR_PULA
	cQryAux += "  CASE WHEN LENGTH(E1_BAIXA)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_BAIXA,7,2) || '/' || SUBSTR(E1_BAIXA,5,2) || '/' || SUBSTR(E1_BAIXA,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(E1_BAIXA)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E1_BAIXA,1,2) || '/' || SUBSTR(E1_BAIXA,4,2) || '/' || SUBSTR(E1_BAIXA,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "E1_BAIXA,"		+ STR_PULA
	cQryAux += "E1_DESCONT,"		+ STR_PULA
	cQryAux += "E1_MULTA,	"		+ STR_PULA
	cQryAux += "E1_JUROS,	"		+ STR_PULA
	cQryAux += "E1_VALLIQ,	"		+ STR_PULA
	cQryAux += "E1_VENCORI,"		+ STR_PULA
	cQryAux += "E1_PEDIDO,	"		+ STR_PULA
	cQryAux += "E1_VLCRUZ,"		+ STR_PULA
	cQryAux += "E1_NUMNOTA,"		+ STR_PULA
	cQryAux += "E1_SERIE,	"		+ STR_PULA
	cQryAux += "E1_CSLL,"		+ STR_PULA
	cQryAux += "E1_COFINS,"		+ STR_PULA
	cQryAux += "E1_PIS,"		+ STR_PULA
	cQryAux += "E1_BASEPIS,	"		+ STR_PULA
	cQryAux += "E1_BASECOF,	"		+ STR_PULA
	cQryAux += "E1_BASECSL,"		+ STR_PULA
	cQryAux += "E1_TITPAI,	"		+ STR_PULA
	cQryAux += "E1_NFELETR,"		+ STR_PULA
	cQryAux += "E1_PGVTTID,"		+ STR_PULA
	cQryAux += "E1_NOSSVTX"		+ STR_PULA
	cQryAux += "FROM SE1010 "		+ STR_PULA
	cQryAux += "WHERE E1_BAIXA >= '"+Dtos(MV_PAR03)+"' AND E1_BAIXA <= '"+Dtos(MV_PAR04)+"' AND  "		+ STR_PULA
	cQryAux += "  E1_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND E1_EMISSAO <= '"+Dtos(MV_PAR02)+"'    AND D_E_L_E_T_ =' '"		+ STR_PULA
	cQryAux += "      AND E1_CLIENTE <> '093632'"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "E1_EMISSAO", "D")
	TCSetField("QRY_AUX", "E1_VENCTO", "D")
	TCSetField("QRY_AUX", "E1_VENCREA", "D")
	TCSetField("QRY_AUX", "E1_BAIXA", "D")
	TCSetField("QRY_AUX", "E1_VENCORI", "D")
	
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

	u_zPutSx1(cPerg,"01", "Da Emissao ?"	,"","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01")
	u_zPutSx1(cPerg,"02", "Ate Emissão ?"	,"","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02")
	u_zPutSx1(cPerg,"03","Da Baixa?"			,"","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
	u_zPutSx1(cPerg,"04", "Até a Baixa?"			,"","","mv_ch4","D",08,0,0,"G","","","","","MV_PAR04")
	RestArea(aArea)
Return Nil
