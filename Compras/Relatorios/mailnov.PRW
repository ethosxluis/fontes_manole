#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MAILNOV³ Autor ³ FONTANELLI                 ³ Data ³25/08/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ eMAIL DE NOVIDADES DE PRODUTOS                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//  u_MAILNOV()

User Function MAILNOV()

Private cPerg    := "MAILNOV"
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
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
	DbSelectArea("TMP")
	NQTD := TMP->QTD
	TMP->( DbCloseArea() )

	If msgyesno("Confirma Envio dos Emails de Novidades ?")
		Processa( {|| MAILNOVa(NQTD) } )
	endif

endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MAILNOVa³ Autor ³ FONTANELLI                ³ Data ³25/08/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ eMAIL DE NOVIDADES DE PRODUTOS                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MAILNOVa(NQTD)

cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_MAILCSG FROM " + RetSqlName("SA1") + " "
cQuery += "  WHERE A1_FILIAL = '"+ xFilial("SA1")+"' "
cQuery += "    AND A1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "'"
cQuery += "    AND A1_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "' "
cQuery += "    AND A1_MAILCSG <> ' ' "
cQuery += "    AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY A1_NOME "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
DbSelectArea("TMP")
TMP->( DbGoTop() )
ProcRegua(NQTD)
While !TMP->(EOF() )

	IncProc("Cliente: "+ALLTRIM(TMP->A1_NREDUZ))

    MAILNOVb(TMP->A1_COD, TMP->A1_LOJA, TMP->A1_NOME, TMP->A1_NREDUZ, TMP->A1_MAILCSG)

	TMP->( DbSkip() )
EndDo

TMP->( DbCloseArea() )

MSGINFO("Geração Finalizada!","Atenção")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ MAILNOVb³ Autor ³ FONTANELLI                ³ Data ³25/08/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ eMAIL DE NOVIDADES DE PRODUTOS                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MAILNOVb(xA1_COD, xA1_LOJA, xA1_NOME, xA1_NREDUZ, xA1_MAILCSG)

Local cQuery    := ""
Local ENTERL    := CHR(13)+CHR(10)

Private EnviaMail := .F.

cAliasQry := GetNextAlias()

WDIR_ARQ  := lower(ALLTRIM(MV_PAR09))
WNOM_ARQ  := lower(ALLTRIM(MV_PAR10) +"_"+xA1_COD+"_"+substr(dtoc(dDatabase),1,2)+substr(dtoc(dDatabase),4,2)+substr(dtoc(dDatabase),7,4)+ ".XLS")
WNOME_CLI := WDIR_ARQ + WNOM_ARQ
nHandle   := FCREATE(WNOME_CLI, 0)

W_CLIENTE := ": " + xA1_COD + " - " + ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_NOME"))
W_CLIENTE += ", CIDADE: "+ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_MUN"))
W_CLIENTE += "/"+ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_EST"))

If nHandle >= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ
	//³monta cabeçalho de pagina HTML para posterior utilização³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ

	cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
	cLinFile += "<TR>
	cLinFile += "<TD colspan=16 align ='center' style='Background: #FFFFC0; font-style: Bold;'><b> R E L A Ç Ã O    D E    N O V I D A D E S</b></TD>"+ CRLF
	cLinFile += "</TR>"+ CRLF
	cLinFile += "</Table>"+ CRLF
	FWRITE(nHandle, cLinFile)

	// LINHA CABECALHO
	cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"+ CRLF
	cLinFile += "<TR>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>CLIENTE</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>LOJA</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NOME CLIENTE</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>VENDEDOR</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>NOME VENDEDOR</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DATA PUBLICAÇÃO</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SEGMENTO</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>PRODUTO</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DESCRIÇÃO</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>PREÇO ATUAL</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SAÍDA CONSIGNADA</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DEVOLUÇÃO SIMBÓLICA (ACERTOS)</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>DEVOLUÇÃO FÍSICA</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SALDO CONSIGNADO ATUAL</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>TOTAL ACERTO + COMPRAS</b></TD>"+ CRLF
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>SOLICITAR CONSIGNAÇÃO</b></TD>"+ CRLF
	cLinFile += "</TR>"+ CRLF
	FWRITE(nHandle, cLinFile)

endif

