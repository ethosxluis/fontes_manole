//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RTRANSP
Relatório - Relatorio Diario - Transportadora
@author Wallace José Pereira
@since 22/10/2020
@version 1.0
	@example
	u_RTRANSP()
/*/
	
User Function RTRANSP()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := "RTRANSP"
	
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
	oReport := TReport():New(	"RTRANSP",;		//Nome do Relatório
								"Relatorio Diario - Transportadora",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	oReport:SetLineHeight(60)
	oReport:nFontBody := 12
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "F2_FILIAL", "QRY_AUX", "Filial", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "F2_DOC", "QRY_AUX", "Numero", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "F2_SERIE", "QRY_AUX", "Serie Docto.", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "F2_CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "F2_LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "F2_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_COD", "QRY_AUX", "Codigo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_NREDUZ", "QRY_AUX", "N Fantasia", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A4_NREDUZ", "QRY_AUX", "Nome Reduz.", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT "		+ STR_PULA
	cQryAux += "F2_FILIAL,"		+ STR_PULA
	cQryAux += "F2_DOC,"		+ STR_PULA
	cQryAux += "F2_SERIE,"		+ STR_PULA
	cQryAux += "F2_CLIENTE,"		+ STR_PULA
	cQryAux += "F2_LOJA,"		+ STR_PULA
	//cQryAux += "CASE WHEN LENGTH(F2_EMISSAO)=8"		+ STR_PULA
	//cQryAux += "    THEN SUBSTR(F2_EMISSAO,7,2) || '/' || SUBSTR(F2_EMISSAO,5,2) || '/' || SUBSTR(F2_EMISSAO,1,4)"		+ STR_PULA
	//cQryAux += "    WHEN LENGTH(F2_EMISSAO)=10"		+ STR_PULA
	//cQryAux += "    THEN SUBSTR(F2_EMISSAO,1,2) || '/' || SUBSTR(F2_EMISSAO,4,2) || '/' || SUBSTR(F2_EMISSAO,7,4)"		+ STR_PULA
	//cQryAux += "END"		+ STR_PULA
	cQryAux += "F2_EMISSAO,"		+ STR_PULA
	cQryAux += "A1_COD,"		+ STR_PULA
	cQryAux += "A1_LOJA,"		+ STR_PULA
	cQryAux += "A1_NREDUZ,"		+ STR_PULA
	cQryAux += "A4_NREDUZ"		+ STR_PULA
	cQryAux += "FROM SF2010 SF2, SA1010 SA1, SA4010 SA4"		+ STR_PULA
	cQryAux += "WHERE SF2.D_E_L_E_T_ = ' ' "		+ STR_PULA
	cQryAux += "AND SF2.F2_CLIENTE = SA1.A1_COD"		+ STR_PULA
	cQryAux += "AND SF2.F2_LOJA = SA1.A1_LOJA"		+ STR_PULA
	cQryAux += "AND SF2.F2_TRANSP = SA4.A4_COD"		+ STR_PULA
	cQryAux += "AND SF2.F2_EMISSAO >= '"+Dtos(MV_PAR01)+"' AND SF2.F2_EMISSAO <= '"+Dtos(MV_PAR02)+"'  "		+ STR_PULA
	cQryAux += "AND SF2.F2_DOC >= '"+MV_PAR03+"' AND SF2.F2_DOC <= '"+MV_PAR04+"'  "		+ STR_PULA
	cQryAux += "AND SF2.F2_SERIE >= '"+MV_PAR05+"' AND SF2.F2_SERIE <= '"+MV_PAR06+"'  "		+ STR_PULA
	cQryAux += "AND SA1.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "AND SA4.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "F2_EMISSAO", "D")
	
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


//---------------------------------------------------------------
Static Function AjustaSX1(cPerg)
	Local aArea := GetArea()

	PutSx1(cPerg,"01","Emissao de ?       	","","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01")
	PutSx1(cPerg,"02","Emissao ate ?       	","","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02")
	PutSx1(cPerg,"03","Nota Fiscal de ?		","","","mv_ch3","C",09,0,0,"G","","","","","MV_PAR03")
	PutSx1(cPerg,"04","Nota Fiscal ate ?	","","","mv_ch4","C",09,0,0,"G","","","","","MV_PAR04")
	PutSx1(cPerg,"05","Serie de ?       	","","","mv_ch5","C",03,0,0,"G","","","","","MV_PAR05")
	PutSx1(cPerg,"06","Serie ate ?       	","","","mv_ch6","C",03,0,0,"G","","","","","MV_PAR06")

RestArea( aArea )           
Return Nil