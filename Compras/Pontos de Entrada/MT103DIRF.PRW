#include"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH"

User Function MT103DIRF()
Local aCodR := {}
Local lRet := .T.
Local nX := 0

aCodR := aClone(PARAMIXB[1]) 

//valida��es do usu�rio
For nX := 1 to len(aCodR)
	If Empty(aCodr[nX][2]) //== '    ' //Se o c�digo de reten��o for igual "0297" aborta inclus�o da nota.
		lRet := .F.
		msginfo("O imposto: "+aCodr[nX][4]+" esta sem codigo de Reten��o, favor informar o codigo correto")
	EndIf
Next nX
Return lRet