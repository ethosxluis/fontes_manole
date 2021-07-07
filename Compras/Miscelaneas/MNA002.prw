#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} MNA002
Cadastro de Produto x Autor
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@example MNA002()
/*/
//------------------------------------------------------------------------------\\
User Function MNA002()

Local cCadastro := 'Produto x Autor'

Private aRotina := {{'Pesquisar' ,'AxPesqui',0,1},;
					{'Visualizar','U_MNA002I(2)',0,2},;
					{'Incluir'   ,'U_MNA002I(3)',0,3},;
					{'Alterar'   ,'U_MNA002I(4)',0,4},;
					{'Excluir'   ,'U_MNA002I(5)',0,5}}

DbSelectArea("ZZC")
DbSetOrder(1)

mBrowse(6,1,22,75,"ZZC")


Return Nil

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} MNA002I
Rotina dde manipulação de dados
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@param nOpcx, numérico, 2-Visualizar
						3-Incluir
						4-Alterar
						5-Excluir
@example MNA002I(nOpcx)
/*/
//------------------------------------------------------------------------------\\
User Function MNA002I(nOpcx)

Local aArea    := GetArea()
Local aButtons := {}
Local aGetSD   := {}
Local nUsado   := 0
Local nI := {}

Private cCodigo := Space(15)
Private cDesc   := Space(100)
Private aHeader := {}
Private aCols   := {}

If nOpcx <> 3	// Visualizar, Alterar ou Excluir
	cCodigo := ZZC->ZZC_PRODUT
	cDesc   := Posicione('SB1',1,xFilial('SB1')+cCodigo,'B1_VTTITUL')
EndIf
//------------------------------------------------------------------------\\
//---------------------------- Define aHeader ----------------------------\\
//------------------------------------------------------------------------\\
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZZC")

