#Include 'rwmake.ch'

User Function GERASBI()

DbSelectArea("SB1")
DbSetOrder(1)
Dbgotop()

Do While 	SB1->B1_FILIAL	==	xFilial("SB1")	.And. !Eof()

//	If SB1->B1_PRV1 == 0
//		DbSkip()
//		Loop
//	Endif
	
	DbSelectArea("SBI")
	DbSetOrder(1)                                                                                                                             
	
	If DbSeek(xFilial("SBI")+SB1->B1_COD)	
		RecLock("SBI",.F.)     
	Else	                   
		RecLock("SBI",.T.)     
	Endif	                        
	           
	SBI->BI_FILIAL 	:= 	xFilial("SB1")
	SBI->BI_COD		:= 	SB1->B1_COD  
	SBI->BI_DESC	:= 	SB1->B1_DESC
	SBI->BI_COD		:= 	SB1->B1_COD  
	SBI->BI_TIPO	:= 	SB1->B1_TIPO
	SBI->BI_UM		:= 	SB1->B1_UM
	SBI->BI_LOCPAD	:= 	SB1->B1_LOCPAD
	SBI->BI_LOCPAD	:= 	SB1->B1_LOCPAD   
	SBI->BI_GRUPO	:= 	SB1->B1_GRUPO
	SBI->BI_PICM	:= 	SB1->B1_PICM
	SBI->BI_IPI		:= 	SB1->B1_IPI
	SBI->BI_ALIQISS	:= 	SB1->B1_ALIQISS
	SBI->BI_CODISS	:= 	SB1->B1_CODISS 
	SBI->BI_TS	    := 	SB1->B1_TS 
	SBI->BI_PICMRET	:= 	SB1->B1_PICMRET
	SBI->BI_PICMENT	:= 	SB1->B1_PICMENT
	SBI->BI_IMPZFRC	:= 	SB1->B1_IMPZFRC 
	SBI->BI_SEGUM	:= 	SB1->B1_SEGUM   
	SBI->BI_QE		:= 	SB1->B1_QE 
	SBI->BI_PESO	:= 	SB1->B1_PESO
	SBI->BI_CLASFIS	:= 	SB1->B1_CLASFIS
	SBI->BI_FORAEST	:= 	SB1->B1_FORAEST
	SBI->BI_CODBAR	:= 	SB1->B1_CODBAR
	SBI->BI_PRV 	:= 	SB1->B1_PRV1 //* 0.97     
	
		SBI->BI_QE		:= 	SB1->B1_QE
	
	
	
	
	
	Msunlock()
	
	DbSelectArea("SB1")
	DbSkip()

Enddo

Return .T.		