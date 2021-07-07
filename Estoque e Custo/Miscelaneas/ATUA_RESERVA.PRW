#include "Protheus.ch"

User Function atua_reserva()  
/*
Este programa executa a baixa de itens da reserva em pedidos com oredem de separação que não foram separados
*/

DbSelectArea("CB7")  
dbsetorder(1)
CB7->(DBGOTOP())

DbSelectArea("CB8")  
CB8->(DBGOTOP())

DbSelectArea("CB9")  
CB9->(DBGOTOP())

DbSelectArea("SC9")  
SC9->(DBGOTOP())    

While  !CB7->(eof())    
// primeiro if     
    cStatus := 	CB7->CB7_STATUS
    cPedido := 	CB7->CB7_PEDIDO
    If (CB7->CB7_STATUS == "9")
  //	If MsgYesNo("Tem certeza que deseja excluir o item "+Alltrim(cCodPro)+" da Ordem de separação? Esta exclusão não irá tratar Embalagem/Volume. Esta operação não terá volta!!!")
		SC9->(DbSetOrder(1))//C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	    //segundo if
			If SC9->( DbSeek(xFilial("SC9") + cNumPed + cItemPed + cSqItem + cCodPro) )   
		    // terceito if
				If Empty(SC9->C9_NFISCAL)  
			    // quarto if
					If SC9->C9_ORDSEP == CB7->CB7_ORDSEP
                    CB9->( DbSetOrder(9)) //CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER 
                  //quinto if
                    If CB9->( DbSeek(xFilial("CB9") + CB7->CB7_ORDSEP + cCodPro + cLocal ) )
                    	While !CB9->( EOF() ) .AND. CB9->(CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL) == (xFilial("CB9") + CB7->CB7_ORDSEP + cCodPro + cLocal) 
                    	//sexto if	
                    		If !(CB9->(CB9_ITESEP + CB9_SEQUEN ) == ( cItemPed + cSqItem ))
		                    	CB9->( DbSkip()) 
		                    	Loop                   		
                    		EndIf
                    	 //* fim do sexto if	
	                    	RecLock("CB9",.F.)
	                    	CB9->( DbDelete() )
	                    	CB9->( MsUnLock() )
	                    	CB9->( DbSkip())
	                    EndDo
	                    CB8->( DbSetOrder(1) ) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD
	                //setimo if
	                    If CB8->( DbSeek(xFilial("CB8") + CB7->CB7_ORDSEP + cItemPed + cSqItem + cCodPro ) )
	                    	While !CB8->( EOF() ) .AND. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD) == (xFilial("CB8") + CB7->CB7_ORDSEP + cItemPed + cSqItem + cCodPro)
	                    		RecLock("CB8",.F.)
	                    		CB8->( DbDelete() )
	                    		CB8->( MsUnLock() )	                    	
	                    		CB8->( DbSkip() )
	                    	EndDo
	                    EndIf   
	                 //* fim do setimo if    
                    EndIf
				   //* fim do quinto if  
						RecLock("SC9",.F.)
					SC9->C9_ORDSEP := ""
					SC9->(MsUnLock())  
					MsgInfo("Item excluido da Ordem de Separacao e estornado para o pedido com sucesso.")
				Else
					Alert("Item com ordem de separação diferente da selecionada")
				EndIf  
			  //* fim do quarto if  	                                        			
			Else 
				Alert("Este item não pode ser deletado pois já possui NF emitida.")
			EndIf  
		 //* fim do terceiro if 	
		EndIf    
	
	 //* fim do segundo if 	
	Else
  //		MsgAlert("Processo cancelado.")	  
     	CB7->( DbSkip() )  
 //	EndIf  
 //* fim do primeiro if 	
//Else 
//	Alert("Opção disponivel apenas quando a Ord.Separação está finalizada. Siga os procedimentos padrões de estorno.")
EndIf
   
   
   
   
    	
End
Return