#INCLUDE"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH" 
        
        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCDA099   บAutor  ณANDERSON CIRIACO    บ Data ณ  06/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CALENDARIOS DE FECHAMENTO DE DIREITOS AUTORAIS             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EDITORA MANOLE                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION MCDA099()

Local cAlias  := "AHZ"
Local cTitulo := "Cadastro de Calendแrios de Direitos Autorais"
Local cVldExc := "DA099VldEx()"

If AliasInDic( cAlias )
	dbSelectArea( cAlias )
	AHZ->(dbSetOrder( 1 ))
	AxCadastro( cAlias, cTitulo )
Else
	MsgAlert( "Tabela de Calendแrios de D.A. (AHZ) nใo encontrada!" )
EndIf

Return Nil
                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDA099VldExบAutor  ณMicrosiga           บ Data ณ  06/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVALIDA A EXCLUSรO DE CALENDARIO, NรO PERMITINDO EXCLUIR DADOSฑฑ
ฑฑบ          ณJม EFETIVADOS                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DA099VldEx()

Local lRet  := .T.
Local aArea := GetArea()

dbSelectArea( "AHZ" )
AHZ->(dbSetOrder(1))
AHZ->(dbGoTop())                           

While ( AHZ->(!Eof()) ) .And. ( AHZ->AHZ_FILIAL == xFilial( "AHZ" ) ) 
	If !EMPTY( AHZ->AHZ_IDFECH )
		lRet := .F.
		Help( " ", 1, "DA099VldEx", , "Nใo Foi Possivel Excluir o calendแrio, pois o mesmo encontra-se efetivado!!! ", 1, 0 ) 
		Exit
	EndIf
	AHZ->(dbSkip())
EndDo

RestArea( aArea ) 

Return lRet  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCD099Dtp  บAutor  ณMicrosiga           บ Data ณ  06/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcalcula data inicial do periodo para grava็๕es de calculo   บฑฑ
ฑฑบ          ณde Direitos Autorais                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CD099Dtp(dDataFech,xPeriodo)
Local aArea     := GetArea()
Local dPerIni
Local dPerFim
Local i         := 0
Local aSM0			:= AdmAbreSM0()
Local nContFil		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Periodo de processamento, do dia 01 do mes e ano informados  ณ
//ณ ate o ultimo dia do mes.                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dPerIni := CTOD("01/"+StrZero(Month(dDataFech),2)+"/"+Str(Year(dDataFech)))
dPerFim := dDataFech

//ANDERSON CIRIACO - TRATAMENTO POR PERIODO
IF XPERIODO == "02" // BIMESTRAL
	IF STRZERO(MONTH(dPerFim),2)$"01/03/05/07/09/11" //PERTENCE AO PERIODO E PODE EFETUAR O CALCULO
		dPerIni := "01/"+if(val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1,StrZero(12-val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2)),2),StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))
		IF val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1 //BUSCA ANO ANTERIOR PARA O CALCULO CONSIDERANDO QUE O MES DE JANEIRO FOI CONSIDERADO COMO PERIODO FINAL
			DPERINI += "/"+Str(Year(dPerFim)-1)
		ELSE
			DPERINI += "/"+Str(Year(dPerFim))
		ENDIF
		
		DPERINI := CTOD(DPERINI)
		
	ELSE
		ALERT("ATENวรO!!! O MสS "+STRZERO(MONTH(dPerFim),2)+" NรO PODE EFETUAR O CALCULO BIMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE ESTม SENDO INCLUอDO")
		Return (.F.)
	ENDIF
	
