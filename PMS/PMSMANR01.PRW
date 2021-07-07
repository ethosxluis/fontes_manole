#Include "Protheus.ch"
#Include "tbiconn.ch"

/*/{Protheus.doc} DAMANR01
RELATORIO COM DETALHAMENTO DO PERIODO DO DIREITOS AUTORAIS
@type function
@author Luis
@since 09/10/2020
@version 1.0
/*/

User Function PMSMANR01()
	PRIVATE cPerg     := "PMSMANR01"
	PRIVATE _total    := 0
	PRIVATE _totedt   := 0
	if !Pergunte(cPerg, .T.)
		Return nil
	endif

	
//	   AjustaSX1(cPerg)

	/*if !Pergunte(cPerg, .T.)
		Return nil
	endif*/




//	Processa({|| U_LE_ARQS() },"Lendo os arquivos...","Aguarde.")
	
	Processa( {|| PMSMANR0101() }, "Aguarde...", "Selecionando Registros...",.F.)

	Processa( {|| imp_plan() }, "Aguarde...", "Gerando Excel...",.F.)


 
Return 


static Function PMSMANR0101()



	Local cAlias 		:=  GetNextAlias()
    Local oFWMsExcel	:=  nil
     
     
 

	 PRIVATE AARQTRB := {}
	 PRIVATE BARQTRB := {}
 	 PRIVATE EARQTRB := {}
	 PRIVATE JARQTRB := {}

// AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,AFG_NUMSC,C7_NUM,D1_DOC,D1_COD,D1_DESC,D1_ITEM,D1_TOTAL,E2_VALOR

     AADD(AARQTRB,{"PROJETO" 			,"C",10,0})
     AADD(AARQTRB,{"DESCRIPRO" 			,"C",90,0})
     AADD(AARQTRB,{"TAREFA" 			,"C",12,0})     
	 AADD(AARQTRB,{"DESCRIEDT"    		,"C",90,0})     
	 AADD(AARQTRB,{"DESCRITAR"    		,"C",90,0})
     AADD(AARQTRB,{"PRODUTO"     		,"C",15,0})
     AADD(AARQTRB,{"DESCRI"     		,"C",30,0})
     AADD(AARQTRB,{"QUANT" 				,"N",11,2})
     AADD(AARQTRB,{"CUSTO"      		,"N",16,2})
     AADD(AARQTRB,{"TOTAL"      		,"N",16,2})
	 AADD(AARQTRB,{"DESPREC"            ,"C",01,0})
	 AADD(AARQTRB,{"PARCEIR"            ,"C",20,0})
	 AADD(AARQTRB,{"PERCENT"            ,"N",05,2})	 			

   
	if select("D01")>0
		D01->(DBCLOSEAREA())
	endif


	 CARQTRB := CRIATRAB(AARQTRB,.T.)
	 DBUSEAREA(.T.,,CARQTRB,"D01")
     INDEX ON PROJETO+TAREFA + DESPREC TO &CARQTRB

     AADD(BARQTRB,{"QUANT" 				,"N",11,2})
     AADD(BARQTRB,{"TOTAL"      		,"N",16,2})

	if select("D02")>0
		D02->(DBCLOSEAREA())
	endif


	 DARQTRB := CRIATRAB(BARQTRB,.T.)
	 DBUSEAREA(.T.,,DARQTRB,"D02")


     AADD(EARQTRB,{"TOTAL"      		,"N",16,2})


	if select("D03")>0
		D03->(DBCLOSEAREA())
	endif


	 FARQTRB := CRIATRAB(EARQTRB,.T.)
	 DBUSEAREA(.T.,,FARQTRB,"D03")





     AADD(JARQTRB,{"TES"          		,"C",03,0})
     AADD(JARQTRB,{"QUANT"       		,"N",16,2})
     AADD(JARQTRB,{"TOTAL"      		,"N",16,2})
     AADD(JARQTRB,{"PGTO"        		,"C",15,0})


	if select("D04")>0
		D04->(DBCLOSEAREA())
	endif


	 KARQTRB := CRIATRAB(JARQTRB,.T.)
	 DBUSEAREA(.T.,,KARQTRB,"D04")







	le_arqs()



return()



