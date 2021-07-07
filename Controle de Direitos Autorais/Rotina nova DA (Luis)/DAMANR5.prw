#Include "Protheus.ch"
#Include "tbiconn.ch"

/*/{Protheus.doc} DAMANR01
RELATORIO COM DETALHAMENTO DO PERIODO DO DIREITOS AUTORAIS
@type function
@author Fernando Carvalho3
3.
@since 05/05/2020
@version 1.0
/*/

User Function DAMANR5()
	Local cPerg     := "DAMANHR05"
	
//	   AjustaSX1(cPerg)

	if !Pergunte(cPerg, .T.)
		Return nil
	endif


//	Processa({|| U_LE_ARQS() },"Lendo os arquivos...","Aguarde.")
	
	Processa( {|| DAMANR0501() }, "Aguarde...", "Selecionando Registros...",.F.)

	Processa( {|| imp_plan() }, "Aguarde...", "Gerando Excel...",.F.)


 
Return 


static Function DAMANR0501()



	Local cAlias 		:= GetNextAlias()
    Local oFWMsExcel	:= nil
    
    _mesatual := MV_PAR03

	 PRIVATE AARQTRB := {}

     AADD(AARQTRB,{"FORNECEDOR" 		,"C",06,0})
     AADD(AARQTRB,{"CONTRATO" 			,"C",06,0})
     AADD(AARQTRB,{"PRODUTO" 			,"C",30,0})     
     AADD(AARQTRB,{"TIPO_FAT"    		,"C",01,0})
	 AADD(AARQTRB,{"PERCENTUAL" 		,"N",06,2})
	 AADD(AARQTRB,{"TIPO_PGTO" 	        ,"C",01,0})
     AADD(AARQTRB,{"DOCUMENTO" 			,"C",09,0})
     AADD(AARQTRB,{"PARCELAS"     		,"C",01,0})
     AADD(AARQTRB,{"PARC_PAGAS"   		,"C",01,0})
     AADD(AARQTRB,{"EMISSAO" 			,"D",08,0})
     AADD(AARQTRB,{"VALOR_TIT"  		,"N",17,2})
     AADD(AARQTRB,{"PRC_TABELA" 		,"N",14,2})
     AADD(AARQTRB,{"TOTAL"		 		,"N",14,2})
   
	if select("D01")>0
		D01->(DBCLOSEAREA())
	endif


	 CARQTRB := CRIATRAB(AARQTRB,.T.)
	 DBUSEAREA(.T.,,CARQTRB,"D01")
//     INDEX ON NOMAUT+DESPRO TO &CARQTRB
	
	
	
	
	
	_mesatual := MV_PAR03
	_mesano := MV_PAR04 + MV_PAR03
	_dtini := ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04)
	_dtfim := lastday(_dtini)
	_period := "01"
	
	_dtini2 := _dtini
	_dtfim2 := lastday(_dtini2)



	le_arqs(_period,_dtini,_dtfim)


	IF _mesatual$(GETMV("MV_DAPER02"))  //BIMESTRAIS
   	
   		_period := "02"
//   		_dtini := ctod("01" + "/" + str(val(MV_PAR03) - 1) + "/" + MV_PAR04)
 		_dtini := MonthSub(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04),1)   		
   		_dtfim := lastday(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04))

	
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  _mesini
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)

		for _imes  := (month(_dtini2))  to _mesfim
			le_arqs(_period,_dtini,_dtfim)
		next



   		
	elseif _mesatual$(GETMV("MV_DAPER03"))  //TRIMESTRAIS
   	
		_period := "03"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR03) - 2) + "/" + MV_PAR04)
