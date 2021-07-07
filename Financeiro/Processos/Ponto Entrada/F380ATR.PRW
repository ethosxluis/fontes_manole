#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F380ATR   ºAutor  ³LEANDRO DUARTE      º Data ³  08/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA DE AJUSTE DE CONCILIAÇÃO PARA APARECER OS TITULOS    º±±
±±º          ³ORIGINAIS SE É RECEBER OU A PAGAR                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function F380ATR()

/*

FONTANELLI REMOVIDO ESTA ROTINA

Local cQuery := ""
TRB->(DBGOTOP())
WHILE TRB->(!EOF())
	cQuery := " SELECT E5_RECPAG FROM "+RETSQLNAME("SE5")+" A WHERE A.E5_NUMCHEQ = '"+TRB->E5_NUMCHEQ+"' AND  A.E5_DATA = '"+DTOS(TRB->E5_DATA)+"' AND A.E5_PROCTRA = '"+TRB->E5_PROCTRA+"' AND A.E5_PREFIXO = '"+TRB->E5_PREFIXO+"' AND A.E5_NUMERO = '"+TRB->E5_NUMERO+"' AND A.E5_PARCELA = '"+TRB->E5_PARCELA+"' AND A.E5_TIPO = '"+TRB->E5_TIPO+"' AND A.E5_CLIFOR = '"+TRB->E5_CLIFOR+"' AND A.E5_LOJA = '"+TRB->E5_LOJA+"' AND A.E5_TIPODOC = '"+TRB->E5_TIPODOC+"' AND A.E5_AGENCIA = '"+TRB->E5_AGENCIA+"' AND A.E5_CONTA = '"+TRB->E5_CONTA+"' AND A.D_E_L_E_T_ = ' ' "
	IIF(SELECT("TTRRBB")>0,TTRRBB->(DBCLOSEAREA()),NIL)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TTRRBB",.F.,.T.)
	IF !EMPTY(TTRRBB->E5_RECPAG)
		RECLOCK("TRB",.F.)
		E5_RECPAG := TTRRBB->E5_RECPAG
		MSUNLOCK()
	ENDIF
	TRB->(DBSKIP())
END
TRB->(DBGOTOP())
*/

return()