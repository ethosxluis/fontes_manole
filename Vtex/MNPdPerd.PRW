#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNPDPERD  บAutor  ณLeandro Duarte      บ Data ณ  12/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para analisa se o Pedido estava na area de Start Hangบฑฑ
ฑฑบ          ณling pois se estiver nessa area e nเo esta no protheus deve บฑฑ
ฑฑบ          ณrodar essa rotina para trazer o pedido e faturar no Totvs   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function MNPdPerd()
Local oGet1
Local cGet1 := space(TAMSX3("C5_VTEX")[1])
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSButton1
Local oSButton2
Private oDlg
Private oFont1 := TFont():New("Times New Roman",,020,,.T.,,,,,.F.,.F.)
Private oFont2 := TFont():New("Times New Roman",,024,,.T.,,,,,.F.,.F.)
Private oFont3 := TFont():New("Times New Roman",,024,,.T.,,,,,.F.,.F.)
Private aDadKit	:= {}
Private cArqNtx1 := Criatrab(Nil,.F.)
Private cArqNtx2 := Criatrab(Nil,.F.)
Private cArqNtx3 := Criatrab(Nil,.F.)
DEFINE MSDIALOG oDlg TITLE "Status Start Hangling" FROM 000, 000  TO 250, 800 COLORS 0, 16777215 PIXEL

@ 010, 018 SAY oSay1 PROMPT "Rotina para CAPTURAR os pedidos que nใo estใo no protheus e estใo com o Status de Start hangling para ser Processado" SIZE 368, 018 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 041, 020 SAY oSay2 PROMPT "Insira o Numero do Pedido da Vtex" SIZE 138, 009 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 041, 158 MSGET oGet1 VAR cGet1 SIZE 161, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 066, 020 SAY oSay3 PROMPT "Status:" SIZE 037, 009 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
DEFINE SBUTTON oSButton1 FROM 094, 030 TYPE 01 OF oDlg ENABLE action(iif(empty(cGet1),bbusc(),buscped(alltrim(cGet1))) )
DEFINE SBUTTON oSButton2 FROM 094, 093 TYPE 02 OF oDlg ENABLE action(odlg:end())

ACTIVATE MSDIALOG oDlg CENTERED
ferase(cArqNtx1)
ferase(cArqNtx2)
ferase(cArqNtx3)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNPDPERD  บAutor  ณMicrosiga           บ Data ณ  08/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function bbusc()
Local aDa := {}
aadd(aDa,"752981194708-01")
For nFor := 1 to len(ada)
	buscped(ada[nFor])