//		_dtfim := lastday(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04))

   		_dtini := MonthSub(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04),2)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04))
		
		
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  _mesini
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		for _imes  := (month(_dtini2))  to _mesfim

			le_arqs(_period,_dtini,_dtfim)
		
		next



	elseif _mesatual$(GETMV("MV_DAPER04"))  //QUADRIMESTRAIS
   	
		_period := "04"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR03) - 3) + "/" + MV_PAR04)
		_dtini := MonthSub(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04),3)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04))


		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  _mesini
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		for _imes  := (month(_dtini2))  to _mesfim

			le_arqs(_period,_dtini,_dtfim)
			

		next




	
	elseif _mesatual$(GETMV("MV_DAPER06"))  //SEMESTRAIS
   	
		_period := "06"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR03) - 5) + "/" + MV_PAR04)
   		_dtini := MonthSub(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04),5)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04))
				
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  1
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		_imesfim := DateDiffMonth(_dtini,_dtfim) + 1
		
		for _imes  := 1  to _imesfim

			le_arqs(_period,_dtini,_dtfim)

		next
	
	
	elseif _mesatual$(GETMV("MV_DAPER12"))  //ANUAIS
   	
		_period := "12"

   		_dtini := MonthSub(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04),11)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR03 + "/" + MV_PAR04))
				
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  1
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		_imesfim := DateDiffMonth(_dtini,_dtfim) + 1
		
		for _imes  := 1  to _imesfim

			le_arqs(_period,_dtini,_dtfim)


		next



	endif
	


return()


