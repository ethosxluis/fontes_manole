#Include 'Protheus.ch'

/*/{Protheus.doc} MT120PCOK
PE antes da gravação do pedido de compras
@type function
@author Claudio
@since 30/01/2018
@version 1.0
/*/
User Function MT120PCOK()

Local cArea    := GetArea()
Local cUsuario := RetCodUsr() 
Local lRet := .T.

ZZG->(DbSetOrder(1))
If ZZG->(DbSeek(xFilial("ZZG") + cUsuario + M->CA120FORN))
	Alert("Usuário sem permissão para emitir pedido de compra para este fornecedor")
	lRet := .F.
Endif

RestArea(cArea)

Return lRet

