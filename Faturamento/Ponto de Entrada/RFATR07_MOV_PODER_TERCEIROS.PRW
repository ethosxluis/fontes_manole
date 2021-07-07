#include "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR07	  ºAutor  ³Sonia Kodaira       Data ³  18/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio - Movimentação em/de poder de terceiros          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR07()
Local oReport
Private cAliasTrbREL := GetNextAlias()
oReport := ReportDef()
oReport:PrintDialog()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RFATR07	 ºAutor  ³Sonia Kodaira       Data ³  18/03/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local oSection
Local oCell
Local cPerg	   := "MAN_RFATR7"
Local aOrd     := {"" }
Local aPergs   := {}
Local WOrdem   := ""

CriaSX1( cPerg )
Pergunte(cPerg,.T.)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                  	                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport := TReport():New("RFATR07","Relatorio da movimentacao de poder de terceiros",cPerg, {|oReport| ReportPrn(oReport)}," Este relatorio imprime a movimentação de poder de terceiros")

//oReport:SetPortrait()
oReport:Setlandscape()

//oReport:cFontBody := 'Lucida Fax'
//oReport:nFontBody := 07

oSection := TRSection():New(oReport,"SA1",{"SA1"},aOrd) // ""

//oSection:SetHeaderPage()

TRCell():New(oSection,"TR_CLIFOR"	,/*Tabela*/, "Codigo"      , /*Picture*/   ,TamSX3("B6_CLIFOR")[1],  /*lPixel*/, {|| (cAliasTrbREL)->TR_CLIFOR })
//TRCell():New(oSection,"TR_CLIFORL"	,/*Tabela*/, "LJ"          , /*Picture*/   ,TamSX3("B6_LOJA")[1],    /*lPixel*/, {|| (cAliasTrbREL)->TR_CLIFORL })
TRCell():New(oSection,"TR_CLIFORR"	,/*Tabela*/, "Razão Social", /*Picture*/   ,30,    /*lPixel*/, {|| (cAliasTrbREL)->TR_CLIFORR })
TRCell():New(oSection,"TR_DATA"		,/*Tabela*/, "Data"        , /*Picture*/   ,12,                      /*lPixel*/, {|| IIF((cAliasTrbREL)->TR_INDIMP <> "Z", (cAliasTrbREL)->TR_DATA, "") })
TRCell():New(oSection,"TR_PRODUTO"	,/*Tabela*/, "Produto"     , /*Picture*/   ,TamSX3("B1_COD")[1], /*lPixel*/, {|| (cAliasTrbREL)->TR_PRODUTO })
TRCell():New(oSection,"TR_LOCAL	"	,/*Tabela*/, "Local"  	   , /*Picture*/   ,05,                       /*lPixel*/, {|| (cAliasTrbREL)->TR_LOCAL })
TRCell():New(oSection,"TR_DESCRI"	,/*Tabela*/, "Descrição"   , /*Picture*/   ,TamSX3("B1_desc")[1],     /*lPixel*/, {|| (cAliasTrbREL)->TR_DESCRI })
TRCell():New(oSection,"TR_DOC	"	,/*Tabela*/, "Nota Fiscal" , /*Picture*/   ,12,                       /*lPixel*/, {|| (cAliasTrbREL)->TR_DOC })
TRCell():New(oSection,"TR_SERIE	"	,/*Tabela*/, "Serie"       , /*Picture*/   ,TamSX3("B6_SERIE")[1],    /*lPixel*/, {|| (cAliasTrbREL)->TR_SERIE })
TRCell():New(oSection,"TR_TES	"	,/*Tabela*/, "Tes"         , /*Picture*/   ,05,                       /*lPixel*/, {|| (cAliasTrbREL)->TR_TES })
TRCell():New(oSection,"TR_QTDENV"	,/*Tabela*/, "Qtd Enviada" , "@E 9999,999" , 8,    /*lPixel*/, {|| (cAliasTrbREL)->TR_QTDENV })
TRCell():New(oSection,"TR_QTDRET"	,/*Tabela*/, "Qtd Retorno" , "@E 9999,999" , 8,     /*lPixel*/, {|| (cAliasTrbREL)->TR_QTDRET })
TRCell():New(oSection,"TR_QTSALDO"	,/*Tabela*/, "Saldo" ,       "@E 9999,999" , 8,     /*lPixel*/, {|| (cAliasTrbREL)->TR_QTSALDO })
TRCell():New(oSection,"TR_VLRORIG"	,/*Tabela*/, "Vr Orig NF"   , "@E@Z 99999,999.99" ,TamSX3("B6_CUSTO1")[1],/*lPixel*/, {|| (cAliasTrbREL)->TR_VLRORIG })
TRCell():New(oSection,"TR_ORIGDOC"	,/*Tabela*/, "Doc. Orig"   , /*Picture*/   ,12,       /*lPixel*/, {|| (cAliasTrbREL)->TR_ORIGDOC })
TRCell():New(oSection,"TR_ORIGSER"	,/*Tabela*/, "Sorig"    , /*Picture*/   ,05,     /*lPixel*/, {|| (cAliasTrbREL)->TR_ORIGSER })
TRCell():New(oSection,"TR_VLRLIQ"	,/*Tabela*/, "Vr Liq NF"   , "@E@Z 99999,999.99" ,TamSX3("B6_CUSTO1")[1],/*lPixel*/, {|| (cAliasTrbREL)->TR_VLRLIQ })
TRCell():New(oSection,"TR_VLRTOT"	,/*Tabela*/, "Total Liq"   , "@E@Z 99999,999.99" ,TamSX3("B6_CUSTO1")[1],/*lPixel*/, {|| (cAliasTrbREL)->TR_VLRTOT })
TRCell():New(oSection,"TR_IDENT"	,/*Tabela*/, "IDENT"       , /*Picture*/   ,TamSX3("B6_IDENT")[1],    /*lPixel*/, {|| (cAliasTrbREL)->TR_IDENT })

