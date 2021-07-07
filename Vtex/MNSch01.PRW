#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "PARMTYPE.CH"
//#INCLUDE "MSSPOOL.CH"
Static nPageLines, nAtualLine
Static __cFrom, __cServer, __cAccount, __cPassword, __cAccFrom, __nTimeOut, __cMailAdt, __lSmtpAuth, __cMVFrom
Static __lSX6Opened
Static __lSendMail
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNSCH01   ºAutor  ³Leandro Duarte      º Data ³  08/19/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para ler sempre o xml do vtex a cada termino executa º±±
±±º          ³novamente PARA ALIMENTAR O DE PARA                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MNSCH01(aParEmp)
Local _cEmpresa
Local _cFilial
Local aTables := {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","UA3","UA4","UA5"}
Local AFILIALS	:= {}
Local aNomeTab	:= {}
Local NFORX		:= 0
Private lWin 	:= file('c:\windows')
Private cArqPd 	:= iif(lWin,"\imp_vtex\","/imp_vtex/")
Private cNomArq	:= dtos(date())+replace(time(),':','')
Private lGRVPed	:= .t.
Private lGRVDPA	:= .t.

_cEmpresa 	:= "01"
_cFilial	:= "01"

RpcSetType(3)
RpcSetEnv( _cEmpresa,_cFilial)
SM0->(DBGOTOP())
while SM0->(!EOF())
	AADD(AFILIALS,{SM0->M0_CODIGO,SM0->M0_CODFIL})
	SM0->(DBSKIP())
END
RpcClearEnv()

//Se a rotina não for executada por agendamento de Schedule, voltar While e For abaixo para executar sem parar
//WHILE .T.

	//FOR NFORX := 1 TO LEN(AFILIALS)

		//_cEmpresa := AFILIALS[NFORX][1]
		//_cFilial	:= AFILIALS[NFORX][2]
		_cEmpresa 	:= "01"
		_cFilial	:= "01"

		RpcSetType(3)
		RpcSetEnv( _cEmpresa,_cFilial,,, "CTB", "SCHEDULE DE INTEGRAÇÃO COM VTEX", aTables, , , ,  )
		cNomArq	:= dtos(date())+replace(time(),':','')
		lGRVPed	:= GETNEWPAR("MV_VTEXPD",.T.)
		lGRVDPA	:= GETNEWPAR("MV_VTEXDP",.T.)
		lBANCO	:= GETNEWPAR("MV_VTEXBC",.F.)// ROTINA PARA SABER SE GRAVA OS DE-PARA EM BANCO OU LOCAL

		Conout("MNSCH01-001 - EXECUÇÃO DA LEITURA DA VTEX DATA: "+DTOC(DATE())+" HORA: "+TIME())
		aNomeTab := U_MNDPTAB(lBANCO)		//ANALISA O DEPARA PARA A CRIAÇÃO DAS TABELAS TEMPORARIAS
		if len(aNomeTab)>0			//ANALISA SE JA EXISTE A ESTRUTURA DAS TABELAS PARA A IMPORTAÇÃO
			if lGRVDPA
				U_MNALIMDP(aNomeTab)	//ALIMENTA OS DADOS NAS TABELAS DEPARA CASO OCORRA QUEDA DO SISTEMA		
			endif
			
		   	if lGRVPed
		   		U_ALTERFIL(aNomeTab)
		   		
		   		U_MNPED01(aNomeTab)		//INTEGRAÇÃO DE PEDIDO E DE CLIENTES A PARTIR DAS TABELAS DEPARA

				U_MNACC9()	
		   	endif
		ENDIF
		Conout("MNSCH01-001 - TERMINO DA LEITURA DA VTEX DATA: "+DTOC(DATE())+" HORA: "+TIME())
		RpcClearEnv()

	//NEXT NFORX
//END

Return

USER FUNCTION MNACC9()

cquery := " "
 cquery := " select C9_FILIAL,C9_PRODUTO,C9_QTDLIB,C9_LOCAL "
 cquery += " from "+retsqlname("SC9")+ " SC9"
 cquery += " WHERE NOT EXISTS (SELECT * FROM "+retsqlname("SC6")+" SC6 WHERE SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO  = SC6.C6_NUM AND SC9.C9_CLIENTE = SC6.C6_CLI  "
 cquery += " AND SC9.C9_LOJA = SC6.C6_LOJA AND SC6.D_E_L_E_T_ = ' ') "
 cquery += " AND SC9.C9_DATALIB >= '20201205' AND SC9.D_E_L_E_T_ = ' ' " // AND SC9.C9_FILIAL ='01' "

 cQuery := ChangeQuery(cQuery)


	if select("TRB")>0
		TRB->(DBCLOSEAREA())
	endif


dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .T., .T.)

While !eof()

   DBSELECTAREA("SB2")
   DBGOTOP()
   DBSETORDER(1)
    If dbseek(TRB->C9_FILIAL + TRB->C9_PRODUTO + TRB->C9_LOCAL)
	    IF SB2->B2_RESERVA >= TRB->C9_QTDLIB
	   		RECLOCK("SB2",.F.)
			  SB2->B2_RESERVA := SB2->B2_RESERVA - TRB->C9_QTDLIB
			MSUNLOCK()
		ENDIF
	    IF SB2->B2_QEMP >= TRB->C9_QTDLIB
			RECLOCK("SB2",.F.)
		  		SB2->B2_QEMP := SB2->B2_QEMP - TRB->C9_QTDLIB
			MSUNLOCK()
		ENDIF
	endif
//////////////
   DBSELECTAREA("SBF")
   DBGOTOP()
   DBSETORDER(2)
    If dbseek(TRB->C9_FILIAL + TRB->C9_PRODUTO + TRB->C9_LOCAL)
		While TRB->C9_FILIAL == SBF->BF_FILIAL .AND. TRB->C9_PRODUTO == SBF->BF_PRODUTO .AND. TRB->C9_LOCAL == SBF->BF_LOCAL
	     IF SBF->BF_EMPENHO >= TRB->C9_QTDLIB
	   	    	RECLOCK("SBF",.F.)
			       SBF->BF_EMPENHO := SBF->BF_EMPENHO - TRB->C9_QTDLIB
			    MSUNLOCK()
		ENDIF
		DBSKIP()
		ENDDO


	endif
/////////////////////
   DBSELECTAREA("TRB")
   DBSKIP()
   ENDDO

   			cquery := " "
			cquery := " UPDATE "+retsqlname("SC9")+" SC9 SET D_E_L_E_T_ = '*' "
			cquery += " WHERE NOT EXISTS (SELECT * FROM "+retsqlname("SC6")+" SC6 WHERE SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO  = SC6.C6_NUM AND SC9.C9_CLIENTE = SC6.C6_CLI "
			cquery += " AND SC9.C9_LOJA = SC6.C6_LOJA AND SC6.D_E_L_E_T_ = ' ') "
			cquery += " AND SC9.C9_DATALIB >= '20201205' AND SC9.D_E_L_E_T_ = ' ' " //AND SC9.C9_FILIAL ='02' "
			
  			
			
			TcsqlExec(cquery)




return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNSCH02   ºAutor  ³Leandro Duarte      º Data ³  14/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para ler o pedido ja faturado e atualizar o status doº±±
±±º          ³pedido para invoice                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MNSCH02(aParEmp)
Local _cEmpresa
Local _cFilial
Local aTables :={"PAE","SC6","SE3","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","SC5","UA3","UA4","UA5"}
Local AFILIALS	:= {}
Local NFORX		:= 0
_cEmpresa 	:= "01"
_cFilial	:= "01"

RpcSetType(3)
RpcSetEnv( _cEmpresa,_cFilial)
SM0->(DBGOTOP())
while SM0->(!EOF())
	AADD(AFILIALS,{SM0->M0_CODIGO,SM0->M0_CODFIL})
	SM0->(DBSKIP())
END
RpcClearEnv()

//WHILE .T.

	//FOR NFORX := 1 TO LEN(AFILIALS)

		_cEmpresa 	:= "01"	//AFILIALS[NFORX][1]
		_cFilial	:= "01"	//AFILIALS[NFORX][2]
		RpcSetType(3)
		RpcSetEnv( _cEmpresa,_cFilial,,, "CTB", "SCHEDULE DE ALTERAÇÃO DE STATUS", aTables, , , ,  )
		U_MNStVce()
		RpcClearEnv()
	//NEXT NFORX
//END
Return

/* edmar
User Function MNSCH03(aParEmp)
Local _cEmpresa
Local _cFilial
Local aTables := {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9"}
Local AFILIALS	:= {}
Local aNomeTab	:= {}
Local NFORX		:= 0
Private lWin 	:= file('c:\windows')
Private cArqPd 	:= iif(lWin,"\imp_vtex\","/imp_vtex/")
Private cNomArq	:= dtos(date())+replace(time(),':','')

_cEmpresa 	:= "01"
_cFilial	:= "01"

RpcSetType(3)
RpcSetEnv( _cEmpresa,_cFilial)
SM0->(DBGOTOP())
while SM0->(!EOF())
	AADD(AFILIALS,{SM0->M0_CODIGO,SM0->M0_CODFIL})
	SM0->(DBSKIP())
END
RpcClearEnv()

WHILE .T.

	FOR NFORX := 1 TO LEN(AFILIALS)

		_cEmpresa 	:= AFILIALS[NFORX][1]
		_cFilial	:= AFILIALS[NFORX][2]
		RpcSetType(3)
		RpcSetEnv( _cEmpresa,_cFilial,,, "CTB", "SCHEDULE DE INTEGRAÇÃO COM VTEX", aTables, , , ,  )
		cNomArq	:= dtos(date())+replace(time(),':','')

		Conout("MNSCH01-002 - EXECUÇÃO DA LEITURA DA VTEX DATA: "+DTOC(DATE())+" HORA: "+TIME())
		aNomeTab := {{'1',u_Velhoarq('1')},{'2',u_Velhoarq('2')},{'3',u_Velhoarq('3')}}
		U_MNPED01(aNomeTab)		//INTEGRAÇÃO DE PEDIDO E DE CLIENTES A PARTIR DAS TABELAS DEPARA
		Conout("MNSCH01-003 - TERMINO DA LEITURA DA VTEX DATA: "+DTOC(DATE())+" HORA: "+TIME())

		RpcClearEnv()
	NEXT NFORX
END
Return
edmar */

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNSCH03   ºAutor  ³Leandro Duarte      º Data ³  08/19/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para ler sempre o xml do vtex a cada termino executa º±±
±±º          ³novamente PARA GERAR OS PEDIDOS                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNSCH03(aParEmp)
Local _cEmpresa
Local _cFilial
Local aTables := {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","UA3","UA4","UA5"}
Local AFILIALS	:= {}
Local aNomeTab	:= {}
Local NFORX		:= 0
Private lWin 	:= file('c:\windows')
Private cArqPd 	:= iif(lWin,"\imp_vtex\","/imp_vtex/")
Private cNomArq	:= dtos(date())+replace(time(),':','')
Private lGRVPed	:= .t.
Private lGRVDPA	:= .t.

_cEmpresa 	:= "01"
_cFilial	:= "01"

RpcSetType(3)
RpcSetEnv( _cEmpresa,_cFilial)
SM0->(DBGOTOP())
while SM0->(!EOF())
	AADD(AFILIALS,{SM0->M0_CODIGO,SM0->M0_CODFIL})
	SM0->(DBSKIP())
END
RpcClearEnv()

//WHILE .T.

	//FOR NFORX := 1 TO LEN(AFILIALS)

		_cEmpresa 	:= "01"		//AFILIALS[NFORX][1]
		_cFilial	:= "01"		//AFILIALS[NFORX][2]
		RpcSetType(3)
		RpcSetEnv( _cEmpresa,_cFilial,,, "CTB", "SCHEDULE DE INTEGRAÇÃO COM VTEX", aTables, , , ,  )
		cNomArq	:= dtos(date())+replace(time(),':','')
		lGRVPed	:= GETNEWPAR("MV_VTEXPD",.T.)
		lGRVDPA	:= .F.//GETNEWPAR("MV_VTEXDP",.T.)

		Conout("MNSCH03-001 - EXECUÇÃO DA LEITURA DA VTEX DATA: "+DTOC(DATE())+" HORA: "+TIME())
		aNomeTab := U_MNDPTAB()		//ANALISA O DEPARA PARA A CRIAÇÃO DAS TABELAS TEMPORARIAS
		if len(aNomeTab)>0			//ANALISA SE JA EXISTE A ESTRUTURA DAS TABELAS PARA A IMPORTAÇÃO
			if lGRVDPA
				U_MNALIMDP(aNomeTab)	//ALIMENTA OS DADOS NAS TABELAS DEPARA CASO OCORRA QUEDA DO SISTEMA
			endif
		   	if lGRVPed
		   		U_ALTERFIL(aNomeTab)
		   		
		   		U_MNPED01(aNomeTab)		//INTEGRAÇÃO DE PEDIDO E DE CLIENTES A PARTIR DAS TABELAS DEPARA
		   	endif
		ENDIF
		Conout("MNSCH03-002 - TERMINO DA LEITURA DA VTEX DATA: "+DTOC(DATE())+" HORA: "+TIME())

		RpcClearEnv()
	//NEXT NFORX
//END
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EmailEnv  ºAutor  ³lEANDRO DUARTE      º Data ³  12/16/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA DISPARO DE E-MAIL COM O LOG DE PROCESSAMENTO    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11 E P12                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function ENVMAIL(cEmailCC,cArq,cAssunto,cMsg,cConta,cTexto,lback,cCCBakMail)
Local lResulConn := .T.
Local lResulSend := .T.
Local lResult := .T.
Local cError := ""
Local cCc := ""
Local cBcc := ""
Local cAnexo1 := ""
Local cAnexo2 := ""
Local cEmail	:= ""
Local cPass		:= ""
Local nForq		:= 0
Local aTables	:= {"SF3","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SE4","SFT","SL3","SL4","SF4","CC2","SB1","SB2","SC9","SC5","SC6","SX5","SB1","SM4","CC2","ZZ1"}
Default cConta := "MANOLE"
Default lBack	:= .F.
Default cTexto	:= ""
Default cCCBakMail := ""
WF7->(DBSETORDER(1))
WF7->(DBGOTOP())
WF7->(DBSEEK(XfILIAL("WF7")+cConta))

cEmail	:= AllTrim(WF7->WF7_AUTUSU)
cPass	:= AllTrim(WF7->WF7_AUTSEN)

oMail := TMailManager():New()
if alltrim(WF7->WF7_SMTPSE) == 'SSL'
oMail:SetUseSSL(.T.)
ELSEIF alltrim(WF7->WF7_SMTPSE) == 'TLS'
oMail:SetUseTLS(.T.)
ENDIF
oMail:Init( ALLTRIM(WF7->WF7_POP3SR), AllTrim(WF7->WF7_SMTPSR) , AllTrim(WF7->WF7_AUTUSU), AllTrim(WF7->WF7_AUTSEN), WF7->WF7_POP3PR ,WF7->WF7_SMTPPR )
oMail:SetSmtpTimeOut( WF7->WF7_TEMPO )
Conout("cEmail: " + cEmail)
Conout("cPass: " + cPass)
conout('Conectando do SMTP')

//nErro := oMail:SmtpConnect()
nErro := oMail:IMAPConnect()
if nErro <> 0
	oMail:SMTPDisconnect()
	if lback
		STARTJOB('U_XJBX',GetEnvServer(),.f.,{ SM0->M0_CODIGO, SM0->M0_CODFIL ,aTables,cEmailCC,cAssunto,cMsg,{cArq},cCCBakMail })
		cTexto := "E-mail Disparado Com sucesso"
		Return(.t.)
	else
		u_xSetMail(cEmailCC,cAssunto,cMsg,{cArq},.F.,.F.,.F.,.F.,cCCBakMail)
		cTexto := "E-mail Disparado Com sucesso"
		Return(.t.)
	endif
	conout("ERROR:" + oMail:GetErrorString(nErro))
	alert("ERROR:" + oMail:GetErrorString(nErro))
	cTexto := "ERROR:" + oMail:GetErrorString(nErro)
	return .F.
Endif

nErro := oMail:SmtpAuth(cEmail ,cPass)
If nErro <> 0
	oMail:SMTPDisconnect()
	if lback
		STARTJOB('U_XJBX',GetEnvServer(),.f.,{ SM0->M0_CODIGO, SM0->M0_CODFIL ,aTables,cEmailCC,cAssunto,cMsg,{cArq},cCCBakMail })
		cTexto := "E-mail Disparado Com sucesso"
		Return(.t.)
	else
		u_xSetMail(cEmailCC,cAssunto,cMsg,{cArq},.F.,.F.,.F.,.F.,cCCBakMail)
		cTexto := "E-mail Disparado Com sucesso"
		Return(.t.)
	endif
	conout("ERROR:" + oMail:GetErrorString(nErro))
	alert("ERROR:" + oMail:GetErrorString(nErro))
	cTexto := "ERROR:" + oMail:GetErrorString(nErro)
	return .F.
Endif
cPara := cEmailCC
nVolta:= 0
while at(';',cPara)>0
	nVolta+= 1
	setprvt("cPara"+cvaltochar(nVolta))
	&("cPara"+cvaltochar(nVolta)) := substr(cPara,1,at(';',cPara)-1)
	cPara := substr(cPara,at(';',cPara)+1)
end
if at('@',cPara)>0
	nVolta+= 1
	setprvt("cPara"+cvaltochar(nVolta))
	&("cPara"+cvaltochar(nVolta)) := alltrim(cPara)
endif
cAnexo1 :=  cArq
For nForq := 1 to nVolta
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o Email³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom 			:= cEmail
	oMessage:cTo	 		:= &("cPara"+cvaltochar(nForq))
	oMessage:cBcc 			:= WF7->WF7_REMETE
	oMessage:cCc 			:= IIF(EMPTY(cCCBakMail),"",cCCBakMail)
	oMessage:cSubject 		:= IIF(EMPTY(cPara),'',cAssunto)
	oMessage:cBody 			:= cMsg+"<br><img src='cid:\system\manole.jpg>"


	//Adiciona um attach
	If oMessage:AttachFile(cAnexo1) < 0
		Conout( "Erro ao atachar o arquivo" )

	Else                     		//adiciona uma tag informando que é um attach e o nome do arq
		oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cArq)
	EndIf
	oMessage:AttachFile( '\system\manole.jpg' )
	oMessage:AddAttHTag( 'Content-ID: <manole.jpg>' )

	nErro := oMessage:Send( oMail )
	if nErro <> 0
		conout("ERROR:" + oMail:GetErrorString(nErro))
		cTexto := "ERROR:" + oMail:GetErrorString(nErro)
		oMail:SMTPDisconnect()
		return .F.
	ELSE
		lResulSend := .t.
	Endif
next nForq

//FERASE(cAnexo1)
//DISCONNECT SMTP SERVER
conout('Desconectando do SMTP')
oMail:SMTPDisconnect()
cTexto := "E-mail Disparado Com sucesso"
return(lResulSend)

User Function XJBX(aParam)
RpcSetType(3)
RpcSetEnv( aParam[1], aParam[2] ,,, "FAT", "DISPARA DE EMAIL", aParam[3], , , ,  )
u_xSetMail(aParam[4],aParam[5],aParam[6],aParam[7],.F.,.F.,.F.,.F.,aParam[8])
RpcClearEnv()
Return()

user Function xSetMail(cEmail,cTitle,cDesc,aFiles,lCopy,lText,lNoScreen,lFormatMsg,cBCC)
Local lResult
Local aRetUser
Local cMailSnd	:= ""
Local cMsgInfo := ""
Local cFrom := ""
Local cAlignSubject := ''

If ( SX6IsOpened() )
	cAlignSubject := GetMV('MV_SUBJLE', .F., 'S')
EndIf

DEFAULT aFiles := {}, cEmail := "", cTitle := "",;
		cDesc := "", lCopy := .F., lText := .F., lNoScreen := .F.,;
		lFormatMsg := .T., cBCC := ""

cEmail := MailGroup(cEmail)

//MV_RELACNT -> ACCOUNT
//MV_RELPSW  -> PASSWORD
//MV_RELSERV -> SERVER
/*
If IsRunSch()
	PswOrder(1)
	If PswSeek(__CUSERID)
		aRetUser := PswRet(1)
		__cFrom := "Relatório "+SetSchedule()[4]+" enviado pelo Protheus Report Scheduler."+"<br>" // ### " enviado pelo Protheus Report Scheduler."
		__cFrom += "Proprietário: "+aRetUser[1][2]+"<br><br>" //"Proprietário: "
		If Empty(aRetUser[1][14])
			__cAccFrom := MAIL_ADDRESS
		Else
			__cAccFrom := AllTrim(aRetUser[1][14])
		EndIf
	Else
		APMSGINFO("ID Usuario "+__CUSERID+" nao encontrado.") //"ID Usuario " ### " nao encontrado."
		Return .F.
	EndIf
Else*/If __cFrom == NIL
	PswOrder(1)
	PswSeek(__CUSERID)
	aRetUser := PswRet(1)
	If ( Len(aRetUser) > 0 )
		__cFrom := "E-mail enviado por: "+aRetUser[1][2]+"<br>"+; //"E-mail enviado por: "
					"Nome completo: "+aRetUser[1][4]+"<br>"+; //"Nome completo: "
					"E-mail: "+aRetUser[1][14]+"<br><br>" //"E-mail: "
		If Empty(aRetUser[1][14])
			__cAccFrom := MAIL_ADDRESS
		Else
			__cAccFrom := AllTrim(aRetUser[1][14])
		EndIf
	Else
		__cFrom := ""
		__cAccFrom := MAIL_ADDRESS
	EndIf
EndIf

If __cMVFrom == NIL
	__cMVFrom := AllTrim(GetMV("MV_RELFROM",,""))
EndIf

If Empty(__cMVFrom)
	cFrom := __cAccFrom
Else
	cFrom := __cMVFrom
EndIf

If __cServer == NIL
	__cServer := AllTrim(GetMv("MV_RELSERV",,""))
	If Empty(__cServer)
		APMSGINFO("Não foi possível enviar o e-mail. Verifique o parâmetro de configuração do servidor de e-mail (MV_RELSERV).",OemToAnsi("Relatorios")) //"Não foi possível enviar o e-mail. Verifique o parâmetro de configuração do servidor de e-mail (MV_RELSERV)."
		Return .F.
	EndIf
EndIf

If __lSmtpAuth == NIL
	__lSmtpAuth := GetMv("MV_RELAUTH",,.F.)
EndIf

If __cAccount == NIL
	__cAccount := AllTrim(GetMv("MV_RELACNT",,""))
	If Empty(__cAccount) .and. !__lSmtpAuth
		APMSGINFO("Não foi possível enviar o e-mail. Verifique o parâmetro de configuração da conta de e-mail (MV_RELACNT).",OemToAnsi("Relatorios")) //"Não foi possível enviar o e-mail. Verifique o parâmetro de configuração da conta de e-mail (MV_RELACNT)."
		Return .F.
	EndIf
EndIf

If __cPassword == NIL
	__cPassword := AllTrim(GetMv('MV_RELPSW',,""))
EndIf

If __nTimeOut == NIL
	__nTimeOut := GetMv("MV_RELTIME",,30)
EndIf

If __cMailAdt == NIL	//e-mail para auditoria enviado como oculto
	__cMailAdt := AllTrim(GetMv('MV_MAILADT',,""))
EndIf

If lCopy
	If !(MAIL_ADDRESS$__cAccFrom) .And. !(__cAccFrom$cEmail)
		cEmail += ";"+__cAccFrom
	EndIf
EndIf

// Ponto de entrada para validar o envio de e-mail

lResult := .T.

DEFAULT __lSendMail := ExistBlock('VLDMAIL')

If ( __lSendMail )
    cMsgInfo := ExecBlock('VLDMAIL', .F., .F., { cFrom, {cEmail}, cTitle, cDesc, aFiles } )
	If ( ValType(cMsgInfo) == 'C' ) .And. ( ! Empty(cMsgInfo) )
		lResult := .F.
	EndIf
EndIf

If ( lResult )
	lResult := MailSmtpOn(__cServer,__cAccount,__cPassword,__nTimeOut)
EndIf

If lResult

	If __lSmtpAuth
		lResult := MailAuth(__cAccount,__cPassword)
		If !lResult
			lResult := MailUser()
		EndIf
	EndIf

	If lResult
		cDesc := Trim(cDesc)
		If lFormatMsg
			cDesc := __cFrom+If(Empty(cDesc),"",("Descrição:"+"<br>"+cDesc)) //"Descrição:"
			cTitle := Trim(cTitle)

			If ( cAlignSubject == 'S' )
				cTitle := "Advanced Protheus Report - "+If(Empty(cTitle),"",(" - "+cTitle)) //"Advanced Protheus Report - "
			Else
				cTitle := If(Empty(cTitle),"Advanced Protheus Report - ",(cTitle + " - "+"Advanced Protheus Report - ")) //"Advanced Protheus Report - "
			EndIf

		EndIf

		If !Empty(__cMailAdt)
			If Empty(cBCC)
				cBCC := __cMailAdt
			Else
				cBCC += ";"+__cMailAdt
			EndIf
		EndIf

//	AADD(AFILIALS,{SM0->M0_CODIGO,SM0->M0_CODFIL})
		lResult := MailSend(cFrom,{cEmail},{},{cBCC},cTitle,cDesc,aFiles,lText)
		If lResult
			cMsgInfo := "O e-mail foi enviado com sucesso." //"O e-mail foi enviado com sucesso."
		Else
			cMsgInfo := "O e-mail não pode ser enviado."+Chr(13)+Chr(10)+"Error:"+AllTrim(MailGetErr()) //"O e-mail não pode ser enviado."
		EndIf
		MailSmtpOff()
	Else
		cMsgInfo := "Não foi possível conectar ao servidor de e-mail."+__cServer+Chr(13)+Chr(10)+"Error:"+AllTrim(MailGetErr()) //"Não foi possível conectar ao servidor de e-mail."
	EndIf
Else
	If ( Empty(cMsgInfo) )
		cMsgInfo := "Não foi possível conectar ao servidor de e-mail."+__cServer+Chr(13)+Chr(10)+"Error:"+AllTrim(MailGetErr()) //"Não foi possível conectar ao servidor de e-mail."
	EndIf
EndIf

If ( Upper(Subs(__cLogSiga,6,1)) == "S" )
    cMailSnd := __cAccFrom + " => " + cEmail + " - " + If( cTitle != Nil, cTitle, "" )+;
			    " - Status: " + MailGetErr()
    __GeraLog("M", cMailSnd )
EndIf

//APMSGINFO(cMsgInfo,OemToAnsi("Relatorios"))
Return lResult

Static ;
Function SX6IsOpened( )

If ( __lSX6Opened == NIL )
	If ( Select('SX6') > 0 )
		__lSX6Opened := .T.
	Else
		__lSX6Opened := .F.
	EndIf
EndIf

Return(__lSX6Opened)
