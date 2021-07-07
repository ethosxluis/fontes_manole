#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MNLJOBNFEบ Autor ณEdmar Mendes Prado  บ Data ณ  19/04/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia lembrete para as notas que nใo tiveram retorno Sefaz บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Schedule na empresa 01,01. 	  Nome: MNLJOBNFE - U_MNLJOBNFE("01","01")บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MNLNFE()

//Local lJob		:= .F.  
//Para notas fiscais de Entrada
Local cErrMail1  := "consignacao@manole.com.br; financeiro.cr@manole.com.br; ecommerce@manole.com.br; logistica@manole.com.br"
//Para notas fiscais de Saida			
Local cErrMail2  := "consignacao@manole.com.br; financeiro.cr@manole.com.br; ecommerce@manole.com.br; logistica@manole.com.br"									
//Para notas fiscais de SERVIวO
Local cErrMail3  := "cobrancas@manole.com.br; financeiro.cr@manole.com.br; "										
Local cErrMail6  := "anderson@manole.com.br;financerio.cr@manole.com.br;cobrancas@manole.com.br;"
Local cEMailFis	 := "anderson@manole.com.br;financerio.cr@manole.com.br;cobrancas@manole.com.br;"
//Local cErrMailA  := "wallace.pereira@ethosx.com;"

Local cQuery1	:= ""
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cQuery4	:= ""
Local cQuery5	:= ""
Local cQuery6	:= ""
//Local aTabelas	:= {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","SC5","SC6","UA3","UA4","UA5"}
Local aTabelas	:= {}
Local cAlias1	:= GetNextAlias()
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local cAlias4	:= GetNextAlias()
Local cAlias5	:= GetNextAlias()
Local cAlias6	:= GetNextAlias()


RPCClearEnv()																					//Limpa o ambiente
RPCSetType(3)																					//Define o ambiente nao consome licenca
Prepare Environment Empresa "01" Filial "01" 


//Notas Fiscais de Entrada de Formulแrio Pr๓prio
Conout("** INICIO - Notas de Entrada " + DtoC(Date()) + " - " + Time() + " **")

cQuery1:= " SELECT F1_FIMP, F1_STATUS, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT, F1_VALBRUT, F1_DESCONT, F1_VALMERC "+CHR(13)+CHR(10)
cQuery1+= "	FROM SF1010 SF1 WHERE SF1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery1+= "  AND F1_EMISSAO >= '20180401' "+CHR(13)+CHR(10)
cQuery1+= "	AND F1_SERIE = '001' "+CHR(13)+CHR(10)
cQuery1+= "	AND F1_FORMUL = 'S'	"+CHR(13)+CHR(10)
cQuery1+= "	AND F1_FIMP NOT IN ('S') "+CHR(13)+CHR(10)
cQuery1:= ChangeQuery(cQuery1)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery1),cAlias1, .T., .T.)

(cAlias1)->(dbGoTop())
While !(cAlias1)->(Eof())

		U_EXPMAIL(cErrMail1, "Status de Nota Protheus x Sefaz , verifique NOTA: "+(cAlias1)->F1_DOC+" - "+(cAlias1)->F1_SERIE, "Favor, verificar a Nota "+(cAlias1)->F1_DOC+" - "+(cAlias1)->F1_SERIE+" para que seja atualizado de acordo com o Sefaz. ")
//		U_EXPMAIL(cErrMailA, "Status de Nota Protheus x Sefaz , verifique NOTA: "+(cAlias1)->F1_DOC+" - "+(cAlias1)->F1_SERIE, "Favor, verificar a Nota "+(cAlias1)->F1_DOC+" - "+(cAlias1)->F1_SERIE+" para que seja atualizado de acordo com o Sefaz. ")

	(cAlias1)->(dbSkip())
EndDo

(cAlias1)->(dbCloseArea())
          
Conout("** FIM - Notas de Entrada " + DtoC(Date()) + " - " + Time() + " **")





//Notas Fiscais de Saํda 
Conout("** INICIO - Notas de Saํda " + DtoC(Date()) + " - " + Time() + " **")

