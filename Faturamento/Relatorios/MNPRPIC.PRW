#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNPRPIC   ºAutor  ³LEANDRO DUARTE      º Data ³  03/29/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE PRÉ PIC                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 E P12                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION MNPRPIC()

Local oReport
PRIVATE aRecno:={}

//Configuracoes da pergunte AIA106 (Pedidos de Venda), ativado pela tecla F12:
PRIVATE nConfLote
PRIVATE nEmbSimul
PRIVATE nEmbalagem
PRIVATE nGeraNota
PRIVATE nImpNota
PRIVATE nImpEtVol
PRIVATE nEmbarque
PRIVATE nAglutPed
PRIVATE nAglutArm
//Configuracoes da pergunte AIA107 (Notas Fiscais), ativado pela tecla F12:
PRIVATE nEmbSimuNF
PRIVATE nEmbalagNF
PRIVATE nImpNotaNF
PRIVATE nImpVolNF
PRIVATE nEmbarqNF
//Configuracoes da pergunte AIA108 (Ordens de Producao), ativado pela tecla F12:
PRIVATE nReqMatOP
PRIVATE nAglutArmOP
PRIVATE nPreSep
PUBLIC cPed := ""

u_MNSEP01()

oReport := ReportDef()
oReport:PrintDialog()

u_MXTR730(cPed) // u_MATR731(cPed)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³LEANDRO DUARTE      º Data ³  03/29/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 E P12                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

Local oReport
Local cTitulo	:= "PRÉ-PIC"
Local cISBN		:= ""
Local cDesc		:= ""
Local nQtd		:= 0
Local cORDS		:= ""
Local cLoca		:= ""
Private cPerg   :=PADR("PREPIC001",10)


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
oReport:= TReport():New(cPerg,cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cTitulo)
oReport:SetPortrait(.T.)
oReport:nfontbody:=10
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
oEmpFil := TRSection():New(oReport,"BUSCA EM ESTOQUE",{"SC5"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
oEmpFil:SetTotalInLine(.F.)
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

	TRCell():New(oEmpFil,"cORDS" ,/*Tabela*/,"Ordem de Separação",/*Picture*/,15,/*lPixel*/,{|| cORDS  })
	TRCell():New(oEmpFil,"cISBN" ,/*Tabela*/,"ISBN",/*Picture*/,TamSx3("B1_COD")[1],/*lPixel*/,{|| cISBN  })
	TRCell():New(oEmpFil,"cDesc" ,/*Tabela*/,"Nome",/*Picture*/,150,/*lPixel*/,{|| cDesc  })
	TRCell():New(oEmpFil,"cLoca" ,/*Tabela*/,"Endereço",/*Picture*/,20,/*lPixel*/,{|| cLoca  })
	TRCell():New(oEmpFil,"nQtd" ,/*Tabela*/,"Quantidade",/*Picture*/,5,/*lPixel*/,{|| nQtd  })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no top da pagina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):SetHeaderPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 									   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.F.)

Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³LEANDRO DUARTE      º Data ³  03/29/14   º±±
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

Local cISBN		:= ""
Local cDesc		:= ""
Local nQtd		:= 0
Local cWhere	:= ""
Local cORDS		:= ""
Local cLoca		:= ""
Local cAliasTRB	:= GETNEXTALIAS()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser                   ³
//³ utilizadas em outras funcoes nao precisando declara-las                ³
//³ como private.                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("cORDS"	):SetBlock({|| 	cORDS	})
oReport:Section(1):Cell("cISBN"	):SetBlock({|| 	cISBN	})
oReport:Section(1):Cell("cDesc"	):SetBlock({|| cDesc	})
oReport:Section(1):Cell("cLoca" ):SetBlock({|| 	cLoca	})
oReport:Section(1):Cell("nQtd" 	):SetBlock({|| 	nQtd	})