static function le_arqs(_period,_dtini,_dtfim)

/*	
cquery := " SELECT AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,AFG_NUMSC,C7_NUM,D1_DOC,D1_COD,C7_DESCRI,D1_ITEM,D1_QUANT,D1_VUNIT,D1_TOTAL "
//cquery := " SELECT AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,C7_NUM,D1_DOC,D1_COD,C7_DESCRI,D1_ITEM,D1_QUANT,D1_VUNIT,D1_TOTAL
cquery += " FROM "+retsqlname("AF8")+","+retsqlname("AF9")+","+retsqlname("AFG")+","+retsqlname("SC7")+","+retsqlname("SD1")+","+retsqlname("SE2")+","+retsqlname("SC1")+ " "
//cquery += "  FROM "+retsqlname("AF8")+","+retsqlname("AF9")+","+retsqlname("SC7")+","+retsqlname("SE2")+","+retsqlname("SD1")+ " "
cquery += " WHERE AF8_PROJET = AF9_PROJET "
cquery += " AND AF9_PROJET = AFG_PROJET "
cquery += " AND AF9_TAREFA = AFG_TAREFA "
cquery += " AND AFG_NUMSC = C1_NUM "
cquery += " AND AFG_ITEMSC = C1_ITEM "
cquery += " AND C7_NUMSC = C1_NUM "
cquery += " AND C7_ITEMSC = C1_ITEM "
cquery += " AND D1_PEDIDO = C7_NUM "
cquery += " AND D1_ITEMPC = C7_ITEM "
cquery += " AND E2_NUM = D1_DOC "
cquery += " AND AF8_PROJET = '"+MV_PAR01+"'"
cquery += " AND "+retsqlname("AF8")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("AF9")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("AFG")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("SC7")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("SD1")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("SE2")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("SC1")+".D_E_L_E_T_ <> '*' "
cquery += " GROUP BY  AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,AFG_NUMSC,C7_NUM,D1_DOC,D1_COD,C7_DESCRI,D1_ITEM,D1_QUANT,D1_VUNIT,D1_TOTAL "
//cquery += " GROUP BY  AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,C7_NUM,D1_DOC,D1_COD,C7_DESCRI,D1_ITEM,D1_QUANT,D1_VUNIT,D1_TOTAL  "
cquery += " order by AF9_TAREFA "
*/

cquery := " "
  cquery := " select AF8_FILIAL,AF8_PROJET,AF8_DESCRI,AFC_EDT,AFC_DESCRI,AF9_TAREFA,AF9_DESCRI,AFA_PRODUT,B1_DESC,AFA_QUANT,AFA_CUSTD,AF8_XPARC,AF8_XLJPAR,AF8_XPORC " // ,A2_NREDUZ 
  cquery += " from AF8010,AF9010,AFA010,SB1010,AFC010 " //,SA2010 "
    cquery += " WHERE AF8_PROJET = '"+mv_par01+"' "
  cquery += " AND AF8_PROJET = AFC_PROJET "
  cquery += " AND AF8_REVISA = AFC_REVISA "
