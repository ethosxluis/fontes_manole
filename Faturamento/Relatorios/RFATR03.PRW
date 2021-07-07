#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE  CRLF  Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ RFATR03  ³ Autor ³ TOTVS                    ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// 10/03/14 - Incluir parametro impressão somente com saldo pendente          //
// 21/03/14 - Gravar as quantidades somente no primeiro item cf relatorio     //
// 02/04/14 - Verifcar o evento de cada saldo                                 //
// 08/04/14 - Gerar a planilha para envio ao cliente - Solicitação Daniel     //
// 10/12/14 - Alterado a versão de 03/11/14 - % desconto pegar da NF origem   //
//          - Gerar as linhas de area / desconto na planilha do cliente       //
// 17/12/14 - Incluir ordem de impressao ( codigo prod ou descricao prod )    //
// 02/07/15 - Parametro para excluir clientes deposito externo (ADK-000001)   //
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATR03()

//³ Define Variaveis                                             ³
Local cDesc1  := "Este relatório ira imprimir o resumo  "
Local cDesc2  := "das consignacoes por cliente."
Local cDesc3  := "."

Private cString  := "SZ2"
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RFAT03"
Private NomeProg := "RFAT03"
Private nLastKey := 0
Private Limite   := 220//P=80    M=132   G=220
Private Tamanho  := "G"
Private Titulo   := "Relação de Consignacao por Cliente"
Private cPerg    := "RFAT03"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "Registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private lImp     := .F.

Private nRecSD2 := 0 // sonia - 10/03/14
Private aHeader := {} // sonia - 10/03/14
Private aCols   := {} // sonia - 10/03/14
Private N       := 1 // sonia - 10/03/14
Private cAliasNew := GetNextAlias()
Private cNomeCli  := ""
Private cNomeVend := ""
Private cNmAutor  := ""
Private WD_AREA   := ""
Private nQtdPen   := 0

AjustaSX1()
Pergunte(cPerg,.F.)

//           0        10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1   := " Cliente - Loja - Vendedo                                                                                                                              Preco      ------------------ NOTA FISCAL DE ORIGEM ------------------"
Cabec2   := " I.S.B.N.           Cliente Titulo                             Autor                     Evento  Consign  Dv.Simb  Dv.Fis. Faturado Pendente  Area     Atual      Descto No da N.F Lc  Emissão   Saldo  Preco N.F Liq X Saldo"
///////////// 123456779D12345678  123456 123456789D123456789V123456789T1234 123456789D123456789V12345 123456  999,999  999,999  999,999  999,999  999,999  12345678 99,999.99  999.99 123456789 99 99/99/99 999,999  99,999.99   99,999.99

