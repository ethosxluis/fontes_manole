#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNFATR024 บAutor  ณClaudio Macedo      บ Data ณ  02/01/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Faturamento por Perํodo                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Editora Manole                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function MNFATR024()

Local aArea   := GetArea()
Local oReport := ReportDef()

oReport:PrintDialog()
restarea(aArea)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDefบAutor  ณClaudio Macedo      บ Data ณ  02/01/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ReportDef Defini็๕es da celulas                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

Local aOrdem	   := {}
Local oReport	   := NIL
Local cAliasQRY    := GetNextAlias()
Local cPerg        := PADR("MNFATR024",10)
Local cAviso	   := "Relatorio de Faturamento por Perํodo"
Local oBreak1      := NIL

//Ajusta as Perguntas
AjustaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao do componente de impressao                                      ณ
//ณ                                                                        ณ
//ณTReport():New                                                           ณ
//ณExpC1 : Nome do relatorio                                               ณ
//ณExpC2 : Titulo                                                          ณ
//ณExpC3 : Pergunte                                                        ณ
//ณExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ณ
//ณExpC5 : Descricao                                                       ณ
//ณ                                                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport := TReport():New("MNFATR024","Relatorio de Faturamento por Perํodo", cPerg, {|oReport| ReportPrint(oReport,@cAliasQRY)}, cAviso)

//oReport:SetLandscape()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte(oReport:uParam,.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao da secao utilizada pelo relatorio                               ณ
//ณ                                                                        ณ
//ณTRSection():New                                                         ณ
//ณExpO1 : Objeto TReport que a secao pertence                             ณ
//ณExpC2 : Descricao da se็ao                                              ณ
//ณExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ณ
//ณ        sera considerada como principal para a se็ใo.                   ณ
//ณExpA4 : Array com as Ordens do relat๓rio                                ณ
//ณExpL5 : Carrega campos do SX3 como celulas                              ณ
//ณ        Default : False                                                 ณ
//ณExpL6 : Carrega ordens do Sindex                                        ณ
//ณ        Default : False                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oSection := TRSection():New(oReport,"Dados", cAliasQRY)                                                                                                                                                                       
oSection:SetTotalInLine(.F.)
oReport:SetLandscape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 9

// TRCell():New(oParent, cName, cAlias, cTitle, cPicture, nSize, lPixel, bBlock, cAlign, lLineBreak, cHeaderAlign, lCellBreak, nColSpace, lAutoSize, nClrBack, nClrFore, lBold)   

TRCell():New(oSection, "B1_UNEG"   , cAliasQRY, "Unidade de Neg๓cio"       , "@!", 18,,,"LEFT",,"LEFT",, 02,,,,.F.)
TRCell():New(oSection, "B1_DEPVTEX", cAliasQRY, "มrea"                     , "@!", 05,,,"LEFT",,"LEFT",, 02,,,,.F.)
TRCell():New(oSection, "ZAC_DESCRI", cAliasQRY, "Descri็ใo da มrea"        , "@!", 40,,,"LEFT",,"LEFT",, 02,,,,.F.)           
TRCell():New(oSection, "B1_CATEGOR", cAliasQRY, "Categoria"                , "@!", 09,,,"LEFT",,"LEFT",, 02,,,,.F.)
TRCell():New(oSection, "ZAD_DESCRI", cAliasQRY, "Descri็ใo da Categoria"   , "@!", 40,,,"LEFT",,"LEFT",, 02,,,,.F.)
TRCell():New(oSection, "B1_VTSUBCA", cAliasQRY, "Subcategoria"             , "@!", 12,,,"LEFT",,"LEFT",, 02,,,,.F.)
TRCell():New(oSection, "ZAE_DESCRI", cAliasQRY, "Descri็ใo da Subcategoria", "@!", 40,,,"LEFT",,"LEFT",, 02,,,,.F.)
TRCell():New(oSection, "D2_COD"    , cAliasQRY, "Produto"                  , "@!", 15,,,"LEFT",,"LEFT",, 02,,,,.F.)	
TRCell():New(oSection, "B1_CODBAR" , cAliasQRY, "C๓digo de Barras"         , "@!", 16,,,"LEFT",,"LEFT",, 02,,,,.F.)	
TRCell():New(oSection, "B1_DESC"   , cAliasQRY, "Descri็ใo do Produto"     , "@!", 80,,,"LEFT",,"LEFT",, 02,,,,.F.)	
TRCell():New(oSection, "D2_CLIENTE", cAliasQRY, "Cliente"                  , "@!", 07,,,"LEFT",,"LEFT",, 02,,,,.F.)	
TRCell():New(oSection, "D2_LOJA"   , cAliasQRY, "Loja"                     , "@!", 02,,,"LEFT",,"LEFT",, 02,,,,.F.)	
TRCell():New(oSection, "A1_NREDUZ" , cAliasQRY, "Nome do Cliente"          , "@!", 50,,,"LEFT",,"LEFT",, 02,,,,.F.)	
TRCell():New(oSection, "D2_TOTAL"  , cAliasQRY, "Valor Faturado"           , "@E 999,999,999.99", 14,,,"RIGHT" ,,"RIGHT" ,, 03,,,,.F.)	

