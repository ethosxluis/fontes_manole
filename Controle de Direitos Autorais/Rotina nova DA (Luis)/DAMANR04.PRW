#Include "Protheus.ch"
#Include "tbiconn.ch"

/*/{Protheus.doc} DAMANR04
RELATORIO COM DETALHAMENTO DO PERIODO DO DIREITOS AUTORAIS
@type function
@author Fernando Carvalho3
3.
@since 05/05/2020
@version 1.0
/*/

User Function DAMANR04()
	Local cPerg     := "DAMANHR04"
	

	if !Pergunte(cPerg, .T.)
		Return nil
	endif
	
	Processa( {|| DAMANR0401() }, "Aguarde...", "Selecionando Registros...",.F.)

	Processa( {|| imp_plan() }, "Aguarde...", "Gerando Excel...",.F.)


Return 


static Function DAMANR0401()

	Local cAlias 		:= GetNextAlias()
    Local oFWMsExcel	:= nil
    
    _mesatual := MV_PAR03


//RAZÃO SOCIAL	FORNECEDOR	LOJA	PRODUTO VENDIDO	PERIODO DE PAG.	QUANTIDADE DE VENDAS	DEVOLUÇÃO	VALOR UNITARIO	VALOR DE VENDA	TOTAL DE PARCELAS	PARCELAS BAIXADAS NO PERIODO	PORCENTAGEM DE D.A	VALOR EM DIREITOS AUTORAIS	ADIANTAMENTO	IR	VALOR DO TITULO  (VALOR DE D.A - ADIANTAMENTO - IR=  VALOR DO TITULO)	NUMERO DO RECIBO

	 PRIVATE AARQTRB := {}
 
     AADD(AARQTRB,{"PROD"         ,"C",30,0})
     AADD(AARQTRB,{"PER"	      ,"C",02,0})
	 AADD(AARQTRB,{"QTDV"         ,"N",11,2})
	 AADD(AARQTRB,{"QTDEV"        ,"N",09,0})
     AADD(AARQTRB,{"VLRUNIT"      ,"N",14,2})
     AADD(AARQTRB,{"VLRVDA"		  ,"N",14,2})
     AADD(AARQTRB,{"VLRDA" 		  ,"N",14,2})
     AADD(AARQTRB,{"VLTIT" 		  ,"N",17,2})
    if select("D01")>0
		D01->(DBCLOSEAREA())
	endif


	 CARQTRB := CRIATRAB(AARQTRB,.T.)
	 DBUSEAREA(.T.,,CARQTRB,"D01")

//mensais	
cquery := "	select P03_PRODUT,P03_PERIOD,SUM(P03_QTDE) AS P03_QTDE,SUM(P03_QTDDEV) P03_QTDDEV,SUM(P03_PRUNIT) AS P03_PRUNIT,SUM(P03_PRCVEN) AS P03_PRCVEN,SUM(P03_VLRDA) AS P03_VLRDA,SUM(E2_VALOR) AS E2_VALOR"
cquery += "	FROM "+retsqlname("SA2")+","+retsqlname("P03")+","+retsqlname("SE2")
cquery += "	WHERE A2_COD = P03_FORNEC "
cquery += " AND A2_LOJA = P03_LOJAFO "
cquery += " AND A2_COD = E2_FORNECE "
cquery += " AND A2_LOJA = E2_LOJA "
cquery += " AND SUBSTR(E2_EMISSAO,1,6) = '"+mv_par04 + mv_par03+"'"
cquery += " AND E2_ORIGEM = 'CALC_DA' "
cquery += " AND P03_PRODUT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cquery += " AND P03_MESANO =  '"+mv_par04 + mv_par03+"'"
cquery += " AND "+retsqlname("SA2")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("P03")+".D_E_L_E_T_ <> '*' "
cquery += " AND "+retsqlname("SE2")+".D_E_L_E_T_ <> '*' "
cquery += " GROUP BY P03_PRODUT,P03_PERIOD "
cquery += " ORDER BY P03_PRODUT,P03_PERIOD "

  cQuery := ChangeQuery(cQuery)
   	
   		
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)


	while !eof("TRB")
	
	DBSELECTAREA("D01")
		  reclock("D01",.T.)
				     
		 D01->PROD      := TRB->P03_PRODUT
		 D01->PER 	    := TRB->P03_PERIOD    
		 D01->QTDV      := TRB->P03_QTDE    
		 D01->QTDEV     := TRB->P03_QTDDEV    
		 D01->VLRUNIT   := TRB->P03_PRUNIT    
		 D01->VLRVDA 	:= TRB->P03_PRCVEN    
		 D01->VLRDA  	:= TRB->P03_VLRDA     
		 D01->VLTIT  	:= TRB->E2_VALOR  
    
		  msunlock()
	
		dbselectarea("TRB")
		dbskip()
	
	enddo
	
	
	
	return()
	
	static function imp_plan()
	Local cArquivo    := GetTempPath()+'damanr04.xml'
	
	//Criando o objeto que irá gerar o conteúdo do Excel