cQuery2:= " SELECT F2_FIMP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA  "+CHR(13)+CHR(10)
cQuery2+= "	FROM SF2010 SF2 WHERE SF2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery2+= "  AND F2_EMISSAO >= '20180101' "+CHR(13)+CHR(10)
cQuery2+= "	AND F2_SERIE = '001' "+CHR(13)+CHR(10)
cQuery2+= "	AND F2_FIMP NOT IN ('S') "+CHR(13)+CHR(10)
cQuery2:= ChangeQuery(cQuery2)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery2),cAlias2, .T., .T.)

(cAlias2)->(dbGoTop())
While !(cAlias2)->(Eof())

		U_EXPMAIL(cErrMail2, "Status de Nota Protheus x Sefaz , verifique NOTA: "+(cAlias2)->F2_DOC+" - "+(cAlias2)->F2_SERIE, "Favor, verificar a Nota "+(cAlias2)->F2_DOC+" - "+(cAlias2)->F2_SERIE+" para que seja atualizado de acordo com o Sefaz. ")
//		U_EXPMAIL(cErrMailA, "Status de Nota Protheus x Sefaz , verifique NOTA: "+(cAlias2)->F2_DOC+" - "+(cAlias2)->F2_SERIE, "Favor, verificar a Nota "+(cAlias2)->F2_DOC+" - "+(cAlias2)->F2_SERIE+" para que seja atualizado de acordo com o Sefaz. ")

	(cAlias2)->(dbSkip())
EndDo

(cAlias2)->(dbCloseArea())
          
Conout("** FIM - Notas de Saํda " + DtoC(Date()) + " - " + Time() + " **")




//Notas Fiscais de Saํda de Servi็o
Conout("** INICIO - Notas de Servi็o " + DtoC(Date()) + " - " + Time() + " **")

cQuery3:= " SELECT F2_FIMP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA  "+CHR(13)+CHR(10)
cQuery3+= "	FROM SF2010 SF2 WHERE SF2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery3+= "  AND F2_EMISSAO >= '20180101' "+CHR(13)+CHR(10)
cQuery3+= "	AND F2_SERIE = 'A' "+CHR(13)+CHR(10)
cQuery3+= "	AND F2_NFELETR = ' ' "+CHR(13)+CHR(10)
cQuery3:= ChangeQuery(cQuery3)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery3),cAlias3, .T., .T.)

(cAlias3)->(dbGoTop())
While !(cAlias3)->(Eof())

		U_EXPMAIL(cErrMail3, "Status de Nota Protheus x Prefeitura , verifique NOTA: "+(cAlias3)->F2_DOC+" - "+(cAlias3)->F2_SERIE, "Favor, verificar a Nota "+(cAlias3)->F2_DOC+" - "+(cAlias3)->F2_SERIE+" para que seja atualizado de acordo com a Prefeitura. ")
//		U_EXPMAIL(cErrMailA, "Status de Nota Protheus x Prefeitura , verifique NOTA: "+(cAlias3)->F2_DOC+" - "+(cAlias3)->F2_SERIE, "Favor, verificar a Nota "+(cAlias3)->F2_DOC+" - "+(cAlias3)->F2_SERIE+" para que seja atualizado de acordo com a Prefeitura. ")

	(cAlias3)->(dbSkip())
EndDo

(cAlias3)->(dbCloseArea())
          
Conout("** FIM - Notas de Servi็o " + DtoC(Date()) + " - " + Time() + " **")





//Status de Notas Canceladas no Livro Fiscal com retorno de nota autorizada no Sefaz
//Para atualizar o status, fazer consulta do n๚mero atrav้s do MONITOR

Conout("** INICIO - Notas CANCELADAS x SEFAZ " + DtoC(Date()) + " - " + Time() + " **")

cQuery4:= " SELECT F3_OBSERV, F3_CODRSEF, F3_CODRET, F3_DESCRET, F3_NFISCAL, F3_SERIE, F3_ENTRADA, F3_EMISSAO "+CHR(13)+CHR(10)
cQuery4+= "	FROM SF3010 SF3 WHERE SF3.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery4+= "	AND F3_EMISSAO >= '20180601' "+CHR(13)+CHR(10)
cQuery4+= "	AND F3_OBSERV LIKE '%CANCELADA%' "+CHR(13)+CHR(10)
cQuery4+= "	AND F3_SERIE = '001' "+CHR(13)+CHR(10)
cQuery4+= "	AND F3_CODRSEF NOT IN ('101','155','205','302') "+CHR(13)+CHR(10)
cQuery4:= ChangeQuery(cQuery4)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery4),cAlias4, .T., .T.)