////////////////////////////////////////
//mv_par01 -  1=Analitico; 2=Sintetico//
////////////////////////////////////////
//Cabec1 := "Vendedor    Pedido     Frete        Qtd Caixas            Valor "
/*

| Parametros do aReturn |
aReturn - Preenchido pelo SetPrint()
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Comprimido 2=Normal
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Prota ou arquivo 1-Lpt1... 4-Com1...
aReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//| Solicita ao usuario a parametrizacao do relatorio.
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,.F.,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)


//| Se teclar ESC, sair
If nLastKey == 27
	Return
Endif

//| Estabelece os padroes para impressao, conforme escolha do usuario
SetDefault(aReturn,cString)

//| Verificar se sera reduzido ou normal
nTipo := Iif(aReturn[4] == 1, 15, 18)

//| Se teclar ESC, sair
If nLastKey == 27
	Return
Endif

//| Chama funcao que processa os dados
RptStatus({|lEnd| FATR01(@lEnd, wnrel, cString) }, "Aguarde...", "Processando Registros...", .T. )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ FATR01   ³ Autor ³TOTVS                  ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  FATR01(lEnd,WnRel,cString)

//³ Define Variaveis                                             ³

Local cQuery    := ""
Local cChave    := ""
Local ENTERL    := CHR(13)+CHR(10)
Local nTotPen   := 0
Local nTotLiq   := 0
Local nTpArea := 0

//| Cria filtro temporario
// mv_par11 = 1 - Loja; 2 = Evento ; 3 = Ambos.
cAliasNew := GetNextAlias()

///// SONIA - 17/03/14 - CRIAR O ARQUIVO EXCELL - INICIO    //
///// SONIA - 08/04/14 - CRIAR O ARQUIVO EXCELL - CLIENTE   //

WDIR_ARQ  := ALLTRIM(MV_PAR13) + IIF(RIGHT(ALLTRIM(MV_PAR13),1) <> "/", "/", "") + ALLTRIM(MV_PAR14)
WNOME_ARQ := WDIR_ARQ + ".xls"
WNOME_CLI := WDIR_ARQ + "_CLIENTE.xls" // SONIA - 08/04/14
nHdl      := FCreate( WNOME_ARQ )
nHdl_CLI  := FCreate( WNOME_CLI )  // SONIA - 08/04/14
IF EMPTY(WDIR_ARQ)
	MSGALERT(ALLTRIM(CUSERNAME) + ", PARAMETROS PARA GERACAO DO ARQUIVO EXCEL EM BRANCO !!!")
ELSE

	   W_CLIENTE := ": " + MV_PAR01 + " - " + ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + MV_PAR01, "A1_NOME"))
	   IF MV_PAR01 <> MV_PAR03
	      W_CLIENTE += " a: " + MV_PAR03 + " - " + ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + MV_PAR03, "A1_NOME"))
       ENDIF

	If nHdl >= 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ
		//³monta cabeçalho de pagina HTML para posterior utilização³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ

		cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
		cLinFile += "<TR>
		cLinFile += "<TD colspan=28 align ='center' style='Background: #FFFFC0; font-style: Bold;'><b> Saldo MENSAL de Consignação</b></TD>"+ CRLF
		cLinFile += "</TR>"+ CRLF
		cLinFile += "</Table>"+ CRLF
		FWRITE(nHdl, cLinFile)

		// LINHA CABECALHO
		cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
		cLinFile += "<TR>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>COD CLIENTE</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>LOJA</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NOME CLIENTE</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>COD VENDEDOR</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NOME VENDEDOR</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ESGOTADO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ISBN</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>TÍTULO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>AUTOR</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>EVENTO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>CONSIG</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DEV SIMB</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DEV FÍSICA</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>FATURADO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>PENDENTE</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ÁREA</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DESCONTO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>PREÇO ATUAL</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NF ORIGEM</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>LOCAL</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NF EMISSÃO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SALDO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NF PREÇO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>PREÇO LIQ X SALDO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SALDO ESTOQUE</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NÍVEL ESGOT</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>MUNICÍPIO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>UF</b></TD>"+ CRLF
		
		/*Edmar Mendes do Prado
		17/07/2019 - Solicitação da Amarylis
		
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ULTIMA COMPRA</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SALDO A RECEBER</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>LIMITE CONSIGNACAO</b></TD>"+ CRLF
		//Fim Edmar
		*/
		cLinFile += "</TR>"+ CRLF
		FWRITE(nHdl, cLinFile)

		//FWrite( nHdl, 'Relatorio de consignacao' + W_CLIENTE + CRLF )
		//FWrite( nHdl, "COD CLIENTE; LOJA; NOME CLIENTE; COD VENDEDOR; NOME VENDEDOR; ESGOTADO; ISBN (PRODUTO); TITULO; AUTOR; EVENTO; CONSIGN; DEV SIMB; DEV FISICA; FATURADO; PENDENTE; AREA; DESCONTO; PRECO ATUAL; NF ORIGEM; LOCAL; NF EMISSAO; SALDO; NF PRECO; PREC LIQ X SALDO; SALDOESTOQUE; NIVEL ESGOT; MUNICIPIO; UF" + CRLF )

	ELSE
		MSGALERT(ALLTRIM(CUSERNAME) + ", NÃO FOI POSSIVEL CRIAR AS INFORMACOES PARA O EXCEL: " + WNOME_ARQ )
	ENDIF

	If nHdl_CLI >= 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ
		//³monta cabeçalho de pagina HTML para posterior utilização³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ

		cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
		cLinFile += "<TR>
		cLinFile += "<TD colspan=13 align ='center' style='Background: #FFFFC0; font-style: Bold;'><b> Saldo MENSAL de Consignação</b></TD>"+ CRLF
		cLinFile += "</TR>"+ CRLF
		cLinFile += "</Table>"+ CRLF
		FWRITE(nHdl_CLI, cLinFile)

		// LINHA CABECALHO
		cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
		cLinFile += "<TR>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ESGOTADO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ISBN</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>TÍTULO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>AUTOR</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>EVENTO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>ÁREA</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DESCONTO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NF ORIGEM</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NF EMISSÃO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SALDO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>PREÇO ORIGEM</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>MUNICÍPIO</b></TD>"+ CRLF
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>UF</b></TD>"+ CRLF
		cLinFile += "</TR>"+ CRLF
		FWRITE(nHdl_CLI, cLinFile)

		//FWrite( nHdl_CLI, 'Relatorio de consignacao - Cliente ' + W_CLIENTE + CRLF )
		//FWrite( nHdl_CLI, "ESGOTADO; ISBN (PRODUTO); TITULO; AUTOR; EVENTO; AREA; DESCONTO; NF ORIGEM; NF EMISSAO; SALDO; PRECO ORIGEM; MUNICIPIO; UF" + CRLF )

	ELSE
		MSGALERT(ALLTRIM(CUSERNAME) + ", NÃO FOI POSSIVEL CRIAR AS INFORMACOES PARA O EXCEL: " + WNOME_CLI )
	ENDIF
ENDIF

///// SONIA - 17/03/14 - CRIAR O ARQUIVO EXCELL - FINAL   //
cQuery := " SELECT SZ2.Z2_CLIENTE, SZ2.Z2_LOJA, SZ2.Z2_PRODUTO, SZ2.Z2_EVENTO, SA1.A1_VEND, "+ ENTERL
cQuery += " SZ2.Z2_QTDCON, SZ2.Z2_DEVSIMB, SZ2.Z2_DEVFIS, SZ2.Z2_FATCON, B1_DESC "+ ENTERL   // SK - 17/12/14 - INCLUIR B1_DESC

cQuery += " FROM " + RetSqlName("SZ2") + " SZ2 " +ENTERL

cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + ENTERL
cQuery += " SA1.A1_FILIAL  = '"+ xFilial("SA1")+"' AND "+ENTERL         // SK - 17/12/14 - INCLUIR A VERIFICACAO DA FILIAL DA TABELA SA1
cQuery += " SA1.A1_COD = SZ2.Z2_CLIENTE AND "+ ENTERL
cQuery += " SA1.A1_LOJA = SZ2.Z2_LOJA "+ ENTERL

cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + ENTERL  // SK - 17/12/14 - INCLUIR TABELA SB1
cQuery += " SB1.B1_COD = SZ2.Z2_PRODUTO AND "+ ENTERL               // SK - 17/12/14 - INCLUIR TABELA SB1
cQuery += " SB1.B1_FILIAL  = '"+ xFilial("SB1")+"' "+ENTERL         // SK - 17/12/14 - INCLUIR TABELA SB1

cQuery += " WHERE SZ2.Z2_FILIAL  = '"+ xFilial("SZ2")+"' AND "+ENTERL
cQuery += " SZ2.Z2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03 +"' AND " + ENTERL
cQuery += " SZ2.Z2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04+ "' AND " + ENTERL
cQuery += " SZ2.Z2_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "' AND " + ENTERL

If mv_par07 == 1 // Loja
	cQuery += " SZ2.Z2_EVENTO = '      ' AND " + ENTERL
ElseIf mv_par07 == 2 // Evento
	cQuery += " SZ2.Z2_EVENTO BETWEEN '" + mv_par08 + "' AND '" + mv_par09+ "' AND " + ENTERL
	cQuery += " SZ2.Z2_EVENTO <> '      ' AND " + ENTERL
EndIf
cQuery += " SA1.A1_VEND BETWEEN '" + mv_par10 + "' AND '" + mv_par11+ "' AND " + ENTERL

IF MV_PAR16 == 1 // SOMENTE CLIENTES - SK - 02/07/15
   cQuery += " SA1.A1_UNIDVEN <> '000001' AND " + ENTERL
ELSEIF MV_PAR16 == 2 // SOMENTE DEPOSITO EXTERNO - SK - 02/07/15
   cQuery += " SA1.A1_UNIDVEN = '000001' AND " + ENTERL
ENDIF

cQuery += " SZ2.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery += " SA1.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery += " SB1.D_E_L_E_T_ <> '*' " + ENTERL  // SK - 17/12/14/ - INCLUIR TABELA SB1

IF MV_PAR15 == 1 // ORDEM POR CODIGO DO PRODUTO
   cQuery += " ORDER BY Z2_CLIENTE, Z2_LOJA, Z2_EVENTO, Z2_PRODUTO " + ENTERL
ELSE
   cQuery += " ORDER BY Z2_CLIENTE, Z2_LOJA, Z2_EVENTO, B1_DESC " + ENTERL
ENDIF