Return(oReport)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportPrint| Autor ³ Sonia Kodaira                 ³ Data ³18/03/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³                                                                     ³±±
±±³          ³                                                                     ³±±
±±³          ³                                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportPrn(oReport)

Local oSection  := oReport:Section(1)
Local nOrdem 	:= IIf(IsBlind(),Val(SX4->X4_ORDEM),oReport:Section(1):GetOrder())
Local nCnt      := 0
Local cWher1    := ""
Local cWhere    := ""
//Local nTGeral   := 0

Local nLin := 0
Local nPag := 1
Local nPulo := 90

Private W_PRIMPAG   := .T.
Private oFont10		:= TFont():New("Lucida Fax",10,10,,.F.,,,,.T.,.F.)
Private oFont10n 	:= TFont():New("Lucida Fax",10,10,,.T.,,,,.T.,.F.)
Private oFont12		:= TFont():New("Lucida Fax",12,12,,.F.,,,,.T.,.F.)
Private oFont12n 	:= TFont():New("Lucida Fax",12,12,,.T.,,,,.T.,.F.)
Private oFont14n 	:= TFont():New("Lucida Fax",14,14,,.T.,,,,.T.,.F.)
Private oFont16n 	:= TFont():New("Lucida Fax",16,16,,.T.,,,,.T.,.F.)

Private nOrdem := oSection:getOrder()

