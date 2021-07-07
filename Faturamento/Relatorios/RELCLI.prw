#include "rwmake.ch"
#include "protheus.ch"
#define DMPAPER_A4 9 


User Function RELCLI()
	local oReport
 
	oReport := reportDef()
	oReport:printDialog()
Return
 
static function reportDef()
	local oReport
	Local oSection1
	Local oSection2
	local cTitulo := '[RELCLI] - Impressão de NFs por Cliente'
 
	oReport := TReport():New('RELCLI', cTitulo, , {|oReport| PrintReport(oReport)},"Relatório de faturamento por cliente")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()
 
	oSection1 := TRSection():New(oReport,"Cliente",{"SF2"})
	oSection1:SetTotalInLine(.F.)
 
	TRCell():New(oSection1, "F2_DOC"	, "SF2", 'NOTA'		,PesqPict('SF2',"F2_DOC"),TamSX3("F2_DOC")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "F2_SERIE"	, "SF2", 'SERIE'	,PesqPict('SF2',"F2_SERIE"),TamSX3("F2_SERIE")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "F2_VALFAT"	, "SF2", 'VALOR'	,PesqPict('SF2',"F2_VALFAT"),TamSX3("F2_VALFAT")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "F2_EMISSAO", "SF2", 'DT. EMIS'	,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)

	oBreak := TRBreak():New(oSection1,oSection1:Cell("F2_CLIENTE"),,.F.)
 
//	TRFunction():New(oSection1:Cell("TES"),"TOTAL TES,"COUNT",oBreak,,"@E 999999",,.F.,.F.)
	TRFunction():New(oSection1:Cell("F2_VALFAT"),"TOTAL GERAL DO CLIENTE" ,"COUNT",,,"@E 999999",,.F.,.T.)	
    
return (oReport)
 
Static Function PrintReport(oReport)
	Local oSection1 := oReport:Section(1)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
 
	DbSelectArea('SF2') 
	dbSetOrder(2)
	dbGoTop()
	oReport:SetMeter(QRY->(RecCount()))
	
	dbSeek(xFilial("SF2")+'V00003') 

// Indice	
// F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE
	
	
	While SF2->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
 
		oReport:IncMeter() 
 
		oSection1:Cell("F2_DOC"):SetValue(SF2->F2_DOC)
		oSection1:Cell("F2_DOC"):SetAlign("CENTER")
 
		oSection1:Cell("F2_SERIE"):SetValue(SF2->F2_SERIE)
		oSection1:Cell("F2_SERIE"):SetAlign("CENTER")
 
		oSection1:Cell("F2_VALFAT"):SetValue(SF2->F2_VALFAT)
		oSection1:Cell("F2_VALFAT"):SetAlign("CENTER")
 
		oSection1:Cell("F2_EMISSAO"):SetValue(SF2->F2_EMISSAO)
		oSection1:Cell("F2_EMISSAO"):SetAlign("CENTER")
        
		oSection1:PrintLine()
 
		dbSelectArea("SF2")
		SF2->(dbSkip())
	EndDo
	oSection1:Finish()
Return