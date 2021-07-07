#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MADELIT   �Autor  �Microsiga           � Data �  23/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Rotina acionada pelo PE ACD100BUT para deletar item da    ���
���          �  Ordem de separacao e desvincular SC9 com Ordem Separacao  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MADELIT()      
Local aArea			:= GetArea()
Local aAreaSC9		:= SC9->(GetArea())
Local aAreaCB7		:= CB7->(GetArea())
Local aAreaCB8		:= CB8->(GetArea())
Local aAreaCB9		:= CB9->(GetArea())
Local nPosCod   	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_PROD"})   
Local nPosPedido   	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_PEDIDO"})   
Local nPosItemPed  	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_ITEM"})
Local nPosItemSq   	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_SEQUEN"})  
Local nPosQtOrig	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_QTDORI"})  
Local nPosQtSaldS	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_SALDOS"})   
Local nPosLocal		:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_LOCAL"})   
Local nPosLocaliz	:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_LCALIZ"})   
Local nPosLote		:= aScan(aHeader,{|x| AllTrim(x[2])=="CB8_LOTECT"})   
Local cCodPro		:= aCols[n][nPosCod]
Local cNumPed		:= aCols[n][nPosPedido]
Local cItemPed		:= aCols[n][nPosItemPed]
Local cSqItem		:= aCols[n][nPosItemSq]
Local nQtdOrig		:= aCols[n][nPosQtOrig]
Local nQtdSaldS		:= aCols[n][nPosQtSaldS]  
Local cLocal		:= aCols[n][nPosLocal]
Local cEndereco		:= aCols[n][nPosLocaliz]
Local cLote			:= aCols[n][nPosLote]

If (CB7->CB7_STATUS == "9")
	If MsgYesNo("Tem certeza que deseja excluir o item "+Alltrim(cCodPro)+" da Ordem de separa��o? Esta exclus�o n�o ir� tratar Embalagem/Volume. Esta opera��o n�o ter� volta!!!")
		SC9->(DbSetOrder(1))//C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		If SC9->( DbSeek(xFilial("SC9") + cNumPed + cItemPed + cSqItem + cCodPro) )   
			If Empty(SC9->C9_NFISCAL)  
				If SC9->C9_ORDSEP == CB7->CB7_ORDSEP
                    CB9->( DbSetOrder(9)) //CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER 
                    If CB9->( DbSeek(xFilial("CB9") + CB7->CB7_ORDSEP + cCodPro + cLocal ) )
                    	While !CB9->( EOF() ) .AND. CB9->(CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL) == (xFilial("CB9") + CB7->CB7_ORDSEP + cCodPro + cLocal) 
                    		If !(CB9->(CB9_ITESEP + CB9_SEQUEN ) == ( cItemPed + cSqItem ))
		                    	CB9->( DbSkip()) 
		                    	Loop                   		
                    		EndIf
                    		
	                    	RecLock("CB9",.F.)
	                    	CB9->( DbDelete() )
	                    	CB9->( MsUnLock() )
	                    	CB9->( DbSkip())
	                    EndDo
	                    CB8->( DbSetOrder(1) ) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD
	                    If CB8->( DbSeek(xFilial("CB8") + CB7->CB7_ORDSEP + cItemPed + cSqItem + cCodPro ) )
	                    	While !CB8->( EOF() ) .AND. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD) == (xFilial("CB8") + CB7->CB7_ORDSEP + cItemPed + cSqItem + cCodPro)
	                    		RecLock("CB8",.F.)
	                    		CB8->( DbDelete() )
	                    		CB8->( MsUnLock() )	                    	
	                    		CB8->( DbSkip() )
	                    	EndDo
	                    EndIf
                    EndIf
					RecLock("SC9",.F.)
					SC9->C9_ORDSEP := ""
					SC9->(MsUnLock())  
					MsgInfo("Item excluido da Ordem de Separacao e estornado para o pedido com sucesso.")
				Else
					Alert("Item com ordem de separa��o diferente da selecionada")
				EndIf                                          			
			Else 
				Alert("Este item n�o pode ser deletado pois j� possui NF emitida.")
			EndIf
		EndIf
	Else
		MsgAlert("Processo cancelado.")	       
	EndIf
Else 
	Alert("Op��o disponivel apenas quando a Ord.Separa��o est� finalizada. Siga os procedimentos padr�es de estorno.")
EndIf

RestArea(aAreaCB9)
RestArea(aAreaCB8)
RestArea(aAreaCB7)
RestArea(aAreaSC9)
RestArea(aArea)
Return