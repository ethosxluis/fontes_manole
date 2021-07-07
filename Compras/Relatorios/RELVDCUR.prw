#include "protheus.ch"    
#include "topconn.ch"
#include "tbiconn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELVDCUR  ºAutor  ³   FONTANELLI       º Data ³  30/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Venda de Curso 			                      º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

	// U_RELVDCUR()

User Function RELVDCUR()

Local   oReport
Local   aArea	  	:= GetArea()        		
Private cPerg     	:= "RELVDCUR2"
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

oReport := TReport():New("RELVDCUR","Venda de Cursos com Livros/eBook", cPerg , {|oReport| ReportPrint(oReport)} , " Venda de Cursos com Livros/eBook " )
//oReport:SetPortrait() 
oReport:SetLandscape() 
oReport:lHeaderVisible 		:= .T. 	// Não imprime cabeçalho do protheus
oReport:lFooterVisible		:= .T.	// Não imprime rodapé do protheus
oReport:lParamPage		  	:= .T.	// Não imprime pagina de parametros
oReport:oPage:nPaperSize  	:= 12	// Ajuste para papel A4				

oSection := TRSection():New(oReport,"Venda de Cursos com Livros/eBook", cAliasQRY)
oSection:SetHeaderPage(.F.)

TRCell():New(oSection,"TIPO"			,cAliasQRY ,"TIPO"					,"@!" 							, 10 					)
TRCell():New(oSection,"CODIGO"			,cAliasQRY ,"PRODUTO"				,PesqPict("SD2","D2_COD")		, TamSX3("D2_COD")[1]	)
TRCell():New(oSection,"DESCRICAO"		,cAliasQRY ,"DESCRICAO"				,PesqPict("SB1","B1_DESC")		, TamSX3("B1_DESC")[1]	)
TRCell():New(oSection,"QTD"				,cAliasQRY ,"QUANTIDADE"			,PesqPict("SD2","D2_QUANT")		, TamSX3("D2_QUANT")[1]	)
TRCell():New(oSection,"TOTAL"			,cAliasQRY ,"TOTAL"					,PesqPict("SD2","D2_TOTAL")		, TamSX3("D2_TOTAL")[1]	)
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

cQuery:= " SELECT "
cQuery+= "       CASE B1_XTIPO "
cQuery+= "           WHEN '1' THEN 'LIVRO' "
cQuery+= "           WHEN '2' THEN 'CURSO' "
cQuery+= "           WHEN '3' THEN 'OUTROS' "
cQuery+= "           WHEN '4' THEN 'EBOOK' "
cQuery+= "           ELSE ' ' "
cQuery+= "         END AS TIPO, "
cQuery+= "        CODIGO,  "
cQuery+= "        B1_DESC DESCRICAO, "
cQuery+= "        (  "
cQuery+= "         SELECT SUM(D2_QUANT) FROM "+RETSQLNAME("SD2")+"  "
cQuery+= "         WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "           AND D2_COD = CODIGO "
cQuery+= "           AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery+= "           AND D2_PEDIDO IN (  "
cQuery+= "                                 SELECT DISTINCT D2_PEDIDO FROM "+RETSQLNAME("SD2")+"  "
cQuery+= "                                 WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "                                   AND D2_SERIE = 'A  ' "
cQuery+= "                                   AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery+= "                                   AND D2_TES IN ('503','504') "
cQuery+= "                                   AND D_E_L_E_T_ = ' ' "
cQuery+= "                            ) " 
cQuery+= "           AND D_E_L_E_T_ = ' ' "
cQuery+= "         ) QTD, "
cQuery+= "        (  "
cQuery+= "         SELECT SUM(D2_TOTAL) FROM "+RETSQLNAME("SD2")+"  "
cQuery+= "         WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "           AND D2_COD = CODIGO "
cQuery+= "           AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery+= "           AND D2_PEDIDO IN (  "
cQuery+= "                                 SELECT DISTINCT D2_PEDIDO FROM "+RETSQLNAME("SD2")+"  "
cQuery+= "                                 WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "                                   AND D2_SERIE = 'A  ' "
cQuery+= "                                   AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery+= "                                   AND D2_TES IN ('503','504') "
cQuery+= "                                   AND D_E_L_E_T_ = ' ' "
cQuery+= "                            ) " 
cQuery+= "           AND D_E_L_E_T_ = ' ' "
cQuery+= "         ) TOTAL "
cQuery+= "   FROM ( "
cQuery+= "           SELECT DISTINCT D2_COD CODIGO FROM "+RETSQLNAME("SD2")+"  "
cQuery+= "            WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "             AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery+= "              AND D2_PEDIDO IN ( "
cQuery+= "                                 SELECT DISTINCT D2_PEDIDO FROM "+RETSQLNAME("SD2")+"  "
cQuery+= "                                 WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "                                   AND D2_SERIE = 'A  ' "
cQuery+= "                                   AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery+= "                                   AND D2_TES IN ('503','504') "
cQuery+= "                                   AND D_E_L_E_T_ = ' ' "
cQuery+= "                                ) "
cQuery+= "              AND D_E_L_E_T_ = ' '  "
cQuery+= "       ), "+RETSQLNAME("SB1")+"  "
cQuery+= " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery+= "   AND B1_COD = CODIGO "
cQuery+= "   AND D_E_L_E_T_ = ' ' "
cQuery+= " ORDER BY TIPO, CODIGO "       
cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.F.,.F.)
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())   
oSection:Init()  
While (cAliasQry)->(!EOF())                
	osection:cell("TIPO"):setValue((cAliasQry)->TIPO)
	osection:cell("PRODUTO"):setValue((cAliasQry)->CODIGO)
	osection:cell("DESCRICAO"):setValue((cAliasQry)->DESCRICAO)
	osection:cell("QUANTIDADE"):setValue((cAliasQry)->QTD)
	osection:cell("TOTAL"):setValue((cAliasQry)->TOTAL)  
	oSection:PrintLine()
	(cAliasQry)->(DbSkip())
End

oSection:Finish()

Return NIL                                                          

//---------------------------------------------------------------
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()

If !dbSeek( cPerg )                                                                                                                    
	PutSx1(cPerg,"01","Periodo de ?     ","","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01")
	PutSx1(cPerg,"02","Periodo ate ?    ","","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02")
Endif

RestArea( aArea )           

Return Nil