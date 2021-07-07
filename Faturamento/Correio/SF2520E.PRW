#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³TOTVS               º Data ³ 22/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para estorno da Tabela de controle de      º±±
±±º          ³Consignacao.                                                º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2520E()

Local aArea     := GetArea()
Local aAreaSD2  := SD2->(GetArea())
Local cQuery := " "
Local cChaveSZ1 := SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_DOC + SF2->F2_SERIE
Local cChaveSZ2 := xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA

DbSelectArea("SZ1")
DbSetOrder(1)
If DbSeek(xFilial("SZ1")+SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_DOC + SF2->F2_SERIE)
	While !Eof() .And. xFilial("SZ1")+SZ1->Z1_CLIENTE + SZ1->Z1_LOJA + SZ1->Z1_DOC + SZ1->Z1_SERIE == xFilial("SF2")+cChaveSZ1
		RecLock("SZ1",.F.)
		DbDelete()
		MsUnlock()
		DbSkip()
	EndDo
EndIf

//ESTORNO DA remessa de faturamento
DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	While !Eof().And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cChaveSZ2
		If SD2->D2_XTPCON == "R"
			U_AtuCons(SF2->F2_CLIENTE,SF2->F2_LOJA,SD2->D2_COD,SD2->D2_XEVENTO,"CE",SD2->D2_QUANT)
		ElseIf SD2->D2_XTPCON == "F"
			U_AtuCons(SF2->F2_CLIENTE,SF2->F2_LOJA,SD2->D2_COD,SD2->D2_XEVENTO,"FE",SD2->D2_QUANT)
		EndIf
		SD2->(DbSkip())
	EndDo
EndIf

RestArea(aAreaSD2)
RestArea(aArea)


//*****************************************
// Função para CANCELAR o OBJETO do CORREIO
//*****************************************
FCanObjC()

cQuery += " SELECT A.R_E_C_N_O_ AS RECCB7, B.R_E_C_N_O_ AS RECCB8 "
cQuery += "   FROM "+retsqlname("CB7")+" A, "+Retsqlname("CB8")+" B  "
cQuery += "  WHERE A.CB7_FILIAL = '"+Xfilial("CB7")+"'  "
cQuery += "    AND B.CB8_FILIAL = '"+Xfilial("CB8")+"'  "
cQuery += "    AND A.D_E_L_E_T_ = ' '  "
cQuery += "    AND B.D_E_L_E_T_ = ' '  "
cQuery += "    AND A.CB7_ORDSEP = B.CB8_ORDSEP "
cQuery += "    AND (A.CB7_NOTA = '"+SF2->F2_DOC+"' OR B.CB8_NOTA = '"+SF2->F2_DOC+"') "
cQuery += "    AND (A.CB7_SERIE = '"+SF2->F2_SERIE+"' OR B.CB8_SERIE = '"+SF2->F2_SERIE+"') "
IIF(SELECT("TTRRBB")>0,TTRRBB->(DBCLOSEAREA()),NIL)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TTRRBB",.F.,.T.)
WHILE TTRRBB->(!EOF())
	CB7->(DBGOTO(TTRRBB->RECCB7))
	RECLOCK("CB7",.F.)
	CB7->CB7_NOTA	:= " "
	CB7->CB7_SERIE	:= " "
	MSUNLOCK()

	CB8->(DBGOTO(TTRRBB->RECCB8))
	RECLOCK("CB8",.F.)
	CB8->CB8_NOTA	:= " "
	CB8->CB8_SERIE	:= " "
	MSUNLOCK()

	TTRRBB->(DBSKIP())
END
IIF(SELECT("TTRRBB")>0,TTRRBB->(DBCLOSEAREA()),NIL)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³FONTANELLI          º Data ³ 09/06/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para cancelar o objeto utilizado do correio (UA5) e  º±±
±±º          ³cancelar o vinculo com o pedido de venda (SC5)              º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FCanObjC()

LOCAL _aArea:= GetArea()
Local cQuery := " "
LOCAL _cFilial  := SF2->F2_FILIAL
LOCAL _cNota    := SF2->F2_DOC
LOCAL _cSerie   := SF2->F2_SERIE
LOCAL _cCliente := SF2->F2_CLIENTE
LOCAL _cLoja    := SF2->F2_LOJA

