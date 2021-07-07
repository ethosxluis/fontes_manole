#include 'protheus.ch'
#include 'parmtype.ch'

//Calculo de direitos Autorais Especifico - Manole
//Luis Balestrero - Ethosx  - 03/05/2020






user function CALDAFIM()



if !pergunte("CLDDA01",.T.)
 
   return()
     
endif

	_mesano := MV_PAR02 + MV_PAR01
	_dtini := ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02)
	_dtfim := lastday(_dtini)


//U_LE_ARQS()
//Processa({|| U_LE_ARQS2() },"Lendo os arquivos...","Aguarde.")


//U_CALC()
//Processa({|| U_CALC2() },"Calculando os Direitos Autorais...","Aguarde.")



IF MV_PAR03 == 1
//gera_tit()
	Processa({|| U_LimpaP03() },"Ajustando os dados...","Aguarde.")
	Processa({|| gera_tit() },"Gerando os titulos a pagar  dos Direitos Autorais...","Aguarde.")
ENDIF

 
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

return()



USER FUNCTION LE_ARQS2()

Local _imes := 0

cquery := " "
 cquery += " SELECT P03_TITULO,E2_FORNECE,E2_LOJA "
 cquery += " from "+retsqlname("P03")+","+retsqlname("SE2")
 cquery += " where P03_MESANO = '"+MV_PAR02 + MV_PAR01+ "'"
 cquery += " AND P03_TITULO = E2_NUM "
 cquery += " AND P03_FORNEC = E2_FORNECE "
 cquery += " AND P03_LOJAFO = E2_LOJA "
 cquery += " AND E2_BAIXA <> ' ' AND E2_VALOR <> E2_SALDO AND E2_NUMBOR <> ' ' "
 cquery += " AND "+retsqlname("P03")+".D_E_L_E_T_ <> '*' "
 cquery += " AND "+retsqlname("SE2")+".D_E_L_E_T_ <> '*' "
 
  cQuery := ChangeQuery(cQuery)
   	
   		
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   	
		dbSelectArea("TRB")
		dbGoTop()
		IF TRB->( !EOF () )
     
			alert("Este fechamento já foi executado, e existem titulos baixados para o mesmo, será necessária a exclusão das baixas ")
			
		ENDIF



cquery := " "
  cquery := " SELECT P03_MESANO "
  cquery += " FROM " +RetSQLName("P03")
  cquery += " WHERE P03_MESANO = '"+MV_PAR02+MV_PAR01+ "'"
  cquery += " AND D_E_L_E_T_ <> '*' "
  
  
   	cQuery := ChangeQuery(cQuery)
   	
   		
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   	
		dbSelectArea("TRB")
		dbGoTop()
		IF TRB->( !EOF () )

			If MsgYesNo("O fechamento do mês/ano "+MV_PAR01+"/"+MV_PAR02+" já foi executado, deseja refazer?")
			    alert("Os registros que geraram títulos a pagar e foram baixados, não serão excluidos")
				Processa({|| U_LimpaP03() },"Ajustando os dados...","Aguarde.")
			else
			  ruturn()
			endif

		ENDIF


//PRODUTOS QUE TEM O CALCULO FEITO PELO FINANECEIRO

_mesatual := MV_PAR01

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////*********************MENSAIS************RODAR TODOS OS MESES*********INICIO

//*********************  CONTRATOS FINANCEIRO *************************************************

//MENSAIS
   cquery :=   " SELECT P04_CONTRA,P04_SEQCON,P04_FORNEC,P04_LOJAFO,P04_PRODUT,P04_PERIOD,D2_QUANT, "
   cquery  +=  " D2_PRUNIT PRUNIT, "
   cquery  +=  " D2_PRCVEN PRCVEN, "  
   cquery  +=  " D2_DOC, D2_CLIENTE, D2_LOJA,  "
   cquery  +=  " D2_SERIE,D2_ITEM,E1_EMISSAO,E1_BAIXA,E1_PARCELA " 
   cquery  +=  " FROM "+RetSQLName("P04")+" , "+RetSQLName("SD2")+" ,"+retsqlname("SE1")
   cquery  +=  " WHERE P04_PRODUT = D2_COD  "
