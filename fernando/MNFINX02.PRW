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
Fonte responsavel pela grava��o dos dados do arquivo de concilia��o bancaria da adquirente Mazine Luiza
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

		RpcSetEnv("01","01")
	Endif

	cLocal := GETMV("MN_MAGALOC",.T.,"C:\app_node\magalu.csv")


	cStartPath 	:= GetSrvProfString("StartPath","")

	//Fun��o para realizar a copia dos arquivos para dentro da System
	lCopy 		:= __CopyFile(cLocal+cArquivo, cStartPath+cArquivo) 

	If lCopy
		
		FErase(cLocal+cArquivo) //Realiza a exclus�o do arquivo copiado

		//Fun��o responsavel pela convers�o do arquivo XLS 
		aDados := U_CargaXLS(cArquivo,cStartPath,1,.F.) //Arquivo , Caminho , Linhas a serem puladas como cabe�alho , Executa em Tela

		DbSelectArea("P06")

		For N := 1 To Len(aDados)
			If !Empty(aDados[N][5])
				RecLock("P06",.T.)

				P06->P06_FILIAL         := xFilial('P06')
				P06->P06_DATA           := STOD(SUBSTR(aDados[N][2],7,4)+ SUBSTR(aDados[N][2],4,2) +SUBSTR(aDados[N][2],1,2))
				P06->P06_IDPED          := aDados[N][4]
				P06->P06_IDSELL         := aDados[N][5]
				P06->P06_IDTRAN         := aDados[N][6]
				P06->P06_PARCEL         := u_RetParcela(aDados[N][10])
				P06->P06_VALLIQ         := VAL(aDados[N][12])
				P06->P06_VALBRU         := VAL(aDados[N][16])
				P06->P06_TAXA           := VAL(aDados[N][15])
				P06->P06_STATUS         :='1'
				P06->(MsUnlock())

				cRet := "true"
			EndIf

		Next
	EndIf

Return cRet
