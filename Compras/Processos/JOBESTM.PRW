#Include "topconn.ch"
#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JOBESTM  º Autor ³FONTANELLI          º Data ³  14/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia lembrete caso o limite do estoque seja inferior ao   º±±
±±º          ³ campo B1_XESTAV                                            º±±
±±º          ³      											          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±'±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// U_JOBESTM()

USER FUNCTION JOBESTM()

Local cDetPed := ""

conout("<--- INICIADO JOB ESTOQUE MINIMO " + DtoC(Date()) + " - " + Time() + " --->")

Prepare Environment Empresa "01" Filial "01"

nItem := 0

cDetPed := '<table border="1" width="100%">'

cDetPed += '<tr>'
cDetPed += '<td width="25%"><b><font size="2"> <font color="#0000FF" face="Verdana">'
cDetPed += "Relação"
cDetPed += '</font> </font></b></td>'
cDetPed += '<td width="75%"><font face="Verdana" size="2">'
cDetPed += "Aviso Estoque Mínimo"
cDetPed += '</font></td>'
cDetPed += '</tr>'

cDetPed += '<tr>'
cDetPed += '<td width="25%"><b><font size="2"> <font color="#0000FF" face="Verdana">'
cDetPed += "Emissão"
cDetPed += '</font> </font></b></td>'
cDetPed += '<td width="75%"><font face="Verdana" size="2">'
cDetPed += DTOC(dDataBase)
cDetPed += '</font></td>'
cDetPed += '</tr>'

// ITEM HTML

cDetPed += '</table>'
cDetPed += '<table border="1" width="100%">'

cDetPed += '<tr>'

//Item
cDetPed += '<td width="5%"><b><font color="#0000FF" face="Verdana" size="2">'
cDetPed += "Item"
cDetPed += '</font></b></td>'

//Produto
cDetPed += '<td width="20%"><b><font color="#0000FF" face="Verdana" size="2">'
cDetPed += "Produto"
cDetPed += '</font></b></td>'

//Descrição
cDetPed += '<td width="45%"><b><font color="#0000FF" face="Verdana" size="2">'
cDetPed += "Descrição"
cDetPed += '</font></b></td>'

//Estoque Minimo
cDetPed += '<td width="10%"><b><font color="#0000FF" face="Verdana" size="2">'
cDetPed += "Est. Min."
cDetPed += '</font></b></td>'

//Saldo Atual
cDetPed += '<td width="10%"><b><font color="#0000FF" face="Verdana" size="2">'
cDetPed += "Saldo Atual"
cDetPed += '</font></b></td>'

//Saldo Terceiro
cDetPed += '<td width="10%"><b><font color="#0000FF" face="Verdana" size="2">'
cDetPed += "Saldo Terceiro"
cDetPed += '</font></b></td>'

cDetPed +=   '</tr>'

