#include "protheus.ch" 
//#Include 'ISAMQry.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460IREN  ºAutor  ³LEANDRO DUARTE      º Data ³  10/28/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA ATRIBUIR O CAMPO TID DO CARTÃO DE CREDITO PARA  º±±
±±º          ³A BAIXA DO CARTÃO DE CREDITO                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M460IREN'()
Local IRRF	:= paramixb
Local aArea	:= SC5->(GETAREA())
IF SC5->(DBSeek(xFilial("SC5")+SE1->E1_PEDIDO)) .AND. !EMPTY(SC5->C5_PGVTTID)
	SE1->E1_PGVTTID	:= SC5->C5_PGVTTID
	SE1->E1_NOSSVTX	:= SC5->C5_NOSSONU
ENDIF

IF SC5->(DBSeek(xFilial("SC5")+SE1->E1_PEDIDO)) .AND. !EMPTY(SC5->C5_XNSUTEF)
	SE1->E1_NSUTEF 	:= SC5->C5_XNSUTEF
ENDIF



RESTAREA(aArea)
RETURN(IRRF)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³libVtex   ºAutor  ³Leandro Duarte      º Data ³  11/17/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para liberar por completo o pedido da Vtex para o pesº±±
±±º          ³soal do site da manole efetuar os processos                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function libVtex(cIdPedido,cNF)
//Alteracao em 02/05/2018
//Local cUrlOrder := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/invoice/?an=manole"
//Local cUrlInVcd := "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/?an=manole&f_status=invoiced"
Local cUrlOrder := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/invoice/?an=manole"
Local cUrlInVcd := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/?an=manole&f_status=invoiced"
local oxml
Local aHeadOut := {}
Local cHeadRet := ""
Local sPostRet := ""
Local cParam   := ""
local UserCode := "vtexappkey-manole-UMVGHE"
local PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
local Lxml := .f.
Local cDataFat	:= dtos(ddatabase)
Local cDtFat	:= dtos(ddatabase)
Local cHora		:= time()
Local nVlTot	:= 0
Local cRastreio	:= ""
Local cDanf		:= ""
lOCAL cURL		:= "http://sro.micropost.com.br/consulta.php?objetos="
Private _cFilant := "  "

