#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNSALD1   �Autor  �LEANDRO DUARTE      � Data �  01/05/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA LISTAR A TABELA SB2 E ATUALIZAR O SALDO EM ESTO ���
���          �QUE DA VTEX DEVERA CORRER ESSA ROTINA A CADA 3 HORAS        ���
�������������������������������������������������������������������������͹��
���Uso       � P11 E P12.X                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNSALD1()
Local cQuery 	:= ""
Local cInf		:= ""
Local nVolt		:= 0

cQuery 	+= " SELECT A.B2_LOCAL, B.B1_IDSKU, A.B2_QATU "
cQuery 	+= "   FROM "+RETSQLNAME("SB2")+" A, "+RETSQLNAME("SB1")+" B "
cQuery 	+= "  WHERE A.B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery 	+= "    AND B.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery 	+= "    AND A.D_E_L_E_T_ = ' ' "
cQuery 	+= "    AND B.D_E_L_E_T_ = ' ' "
cQuery 	+= "    AND A.B2_COD = B.B1_COD "
cQuery 	+= "    AND A.B2_LOCAL = B.B1_LOCPAD "
IIF(SELECT("SB2VTEX")>0,SB2VTEX->(DBCLOSEAREA()),NIL)
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"SB2VTEX", .T., .T.)

while SB2VTEX->(!eof())
	nVolt++
	IF nVol>50
		nVolt := 0
		cInf := SUBSTR(cInf,1,LEN(cInf)-1)
		MNSALD2(cInf)
		cInf := ""
	ELSE
		cInf+='{ "wareHouseId":"'+SB2VTEX->B2_LOCAL+'","itemId":"'+SB2VTEX->B1_IDSKU+'","quantity":"'+SB2VTEX->B2_QATU+'","dateUtcOnBalanceSystem":null },'
	ENDIF
	SB2VTEX->(DBSKIP())
end
IF LEN(cInf)>1
	nVolt 	:= 0
	cInf 	:= SUBSTR(cInf,1,LEN(cInf)-1)
	MNSALD2(cInf)
	cInf 	:= ""
ENDIF
RETURN()   
   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNSALD2   �Autor  �LEANDRO DUARTE      � Data �  01/05/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA ATUALIZAR O VALOR DO SALDO DO PRODUTO NA VTEX   ���
���          � BASEADO NA TABELA SB2 POIS � A TABELA PRIMARIA             ���
�������������������������������������������������������������������������͹��
���Uso       � P11 E P12.X                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION MNSALD2(cParam)

Local cUrlProc 	:= "https://manole.vtexcommercestable.com.br/api/logistics/pvt/inventory/warehouseitembalances"
local oxml
Local aHeadOut := {}
//Local cHeadRet := ""
Local sPostRet := ""
local UserCode := "vtexappkey-manole-UMVGHE"
local PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
DEFAULT cParam := ""

//������������������������������������������������������Ŀ
//� Montagem da URL para o HTTPPost                      �
//��������������������������������������������������������
aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

sPostRet := HttpPOST(cUrlProc,"",cParam ,,aHeadOut)
Lxml := FWJsonDeserialize(sPostRet,@oxml)

Return