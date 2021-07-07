#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELKIT    ºAutor  ³LEANDRO DUARTE      º Data ³  16/05/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE QUANTIDADE DE VENDAS REALISADAS NO KIT         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 E P12                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION RELKIT()
Local oReport
oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³LEANDRO DUARTE      º Data ³  16/05/2016 º±±
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
Local cTitulo1	:= "RELATORIO DE VENDAS DO KIT"
Local cTitulo2	:= "DETALHE DE VENDAS DO KIT"
Local cCodKit1	:= ""
Local cCodKit2	:= ""
Local cDescKit	:= ""
Local cItemPV	:= ""
Local cDescPro	:= ""
Local QtdKit	:= 0
Local cNotaFis	:= ""
Local cSerieFi	:= ""
Local cPedido	:= ""
Local cPeriodo	:= ""
Local cCodPrd	:= ""
Local nQtd		:= 0
Local nValor	:= 0
Local TotKit	:= 0
Private cPerg   :=PADR("KIT0100001",10)
Private oSintKit := oDetaKit := nil
ValidPerg(cPerg)
pergunte(cPerg,.f.)
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
oReport:= TReport():New("KIT0100001",cTitulo1,cPerg, {|oReport| ReportPrint(oReport)},cTitulo1)
oReport:SetPortrait(.F.)
oReport:SetLandscape(.T.)

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


