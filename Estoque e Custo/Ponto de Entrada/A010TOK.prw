// #########################################################################################
// Projeto: Cadastro de Produtos
// Modulo : Estoque/Custos
// Fonte  : A010TOK
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 01/12/16 | Cláudio Macedo    | Valida se o campo Categoria pertence à Área informada, e o 
//                              | campo Sub-categoria pertence à Categoria informada. 
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"


User Function A010TOK()

	Local cArea         := GetArea()
	Local lCategoria    := .F.
	Local lSubcategoria := .F. 
	Local lRet := .T.

	Local cMsg := "Deseja incluir este produto nas demais Filiais?"
	Local cCaption := "Copiando..."

	If M->B1_TIPO $ "PA"

	//-------------------- Verifica se a area foi informada
	If Empty(M->B1_DEPVTEX)
	Alert("Informe a area.")
	lRet := .F.	
	Endif

	If ! Empty(M->B1_DEPVTEX)
	//=================================================================\\
	//-------------------- Verifica a área possui categorias
	DbSelectArea("ZAF")
	DbSetOrder(1)
	lCategoria := DbSeek(xFilial("ZAF")+M->B1_DEPVTEX)
	//-------------------- Verifica se a categoria foi informada.
	If Empty(M->B1_CATEGOR)
	If lCategoria
	Alert("Informe a categoria.")
	lRet := .F.
	Endif	
	Else
		//-------------------- Verifica amarração de Área x Categoria
		DbSelectArea("ZAF")
		DbSetOrder(1)
		If ! DbSeek(xFilial("ZAF")+M->B1_DEPVTEX+M->B1_CATEGOR)
		Alert("A categoria não pertence a area informada.")
		lRet := .F.
	Endif
	Endif

	If ! Empty(M->B1_CATEGOR)
	//=================================================================\\
	//-------------------- Verifica a categoria possui sub-categorias
	DbSelectArea("ZAG")
	DbSetOrder(1)
	lSubCategoria := DbSeek(xFilial("ZAG")+M->B1_CATEGOR)
	//-------------------- Verifica se a sub-categoria foi informada.
	If Empty(M->B1_VTSUBCA)
	If lSubCategoria
	Alert("Informe a sub-categoria.")
	lRet := .F.				
	Endif
	Else
		//-------------------- Verifica amarração de Categoria x Sub-categoria
		DbSelectArea("ZAG")
		DbSetOrder(1)
		If ! DbSeek(xFilial("ZAG")+M->B1_CATEGOR+M->B1_VTSUBCA)
		Alert("A sub-categoria não pertence a categoria informada.")
		lRet := .F.
	Endif
	Endif
	Endif
	Endif

	//Implementações regras fiscais em 22/04/2019
	//Analista Fiscal: Andressa Santos
	//Analista Desenvolvimento: Edmar Mendes do Prado

	//Validação de produtos para o TIPO PA e grupos Tributarios	

	If !(M->B1_GRUPO $ "4001/4002/4003")  
	Alert("Grupo de Produto invalido para esse Tipo PA - Produto Acabado")
	lRet := .F.	
	ElseIf M->B1_GRUPO $ "4001" .And. !(Alltrim(M->B1_GRTRIB) == Alltrim("016")) 	
		Alert("Verifique o Grupo Tributario")
		lRet := .F.		
	ElseIf M->B1_GRUPO $ "4002" .And. !(Alltrim(M->B1_GRTRIB) == Alltrim("018"))  
		Alert("Verifique o Grupo Tributario")
		lRet := .F.
	ElseIf M->B1_GRUPO $ "4003" .And. !(Alltrim(M->B1_GRTRIB) == Alltrim("017"))
		Alert("Verifique o Grupo Tributario")
		lRet := .F.	
	EndIf

	IF (M->B1_GRUPO $ "4001" .And. (Alltrim(M->B1_GRTRIB) == Alltrim("016"))) .And. !(Alltrim(M->B1_XTIPO) == Alltrim("1"))
	Alert("Verifique o Tipo de Produto Manole")
	lRet := .F.		
	ElseIf (M->B1_GRUPO $ "4002" .And. (Alltrim(M->B1_GRTRIB) == Alltrim("018")))  .And. !(Alltrim(M->B1_XTIPO) == Alltrim("4"))
		Alert("Verifique o Tipo de Produto Manole")
		lRet := .F.
	ElseIf (M->B1_GRUPO $ "4003" .And. (Alltrim(M->B1_GRTRIB) == Alltrim("017")))  .And. !(Alltrim(M->B1_XTIPO) $ Alltrim("1/4"))
		Alert("Verifique o Tipo de Produto Manole")
		lRet := .F.
	EndIf


	ElseIf M->B1_TIPO $ "SV"
		Alert("Não há regra fiscal definida para esse Tipo!")
		lRet := .F.

	ElseIf M->B1_TIPO $ "SS"

		//Validação de produtos para o TIPO SS e grupos Tributarios	

		If !(M->B1_GRUPO $ "3001/3002/3003/3004/3005/3006/3007")  
		Alert("Grupo de Produto invalido para esse Tipo SS - Servicos")
		lRet := .F.	
	ElseIF M->B1_GRUPO $ "3001/3002/3003" .And. !(Alltrim(M->B1_GRTRIB) == Alltrim("013")) 	
		Alert("Verifique o Grupo Tributario")
		lRet := .F.		
	ElseIf M->B1_GRUPO $ "3004/3005/3006/3007" .And. !(Alltrim(M->B1_GRTRIB) == Alltrim("003"))  
		Alert("Verifique o Grupo Tributario")
		lRet := .F.
	EndIf

	IF (M->B1_GRUPO $ "3001/3002/3003" .And. Alltrim(M->B1_GRTRIB) == Alltrim("013")) .And. !(Alltrim(M->B1_XTIPO) == Alltrim("2"))
	Alert("Verifique o Tipo de Produto Manole")
	lRet := .F.		
	ElseIf (M->B1_GRUPO $ "3004/3005/3006/3007" .And. Alltrim(M->B1_GRTRIB) == Alltrim("003"))  .And. !(Alltrim(M->B1_XTIPO) == Alltrim("3"))
		Alert("Verifique o Tipo de Produto Manole")
		lRet := .F.
	EndIf

	ElseIf M->B1_TIPO $ "AI"

		//Validação de produtos para o TIPO SS e grupos Tributarios	

		If !(M->B1_GRUPO $ "2001")  
		Alert("Grupo de Produto invalido para esse Tipo AI - Ativo Fixo")
		lRet := .F.
	ElseIF M->B1_GRUPO $ "2001" .And. !(Alltrim(M->B1_GRTRIB) $ Alltrim("007/015")) 	
		Alert("Verifique o Grupo Tributario")
		lRet := .F.		
	EndIf

	IF  !(Alltrim(M->B1_XTIPO) == Alltrim("3"))
	Alert("Verifique o Tipo de Produto Manole")
	lRet := .F.		
	EndIf


	ElseIf M->B1_TIPO $ "MC"

		//Validação de produtos para o TIPO MC e grupos Tributarios	

		If !(M->B1_GRUPO $ "5001/5002")  
		Alert("Grupo de Produto invalido para esse Tipo MC - Material para Consumo")
		lRet := .F.
	ElseIF M->B1_GRUPO $ "5001" .And. !(Alltrim(M->B1_GRTRIB) $ Alltrim("005/012")) 	
		Alert("Verifique o Grupo Tributario")
		lRet := .F.		
	ElseIF M->B1_GRUPO $ "5002" .And. !(Alltrim(M->B1_GRTRIB) $ Alltrim("005")) 	
		Alert("Verifique o Grupo Tributario")
		lRet := .F.		
	EndIf

	IF  !(Alltrim(M->B1_XTIPO) == Alltrim("3"))
	Alert("Verifique o Tipo de Produto Manole")
	lRet := .F.		
	EndIf

	Else

		M->B1_DEPVTEX := SPACE(2)    
		M->B1_CATEGOR := SPACE(3)       
		M->B1_VTSUBCA := SPACE(3)

	Endif


	//Edmar Mendes do Prado - 03/04/2019
	//Exclui registro da SB0 
	DbSelectArea("SB0")
	DbGoTop()
	DbSetOrder(1)
	If SB0->(DbSeek(xFilial("SB0")+M->B1_COD))
	Reclock("SB0",.F.)
	DBDelete()
	Msunlock()

	//Insere novo registro SB0 para carga nos caixas
	Reclock("SB0",.T.)
	SB0->B0_FILIAL  := M->B1_FILIAL
	SB0->B0_COD     := M->B1_COD
	SB0->B0_PRV1    := M->B1_PRV1
	SB0->B0_ECFLAG  :=  '1'
	Msunlock()
	EndIf




if inclui 
	//mostra pergunta do parametro cMsg
	If ApMsgNoYes(cMsg, cCaption)
		//tabela com as informaçoes das filiais
		DbSelectArea("SM0")
			nRec := SM0->(Recno())
			SM0->(dbGoTop())
		While SM0->(!Eof())
			//Filial da tabela é diferente da filial logada?
			if SM0->M0_CODFIL <> cfilant
				RecLock("SB1",.T.)
				AvReplace("M","SB1")
				//altero a filial do produto
				SB1->B1_FILIAL = SM0->M0_CODFIL
				//libero registro
				SB1->(MsUnlock())
			endif
		//proximo registro
			SM0->(DbSkip())
		EndDo
			//libero registro
			//SM0->(dbCloseArea()) COMENTA ESSA LINHA NÃO PODE FECHAR ESSA TABELA
		SM0->(dbGoTo(nRec))
	endif

If Alltrim(SB1->B1_TIPO) <> "  "
	dbSelectArea("SB2")
    dbSetOrder(1)
	IF !SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD ))
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	EndIf							
EndIf


endif
	
//RestArea(aArea)
//Return

	RestArea(cArea)

Return 