//   cquery  +=  " AND P04_PERIOD = '01'  "
   cquery  +=  " AND D2_TES IN(SELECT F4_CODIGO FROM "+retsqlname("SF4")+ " WHERE F4_TIPOPER = '5' AND D_E_L_E_T_ <> '*')  "
   cquery  +=  " AND D2_EMISSAO BETWEEN '20200401' AND '20210331' " //considerar pagamento pelo financeiro de 01/04/2020 até 31/03/2021
   cquery  +=  " AND E1_SERIE = D2_SERIE "
   cquery  +=  " AND E1_NUM = D2_DOC "
   cquery  +=  " AND E1_CLIENTE = D2_CLIENTE "
   cquery  +=  " AND E1_LOJA = D2_LOJA "
   cquery  +=  " AND E1_SALDO  > 0 "   
   cquery  +=  " AND "+RetSQLName("P04")+".D_E_L_E_T_ <> '*' "
   cquery  +=  " AND "+RetSQLName("SD2")+".D_E_L_E_T_ <> '*' "
   cquery  +=  " AND "+retsqlname("SE1")+".D_E_L_E_T_ <> '*' "
   cquery  +=  " ORDER BY P04_FORNEC,P04_LOJAFO,D2_DOC,D2_SERIE,D2_ITEM "

   
   	cQuery := ChangeQuery(cQuery)
	
	
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   
		dbSelectArea("TRB")
		dbGoTop()

		While TRB->(!Eof())
		   DBSELECTAREA("P03")
		   DBGOTOP()
		   DBSETORDER(3)
		   
		   IF !dbseek(xFilial("P03")  + MV_PAR02 + MV_PAR01 + TRB->P04_CONTRA + TRB->P04_SEQCON +TRB->P04_FORNEC+TRB->P04_LOJAFO+P03_PRODUT +TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_CLIENTE+TRB->D2_LOJA+TRB->E1_PARCELA)   

		   reclock("P03",.T.)
		        P03_FILIAL  := xfilial() 
	         	P03_MESANO  := _mesano
	         	P03_CONTRA  := TRB->P04_CONTRA
	         	P03_SEQCON  := TRB->P04_SEQCON
	         	P03_FORNEC  := TRB->P04_FORNEC
	         	P03_LOJAFO  := TRB->P04_LOJAFO
	         	P03_PRODUT  := TRB->P04_PRODUT               
	         	P03_PERIOD  := TRB->P04_PERIOD
	         	P03_QTDE    := TRB->D2_QUANT       
	         	P03_PRUNIT  := TRB->D2_QUANT * TRB->PRUNIT      
	         	P03_PRCVEN  := TRB->D2_QUANT * TRB->PRCVEN
	         	P03_SERIE   := TRB->D2_SERIE
	         	P03_DOC     := TRB->D2_DOC
	         	P03_CLIENT  := TRB->D2_CLIENTE
	         	P03_LOJCLI  := TRB->D2_LOJA
	         	P03_EMISS   := STOD(TRB->E1_EMISSAO)
	         	P03_BAIXA   := STOD(TRB->E1_BAIXA)
	         	P03_PARC    := TRB->E1_PARCELA
		  msunlock()
		 ELSE
		    reclock("P03",.F.)
		       	P03_QTDE    += TRB->D2_QUANT       
	         	P03_PRUNIT  += (TRB->D2_QUANT * TRB->PRUNIT)      
	         	P03_PRCVEN  += (TRB->D2_QUANT * TRB->PRCVEN)
		    msunlock()
		 ENDIF 
        
		   DBSELECTAREA("TRB")
		   dbskip()
		enddo




