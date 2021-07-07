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

// AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,AFG_NUMSC,C7_NUM,D1_DOC,D1_COD,D1_DESC,D1_ITEM,D1_TOTAL,E2_VALOR

     AADD(AARQTRB,{"PROJETO" 			,"C",10,0})
     AADD(AARQTRB,{"DESCRIPRO" 			,"C",90,0})
     AADD(AARQTRB,{"TAREFA" 			,"C",12,0})     
     AADD(AARQTRB,{"DESCRITAR"    		,"C",90,0})
	 AADD(AARQTRB,{"SOCICIT" 			,"C",06,0})
	 AADD(AARQTRB,{"PEDIDO" 	        ,"C",06,0})
     AADD(AARQTRB,{"NOTA" 				,"C",09,0})
     AADD(AARQTRB,{"PRODUTO"     		,"C",15,0})
     AADD(AARQTRB,{"DESCRI"     		,"C",30,0})
     AADD(AARQTRB,{"ITEM" 				,"C",04,0})
     AADD(AARQTRB,{"QUANT" 				,"N",11,2})
     AADD(AARQTRB,{"VALOR_ITEM"  		,"N",14,2})
     AADD(AARQTRB,{"VALOR_NOTA" 		,"N",16,2})
     AADD(AARQTRB,{"TOTAL"      		,"N",16,2})
     AADD(AARQTRB,{"DESPREC"     		,"C",01,0})
     

   
	if select("D01")>0
		D01->(DBCLOSEAREA())
	endif


	 CARQTRB := CRIATRAB(AARQTRB,.T.)
	 DBUSEAREA(.T.,,CARQTRB,"D01")
     INDEX ON PROJETO+TAREFA + DESPREC TO &CARQTRB
	


//	le_arqs(_period,_dtini,_dtfim)
	le_arqs()



return()



static function le_arqs(_period,_dtini,_dtfim)

	
cquery := " SELECT AF8_PROJET,AF8_DESCRI,AF9_TAREFA,AF9_DESCRI,AFG_NUMSC,C7_NUM,D1_DOC,D1_COD,C7_DESCRI,D1_ITEM,D1_QUANT,D1_VUNIT,D1_TOTAL "
cquery += " FROM "+retsqlname("AF8")+","+retsqlname("AF9")+","+retsqlname("AFG")+","+retsqlname("SC7")+","+retsqlname("SD1")+","+retsqlname("SE2")+","+retsqlname("SC1")+ " "
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
cquery += " order by AF9_TAREFA "

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
		  	D01->SOCICIT			:= TRB->AFG_NUMSC
		  	D01->PEDIDO 	    	:= TRB->C7_NUM
		  	D01->NOTA				:= TRB->D1_DOC
		  	D01->PRODUTO        	:= TRB->D1_COD
		  	D01->DESCRI     		:= TRB->C7_DESCRI
		  	D01->ITEM				:= TRB->D1_ITEM
		  	D01->QUANT            := TRB->D1_QUANT
		  	D01->VALOR_ITEM     	:= TRB->D1_VUNIT
		  	D01->VALOR_NOTA     	:= TRB->D1_TOTAL		
		  	D01->TOTAL            := D01->TOTAL + TRB->D1_TOTAL
		  	D01->DESPREC          := "D" 	
		  msunlock()
	
		dbselectarea("TRB")
		dbskip()
	
	enddo
	
	dquery := " "
	 dquery := "SELECT D2_COD,B1_DESC,AF9_PROJET,AF9_TAREFA,SUM(D2_QUANT) AS QUANT,SUM(D2_TOTAL) AS TOTAL "
	 dquery += " from "+retsqlname("SD2")+","+retsqlname("AF9")+","+retsqlname("SB1")
	 dquery += " WHERE D2_COD = B1_COD "
	 dquery += " AND D2_COD = AF9_PRODFA "  
	 dquery += " AND AF9_PROJET = '"+mv_par01+"'"
	 dquery += " AND "+retsqlname("SD2")+".D_E_L_E_T_ <> '*'"
	 dquery += " AND "+retsqlname("SB1")+".D_E_L_E_T_ <> '*'"
	 dquery += " AND "+retsqlname("AF9")+".D_E_L_E_T_ <> '*'"
	 
	 dquery += " GROUP BY D2_COD,B1_DESC,AF9_PROJET,AF9_TAREFA "
	 
	 
	 dQuery := ChangeQuery(dQuery)
   		
	 if select("TRC")>0
		TRC->(DBCLOSEAREA())
	 endif

	 dbUseArea( .T.,"TOPCONN",TCGENQRY(,,dQuery),"TRC",.F.,.T.)
	
		while !eof("TRC")
		DBSELECTAREA("D01")
		  reclock("D01",.T.) 
		  	D01->PROJETO            := TRC->AF9_PROJET
		  	D01->TAREFA              := TRC->AF9_TAREFA
		  	D01->PRODUTO        	:= TRC->D2_COD
		  	D01->QUANT              := TRC->QUANT
		  	D01->VALOR_NOTA     	:= TRC->TOTAL		
		  	D01->DESPREC            := "R" 	
	
		  msunlock()
		dbselectarea("TRC")
		dbskip()
	   
	   enddo
	return()
	
	static function imp_plan()
	Local cArquivo    := GetTempPath()+'PMSMANR01.xml'
	
	//Criando o objeto que irá gerar o conteúdo do Excel