/*	
	BeginSql alias cAlias
			SELECT 
			P04_FORNEC FORNECEDOR,
			P04_CONTRA CONTRATO,
			P04_XTPFAT TIPO_FATURA,
			P05_PERCRE PERCENTUAL,
			P05_PRBRUT TIPO_PAGAMENTO,
			(SELECT COUNT(*) FROM SE1010 WHERE E1_PREFIXO = D2_SERIE AND E1_NUM = D2_DOC AND E1_CLIENTE = D2_CLIENTE AND E1_LOJA = D2_LOJA AND D_E_L_E_T_ = ' ') QTD_PARCELAS,
			(SELECT COUNT(*) FROM SE1010 WHERE E1_PREFIXO = D2_SERIE AND E1_NUM = D2_DOC AND E1_CLIENTE = D2_CLIENTE AND E1_LOJA = D2_LOJA AND D_E_L_E_T_ = ' ' AND E1_BAIXA <> '') PARCELA_PAGAS, 
			E1_PARCELA PARCELA_ATUAL,
			E1_EMISSAO EMISSAO,
			E1_VALOR VALOR_TITULO,
			D2_DOC DOCUMENTO,
			D2_COD PRODUTO,
			D2_QUANT QUANTIDADE,
			D2_PRUNIT PRC_TABELA,
			D2_PRCVEN PRC_VENDA,
			D2_TOTAL TOTAL

			FROM %table:SD2% SD2
			INNER JOIN %table:SE1% SE1 ON
					E1_NUM = D2_DOC    
					AND E1_SERIE = D2_SERIE 
					AND E1_CLIENTE = D2_CLIENTE 
					AND E1_LOJA = D2_LOJA 
					AND SE1.D_E_L_E_T_ <> '*'
					AND E1_BAIXA BETWEEN %exp:DTOS(MV_PAR03)% AND %exp:DTOS(MV_PAR04)%
			INNER JOIN  %table:P04% P04 ON
					P04_PRODUT = D2_COD
					AND P04_XTPFAT = '2'
					AND P04_FORNEC BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%         
				//	AND P04_PRODUT BETWEEN %exp:MV_PAR05% AND %exp:DMV_PAR06%
					AND P04_PERIOD = %exp:MV_PAR05%
					AND P04.D_E_L_E_T_ <> '*'
			INNER JOIN %table:P05% P05 ON
					P05_CONTRA = P04_CONTRA
					AND P05_FORNEC = P04_FORNEC
					AND P05_LOJAFO = P04_LOJAFO
					AND P05_PRODUT = P04_PRODUT
					AND P05.D_E_L_E_T_  <> '*'
					AND P05_ITEM = '01'

			WHERE 
				SD2.D_E_L_E_T_ <> '*'				
//				AND D2_COD BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
				AND D2_EMISSAO >= '20200401'
			UNION ALL	

			SELECT 
			P04_FORNEC FORNECEDOR,
			P04_CONTRA CONTRATO,
			P04_XTPFAT TIPO_FATURA,
			P05_PERCRE PERCENTUAL,
			P05_PRBRUT TIPO_PAGAMENTO,
			1 QTD_PARCELAS,
			1 PARCELA_PAGAS, 
			'1' PARCELA_ATUAL,
			D2_EMISSAO EMISSAO,
			0  VALOR_TITULO,
			D2_DOC DOCUMENTO,
			D2_COD PRODUTO,
			D2_QUANT QUANTIDADE,
			D2_PRUNIT PRC_TABELA,
			D2_PRCVEN PRC_VENDA,
			D2_TOTAL TOTAL

			FROM %table:SD2% SD2
			INNER JOIN %table:P04% P04 ON
					P04_PRODUT = D2_COD
					AND P04_XTPFAT = '1'
					AND P04_FORNEC BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%         
					AND P04_PRODUT BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06% 
					AND P04.D_E_L_E_T_ <> '*'
			INNER JOIN %table:P05% P05 ON
					P05_CONTRA = P04_CONTRA
					AND P05_FORNEC = P04_FORNEC
					AND P05_LOJAFO = P04_LOJAFO
					AND P05_PRODUT = P04_PRODUT
					AND P05.D_E_L_E_T_  <> '*'
					AND P05_ITEM = '01'

			WHERE 
				SD2.D_E_L_E_T_ <> '*'
				                  
				AND D2_EMISSAO BETWEEN %exp:DTOS(MV_PAR03)% AND %exp:DTOS(MV_PAR04)%
				//AND D2_COD BETWEEN %exp:MV_PAR05% AND %exp:DMV_PAR06%
			UNION ALL	

			SELECT 
			P04_FORNEC FORNECEDOR, 
			P04_CONTRA CONTRATO,
			P04_XTPFAT TIPO_FATURA,
			P05_PERCRE PERCENTUAL,
			P05_PRBRUT TIPO_PAGAMENTO,
			1 QTD_PARCELAS,
			1 PARCELA_PAGAS, 
			'1' PARCELA_ATUAL,
			P01_EMISS EMISSAO,
			0  VALOR_TITULO,
			P01_DOC DOCUMENTO,
			P01_COD PRODUTO,
			P01_QUANT QUANTIDADE,
			P01_PRTAB PRC_TABELA,
			P01_PRUNIT PRC_VENDA,
			P01_QUANT * P01_PRTAB TOTAL

			FROM %table:P01% P01
			INNER JOIN %table:P04% P04 ON
					P04_PRODUT = P01_COD
					AND P04_FORNEC BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%         
				//	AND P04_PRODUT BETWEEN %exp:MV_PAR05% AND %exp:DMV_PAR06%
					AND P04.D_E_L_E_T_ <> '*'
			INNER JOIN %table:P05% P05 ON
					P05_CONTRA = P04_CONTRA
					AND P05_FORNEC = P04_FORNEC
					AND P05_LOJAFO = P04_LOJAFO
					AND P05_PRODUT = P04_PRODUT
					AND P05.D_E_L_E_T_  <> '*'
					AND P05_ITEM = '01'

			WHERE 
				P01.D_E_L_E_T_ <> '*'
				AND P04_FORNEC BETWEEN  %exp:MV_PAR01% AND %exp:MV_PAR02%
				AND P01_EMISS BETWEEN  %exp:DTOS(MV_PAR03)% AND %exp:DTOS(MV_PAR04)%
				//AND P01_COD BETWEEN %exp:MV_PAR05% AND %exp:DMV_PAR06%
				
				
				
	EndSql
	*/

static function le_arqs(_period,_dtini,_dtfim)