cISBN		:= ""
cDesc		:= ""
nQtd		:= 0
cWhere		:= ""
cORDS		:= ""
cLoca		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona SB1 para antes da impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//TRPosition():New(oReport:Section(1),"SB1",1,{|| xFilial("SB1") + TRB->D2_COD })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//³Obs: Utilizamos SetFilter no SD1 e nao Query pois e dado dbSeek         ³
//³no SD1 na funcao CALCDEVR4.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui Devolucao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	cAlias := GetNextAlias()

	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasTRB

		SELECT C.B1_COD, C.B1_DESC, E.CB8_ORDSEP, SUM(B.C6_QTDVEN) AS C6_QTDVEN, CB8_LCALIZ
		  FROM %table:SC5% A, %table:SC6% B, %table:SB1% C , %table:CB7% D, %table:CB8% E
		 WHERE A.%NotDel%
		   AND A.C5_FILIAL = %xFilial:SC5%
		   AND A.C5_EMISSAO >= %Exp:Dtos(DDATABASE-3)%
		   And A.C5_NOTA = ' '
		   And A.C5_BLQ = ' '
		   AND B.C6_FILIAL = %xFilial:SC6%
		   AND B.%NotDel%
		   AND B.C6_NUM = A.C5_NUM
		   AND C.B1_FILIAL = %xFilial:SB1%
		   AND C.%NotDel%
		   AND C.B1_COD = B.C6_PRODUTO
		   AND C.B1_XTIPO = '1'
		   AND A.C5_VTEX <> '  '
		   AND D.CB7_FILIAL = %xFilial:CB7%
		   AND D.%NotDel%
		   AND D.CB7_PEDIDO = A.C5_NUM
		   AND D.CB7_CLIENT = A.C5_CLIENTE
		   AND D.CB7_LOJA = A.C5_LOJACLI
		   AND D.CB7_DTEMIS = %Exp:Dtos(DDATABASE)%
		   AND E.CB8_FILIAL = %xFilial:CB8%
		   AND E.%NotDel%
		   AND E.CB8_PEDIDO = A.C5_NUM
		   AND E.CB8_SALDOS > 0
		   AND E.CB8_PROD = B.C6_PRODUTO
		   AND E.CB8_PEDIDO = D.CB7_PEDIDO
		   AND E.CB8_ORDSEP = D.CB7_ORDSEP
		   AND B.C6_TURNO = ' '
		GROUP BY C.B1_COD, C.B1_DESC, E.CB8_ORDSEP, CB8_LCALIZ
		ORDER BY 5, 4 DESC
	EndSql
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arqiuvo Temporario                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Notas de Saida                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

(cAliasTRB)->(dbGoTop())
oReport:Section(1):Init()
oReport:SetMeter(RecCount())
lPrt	:= .F.
While !oReport:Cancel() .And. !(cAliasTRB)->(Eof())
	lPrt	:= !lPrt
	cORDS	:= (cAliasTRB)->CB8_ORDSEP
	cISBN	:= (cAliasTRB)->B1_COD
	cDesc	:= (cAliasTRB)->B1_DESC
	nQtd	:= (cAliasTRB)->C6_QTDVEN
	cLoca	:= (cAliasTRB)->CB8_LCALIZ
	cPed 	+= Posicione("CB7",1,xfilial("CB7")+(cAliasTRB)->CB8_ORDSEP,"ALLTRIM(CB7_PEDIDO)")+"','"
	SC6->(DBSETORDER(2))
	IF SC6->(DBSEEK(xfilial("SC6")+cISBN+CB7->CB7_PEDIDO))
		reclock("SC6",.F.)
			SC6->C6_TURNO	:= '1' // processo para não rodar o pré pic de novo
		MSUNLOCK()
	ENDIF
	if lPrt
		oReport:Section(1):Cell("cORDS"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cORDS"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("cISBN"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cISBN"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("cDesc"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cDesc"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("nQtd"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("nQtd"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("cLoca"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cLoca"):SetClrBack(CLR_HGRAY) //cor do fundo
	else
		oReport:Section(1):Cell("cORDS"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cORDS"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("cISBN"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cISBN"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("cDesc"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cDesc"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("nQtd"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("nQtd"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("cLoca"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cLoca"):SetClrBack(CLR_WHITE) //cor do fundo
	endif
	oReport:Section(1):Cell("cORDS"	):Show()
	oReport:Section(1):Cell("cISBN"	):Show()
	oReport:Section(1):Cell("cDesc"	):Show()
	oReport:Section(1):Cell("cLoca"):Show()
	oReport:Section(1):Cell("nQtd"	):Show()
	oReport:Section(1):PrintLine()
	oReport:IncMeter()
	(cAliasTRB)->(dbskip())
EndDo

oReport:Section(1):SetTotalText("PRÉ PIC DA DATA DE: "+DTOC(DDATABASE-1)+" DATA ATÉ:"+DTOC(DDATABASE))
oReport:Section(1):Finish()
oReport:Section(1):Init()


oReport:Section(1):SetPageBreak()
(cAliasTRB)->(dbCloseArea())

Return


