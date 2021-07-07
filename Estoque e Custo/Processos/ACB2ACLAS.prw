#Include 'Protheus.ch'

//**************************************************************************************
//** Descricao: ROTINA DESENVOLVIDA PARA AJUSTAR O SALDO A CLASSIFICAR NA SB2
//**************************************************************************************
User Function ACB2ACLAS()

If ApMsgYesNo("Confirma o processo de ajuste da quantidade a classificar do estoque ?")
	Processa({|lEnd| SB2_01()})
	ApMsgInfo("Processo finalizado...")
EndIF

Return



///------------------------------------------------------------------------------------------------
/// FUNÇÃO QUE AJUSTA OS SALDO A CLASSIFICAR.
///------------------------------------------------------------------------------------------------
Static Function SB2_01()
Local cLogINI := ""
Local cLogFim := ""  
Local nQtdClas := 0

dbSelectArea("SB2")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())
Do While !Eof()

	IncProc( 'Processando Ajuste de Saldos' )
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SB2->B2_COD)
	If SB1->B1_LOCALIZ == "S"
		nQtdClas := 0
		dbSelectArea("SDA")
		dbSetOrder(1)
		If dbSeek(xFilial("SDA")+SB2->B2_COD+SB2->B2_LOCAL)
			Do While !Eof() .and. SDA->DA_FILIAL == xFilial("SDA") .and. SDA->DA_PRODUTO == SB2->B2_COD .AND. SDA->DA_LOCAL == SB2->B2_LOCAL
				nQtdClas += SDA->DA_SALDO
				dbSkip()
			EndDo
		EndIf
		If SB2->B2_QACLASS <> nQtdClas
			cLogIni += SB2->B2_COD + "|" + SB2->B2_LOCAL + "|" + Transform(nQtdClas,"@E 9999999999.99")  + "|" + Transform(SB2->B2_QACLASS,"@E 9999999999.99") + CHR(13)+CHR(10) 
		EndIf
		dbSelectArea("SB2")
		RecLock("SB2",.F.)
		SB2->B2_QACLASS := nQtdClas
		MsUnlock()
		If SB2->B2_QACLASS <> nQtdClas
			cLogFim += SB2->B2_COD + "|" + SB2->B2_LOCAL + "|" + Transform(nQtdClas,"@E 9999999999.99")  + "|" + Transform(SB2->B2_QACLASS,"@E 9999999999.99") + CHR(13)+CHR(10) 
		EndIf

	EndIf
	dbSelectArea("SB2")	
	dbSkip()	
EndDo

//MEMOWRITE("D:\LOG_SB2_INI",cLogIni)
//MEMOWRITE("D:\LOG_SB2_FIM",cLogfim)

Return