if GetMv("XM_CORREIO") .AND. alltrim(_cSerie) <> "A"

	dbSelectArea("UA5")
	dbSetOrder(2) // UA5_FILIAL+UA5_NF+UA5_SERIE
	If dbSeek(xFilial("UA5")+_cNota+_cSerie,.T.)

		//*********************************************************************************
		// Apaga a referencia na tabela UA5 no Objeto do Correio apos Excluir a Nota Fiscal
		//*********************************************************************************
		RecLock("UA5",.F.)
		UA5->UA5_NF    := SPACE(9)
		UA5->UA5_SERIE := SPACE(3)
		MsUnLock()

		//******************************************************************************************
		// Apaga a referencia na tabela SC5 o numero do Objeto do Correio apos Excluir a Nota Fiscal
		//******************************************************************************************
		DbSelectArea("SD2")
		DbsetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->(DbGotop())
		If DbSeek(_cFilial+_cNota+_cSerie+_cCliente+_cLoja)

			aPEDIDOS := {}
			While SD2->(!EOF()) .AND. SD2->D2_FILIAL == _cFilial .AND. SD2->D2_DOC == _cNota .AND. SD2->D2_SERIE == _cSerie .AND. SD2->D2_CLIENTE == _cCliente .AND. SD2->D2_LOJA == _cLoja

				DbSelectArea("SC5")
				SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
				If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			 		if !EMPTY(SC5->C5_OBJETO)
						nPosPEDIDO := aScan(aPEDIDOS, {|x| Alltrim(x[1]) == SD2->D2_PEDIDO})
						If nPosPEDIDO == 0
							aAdd(aPEDIDOS,{SD2->D2_PEDIDO})
						endif
					endif
				endif

				SD2->(DbSkip())
			Enddo

			For xC := 1 to LEN(aPEDIDOS)
				DbSelectArea("SC5")
				DbsetOrder(1) // C5_FILIAL+C5_NUM
				SC5->(DbGotop())
				If DbSeek(xFilial("SC5")+aPEDIDOS[xC][1])
					RecLock("SC5",.f.)
					SC5->C5_OBJETO := SPACE(13)
					MsUnLock()
				endif
			Next xC

		endif

	endif

endif

RestArea(_aArea)

cQuery += " SELECT A.R_E_C_N_O_ AS RECCB7, B.R_E_C_N_O_ AS RECCB8 "
cQuery += "   FROM "+retsqlname("CB7")+" A, "+Retsqlname("CB8")+" B  "
cQuery += "  WHERE A.CB7_FILIAL = '"+Xfilial("CB7")+"'  "
cQuery += "    AND B.CB8_FILIAL = '"+Xfilial("CB8")+"'  "
cQuery += "    AND A.D_E_L_E_T_ = ' '  "
cQuery += "    AND B.D_E_L_E_T_ = ' '  "
cQuery += "    AND A.CB7_ORDSEP = B.CB8_ORDSEP "
cQuery += "    AND (A.CB7_NOTA = '"+SF2->F2_DOC+"' OR B.CB8_NOTA = '"+SF2->F2_DOC+"') "
cQuery += "    AND (A.CB7_SERIE = '"+SF2->F2_SERIE+"' OR B.CB8_SERIE = '"+SF2->F2_SERIE+"') "
IIF(SELECT("TTRRBB")>0,TTRRBB->(DBCLOSEAREA()),NIL)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TTRRBB",.F.,.T.)
WHILE TTRRBB->(!EOF())
	CB7->(DBGOTO(TTRRBB->RECCB7))
	RECLOCK("CB7",.F.)
	CB7->CB7_NOTA	:= " "
	CB7->CB7_SERIE	:= " "
	MSUNLOCK()

	CB8->(DBGOTO(TTRRBB->RECCB8))
	RECLOCK("CB8",.F.)
	CB8->CB8_NOTA	:= " "
	CB8->CB8_SERIE	:= " "
	MSUNLOCK()

	TTRRBB->(DBSKIP())
END
IIF(SELECT("TTRRBB")>0,TTRRBB->(DBCLOSEAREA()),NIL)
Return
