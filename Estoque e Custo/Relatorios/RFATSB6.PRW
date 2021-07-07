#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATSB6  ºAutor  ³ FONTANELLI         º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Poder de Terceiro por:                           º±±
±±º          ³ Area X Categoria X Sub-Categoria                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ABM                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATSB6()

Local   oReport
Local   aArea := GetArea()

Private cAliasQRY := GetNextAlias()

PRIVATE oSection1
PRIVATE oSection2
PRIVATE oSection3
PRIVATE oSection4

oReport := ReportDef()
oReport:PrintDialog()

RestArea(aArea)
Return nil


//----------------------------------------------------------------------------
Static Function ReportDef()
Local oReport
Local oCell
Local cPerg	:= "RFATSB6a"

cPerg := PADR(cPerg,10)
AjustaSX1(cPerg)
Pergunte(cPerg, .F.)

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

oReport := TReport():New("RFATSB6","Empresas Socias por Regional",cPerg, {|oReport| ReportPrint(oReport)},"  Este relatorio lista as informações de poder de terceiro.")
oReport:SetLandScape()  //oReport:SetPortrait()

//METHOD New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold) CLASS TRCell

oSection1 := TRSection():New(oReport,"AREA",{cAliasQRY})
TRCell():New(oSection1,"DAREA" 			, /*"SA1"*/,"Area"/*Titulo*/			,/*Picture*/		,40,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .T. /*lBold*/)
TRCell():New(oSection1,"DCATEGORIA" 	, /*"SA1"*/,"Categoria"/*Titulo*/		,/*Picture*/		,45,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .T. /*lBold*/)
TRCell():New(oSection1,"DSUBCATEGORIA" 	, /*"SA1"*/,"Sub-Categoria"/*Titulo*/	,/*Picture*/		,45,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .T. /*lBold*/)
oSection1:SetHeaderPage(.f.)

oSection2 := TRSection():New(oReport,"CLIENTE",{cAliasQRY})
TRCell():New(oSection2,"CLIFOR"		 	, /*"SA1"*/,"Código"/*Titulo*/			,/*Picture*/		,06,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .T. /*lBold*/)
TRCell():New(oSection2,"NOME"		 	, /*"SA1"*/,"Cliente"/*Titulo*/			,/*Picture*/   		,40,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .T. /*lBold*/)
oSection2:SetHeaderPage(.f.)