*********************MENSAIS************RODAR TODOS OS MESES*********FIM
/*
// verificao dos outros perodos que no so mensais

//   IF _mesatual$(GETMV("MV_DAPER02"))  //BIMESTRAIS
   	
   		_period := "02"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR01) - 1) + "/" + MV_PAR02)
   		_dtini := MonthSub(ctod("01" + "/" + str(val(MV_PAR01)) + "/" + MV_PAR02),1)
   		_dtfim := lastday(ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02))
   		
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
   	
   		_imes :=  _mesini
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		for _imes  := (month(_dtini2))  to _mesfim
			 calc_d2(_period,_dtini2,_dtfim2)
			_dtini2 := MonthSum(_dtini2,1)
			_dtfim2 := lastday(_dtini2)
		next
   	
   	
   		
   		
   		
//   		calc_d2(_period,_dtini,_dtfim)
   		calc_p01(_period,_dtini,_dtfim)
   		calc_dev(_period,_dtini,_dtfim)




//   ENDIF

//   IF   _mesatual$(GETMV("MV_DAPER03"))  //TRIMESTRAIS
/*   	
		_period := "03"
   		_dtini := MonthSub(ctod("01" + "/" + str(val(MV_PAR01)) + "/" + MV_PAR02),2)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02))
		calc_d2(_period,_dtini,_dtfim)
   		calc_p01(_period,_dtini,_dtfim)		
   		calc_dev(_period,_dtini,_dtfim)
*/
/*		_period := "03"
   		_dtini := MonthSub(ctod("01" + "/" + str(val(MV_PAR01)) + "/" + MV_PAR02),2)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02))
		
		
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
	
		_imes :=  _mesini
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		for _imes  := (month(_dtini2))  to _mesfim
			 calc_d2(_period,_dtini2,_dtfim2)
			_dtini2 := MonthSum(_dtini2,1)
			_dtfim2 := lastday(_dtini2)
		next

//		calc_d2(_period,_dtini,_dtfim)
   		calc_p01(_period,_dtini,_dtfim)		
   		calc_dev(_period,_dtini,_dtfim)




   //ENDIF
	
//   IF _mesatual$(GETMV("MV_DAPER04"))  //QUADRIMESTRAIS
   	
		_period := "04"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR01) - 3) + "/" + MV_PAR02)
   		_dtini := MonthSub(ctod("01" + "/" + str(val(MV_PAR01)) + "/" + MV_PAR02),3)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02))

		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  _mesini
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		for _imes  := (month(_dtini2))  to _mesfim
			 calc_d2(_period,_dtini2,_dtfim2)
			_dtini2 := MonthSum(_dtini2,1)
			_dtfim2 := lastday(_dtini2)
		next




//		calc_d2(_period,_dtini_dtfim)
		calc_p01(_period,_dtini,_dtfim)
   		calc_dev(_period,_dtini,_dtfim)

//  ENDIF
	
//  IF  _mesatual$(GETMV("MV_DAPER06"))  //SEMESTRAIS
   	
		_period := "06"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR01) - 5) + "/" + MV_PAR02)
   		_dtini := MonthSub(ctod("01" + "/" + str(val(MV_PAR01)) + "/" + MV_PAR02),5)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02))
		
		_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  1
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		_imesfim := DateDiffMonth(_dtini,_dtfim) + 1
		
		for _imes  := 1  to _imesfim
			 calc_d2(_period,_dtini2,_dtfim2)
			_dtini2 := MonthSum(_dtini2,1)
			_dtfim2 := lastday(_dtini2)
		next
	
	
	
		calc_d2ft(_period,_dtini,_dtfim)
   		calc_p01(_period,_dtini,_dtfim)
   		calc_dev(_period,_dtini,_dtfim)
 
//  ENDIF
	
//  IF _mesatual$(GETMV("MV_DAPER12"))  //ANUAIS
   	
		_period := "12"
//		_dtini := ctod("01" + "/" + str(val(MV_PAR01) - 11) + "/" + MV_PAR02)
   		_dtini := MonthSub(ctod("01" + "/" + str(val(MV_PAR01)) + "/" + MV_PAR02),11)
		_dtfim := lastday(ctod("01" + "/" + MV_PAR01 + "/" + MV_PAR02))
	_mesini := (month(_dtini))
		_mesfim := (month(_dtfim))
		
		_imes :=  1
		
		_dtini2 := _dtini
		_dtfim2 := lastday(_dtini2)
		_imesfim := DateDiffMonth(_dtini,_dtfim) + 1
		
		for _imes  := 1  to _imesfim
			 calc_d2(_period,_dtini2,_dtfim2)
			_dtini2 := MonthSum(_dtini2,1)
			_dtfim2 := lastday(_dtini2)
		next
	
	
	
//		calc_d2(_period,_dtini,_dtfim)
   		calc_p01(_period,_dtini,_dtfim)
   		calc_dev(_period,_dtini,_dtfim)
//   ENDIF


//////////////////////////////////////////////////////////////
static function calc_d2(_period,_dtini_dtfim)

//FINANCEIRO
   
   cquery :=  " SELECT P04_CONTRA,P04_SEQCON,P04_FORNEC,P04_LOJAFO,P04_PRODUT,P04_PERIOD,D2_QUANT, "
   cquery  +=  " D2_PRUNIT, "
   cquery  +=  " D2_PRCVEN, "
   cquery  +=  " D2_DOC,D2_CLIENTE,D2_LOJA, "
   cquery  +=  " D2_SERIE,E1_EMISSAO,E1_BAIXA,E1_PARCELA " 
   cquery  +=  " FROM "+RetSQLName("P04")+" , "+RetSQLName("SD2")+" ,"+retsqlname("SE1")
   cquery  +=  " WHERE P04_PRODUT = D2_COD  "
   cquery  +=  " AND P04_PERIOD = '"+_period+"'"
   cquery  +=  " AND D2_TES IN(SELECT F4_CODIGO FROM  "+retsqlname("SF4")+ "  WHERE F4_TIPOPER = '5' AND D_E_L_E_T_ <> '*')  "
   cquery  +=  " and D2_EMISSAO BETWEEN  '20200401' AND '20210331' "
   cquery  +=  " AND E1_SERIE = D2_SERIE "
   cquery  +=  " AND E1_NUM = D2_DOC "
   cquery  +=  " AND E1_CLIENTE = D2_CLIENTE "
   cquery  +=  " AND E1_LOJA = D2_LOJA "
//   cquery  +=  " AND E1_CLIENTE <> '045421' "
//   cquery  +=  " AND E1_BAIXA  BETWEEN '"+dtos(_dtini2)+"' AND '"+dtos(_dtfim2)+"'"
   cquery  +=  " AND E1_SALDO > 0 "   
//   cquery  +=  " AND P04_XTPFAT = '2'"
   cquery  +=  " AND "+RetSQLName("P04")+".D_E_L_E_T_ <> '*' "
   cquery  +=  " AND "+RetSQLName("SD2")+".D_E_L_E_T_ <> '*' "
   cquery  +=  " AND "+retsqlname("SE1")+".D_E_L_E_T_ <> '*' "
   cquery  +=  " ORDER BY P04_FORNEC,P04_LOJAFO,D2_DOC,D2_SERIE,D2_ITEM "
   
   	cQuery := ChangeQuery(cQuery)
	
	
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   
		dbSelectArea("TRB")
		dbGoTop()

		While TRB->(!Eof())
/*
		   _serie   := TRB->D2_SERIE
		   _doc     := TRB->D2_DOC
		   _cliente := TRB->D2_CLIENTE
		   _lojacli := TRB->D2_LOJA

		   _qtdparc := num_parc(_serie,_doc,_cliente,_lojacli)
	*/	   
