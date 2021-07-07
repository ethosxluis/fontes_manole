#include "totvs.ch"
#include "protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410STTS   บAutor  ณEdmar Mendes Prado  บ Data ณ  28/08/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada no Pedido de Vendas para bloquear quando   บฑฑ
ฑฑบ          ณhouver itens com valores negativos - Integra็ใo Vtex		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณManole                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function M410STTS()

Local aArea    := GetArea()
Local aAreaSC6 := SC6->( GetArea() )
Local aAreaSA1 := SA1->( GetArea() )
Local lDiverg 	:= .F.
Local lCliExt	:= .F.
Local cErItNgL	:= "ecommerce@manole.com.br;lazaro@manole.com.br;financeiro.cr@manole.com.br;cobrancas@manole.com.br"
Local cErAudit  := "wallace.pereira@ethosx.com"
Local cMailSta  := Alltrim(Lower(SC5->C5_XEMAIL))

If Inclui .or. Altera

	//Verifica se o cliente ้ estrangeiro
	//dbselectarea("SA1")
	SA1->( dbsetorder(1) )
	SA1->( dbseek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )

	If (SA1->A1_EST = 'EX' .OR. SA1->A1_ESTADO = 'EX' .OR. SA1->A1_COD_MUN = '99999') .And. (SA1->A1_TIPO = 'F' .Or. SA1->A1_PAIS = '105' )  
		lCliExt := .T.
	EndIf


	SC6->( dbSetOrder(1) )
	SC6->( dbSeek( SC5->C5_FILIAL + SC5->C5_NUM, .T.) )
	while ! SC6->( EOF() ) .and. SC6->C6_FILIAL == SC5->C5_FILIAL .and. SC6->C6_NUM == SC5->C5_NUM .AND. !SC5->C5_TIPO $ 'C,I,P' 
			
		If SC6->C6_PRCVEN < 0 .OR. SC6->C6_VALOR < 0 .OR. SC6->C6_PRUNIT < 0
			lDiverg := .T.
		EndIf
		
		If lCliExt .And. !(Substr(SC6->C6_CF,1,1) $ '7') 
			//Se o item nใo estiver com CFOP de exporta็ใo, bloqueia o pedido
			RecLock("SC5", .F.)
				SC5->C5_BLQ := "1"
			MsUnlock()

			Conout("** M410STTS-001 - Enviando e-mail de Pedido CFOP " + DtoC(Date()) + " - " + Time() + " **")
			U_EXPMAIL(cErItNgL , "VERIFIQUE CADASTRO DE CLIENTE E CFOP DO PEDIDO: " + SC5->C5_NUM, " Corrija cadastro de cliente " + SA1->A1_COD + " e CFOP dos itens para ser faturado corretamente. ")
			U_EXPMAIL(cErAudit , "VERIFIQUE CADASTRO DE CLIENTE E CFOP DO PEDIDO: " + SC5->C5_NUM, " Corrija cadastro de cliente " + SA1->A1_COD + " e CFOP dos itens para ser faturado corretamente. ")		

		EndIf

		SC6->( dbSkip() )	
		
	End
	
	If lDiverg
		//Se algum dos itens estiver com o valor negativo, bloqueia o pedido
		RecLock("SC5", .F.)
			SC5->C5_BLQ := "1"
		MsUnlock()
			
		Conout("** M410STTS-002 - Enviando e-mail de Pedido Bloqueado " + DtoC(Date()) + " - " + Time() + " **")
		U_EXPMAIL(cErItNgL , "PEDIDO BLOQUEADO POR ITENS COM VALORES NEGATIVOS, CORRIJA: " + SC5->C5_NUM, " Altere os itens do pedido " + SC5->C5_NUM + " conforme a Vtex para ser faturado com os valores corretos. ")
		U_EXPMAIL(cErAudit , "PEDIDO BLOQUEADO POR ITENS COM VALORES NEGATIVOS, CORRIJA: " + SC5->C5_NUM, " Altere os itens do pedido " + SC5->C5_NUM + " conforme a Vtex para ser faturado com os valores corretos. ")		
		
	EndIf

	//Valido para pedidos B2B
	//Se o campo de email do pedido de vendas estiver preenchido, atualizarแ status do pedido e enviara email	
	If Inclui .And. ! Empty(SC5->C5_XEMAIL) 

		/*
		INC - Pedido Incluido
		SEP - Pedido Separado
		FAT - Pedido Faturado
		EMB - Pedido Embarcado
		*/

		RecLock("SC5", .F.)
			SC5->C5_XSTATUS := "INC"
		MsUnlock()
	
		Conout("** M410STTS-002 - Enviando e-mail status de Pedido" + DtoC(Date()) + " - " + Time() + " **")
		//U_EXPMAIL(cMailSta , "MANOLE - Pedido Incluido: " + SC5->C5_NUM, " Seu pedido foi incluido no sistema sob n๚mero " + SC5->C5_NUM + " conforme negocia็ใo acordada. ")		
	
		cHtml := u_StatPed(SC5->C5_NUM)
		EnviaEmail(cHtml,cMailSta)
		
	EndIf
	
EndIf				
				
SC6->( RestArea( aAreaSC6 ) )
RestArea( aArea )
Return nil




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณFun…o    ณ Enviaemail  ณ Autor ณ FONTANELLI            ณ Data ณ13/10/2010ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณRelacao de Consignacao - Utilizando tabela totalizadora        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                    ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Enviaemail(cHTML,cEmail)

Local lOk			:= .F.
Local cError
Local cMailConta	:= "acertos@manole.com.br"				//Alltrim(GetMv("MN_CSGCONT"))
Local cMailSenha	:= "@c3rt05!+" 							//Alltrim(GetMv("MN_CSGSENH"))
Local cMailServer	:= "smtp.gmail.com:587"					//Alltrim(GetMv("MN_CSGSERV"))
local nRelTime 	    := 300									//GetMv("MN_CSGTIME")	//300	
Local lSSL	        := .T.									//GetMv("MN_CSGSSL")	//.T. 
Local lTLS	        := .T.									//GetMv("MN_CSGTLS")	//.T. 
Local lAutentica    := .T.									//GetMv("MN_CSGAUTH")	//.T. 
Local cAssunto	    := "Pedido de Venda Manole"
Local cTo           := cEmail
Local cCC           := ""
Local cTexto        := cHTML

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
				ALERT("Falha na Autentica็ใo do Usuแrio")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					ALERT("Erro na Desconexใo: "+cError)
				ENDIF
				Return .F.
			EndIf
		EndIf
		//
		SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cTexto ATTACHMENT RESULT lSendOk
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