//mensais	
cquery := "	SELECT "
cquery += "	P04_FORNEC FORNECEDOR, "
cquery += "		P04_CONTRA CONTRATO, "
cquery += "		P04_XTPFAT TIPO_FATURA, "
cquery += "		P05_PERCRE PERCENTUAL, "
cquery += "		P05_PRBRUT TIPO_PAGAMENTO, "
cquery += "		(SELECT COUNT(*) FROM SE1010 WHERE E1_PREFIXO = D2_SERIE AND E1_NUM = D2_DOC AND E1_CLIENTE = D2_CLIENTE AND E1_LOJA = D2_LOJA AND D_E_L_E_T_ = ' ') QTD_PARCELAS, "
cquery += "		(SELECT COUNT(*) FROM SE1010 WHERE E1_PREFIXO = D2_SERIE AND E1_NUM = D2_DOC AND E1_CLIENTE = D2_CLIENTE AND E1_LOJA = D2_LOJA AND D_E_L_E_T_ = ' ' AND E1_BAIXA <> ' ') PARCELA_PAGAS,  "
cquery += "		E1_PARCELA PARCELA_ATUAL, "
cquery += "		E1_EMISSAO EMISSAO, "
cquery += "		E1_VALOR VALOR_TITULO, "
cquery += "		D2_DOC DOCUMENTO, "
cquery += "		D2_COD PRODUTO, "
cquery += "		D2_QUANT QUANTIDADE, "
cquery += "		D2_PRUNIT PRC_TABELA, "
cquery += "		D2_PRCVEN PRC_VENDA, "
cquery += "		D2_TOTAL TOTAL "
cquery += "		FROM "+retsqlname("SD2")+" SD2 "
cquery += "		INNER JOIN "+retsqlname("SE1")+" SE1 ON "
cquery += "				E1_NUM = D2_DOC "   
cquery += "				AND E1_SERIE = D2_SERIE "
cquery += "				AND E1_CLIENTE = D2_CLIENTE "
cquery += "				AND E1_LOJA = D2_LOJA "
cquery += "				AND SE1.D_E_L_E_T_ <> '*' "
cquery += "				AND E1_BAIXA BETWEEN '"+dtos(_dtini2)+"' AND '"+dtos(_dtfim2)+"'"
cquery += "		INNER JOIN  "+retsqlname("P04")+" P04 ON "
cquery += "				P04_PRODUT = D2_COD "
cquery += "				AND P04_XTPFAT = '2' "
cquery += "				AND P04_FORNEC BETWEEN '"+MV_PAR01+"' AND'"+MV_PAR02+"'"
cquery += "				AND P04_PERIOD = '"+_period+"'"
cquery += "				AND P04.D_E_L_E_T_ <> '*' "
cquery += "		INNER JOIN "+retsqlname("P05")+" P05 ON "
cquery += "				P05_CONTRA = P04_CONTRA "
cquery += "				AND P05_FORNEC = P04_FORNEC "
cquery += "				AND P05_LOJAFO = P04_LOJAFO "
cquery += "				AND P05_PRODUT = P04_PRODUT "
cquery += "				AND P05.D_E_L_E_T_  <> '*' "
cquery += "				AND P05_ITEM = '01' "
cquery += "		WHERE "
cquery += "			SD2.D_E_L_E_T_ <> '*' "
if _period = '01'
	cquery += "			AND D2_EMISSAO >= '20200401' "
else
	cquery += "			AND D2_EMISSAO >= '"+dtos(_dtini)+"'"
