#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010ALT  ºAutor  ³LEANDRO DUARTE      º Data ³  12/14/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA DEFINIR SE ENVIA O PRODUTO PARA VETX NO MODO DE º±±
±±º          ³ALTERAÇÃO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT010ALT()
Local oObj	:= NIL
IF !EMPTY(SB1->B1_LINKVTX)
	oObj	:= WSServiceVtex():new()
	oObj:oWSproductVO:nBrandId                  := val(SB1->B1_VTMARCA)
	oObj:oWSproductVO:nCategoryId               := val(SB1->B1_CATEGOR) //71 //_IdCategoria
	oObj:oWSproductVO:nDepartmentId             := val(SB1->B1_DEPVTEX) //6 //_IdDepartamento (Não alterável)
	oObj:OWSPRODUCTVO:CDESCRIPTION              := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" // DESCRIÇÃO DO PRODUTO
	oObj:oWSproductVO:cDescriptionShort         := alltrim(SB1->B1_DESC) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA" // DESCRIÇÃO CURTA
	oObj:oWSproductVO:nId                       := val(SB1->B1_IDSKU)    //  //SB1->B1_IDSKU codigo sequencial RECNO
	oObj:oWSproductVO:lIsActive                 := .t. //se não atender requisitos de ativação(ter SKUs ativas), não será ativado
	oObj:oWSproductVO:lIsVisible                := .t. // vai ser visível no site
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
