#include "protheus.ch"
user function mnseq(cNumero)
	local cLogFile := "c:\temp\seq1.txt"
	If !File(cLogFile)
		If (nHandle := MSFCreate(cLogFile,0)) <> -1
			FWrite( nHandle,cNumero)
			cBuffer := cNumero
		EndIf
	Else
		If (nHandle := FOpen(cLogFile,2)) <> -1
			nTamFile := fSeek(nHandle,0,2)
			fSeek(nHandle,0,0)
			nTamLin  := 6
			cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura
			nBtLidos := fRead(nHandle,@cBuffer,nTamLin)

		EndIf
	EndIf
	nValor := strzero(VAL(soma1(cBuffer)),6)
	fSeek(nHandle,0,0)
	FWrite(nHandle,nValor)
	FCLOSE(nHandle)
Return(nValor)