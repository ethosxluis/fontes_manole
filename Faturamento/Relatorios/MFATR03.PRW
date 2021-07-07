#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MFATR03  ³ Autor ³ FONTANELLI               ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATR03()

Private cPerg    := "MFAT03"
Private nLastKey := 0

AjustaSX1(cPerg)
if Pergunte(cPerg,.T.)

	cQuery := " SELECT COUNT(*) QTD FROM " + RetSqlName("SA1") + " "
	cQuery += "  WHERE A1_FILIAL = '"+ xFilial("SA1")+"' "
	cQuery += "    AND A1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "'"
	cQuery += "    AND A1_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "' "
	cQuery += "    AND A1_MAILCSG <> ' ' "
	cQuery += "    AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY A1_NOME "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPFOR",.T.,.T.)
	DbSelectArea("TMPFOR")
	NQTD := TMPFOR->QTD
	TMPFOR->( DbCloseArea() )

	If msgyesno("Confirma Envio dos Emails ?")
		Processa( {|| MFATR03a(NQTD) } )
	endif

endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MFATR03a ³ Autor ³ FONTANELLI               ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MFATR03a(NQTD)

cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_MAILCSG FROM " + RetSqlName("SA1") + " "
cQuery += "  WHERE A1_FILIAL = '"+ xFilial("SA1")+"' "
cQuery += "    AND A1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "'"
cQuery += "    AND A1_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "' "
cQuery += "    AND A1_MAILCSG <> ' ' "
cQuery += "    AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY A1_NOME "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPFOR",.T.,.T.)
DbSelectArea("TMPFOR")
TMPFOR->( DbGoTop() )
ProcRegua(NQTD)
While !TMPFOR->(EOF() )

	IncProc("Cliente: "+ALLTRIM(TMPFOR->A1_NREDUZ))

    MFATR03b(TMPFOR->A1_COD, TMPFOR->A1_LOJA, TMPFOR->A1_NOME, TMPFOR->A1_NREDUZ, TMPFOR->A1_MAILCSG)

	TMPFOR->( DbSkip() )
EndDo

TMPFOR->( DbCloseArea() )

MSGINFO("Geração Finalizada!","Atenção")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MFATR03b ³ Autor ³ FONTANELLI               ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MFATR03b(xA1_COD, xA1_LOJA, xA1_NOME, xA1_NREDUZ, xA1_MAILCSG)

Local cQuery    := ""
Local cChave    := ""
Local ENTERL    := CHR(13)+CHR(10)
Local nTotPen   := 0
Local nTotLiq   := 0
Local nTpArea := 0

Private aHeader := {}
Private aCols   := {}
Private N       := 1

Private cNomeCli  := ""
Private cNomeVend := ""
Private cNmAutor  := ""
Private WD_AREA   := ""
Private nQtdPen   := 0

Private EnviaMail := .F.

cAliasNew := GetNextAlias()

WDIR_ARQ  := lower(ALLTRIM(MV_PAR13))
WNOM_ARQ  := lower(ALLTRIM(MV_PAR14) +"_"+xA1_COD+"_"+substr(dtoc(dDatabase),1,2)+substr(dtoc(dDatabase),4,2)+substr(dtoc(dDatabase),7,4)+ ".CSV")
WNOME_CLI := WDIR_ARQ + WNOM_ARQ
nHandle   := FCREATE(WNOME_CLI, 0)

W_CLIENTE := ": " + xA1_COD + " - " + ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_NOME"))
W_CLIENTE += " CIDADE : "+ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_MUN"))
W_CLIENTE += "/"+ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_EST"))

If nHandle >= 0

	/*

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ
	//³monta cabeçalho de pagina HTML para posterior utilização³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ

	cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
	cLinFile += "<TR>
	cLinFile += "<TD colspan=11 align ='center' style='Background: #FFFFC0; font-style: Bold;'><b> Saldo MENSAL de Consignação</b></TD>"+ CRLF
	cLinFile += "</TR>"+ CRLF
	cLinFile += "</Table>"+ CRLF
	FWRITE(nHandle, cLinFile)

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
	cLinFile += "</TR>"+ CRLF
	FWRITE(nHandle, cLinFile)

	*/

	FWrite( nHandle, "ESGOTADO; ISBN; TITULO; AUTOR; EVENTO; AREA; DESCONTO; NF ORIGEM; NF EMISSAO; SALDO; PRECO ORIGEM" + CRLF )

