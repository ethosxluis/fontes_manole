#INCLUDE "PROTHEUS.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RCDAR01A  � Autor � ANDERSON CIRIACO     � Data � 19/07/13 ���
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

User Function RCDAR01A()

Local oReport
Private cPerg := Padr("RCDAR01A",10)

//Correcao no Grupo de Perguntas
AjustaSX1()

//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � ANDERSON CIRIACO      � Data �02/07/2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local nSaldo := 0
LOCAL OBREAK01

Local cAliasSZ2 := GetNextAlias()


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
oReport := TReport():New("RCDAR01A","CONFERENCIA D.A. x TITULO FINANCEIRO",CPERG, {|oReport| ReportPrint(oReport,cAliasSZ2)},"Este programa emite Rel. de Confer�ncia de Titulos Financeiros gerado pelo Controle de Direitos Autorais")
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
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oNSU := TRSection():New(oReport,"CONFERENCIA D.A. x TITULO FINANCEIRO",{"SE2","AH1","AH5","AH6"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oNSU:SetTotalInLine(.F.)

//Z2_COD, B1_DIV_USA, B1_FAM_USA, B1_CAT_USA, B1_SEG_USA, B1_DESC, Z2_NFVEN1, Z2_DATAV1, Z2_PRVEN, 0 COFINS, 0 DESCONTO, 0 BASE, Z2_GRUPO
TRCell():New(oNSU,"E2_NUM"		,cAliasSZ2,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"E2_FORNECE"	,cAliasSZ2,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"E2_LOJA"		,cAliasSZ2,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"E2_EMISSAO"	,cAliasSZ2,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"E2_VALOR"		,cAliasSZ2,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"E2_IRRF"	,cAliasSZ2,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"VALBRUT"	,cAliasSZ2,"Valor Bruto do Titulo","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"VALCALC"	,cAliasSZ2,"Valor do Calculo do DA","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"DIVERGEN"	,cAliasSZ2,"Divergencia Titulo X DA","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/)

//defini��o de linha de subtotal
//DEFINI��O DE VARIAVEL PARA QUEBRA DO RELATORIO
//OBREAK01 := TRBREAK():NEW(ONSU,"E2_FORNECE","Sub total",.F.)
//DEFINI��ES ABAIXO COM OS DADOS QUE SER�O SOMADOS NA QUEBRA
//TRFunction():NEW(oNSU:CELL("Z2_PRVEN"),NIL,"SUM",OBREAK01,,"@E 999,999,999.99",,.F.)
///TRFunction():NEW(oNSU:CELL("COFINS"),NIL,"SUM",OBREAK01,,"@E 999,999,999.99",,.F.)
//TRFunction():NEW(oNSU:CELL("DESCIT"),NIL,"SUM",OBREAK01,,"@E 999,999,999.99",,.F.)

//DEFINI��ES PARA O TOTAL GERAL DO RELATORIO - OBSERVA��O - PARA O TOTAL GERAL N�O � ATRIBUIDO UM OBJETO DE QUEBRA, VISTO QUE O MESMO N�O QUEBRA POR AGRUPAMENTO
TRFunction():NEW(oNSU:CELL("E2_VALOR"),NIL,"SUM",,,"@E 999,999,999.99",,.F.)
TRFunction():NEW(oNSU:CELL("E2_IRRF"),NIL,"SUM",,,"@E 999,999,999.99",,.F.)
TRFunction():NEW(oNSU:CELL("VALBRUT"),NIL,"SUM",,,"@E 999,999,999.99",,.F.)
TRFunction():NEW(oNSU:CELL("VALCALC"),NIL,"SUM",,,"@E 999,999,999.99",,.F.)
TRFunction():NEW(oNSU:CELL("DIVERGEN"),NIL,"SUM",,,"@E 999,999,999.99",,.F.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �ANDERSON CIRIACO       � Data �02/07/2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSZ2)

Local lPrint   := .F.

//oReport:Section(1):Section(1):Cell("NSALDO" ):SetBlock({|| nSaldo })

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SE2")

//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1
//��������������������������������������������������������������������������


//	, SUM(AH5_VALORD) , ROUND(SUM(AH5_VALORD),2) VALCALC
//	, ABS(E2_VALOR - ROUND(SUM(AH5_VALORD),2) + E2_IRRF) DIVERGEN


oReport:Section(1):BeginQuery()
BeginSql Alias cAliasSZ2

	SELECT E2.R_E_C_N_O_ REGE2, E2_NUM, E2_FORNECE, E2_EMISSAO, E2_VALOR, E2_IRRF, E2_VLCRUZ, E2_SALDO
	, E2_VALOR + E2_IRRF VALBRUT
	, ROUND(SUM(AH6_VALORD),2) VALCALC
	, ABS(E2_VALOR - ROUND(SUM(AH6_VALORD),2) + E2_IRRF) DIVERGEN
	FROM %table:SE2% E2, %table:AH6% AH6, %table:SA2% A2
	WHERE AH6.D_E_L_E_T_ <> '*'
	AND E2.D_E_L_E_T_ <> '*'
	AND A2.D_E_L_E_T_ <> '*'
	AND E2_EMISSAO = %Exp:mv_par01%
	AND E2_PREFIXO = 'RYI'
	AND E2_FORNECE = AH6_FORNEC
	AND E2_LOJA = AH6_LOJAFO
	AND E2_FORNECE = A2_COD
	AND E2_LOJA = A2_LOJA
	AND E2_EMISSAO = AH6_XDTCAL
	GROUP BY E2.R_E_C_N_O_ , E2_NUM, E2_FORNECE, E2_EMISSAO, E2_VALOR, E2_IRRF, E2_VLCRUZ, E2_SALDO
	ORDER BY E2_FORNECE

EndSql

//������������������������������������������������������������������������Ŀ
//�Metodo EndQuery ( Classe TRSection )                                    �
//�                                                                        �
//�Prepara o relat�rio para executar o Embedded SQL.                       �
//�                                                                        �
//�ExpA1 : Array com os parametros do tipo Range                           �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)


//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter((cAliasSZ2)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasSZ2)->(Eof())


	oReport:Section(1):PrintLine()

	If lPrint
		oReport:SkipLine()
		lPrint := .F.
	EndIf

	dbSelectArea(cAliasSZ2)
	dbSkip()
	oReport:IncMeter()

EndDo

oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.)

Return


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
PutSx1( "RCDAR01A", "01","Data de Fechamento ","Data de Fechamento ","Data de Fechamento ","mv_ch01","D",8,0,1,"G","","","","",;
"mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aArea)

Return Nil