Processa( {|| U_CRIATRB() } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatorio da secao 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection:Init()

DBSELECTAREA(cAliasTrbREL)

(cAliasTrbREL)->(DbEval({|x| nCnt++}))
(cAliasTrbREL)->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define o total da regua da tela de processamento do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter( nCnt )

W_TT_SALDO := 0

DO While !(cAliasTrbREL)->(Eof())

	W_CLIFOR := (cAliasTrbREL)->( TR_CLIFOR )
	oReport:IncMeter()

	DO While !(cAliasTrbREL)->(Eof()) .AND. (cAliasTrbREL)->( TR_CLIFOR) == W_CLIFOR

		W_PRODUTO := (cAliasTrbREL)->( TR_PRODUTO )

		DO While !(cAliasTrbREL)->(Eof()) .AND. (cAliasTrbREL)->( TR_CLIFOR) == W_CLIFOR .AND. (cAliasTrbREL)->( TR_PRODUTO ) == W_PRODUTO

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Movimenta Regua de Processamento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oReport:Section(1):PrintLine()

		(cAliasTrbREL)->(DbSkip())

        ENDDO

		oReport:SkipLine()

	ENDDO

	IF !(cAliasTrbREL)->(Eof())
		oReport:EndPage()
		oReport:StartPage()
	ENDIF

EndDo

oSection:Finish()

(cAliasTrbREL)->(dbCloseArea())

Return NIL


///////////////////////////////////////////////////////////////////////////////////////////
/// CRIA O ARQUIVO DE TRABALHO                                                           //
//--------------------------------------------------------------------------------------------------------
USER Function CRIATrb()
//--------------------------------------------------------------------------------------------------------

Local aArea := GetArea()

aStruc := Array(0)

aAdd(aStruc,{"TR_INDIMP"	,"C", 1						, 0 })

aAdd(aStruc,{"TR_CLIFOR"	,"C", TamSX3("B6_CLIFOR")[1]	, TamSX3("B6_CLIFOR") [2] })
aAdd(aStruc,{"TR_CLIFORL"	,"C", TamSX3("B6_LOJA")[1]		, TamSX3("B6_LOJA")	  [2] })
aAdd(aStruc,{"TR_CLIFORR"	,"C", TamSX3("A1_NOME")[1]	    , TamSX3("A1_NOME")   [2] })
aAdd(aStruc,{"TR_DATA"	    ,"D", TamSX3("B6_EMISSAO")[1]		, TamSX3("B6_EMISSAO")[2] })
aAdd(aStruc,{"TR_PRODUTO"	,"C", 20	, 0 })
aAdd(aStruc,{"TR_LOCAL"		,"C", TamSX3("B6_LOCAL")[1]		, TamSX3("B6_LOCAL")  [2] })
aAdd(aStruc,{"TR_DESCRI "	,"C", TamSX3("B1_DESC")[1]	    , TamSX3("B1_DESC")   [2] })
aAdd(aStruc,{"TR_DOC	"	,"C", TamSX3("B6_DOC")[1]	    , TamSX3("B6_DOC")    [2] })
aAdd(aStruc,{"TR_SERIE	"	,"C", TamSX3("B6_SERIE")[1]	    , TamSX3("B6_SERIE")  [2] })
aAdd(aStruc,{"TR_TES	"	,"C", TamSX3("B6_TES")[1]	    , TamSX3("B6_TES")    [2] })
aAdd(aStruc,{"TR_QTDENV	"	,"N", TamSX3("B6_QUANT")[1]	    , TamSX3("B6_QUANT")  [2] })
aAdd(aStruc,{"TR_QTDRET	"	,"N", TamSX3("B6_QUANT")[1]	    , TamSX3("B6_QUANT")  [2] })
aAdd(aStruc,{"TR_QTSALDO"	,"N", TamSX3("B6_QUANT")[1]	    , TamSX3("B6_QUANT")  [2] })
aAdd(aStruc,{"TR_VLRORIG"	,"N", TamSX3("B6_CUSTO1")[1]	, TamSX3("B6_CUSTO1") [2] })
aAdd(aStruc,{"TR_ORIGDOC"	,"C", TamSX3("B6_DOC")[1]		, TamSX3("B6_DOC")	  [2] })
aAdd(aStruc,{"TR_ORIGSER"	,"C", TamSX3("B6_SERIE")[1]		, TamSX3("B6_SERIE")	  [2] })
aAdd(aStruc,{"TR_VLRLIQ"	,"N", TamSX3("B6_CUSTO1")[1]	, TamSX3("B6_CUSTO1") [2] })
aAdd(aStruc,{"TR_VLRTOT"	,"N", TamSX3("B6_CUSTO1")[1]	, TamSX3("B6_CUSTO1") [2] })
aAdd(aStruc,{"TR_IDENT"		,"C", TamSX3("B6_IDENT")[1]		, TamSX3("B6_IDENT") [2] })


cArq := CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cArq,cAliasTrbREL,.T.,.F.)