endif
cquery += "		UNION ALL "
cquery += "		SELECT "
cquery += "		P04_FORNEC FORNECEDOR, "
cquery += "		P04_CONTRA CONTRATO, "
cquery += "		P04_XTPFAT TIPO_FATURA, "
cquery += "		P05_PERCRE PERCENTUAL, "
cquery += "		P05_PRBRUT TIPO_PAGAMENTO, "
cquery += "		1 QTD_PARCELAS, "
cquery += "		1 PARCELA_PAGAS, "
cquery += "		'1' PARCELA_ATUAL, "
cquery += "		D2_EMISSAO EMISSAO, "
cquery += "		0  VALOR_TITULO, "
cquery += "		D2_DOC DOCUMENTO, "
cquery += "		D2_COD PRODUTO, "
cquery += "		D2_QUANT QUANTIDADE, "
cquery += "		D2_PRUNIT PRC_TABELA, "
cquery += "		D2_PRCVEN PRC_VENDA, "
cquery += "		D2_TOTAL TOTAL "
cquery += "		FROM "+retsqlname("SD2")+" SD2 "
cquery += "		INNER JOIN "+retsqlname("P04")+" P04 ON "
cquery += "				P04_PRODUT = D2_COD "
cquery += "				AND P04_XTPFAT = '1' "
cquery += "				AND P04_FORNEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
//cquery += "				AND P04_PRODUT BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06% "
cquery += "				AND P04.D_E_L_E_T_ <> '*' "
cquery += "		INNER JOIN "+retsqlname("P05")+" P05 ON "
cquery += "				P05_CONTRA = P04_CONTRA "
cquery += "				AND P05_FORNEC = P04_FORNEC "
cquery += "				AND P05_LOJAFO = P04_LOJAFO "
cquery += "				AND P05_PRODUT = P04_PRODUT "
cquery += "				AND P05.D_E_L_E_T_  <> '*' "
cquery += "				AND P05_ITEM = '01' "
cquery += "		WHERE "
cquery += "			SD2.D_E_L_E_T_ <> '*' "
cquery += "			AND D2_EMISSAO BETWEEN '"+dtos(_dtini)+ "' AND '"+dtos(_dtfim)+"'"
cquery += "		UNION ALL "
cquery += "	SELECT "
cquery += "		P04_FORNEC FORNECEDOR, "
cquery += "		P04_CONTRA CONTRATO, "
cquery += "		P04_XTPFAT TIPO_FATURA, "
cquery += "		P05_PERCRE PERCENTUAL, "
cquery += "		P05_PRBRUT TIPO_PAGAMENTO, "
cquery += "		1 QTD_PARCELAS, "
cquery += "		1 PARCELA_PAGAS, "
cquery += "		'1' PARCELA_ATUAL, "
cquery += "		P01_EMISS EMISSAO, "
cquery += "		0  VALOR_TITULO, "
cquery += "		P01_DOC DOCUMENTO, "
cquery += "		P01_COD PRODUTO, "
cquery += "		P01_QUANT QUANTIDADE, "
cquery += "		P01_PRTAB PRC_TABELA, "
cquery += "		P01_PRUNIT PRC_VENDA, "
cquery += "		P01_QUANT * P01_PRTAB TOTAL "
cquery += "		FROM "+retsqlname("P01")+" P01 "
cquery += "		INNER JOIN "+retsqlname("P04")+" P04 ON "
cquery += "				P04_PRODUT = P01_COD "
cquery += "				AND P04_FORNEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cquery += "				AND P04.D_E_L_E_T_ <> '*' "
cquery += "		INNER JOIN "+retsqlname("P05")+" P05 ON "
cquery += "				P05_CONTRA = P04_CONTRA "
cquery += "				AND P05_FORNEC = P04_FORNEC "
cquery += "				AND P05_LOJAFO = P04_LOJAFO "
cquery += "				AND P05_PRODUT = P04_PRODUT "
cquery += "				AND P05.D_E_L_E_T_  <> '*' "
cquery += "				AND P05_ITEM = '01' "
cquery += "		WHERE "
cquery += "			P01.D_E_L_E_T_ <> '*' "
cquery += "      AND P04_PERIOD = '"+_period+"'"
cquery += "			AND P04_FORNEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" 
cquery += "			AND P01_EMISS BETWEEN  '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"


  cQuery := ChangeQuery(cQuery)
   	
   		
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	while !eof("TRB")
		DBSELECTAREA("D01")
		  reclock("D01",.T.)
		
		  	D01->FORNECEDOR  	:= TRB->FORNECEDOR  	
		  	D01->CONTRATO  		:= TRB->CONTRATO
		  	D01->PRODUTO        := TRB->PRODUTO  		
		  	D01->TIPO_FAT   	:= TRB->TIPO_FATURA  	
		  	D01->PERCENTUAL  	:= TRB->PERCENTUAL  	
		  	D01->TIPO_PGTO      := TRB->TIPO_PAGAMENTO 
		  	D01->DOCUMENTO  	:= TRB->DOCUMENTO  	
		  	D01->PARCELAS       := alltrim(str(TRB->QTD_PARCELAS))
		  	D01->PARC_PAGAS     := alltrim(str(TRB->PARCELA_PAGAS))
		  	D01->EMISSAO  		:= stod(TRB->EMISSAO)  		
		  	D01->VALOR_TIT  	:= TRB->VALOR_TITULO  	
		  	D01->PRC_TABELA  	:= TRB->PRC_TABELA  	
		  	D01->TOTAL 		 	:= TRB->TOTAL 		 	

	
		  msunlock()
	
		dbselectarea("TRB")
		dbskip()
	
	enddo
	
	
	
	return()
	
	static function imp_plan()
	Local cArquivo    := GetTempPath()+'damanr05.xml'
	
	//Criando o objeto que irá gerar o conteúdo do Excel
