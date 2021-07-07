#INCLUDE "PROTHEUS.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RCDAR02A  � Autor � ANDERSON CIRIACO     � Data � 19/07/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RELATORIO DE CONFERENCIA DE DIREITOS AUTORAIS              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � RCDAR01A()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RCDAR02A()

Local oReport
Private cPerg := Padr("RCDAR02A",10)

//Correcao no Grupo de Perguntas
AjustaSX1()

//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Divergencias de Pedidos de Compras   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local cTitle   := "CONFERENCIA D.A. FATURAMENTO" //"Relacao de Divergencias de Pedidos de Compras"
Local oReport
Local oSection1
Local oSection2
Local cAlias01 := GetNextAlias()
Local cAlias02 := GetNextAlias()

AjustaSx1()
//������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                   �
//� mv_par01 // a partir da data de recebimento                            �
//� mv_par02 // ate a data de recebimento                                  �
//� mv_par03 // Lista itens Pedido - Que constam na NF / todos os itens    �
//��������������������������������������������������������������������������
//Pergunte("MTR130",.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("RCDAR02A","CONFERENCIA D.A. X FATURAMENTO","RCDAR02A", {|oReport| ReportPrint(oReport,cAlias01,cAlias02)},"CONFERENCIA DE D.A. X FATURAMENTO") //"Emissao da Relacao de Itens para Compras com divergencias"
oReport:SetTotalInLine(.F.)
oReport:SetLandscape()
Pergunte(oReport:uParam,.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relatorio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de codigo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,"RELA��O DE ITENS DE D.A.",{"AH1","AH4"},/*aOrdem*/)
//oSection1:SetHeaderPage()
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"AH1_PERIOD"    ,CALIAS01,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"AH1_PRODUT"    ,CALIAS01,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"AH1_FORNEC"    ,CALIAS01,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"AH1_LOJAFO"    ,CALIAS01,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"QUANTID"       ,CALIAS01,"Quantidade Registrada em D.A.","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"VAL_ACU"       ,CALIAS01,"Valor Acumulado Registrado em D.A.","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"VLORD"         ,CALIAS01,"Valor de D.A.","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")


oSection2:= TRSection():New(oSection1,"RELA��O DE ITENS DE FATURAMENTO",{"SD2","SB1"})
oSection2:SetHeaderPage()
oSection2 :SetTotalInLine(.F.)

