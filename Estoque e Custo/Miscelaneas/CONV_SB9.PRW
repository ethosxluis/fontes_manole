#include "Protheus.ch"

User Function conv_sb9()

DbSelectArea("SB9")  
dbsetorder(1)
SB9->(DBGOTOP())

While  !SB9->(eof()) 
    IF SB9->B9_VINI1 >= 0                                                   
    
       SB9->(DbSkip())
       Loop
    endif
   		
   	Reclock("SB9",.F.)
   
	SB9->B9_VINI1	 := SB9->B9_VINI1 * -1

	SB9->(MSUnLock())
	SB9->(dbSkip())
    	
End
Return