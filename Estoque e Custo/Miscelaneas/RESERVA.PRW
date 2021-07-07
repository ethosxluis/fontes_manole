#include "Protheus.ch"

User Function atu_res1()  
/*
Este programa executa a baixa de itens
os e permitindo um novo processamento para os pedidos
Adalberto / 05/07/13
*/            

If MsgYesNo("Esta rotina, irá fazer a limpeza de itens liberados/reservas do Pedido de venda, bem como tais itens da Ordem de separação. ";
+	"Após a execução desta rotina é obrigatorio a exucução das rotinas Saldo Atual e Refaz Acumulados. TEM CERTEZA QUE DESEJA PROSSEGUIR?")
	
	Processa({|| RunProc() },"Processando...")
EndIf
                         
Return

//Funcao de Processamento
Static Function RunProc()
Local cQry := ""

DbSelectArea("CB8") // Itens de separação 
CB8->(DBGOTOP())

DbSelectArea("CB9") // Produtos separados 
CB9->(DBGOTOP())

DbSelectArea("SBF") // Saldos por endereço 
SBF->(DBGOTOP())    

DbSelectArea("SC5") // Pedidos de vendas
SC5->(DBGOTOP())    

DbSelectArea("SC6") // Itens do Pedido de vendas
SC6->(DBGOTOP())    
   
DbSelectArea("SC9") // Pedidos liberados  
SC9->(DBGOTOP())   
                
DbSelectArea("SDC") // Saldos a serem liberados 
SDC->(DBGOTOP())
                                      
//Busca SC9 apenas de itens não emitidos NFs -> cQry += " AND C9_PEDIDO = 'V01LZG'" Retirado da query abaixo linha 47
cQry := " SELECT * FROM " + RetSqlName("SC9") 
cQry += " WHERE C9_FILIAL = '" + xFilial("SC9") + "' AND C9_NFISCAL = ' ' "
cQry += " AND D_E_L_E_T_ = ' ' "
cQry += " ORDER BY C9_FILIAL, C9_PEDIDO "
cQry := ChangeQuery(cQry)                                      

If Select("SC9QRY") > 0
	SC9QRY->( DbCloseArea() )
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'SC9QRY', .T., .T.)
                        
ProcRegua(SC9QRY->(RecCount())) // Numero de registros a processar

If SC9QRY->(eof()) 
	MsgInfo("Não foi encontrado nenhum registro para processar.")
EndIf

While  !SC9QRY->(eof())   
     
    cNumPed  := 	SC9QRY->C9_PEDIDO 
    cCodPro  := 	SC9QRY->C9_PRODUTO  
    cLocal   := 	SC9QRY->C9_LOJA 
    cItemPed := 	SC9QRY->C9_ITEM 
    cSqItem  := 	SC9QRY->C9_SEQUEN  
    nQtdLib	 := 	SC9QRY->C9_QTDLIB
    cOrigem  :=     "SC6"

	IncProc("Processando pedido " + ALLTRIM(cNumPed))
	
	//Se possui Ordem de Separação, apaga CB9 e CB8  
	If !Empty(SC9QRY->C9_ORDSEP)
		
		//Localiza Produtos a serem separados deste Item do Pedido
        CB8->( DbSetOrder(1) ) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD
        If CB8->( DbSeek(xFilial("CB8") + SC9QRY->C9_ORDSEP + SC9QRY->C9_ITEM + SC9QRY->C9_SEQUEN + SC9QRY->C9_PRODUTO ) )

           	While !CB8->( EOF() ) .AND. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD) == (xFilial("CB8") + SC9QRY->C9_ORDSEP + SC9QRY->C9_ITEM + SC9QRY->C9_SEQUEN + SC9QRY->C9_PRODUTO)

				//Localiza Prdutos separados, para realizar deleção
	        	CB9->( DbSetOrder(9)) //CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER 
	            If CB9->( DbSeek(xFilial("CB9") + CB8->CB8_ORDSEP + CB8->CB8_PROD + CB8->CB8_LOCAL + CB8->CB8_LCALIZ + CB8->CB8_LOTECT + CB8->CB8_NUMLOT + CB8->CB8_NUMSER) )
	                While !CB9->( EOF() ) .AND. CB9->(CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER) == ;
	                (xFilial("CB9") + CB8->CB8_ORDSEP + CB8->CB8_PROD + CB8->CB8_LOCAL + CB8->CB8_LCALIZ + CB8->CB8_LOTECT + CB8->CB8_NUMLOT + CB8->CB8_NUMSER) 
	            
		            	If !(CB9->(CB9_ITESEP + CB9_SEQUEN ) == CB8->(CB8_ITEM + CB8_SEQUEN ))
				           	CB9->( DbSkip()) 
				           	Loop                   		
		                EndIf
		                
			            RecLock("CB9",.F.)
			            CB9->( DbDelete() )
			            CB9->( MsUnLock() )
		
			            CB9->( DbSkip())
		            EndDo	                    
		        EndIf  
		
	       		RecLock("CB8",.F.)
	      		CB8->( DbDelete() )
	       		CB8->( MsUnLock() )	                    	
	       		CB8->( DbSkip() )

           	EndDo                   	

        EndIf   
    
    EndIf   
    

	SDC->( DbSetOrder(1) ) //DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
	If SDC->( DbSeek(xFilial("SDC") + SC9QRY->(C9_PRODUTO+C9_LOCAL)+ cOrigem + SC9QRY->(C9_PEDIDO+C9_ITEM+C9_SEQUEN+ C9_LOTECTL+C9_NUMLOTE) ) ) 
		While !SDC->( EOF() ) .AND. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE) == ;
		  xFilial("SDC") + SC9QRY->(C9_PRODUTO+C9_LOCAL)+ cOrigem + SC9QRY->(C9_PEDIDO+C9_ITEM+C9_SEQUEN+ C9_LOTECTL+C9_NUMLOTE)
			RecLock("SDC",.F.)
			SDC->( DbDelete() )
			SDC->( MsUnLock() )	   
			SDC->(DBSKIP() )
		EndDo
	EndIf    

	SC9->( DbGoTo(SC9QRY->R_E_C_N_O_) ) 
	RecLock("SC9",.F.)
	SC9->( DbDelete() )
	SC9->( MsUnLock() )                    
		              
	SC6->( DbSetOrder(1) )
	If SC6->( DbSeek(xFilial("SC6")+cNumPed+cItemPed+cCodPro) )   
		If SC6->C6_QTDEMP >= nQtdLib
			RecLock("SC6",.F.)
			SC6->C6_QTDEMP := SC6->C6_QTDEMP - nQtdLib
			SC6->(MsUnLock())                               
			If SC6->C6_QTDEMP < 0
				RecLock("SC6",.F.)
				SC6->C6_QTDEMP := 0
				SC6->(MsUnLock())                         		
			EndIf			                       
		ElseIf SC6->C6_QTDEMP < 0
			RecLock("SC6",.F.)
			SC6->C6_QTDEMP := 0
			SC6->(MsUnLock())                         		
		EndIf
	
		SC5->( DbSetOrder(1) ) 
		If SC5->( DbSeek(xFilial("SC5") + cNumPed ) )
		    RecLock("SC5",.F.)
			SC5->C5_LIBEROK := ""
			SC5->C5_NOTA    := "" 
			SC5->C5_SERIE   := ""	
			SC5->(MsUnLock())  
		EndIf
	EndIf  	

		
	SC9QRY->( DbSkip() )   

EndDo                                                            

MsgInfo("Processo concluido!")

Return