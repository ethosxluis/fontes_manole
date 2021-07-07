#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Topconn.ch"
#Include "Fileio.ch"
#INCLUDE "stdwin.ch"
#include "Rwmake.ch"
#INCLUDE "Ap5Mail.ch"
#Include 'ApWebEx.ch'

/*/{Protheus.doc} MNFINX03
Fonte responsavel pela gravação dos dados do arquivo de conciliação bancaria da adquirente Carrefour
@type function
@version 1.0 
@author Guelder A. Santos
@since 24/02/2021
@return Caracter
/*/
User Function MNFINX03(cArquivo)
	Local lCabec    	:= .T.
	Local cMemo     	:= ""
	Local aDados    	:= {}
	Local cLocal		:= ""
	Local cStartPath	:= ""
	Local lCopy			:= .F.
	
	Private cRet      	:= "false"

	If Type('cFilAnt') == 'U'
		RpcClearEnv()
		RpcSetType(3)

		RpcSetEnv("99","01")
	Endif

	cLocal 		:= GETMV("MN_ARQLOC",.T.,"C:\Users\gueld\Downloads\")

	cStartPath 	:= GetSrvProfString("StartPath","")

	
	lCopy 		:= __CopyFile(cLocal+cArquivo, cStartPath+cArquivo)  //Função para realizar a copia dos arquivos para dentro da System

	If lCopy
		
		FErase(cLocal+cArquivo) //Realiza a exclusão do arquivo copiado

    	FT_FUse(cStartPath+cArquivo) // Abre o arquivo
		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()

    	While !FT_FEof() 
			IncProc("Lendo arquivo CSV...")
			cMemo := FT_FReadln()

			If lCabec
				lCabec := .F.
			Else
		
		    	cMemo := FT_FReadln()
	        	aAdd(aDados, StrTokArr(cMemo, ";"))
				cRet := MNFINX003(aDados)

			EndIf		

        	FT_FSkip()

		EndDo
		
		FT_FUse() // Fecha o arquivo     
	EndIf

   
Return cRet
		

/*/{Protheus.doc} MNFINX003
Função responsavel pela Gravação da tabela com as informações do arquivo de conciliação bancaria.
@type function
@version  
@author gueld
@since 24/02/2021
@param aDados, array, param_description
@return return_type, return_description
/*/
Static Function MNFINX003(aDados)
    Local nVal  := 0
	
    Default aDados    := {}

        DbSelectArea("P02")

        If "DESPESAS" $ UPPER(aDados[1][7])
            DbSelectArea("P02")
            P02->(DbSetOrder(1))
            If P02->(DbSeek(xFilial("P02")+aDados[1][4]) )
                nVal := P02->P02_VALLIQ
                RecLock("P02",.F.)
                P02->P02_VALLIQ         := nVal + VAL(aDados[1][10])
                P02->P02_VALBRU         := nVal + VAL(aDados[1][10])

                P02->(MsUnlock())
            EndIf

        ElseIf !(P02->(DbSeek(xFilial("P02")+aDados[1][4]) )) .AND. Len(aDados[1]) >= 12
            RecLock("P02",.T.)
    
            P02->P02_FILIAL         := xFilial('P02')
            P02->P02_DATA           := CTOD(SUBSTR(aDados[1][2],1,2)+ '/' + SUBSTR(aDados[1][2],4,2)+'/' +SUBSTR(aDados[1][2],7,2))
            P02->P02_IDPED          := aDados[1][5]
            P02->P02_IDSELL         := aDados[1][4]
            P02->P02_IDTRAN         := aDados[1][4]
            P02->P02_PARCEL         := aDados[1][6]//SUBSTR(aDados[1][4] , AT('-',aDados[1][4])+1 )
            P02->P02_VALLIQ         := VAL(aDados[1][12])
            P02->P02_VALBRU         := VAL(aDados[1][12])
            P02->P02_TAXA           := 0
        
            P02->(MsUnlock())

			cRet := "true"
        EndIf       
    
        aDados    := {}


Return cRet



