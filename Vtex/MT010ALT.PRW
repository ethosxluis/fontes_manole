#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010ALT  �Autor  �LEANDRO DUARTE      � Data �  12/14/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA DEFINIR SE ENVIA O PRODUTO PARA VETX NO MODO DE ���
���          �ALTERA��O                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MT010ALT()
Local oObj	:= NIL
IF !EMPTY(SB1->B1_LINKVTX)
	oObj	:= WSServiceVtex():new()
	oObj:oWSproductVO:nBrandId                  := val(SB1->B1_VTMARCA)
	oObj:oWSproductVO:nCategoryId               := val(SB1->B1_CATEGOR) //71 //_IdCategoria
	oObj:oWSproductVO:nDepartmentId             := val(SB1->B1_DEPVTEX) //6 //_IdDepartamento (N�o alter�vel)
	oObj:OWSPRODUCTVO:CDESCRIPTION              := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" // DESCRI��O DO PRODUTO
	oObj:oWSproductVO:cDescriptionShort         := alltrim(SB1->B1_DESC) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA" // DESCRI��O CURTA
	oObj:oWSproductVO:nId                       := val(SB1->B1_IDSKU)    //  //SB1->B1_IDSKU codigo sequencial RECNO
	oObj:oWSproductVO:lIsActive                 := .t. //se n�o atender requisitos de ativa��o(ter SKUs ativas), n�o ser� ativado
	oObj:oWSproductVO:lIsVisible                := .t. // vai ser vis�vel no site
	oObj:oWSproductVO:cKeyWords                 := alltrim(SB1->B1_KEYPSQ1) // "1DICIONARIO, CREYSSON, CASSETA, PLANETA, "// palavras chaves relevantes para a busca
	oObj:oWSproductVO:cLinkId                   := alltrim(SB1->B1_LINKVTX) //"2"// site principal
	oObj:oWSproductVO:oWSListStoreId            :=  Service_ArrayOfint():new()
	oObj:oWSproductVO:cMetaTagDescription       := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" //meta tag de description (SEO)
	oObj:oWSproductVO:cName                     := alltrim(SB1->B1_DESC)  //nome do produto
	oObj:oWSproductVO:cRefId                    := alltrim(SB1->B1_COD) //identificador do produto no ERP
	oObj:oWSproductVO:cTitle                    := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!"
	oObj:ProductInsertUpdate(oObj:oWSproductVO)
	IF !EMPTY(oObj:CMESSAGE)
		AVISO("Aviso",oObj:CMESSAGE,{"OK"})
	ENDIF
	u_MNPRICE(SB1->B1_IDSKU,SB1->B1_PRV1)
ENDIF

//Edmar Mendes do Prado
// Cadastro de produtos nos armazens
If Alltrim(SB1->B1_TIPO) == "SS"
	dbSelectArea("SB2")
    dbSetOrder(1)
	IF !SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD ))
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	EndIf							
EndIf

RETURN
