#include "Protheus.ch"
//#define CRLF CHR(13)+CHR(10)

User Function ATUA_CONSIG()  

Local cProduto := ""
Local cLocal   := "01"

DbSelectArea("SZ2")
DbSetOrder(1)
SZ2->(DBGOTOP())  

DbSelectArea("SB2")
SB2->(DBGOTOP())

While  !SZ2->(eof())  
     cProduto :=	SZ2->(Z2_PRODUTO)  

     IF DBSEEK(xfilial("SB2")+cProduto+cLocal)  
        Reclock("SB2",.F.)
     else 
        SZ2->(DbSkip())
        loop
     endif

     SB2->B2_QNPT   += SZ2->Z2_QTDCON - SZ2->Z2_DEVSIMB - SZ2->Z2_DEVFIS
     
     Msunlock()
     SZ2->(DbSkip())            
end
return 