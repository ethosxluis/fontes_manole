#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCDAR030  ºAutor  ³Anderson Ciriaco    º Data ³  06/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MANR02A()
Local oReport
Private cPerg := Padr("MANR002",10)

//Correcao no Grupo de Perguntas
CriaSx1(cPerg)  

//chama o pergunte no inicio para parametrizar a quebra
Pergunte(cPerg)
//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ ANDERSON CIRIACO      ³ Data ³06/10/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local nSaldo := 0
LOCAL OBREAK01

LOCAL cAliasPa2 := GetNextAlias()
LOCAL cAliasDa2 := GetNextAlias()
LOCAL cAliasDa3 := GetNextAlias()


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
oReport := TReport():New("MANR02A","OCORRENCIAS DE NOTAS FISCAIS DE ENTRADA",CPERG, {|oReport| ReportPrint(oReport,cAliasPa2,cAliasDa2,cAliasDa3)},"Este programa emite Rel. de Ocorrencias referentes a NF de Entrada.")
oReport:SetTotalInLine(.F.)
oReport:SetLandscape()
Pergunte(oReport:uParam,.F.)


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
oNSU := TRSection():New(oReport,"OCORRENCIAS DE NOTAS FISCAIS DE ENTRADA",{"PA2","SF1","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oNSU:SetTotalInLine(.F.)

//Código do fornecedor|Nome do fornecedor|ISBN|Nome do livro|Periodicidade|Quantidade de exemplares vendidos registrado em DA|Quantidade de devoluções no DA|Saldo a considerar no direito autoral (Quantidade-devoluções)|Preço médio de capa para o cálculo do DA|Valor faturamento acumulado registrado em DA para base de calculo (preço de capa x saldo)|Porcentagem de direito autoral|Valor de DA para o livro|Quantidade de exemplares do resumo de vendas|Quantidade de exemplares devolvidos no resumo de vendas|Saldo de livros no resumo de vendas|

TRCell():New(oNSU,"DOCUMENTO"		,cAliasPa2,"Nota Fiscal",/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"SERIE"	,cAliasPa2,"Serie",/*Picture*/,6,/*lPixel*/,/*{|| code-block de impressao }*/)      
TRCell():New(oNSU,"CLIENTE"	,cAliasPa2,"Cod. Cliente",/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"LOJA"		,cAliasPa2,"Loja",/*Picture*/,6,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"NOME"	,cAliasPa2,"Nome do Cliente",/*Picture*/,45,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"ISBN"	,cAliasPa2,"ISBN",/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNSU,"DESCRICAO"	,cAliasPa2,"Descrição",/*Picture*/,45,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNSU,"TIPO"	,cAliasPa2,"Tipo de Ocorrencia",/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNSU,"DESOCO"	,cAliasPa2,"Descrição da Ocorrência",/*Picture*/,45,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNSU,"QUANT"	,cAliasPa2,"Quantidade","@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNSU,"OBSERV"	,cAliasPa2,"Observações",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ANDERSON CIRIACO       ³ Data ³06/10/2014³±±
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
Static Function ReportPrint(oReport,cAliasPa2,cAliasDa2,cAliasDa3)

Local cAlias   := "PA2"
Local bEval
Local aSalAlmox:= {}
Local lPrint   := .F.
Local cNomArq  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()
BeginSql Alias cAliasPa2
	


SELECT 
PA2_DOCENT DOCUMENTO
,PA2_SERIE SERIE
,PA2_CLIFOR CLIENTE
,PA2_LOJA LOJA
,A1_NOME NOME
,PA2_ISBN ISBN
,B1_DESC DESCRICAO
,PA2_TIPO TIPO
,X5_DESCRI DESOCO
,PA2_QTD QUANT
,PA2_OBS OBSERV
FROM %table:PA2% PA2, %table:SF1% SF1, %table:SX5% X5, %table:SA1% A1, %table:SB1% B1
WHERE SF1.F1_DOC = PA2.PA2_DOCENT 
AND SF1.F1_SERIE = PA2.PA2_SERIE 
AND SF1.F1_FORNECE = PA2.PA2_CLIFOR
AND SF1.F1_LOJA = PA2.PA2_LOJA
AND X5_TABELA = '_B'
AND X5_CHAVE = PA2_TIPO
AND B1_COD = PA2_ISBN
AND A1_COD = PA2_CLIFOR
AND A1_LOJA = PA2_LOJA
AND PA2.PA2_DOCENT BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
AND PA2.PA2_SERIE BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
AND PA2.PA2_CLIFOR BETWEEN %Exp:mv_par05% AND %Exp:mv_par07% 
AND PA2.PA2_LOJA BETWEEN %Exp:mv_par06% AND %Exp:mv_par08%
AND SF1.F1_EMISSAO BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
AND B1.D_E_L_E_T_ <> '*'
AND A1.D_E_L_E_T_ <> '*'
AND X5.D_E_L_E_T_ <> '*'
AND PA2.D_E_L_E_T_ <> '*'
AND SF1.D_E_L_E_T_ <> '*'
ORDER BY PA2_FILIAL, PA2_DOCENT, PA2_SERIE, PA2_CLIFOR, PA2_LOJA, PA2_RO
	
	
EndSql

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo EndQuery ( Classe TRSection )                                    ³
//³                                                                        ³
//³Prepara o relatório para executar o Embedded SQL.                       ³
//³                                                                        ³
//³ExpA1 : Array com os parametros do tipo Range                           ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAliasPa2)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasPa2)->(Eof())
	
	oReport:Section(1):PrintLine()
	
	dbSelectArea(cAliasPa2)
	dbSkip()
	oReport:IncMeter()
	
EndDo

oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.)

Return


Static Function CriaSx1( cPerg )

Local aPergs 		:= {}

Aadd(aPergs,{"NF de?"	  	  		,"","","mv_ch1","C",09,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"NF ate?"  	 		,"","","mv_ch2","C",09,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Serie de?"	  	  		,"","","mv_ch3","C",03,00,00,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Serie ate?"  	 		,"","","mv_ch4","C",03,00,00,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Cliente de?"	  	  		,"","","mv_ch5","C",06,00,00,"G","","mv_par05","","","","","","","","","","","","","","","SA1","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Loja de?"	  	  		,"","","mv_ch6","C",02,00,00,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Cliente ate?"  	 		,"","","mv_ch7","C",06,00,00,"G","","mv_par07","","","","","","","","","","","","","","","SA1","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Loja ate?"  	 		,"","","mv_ch8","C",02,00,00,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}}) 
Aadd(aPergs,{"Emissao de?"  	 		,"","","mv_ch9","D",08,00,00,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Emissao ate?"  	 		,"","","mv_cha","D",08,00,00,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})


AjustaSX1(cPerg,aPergs)

Return