//		   dbSelectArea("TRB")
/*
		   DBSELECTAREA("P03")
		   DBGOTOP()
		   DBSETORDER(3)


		   IF !dbseek(xFilial("P03")  + MV_PAR02 + MV_PAR01 + TRB->P04_CONTRA + TRB->P04_SEQCON +TRB->P04_FORNEC+TRB->P04_LOJAFO+P03_PRODUT +TRB->D2_SERIE+TRB->D2_DOC+TRB->D2_CLIENTE+TRB->D2_LOJA+TRB->E1_PARCELA)   
		   reclock("P03",.T.)
		        P03_FILIAL  := xfilial() 
	         	P03_MESANO  := _mesano
	         	P03_CONTRA  := TRB->P04_CONTRA
	         	P03_SEQCON  := TRB->P04_SEQCON
	         	P03_FORNEC  := TRB->P04_FORNEC
	         	P03_LOJAFO  := TRB->P04_LOJAFO
	         	P03_PRODUT  := TRB->P04_PRODUT               
	         	P03_PERIOD  := TRB->P04_PERIOD
	         	P03_QTDE    := TRB->D2_QUANT       
	         	P03_PRUNIT  := TRB->D2_QUANT * TRB->D2_PRUNIT //   / _qtdparc      
	         	P03_PRCVEN  := TRB->D2_QUANT * TRB->D2_PRCVEN //     / _qtdparc
	         	P03_SERIE   := TRB->D2_SERIE
	         	P03_DOC     := TRB->D2_DOC
	         	P03_CLIENT  := TRB->D2_CLIENTE
	         	P03_LOJCLI  := TRB->D2_LOJA
	         	P03_EMISS   := STOD(TRB->E1_EMISSAO)
	         	P03_BAIXA   := STOD(TRB->E1_BAIXA)
	         	P03_PARC    := TRB->E1_PARCELA
		  msunlock()
		 ELSE
		    reclock("P03",.F.)
		       	P03_QTDE    += TRB->D2_QUANT       
	         	P03_PRUNIT  += (TRB->D2_QUANT * (TRB->D2_PRUNIT))//    / _qtdparc))      
	         	P03_PRCVEN  += (TRB->D2_QUANT * (TRB->D2_PRCVEN))//    / _qtdparc))
		    msunlock()
		 ENDIF 
        
		   DBSELECTAREA("TRB")
		   dbskip()
		enddo

		return()
		
*/