//    oFWMsExcel :=  Excel():New()
    oFWMsExcel := FWMSExcel():New()
     
    //Alterando atributos
    oFWMsExcel:SetFontSize(12)                 //Tamanho Geral da Fonte
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#ffffff")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.)               //Título Negrito
    oFWMsExcel:SetTitleFrColor("#94eaff")      //Cor da Fonte do título - Azul Claro
    oFWMsExcel:SetLineFrColor("#d4d4d4")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
     
    
    oFWMsExcel:AddworkSheet("Aba Detalhes")
        //Criando a Tabela
        oFWMsExcel:AddTable("Aba Detalhes","Detalhes")
		//Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Autor",2,1)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Contrato",2,1)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Produto",2,1)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Tipo Fatura",2,1)
//        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Percentual",2,1)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Origem Valor",2,1)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Documento",2,1)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Parcelas",2,1)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Parcelas Pagas",2,1)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Emissao",2,4)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Valor Boleto",2,3)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Preco Unitario",2,3)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Total",2,3)
        DbGoTop()
 		ProcRegua(RecCount())
/* 
        While !((cAlias)->(EoF()))
			IncProc() 
            oFWMsExcel:AddRow("Aba Detalhes","Detalhes",{;
				(cAlias)->FORNECEDOR,;
				(cAlias)->CONTRATO,;
				(cAlias)->TIPO_FATURA,;
				(cAlias)->PERCENTUAL,;
				(cAlias)->TIPO_PAGAMENTO,;
				(cAlias)->DOCUMENTO,;
				(cAlias)->EMISSAO,;
				(cAlias)->VALOR_TITULO,;
				(cAlias)->PRC_TABELA,;
				(cAlias)->TOTAL;			
            })
         
           
            (cAlias)->(DbSkip())
        EndDo
  */  
  
  	DBSELECTAREA("D01")
  	DBGOTOP()

    While !(("D01")->(EoF()))
			IncProc() 
            oFWMsExcel:AddRow("Aba Detalhes","Detalhes",{;
		D01->FORNECEDOR,;
				D01->CONTRATO,;
				D01->PRODUTO,;
				D01->TIPO_FAT,;
				D01->TIPO_PGTO,;
				D01->DOCUMENTO,;
				D01->PARCELAS,;
				D01->PARC_PAGAS,;
				D01->EMISSAO,;
				D01->VALOR_TIT,;
				D01->PRC_TABELA,;
				D01->TOTAL;			
            })
         
//				D01->PERCENTUAL,;           
            ("D01")->(DbSkip())
        EndDo



    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
    
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
    
         
  	frename(cArquivo , 'c:\Temp\damanr05.xml' )
	FErase(cArquivo,/*xParam*/,.T.)
    ("D01")->(DbCloseArea())
 



Return

Static Function AjustaSX1(cPerg)
            //cGrupo    ,cOrdem	,cPergunt		,  ,  ,cVar		,cTipo ,nTamanho				 , ,,cGSC	,cValid	,cF3, cGrpSxg	,  ,cVar01    ,cDef01	,  ,  ,  ,cDef02,"","",cDef03	,"","",cDef04,"","",cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
