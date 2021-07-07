#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} MNA006
Cadastro de informa��es para RPA
@type function
@author Claudio
@since 11/04/2018
@version 1.0
@example MNA006()
/*/
//------------------------------------------------------------------------------\\
User Function MNA006()

Local cCadastro := 'Informa��es para RPA'

Private aRotina := {{'Pesquisar' ,'AxPesqui',0,1},;
					{'Visualizar','U_MNA006I(2)',0,2},;
					{'Incluir'   ,'U_MNA006I(3)',0,3},;
					{'Alterar'   ,'U_MNA006I(4)',0,4},;
					{'Excluir'   ,'U_MNA006I(5)',0,5}}

DbSelectArea("SZ4")
DbSetOrder(1)

mBrowse(6,1,22,75,"SZ4")

Return Nil

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} MNA006I
Rotina dde manipula��o de dados
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@param nOpcx, num�rico, 2-Visualizar
						3-Incluir
						4-Alterar
						5-Excluir
@example MNA002I(nOpcx)
/*/
//------------------------------------------------------------------------------\\
User Function MNA006I(nOpcx)

Local aArea    := GetArea()
Local aButtons := {}
Local aGetSD   := {}
Local nUsado   := 0
Local nI := {}

Private cFornec  := space(6)
Private cLoja    := space(2)
Private cNomeFor := Space(40)
Private dDtNasc  := STOD(space(10))
Private cPIS     := space(11)
Private cNacio   := space(25)
Private cNatur   := space(25)
Private cBanco   := space(4)
Private cAgencia := space(6)
Private cConta   := space(10)
Private aHeader  := {}
Private aCols    := {}

If nOpcx <> 3	// Visualizar, Alterar ou Excluir
	cFornec  := SZ4->Z4_FORNEC
	cNomeFor := Posicione('SA2',1,xFilial('SA2')+cFornec,'A2_NOME')
	cLoja    := SZ4->Z4_LOJA
	dDtNasc  := SZ4->Z4_DTNASC
	cPIS     := SZ4->Z4_PIS
	cNacio   := SZ4->Z4_NACIO
	cNatur   := SZ4->Z4_NATUR
	cBanco   := SZ4->Z4_BANCO
	cAgencia := SZ4->Z4_AGENCIA
	cConta   := SZ4->Z4_CONTA
EndIf
//------------------------------------------------------------------------\\
//---------------------------- Define aHeader ----------------------------\\
//------------------------------------------------------------------------\\
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ5")

While !Eof() .AND. (X3_ARQUIVO == "SZ5")
	If Trim(X3_CAMPO) == "Z5_FORNEC" .OR. Trim(X3_CAMPO) == "Z5_LOJA" .OR. Trim(X3_CAMPO) == "Z5_FILIAL"
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
	DbSeek("SZ5")
	nUsado := 0
	While !Eof() .And. (x3_arquivo == "SZ5")
		IF TRIM(X3_CAMPO) == "Z5_FORNEC" .OR. TRIM(X3_CAMPO) == "Z5_LOJA" .OR. TRIM(X3_CAMPO) == "Z5_FILIAL"
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
	//��������������������������������������������������������������Ŀ
	//� Montando aCols                                               �
	//����������������������������������������������������������������
	_aArea := GetArea()
	dbSelectArea('SZ5')
	SZ5->( dbSetOrder(1) )
	SZ5->(dbSeek(XFILIAL('SZ5')+cFornec+cLoja))
	aCols := {}
	
	While SZ5->( !Eof() .And. cFornec == Z5_FORNEC .And. cLoja == Z5_LOJA)
		AADD(aCols,Array(nUsado+1))

		For nI := 1 to nUsado
			aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
		Next
		aCols[Len(aCols),nUsado+1] := .F.
		SZ5->(DbSkip())
	End
	RestArea(_aArea)
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
nLinGetD:=0
//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������

If nOpcx == 3
	lAlterar := .t.
	cTitulo   := "Incluir informa��es para RPA"
Else
	If nOpcx == 4 // alterar
		cTitulo := "Alterar informa��es para RPA"
		lAlterar := .t.
	ElseIf nOpcx == 2 // visualiar
		cTitulo := "Visualizar informa��es para RPA"
		lAlterar := .f.
	ElseIf nOpcx == 5 // excluir
		cTitulo := "Excluir informa��es para RPA"
		lAlterar := .f.		
	EndIf
