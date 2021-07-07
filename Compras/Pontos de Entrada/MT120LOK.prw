#include 'protheus.ch'
#include 'parmtype.ch'

User Function  MT120LOK()

Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local nPosISBN  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XISBN'})
Local cGrupo    := Posicione('SB1',1,xFilial('SB1') + aCols[n][nPosProd],'B1_GRUPO')
Local lContrato := IIF(Posicione('SBM',1,xFilial('SBM') + cGrupo,'BM_XGERCON') = 'S',.T.,.F.) 

Local lRet := .T.

If Empty(aCols[n][nPosISBN]) .AND. lContrato
	MsgInfo("Informe o ISBN para este código de serviço.")
	lRet := .F.
EndIf

Return lRet