//    oFWMsExcel :=  Excel():New()
    oFWMsExcel := FWMSExcel():New()
     
    //Alterando atributos
    oFWMsExcel:SetFontSize(12)                 //Tamanho Geral da Fonte
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
//    oFWMsExcel:SetBgGeneralColor("#000000")    //Cor de Fundo Geral
 /*   oFWMsExcel:SetBgGeneralColor("#ffffff")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.)               //Título Negrito
    oFWMsExcel:SetTitleFrColor("#000000")      //Cor da Fonte do título - Azul Claro
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
   */  
    
    oFWMsExcel:AddworkSheet("Principios")
    oFWMsExcel:AddworkSheet("DRE Princ./Proj" + mv_par01)
    
        //Criando a Tabela
        oFWMsExcel:AddTable("Principios","Detalhes")
		//Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
        oFWMsExcel:AddColumn("Principios","Detalhes","Projeto",2,1)
        oFWMsExcel:AddColumn("Principios","Detalhes","Curso",2,1)
        oFWMsExcel:AddColumn("Principios","Detalhes","Coordenador",2,1)
        oFWMsExcel:AddColumn("Principios","Detalhes","Tarefa",2,1)
        oFWMsExcel:AddColumn("Principios","Detalhes","Descrição",2,1)
		oFWMsExcel:AddColumn("Principios","Detalhes","Produto",2,1)
		oFWMsExcel:AddColumn("Principios","Detalhes","Quant.",2,2)	
        oFWMsExcel:AddColumn("Principios","Detalhes","Valor Total",2,3)
        oFWMsExcel:AddColumn("Principios","Detalhes","Valor Unit.",2,3)
        oFWMsExcel:AddColumn("Principios","Detalhes","CUSTO REAL GASTO",2,3)
        oFWMsExcel:AddColumn("Principios","Detalhes","VALOR DISPONIVEL",2,3)
		oFWMsExcel:AddColumn("Principios","Detalhes","OBSERVAÇÕES",2,1)
//		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Produto",2,1)
//		oFWMsExcel:AddColumn("Aba Detalhes","Detalhes","Item",2,4)

        DbGoTop()
 		ProcRegua(RecCount())
 
  
  	DBSELECTAREA("D01")
  	DBGOTOP()



_taratu := " "
_tarant := " "
_prjatu := " "
_prjant := " "

    While !(("D01")->(EoF()))
    IF D01->DESPREC ==  "D"
        _taratu := D01->TAREFA
        _prjatu := D01->PROJETO
        IF _prjatu <> " " .and. _prjatu <> _prjant
			IncProc() 
            oFWMsExcel:AddRow("Principios","Detalhes",{;
            D01->PROJETO,;	
            D01->DESCRIPRO,; 	
            " ",;
            " ",;		
            " ",;  
            " ",;	
            " ",; 	
            " ",;		
            " ",;    
            " ",;     
            " ",; 
            " "; 
            })
        ENDIF
    	if _taratu <> " " .and. _taratu <> _tarant
			IncProc() 
            oFWMsExcel:AddRow("Principios","Detalhes",{;
            " ",;	
            " ",;
            " ",; 	
            D01->TAREFA,;		
            D01->DESCRITAR,;  
            " ",;	
            " ",; 	
            " ",;		
            " ",;    
            " ",;     
            " ",; 
            " "; 
            })
         
        endif
//            D01->TAREFA,;  

		IncProc() 
            oFWMsExcel:AddRow("Principios","Detalhes",{;
            "  ",;		
            "  ",;
            "  ",; 
            "  ",;		
            "  ",; 
            D01->DESCRI,;
            D01->QUANT,;
            D01->VALOR_NOTA,; 
            D01->VALOR_ITEM,; 
            D01->VALOR_NOTA,;	
            0.00,; 	
            " ";		
            })
         
            
            _tarant := D01->TAREFA
            _prjant := D01->PROJETO
            _total  += D01->VALOR_NOTA
      
          	ENDIF
            ("D01")->(DbSkip())

        EndDo

		IncProc() 
            oFWMsExcel:AddRow("Principios","Detalhes",{;
            "  ",;		
            "  ",;
            "  ",; 
            "  ",;		
            "  ",; 
            "  ",;
            "  ",;
            "  ",; 
            "Sub-total - Conteúdo para Plataforma",; 
            _total,;	
            "  ",; 	
            " ";		
            })

  	DBSELECTAREA("D01")
  	DBGOTOP()



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