Next
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbuscped   บAutor  ณLeandro Duarte      บ Data ณ  12/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para buscar os pedidos que nใo foram importados pelo บฑฑ
ฑฑบ          ณprotheus e estใso com o start hangling                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 e p11                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function buscped(cIdPedido)
Local cUrl := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/?an=manole&f_status=invoiced"
//Local cUrl := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/?an=manole&f_status=invoiced"
Local nTimeOut := 99999
local oxml
Local cHeadRet := ""
Local sPostRet := ""
Local cErro    := ""
Local cAviso   := ""
Local cXml     := ""
Local cNum     := ""
Local lRetorno := .T.
Local nX       := 0
local lXml := .f.
Local cXmlPed := ""
Local LxmlPed := .f.
LOCAL _cUrlOrder := ""
local _cDataPed := ""
Local oXMLLIST
Local nFor1		:= 0
Local nForx		:= 0
Local cCupon	:= ""
Local nForKit	:= 0
Local nFor2		:= 0
private cParam   := ""
private UserCode := "vtexappkey-manole-UMVGHE"
private PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
private aHeadOut := {}
private oXMLped
Private lWin 	:= file('c:\windows')
Private cArqPd := iif(lWin,"\imp_vtex\","/imp_vtex/")
Private _X		:= 0
Private aValorOrig := {}
Private lTemCurLiv	:= .F.

@ 063, 063 SAY oSay4 PROMPT "                                                                                                                                        " SIZE 189, 024 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
oSay4:refresh()
oDlg:refresh()

//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

// COMUNICA COM O WEBSERVICE
sPostRet := HttpGET(cUrl,cParam,12000,aHeadOut,@cHeadRet)

lXml := FWJsonDeserialize(sPostRet,@oxml)
UA1->(DBSETORDER(3))
//SE HOUVEREM PEDIDOS A SEREM PROCESSADOS
if lXml .and. at('ORDERID',upper(sPostRet))>0
	UA1->(DBSEEK(XFILIAL("UA1")+'1'+'1'))
	cNumPed := oxml:OrderId
	cVelhoArq := u_Velhoarq('1')
	if valtype(cNumPed) <> "U"
		I := 1
		cUrlPed := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cNumPed+"/?an=manole"
		//cUrlPed := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cNumPed+"/?an=manole"
		cXmlPed := HttpGET(cUrlPed,cParam,12000,aHeadOut,@cHeadRet)
		lXmlPed := FWJsonDeserialize(cXmlPed,@oXMLped)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณanalisa se deve gravar os dados na tabela de Cliente, para saber se ja existe a estrutura da tabela DEPARA de clienteณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if !empty(cVelhoArq)
			iif(SELECT("TRBCLI")>0,TRBCLI->(DbCloseArea()),nil)
			dbUseArea(.T.,,cVelhoArq,"TRBCLI", .T., .F. )
			while !(select("TRBCLI")>0)
				dbUseArea(.T.,,cVelhoArq,"TRBCLI", .T., .F. )
			end
			aCpos	:= Extrut(cVelhoArq)
			cIndCond := "A1_CGC"
			IndRegua("TRBCLI",cArqNtx1,cIndCond,,,"Selecionando Registros...")
			dbselectarea("TRBCLI")
			dbSetIndex(cArqNtx1 + OrdBagExt())
			dbselectarea("TRBCLI")
			xRet := ascan(aCpos,{|x| alltrim(x[2]) == "A1_CGC" })
			if xRet > 0
				lSeek := !TRBCLI->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] ) ))
				Reclock("TRBCLI",lSeek)
			else
				Reclock("TRBCLI",.T.)
			endif
			xRet := ""
			For nFor1 := 1 TO LEN(aCpos)
				xRet := &("TRBCLI->"+aCpos[nFor1][2])
				&("TRBCLI->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
			Next nFor1
			
			MsUnlock()
			iif(SELECT("TRBCLI")>0,TRBCLI->(DbCloseArea()),nil)
			@ 063, 063 SAY oSay4 PROMPT "Cliente Importado" SIZE 189, 024 OF oDlg FONT oFont3 COLORS 255, 16777215 PIXEL
			oSay4:refresh()
			oDlg:refresh()
		endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณanalisa se deve gravar os dados na tabela do Cabe็alho do Pedido,se ja existe a estrutura da tabela DEPARA de pedido ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		UA1->(DBSETORDER(3))
		UA1->(DBSEEK(XFILIAL("UA1")+'1'+'2'))
		cVelhoArq := u_Velhoarq('2')
		if  !empty(cVelhoArq)
			@ 063, 063 SAY oSay4 PROMPT "                                         " SIZE 189, 024 OF oDlg FONT oFont3 COLORS 255, 16777215 PIXEL
			oDlg:refresh()
			if !(SELECT("TRBPEDC")>0)
				iif(SELECT("TRBPEDC")>0,TRBPEDC->(DbCloseArea()),nil)
				DbUseArea(.t.,,cVelhoArq,"TRBPEDC", .T., .F. )
				while !(select("TRBPEDC")>0)
					dbUseArea(.T.,,cVelhoArq,"TRBPEDC", .T., .F. )
				end
				aCpos	:= Extrut(cVelhoArq)
				cIndCond := "C5_VTEX"
				IndRegua("TRBPEDC",cArqNtx2,cIndCond,,,"Selecionando Registros...")
				dbselectarea("TRBPEDC")
				dbSetIndex(cArqNtx1 + OrdBagExt())
			endif
			dbselectarea("TRBPEDC")
			xRet := ascan(aCpos,{|x| alltrim(x[2]) == "C5_VTEX" })
			if xRet > 0
				lSeek := !TRBPEDC->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] ) ))
				Reclock("TRBPEDC",lSeek)
			else
				Reclock("TRBPEDC",.T.)
			endif
			xRet := ""
			For nFor1 := 1 TO LEN(aCpos)
				if alltrim(aCpos[nFor1][2]) == 'C5_TRANSP'
					nXfor3 := nxFor4	:= 0
					AEVAL(OXMLPED:SHIPPINGDATA:LOGISTICSINFO,{|X| nXfor3+= 1, iif(alltrim(X:DELIVERYIDS[1]:COURIERID)$'40436,41068,81019',nxFor4 := nxFor3,nil)}) // SEDEX,CORREIOS - PAC,PAC,E-SEDEX
					if nxFor4 > 0
						&("TRBPEDC->"+aCpos[nFor1][2]) := POSICIONE("SA4",5,XFILIAL("SA4")+OXMLPED:SHIPPINGDATA:LOGISTICSINFO[nxFor4]:DELIVERYIDS[1]:COURIERID,"A4_COD")
					//Edmar Mendes do Prado  -  21/11/2018
					//Altera็ใo para os pedidos oriundos da Amazon sem transportadora
					//elseIf Type("OXMLPED:SHIPPINGDATA:LOGISTICSINFO[nxFor4]:DELIVERYIDS[1]:COURIERID") == "U"
					//	&("TRBPEDC->"+aCpos[nFor1][2]) := "300"	
					Else
						&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
					endif
				ELSEif alltrim(aCpos[nFor1][2]) == 'C5_ENDTREG'
					xRet := &("TRBPEDC->"+aCpos[nFor1][2])
					&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
				ELSE
					&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
				ENDIF
			Next nFor1
			MsUnlock()
			@ 063, 226 SAY oSay4 PROMPT "Pedido Importado" SIZE 189, 024 OF oDlg FONT oFont3 COLORS 255, 16777215 PIXEL
			oSay4:refresh()
			oDlg:refresh()
		endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณanalisa se deve gravar os dados na tabela do Detalho do Pedido,se ja existe a estrutura da tabela DEPARA de Detalhe do Pedido ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		UA1->(DBSETORDER(3))
		UA1->(DBSEEK(XFILIAL("UA1")+'1'+'3'))
		cVelhoArq := u_Velhoarq('3')
		if  !empty(cVelhoArq)
			iif(SELECT("TRBPEDD")>0,TRBPEDD->(DbCloseArea()),nil)
			DbUseArea(.t.,,cVelhoArq,"TRBPEDD", .T., .F. )
			while !(select("TRBPEDD")>0)
				dbUseArea(.T.,,cVelhoArq,"TRBPEDD", .T., .F. )
			end
			aCpos	:= Extrut(cVelhoArq)
			cIndCond := "C6_VTEX+C6_PRDVTEX+C6_KITVTEX"
			IndRegua("TRBPEDD",cArqNtx3,cIndCond,,,"Selecionando Registros...")
			dbselectarea("TRBPEDD")
			dbSetIndex(cArqNtx1 + OrdBagExt())
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณcorre a quantidade de itens do pedidoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			for nFor2 := 1 TO LEN(oXMLped:ITEMS)
				_X := nFor2
				if valtype(oXMLped:ITEMS[_X]:REFID) <> "U"
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณCONDIวรO DE ANALISE SE EXISTE OU NรO O PRODUTOณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					// regra para verificar se existe kit de vendas manole
					if type("OXMLPED:MARKETINGDATA:COUPON") <> "U"
						cCupon	:= alltrim(OXMLPED:MARKETINGDATA:COUPON)
					else
						cCupon	:= ""
					endif
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณRegra para saber o produto ้ Brind, pois o campo oXMLped:ITEMS[_X]:ISGIFT ira vir verdadeiroณ
					//ณnesse caso o If Apresentado esta negado para que ele somente entra caso nใo for Brind e lแ  ณ
					//ณem baixo fa็o o tratamento para esse produto brind trocando as informa็๕es necessarias      ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					if !oXMLped:ITEMS[_X]:ISGIFT
						if valtype(OXMLPED:ITEMS[_X]:SELLERSKU) <> 'U' .AND.  valtype(OXMLPED:ITEMS[_X]:PRODUCTID) <> 'U' .AND. BUSCKIT(OXMLPED:ITEMS[_X]:PRODUCTID,OXMLPED:ITEMS[_X]:SELLERSKU,cCupon) // FUNวรO DE BUSCA SE O KIT EXISTE
							lEntra		:= .T.
							FOR nForKit := 1 to len(aDadKit)
								xRet  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
								xRet1 := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
								if xRet > 0 .AND. xRet1 > 0
									aadd(aValorOrig,{aDadKit[nForKit][2],0,padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] )+padr(aDadKit[nForKit][2],tamsx3(aCpos[xRet1][2])[1])+'S',aDadKit[nForKit][3]})
									lSeek := !TRBPEDD->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] )+padr(aDadKit[nForKit][2],tamsx3(aCpos[xRet1][2])[1])+'S' )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
									Reclock("TRBPEDD",lSeek)
								else
									Reclock("TRBPEDD",.T.)
									lSeek := .T.
								endif
								xRet := ""
								For nFor1 := 1 TO LEN(aCpos)
									aCpos[nFor1][1] := REPLACE(aCpos[nFor1][1],'OXMLPED:ITEMS[_X]:EAN','OXMLPED:ITEMS[_X]:REFID')
									if aCpos[nFor1][2] == "C6_KITVTEX"
										&("TRBPEDD->"+aCpos[nFor1][2]) := 'S'
									ELSEif ALLTRIM(aCpos[nFor1][2]) == "C6_ITEM"
										&("TRBPEDD->"+aCpos[nFor1][2]) := STRZERO(iif(nForKit==1 .and. _X == 1,_X,iif(nForKit==1 .and.  _X > 1,_X,LEN(oXMLped:ITEMS)+nForKit+iif(_X>1.and. nForKit>1,0,-1))),2) // regra ara calcular o item correto
									ELSEif ALLTRIM(aCpos[nFor1][2]) == "C6_PRDVTEX"
										&("TRBPEDD->"+aCpos[nFor1][2]) := aDadKit[nForKit][2]
									ELSE
										if ALLTRIM(aCpos[nFor1][2]) == "C6_VALOR"
											aValorOrig[nForKit][2]	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[nForKit][1],"B1_PRV1"),Valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1))
											nXvlTot	:= Valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
										ENDIF
										&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
									ENDIF
								Next nFor1
								xRet  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
								xRet1 := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
								xRet2  := 0
								xRet3  := 0
								xRet4  := 0
								xRet5  := 0
								xRet6  := 0
								xRet7  := 0
								xRet8  := 0
								xRet9  := 0
								xRet10 := 0
								if xRet > 0 .AND. xRet1 > 0 .and. alltrim(aDadKit[nForKit][2]) <> alltrim(TRBPEDD->C6_PRODUTO)
									TRBPEDD->C6_PRDVTEX		:= aDadKit[nForKit][2]
									TRBPEDD->C6_PRODUTO		:= aDadKit[nForKit][2]
									xRet2  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRCVEN" })
									xRet3  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VALOR" })
									xRet4  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRUNIT" })
									xRet5  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_CODISS" })
									xRet6  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_TES" })
									xRet7  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_XOPER" })
									xRet8  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_DESCRI" })
									xRet9  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_UM" })
									xRet10  := ascan(aCpos,{|x| alltrim(x[2]) == "C6_FILIAL" })
									nxIVl  := ascan(aDadKit,{|x| alltrim(x[3]) == "1" .AND. ALLTRIM(X[2]) == ALLTRIM(TRBPEDD->C6_PRODUTO)})
									if nxIVl <= 0 .and. len(aDadKit) > 1
										nxIVl  := iif(nForKit+1 <= len(aDadKit), nForKit+1, len(aDadKit))
										xnValor	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_PRV1"),Posicione("SB1",1,XFILIAL("SB1")+aDadKit[nxIVl][2],"B1_PRV1"))
										aDadKit[nxIVl][5]  := 1
									elseif nxIVl > 0 .and. aDadKit[ascan(aDadKit,{|z| alltrim(z[2]) == alltrim(TRBPEDD->C6_PRODUTO) })][4] <= 0
										xnValor	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_PRV1"),Posicione("SB1",1,XFILIAL("SB1")+aDadKit[nxIVl][2],"B1_PRV1"))
										aDadKit[nxIVl][5]  := 1
									elseif nxIVl > 0 .and. aDadKit[ascan(aDadKit,{|z| alltrim(z[2]) == alltrim(TRBPEDD->C6_PRODUTO) })][4] > 0
										xnValor	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_PRV1"),aDadKit[ascan(aDadKit,{|z| alltrim(z[2]) == alltrim(TRBPEDD->C6_PRODUTO) })][4])
										aDadKit[nxIVl][5]  := 1
									endif
									TRBPEDD->C6_LOCAL		:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_LOCPAD")
									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณcaso tenha valor na regra do KIT devera pegar o valor e esquecer o rateioณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									
									IF aDadKit[nForKit][4] > 0
										xnValor		:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_PRV1"),aDadKit[nForKit][4])
										IF xRet2 > 0
											aValorOrig[nForKit][2]	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_PRV1"),xnValor)
											TRBPEDD->C6_PRCVEN		:= xnValor// ATRIBUIREI OS 10 CENTAVOS PARA CADA LIVRO QUE RETIREI O VALOR DO CURSO
										ENDIF
										IF xRet3 > 0
											TRBPEDD->C6_VALOR		:= xnValor// ATRIBUIREI OS 10 CENTAVOS PARA CADA LIVRO QUE RETIREI O VALOR DO CURSO
										ENDIF
										IF xRet4 > 0
											TRBPEDD->C6_PRUNIT		:= xnValor// ATRIBUIREI OS 10 CENTAVOS PARA CADA LIVRO QUE RETIREI O VALOR DO CURSO
										ENDIF
										IF xRet5 > 0 .and. Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_XTIPO=='1'")
											TRBPEDD->C6_CODISS		:= " "
										ENDIF
										
										IF xRet10 > 0 
												dbSelectArea("SB1")
												SB1->(dbSetOrder(14))
												IF SB1->(DBSEEK(xFilial("SB1")+ TRBPEDD->C6_PRODUTO))
													If ALLTRIM(SB1->B1_XTIPO) == "2"
														TRBPEDD->C6_FILIAL		:= "01"
													ELSE
														TRBPEDD->C6_FILIAL		:= "02"
													ENDIF	
												ELSE
													SB1->(dbSetOrder(1))
													IF SB1->(DBSEEK(xFilial("SB1")+ TRBPEDD->C6_PRODUTO))
														If ALLTRIM(SB1->B1_XTIPO) == "2"
															TRBPEDD->C6_FILIAL		:= "01"
														ELSE
															TRBPEDD->C6_FILIAL		:= "02"
														ENDIF
													Endif
												Endif		
											ENDIF
												
										
										IF xRet6 > 0
										/* Edmar 24/04/2018
											if upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
												TRBPEDD->C6_XOPER		:= "14"
											else
												TRBPEDD->C6_XOPER		:= "15"
											endif
										*/
										
										
										
										
										
										
										
										
											if (OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) <> NIL
											 
												If upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
													TRBPEDD->C6_TES			:= "530"
												else
													TRBPEDD->C6_TES			:= "531"
												endif
											
											Else
													TRBPEDD->C6_TES			:= "531"
											
											EndIf
										ENDIF
										IF xRet7 > 0
										
										/* Edmar 24/04/2018
											if upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
												TRBPEDD->C6_XOPER		:= "14"
											else
												TRBPEDD->C6_XOPER		:= "15"
											endif
										*/
										
											if (OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) <> NIL
											 
												If upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
													TRBPEDD->C6_TES			:= "530"
												else
													TRBPEDD->C6_TES			:= "531"
												endif
											
											Else
													TRBPEDD->C6_TES			:= "531"
											
											EndIf
										
										ENDIF
										IF xRet8 > 0
											TRBPEDD->C6_DESCRI			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										ENDIF
										IF xRet9 > 0
											TRBPEDD->C6_UM			:= SB1->B1_UM// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										ENDIF 
										TRBPEDD->C6_DESCRI			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
									else
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณCaso nใo tenha valor do Kit deve pegar e efetuar o rateio do valor do produtoณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										if nxIVl > 0
											IF aDadKit[nForKit][3] <> '1' .or. (nForKit == 1 .and. len(aDadKit) > 1 )// SOMENTE CURSO
												IF xRet2 > 0
													TRBPEDD->C6_PRCVEN		-= xnValor// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
												ENDIF
												IF xRet3 > 0
													TRBPEDD->C6_VALOR		-= xnValor// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
												ENDIF
												IF xRet4 > 0
													TRBPEDD->C6_PRUNIT		-= xnValor// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
												ENDIF
												IF xRet9 > 0
													TRBPEDD->C6_UM			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
												ENDIF 
												TRBPEDD->C6_DESCRI			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
											ELSE
												IF xRet2 > 0
													aValorOrig[nForKit][2]	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_PRV1"),xnValor)
													TRBPEDD->C6_PRCVEN		:= xnValor// ATRIBUIREI OS 10 CENTAVOS PARA CADA LIVRO QUE RETIREI O VALOR DO CURSO
												ENDIF
												IF xRet3 > 0
													TRBPEDD->C6_VALOR		:= xnValor// ATRIBUIREI OS 10 CENTAVOS PARA CADA LIVRO QUE RETIREI O VALOR DO CURSO
												ENDIF
												IF xRet4 > 0
													TRBPEDD->C6_PRUNIT		:= xnValor// ATRIBUIREI OS 10 CENTAVOS PARA CADA LIVRO QUE RETIREI O VALOR DO CURSO
												ENDIF
												IF xRet5 > 0
													TRBPEDD->C6_CODISS		:= " "
												ENDIF
												
												IF xRet10 > 0 
												dbSelectArea("SB1")
												SB1->(dbSetOrder(14))
												IF SB1->(DBSEEK(xFilial("SB1")+ TRBPEDD->C6_PRODUTO))
													If ALLTRIM(SB1->B1_XTIPO) == "2"
														TRBPEDD->C6_FILIAL		:= "01"
													ELSE
														TRBPEDD->C6_FILIAL		:= "02"
													ENDIF	
												ELSE
													SB1->(dbSetOrder(1))
													IF SB1->(DBSEEK(xFilial("SB1")+ TRBPEDD->C6_PRODUTO))
														If ALLTRIM(SB1->B1_XTIPO) == "2"
															TRBPEDD->C6_FILIAL		:= "01"
														ELSE
															TRBPEDD->C6_FILIAL		:= "02"
														ENDIF
													Endif
												Endif		
											ENDIF
												
												
												IF xRet6 > 0
													if upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
														TRBPEDD->C6_TES			:= "530"
													else
														TRBPEDD->C6_TES			:= "531"
													endif
												ENDIF
												IF xRet7 > 0
													if upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
														TRBPEDD->C6_XOPER		:= "14"
													else
														TRBPEDD->C6_XOPER		:= "15"
													endif
												ENDIF
												IF xRet8 > 0
													TRBPEDD->C6_DESCRI			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
												ENDIF
												IF xRet9 > 0
													TRBPEDD->C6_UM			:= SB1->B1_UM// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
												ENDIF
											ENDIF
										endif
									endif
								ENDIF
								// REGRA PARA RETIRAR O DESCONTO CASO TENHA PARA O KIT EXEMPLO EX ALUNO, PROFESSOR, PAGAMENTO DE BOLETO
								if lEntra .and. (nDesc := (OXMLPED:ITEMS[1]:PRICE - OXMLPED:ITEMS[1]:SELLINGPRICE)/100)>0  .AND. (TRBPEDD->C6_PRCVEN-nDesc)>0 .and. aDadKit[nForKit][4] > 0
									lEntra := .F.
									IF xRet2 > 0
										TRBPEDD->C6_PRCVEN		-= nDesc
									ENDIF
									IF xRet3 > 0
										TRBPEDD->C6_VALOR		-= nDesc
									ENDIF
									IF xRet4 > 0
										TRBPEDD->C6_PRUNIT		-= nDesc
									ENDIF
								endif
								if !lSeek
									TRBPEDD->UXU_PROQUE := 0
								endif
								MsUnlock()
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณRegra para colocar o pedido para PAC pois o mesmo possui um livro e esse processo conforme Alexandre passou deve ser colocada PAC na transportadoraณ
								//ณPois a Vtex nใo traz o tipo de Transportadora para os KITS                                                                                         ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								if SB1->B1_XTIPO == '1'
									Reclock("TRBPEDC",.F.)
									TRBPEDC->C5_TRANSP := '08' // codigo do PAC na tabela SA4
									MsUnlock()
								ENDIF
							Next nForKit
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณACERTANDO OS VALORES DOS KITSณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							Asort(aValorOrig,,,{|x,y| x[2]>y[2]})
							For nXwq := 1 to len(aValorOrig)
								if nXwq == 1
									nXwqvl := aValorOrig[nXwq][2]
								else
									nXwqvl -= aValorOrig[nXwq][2]
								endif
							next nXwq

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณRegra de valores Negativoณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							if nXwqvl < 0
								nTotDiv := 0
								nXwqvl := 0
								For nFx1 := 1 to len(aValorOrig)
									 nXwqvl += Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[nFx1][1],"B1_PRV1") 
									 //1 = livro; 2 = Curso 
									 if (!lTemCurLiv .and. aValorOrig[nFx1][4]== '1') .or. (lTemCurLiv .and. aValorOrig[nFx1][4]== '2')
									 	nTotDiv+=1
									 endif
								next nFx1
								nXwqvl := nXwqvl - nXvlTot
								nXwqvl := (nXwqvl/nTotDiv)
								for I := 1 to len(aValorOrig)
									if (!lTemCurLiv .and. aValorOrig[I][4]== '1') .or. (lTemCurLiv .and. aValorOrig[I][4]== '2')
										lSeek := !TRBPEDD->(dbseek( aValorOrig[i][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
										Reclock("TRBPEDD",lSeek)
										TRBPEDD->C6_PRCVEN		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[i][1],"B1_PRV1") -nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										TRBPEDD->C6_VALOR		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[i][1],"B1_PRV1") -nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										TRBPEDD->C6_PRUNIT		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[i][1],"B1_PRV1") -nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										Msunlock()
									ENDIF	
								next I
							elseif len(aValorOrig)>0 .and. ascan(aDadKit,{|x| x[4] <= 0 }) > 0
								lSeek := !TRBPEDD->(dbseek( aValorOrig[1][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
								Reclock("TRBPEDD",lSeek)
								TRBPEDD->C6_PRCVEN		:= nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
								TRBPEDD->C6_VALOR		:= nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
								TRBPEDD->C6_PRUNIT		:= nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
								Msunlock()
								for I := 2 to len(aValorOrig) 
									lSeek := !TRBPEDD->(dbseek( aValorOrig[i][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
									Reclock("TRBPEDD",lSeek)
									TRBPEDD->C6_PRCVEN		:= aValorOrig[i][2]// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
									TRBPEDD->C6_VALOR		:= aValorOrig[i][2]// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
									TRBPEDD->C6_PRUNIT		:= aValorOrig[i][2]// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
									Msunlock()	
								next I
							endif
							aValorOrig := {}
						elseif valtype(OXMLPED:ITEMS[_X]:EAN) <> 'U'
							xRet := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
							xRet1 := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
							if xRet > 0 .AND. xRet1 > 0
								lSeek := !TRBPEDD->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] )+padr(&(aCpos[xRet1][1]),tamsx3(aCpos[xRet1][2])[1])+'N' ))// O CAMPO "N" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO NAO FOI CRIADO PELO KIT
								Reclock("TRBPEDD",lSeek)
							else
								Reclock("TRBPEDD",.T.)
								lSeek := .T.
							endif
							xRet := ""
							For nFor1 := 1 TO LEN(aCpos)
								&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
							Next nFor1
							if !lSeek
								TRBPEDD->UXU_PROQUE := 0
							endif
							MsUnlock()
						ELSEIF valtype(OXMLPED:ITEMS[_X]:REFID) <> 'U'
							xRet := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
							xRet1 := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
							if xRet > 0 .AND. xRet1 > 0
								lSeek := !TRBPEDD->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] )+padr(&(aCpos[xRet1][1]),tamsx3(aCpos[xRet1][2])[1])+'N' ))// O CAMPO "N" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO NAO FOI CRIADO PELO KIT
								Reclock("TRBPEDD",lSeek)
							else
								Reclock("TRBPEDD",.T.)
								lSeek := .T.
							endif
							xRet := ""
							For nFor1 := 1 TO LEN(aCpos)
								aCpos[nFor1][1] := REPLACE(aCpos[nFor1][1],'OXMLPED:ITEMS[_X]:EAN','OXMLPED:ITEMS[_X]:REFID')
								&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
							Next nFor1
							if !lSeek
								TRBPEDD->UXU_PROQUE := 0
							endif
							MsUnlock()
						ELSE
							xRet 	:= ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
							xRet1 	:= ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
							cVTex	:= &(aCpos[xRet][1])
							cLogFile := cArqPd+cNomArq+".log"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
							If !File(cLogFile)
								If (nHandle := MSFCreate(cLogFile,0)) <> -1
									FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido nใo possui CODIGO EAN cadastrado no Site da VTEX: "+CRLF)
									FCLOSE(nHandle)
								EndIf
							Else
								If (nHandle := FOpen(cLogFile,2)) <> -1
									FSeek(nHandle,0,2)
									FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido nใo possui CODIGO EAN cadastrado no Site da VTEX: "+CRLF)
									FCLOSE(nHandle)
								EndIf
							EndIf
						endif
					else
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณTraamento quando a op็ใo oXMLped:ITEMS[_X]:ISGIFT, for brindณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						if valtype(OXMLPED:ITEMS[_X]:EAN) <> 'U'
							xRet := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
							xRet1 := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
							if xRet > 0 .AND. xRet1 > 0
								lSeek := !TRBPEDD->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] )+padr(&(aCpos[xRet1][1]),tamsx3(aCpos[xRet1][2])[1])+'N' ))// O CAMPO "N" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO NAO FOI CRIADO PELO KIT
								Reclock("TRBPEDD",lSeek)
							else
								Reclock("TRBPEDD",.T.)
							endif
							xRet := ""
							For nFor1 := 1 TO LEN(aCpos)
								
								IF ALLTRIM(aCpos[nFor1][2]) == 'C6_TES'
									&("TRBPEDD->"+aCpos[nFor1][2]) := '590'
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_XOPER'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 'DO'
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_PRCVEN'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 10
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_VALOR'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 10
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_PRUNIT'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 10	
								
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_FILIAL'
												_cproduto := valtxp(xRet,&(aCpos[1][1]),aCpos[1][3],aCpos[1][2],1)
												dbSelectArea("SB1")
												SB1->(dbSetOrder(14))
												IF SB1->(DBSEEK(xFilial("SB1")+_cproduto))
													If ALLTRIM(SB1->B1_XTIPO) == "2"
														_FILIAL		:= "01"
													ELSE
														_FILIAL		:= "02"
													ENDIF	
												ELSE
													SB1->(dbSetOrder(1))
													IF SB1->(DBSEEK(xFilial("SB1")+ _cproduto))
														If ALLTRIM(SB1->B1_XTIPO) == "2"
															_FILIAL		:= "01"
														ELSE
															_FILIAL		:= "02"
														ENDIF
													Endif
												Endif	
											&("TRBPEDD->"+aCpos[nFor1][2]) := _FILIAL
								
													
								else
									&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
								endif
								
							Next nFor1
							
							MsUnlock()
						ELSEIF valtype(OXMLPED:ITEMS[_X]:REFID) <> 'U'
							xRet := ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
							xRet1 := ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
							if xRet > 0 .AND. xRet1 > 0
								lSeek := !TRBPEDD->(dbseek( padr(&(aCpos[xRet][1]),tamsx3(aCpos[xRet][2])[1] )+padr(&(aCpos[xRet1][1]),tamsx3(aCpos[xRet1][2])[1])+'N' ))// O CAMPO "N" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO NAO FOI CRIADO PELO KIT
								Reclock("TRBPEDD",lSeek)
							else
								Reclock("TRBPEDD",.T.)
							endif
							xRet := ""
							For nFor1 := 1 TO LEN(aCpos)
								aCpos[nFor1][1] := REPLACE(aCpos[nFor1][1],'OXMLPED:ITEMS[_X]:EAN','OXMLPED:ITEMS[_X]:REFID')
								
								IF ALLTRIM(aCpos[nFor1][2]) == 'C6_TES'
									&("TRBPEDD->"+aCpos[nFor1][2]) := '590'
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_XOPER'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 'DO'
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_PRCVEN'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 10
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_VALOR'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 10
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_PRUNIT'
									&("TRBPEDD->"+aCpos[nFor1][2]) := 10	
								
								
								elseif ALLTRIM(aCpos[nFor1][2]) == 'C6_FILIAL'
												_cproduto := valtxp(xRet,&(aCpos[1][1]),aCpos[1][3],aCpos[1][2],1)
												dbSelectArea("SB1")
												SB1->(dbSetOrder(14))
												IF SB1->(DBSEEK(xFilial("SB1")+_cproduto))
													If ALLTRIM(SB1->B1_XTIPO) == "2"
														_FILIAL		:= "01"
													ELSE
														_FILIAL		:= "02"
													ENDIF	
												ELSE
													SB1->(dbSetOrder(1))
													IF SB1->(DBSEEK(xFilial("SB1")+ _cproduto))
														If ALLTRIM(SB1->B1_XTIPO) == "2"
															_FILIAL		:= "01"
														ELSE
															_FILIAL		:= "02"
														ENDIF
													Endif
												Endif	
											&("TRBPEDD->"+aCpos[nFor1][2]) := _FILIAL
								
								
								else
									&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
							EndIf	
							Next nFor1
							
							MsUnlock()
						endif
					endif
				endif
			next nFor2
			iif(SELECT("TRBPEDD")>0,TRBPEDD->(DbCloseArea()),nil)
		endif
		iif(SELECT("TRBPEDC")>0,TRBPEDC->(DbCloseArea()),nil)
	else
		@ 063, 063 SAY oSay4 PROMPT "Pedido nใo Localizado" SIZE 189, 024 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
		oSay4:refresh()
		oDlg:refresh()
	endif