MEMOWRITE ("RFATR03.TXT",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

aadd( aHeader, { "Quantidade", "D1_QUANT"})        // SONIA - 10/03/14
aadd( aHeader, { "Total",      "D1_TOTAL"})        // SONIA - 10/03/14
aadd( aHeader, { "Ident B6",   "D1_IDENTB6"})      // SONIA - 10/03/14
aadd( aHeader, { "TES",        "D1_TES"})          // SONIA - 10/03/14
aadd( aCols  , { 1, 0, SPACE(1), "001", .F.})      // SONIA - 10/03/14

(cAliasNew)->(dbGoTop())
If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

WT_PENDENTE  := 0  // SONIA - 08/04/14
WT_ANALITICO := 0  // SONIA - 08/04/14
WT_VALOR     := 0  // SONIA - 08/04/14

DO While (cAliasNew)->(!Eof())

	// REMOVIDO FONTANELLI
	// nQtdPen := ((cAliasNew)->Z2_QTDCON - (cAliasNew)->Z2_DEVSIMB -(cAliasNew)->Z2_DEVFIS) // SONIA - 10/03/14

	// ADICIONADO FONTANELLI
    nQtdPen := U_SALDOSB6((cAliasNew)->Z2_CLIENTE,(cAliasNew)->Z2_LOJA, (cAliasNew)->Z2_PRODUTO, (cAliasNew)->Z2_EVENTO )

	IF MV_PAR12 == 3 .OR.;                          // SONIA - 10/03/14 - IMPRIME COM SALDO E SEM SALDO PENDENTE
		( MV_PAR12 == 1 .AND. NQTDPEN <> 0 ) .OR. ;  // SONIA - 10/03/14 - SOMENTE SALDO PENDENTE
		( MV_PAR12 == 2 .AND. NQTDPEN == 0 )         // SONIA - 10/03/14 - SOMENTE SALDO PENDENTE

		lImp   := .T.

		If cChave <> (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA

			cNomeCli := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_NREDUZ")
			cNomeVend := Posicione("SA3",1,xFilial("SA3")+(cAliasNew)->A1_VEND,"A3_NREDUZ")
			@ Li, 000 PSay (cAliasNew)->Z2_CLIENTE + " "+ (cAliasNew)->Z2_LOJA +" - "+ cNomeCli + " "+ (cAliasNew)->A1_VEND+ " - "+cNomeVend
			Li++
			@ Li,000 Psay __PrtThinLine()
			Li++

			cChave  := (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA
			nTotPen := 0
		EndIf
		//** Posicionamento do relatorios alterado p/ Adalberto em 17/10/11
		@ Li, 000 PSay LEFT( (cAliasNew)->Z2_PRODUTO, 19) // SONIA - 10/03/14 - LIMITADO A 19
		@ Li, 021 PSay (cAliasNew)->Z2_CLIENTE // código do autor alterado por Adalberto em 03/11/14
		@ Li, 028 PSay left( AllTrim(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")), 34) // SONIA - 10/03/14 - LIMITADO A 40 /Limitado a 34 - Adalberto - 03/11/14
		cNmAutor := LEFT( Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_XNMAUT"), 25) // SONIA - 10/03/14 - LIMITADO A 25
		if cNmAutor == " "
			cNmAutor := "."
		Endif
		@ Li, 063 PSay cNmAutor  // SONIA - 10/03/14 - ESTAVA 65
		@ Li, 089 PSay (cAliasNew)->Z2_EVENTO  // SONIA - 10/03/14 - ESTAVA 92
		//	@ Li, 085 PSay 50 Picture PesqPict("SD2","D2_QUANT")// Preco de Tabela
		@ Li, 097 PSay (cAliasNew)->Z2_QTDCON  Picture "@E 999,999"//CONSIGNADO // SONIA - 10/03/14 -  ESTAVA 102
		@ Li, 106 PSay (cAliasNew)->Z2_DEVSIMB Picture "@E 999,999"//DEV.SIMN  // SONIA - 10/03/14 - ESTAVA 115
		@ Li, 115 PSay (cAliasNew)->Z2_DEVFIS  Picture "@E 999,999"//DEV. FISICA  // SONIA - 10/03/14 - ESTAVA 128
		@ Li, 124 PSay (cAliasNew)->Z2_FATCON  Picture "@E 999,999"//FATURADO // SONIA - 10/03/14 - ESTAVA 143
		///	nQtdPen := ((cAliasNew)->Z2_QTDCON - (cAliasNew)->Z2_DEVSIMB -(cAliasNew)->Z2_DEVFIS) // SONIA - 10/03/14 - 10/03/14
		@ Li, 133 PSay nQtdPen  Picture "@E 999,999"//PENDENTE // SONIA - 10/03/14 - ESTAVA 182
		//	@ Li, 175 PSay 9999                Picture PesqPict("SD2","D2_QUANT")//Total Liquido

		//**  Alterado p/ Adalberto em 18/10/11
		//   	@ Li, 175 PSay Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_XSEGME")//Segmento de desconto
		//	@ Li, 179 PSay Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_PRODUTO,"A1_XDESC1") Picture "@E 999,999.99"//Desconto

		//**
		nTpArea   := Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_XSEGME")//Segmento de desconto
		WD_AREA   := ""  // SONIA - 17/03/14 - JOGO PARA VARIAVEL PARA UTILIZAR NA GERACAO DO ARQUIVO EM EXCELL
		WDESCONTO := 0   // SONIA - 17/03/14 - JOGO PARA VARIAVEL PARA UTILIZAR NA GERACAO DO ARQUIVO EM EXCELL

		If  val(nTpArea) == 1
			WD_AREA   := "Medicina"
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC1")
			@ Li, 142 PSay WD_AREA
////////////@ Li, 151 PSay WDESCONTO Picture "@E 999.99"//Desconto de medicina // 10/12/14 CONSIDERAR O DESCONTO DA NF ORIGEM
		ElseIf val(nTpArea) == 2
			WD_AREA   := "Publico "
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC2")
			@ Li, 142 PSay WD_AREA
////////////@ Li, 151 PSay WDESCONTO  Picture "@E 999.99"//Desconto de Publico// 10/12/14 CONSIDERAR O DESCONTO DA NF ORIGEM
		ElseIf val(nTpArea) == 03
			WD_AREA   := "Humanas "
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC3")
			@ Li, 142 PSay WD_AREA
////////////@ Li, 151 PSay WDESCONTO  Picture "@E 999.99"//Desconto de Humanas // 10/12/14 CONSIDERAR O DESCONTO DA NF ORIGEM
		Else
			WD_AREA   := "Civil   "
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC4")
			@ Li, 142 PSay WD_AREA
////////////@ Li, 151 PSay WDESCONTO Picture "@E 999.99"//Desconto de Civil // 10/12/14 CONSIDERAR O DESCONTO DA NF ORIGEM
		Endif

		@ Li, 151 PSay Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_PRV1") Picture "@E 999,999.99" //Preço Unitario

		nTotPen += nQtdPen

       U_IMP_SLDSB6((cAliasNew)->Z2_CLIENTE,(cAliasNew)->Z2_LOJA, (cAliasNew)->Z2_PRODUTO, nQtdPen, (cAliasNew)->Z2_EVENTO )     // SONIA - 10/03/14 - 02/04/14 - EVENTO

		Li++


	ENDIF // SONIA - 10/03/14 - TRATAMENTO PARA IMPRESSAO DE SALDO PENDENTE

	(cAliasNew)->(dbSkip())

	//	If cChave <> (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA // SONIA - 10/03/14
	If cChave <> (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA .AND. NTOTPEN <> 0 // SONIA - 10/03/14
		Li++
		@ Li, 000 PSay " T O T A L  - - - - - - - - - - - - > "
		@ Li, 128 PSay	nTotPen Picture "@E 99,999,999"
		Li++
		@ Li,000 Psay __PrtThinLine()
		//@ Li, 000 PSay Replicate("=", Limite)
		Li++
		//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf

	If Li > 51 //.And. !TRB->(Eof())
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//		Li++
		//		@ Li,000 Psay __PrtThinLine()
		//		Li++
		//		Cabec1()
	Endif

EndDo

U_GRV_NHDL(SPACE(1), SPACE(1), "TOTAL GERAL", STR(WT_ANALITICO), "0", STR(WT_VALOR), "TOT", .T., WT_PENDENTE ) // SONIA - 08/04/14


FClose( nHdl ) // SONIA - 17/03/14

FClose( nHdl_CLI ) // SONIA - 08/04/14

If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

(cAliasNew)->(DbCloseArea())

If lEnd
	@ Li, 000 PSay cCancel
	Return
Endif

If 	lImp
	If Li <> 80
		Roda(cbCont,cbTxt,Tamanho)//Impressao de Rodape padrao.
	Endif
	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
Else
	MsgStop ("Nao existem dados a serem visualizados!, Verifique os parametros" )
EndIf

Ms_Flush()

Return

/*
* rotina para geração de arquivo em formato excel (xls)               *
* desenvolvida por Adalberto em 25/10/11                              *
*/
cArqExcel := __RELDIR+NomeProg="_"+Substr(cUsuario,7,4)+".XLS"
Copy To &cArqExcel

#IFNDEF TOP
	dbSelectArea(CAliasImp)
	RetIndex(cAliasImp)
	Set Filter TO
#ELSE
	dbSelectArea(CAliasImp)
	dbCloseArea()
#ENDIF

dbSetOrder(1)
dbGoTop()

If aReturn[5] ==1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

// Abrindo a planilha em Excel
If mv_par8 ==1
	__CopyFile(cArqExcel, "c:\"+NomeProg+"_"=Substr(cUsuario,7,4)+".XLS")
	If ! ApOleClient("MsExcel")
		MsgAlert("MsExcel não instalado !")
		Return
	Endif
	oExcelApp := MsExcel() :New()
	oExcelApp:WorkBooks:Open( "c:\"+NomeProg+"_"+Substr(cUsuario,7,4)+".XLS" )
	oExcelApp:SetVisible(.T.)
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    ºData  ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para incluir os grupos de perguntas OMSC01           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
PutSx1(cPerg, '01', 'Cliente de      ?', 'Cliente de     ?', 'Cliente de    ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par01', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '02', 'Loja de         ?', 'Loja de        ?', 'Loja de       ?', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '03', 'Cliente ate     ?', 'Cliente ate    ?', 'Cliente ate   ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par02', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'Loja Ate        ?', 'Loja ate       ?', 'Loja ate      ?', 'mv_ch4', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '05', 'Produto de      ?', 'Produto de     ?', 'Produto de    ?', 'mv_ch5', 'C',30, 0, 0, 'G', '', 'SB1'   , '', '', 'mv_par05', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto ate     ?', 'Produto ate    ?', 'Produto ate   ?', 'mv_ch6', 'C',30, 0, 0, 'G', '', 'SB1'   , '', '', 'mv_par06', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '07', 'Tipo Consignacao ?','Tipo Consignacao?','Tipo Consig    ?', 'mv_ch7', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par07',	 'Loja','Loja','Loja', '', 'Evento','Evento','Evento','Ambos','Ambos','Ambos','','','','','','','')

PutSx1(cPerg, '08', 'Evento de       ?', 'Evento de      ?', 'Evento de     ?', 'mv_ch8', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par08', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '09', 'Evento ate      ?', 'Evento ate     ?', 'Evento ate    ?', 'mv_ch9', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par09', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '10', 'Vendedor de     ?', 'Vendedor de    ?', 'Vendedor de   ?', 'mv_cha', 'C',6, 0, 0, 'G', '', 'SA3'   , '', '', 'mv_par10', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '11', 'Vendedor ate    ?', 'Vendedor ate   ?', 'Vendedor ate  ?', 'mv_chb', 'C',6, 0, 0, 'G', '', 'SA3'   , '', '', 'mv_par11', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '12','Somente saldo pendente?','Somente saldo pendente?','Somente saldo pendente?', 'mv_chc', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par12',	 'Sim','Sim','Sim', '', 'Nao','Nao','Nao','Ambos','Ambos','Ambos','','','','','','','') // SONIA - 10/03/14

PutSx1(cPerg, '13', 'Pasta arquivo Excell?', 'Pasta arquivo Excell    ?', 'Pasta arquivo Excell   ?', 'mv_chd', 'C',50, 0, 0, 'G', '', ''   , '', '', 'mv_par13', '', '', '', '', '', '', '','','','','','','','','','','') // SONIA - 17/03/14
PutSx1(cPerg, '14', 'Nome arquivo Excell?', 'Nome arquivo Excell    ?', 'Nome arquivo Excell   ?', 'mv_che', 'C',20, 0, 0, 'G', '', ''   , '', '', 'mv_par14', '', '', '', '', '', '', '','','','','','','','','','','')    // SONIA - 17/03/14

PutSx1(cPerg, '15', 'Ordem para impressao?','Ordem para impressao?','Ordem para impressao?', 'mv_chf', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par15',	 'Codigo Prod','Codigo Prod','Codigo Prod', '', ' Descricao Prod',' Descricao Prod',' Descricao Prod','','','','','','','','','','') // SK - 17/12/14

PutSx1(cPerg, '16','Tipo de impressao?','Tipo de impressao?','Tipo de impressao?', 'mv_chc', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par16',	 'Clientes','Clientes','Clientes', '', 'Deposito Externo','Deposito Externo','Deposito Externo','Ambos','Ambos','Ambos','','','','','','','') // SONIA - 02/07/15

/////*
///PutSx1(cPerg, '03', 'Cliente de       ?', 'Cliente de      ?', 'Cliente de     ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///PutSx1(cPerg, '04', 'Cliente ate      ?', 'Cliente ate     ?', 'Cliente ate    ?', 'mv_ch4', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///
///PutSx1(cPerg, '05', 'Loja de          ?', 'Loja de         ?', 'Loja de        ?', 'mv_ch5', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///PutSx1(cPerg, '06', 'Loja Ate         ?', 'Loja Ate        ?', 'Loja Ate       ?', 'mv_ch6', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///
///PutSx1(cPerg, '07', 'Emissao de       ?', 'Emissao de      ?', 'Emissao de     ?', 'mv_ch7', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par05', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///PutSx1(cPerg, '08', 'Emissao ate      ?', 'Emissao ate     ?', 'Emissao ate    ?', 'mv_ch8', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par06', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///
///PutSx1(cPerg, '09','Tipo Frete        ?', 'Tipo Frete      ?','Tipo Frete      ?', 'mv_ch9', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par05',	 'Cif',	'Cif','Cif', '', 'Fob',	'Fob','Fob','Ambos','Ambos','Ambos','','','','','','','')
////*/

Return



//////////////////////////////////////////////////////////////////////////////
USER FUNCTION SALDOSB6(x_cliente, x_loja, x_produto,  x_evento) // FONTANELLI
//////////////////////////////////////////////////////////////////////////////
If Select("_QRYPSB6") > 0
	_QRYSB6_SD2->( DbCloseArea() )
EndIf
cQuery := "SELECT * FROM " + RetSqlName( "SB6" ) + " SB6, " +  RetSqlName( "SD2" ) + " SD2
cQuery += " WHERE SB6.D_E_L_E_T_= ' '  AND B6_SALDO <> 0"
cQuery += " AND B6_FILIAL = '"  + XFILIAL("SB6") + "'"
cQuery += " AND B6_CLIFOR = '"  + x_cliente  + "'"
cQuery += " AND B6_LOJA = '"    + x_loja + "'"
cQuery += " AND B6_PRODUTO = '" + x_produto + "'"
cQuery += " AND SD2.D_E_L_E_T_= ' '  "
cQuery += " AND D2_FILIAL = '"  + XFILIAL("SD2") + "'"
cQuery += " AND D2_CLIENTE = '" + x_cliente  + "'"
cQuery += " AND D2_LOJA  = '"   + x_loja + "'"
cQuery += " AND D2_COD = '" + x_produto + "'"
cQuery += " AND D2_LOCAL = B6_LOCAL AND D2_DOC = B6_DOC AND D2_SERIE = B6_SERIE "
cQuery += " AND D2_NUMSEQ = B6_IDENT"
cQuery += " AND D2_XEVENTO = '" + X_EVENTO + "'"
cQuery += " AND D2_CF NOT IN ('5103','5113','5116','5910','6113','5918','6918')"
TcQuery CQUERY New Alias _QRYSB6_SD2
W_SALDO := 0
DO WHILE .NOT. _QRYSB6_SD2->(EOF())
	W_SALDO += _QRYSB6_SD2->B6_SALDO
	_QRYSB6_SD2->(DBSKIP())
ENDDO
_QRYSB6_SD2->( DbCloseArea() )
RETURN(W_SALDO)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////USER FUNCTION IMP_SLDSB6(x_cliente, x_loja, x_produto, nQtdPen)      // SONIA 10/03/14 - 02/04/14 - evento //
USER FUNCTION IMP_SLDSB6(x_cliente, x_loja, x_produto, nQtdPen, x_evento) // SONIA 10/03/14 - 02/04/14 - evento //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If Select("_QRYPSB6") > 0
	_QRYSB6_SD2->( DbCloseArea() )
EndIf

cQuery := "SELECT * FROM " + RetSqlName( "SB6" ) + " SB6, " +  RetSqlName( "SD2" ) + " SD2
cQuery += " WHERE SB6.D_E_L_E_T_= ' '  AND B6_SALDO <> 0"
cQuery += " AND B6_FILIAL = '"  + XFILIAL("SB6") + "'"
cQuery += " AND B6_CLIFOR = '"  + x_cliente  + "'"
cQuery += " AND B6_LOJA = '"    + x_loja + "'"
cQuery += " AND B6_PRODUTO = '" + x_produto + "'"
cQuery += " AND SD2.D_E_L_E_T_= ' '  "                      // SONIA - 17/03/14 - TRATAMENTO COM AS NFS DE ORIGEM
cQuery += " AND D2_FILIAL = '"  + XFILIAL("SD2") + "'"
cQuery += " AND D2_CLIENTE = '" + x_cliente  + "'"
cQuery += " AND D2_LOJA  = '"   + x_loja + "'"
cQuery += " AND D2_COD = '" + x_produto + "'"
cQuery += " AND D2_LOCAL = B6_LOCAL AND D2_DOC = B6_DOC AND D2_SERIE = B6_SERIE "
cQuery += " AND D2_NUMSEQ = B6_IDENT"
cQuery += " AND D2_XEVENTO = '" + X_EVENTO + "'"            // SONIA - 02/04/14
cQuery += " AND D2_CF NOT IN ('5103','5113','5116','5910','6113','5918','6918')"

TcQuery CQUERY New Alias _QRYSB6_SD2

MEMOWRIT("C:\WINDOWS\TEMP\RFATR03_SB6_SD2", cQuery)

W_SALDO := 0
W_QITEM := 0

WT_PENDENTE += nQtdPen

IF _QRYSB6_SD2->(EOF())  // SE NAO TIVER O SB6 / SD2, GRAVA O ARQUIVO EM EXCELL

   U_GRV_NHDL(SPACE(1), SPACE(1), SPACE(1), "0", "0", "0", SPACE(1), .T., nQtdPen ) // SONIA - 17/03/14

ELSE

	WPRIM_ITEM := .T.      // SONIA - 21/03/14 - SE FOR O PRIMEIRO ITEM GRAVA AS LINHAS COM OS VALORES
	DO WHILE .NOT. _QRYSB6_SD2->(EOF())
	 	W_EMISSAO := STOD(_QRYSB6_SD2->B6_EMISSAO)
		WDESCONTO := _QRYSB6_SD2->D2_DESC  // 10/12/14 - CONSIDERAR O DESCONTO DA NF DE ORIGEM

		@ LI,162 PSAY WDESCONTO PICTURE "@E 999.99"
		@ LI,169 PSAY _QRYSB6_SD2->B6_DOC
		@ LI,179 PSAY _QRYSB6_SD2->B6_LOCAL
		@ LI,182 PSAY STRZERO(DAY(W_EMISSAO),2) + "/" + STRZERO(MONTH(W_EMISSAO),2) + "/" + RIGHT(STRZERO(YEAR(W_EMISSAO),4),2)
		@ LI,191 PSAY _QRYSB6_SD2->B6_SALDO  PICTURE "@E 999,999"
		@ LI,200 PSAY _QRYSB6_SD2->D2_PRUNIT PICTURE "@E 99,999.99"

        W_TOTAL    := 0
        W_DIFPRECO := .T.

		IF _QRYSB6_SD2->D2_PRCVEN <> _QRYSB6_SD2->D2_PRUNIT // O PRECO JA ESTA COM DESCONTO
		   W_TOTAL := (_QRYSB6_SD2->D2_PRCVEN * _QRYSB6_SD2->B6_SALDO )
	       W_DIFPRECO := .T.
		 ELSE // DANIEL PEDIU PARA APLICAR O DESCONTO
		   W_TOTAL := ((_QRYSB6_SD2->D2_PRCVEN * WDESCONTO)/100) * _QRYSB6_SD2->B6_SALDO
	       W_DIFPRECO := .F.
		ENDIF
		@ LI,211 PSAY TRANSFORM(W_TOTAL, "@E 99,999.99") + IIF( W_DIFPRECO, "", "*")

		WT_ANALITICO += _QRYSB6_SD2->B6_SALDO // SONIA - 08/04/14
		WT_VALOR     += W_TOTAL               // SONIA - 08/04/14

		LI += 1

		If Li > 51 //.And. !TRB->(Eof())
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Endif

		W_SALDO += _QRYSB6_SD2->B6_SALDO
		W_QITEM += 1 // SONIA - 17/03/14 - VERIFICA A QUANTIDADE DE ITEM

		/////////////////////////////////////////////////////////////////////////
		/// SONIA - 17/03/14 - GRAVAR AS INFORMACOES PARA O ARQUIVO EXCELL     //
		/////////////////////////////////////////////////////////////////////////

		U_GRV_NHDL(_QRYSB6_SD2->B6_DOC, _QRYSB6_SD2->B6_LOCAL, ;
		 ( STRZERO(DAY(W_EMISSAO),2) + "/" + STRZERO(MONTH(W_EMISSAO),2) + "/" + RIGHT(STRZERO(YEAR(W_EMISSAO),4),2) ), ;
		 STR(_QRYSB6_SD2->B6_SALDO), STR(_QRYSB6_SD2->D2_PRUNIT), ;
		 STR( W_TOTAL ) , ;
		 SPACE(1), ;
		 WPRIM_ITEM, nQtdPen  ) // SONIA - 17/03/14

		WPRIM_ITEM := .F.      // SONIA - 21/03/14 - SE FOR O PRIMEIRO ITEM GRAVA AS LINHAS COM OS VALORES

		_QRYSB6_SD2->(DBSKIP())

	ENDDO

ENDIF  // IF _QRYSB6_SD2->(EOF())  // SE NAO TIVER O SB6 / SD2, GRAVA O ARQUIVO EM EXCELL

IF W_QITEM > 1 .OR. W_SALDO <> NQTDPEN

    IF W_QITEM > 1
    	@ LI,191 PSAY W_SALDO PICTURE "@E 999,999"
	   LI += 1
    ENDIF

    U_GRV_NHDL(SPACE(1), SPACE(1), "TOTAL", STR(W_SALDO), "0", "0", IIF(W_SALDO <> NQTDPEN, "DIF", ""), .F., nQtdPen ) // SONIA - 17/03/14

ENDIF

_QRYSB6_SD2->( DbCloseArea() )
RETURN()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USER FUNCTION GRV_NHDL(x_nota, x_local, x_emissao, x_saldo, x_preco, x_total, X_DIFERE, XPRIM_ITEM, X_QtdPen ) // sonia - 17/03/14  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    WSALDO_SB2 := POSICIONE("SB2", 1, XFILIAL("SB2") + (cAliasNew)->Z2_PRODUTO + "01", "B2_QATU")  // SK - 10/12/14
    WESGOT_SB1 := POSICIONE("SB1", 1, XFILIAL("SB1") + (cAliasNew)->Z2_PRODUTO , "B1_XESGOT") // SK - 10/12/14
    WESGOTADO  := IIF(WSALDO_SB2 <= WESGOT_SB1, "(E)", "")  // SK - 10/12/14
    WSALDO_SB2 := IIF(EMPTY(WESGOTADO), "", STR(WSALDO_SB2) ) // SK - 10/12/14
    WESGOT_SB1 := IIF(EMPTY(WESGOTADO), "", STR(WESGOT_SB1) ) // SK - 10/12/14

 	cLinFile := "<TR>"
 	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_CLIENTE)																				+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_LOJA)																				+"</TD>"+ CRLF
	cLinFile += "<TD>"+cNomeCli																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->A1_VEND)																				+"</TD>"+ CRLF
	cLinFile += "<TD>"+cNomeVend																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+WESGOTADO																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_PRODUTO)																				+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC"))									+"</TD>"+ CRLF
	cLinFile += "<TD>"+cNmAutor																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_EVENTO)												 								+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, Transform((cAliasNew)->Z2_QTDCON,"@E 9999") , "") , "")				    +"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, Transform((cAliasNew)->Z2_DEVSIMB,"@E 9999") , "") , "")				+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, Transform((cAliasNew)->Z2_DEVFIS,"@E 9999") , "") , "")				    +"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, Transform((cAliasNew)->Z2_FATCON,"@E 9999") , "") , "")				    +"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(XPRIM_ITEM, Transform(X_QTDPEN,"@E 9999"), "" )															+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, WD_AREA, "") , IIF(X_DIFERE == "DIF", "(*) DIF. sALDO", ""))			+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, Transform(WDESCONTO,"@E 9999%") , "") , "")								+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, Transform(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_PRV1"),"@E 999,999.99"), ""), "")	+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_nota																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_local																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_emissao																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_saldo),"@E 9999999")																			+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_preco),"@E 999,999.99")																		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_total),"@E 999,999.99")																		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(WSALDO_SB2),"@E 9999999")																		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(WESGOT_SB1),"@E 9999999")																		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_MUN")					+"</TD>"+ CRLF
	cLinFile += "<TD>"+Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_EST")			  		+"</TD>"+ CRLF

	/*
	*Edmar Mendes do Prado
	17/07/2019 - Solicitação da Amarylis
	
	cLinFile += "<TD>"+dTos(Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_ULTCOM"))			  		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_SALDUP"),"@E 999,999.99")				+"</TD>"+ CRLF	
	cLinFile += "<TD>"+Transform(Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_LCONSIG"),"@E 999,999.99")		  		+"</TD>"+ CRLF	
	*/
	cLinFile += "</TR>" + CRLF
	FWRITE(nHdl, cLinFile)


	/*
	FWrite( nHdl, ALLTRIM((cAliasNew)->Z2_CLIENTE) + ";" + ALLTRIM((cAliasNew)->Z2_LOJA)  + ";" + cNomeCli + ";" + ;
	ALLTRIM((cAliasNew)->A1_VEND) + ";" + cNomeVend + ";" + ;
    WESGOTADO  + ";" + ; // SK - 10/12/14
	ALLTRIM((cAliasNew)->Z2_PRODUTO) + ";" + ;
	ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")) + ";" + ;
	cNmAutor + ";" + ;
	(cAliasNew)->Z2_EVENTO + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_QTDCON) , "") , "") + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_DEVSIMB), "") , "") + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_DEVFIS ), "") , "") + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_FATCON ), "") , "") + ";" + ;
	IIF(XPRIM_ITEM, STR(X_QTDPEN), "" ) + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, WD_AREA, "") , IIF(X_DIFERE == "DIF", "(*) DIF. sALDO", "")) + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR(WDESCONTO), "") , "") + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_PRV1")), ""), "") + ";" + ;
	x_nota + ";" + ;
	x_local + ";" + ;
	x_emissao + ";" + ;
	x_saldo + ";" + ;
    x_preco + ";" + ;
	STRTRAN(x_total, ".", ",") + ";" + ;
	WSALDO_SB2  + ";" + ;  // SK - 10/12/14
	WESGOT_SB1  + ";" + ;  // SK - 10/12/14
	Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_MUN")+ ";" + ;
	Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_EST")+ ";" + ;
	CRLF ) // SONIA - 17/03/14
    */

 	cLinFile := "<TR>"
	cLinFile += "<TD>"+WESGOTADO																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_PRODUTO)																				+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC"))									+"</TD>"+ CRLF
	cLinFile += "<TD>"+cNmAutor																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_EVENTO)												 								+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", WD_AREA) , IIF(X_DIFERE == "DIF", "(*) DIF. SALDO", "")) 	+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", Transform(WDESCONTO,"@E 9999%") ) , "")					+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_nota																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_emissao																									+"</TD>"+ CRLF
	//cLinFile += "<TD>"+IIF(XPRIM_ITEM, Transform(X_QTDPEN,"@E 9999"), "" )															+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_saldo),"@E 9999999")																			+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_preco),"@E 999,999.99")																		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_MUN")					+"</TD>"+ CRLF
	cLinFile += "<TD>"+Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_EST")					+"</TD>"+ CRLF
	cLinFile += "</TR>" + CRLF
	FWRITE(nHdl_CLI, cLinFile)

	/*
	FWrite( nHdl_CLI,;
    WESGOTADO  + ";" + ; // SK - 10/12/14
	ALLTRIM((cAliasNew)->Z2_PRODUTO) + ";" + ;
	ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")) + ";" + ;
	cNmAutor + ";" + ;
	(cAliasNew)->Z2_EVENTO + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", WD_AREA) , IIF(X_DIFERE == "DIF", "(*) DIF. SALDO", "")) + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", STR(WDESCONTO) ) , "") + ";" + ;
	x_nota + ";" + ;
	x_emissao + ";" + ;
	x_saldo + ";" + ;
    STRTRAN(x_preco,".", ",") + ";" + ;
	Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_MUN")+ ";" + ;
	Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_EST")+ ";" + ;
	CRLF ) // SONIA - 17/03/14
    */

//// SK - 10/12/14 - GRAVAR EM TODAS AS LINHAS
///	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, WD_AREA, "") , IIF(X_DIFERE == "DIF", "(*) DIF. SALDO", "")) + ";" + ;
///	IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR(WDESCONTO), "") , "") + ";" + ;
/////

RETURN()