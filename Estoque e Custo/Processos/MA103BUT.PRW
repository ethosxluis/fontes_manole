#INCLUDE "Protheus.CH"
#INCLUDE "TOPCONN.CH" 

USER FUNCTION MA103BUT()
LOCAL aBUTNEW := {}

aAdd(aBUTNEW, {'Ocorrencias',{||u_MnOcor02()},"Ocorrencias","Ocorrencias"} ) 

RETURN(aBUTNEW)