EndIf
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
// monta cabe�alho

AADD(aC,{"cFornec"  ,{20,10} ,"Fornecedor             "  ,X3PICTURE("SZ5_FORNEC"),"NAOVAZIO().And. U_ValFor(cFornec)","SA2",If(nOpcx==3,.T.,.F.)})
AADD(aC,{"cLoja"    ,{20,120},"Loja       "  ,X3PICTURE("SZ5_LOJA"),"NAOVAZIO().And. U_ValLoja(cFornec,cLoja,@cNomeFor)","",If(nOpcx==3,.T.,.F.)})
AADD(aC,{"cNomeFor" ,{20,300},"Nome           ","@!","NAOVAZIO()",,.F.})
AADD(aC,{"dDtNasc"  ,{40,10} ,"Data de Nascimento","@!",,,}) 
AADD(aC,{"cPIS"     ,{40,300},"N� do PIS     "      ,"@!",,,}) 
AADD(aC,{"cNacio"   ,{60,10} ,"Nacionalidade          ","@!",,,})
AADD(aC,{"cNatur"   ,{60,300},"Naturalidade"      ,"@!",,,})
AADD(aC,{"cBanco"   ,{80,10} ,"Banco                      ","@!",,,})
AADD(aC,{"cAgencia" ,{80,120},"Agencia " ,"@!",,,})
AADD(aC,{"cConta"   ,{80,300},"Conta           " ,"@!",,,})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

  aCGD:={200,5,3188,315}

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������

cLinhaOk := "U_LA006OK()"
cTudoOK  := "ALLWAYSTRUE()"

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
// lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,,.T.,.T.,aButtons)
If lRetMod2
	
	If nOpcx == 3 
	
		DbSelectArea("SZ4")
		// Inclusao dcampos da enchoice
		RecLock("SZ4",.T.)
		SZ4->Z4_FILIAL  := xFilial("SZ4")
		SZ4->Z4_FORNEC  := cFornec
		SZ4->Z4_LOJA    := cLoja
		SZ4->Z4_DTNASC  := dDtNasc
		SZ4->Z4_PIS     := cPIS
		SZ4->Z4_NACIO   := cNacio
		SZ4->Z4_NATUR   := cNatur
		SZ4->Z4_BANCO   := cBanco
		SZ4->Z4_AGENCIA := cAgencia
		SZ4->Z4_CONTA   := cConta
		SZ4->(MsUnlock())	

		// Inclusao das linhas do GetDados
		DbSelectArea("SZ5")
		For nI := 1 to len(aCols)
			If !aCols[nI][nUsado+1] 
				While !RecLock("SZ5",.T.)
					loop
				Enddo
				SZ5->Z5_FILIAL := xFilial("SZ5")
				SZ5->Z5_FORNEC := cFornec
				SZ5->Z5_LOJA   := cLoja
				SZ5->Z5_NOME   := aCols[nI][1]
				SZ5->Z5_DTNASC := aCols[nI][2]
				SZ5->Z5_PARENT := aCols[nI][3]
				SZ5->Z5_CPF    := aCols[nI][4]
				SZ5->(MsUnlock())	
			Endif
		Next			
	ElseIf nOpcx == 4
		SZ5->(dbSetOrder(1))
		SZ5->(dbSeek(xFilial("SZ5")+cFornec+cLoja))
		While SZ5->(!Eof() .And. SZ5->Z5_FORNEC == cFornec .And. SZ5->Z5_LOJA == cLoja)
			RecLock("SZ5", .F. )
			SZ5->(dbDelete())
			SZ5->(MsUnlock())
			SZ5->(dbSkip())
		EndDo
		DbSelectArea("SZ4")
		// Inclusao dcampos da enchoice
		RecLock("SZ4",.F.)
		SZ4->Z4_DTNASC  := dDtNasc
		SZ4->Z4_PIS     := cPIS
		SZ4->Z4_NACIO   := cNacio
		SZ4->Z4_NATUR   := cNatur
		SZ4->Z4_BANCO   := cBanco
		SZ4->Z4_AGENCIA := cAgencia
		SZ4->Z4_CONTA   := cConta
		SZ4->(MsUnlock())	

		// Inclusao das linhas do GetDados
		DbSelectArea("SZ5")
		For nI := 1 to len(aCols)
			If !aCols[nI][nUsado+1] 
				While !RecLock("SZ5",.T.)
					loop
				Enddo
				SZ5->Z5_FILIAL := xFilial("SZ5")
				SZ5->Z5_FORNEC := cFornec
				SZ5->Z5_LOJA   := cLoja
				SZ5->Z5_NOME   := aCols[nI][1]
				SZ5->Z5_DTNASC := aCols[nI][2]
				SZ5->Z5_PARENT := aCols[nI][3]
				SZ5->Z5_CPF    := aCols[nI][4]
				SZ5->(MsUnlock())	
			Endif
		Next			
	ElseIf nOpcx == 5 // Exclusao		

		SZ4->(dbSetOrder(1))
		SZ4->(dbSeek(xFilial("SZ4")+cFornec+cLoja))

		RecLock("SZ4", .F. )
		SZ4->(dbDelete())
		SZ4->(MsUnlock())

		// Inclusao das linhas do GetDados
		SZ5->(dbSetOrder(1))
		SZ5->(dbSeek(xFilial("SZ5")+cFornec+cLoja))
		While SZ5->(!Eof() .And. SZ5->Z5_FORNEC == cFornec .And. SZ5->Z5_LOJA == cLoja)
			RecLock("SZ5", .F. )
			SZ5->(dbDelete())
			SZ5->(MsUnlock())
			SZ5->(dbSkip())
		EndDo
	Endif