endif

cQuery := " SELECT SZ2.Z2_CLIENTE, SZ2.Z2_LOJA, SZ2.Z2_PRODUTO, SZ2.Z2_EVENTO, SA1.A1_VEND, "+ ENTERL
cQuery += " SZ2.Z2_QTDCON, SZ2.Z2_DEVSIMB, SZ2.Z2_DEVFIS, SZ2.Z2_FATCON, B1_DESC "+ ENTERL

cQuery += " FROM " + RetSqlName("SZ2") + " SZ2 " +ENTERL

cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + ENTERL
cQuery += " SA1.A1_FILIAL  = '"+ xFilial("SA1")+"' AND "+ENTERL
cQuery += " SA1.A1_COD = SZ2.Z2_CLIENTE AND "+ ENTERL
cQuery += " SA1.A1_LOJA = SZ2.Z2_LOJA "+ ENTERL

cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + ENTERL
cQuery += " SB1.B1_COD = SZ2.Z2_PRODUTO AND "+ ENTERL
cQuery += " SB1.B1_FILIAL  = '"+ xFilial("SB1")+"' "+ENTERL

cQuery += " WHERE SZ2.Z2_FILIAL  = '"+ xFilial("SZ2")+"' AND "+ENTERL
cQuery += " SZ2.Z2_CLIENTE BETWEEN '" + xA1_COD + "' AND '" + xA1_COD +"' AND " + ENTERL
cQuery += " SZ2.Z2_LOJA BETWEEN '" + xA1_LOJA + "' AND '" + xA1_LOJA + "' AND " + ENTERL
cQuery += " SZ2.Z2_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "' AND " + ENTERL

If mv_par07 == 1 // Loja
	cQuery += " SZ2.Z2_EVENTO = '      ' AND " + ENTERL
ElseIf mv_par07 == 2 // Evento
	cQuery += " SZ2.Z2_EVENTO BETWEEN '" + mv_par08 + "' AND '" + mv_par09+ "' AND " + ENTERL
	cQuery += " SZ2.Z2_EVENTO <> '      ' AND " + ENTERL
EndIf
cQuery += " SA1.A1_VEND BETWEEN '" + mv_par10 + "' AND '" + mv_par11+ "' AND " + ENTERL

IF MV_PAR16 == 1 // SOMENTE CLIENTES
	cQuery += " SA1.A1_UNIDVEN <> '000001' AND " + ENTERL
ELSEIF MV_PAR16 == 2 // SOMENTE DEPOSITO EXTERNO
	cQuery += " SA1.A1_UNIDVEN = '000001' AND " + ENTERL
ENDIF

cQuery += " SZ2.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery += " SA1.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery += " SB1.D_E_L_E_T_ <> '*' " + ENTERL

IF MV_PAR15 == 1 // ORDEM POR CODIGO DO PRODUTO
	cQuery += " ORDER BY Z2_CLIENTE, Z2_LOJA, Z2_EVENTO, Z2_PRODUTO " + ENTERL
ELSE
	cQuery += " ORDER BY Z2_CLIENTE, Z2_LOJA, Z2_EVENTO, B1_DESC " + ENTERL
ENDIF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

aadd( aHeader, { "Quantidade", "D1_QUANT"})
aadd( aHeader, { "Total",      "D1_TOTAL"})
aadd( aHeader, { "Ident B6",   "D1_IDENTB6"})
aadd( aHeader, { "TES",        "D1_TES"})
aadd( aCols  , { 1, 0, SPACE(1), "001", .F.})

(cAliasNew)->(dbGoTop())

WT_PENDENTE  := 0
WT_ANALITICO := 0
WT_VALOR     := 0