cArqInd := CriaTrab(Nil,.F.)

Indregua(cAliasTrbREL,cArqInd,"TR_CLIFOR + TR_PRODUTO  + TR_INDIMP + DTOS(TR_DATA)",,,)
dbSetOrder(1)


//////////////////////////////////////////////////////////////////////////////////////////////////////
// GERAR AS INFORMACOES PARA A PARTIR DA TABELA SB6                                                 //
//////////////////////////////////////////////////////////////////////////////////////////////////////

If Select("_QRYSB6") > 0
	_QRYSB6->( DbCloseArea() )
EndIf

cQuery := "SELECT * FROM " + RetSqlName( "SB6" ) + " SB6 "
cQuery += "WHERE D_E_L_E_T_= ' ' "
cQuery += " AND B6_FILIAL = '"         + XFILIAL("SB6") + "'"
cQuery += " AND B6_CLIFOR  BETWEEN '"  + MV_PAR01 + "' AND '" + MV_PAR02  + "'"
cQuery += " AND B6_PRODUTO BETWEEN '"  + MV_PAR03 + "' AND '" + MV_PAR04  + "'"
cQuery += " AND B6_EMISSAO BETWEEN '"  + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06)  + "'"

IF MV_PAR07 == 2 // SOMENTE COM SALDO
   cQuery += " AND B6_SALDO > 0 "
ENDIF

TcQuery CQUERY New Alias _QRYSB6

DBSELECTAREA("_QRYSB6")
DBGOTOP()
PROCREGUA(LASTREC())

