#INCLUDE "PROTHEUS.CH"
#DEFINE XPERG		"MNLNFENT"
#DEFINE XTITULO		"Relatório de Notas de Entrada com Centro de Custo"
#DEFINE XNOMEREL	"MNLNFENT"
#DEFINE XDESCRI		"Relatório de Notas de Entrada com Centro de Custo"
/*
-----------------------------------------------------------------------------------------------------
	Funcao     - MNLNFENT
	Autor      - Edmar Mendes do Prado
	Descricao  - TReport Exemplo
	Data       - 04/07/2018
-----------------------------------------------------------------------------------------------------	
*/
User Function MNLNFENT()
	Local   aArea		:= GetArea()
	Local   oReport		:= NIL
	Private cAliasQRY	:= GetNextAlias()
	
	oReport := ReportDef()
	oReport:PrintDialog()

	RestArea(aArea)
Return NIL
/*
-----------------------------------------------------------------------------------------------------
	Funcao     - ReportDef
	Autor      - Edmar Mendes do Prado
	Descricao  - Definicoes do Relatorio
	Data       - 04/07/2018
-----------------------------------------------------------------------------------------------------	
*/
Static Function ReportDef()
	Local oReport	:= NIL
	Local cPerg	:= PADR(XPERG, 10)
	
	AjustaSX1(cPerg)
	Pergunte(cPerg, .F.)
	
	oReport := TReport():New(XNOMEREL, XTITULO, cPerg, {|oReport| ReportPrint(oReport)}, XDESCRI)
	oReport:SetLandScape()
	
	oSection := TRSection():New(oReport, XTITULO, {cAliasQRY})
	
