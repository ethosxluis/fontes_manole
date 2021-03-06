#include 'protheus.ch'





USER FUNCTION MT103FIM()

Local aAreaA     := GetArea()
Local aAreaSD1   := SD1->(GetArea())
Local nOpcao     := PARAMIXB[1]   // Op��o Escolhida pelo usuario no aRotina 
Local nConfirma  := PARAMIXB[2]   // Se o usuario confirmou a opera��o de grava��o da NFE


IF nConfirma == 1 .and. nOpcao == 3 

If !MsgYesNo("Deseja efetuar o rateio entre os centro de custo dos projetos ativos?")
	SD1->(RestArea(aAreaSD1))			
	RestArea(aAreaA)
 RETURN()
Endif



	_doc    := SF1->F1_DOC
	_serie  := SF1->F1_SERIE
	_fornec := SF1->F1_FORNECE
	_loja   := SF1->F1_LOJA




	DBSELECTAREA("SD1")
	DBSETORDER(1)
		DBGOTOP()
			DBSEEK(xfilial("SD1")+_doc+_serie+_fornec+_loja)
				While !eof() .and. _doc == SD1->D1_DOC .AND. _serie == SD1->D1_SERIE .AND. _fornec == SD1->D1_FORNECE .AND. _loja == SD1->D1_LOJA
					_itemnf := SD1->D1_ITEM
					_valor  := SD1->D1_TOTAL
					rateia(_itemnf,_valor)
  
					DBSELECTAREA("SD1")
				DBSKIP()
				ENDDO

ENDIF
SD1->(RestArea(aAreaSD1))			
RestArea(aAreaA)

 RETURN()

//MSGSTOP("MT103FIM")

static function rateia(_itemnf,_valor)

	 PRIVATE AARQTRB := {}

     AADD(AARQTRB,{"PROJETO"         		,"C",10,0})
     AADD(AARQTRB,{"TAREFA" 	 			,"C",12,0})
     AADD(AARQTRB,{"CC" 					,"C",09,0})     
     AADD(AARQTRB,{"VALOR"    				,"N",14,2})
     AADD(AARQTRB,{"PESO"    				,"C",02,0})     
	 AADD(AARQTRB,{"COEFIC"    				,"N",06,2})
	 AADD(AARQTRB,{"QTDTRF"    				,"N",03,0})
	 AADD(AARQTRB,{"COEFI2"    				,"N",06,2})
	 AADD(AARQTRB,{"VALLIQ"    				,"N",14,2})
	 
	if select("D01")>0
		D01->(DBCLOSEAREA())
	endif


	 CARQTRB := CRIATRAB(AARQTRB,.T.)
	 DBUSEAREA(.T.,,CARQTRB,"D01")
     INDEX ON PROJETO + CC TO &CARQTRB


	 PRIVATE AARQTRB := {}

     AADD(AARQTRB,{"CC" 					,"C",09,0})     
     AADD(AARQTRB,{"VALLIQ"    				,"N",14,2})
	 AADD(AARQTRB,{"COEFI2"    				,"N",06,2})
     
	 
	if select("D02")>0
		D02->(DBCLOSEAREA())
	endif


	 DARQTRB := CRIATRAB(AARQTRB,.T.)
	 DBUSEAREA(.T.,,DARQTRB,"D02")
     INDEX ON  CC TO &DARQTRB




