#Include "Protheus.ch"
#Include "RESTFUL.ch"
#Include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERORC    ºAutor  ³Tiago Malta      º Data ³     31/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ função para gerar o html com os dados do orçamento         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function StatPed(cAxPed)

Local cHtml  := ""
Local oHtml
	
oHtml := TWFHtml():New("\workflow\statped.html")

dbSelectArea("SC5")
SC5->( dbsetorder(1) )
SC5->( dbseek( xFilial("SC5") + cAxPed ) )

If SC5->C5_XSTATUS == 'INC'
	cStatus := 'Inclu&iacute;do'
ElseIf SC5->C5_XSTATUS == 'SEP'
	cStatus := 'Separado'
ElseIf SC5->C5_XSTATUS == 'FAT'
	cStatus := 'Faturado'
ElseIf SC5->C5_XSTATUS == 'EMB'
	cStatus := 'Embalado'
EndIf
		
oHtml:cBuffer := StrTran( oHtml:cBuffer, "$STATUSPED$"   	, cStatus )
oHtml:cBuffer := StrTran( oHtml:cBuffer, "$NUMPED$"   		, SC5->C5_NUM )
 	
cHtml := oHtml:cBuffer
	
Return cHtml