DO While !_QRYSB6->(Eof())

	INCPROC( _QRYSB6->B6_CLIFOR + " - " + _QRYSB6->B6_PRODUTO)

	RECLOCK( cAliasTrbREL, .T.)

	(cAliasTrbREL)->TR_CLIFOR  := _QRYSB6->B6_CLIFOR
	(cAliasTrbREL)->TR_CLIFORL := _QRYSB6->B6_LOJA
	(cAliasTrbREL)->TR_CLIFORR := POSICIONE("SA1", 1, XFILIAL("SA1") + _QRYSB6->B6_CLIFOR, "A1_NOME")
	(cAliasTrbREL)->TR_DATA    := STOD(_QRYSB6->B6_EMISSAO)
	(cAliasTrbREL)->TR_PRODUTO := _QRYSB6->B6_PRODUTO
	(cAliasTrbREL)->TR_LOCAL   := _QRYSB6->B6_LOCAL
	(cAliasTrbREL)->TR_DESCRI  := POSICIONE("SB1", 1, XFILIAL("SB1") + _QRYSB6->B6_PRODUTO, "B1_DESC")
	(cAliasTrbREL)->TR_DOC     := _QRYSB6->B6_DOC
	(cAliasTrbREL)->TR_SERIE   := _QRYSB6->B6_SERIE
	(cAliasTrbREL)->TR_TES     := _QRYSB6->B6_TES
	(cAliasTrbREL)->TR_QTDENV  := IIF(_QRYSB6->B6_PODER3 == "R", _QRYSB6->B6_QUANT, 0)
	(cAliasTrbREL)->TR_QTDRET  := IIF(_QRYSB6->B6_PODER3 == "D", _QRYSB6->B6_QUANT, 0)
	(cAliasTrbREL)->TR_QTSALDO := _QRYSB6->B6_SALDO
	(cAliasTrbREL)->TR_IDENT   := _QRYSB6->B6_IDENT

	IF _QRYSB6->B6_PODER3 == "R"

		If Select("_QRYSD2") > 0
			_QRYSD2->( DbCloseArea() )
		EndIf

		cQuery := "SELECT * FROM " + RetSqlName( "SD2" ) + " SD2 "
		cQuery += "WHERE D_E_L_E_T_= ' ' "
		cQuery += " AND D2_FILIAL = '"  + XFILIAL("SD2") + "'"
		cQuery += " AND D2_CLIENTE = '"   +  _QRYSB6->B6_CLIFOR + "'"
		cQuery += " AND D2_LOJA   = '"   +  _QRYSB6->B6_LOJA + "'"
		cQuery += " AND D2_DOC   = '"   + _QRYSB6->B6_DOC + "'"
		cQuery += " AND D2_SERIE = '"   + _QRYSB6->B6_SERIE + "'"
		cQuery += " AND D2_COD   = '"   + _QRYSB6->B6_PRODUTO + "'"
		cQuery += " AND D2_EMISSAO = '" + _QRYSB6->B6_EMISSAO + "'"
		cQuery += " AND D2_TES   = '"   + _QRYSB6->B6_TES + "'"
		cQuery += " AND D2_IDENTB6 = '"   + _QRYSB6->B6_IDENT + "'"

		TcQuery CQUERY New Alias _QRYSD2
		(cAliasTrbREL)->TR_VLRORIG   := _QRYSD2->D2_PRUNIT
		(cAliasTrbREL)->TR_VLRLIQ    := _QRYSD2->D2_PRCVEN
		(cAliasTrbREL)->TR_VLRTOT    := ( _QRYSD2->D2_PRCVEN * _QRYSB6->B6_SALDO)
		_QRYSD2->( DbCloseArea() )
	ELSE

		If Select("_QRYSD1") > 0
			_QRYSD1->( DbCloseArea() )
		EndIf

		cQuery := "SELECT * FROM " + RetSqlName( "SD1" ) + " SD1 "
		cQuery += "WHERE D_E_L_E_T_= ' ' "
		cQuery += " AND D1_FILIAL = '"  + XFILIAL("SD1") + "'"
		cQuery += " AND D1_FORNECE  = '"   +  _QRYSB6->B6_CLIFOR + "'"
		cQuery += " AND D1_LOJA   = '"   +  _QRYSB6->B6_LOJA + "'"
		cQuery += " AND D1_DOC   = '"   +  _QRYSB6->B6_DOC + "'"
		cQuery += " AND D1_SERIE = '"   +  _QRYSB6->B6_SERIE + "'"
		cQuery += " AND D1_COD   = '"   + _QRYSB6->B6_PRODUTO + "'"
		cQuery += " AND D1_EMISSAO = '" + _QRYSB6->B6_EMISSAO + "'"
		cQuery += " AND D1_TES   = '"   +  _QRYSB6->B6_TES + "'"
		cQuery += " AND D1_IDENTB6 = '"   + _QRYSB6->B6_IDENT + "'"

		TcQuery CQUERY New Alias _QRYSD1
		(cAliasTrbREL)->TR_ORIGDOC := _QRYSD1->D1_NFORI
		(cAliasTrbREL)->TR_ORIGSER := _QRYSD1->D1_SERIORI
		(cAliasTrbREL)->TR_VLRORIG := _QRYSD1->D1_VUNIT
		_QRYSD1->( DbCloseArea() )
	ENDIF

	(cAliasTrbREL)->(MSUNLOCK())

	_QRYSB6->(DBSKIP())

ENDDO

DBSELECTAREA(cAliasTrbREL)
PROCREGUA( (cAliasTrbREL)->(LASTREC()))
(cAliasTrbREL)->(DbGoTop())

A_TOTAL := {}