oSection3 := TRSection():New(oReport,"PRODUTO",{cAliasQRY})
TRCell():New(oSection3,"PRODUTO"    	, /*"SA1"*/,"Produto" /*Titulo*/		,/*Picture*/		,30/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection3,"DESCRICAO"  	, /*"SA1"*/,"Descrição" /*Titulo*/		,/*Picture*/		,150/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection3,"REMESSA"   		, /*"SA1"*/,"Rem." /*Titulo*/	 		,"@E 999,999" 		,07/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection3,"DEVOLUCAO" 		, /*"SA1"*/,"Dev." /*Titulo*/			,"@E 999,999" 		,07/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection3,"SALDO"  		, /*"SA1"*/,"Saldo" /*Titulo*/			,"@E 999,999,999" 	,12/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
oSection2:SetHeaderPage(.f.)

oSection4 := TRSection():New(oReport,"TOTAL",{cAliasQRY})
TRCell():New(oSection4,"NOME"           , /*"SA1"*/,/*Titulo*/					,/*Picture*/		,180,/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection4,"REMESSA"  		, /*"SA1"*/,/*Titulo*/					,"@E 999,999" 		,07/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection4,"DEVOLUCAO"  	, /*"SA1"*/,/*Titulo*/					,"@E 999,999" 		,07/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
TRCell():New(oSection4,"SALDO"			, /*"SA1"*/,/*Titulo*/					,"@E 999,999,999"	,12/*40Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/, .F. /*lBold*/)
oSection2:SetHeaderPage(.f.)

oSection1:SetEdit(.F.)
oSection2:SetEdit(.F.)
oSection3:SetEdit(.F.)
oSection4:SetEdit(.F.)

oSection1:SetTotalInLine(.F.)
oSection2:SetTotalInLine(.F.)
oSection3:SetTotalInLine(.F.)
oSection4:SetTotalInLine(.F.)

oSection4:SetHeaderSection(.F.)

oreport:nfontbody:=8
oreport:cfontbody:="Courier"

Return(oReport)


//----------------------------------------------------------------------------------------
Static Function ReportPrint(oReport)
Local cQuery

cQuery := " SELECT LOJA, CLIFOR, A1_NOME NOME, TPCF, " + CHR(13)+CHR(10)
cQuery += " 	   AREA, NVL(DAREA,' ') DAREA, " + CHR(13)+CHR(10)
cQuery += " 	   CATEGORIA, NVL(DCATEGORIA,' ') DCATEGORIA, " + CHR(13)+CHR(10)
cQuery += " 	   SUBCATEGORIA, NVL(DSUBCATEGORIA,' ') DSUBCATEGORIA,  " + CHR(13)+CHR(10)
cQuery += " 	   PRODUTO, SUBSTR(DESCRICAO,1,150) DESCRICAO, " + CHR(13)+CHR(10)
cQuery += " 	   ( SELECT NVL(SUM(B6_QUANT),0) FROM "+RetSqlName('SB6')+" SB6A " + CHR(13)+CHR(10)
cQuery += " 	      WHERE SB6A.B6_FILIAL = '"+xFilial('SB6')+"' " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6A.B6_CLIFOR = CLIFOR " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6A.B6_LOJA = LOJA " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6A.B6_PRODUTO = PRODUTO " + CHR(13)+CHR(10)
cQuery += " 			AND SB6A.B6_PODER3 = 'R' " + CHR(13)+CHR(10)
cQuery += " 			AND SB6A.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += "        ) REMESSA, " + CHR(13)+CHR(10)
cQuery += " 	   ( SELECT NVL(SUM(B6_QUANT),0) FROM "+RetSqlName('SB6')+" SB6B " + CHR(13)+CHR(10)
cQuery += " 	      WHERE SB6B.B6_FILIAL = '"+xFilial('SB6')+"' " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6B.B6_CLIFOR = CLIFOR " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6B.B6_LOJA = LOJA " + CHR(13)+CHR(10)
cQuery += " 			AND SB6B.B6_PRODUTO = PRODUTO " + CHR(13)+CHR(10)
cQuery += " 			AND SB6B.B6_PODER3 = 'D' " + CHR(13)+CHR(10)
cQuery += " 			AND SB6B.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += "        ) DEVOLUCAO, " + CHR(13)+CHR(10)
cQuery += " 	   ( " + CHR(13)+CHR(10)
cQuery += " 	   ( SELECT NVL(SUM(B6_QUANT),0) FROM "+RetSqlName('SB6')+" SB6C " + CHR(13)+CHR(10)
cQuery += " 	      WHERE SB6C.B6_FILIAL = '"+xFilial('SB6')+"' " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6C.B6_CLIFOR = CLIFOR " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6C.B6_LOJA = LOJA " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6C.B6_PRODUTO = PRODUTO " + CHR(13)+CHR(10)
cQuery += " 			AND SB6C.B6_PODER3 = 'R' " + CHR(13)+CHR(10)
cQuery += " 			AND SB6C.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += " 		) " + CHR(13)+CHR(10)
cQuery += " 		 - " + CHR(13)+CHR(10)
cQuery += " 		( " + CHR(13)+CHR(10)
cQuery += " 	     SELECT NVL(SUM(B6_QUANT),0) FROM "+RetSqlName('SB6')+" SB6D " + CHR(13)+CHR(10)
cQuery += " 	      WHERE SB6D.B6_FILIAL = '"+xFilial('SB6')+"' " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6D.B6_CLIFOR = CLIFOR " + CHR(13)+CHR(10)
cQuery += " 		    AND SB6D.B6_LOJA = LOJA " + CHR(13)+CHR(10)
cQuery += " 			AND SB6D.B6_PRODUTO = PRODUTO " + CHR(13)+CHR(10)
cQuery += " 			AND SB6D.B6_PODER3 = 'D' " + CHR(13)+CHR(10)
cQuery += " 			AND SB6D.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += "        ) " + CHR(13)+CHR(10)
cQuery += " 	   ) SALDO " + CHR(13)+CHR(10)
cQuery += "   FROM ( " + CHR(13)+CHR(10)
cQuery += " 			SELECT DISTINCT B6_LOJA LOJA, B6_CLIFOR CLIFOR, B6_TPCF TPCF, " + CHR(13)+CHR(10)
cQuery += " 							B6_PRODUTO PRODUTO, B1_DESC DESCRICAO, " + CHR(13)+CHR(10)
cQuery += " 							B1_DEPVTEX AREA, ZAC_DESCRI DAREA,  " + CHR(13)+CHR(10)
cQuery += " 							B1_CATEGOR CATEGORIA, ZAD_DESCRI DCATEGORIA, " + CHR(13)+CHR(10)
cQuery += " 							B1_VTSUBCA SUBCATEGORIA, ZAE_DESCRI DSUBCATEGORIA " + CHR(13)+CHR(10)
cQuery += " 			  FROM "+RetSqlName('SB6')+" SB6 " + CHR(13)+CHR(10)
cQuery += " 			  LEFT JOIN "+RetSqlName('SB1')+" SB1 ON SB1.B1_FILIAL = '"+xFilial('SB1')+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND SB1.B1_COD = SB6.B6_PRODUTO " + CHR(13)+CHR(10)
cQuery += " 								  AND SB1.B1_DEPVTEX BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND SB1.B1_CATEGOR BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND SB1.B1_VTSUBCA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND SB1.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += " 			  LEFT JOIN "+RetSqlName('ZAC')+" ZAC ON ZAC.ZAC_FILIAL = '"+xFilial('ZAC')+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND ZAC.ZAC_CODIGO = SB1.B1_DEPVTEX " + CHR(13)+CHR(10)
cQuery += " 								  AND ZAC.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += " 			  LEFT JOIN "+RetSqlName('ZAD')+" ZAD ON ZAD.ZAD_FILIAL = '"+xFilial('ZAD')+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND ZAD.ZAD_CODIGO = SB1.B1_CATEGOR " + CHR(13)+CHR(10)
cQuery += " 								  AND ZAD.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += " 			  LEFT JOIN "+RetSqlName('ZAE')+" ZAE ON ZAE.ZAE_FILIAL = '"+xFilial('ZAE')+"' " + CHR(13)+CHR(10)
cQuery += " 								  AND ZAE.ZAE_CODIGO = SB1.B1_VTSUBCA " + CHR(13)+CHR(10)
cQuery += " 								  AND ZAE.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += " 			 WHERE SB6.B6_FILIAL = '"+xFilial('SB6')+"' " + CHR(13)+CHR(10)
cQuery += " 			   AND SB6.B6_CLIFOR BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR09+"' " + CHR(13)+CHR(10)
cQuery += " 			   AND SB6.B6_LOJA BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR10+"' " + CHR(13)+CHR(10)
cQuery += " 			   AND SB6.B6_PRODUTO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' " + CHR(13)+CHR(10)
cQuery += " 			   AND SB6.B6_TPCF = 'C' " + CHR(13)+CHR(10)
cQuery += " 			   AND SB6.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += "        ) TMP " + CHR(13)+CHR(10)
cQuery += "    LEFT JOIN "+RetSqlName('SA1')+" SA1 ON SA1.A1_FILIAL = '"+xFilial('SA1')+"' " + CHR(13)+CHR(10)
cQuery += " 	  	     	   AND SA1.A1_COD = CLIFOR " + CHR(13)+CHR(10)
cQuery += " 				   AND SA1.A1_LOJA = LOJA " + CHR(13)+CHR(10)
cQuery += " 				   AND SA1.D_E_L_E_T_ = ' ' " + CHR(13)+CHR(10)
cQuery += " ORDER BY DAREA, DCATEGORIA, DSUBCATEGORIA, NOME, LOJA, PRODUTO " + CHR(13)+CHR(10)

