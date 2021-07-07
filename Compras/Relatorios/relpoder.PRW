#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELPODER  ºAutor  ³   FONTANELLI       º Data ³  30/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio poder de Terceiro                                º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

	// U_RELPODER()

User Function RELPODER()

Local   oReport
Local   aArea	  	:= GetArea()
Private cPerg     	:= "RELPODER2"
Private cAliasQRY 	:= GetNextAlias()
Private cCli		:= " "
Private nCont		:= 0

cPerg   := PADR(cPerg,10)

AjustaSX1(cPerg)

Pergunte(cPerg, .F.)

oReport := ReportDef()
oReport:PrintDialog()

if Select(cAliasQRY) > 0
	(cAliasQRY)->(DbCloseArea())
endif

RestArea( aArea )

Return nil

//----------------------------------------------------------------------------
Static Function ReportDef()

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

oReport := TReport():New("RELPODER","Novid. Cliente x Produto", cPerg , {|oReport| ReportPrint(oReport)} , " Novid. Cliente x Produto " )
//oReport:SetPortrait()
oReport:SetLandscape()
oReport:lHeaderVisible 		:= .T. 	// Não imprime cabeçalho do protheus
oReport:lFooterVisible		:= .T.	// Não imprime rodapé do protheus
oReport:lParamPage		  	:= .T.	// Não imprime pagina de parametros
oReport:oPage:nPaperSize  	:= 12	// Ajuste para papel A4

oSection := TRSection():New(oReport,"Novid. Cliente x Produto", cAliasQRY)
oSection:SetHeaderPage(.F.)

TRCell():New(oSection,"CODCLIE"			,cAliasQRY ,"CLIENTE"				,PesqPict("SA1","A1_COD")		, 09 /*TamSX3("A1_NOME")[1]*/	)
TRCell():New(oSection,"LOJCLIE"			,cAliasQRY ,"LOJA"					,PesqPict("SA1","A1_LOJA")		, 04 /*TamSX3("A1_NOME")[1]*/	)
TRCell():New(oSection,"NOMCLIE"			,cAliasQRY ,"NOME_CLIENTE"			,PesqPict("SA1","A1_NOME")		, 30 /*TamSX3("A1_NOME")[1]*/	)
TRCell():New(oSection,"CODVEND"			,cAliasQRY ,"VENDEDOR"				,PesqPict("SA3","A3_COD")		, 09 /*TamSX3("A1_NOME")[1]*/	)
TRCell():New(oSection,"NOMVEND"			,cAliasQRY ,"NOME_VENDEDOR"			,PesqPict("SA3","A3_NOME")		, 30 /*TamSX3("A1_NOME")[1]*/	)
TRCell():New(oSection,"B1_XDTLANC"		,cAliasQRY ,"DATA_PUBLICACAO"		,PesqPict("SB1","B1_XDTLANC")	, 15 /*TamSX3("B1_XDTLANC")[1]*/)
TRCell():New(oSection,"X5_DESCRI"		,cAliasQRY ,"SEGMENTO"				,PesqPict("SX5","X5_DESCRI")	, 20 /*TamSX3("X5_DESCRI")[1]*/	)
TRCell():New(oSection,"B1_COD"			,cAliasQRY ,"PRODUTO"				,PesqPict("SB1","B1_COD")		, 30/*TamSX3("B1_COD")[1]*/		)
TRCell():New(oSection,"B1_DESC"			,cAliasQRY ,"DESCRICAO"				,PesqPict("SB1","B1_DESC")		, 50/*TamSX3("B1_DESC")[1]*/  	)
TRCell():New(oSection,"B1_PRV1"			,cAliasQRY ,"PRECO_ATUAL" 			,PesqPict("SB1","B1_PRV1")		, TamSX3("B1_PRV1")[1]  		)
TRCell():New(oSection,"QTER_REQ"		,cAliasQRY ,"SAIDA_CONSIG"			,"999999999"					, TamSX3("B6_QUANT")[1]			)
TRCell():New(oSection,"QTER_DEV_SIMB"	,cAliasQRY ,"DEVOLUCAO_SIMBOLICA"	,"999999999"					, TamSX3("B6_QUANT")[1]			)
TRCell():New(oSection,"QTER_DEV_FIS"	,cAliasQRY ,"DEVOLUCAO_FISICA"		,"999999999"					, TamSX3("B6_QUANT")[1]			)
TRCell():New(oSection,"SALDO"			,cAliasQRY ,"SALDO_CONSIG_ATUAL"	,"999999999"					, TamSX3("B6_QUANT")[1]			)
TRCell():New(oSection,"VENDA"			,cAliasQRY ,"TOTAL_VENDA_ACERTO"	,"999999999"					, TamSX3("D2_QUANT")[1]			)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ FONTANELLI	 		³ Data ³07.06.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection  := oReport:Section(1)
Local cQuery	:= ""

