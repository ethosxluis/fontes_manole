#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460NUM   ºAutor  ³Leandro Duarte      º Data ³  01/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alimenta o campo da SC5 da regra                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M460NUM()
Local cQuery		:=  ""
Local aAreaSC5		:= SC5->(GETAREA())
Local aAreaSC6		:= SC6->(GETAREA())
Local NqTD			:= 1
Local lRetira 		:= .F.
Local xC5_FRETE		:= 0
Local xRecno		:= 0
IF TYPE("aM460Num")!="A"
	PUBLIC aM460Num	:= {}
ENDIF 

cQuery +=  " SELECT A.CB9_VOLUME AS ETIQUETA, C.CB3_DESCRI AS ESPECIE "
cQuery +=  "   FROM "+retsqlname("CB9")+" A, "+retsqlname("CB6")+" B, "+retsqlname("CB3")+" C "
cQuery +=  "  WHERE A.CB9_FILIAL = '"+xFilial("CB9")+"' "
cQuery +=  "    AND B.CB6_FILIAL = '"+xFilial("CB6")+"' "
cQuery +=  "    AND C.CB3_FILIAL = '"+xFilial("CB3")+"' "
cQuery +=  "    AND A.D_E_L_E_T_ = ' ' "
cQuery +=  "    AND B.D_E_L_E_T_ = ' ' "
cQuery +=  "    AND C.D_E_L_E_T_ = ' ' "
IF ParamIXB # Nil
	cQuery +=  "    AND A.CB9_PEDIDO = '"+ParamIxb[1,1]+"' "
	CpEDIDO	:= ParamIxb[1,1]
ELSEIF SELECT("MA460PROC")>0 .AND. !EMPTY(MA460PROC->C9_PEDIDO)
	cQuery +=  "    AND A.CB9_PEDIDO = '"+MA460PROC->C9_PEDIDO+"' "
	CpEDIDO	:= MA460PROC->C9_PEDIDO
ELSE
	cQuery +=  "    AND A.CB9_PEDIDO = '"+SDC->DC_PEDIDO+"' "
	CpEDIDO	:= SDC->DC_PEDIDO
ENDIF
cQuery +=  "    AND A.CB9_PEDIDO = B.CB6_PEDIDO "
cQuery +=  "    AND B.CB6_TIPVOL = C.CB3_CODEMB "
cQuery +=  " GROUP BY A.CB9_VOLUME, C.CB3_DESCRI "
cQuery := ChangeQuery(cQuery)
IIF(SELECT("SQL1")>0,SQL1->(DBCLOSEAREA()),NIL)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL1", .F., .T.)
SC5->(DBSETORDER(1))
while SQL1->(!eof())
	IF SC5->(DBSEEK(XFILIAL("SC5")+CpEDIDO))
		RECLOCK("SC5",.F.)
		SC5->C5_VOLUME1 := NqTD
		SC5->C5_ESPECI1 := SQL1->ESPECIE
		MSUNLOCK()
		NqTD+=1
	ENDIF
	SQL1->(DBSKIP())
end
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PROCESSAMENTO DA ROTINA QUANDO FOR O CURSO RETIRAR O FRETE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SC5->(DBSEEK(XFILIAL("SC5")+CPEDIDO))
	IF SC6->(DBSEEK(XFILIAL("SC6")+cPedido+SC9->C9_ITEM+SC9->C9_PRODUTO))
		WHILE SC6->C6_NUM == cPedido
			IF POSICIONE('SB1',1,XFILIAL('SB1')+SC6->C6_PRODUTO,'B1_XTIPO') == '2' // somente curso
				lRetira 		:= .T.
				xC5_FRETE		:= SC5->C5_FRETE
				xRecno			:= SC5->(RECNO())
				AADD(aM460Num,{lRetira,xC5_FRETE,xRecno})
			endif
			SC6->(DBSKIP())
		END
	ENDIF
	if 	lRetira
		RECLOCK("SC5",.F.)
		SC5->C5_FRETE	:= 0
		MSUNLOCK()
	endif
ENDIF
RESTAREA(aAreaSC5)
RESTAREA(aAreaSC6)  

RETURN()