DO While (cAliasNew)->(!Eof())

	// REMOVIDO FONTANELLI
	//nQtdPen := ((cAliasNew)->Z2_QTDCON - (cAliasNew)->Z2_DEVSIMB -(cAliasNew)->Z2_DEVFIS) // SONIA - 10/03/14

	// ADICIONADO FONTANELLI
    nQtdPen := U_SALDSB6((cAliasNew)->Z2_CLIENTE,(cAliasNew)->Z2_LOJA, (cAliasNew)->Z2_PRODUTO, (cAliasNew)->Z2_EVENTO )

	IF MV_PAR12 == 3 .OR.;
		( MV_PAR12 == 1 .AND. NQTDPEN <> 0 ) .OR. ;
		( MV_PAR12 == 2 .AND. NQTDPEN == 0 )

		lImp   := .T.

		If cChave <> (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA

			cNomeCli := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_NREDUZ")
			cNomeVend := Posicione("SA3",1,xFilial("SA3")+(cAliasNew)->A1_VEND,"A3_NREDUZ")
			cChave  := (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA
			nTotPen := 0
		EndIf
		cNmAutor := LEFT( Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_XNMAUT"), 25) // LIMITADO A 25
		if cNmAutor == " "
			cNmAutor := "."
		Endif

		nTpArea   := Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_XSEGME") // Segmento de desconto
		WD_AREA   := ""  // JOGO PARA VARIAVEL PARA UTILIZAR NA GERACAO DO ARQUIVO EM EXCELL
		WDESCONTO := 0   // JOGO PARA VARIAVEL PARA UTILIZAR NA GERACAO DO ARQUIVO EM EXCELL

		If  val(nTpArea) == 1
			WD_AREA   := "Medicina"
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC1")
		ElseIf val(nTpArea) == 2
			WD_AREA   := "Publico "
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC2")
		ElseIf val(nTpArea) == 03
			WD_AREA   := "Humanas "
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC3")
		Else
			WD_AREA   := "Civil   "
			WDESCONTO := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_XDESC4")
		Endif

		nTotPen += nQtdPen

		U_MIMP_SLDSB6((cAliasNew)->Z2_CLIENTE,(cAliasNew)->Z2_LOJA, (cAliasNew)->Z2_PRODUTO, nQtdPen, (cAliasNew)->Z2_EVENTO )

	ENDIF // TRATAMENTO PARA IMPRESSAO DE SALDO PENDENTE

	(cAliasNew)->(dbSkip())

EndDo

U_MGRV_NHDL(SPACE(1), SPACE(1), "TOTAL GERAL", STR(WT_ANALITICO), "0", STR(WT_VALOR), "TOT", .T., WT_PENDENTE )

// cLinFile := "</Table>"
// FWRITE(nHandle, cLinFile)

FCLose(nHandle)

SLEEP(500)

CpyT2S(WNOME_CLI, "\system\consig\" , .T. )

SLEEP(500)

(cAliasNew)->(DbCloseArea())


If EnviaMail

	//if MV_PAR17 == 1
		//cEmail:= "marcos.fontanelli@ethosx.com"
		//cEmail:= lower(alltrim(xA1_MAILCSG))+";consignacao@manole.com.br;consignacao3@manole.com.br"
	//else
	  // cEmail:= "consignacao@manole.com.br;consignacao3@manole.com.br"
	//endif

	//cEmail:= "marcos.fontanelli@ethosx.com;consignacao@manole.com.br"
	//cEmail:= "consignacao@manole.com.br"

	cEmail:= lower(alltrim(xA1_MAILCSG))+";consignacao@manole.com.br;consignacao3@manole.com.br;acertos@manole.com.br"
	cHTML:= GERAHTML()
	EnviaEmail(cHTML,cEmail,WNOM_ARQ,xA1_COD)
endif

Return

  //////////////////////////////////////////////////////////////////////////////
USER FUNCTION SALDSB6(x_cliente, x_loja, x_produto,  x_evento) // FONTANELLI
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MIMP_SLDSB6 ³ Autor ³ FONTANELLI            ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MIMP_SLDSB6(x_cliente, x_loja, x_produto, nQtdPen, x_evento) //  evento //

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
W_QITEM := 0

WT_PENDENTE += nQtdPen

IF _QRYSB6_SD2->(EOF())  // SE NAO TIVER O SB6 / SD2, GRAVA O ARQUIVO EM EXCELL

	U_MGRV_NHDL(SPACE(1), SPACE(1), SPACE(1), "0", "0", "0", SPACE(1), .T., nQtdPen ) // SONIA - 17/03/14

ELSE

	WPRIM_ITEM := .T. // SE FOR O PRIMEIRO ITEM GRAVA AS LINHAS COM OS VALORES
	DO WHILE .NOT. _QRYSB6_SD2->(EOF())
		W_EMISSAO := STOD(_QRYSB6_SD2->B6_EMISSAO)
		WDESCONTO := _QRYSB6_SD2->D2_DESC  // CONSIDERAR O DESCONTO DA NF DE ORIGEM

		W_TOTAL    := 0
		W_DIFPRECO := .T.

		IF _QRYSB6_SD2->D2_PRCVEN <> _QRYSB6_SD2->D2_PRUNIT // O PRECO JA ESTA COM DESCONTO
			W_TOTAL := (_QRYSB6_SD2->D2_PRCVEN * _QRYSB6_SD2->B6_SALDO )
			W_DIFPRECO := .T.
		ELSE // APLICAR O DESCONTO
			W_TOTAL := ((_QRYSB6_SD2->D2_PRCVEN * WDESCONTO)/100) * _QRYSB6_SD2->B6_SALDO
			W_DIFPRECO := .F.
		ENDIF

		WT_ANALITICO += _QRYSB6_SD2->B6_SALDO
		WT_VALOR     += W_TOTAL


		W_SALDO += _QRYSB6_SD2->B6_SALDO
		W_QITEM += 1 // VERIFICA A QUANTIDADE DE ITEM

		/////////////////////////////////////////////////////////////////////////
		/// GRAVAR AS INFORMACOES PARA O ARQUIVO EXCELL     //
		/////////////////////////////////////////////////////////////////////////

		U_MGRV_NHDL(_QRYSB6_SD2->B6_DOC, _QRYSB6_SD2->B6_LOCAL, ;
		( STRZERO(DAY(W_EMISSAO),2) + "/" + STRZERO(MONTH(W_EMISSAO),2) + "/" + RIGHT(STRZERO(YEAR(W_EMISSAO),4),2) ), ;
		STR(_QRYSB6_SD2->B6_SALDO), STR(_QRYSB6_SD2->D2_PRUNIT), ;
		STR( W_TOTAL ) , ;
		SPACE(1), ;
		WPRIM_ITEM, nQtdPen  )

		WPRIM_ITEM := .F. // SE FOR O PRIMEIRO ITEM GRAVA AS LINHAS COM OS VALORES

		_QRYSB6_SD2->(DBSKIP())

	ENDDO

ENDIF  // SE NAO TIVER O SB6 / SD2, GRAVA O ARQUIVO EM EXCELL

IF W_QITEM > 1 .OR. W_SALDO <> NQTDPEN

	U_MGRV_NHDL(SPACE(1), SPACE(1), "TOTAL", STR(W_SALDO), "0", "0", IIF(W_SALDO <> NQTDPEN, "DIF", ""), .F., nQtdPen ) // SONIA - 17/03/14

ENDIF

_QRYSB6_SD2->( DbCloseArea() )

RETURN()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MGRV_NHDL   ³ Autor ³ FONTANELLI            ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MGRV_NHDL(x_nota, x_local, x_emissao, x_saldo, x_preco, x_total, X_DIFERE, XPRIM_ITEM, X_QtdPen ) //

WSALDO_SB2 := POSICIONE("SB2", 1, XFILIAL("SB2") + (cAliasNew)->Z2_PRODUTO + "01", "B2_QATU")
WESGOT_SB1 := POSICIONE("SB1", 1, XFILIAL("SB1") + (cAliasNew)->Z2_PRODUTO , "B1_XESGOT")

WESGOTADO  := IIF(WSALDO_SB2 <= WESGOT_SB1, "ESGOTADO", "")
WSALDO_SB2 := IIF(EMPTY(WESGOTADO), "", STR(WSALDO_SB2) )
WESGOT_SB1 := IIF(EMPTY(WESGOTADO), "", STR(WESGOT_SB1) )

if val(x_saldo)>0

	EnviaMail := .T.

	/*
 	cLinFile := "<TR>"
	cLinFile += "<TD>"+WESGOTADO																								+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_PRODUTO)																			+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC"))								+"</TD>"+ CRLF
	cLinFile += "<TD>"+cNmAutor																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+ALLTRIM((cAliasNew)->Z2_EVENTO)												 							+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", alltrim(WD_AREA)) , IIF(X_DIFERE == "DIF", "", ""))	+"</TD>"+ CRLF
	cLinFile += "<TD>"+IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", Transform(WDESCONTO,"@E 9999%") ) , "")				+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_nota																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+x_emissao																								+"</TD>"+ CRLF
	//cLinFile += "<TD>"+IIF(XPRIM_ITEM, Transform(X_QTDPEN,"@E 9999"), "" )														+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_saldo),"@E 9999999")																		+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(VAL(x_preco),"@E 999,999.99")																	+"</TD>"+ CRLF
	cLinFile += "</TR>" + CRLF
	FWRITE(nHandle, cLinFile)
	*/

 	FWrite( nHandle,;
	WESGOTADO  + ";" + ;
	ALLTRIM((cAliasNew)->Z2_PRODUTO)+ ";" + ;
	ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")) + ";" + ;
	cNmAutor + ";" + ;
	(cAliasNew)->Z2_EVENTO + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", alltrim(WD_AREA)) , IIF(X_DIFERE == "DIF", "", "")) + ";" + ;
	IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", Transform(WDESCONTO,"@E 9999%") ) , "") + ";" + ;
	x_nota + ";" + ;
	x_emissao + ";" + ;
	x_saldo + ";" + ;
	STRTRAN(x_preco,".", ",") + ";" + ;
	CRLF )

endif

RETURN()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ Enviaemail  ³ Autor ³ FONTANELLI            ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Enviaemail(cHTML,cEmail,cArquivo,xA1_COD )

Local lOk			:= .F.
Local cError
//Inicio - 13/12/2017 - Edmar Mendes Prado 
//local nRelTime 	    := GetMv('MV_RELTIME', , 120 )
//Local lSSL	        := GETMV("MV_RELSSL") // .F.
//Local lTLS	        := GETMV("MV_RELTLS") // .T.
//Local cMailServer	:= GETMV("MV_RELSERV")  // mail.exchangecorp.com.br:587
//Local lAutentica    := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
//Local cMailConta	:= GETMV("MV_RELACNT")  //Conta utilizada p/envio do email
//Local cMailSenha	:= GETMV("MV_RELPSW") //Password
//Local cMailConta	:= "acertos@sistemadeinformacaomanole.com.br"
//Local cMailSenha	:= "FwyW83xQ"
//Fim - 13/12/2017 - Edmar Mendes Prado 

Local cMailConta	:= "acertos@manole.com.br"				//Alltrim(GetMv("MN_CSGCONT"))
Local cMailSenha	:= "@c3rt05!+" 							//Alltrim(GetMv("MN_CSGSENH"))
Local cMailServer	:= "smtp.gmail.com:587"					//Alltrim(GetMv("MN_CSGSERV"))
local nRelTime 	    := 300									//GetMv("MN_CSGTIME")	//300	
Local lSSL	        := .T.									//GetMv("MN_CSGSSL")	//.T. 
Local lTLS	        := .T.									//GetMv("MN_CSGTLS")	//.T. 
Local lAutentica    := .T.									//GetMv("MN_CSGAUTH")	//.T. 
Local cAssunto	    := "Saldo MENSAL de Consignação (MAPA), "+ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_NREDUZ"))
Local cTo           := cEmail
Local cCC           := ""
Local cTexto        := cHTML
Local cAnexo        := "\system\consig\"+cArquivo


ProcRegua(8)
IncProc()
IncProc("Conectando SERVIDOR...")

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	// Conecta uma vez com o servidor de e-mails
	IF lSSL .AND. lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime SSL TLS RESULT lOk
	ELSEIF lSSL .AND. !lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime SSL RESULT lOk
	ELSEIF !lSSL .AND. lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime TLS RESULT lOk
	ELSEIF !lSSL .AND. !lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime RESULT lOk
	ENDIF

	IncProc()
	IncProc()
	IncProc("Enviando e-mail...")

	If lOk
		If lAutentica
			If !MailAuth(cMailConta, cMailSenha )
				ALERT("Falha na Autenticação do Usuário")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					ALERT("Erro na Desconexão: "+cError)
				ENDIF
				Return .F.
			EndIf
		EndIf
		//
		SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cTexto ATTACHMENT cAnexo RESULT lSendOk
		IncProc()
		IncProc()
		IncProc("Desconectando...")
		If !lSendOk
			GET MAIL ERROR cError
			ALERT("1-Erro no envio do e-Mail",cError)
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		ALERT("2-Erro no envio do e-Mail",cError)
	EndIf
EndIf

If lOk
	DISCONNECT SMTP SERVER
	IncProc()
	IncProc()
	IncProc()
EndIf

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ GERAHTML    ³ Autor ³ FONTANELLI            ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Utilizando tabela totalizadora        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION GERAHTML()

chtml1:= ""
chtml1+=" <!doctype html>
chtml1+=" <html>
chtml1+=" <head>
chtml1+='     <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
chtml1+="     <title>[titulo]</title>
chtml1+=" </head>
chtml1+=" <body>
chtml1+='     <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
chtml1+="       <tr>
chtml1+='         <td width="287" align="center" valign="middle"><img src="https://manole.vteximg.com.br/arquivos/mano.bel.brand-links-manole.png" alt="" /></td>
chtml1+='     <td width="313" align="center" valign="middle"><font color="#191970" size="6" face="Arial">WORKFLOW<br />
chtml1+="       CONSIGNAÇÃO</font></td>
chtml1+="       </tr>
chtml1+="       <tr>
chtml1+='         <td height="22" colspan="2" align="left" bgcolor="#191970" style="padding-left:6px; padding-right:6px;"><strong><font face="Arial" size="1" color="#FFFFFF">
chtml1+= DIASEMANA(ddatabase)+", "
chtml1+= substr(dtos(ddatabase),7,2)+ " de "
chtml1+= MesExtenso(substr(dtos(ddatabase),5,2)) + " de "
chtml1+= substr(dtos(ddatabase),1,4)
chtml1+="</font></strong></td>
chtml1+="       </tr>
chtml1+="       <tr>
chtml1+='         <td colspan="2" bgcolor="#FFFFFF"><table width="600" border="0" cellspacing="5" cellpadding="5">
chtml1+="           <tr>
chtml1+=" 	<br>
chtml1+=" 	Prezado(a) Cliente: "+W_CLIENTE+", "

chtml1+=" Segue em anexo seu saldo de consignação."
chtml1+=" 	<br><br>
chtml1+=" Os acertos mensais de consignações deverão estar acompanhados da Nota Fiscal de devolução simbólica de mercadoria consignada."
chtml1+=" 	<br><br>
chtml1+=" A emissão de nota fiscal de devolução simbólica para o consignante, e a mercadoria efetivamente vendida pelo consignatário a terceiros (consumidores finais)."
chtml1+=" 	<br><br>
chtml1+=" Assim, por ocasião das vendas realizadas a terceiros, o consignatário emitirá nota fiscal de devolução simbólica:"
chtml1+=" 	<br><br>
chtml1+=" a) Natureza da operação: 'Devolução simbólica de mercadoria recebida em consignação'"
chtml1+=" 	<br><br>
chtml1+=" b) No campo 'Informações Complementares': informar a origem da nota de remessa em consignação."
chtml1+=" 	<br><br>
chtml1+=" c) CFOP 5.919 (NO ESTADO) ou 6.919 (FORA DO ESTADO), Conforme o caso. "
chtml1+=" 	<br><br>
chtml1+=" LEMBRETE: ACERTOS SEM SIMBÓLICA, NÃO SERÃO PROCESSADOS! "
chtml1+=" 	<br><br>
chtml1+=" OBSERVAÇÃO: ENVIAR ACERTOS NO E-MAIL consignacao@manole.com.br e consignacao3@manole.com.br"
chtml1+="  <br><br>
chtml1+='             <font face="Arial" size="2" color="#333333"><br>
chtml1+=" </font></td>
chtml1+="           </tr>
chtml1+="         </table></td>
chtml1+="       </tr>
chtml1+="       <tr>
chtml1+='         <td height="20" colspan="2" align="center" bgcolor="#191970" style="padding-left:6px; padding-right:6px;"><font face="Arial" size="1" color="#FFFFFF">MANOLE - '+substr(dtos(ddatabase),1,4)+' - Todos os direitos reservados</font></td>
chtml1+="       </tr>
chtml1+="     </table>
chtml1+=" </body>
chtml1+=" </html>

RETURN(chtml1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    ºData  ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para incluir os grupos de perguntas OMSC01           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)
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

PutSx1(cPerg, '16','Tipo de impressao?','Tipo de impressao?','Tipo de impressao?', 'mv_chg', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par16',	 'Clientes','Clientes','Clientes', '', 'Deposito Externo','Deposito Externo','Deposito Externo','Ambos','Ambos','Ambos','','','','','','','') // SONIA - 02/07/15

PutSx1(cPerg, '17','Envia para o Cliente ?','Envia para o Cliente ?','Envia para o Cliente ?', 'mv_chh', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par17',	 'Sim','Sim','Sim', '', 'Nao','Nao','Nao','','','','','','','','','','')

Return

