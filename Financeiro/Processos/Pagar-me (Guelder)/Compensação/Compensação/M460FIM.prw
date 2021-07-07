#include "totvs.ch"
#include "protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460FIM   บAutor  ณTOTVS               บ Data ณ 22/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada no final da gravacao da Nota Fiscal de     บฑฑ
ฑฑฬออออออออออณSaida para gravar a tabela de controle de consignacao.      บฑฑ
ฑฑบ          ณCampos Especificos:                                         บฑฑ
ฑฑบ          ณC5_XTPCON -> R=Remessa; V=Venda Consignacao.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M460FIM()

Local aArea    := GetArea()
Local aAreaSD2 := SD2->(GetArea())
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSC9 := SC9->(GetArea())
Local cChave   := xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
Local lContinua:= .F.
Local cMailSta  := Alltrim(Lower(SC5->C5_XEMAIL))

IF TYPE("aM460Num")=="A"
	For nFor := 1 to len(aM460Num)
		IF aM460Num[nFor][1]
			DBSELECTAREA("SC5")
			SC5->(DBGOTO(aM460Num[nFor][3]))
			RECLOCK("SC5",.F.)
			SC5->C5_FRETE := aM460Num[nFor][2]
			MSUNLOCK()
		endif
	Next nFor	
ENDIF

If SC5->C5_XTPCON == "F"//Faturamento Consignacao
	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While !Eof().And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cChave
			RecLock("SZ1",.T.)
			Z1_FILIAL  := xFilial("SZ1")
			Z1_CLIENTE := SD2->D2_CLIENTE
			Z1_LOJA    := SD2->D2_LOJA
			Z1_PRODUTO := SD2->D2_COD
			Z1_UN      := SD2->D2_UM
			Z1_QUANT   := SD2->D2_QUANT
			Z1_DOC     := SD2->D2_DOC
			Z1_SERIE   := SD2->D2_SERIE
			Z1_EMISSAO := SD2->D2_EMISSAO
			Z1_ITEMS   := SD2->D2_ITEM
			Z1_PRUNIT  := SD2->D2_PRCVEN
			Z1_TIPO    := 'F'
			Z1_DOCORI  := SC6->C6_XNFORCO
			Z1_SERIEOR := SC6->C6_XSERCON
			Z1_ITEMORI := SC6->C6_XITCON
			Z1_EVENTO  := SC5->C5_XEVENTO
			Z1_PEDIDO  := SD2->D2_PEDIDO
			MsUnLock()
			U_AtuCons(SF2->F2_CLIENTE,SF2->F2_LOJA,SD2->D2_COD,SD2->D2_XEVENTO,"FI",SD2->D2_QUANT)
			SD2->(DbSkip())
		EndDo
	EndIf
ElseIf SC5->C5_XTPCON == "R"
	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While !Eof().And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cChave
			
			U_AtuCons(SF2->F2_CLIENTE,SF2->F2_LOJA,SD2->D2_COD,SD2->D2_XEVENTO,"CI",SD2->D2_QUANT)
			
			SD2->(DbSkip())
		EndDo
	EndIf
EndIf


//Alimenta Volume na NF.
xAtuVol()


//Valido para pedidos B2B
//Se o campo de email do pedido de vendas estiver preenchido, atualizarแ status do pedido e enviara email	
If ! Empty(SC5->C5_XEMAIL) 

	/*
	INC - Pedido Incluido
	SEP - Pedido Separado
	FAT - Pedido Faturado
	EMB - Pedido Embarcado
	*/

	RecLock("SC5", .F.)
		SC5->C5_XSTATUS := "FAT"
	MsUnlock()
	
	Conout("** M460FIM-001 - Enviando e-mail status de Pedido" + DtoC(Date()) + " - " + Time() + " **")
	//U_EXPMAIL(cMailSta , "MANOLE - Pedido Faturado: " + SC5->C5_NUM, " Seu pedido foi faturado no sistema sob n๚mero de Nota Fiscal " + SF2->F2_DOC + " conforme negocia็ใo acordada. ")		
	cHtml := u_StatPed(SC5->C5_NUM)
	EnviaEmail(cHtml,cMailSta)
		
EndIf
	

RestArea(aAreaSC9)
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aArea)

	//Concilia็ใo NCC - ETHOSX
	u_NCCCONC()

Return


/*/
xAtuVol
/*/

Static Function xAtuVol()

Local nQtdeVol := 0
Local cTmp1       := "NUM"
local aarea1 := getarea()
local aAreaCB6 := CB6->(GetArea())
LOCAL cQuery

cQuery := "SELECT count(*) NUM "
cQuery += "FROM" + RetSqlTab('CB6') + " "
cQuery += "where CB6_NOTA = '"+ SF2->F2_DOC +"' "
cQuery += "and CB6_SERIE = '" +SF2->F2_SERIE+"' "
cQuery += "and D_E_L_E_T_ <> '" +'*'+"' "


IF SELECT("TRB0")<>0
	DBSELECTAREA("TRB0")
	TRB0->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS TRB0

DBSELECTARE("TRB0")
TRB0->(DBGOTOP())


//cQuery := ChangeQuery(cQuery)

//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTmp1, .F., .T.)

nQtdeVol := TRB0->NUM


If nQtdeVol > 0
	RecLock("SF2",.F.)
	SF2->F2_VOLUME1 := nQtdeVol	 // grava quantidade de volumes na nota
	SF2->F2_ESPECI1 := "CAIXA(S)"
	SF2->F2_PBRUTO  := SF2->F2_PBRUTO + nQtdeVol
	SF2->(MsUnlock())
EndIf

//ATUALIZA DADOS DE CB6 E CB7 COM INFORMAวีES DA NOTA
_CQUERY1 := ""
_CQUERY1 := " SELECT R_E_C_N_O_ REGCB7 FROM "+RETSQLNAME("CB7")+" "
_CQUERY1 += " WHERE CB7_FILIAL = '"+XFILIAL("CB7")+"' AND CB7_PEDIDO IN "
_CQUERY1 += " (SELECT D2_PEDIDO FROM "+RETSQLNAME("SD2")+" WHERE D2_FILIAL = '"+XFILIAL("SF2")+"' AND D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE = '"+SF2->F2_SERIE+"' AND D_E_L_E_T_ <> '*' )"
_CQUERY1 += " AND D_E_L_E_T_ <> '*' AND CB7_NOTA = '         ' AND CB7_SERIE = '   ' "

IF SELECT("TRB1")<>0
	DBSELECTAREA("TRB1")
	TRB1->(DBCLOSEAREA())
ENDIF

TCQUERY _CQUERY1 NEW ALIAS TRB1

DBSELECTAREA("TRB1")
TRB1->(DBGOTOP())

DBSELECTAREA("CB7")

WHILE !TRB1->(EOF())
	CB7->(DBGOTO(TRB1->REGCB7))
	RECLOCK("CB7",.F.)
	CB7->CB7_NOTA := SF2->F2_DOC
	CB7->CB7_SERIE := SF2->F2_SERIE
	CB7->(MSUNLOCK())
	
	TRB1->(DBSKIP())
END

RestArea(aAreaCB6)
restarea(aarea1)
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

