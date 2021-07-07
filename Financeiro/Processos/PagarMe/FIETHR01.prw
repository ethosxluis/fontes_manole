#Include 'Protheus.ch'

User Function FIETHR01(aTitRA)
	Local oReport
	
	oReport:= TReport():New("","Relatorio de Clientes com RA", , {|oReport| ReportPrint(oReport,aTitRA)},"Listagem de Clientes com RA")
	
	oSection := TRSection():New(oReport	,"Cliente",{"SE1"},/*Ordem*/)
		
	TRCell():New(oSection,"E1_FILIAL"		,"SE1" ,"Filial"/*Titulo*/	,/*Picture*/,02/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_CLIENTE"		,"SE1" ,"Cliente"/*Titulo*/	,/*Picture*/,06/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_LOJA"			,"SE1" ,"Loja"/*Titulo*/	,/*Picture*/,02/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_PREFIXO"		,"SE1" ,"Prefixo"/*Titulo*/	,/*Picture*/,03/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_NUM"			,"SE1" ,"Número"/*Titulo*/	,/*Picture*/,09/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_TIPO"			,"SE1" ,"Tipo"/*Titulo*/	,/*Picture*/,03/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_PARCELA"		,"SE1" ,"Parcela"/*Titulo*/	,/*Picture*/,03/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_VALOR"		,"SE1" ,"Valor"/*Titulo*/	,/*Picture*/,14/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"E1_PGVTTID"		,"SE1" ,"ID VETEX"/*Titulo*/,/*Picture*/,50/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	TRCell():New(oSection,"DETALHE"			,"SE1" ,"Detalhe" /*Titulo*/,/*Picture*/,50/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",,"CENTER")
	
	oReport:PrintDialog()

Return

Static Function ReportPrint(oReport,aTitRA)	
	Local nLoop	:= 0
	
	oReport:Section(1):Init()
	For nLoop := 1 To Len(aTitRA)
		oSection:Cell("E1_FILIAL"):SetValue(aTitRA[nLoop,1])
		oSection:Cell("E1_CLIENTE"):SetValue(aTitRA[nLoop,2])
		oSection:Cell("E1_LOJA"):SetValue(aTitRA[nLoop,3])
		oSection:Cell("E1_PREFIXO"):SetValue(aTitRA[nLoop,4])
		oSection:Cell("E1_NUM"):SetValue(aTitRA[nLoop,5])
		oSection:Cell("E1_TIPO"):SetValue(aTitRA[nLoop,6])
		oSection:Cell("E1_PARCELA"):SetValue(aTitRA[nLoop,7])
		oSection:Cell("E1_VALOR"):SetValue(aTitRA[nLoop,9])
		oSection:Cell("E1_PGVTTID"):SetValue(aTitRA[nLoop,8])
		oSection:Cell("DETALHE"):SetValue(aTitRA[nLoop,10])
		
		oReport:Section(1):PrintLine()
	Next 
	oReport:Section(1):Finish()
Return

