#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFSERVR   บAutor  ณLEANDRO DUARTE      บ Data ณ  07/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRELATORIO DA ANDREIA PARA SABER O QUE ELA DEVE FATURAR AS NOบฑฑ
ฑฑบ          ณNOTAS DE SERVIวOS                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NF3SERVR()
Local oReport
Private aSec := {}
oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณLEANDRO DUARTE      บ Data ณ  07/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณA funcao estatica ReportDef devera ser criada para todos os ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.          ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 E P12                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

Local oReport
Local cTitulo	:= "Emissใo para Notas de Servi็os"
Local cPedMano  := cPedVtex    := cNossonu    := cCodCli    := cNomeCli      := cCodPrd      := cDescPrd  := ""
Local nQtd  	:= nVlUnit      := nTotal      := nTotVLR	:= 	nTotQtd := 0
Local dEmis		:= stod('')
lOCAL cPrc		:= PesqPict('SC6','C6_VALOR')
Private cPerg   :=PADR("NFSERVR",10)
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
oReport:= TReport():New("NFSERVR",cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cTitulo)
oReport:SetPortrait(.T.)
oReport:SetLandscape(.F.)

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
//ณ                                                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// regra para gravar a localiza็ใo do SIGAMAT.EMP
oEmpFil := TRSection():New(oReport,"Emissใo para Notas de Servi็os",{"SC5","SC6","SB1","SA1"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
oEmpFil:SetTotalInLine(.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao da celulas da secao do relatorio                                ณ
//ณ                                                                        ณ
//ณTRCell():New                                                            ณ
//ณExpO1 : Objeto TSection que a secao pertence                            ณ
//ณExpC2 : Nome da celula do relat๓rio. O SX3 serแ consultado              ณ
//ณExpC3 : Nome da tabela de referencia da celula                          ณ
//ณExpC4 : Titulo da celula                                                ณ
//ณ        Default : X3Titulo()                                            ณ
//ณExpC5 : Picture                                                         ณ
//ณ        Default : X3_PICTURE                                            ณ
//ณExpC6 : Tamanho                                                         ณ
//ณ        Default : X3_TAMANHO                                            ณ
//ณExpL7 : Informe se o tamanho esta em pixel                              ณ
//ณ        Default : False                                                 ณ
//ณExpB8 : Bloco de c๓digo para impressao.                                 ณ
//ณ        Default : ExpC2                                                 ณ
//ณ                                                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

TRCell():New(oEmpFil,"cPedMano" ,/*Tabela*/,"Pedido"+CRLF+"Manole",/*Picture*/,TamSx3("C5_NUM")[1]+4,/*lPixel*/,{|| cPedMano  })
TRCell():New(oEmpFil,"cPedVtex" ,/*Tabela*/,"Pedido"+CRLF+"Vtex",/*Picture*/,TamSx3("C5_VTEX")[1]+6,/*lPixel*/,{|| cPedVtex  })
TRCell():New(oEmpFil,"cNossonu" ,/*Tabela*/,"Codigo"+CRLF+"Vtex",/*Picture*/,TamSx3("C5_NOSSONU")[1],/*lPixel*/,{|| cNossonu  })
TRCell():New(oEmpFil,"cCodCli"  ,/*Tabela*/,"Cliente",/*Picture*/,TamSx3("A1_COD")[1]+10,/*lPixel*/,{|| cCodCli  })
TRCell():New(oEmpFil,"cNomeCli" ,/*Tabela*/,"Nome",/*Picture*/,40,/*lPixel*/,{|| cNomeCli  })
TRCell():New(oEmpFil,"dEmis"    ,/*Tabela*/,"Emissใo",/*Picture*/,TamSx3("C5_EMISSAO")[1]+10,/*lPixel*/,{|| dEmis  })
TRCell():New(oEmpFil,"cCodPrd"  ,/*Tabela*/,"Cod Prod",/*Picture*/,10,/*lPixel*/,{|| cCodPrd  })
TRCell():New(oEmpFil,"cDescPrd" ,/*Tabela*/,"Nome Prod",/*Picture*/,95,/*lPixel*/,{|| cDescPrd  })
TRCell():New(oEmpFil,"nQtd"     ,/*Tabela*/,"Quantidade",/*Picture*/,TamSx3("C6_QTDVEN")[1],/*lPixel*/,{|| nQtd  })
TRCell():New(oEmpFil,"nVlUnit"  ,/*Tabela*/,"Valor"+CRLF+"Unitario",cPrc,TamSx3("C6_PRCVEN")[1],/*lPixel*/,{|| nVlUnit  })
TRCell():New(oEmpFil,"nTotal"   ,/*Tabela*/,"Valor"+CRLF+"Total",cPrc,TamSx3("C6_VALOR")[1],/*lPixel*/,{|| nTotal  })
//TRCell():New(oEmpFil,"nTotVLR"	,/*Tabela*/,"Valor"+CRLF+"Total","@E 99,999,999,999,999.99",21/*Tamanho*/,/*lPixel*/,{|| nTotVLR },/*"RIGHT"*/,,"RIGHT" )
//TRCell():New(oEmpFil,"nTotQtd"	,/*Tabela*/,"Quantidade"+CRLF+"Total","@E 99,999,999,999,999.99",21/*Tamanho*/,/*lPixel*/,{|| nTotQtd },/*"RIGHT"*/,,"RIGHT" )

//oEmpFil:Cell("nTotVLR"):lHeaderSize	:= .F.
//oEmpFil:Cell("nTotQtd"):lHeaderSize	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do Cabecalho no top da pagina                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:Section(1):SetHeaderPage()
oReport:Section(1):SetEdit(.F.)
oReport:Section(1):SetEditCell(.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas 									   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Pergunte(oReport:uParam,.F.)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบAutor  ณLEANDRO DUARTE      บ Data ณ  05/07/16   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 E P12                                                   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

Local cAlias	:= ""
Local cPedMano  := cPedVtex    := cNossonu    := cCodCli    := cNomeCli      := cCodPrd      := cDescPrd  := ""
Local nQtd  	:= nVlUnit      := nTotal      := nTotQtd := nTotVLR := 0
Local dEmis		:= stod('')
Local cAliasSD1	:= GETNEXTALIAS()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SetBlock: faz com que as variaveis locais possam ser                   ณ
//ณ utilizadas em outras funcoes nao precisando declara-las                ณ
//ณ como private.                                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:Section(1):Cell("cPedMano" ):SetBlock({||  cPedMano  })
oReport:Section(1):Cell("cPedVtex" ):SetBlock({||  cPedVtex  })
oReport:Section(1):Cell("cNossonu" ):SetBlock({||  cNossonu  })
oReport:Section(1):Cell("cCodCli"  ):SetBlock({||  cCodCli  })
oReport:Section(1):Cell("cNomeCli" ):SetBlock({||  cNomeCli  })
oReport:Section(1):Cell("dEmis"    ):SetBlock({||  dEmis  })
oReport:Section(1):Cell("cCodPrd"  ):SetBlock({||  cCodPrd  })
oReport:Section(1):Cell("cDescPrd" ):SetBlock({||  cDescPrd  })
oReport:Section(1):Cell("nQtd"     ):SetBlock({||  nQtd  })
oReport:Section(1):Cell("nVlUnit"  ):SetBlock({||  nVlUnit  })
oReport:Section(1):Cell("nTotal"   ):SetBlock({||  nTotal  })

cPedMano  := cPedVtex    := cNossonu    := cCodCli    := cNomeCli      := cCodPrd      := cDescPrd  := ""
nQtd  	:= nVlUnit      := nTotal      := 0
dEmis		:= stod('')

cAlias := GetNextAlias()

oReport:Section(1):BeginQuery()

BeginSql Alias cAliasSD1
	SELECT A.C5_NUM, A.C5_VTEX, A.C5_NOSSONU, D.A1_COD||'-'||D.A1_LOJA as CODCLI, D.A1_NOME, A.C5_EMISSAO, C.B1_COD, C.B1_DESC, B.C6_QTDVEN, B.C6_PRCVEN, B.C6_VALOR
	  FROM %table:SC5% A, %table:SC6% B, %table:SB1% C, %table:SA1% D
	 WHERE A.C5_FILIAL = %xFilial:SC5%
	   AND B.C6_FILIAL = %xFilial:SC6%
	   AND C.B1_FILIAL = %xFilial:SB1%
	   AND D.A1_FILIAL = %xFilial:SA1%
	   AND A.D_E_L_E_T_ = ' '
	   AND B.D_E_L_E_T_ = ' '
	   AND C.D_E_L_E_T_ = ' '
	   AND D.D_E_L_E_T_ = ' '
	   AND A.C5_NUM = B.C6_NUM
	   AND B.C6_PRODUTO = C.B1_COD
	   AND A.C5_CLIENTE = D.A1_COD
	   AND A.C5_LOJACLI = D.A1_LOJA
	   AND C.B1_XTIPO = '2'
	   AND A.C5_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	   AND C.B1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	   AND D.A1_COD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	   AND C6_NOTA = '   '
   	ORDER BY  A.R_E_C_N_O_
EndSql
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
(cAliasSD1)->(dbGoTop())
oReport:SetMeter(RecCount())
oReport:Section(1):Init()
While !oReport:Cancel() .And. (cAliasSD1)->(!Eof())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณprocesso de alimentar as variaveis para adicionar no relatorioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cPedMano  := (cAliasSD1)->C5_NUM
	cPedVtex  := (cAliasSD1)->C5_VTEX
	cNossonu  := (cAliasSD1)->C5_NOSSONU
	cCodCli   := (cAliasSD1)->CODCLI
	cNomeCli  := (cAliasSD1)->A1_NOME
	dEmis  	  := (cAliasSD1)->C5_EMISSAO
	cCodPrd   := (cAliasSD1)->B1_COD
	cDescPrd  := (cAliasSD1)->B1_DESC
	nQtd      := (cAliasSD1)->C6_QTDVEN
	nVlUnit   := (cAliasSD1)->C6_PRCVEN
	nTotal    := (cAliasSD1)->C6_VALOR
	nTotQtd   += nQtd
	nTotVLR   += nTotal
	oReport:Section(1):Cell("cPedMano"):Show()//HIDE()"
	oReport:Section(1):Cell("cPedVtex"):Show()//HIDE()"
	oReport:Section(1):Cell("cNossonu"):Show()//HIDE()"
	oReport:Section(1):Cell("cCodCli"):Show()//HIDE()"
	oReport:Section(1):Cell("cNomeCli"):Show()//HIDE()"
	oReport:Section(1):Cell("dEmis"):Show()//HIDE()"
	oReport:Section(1):Cell("cCodPrd"):Show()//HIDE()"
	oReport:Section(1):Cell("cDescPrd"):Show()//HIDE()"
	oReport:Section(1):Cell("nQtd"):Show()//HIDE()"
	oReport:Section(1):Cell("nVlUnit"):Show()//HIDE()"
	oReport:Section(1):Cell("nTotal"):Show()//HIDE()"
	oReport:Section(1):PrintLine()//imprime a linha

	oReport:IncMeter()


	(cAliasSD1)->(dbskip())
End
oReport:SkipLine()
nQtd := 	nTotQtd
nTotal  := 	nTotVLR
cPedVtex := "Total Geral"
oReport:Section(1):Cell("cPedMano"):HIDE()
oReport:Section(1):Cell("cPedVtex"):Show()
oReport:Section(1):Cell("cNossonu"):HIDE()
oReport:Section(1):Cell("cCodCli"):HIDE()
oReport:Section(1):Cell("cNomeCli"):HIDE()
oReport:Section(1):Cell("dEmis"):HIDE()
oReport:Section(1):Cell("cCodPrd"):HIDE()
oReport:Section(1):Cell("cDescPrd"):HIDE()
oReport:Section(1):Cell("nQtd"):Show()//HIDE()"
oReport:Section(1):Cell("nVlUnit"):HIDE()
oReport:Section(1):Cell("nTotal"):Show()//HIDE()"
oReport:Section(1):PrintLine()//imprime a linha

oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak()
(cAliasSD1)->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณLEANDRO DUARTE      บ Data ณ  07/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA PARA CRIAR OS PERGUNTES                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()

If !dbSeek( cPerg )
	PutSx1(cPerg,"01","Cliente De      		","","","mv_ch1","C",06,0,0,"G","","SA1","","","MV_PAR01")
	PutSx1(cPerg,"02","Cliente ate  		","","","mv_ch2","C",06,0,0,"G","","SA1","","","MV_PAR02")
	PutSx1(cPerg,"03","Emissใo de ?     	","","","mv_ch3","D",08,0,0,"G","","","","","MV_PAR03")
	PutSx1(cPerg,"04","Emissใo ate ?    	","","","mv_ch4","D",08,0,0,"G","","","","","MV_PAR04")
	PutSx1(cPerg,"05","Produto de ?			","","","mv_ch5","C",30,0,0,"G","","SB1","","","MV_PAR05")
	PutSx1(cPerg,"06","Produto ate ?		","","","mv_ch6","C",30,0,0,"G","","SB1","","","MV_PAR06")
Endif


RestArea( aArea )