ELSE
	@ 063, 063 SAY oSay4 PROMPT "Pedido nใo Localizado" SIZE 189, 024 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	oSay4:refresh()
	oDlg:refresh()
endif
RETURN()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNALIMDP  บAutor  ณMicrosiga           บ Data ณ  08/25/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Extrut(cNomEstr)
Local aStr	:= {}
UA1->(dbsetorder(1))
if UA1->(DBSEEK(XFILIAL("UA1")+cNomEstr))
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aadd(aStr,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL,nil})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aStr[LEN(aStr)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		aStr[LEN(aStr)][3] := tamsx3(aStr[LEN(aStr)][2])[3]
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
	END
endif
Return(aStr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALTXP    บAutor  ณLeandro Duarte      บ Data ณ  08/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณvalida os dados para nใo dar erro de mismach                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function valtxp(cCpoAnt, cCpoNow, cTipo, cCpo, nVt)
Local xRet	:= nil
Local aRet	:= aClone(aCpos)
Local xOpc	:= ascan(aRet,{|z| z[2] == cCpo })
adel(aRet,xOpc)
asize(aRet,len(aRet)-1)
xOpc	:= ascan(aRet,{|z| z[2] == cCpo })
if xOpc == 0
	cCpoAnt	:= ""
endif
IF VALTYPE(cCpoNow) == 'O' .OR. VALTYPE(cCpoAnt) == 'O'
	xRet := IIF(cTipo == 'C','CAMPO ERRADO CLIENT',NIL)
	RETURN(xRet)
ENDIF
if cTipo == valtype(cCpoNow)
	if (cTipo == valtype(cCpoAnt) .or. VALtype(cCpoAnt) == 'U')
		if valtype(cCpoNow)== 'N'
			xRet	:= cCpoNow
		elseif valtype(cCpoNow)== 'C'
			xRet	:= ALLTRIM(ALLTRIM(cCpoAnt)+' '+ALLTRIM(cCpoNow))
		else
			xRet	:= cCpoNow
		endif
	else
		do case
			case  cTipo == 'C'
				xRet := ALLTRIM(cValtochar(cCpoAnt))
				xRet	+= ', '+cCpoNow
			case  cTipo == 'M'
				xRet := ALLTRIM(cValtochar(cCpoAnt))
				xRet	+= ', '+cCpoNow
			case  cTipo == 'N'
				xRet	:= cCpoNow
			otherwise
				xRet	:= cCpoNow
		endcase
		
	endif
Else
	if (cTipo == VALtype(cCpoAnt) .or. VALtype(cCpoAnt) == 'U')
		xRet := IIF( VALtype(cCpoAnt) == 'U','',ALLTRIM(cCpoAnt) )
		do case
			case  cTipo == 'D'
				xRet := iif(empty(stod(cCpoNow)),ctod(cCpoNow),stod(cCpoNow))
			case  cTipo == 'N'
				xRet := VAL(cCpoNow)
			case  cTipo == 'C'
				xRet := ALLTRIM(xRet+' '+ALLTRIM(cValtochar(cCpoNow)))
			case  cTipo == 'L'
				xRet := iif(upper(cCpoNow)=='.F.',.f.,.t.)
			case  cTipo == 'M'
				xRet := xRet+' '+cValtochar(cCpoNow)
		endcase
	else
		do case
			case  cTipo == 'D'
				xRet := iif(empty(stod(cCpoAnt)),ctod(cCpoAnt),stod(cCpoAnt))
			case  cTipo == 'N'
				xRet := VAL(cCpoAnt)
			case  cTipo == 'C'
				xRet := ALLTRIM(cValtochar(cCpoAnt))
			case  cTipo == 'L'
				xRet := iif(upper(cCpoAnt)=='.F.',.f.,.t.)
			case  cTipo == 'M'
				xRet := ALLTRIM(cValtochar(cCpoAnt))
		endcase
		do case
			case  cTipo == 'D'
				xRet := iif(empty(stod(cCpoNow)),ctod(cCpoNow),stod(cCpoNow))
			case  cTipo == 'N'
				xRet := VAL(cCpoNow)
			case  cTipo == 'C'
				xRet += ','+ALLTRIM(cValtochar(cCpoNow))
			case  cTipo == 'L'
				xRet := iif(upper(cCpoNow)=='.F.',.f.,.t.)
			case  cTipo == 'M'
				xRet += ','+ALLTRIM(cValtochar(cCpoNow))
		endcase
	endif
endif
if cTipo$'M,C'
	xRet := UPPER(IIF(LEN(UPPER(xRet))==9,REPLACE(UPPER(xRet),'-',''),UPPER(xRet)))
	xRet := u_TIRACENTO(xRet)
ENDIF

Return(xRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVelhoarq  บAutor  ณLeandro Duarte      บ Data ณ  08/20/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para capturar o nome antigo da tabela                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function Velhoarq(cTipo)
Local aArea		:= UA1->(GETAREA())
Local cVersold	:= strzero(val(UA1->UA1_VERSAO)-1,4)
lOCAL cCod		:= UA1->UA1_COD
Local cRet		:= ""

UA1->(DBSETORDER(3))
// CADASTRO DE CLIENTE

if UA1->(DBSEEK(XFILIAL("UA1")+'1'+cTipo)) // FILIAL + ATIVO + ROTINA + COD + VERSAO
	if !UA1->(dbSeek( xFilial( "UA1" ) + cCod + cVersold ))
		cVersold	:= strzero(val(cVersold)-1,4)
		while !UA1->(dbSeek( xFilial( "UA1" ) + cCod + cVersold )) .and. cVersold>= '0000'
			cVersold	:= strzero(val(cVersold)-1,4)
		end
	endif
ENDIF
if EMPTY(UA1->UA1_COD)
	Restarea(aArea)
ENDIF
cRet := UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
Restarea(aArea)
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBUSCKIT   บAutor  ณLeandro Duarte      บ Data ณ  04/18/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para buscar se existe o Kit Cadastrado com esse idrefบฑฑ
ฑฑบ          ณe o skuid juntos                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BUSCKIT(cCodKit,cSkuId,cCodProm)
Local lExi	:= .F.
Local aArea	:= Getarea()
Local cKey	:= ""
Local lCur	:= .F.
Local lLivr	:= .F.
dbselectarea("UA3")
aDadKit := {}
UA3->(DbSetorder(1))
if UA3->(DbSeek(xFilial("UA3")+PADR(cCodKit,TAMSX3("UA3_CODKIT")[1])+PADR(cSkuId,TAMSX3("UA3_SKUID")[1])))
	cKey	:= xFilial("UA3")+PADR(cCodKit,TAMSX3("UA3_CODKIT")[1])+PADR(cSkuId,TAMSX3("UA3_SKUID")[1])
	lExi	:= .T.
	while cKey == UA3->UA3_FILIAL+UA3->UA3_CODKIT+UA3->UA3_SKUID .and. UA3->(!EOF())
		if UA3->UA3_GANHLI == '1' .AND. cCodProm $ UA3->UA3_CODGAN
			aadd(aDadKit,{UA3->UA3_ITEM, UA3->UA3_PRODUT, POSICIONE("SB1",1,XFILIAL("SB1")+UA3->UA3_PRODUT,"B1_XTIPO"), UA3->UA3_VALOR,0})
		ELSEIF !(UA3->UA3_PERDLI == '1' .AND. cCodProm $ UA3->UA3_CODPER) .or. empty(cCodProm)// DIFERENวA DA NEGAวรO DE QUANDO ACHAR O CODIGO DA PROMOวรO QUE PERDE O LIVRO
			aadd(aDadKit,{UA3->UA3_ITEM, UA3->UA3_PRODUT, POSICIONE("SB1",1,XFILIAL("SB1")+UA3->UA3_PRODUT,"B1_XTIPO"), UA3->UA3_VALOR,0})
		ENDIF
		if SB1->B1_XTIPO== '1'
			lLivr := .t.
		ELSE
			lCur := .t.
		ENDIF
		UA3->(DBSKIP())
	END
ENDIF
IF lLivr .AND. lCur
	lTemCurLiv := .T.
ELSE
	lTemCurLiv := .F.
ENDIF
RestArea(aArea)
Return(lExi)