CQUERY := " "

  cquery +=  " SELECT AF8_FILIAL,AF8_PROJET,AF9_TAREFA,AF9_CCUSTO,AF8_XPESO, "
  cquery +=  " AF8_XPESO/(SELECT SUM(AF8_XPESO) FROM "+retsqlname("AF8")+" WHERE AF8_ENCPRJ <> '1' AND AF8_FILIAL + AF8_PROJET IN(SELECT AF9_FILIAL + AF9_PROJET FROM "+retsqlname("AF9")+" WHERE D_E_L_E_T_ <> '*' AND AF9_CCUSTO <> ' ') AND D_E_L_E_T_ <> '*')*100 AS COEFIC "
  cquery +=  " FROM "+retsqlname("AF8")+","+retsqlname("AF9")+" "
  cquery +=  " WHERE AF8_ENCPRJ <> '1' "
  cquery +=  " AND AF9_CCUSTO <> ' ' "
  cquery +=  " AND AF8_FILIAL = AF9_FILIAL "
  cquery +=  " AND AF8_PROJET = AF9_PROJET "
  cquery +=  " AND AF8_FILIAL + AF8_PROJET IN(SELECT AF9_FILIAL + AF9_PROJET FROM "+retsqlname("AF9")+" WHERE D_E_L_E_T_ <> '*' AND AF9_CCUSTO <> ' ') "
  cquery +=  " AND "+retsqlname("AF8")+".D_E_L_E_T_ <> '*' "
  cquery +=  " AND "+retsqlname("AF9")+".D_E_L_E_T_ <> '*' "
  cquery +=  " ORDER BY AF8_PROJET, AF9_CCUSTO "

 	IiF(SELECT("TR11")>0,TR11->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TR11", .T., .T.)


  TR11->(DBGOTOP())
  
    While !eof("TR11")
       DBSELECTAREA("D01")
       DBGOTOP()
       IF !DBSEEK(TR11->AF8_PROJET+TR11->AF9_CCUSTO)
       _prj := TR11->AF8_PROJET
       
        	Reclock("D01",.T.)
        	  D01->PROJETO := TR11->AF8_PROJET
//        	  D01->TAREFA  := TR11->AF9_TAREFA
        	  D01->CC      := TR11->AF9_CCUSTO
        	  D01->VALOR   := _valor
//        	  D01->PESO    := TR1->AF8_XPESO
        	  D01->COEFIC  := TR11->COEFIC
        	  D01->QTDTRF  := BSC_QTD(_prj)
        	  D01->COEFI2   := TR11->COEFIC / D01->QTDTRF
        	  D01->VALLIQ  := _valor *(D01->COEFI2/100) 
        	Msunlock()
       ELSE
        	Reclock("D01",.F.)
        	  D01->COEFI2  += TR11->COEFIC / D01->QTDTRF
        	  D01->VALLIQ  := _valor *(D01->COEFI2/100) 
        	Msunlock()
       ENDIF
       	
       	
   DBSELECTAREA("TR11")
   DBSKIP()
   
   enddo

DBSELECTAREA("D01")
DBGOTOP()
  _item := 1
  While !eof()
  	DBSELECTAREA("D02")
  	IF !DBSEEK(D01->CC)

  	 RECLOCK("D02",.T.)
  	  D02->CC      := D01->CC
  	  D02->VALLIQ  := D01->VALLIQ
  	  D02->COEFI2  := D01->COEFI2
  	 MSUNLOCK()

  	ELSE

  	 RECLOCK("D02",.F.)
  	   D02->VALLIQ  += D01->VALLIQ
  	   D02->COEFI2  += D01->COEFI2
  	 MSUNLOCK()

  	ENDIF
  	


  	DBSELECTAREA("D01")
  	DBSKIP()
  ENDDO






DBSELECTAREA("D02")
DBGOTOP()
  _item := 1
  While !eof()
  
    Reclock("SDE",.T.)
       DE_FILIAL   := xFilial("SDE")
       DE_DOC      :=  _doc 
       DE_SERIE    :=  _serie 
       DE_FORNECE  :=  _fornec
       DE_LOJA     :=  _loja
       DE_ITEMNF   :=  _itemnf
       DE_ITEM     :=  STRZERO(_item,2)  
       DE_PERC     :=  D02->COEFI2         
       DE_CC       :=  D02->CC
       DE_CUSTO1   :=  D02->VALLIQ           
    Msunlock()
  
  _item += 1
  DBSELECTAREA("D02")
  DBSKIP()
  
  ENDDO



RETURN()


STATIC FUNCTION BSC_QTD()

dquery := ' '
 dquery := " SELECT AF9_PROJET,COUNT(*) AS QTD FROM "+retsqlname("AF9")+","+retsqlname("AF8")+" WHERE AF8_FILIAL = AF9_FILIAL AND AF8_PROJET = AF9_PROJET AND AF9_CCUSTO <> ' ' AND AF8_PROJET = '"+_prj+"' AND AF8_PROJET <> '1'AND "+retsqlname("AF8")+".D_E_L_E_T_ <> '*' AND "+retsqlname("AF9")+".D_E_L_E_T_ <> '*' GROUP BY AF9_PROJET "

  	IiF(SELECT("TR12")>0,TR12->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(dQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,dQuery),"TR12", .T., .T.)
 
 _qtd := TR12->QTD
 
 return(_qtd)