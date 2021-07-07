#Include 'Protheus.ch'
/*
{Protheus.doc} FSENVMAIL()
Envia email
@Author     Fernando Carvalho
@Since      16/08/2017
@Version    P12.7
@Project    Portal Protheus
@Param		 cAssunto
@Param		 cBody
@Param		 cEmail
*/
User Function FSENVMAIL(cAssunto, cBody, cEmail,cAttach,cMailConta,cUsuario,cMailServer,cMailSenha,lMailAuth,lUseSSL,lUseTLS,cCopia,cCopiaOculta)
	
	Local nMailPort		:= 0
	Local nAt			:= ""
	Local lRet 			:= .T.
	Local oServer		:= TMailManager():New()
	Local aAttach		:= {}
	Local nLoop			:= 0
	
	Default cAttach		:= ''
	Default cMailConta	:= SuperGetMV("MV_RELACNT")
	Default cUsuario	:= SubStr(cMailConta,1,At("@",cMailConta)-1)
	Default cMailServer	:= AllTrim(SuperGetMv("MV_RELSERV"))
	Default cMailSenha	:= SuperGetMV("MV_RELPSW")
	Default lMailAuth	:= SuperGetMV("MV_RELAUTH",,.F.)
	Default lUseSSL		:= SuperGetMV("MV_RELSSL",,.F.)
	Default lUseTLS		:= SuperGetMV("MV_RELTLS",,.F.)
	Default cCopia		:= ''
	Default cAttach2    := ''
	nAt			:= At(":",cMailServer)
	
	oServer:SetUseSSL(lUseSSL)
	oServer:SetUseTLS(lUseTLS)
	
	
	// Tratamento para usar a porta quando informada no mailserver
	If nAt > 0
		nMailPort	:= VAL(SUBSTR(ALLTRIM(cMailServer),At(":",cMailServer) + 1,Len(ALLTRIM(cMailServer)) - nAt))
		cMailServer	:= SUBSTR(ALLTRIM(cMailServer),1,At(":",cMailServer)-1)
		oServer:Init("", cMailServer, cMailConta, cMailSenha,0,nMailPort)
	Else
		oServer:Init("", cMailServer, cMailConta, cMailSenha,0,nMailPort)
	EndIf
	
	If oServer:SMTPConnect() != 0
		lRet := .F.
	EndIf
	
	If lRet
		If lMailAuth
			
			//Tentar com conta e senha
			If oServer:SMTPAuth(cMailConta, cMailSenha) != 0
				
				//Tentar com usuário e senha
				If oServer:SMTPAuth(cUsuario, cMailSenha) != 0
					lRet := .F.
				EndIf
				
			EndIf
			
		EndIf
	EndIf
	
	If lRet
		
		oMessage				:= TMailMessage():New()
		
		oMessage:Clear()
		oMessage:cFrom		:= cMailConta
		oMessage:cTo			:= cEmail
		oMessage:cCc			:= cCopia
		oMessage:cBCC			:= cCopiaOculta
		oMessage:cSubject		:= cAssunto
		oMessage:cBody			:= cBody
		
		oMessage:MsgBodyType( "text/html" )
		
//		cAttach := {}
//		aadd(cAttach,('\workflow\00084096845.pdf'))
//		aAttach	:= StrTokArr(cAttach, ';')
		
//		For nLoop := 1 To Len(aAttach)
//			oMessage:AttachFile( cAttach[nLoop] )
//			oMessage:AttachFile( cAttach[1] )
			oMessage:AttachFile( cAttach )
//		Next
		
		
		//Envia o e-mail
		
		If !(oMessage:Send( oServer ) == 0)
			lRet := .F.
		EndIf
		
	EndIf
	 
	//Desconecta do servidor
	oServer:SMTPDisconnect()
	
Return lRet
/*
user Function tstEnvEmail()

Local cAssunto 	:= 'teste'
	local cBody		:= 'teste no corpo'
	Local cEmail 	:= "fernando.santos@ethosx.com"
	Local cAttach	:= ''
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
	 
	If u_FSENVMAIL(cAssunto, cBody, cEmail,cAttach)
		ConOut("Enviou com sucesso")
	Else
		ConOut("NÃO Enviou com sucesso")
	Endif
Return