/*	u_fsPutSx1(cPerg	,"01"	,"Autor de"    	,'','',"MV_C01"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par01",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	u_fsPutSx1(cPerg	,"02"	,"Autor ate"   	,'','',"MV_C02"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par02",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	u_fsPutSx1(cPerg	,"03"	,"Data de"     	,'','',"MV_C03"	,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par03",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	u_fsPutSx1(cPerg	,"04"	,"Data ate" 	,'','',"MV_C04" ,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par04",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
    u_fsPutSx1(cPerg	,"05"	,"Periodo" 		,'','',"MV_C05" ,"C"	,2                       ,0,,"C"	,""		,""	,""			,"","mv_par05","01"		,"","","","02"	,"","","03"		,"","","06"  ,"","","12"  ,"","","")
*/
	fsPutSx1(cPerg	,"01"	,"Autor de"    	,'','',"MV_C01"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par01",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	fsPutSx1(cPerg	,"02"	,"Autor ate"   	,'','',"MV_C02"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par02",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	fsPutSx1(cPerg	,"03"	,"Data de"     	,'','',"MV_C03"	,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par03",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	fsPutSx1(cPerg	,"04"	,"Data ate" 	,'','',"MV_C04" ,"D"	,TAMSX3("E1_EMISSAO")[1] ,0,,"G"	,""		,""	,""			,"","mv_par04",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
    fsPutSx1(cPerg	,"05"	,"Periodo" 		,'','',"MV_C05" ,"C"	,2                       ,0,,"C"	,""		,""	,""			,"","mv_par05","01"		,"","","","02"	,"","","03"		,"","","06"  ,"","","12"  ,"","","")    
    
return

static Function fsPutSx1( cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
						cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
						cF3, cGrpSxg,cPyme,;
						cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
						cDef02,cDefSpa2,cDefEng2,;
						cDef03,cDefSpa3,cDefEng3,;
						cDef04,cDefSpa4,cDefEng4,;
						cDef05,cDefSpa5,cDefEng5,;
						aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
		If !(X1_GRUPO+X1_ORDEM+X1_PERGUNT+X1_VARIAVL+X1_TIPO == cGrupo+ cOrdem+cPergunt+SPACE(Len(X1_PERGUNT)-len(cPergunt))+cVar+cTipo)
			Reclock( "SX1" , .F. )
	
			Replace X1_GRUPO   With cGrupo
			Replace X1_ORDEM   With cOrdem
			Replace X1_PERGUNT With cPergunt
			Replace X1_PERSPA With cPerSpa
			Replace X1_PERENG With cPerEng
			Replace X1_VARIAVL With cVar
			Replace X1_TIPO    With cTipo
			Replace X1_TAMANHO With nTamanho
			Replace X1_DECIMAL With nDecimal
			Replace X1_PRESEL With nPresel
			Replace X1_GSC     With cGSC
			Replace X1_VALID   With cValid
	
			Replace X1_VAR01   With cVar01
	
			Replace X1_F3      With cF3
			Replace X1_GRPSXG With cGrpSxg
	
			If Fieldpos("X1_PYME") > 0
				If cPyme != Nil
					Replace X1_PYME With cPyme
				Endif
			Endif
	
			Replace X1_CNT01   With cCnt01
			If cGSC == "C"               // Mult Escolha
				Replace X1_DEF01   With cDef01
				Replace X1_DEFSPA1 With cDefSpa1
				Replace X1_DEFENG1 With cDefEng1
	
				Replace X1_DEF02   With cDef02
				Replace X1_DEFSPA2 With cDefSpa2
				Replace X1_DEFENG2 With cDefEng2
	
				Replace X1_DEF03   With cDef03
				Replace X1_DEFSPA3 With cDefSpa3
				Replace X1_DEFENG3 With cDefEng3
	
				Replace X1_DEF04   With cDef04
				Replace X1_DEFSPA4 With cDefSpa4
				Replace X1_DEFENG4 With cDefEng4
	
				Replace X1_DEF05   With cDef05
				Replace X1_DEFSPA5 With cDefSpa5
				Replace X1_DEFENG5 With cDefEng5
			Endif
	
			Replace X1_HELP With cHelp
	
			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
			MsUnlock()
		endif
	Endif

	RestArea( aArea )

Return