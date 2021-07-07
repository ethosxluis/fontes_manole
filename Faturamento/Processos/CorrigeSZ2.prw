#Include 'Protheus.ch'

/*/{Protheus.doc} CorrigeSZ2
(long_description) Carvalho
@author Fernando
@since 08/04/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CorrigeSZ2()
	Local cQuerySD2 := ""
	Local cQuerySB6 := ""
	
	cQuerySD2 := " SELECT"
	cQuerySD2 += " SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD" 
	cQuerySD2 += " FROM"
	cQuerySD2 += " SD2010 SD2"
	cQuerySD2 += " INNER JOIN"
	cQuerySD2 += " SC5010 SC5"
	cQuerySD2 += " ON SC5.C5_FILIAL =  '01'"
	cQuerySD2 += " AND SC5.C5_NUM = SD2.D2_PEDIDO"
	cQuerySD2 += " AND SC5.C5_EMISSAO >= '20151101'"
	cQuerySD2 += " AND SC5.D_E_L_E_T_ = ' '"
	cQuerySD2 += " WHERE"
	cQuerySD2 += " SD2.D2_FILIAL = '01'"
	cQuerySD2 += " AND SD2.D2_COD BETWEEN '' AND 'ZZZZZ'"
	cQuerySD2 += " AND SD2.D2_TES IN ('510','901','900')"
	cQuerySD2 += " AND SD2.D2_CF IN ('5917','6917','5904')"
	cQuerySD2 += " GROUP BY  SD2.D2_CLIENTE, SD2.D2_LOJA,SD2.D2_COD"
	cQuerySD2 += " ORDER BY SD2.D2_CLIENTE, SD2.D2_COD"
	
	cQuerySD2 := ChangeQuery(cQuerySD2)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySD2),"TRBSD2",.T.,.T.)		
	DbSelectArea("TRBSD2")	
	TRBSD2->(dbGoTop())
	
	While !TRBSD2->(Eof())
		cQuerySB6 := " SELECT SUM(B6_SALDO) B6_TOTAL FROM SB6010 SB6
		cQuerySB6 += " WHERE B6_FILIAL 	= '01'
		cQuerySB6 += " AND B6_CLIFOR 	= '"+TRBSD2->D2_CLIENTE+"'
		cQuerySB6 += " AND B6_LOJA 		= '"+TRBSD2->D2_LOJA+"'  
		cQuerySB6 += " AND B6_PRODUTO 	= '"+TRBSD2->D2_COD+"'
		cQuerySB6 += " AND B6_SALDO > 0 
		cQuerySB6 += " AND D_E_L_E_T_ = ''
		cQuerySB6 += " ORDER BY B6_CLIFOR
		
		cQuerySB6 := ChangeQuery(cQuerySB6)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySB6),"TRBSB6",.T.,.T.)		
		DbSelectArea("TRBSB6")	
		TRBSB6->(dbGoTop())
		If !TRBSB6->(Eof())
			//Alert("CLIENTE "+_QRYSB6->B6_CLIFOR+"**** PRODU  "+_QRYSB6->B6_PRODUTO +" OK")
			DbSelectArea("SZ2")
			DbSetOrder(1)
			If !DbSeek(xFilial("SZ2")+TRBSD2->D2_CLIENTE+TRBSD2->D2_LOJA+TRBSD2->D2_COD)
				RecLock("SZ2",.T.)
				SZ2->Z2_FILIAL  := xFilial("SZ2")
				SZ2->Z2_CLIENTE := TRBSD2->D2_CLIENTE
				SZ2->Z2_LOJA    := TRBSD2->D2_LOJA
				SZ2->Z2_PRODUTO := TRBSD2->D2_COD
				SZ2->Z2_EVENTO  := ""
				SZ2->Z2_QTDCON  := TRBSB6->B6_TOTAL
				SZ2->Z2_DEVSIMB := 0
				SZ2->Z2_DEVFIS  := 0
				SZ2->Z2_FATCON  := 0
				MsUnLock()
			Else
				RecLock("SZ2",.F.)
				SZ2->Z2_QTDCON  := TRBSB6->B6_TOTAL			
				//SZ2->Z2_DEVSIMB := 0
				//SZ2->Z2_DEVFIS  := 0
				//SZ2->Z2_FATCON  := 0
				MsUnLock()				
			EndIf
			
		EndIf
	EndDo
Return

