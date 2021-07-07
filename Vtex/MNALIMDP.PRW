#include "Protheus.ch"
#Include 'parmtype.ch'
#Include 'RestFul.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNALIMDP  ºAutor  ³Leandro Duarte      º Data ³  08/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para alimentar as tabelas DEPARA                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MNALIMDP(aNomeTab)
//Local cUrl := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/?an=manole&f_status=ready-for-handling"
Local cUrl := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/?an=manole&f_status=ready-for-handling"
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
Local cXmlEMP := ""
Local LxmlPed := .f.
LOCAL _cUrlOrder := ""
local _cDataPed := ""
Local oXMLLIST
Local nFor1		:= 0
Local nFor2		:= 0
Local nForKit	:= 0
Local I			:= 0
Local cCupon	:= ""
Local cEndereco := ""
Local cCGCExt	:= .F.
Local cTipo     := ""
Local cTP     := ""

Local cNum001	:="MZN-701-4413518-8577030"
//"1051502523693-01"
//"1037151541784-01" 
//"1035550654396-01/1035553408070-01/1035553032770-01/1035553032770-01"
//"SKY-Lojas_Americanas-274644931101/"
//"1029503392855-01/1029503424326-01/1029511998019-01"
//"1024840932156-01   "
//"1023700848501-01"//"1021563335208-01/1021562922646-01/1021562922646-01/1021592992500-01/1021602850463-01/1021601987573-01/1021591435474-01/1021590264324-01/1021591110541-01"

Local cNum002	:= "SKY-"
Local cNum003	:= ""
Local cNum004 	:= ""
Local cNumSKY	:= "SKY-"