if !EMPTY(MV_PAR01) .AND. !EMPTY(MV_PAR09)
	Alert("Não e permitido selecionar cliente e vendedor ao mesmo tempo!")
	return()
endif

cQuery:= " SELECT " +CHR(13)+CHR(10)
if !EMPTY(MV_PAR09)
	cQuery+= " 		 A1_COD, A1_LOJA, "+CHR(13)+CHR(10)
endif
cQuery+= " 		 B1_XDTLANC, B1_COD, SUBSTR(B1_DESC,1,50) B1_DESC, B1_XSEGME, B1_PRV1, "+CHR(13)+CHR(10)
cQuery+= "       ( SELECT X5_DESCRI FROM "+RETSQLNAME("SX5")+" WHERE X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA = '_A' AND X5_CHAVE = B1_XSEGME AND D_E_L_E_T_  = ' ' ) X5_DESCRI,
cQuery+= "       ( "+CHR(13)+CHR(10)
cQuery+= "         SELECT NVL(SUM(B6_QUANT),0) FROM "+RETSQLNAME("SB6")+" "+CHR(13)+CHR(10)
cQuery+= "          WHERE B6_FILIAL = '"+xFilial("SB6")+"' "+CHR(13)+CHR(10)
if !EMPTY(MV_PAR01)
	cQuery+= "        AND B6_CLIFOR = '"+MV_PAR01+"' "+CHR(13)+CHR(10)
	cQuery+= "        AND B6_LOJA = '"+MV_PAR02+"' "+CHR(13)+CHR(10)
endif
if !EMPTY(MV_PAR09)
	cQuery+= "        AND B6_CLIFOR = A1_COD "+CHR(13)+CHR(10)
	cQuery+= "        AND B6_LOJA = A1_LOJA "+CHR(13)+CHR(10)
endif
cQuery+= "            AND B6_PRODUTO = B1_COD "+CHR(13)+CHR(10)
cQuery+= "            AND B6_TIPO = 'E' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_PODER3 = 'R' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_ESTOQUE = 'S' "+CHR(13)+CHR(10)
cQuery+= "            AND D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= "        ) QTER_REQ, "+CHR(13)+CHR(10)
cQuery+= "        ( "+CHR(13)+CHR(10)
cQuery+= "          SELECT NVL(SUM(B6_QUANT),0) FROM "+RETSQLNAME("SB6")+" "+CHR(13)+CHR(10)
cQuery+= "           WHERE B6_FILIAL = '"+xFilial("SB6")+"' "+CHR(13)+CHR(10)
if !EMPTY(MV_PAR01)
	cQuery+= "        AND B6_CLIFOR = '"+MV_PAR01+"' "+CHR(13)+CHR(10)
	cQuery+= "        AND B6_LOJA = '"+MV_PAR02+"' "+CHR(13)+CHR(10)
endif
if !EMPTY(MV_PAR09)
	cQuery+= "        AND B6_CLIFOR = A1_COD "+CHR(13)+CHR(10)
	cQuery+= "        AND B6_LOJA = A1_LOJA "+CHR(13)+CHR(10)
endif
cQuery+= "            AND B6_PRODUTO = B1_COD "+CHR(13)+CHR(10)
cQuery+= "            AND B6_TIPO = 'E' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_PODER3 = 'D' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_ESTOQUE = 'S' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_TES IN (SELECT F4_CODIGO FROM "+RETSQLNAME("SF4")+" WHERE  F4_FILIAL = '01' AND F4_DUPLIC = 'N'  AND F4_PODER3 = 'D' AND F4_CF = '1918' AND D_E_L_E_T_ = ' ' )"
cQuery+= "            AND D_E_L_E_T_ = ' '  "+CHR(13)+CHR(10)
cQuery+= "         ) QTER_DEV_FIS, "+CHR(13)+CHR(10)
cQuery+= "        ( "+CHR(13)+CHR(10)
cQuery+= "          SELECT NVL(SUM(B6_QUANT),0) FROM "+RETSQLNAME("SB6")+" "+CHR(13)+CHR(10)
cQuery+= "           WHERE B6_FILIAL = '"+xFilial("SB6")+"' "+CHR(13)+CHR(10)
if !EMPTY(MV_PAR01)
	cQuery+= "        AND B6_CLIFOR = '"+MV_PAR01+"' "+CHR(13)+CHR(10)
	cQuery+= "        AND B6_LOJA = '"+MV_PAR02+"' "+CHR(13)+CHR(10)
