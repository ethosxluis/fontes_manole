#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNSXB01   ºAutor  ³Leandro Duarte      º Data ³  08/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta do SXB                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNSxb01
Local oButton1
Local oButton2
Local oFont1 := TFont():New("Times New Roman",,022,,.T.,,,,,.F.,.F.)
Local oSay1
Static oDlg
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Private oWBrowse1
Private aWBrowse1 := {}
Private  cUrl := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/?an=manole&f_status=ready-for-handling"
Private  nTimeOut := 99999
Private  oxml
Private  cHeadRet := ""
Private  sPostRet := ""
Private  cErro    := ""
Private  cAviso   := ""
Private  cXml     := ""
Private  cNum     := ""
Private  lRetorno := .T.
Private  nX       := 0
Private  lXml := .f.
Private  cXmlPed := ""
Private  LxmlPed := .f.
Private  oXMLLIST
private cParam   := ""
private UserCode := "vtexappkey-manole-UMVGHE"
private PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
private aHeadOut := {}
private oXMLped	
Private	nFor1	:= 0

//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

// COMUNICA COM O WEBSERVICE
sPostRet := HttpGET(cUrl,cParam,12000,aHeadOut,@cHeadRet)

lXml := FWJsonDeserialize(sPostRet,@oxml)

//SE HOUVEREM PEDIDOS A SEREM PROCESSADOS
if lXml


  DEFINE MSDIALOG oDlg TITLE "Consulta WebService" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

    @ 010, 133 SAY oSay1 PROMPT "Apresentação da estrutura do WebService" SIZE 179, 013 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 235, 135 BUTTON oButton1 PROMPT "Adicionar" SIZE 037, 012 OF oDlg PIXEL action (aCOLS[n][2] := aWBrowse1[oWBrowse1:nAt,2],oGet:refresh(), oDlg:end())
    @ 235, 207 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL action (oDlg:end())
    Processa( {|| fWBrowse1()  }, "Processando..." )

  ACTIVATE MSDIALOG oDlg CENTERED
else
	msginfo("Não há novos pedidos no portal à serem apresentados nessa estrutura.")
endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWBrowse1 ºAutor  ³Leandro Duarte      º Data ³  08/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a leitura do webservice da monili x vtex e apre º±±
±±º          ³senta para o cliente colocar na rotina                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fWBrowse1()
	oXmlList := oxml:LIST
	if Len(oXmlList) > 0
		if !file(cArqPed)
			I := 1
			cNumPed	:= oXmlList[I]:OrderId
			cUrlPed := "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cNumPed+"/?an=manole"
			cXmlPed := HttpGET(cUrlPed,cParam,12000,aHeadOut,@cHeadRet)
			lXmlPed := FWJsonDeserialize(cXmlPed,@oXMLped)
			nHdlPed	:= FCreate( cArqPed )
			FWrite( nHdlPed,VARINFO('oXMLped',oXMLped , , .f. ))
		    fclose(nHdlPed)
	    endif
		FT_FUSE(cArqPed)
		FT_FGOTOP() //PONTO NO TOPO
		ProcRegua(FT_FLASTREC()) 
		FT_FGOTOP() //PONTO NO TOPO
		FT_FSKIP()
		while !FT_FEOF()
			IncProc()
			cBuffer := alltrim(FT_FREADLN())
		    Aadd(aWBrowse1,{.F.,substr(cBuffer,1,at(' ',cBuffer)-1),nil})
		    cBuffer := substr(cBuffer,at(') [',cBuffer)+2)
		    cBuffer := substr(cBuffer,1,at(']',cBuffer))
		    aWBrowse1[len(aWBrowse1)][3] := cBuffer
		    FT_FSKIP()
	    end
	    FT_FUSE()
    else
    	Aadd(aWBrowse1,{.F.," "," "})
    endif
    @ 028, 004 LISTBOX oWBrowse1 Fields HEADER "","Campo VTex","Conteudo" SIZE 440, 201 OF oDlg PIXEL ColSizes 20,120,30
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {iIf(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3]}}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],oWBrowse1:DrawSelect()}

Return