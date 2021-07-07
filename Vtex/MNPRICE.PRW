#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNPRICE   บAutor  ณLEANDRO DUARTE      บ Data ณ  01/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA PARA TUALIZAR O VALOR DO PREวO DO PRODUTO NA VTEX    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 E P12.X                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION MNPRICE(nId,nPr)

Local cUrlProc 	:= "https://rnb.vtexcommercestable.com.br/api/pricing/pvt/price-sheet?an=manole"
local oxml
Local aHeadOut := {}
//Local cHeadRet := ""
Local sPostRet := ""
Local cParam   := ""
local UserCode := "vtexappkey-manole-UMVGHE"
local PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
Local nAno		:= YEAR(DATE())
Local cMes		:= substr(dtos(DATE()),5,2)
Local cDia		:= substr(dtos(DATE()),7,2)
Local nAnoN		:= YEAR(DATE())+10

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da URL para o HTTPPost                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณconverss๕esณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
nPr := nPr*100

cParam := '{ '
cParam += '              "itemId": '+cValtochar(nId)+', '
cParam += '              "source": null, '
cParam += '              "price": '+cValtochar(nPr)+', '
cParam += '              "salesChannel": 1, '
cParam += '              "medium": null, '
cParam += '              "campaign": null, '
cParam += '              "internalCampaign": null, '
cParam += '              "validFrom": "'+cValtochar(nAno)+'-'+cMes+'-'+cDia+'T'+time()+'.00", '
cParam += '              "validTo": "'+cValToChar(nAnoN)+'-'+cMes+'-'+cDia+'T'+time()+'.00", '
cParam += '              "listPrice": 500 '
cParam += '          }'
sPostRet := HttpPOST(cUrlProc,"",cParam ,,aHeadOut)
Lxml := FWJsonDeserialize(sPostRet,@oxml)

Return