endif
if !EMPTY(MV_PAR09)
	cQuery+= "        AND B6_CLIFOR = A1_COD "+CHR(13)+CHR(10)
	cQuery+= "        AND B6_LOJA = A1_LOJA "+CHR(13)+CHR(10)
endif
cQuery+= "            AND B6_PRODUTO = B1_COD "+CHR(13)+CHR(10)
cQuery+= "            AND B6_TIPO = 'E' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_PODER3 = 'D' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_ESTOQUE = 'S' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_TES IN (SELECT F4_CODIGO FROM "+RETSQLNAME("SF4")+" WHERE  F4_FILIAL = '01' AND F4_DUPLIC = 'N'  AND F4_PODER3 = 'D' AND F4_CF = '1919' AND D_E_L_E_T_ = ' ' )"
cQuery+= "            AND D_E_L_E_T_ = ' '  "+CHR(13)+CHR(10)
cQuery+= "         ) QTER_DEV_SIMB, "+CHR(13)+CHR(10)
cQuery+= "         ( "
cQuery+= "           SELECT NVL(SUM(D2_QUANT),0) FROM "+RETSQLNAME("SD2")+" "+CHR(13)+CHR(10)
cQuery+= "            WHERE D2_FILIAL = '"+xFilial("SD2")+"' "+CHR(13)+CHR(10)
cQuery+= "              AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)

if !EMPTY(MV_PAR01)
cQuery+= "              AND D2_CLIENTE = '"+MV_PAR01+"' "+CHR(13)+CHR(10)
cQuery+= "              AND D2_LOJA = '"+MV_PAR02+"' "+CHR(13)+CHR(10)
endif
if !EMPTY(MV_PAR09)
cQuery+= "              AND D2_CLIENTE = A1_COD "+CHR(13)+CHR(10)
cQuery+= "              AND D2_LOJA = A1_LOJA "+CHR(13)+CHR(10)
endif
cQuery+= "              AND D2_COD = B1_COD "+CHR(13)+CHR(10)
cQuery+= "              AND D2_TES IN ( SELECT F4_CODIGO FROM "+RETSQLNAME("SF4")+" WHERE F4_FILIAL = '"+xFilial("SF4")+"' AND F4_DUPLIC = 'S' AND F4_PODER3 = 'N' AND D_E_L_E_T_ = ' ' )"+CHR(13)+CHR(10)
cQuery+= "              AND D_E_L_E_T_ = ' '  "+CHR(13)+CHR(10)
cQuery+= "         ) VENDA "+CHR(13)+CHR(10)

if !EMPTY(MV_PAR01)
	cQuery+= "   FROM "+RETSQLNAME("SB1")+" "+CHR(13)+CHR(10)
	cQuery+= "  WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND B1_XDTLANC BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND B1_XSEGME BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
	cQuery+= " ORDER BY B1_XDTLANC, B1_XSEGME, B1_COD "+CHR(13)+CHR(10)
endif

if !EMPTY(MV_PAR09)
	cQuery+= "   FROM "+RETSQLNAME("SB1")+",  "+RETSQLNAME("SA1")+CHR(13)+CHR(10)
	cQuery+= "  WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND B1_XDTLANC BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND B1_XSEGME BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "+CHR(13)+CHR(10)
	cQuery+= "    AND "+RETSQLNAME("SB1")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
    cQuery+= "    AND A1_COD IN (SELECT A1_COD FROM "+RETSQLNAME("SA1")+" WHERE A1_VEND = '"+MV_PAR09+"' AND D_E_L_E_T_ = ' ') "+CHR(13)+CHR(10)
    cQuery+= "    AND "+RETSQLNAME("SA1")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
 	cQuery+= " ORDER BY A1_COD, B1_XDTLANC, B1_XSEGME, B1_COD "+CHR(13)+CHR(10)
