#include "protheus.ch"    
#include "topconn.ch"
#include "tbiconn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCOR01  ºAutor  ³   FONTANELLI       º Data ³  07/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio DIARIO para o correio                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

// U_RELCOR01()

User Function RELCOR01()

Local   oReport
Local   aArea	  	:= GetArea()        		
Private cPerg     	:= "RELCOR01"
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

oReport := TReport():New("RELCOR01","Relatorio Diario - Correio", cPerg , {|oReport| ReportPrint(oReport)} , " Relatorio Diario - Correio " )
oReport:SetPortrait() 	// oReport:SetLandscape() 
oReport:lHeaderVisible 		:= .T. 	// Não imprime cabeçalho do protheus
oReport:lFooterVisible		:= .T.	// Não imprime rodapé do protheus
oReport:lParamPage		  	:= .T.	// Não imprime pagina de parametros
oReport:oPage:nPaperSize  	:= 9	// Ajuste para papel A4				

oSection := TRSection():New(oReport,"Relatorio Diario - Correio", cAliasQRY)
oSection:SetHeaderPage(.F.)

TRCell():New(oSection,"EMISSAO"		,cAliasQRY ,"EMISSAO"		,PesqPict("SF2","F2_EMISSAO")	, TamSX3("F2_EMISSAO")[1]	)
TRCell():New(oSection,"NOTAFISCAL"	,cAliasQRY ,"NOTAFISCAL"	,PesqPict("SF2","F2_DOC")		, TamSX3("F2_DOC")[1]		)
TRCell():New(oSection,"SERIE"		,cAliasQRY ,"SERIE"			,PesqPict("SF2","F2_SERIE")		, TamSX3("F2_SERIE")[1] 	)
TRCell():New(oSection,"CLIENTE"		,cAliasQRY ,"CLIENTE"		,PesqPict("SA1","A1_NOME")		, TamSX3("A1_NOME")[1]  	)
TRCell():New(oSection,"CEP"			,cAliasQRY ,"CEP" 		 	,PesqPict("SA1","A1_CEP")		, TamSX3("A1_CEP")[1]  		)
TRCell():New(oSection,"OBJETO"		,cAliasQRY ,"OBJETO"		,PesqPict("SC5","C5_OBJETO")	, TamSX3("C5_OBJETO")[1]	)
                              
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
          
cQuery:= " SELECT * FROM ( 
cQuery+= " SELECT F2_FILIAL FILIAL,F2_EMISSAO EMISSAO, F2_DOC NOTAFISCAL, F2_SERIE SERIE, A1_NOME CLIENTE, A1_CEP CEP, "+CHR(13)+CHR(10)
cQuery+= "        ( SELECT C5_OBJETO FROM "+RETSQLNAME("SC5")+" "+CHR(13)+CHR(10)
cQuery+= "           WHERE C5_FILIAL = '"+xFilial("SC5")+"' "+CHR(13)+CHR(10)
cQuery+= "             AND C5_NUM = D2_PEDIDO "+CHR(13)+CHR(10)
cQuery+= "             AND D_E_L_E_T_ = '  ' ) OBJETO "+CHR(13)+CHR(10)
cQuery+= "  FROM ( "+CHR(13)+CHR(10)
cQuery+= "			SELECT F2_FILIAL, F2_EMISSAO, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_NOME, A1_CEP, "+CHR(13)+CHR(10)
cQuery+= "			       ( SELECT DISTINCT D2_PEDIDO FROM "+RETSQLNAME("SD2")+" "+CHR(13)+CHR(10)
cQuery+= "         	          WHERE D2_FILIAL = F2_FILIAL "+CHR(13)+CHR(10)
cQuery+= "         	            AND D2_DOC = F2_DOC "+CHR(13)+CHR(10)
cQuery+= "         	            AND D2_SERIE = F2_SERIE "+CHR(13)+CHR(10)
cQuery+= "         	            AND D2_CLIENTE = F2_CLIENTE "+CHR(13)+CHR(10)
cQuery+= "         	            AND D2_LOJA = F2_LOJA "+CHR(13)+CHR(10)
cQuery+= "          	        AND D_E_L_E_T_ = ' ' ) D2_PEDIDO "+CHR(13)+CHR(10)  
cQuery+= "		 	 FROM "+RETSQLNAME("SF2")+" SF2, "+RETSQLNAME("SA1")+" SA1 "+CHR(13)+CHR(10)
cQuery+= "		 	 WHERE F2_FILIAL = '"+xFilial("SF2")+"' "+CHR(13)+CHR(10)
cQuery+= "			   AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CHR(13)+CHR(10)
cQuery+= "			   AND F2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CHR(13)+CHR(10)
cQuery+= "			   AND F2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CHR(13)+CHR(10)
cQuery+= "			   AND SF2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= "			   AND A1_FILIAL = '"+xFilial("SA1")+"' "+CHR(13)+CHR(10)
cQuery+= "			   AND A1_COD = F2_CLIENTE "+CHR(13)+CHR(10)
cQuery+= "			   AND A1_LOJA = F2_LOJA "+CHR(13)+CHR(10)
cQuery+= "			   AND SA1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= "		) "+CHR(13)+CHR(10) 
cQuery+= "		) "+CHR(13)+CHR(10) 
cQuery+= "	WHERE OBJETO <> '' "
cQuery+= " ORDER BY EMISSAO, NOTAFISCAL, SERIE "+CHR(13)+CHR(10)
cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.F.,.F.)
TcSetField(cAliasQry,"EMISSAO","D")
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())   
oSection:Init()  
While (cAliasQry)->(!EOF())        
	osection:cell("EMISSAO"):setValue((cAliasQry)->EMISSAO)
	osection:cell("NOTAFISCAL"):setValue((cAliasQry)->NOTAFISCAL)
	osection:cell("SERIE"):setValue((cAliasQry)->SERIE)
	osection:cell("CLIENTE"):setValue((cAliasQry)->CLIENTE)
	osection:cell("CEP"):setValue(TransForm((cAliasQry)->CEP,"@r 99999-999"))  
	osection:cell("OBJETO"):setValue((cAliasQry)->OBJETO)  
	oSection:PrintLine()
	(cAliasQry)->(DbSkip())
End

oSection:Finish()

Return NIL                                                          

//---------------------------------------------------------------
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()

If !dbSeek( cPerg )                                                                                                                    
	PutSx1(cPerg,"01","Emissao de ?       	","","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01")
	PutSx1(cPerg,"02","Emissao ate ?       	","","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02")
	PutSx1(cPerg,"03","Nota Fiscal de ?		","","","mv_ch3","C",09,0,0,"G","","","","","MV_PAR03")
	PutSx1(cPerg,"04","Nota Fiscal ate ?	","","","mv_ch4","C",09,0,0,"G","","","","","MV_PAR04")
	PutSx1(cPerg,"05","Serie de ?       	","","","mv_ch5","C",03,0,0,"G","","","","","MV_PAR05")
	PutSx1(cPerg,"06","Serie ate ?       	","","","mv_ch6","C",03,0,0,"G","","","","","MV_PAR06")
Endif

RestArea( aArea )           

Return Nil