cQuery:= " SELECT " +CHR(13)+CHR(10)
cQuery+= " 		 B1_XDTLANC, B1_COD, SUBSTR(B1_DESC,1,50) B1_DESC, B1_XSEGME, B1_PRV1, "+CHR(13)+CHR(10)
cQuery+= "       ( SELECT X5_DESCRI FROM "+RETSQLNAME("SX5")+" WHERE X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA = '_A' AND X5_CHAVE = B1_XSEGME AND D_E_L_E_T_  = ' ' ) X5_DESCRI,
cQuery+= "       ( "+CHR(13)+CHR(10)
cQuery+= "         SELECT NVL(SUM(B6_QUANT),0) FROM "+RETSQLNAME("SB6")+" "+CHR(13)+CHR(10)
cQuery+= "          WHERE B6_FILIAL = '"+xFilial("SB6")+"' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_CLIFOR = '"+xA1_COD+"' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_LOJA = '"+xA1_LOJA+"' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_PRODUTO = B1_COD "+CHR(13)+CHR(10)
cQuery+= "            AND B6_TIPO = 'E' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_PODER3 = 'R' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_ESTOQUE = 'S' "+CHR(13)+CHR(10)
cQuery+= "            AND D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= "        ) QTER_REQ, "+CHR(13)+CHR(10)
cQuery+= "        ( "+CHR(13)+CHR(10)
cQuery+= "          SELECT NVL(SUM(B6_QUANT),0) FROM "+RETSQLNAME("SB6")+" "+CHR(13)+CHR(10)
cQuery+= "           WHERE B6_FILIAL = '"+xFilial("SB6")+"' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_CLIFOR = '"+xA1_COD+"' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_LOJA = '"+xA1_LOJA+"' "+CHR(13)+CHR(10)
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
cQuery+= "            AND B6_CLIFOR = '"+xA1_COD+"' "+CHR(13)+CHR(10)
cQuery+= "            AND B6_LOJA = '"+xA1_LOJA+"' "+CHR(13)+CHR(10)
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
cQuery+= "              AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "+CHR(13)+CHR(10)
cQuery+= "              AND D2_CLIENTE = '"+xA1_COD+"' "+CHR(13)+CHR(10)
cQuery+= "              AND D2_LOJA = '"+xA1_LOJA+"' "+CHR(13)+CHR(10)
cQuery+= "              AND D2_COD = B1_COD "+CHR(13)+CHR(10)
cQuery+= "              AND D2_TES IN ( SELECT F4_CODIGO FROM "+RETSQLNAME("SF4")+" WHERE F4_FILIAL = '"+xFilial("SF4")+"' AND F4_DUPLIC = 'S' AND F4_PODER3 = 'N' AND D_E_L_E_T_ = ' ' )"+CHR(13)+CHR(10)
cQuery+= "              AND D_E_L_E_T_ = ' '  "+CHR(13)+CHR(10)
cQuery+= "         ) VENDA "+CHR(13)+CHR(10)
cQuery+= "   FROM "+RETSQLNAME("SB1")+" "+CHR(13)+CHR(10)
cQuery+= "  WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_XDTLANC BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "+CHR(13)+CHR(10)
cQuery+= "    AND D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= " ORDER BY B1_XDTLANC, B1_XSEGME, B1_COD "+CHR(13)+CHR(10)
//cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.F.,.F.)
TcSetField(cAliasQry,"B1_XDTLANC","D")
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())
While (cAliasQry)->(!EOF())

	EnviaMail := .T.

	xCliente  := xA1_COD
	xLoja     := xA1_LOJA
	xNomeClie := ""
	xVendedor := ""
	xNomeVend := ""
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

 	cLinFile := "<TR>"
	cLinFile += "<TD>"+xCliente																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+xLoja																										+"</TD>"+ CRLF
	cLinFile += "<TD>"+xNomeClie																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+xVendedor																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+xNomeVend																									+"</TD>"+ CRLF
	cLinFile += "<TD>"+DTOC((cAliasQry)->B1_XDTLANC) 																				+"</TD>"+ CRLF
	cLinFile += "<TD>"+(cAliasQry)->X5_DESCRI																						+"</TD>"+ CRLF
	cLinFile += "<TD>"+(cAliasQry)->B1_COD	 																						+"</TD>"+ CRLF
	cLinFile += "<TD>"+(cAliasQry)->B1_DESC 																						+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(((cAliasQry)->B1_PRV1),"@E 999,999.99") 															+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(((cAliasQry)->QTER_REQ),"@E 9999999")																+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(((cAliasQry)->QTER_DEV_SIMB),"@E 9999999")															+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(((cAliasQry)->QTER_DEV_FIS),"@E 9999999")															+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(((cAliasQry)->QTER_REQ - ((cAliasQry)->QTER_DEV_SIMB + (cAliasQry)->QTER_DEV_FIS)),"@E 9999999")	+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(((cAliasQry)->VENDA),"@E 9999999")	 																+"</TD>"+ CRLF
	cLinFile += "<TD>"
	cLinFile += "</TD>" + CRLF
	cLinFile += "</TR>" + CRLF

	FWRITE(nHandle, cLinFile)

	(cAliasQry)->(DbSkip())
End

(cAliasQry)->(DbCloseArea())

cLinFile := "</Table>"

FWRITE(nHandle, cLinFile)

FCLose(nHandle)

SLEEP(500)