cQuery:= "  SELECT * "+CHR(13)+CHR(10)
cQuery+= "   FROM ("+CHR(13)+CHR(10)
cQuery+= "           SELECT B1_COD, B1_DESC, B1_XESTAV, "+CHR(13)+CHR(10)
cQuery+= "                  ( SELECT NVL(MAX(B2_QATU),0) FROM "+RetSqlName("SB2")+" "+CHR(13)+CHR(10)
cQuery+= "                     WHERE B2_FILIAL = '"+xFilial("SB2")+"' "+CHR(13)+CHR(10)
cQuery+= "                       AND B2_COD = B1_COD "+CHR(13)+CHR(10)
cQuery+= "                       AND B2_LOCAL = '01' "+CHR(13)+CHR(10)
cQuery+= "                       AND D_E_L_E_T_ = ' ' ) B2_QATU,"+CHR(13)+CHR(10)
cQuery+= "                  ( SELECT NVL(SUM(B6_QUANT),0) FROM "+RetSqlName("SB6")+""+CHR(13)+CHR(10)
cQuery+= "                    WHERE B6_FILIAL = '"+xFilial("SB6")+"'"+CHR(13)+CHR(10)
cQuery+= "                      AND B6_CLIFOR = '047253'"+CHR(13)+CHR(10)
cQuery+= "                      AND B6_LOJA = '01' "+CHR(13)+CHR(10)
cQuery+= "                      AND B6_PRODUTO = B1_COD   "+CHR(13)+CHR(10)
cQuery+= "                      AND B6_TIPO = 'E' "+CHR(13)+CHR(10)
cQuery+= "                      AND B6_PODER3 = 'R'"+CHR(13)+CHR(10)
cQuery+= "                      AND B6_ESTOQUE = 'S'"+CHR(13)+CHR(10)
cQuery+= "                      AND D_E_L_E_T_ = ' ' ) "
cQuery+= "                      - "
cQuery+= "                  ( SELECT NVL(SUM(B6_QUANT),0) FROM "+RetSqlName("SB6")+""+CHR(13)+CHR(10)
cQuery+= "                    WHERE B6_FILIAL = '"+xFilial("SB6")+"'"+CHR(13)+CHR(10)
cQuery+= "                      AND B6_CLIFOR = '047253'"+CHR(13)+CHR(10)
cQuery+= "                      AND B6_LOJA = '01' "+CHR(13)+CHR(10)
cQuery+= "                      AND B6_PRODUTO = B1_COD   "+CHR(13)+CHR(10)
cQuery+= "                      AND B6_TIPO = 'E' "+CHR(13)+CHR(10)
cQuery+= "                      AND B6_PODER3 = 'D'"+CHR(13)+CHR(10)
cQuery+= "                      AND B6_ESTOQUE = 'S'"+CHR(13)+CHR(10)
cQuery+= "                      AND D_E_L_E_T_ = ' ' )
cQuery+= "                  B6_QUANT"+CHR(13)+CHR(10)
cQuery+= "            FROM "+RetSqlName("SB1")+""+CHR(13)+CHR(10)
cQuery+= "           WHERE B1_FILIAL = '"+xFilial("SB1")+"'"+CHR(13)+CHR(10)
cQuery+= "             AND B1_XTIPO = '1'"+CHR(13)+CHR(10)
cQuery+= "             AND B1_XESTAV > 0"+CHR(13)+CHR(10)
cQuery+= "             AND D_E_L_E_T_ = ' '"+CHR(13)+CHR(10)
cQuery+= "        )"+CHR(13)+CHR(10)
cQuery+= "  WHERE B2_QATU < B1_XESTAV"+CHR(13)+CHR(10)
cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
DbSelectArea("TRB")
TRB->(DbGoTop())
While TRB->(!EOF())

	cDetPed += '<tr>'

	//Item
	cDetPed += '<td width="5%"><font face="Verdana" size="1">'
	cDetPed += STRZERO(nItem++,4)
	cDetPed += '</font></td>'

	//Produto
	cDetPed += '<td width="20%"><font face="Verdana" size="1">'
	cDetPed += alltrim(TRB->B1_COD)
	cDetPed += '</font></td>'

	//Descrição
	cDetPed += '<td width="45%"><font face="Verdana" size="1">'
	cDetPed += SUBSTR(TRB->B1_DESC,1,45)
	cDetPed += '</font></td>'

	//Estoque Minimo
	cDetPed += '<td width="10%"><font face="Verdana" size="1"> <div align="right">'
	cDetPed += transform(TRB->B1_XESTAV,'@E 99999')
	cDetPed += '</div></font></td>'

	//Saldo Atual
	cDetPed += '<td width="10%"><font face="Verdana" size="1"> <div align="right">'
	cDetPed += transform(TRB->B2_QATU,'@E 99999')
	cDetPed += '</div></font></td>'

	//Saldo Terceiro
	cDetPed += '<td width="10%"><font face="Verdana" size="1"> <div align="right">'
	cDetPed += transform(TRB->B6_QUANT,'@E 99999')
	cDetPed += '</font></td>'

	cDetPed +=  '</tr>'

	TRB->(Dbskip())
ENDDO
TRB->(dbCloseArea())

cDetPed += '</table>'

if !EMPTY(cDetPed)
	cEmail:= GetMv("XM_ESTMIN")
 	cHTML:= GERAHTML(cDetPed)
	EnviaEmail(cHTML,cEmail)
endif

   conout("<--- FINALIZADO JOB ESTOQUE MINIMO "  + DtoC(Date()) + " - " + Time() + " --->")

Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia e-mail								  |
//³																				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static function Enviaemail(cHTML,cEmail)

Local lOk			:= .F.
Local cError

/*/Inicio - 18/04/2018 - Edmar Mendes Prado 
//Local cMailConta	:= GETMV("MV_RELACNT")  //Conta utilizada p/envio do email
//Local cMailSenha	:= GETMV("MV_RELPSW") //Password
Local cMailConta	:= "acertos@sistemadeinformacaomanole.com.br"
Local cMailSenha	:= "FwyW83xQ"
Local cMailServer	:= GETMV("MV_RELSERV")  // mail.exchangecorp.com.br:587
local nRelTime 	    := GetMv('MV_RELTIME', , 120 )
Local lSSL	        := GETMV("MV_RELSSL") // .F.
Local lTLS	        := GETMV("MV_RELTLS") // .T.
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

Local cAssunto	    := "Aviso Estoque Mínimo."
Local cTo           := cEmail
Local cCC           := ""
Local cTexto        := cHTML
Local cAnexo        := ""


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
				MSGINFO("Falha na Autenticação do Usuário","Atenção")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					MSGINFO("Erro na Desconexão: "+cErrorMsg,"Atenção")
				ENDIF
				Return .F.
			EndIf
		EndIf
		SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cTexto ATTACHMENT cAnexo RESULT lSendOk
		IncProc()
		IncProc()
		IncProc("Desconectando...")
		If !lSendOk
			GET MAIL ERROR cError
			Aviso("1-Erro no envio do e-Mail",cError,{"Fechar"},2)
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Aviso("2-Erro no envio do e-Mail",cError,{"Fechar"},2)
	EndIf
EndIf

If lOk
	DISCONNECT SMTP SERVER
	IncProc()
	IncProc()
	IncProc()
EndIf

Return lOk


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera HTML para constituicao do corpo de e-mail.								  |
//³																				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION GERAHTML(cDetPed)

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
chtml1+="       AVISO</font></td>
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
chtml1+=" 	Prezado(a), Relação do(s) produto(s) com saldo mínimo."
chtml1+="     <br><br>
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






