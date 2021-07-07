#include "protheus.ch"
#include "parmtype.ch"

//http://tdn.totvs.com/display/public/PROT/ADV0041_PE_MVC_MATA010_P12
 
User Function ITEM()
    Local aParam := PARAMIXB
    Local xRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
    Local nLinha := 0
    Local nQtdLinhas := 0
    Local cMsg := ""

	Local aGrupos 	:=	UsrRetGrp(cUserName)		// Carrega os grupos do usuário
	Local cGrupLog	:=	SuperGetMV("MN_GRPLOG")		// Parametro que contem o grupo Manole Cursos	
	Local lBloqueia	:= .F.
	Local cCadProd	:= "roberta.lima@manole.com.br;gabryel.fernandes@manole.com.br;walter@manole.com.br;"
	
		 
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
 
        If cIdPonto == "MODELPOS"
            //cMsg := "Chamada na validação total do modelo." + CRLF
            //cMsg += "ID " + cIdModel + CRLF
 
            //xRet := ApMsgYesNo(cMsg + "Continua?")
 
        ElseIf cIdPonto == "FORMPOS"
            //cMsg := "Chamada na validação total do formulário." + CRLF
            //cMsg += "ID " + cIdModel + CRLF
 					 
            If lIsGrid
                //cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
                //cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
            Else
                //cMsg += "É um FORMFIELD" + CRLF
            EndIf
 
            //xRet := ApMsgYesNo(cMsg + "Continua?")
 
        ElseIf cIdPonto == "FORMLINEPRE"
            If aParam[5] == "DELETE"
                //cMsg := "Chamada na pré validação da linha do formulário. " + CRLF
                //cMsg += "Onde esta se tentando deletar a linha" + CRLF
                //cMsg += "ID " + cIdModel + CRLF
                //cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
                //cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
                //xRet := ApMsgYesNo(cMsg + " Continua?")
            EndIf
 
        ElseIf cIdPonto == "FORMLINEPOS"
            //cMsg := "Chamada na validação da linha do formulário." + CRLF
            //cMsg += "ID " + cIdModel + CRLF
            //cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
            //cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
            //xRet := ApMsgYesNo(cMsg + " Continua?")
 
        ElseIf cIdPonto == "MODELCOMMITTTS"
            //ApMsgInfo("Chamada após a gravação total do modelo e dentro da transação.")
 
        ElseIf cIdPonto == "MODELCOMMITNTTS"
            //ApMsgInfo("Chamada após a gravação total do modelo e fora da transação.")
 
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
            //ApMsgInfo("Chamada após a gravação da tabela do formulário.")
 
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
            //ApMsgInfo("Chamada após a gravação da tabela do formulário.")

			IF !EMPTY(SB1->B1_LINKVTX)
			//TODO VERIFICAR MT010INC E MT010ALT
				/*oObj	:= WSServiceVtex():new()
				oObj:oWSproductVO:nBrandId                  := val(SB1->B1_VTMARCA)
				oObj:oWSproductVO:nCategoryId               := val(SB1->B1_CATEGOR) //71 //_IdCategoria
				oObj:oWSproductVO:nDepartmentId             := val(SB1->B1_DEPVTEX) //6 //_IdDepartamento (Não alterável)
				oObj:OWSPRODUCTVO:CDESCRIPTION              := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" // DESCRIÇÃO DO PRODUTO
				oObj:oWSproductVO:cDescriptionShort         := alltrim(SB1->B1_DESC) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA" // DESCRIÇÃO CURTA
				oObj:oWSproductVO:nId                       := val(SB1->B1_IDSKU)    //  //SB1->B1_IDSKU codigo sequencial RECNO
				oObj:oWSproductVO:lIsActive                 := .t. //se não atender requisitos de ativação(ter SKUs ativas), não será ativado
				oObj:oWSproductVO:lIsVisible                := .t. // vai ser visível no site
				oObj:oWSproductVO:cKeyWords                 := alltrim(SB1->B1_KEYPSQ1) // "1DICIONARIO, CREYSSON, CASSETA, PLANETA, "// palavras chaves relevantes para a busca
				oObj:oWSproductVO:cLinkId                   := alltrim(SB1->B1_LINKVTX) //"2"// site principal
				oObj:oWSproductVO:oWSListStoreId            :=  Service_ArrayOfint():new()
				oObj:oWSproductVO:cMetaTagDescription       := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!" //meta tag de description (SEO)
				oObj:oWSproductVO:cName                     := alltrim(SB1->B1_DESC)  //nome do produto
				oObj:oWSproductVO:cRefId                    := alltrim(SB1->B1_COD) //identificador do produto no ERP
				oObj:oWSproductVO:cTitle                    := alltrim(SB1->B1_DVETEX1) //"1DICIONARIO DO SEU CREYSSON CASSETA E PLANETA - PERGUNTE AO SEU CREYSSON - YOUTUBE - ENCICROPEDIA!!!!"
				oObj:ProductInsertUpdate(oObj:oWSproductVO)
				IF !EMPTY(oObj:CMESSAGE)
					AVISO("Aviso",oObj:CMESSAGE,{"OK"})
				ENDIF
				*/
				u_MNPRICE(SB1->B1_IDSKU,SB1->B1_PRV1)
			ENDIF
			
			// Cadastro de produtos nos armazens
			If Alltrim(SB1->B1_TIPO) == "SS"
				dbSelectArea("SB2")
			    dbSetOrder(1)
				IF !SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD ))
					CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
				EndIf							
			EndIf
			
			//Unidade de Medida para exportacao
			If Alltrim(SB1->B1_POSIPI) $ "49019900/49011000"
				dbSelectArea("SB5")
				dbSetOrder(1)
				If SB5->(dbSeek(xFilial("SB5") + SB1->B1_COD ))
					If Empty(SB5->B5_UMDIPI)
						RecLock('SB5',.F.)
							SB5->B5_UMDIPI := "KG"
						SB5->(MsUnLock())
					EndIf   
				EndIf
			EndIf
			
			//Bloqueia os produtos que foram cadastrados pela Logistica
			If Alltrim(SUBSTR(SB1->B1_COD,1,8)) $ "97885204"	
				For nI := 1 to Len(aGrupos)
					If aGrupos[nI] $ cGrupLog
						
						lBloqueia	:= .T.
						
						//If Inclui 
							MsgAlert("Produto ficará bloqueado, solicite alteração ao departamento responsável !")
							
							RecLock('SB1',.F.)
								SB1->B1_MSBLQL := "1"
							SB1->(MsUnLock())
					
						//EndIf
						
					EndIf
				Next nI
			EndIf
			
			//Envia email para cadastro de produtos para que insiram contratos de D.A.
			If lBloqueia == .T.
				Conout("** Produto Manole Cadastrado pela Logistica " + DtoC(Date()) + " - " + Time() + " **")
				U_EXPMAIL(cCadProd , "Produto MANOLE cadastrado pela Logistica: " + SB1->B1_COD, " Faça a analise do cadastro e Contratos de D.A. ")
			EndIf
			
			
        ElseIf cIdPonto == "MODELCANCEL"
            //cMsg := "Deseja realmente sair?"
            //xRet := ApMsgYesNo(cMsg)
 
        ElseIf cIdPonto == "BUTTONBAR"
            xRet := {{"Salvar", "SALVAR", {||u_TSMT010()}}}
        EndIf
    EndIf
Return xRet
 
User Function TSMT010()
    Alert("Buttonbar")
Return NIL