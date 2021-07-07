#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT120ALT()


Local lExecuta := .T.

If Paramixb[1] == 4  // Alteração    




    DBSELECTAREA("SC7")    


                If SC7->C7_XSTATUS == "LIBERADO  "
                    msgstop("Este pedido já foi liberado e não poderá ser alterado!!!")
                    lExecuta := .F.    
                EndIf

            

    
EndIf




Return( lExecuta ) 
