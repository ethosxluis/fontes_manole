#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNFAT02 ºAutor  ³Microsiga             º Data ³  11/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenchimento de numero de título quando for D.A.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Criar gatilho no campo E2_PREFIXO para o campo E2_NUM      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßdßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumTitDA()

Local _aArea		:=	GetArea()
Local _aAreaSE2		:=	SE2->(GetArea())
Local cQuery		:= ""
Local cTabQry		:= ""
Local cRetorno		:= ""
Local cCodNew		:= ""

If M->E2_PREFIXO = 'RYI'

	cTabQry	:= GetNextAlias()
	cQuery 	+= "SELECT	MAX(E2_NUM) NUMDA" + CRLF
	cQuery 	+= "FROM		" + RetSqlName("SE2") + " SE2" + CRLF
	cQuery 	+= "WHERE		SE2.E2_FILIAL = '" + xFilial("SE2") + "'" + CRLF
	cQuery 	+= "AND		SE2.E2_PREFIXO = 'RYI' " + CRLF
	cQuery 	+= "AND		SE2.D_E_L_E_T_ = ''" + CRLF
	cQuery	+= "AND		SE2.E2_TIPO = 'RC' " + CRLF
	cQuery	+= "AND		SE2.E2_NATUREZ = '20020' " + CRLF
	cQuery	+= "AND		SE2.E2_EMISSAO = '20190531' " + CRLF
			
	//MemoWrite("MNCOMA03.SQL", cQuery)
		
	cQuery 	:= ChangeQuery(cQuery)
		
	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTabQry, .T., .T.)
			
	While !(cTabQry)->(Eof())
		cRetorno := Soma1((cTabQry)->NUMDA) 
	
		(cTabQry)->(DbSkip())
	End
	
	If Select(cTabQry) > 0
		(cTabQry)->(DbCloseArea())
	EndIf
EndIf

RestArea(_aAreaSE2)
RestArea(_aArea)
Return cRetorno