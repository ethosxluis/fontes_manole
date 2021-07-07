#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} MNA005
Cadastro de Usuário x Exceção de Fornecedor
@type function
@author Claudio
@since 29/12/2017
@version 1.0
@example MNA005()
/*/
//------------------------------------------------------------------------------\\
User Function MNA005()

Local cCadastro := 'Usuário x Exceção de Fornecedor'

Private aRotina := {{'Pesquisar' ,'AxPesqui',0,1},;
					{'Visualizar','U_MNA005I(2)',0,2},;
					{'Incluir'   ,'U_MNA005I(3)',0,3},;
					{'Alterar'   ,'U_MNA005I(4)',0,4},;
					{'Excluir'   ,'U_MNA005I(5)',0,5}}

DbSelectArea("ZZG")
DbSetOrder(1)

mBrowse(6,1,22,75,"ZZG")

Return Nil

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} MNA005I
Rotina de manipulação de dados
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@param nOpcx, numérico, 2-Visualizar
						3-Incluir
						4-Alterar
						5-Excluir
@example MNA005I(nOpcx)
/*/
//------------------------------------------------------------------------------\\
User Function MNA005I(nOpcx)

Local aArea    := GetArea()
Local aButtons := {}
Local aGetSD   := {}
Local nUsado   := 0
Local nI := {}

Private cUsuario     := Space(6)
Private cNomeUsuario := Space(40)
Private aHeader := {}
Private aCols   := {}

If nOpcx <> 3	// Visualizar, Alterar ou Excluir
	cUsuario := ZZG->ZZG_USER
	cNomeUsuario := UsrFullName(cUsuario)
EndIf
//------------------------------------------------------------------------\\
//---------------------------- Define aHeader ----------------------------\\
//------------------------------------------------------------------------\\
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZZG")

While !Eof() .AND. (X3_ARQUIVO == "ZZG")
	If Trim(X3_CAMPO) == "ZZG_USER" .OR. Trim(X3_CAMPO) == "ZZG_NOMUSE" .OR. Trim(X3_CAMPO) == "ZZG_FILIAL"
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
	DbSelectArea("SX3")
	DbSeek("ZZG")
	nUsado := 0
	While !Eof() .And. (x3_arquivo == "ZZG")
		IF TRIM(X3_CAMPO) == "ZZG_USER" .OR. TRIM(X3_CAMPO) == "ZZG_NOMUSE" .OR. TRIM(X3_CAMPO) == "ZZG_FILIAL"
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
	dbSelectArea('ZZG')
	ZZG->( dbSetOrder(1) )
	ZZG->(dbSeek(XFILIAL('ZZG')+cUsuario))
	aCols := {}
	
	While ZZG->( !Eof() .And. cUsuario == ZZG_USER )
		AADD(aCols,Array(nUsado+1))

		For nI := 1 to nUsado
			If aHeader[nI][2] = 'ZZG_NOMFOR'  //Campo virtual
				aCols[Len(aCols),nI] := Posicione('SA2',1,xFilial('SA2')+ZZG_FORNEC,'A2_NOME')
			Else
				aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next
		aCols[Len(aCols),nUsado+1] := .F.
		ZZG->(DbSkip())
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
	cTitulo   := "Incluir Usuário x Exceção de Fornecedor"
Else
	If nOpcx == 4 // alterar
		cTitulo := "Alterar Usuário x Exceção de Fornecedor"
		lAlterar := .t.
	ElseIf nOpcx == 2 // visualiar
		cTitulo := "Visualizar Usuário x Exceção de Fornecedor"
		lAlterar := .f.
	ElseIf nOpcx == 5 // excluir
		cTitulo := "Excluir Usuário x Exceção de Fornecedor"
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

AADD(aC,{"cUsuario",{15,10} ,OemToAnsi("Usuário")  ,X3PICTURE("ZZG_USER"),"NAOVAZIO().And. U_ValUser(cUsuario)","USR",If(nOpcx==3,.T.,.F.)})
AADD(aC,{"cNomeUsuario"  ,{15,130},OemToAnsi("Nome"),"@!","NAOVAZIO()",,.F.})

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

cLinhaOk := "U_LinhaOK5()"
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
			ZZG->(dbSetOrder(1))
			ZZG->(dbSeek(xFilial("ZZG")+cUsuario))
			While ZZG->(!Eof() .And. ZZG_USER == cUsuario)
				RecLock("ZZG", .f. )
				ZZG->(dbDelete())
				ZZG->(MsUnlock())
				ZZG->(dbSkip())
			EndDo
		EndIf	
		DbSelectArea("ZZG")
		// Inclusao das linhas do Escopo
		For nI := 1 to len(aCols)
			If !aCols[nI][nUsado+1] 
				While !RecLock("ZZG",.T.)
					loop
				End
				ZZG->ZZG_FILIAL := xFilial("ZZG")
				ZZG->ZZG_USER   := cUsuario
				ZZG->ZZG_FORNEC := aCols[nI][1]
				ZZG->(MsUnlock())	
			Endif
		Next			
	ElseIf nOpcx == 5 // Exclusao		
		ZZG->(dbSetOrder(1))
		ZZG->(dbSeek(xFilial("ZZG")+cUsuario))
		While ZZG->(!Eof() .And. ZZG_USER == cUsuario)
			RecLock("ZZG", .f. )
			ZZG->(dbDelete())
			ZZG->(dbSkip())
			ZZG->(MsUnlock())
		EndDo
	Endif
EndIf

Return

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} ValUser
Validar código do usuário
@type function
@author Claudio
@since 30/01/2018
@version 1.0
@param cUsuario, character, Código do usuário
@return lRet
@example ValUser(cUsuario)
/*/
//------------------------------------------------------------------------------\\
User Function ValUser(cUsuario)
Local lRet := .T.

aArea     := GetArea()
aAreaZZG  := ZZG->(GetArea())
cMensagem := ''

If ! Empty(cUsuario)
	ZZG->(dbSetOrder(1))
	If ZZG->(dbSeek(xFilial("ZZG")+cUsuario))
		cMensagem := "Usuário já incluído"
	Else
		If ! UsrExist(cUsuario)
			cMensagem := "Usuário não cadastrado"
		Else
			cNomeUsuario := UsrFullName(cUsuario)
		Endif
	EndIf
EndIf
				
If ! Empty(cMensagem)
	MsgAlert(cMensagem)
	lRet := .F.
Endif
				
RestArea(aAreaZZG)
RestArea(aArea)

Return(lRet)
//------------------------------------------------------------------------------\\
/*/{Protheus.doc} LinhaOK5
Validar linha do grid
@type function
@author Claudio
@since 30/01/2018
@version 1.0
@return lRet
@example LinhaOK5()
/*/
//------------------------------------------------------------------------------\\
User Function LinhaOK5()
Local nLinhaAtual := n 
Local lRet := .T.
Local nI   := 0 

If aCols[nLinhaAtual][3] == .F.
	For nI := 1 to Len( aCols ) 
	   If (aCols[nLinhaAtual,1] == aCols[nI,1]) .AND. nI <> nLinhaAtual .AND. aCols[nI][3] == .F.
	      MsgInfo('Fornecedor já cadastrado para este usuário') 
	      lRet := .F. 
	   EndIf 
	Next nI
Endif

Return lRet