(cAlias4)->(dbGoTop())
While !(cAlias4)->(Eof())

		U_EXPMAIL(cErrMail1, "Status de Nota Protheus x Sefaz , CONSULTE a nota no MONITOR FAIXA: "+(cAlias4)->F3_NFISCAL+" - "+(cAlias4)->F3_SERIE, "Favor, verificar a Nota "+(cAlias4)->F3_NFISCAL+" - "+(cAlias4)->F3_SERIE+" no MONITOR, FAIXA, para que seja atualizado de acordo com o Sefaz. ")
//		U_EXPMAIL(cErrMailA, "Status de Nota Protheus x Sefaz , CONSULTE a nota no MONITOR FAIXA: "+(cAlias4)->F3_NFISCAL+" - "+(cAlias4)->F3_SERIE, "Favor, verificar a Nota "+(cAlias4)->F3_NFISCAL+" - "+(cAlias4)->F3_SERIE+" no MONITOR, FAIXA, para que seja atualizado de acordo com o Sefaz. ")

	(cAlias4)->(dbSkip())
EndDo

(cAlias4)->(dbCloseArea())
          
Conout("** FIM - Notas CANCELADAS x SEFAZ " + DtoC(Date()) + " - " + Time() + " **")






//Status de Notas no Livro Fiscal sem retorno de nota autorizada no Sefaz
//Para atualizar o status, fazer consulta do n๚mero atrav้s do MONITOR

Conout("** INICIO - Verificar Livro Fiscal " + DtoC(Date()) + " - " + Time() + " **")
 
cQuery5:= " SELECT F3_OBSERV, F3_CODRSEF, F3_CODRET, SUBSTR(F3_DESCRET,1,20), F3_NFISCAL, F3_SERIE, F3_ENTRADA, F3_EMISSAO "+CHR(13)+CHR(10)
cQuery5+= "	FROM SF3010 SF3 WHERE SF3.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery5+= "	AND F3_EMISSAO >= '20180901' "+CHR(13)+CHR(10)
cQuery5+= "	AND F3_OBSERV NOT IN ('NF INUTILIZADA','CANCELADA') "+CHR(13)+CHR(10)
cQuery5+= "	AND F3_SERIE = '001' AND F3_SDOC = '001' AND F3_ESPECIE = 'SPED' AND F3_FORMUL = 'S' "+CHR(13)+CHR(10)
cQuery5+= "	AND F3_CODRSEF NOT IN ('100','101','155','205','302')  "+CHR(13)+CHR(10)
cQuery5:= ChangeQuery(cQuery5)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery5),cAlias5, .T., .T.)

(cAlias5)->(dbGoTop())
While !(cAlias5)->(Eof())

		U_EXPMAIL(cEmailFis, "Verificar Livro Fiscal: "+(cAlias5)->F3_NFISCAL+" - "+(cAlias5)->F3_SERIE, "Favor, verificar a Nota "+(cAlias5)->F3_NFISCAL+" - "+(cAlias5)->F3_SERIE+" no MONITOR, FAIXA, para que seja atualizado de acordo com o Sefaz. ")

	(cAlias5)->(dbSkip())
EndDo

(cAlias5)->(dbCloseArea())
          
Conout("** FIM - Verificar Livro Fiscal " + DtoC(Date()) + " - " + Time() + " **")



//Conforme orientacao da analista Andressa, as notas de remessa para conserto e exposicao devem retornar nos prazos
//Remessa para conserto - 120 Dias
//Remessa para feira    - 60  Dias
//Remessa para garantia - 45  Dias

Conout("** INICIO - Verificar Notas de Remessa " + DtoC(Date()) + " - " + Time() + " **")
 
cQuery6:= " SELECT D2_COD, D2_ITEM, D2_QUANT, D2_QTDEDEV, D2_PRCVEN, D2_TOTAL, D2_VALDEV, D2_TES, D2_CF, D2_PEDIDO, D2_CLIENTE, D2_LOJA, D2_DOC, D2_SERIE, D2_EMISSAO "+CHR(13)+CHR(10)
cQuery6+= "	FROM SD2010 SD2 WHERE SD2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery6+= "	AND D2_EMISSAO >= '20190101' "+CHR(13)+CHR(10)
cQuery6+= "	AND D2_TES IN ('711','660','572') "+CHR(13)+CHR(10)
cQuery6+= "	AND D2_QUANT > D2_QTDEDEV "+CHR(13)+CHR(10)
cQuery6:= ChangeQuery(cQuery6)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery6),cAlias6, .T., .T.)