//FUNCAO PARA CALCULAR OS DIREITOS AUTORAIS
USER FUNCTION CALC2()

//DBSELECTAREA("P03")
//DBSETORDER(3) //P03_FILIAL+P03_MESANO+P03_CONTRA+P03_SEQCON+P03_PRODUT+P03_SERIE+P03_DOC+P03_CLIENT+P03_LOJCLI+P03_PARC   

DBSELECTAREA("P03")
DBSETORDER(2)

	
	
	IF DBSEEK(xFilial("P03") + _mesano)

	   _contra := P03->P03_CONTRA
	   _seq    := P03->P03_SEQCON
	   _faixa  := P03->P03_QTDE - P03->P03_QTDDEV
	   _produt := P03->P03_PRODUT
	   _fornec := P03_FORNEC
	   _period := P03_PERIOD
	
	 _mesano := P03->P03_MESANO
	  
	  
		while !eof() .AND. _mesano == MV_PAR02 + MV_PAR01  
		
		
			_contra := P03->P03_CONTRA
			_seq    := P03->P03_SEQCON
			_faixa  := P03->P03_QTDE - P03->P03_QTDDEV
			_produt := P03->P03_PRODUT
			_fornec := P03_FORNEC
			_doc    := P03_DOC
			_serie  := P03_SERIE
			_cliente := P03_CLIENT
			_lojacli := P03_LOJCLI
 			_parcela := P03_PARC
			_qtdparc := 1
			
			if !empty(P03_DOC)
 				_qtdparc := num_parc(_serie,_doc,_cliente,_lojacli)
 			endif
 			
 			if _qtdparc == 0
    	   	  _qtdparc := 1
    	    endif
			
			_perc := busca_per(_contra,_seq,_faixa,_produt,_fornec)
			_prc  := busca_per(_contra,_seq,_faixa,_produt,_fornec)
		   
		   DBSELECTAREA("P03")
		   
		   if _perc > 0
		      if _prc == '1'
		   		RECLOCK("P03",.F.)	
		   			P03->P03_PRUNIT  := P03->P03_PRUNIT / _qtdparc
		   			P03->P03_VLRDA   := (P03->P03_PRUNIT - P03->P03_PRUNID)  * (_perc/100)
		   			P03->P03_PERCDA  := _perc
		        MSUNLOCK()
		       else
		   		RECLOCK("P03",.F.)	
		   			P03->P03_PRCVEN := P03->P03_PRCVEN / _qtdparc
		   			P03->P03_VLRDA := (P03->P03_PRCVEN - P03->P03_PRCVED)  * (_perc/100)
		   			P03->P03_PERCDA  := _perc
		        MSUNLOCK()
		      endif 
		   endif
		   
		   
	       dbskip()
	       _mesano := P03->P03_MESANO
	     
	     
	       
	       
	    enddo
	    
	    
   endif
		  
		   
RETURN()

static function busca_per(_contra,_seq,_faixa,_produt,_fornec)

