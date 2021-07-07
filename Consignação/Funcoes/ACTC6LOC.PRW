#INCLUDE "PROTHEUS.CH"

///------------------------------------------------------------------------------------------------------------------------------
/// ROTINA PARA AJUSTAR O CAMPO C6_LOCAL QUANDO A TES DO PEDIDO DE VENDA NÃO ATUALIZA ESTOQUE NEM POSSUI PODER DE TERCEIRO.
///------------------------------------------------------------------------------------------------------------------------------
/// DEVIDO A OBRIGATORIEDADE DO CAMPO C6_LOCAL (MESMO COM A TES NÃO CONTROLANDO ESTOQUE, O SISTEMA VALIDA A EXISTENCIA DA TABELA 
/// DE SALDO "SB2" PARA O PRODUTO X ARMAZEM.
/// NAO É NECESSÁRIO EXISTIR SALDO NESSE ARMAZÉM, MS O REGISTRO PRECISA EXISTIR.
/// ESSA ROTINA SE PROPÕES A CRIAR ESSE REGISTRO NA TABELA "SB2" SE NECESSÁRIO.
///------------------------------------------------------------------------------------------------------------------------------

User Function ACTC6LOC()

Local _nPosProd := aScan(aHeader,{|x| AllTrim(x[2])== "C6_PRODUTO"})
Local _nPosTES := aScan(aHeader,{|x| AllTrim(x[2])== "C6_TES"})

Local _cLocal 	:= M->C6_LOCAL
Local _cProd 	:= ACOLS[N,_nPosProd]
Local _cTES 	:= ACOLS[N,_nPosTES]
Local _lTES		:= .F.

If !Empty(_cTES)
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4") + _cTES)
		If SF4->F4_ESTOQUE = "N" .and. SF4->F4_PODER3 = "N"
			_lTES := .T.
		EndIf
	EndIf	
EndIf

If M->C5_XTPCON = "F" .AND. _lTES       
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB2")+_cProd+_cLocal) 
		If ApMsgYesNo('O almoxarifado "'+_cLocal+'" não existe para esse produto. Deseja criar o almoxarifado ? ')
			If RecLock("SB2",.T.)
				SB2->B2_FILIAL 	:= xFilial("SB2")
				SB2->B2_COD		:= _cProd
				SB2->B2_LOCAL	:= _cLocal		
				MsUnlock()
			EndIf
		EndIf		
	EndIf
EndIf

Return(.T.)


