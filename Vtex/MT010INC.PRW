#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010INC  �Autor  �Leandro Duarte      � Data �  12/14/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para definir se envia o produto para a Vtex          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 e P12                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function MT010INC()
Local oObj	:= NIL

//TODO VERIFICAR MT010INC E MT010ALT
/*
IF !EMPTY(SB1->B1_LINKVTX)
	Reclock("SB1",.F.)
	SB1->B1_IDSKU	:= val(GetSxeNum("SB1","B1_IDSKU"))
	MsUnlock()
	CONFIRMSX8()
	oObj	:= WSServiceVtex():new()
	oObj:oWSproductVO:nBrandId                  := SB1->B1_CODVTEX
	oObj:oWSproductVO:nCategoryId               := VAL(SB1->B1_CATEGOR) //71 //_IdCategoria
	oObj:oWSproductVO:nDepartmentId             := VAL(SB1->B1_DEPVTEX) //6 //_IdDepartamento (N�o alter�vel)
	oObj:OWSPRODUCTVO:CDESCRIPTION              := SB1->B1_DVETEX1 //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" // DESCRI��O DO PRODUTO
	oObj:oWSproductVO:cDescriptionShort         := SB1->B1_DESC //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA" // DESCRI��O CURTA
	oObj:oWSproductVO:nId                       := val(SB1->B1_IDSKU) // SB1->(RECNO()) // codigo sequencial RECNO
	oObj:oWSproductVO:lIsActive                 := .t. //se n�o atender requisitos de ativa��o(ter SKUs ativas), n�o ser� ativado
	oObj:oWSproductVO:lIsVisible                := .t. // vai ser vis�vel no site
	oObj:oWSproductVO:cKeyWords                 := SB1->B1_KEYPSQ1 // "1DICIONARIO, CREYSSON, CASSETA, PLANETA, "// palavras chaves relevantes para a busca
	oObj:oWSproductVO:cLinkId                   := SB1->B1_LINKVTX //"2"// site principal
	oObj:oWSproductVO:oWSListStoreId            :=  Service_ArrayOfint():new()
	oObj:oWSproductVO:cMetaTagDescription       := SB1->B1_DVETEX1//"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" //meta tag de description (SEO)
	oObj:oWSproductVO:cName                     := SB1->B1_DESC  //nome do produto
	oObj:oWSproductVO:cRefId                    := SB1->B1_COD //identificador do produto no ERP
	oObj:oWSproductVO:cTitle                    := SB1->B1_DVETEX1//"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!"
	oObj:ProductInsertUpdate(oObj:oWSproductVO)
	IF !EMPTY(oObj:CMESSAGE)
		AVISO("Aviso",oObj:CMESSAGE,{"OK"})
	ENDIF
	u_MNPRICE(SB1->B1_IDSKU,SB1->B1_PRV1)
ENDIF
*/

//Edmar Mendes do Prado
// Cadastro de produtos nos armazens
If Alltrim(SB1->B1_TIPO) == "SS"
	dbSelectArea("SB2")
    dbSetOrder(1)
	IF !SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD ))
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	EndIf							
EndIf

Return()

