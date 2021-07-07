#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460PROC  ºAutor  ³Leandro Duarte      º Data ³  01/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alimenta o campo da SC5 da regra                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M460PROC()
Local cQuery :=  ""

cQuery +=  " SELECT A.CB9_VOLUME AS ETIQUETA, C.CB3_DESCRI AS ESPECIE "
cQuery +=  "   FROM "+retsqlname("CB9")+" A, "+retsqlname("CB6")+" B, "+retsqlname("CB3")+" C "
cQuery +=  "  WHERE A.CB9_FILIAL = '"+xFilial("CB9")+"' "
cQuery +=  "    AND B.CB6_FILIAL = '"+xFilial("CB6")+"' "
cQuery +=  "    AND C.CB3_FILIAL = '"+xFilial("CB3")+"' "
cQuery +=  "    AND A.D_E_L_E_T_ = ' ' "
cQuery +=  "    AND B.D_E_L_E_T_ = ' ' "
cQuery +=  "    AND C.D_E_L_E_T_ = ' ' "
cQuery +=  "    AND A.CB9_PEDIDO = '"+SC9->C9_PEDIDO+"' "
cQuery +=  "    AND A.CB9_PEDIDO = B.CB6_PEDIDO "
cQuery +=  "    AND B.CB6_TIPVOL = C.CB3_CODEMB "
cQuery +=  " GROUP BY A.CB9_VOLUME, C.CB3_DESCRI "
cQuery := ChangeQuery(cQuery)
IIF(SELECT("SQL1")>0,SQL1->(DBCLOSEAREA()),NIL)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL1", .F., .T.)
SC5->(DBSETORDER(1))
while SQL1->(!eof())
	IF SC5->(DBSEEK(XFILIAL("SC5")+SC9->C9_PEDIDO))
		RECLOCK("SC5",.F.)
		SC5->C5_VOLUME1 += 1
		SC5->C5_ESPECI1 := SQL1->ESPECIE
		MSUNLOCK()
	ENDIF
	SQL1->(DBSKIP())
end

RETURN()