Return oReport
/*
-----------------------------------------------------------------------------------------------------
	Funcao     - ReportPrint
	Autor      - Edmar Mendes do Prado
	Descricao  - Impressao do Relatorio
	Data       - 04/07/2018
-----------------------------------------------------------------------------------------------------	
*/
Static Function ReportPrint(oReport)
	Local aAreaSX3	:= SX3->(GetArea())
	Local cQuery		:= ""
	Local oSection	:= oReport:Section(1)



	cQuery += "SELECT	" + CRLF															
	cQuery += "      D1_DTDIGIT                      AS Data_Digitacao		" + CRLF
	cQuery += "    , D1_EMISSAO                      AS Data_Emissao		" + CRLF
	cQuery += "    , D1_DOC                          AS Nota_Fiscal			" + CRLF
	cQuery += "    , D1_SERIE                        AS Serie				" + CRLF
	cQuery += "    , D1_ITEM                         AS Item				" + CRLF
	cQuery += "    , D1_TOTAL                        AS Valor				" + CRLF
	cQuery += "    , D1_COD                          AS Codigo_Produto			" + CRLF
	cQuery += "    , SUBSTR(B1_DESC,1,50)            AS Descricao_do_Produto	" + CRLF
	cQuery += "    , D1_FORNECE                      AS Codigo_Fornecedor		" + CRLF
	cQuery += "    , D1_LOJA                         AS Loja				" + CRLF
	cQuery += "    , A2_NREDUZ                       AS Nome_Fornecedor		" + CRLF

	cQuery += "    , A2_XTIPO                        AS Class_TI_Tipo		" + CRLF
	cQuery += "    , A2_XSEGMEN                      AS Class_TI_Segmento	" + CRLF
	cQuery += "    , A2_XUNIDNE                      AS Class_TI_Unid_Neg	" + CRLF
	
	cQuery += "    , D1_CLVL                         AS Unidade_Negocio 	" + CRLF
	cQuery += "    , CTH_DESC01                      AS Descricao_UN 		" + CRLF
	cQuery += "    , D1_CC                           AS Centro_Custo		" + CRLF
	cQuery += "    , CTT_DESC01                      AS Descricao_CC		" + CRLF
	cQuery += "    , (SELECT MIN (E2_VENCREA) FROM SE2010 SE2 WHERE   SE2.E2_FILIAL = '01' AND SD1.D1_DOC = SE2.E2_NUM 		" + CRLF
	cQuery += " 	AND SD1.D1_FORNECE = SE2.E2_FORNECE AND SD1.D1_LOJA = SE2.E2_LOJA AND SE2.D_E_L_E_T_ = ' ' )      AS Data_Venc_Primeira_Parcela 	" + CRLF
	cQuery += "    , (SELECT MAX (E2_VENCREA) FROM SE2010 SE2 WHERE   SE2.E2_FILIAL = '01' AND SD1.D1_DOC = SE2.E2_NUM 		" + CRLF
	cQuery += " 	AND SD1.D1_FORNECE = SE2.E2_FORNECE AND SD1.D1_LOJA = SE2.E2_LOJA AND SE2.D_E_L_E_T_ = ' ' )      AS Data_Venc_Ultima_Parcela		" + CRLF
  
	cQuery += "    FROM SD1010 SD1 	" + CRLF
    
	cQuery += "    INNER JOIN SB1010 SB1 ON (SD1.D1_FILIAL = SB1.B1_FILIAL AND SD1.D1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' )		" + CRLF
	cQuery += "    INNER JOIN SA2010 SA2 ON (SA2.A2_FILIAL = ' ' AND SD1.D1_FORNECE = SA2.A2_COD AND SD1.D1_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ = ' ')		" + CRLF
	cQuery += "    INNER JOIN CTT010 CTT ON (CTT.CTT_FILIAL = '01' AND SD1.D1_CC = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_ = ' ' )		" + CRLF
	cQuery += "    INNER JOIN CTH010 CTH ON (CTH.CTH_FILIAL = '01' AND SD1.D1_CLVL = CTH.CTH_CLVL AND CTH.D_E_L_E_T_ = ' ' )	" + CRLF
        
	cQuery += "    WHERE SD1.D_E_L_E_T_ = ' ' 							" + CRLF
	cQuery += "    AND D1_DTDIGIT BETWEEN   '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'" + CRLF
	cQuery += "    AND D1_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04+ "'					 " + CRLF
	
	cQuery += "    ORDER BY D1_DTDIGIT, D1_DOC, D1_SERIE				" + CRLF
    
    
	MemoWrite(XNOMEREL + ".sql", cQuery)
	
	cQuery := ChangeQuery(cQuery)
		
	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cAliasQRY, .T., .T.)
    
	If !(cAliasQRY)->(Eof()) 
		For nI := 1 to (cAliasQRY)->(FCount()) 

			TRCell():New(oSection, FieldName(nI), cAliasQRY, FieldName(nI), , Len((cAliasQry)->(FieldName(nI))))
			
		Next nI
	EndIf

	oSection:Print()

	If Select(cAliasQRY) > 0
		(cAliasQRY)->(DbCloseArea())
	EndIf
	SX3->(RestArea(aAreaSX3))
Return NIL
/*
-----------------------------------------------------------------------------------------------------
	Funcao     - AjustaSX1
	Autor      - Edmar Mendes do Prado
	Descricao  - Ajuste das Perguntas no SX1
	Data       - 04/07/2018
-----------------------------------------------------------------------------------------------------	
*/
Static Function AjustaSX1(cPerg)
	Local aArea := GetArea()

	PutSx1(cPerg,"01", "Da Dt. Entrada ?"		,"","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01")
	PutSx1(cPerg,"02", "Ate Dt. Entrada ?"		,"","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02")
	PutSx1(cPerg,"03", "Do C.C De ?"			,"","","mv_ch3","C",09,0,0,"G","","CTT","","","MV_PAR03")
	PutSx1(cPerg,"04", "Do C.C Ate ?"			,"","","mv_ch4","C",09,0,0,"G","","CTT","","","MV_PAR04")
		
	RestArea(aArea)
Return Nil