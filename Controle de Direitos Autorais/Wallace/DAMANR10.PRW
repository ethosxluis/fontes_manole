//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} DAMANR10
Relat�rio - Relatorio  Direito Autoral Det
@author zReport
@since 10/09/2020
@version 1.0
	@example
	u_DAMANR10()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function DAMANR10()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	cPerg := "DAMANR10  "
	
	//Se a pergunta n�o existir, zera a vari�vel
	//DbSelectArea("SX1")
	//SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	//If ! SX1->(DbSeek(cPerg))
	//	cPerg := Nil
	//EndIf
	
	AjustaSX1()
	Pergunte(cPerg,.F.)
	
	//Cria as defini��es do relat�rio
	oReport := fReportDef()
	
	//Ser� enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Sen�o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun��o que monta a defini��o do relat�rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	Local oFunTot1 := Nil
	Local oFunTot2 := Nil
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"DAMANR10",;		//Nome do Relat�rio
								"Relatorio  Direito Autoral Detalhado",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Dados",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
//Colunas do relat�rio
	TRCell():New(oSectDad, "COD_PRODUTO", "QRY_AUX", "Cod_produto", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 180, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_VENDIDA", "QRY_AUX", "Qtd_vendida", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_DEVOLVIDA", "QRY_AUX", "Qtd_devolvida", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRC_VENDIDO", "QRY_AUX", "Prc_vendido", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PERCENTUAL_DA", "QRY_AUX", "Percentual_da", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_DA", "QRY_AUX", "Valor_da", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ADIANTAMENTO", "QRY_AUX", "Adiantamento", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_FORNECEDOR", "QRY_AUX", "Cod_fornecedor", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA_FORNECEDOR", "QRY_AUX", "Loja_fornecedor", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_FORNECEDOR", "QRY_AUX", "Nome_fornecedor", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PERIODO", "QRY_AUX", "Periodo", /*Picture*/, 13, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BAIXA_TIT", "QRY_AUX", "Baixa_tit", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VLR_TIT", "QRY_AUX", "Vlr_tit", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SALDO", "QRY_AUX", "Saldo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TITULO", "QRY_AUX", "Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT DISTINCT P03_PRODUT COD_PRODUTO,"		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO,"		+ STR_PULA
	cQryAux += "SUM(P03_QTDE) QTD_VENDIDA,"		+ STR_PULA
	cQryAux += "SUM(P03_QTDDEV) QTD_DEVOLVIDA,"		+ STR_PULA
	cQryAux += "SUM(P03_PRCVEN) PRC_VENDIDO,"		+ STR_PULA
	cQryAux += "P03_PERCDA PERCENTUAL_DA,"		+ STR_PULA
	cQryAux += "SUM(P03_VLRDA) VALOR_DA,"		+ STR_PULA
	cQryAux += "SUM(P03_ADIANT) ADIANTAMENTO,"		+ STR_PULA
	cQryAux += "P03_FORNEC COD_FORNECEDOR,"		+ STR_PULA
	cQryAux += "P03_LOJAFO LOJA_FORNECEDOR,"		+ STR_PULA
	cQryAux += "A2_NOME NOME_FORNECEDOR,"		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '01' THEN 'MENSAL'         ELSE "		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '02' THEN 'BIMESTRAL'      ELSE"		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '03' THEN 'TRIMESTRAL'     ELSE"		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '04' THEN 'QUADRIMESTRAL'  ELSE"		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '06' THEN 'SEMESTRAL'      ELSE"		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '12' THEN 'ANUAL'          ELSE"		+ STR_PULA
	cQryAux += "CASE P03_PERIOD WHEN '24' THEN 'BIENAL'         "		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "END"		+ STR_PULA
	cQryAux += "PERIODO,"		+ STR_PULA
	cQryAux += "case when length(E2_BAIXA)=8"		+ STR_PULA
    cQryAux += "then substr(E2_BAIXA,7,2) || '/' || substr(E2_BAIXA,5,2) || '/' || substr(E2_BAIXA,1,4)"		+ STR_PULA
    cQryAux += "when length(E2_BAIXA)=10"		+ STR_PULA
    cQryAux += "then substr(E2_BAIXA,1,2) || '/' || substr(E2_BAIXA,4,2) || '/' || substr(E2_BAIXA,7,4)"		+ STR_PULA
    cQryAux += "end"		+ STR_PULA
    cQryAux += "BAIXA_TIT,"		+ STR_PULA
    cQryAux += "E2_VALOR AS VLR_TIT,"		+ STR_PULA
    cQryAux += "E2_SALDO AS SALDO,"		+ STR_PULA
    cQryAux += "E2_NUM AS TITULO"		+ STR_PULA
	cQryAux += "FROM "+retsqlname("SA2")+","+retsqlname("P03")+","+retsqlname("SE2")+","+retsqlname("SB1")	+ STR_PULA
	cQryAux += "WHERE "		+ STR_PULA
	cQryAux += "P03_FORNEC = E2_FORNECE "		+ STR_PULA
	cQryAux += "AND P03_LOJAFO = E2_LOJA "		+ STR_PULA
	cQryAux += "AND P03_PRODUT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "		+ STR_PULA
	cQryAux += "AND P03_FORNEC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "		+ STR_PULA
	cQryAux += "AND SUBSTR(E2_EMISSAO,1,6) between '"+mv_par05+"' AND '"+mv_par06+"' "		+ STR_PULA
	cQryAux += "AND E2_ORIGEM = 'CALC_DA' "		+ STR_PULA
	cQryAux += "AND P03_MESANO between '"+mv_par05+"' AND '"+mv_par06+"' "		+ STR_PULA
	cQryAux += "AND A2_COD = P03_FORNEC "		+ STR_PULA
	cQryAux += "AND A2_LOJA = P03_LOJAFO "		+ STR_PULA
	cQryAux += "AND B1_FILIAL = P03_FILIAL"		+ STR_PULA
	cQryAux += "AND B1_COD = P03_PRODUT"		+ STR_PULA
	cQryAux += "AND "+retsqlname("P03")+".D_E_L_E_T_ <> '*' "		+ STR_PULA
	cQryAux += "AND "+retsqlname("SE2")+".D_E_L_E_T_ <> '*' "		+ STR_PULA
	cQryAux += "AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "		+ STR_PULA
	cQryAux += "AND "+retsqlname("SB1")+".D_E_L_E_T_ <> '*' "		+ STR_PULA
	cQryAux += "GROUP BY P03_PRODUT,B1_DESC, P03_PERIOD,"		+ STR_PULA
	cQryAux += "P03_FORNEC ,"		+ STR_PULA
	cQryAux += "P03_LOJAFO ,"		+ STR_PULA
	cQryAux += "A2_NOME ,"		+ STR_PULA
	cQryAux += "P03_PERCDA,"		+ STR_PULA
	cQryAux += "E2_BAIXA ,"		+ STR_PULA
	cQryAux += "E2_VALOR ,"		+ STR_PULA
	cQryAux += "E2_SALDO ,"		+ STR_PULA
	cQryAux += "E2_NUM "		+ STR_PULA
	cQryAux += "ORDER BY P03_PRODUT"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a r�gua
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
	PutSx1(cPerg	,"03"	,"Mes do Fechamento"     	,'','',"MV_C03"	,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par03",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	PutSx1(cPerg	,"04"	,"Ano do Fechamento" 	,'','',"MV_C04" ,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par04",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
    //PutSx1(cPerg	,"05"	,"Periodo" 		,'','',"MV_C05" ,"C"	,2                       ,0,,"C"	,""		,""	,""			,"","mv_par05","01"		,"","","","02"	,"","","03"		,"","","06"  ,"","","12"  ,"","","")    
	
	RestArea(aArea)    
return

