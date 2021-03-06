#INCLUDE"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH" 
        
        
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MCDA099   �Autor  �ANDERSON CIRIACO    � Data �  06/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � CALENDARIOS DE FECHAMENTO DE DIREITOS AUTORAIS             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EDITORA MANOLE                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MCDA099()

Local cAlias  := "AHZ"
Local cTitulo := "Cadastro de Calend�rios de Direitos Autorais"
Local cVldExc := "DA099VldEx()"

If AliasInDic( cAlias )
	dbSelectArea( cAlias )
	AHZ->(dbSetOrder( 1 ))
	AxCadastro( cAlias, cTitulo )
Else
	MsgAlert( "Tabela de Calend�rios de D.A. (AHZ) n�o encontrada!" )
EndIf

Return Nil
                    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DA099VldEx�Autor  �Microsiga           � Data �  06/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �VALIDA A EXCLUS�O DE CALENDARIO, N�O PERMITINDO EXCLUIR DADOS��
���          �J� EFETIVADOS                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Help( " ", 1, "DA099VldEx", , "N�o Foi Possivel Excluir o calend�rio, pois o mesmo encontra-se efetivado!!! ", 1, 0 ) 
		Exit
	EndIf
	AHZ->(dbSkip())
EndDo

RestArea( aArea ) 

Return lRet  



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CD099Dtp  �Autor  �Microsiga           � Data �  06/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �calcula data inicial do periodo para grava��es de calculo   ���
���          �de Direitos Autorais                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CD099Dtp(dDataFech,xPeriodo)
Local aArea     := GetArea()
Local dPerIni
Local dPerFim
Local i         := 0
Local aSM0			:= AdmAbreSM0()
Local nContFil		:= 0

//��������������������������������������������������������������Ŀ
//� Periodo de processamento, do dia 01 do mes e ano informados  �
//� ate o ultimo dia do mes.                                     �
//����������������������������������������������������������������
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
		ALERT("ATEN��O!!! O M�S "+STRZERO(MONTH(dPerFim),2)+" N�O PODE EFETUAR O CALCULO BIMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE EST� SENDO INCLU�DO")
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
		ALERT("ATEN��O!!! O M�S "+STRZERO(MONTH(dPerFim),2)+" N�O PODE EFETUAR O CALCULO TRIMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE EST� SENDO INCLU�DO")
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
		ALERT("ATEN��O!!! O M�S "+STRZERO(MONTH(dPerFim),2)+" N�O PODE EFETUAR O CALCULO TRIMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE EST� SENDO INCLU�DO")
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
		ALERT("ATEN��O!!! O M�S "+STRZERO(MONTH(dPerFim),2)+" N�O PODE EFETUAR O CALCULO SEMESTRAL, VERIFIQUE OS DADOS DO CALENDARIO QUE EST� SENDO INCLU�DO")
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
		ALERT("ATEN��O!!! O M�S "+STRZERO(MONTH(dPerFim),2)+" N�O PODE EFETUAR O CALCULO ANUAL, VERIFIQUE OS DADOS DO CALENDARIO QUE EST� SENDO INCLU�DO")
		Return (.F.)
	ENDIF
	
	
ELSE // MENSAL
	dPerIni := CTOD("01/"+StrZero(Month(dDataFech),2)+"/"+Str(Year(dDataFech)))
	dPerFim := LastDay(dPerini)
ENDIF

lRet := .T.
Return(dPerIni)