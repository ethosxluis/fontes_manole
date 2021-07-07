#include"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH"

User Function MT103DIRF()
Local aCodR := {}
Local lRet := .T.
Local nX := 0

aCodR := aClone(PARAMIXB[1]) 

//validações do usuário
For nX := 1 to len(aCodR)
	If Empty(aCodr[nX][2]) //== '    ' //Se o código de retenção for igual "0297" aborta inclusão da nota.
		lRet := .F.
		msginfo("O imposto: "+aCodr[nX][4]+" esta sem codigo de Retenção, favor informar o codigo correto")
	EndIf
Next nX
Return lRet