DO While !(cAliasTrbREL)->(Eof())

	W_CLIFOR  :=  (cAliasTrbREL)->TR_CLIFOR
	W_CLIFORR :=  (cAliasTrbREL)->TR_CLIFORR
	W_PRODUTO :=  (cAliasTrbREL)->TR_PRODUTO

	W_QTDENV  := 0
	W_QTDRET  := 0
	W_QTSALDO := 0
	W_TOTAL   := 0
	W_QTDREG  := 0

	DO While !(cAliasTrbREL)->(Eof()) .AND. (cAliasTrbREL)->TR_CLIFOR + (cAliasTrbREL)->TR_PRODUTO == W_CLIFOR + W_PRODUTO

		W_QTDENV  += (cAliasTrbREL)->TR_QTDENV
		W_QTDRET  += (cAliasTrbREL)->TR_QTDRET
		W_QTSALDO += (cAliasTrbREL)->TR_QTSALDO
		W_TOTAL   += (cAliasTrbREL)->TR_VLRTOT

		W_QTDREG += 1

		(cAliasTrbREL)->(DBSKIP())

	ENDDO

	IF W_QTDREG > 1
		AADD(A_TOTAL, { W_CLIFOR, W_CLIFOR, W_PRODUTO, W_QTDENV, W_QTDRET, W_QTSALDO, W_TOTAL } )
	ENDIF

ENDDO

FOR W_I:=1 TO LEN(A_TOTAL)

	RECLOCK( cAliasTrbREL, .T.)

	(cAliasTrbREL)->TR_CLIFOR   := A_TOTAL[W_I][1]
	(cAliasTrbREL)->TR_CLIFORR  := A_TOTAL[W_I][2]
	(cAliasTrbREL)->TR_PRODUTO   := A_TOTAL[W_I][3]
	(cAliasTrbREL)->TR_INDIMP    := "Z"
	(cAliasTrbREL)->TR_DESCRI    := "TOTAL DO PRODUTO"
	(cAliasTrbREL)->TR_QTDENV    := A_TOTAL[W_I][4]
	(cAliasTrbREL)->TR_QTDRET    :=	A_TOTAL[W_I][5]
	(cAliasTrbREL)->TR_QTSALDO   :=	A_TOTAL[W_I][6]
	(cAliasTrbREL)->TR_VLRTOT    :=	A_TOTAL[W_I][7]
	(cAliasTrbREL)->(MSUNLOCK())

NEXT

RETURN()


//------------------------------------------------------------------------------------------------------//
Static Function CriaSX1(cPerg)
//------------------------------------------------------------------------------------------------------//

PutSx1( cPerg, "01", "Cliente De              ?", "", "", "mv_ch1", "C",  TamSX3("B6_CLIFOR")[1], 0, 0, "G", ""                                            , "SA1", "", "", "MV_PAR01" )
PutSx1( cPerg, "02", "cliente Ate             ?", "", "", "mv_ch2", "C",  TamSX3("B6_CLIFOR")[1], 0, 0, "G", "NaoVazio() .AND. MV_PAR02 >= MV_PAR01"       , "SA1", "", "", "MV_PAR02" )
PutSx1( cPerg, "03", "Produto De              ?", "", "", "mv_ch3", "C",  TamSX3("B6_PRODUTO")[1], 0, 0, "G", ""                                            , "SB1", "", "", "MV_PAR03" )
PutSx1( cPerg, "04", "Produto Ate             ?", "", "", "mv_ch4", "C",  TamSX3("B6_PRODUTO")[1], 0, 0, "G", "NaoVazio() .AND. MV_PAR04 >= MV_PAR03"       , "SB1", "", "", "MV_PAR04" )
PutSx1( cPerg, "05", "Data De                 ?", "", "", "mv_ch5", "D",  TamSX3("B6_EMISSAO")[1], 0, 0, "G", ""                                            , "", "", "", "MV_PAR05" )
PutSx1( cPerg, "06", "Data Ate                ?", "", "", "mv_ch6", "D",  TamSX3("B6_EMISSAO")[1], 0, 0, "G", "NaoVazio() .AND. MV_PAR06 >= MV_PAR05"       , "", "", "", "MV_PAR06" )
PutSx1( cPerg, "07", "Imprime movimentos      ?", "", "", 'mv_ch7', 'N',                       1 , 0, 0, 'C', ''                                            , '', '', '', 'mv_par07', 'Todos'     , 'Todos'     , 'Todos'     , '', 'Com Saldo', 'Com Saldo','Com Saldo')

RETURN()