CpyT2S(WNOME_CLI, "\system\consig\" , .T. )

SLEEP(500)

If EnviaMail
	if MV_PAR11 == 1
		//cEmail:= "marcos.fontanelli@ethosx.com"
		cEmail:= lower(alltrim(xA1_MAILCSG))+";consignacao@manole.com.br;consignacao3@manole.com.br"
	else
	   cEmail:= "consignacao@manole.com.br;consignacao3@manole.com.br"
	endif
	cHTML:= GERAHTML()
	EnviaEmail(cHTML,cEmail,WNOM_ARQ,xA1_COD)
endif

Return


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

/*/Inicio - 18/04/2018 - Edmar Mendes Prado 
//Local cMailConta	:= GETMV("MV_RELACNT")  //Conta utilizada p/envio do email
//Local cMailSenha	:= GETMV("MV_RELPSW") //Password
Local cMailConta	:= "acertos@sistemadeinformacaomanole.com.br"
Local cMailSenha	:= "FwyW83xQ"
Local cMailServer	:= GETMV("MV_RELSERV")  //Server
local nRelTime 	    := GetMv('MV_RELTIME', , 120 )
Local lSSL	        := GETMV("MV_RELSSL")
Local lTLS	        := GETMV("MV_RELTLS")
Local lAutentica    := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
//Fim - 18/04/2018 - Edmar Mendes Prado
*/

Local cMailConta	:= "acertos@manole.com.br"				//Alltrim(GetMv("MN_CSGCONT"))
Local cMailSenha	:= "@c3rt05!+" 							//Alltrim(GetMv("MN_CSGSENH"))
Local cMailServer	:= "smtp.gmail.com:587"					//Alltrim(GetMv("MN_CSGSERV"))
local nRelTime 	    := 300									//GetMv("MN_CSGTIME")	//300	
Local lSSL	        := .T.									//GetMv("MN_CSGSSL")	//.T. 
Local lTLS	        := .T.									//GetMv("MN_CSGTLS")	//.T. 
Local lAutentica    := .T.									//GetMv("MN_CSGAUTH")	//.T. 

Local cAssunto	    := "Relação de Novidades, "+ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + xA1_COD, "A1_NREDUZ"))
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
				//MSGINFO("Falha na Autenticação do Usuário","Atenção")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					//MSGINFO("Erro na Desconexão: "+cError',"Atenção")
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
			//Aviso("1-Erro no envio do e-Mail",cError,{"Fechar"},2)
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		//Aviso("2-Erro no envio do e-Mail",cError,{"Fechar"},2)
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
chtml1+="       NOVIDADES</font></td>
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
chtml1+=" Segue em anexo a relação de novidades movimentas até o momento.."
chtml1+=" 	<br><br>

chtml1+=" Vale lembrar o uso dos filtros por segmento coluna (G) caso necessário."
chtml1+=" 	<br><br> "
chtml1+=" A coluna (O), refere-se à soma dos acertos mais as compras diretas."
chtml1+=" 	<br><br> "
chtml1+=" A coluna (P), é o campo onde pode montar o pedido das novidades, atentando para os livros que não possui consignado ou com baixo estoque consignado coluna (N)."
chtml1+=" 	<br><br> "
chtml1+=" Qualquer dúvida, gentileza retornar nos e-mails abaixo."
chtml1+=" Aguardamos o seu pedido!"
chtml1+=" 	<br><br> "
chtml1+=" OBSERVAÇÃO: Enviar solicitação no eMail consignacao@manole.com.br consignacao3@manole.com.br ou atendimento@manole.com.br"
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
PutSx1(cPerg, '01', 'Cliente de      ?', 'Cliente de     ?', 'Cliente de     ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par01', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '02', 'Loja de         ?', 'Loja de        ?', 'Loja de        ?', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, '03', 'Cliente ate     ?', 'Cliente ate    ?', 'Cliente ate    ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '04', 'Loja Ate        ?', 'Loja ate       ?', 'Loja ate       ?', 'mv_ch4', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, "05", "Produto de      ?","Produto de      ?","Produto de      ?" ,"mv_ch5", "C", 30,0, 0, "G", "", "SB1", "", "", "MV_PAR05", '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, "06", "Produto ate     ?","Produto ate     ?","Produto ate     ?" ,"mv_ch6", "C", 30,0, 0, "G", "", "SB1", "", "", "MV_PAR06", '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, '07', 'Lancamento de   ?', 'Lancamento de  ?', 'Lancamento de  ?', 'mv_ch7', 'D',08, 0, 0, 'G', '', ''   , '', '', 'mv_par07', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '08', 'Lancamento ate  ?', 'Lancamento ate ?', 'Lancamento ate ?', 'mv_ch8', 'D',08, 0, 0, 'G', '', ''   , '', '', 'mv_par08', '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, '09', 'Pasta arquivo Excel ?', 'Pasta arquivo Excel    ?', 'Pasta arquivo Excel   ?', 'mv_ch9', 'C',50, 0, 0, 'G', '', ''   , '', '', 'mv_par09', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '10', 'Nome arquivo Excel  ?', 'Nome arquivo Excel     ?', 'Nome arquivo Excel    ?', 'mv_cha', 'C',20, 0, 0, 'G', '', ''   , '', '', 'mv_par10', '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, '11','Envia para o Cliente ?','Envia para o Cliente ?','Envia para o Cliente ?', 'mv_chb', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par11',	 'Sim','Sim','Sim', '', 'Nao','Nao','Nao','','','','','','','','','','')

Return






























