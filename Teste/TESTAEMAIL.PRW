// Teste 5

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TESTAEMAIL³ Autor ³ FONTANELLI            ³ Data ³ 10/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Testa email 123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123                                               ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ABM                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TESTAEMAIL()

cRetorno := MaTesInt(1,"12","022920","01","C","9788520435557                 ")

alert(cRetorno)

return

lConectou := .F.
lEnviado  := .F.

_cPara     := 'marcosaureliofontanelli@gmail.com'
_ccc       := 't.i@manole.com.br;'
_cAssunto  := 'u_TESTAEMAIL() -> mail.exchangecorp.com.br'
_cMensagem := '(1x)-Este email e um teste para validar o envio !'
_cAnexos   := ''

cServer   := "mail.exchangecorp.com.br:587"
lAuth     := .T.
cUser     := "acertos@sistemadeinformacaomanole.com.br"
cPass     := "FwyW83xQ"
_cFrom    := "acertos@sistemadeinformacaomanole.com.br"

lTLS      := .T.
lSSL      := .F.

alert("email-1")
IF lSSL .AND. lTLS
	CONNECT SMTP SERVER cServer ACCOUNT _cFrom PASSWORD cPass SSL TLS RESULT lConectou
ELSEIF lSSL .AND. !lTLS
	CONNECT SMTP SERVER cServer ACCOUNT _cFrom PASSWORD cPass SSL RESULT lConectou
ELSEIF !lSSL .AND. lTLS
	CONNECT SMTP SERVER cServer ACCOUNT _cFrom PASSWORD cPass TLS RESULT lConectou
ELSEIF !lSSL .AND. !lTLS
	CONNECT SMTP SERVER cServer ACCOUNT _cFrom PASSWORD cPass RESULT lConectou
ENDIF

If !lConectou

	MsgAlert ('(1x)-Nao Foi Possivel Conectar ao Servidor de E-mail , Contate o suporte')

else

	If (lAuth .and. MailAuth(cUser , cPass)) .or. !lAuth
		SEND MAIL FROM _cFrom TO _cPara CC _ccc SUBJECT _cAssunto BODY _cMensagem ATTACHMENT _cAnexos RESULT lEnviado
	Else
		Alert("Nao foi possivel se conectar ao Servidor de E-Mail...")
	EndIF

	If !lEnviado
	    GET MAIL ERROR cError
	    Aviso("Não foi...",'Erro: ' + cError,{"Ok"},3 )
	EndIf

	DISCONNECT SMTP SERVER
	/// TESSTE

endif