dbUseArea( .T., "TOPCONN", TCGENQRY( ,,cQuery ), cAliasQRY , .F., .T. )

nREMESSA   := 0
nDEVOLUCAO := 0
nSALDO     := 0

nGREMESSA   := 0
nGDEVOLUCAO := 0
nGSALDO     := 0

Do While !Eof()

	oSection1:Init()
	oSection1:Cell("DAREA"):SetValue((cAliasQry)->DAREA)
	oSection1:Cell("DCATEGORIA"):SetValue((cAliasQry)->DCATEGORIA)
	oSection1:Cell("DSUBCATEGORIA"):SetValue((cAliasQry)->DSUBCATEGORIA)
	oSection1:PrintLine()
	oSection1:Finish()

	oSection2:Init()
	oSection2:Cell("CLIFOR"):SetValue((cAliasQry)->CLIFOR)
	oSection2:Cell("NOME"):SetValue((cAliasQry)->NOME)
	oSection2:PrintLine()
	oSection2:Finish()

	cQuebra := (cAliasQry)->DAREA+(cAliasQry)->DCATEGORIA+(cAliasQry)->DSUBCATEGORIA+(cAliasQry)->NOME+(cAliasQry)->LOJA

	oSection3:Init()
	Do While !Eof() .and. cQuebra == (cAliasQry)->DAREA+(cAliasQry)->DCATEGORIA+(cAliasQry)->DSUBCATEGORIA+(cAliasQry)->NOME+(cAliasQry)->LOJA

		oSection3:Cell("PRODUTO"):SetValue((cAliasQry)->PRODUTO)
		oSection3:Cell("DESCRICAO"):SetValue((cAliasQry)->DESCRICAO)
		oSection3:Cell("REMESSA"):SetValue((cAliasQry)->REMESSA)
		oSection3:Cell("DEVOLUCAO"):SetValue((cAliasQry)->DEVOLUCAO)
		oSection3:Cell("SALDO"):SetValue((cAliasQry)->SALDO)
		oSection3:PrintLine()
		oReport:IncMeter()

		nREMESSA   += (cAliasQry)->REMESSA
		nDEVOLUCAO += (cAliasQry)->DEVOLUCAO
		nSALDO     += (cAliasQry)->SALDO

		ngREMESSA   += (cAliasQry)->REMESSA
		ngDEVOLUCAO += (cAliasQry)->DEVOLUCAO
		ngSALDO     += (cAliasQry)->SALDO

	    dbSkip()

	endDO
	oSection3:Finish()

	oSection4:Init()
	oReport:Thinline()
	oSection4:Cell("NOME"):SetValue( "Total Area X Categoria X Sub-Categoria")
	oSection4:Cell("REMESSA"):SetValue(nREMESSA)
	oSection4:Cell("DEVOLUCAO"):SetValue(nDEVOLUCAO)
	oSection4:Cell("SALDO"):SetValue(nSALDO)
	oSection4:PrintLine()
	oSection4:Finish()

	oReport:SkipLine()
	oReport:Thinline()
	oReport:Thinline()
	oReport:Thinline()
	oReport:SkipLine()

	nREMESSA   := 0
	nDEVOLUCAO := 0
	nSALDO     := 0

