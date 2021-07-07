
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANA001   บAutor  ณPaulo Figueira      บ Data ณ  01/17/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณControle das ocorrencias	                         	      บฑฑ
ฑฑบ          ณPara monitorar e ajustar as ocorrencias do documento        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#Include "Protheus.Ch"
User Function MANA002(cAlias,nRecNo,nOpc)

INCLUI := .F.
ALTERA := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao para visualizar e alterar - Chamada sempre na opcao 4 - alterarณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(SF1->F1_XRO)
	_cXRO := GetSXENum("PA2","PA2_RO")
	
	RecLock("SF1",.F.)
	SF1->F1_XRO := _cXRO
	MsUnLock()
EndIf

u_MA002MNT(cAlias,nRecNo,4)


Return

User Function MA002MNT(cAlias,nRecNo,nOpc)

Local oDlg

Local nPosDoc		:= 0
Local nPosSeri		:= 0
Local nPosCli		:= 0
Local nPosLoj		:= 0

Local nOpcx		 	:= aRotina[nOpc,4]
Local nInd			:= 0
Local nISBN			:= 0
Local nDespro		:= 0
Local nQtd			:= 0
Local nOcorre		:= 0
Local nDesoco		:= 0
Local nObs			:= 0
Local nX			:= 0
Local nOpca			:= 0
Local aArea			:= GetArea()
Local nPos       	:= 0
Local nLinha        := 0
Local aHeaCab       := {}
Local _cXRO         := ""

Local aSize         := MsAdvSize()
Local aObjects      := {{100,100,.t.,.t.},{100,100,.t.,.t.},{100,015,.t.,.f.}}
Local aInfo         := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local aPosObj       := MsObjSize(aInfo,aObjects)
Local nPosItem      := 0
Local oEnchoice

