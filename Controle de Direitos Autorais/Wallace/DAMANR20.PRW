//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} DAMANR20
Relatório - Relatorio                     
@author zReport
@since 14/09/2020
@version 1.0
	@example
	u_DAMANR20()
	@obs Função gerada pelo zReport()
/*/
	
User Function DAMANR20()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "DAMANR20"
	
	//Se a pergunta não existir, zera a variável
	//DbSelectArea("SX1")
	//SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	//If ! SX1->(DbSeek(cPerg))
	//	cPerg := Nil
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
	oReport := TReport():New(	"DAMANR20",;		//Nome do Relatório
								"Relatorio ",;		//Título
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
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 180, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PERCENTUAL_DA", "QRY_AUX", "Percentual_da", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_VENDIDA", "QRY_AUX", "Qtd_vendida", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BASEDA", "QRY_AUX", "Baseda", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALORDA", "QRY_AUX", "Valorda", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRC_CAPA", "QRY_AUX", "Prc_capa", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DTPRESTACAO", "QRY_AUX", "Dtprestacao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_FORNECEDOR", "QRY_AUX", "Cod_fornecedor", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA_FORNECEDOR", "QRY_AUX", "Loja_fornecedor", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_FORNECEDOR", "QRY_AUX", "Nome_fornecedor", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TITULO", "QRY_AUX", "Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VLR_TIT", "QRY_AUX", "Vlr_tit", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SALDO", "QRY_AUX", "Saldo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BAIXA_TIT", "QRY_AUX", "Baixa_tit", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT DISTINCT(AH5_PRODUT) PRODUTO, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO,"		+ STR_PULA
	cQryAux += "AH5_PERCDA PERCENTUAL_DA,"		+ STR_PULA
	cQryAux += "SUM(AH5_QTDACU) QTD_VENDIDA,"		+ STR_PULA
	cQryAux += "SUM(AH5_BASEDA) BASEDA,"		+ STR_PULA
	cQryAux += "SUM(AH5_VALORD) VALORDA,"		+ STR_PULA
	cQryAux += "CASE WHEN AH5_BASEDA > 0 AND (AH5_QTDACU)>0 " + STR_PULA
	cQryAux += "THEN " + STR_PULA
	cQryAux += "ROUND(SUM(AH5_BASEDA) / SUM(AH5_QTDACU),2)"		+ STR_PULA
	cQryAux += "ELSE 0"		+ STR_PULA
	cQryAux += "END "		+ STR_PULA
	cQryAux += "PRC_CAPA,"		+ STR_PULA
	cQryAux += "CASE WHEN LENGTH(AH5_DTPRES)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(AH5_DTPRES,7,2) || '/' || SUBSTR(AH5_DTPRES,5,2) || '/' || SUBSTR(AH5_DTPRES,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(AH5_DTPRES)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(AH5_DTPRES,1,2) || '/' || SUBSTR(AH5_DTPRES,4,2) || '/' || SUBSTR(AH5_DTPRES,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "DTPRESTACAO,  "		+ STR_PULA
	cQryAux += "AH5_FORNEC COD_FORNECEDOR,"		+ STR_PULA
	cQryAux += "AH5_LOJAFO LOJA_FORNECEDOR,"		+ STR_PULA
	cQryAux += "E2_NOMFOR NOME_FORNECEDOR,"		+ STR_PULA
	cQryAux += "E2_NUM TITULO,"		+ STR_PULA
	cQryAux += "E2_VALOR VLR_TIT,"		+ STR_PULA
	cQryAux += "E2_SALDO AS SALDO,"		+ STR_PULA
	cQryAux += "CASE WHEN LENGTH(E2_BAIXA)=8"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E2_BAIXA,7,2) || '/' || SUBSTR(E2_BAIXA,5,2) || '/' || SUBSTR(E2_BAIXA,1,4)"		+ STR_PULA
	cQryAux += "     WHEN LENGTH(E2_BAIXA)=10"		+ STR_PULA
	cQryAux += "     THEN SUBSTR(E2_BAIXA,1,2) || '/' || SUBSTR(E2_BAIXA,4,2) || '/' || SUBSTR(E2_BAIXA,7,4)"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "BAIXA_TIT"		+ STR_PULA
	cQryAux += "FROM AH5010 AH5 ,SE2010 SE2, AH1010 AH1, SB1010 SB1"		+ STR_PULA
	cQryAux += "WHERE E2_PREFIXO = 'RYI'"		+ STR_PULA
	cQryAux += "	AND AH5_PRODUT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "		+ STR_PULA
	cQryAux += "	AND AH5_FORNEC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "		+ STR_PULA
	cQryAux += "	AND E2_EMISSAO >= '"+Dtos(MV_PAR05)+"' AND E2_EMISSAO <= '"+Dtos(MV_PAR06)+"'  "		+ STR_PULA
	cQryAux += "    AND AH5_FORNEC  = E2_FORNECE "		+ STR_PULA
	cQryAux += "    AND AH5_LOJAFO  = E2_LOJA  "		+ STR_PULA
	cQryAux += "    AND AH5_DTPRES = E2_EMISSAO "		+ STR_PULA
	cQryAux += "    AND SE2.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "    AND AH5.D_E_L_E_T_ <> '*' "		+ STR_PULA
	cQryAux += "    AND AH1.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "    AND SB1.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "    AND AH1_PRODUT = AH5_PRODUT"		+ STR_PULA
	cQryAux += "    AND AH1_FORNEC = E2_FORNECE"		+ STR_PULA
	cQryAux += "    AND AH5_PRODUT = B1_COD"		+ STR_PULA
	cQryAux += "GROUP BY AH5_PRODUT,B1_DESC, AH5_PERCDA ,AH5_DTPRES,  E2_NUM,E2_VALOR ,AH5_FORNEC,AH5_LOJAFO, E2_NOMFOR,E2_BAIXA, E2_SALDO,AH5_BASEDA,AH5_QTDACU"		+ STR_PULA
	cQryAux += "ORDER BY AH5_PRODUT"		+ STR_PULA
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

Static Function AjustaSX1(cPerg)

	Local aArea := GetArea()
            //cGrupo    ,cOrdem	,cPergunt		,  ,  ,cVar		,cTipo ,nTamanho				 , ,,cGSC	,cValid	,cF3, cGrpSxg	,  ,cVar01    ,cDef01	,  ,  ,  ,cDef02,"","",cDef03	,"","",cDef04,"","",cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	PutSx1(cPerg	,"01"	,"Produto de"    	,'','',"MV_C01"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par01",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	PutSx1(cPerg	,"02"	,"Produto ate"   	,'','',"MV_C02"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par02",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	PutSx1(cPerg	,"01"	,"Autor de"    	,'','',"MV_C01"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par01",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	PutSx1(cPerg	,"02"	,"Autor ate"   	,'','',"MV_C02"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par02",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	PutSx1(cPerg	,"03"	,"Da Data de Prestação?"     	,'','',"MV_C03"	,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par03",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	PutSx1(cPerg	,"04"	,"Ate Data de Prestação?" 	,'','',"MV_C04" ,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par04",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
    //PutSx1(cPerg	,"05"	,"Periodo" 		,'','',"MV_C05" ,"C"	,2                       ,0,,"C"	,""		,""	,""			,"","mv_par05","01"		,"","","","02"	,"","","03"		,"","","06"  ,"","","12"  ,"","","")    
	
	RestArea(aArea)    
return


