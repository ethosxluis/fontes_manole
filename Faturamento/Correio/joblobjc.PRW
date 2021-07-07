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
±±ºPrograma  ³ JOBLOBJC º Autor ³FONTANELLI          º Data ³  14/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia lembrete caso o limite de objetos do correio seja    º±±
±±º          ³ aringido MENOR QUE 1000                                    º±±
±±º          ³      											          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// U_JOBLOBJC()

USER FUNCTION JOBLOBJC()
Local aTables := {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","SC5","SC6","UA3","UA4","UA5"}
Local cObjSolicitar := ""
RpcSetType(3)
RpcSetEnv( "01","01",,, "CTB", "SCHEDULE DE INTEGRAÇÃO COM VTEX", aTables, , , ,  )
if GetMv("XM_CORREIO")

	conout("<--- INICIADO JOB LEMBRETE OBJETO DO CORREIO " + DtoC(Date()) + " - " + Time() + " --->")

	Prepare Environment Empresa "01" Filial "01"

	cQuery:= " SELECT UA5_TRANSP, "+CHR(13)+CHR(10)
	cQuery+= "        ( SELECT A4_NOME FROM "+RetSqlName("SA4")+" WHERE A4_FILIAL = '"+xFilial("SA4")+"' AND A4_COD = UA5_TRANSP AND D_E_L_E_T_ = '' ) NOME, "+CHR(13)+CHR(10)
	cQuery+= "        QTDOBJ "+CHR(13)+CHR(10)
	cQuery+= "   FROM ( "+CHR(13)+CHR(10)
	cQuery+= "          SELECT UA5_TRANSP, COUNT(*) QTDOBJ FROM "+RetSqlName("UA5")+" "+CHR(13)+CHR(10)
	cQuery+= "           WHERE UA5_FILIAL = '"+xFilial("UA5")+"' "+CHR(13)+CHR(10)
	cQuery+= "             AND UA5_NF = '' "+CHR(13)+CHR(10)
	cQuery+= "             AND D_E_L_E_T_ = '' "+CHR(13)+CHR(10)
	cQuery+= "           GROUP BY UA5_TRANSP  "+CHR(13)+CHR(10)
	cQuery+= "        ) "+CHR(13)+CHR(10)
	cQuery+= "  WHERE QTDOBJ < "+ALLTRIM(STR(GetMv("XM_CORLIMI")))+" "+CHR(13)+CHR(10)
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
	DbSelectArea("TRB")
	TRB->(DbGoTop())
	While TRB->(!EOF())
		cObjSolicitar := cObjSolicitar + "Objeto: "+ALLTRIM(TRB->NOME)+" Disponivel: "+ALLTRIM(TRANSFORM(TRB->QTDOBJ, "@E 99999999"))+CHR(13)+CHR(10)
		TRB->(Dbskip())
	ENDDO
	TRB->(dbCloseArea())

	if !EMPTY(cObjSolicitar)
		cEmail:=GetMv("XM_CORMAIL")
		cHTML:= GERAHTML(cObjSolicitar)
		EnviaEmail(cHTML,cEmail)
	endif

   conout("<--- FINALIZADO JOB LEMBRETE OBJETO DO CORREIO " + DtoC(Date()) + " - " + Time() + " --->")

endif
RpcClearEnv()
Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia e-mail								  |
//³																				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static function Enviaemail(cHTML,cEmail)

Local lOk			:= .F.
Local cError

/* Inicio - 18/04/2018 - Edmar Mendes Prado 
//Local cMailConta	:= GETMV("MV_RELACNT")  //Conta utilizada p/envio do email
//Local cMailSenha	:= GETMV("MV_RELPSW") //Password
Local cMailConta	:= "acertos@sistemadeinformacaomanole.com.br"
Local cMailSenha	:= "FwyW83xQ"
Local cMailServer	:= GETMV("MV_RELSERV")  // mail.exchangecorp.com.br:587
local nRelTime 	    := GetMv('MV_RELTIME', , 120 )
Local lSSL	        := GETMV("MV_RELSSL") // .F.
Local lTLS	        := GETMV("MV_RELTLS") // .T.
Local lAutentica    := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
Fim - 18/04/2018 - Edmar Mendes Prado 
*/

Local cMailConta	:= "acertos@manole.com.br"				//Alltrim(GetMv("MN_CSGCONT"))
Local cMailSenha	:= "@c3rt05!+" 							//Alltrim(GetMv("MN_CSGSENH"))
Local cMailServer	:= "smtp.gmail.com:587"					//Alltrim(GetMv("MN_CSGSERV"))
local nRelTime 	    := 300									//GetMv("MN_CSGTIME")	//300	
Local lSSL	        := .T.									//GetMv("MN_CSGSSL")	//.T. 
Local lTLS	        := .T.									//GetMv("MN_CSGTLS")	//.T. 
Local lAutentica    := .T.									//GetMv("MN_CSGAUTH")	//.T. 


Local cAssunto	    := "Lembrete de solicitação de numeração para o correio."
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
	IF LSSL .AND. LTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime SSL TLS RESULT lOk
	ELSEIF LSSL .AND. !LTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime SSL RESULT lOk
	ELSEIF !LSSL .AND. LTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime TLS RESULT lOk
	ELSEIF !LSSL .AND. !LTLS
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
STATIC FUNCTION GERAHTML(cObjSolicitar)

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
chtml1+=" 	Prezado(a), Solicitar uma nova numeração para o(s) objeto(s) mencionado(s)."
chtml1+="     <br><br>
chtml1+=cObjSolicitar+" "
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