endDO

oSection4:Init()
oReport:Thinline()
oSection4:Cell("NOME"):SetValue( "Total Geral" )
oSection4:Cell("REMESSA"):SetValue(nGREMESSA)
oSection4:Cell("DEVOLUCAO"):SetValue(nGDEVOLUCAO)
oSection4:Cell("SALDO"):SetValue(nGSALDO)
oSection4:PrintLine()
oSection4:Finish()


dbCloseArea()

Return NIL


//---------------------------------------------------------------
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()

// PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
//	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
//	cF3, cGrpSxg,cPyme,;
//	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
//	cDef02,cDefSpa2,cDefEng2,;
//	cDef03,cDefSpa3,cDefEng3,;
//	cDef04,cDefSpa4,cDefEng4,;
//	cDef05,cDefSpa5,cDefEng5,;
//	aHelpPor,aHelpEng,aHelpSpa,cHelp)

PutSx1(cPerg,"01","Area de ?"   		,".",".","mv_ch1","C",02,0,0,"G","","ZAC1","","","MV_PAR01")
PutSx1(cPerg,"02","Area ate ?"   		,".",".","mv_ch2","C",02,0,0,"G","","ZAC1","","","MV_PAR02")
PutSx1(cPerg,"03","Categoria de ?"		,".",".","mv_ch3","C",03,0,0,"G","","ZAFREL","","","MV_PAR03")
PutSx1(cPerg,"04","Categoria ate ?"		,".",".","mv_ch4","C",03,0,0,"G","","ZAFREL","","","MV_PAR04")
PutSx1(cPerg,"05","Sub-Categoria de ?"  ,".",".","mv_ch5","C",03,0,0,"G","","ZAGREL","","","MV_PAR05")
PutSx1(cPerg,"06","Sub-Categoria ate ?" ,".",".","mv_ch6","C",03,0,0,"G","","ZAGREL","","","MV_PAR06")
PutSx1(cPerg,"07","Cliente de ?"   		,".",".","mv_ch7","C",06,0,0,"G","","SA1","","","MV_PAR07")
PutSx1(cPerg,"08","Loja ate ?"   		,".",".","mv_ch8","C",02,0,0,"G","","","","","MV_PAR08")
PutSx1(cPerg,"09","Cliente ate ?"   	,".",".","mv_ch9","C",06,0,0,"G","","SA1","","","MV_PAR09")
PutSx1(cPerg,"10","Loja ate ?"   	    ,".",".","mv_cha","C",02,0,0,"G","","","","","MV_PAR10")
PutSx1(cPerg,"11","Produto de ?"   		,".",".","mv_chb","C",30,0,0,"G","","SB1","","","MV_PAR11")
PutSx1(cPerg,"12","Produto ate ?"   	,".",".","mv_chc","C",30,0,0,"G","","SB1","","","MV_PAR12")

RestArea( aArea )
Return Nil