oSintKit := TRSection():New(oReport,cTitulo1,{"TRB1"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
oSintKit:SetTotalInLine(.F.)
oDetaKit := TRSection():New(oReport,cTitulo2,{"TRB2"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
oDetaKit:SetTotalInLine(.F.)
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

TRCell():New(oSintKit,"cCodKit1" ,/*Tabela*/,"Cod Kit1",/*Picture*/,20,/*lPixel*/,{|| cCodKit1  })
TRCell():New(oSintKit,"cCodKit2" ,/*Tabela*/,"Cod Kit2",/*Picture*/,6,/*lPixel*/,{|| cCodKit2  })
TRCell():New(oSintKit,"cDescKit" ,/*Tabela*/,"Desc. Kit",/*Picture*/,60,/*lPixel*/,{|| cDescKit  })
TRCell():New(oSintKit,"QtdKit" ,/*Tabela*/,"Quantidade Kit",/*Picture*/,8,/*lPixel*/,{|| QtdKit  })
TRCell():New(oSintKit,"TotKit" ,/*Tabela*/,"Total do Kit","@E 999,999,999.99",15,/*lPixel*/,{|| TotKit  })
TRCell():New(oDetaKit,"cNotaFis" ,/*Tabela*/,"Nota Fiscal",/*Picture*/,9,/*lPixel*/,{|| cNotaFis  })
TRCell():New(oDetaKit,"cSerieFi" ,/*Tabela*/,"Serie NF",/*Picture*/,3,/*lPixel*/,{|| cSerieFi  })
TRCell():New(oDetaKit,"cPedido" ,/*Tabela*/,"Pedido Venda",/*Picture*/,6,/*lPixel*/,{|| cPedido  })
TRCell():New(oDetaKit,"cItemPV" ,/*Tabela*/,"Item Pedido",/*Picture*/,6,/*lPixel*/,{|| cItemPV  })
TRCell():New(oDetaKit,"cPeriodo" ,/*Tabela*/,"Data Venda",/*Picture*/,8,/*lPixel*/,{|| cPeriodo  })
TRCell():New(oDetaKit,"cCodPrd" ,/*Tabela*/,"ISBN",/*Picture*/,30,/*lPixel*/,{|| cCodPrd  })
TRCell():New(oDetaKit,"cDescPro" ,/*Tabela*/,"Descrição",/*Picture*/,50,/*lPixel*/,{|| cDescPro  })
TRCell():New(oDetaKit,"nQtd" ,/*Tabela*/,"Qtd Vendida",/*Picture*/,8,/*lPixel*/,{|| nQtd  })
TRCell():New(oDetaKit,"nValor" ,/*Tabela*/,"Valor","@E 999,999,999.99",8,/*lPixel*/,{|| nValor  })

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

Local cAlias	:= ""
Local cAliar	:= ""
Local cAliasTRB	:= GETNEXTALIAS()
Local aQuery:= {}
Local cAliasTRS	:= GETNEXTALIAS()
Local cCodKit1	:= ""
Local cCodKit2	:= ""
Local cDescKit	:= ""
Local cItemPV	:= ""
Local cDescPro	:= ""
Local QtdKit	:= 0
Local cNotaFis	:= ""
Local cSerieFi	:= ""
Local cPedido	:= ""
Local cPeriodo	:= ""
Local cCodPrd	:= ""
Local nQtd		:= 0
Local nValor	:= 0
Local TotKit	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser                   ³
//³ utilizadas em outras funcoes nao precisando declara-las                ³
//³ como private.                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("cCodKit1"):SetBlock({|| cCodKit1	})
oReport:Section(1):Cell("cCodKit2"):SetBlock({|| cCodKit2	})
oReport:Section(1):Cell("cDescKit"):SetBlock({|| cDescKit	})
oReport:Section(1):Cell("QtdKit"):SetBlock({||   QtdKit	})
oReport:Section(1):Cell("TotKit"):SetBlock({||   TotKit	})
oReport:Section(2):Cell("cNotaFis"):SetBlock({|| cNotaFis	})
oReport:Section(2):Cell("cSerieFi"):SetBlock({|| cSerieFi	})
oReport:Section(2):Cell("cPedido"):SetBlock({||  cPedido	})
oReport:Section(2):Cell("cItemPV"):SetBlock({||  cItemPV   })
oReport:Section(2):Cell("cPeriodo"):SetBlock({|| cPeriodo	})
oReport:Section(2):Cell("cCodPrd"):SetBlock({||  cCodPrd	})
oReport:Section(2):Cell("cDescPro"):SetBlock({|| cDescPro	})
oReport:Section(2):Cell("nQtd"):SetBlock({||     nQtd	})
oReport:Section(2):Cell("nValor"):SetBlock({||  nValor	})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona SB1 para antes da impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//TRPosition():New(oReport:Section(1),"SB1",1,{|| xFilial("SB1") + TRB->D2_COD })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Edição de parametros para pegar a regra do primeiro dia do mes e o ultimo dia do mes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


cAlias := GetNextAlias()
oReport:Section(1):BeginQuery()
BeginSql Alias cAliasTRB
		SELECT DISTINCT A.UA3_CODKIT, A.UA3_SKUID, A.UA3_DESCRI, (SELECT CASE WHEN SUM(B.C6_QTDVEN) IS NULL THEN 0 ELSE SUM(B.C6_QTDVEN)END  FROM %table:SC6010% B WHERE B.C6_FILIAL = %xfilial:SC6%  AND B.%notDel% AND B.C6_CODKIT1 = A.UA3_CODKIT AND B.C6_CODKIT2 = A.UA3_SKUID AND B.C6_KITVTEX IN('S','N')) AS QTDKIT,
		(SELECT CASE WHEN SUM(B.C6_VALOR) IS NULL THEN 0 ELSE SUM(B.C6_VALOR)END  FROM %table:SC6010% B WHERE B.C6_FILIAL = %xfilial:SC6%  AND B.%notDel% AND B.C6_CODKIT1 = A.UA3_CODKIT AND B.C6_CODKIT2 = A.UA3_SKUID AND B.C6_KITVTEX IN('S','N')) AS TOTKIT
		  FROM %table:UA3010% A
		 WHERE A.UA3_FILIAL = %xfilial:UA3%  
		   AND A.%notDel%
		ORDER BY 1,2
EndSql
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arqiuvo Temporario                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAliasTRB)->(dbGoTop())
oReport:SetMeter(RecCount())
oReport:Section(1):Init()
While !oReport:Cancel() .And. (cAliasTRB)->(!Eof())
	oReport:Section(1):oFontBody:Bold := .T. // negrito
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³processo de alimentar as variaveis para adicionar no relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodKit1 		:= (cAliasTRB)->UA3_CODKIT
	cCodKit2 		:= (cAliasTRB)->UA3_SKUID
	cDescKit 		:= (cAliasTRB)->UA3_DESCRI
	QtdKit	 		:= (cAliasTRB)->QTDKIT
	TotKit	 		:= (cAliasTRB)->TOTKIT
	oReport:Section(1):Cell("cCodKit1"):Show()//HIDE()"
	oReport:Section(1):Cell("cCodKit2"):Show()//HIDE()"
	oReport:Section(1):Cell("cDescKit"):Show()//HIDE()"
	oReport:Section(1):Cell("QtdKit"):Show()//HIDE()"
	oReport:Section(1):Cell("TotKit"):Show()//HIDE()"
	oReport:Section(1):PrintLine()//imprime a linha
	oReport:IncMeter()
	oReport:SkipLine()//imprime a linha
	cAliar := GetNextAlias()
	oReport:Section(2):BeginQuery()
	
	BeginSql Alias cAliasTRS
			SELECT DISTINCT A.C6_PRODUTO,
			       C.B1_DESC,
			       B.UA3_CODKIT,
			       B.UA3_SKUID,
			       B.UA3_DESCRI,
			       A.C6_QTDVEN,
			       A.C6_NOTA,
			       A.C6_SERIE,
			       A.C6_NUM,
			       D.C5_EMISSAO,
			       A.C6_ITEM,
			       A.C6_VALOR
			  FROM %table:SC6010% A, %table:UA3010% B, %table:SB1010% C, %table:SC5010% D
			 WHERE A.%notDel%
			   AND A.C6_FILIAL = %xfilial:SC6%  
			   AND A.C6_CODKIT1 <> '     '
			   AND A.C6_CODKIT1 = B.UA3_CODKIT
			   AND A.C6_CODKIT2 = B.UA3_SKUID
			   AND A.C6_PRODUTO = B.UA3_PRODUT
			   AND B.%notDel%
			   AND B.UA3_FILIAL = %xfilial:UA3%
			   AND C.B1_COD = A.C6_PRODUTO
			   AND C.B1_FILIAL = %xfilial:SB1%
			   AND C.%notDel%
			   AND D.C5_FILIAL = %xfilial:SC5%
			   AND D.%notDel%
			   AND D.C5_NUM = A.C6_NUM
			   AND A.C6_KITVTEX = 'S'
			   AND D.C5_EMISSAO >= %Exp:mv_par01%
			   AND D.C5_EMISSAO <= %Exp:mv_par02% 
			   AND A.C6_PRODUTO >= %Exp:mv_par03%
			   AND A.C6_PRODUTO <= %Exp:mv_par04%
			   AND A.C6_CODKIT1 = %Exp:cCodKit1%
			   AND A.C6_CODKIT2 = %Exp:cCodKit2% 
			UNION
			SELECT DISTINCT A1.C6_PRODUTO,
			       C1.B1_DESC,
			       A1.C6_CODKIT1,
			       A1.C6_CODKIT2,
			       ' ' AS UA3_DESCRI,
			       A1.C6_QTDVEN,
			       A1.C6_NOTA,
			       A1.C6_SERIE,
			       A1.C6_NUM,
			       D1.C5_EMISSAO,
			       A1.C6_ITEM,
			       A1.C6_VALOR
			  FROM  %table:SC6010% A1,  %table:SB1010% C1,  %table:SC5010% D1
			 WHERE A1.%notDel%
			   AND A1.C6_FILIAL = %xfilial:SC6%
			   AND A1.C6_CODKIT1 <> '     '
			   AND C1.B1_COD = A1.C6_PRODUTO
			   AND C1.B1_FILIAL = %xfilial:SB1%
			   AND C1.%notDel%
			   AND D1.C5_FILIAL = %xfilial:SC5%
			   AND D1.%notDel%
			   AND D1.C5_NUM = A1.C6_NUM
			   AND A1.C6_KITVTEX = 'N'
			   AND D1.C5_EMISSAO >= %Exp:mv_par01%
			   AND D1.C5_EMISSAO <= %Exp:mv_par02% 
			   AND A1.C6_PRODUTO >= %Exp:mv_par03%
			   AND A1.C6_PRODUTO <= %Exp:mv_par04% 
			   AND A1.C6_CODKIT1 = %Exp:cCodKit1%
			   AND A1.C6_CODKIT2 = %Exp:cCodKit2%
			   AND D1.C5_NUM IN (SELECT A2.C6_NUM
			                       FROM %table:SC6010% A2, %table:UA3010% B2, %table:SB1010% C2, %table:SC5010% D2
			                      WHERE A2.%notDel%
			                        AND A2.C6_FILIAL = %xfilial:SC6%
			                        AND A2.C6_CODKIT1 <> '     '
			                        AND A2.C6_CODKIT1 = B2.UA3_CODKIT
			                        AND A2.C6_CODKIT2 = B2.UA3_SKUID
			                        AND A2.C6_PRODUTO = B2.UA3_PRODUT
			                        AND B2.%notDel%
			                        AND B2.UA3_FILIAL = %xfilial:UA3%
			                        AND C2.B1_COD = A2.C6_PRODUTO
			                        AND C2.B1_FILIAL = %xfilial:SB1%
			                        AND C2.%notDel%
			                        AND D2.C5_FILIAL = %xfilial:SC5%
			                        AND D2.%notDel%
			                        AND D2.C5_NUM = A2.C6_NUM
	 							    AND D2.C5_EMISSAO >= %Exp:mv_par01%
	  							    AND D2.C5_EMISSAO <= %Exp:mv_par02% 
								    AND A2.C6_PRODUTO >= %Exp:mv_par03%
								    AND A2.C6_PRODUTO <= %Exp:mv_par04%
								    AND A2.C6_CODKIT1 = %Exp:cCodKit1%
								    AND A2.C6_CODKIT2 = %Exp:cCodKit2% )
			ORDER BY 9, 11
	EndSql
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera Arqiuvo Temporario                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(cAliasTRS)->(dbGoTop())
	oReport:SetMeter(RecCount())
	oReport:Section(2):Init()
	While !oReport:Cancel() .And. (cAliasTRS)->(!Eof())
		oReport:Section(2):oFontBody:Bold := .F. // negrito
		cNotaFis 		:= (cAliasTRS)->C6_NOTA
		cSerieFi 		:= (cAliasTRS)->C6_SERIE
		cPedido 		:= (cAliasTRS)->C6_NUM
		cPeriodo 		:= (cAliasTRS)->C5_EMISSAO
		cCodPrd 		:= (cAliasTRS)->C6_PRODUTO
		cDescPro 		:= (cAliasTRS)->B1_DESC
		cItemPV			:= (cAliasTRS)->C6_ITEM
		nQtd	 		:= (cAliasTRS)->C6_QTDVEN
		nValor	 		:= (cAliasTRS)->C6_VALOR
	
		oReport:Section(2):Cell("cNotaFis"):Show()//HIDE()"
		oReport:Section(2):Cell("cSerieFi"):Show()//HIDE()"
		oReport:Section(2):Cell("cPedido"):Show()//HIDE()"
		oReport:Section(2):Cell("cItemPV"):Show()//HIDE()"
		oReport:Section(2):Cell("cPeriodo"):Show()//HIDE()"
		oReport:Section(2):Cell("cCodPrd"):Show()//HIDE()"
		oReport:Section(2):Cell("cDescPro"):Show()//HIDE()"
		oReport:Section(2):Cell("nQtd"):Show()//HIDE()" 
		oReport:Section(2):Cell("nValor"):Show()//HIDE()" 
		
		oReport:Section(2):PrintLine()//imprime a linha
		
		oReport:IncMeter()
		(cAliasTRS)->(dbskip())
	END
	oReport:SkipLine()//imprime a linha
	oReport:ThinLine()//imprime a linha
	(cAliasTRB)->(dbskip())
End

oReport:Section(1):SetTotalText("TOTAL")//+ " " + AllTrim(RetTitle(cVaria)) + " " + &cCampo)		// "TOTAL"
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak()
(cAliasTRB)->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXPR041   ºAutor  ³Microsiga           º Data ³  04/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)
Local nY, nX
Local aRegs  	:= {}
Local nSX1Order	:= SX1->(IndexOrd())

SX1->(dbSetOrder(1))
cPerg :=PADR(cPerg,len(sx1->x1_grupo))

Aadd(aRegs,{cPerg,"01","PERIODO DE",	"",	"",	"mv_ch1",	"D",	8						,	0,	0,	"G",	"",	"mv_par01",	"",	"",	"",	"",	"",				"",  					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","",""	})
Aadd(aRegs,{cPerg,"02","PERIODO ATÉ",	"",	"",	"mv_ch2",	"D",	8						,	0,	0,	"G",	"",	"mv_par02",	"",	"",	"",	"",	"",				"",  					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","",""	})
Aadd(aRegs,{cPerg,"03","PRODUTO DE",	"",	"",	"mv_ch3",	"C",	TamSx3('B1_COD')[1]		,	0,	0,	"G",	"",	"mv_par03",	"",	"",	"",	"",	"",				"",  					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","SB1",""	})
Aadd(aRegs,{cPerg,"04","PRODUTO ATÉ",	"",	"",	"mv_ch4",	"C",	TamSx3('B1_COD')[1]		,	0,	0,	"G",	"",	"mv_par04",	"",	"",	"",	"",	"",				"", 					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","SB1",""	})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

