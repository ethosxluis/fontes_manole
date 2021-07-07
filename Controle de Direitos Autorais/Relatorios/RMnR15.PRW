#INCLUDE "CDAR015.ch"
#include "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MnR15  ³ Autor ³ Liber de Esteban      ³ Data ³ 08/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio periodico de direitos autorais (royalty).        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MnR15(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - controle de royalty (direito autoral)         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function RMnR15()

Private oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³ RMnR15.PRW ³ Autor ³ Leandro duarte ³ Data  ³ 24/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descriçao ³                                                            ³±±
±±³Descriçao ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local cTitulo	:= "Relatorio de conferencia Direitos Autorais"


Private cPerg      := "CDR015"
Private oSec1 := nil
Private oSec2 := nil
pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= TReport():New("CDR015",cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cTitulo)
	oReport:SetPortrait(.F.)
	oReport:SetLandscape(.T.)
	//oReport:nfontbody:=4
	//oReport:cfontbody:="Arial"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// regra para gravar a localização do SIGAMAT.EMP

	oSec1 := TRSection():New(oReport,"CABEÇALHO",{"TRB"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
	oSec1:SetTotalInLine(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                                ³
	//³                                                                        ³
	//³TRCell():New                                                            ³
	//³ExpO1 : Objeto TSection que a secao pertence                            ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
	//³ExpC3 : Nome da tabela de referencia da celula                          ³
	//³ExpC4 : Titulo da celula                                                ³
	//³        Default : X3Titulo()                                            ³
	//³ExpC5 : Picture                                                         ³
	//³        Default : X3_PICTURE                                            ³
	//³ExpC6 : Tamanho                                                         ³
	//³        Default : X3_TAMANHO                                            ³
	//³ExpL7 : Informe se o tamanho esta em pixel                              ³
	//³        Default : False                                                 ³
	//³ExpB8 : Bloco de código para impressao.                                 ³
	//³        Default : ExpC2                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	TRCell():New(oSec1,"cFornec" ,/*Tabela*/,"Fornecedor",/*Picture*/,9,/*lPixel*/,{|| cFornec })
	TRCell():New(oSec1,"cNomeFo" ,/*Tabela*/,"Nome do Fornecedor",/*Picture*/,60,/*lPixel*/,{|| cNomeFo })
	//TRCell():New(oSec1,"xxxxx" ,/*Tabela*/,"                                                                                            *************************A D I A N T A M E N T O*************************",/*Picture*/,10,/*lPixel*/,{|| cNomeFo })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Cabecalho no top da pagina                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):SetHeaderPage()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializa a outra sessao³
	//³A sessao dos detalhes    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSec2 := TRSection():New(oReport,"DETALHES",{"TRB"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
	oSec2:SetTotalInLine(.F.)

	TRCell():New(oSec2,"cProd" ,/*Tabela*/,"Produto",/*Picture*/,20,/*lPixel*/,{|| cProd  })
	TRCell():New(oSec2,"cNomeProd" ,/*Tabela*/,"Descrição",/*Picture*/,50,/*lPixel*/,{|| cNomeProd  })
	TRCell():New(oSec2,"cPer" ,/*Tabela*/,"Periodo",/*Picture*/,3,/*lPixel*/,{|| cPer  })
	TRCell():New(oSec2,"cXC" ,/*Tabela*/,"C",/*Picture*/,2,/*lPixel*/,{|| cXC  })
	TRCell():New(oSec2,"cMD" ,/*Tabela*/,"MD",/*Picture*/,2,/*lPixel*/,{|| cMD  })
	TRCell():New(oSec2,"cMesAno" ,/*Tabela*/,"Data",/*Picture*/,12,/*lPixel*/,{|| cMesAno  })
	TRCell():New(oSec2,"nQtdVen" ,/*Tabela*/,"Qtd."+CRLF+"Venda",/*Picture*/,15,/*lPixel*/,{|| nQtdVen  })
	TRCell():New(oSec2,"nPrcPrd" ,/*Tabela*/,"Preço"+CRLF+"Prod",/*Picture*/,15,/*lPixel*/,{|| nPrcPrd  })
	TRCell():New(oSec2,"nQtdDev" ,/*Tabela*/,"Qtd"+CRLF+"Devol",/*Picture*/,15,/*lPixel*/,{|| nQtdDev  })
	TRCell():New(oSec2,"nQtdLiq" ,/*Tabela*/,"Qtd"+CRLF+"Liquida",/*Picture*/,15,/*lPixel*/,{|| nQtdLiq })
	TRCell():New(oSec2,"nIRRF" ,/*Tabela*/,"IRRF",/*Picture*/,8,/*lPixel*/,{|| nIRRF })
	TRCell():New(oSec2,"nBsDa" ,/*Tabela*/,"Base "+CRLF+"P/ D.A.",/*Picture*/,20,/*lPixel*/,{|| nBsDa })
	TRCell():New(oSec2,"nPerDA" ,/*Tabela*/,"% D.A",/*Picture*/,10,/*lPixel*/,{|| nPerDA  })
	TRCell():New(oSec2,"nVLDA" ,/*Tabela*/,"Valor "+CRLF+"D.A",/*Picture*/,15,/*lPixel*/,{|| nVLDA  })
	TRCell():New(oSec2,"nVLPgt" ,/*Tabela*/,"Valor"+CRLF+"Pagar",/*Picture*/,15,/*lPixel*/,{|| nVLPgt  })
	TRCell():New(oSec2,"cTP" ,/*Tabela*/,"Tp",/*Picture*/,2,/*lPixel*/,{|| cTp  })
	TRCell():New(oSec2,"nVLTot" ,/*Tabela*/,"Valor"+CRLF+"Total",/*Picture*/,15,/*lPixel*/,{|| nVLTot })
	TRCell():New(oSec2,"nSldQtd" ,/*Tabela*/,"Saldo"+CRLF+"Qtde",/*Picture*/,15,/*lPixel*/,{|| nSldQtd })
	TRCell():New(oSec2,"nSldVl" ,/*Tabela*/,"Saldo"+CRLF+"Valor",/*Picture*/,15,/*lPixel*/,{|| nSldVl })
	TRCell():New(oSec2,"cMd" ,/*Tabela*/,"Md",/*Picture*/,4,/*lPixel*/,{|| cMd })
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Cabecalho no top da pagina                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(2):SetHeaderPage()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas 									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte(oReport:uParam,.F.)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³LEANDRO DUARTE      º Data ³  04/28/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 E P12                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)
Local cAliasTRB	:= GETNEXTALIAS()
Local nxFor := 0
Local nFor := 0
Private cFornec := ""
Private cAdiant	:= ""
Private cZero	:= ""
Private cNomeFo := ""
Private cProd := ""
Private cNomeProd := ""
Private cPer := ""
Private cXC := ""
Private cMD := ""
Private cMesAno := ""
Private nQtdVen := ""
Private nPrcPrd := ""
Private nQtdDev := ""
Private nQtdLiq := ""
Private nBsDa := ""
Private nPerDA := ""
Private nVLDA := ""
Private nVLPgt := ""
Private cTp := ""
Private nVLTot := ""
Private nSldQtd := ""
Private nSldVl := ""
Private aDados := {}
Private aTot	:= {}
Private nIRRF := 0
Private lPulaTot := .F.


oReport:Section(1):Cell("cFornec"):SetBlock({|| cFornec })
oReport:Section(1):Cell("cNomeFo"):SetBlock({|| cNomeFo })
oReport:Section(2):Cell("cProd"):SetBlock({|| cProd  })
oReport:Section(2):Cell("cNomeProd"):SetBlock({|| cNomeProd  })
oReport:Section(2):Cell("cPer"):SetBlock({|| cPer  })
oReport:Section(2):Cell("cXC"):SetBlock({|| cXC  })
oReport:Section(2):Cell("cMD"):SetBlock({|| cMD  })
oReport:Section(2):Cell("cMesAno"):SetBlock({|| cMesAno  })
oReport:Section(2):Cell("nQtdVen"):SetBlock({|| nQtdVen  })
oReport:Section(2):Cell("nPrcPrd"):SetBlock({|| nPrcPrd  })
oReport:Section(2):Cell("nQtdDev"):SetBlock({|| nQtdDev  })
oReport:Section(2):Cell("nQtdLiq"):SetBlock({|| nQtdLiq })
oReport:Section(2):Cell("nIRRF"):SetBlock({|| nIRRF })
oReport:Section(2):Cell("nBsDa"):SetBlock({|| nBsDa })
oReport:Section(2):Cell("nPerDA"):SetBlock({|| nPerDA  })
oReport:Section(2):Cell("nVLDA"):SetBlock({|| nVLDA  })
oReport:Section(2):Cell("nVLPgt"):SetBlock({|| nVLPgt  })
oReport:Section(2):Cell("cTP"):SetBlock({|| cTp  })
oReport:Section(2):Cell("nVLTot"):SetBlock({|| nVLTot })
oReport:Section(2):Cell("nSldQtd"):SetBlock({|| nSldQtd })
oReport:Section(2):Cell("nSldVl"):SetBlock({|| nSldVl })
oReport:Section(2):Cell("cMd"):SetBlock({|| cMd })


/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis utilizadas para parametros                         ³
³ mv_par01    // Mes/Ano da prestacao                          ³
³ mv_par02    // Periodicidade a ser impressa? ** (todos)      ³
³ mv_par03    // Fornecedor inicial                            ³
³ mv_par04    // Fornecedor final                              ³
³ mv_par05    // Produto inicial                               ³
³ mv_par06    // Produto final                                 ³
³ mv_par07    // Um por pagina (Fornecedor / Produto)          ³
³ mv_par08    // Relatorio ? Analitico / Sintetico             ³
³ mv_par09    // Imprime Zerado? Sim / Nao                     ³
³ mv_par10    // Imprime ? Com Adiant. / Sem Adiant. / Todos   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

cForne1	:= MV_PAR03
cForne2	:= MV_PAR04
cProd1	:= MV_PAR05
cProd2	:= MV_PAR06
dPerFinal := lastday(MV_PAR01)
dPerInici := FIRSTDAY(MV_PAR01)
if MV_PAR02=='**'
	cPeriod := "% AH1_PERIOD <> '**' %"
ELSE
	cPeriod := "% AH1_PERIOD = '"+MV_PAR02+"' %"
ENDIF
if MV_PAR09 == 1
	cZero := "% (AH5_VALORD >= 0 or AH5_VALORD <= 0) %"
ELSE
	cZero := "% AH5_VALORD <> 0 %"
ENDIF
if MV_PAR10 == 1
	cAdiant := "% AH1_SALDQT <> 0 %"
ELSEif MV_PAR10 == 2
	cAdiant := "% AH1_SALDQT = 0 %"
else
	cAdiant := "% (AH1_SALDQT = 0 or AH1_SALDQT <> 0) %"
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatorio                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()
BeginSql Alias cAliasTRB
SELECT AH1_PRODUT, AH1_FORNEC, AH1_LOJAFO, AH1_MOEDRO, AH1_MOEDA, AH1_SALDQT, AH1_VALADI, AH1_SALDOA, AH1_PERIOD, AH1_MOEDA
       AH4_PRODUT, AH4_FORNEC, AH4_LOJAFO, AH4_DATCAL, AH4_VALADI, AH4_QTDADI, AH4_LICITA, AH4_DTPRES,
       AH5_PRODUT, AH5_FORNEC, AH5_LOJAFO, AH5_DATCAL, AH5_VALORD, AH5_LICITA, AH5_XADIPE,
       AH5_PERCDA, AH5_QTDACU, AH5_PRECOU, AH5_BASEDA, AH5_DTPRES

FROM %table:AH1% AH1, %table:AH4% AH4, %table:AH5% AH5

WHERE AH1_FILIAL = %xFilial:AH1% AND AH1.%NotDel% AND
	  AH4_FILIAL = %xFilial:AH4% AND AH4.%NotDel% AND
	  AH4_DTPRES >= %Exp:dPerInici% AND AH4_DTPRES <= %Exp:dPerFinal% AND
	  AH5_FILIAL = %xFilial:AH5% AND AH5.%NotDel% AND
	  AH4_PRODUT = AH5_PRODUT AND AH4_FORNEC = AH5_FORNEC AND
	  AH4_LOJAFO = AH5_LOJAFO AND AH4_LICITA = AH5_LICITA AND AH4_DATCAL = AH5_DATCAL AND
	  %Exp:cPeriod% AND
	  %Exp:cAdiant% AND
	  %Exp:cZero% AND
	  AH1.AH1_FORNEC BETWEEN %Exp:cForne1% AND %Exp:cForne2% AND
	  AH1.AH1_PRODUT BETWEEN %Exp:cProd1% AND %Exp:cProd2% AND
	  AH4_DTPRES = AH5_DTPRES AND AH1.AH1_PRODUT = AH5.AH5_PRODUT AND
	  AH1.AH1_FORNEC = AH5.AH5_FORNEC AND AH1.AH1_LOJAFO = AH5.AH5_LOJAFO
ORDER BY AH1_FILIAL,AH1_FORNEC,AH1_LOJAFO,AH1_PRODUT

EndSql
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arqiuvo Temporario                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAliasTRB)->(dbGoTop())
oReport:SetMeter(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo para adicionar no Array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFor	:= {}
aDados	:= {}
aTot 	:= {}
aTtot	:= {}
nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTot7 :=  nTot8 := 0
nTTot1 := nTTot2 := nTTot3 := nTTot4 := nTTot5 := nTTot6 := nTTot7 :=  nTTot8 := 0
nTTGot1 := nTTGot2 := nTTGot3 := nTTGot4 := nTTGot5 := nTTGot6 := nTTGot7 :=  nTTGot8 := 0
nLinha	:= nValIRRF := 0
aTabela   := CD040AbrIR()
SA1->(DBSETORDER(1))
cAdiChave := ''
nTotParcial := 0
While !oReport:Cancel() .And. (cAliasTRB)->(!Eof())
	if aScan(aFor,{|x| x[1]==(cAliasTRB)->AH1_FORNEC+" - "+(cAliasTRB)->AH1_LOJAFO}) <= 0
		aadd(aFor,{(cAliasTRB)->AH1_FORNEC+" - "+(cAliasTRB)->AH1_LOJAFO, Posicione("SA2",1,XFILIAL("SA2")+(cAliasTRB)->AH1_FORNEC+(cAliasTRB)->AH1_LOJAFO,"A2_NOME"),{}})
		nLinha	:= 0
	endif
	nLinha++
	cTipoPag := ""
	nMoedAdt := 0
	dbSelectArea("AH3")
	AH3->(dbSeek( xFilial("AH3") + (cAliasTRB)->AH1_PRODUT + (cAliasTRB)->AH1_FORNEC + (cAliasTRB)->AH1_LOJAFO ))
	While xFilial("AH3") + (cAliasTRB)->AH1_PRODUT + (cAliasTRB)->AH1_FORNEC + (cAliasTRB)->AH1_LOJAFO == AH3->AH3_FILIAL+AH3->AH3_PRODUT+AH3->AH3_FORNEC+AH3->AH3_LOJAFO
		cTipoPag := Iif(Empty(cTipoPag),AH3->AH3_TIPOPA,cTipoPag)
		nMoedAdt := Iif(Empty(nMoedAdt),AH3->AH3_MDATIT,nMoedAdt)
		AH3->(dbSkip())
	End
	SA2->(DBSEEK(XFILIAL("SA2")+(cAliasTRB)->AH1_FORNEC+(cAliasTRB)->AH1_LOJAFO))
	if SA2->A2_TIPO == "F"
		nValIRRF := CD040CalIR((cAliasTRB)->AH5_VALORD,aTabela,dPerFinal)
	Else
		nValIRRF := 0
	Endif
	If SA2->A2_TXTRIBU > 0 .And. (cAliasTRB)->AH5_VALORD > 0
		nValIRRF := nValIRRF + Round((cAliasTRB)->AH5_VALORD*SA2->A2_TXTRIBU/100,2)
	Endif
	(cAliasTRB)->(aadd(aFor[LEN(aFor)][3],{AH1_FORNEC+" - "+AH1_LOJAFO,;//1
				Posicione("SA2",1,XFILIAL("SA2")+AH1_FORNEC+AH1_LOJAFO,"A2_NOME"),;//2
				AH1_PRODUT,;//3
				Posicione("SB1",1,XFILIAL("SB1")+AH1_PRODUT,"B1_DESC"),;//4
				AH1_PERIOD,;//5
				AH1_MOEDA,;//6
				AH1_MOEDRO,;//7
				substr(dtoc(AH4_DTPRES),4),;//8
				AH5_QTDACU,;//9
				AH5_PRECOU,;//10
				IIF(AH5_QTDACU>0,0,AH5_QTDACU),;//11
				IIF(AH5_QTDACU<0,0,AH5_QTDACU),;//12
				AH5_BASEDA,;//13
				AH5_PERCDA,;//14
				AH5_VALORD,;//15
				AH5_VALORD,;//16
				cTipoPag,;//17
				0,;//AH1_SALDOA,;//18
				AH1_SALDQT,;//19
				0,;//AH1_VALADI,;//20
				nMoedAdt,;
				nValIRRF}))

	nTot1 += aFor[LEN(aFor)][3][nLinha][09]
	nTot2 += aFor[LEN(aFor)][3][nLinha][11]
	nTot3 += aFor[LEN(aFor)][3][nLinha][12]
	nTot4 += aFor[LEN(aFor)][3][nLinha][15]
	nTot5 += aFor[LEN(aFor)][3][nLinha][16]
	nTot6 += aFor[LEN(aFor)][3][nLinha][19]
	
	//TRATAMENTO PARA O ADIANTAMENTO
	If (cAliasTRB)->(AH1_SALDOA) > 0 .AND. (cAliasTRB)->(AH1_FORNEC+AH1_LOJAFO+AH1_PRODUT) <> cAdiChave //fernando
		If (cAliasTRB)->(AH5_XADIPE) == 0//NÃO HOUVE FECHAMENTO
			nTot7 += (cAliasTRB)->(AH1_SALDOA)	
		Else
			nTot7 += (cAliasTRB)->(AH5_XADIPE)
		Endif		
		cAdiChave := (cAliasTRB)->(AH1_FORNEC+AH1_LOJAFO+AH1_PRODUT)
	Endif
	
	nTot8 += aFor[LEN(aFor)][3][nLinha][22]

	(cAliasTRB)->(dbskip())

	if ALLTRIM((cAliasTRB)->AH1_PRODUT) != ALLTRIM(aFor[LEN(aFor)][3][nLinha][3]) .or. (cAliasTRB)->AH1_FORNEC+" - "+(cAliasTRB)->AH1_LOJAFO != aFor[LEN(aFor)][3][nLinha][1]
		
		If nTot5 < nTot7 //fernando
			nTot5 := 0
		Else
			nTot5 := nTot5 - nTot7
		
		Endif	
		aadd(aFor[LEN(aFor)][3],{aFor[LEN(aFor)][3][nLinha][01],;
					aFor[LEN(aFor)][3][nLinha][02],;
					aFor[LEN(aFor)][3][nLinha][03],;
					aFor[LEN(aFor)][3][nLinha][04],;
					aFor[LEN(aFor)][3][nLinha][05],;
					aFor[LEN(aFor)][3][nLinha][06],;
					aFor[LEN(aFor)][3][nLinha][07],;
					aFor[LEN(aFor)][3][nLinha][08],;
					nTot1,;
					aFor[LEN(aFor)][3][nLinha][10],;
					nTot2,;
					nTot3,;
					aFor[LEN(aFor)][3][nLinha][13],;
					aFor[LEN(aFor)][3][nLinha][14],;
					nTot4,;
					nTot5,;
					aFor[LEN(aFor)][3][nLinha][17],;
					aFor[LEN(aFor)][3][nLinha][18],;
					nTot6,;
					nTot7,;
					aFor[LEN(aFor)][3][nLinha][21],;
					nTot8})
		nLinha++
		nTTot1 += nTot1
		nTTot2 += nTot2
		nTTot3 += nTot3
		nTTot4 += nTot4
		nTTot5 += nTot5
		nTTot6 += nTot6
		nTTot7 += nTot7
		nTTot8 += nTot8
		nTot1 := 0
		nTot2 := 0
		nTot3 := 0
		nTot4 := 0
		nTot5 := 0
		nTot6 := 0
		nTot7 := 0
		nTot8 := 0
		IF (cAliasTRB)->AH1_FORNEC+" - "+(cAliasTRB)->AH1_LOJAFO != aFor[LEN(aFor)][3][nLinha][1]
			
			aadd(aFor[LEN(aFor)][3],{aFor[LEN(aFor)][3][nLinha][01],;
						aFor[LEN(aFor)][3][nLinha][02],;
						aFor[LEN(aFor)][3][nLinha][03],;
						aFor[LEN(aFor)][3][nLinha][04],;
						aFor[LEN(aFor)][3][nLinha][05],;
						aFor[LEN(aFor)][3][nLinha][06],;
						aFor[LEN(aFor)][3][nLinha][07],;
						aFor[LEN(aFor)][3][nLinha][08],;
						nTTot1,;
						aFor[LEN(aFor)][3][nLinha][10],;
						nTTot2,;
						nTTot3,;
						aFor[LEN(aFor)][3][nLinha][13],;
						aFor[LEN(aFor)][3][nLinha][14],;
						nTTot4,;
						nTTot5,;
						aFor[LEN(aFor)][3][nLinha][17],;
						aFor[LEN(aFor)][3][nLinha][18],;
						nTTot6,;
						nTTot7,;
						aFor[LEN(aFor)][3][nLinha][21],;
						nTTot8})
			nLinha++
			nTTGot1 += nTTot1
			nTTGot2 += nTTot2
			nTTGot3 += nTTot3
			nTTGot4 += nTTot4
			nTTGot5 += nTTot5
			nTTGot6 += nTTot6
			nTTGot7 += nTTot7
			nTTGot8 += nTTot8
			nTTot1 := 0
			nTTot2 := 0
			nTTot3 := 0
			nTTot4 := 0
			nTTot5 := 0
			nTTot6 := 0
			nTTot7 := 0
			nTTot8 := 0
		ENDIF
	endif
end
nLinha--
if len(aFor)>0
	
aadd(aFor[LEN(aFor)][3],{aFor[LEN(aFor)][3][nLinha][01],;
						aFor[LEN(aFor)][3][nLinha][02],;
						aFor[LEN(aFor)][3][nLinha][03],;
						aFor[LEN(aFor)][3][nLinha][04],;
						aFor[LEN(aFor)][3][nLinha][05],;
						aFor[LEN(aFor)][3][nLinha][06],;
						aFor[LEN(aFor)][3][nLinha][07],;
						aFor[LEN(aFor)][3][nLinha][08],;
						nTTGot1,;
						aFor[LEN(aFor)][3][nLinha][10],;
						nTTGot2,;
						nTTGot3,;
						aFor[LEN(aFor)][3][nLinha][13],;
						aFor[LEN(aFor)][3][nLinha][14],;
						nTTGot4,;
						nTTGot5,;
						aFor[LEN(aFor)][3][nLinha][17],;
						aFor[LEN(aFor)][3][nLinha][18],;
						nTTGot6,;
						nTTGot7,;
						aFor[LEN(aFor)][3][nLinha][21],;
						nTTGot8})
endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³impressão do cabecalho da sessao 1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	oReport:Section(1):SetPageBreak(.T.)
else
	oReport:Section(1):Init()
endif
For nFor := 1 to len(aFor)
	if mv_par07 == 1
		oReport:Section(1):Init()
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³inicializa a sessao de detalhe³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFornec := aFor[nFor][1]
	cNomeFo := aFor[nFor][2]
	oReport:Section(1):Cell("cFornec"):Show()//HIDE()"
	oReport:Section(1):Cell("cNomeFo"):Show()//HIDE()"
	oReport:Section(1):PrintLine()//imprime a linha
	oReport:IncMeter()
	oReport:Section(2):Init()
	aDados := aFor[nFor][3]
	if mv_par08 == 1
		FOR nxFor := 1 to len(aDados)
			if nxFor+1 == len(aDados) .or. aDados[nxFor][03] != aDados[iif(nxFor+1 > len(aDados),len(aDados),nxFor+1)][03]
				cProd		:= "SubTotal do "
				cNomeProd	:= "Produto: "+aDados[nxFor][04]
				lPulaTot		:= .T.
			elseif nxFor == len(aDados)
				cProd		:= "Total do Autor "
				cNomeProd	:= aDados[nxFor][01]
			else
				cProd		:= aDados[nxFor][03]
				cNomeProd	:= aDados[nxFor][04]
			endif
			cPer		:= aDados[nxFor][05]
			cXC			:= aDados[nxFor][06]
			cMD			:= aDados[nxFor][07]
			cMesAno		:= aDados[nxFor][08]
			nQtdVen		:= aDados[nxFor][09]
			nPrcPrd		:= aDados[nxFor][10]
			nQtdDev		:= aDados[nxFor][11]
			nQtdLiq		:= aDados[nxFor][12]
			nBsDa		:= aDados[nxFor][13]
			nPerDA		:= aDados[nxFor][14]
			nVLDA		:= aDados[nxFor][15]
			nVLPgt		:= aDados[nxFor][16]
			cTp			:= aDados[nxFor][17]
			nVLTot		:= aDados[nxFor][18]
			nSldQtd		:= aDados[nxFor][19]
			nSldVl		:= aDados[nxFor][20]
			cMd			:= aDados[nxFor][21]
			oReport:Section(2):Cell("cProd"):Show()
			oReport:Section(2):Cell("cNomeProd"):Show()
			if nxFor+1 == len(aDados) .or.  nxFor == len(aDados) .or. aDados[nxFor][03] != aDados[iif(nxFor+1 > len(aDados),len(aDados),nxFor+1)][03]
				oReport:Section(2):Cell("cPer"):hide()
				oReport:Section(2):Cell("cXC"):hide()
				oReport:Section(2):Cell("cMD"):hide()
				oReport:Section(2):Cell("cMesAno"):Show()
				oReport:Section(2):Cell("nQtdVen"):Show()
				oReport:Section(2):Cell("nPrcPrd"):hide()
				oReport:Section(2):Cell("nQtdDev"):Show()
				oReport:Section(2):Cell("nQtdLiq"):Show()
				oReport:Section(2):Cell("nBsDa"):hide()
				oReport:Section(2):Cell("nPerDA"):hide()
				oReport:Section(2):Cell("nVLDA"):Show()
				oReport:Section(2):Cell("nVLPgt"):Show()
				oReport:Section(2):Cell("cTp"):hide()
				oReport:Section(2):Cell("nVLTot"):hide()
				oReport:Section(2):Cell("nSldQtd"):Show()
				oReport:Section(2):Cell("nSldVl"):Show()
				oReport:Section(2):Cell("cMd"):hide()
				oReport:ThinLine()
				oReport:lBold := .T.
			else
				oReport:Section(2):Cell("cPer"):Show()
				oReport:Section(2):Cell("cXC"):Show()
				oReport:Section(2):Cell("cMD"):Show()
				oReport:Section(2):Cell("cMesAno"):Show()
				oReport:Section(2):Cell("nQtdVen"):Show()
				oReport:Section(2):Cell("nPrcPrd"):Show()
				oReport:Section(2):Cell("nQtdDev"):Show()
				oReport:Section(2):Cell("nQtdLiq"):Show()
				oReport:Section(2):Cell("nBsDa"):Show()
				oReport:Section(2):Cell("nPerDA"):Show()
				oReport:Section(2):Cell("nVLDA"):Show()
				oReport:Section(2):Cell("nVLPgt"):Show()
				oReport:Section(2):Cell("cTp"):Show()
				oReport:Section(2):Cell("nVLTot"):Show()
				oReport:Section(2):Cell("nSldQtd"):Show()
				oReport:Section(2):Cell("nSldVl"):Show()
				oReport:Section(2):Cell("cMd"):Show()
			endif
			oReport:Section(2):PrintLine()//imprime a linha
			oReport:IncMeter()
			if lPulaTot
				lPulaTot := .F.
				oReport:SkipLine()
			endif
		Next nxFor
	else
		nxFor := len(aDados)
		cProd		:= "Total do Autor "
		cNomeProd		:= aDados[nxFor][01]
		cPer			:= aDados[nxFor][05]
		cXC			:= aDados[nxFor][06]
		cMD			:= aDados[nxFor][07]
		cMesAno		:= aDados[nxFor][08]
		nQtdVen		:= aDados[nxFor][09]
		nPrcPrd		:= aDados[nxFor][10]
		nQtdDev		:= aDados[nxFor][11]
		nQtdLiq		:= aDados[nxFor][12]
		nBsDa		:= aDados[nxFor][13]
		nPerDA		:= aDados[nxFor][14]
		nVLDA		:= aDados[nxFor][15]
		nVLPgt		:= aDados[nxFor][16]
		cTp			:= aDados[nxFor][17]
		nVLTot		:= aDados[nxFor][18]
		nSldQtd		:= aDados[nxFor][19]
		nSldVl		:= aDados[nxFor][20]
		cMd			:= aDados[nxFor][21]
		oReport:Section(2):Cell("cProd"):Show()
		oReport:Section(2):Cell("cNomeProd"):Show()
		oReport:Section(2):Cell("cPer"):hide()
		oReport:Section(2):Cell("cXC"):hide()
		oReport:Section(2):Cell("cMD"):hide()
		oReport:Section(2):Cell("cMesAno"):Show()
		oReport:Section(2):Cell("nQtdVen"):Show()
		oReport:Section(2):Cell("nPrcPrd"):hide()
		oReport:Section(2):Cell("nQtdDev"):Show()
		oReport:Section(2):Cell("nQtdLiq"):Show()
		oReport:Section(2):Cell("nBsDa"):hide()
		oReport:Section(2):Cell("nPerDA"):hide()
		oReport:Section(2):Cell("nVLDA"):Show()
		oReport:Section(2):Cell("nVLPgt"):Show()
		oReport:Section(2):Cell("cTp"):hide()
		oReport:Section(2):Cell("nVLTot"):hide()
		oReport:Section(2):Cell("nSldQtd"):Show()
		oReport:Section(2):Cell("nSldVl"):Show()
		oReport:Section(2):Cell("cMd"):hide()
		oReport:Section(2):PrintLine()//imprime a linha
		oReport:IncMeter()
		oReport:ThinLine()
		oReport:lBold := .T.
	endif
	oReport:SkipLine()
	if mv_par07 == 1
		oReport:Section(1):Finish()
		oReport:Section(1):SetPageBreak()
	endif
Next nFor

oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak()
oReport:Section(2):Finish()
oReport:Section(2):SetPageBreak()
(cAliasTRB)->(dbCloseArea())

Return