//    oFWMsExcel :=  Excel():New()
    oFWMsExcel := FWMSExcel():New()
     
    //Alterando atributos
    oFWMsExcel:SetFontSize(12)                 //Tamanho Geral da Fonte
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#000666")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.)               //Título Negrito
    oFWMsExcel:SetTitleFrColor("#94eaff")      //Cor da Fonte do título - Azul Claro
    oFWMsExcel:SetLineFrColor("#d4d4d4")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#ffffff")      //Cor da Fonte da segunda linha - Branco
     


//RAZÃO SOCIAL	FORNECEDOR	LOJA	PRODUTO VENDIDO	PERIODO DE PAG.	QUANTIDADE DE VENDAS	DEVOLUÇÃO	VALOR UNITARIO	VALOR DE VENDA	TOTAL DE PARCELAS	PARCELAS BAIXADAS NO PERIODO	
//PORCENTAGEM DE D.A	VALOR EM DIREITOS AUTORAIS	ADIANTAMENTO	IR	VALOR DO TITULO  (VALOR DE D.A - ADIANTAMENTO - IR=  VALOR DO TITULO)	NUMERO DO RECIBO
    
    oFWMsExcel:AddworkSheet("Aba Detalhes")
        //Criando a Tabela
        oFWMsExcel:AddTable("Aba Detalhes","Detalhes")
		//Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","PRODUTO VENDIDO",2,1)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","PERIODO DE PAG.",2,1)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","QUANTIDADE DE VENDAS",2,1)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","DEVOLUÇÃO",2,1)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","VALOR UNITÁRIO",2,3)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","VALOR DE VENDA",2,3)
		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","VALOR EM DIREITOS AUTORAIS",2,3)
        oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","VALOR DO TÍTULO",2,3)

        DbGoTop()
 		ProcRegua(RecCount())
  
  	DBSELECTAREA("D01")
  	DBGOTOP()

    While !(("D01")->(EoF()))
			IncProc() 
            oFWMsExcel:AddRow("Aba Detalhes","Detalhes",{;
            	D01->PROD,;  
				D01->PER,; 	
				D01->QTDV,;  
				D01->QTDEV,; 
				D01->VLRUNIT,;
				D01->VLRVDA,;
				D01->VLRDA,;
				D01->VLTIT; 
            })
         
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
     
    
         
  	frename(cArquivo , 'c:\Temp\damanr04.xml' )
	FErase(cArquivo,/*xParam*/,.T.)
    ("D01")->(DbCloseArea())
 



Return

Static Function AjustaSX1(cPerg)
            //cGrupo    ,cOrdem	,cPergunt		,  ,  ,cVar		,cTipo ,nTamanho				 , ,,cGSC	,cValid	,cF3, cGrpSxg	,  ,cVar01    ,cDef01	,  ,  ,  ,cDef02,"","",cDef03	,"","",cDef04,"","",cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	fsPutSx1(cPerg	,"01"	,"Produto de"    	,'','',"MV_C01"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par01",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
	fsPutSx1(cPerg	,"02"	,"Produto ate"   	,'','',"MV_C02"	,"C"	,TAMSX3("P04_FORNEC")[1] ,0,,"G"	,""		,""	,""			,"","mv_par02",""  		,"","","",""	,"","",""  		,"","",""	 ,"",""       ,"","","")
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

/*
static function num_parc(_serie,_doc,_cliente,_lojacli)
 
 
 cquery := " "
  cquery := " SELECT COUNT(*) AS QTDPARC  FROM "+retsqlname("SE1")+" WHERE E1_PREFIXO = '"+_serie+"' AND E1_NUM = '"+_doc+"'  AND E1_CLIENTE = '"+_cliente+"' AND E1_LOJA = '"+_lojacli+"' AND D_E_L_E_T_ <> '*' "

 	if select("TRZ")>0
		TRZ->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRZ",.F.,.T.)
	
	_qtdparc := TRZ->QTDPARC
	
	return(_qtdparc)

	
	
static function num_parcpg(_serie,_doc,_cliente,_lojacli)
*/
 
 
 cquery := " "
  cquery := " SELECT COUNT(*) AS QTDPARC  FROM "+retsqlname("SE1")+" WHERE E1_PREFIXO = '"+_serie+"' AND E1_NUM = '"+_doc+"'  AND E1_CLIENTE = '"+_cliente+"' AND E1_LOJA = '"+_lojacli+"' AND D_E_L_E_T_ <> '*' AND E1_BAIXA <> ' ' "

 	if select("TRZ")>0
		TRZ->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRZ",.F.,.T.)
	
	_qtdparc := TRZ->QTDPARC
	
	return(_qtdparc)
	