EndIf

Return

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} ProdVal
Validar c�digo do produto
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@param cCodigo, character, C�digo do produto
@return lRet
@example ProdVal(cCodigo)
/*/
//------------------------------------------------------------------------------\\
User Function ValFor(cFornec)
Local lRet := .T.

aArea     := GetArea()
aAreaSZ5  := SZ5->(GetArea())
cMensagem := ''

If ! Empty(cFornec)
	SZ5->(dbSetOrder(1))
	If SZ5->(dbSeek(xFilial("SZ5")+cFornec))
		cMensagem := "Fornecedor j� cadastrado."
	Else
		If ! Sa2->(DbSeek(xFilial('SA2')+cFornec))
			cMensagem := "Fornecedor n�o cadastrado"
		Else
			cNomeFor := SA2->A2_NOME
		Endif
	EndIf
EndIf
				
If ! Empty(cMensagem)
	MsgAlert(cMensagem)
	lRet := .F.
Endif
				
RestArea(aAreaSZ5)
RestArea(aArea)

Return(lRet)

//------------------------------------------------------------------------------\\
/*/{Protheus.doc} ProdVal
Validar c�digo do produto
@type function
@author Claudio
@since 28/12/2017
@version 1.0
@param cCodigo, character, C�digo do produto
@return lRet
@example ProdVal(cCodigo)
/*/
//------------------------------------------------------------------------------\\
User Function ValLoja(cFornec,cLoja,cNomeFor)
Local lRet := .T.

aArea     := GetArea()
cMensagem := ''

If ! Empty(cFornec+cLoja)
	SA2->(dbSetOrder(1))
	If ! SA2->(dbSeek(xFilial("SA2")+cFornec+cLoja))
		cMensagem := "Fornecedor n�o cadastrado"
	Else
		cNomeFor := SA2->A2_NOME
	EndIf
EndIf
				
If ! Empty(cMensagem)
	MsgAlert(cMensagem)
	lRet := .F.
Endif
				
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
User Function LA006OK()

Local nLinhaAtual := n 
Local lRet := .T.
Local nI   := 0 

If aCols[nLinhaAtual][5] == .F.
	For nI := 1 to Len( aCols ) 
	   If (aCols[nLinhaAtual,1] == aCols[nI,1]) .AND. nI <> nLinhaAtual .AND. aCols[nI][5] == .F.
	      MsgInfo('Dependente j� cadastrado.') 
	      lRet := .F. 
	   EndIf 
	Next nI
Endif

Return lRet
