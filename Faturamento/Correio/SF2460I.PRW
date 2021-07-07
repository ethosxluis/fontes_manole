#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SF2460I  บAutor  ณFONTANELLI          บ Data ณ  09/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada                                           บฑฑ
ฑฑบ          ณ inclusao da Nota Fiscal (Origem MATA460 Nota Fiscal)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SF2460I()

LOCAL aArea		:= GetArea()

LOCAL _cFilial  := SF2->F2_FILIAL
LOCAL _cNota    := SF2->F2_DOC
LOCAL _cSerie   := SF2->F2_SERIE
LOCAL _cCliente := SF2->F2_CLIENTE
LOCAL _cLoja    := SF2->F2_LOJA

if GetMv("XM_CORREIO") .AND. alltrim(_cSerie) <> "A"

	DbSelectArea("SD2")
	DbsetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->(DbGotop())
	If DbSeek(_cFilial+_cNota+_cSerie+_cCliente+_cLoja)
		
		aPEDIDOS := {}
		While SD2->(!EOF()) .AND. SD2->D2_FILIAL == _cFilial .AND. SD2->D2_DOC == _cNota .AND. SD2->D2_SERIE == _cSerie .AND. SD2->D2_CLIENTE == _cCliente .AND. SD2->D2_LOJA == _cLoja
			
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
			If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				
				cTRANSP := SC5->C5_TRANSP	

				nPosPEDIDO := aScan(aPEDIDOS, {|x| Alltrim(x[1]) == SD2->D2_PEDIDO})
				If nPosPEDIDO == 0
					aAdd(aPEDIDOS,{SD2->D2_PEDIDO})
				endif
				
			endif
			
			SD2->(DbSkip())
		Enddo
		
		DbSelectArea("UA4")
		UA4->(DbSetOrder(1)) 
		If UA4->(DbSeek(xFilial("UA4")+cTRANSP))
			if LEN(aPEDIDOS) > 0
				cQuery := " SELECT UA5_OBJETO FROM "+RetSqlName("UA5")+" "+CHR(13)+CHR(10)
		 		cQuery += "  WHERE UA5_FILIAL = '"+xFilial("UA5")+"' "+CHR(13)+CHR(10)
		 		cQuery += "    AND UA5_TRANSP = '"+cTRANSP+"' "+CHR(13)+CHR(10)
		 		cQuery += "    AND UA5_NF = ' ' "+CHR(13)+CHR(10)
		 		cQuery += "    AND ROWNUM = 1 "+CHR(13)+CHR(10)
		 		cQuery += "    AND D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
		 		cQuery += " ORDER BY UA5_FILIAL, UA5_DATA, UA5_TRANSP, UA5_TIPO, UA5_OBJETO "+CHR(13)+CHR(10)
				cQuery:= ChangeQuery(cQuery)
				DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPOBJ",.F.,.F.)
				DbSelectArea("TMPOBJ")
				TMPOBJ->(DbGoTop())   
				cNumObjeto := TMPOBJ->UA5_OBJETO
				TMPOBJ->(dbCloseArea())
			    
				dbSelectArea("UA5")
				dbSetOrder(3) // UA5_FILIAL+UA5_OBJETO
				If dbSeek(xFilial("UA5")+cNumObjeto,.T.)
					RecLock("UA5",.F.)
					UA5->UA5_NF    := _cNota
					UA5->UA5_SERIE := _cSerie
					MsUnLock()
				endif	
		
				For xC := 1 to LEN(aPEDIDOS)
					DbSelectArea("SC5")
					DbsetOrder(1) // C5_FILIAL+C5_NUM
					SC5->(DbGotop())
					If DbSeek(xFilial("SC5")+aPEDIDOS[xC][1])
						RecLock("SC5",.f.)
						SC5->C5_OBJETO := cNumObjeto
						MsUnLock()
					endif
				Next xC
			endif
		EndIf
		
		//Solicita็ใo do Alexandre (Logistica) para que os pedidos da nova modalidade de Frete saiam no relatorio de Frete Diario
		If cTRANSP == "300"
		
			If LEN(aPEDIDOS) > 0
				For xC := 1 to LEN(aPEDIDOS)
					DbSelectArea("SC5")
					DbsetOrder(1) // C5_FILIAL+C5_NUM
					SC5->(DbGotop())					
					If DbSeek(xFilial("SC5")+aPEDIDOS[xC][1])
						RecLock("SC5",.f.)
							SC5->C5_OBJETO := "SEM CODIGO"
						MsUnLock()
					endif
				Next xC
			EndIf
					
		Endif
	
		//Valido para pedidos B2B
		//Se o campo de email do pedido de vendas estiver preenchido, atualizarแ status do pedido e enviara email	
		If ! Empty(SC5->C5_XEMAIL)  .And. ! Empty(SC5->C5_STATUS) 
	
			/*
			INC - Pedido Incluido
			SEP - Pedido Separado
			FAT - Pedido Faturado
			EMB - Pedido Embarcado
			*/
	
			RecLock("SC5", .F.)
				SC5->C5_XSTATUS := "FAT"
			MsUnlock()
		
			Conout("** SF2460I-001 - Enviando e-mail status de Pedido Faturado" + DtoC(Date()) + " - " + Time() + " **")
		
			cHtml := u_StatPed(SC5->C5_NUM)
			EnviaEmail(cHtml,cMailSta)
			
		EndIf
				
	endif
	
endif
	
RestArea(aArea)

Return










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