TRCell():New(oSection2,"D2_COD"    		,CALIAS02,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_TES"	  		,CALIAS02,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"TOTD2"			,CALIAS02,"Valor Acumulado de Venda","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

//TRFunction():NEW(oSection1:CELL("VLORD"),NIL,"SUM",,,"@E 999,999,999.99",,.F.)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Divergencias de Pedidos de Compras   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAlias01,cAlias02)

Local dDataSav   := ctod("")
Local aItPcNotNF := {}
Local cCondPagto := ""
Local cNumPcSD1  := ""
Local cItemPcSD1 := ""
Local lPrint   := .F.
Local cNomArq  := ""
Local nExiste    := 0
Local nX         := 0
Local bEval
Local aSalAlmox:= {} 
Local oSection1:= oReport:Section(1) 
Local oSection2:= oReport:Section(1):Section(1)

Private nValorSC7:= 0

dbSelectArea("SD2")
dbSetOrder(1)


//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������


//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
oReport:Section(1):BeginQuery()

BeginSql Alias cAlias01
	
	SELECT AH1_FORNEC, AH1_LOJAFO,AH1_PRODUT, AH1_PERIOD, ROUND(SUM(AH4_QTDACU),2) QUANTID, ROUND(SUM(AH4_VALACU),2) VAL_ACU , ROUND(SUM(AH4_VALORD),2) VLORD
	FROM AH1010 AH1, AH4010 AH4
	WHERE AH1_FORNEC = AH4_FORNEC
	AND AH1_LOJAFO = AH4_LOJAFO
	AND AH1_PRODUT = AH4_PRODUT
	AND AH4_DTPRES = %Exp:mv_par01%
	AND AH1_PERIOD = %Exp:mv_par02%
	AND AH4.D_E_L_E_T_ <> '*'
	AND AH1.D_E_L_E_T_<> '*'
	GROUP BY AH1_FORNEC, AH1_LOJAFO,AH4_FILIAL,AH1_PRODUT, AH1_PERIOD
	ORDER BY AH1_PERIOD, AH1_FORNEC, AH1_LOJAFO, AH1_PRODUT
	
EndSql

oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

oReport:SetMeter((cAlias01)->(LastRec()))
oReport:Section(1):Init()

_CPARAM := firstday(mv_par01-(val(mv_par02)*day(mv_par01)-31))


While !oReport:Cancel() .And. !(cAlias01)->(Eof())
	If lPrint
		oReport:SkipLine() 
		oReport:ThinLine()
		lPrint := .F.
	EndIf
	oSection1:PrintLine()
	
	oSection2:Init()
	
	oSection2:BeginQuery()
	
	BeginSql Alias cAlias02
		
		SELECT D2_COD, D2_TES, SUM(D2_TOTAL) TOTD2
		FROM SD2010
		WHERE D2_COD = %Exp:(cAlias01)->AH1_PRODUT%
		AND D_E_L_E_T_ <> '*'
		AND D2_EMISSAO BETWEEN %Exp:_CPARAM% AND %Exp:mv_par01%
		AND D2_TES IN (%Exp:STRTRAN(GETMV("MV_CDAVEND"),"/","','")%)
		GROUP BY D2_COD, D2_TES
		
	EndSql
	
	oSection2:EndQuery()
	While !oReport:Cancel() .And. !(cAlias02)->(Eof())   
	//oReport:SkipLine(1)
	oSection2:PrintLine()        
		
	   //	oSection2:Cell("D2_COD"):SetValue((calias02)->D2_COD)
		//oSection2:Cell("D2_TES"):SetValue((calias02)->D2_TES)
		//oSection2:Cell("TOTD2"):SetValue((calias02)->TOTD2)
		
		//oSection2:Cell("D2_COD"):SHOW()
		//oSection2:Cell("D2_TES"):SHOW()
		//oSection2:Cell("TOTD2"):SHOW()
		
		dbSelectArea(cAlias02)
		dbSkip()
	EndDo   
   //	oSection2:PrintLine()
	oSection2:Finish() 
	   //	oSection2:SetPageBreak(.T.)
		oReport:SkipLine() 
		oReport:ThinLine()

		
	dbSelectArea(cAlias01)
	dbSkip()  

	oReport:IncMeter()
EndDo

oSection1:Finish()
//oReport:Section(1):Section(1):Finish()
oSection1:SetPageBreak(.T.)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1  � Autor �ANDERSON CIRIACO    � Data � 02/07/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Correcoes no SX1                                     		  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nulo                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local aArea   := GetArea()
Local aHelpPor:= {}
Local aHelpEng:= {}
Local aHelpSpa:= {}

Aadd( aHelpPor, "Informe a Data de Fechamento do DA" )
Aadd( aHelpEng, "Informe a Data de Fechamento do DA" )
Aadd( aHelpSpa, "Informe a Data de Fechamento do DA" )
PutSx1( "RCDAR02A", "01","Data de Fechamento ","Data de Fechamento ","Data de Fechamento ","mv_ch01","D",8,0,1,"G","","","","",;
"mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Aadd( aHelpPor, "Informe o Periodo do DA" )
Aadd( aHelpEng, "Informe o Periodo do DA" )
Aadd( aHelpSpa, "Informe o Periodo do DA" )
PutSx1( "RCDAR02A", "02","Periodo do DA ","Periodo do DA ","Periodo do DA ","mv_ch02","C",2,0,1,"G","","","","",;
"mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return Nil