endif

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.F.,.F.)
TcSetField(cAliasQry,"B1_XDTLANC","D")
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())
oSection:Init()
While (cAliasQry)->(!EOF())

	xCliente  := ""
	xLoja     := ""
	xNomeClie := ""
	xVendedor := ""
	xNomeVend := ""

	if !EMPTY(MV_PAR01)

		xCliente  := MV_PAR01
		xLoja     := MV_PAR02
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+xCliente+xLoja)
		   xNomeClie:= SA1->A1_NREDUZ
		   xVendedor:= SA1->A1_VEND
		EndIf
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+xVendedor)
		   xNomeVend:= SA3->A3_NOME
		EndIf

		osection:cell("CLIENTE"):setValue(xCliente)
		osection:cell("LOJA"):setValue(xLoja)
		osection:cell("NOME_CLIENTE"):setValue(xNomeClie)
		osection:cell("VENDEDOR"):setValue(xVendedor)
		osection:cell("NOME_VENDEDOR"):setValue(xNomeVend)
	endif

	if !EMPTY(MV_PAR09)

		xCliente  := (cAliasQry)->A1_COD
		xLoja     := (cAliasQry)->A1_LOJA
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+xCliente+xLoja)
		   xNomeClie:= SA1->A1_NREDUZ
		   xVendedor:= SA1->A1_VEND
		EndIf

		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+xVendedor)
		   xNomeVend:= SA3->A3_NOME
		EndIf

		osection:cell("CLIENTE"):setValue(xCliente)
		osection:cell("LOJA"):setValue(xLoja)
		osection:cell("NOME_CLIENTE"):setValue(xNomeClie)
		osection:cell("VENDEDOR"):setValue(xVendedor)
		osection:cell("NOME_VENDEDOR"):setValue(xNomeVend)
	endif

	osection:cell("DATA_PUBLICACAO"):setValue((cAliasQry)->B1_XDTLANC)
	osection:cell("SEGMENTO"):setValue((cAliasQry)->X5_DESCRI)
	osection:cell("PRODUTO"):setValue((cAliasQry)->B1_COD)
	osection:cell("DESCRICAO"):setValue((cAliasQry)->B1_DESC)
	osection:cell("PRECO_ATUAL"):setValue((cAliasQry)->B1_PRV1)
	osection:cell("SAIDA_CONSIG"):setValue((cAliasQry)->QTER_REQ)
	osection:cell("DEVOLUCAO_SIMBOLICA"):setValue((cAliasQry)->QTER_DEV_SIMB)
	osection:cell("DEVOLUCAO_FISICA"):setValue((cAliasQry)->QTER_DEV_FIS)
	osection:cell("SALDO_CONSIG_ATUAL"):setValue((cAliasQry)->QTER_REQ - ((cAliasQry)->QTER_DEV_SIMB + (cAliasQry)->QTER_DEV_FIS))
	osection:cell("TOTAL_VENDA_ACERTO"):setValue((cAliasQry)->VENDA)
	oSection:PrintLine()
	(cAliasQry)->(DbSkip())
End

oSection:Finish()

Return NIL

//---------------------------------------------------------------
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()

If !dbSeek( cPerg )
	PutSx1(cPerg,"01","Cliente ?       		","","","mv_ch1","C",06,0,0,"G","","SA1","","","MV_PAR01")
	PutSx1(cPerg,"02","Loja ?       		","","","mv_ch2","C",02,0,0,"G","","","","","MV_PAR02")
	PutSx1(cPerg,"03","Lancamento de ?     	","","","mv_ch3","D",08,0,0,"G","","","","","MV_PAR03")
	PutSx1(cPerg,"04","Lancamento ate ?    	","","","mv_ch4","D",08,0,0,"G","","","","","MV_PAR04")
	PutSx1(cPerg,"05","Produto de ?			","","","mv_ch5","C",30,0,0,"G","","SB1","","","MV_PAR05")
	PutSx1(cPerg,"06","Produto ate ?		","","","mv_ch6","C",30,0,0,"G","","SB1","","","MV_PAR06")
	PutSx1(cPerg,"07","Segmento de ?       	","","","mv_ch7","C",02,0,0,"G","","_A","","","MV_PAR07")
	PutSx1(cPerg,"08","Segmento ate ?      	","","","mv_ch8","C",02,0,0,"G","","_A","","","MV_PAR08")
	PutSx1(cPerg,"09","Vendedor ?       	","","","mv_ch9","C",06,0,0,"G","","SA3","","","MV_PAR09")
Endif


RestArea( aArea )

Return Nil