//  cquery += " AND SUBSTR(AFC_EDT,1,2)    = SUBSTR(AF9_TAREFA,1,2) "
  cquery += " AND   ((SUBSTR(AF9_TAREFA,3,1) = '.'  AND (SUBSTR(AFC_EDT,2,1)) = (SUBSTR(AF9_TAREFA,2,1))) OR (SUBSTR(AF9_TAREFA,2,1) = '.'  AND (SUBSTR(AFC_EDT,1,1)) = (SUBSTR(AF9_TAREFA,1,1)))) "
  cquery += " AND AF8_PROJET = AF9_PROJET "
  cquery += " AND AF8_REVISA = AF9_REVISA "
  cquery += " AND AF9_PROJET = AFA_PROJET "
  cquery += " AND AF9_REVISA = AFA_REVISA "
  cquery += " AND AF9_TAREFA = AFA_TAREFA "
  cquery += " AND AFA_FILIAL = B1_FILIAL "
  cquery += " AND AFA_PRODUT = B1_COD "
  cquery += " AND AF9_FATURA <> '1' "
  cquery += " AND AFC_EDT <> AFC_PROJET "
  //cquery += " and AF8_XPARC = A2_COD "
  //cquery += " and AF8_XLJPAR = A2_LOJA "
  cquery += " AND AF8010.D_E_L_E_T_ <> '*' "
  cquery += " AND AF9010.D_E_L_E_T_ <> '*' "
  cquery += " AND AFA010.D_E_L_E_T_ <> '*' "
  cquery += " AND AFC010.D_E_L_E_T_ <> '*' "
  //cquery += " AND SA2010.D_E_L_E_T_ <> '*' "

  cQuery := ChangeQuery(cQuery)
   	
   		
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	while !eof("TRB")
		DBSELECTAREA("D01")
		  reclock("D01",.T.)
		  	D01->PROJETO 			:= TRB->AF8_PROJET
		  	D01->DESCRIPRO      	:= TRB->AF8_DESCRI
		  	D01->TAREFA 		    := TRB->AF9_TAREFA
		  	D01->DESCRITAR      	:= TRB->AF9_DESCRI
		  	D01->DESCRIEDT			:= TRB->AFC_DESCRI
			D01->DESCRI             := TRB->B1_DESC
			D01->QUANT              := TRB->AFA_QUANT
			D01->CUSTO              := TRB->AFA_CUSTD
			D01->TOTAL				:= TRB->AFA_QUANT*TRB->AFA_CUSTD
			D01->DESPREC            :=  "D"
			D01->PARCEIR            := IIF(!empty(TRB->AF8_XPARC),cod_for(TRB->AF8_XPARC,TRB->AF8_XLJPAR)," ")
			D01->PERCENT            := TRB->AF8_XPORC
		  msunlock()
	
		dbselectarea("TRB")
		dbskip()
	
	enddo
	
	dquery := " "
	/* dquery := "SELECT D2_COD,B1_DESC,AF9_PROJET,AF9_TAREFA,SUM(D2_QUANT) AS QUANT,SUM(D2_TOTAL) AS TOTAL "
	 dquery += " from "+retsqlname("SD2")+","+retsqlname("AF9")+","+retsqlname("SB1")
	 dquery += " WHERE D2_COD = B1_COD "
	 dquery += " AND D2_COD = AF9_PRODFA "  
	 dquery += " AND AF9_PROJET = '"+mv_par01+"'"
	 dquery += " AND "+retsqlname("SD2")+".D_E_L_E_T_ <> '*'"
	 dquery += " AND "+retsqlname("SB1")+".D_E_L_E_T_ <> '*'"
	 dquery += " AND "+retsqlname("AF9")+".D_E_L_E_T_ <> '*'"
	 
	 dquery += " GROUP BY D2_COD,B1_DESC,AF9_PROJET,AF9_TAREFA "*/

	dquery := " select SUM(D2_QUANT) QUANT,SUM(D2_TOTAL) TOTAL "
	dquery += " from SD2010 "
	dquery += " WHERE D2_COD = '"+mv_par01+"' "
	dquery += " AND D2_TES IN(SELECT F4_CODIGO FROM SF4010 WHERE F4_DUPLIC = 'S' AND D_E_L_E_T_ <> '*') "
	dquery += " AND D_E_L_E_T_ <> '*' "

	 
	 
	 dQuery := ChangeQuery(dQuery)
   		
	 if select("TRC")>0
		TRC->(DBCLOSEAREA())
	 endif

	 dbUseArea( .T.,"TOPCONN",TCGENQRY(,,dQuery),"TRC",.F.,.T.)
	
		while !eof("TRC")
		DBSELECTAREA("D02")
		  reclock("D02",.T.) 
		  	D02->QUANT            := TRC->QUANT
		  	D02->TOTAL            := TRC->TOTAL
	
		  msunlock()
		dbselectarea("TRC")
		dbskip()
	   
	   enddo

	

equery := " "
equery += " SELECT SUM(E1_VALOR) TOTAL "
equery += " FROM SE1010 SE1 "
equery += " INNER JOIN SD2010 SD2 ON(SD2.D2_CLIENTE = E1_CLIENTE AND D2_LOJA = E1_LOJA AND D2_SERIE = E1_PREFIXO AND D2_DOC = E1_NUM AND D2_COD = '"+mv_par01+"' AND  SD2.D_E_L_E_T_ <> '*') "
equery += " WHERE  E1_SALDO = 0 "
equery += " AND E1_BAIXA <> ' ' "
equery += " AND SE1.D_E_L_E_T_ <> '*' "


