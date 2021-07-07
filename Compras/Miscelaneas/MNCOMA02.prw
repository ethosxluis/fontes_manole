#include 'protheus.ch'
#include 'parmtype.ch'

User Function MNCOMA02()

Local aGetSD   := {}
Local aButtons := {}

Private nOpcx  := 3

AAdd(aButtons,{'Excluir',{|| U_Excluir()}, 'Excluir dados RPA','Excluir' } )

//+-----------------------------------------------+//¦ Montando aHeader para a Getdados              ¦//+-----------------------------------------------+
dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SZ2")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZ2")    
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. x3_campo <> 'Z2_FORNEC'  .AND. x3_campo <> 'Z2_LOJA'        
		nUsado:=nUsado+1        
		AADD(aHeader,{ TRIM(x3_titulo),x3_campo,;
		               x3_picture,x3_tamanho,x3_decimal,;
		               "",x3_usado,;
		               x3_tipo, x3_arquivo, x3_context } )    

		If X3_CONTEXT = 'R'
			Aadd(aGetSD, X3_CAMPO)
		Endif

	Endif
    dbSkip()
End
//+-----------------------------------------------+//¦ Montando aCols para a GetDados                ¦//+-----------------------------------------------+
aCols:=Array(1,nUsado+1)
dbSelectArea("SX3")
dbSeek("SZ2")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SZ2")    
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. x3_campo <> 'Z2_FORNEC'  .AND. x3_campo <> 'Z2_LOJA'
		nUsado:=nUsado+1        
		IF nOpcx == 3           
			IF x3_tipo == "C"             
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Elseif x3_tipo == "N"
				aCOLS[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCOLS[1][nUsado] := dDataBase
			Elseif x3_tipo == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCOLS[1][nUsado+1] := .F.

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
				aCols[Len(aCols),nI] := Posicione('ZZB',1,xFilial('ZZB')+ZZC_EDITOR,'ZZB_NOME')
			Else
				aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next
		aCols[Len(aCols),nUsado+1] := .F.
		ZZC->(DbSkip())
	End
	RestArea(_aArea)

cZ1_FORNEC := SA1->A1_COD
cZ1_LOJA   := SA1->A1_LOJA
dZ1_DTNASC := STOD(space(10))
cZ1_PIS    := space(10)
cZ1_NACIO  := space(25)
cZ1_NATUR  := space(25)

//+----------------------------------------------+//¦ Variaveis do Rodape do Modelo 2//+----------------------------------------------+
nLinGetD:=0
//+----------------------------------------------+//¦ Titulo da Janela                             ¦//+----------------------------------------------+
cTitulo:="Informações para RPA"
//+----------------------------------------------+//¦ Array com descricao dos campos do Cabecalho  ¦//+----------------------------------------------+
aC:={}
#IFDEF WINDOWS 
//	AADD(aC,{"cZ1_DTNASC",{20,10} ,"Data de Nascimento","@!",'ExecBlock("MD2VLCLI",.F.,.F.)',"SA2",}) 
	AADD(aC,{"dZ1_DTNASC",{20,10} ,"Data de Nascimento","@!",,,}) 
	AADD(aC,{"cZ1_PIS"   ,{20,250},"Nº do PIS   "      ,"@!",,,}) 
	AADD(aC,{"cZ1_NACIO" ,{35,10} ,"Nacionalidade     ","@!",,,})
	AADD(aC,{"cZ1_NATUR" ,{35,250},"Naturalidade"      ,"@!",,,})
#ENDIF
//+-------------------------------------------------+//¦ Array com descricao dos campos do Rodape        ¦//+-------------------------------------------------+
aR:={}
/*#IFDEF WINDOWS 
	AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados", "@E 999",,,.F.})
#ELSE 
	AADD(aR,{"nLinGetD" ,{19,05},"Linha na GetDados","@E 999",,,.F.})
#ENDIF*/
//+------------------------------------------------+//¦ Array com coordenadas da GetDados no modelo2   ¦//+------------------------------------------------+
#IFDEF WINDOWS    
	aCGD := {85,5,118,315}
#ELSE    
	aCGD:={10,04,15,73}
#ENDIF
//+----------------------------------------------+//¦ Validacoes na GetDados da Modelo 2           ¦//+----------------------------------------------+
cLinhaOk := "U_LCOM02OK()"
cTudoOK  := "ALLWAYSTRUE()"
//+----------------------------------------------+//¦ Chamada da Modelo2                           ¦//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou

/* Modelo2 - Formulário para cadastro 
1	cTitulo
2	[ aC ] 
3	[ aR ] 
4	[ aGd ] 
5	[ nOp ] 
6	[ cLinhaOk ] 
7	[ cTudoOk ]
8	aGetsD 
9	[ bF4 ] 
10	[ cIniCpos ] 
11	[ nMax ] 
12	[ aCordW ] 
13	[ lDelGetD ] 
14	[ lMaximazed ] 
15	[ aButtons ] )
*/

//lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCordW)
//lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,,.T.,.T.,aButtons)

If lRet
	If nOpcx == 3 // Incluir		
		SZ2->(dbSetOrder(1))
		SZ2->(dbSeek(xFilial("SZ2")+cZ1_FORNEC+cZ1_LOJA))
		While SZ2->(!Eof() .And. SZ2->Z2_FORNEC == cZ1_FORNEC .And. SZ2->Z2_LOJA == cZ1_LOJA)
			RecLock("SZ2", .f. )
			SZ2->(dbDelete())
			SZ2->(MsUnlock())
			SZ2->(dbSkip())
		EndDo
		DbSelectArea("SZ2")
		// Inclusao das linhas do Escopo
		For nI := 1 to len(aCols)
			If !aCols[nI][nUsado+1] 
				While !RecLock("SZ2",.T.)
					loop
				Enddo
				SZ2->SZ2_FILIAL := xFilial("SZ2")
				SZ2->SZ2_FORNEC := cZ1_FORNEC
				SZ2->SZ2_LOJA   := cZ1_LOJA
				SZ2->SZ2_NOME   := aCols[nI][1]
				SZ2->SZ2_DTNASC := aCols[nI][2]
				SZ2->SZ2_PARENT := aCols[nI][3]
				SZ2->SZ2_CPF    := aCols[nI][4]
				SZ2->(MsUnlock())	
			Endif
		Next			
	ElseIf nOpcx == 5 // Exclusao		
		SZ2->(dbSetOrder(1))
		SZ2->(dbSeek(xFilial("SZ2")+cZ1_FORNEC+cZ1_LOJA))
		While SZ2->(!Eof() .And. SZ2->Z2_FORNEC == cZ1_FORNEC .And. SZ2->Z2_LOJA == cZ1_LOJA)
			RecLock("SZ2", .f. )
			SZ2->(dbDelete())
			SZ2->(dbSkip())
			SZ2->(MsUnlock())
		EndDo
	Endif
EndIf

Return

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
User Function LCOM02OK()

Local nLinhaAtual := n 
Local lRet := .T.
Local nI   := 0 

If aCols[nLinhaAtual][5] == .F.
	For nI := 1 to Len( aCols ) 
	   If (aCols[nLinhaAtual,1] == aCols[nI,1]) .AND. nI <> nLinhaAtual .AND. aCols[nI][5] == .F.
	      MsgInfo('Dependente já cadastrado.') 
	      lRet := .F. 
	   EndIf 
	Next nI
Endif

Return lRet

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
User Function Excluir()

nOpcx := 5

Return nOpcx