While !Eof() .AND. (X3_ARQUIVO == "ZZC")
	If Trim(X3_CAMPO) == "ZZC_PRODUT" .OR. Trim(X3_CAMPO) == "ZZC_TITULO" .OR. Trim(X3_CAMPO) == "ZZC_FILIAL"
		DbSkip()
		Loop
	Endif
	
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado := nUsado + 1
		AADD(aHeader,{Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllWaysTrue()", X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
		If X3_CONTEXT = 'R'
			Aadd(aGetSD, X3_CAMPO)
		Endif
	Endif
	dbSkip()
Enddo

//----------------------------------------------------------------------\\
//--------------------------- Define aCols -----------------------------\\
//----------------------------------------------------------------------\\
If nOpcx == 3
	aCols := Array(1,nUsado+1)
	DbSelectArea("Sx3")
	DbSeek("ZZC")
	nUsado := 0
	While !Eof() .And. (x3_arquivo == "ZZC")
		IF TRIM(X3_CAMPO) == "ZZC_PRODUT" .OR. TRIM(X3_CAMPO) == "ZZC_TITULO" .OR. TRIM(X3_CAMPO) == "ZZC_FILIAL"
			DBSKIP()
			LOOP
		ENDIF
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
			nUsado:=nUsado+1
			IF nOpcx == 3
					IF x3_tipo == "C"
						aCOLS[1][nUsado] := SPACE(x3_tamanho)
					Elseif x3_tipo == "N"
						aCOLS[1][nUsado] := 0
					Elseif x3_tipo == "D"
						aCOLS[1][nUsado] := dDataBase
					Elseif x3_tipo == "M"
						aCOLS[1][nUsado] := " "
					Else
						aCOLS[1][nUsado] := .F.
					Endif
			Endif
		Endif
		dbSkip()
	End
	aCOLS[1][nUsado+1] := .F.
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aArea := GetArea()
	dbSelectArea('ZZC')
	ZZC->( dbSetOrder(1) )
	ZZC->(dbSeek(XFILIAL('ZZC')+cCodigo))
	aCols := {}
	
	While ZZC->( !Eof() .And. cCodigo == ZZC_PRODUT )
		AADD(aCols,Array(nUsado+1))

		For nI := 1 to nUsado
			If aHeader[nI][2] = 'ZZC_NOME'  //Campo virtual
				//aCols[Len(aCols),nI] := Posicione('ZZB',1,xFilial('ZZB')+ZZC_EDITOR,'ZZB_NOME')
				aCols[Len(aCols),nI] := Posicione('SA2',1,xFilial('SA2')+ZZC_EDITOR+ZZC_LOJA,'A2_NOME')
			Else
				aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next
		aCols[Len(aCols),nUsado+1] := .F.
		ZZC->(DbSkip())
	End
	RestArea(_aArea)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinGetD:=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nOpcx == 3
	lAlterar := .t.
	cTitulo   := "Incluir Produto x Autores"
Else
	If nOpcx == 4 // alterar
		cTitulo := "Alterar Produto x Autores"
		lAlterar := .t.
	ElseIf nOpcx == 2 // visualiar
		cTitulo := "Visualizar Produto x Autores"
		lAlterar := .f.
	ElseIf nOpcx == 5 // excluir
		cTitulo := "Excluir Produto x Autores"
		lAlterar := .f.		
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
// monta cabeçalho

AADD(aC,{"cCodigo",{15,10} ,OemToAnsi("Produto")  ,X3PICTURE("ZZC_PRODUT"),"NAOVAZIO().And. U_ProdVal(cCodigo)","SB1",If(nOpcx==3,.T.,.F.)})
AADD(aC,{"cDesc"  ,{15,130},OemToAnsi("Descricao"),"@!","NAOVAZIO()",,.F.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
// Monta rodape
//	AADD(aR,{"nLinGetD"	,{120,10},"Linha na GetDados"	,"@E 999",,,.F.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  aCGD:={44,5,118,315}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLinhaOk := "U_LinhaOK()"
cTudoOK  := "ALLWAYSTRUE()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
// lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,,.T.,.T.,aButtons)
If lRetMod2
	
	If ( nOpcx == 3 .or. nOpcx == 4 )
		
		If nOpcx == 4
			ZZC->(dbSetOrder(1))
			ZZC->(dbSeek(xFilial("ZZC")+cCodigo))
			While ZZC->(!Eof() .And. ZZC_PRODUT == cCodigo)
				RecLock("ZZC", .f. )
				ZZC->(dbDelete())
				ZZC->(MsUnlock())
				ZZC->(dbSkip())
			EndDo
		EndIf	
		DbSelectArea("ZZC")
		// Inclusao das linhas do Escopo
		For nI := 1 to len(aCols)
			If !aCols[nI][nUsado+1] 
				While !RecLock("ZZC",.t.)
					loop
				End
				ZZC->ZZC_FILIAL := xFilial("ZZC")
				ZZC->ZZC_PRODUT := cCodigo
				ZZC->ZZC_EDITOR := aCols[nI][1]
				ZZC->ZZC_LOJA	:= aCols[nI][2]
				ZZC->(MsUnlock())	
			Endif
		Next			
	ElseIf nOpcx == 5 // Exclusao		
		ZZC->(dbSetOrder(1))
		ZZC->(dbSeek(xFilial("ZZC")+cCodigo))
		While ZZC->(!Eof() .And. ZZC_PRODUT == cCodigo)
			RecLock("ZZC", .f. )
			ZZC->(dbDelete())
			ZZC->(dbSkip())
			ZZC->(MsUnlock())
		EndDo
	Endif
EndIf

Return

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} ProdVal
Validar código do produto
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@param cCodigo, character, Código do produto
@return lRet
@example ProdVal(cCodigo)
/*/
//------------------------------------------------------------------------------\\
User Function ProdVal(cCodigo)
Local lRet := .T.

aArea     := GetArea()
aAreaZZC  := ZZC->(GetArea())
cMensagem := ''

If ! Empty(cCodigo)
	ZZC->(dbSetOrder(1))
	If ZZC->(dbSeek(xFilial("ZZC")+cCodigo))
		cMensagem := "Produto com autores já cadastrados"
	Else
		If ! SB1->(DbSeek(xFilial('SB1')+cCodigo))
			cMensagem := "Produto não cadastrado"
		Else
			cDesc := SB1->B1_VTTITUL
		Endif
	EndIf
EndIf
				
If ! Empty(cMensagem)
	MsgAlert(cMensagem)
	lRet := .F.
Endif
				
RestArea(aAreaZZC)
RestArea(aArea)

Return(lRet)
//------------------------------------------------------------------------------\\
/*/{Protheus.doc} LinhaOK
Validar linha do grid
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@return lRet
@example LinhaOK()
/*/
//------------------------------------------------------------------------------\\
User Function LinhaOK()

Local nLinhaAtual := n 
Local lRet := .T.
Local nI   := 0 

//If aCols[nLinhaAtual][3] == .F.
If aCols[nLinhaAtual][4] == .F.
	For nI := 1 to Len( aCols ) 
	   //If (aCols[nLinhaAtual,1] == aCols[nI,1]) .AND. nI <> nLinhaAtual .AND. aCols[nI][3] == .F.
	   If (aCols[nLinhaAtual,1] == aCols[nI,1]) .AND. nI <> nLinhaAtual .AND. aCols[nI][4] == .F.
	      MsgInfo('Autor já cadastrado para este produto') 
	      lRet := .F. 
	   EndIf 
	Next nI
Endif

Return lRet
