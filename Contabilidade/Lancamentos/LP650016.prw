#Include "Totvs.ch"
User Function LP650016()
	Local nValFre	:= Posicione("SFT",1,xFilial("SFT") + "E" + SD1->(D1_SERIE + D1_DOC + D1_FORNECE + D1_LOJA + D1_ITEM + D1_COD), "SFT->FT_VRETPIS")
	Local nValCof	:= Posicione("SFT",1,xFilial("SFT") + "E" + SD1->(D1_SERIE + D1_DOC + D1_FORNECE + D1_LOJA + D1_ITEM + D1_COD), "SFT->FT_VRETCOF")
	Local nValCsl	:= Posicione("SFT",1,xFilial("SFT") + "E" + SD1->(D1_SERIE + D1_DOC + D1_FORNECE + D1_LOJA + D1_ITEM + D1_COD), "SFT->FT_VALCSL")
	Local nRetorno	:= 0
	
	If Posicione("SF4",1, xFilial("SF4")+SD1->D1_TES,"F4_GRPCON") $ "E009"
		nRetorno := SD1->(D1_TOTAL+D1_VALIPI+D1_DESPESA+D1_VALFRE-D1_VALDESC+D1_ICMSRET+D1_SEGURO-D1_VALIRR-D1_VALINS-D1_VALISS) - nValFre - nValCof - nValCsl
	EndIf

Return nRetorno