private cParam   := ""
private UserCode := "vtexappkey-manole-UMVGHE"
private PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
private aHeadOut := {}
private oXMLped
Private lWin 	:= file('c:\windows')
Private cArqPd := iif(lWin,"\imp_vtex\","/imp_vtex/")
Private aDadKit	:= {}
Private _X		:= 0
Private aValorOrig := {}
Private lTemCurLiv	:= .F.
Private lBANCO	:= GETNEWPAR("MV_VTEXBC",.F.)// ROTINA PARA SABER SE GRAVA OS DE-PARA EM BANCO OU LOCAL
Private aDados	:= {}


//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')
//<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

// COMUNICA COM O WEBSERVICE
sPostRet := HttpGET(cUrl,cParam,12000,aHeadOut,@cHeadRet)

lXml := FWJsonDeserialize(sPostRet,@oxml)

//SE HOUVEREM PEDIDOS A SEREM PROCESSADOS
if lXml
	oXmlList := oxml:LIST
	if Len(oXmlList) > 0
		For I := 1 to Len(oXmlList)
			cNumPed	:= oXmlList[I]:OrderId
			//cUrlPed := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cNumPed+"/?an=manole"
			
			//Edmar Mendes do Prado
			//03/08/2018
			conout('Numero de Pedido a Processar: '+cNumPed)
			
			cNumped := "1122081380356-01"
			If cNumPed $ cNum001 // .Or. (cNumPed $ Alltrim(cNum002)) .Or. (cNumPed $ Alltrim(cNum003))  .Or. (cNumPed $ Alltrim(cNum004)))
				conout('Pedido LOOP em CNUM001: '+cNumPed)
				Loop
			EndIf
			/*
			If cNum002 $ cNumPed
				conout('Pedido LOOP em CNUM002: '+cNumPed)
				Loop
			EndIf
			*/

				cUrlPed := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cNumPed+"/?an=manole"
				//cUrlPed := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cNumPed+"/?an=manole"
				cXmlPed := HttpGET(cUrlPed,cParam,12000,aHeadOut,@cHeadRet)
				
			//	cXmlPed := StrTran(cXmlPed, "\n", " ")
			//	cXmlPed := StrTran(cXmlPed, '"":', '"ErroJson":')
				
				cXmlPed := DecodeUtf8(cXmlPed)
				//cXmlPed := OemToAnsi(cXmlPed)	
				//cXmlPed := DecodeUtf8(cXmlPed)
				//cXmlPed := DecodeUtf8(EncodeUtf8(cXmlPed))			
				//retirado em 08/10/2018/ conout('cXmlPed'+cXmlPed)
				//cXmlEMP := u_Limpar(Alltrim(cXmlPed))
			//	conout('cXmlEMP'+cXmlEMP)
				//			lXmlPed := FWJsonDeserialize(cXmlEMP,@oXMLped)
				
				lXmlPed := FWJsonDeserialize(cXmlPed,@oXMLped)
											
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³analisa se deve gravar os dados na tabela de Cliente, para saber se ja existe a estrutura da tabela DEPARA de cliente³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nScan:= aScan(aNomeTab,{|x| x[1] == '1' })
			if nScan > 0 
				aDados := {}
				if lBanco
					aCpos	:= Extrut(aNomeTab[nScan][2])
					if u_listbl(aNomeTab[nScan][2],0,"TRBCLI",{})// verifica se a tabela existe
						xRet := ascan(aCpos,{|x| alltrim(x[2]) == "A1_CGC" })
						if xRet <= 0
							conout("tabela de Cliente não existe o campo A1_CGC ")
							return()
						endif
					else // caso não existe cria
						u_listbl(aNomeTab[nScan][2],4,"TRBCLI",aCpos)// verifica se a tabela existe
						xRet := ascan(aCpos,{|x| alltrim(x[2]) == "A1_CGC" })
						if xRet <= 0
							conout("tabela de Cliente não existe o campo A1_CGC ")
							return()
						endif
					endif
					xRet := ""
					For nFor1 := 1 TO LEN(aCpos)
						xRet := &("TRBCLI->"+aCpos[nFor1][2])
						&("TRBCLI->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
					Next nFor1
					if !lSeek
						TRBCLI->UXU_PROQUE := 0
					endif
					
					u_listbl(aNomeTab[nScan][2],6,"TRBCLI",aCpos,aDados)
					
				else
					if !(SELECT("TRBCLI") > 0)
						dbUseArea(.T.,,aNomeTab[nScan][2],"TRBCLI", .T., .F. )
						cIndCond := "A1_CGC"
						cArqNtx1 := CriaTrab(Nil, .F.)
						IndRegua("TRBCLI",cArqNtx1,cIndCond,,,"Selecionando Registros...")
						dbselectarea("TRBCLI")
						dbSetIndex(cArqNtx1 + OrdBagExt())
					endif
					aCpos	:= Extrut(aNomeTab[nScan][2])
					xRet := ascan(aCpos,{|x| alltrim(x[2]) == "A1_CGC" })
					
					//Edmar 06/03/2019
					xRetMail := ascan(aCpos,{|x| alltrim(x[2]) == "A1_EMAIL" })
					
					if xRet > 0
						//Fernando Santos - 16/10/2018 - Clientes sem CPF
						If Type("OXMLPED:clientProfileData:corporateDocument") <> "U" .Or. Type("OXMLPED:clientProfileData:document")<> "U"
							lSeek := !TRBCLI->(dbseek( &(aCpos[xRet][1]) ))				
							Reclock("TRBCLI",lSeek)
						
						//Edmar 16/10 - Para baixar pedido para Portugal
						//ElseIf Alltrim(OXMLPED:clientProfileData:phone) == "914029085" .And. Alltrim(Upper(OXMLPED:clientProfileData:firstName)) == Upper("PEDRO")
						//	lSeek := !TRBCLI->(dbseek( &(aCpos[xRet][1]) )) 
						//	Reclock("TRBCLI",lSeek)
						Else
							//Reclock("TRBCLI",.T.)
							//lSeek := .T.
							cCGCExt := .T.
							conout('Cadastro de cliente ESTRANGEIRO: '+cNumPed)
							Loop	
						Endif	
					else
						Reclock("TRBCLI",.T.)
						lSeek := .T.
					endif
					xRet := ""
					For nFor1 := 1 TO LEN(aCpos)
					
						//Edmar Mendes do Prado
						//Verificar endereco a ser cadastrado para nao ficar duplicado
						If Alltrim(aCpos[nFor1][2]) == 'A1_END'
						
							//cEndereco	:= Limpar(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +" "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0) + " " + Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:COMPLEMENT))
							//cEndereco	:= EncodeUTF8(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +" "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0))
							//cEndereco	:= DecodeUTF8(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +" "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0))
							//cEndereco	:= OemToAnsi(FwNoAccent(Limpar(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +", "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0))))
							//cEndereco	:= FwNoAccent(Limpar(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +", "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0)))
							//cEndereco	:= u_Tiracento(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +", "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0))
							cEndereco	:= u_Tiracento(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +", "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0) + " " + Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:COMPLEMENT))
							
							
							xRet := &("TRBCLI->"+aCpos[nFor1][2])
							&("TRBCLI->"+aCpos[nFor1][2]) := Upper(cEndereco)
						
						ElseIf Alltrim(aCpos[nFor1][2]) == 'A1_ENDENT'

							//cEndereco	:= Limpar(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +" "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0) + " " + Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:COMPLEMENT))
							cEndereco	:= u_Tiracento(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +", "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0) + " " + Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:COMPLEMENT))
							
							xRet := &("TRBCLI->"+aCpos[nFor1][2])
							&("TRBCLI->"+aCpos[nFor1][2]) := Upper(cEndereco)

						ElseIf Alltrim(aCpos[nFor1][2]) == 'A1_ENDCOB'
						
							//cEndereco	:= Limpar(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +" "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0) + " " + Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:COMPLEMENT))
							cEndereco	:= u_Tiracento(Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:STREET) +", "+ cValToChar(OXMLPED:SHIPPINGDATA:ADDRESS:NUMBER,12,0) + " " + Alltrim(OXMLPED:SHIPPINGDATA:ADDRESS:COMPLEMENT))
							
							xRet := &("TRBCLI->"+aCpos[nFor1][2])
							&("TRBCLI->"+aCpos[nFor1][2]) := Upper(cEndereco)

						/*Edmar 11/03/2019
						
						ElseIf Alltrim(aCpos[nFor1][2]) == 'A1_CGC'
						
							If cCGCExt
								xRet := &("TRBCLI->"+aCpos[nFor1][2])
								&("TRBCLI->"+aCpos[nFor1][2]) := Upper("")							
							Else
								xRet := &("TRBCLI->"+aCpos[nFor1][2])
								&("TRBCLI->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
							EndIf
						*/													
						Else
											
							xRet := &("TRBCLI->"+aCpos[nFor1][2])
							&("TRBCLI->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
						
						EndIf
						
						
					Next nFor1
					if !lSeek
						TRBCLI->UXU_PROQUE := 0
					endif
					MsUnlock()
				endif
			
			endif
			//EDMAR 03/08/2018
			//EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³analisa se deve gravar os dados na tabela do Cabeçalho do Pedido,se ja existe a estrutura da tabela DEPARA de pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nScan:= aScan(aNomeTab,{|x| x[1] == '2' })
			if nScan > 0
				if !(SELECT("TRBPEDC")>0)
					//iif(SELECT("TRBPEDC")>0,TRBPEDC->(DbCloseArea()),nil)
					DbUseArea(.T.,,aNomeTab[nScan][2],"TRBPEDC", .T., .F. )
					cIndCond := "C5_VTEX"
					cArqNtx1 := CriaTrab(Nil, .F.)//SUBSTR(aNomeTab[nScan][2],1,7)+'1'
					IndRegua("TRBPEDC",cArqNtx1,cIndCond,,,"Selecionando Registros...")
					dbselectarea("TRBPEDC")
					dbSetIndex(cArqNtx1 + OrdBagExt())
				endif
				aCpos	:= Extrut(aNomeTab[nScan][2])
				xRet := ascan(aCpos,{|x| alltrim(x[2]) == "C5_VTEX" })
				if xRet > 0
					lSeek := !TRBPEDC->(dbseek( &(aCpos[xRet][1]) ))
					Reclock("TRBPEDC",lSeek)
				else
					Reclock("TRBPEDC",.T.)
					lSeek := .T.
				endif
				xRet := ""
				For nFor1 := 1 TO LEN(aCpos)
					if alltrim(aCpos[nFor1][2]) == 'C5_TRANSP'
						nXfor3 := nxFor4	:= 0
						
						//Edmar Mendes do Prado - 03/06/2019
						//Alteração de verificação para pedidos de integração SKY
						 
						If cNumSKY $ cNumPed
							AEVAL(OXMLPED:SHIPPINGDATA:LOGISTICSINFO,{|X| nXfor3+= 1, iif(alltrim(X:DELIVERYIDS[1]:dockId)$'1a87133',nxFor4 := nxFor3,nil)}) // SEDEX,CORREIOS - PAC,PAC,E-SEDEX
							
							if nxFor4 > 0
								&("TRBPEDC->"+aCpos[nFor1][2]) := POSICIONE("SA4",5,XFILIAL("SA4")+OXMLPED:SHIPPINGDATA:LOGISTICSINFO[nxFor4]:DELIVERYIDS[1]:DOCKID,"A4_COD")
							else
								&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
							endif
						Else
							//AEVAL(OXMLPED:SHIPPINGDATA:LOGISTICSINFO,{|X| nXfor3+= 1, iif(alltrim(X:DELIVERYIDS[1]:COURIERID)$'40436,41068,81019',nxFor4 := nxFor3,nil)}) // SEDEX,CORREIOS - PAC,PAC,E-SEDEX
							//Inclusao de nova transportadora - Alexandre Logistica 07/03/2018 - CODIGO 300
							AEVAL(OXMLPED:SHIPPINGDATA:LOGISTICSINFO,{|X| nXfor3+= 1, iif(alltrim(X:DELIVERYIDS[1]:COURIERID)$'40436,41068,81019,144BD84,1a87133,185f8bb',nxFor4 := nxFor3,nil)}) // SEDEX,CORREIOS - PAC,PAC,E-SEDEX

							if nxFor4 > 0
								&("TRBPEDC->"+aCpos[nFor1][2]) := POSICIONE("SA4",5,XFILIAL("SA4")+OXMLPED:SHIPPINGDATA:LOGISTICSINFO[nxFor4]:DELIVERYIDS[1]:COURIERID,"A4_COD")
							else
								&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
							endif
							
						EndIf
							
																		
					ELSEif alltrim(aCpos[nFor1][2]) == 'C5_ENDTREG'
						xRet := &("TRBPEDC->"+aCpos[nFor1][2])
						&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
					ELSE
						//&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
						// Alterado Edmar 05/03/2018
						If Empty(&("TRBPEDC->" + aCpos[nFor1][2])) .AND. aCpos[nFor1][2] == "C5_DTLANC"
							xRet := ddatabase
						Else
							&("TRBPEDC->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
						Endif
					ENDIF
				Next nFor1
				if !lSeek
					TRBPEDC->UXU_PROQUE := 0
				endif
				MsUnlock()
				//ferase(cArqNtx1 + OrdBagExt())
			endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³analisa se deve gravar os dados na tabela do Detalho do Pedido,se ja existe a estrutura da tabela DEPARA de Detalhe do Pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nScan:= aScan(aNomeTab,{|x| x[1] == '3' })
			if nScan > 0
				if !(SELECT("TRBPEDD")>0)
					//iif(SELECT("TRBPEDD")>0,TRBPEDD->(DbCloseArea()),nil)
					DbUseArea(.T.,,aNomeTab[nScan][2],"TRBPEDD", .T., .F. )
					cIndCond := "C6_VTEX+C6_PRDVTEX+C6_KITVTEX"
					cArqNtx1 := CriaTrab(Nil, .F.)//SUBSTR(aNomeTab[nScan][2],1,7)+'2'
					IndRegua("TRBPEDD",cArqNtx1,cIndCond,,,"Selecionando Registros...")
					dbselectarea("TRBPEDD")
					dbSetIndex(cArqNtx1 + OrdBagExt())
				endif
				aCpos	:= Extrut(aNomeTab[nScan][2])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³corre a quantidade de itens do pedido³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				for nFor2 := 1 TO LEN(oXMLped:ITEMS)
					_X := nFor2
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³CONDIÇÃO DE ANALISE SE EXISTE OU NÃO O PRODUTO³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					// regra para verificar se existe kit de vendas manole
					if type("OXMLPED:MARKETINGDATA:COUPON") <> "U"
						cCupon	:= alltrim(OXMLPED:MARKETINGDATA:COUPON)
					else
						cCupon	:= ""
					endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Regra para saber o produto é Brind, pois o campo oXMLped:ITEMS[_X]:ISGIFT ira vir verdadeiro³
					//³nesse caso o If Apresentado esta negado para que ele somente entra caso não for Brind e lá  ³
					//³em baixo faço o tratamento para esse produto brind trocando as informações necessarias      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if !oXMLped:ITEMS[_X]:ISGIFT
						if valtype(OXMLPED:ITEMS[_X]:SELLERSKU) <> 'U' .AND.  valtype(OXMLPED:ITEMS[_X]:PRODUCTID) <> 'U' .AND. BUSCKIT(OXMLPED:ITEMS[_X]:PRODUCTID,OXMLPED:ITEMS[_X]:SELLERSKU,cCupon) // FUNÇÃO DE BUSCA SE O KIT EXISTE
							conout('CAPTURADO O CUPON DE DESCONTO '+cCupon)
							lEntra := .T.
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
										&("TRBPEDD->"+aCpos[nFor1][2]) := STRZERO(iif(nForKit==1 .and. _X == 1,_X,iif(nForKit==1 .and.  _X > 1,_X,LEN(oXMLped:ITEMS)+nForKit+iif(_X>1.and. nForKit>1,0,-1))),2)// regra ara calcular o item correto
									ELSEif ALLTRIM(aCpos[nFor1][2]) == "C6_PRDVTEX"
										&("TRBPEDD->"+aCpos[nFor1][2]) := aDadKit[nForKit][2]
									ELSE
										if ALLTRIM(aCpos[nFor1][2]) == "C6_VALOR"
											aValorOrig[nForKit][2]	:= iif(nForKit>1,Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[nForKit][1],"B1_PRV1"),Valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1))
											nXvlTot	:= Valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
										ENDIF
										&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
									ENDIF
									
									//Edmar, 01/12/2017
									//Conout('MNALIMDP.PRW - 001 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
									
									If Alltrim(aCpos[nFor1][2]) == 'C6_DESCRI'
									//Conout('Entrei para verificar - MNALIMDP.PRW - 00101 ' )
										If Empty(Alltrim(aCpos[nFor1][2]) == 'C6_DESCRI')
											&("TRBPEDD->"+aCpos[nFor1][2]) := Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										EndIf
									EndIf
																		
									//If Empty(Alltrim(TRBPEDD->C6_DESCRI)) .OR. Empty(Alltrim(TRBPEDD->C6_UM))
									//	TRBPEDD->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
									//	TRBPEDD->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
									//EndIf
									//Conout('MNALIMDP.PRW - 002 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + Alltrim(aCpos[nFor1][2]) == 'C6_PRODUTO' + ' - ' + TRBPEDD->C6_DESCRI)
									
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
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³caso tenha valor na regra do KIT devera pegar o valor e esquecer o rateio³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									
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
										IF xRet6 > 0
											if upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
