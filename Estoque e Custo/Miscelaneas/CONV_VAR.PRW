#include "Protheus.ch"

User Function atua_var()

DbSelectArea("SA1")  
dbsetorder(1)
SA1->(DBGOTOP())

While  !SA1->(eof()) 

   	Reclock("SA1",.F.)
   
	SA1->A1_XDESC5	 :=  SA1->A1_XDESC3
	SA1->A1_XCOMIS5	 :=  SA1->A1_XCOMIS3	 	 

	SA1->(MSUnLock())
	SA1->(dbSkip())
    	
End
Return