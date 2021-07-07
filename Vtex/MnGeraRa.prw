#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerRA()   ºAutor  ³Leandro Duarte      º Data ³  02/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o titulo de Recebimento Antecipado para o pessoal do   º±±
±±º          ³Financeiro efetuar a Conciliação financeira corretamente    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pela Srta Andreia Financeiro copelcolchoes      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MnGerRARa()
	Local oDlg
	Local cCadastro := "Tela para geração de titulos do Tipo RA para os pedidos da Vtex"
	Local cPerg		:= "MNFIN00002"
	Local nOpca		:= 0
	Local cQuery 	:= ""

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	DEFINE MSDIALOG oDlg FROM 130,111 TO 350,600 TITLE cCadastro PIXEL

	@ 10 ,4   TO 73 ,239 LABEL '' OF oDlg PIXEL
	@ 23,15 SAY "  "+"Este programa tem como objetivo gerar os boletos do tipo RA dos pedidos de venda Vtex. " SIZE 210,80 OF oDlg PIXEL  // //

	DEFINE SBUTTON FROM 92 ,136 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 92 ,174 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 92 ,204 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpcA == 1
		cQuery := "SELECT A.R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SC5")+" A WHERE A.C5_FILIAL = '"+xFilial("SC5")+"' AND A.D_E_L_E_T_ = ' ' AND A.C5_TIPOPGT = 'BANKINVOICE' AND A.C5_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR03+"' AND A.C5_LOJAENT  BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR04+"' AND A.C5_NUM  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND A.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'  "
		IiF(SELECT("GRVCPED")>0,TRBU->(DBCLOSEAREA()),nil)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GRVCPED", .T., .T.)
		GRVCPED->(DBGOTOP())
		WHILE GRVCPED->(!EOF())
			SC5->(DBGOTO(GRVCPED->REC))
			Processa({|| GeraTit() })
			GRVCPED->(DBSKIP())
		END
	endif

Return()

Static Function GeraTit()
	Local lExiste	:= .F.
	Local cArqPd 	:= "/imp_vtex/"
	local cLogFile := cArqPd+alltrim(SC5->C5_VTEX)+".LOG"
	Local lMSHelpAuto := .F.
	Local lMSErroAuto := .F.

	IF ALLTRIM(SC5->C5_TIPOPGT) == 'BANKINVOICE'
		conout("GERANDO O TITULO DE RA")
		cHistorico	:= alltrim(SC5->C5_MENNOTA)
		cNatureza	:= 'RECE'
		nValor		:= xValorPed(SC5->C5_NUM)
		SA6->(DBSETORDER(1))
		IF nValor > 0 .AND. SA6->(DBSEEK(XFILIAL("SA6")+"2376539 7639      "))
			DBSelectArea("SE1")
			// rotina para saber se ja existe o titulo de RA do cliente referente a essa compra
			lExiste := BusqSe1()
			if !lExiste
				cNumTit := SE1->(GetSxeNum("SE1","E1_NUM"))
				WHILE BUSCSX(cNumTit)// VERIFICA SE EXISTE O TITULO NA BASE
					SE1->(ConfirmSX8())
					cNumTit := SE1->(GetSxeNum("SE1","E1_NUM"))
				END
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta array com dados do Titulo.			                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aTituloSE1  := {	{"E1_PREFIXO"	,"RA"							,Nil},;
					{"E1_NUM"	  	,cNumTit 						,Nil},;
					{"E1_PARCELA" 	,'1'			     			,Nil},;
					{"E1_TIPO"	 	,'RA'							,Nil},;
					{"E1_NATUREZ" 	,cNatureza						,Nil},;
					{"E1_CLIENTE" 	,SC5->C5_CLIENTE				,Nil},;
					{"E1_LOJA"	  	,SC5->C5_LOJACLI				,Nil},;
					{"E1_EMISSAO" 	,DDATABASE			 				,Nil},;
					{"E1_VENCTO"  	,DATAVALIDA(DDATABASE)							,Nil},;
					{"E1_VENCREA" 	,DATAVALIDA(DDATABASE)							,Nil},;
					{"E1_HIST" 		,cHistorico						,Nil},;
					{"E1_MOEDA" 	,1								,Nil},;
					{"E1_ORIGEM"	,"FINA040"						,Nil},;
					{"E1_FLUXO"		,"S"							,Nil},;
					{"E1_VALOR"	  	,nValor							,Nil},;
					{"CBANCOADT" 	,SA6->A6_COD					,Nil},;
					{"CAGENCIAADT"	,SA6->A6_AGENCIA				,Nil},;
					{"CNUMCON"		,SA6->A6_NUMCON					,Nil},;
					{"E1_PGVTTID"	,SC5->C5_PGVTTID				,Nil},;
					{"E1_NOSSVTX"	,SC5->C5_NOSSONU				,Nil} }

				lMSHelpAuto := .F. //.F. // para nao mostrar os erro na tela
				lMSErroAuto := .F. //.F. // inicializa como falso, se voltar verdadeiro e' que deu erro

				MsExecAuto({|x,y| Fina040(x,y)},aTituloSE1,3) //Inclusao
			ENDIF
			If 	lMsErroAuto
				SE1->(RollBackSX8())
				cFileLogAux	:= NomeAutoLog()
				cMemoErro 	:= MemoRead(cFileLogAux)

				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						FWrite( nHandle,"erro ao Gerar o titulo de Recebimento Antecipado"+CRLF+cMemoErro+CRLF)
						FCLOSE(nHandle)
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						FWrite( nHandle,"erro ao Gerar o titulo de Recebimento Antecipado"+CRLF+cMemoErro+CRLF)
						FCLOSE(nHandle)
					EndIf
				EndIf
			ELSE
				SE1->(ConfirmSX8())
			EndIf

		EndIf
	ENDIF
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xValorPed ºAutor  ³Leandro Duarte      º Data ³  02/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para saber o verdadeiro valor do Boleto antecipado   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍadmÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xValorPed(cPedido)
	Local aAreaSC5 	:= SC5->(getarea())
	Local aAreaSC6 	:= SC6->(getarea())
	Local xValor	:= 0
	SC5->(dbsetorder(1))
	SC6->(dbsetorder(1))
	IF SC5->(DBSEEK(XFILIAL("SC5")+cPedido))
		xValor += SC5->C5_FRETE
		IF SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
			WHILE SC6->C6_NUM == cPedido
				xValor += SC6->C6_VALOR
				SC6->(DBSKIP())
			END
		ENDIF
	ENDIF
	restarea(aAreaSC5)
	restarea(aAreaSC6)