eQuery := ChangeQuery(eQuery)
   		
	 if select("TRD")>0
		TRD->(DBCLOSEAREA())
	 endif

	 dbUseArea( .T.,"TOPCONN",TCGENQRY(,,eQuery),"TRD",.F.,.T.)
	
		while !eof("TRD")
		DBSELECTAREA("D03")
		  reclock("D03",.T.) 
		  	D03->TOTAL            := TRD->TOTAL
	
		  msunlock()
		dbselectarea("TRD")
		dbskip()
	   
	   enddo
 m    

	cquery := " "
	  cquery := " SELECT D2_TES, SUM(D2_TOTAL) AS TOTAL,SUM(D2_QUANT) AS QUANT "
	  cquery += " FROM SD2010,SF4010 "
	  cquery += " WHERE D2_FILIAL = F4_FILIAL "
	  cquery += " AND D2_COD = '"+mv_par01+"'"
	  cquery += " AND F4_DUPLIC = 'S' "
	  cquery += " AND D2_TES = F4_CODIGO "
	  cquery += " AND SD2010.D_E_L_E_T_ <> '*' "
	  cquery += " AND SF4010.D_E_L_E_T_ <> '*' "
	  cquery += " GROUP BY D2_TES "

	  cQuery := ChangeQuery(cQuery)


	 if select("TRE")>0
		TRE->(DBCLOSEAREA())
	 endif

	 dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRE",.F.,.T.)
	
		while !eof("TRE")

			if TRE->D2_TES == "503" .OR. TRE->D2_TES = '531' .OR. TRE->D2_TES = '534'
				RECLOCK("D04",.T.)	
					 D04->TES   := TRE->D2_TES
					 D04->PGTO  := "BOLETO"
					 D04->QUANT := TRE->QUANT
				 	 D04->TOTAL := TRE->TOTAL
				MSUNLOCK()
		    elseif TRE->D2_TES == '535' .OR. TRE->D2_TES == '564' .OR. TRE->D2_TES == '523'
				RECLOCK("D04",.T.)	
					 D04->TES   := TRE->D2_TES
					 D04->PGTO  := "PIX"
					 D04->QUANT := TRE->QUANT
					 D04->TOTAL := TRE->TOTAL
				MSUNLOCK()
		    elseif TRE->D2_TES == '504'
				RECLOCK("D04",.T.)	
					 D04->TES   := TRE->D2_TES
				 	 D04->PGTO  := "CARTAO"
					 D04->QUANT := TRE->QUANT
					 D04->TOTAL := TRE->TOTAL
				MSUNLOCK()
			endif

			DBSELECTAREA("TRE")
			DBSKIP()

		enddo



	return()



	static function imp_plan()
	Local cArquivo    := GetTempPath()+'PMSMANR01.xml'
	
	DBSELECTAREA("D01")
	_curso := D01->DESCRIPRO
	_parca := D01->PARCEIR
	_perc  := D01->PERCENT
	_percman := 100 - _perc


	//Criando o objeto que irá gerar o conteúdo do Excel
//    oFWMsExcel :=  Excel():New()
    oFWMsExcel := FWMSExcel():New()
     
    //Alterando atributos
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
//    oFWMsExcel:SetBgGeneralColor("#000000")    //Cor de Fundo Geral
 /*   oFWMsExcel:SetBgGeneralColor("#ffffff")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.)               //Título Negrito
    oFWMsExcel:SetTitleFrColor("#000000")      //Cor da Fonte do título - Azul Claro
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
   */  
    
    oFWMsExcel:AddworkSheet("Custos")
    oFWMsExcel:AddworkSheet("DRE")
    
	Detalhes := "PLANILHA DE CUSTOS"+ Chr(13) + Chr(10) +"DESPESAS PARA CONTEÚDO DA PLATAFORMA"
	DetDRE   := "PRESTAÇÃO DE CONTAS 3 - CURSO:"+" "+	_curso 
        //Criando a Tabela