Private aHeader		:= {}
Private aCols		:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTrazer os dados para memoriaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RegToMemory(cAlias, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratar numero do RO no cabe็alho da notaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
If Empty(M->F1_XRO)
_cXRO := GetSXENum("PA2","PA2_RO")

M->F1_XRO := _cXRO

RecLock(cAlias,.F.)
cAlias->F1_XRO :=_cXRO
MsUnLock()

EndIf
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do aHeader ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("PA2")
//aHeader:={}
While !Eof().And.(x3_arquivo=="PA2")
	If X3uso(X3_USADO)
		If (alltrim(SX3->X3_CAMPO) $ 'PA2_FILIAL|PA2_DOCENT|PA2_SERIE|PA2_CLIFOR|PA2_LOJA|PA2_RO|' )
			aAdd( aHeaCab, { AlLTrim( X3Titulo() ), ; // 01 - Titulo
			SX3->X3_CAMPO	, ;			// 02 - Campo
			SX3->X3_Picture	, ;			// 03 - Picture
			SX3->X3_TAMANHO	, ;			// 04 - Tamanho
			SX3->X3_DECIMAL	, ;			// 05 - Decimal
			SX3->X3_Valid  	, ;			// 06 - Valid
			SX3->X3_USADO  	, ;			// 07 - Usado
			SX3->X3_TIPO   	, ;			// 08 - Tipo
			SX3->X3_F3		, ;			// 09 - F3
			SX3->X3_CONTEXT	, ;         // 10 - Contexto
			SX3->X3_CBOX	, ; 		// 11 - ComboBox
			SX3->X3_RELACAO	, ;         // 12 - Relacao
			SX3->X3_INIBRW  , ;			// 13 - Inicializador Browse
			SX3->X3_Browse  , ;			// 14 - Mostra no Browse
			SX3->X3_VISUAL  } )
		Else
			aAdd( aHeader, { AlLTrim( X3Titulo() ), ; // 01 - Titulo
			SX3->X3_CAMPO	, ;			// 02 - Campo
			SX3->X3_Picture	, ;			// 03 - Picture
			SX3->X3_TAMANHO	, ;			// 04 - Tamanho
			SX3->X3_DECIMAL	, ;			// 05 - Decimal
			SX3->X3_Valid  	, ;			// 06 - Valid
			SX3->X3_USADO  	, ;			// 07 - Usado
			SX3->X3_TIPO   	, ;			// 08 - Tipo
			SX3->X3_F3		, ;			// 09 - F3
			SX3->X3_CONTEXT	, ;         // 10 - Contexto
			SX3->X3_CBOX	, ; 		// 11 - ComboBox
			SX3->X3_RELACAO	, ;         // 12 - Relacao
			SX3->X3_INIBRW  , ;			// 13 - Inicializador Browse
			SX3->X3_Browse  , ;			// 14 - Mostra no Browse
			SX3->X3_VISUAL  } )
		EndIf
	EndIf
	SX3->(dbSkip())
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem  aCols   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcx == 3
	
	Aadd( aCols, Array( Len( aHeader ) +  1 ) )
	dbSelectArea('SX3')
	dbSeek('PA2')
	nUsado := 0
	
	While !Eof() .And. ( X3_ARQUIVO == 'PA2' )
		
		If X3Uso( X3_USADO ) .And. cNivel >= X3_NIVEL .And. !( AllTrim( SX3->X3_CAMPO ) $ 'PA2_FILIAL|PA2_DOCENT|PA2_SERIE|PA2_CLIFOR|PA2_LOJA|PA2_RO|' )
			nUsado++
			aCols[1][nUsado] := CriaVar( AllTrim( X3_CAMPO ) )
		Endif
		
		SX3 -> ( dbSkip() )
		
	Enddo
	aCols[1][nUsado+1] := .F.
	
Else
	
	PA2->(DbSetOrder(1)) // PA2_FILIAL+PA2_DOCENT+PA2_SERIE+PA2_CLIFOR+PA2_LOJA
	If PA2->(DbSeek(xFilial("PA2")+ M->F1_DOC+M->F1_SERIE))
		
		While !PA2->(Eof()) .And. PA2->(PA2_FILIAL+PA2_DOCENT+PA2_SERIE) == xFilial("PA2")+M->F1_DOC+M->F1_SERIE
			
			Aadd( aCols, Array( Len( aHeader ) + 1 ) )
			For nInd := 1 To Len( aHeader )
				
				cCampo := aHeader[nInd,2]
				
				If aHeader[nInd,10] # 'V'
					aCols[Len(aCols)][nInd] := PA2->&(cCampo)
				Else
					aCols[Len(aCols)][nInd] := CriaVar( cCampo )
				Endif
				
			Next nInd
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
			
			PA2->( dbSkip() )
			
		Enddo
		nTamAcols := Len( aCols )
		
	Else
		
		Aadd( aCols, Array( Len( aHeader ) + 1 ) )
		For nInd := 1 To Len( aHeader )
			
			cCampo := Alltrim( aHeader[nInd,2] )
			aCols[Len(aCols)][nInd] := CriaVar( cCampo )
			
		Next nInd
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
	EndIf
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem da Telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg Title cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMAINWND PIXEL

oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,130,.T.,.F.)
oTPane1:Align := CONTROL_ALIGN_TOP

oEnchoice := MsMGet():New(cAlias,nRecNo,2, , , , ,aPosObj[1],,,,,,oTPane1,,.F.)

oGetDados := MSGetDados():New(0,0,0,0,nOpcX,"u_MA001LOK","u_MA001TOK",,.T.)
oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||iIf(oGetDados:TudoOk(),(nOpcA:=1,oDlg:End()), (nOpcA := 0))},{||oDlg:End()})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpca == 1
	
