#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT120FIM()

Local nOpcao   := PARAMIXB[1]   // Op??o Escolhida pelo usuario 
Local cNumPC   := PARAMIXB[2]   // Numero do Pedido de Compras
Local nOpcA    := PARAMIXB[3]   // Indica se a a??o foi Cancelada = 0  ou Confirmada = 1
Local cArea    := GetArea()
Local cGrupo   := ''
Local cXStatus := '' 
Local lXGerCon := .F.

If nOpcao == 3 .OR. nOpcao == 4
	SC7->(DbSetOrder(1))
	SC7->(DbSeek(xFilial("SC7") + cNumPC))

	While !SC7->(EOF()) .AND. SC7->C7_NUM == cNumPC
	
		cXStatus := ''
		cGrupo   := Posicione('SB1',1,xFilial('SB1') + SC7->C7_PRODUTO,'B1_GRUPO')	
		lXGerCon := IIF(Posicione('SBM',1,xFilial('SBM') + cGrupo,'BM_XGERCON') = 'S',.T.,.F.)
		
		If lXGerCon	
			cXStatus := 'BLOQUEADO'
		Endif
		
		SC7->(RecLock('SC7'),.F.)
		SC7->C7_XSTATUS := cXStatus
		SC7->(MsUnlock())
//////////////		

/*   if  SB1->B1_CUSTEI == 'S'
		
		DBSELECTAREA("SB2")
		if !dbseek(SC7->C7_FILIAL+SC7->C7_PRODUTO+"15")
			reclock("SB2",.T.)
			  SB2->B2_FILIAL := SC7->C7_FILIAL
			  SB2->B2_COD    := SC7->C7_PRODUTO
			  SB2->B2_LOCAL  := "15"
			  SB2->B2_QATU   := SC7->C7_QUANT
			msunlock()
		else
			reclock("SB2",.F.)
			  SB2->B2_QATU  += SC7->C7_QUANT
			msunlock()
		endif

		DBSELECTAREA("SD3")

		RECLOCK("SD3",.T.)
			SD3->D3_FILIAL := xfilial()
			SD3->D3_TM    := "001"
			SD3->D3_COD   := SC7->C7_PRODUTO
			SD3->D3_QUANT := SC7->C7_QUANT
			SD3->D3_LOCAL := "15"
			SD3->D3_EMISSAO := DDATABASE
		MSUNLOCK()

	
		DBSELECTAREA("SC7")

	endif*/
/////////////
		SC7->(DbSkip())
	Enddo
Endif

RestArea(cArea)	
Return