//        oFWMsExcel:AddTable("Custos","XXXXX")
//		oFWMsExcel:AddTable("Custos","XXXX")        
//        oFWMsExcel:AddColumn("Custos","XXXX","XXXXX",2,1)




		oFWMsExcel:AddTable("Custos",Detalhes)
		//Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
		oFWMsExcel:AddTable("DRE",DetDRE)

        

//        oFWMsExcel:AddColumn("Custos",Detalhes,"Projeto",2,1)
        oFWMsExcel:AddColumn("Custos",Detalhes,"Descrição",1,1)
        oFWMsExcel:AddColumn("Custos",Detalhes,"Quant",1,1)
        oFWMsExcel:AddColumn("Custos",Detalhes,"Valor Total",1,3)
        oFWMsExcel:AddColumn("Custos",Detalhes,"Valor Unit",1,3)
		oFWMsExcel:AddColumn("Custos",Detalhes,"CUSTO REAL GASTO",2,1)
		oFWMsExcel:AddColumn("Custos",Detalhes,"VALOR DISPONIVEL",2,3)	
        oFWMsExcel:AddColumn("Custos",Detalhes,"OBSERVAÇÕES",2,3)

//		oFWMsExcel:AddColumn("DRE",DetDRE,"RECEITAS/DESPESAS",1,1)	
		oFWMsExcel:AddColumn("DRE",DetDRE,"DESPESAS/GASTOS",1,1)	
        oFWMsExcel:AddColumn("DRE",DetDRE,"",1,2)



//        oFWMsExcel:AddColumn("Custos",Detalhes,"",2,3)
//        oFWMsExcel:AddColumn("Custos",Detalhes,"",2,3)
//        oFWMsExcel:AddColumn("Custos",Detalhes,"",2,3)
//		oFWMsExcel:AddColumn("Custos",Detalhes,"",2,1)
//		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Produto",2,1)
//		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Item",2,4)

	oFWMsExcel:SetTitleBold(.T.)               //Define se a fonte terá a configuração "Negrito" no estilo do Título
	oFWMsExcel:SetHeaderBold(.T.)



        DbGoTop()
 		ProcRegua(RecCount())
 
  
  	DBSELECTAREA("D01")
  	DBGOTOP()

			IncProc() 
            oFWMsExcel:AddRow("Custos",Detalhes,{;
            D01->DESCRIPRO,; 	
            " ",;
            " ",;		
            " ",;  
            " ",;	
            " ",; 	
            " "; 
            })



		_taratu := " "
		_tarant := " "
		_prjatu := " "
		_edtatu := " "
		_prjant := " "
		_edtant := " "

    While !(("D01")->(EoF()))

    IF D01->DESPREC ==  "D"
        _taratu := alltrim(D01->TAREFA)
        _prjatu := alltrim(D01->PROJETO)
		_edtatu := alltrim(D01->DESCRIEDT)
        IF alltrim(_edtatu) <> " " .and. alltrim(_edtatu) <> alltrim(_edtant)
			
			IncProc() 
            oFWMsExcel:AddRow("Custos",Detalhes,{;
            "  ",;
            "  ",; 
            "  ",;		
            "  ",; 
            " ",;
            " ",;
            " ";		
            })


			IncProc() 
            oFWMsExcel:AddRow("Custos",Detalhes,{;
            D01->DESCRIEDT,; 	
            " ",;
            " ",;		
            " ",;  
            " ",;	
            " ",; 	
            " "; 
            })

			IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            _edtant,;
            _totedt; 
            })


		_totedt := 0


        ENDIF





    	if _taratu <> " " .and. _taratu <> _tarant
			IncProc() 
            oFWMsExcel:AddRow("Custos",Detalhes,{;
            D01->DESCRITAR,;
            D01->QUANT,; 	
            D01->TOTAL,;		
            D01->CUSTO,;  
            " ",;	
            D01->TOTAL,; 	
            " "; 
            })
         
        endif
			  _edtant := D01->DESCRIEDT
