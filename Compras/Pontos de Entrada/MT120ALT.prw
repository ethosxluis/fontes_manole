#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT120ALT()


Local lExecuta := .T.

If Paramixb[1] == 4  // Altera��o    




    DBSELECTAREA("SC7")    


                If SC7->C7_XSTATUS == "LIBERADO  "
                    msgstop("Este pedido j� foi liberado e n�o poder� ser alterado!!!")
                    lExecuta := .F.    
                EndIf

            

    
EndIf




Return( lExecuta ) 