//	nPosItem := aScan(aHeader, {|x| x[2] == "PA2_ITEMNF"})
	nPosItem := aScan(aHeader, {|x| x[2] == "PA2_ISBN  "})
	
	If nOpcx == 3
		
		For nLinha := 1 to Len(aCols)
			
			If !aCols[nLinha][Len(aCols[nLinha])]
				
				RecLock("PA2",.T.)
				
				PA2->PA2_FILIAL 	:= xFilial("PA2")
				PA2->PA2_DOCENT 	:= M->F1_DOC
				PA2->PA2_SERIE 		:= M->F1_SERIE
				PA2->PA2_CLIFOR 	:= M->F1_FORNECE
				PA2->PA2_LOJA	 	:= M->F1_LOJA
				PA2->PA2_RO        	:= M->F1_XRO
				
				For nX := 1 to Len(aHeader)
					
					If aHeader[nX,10] <> 'V' .AND. !aHeader[nX,2] $ 'PA2_FILIAL|PA2_DOCENT|PA2_SERIE|PA2_CLIFOR|PA2_LOJA|PA2_RO|PA2_ISBN|'
						PA2->&(aHeader[nX][2]) := aCols[nLinha][nX]
					EndIf
					
				Next nX
				
				PA2->(MsUnLock())
				
			EndIf
			
		Next nLinha
		
	ElseIf nOpcx == 4
		
		For nLinha := 1 to Len(aCols)
			
			If !aCols[nLinha][Len(aCols[nLinha])]
				
				PA2->(DbSetorder(2)) //PA2_FILIAL+PA2_RO+PA2_ITEMNF
				If PA2->(DbSeek(xFilial("PA2")+M->F1_XRO + aCols[nLinha][nPosItem]))
					RecLock("PA2",.F.)
				Else
					RecLock("PA2", .T.)
					PA2->PA2_FILIAL 	:= xFilial("PA2")
					PA2->PA2_DOCENT 	:= M->F1_DOC
					PA2->PA2_SERIE 	    := M->F1_SERIE
					PA2->PA2_CLIFOR 	:= M->F1_FORNECE
					PA2->PA2_LOJA	 	:= M->F1_LOJA
					PA2->PA2_RO         := M->F1_XRO
					
				Endif
				
				For nX := 1 to Len(aHeader)
					
					If aHeader[nX,10] <> 'V' .AND. !aHeader[nX,2] $ 'PA2_FILIAL|PA2_DOCENT|PA2_SERIE|PA2_CLIFOR|PA2_LOJA|PA2_RO'
						PA2->&(aHeader[nX][2]) := aCols[nLinha][nX]
					EndIf
					
				Next nX                           '
				
				PA2->(MsUnLock())
				
			Else
				
				PA2->(DbSetorder(2)) //PA2_FILIAL+PA2_RO+PA2_ITEMNF
				If PA2->(DbSeek(xFilial("PA2")+M->F1_XRO+aCols[nLinha][nPosItem]))
					
					RecLock("PA2", .F.)
					
					DbDelete()
					
					PA2->(MsUnLock())
					
				EndIf
				
			EndIf
			
		Next nLinha
		
	ElseIf nOpcx == 5
		
		PA2->(DbSetOrder(1)) //PA2_FILIAL+PA2_DOCENT+PA2_RO
		If PA2->(DbSeek(xFilial("PA2")+M->F1_DOC+M->F1_SERIE))
			
			While !PA2->(Eof()) .AND. PA2->(PA2_FILIAL+PA2_DOCENT+PA2_SERIE) == xFilial("PA2")+M->F1_DOC+M->F1_SERIE
				
				RecLock("PA2",.F.)
				DbDelete()
				PA2->(MsUnLock())
				PA2->(DbSkip())
				
			EndDo
		EndIf
		
	EndIf
	
	
EndIf

If __lSX8
	If nOpcA == 1
		While ( GetSx8Len() > 0 )
			ConfirmSX8()
		Enddo
		EvalTrigger()
	Else
		While ( GetSx8Len() > 0 )
			RollBackSX8()
		Enddo
	EndIf
EndIf

RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANA001   บAutor  ณMicrosiga           บ Data ณ  02/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que gera codigo automatico de RO, onde e chamada     บฑฑ
ฑฑบ          ณpelo campo PA2_OCORRE                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function MA001VLD()
Local nPosRO := aScan(aHeader,{|x| x[2] == "PA2_RO    "})

If nPosRO > 0
aCols[n][nPosRO] := getSXENum("PA2","PA2_RO")
EndIf

Return .T.
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANA001   บAutor  ณMicrosiga           บ Data ณ  02/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao tudook	                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                  	                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA001TOK()
Local lRet := .T.

lRet := u_MA001LOK()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANA001   บAutor  ณPaulo Figueira	     บ Data ณ  02/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a linha                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA001LOK()
Local lRet := .T.
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------

If !aCOLS[n,Len(aHeader)+1] 	//| Se a linha nao estiver deletada.
	
	If Empty(aCOLS[n,GdFieldPos("PA2_ISBN")])
		cMsg := "Nao sera permitido linhas sem ISBN."
		Help("",1,"","LinOk",cMsg,1,0)
		lRet := .F.
	Else
		//ConfirmSX8()
	Endif
	
Endif


Return( lRet )