//            _tarant := D01->TAREFA
//            _prjant := D01->PROJETO
	          _total  += D01->TOTAL
			  _totedt += D01->TOTAL
          	ENDIF
            ("D01")->(DbSkip())

        EndDo

			IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            _edtatu,;
            _totedt; 
            })

			IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
         	"T O T A L",;
            _total; 
            })





		IncProc() 
            oFWMsExcel:AddRow("Custos",Detalhes,{;
            " ",;
            " ",; 
            "  ",;		
            "  ",; 
            "  ",;
            "  ",;
            " ";		
            })






		IncProc() 
            oFWMsExcel:AddRow("Custos",Detalhes,{;
            "SUB-TOTAL(plataforma+academicas)  ",;
            "  ",; 
            _total,;		
            "  ",; 
            "  ",;
            "  ",;
            " ";		
            })

  	DBSELECTAREA("D01")
  	DBGOTOP()


	DBSELECTAREA("D02")

		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "",;
            ""; 
            })

		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "",;
            ""; 
            })

		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "",;
            ""; 
            })

		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "",;
            ""; 
            })





		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "RECEITAS/DESPESAS",;
            ""; 
            })


		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "Quantidade de alunos Pagantes",;
            D02->QUANT; 
            })

			IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "Total do Faturamento Bruto",;
            D02->TOTAL; 
            })


	DBSELECTAREA("D03")
		IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "[1]Valores Recebidos dos Parcelamento dos Cartões",;
            D03->TOTAL; 
            })



	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "[2](-) Custos)",;
            _total; 
            })


	DBSELECTAREA("D02")			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "[3](-) Impostos sobre o faturamento bruto ",;
            (D02->TOTAL)*(13.34/100); 
            })			


	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            " ",;
            " "; 
            })


	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "Total líquido (saldo = 1-2-3-4)",;
            (D03->TOTAL - _total - (D02->TOTAL)*(13.34/100)); 
            })			



	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })			


	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "DIVISÃO DA RECEITA  ",;
            "  "; 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            _parca + "    %     ",;
            _perc; 
            })			


	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "MANOLE     %     ",;
            100 - _perc; 
            })			


	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "TOTAL  ",;
            "  "; 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })			
	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            _parca,;
            ((D03->TOTAL - _total - (D02->TOTAL)*(13.34/100))*_perc/100); 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "MANOLE",;
            ((D03->TOTAL - _total - (D02->TOTAL)*(13.34/100))*_percman/100); 
            })			

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })		

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })		

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })		

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })		

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "  ",;
            "  "; 
            })		

	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "Detalhe das despesas financeiras",;
            "  "; 
            })		



	DBSELECTAREA("D04")
	DBGOTOP()

	While !eof()


	IncProc() 
            oFWMsExcel:AddRow("DRE",DetDRE,{;
            "Pagamento em "+ALLTRIM(D04->PGTO)+"("+alltrim(STR(D04->QUANT))+"alunos -  R$ "+ALLTRIM(str(D04->TOTAL))+")",;
            "  "; 
            })	

	dbskip()

	enddo











    While !(("D01")->(EoF()))
    	IF D01->DESPREC ==  "R"
		IncProc() 
            oFWMsExcel:AddRow("Principios","Detalhes",{;
            "  ",;		
            "  ",;
            "  ",; 
            "  ",;		
            "  ",; 
            "Quantidade de Alunos",;
            D01->QUANT,;
            "  ",; 
            "Faturamento",; 
            D01->VALOR_NOTA,;	
            "  ",; 	
            " ";		
            })



         ENDIF

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
     
    
         
  	frename(cArquivo , 'c:\Temp\PMSMANR01.xml' )
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


 
 //static function cod_for(TRB->AF8_XPARC,TRB->AF8_XLJPAR)
 static function cod_for()

 _cod := TRB->AF8_XPARC
 _loj := TRB->AF8_XLJPAR
 
 
 cquery := " "
  cquery := " SELECT A2_NREDUZ  FROM "+retsqlname("SA2")+" WHERE A2_COD = '"+_cod+"' AND A2_LOJA = '"+_loj+"'  AND D_E_L_E_T_ <> '*' "

 	if select("TRZ")>0
		TRZ->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRZ",.F.,.T.)
	
	_nreduz := TRZ->A2_NREDUZ
	
	return(_nreduz)


  