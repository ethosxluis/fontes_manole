#Include "Protheus.ch"
#Include "RESTFUL.ch"
#Include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERORC    �Autor  �Tiago Malta      � Data �     31/07/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � fun��o para gerar o html com os dados do or�amento         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