(cAlias6)->(dbGoTop())
While !(cAlias6)->(Eof())

	If (cAlias6)->D2_TES == '711' .And. Date() >= (Stod((cAlias6)->D2_EMISSAO) + 50)

		U_EXPMAIL(cErrMail6, "Verificar Notas de Remessa: "+(cAlias6)->D2_DOC+" - "+(cAlias6)->D2_SERIE, "Favor, verificar a Nota "+(cAlias6)->D2_DOC+" - "+(cAlias6)->D2_SERIE+" Prazo para RETORNO EXPIRADO ou EXPIRANDO... ")

	ElseIf (cAlias6)->D2_TES == '660' .And. Date() >= (Stod((cAlias6)->D2_EMISSAO) + 110)
	
		U_EXPMAIL(cErrMail6, "Verificar Notas de Remessa: "+(cAlias6)->D2_DOC+" - "+(cAlias6)->D2_SERIE, "Favor, verificar a Nota "+(cAlias6)->D2_DOC+" - "+(cAlias6)->D2_SERIE+" Prazo para RETORNO EXPIRADO ou EXPIRANDO... ")	
	
	ElseIf (cAlias6)->D2_TES == '572' .And. Date() >= (Stod((cAlias6)->D2_EMISSAO) + 45)

		U_EXPMAIL(cErrMail6, "Verificar Notas de Remessa: "+(cAlias6)->D2_DOC+" - "+(cAlias6)->D2_SERIE, "Favor, verificar a Nota "+(cAlias6)->D2_DOC+" - "+(cAlias6)->D2_SERIE+" Prazo para RETORNO EXPIRADO ou EXPIRANDO... ")
	
	EndIf
	

	(cAlias6)->(dbSkip())
EndDo

(cAlias6)->(dbCloseArea())
          
Conout("** FIM - Verificar Notas de Remessa " + DtoC(Date()) + " - " + Time() + " **")

Return(Nil)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MNLJOBNFEบ Autor ณEdmar Mendes Prado  บ Data ณ  19/04/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia lembrete para as notas que nใo tiveram retorno Sefaz บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Schedule na empresa 01,01. 	  Nome: MNLJOBNFE - U_MNLJOBNFE("01","01")บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function ExpMail( cTo, cSubject, cBody, cFile )

Local lAuth         := .T.									//GetMv("MN_CSGAUTH")	//.T.
Local cMailConta	:= "acertos@manole.com.br"				//Alltrim(GetMv("MN_CSGCONT"))
//Local cMailSenha	:= "@c3rt05!+"							//"mnl!1969" 		//Alltrim(GetMv("MN_CSGSENH"))
Local cMailSenha	:= "wegksmehdrfrfevf"							//"mnl!1969" 		//Alltrim(GetMv("MN_CSGSENH"))
Local cMailServer	:= "smtp.gmail.com:587"					//Alltrim(GetMv("MN_CSGSERV"))
local nRelTime 	    := 300									//GetMv("MN_CSGTIME")	//300	
Local lSSL	        := .T.									//GetMv("MN_CSGSSL")	//.T. 
Local lTLS	        := .T.									//GetMv("MN_CSGTLS")	//.T. 
Local lAutentica    := .T.									//GetMv("MN_CSGAUTH")	//.T.

Default cTo		  := ""
Default cSubject  := ""
Default cBody 	  := ""
Default cFile 	  := ""

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

	If lOk
		If lAutentica
			If !MailAuth(cMailConta, cMailSenha )
				MSGINFO("Falha na Autentica็ใo do Usuแrio","Aten็ใo")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					MSGINFO("Erro na Desconexใo: "+cErrorMsg,"Aten็ใo")
				ENDIF
				Return .F.
			EndIf
		EndIf

		//Envio de e-mail
		SEND MAIL FROM cMailConta to cTo SUBJECT cSubject BODY cBody ATTACHMENT cFile RESULT lSendOk
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
	
Endif

If lOk
	DISCONNECT SMTP SERVER
EndIf

Return
