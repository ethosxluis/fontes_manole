#include "Protheus.ch"

user Function mnVtxmail(cEmail)
Local cNewMail := ''
Local cUrl := "https://conversationtracker.vtex.com.br/api/pvt/emailMapping?an=manole&alias="
Local nTimeOut := 99999
local oxml
Local cHeadRet := ""
Local sPostRet := ""
Local lXml	:= .T.
private cParam   := ""
private UserCode := "vtexappkey-manole-UMVGHE"
private PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
private aHeadOut := {}
default cEmail := ""

//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

// COMUNICA COM O WEBSERVICE
if at('VTEX',UPPER(cEmail))>0
	cUrl += alltrim(cEmail)
else
	return(cEmail)
endif

sPostRet := HttpGET(cUrl,cParam,12000,aHeadOut,@cHeadRet)
sPostRet := DecodeUtf8(sPostRet)
lXml := FWJsonDeserialize(sPostRet,@oxml)
IF lXml
	cNewMail := oxml:EMAIL
ELSE
	return(cEmail)
ENDIF
Return(cNewMail)