Return(xValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSQSE1   ºAutor  ³Leandro Duarte      º Data ³  02/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para sasbermos se ja existe o titulo na base de dadosº±±
±±º          ³para não duplicar                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BusqSe1()
	Local lRet := .F.
	Local cQuery := ""
	cQuery := " SELECT count(*) AS QTD FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND A.E1_LOJA = '"+SC5->C5_LOJACLI+"' AND D_E_L_E_T_ = ' ' AND A.E1_NOSSVTX = '"+SC5->C5_NOSSONU+"'"
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	TRBU->(DBGOTOP())
	IF TRBU->QTD > 0
		lRet := .T.
		cQuery := " SELECT A.R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND A.E1_LOJA = '"+SC5->C5_LOJACLI+"' AND D_E_L_E_T_ = ' ' AND A.E1_NOSSVTX = '"+SC5->C5_NOSSONU+"'"
		IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
		TRBU->(DBGOTOP())
		SE1->(DBGOTO(TRBU->REC))
	endif

Return(lRet)

Static Function AjustaSX1(cPerg)
PutSx1(cPerg, '01', 'Cliente de      ?', 'Cliente de     ?', 'Cliente de     ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par01', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '02', 'Loja de         ?', 'Loja de        ?', 'Loja de        ?', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, '03', 'Cliente ate     ?', 'Cliente ate    ?', 'Cliente ate    ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '04', 'Loja Ate        ?', 'Loja ate       ?', 'Loja ate       ?', 'mv_ch4', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, "05", "Pedido de      ?","Pedido de      ?","Pedido de      ?" ,"mv_ch5", "C", 6,0, 0, "G", "", "SC5", "", "", "MV_PAR05", '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, "06", "Pedido ate     ?","Pedido ate     ?","Pedido ate     ?" ,"mv_ch6", "C", 6,0, 0, "G", "", "SC5", "", "", "MV_PAR06", '', '', '', '', '', '', '','','','','','','','','','','')

PutSx1(cPerg, '07', 'Emissão de   ?', 'Emissão de  ?', 'Emissão de  ?', 'mv_ch7', 'D',08, 0, 0, 'G', '', ''   , '', '', 'mv_par07', '', '', '', '', '', '', '','','','','','','','','','','')
PutSx1(cPerg, '08', 'Emissão ate  ?', 'Emissão ate ?', 'Emissão ate ?', 'mv_ch8', 'D',08, 0, 0, 'G', '', ''   , '', '', 'mv_par08', '', '', '', '', '', '', '','','','','','','','','','','')

Return



USER FUNCTION TETE()
Local _cEmpresa	:= "01"
Local _cFilial	:= "01"
Local aTables := {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","UA3","UA4","UA5"}

RpcSetType(3)
RpcSetEnv( _cEmpresa,_cFilial,,, "CTB", "SCHEDULE DE INTEGRAÇÃO COM VTEX", aTables, , , ,  )

DBSELECTAREA("SC5")
SC5->(DBSETORDER(1))
SC5->(DBSEEK(XFILIAL("SC5")+"162005"))
GeraTit()

RpcClearEnv()

RETURN()

STATIC fUNCTION BUSCSX(cNum)
Local lRet := .F.
Local cQuery := " SELECT count(*) AS QTD FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_NUM = '"+cNum+"' AND A.E1_PARCELA = '1' AND D_E_L_E_T_ = ' ' AND A.E1_TIPO = 'RA'"
	IiF(SELECT("TRBA")>0,TRBA->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBA", .T., .T.)
	TRBA->(DBGOTOP())
	IF TRBA->QTD > 0
		lRet := .T.
	ENDIF
RETURN(lRet)