oSection:SetPageBreak(.F.)
oSection:SetTotalText("")
oSection:SetHeaderPage()     
 
 Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrint Autor  ณRodrigo Leite     บ Data ณ  12/1106/16  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio Por quebra e totalizadores em TReport            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 	                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport,cAliasQRY)

Local oSection  := oReport:Section(1)
Local cOrdem    := 'SB1.B1_UNEG, SB1.B1_DEPVTEX, SB1.B1_CATEGOR, SB1.B1_VTSUBCA, SB1.B1_COD'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicio do Embedded SQL                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oSection:BeginQuery()
BeginSQL Alias cAliasQRY
		
	SELECT B1_UNEG, B1_DEPVTEX, ZAC_DESCRI, B1_CATEGOR, ZAD_DESCRI, B1_VTSUBCA, ZAE_DESCRI, D2_COD, B1_CODBAR , B1_DESC, D2_CLIENTE, D2_LOJA, A1_NREDUZ, D2_TOTAL
	FROM %Table:SD2% SD2 JOIN %Table:SF4% SF4 ON
		SF4.F4_CODIGO = SD2.D2_TES
	AND SF4.F4_DUPLIC = 'S'
	AND SF4.%notDel%  JOIN %Table:SA1% SA1 ON
		SA1.A1_COD = SD2.D2_CLIENTE
	AND SA1.A1_LOJA = SD2.D2_LOJA
	AND SA1.%notDel% JOIN %Table:SB1% SB1 ON
		SB1.B1_COD = SD2.D2_COD
	AND SB1.%notDel% LEFT OUTER JOIN %Table:ZAC% ZAC ON
		SB1.B1_DEPVTEX = ZAC.ZAC_CODIGO
	AND ZAC.%notDel% LEFT OUTER JOIN %Table:ZAD% ZAD ON
		SB1.B1_CATEGOR = ZAD.ZAD_CODIGO
	AND ZAD.%notDel% LEFT OUTER JOIN %Table:ZAE% ZAE ON
		SB1.B1_VTSUBCA = ZAE.ZAE_CODIGO
	AND ZAE.%notDel%
	WHERE D2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND SD2.%notDel%
	ORDER BY %Exp:cOrdem%
				
EndSQL
	
oSection:EndQuery()

oReport:SetMeter((cAliasQry)->(LastRec())) 
	 
(cAliasQry)->(dbGoTop())

oSection:Init() 


Do While(cAliasQry)->(!EOF()) 
		
	oSection:PrintLine()	  
	
	(cAliasQry)->(DBSKIP())					
			
EndDo
oReport:SkipLine()

oSection:Finish()	

END REPORT QUERY oReport:Section(1)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณClaudio Macedo      บ Data ณ 23/12/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta SX1                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

Local aRegs := {}

aHelpP	:= {}
aAdd(aHelpP, "Informe a Data de Emissao Inicial")
PutSx1(cPerg, '01', 'Data de Emissao de' , 'Data de Emissao de' , 'Data de Emissao de' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par01', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "Informe a Data de Emissao Inicial")
PutSx1(cPerg, '02', 'Data de Emissao ate' , 'Data de Emissao ate' , 'Data de Emissao ate' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par02', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

Return Nil
