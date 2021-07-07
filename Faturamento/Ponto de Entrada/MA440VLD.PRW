#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA440VLD  ºAutor  ³Microsiga           º Data ³  06/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a liberação do pedido de vendas na rotina de        º±±
±±º          ³ liberação de pedidos.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MA440VLD()


Local aArea    := getArea()
Local lRet     := .T.
Local cQuery   := ""
Local ARQTMS   := ""

cQuery := " SELECT C9_FILIAL , C9_PEDIDO,C9_ITEM, C9_CLIENTE, C9_LOJA , C9_PRODUTO, C9_QTDLIB,C9_NFISCAL,C9_SERIENF "+CRLF
cQuery += " FROM "+RETSQLNAME("SC9") + CRLF
cQuery += " WHERE D_E_L_E_T_ = '' AND C9_PEDIDO = '"+SC5->C5_NUM+"' AND C9_CLIENTE = '"+SC5->C5_CLIENTE+"' AND C9_LOJA = '"+SC5->C5_LOJACLI+"'"+CRLF
cQuery += " AND C9_NFISCAL = ''"
cQuery := ChangeQuery(cQuery)
ARQTMS := GetNextAlias()                                                       

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,ARQTMS, .T., .F.)

DBSelectArea((ARQTMS))
If (ARQTMS)->(!Eof())
	lRet := .F.
Endif

If !lRet 
	Aviso("Pedido Liberado","Atenção! Este Pedido ja se encontra liberado e o mesmo não pode ser liberado novamente!",{"Ok"})
Endif

restarea(aArea)
(ARQTMS)->(dbClosearea())

Return(lRet)