if !empty(cIdPedido)

	_cFilant := alltrim(MNSTVCE->C5_FILIAL)

	//Edmar Mendes do Prado
	//09/10/2018
	//Procura o número do pedido pela SC6 mas tem item que não tem gravado o numero do pedido

	conout("LibVtex - 001 "+alltrim(MNSTVCE->C6_NOTA)+" do pedido da Vtex "+alltrim(MNSTVCE->C5_VTEX)+ " da Filial "+alltrim(MNSTVCE->C5_FILIAL))
	
	SC6->(DBORDERNICKNAME("VTEX"))
	lAchou := .F.
	//lAchou := SC6->(DBSEEK(XFILIAL("SC6")+PADR(cIdPedido,TAMSX3("C6_VTEX")[1]) ) )	
	lAchou := SC6->(DBSEEK(_cFilant+PADR(cIdPedido,TAMSX3("C6_VTEX")[1]) ) )
			  
	If lAchou
		While PADR(cIdPedido,TAMSX3("C6_VTEX")[1]) == SC6->C6_VTEX .AND. SC6->(!eof())
		//conout("LibVtex - 002 ")
			//Edmar - atualizar status de pedidos de serviço no site
			If !Empty(SC6->C6_NOTA)
				conout("LibVtex - 003 ")
				If Alltrim(SC6->C6_SERIE) = 'A' .And. dtos(SC6->C6_DATFAT) >= '20180101' .Or. Alltrim(SC6->C6_SERIE) = 'B' .And. dtos(SC6->C6_DATFAT) >= '20180101'
					//conout("LibVtex - 004 ")
					cDanf := posicione("SF2",1,_cFilant+SC6->C6_NOTA+SC6->C6_SERIE,"F2_NFELETR")
					//cDanf := posicione("SF2",1,xFilial("SF2")+SC6->C6_NOTA+SC6->C6_SERIE,"F2_NFELETR")
				Else
					cDanf := posicione("SF2",1,_cFilant+SC6->C6_NOTA+SC6->C6_SERIE,"F2_CHVNFE")
					//conout("LibVtex - 005 ")
					//cDanf := posicione("SF2",1,xFilial("SF2")+SC6->C6_NOTA+SC6->C6_SERIE,"F2_CHVNFE")
				EndIf
				//conout("LibVtex - 006 ")
			EndIf

			cDataFat	:= dtos(SC6->C6_DATFAT)
			nVlTot		+= SC6->C6_VALOR
			SC6->(DBSKIP())
		
		End

		if empty(cDanf)
			conout("LibVtex - 002 "+alltrim(MNSTVCE->C6_NOTA)+" do pedido da Vtex "+alltrim(MNSTVCE->C5_VTEX))
			return()
		endif
			
	EndIf
	
	/*
	Else
	
	lAchou := .F.
	SC5->(DBORDERNICKNAME("VTEX"))
	lAchou := SC5->(DBSEEK(XFILIAL("SC5")+PADR(cIdPedido,TAMSX3("C5_VTEX")[1]) ) )
	
		If lAchou
			//WHILE SC5->(!EOF()) .AND. ALLTRIM(SC5->C5_VTEX) == ALLTRIM(cIdPedido)
					//Edmar - atualizar status de pedidos de serviço no site
					If !Empty(SC5->C5_NOTA)
						
						//Edmar Mendes do prado
						//Inserido em 08/10/2018 para atualizar status no site
							
							If Alltrim(SC5->C5_SERIE) = 'A' .And. dtos(SC5->C5_EMISSAO) >= '20180101'
								cDanf := posicione("SF2",1,xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE,"F2_NFELETR")
							Else
								cDanf := posicione("SF2",1,xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE,"F2_CHVNFE")
							EndIf
						
						//EndIf
						
					EndIf
		
					//cDtFat		:= Posicione("SC6",4,xFilial("SC6")+SC5->C5_NOTA+SC5->C5_SERIE,"SC6->C6_DATFAT")
					cDtFat		:= Posicione("SF2",1,xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE,"SF2->F2_EMISSAO")
					cDataFat	:= dtos(cDtFat)
					//nVlTot		+= Posicione("SC6",4,xFilial("SC6")+SC5->C5_NOTA+SC5->C5_SERIE,"SC6->C6_VALOR")
					nVlTot		+= Posicione("SF2",1,xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE,"SF2->F2_VALMERC")
					//ENDIF
				//SC5->(DBSKIP())
			//END
	
			if empty(cDanf)
				return()
			endif		
	
		Else
			conout("LibVtex - 003 Pedido não encontrado no SC5 e SC6: "+alltrim(MNSTVCE->C5_VTEX))
		ENDIF
	ENDIF
	*/
	
	SC5->(DBORDERNICKNAME("VTEX"))
	//IF SC5->(DBSEEK(XFILIAL("SC5")+PADR(cIdPedido,TAMSX3("C5_VTEX")[1]) ) )
		IF SC5->(DBSEEK(_cFilant+PADR(cIdPedido,TAMSX3("C5_VTEX")[1]) ) )
		WHILE SC5->(!EOF()) .AND. ALLTRIM(SC5->C5_VTEX) == ALLTRIM(cIdPedido)
		//conout("LibVtex - 007 ")
			cRastreio	:= ALLTRIM(SC5->C5_OBJETO)
			cURL		+= cRastreio
			nVlTot		+= SC5->C5_FRETE
			SC5->(DBSKIP())
		END
	ENDIF
	nVlTot *= 100
	//conout("LibVtex - 008 ")
	cDataFat := substr(cDataFat,1,4)+'-'+substr(cDataFat,5,2)+'-'+substr(cDataFat,7,2)+'T'+cHora
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da URL para o HTTPPost                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
	aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aadd(aHeadOut,'Content-Type: application/json')

	sPostRet := HttpGET(cUrlInVcd,cParam,12000,aHeadOut,@cHeadRet)
				
	sPostRet := StrTran(sPostRet, "\n", " ")
	sPostRet := StrTran(sPostRet, '"":', '"ErroJson":')
				
	sPostRet := DecodeUtf8(sPostRet)
	Lxml := FWJsonDeserialize(sPostRet,@oxml)

	if Lxml
		cParam := '{ '
		cParam += '          "type": "Output",'
		cParam += '          "invoiceNumber": "'+cNF+'", '
		cParam += '          "courier": "", '
		cParam += '          "trackingNumber": "'+cRastreio+'", '
		cParam += '          "trackingUrl": "'+cURL+'", '
		cParam += '          "invoiceKey": "'+cDanf+'", '
		cParam += '          "issuanceDate":"'+substr(cDataFat,1,19)+'", '
		cParam += '          "invoiceValue":'+cvaltochar(nVlTot)+' '
		cParam += '      }'
		sPostRet := HttpPOST(cUrlOrder,"",cParam ,,aHeadOut)
		Lxml := FWJsonDeserialize(sPostRet,@oxml)

		if Lxml
			SC5->(DBORDERNICKNAME("VTEX"))
			lSeek	:= 	!SC5->(DBSEEK(_cFilant+PADR(cIdPedido,TAMSX3("C5_VTEX")[1]) ) )
			IF ALLTRIM(SC5->C5_TRANSP)$'08,191,0100'
		//	conout("LibVtex - 009 ")
				IF !EMPTY(cRastreio)
					WHILE SC5->(!EOF()) .AND. ALLTRIM(SC5->C5_VTEX) == ALLTRIM(cIdPedido)
						reclock("SC5",.f.)
						SC5->C5_INVOICE		:= "1" // TRANSFERIU PARA INVOICE 1=SIM;2NAO
		//				conout("LibVtex - 010 ")
						MSUNLOCK()
						SC5->(DBSKIP())
					END
				ENDIF
			ELSE
				SC5->(DBORDERNICKNAME("VTEX"))
				lSeek	:= 	!SC5->(DBSEEK(_cFilant+PADR(cIdPedido,TAMSX3("C5_VTEX")[1]) ) )
				reclock("SC5",.f.)
				SC5->C5_INVOICE		:= "1" // TRANSFERIU PARA INVOICE 1=SIM;2NAO
		//		conout("LibVtex - 011 ")
				MSUNLOCK()
			ENDIF
			//Edmar Mendes do Prado
			//conout('Nota processada: '+cNF+' Pedido processado: '+cIdPedido+' Invoiced: '+SC5->C5_INVOICE)
			  conout('Nota processada: '+cNF+' Pedido processado: '+cIdPedido+' Invoiced: '+SC5->C5_INVOICE+' Filial processada: '+_cFilant)
		endif
	endif
//conout("LibVtex - 012 ")
EndIf

Return
