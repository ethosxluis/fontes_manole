#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Topconn.ch"
#Include "Fileio.ch"
#INCLUDE "stdwin.ch"
#include "Rwmake.ch"
#INCLUDE "Ap5Mail.ch"
#Include 'ApWebEx.ch'

/*/{Protheus.doc} MNFINX02
Fonte responsavel pela gravação dos dados do arquivo de conciliação bancaria da adquirente Mazine Luiza
@type function
@version 1.0 
@author Guelder A. Santos
@since 24/02/2021
@return Caracter
/*/
User Function MNFINX02(cArquivo)
	Local lCabec    := .T.
	Local cMemo     := ""
	Local aDados    := {}
	Local cRet      := "false"
	Local cLocal	:= ""
	Local lCopy		:= .F.

	If Type('cFilAnt') == 'U'
		RpcClearEnv()
		RpcSetType(3)

		RpcSetEnv("99","01")
	Endif

	cLocal := GETMV("MN_MAGALOC",.T.,"C:\Users\gueld\Downloads\")


	cStartPath 	:= GetSrvProfString("StartPath","")

	//Função para realizar a copia dos arquivos para dentro da System
	lCopy 		:= __CopyFile(cLocal+cArquivo, cStartPath+cArquivo) 

	If lCopy
		
		FErase(cLocal+cArquivo) //Realiza a exclusão do arquivo copiado

		//Função responsavel pela conversão do arquivo XLS 
		aDados := U_CargaXLS(cArquivo,cStartPath,1,.F.) //Arquivo , Caminho , Linhas a serem puladas como cabeçalho , Executa em Tela

		DbSelectArea("P02")

		For N := 1 To Len(aDados)
			If !Empty(aDados[N][5])
				RecLock("P02",.T.)

				P02->P02_FILIAL         := xFilial('P02')
				P02->P02_DATA           := STOD(SUBSTR(aDados[N][2],7,4)+ SUBSTR(aDados[N][2],4,2) +SUBSTR(aDados[N][2],1,2))
				P02->P02_IDPED          := aDados[N][4]
				P02->P02_IDSELL         := aDados[N][5]
				P02->P02_IDTRAN         := aDados[N][6]
				P02->P02_PARCEL         := aDados[N][10]
				P02->P02_VALLIQ         := VAL(aDados[N][12])
				P02->P02_VALBRU         := VAL(aDados[N][16])
				P02->P02_TAXA           := VAL(aDados[N][15])

				P02->(MsUnlock())

				cRet := "true"
			EndIf

		Next
	EndIf

Return cRet