if _faixa <= 0
 _faixa := 1
endif


_perc := 0
_prc  := ""


fquery := " "
 fquery := " select P05_PRBRUT,P05_PERCRE,P05_ITEM "	
 fquery  += "  FROM "+RetSQLName("P05")
 fquery  += " WHERE P05_PRODUT = '"+_produt+"'"
 fquery  += " AND P05_CONTRA = '"+_contra+"'"
 fquery  += " AND P05_SEQCON = '"+_seq+"'"
 fquery  += " AND P05_FORNEC = '"+_fornec+"'"
 fquery  += " AND "+STR(_faixa)+" >= P05_FXINIC AND "+STR(_faixa)+" <= P05_FXFINA "
 fquery  += " AND D_E_L_E_T_ <> '*' "


	if select("TRD")>0
		TRD->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,fQuery),"TRD",.F.,.T.) 
   
   _perc  := TRD->P05_PERCRE 
   _prc   := TRD->P05_PRBRUT
     
     
Return(_perc,_prc)     



USER FUNCTION LIMPAP03()


			//apago os registros da P03 processados anteriormente
/*			cquery := " "
			cquery := " UPDATE  "+retsqlname("P03")+" SET D_E_L_E_T_ = '*' WHERE P03_MESANO ='"+MV_PAR02 + MV_PAR01 +"' and P03_TITULO NOT IN(SELECT E2_NUM FROM "+retsqlname("SE2")+" WHERE E2_FORNECE = P03_FORNEC  AND E2_LOJA = P03_LOJAFO  AND E2_BAIXA <> ' ' AND E2_VALOR <> E2_SALDO AND E2_EMISSAO = '"+dtos(_dtfim)+"' AND E2_ORIGEM = 'CALC_DA' AND D_E_L_E_T_ <> '*') "
			TcsqlExec(cquery)
*/
    cquery := " "
      cquery := " SELECT E2_PREFIXO,E2_NUM,E2_TIPO,E2_NATUREZ,E2_PORTADO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCTO,E2_VENCORI,E2_VENCREA,E2_VALOR,E2_SALDO,E2_BCOPAG,E2_EMIS1,E2_VLCRUZ,E2_HIST,E2_ORIGEM,E2_MOEDA,E2_PARCELA,E2_DIRF,E2_CODRET,E2_LA "
      	cquery += " FROM "+retsqlname("SE2")
      	cquery += " WHERE D_E_L_E_T_ <> '*' "
      	cquery += " AND E2_EMISSAO = '"+dtos(_dtfim)+"'"