ELSEIF XPERIODO == "03"  //TRIMESTRAL
	IF STRZERO(MONTH(dPerFim),2)$"02/05/08/11" //PERTENCE AO PERIODO E PODE EFETUAR O CALCULO
		dPerIni := "01/"+if(val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1,StrZero(12-val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2)),2),StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))
		IF val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1 //BUSCA ANO ANTERIOR PARA O CALCULO CONSIDERANDO QUE O MES DE JANEIRO FOI CONSIDERADO COMO PERIODO FINAL
			DPERINI += "/"+Str(Year(dPerFim)-1)
		ELSE
			DPERINI += "/"+Str(Year(dPerFim))
		ENDIF
		
		DPERINI := CTOD(DPERINI)
		
	ELSE
		ALERT("ATENวรO!!! O MสS "+STRZERO(MONTH(dPerFim),2)+" NรO PODE EFETUAR O CALCULO TRIMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE ESTม SENDO INCLUอDO")
		Return (.F.)
	ENDIF
	
	
ELSEIF XPERIODO == "04"  //QUADRIMESTRAL
	IF STRZERO(MONTH(dPerFim),2)$"03/07/11" //PERTENCE AO PERIODO E PODE EFETUAR O CALCULO
		dPerIni := "01/"+if(val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1,StrZero(12-val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2)),2),StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))
		IF val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1 //BUSCA ANO ANTERIOR PARA O CALCULO CONSIDERANDO QUE O MES DE JANEIRO FOI CONSIDERADO COMO PERIODO FINAL
			DPERINI += "/"+Str(Year(dPerFim)-1)
		ELSE
			DPERINI += "/"+Str(Year(dPerFim))
		ENDIF
		
		DPERINI := CTOD(DPERINI)
		
	ELSE
		ALERT("ATENวรO!!! O MสS "+STRZERO(MONTH(dPerFim),2)+" NรO PODE EFETUAR O CALCULO TRIMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE ESTม SENDO INCLUอDO")
		Return (.F.)
	ENDIF
	
	
ELSEIF XPERIODO == "06" //SEMESTRAL
	IF STRZERO(MONTH(dPerFim),2)=="05" .OR. STRZERO(MONTH(dPerFim),2)=="11"   //PERTENCE AO PERIODO E PODE EFETUAR O CALCULO
		dPerIni := "01/"+if(val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1,StrZero(12-val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2)),2),StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))
		IF val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1 //BUSCA ANO ANTERIOR PARA O CALCULO CONSIDERANDO QUE O MES DE JANEIRO FOI CONSIDERADO COMO PERIODO FINAL
			DPERINI += "/"+Str(Year(dPerFim)-1)
		ELSE
			DPERINI += "/"+Str(Year(dPerFim))
		ENDIF
		
		DPERINI := CTOD(DPERINI)
		
	ELSE
		ALERT("ATENวรO!!! O MสS "+STRZERO(MONTH(dPerFim),2)+" NรO PODE EFETUAR O CALCULO SEMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE ESTม SENDO INCLUอDO")
		Return (.F.)
	ENDIF
	
	
ELSEIF XPERIODO == "12" // ANUAL
	IF STRZERO(MONTH(dPerFim),2)=="11" //PERTENCE AO PERIODO E PODE EFETUAR O CALCULO
		dPerIni := "01/"+if(val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1,StrZero(12-val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2)),2),StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))
		IF val(StrZero(Month(dPerFim)-VAL(XPERIODO)+1,2))<1 //BUSCA ANO ANTERIOR PARA O CALCULO CONSIDERANDO QUE O MES DE JANEIRO FOI CONSIDERADO COMO PERIODO FINAL
			DPERINI += "/"+Str(Year(dPerFim)-1)
		ELSE
			DPERINI += "/"+Str(Year(dPerFim))
		ENDIF
		
		DPERINI := CTOD(DPERINI)
		
	ELSE
		ALERT("ATENวรO!!! O MสS "+STRZERO(MONTH(dPerFim),2)+" NรO PODE EFETUAR O CALCULO ANUAL, VERIFIQUE OS DADOS DO CALENDARIO QUE ESTม SENDO INCLUอDO")
		Return (.F.)
	ENDIF
	
	
ELSE // MENSAL
	dPerIni := CTOD("01/"+StrZero(Month(dDataFech),2)+"/"+Str(Year(dDataFech)))
	dPerFim := LastDay(dPerini)
ENDIF

lRet := .T.
Return(dPerIni)