//												TRBPEDD->C6_TES			:= "530"
												TRBPEDD->C6_TES			:= "534"
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
										TRBPEDD->C6_DESCRI			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										

									//Edmar, 01/12/2017
									//Conout('MNALIMDP.PRW - 00301 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
									If Empty(Alltrim(TRBPEDD->C6_DESCRI)) .OR. Empty(Alltrim(TRBPEDD->C6_UM))
										TRBPEDD->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										TRBPEDD->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
									EndIf
									//Conout('MNALIMDP.PRW - 00401 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
										
									else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Caso não tenha valor do Kit deve pegar e efetuar o rateio do valor do produto³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									
									
									
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
												IF xRet6 > 0
													if upper(OXMLPED:PAYMENTDATA:TRANSACTIONS[1]:PAYMENTS[1]:GROUP) == 'BANKINVOICE'
//														TRBPEDD->C6_TES			:= "530"
														TRBPEDD->C6_TES			:= "534"														
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
													//TRBPEDD->C6_UM			:= SB1->B1_UM// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
													TRBPEDD->C6_UM			:= Posicione("SB1",1,XFILIAL("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
												ENDIF
											ENDIF
										endif
									endif
									
									//Edmar, 01/12/2017
									//Conout('MNALIMDP.PRW - 003 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
									If Empty(Alltrim(TRBPEDD->C6_DESCRI)) .OR. Empty(Alltrim(TRBPEDD->C6_UM))
										TRBPEDD->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										TRBPEDD->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
									EndIf
									//Conout('MNALIMDP.PRW - 004 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
								
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

									//Edmar, 01/12/2017
									//Conout('MNALIMDP.PRW - 003 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
									If Empty(Alltrim(TRBPEDD->C6_DESCRI)) .OR. Empty(Alltrim(TRBPEDD->C6_UM))
										TRBPEDD->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										TRBPEDD->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
									EndIf
									//Conout('MNALIMDP.PRW - 004 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)

								endif
								TRBPEDD->C6_UM				:= Posicione("SB1",1,XFILIAL("SB1")+Alltrim(TRBPEDD->C6_PRODUTO),"B1_UM")
								TRBPEDD->C6_DESCRI			:= Posicione("SB1",1,XFILIAL("SB1")+Alltrim(TRBPEDD->C6_PRODUTO),"B1_DESC")
								MsUnlock()
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Regra para colocar o pedido para PAC pois o mesmo possui um livro e esse processo conforme Alexandre passou deve ser colocada PAC na transportadora³
								//³Pois a Vtex não traz o tipo de Transportadora para os KITS                                                                                         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								if SB1->B1_XTIPO == '1'                                                                     
									Reclock("TRBPEDC",.F.)
									TRBPEDC->C5_TRANSP := '08' // codigo do PAC na tabela SA4
									MsUnlock()
								ENDIF
							Next nForKit
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ACERTANDO OS VALORES DOS KITS³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Asort(aValorOrig,,,{|x,y| x[2]>y[2]})
							For nXwq := 1 to len(aValorOrig)
								if nXwq == 1
									nXwqvl := aValorOrig[nXwq][2]
								else
									nXwqvl -= aValorOrig[nXwq][2]
								endif
							next nXwq

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Regra de valores Negativo³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
//LUIS
								nXvlTot2 := 0
								nTotDiv  := 0
								nTotDiv1 := 0
								nTotDiv2 := 0
								nTotDesc1 := 0
								nTotDesc2 := 0
								nDescInd1 := 0
								nDescInd2 := 0
								nTotOrig1 := 0
								nTotOrig2 := 0
								nXvlTot2 := nXvlTot	
								nXTotTab := 0
								nxTottab1 := 0
								nxtottab2 := 0


								for Ix := 1 to len(aValorOrig)
									    nXTotTab += Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1")
								next Ix
									
								nTotDsc := nXTotTab - nXvlTot

									for Ix := 1 to len(aValorOrig)
									IF aValorOrig[ix][4] == '1'
									    	nTotDiv1 += 1
								    else
									        nTotDiv2 += 1
									endif
									nTotDiv += 1
									next Ix


								nDescInd   := nTotDsc / nTotDiv

								nTotdesc1  := (nDescInd * nTotDiv1)
								nTotdesc2  := (nDescInd * nTotDiv2)

								nTotdesc1  := nTotDesc1 +(nTotDesc1*8/100)
								nTotDesc2  := nTotDsc - nTotDesc1

								nDescInd1  := nTotDesc1 / nTotDiv1
								nDescInd2  := ntotDesc2 / nTotDiv2


								for Ix := 1 to len(aValorOrig)
									IF aValorOrig[ix][4] == '1'
									    nXvlTot2 := nXvlTot2 - Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1")
									ENDIF
								next Ix



									for Ix := 1 to len(aValorOrig)
										IF aValorOrig[ix][4] <> '1'
									    	nTotDiv += 1
										ENDIF
									next Ix
									nXVlCur := nXvlTot2 / nTotDiv
								
								
								
								for Ix := 1 to len(aValorOrig)
/*
									if (!lTemCurLiv .and. aValorOrig[Ix][4]== '1') .or. (lTemCurLiv .and. aValorOrig[Ix][4]== '2')
										lSeek := !TRBPEDD->(dbseek( aValorOrig[ix][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
										Reclock("TRBPEDD",lSeek)
										TRBPEDD->C6_PRCVEN		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") -nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										TRBPEDD->C6_VALOR		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") -nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										TRBPEDD->C6_PRUNIT		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") -nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
										Msunlock()
									ENDIF	
*/
								IF nTotDsc <= nXvlTot
									if aValorOrig[Ix][4]== '1'
										lSeek := !TRBPEDD->(dbseek( aValorOrig[ix][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
										Reclock("TRBPEDD",lSeek)
										  TRBPEDD->C6_PRCVEN		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") 
										  TRBPEDD->C6_VALOR		    := Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") 
										  TRBPEDD->C6_PRUNIT		:= Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") 
										Msunlock()
									ELSEIF	aValorOrig[Ix][4]<> '1'
									lSeek := !TRBPEDD->(dbseek( aValorOrig[ix][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
										Reclock("TRBPEDD",lSeek)
										  TRBPEDD->C6_PRCVEN		:= nXVlCur 
										  TRBPEDD->C6_VALOR		    := nXVlCur 
										  TRBPEDD->C6_PRUNIT		:= nXVlCur 
										Msunlock()
									ENDIF
								ELSE
									if aValorOrig[Ix][4] == '1'
										lSeek := !TRBPEDD->(dbseek( aValorOrig[ix][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
										Reclock("TRBPEDD",lSeek)
										  TRBPEDD->C6_PRCVEN		:= nXvlTot  * (Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") / nXTotTab)
										  TRBPEDD->C6_VALOR		    := nXvlTot  * (Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") / nXTotTab)
										  TRBPEDD->C6_PRUNIT		:= nXvlTot  * (Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") / nXTotTab)
										Msunlock()
									ELSEIF	aValorOrig[Ix][4] <> '1'
									lSeek := !TRBPEDD->(dbseek( aValorOrig[ix][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
										Reclock("TRBPEDD",lSeek)
										  TRBPEDD->C6_PRCVEN		:= nXvlTot  * (Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") / nXTotTab)
										  TRBPEDD->C6_VALOR		    := nXvlTot  * (Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") / nXTotTab)
										  TRBPEDD->C6_PRUNIT		:= nXvlTot  * (Posicione("SB1",1,XFILIAL("SB1")+aValorOrig[ix][1],"B1_PRV1") / nXTotTab)
										Msunlock()
								ENDIF

								
								ENDIF								
								next Ix

							elseif len(aValorOrig)>0 .and. ascan(aDadKit,{|x| x[4] <= 0 }) > 0
								lSeek := !TRBPEDD->(dbseek( aValorOrig[1][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
								Reclock("TRBPEDD",lSeek)
								TRBPEDD->C6_PRCVEN		:= nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
								TRBPEDD->C6_VALOR		:= nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
								TRBPEDD->C6_PRUNIT		:= nXwqvl// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
								Msunlock()
								for Ix := 2 to len(aValorOrig) 
									lSeek := !TRBPEDD->(dbseek( aValorOrig[ix][3] )) // O CAMPO "S" NO FINAL REPRESENTA QUE O ITEM DESSE PEDIDO FOI CRIADO PELO KIT
									Reclock("TRBPEDD",lSeek)
									TRBPEDD->C6_PRCVEN		:= aValorOrig[ix][2]// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
									TRBPEDD->C6_VALOR		:= aValorOrig[ix][2]// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
									TRBPEDD->C6_PRUNIT		:= aValorOrig[ix][2]// CALCULO PARA REDUZIR CASO TENHA MAIS DE UM LIVRO NESSE CURSO REDUZIREI EM 10 CENTAVOS PARA CADA LIVRO EXISTENTE NO KIT
									Msunlock()	
								next Ix
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
							
									//Edmar, 01/12/2017
									//Conout('MNALIMDP.PRW - 005 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
									If Empty(Alltrim(TRBPEDD->C6_DESCRI)) .OR. Empty(Alltrim(TRBPEDD->C6_UM))
										TRBPEDD->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										TRBPEDD->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
									EndIf
									//Conout('MNALIMDP.PRW - 006 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)

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
							
									//Edmar, 01/12/2017
									//Conout('MNALIMDP.PRW - 007 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
									If Empty(Alltrim(TRBPEDD->C6_DESCRI)) .OR. Empty(Alltrim(TRBPEDD->C6_UM))
										TRBPEDD->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_DESC")
										TRBPEDD->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+TRBPEDD->C6_PRODUTO,"B1_UM")
									EndIf
									//Conout('MNALIMDP.PRW - 008 - Verifica descrição do Produto: ' +  TRBPEDD->C6_VTEX + ' - ' + TRBPEDD->C6_PRODUTO + ' - ' + TRBPEDD->C6_DESCRI)
							
								TRBPEDD->UXU_PROQUE := 0
							endif
							MsUnlock()
						ELSE
							xRet 	:= ascan(aCpos,{|x| alltrim(x[2]) == "C6_VTEX" })
							xRet1 	:= ascan(aCpos,{|x| alltrim(x[2]) == "C6_PRDVTEX" })
							cVTex	:= &(aCpos[xRet][1])
							cLogFile := cArqPd+cNomArq+".log"					//função que retorna as informações de erro ocorridos durante o processo da rotina automática
							If !File(cLogFile)
								If (nHandle := MSFCreate(cLogFile,0)) <> -1
									FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido não possui CODIGO EAN cadastrado no Site da VTEX: "+CRLF)
									FCLOSE(nHandle)
								EndIf
							Else
								If (nHandle := FOpen(cLogFile,2)) <> -1
									FSeek(nHandle,0,2)
									FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido não possui CODIGO EAN cadastrado no Site da VTEX: "+CRLF)
									FCLOSE(nHandle)
								EndIf
							EndIf
						endif
					else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Traamento quando a opção oXMLped:ITEMS[_X]:ISGIFT, for brind³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
								else
									&("TRBPEDD->"+aCpos[nFor1][2]) := valtxp(xRet,&(aCpos[nFor1][1]),aCpos[nFor1][3],aCpos[nFor1][2],nFor1)
								endif
							Next nFor1
							
							MsUnlock()
						endif
					endif
				next nFor2
				//iif(SELECT("TRBPEDD")>0,TRBPEDD->(DbCloseArea()),nil)
				//ferase(cArqNtx1 + OrdBagExt())
			endif
			//iif(SELECT("TRBPEDC")>0,TRBPEDC->(DbCloseArea()),nil)
		next I
	endif
endif
/*
///////////////
				_totped := 0
				_totitem := 0
				_difped := 0
				_arat   := 0

					dbselectarea("TRBPEDD")
					dbSetIndex(cArqNtx1 + OrdBagExt())
					 while !eof().and.TRBPEDD->C6_VTEX == OXMLPED:ORDERID
						_totped  += TRBPEDD->C6_VALOR
						_totitem += 1
					dbskip()
					enddo

					if _totped < OXMLPED:VALUE
					   _difped:= OXMLPED:VALUE - _totped
					   _arat  := _difped/_totitem
					endif
					
					if _arat > 0
					   dbselectarea("TRBPEDD")
					   dbSetIndex(cArqNtx1 + OrdBagExt())
					     while !eof()
						   reclock("TRBPEDD",.F.)
						     TRBPEDD->C6_VALOR -= _arat
						   msunlock()
						 dbskip()
						 enddo
				    endif


//////////
*/
RETURN()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNALIMDP  ºAutor  ³Microsiga           º Data ³  08/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALTXP    ºAutor  ³Leandro Duarte      º Data ³  08/28/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³valida os dados para não dar erro de mismach                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function valtxp(cCpoAnt, cCpoNow, cTipo, cCpo, nVt)
Local xRet	:= nil
Local aRet	:= aClone(aCpos)
Local xOpc	:= ascan(aRet,{|z| z[2] == cCpo })
default cCpoAnt := ""
default cCpoNow := ""
if valtype(cCpoNow) == "U"
	cCpoNow := ""
ENDIF
adel(aRet,xOpc)
asize(aRet,len(aRet)-1)
xOpc	:= ascan(aRet,{|z| z[2] == cCpo })
if xOpc == 0
	cCpoAnt	:= ""
endif
if !empty(cCpoNow) .and. !empty(cCpoAnt) .and. iif(cTipo=='C',cCpoNow $ cCpoAnt,.T.) // ja existe o endereço informado no endereço cadastrado
	xRet := cCpoAnt
else
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
endif
Return(xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TIRACENTO ºAutor  ³LEANDRO dUARTE      º Data ³  12/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RETIRA OS ACENTOS DA VARIAVEL                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user FUNCTION TIRACENTO(_cVar)
Local _nPos := 0
Local _cnt := 0
Local _xcVar := ""
If Empty(_cVar)
	_cVar:=" "
	Return(_cVar)
Endif
if DecodeUTF8(_cVar)!=nil
	_xcVar := DecodeUTF8(_cVar)
endif
if len(_xcVar) > 0
	_cVar	:= _xcVar
endif
//_cVar := alltrim(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(_cVar,"Ã©","E"),"A§","C"),"A´","O"),"Ã‰","E"),"ƒ",''))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Matriz de codigos ASCII para procura de posicao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aAce := { ASC("á"),ASC("Á"),ASC("ã"),ASC("Ã"),ASC("ä"),ASC("Ä"),ASC("à"),ASC("À"),ASC("é"),ASC("É"),ASC("ë"),ASC("Ë"),ASC("è"),ASC("È"),ASC("í"),ASC("Í"),ASC("ï"),ASC("Ï"),ASC("ì"),ASC("Ì"),ASC("ó"),ASC("Ó"),ASC("õ"),ASC("Õ"),ASC("ö"),ASC("Ö"),;
ASC("ò"),ASC("Ò"),ASC("ú"),ASC("Ú"),ASC("ü"),ASC("Ü"),ASC("ù"),ASC("Ù"),ASC("ç"),ASC("Ç"),ASC("â"),ASC("ê"),ASC("î"),ASC("ô"),ASC("û"),ASC("Â"),ASC("Ê"),ASC("Î"),ASC("Ô"),ASC("Û"),ASC("ÿ"),ASC("ª"),ASC("º")}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Matriz de caracteres que serao trocados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aSac := { "a","A","a","A","a","A","a","A","e","E","e","E","e","E","i","I","i","I","i","I","o","O","o","O","o","O","o","O","u","U","u","U","u","U","c","C","a","e","i","o","u","A","E","I","O","U","Y","a","o"}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Matriz ASCII referentes aos acentuos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aMat := { "á","Á","ã","Ã","ä","Ä","à","À","é","É","ë","Ë","è","È","í","Í","ï","Ï","ì","Ì","ó","Ó","õ","Õ","ö","Ö","ò","Ò","ú","Ú","ü","Ü","ù","Ù","ç","Ç","â","ê","î","ô","û","Â","Ê","Î","Ô","Û","ÿ","ª","º"}

_cnt := 0
_nPos:=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Laco para verificar todas as posicoes da string ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _cnt := 1 to len(_cVar)
	
	_nPos := ascan(_aAce, ASC(substr(_cVar,_cnt,1)))	    // Identifica posicao
	
	If !_nPos==0
		_cVar:=replace(_cVar,_aMAT[_nPos],_aSac[_nPos])	// Faz a troca
	Endif
	
Next _cnt


_cVar:= replace(_cVar,"'","")
_cVar:= replace(_cVar,"`","")
_cVar:= replace(_cVar,"~","")
_cVar:= replace(_cVar,'"','')
_cVar:=Upper(_cVar)

if DecodeUTF8(_cVar)!=nil
	_xcVar := DecodeUTF8(_cVar)
endif
if len(_xcVar) > 0
	_cVar	:= _xcVar
endif

Return(_cVar)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCKIT   ºAutor  ³Leandro Duarte      º Data ³  04/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para buscar se existe o Kit Cadastrado com esse idrefº±±
±±º          ³e o skuid juntos                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BUSCKIT(cCodKit,cSkuId,cCodProm)
Local lExi	:= .F.
Local aArea	:= Getarea()
Local cKey	:= ""
dbselectarea("UA3")
aDadKit := {}
UA3->(DbSetorder(1))
if UA3->(DbSeek(xFilial("UA3")+PADR(cCodKit,TAMSX3("UA3_CODKIT")[1])+PADR(cSkuId,TAMSX3("UA3_SKUID")[1])))
	cKey	:= xFilial("UA3")+PADR(cCodKit,TAMSX3("UA3_CODKIT")[1])+PADR(cSkuId,TAMSX3("UA3_SKUID")[1])
	lExi	:= .T.
	while cKey == UA3->UA3_FILIAL+UA3->UA3_CODKIT+UA3->UA3_SKUID .and. UA3->(!EOF())
		if UA3->UA3_GANHLI == '1' .AND. cCodProm $ UA3->UA3_CODGAN // atribui os PRODUTOS QUE SOMENTE POSSUI CUPON DE GANHA DE LIVRO OU CURSO
			aadd(aDadKit,{UA3->UA3_ITEM, UA3->UA3_PRODUT, POSICIONE("SB1",1,XFILIAL("SB1")+UA3->UA3_PRODUT,"B1_XTIPO"),UA3->UA3_VALOR,0})
		ELSEIF !(UA3->UA3_PERDLI == '1' .AND. cCodProm $ UA3->UA3_CODPER) .or. empty(cCodProm)// APRESENTA OS LIVROS E OS CURSOS QUE NÃO POSSUI BLOQUEIOS
			aadd(aDadKit,{UA3->UA3_ITEM, UA3->UA3_PRODUT, POSICIONE("SB1",1,XFILIAL("SB1")+UA3->UA3_PRODUT,"B1_XTIPO"),UA3->UA3_VALOR,0})
		ENDIF
		UA3->(DBSKIP())
	END
ENDIF
RestArea(aArea)
Return(lExi)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Limpar ºAutor  ³Edmar Mendes do Pradoº Data ³  10/05/2018   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retira os caracteres especiais                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Manole                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Limpar(cTxt)

Local cRet := ""
Local nX := 0

For nX := 1 To Len(cTxt)
	If SubStr(cTxt,nX,1) $ "ÃÁÂÀÇÉÊÈÍÎÌÓÕÔÒÚÛÙãáâàçéêèíîìóõôòúûù~%¨*£¢¬§ªº°®™©"
		If SubStr(cTxt,nX,1) == ","
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "'"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "~"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "/"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "\"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "-"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "Ã"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "Á"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "Â"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "À"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "Ç"
			cRet += "C"
		ElseIf SubStr(cTxt,nX,1) == "É"
			cRet += "E"
		ElseIf SubStr(cTxt,nX,1) == "Ê"
			cRet += "E"
		ElseIf SubStr(cTxt,nX,1) == "È"
			cRet += "E"
		ElseIf SubStr(cTxt,nX,1) == "Í"
			cRet += "I"
		ElseIf SubStr(cTxt,nX,1) == "Î"
			cRet += "I"
		ElseIf SubStr(cTxt,nX,1) == "Ì"
			cRet += "I"
		ElseIf SubStr(cTxt,nX,1) == "Ó"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "Õ"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "Ô"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "Ò"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "Ú"
			cRet += "U"
		ElseIf SubStr(cTxt,nX,1) == "Û"
			cRet += "U"
		ElseIf SubStr(cTxt,nX,1) == "Ù"
			cRet += "U"
		ElseIf SubStr(cTxt,nX,1) == "ã"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "á"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "â"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "à"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "ç"
			cRet += "C"
		ElseIf SubStr(cTxt,nX,1) == "é"
			cRet += "E"
		ElseIf SubStr(cTxt,nX,1) == "ê"
			cRet += "E"
		ElseIf SubStr(cTxt,nX,1) == "è"
			cRet += "E"
		ElseIf SubStr(cTxt,nX,1) == "í"
			cRet += "I"
		ElseIf SubStr(cTxt,nX,1) == "î"
			cRet += "I"
		ElseIf SubStr(cTxt,nX,1) == "ì"
			cRet += "I"
		ElseIf SubStr(cTxt,nX,1) == "ó"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "õ"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "ô"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "ò"
			cRet += "O"
		ElseIf SubStr(cTxt,nX,1) == "ú"
			cRet += "U"
		ElseIf SubStr(cTxt,nX,1) == "û"
			cRet += "U"
		ElseIf SubStr(cTxt,nX,1) == "ù"
			cRet += "U"
		ElseIf SubStr(cTxt,nX,1) == "@"
			cRet += "A"
		ElseIf SubStr(cTxt,nX,1) == "#"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "$"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "%"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "¨"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "&"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "*"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "("
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == ")"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "-"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "+"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "£"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "¢"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "¬"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "§"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "ª"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "º"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "{"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "}"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "?"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == ":"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == ">"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "<"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "°"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "®"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "™"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "©"
			cRet += " "
		ElseIf SubStr(cTxt,nX,1) == "©"
			cRet += " "									
		ElseIf SubStr(cTxt,nX,1) == " "
			cRet += " "									
		ElseIf SubStr(cTxt,nX,1) == " "
			cRet += " "									

		EndIf
	Else
		cRet += SubStr(cTxt,nX,1)
	EndIf
	
next nX

Return AllTrim(Upper(cRet))	