//      	cquery += " AND E2_EMISSAO = '20210531'"
      	cquery += " AND E2_ORIGEM = 'CALC_DA' "
      	cquery += " AND E2_FORNECE <> 'UNIAO' "
      	cquery += " AND E2_BAIXA = ' ' "
      	cquery += " AND E2_VALOR = E2_SALDO "
      	
      	
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
		dbGoTop()
		IF TRB->( !EOF () )
      	
      			dbSelectArea("TRB")
      			dbGoTop()
      				while TRB->( !eof() )

		aDelSe2	:=	{	{ "E2_FILIAL"	, xFilial("SE2")								, Nil },;
			{ "E2_PREFIXO"	, TRB->E2_PREFIXO											, Nil },;
			{ "E2_NUM"		, TRB->E2_NUM   	   										, Nil },;
			{ "E2_TIPO"		, TRB->E2_TIPO	     										, Nil },;
			{ "E2_NATUREZ"	, TRB->E2_NATUREZ											, Nil },;
			{ "E2_PORTADO"	, TRB->E2_PORTADO				   							, Nil },;
			{ "E2_FORNECE"	, TRB->E2_FORNECE		 									, Nil },;
			{ "E2_LOJA"   	, TRB->E2_LOJA												, Nil },;
			{ "E2_NOMFOR"	, TRB->E2_NOMFOR 											, Nil },;
			{ "E2_EMISSAO"	, CTOD(TRB->E2_EMISSAO)										, Nil },;
			{ "E2_VENCTO"	, CTOD(TRB->E2_VENCTO)   									, Nil },;
			{ "E2_VENCORI"	, CTOD(TRB->E2_VENCORI)	    								, Nil },;
			{ "E2_VENCREA"	, CTOD(TRB->E2_VENCREA)  									, Nil },;
			{ "E2_VALOR"  	, TRB->E2_VALOR   											, Nil },;
			{ "E2_SALDO"  	, TRB->E2_SALDO	    										, Nil },;
			{ "E2_BCOPAG" 	, TRB->E2_BCOPAG					     					, Nil },;
			{ "E2_EMIS1"  	, CTOD(TRB->E2_EMIS1)										, Nil },;
			{ "E2_VLCRUZ" 	, TRB->E2_VLCRUZ		    								, Nil },;
			{ "E2_HIST"   	, TRB->E2_HIST												, Nil },;
			{ "E2_ORIGEM" 	, TRB->E2_ORIGEM									 		, Nil },;
			{ "E2_MOEDA"	, TRB->E2_MOEDA     									    , Nil },;
			{ "E2_PARCELA"	, TRB->E2_PARCELA 								 			, Nil },;
			{ "E2_DIRF" 	, TRB->E2_DIRF												, Nil },; 
			{ "E2_CODRET" 	, TRB->E2_CODRET				  							, Nil },;
			{ "E2_LA"       ,' '                            							, Nil }	}


		lMsErroAuto := .F.
		Public mv_par04		:= 2 	// contabilizao off line
		Public lOnline		:= nil	// contabilizao off line
		MsExecAuto({ | a,b,c | Fina050(a,b,c) },aDelSe2,,5)
		If lMsErroAuto
			mostraErro()
			Exit
	    ENDIF


      				
      	
      				  dbselectarea("TRB")
      				  DBSKIP()
      				enddo
      	endif


return()   


static function gera_tit()

 cquery := " "
  cquery := " SELECT P03_FORNEC,P03_LOJAFO,P03_MESANO,A2_TIPO,A2_BANCO,A2_NREDUZ,SUM(P03_VLRDA) AS VLRDA "
  cquery += " FROM "+retsqlname("P03")+","+retsqlname("SA2")+","+retsqlname("P04")
  cquery += " where P03_FORNEC = A2_COD "
  cquery += " AND P03_LOJAFO = A2_LOJA "
  cquery += " AND P03_CONTRA = P04_CONTRA "
  cquery += " AND P03_SEQCON = P04_SEQCON "
  cquery += "  AND P03_FORNEC = P04_FORNEC "
  cquery += " AND P03_LOJAFO = P04_LOJAFO "
//cquery += " AND P04_PRZOPA = E4_CODIGO "
//  cquery += "  AND A2_COND = E4_CODIGO "
  cquery +=  " AND "+RetSQLName("P03")+ ".D_E_L_E_T_ <> '*' "
  //cquery +=  " AND "+RetSQLName("SE4")+ ".D_E_L_E_T_ <> '*' "
  cquery +=  " AND "+RetSQLName("SA2")+ ".D_E_L_E_T_ <> '*' "
  cquery +=  " AND "+RetSQLName("P04")+ ".D_E_L_E_T_ <> '*' "  
  cquery += " AND P03_MESANO = '"+ MV_PAR02 + MV_PAR01+ "'"
  cquery += " GROUP BY P03_FORNEC,P03_LOJAFO,P03_MESANO,A2_TIPO,A2_BANCO,A2_NREDUZ "
  cquery += " ORDER BY P03_FORNEC,P03_LOJAFO "


 
	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
		dbGoTop()
		IF TRB->( !EOF () )

			cNumero := NUM_SE2()


			while TRB->( !eof() )
IF TRB->VLRDA > 0			

//            _vencto := _dtfim + val(TRB->E4_COND)

	if TRB->A2_TIPO == 'J'
		_naturez := "20022"
	else
	    _naturez := "50066"
	endif

IF TRB->P03_FORNEC = 'A00184'
  msgstop("A00184")
ENDIF



              _vencto := _dtfim + 20            
		aGrvSe2	:=	{	{ "E2_FILIAL"	, xFilial("SE2")								, Nil },;
			{ "E2_PREFIXO"	, Iif(TRB->A2_TIPO=="X","RYE","RYI")						, Nil },;
			{ "E2_NUM"		, cNumero   	   											, Nil },;
			{ "E2_TIPO"		, "RYI"	     												, Nil },;
			{ "E2_NATUREZ"	, _naturez													, Nil },;
			{ "E2_PORTADO"	, TRB->A2_BANCO				   								, Nil },;
			{ "E2_FORNECE"	, TRB->P03_FORNEC		 									, Nil },;
			{ "E2_LOJA"   	, TRB->P03_LOJAFO											, Nil },;
			{ "E2_NOMFOR"	, TRB->A2_NREDUZ 											, Nil },;
			{ "E2_EMISSAO"	, _dtfim													, Nil },;
			{ "E2_VENCTO"	, _vencto   												, Nil },;
			{ "E2_VENCORI"	, _vencto	    											, Nil },;
			{ "E2_VENCREA"	, DataValida(_vencto)   									, Nil },;
			{ "E2_VALOR"  	, (TRB->VLRDA)   											, Nil },;
			{ "E2_SALDO"  	, (TRB->VLRDA)	    										, Nil },;
			{ "E2_BCOPAG" 	, TRB->A2_BANCO					     						, Nil },;
			{ "E2_EMIS1"  	, _dtfim													, Nil },;
			{ "E2_VLCRUZ" 	, (TRB->VLRDA)		    									, Nil },;
			{ "E2_HIST"   	, "Pagamento de D.A."										, Nil },;
			{ "E2_ORIGEM" 	, "calc_da"											  		, Nil },;
			{ "E2_MOEDA"	, 1     												    , Nil },;
			{ "E2_PARCELA"	, "1" 								 						, Nil },;
			{ "E2_DIRF" 	, "1"											  			, Nil },; 
			{ "E2_CODRET" 	, IIF(TRB->A2_TIPO=="J","1708","0588")				  		, Nil },;
			{ "E2_LA"       ,' '                            							, Nil }	}


		lMsErroAuto := .F.
		Public mv_par04		:= 2 	// contabilizao off line
		Public lOnline		:= nil	// contabilizao off line
		MsExecAuto({ | a,b,c | Fina050(a,b,c) },aGrvSe2,,3)
		If lMsErroAuto
			mostraErro()
//			Exit
		Else
			DBSELECTAREA("TRB")
			tquery := " UPDATE  "+retsqlname("P03")+" SET P03_TITULO = '"+strzero((val(cnumero) + 1),9)+"' WHERE P03_FORNEC = '"+TRB->P03_FORNEC +"' AND P03_VLRDA > 0 AND P03_LOJAFO ='"+TRB->P03_LOJAFO+"'AND P03_MESANO = '"+TRB->P03_MESANO+"'"
			TcsqlExec(tquery)
		
		  cnumero := strzero((val(cnumero) + 1),9)
		Endif
		
ENDIF		
		DBSELECTAREA("TRB")
		DBSKIP()


	ENDDO
	
	ENDIF	

RETURN()	

STATIC FUNCTION NUM_SE2()

cquery := " "
 cquery += " SELECT MAX(E2_NUM) E2_NUM "
 cquery += " FROM "+retsqlname("SE2")
 cquery += " WHERE D_E_L_E_T_ <> '*' "
 cquery += " AND E2_ORIGEM = 'CALC_DA' "
 
 
 	if select("TRC")>0
		TRC->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRC",.F.,.T.)
	
	_nummax := STRZERO(VAL(TRC->E2_NUM)+1,9)
	
	return(_nummax)
 
 
 static function num_parc(_serie,_doc,_cliente,_lojacli)
 
 
 cquery := " "
  cquery := " SELECT COUNT(*) AS QTDPARC  FROM "+retsqlname("SE1")+" WHERE E1_PREFIXO = '"+_serie+"' AND E1_NUM = '"+_doc+"'  AND E1_CLIENTE = '"+_cliente+"' AND E1_LOJA = '"+_lojacli+"' AND D_E_L_E_T_ <> '*' "

 	if select("TRZ")>0
		TRZ->(DBCLOSEAREA())
	endif

	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRZ",.F.,.T.)
	
	_qtdparc := TRZ->QTDPARC
	
	return(_qtdparc)


  