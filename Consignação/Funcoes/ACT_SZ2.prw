#Include 'Protheus.ch'


//-------------------------------------------------------------------------------------------------
//funcao para acerto da tabela de saldos por cliente / produto
//-------------------------------------------------------------------------------------------------

User Function ACT_SZ2()


Local _lOk				:= .F.
Local _aReg 			:= {}
Local _cTitulo 		:= "Ajuste de Saldos de Consignação de Cliente x Produto"
Local _aButtons		:= {}
Local _aCli 			:= {Space(006),Space(002),Space(040),Space(015)}
Local oCli 			:= Array(4)
Local _aTot 			:= {0}
Local oTot 			:= Array(1)
Local _aRt 			:= {{.F.},{"","","",""}}
Local _lExecuta		:= .F.
Private lMark  	 	:= .F.
Private oOk     		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo     		:= LoadBitmap( GetResources(), "LBNO" )
Private _aTitCons 	:= {}
Private _aCpoCons	:= {}
Private _aVetCons 	:= {}                                
Private _aSituaCor	:= {}

_cIDMV := GETMV("MN_ACT_SZ2")
If _cIDMV == Nil 
	ApMsgStop('Parametro "MN_ACT_SZ2" inexistente ou desabilitado.  Essa rotina não pode ser executada!')
	Return(.T.)
Else
	_lExecuta := IIF( __cUserID $ GETMV("MN_ACT_SZ2"),.T.,.F.)
	If !_lExecuta
		ApMsgStop('Usuário não autorizado a executar esse processo !')
		Return(.T.)
	EndIf	
EndIf


//                                       
//------------------------------------------------------------------
// Cria vetor para controlar ordem das Colunas do ListBox
//------------------------------------------------------------------
// Posição 1 = identificador do campo
// Posição 2 = Título do ListBox
// Posição 3 = Variável ou campo a ser listado na coluna
// Posição 4 = Formato da coluna C=Caractere, N=Numerica, D=Data
// Posição 5 = .T. ou .F. (indica se a coluna será exibida no ListBox
//------------------------------------------------------------------
_aCpoCons := {}
AADD(_aCpoCons ,{"MRK"		,""					,""														,"C",.T.})
AADD(_aCpoCons ,{"PROD"		,"Produto"			,"SQL->Z2_PRODUTO"								,"C",.T.})
AADD(_aCpoCons ,{"DESC"		,"Descrição"		,"SQL->B1_DESC"										,"C",.T.})
AADD(_aCpoCons ,{"EVENT"	,"Evento"			,"SQL->Z2_EVENTO"									,"C",.T.})
AADD(_aCpoCons ,{"QTDCON"	,"Quant.Cons."	,'ConvDad(SQL->Z2_QTDCON,"TRANSF")'		,"C",.T.})
AADD(_aCpoCons ,{"DEVSIMB","Dev. Simb."	,'ConvDad(SQL->Z2_DEVSIMB,"TRANSF")'	,"C",.T.})
AADD(_aCpoCons ,{"DEVFIS"	,"Dev. Fis."		,'ConvDad(SQL->Z2_DEVFIS,"TRANSF")'		,"C",.T.})
AADD(_aCpoCons ,{"FATCON"	,"Fat. Cons."	,'ConvDad(SQL->Z2_FATCON,"TRANSF")'		,"C",.T.})
AADD(_aCpoCons ,{"X"			,""					,""														,"C",.T.})
AADD(_aCpoCons,{"_MRK"		,""					,".F."													,"C",.F.})
 
// Cria vetor para cabeçalho do ListBox
_aTitCons := {}
For j:=1 to Len(_aCpoCons)
	If _aCpoCons[j,5] // Verifica se é para exibir no ListBox
		AADD(_aTitCons, _aCpoCons[j,2])
	EndIf
Next

///           
_aTot[1] := MONT_VET("0")
///
oDlgCons := MSDIALOG():New(000,000,416,900, _cTitulo,,,,,,,,,.T.)
oDlgCons:lEscClose := .F.

DEFINE FONT oFont 	NAME "Arial" SIZE 7, - 12 BOLD
DEFINE FONT oFnt01 NAME "Arial" SIZE 8, - 15 BOLD
DEFINE FONT oFnt02 NAME "Arial" SIZE 6, - 11 BOLD
DEFINE FONT oFnt03 NAME "Arial" SIZE 8, - 13 BOLD
DEFINE FONT oFntTW NAME "Arial" SIZE 7, - 12

@ 015,005 Say OemToAnsi("Informe o cliente para o qual será feita a geração do pedido de faturamento :" ) 	PIXEL OF oDlgCons FONT oFont
@ 025,005 MSGET oCli[1] VAR  _aCli[1]	SIZE 040,010 OF oDlgCons PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])  F3 "SA1" 	VALID VldCpo(oLbx,oDlgCons,"CLI",oCli,_aCLI,oTot,_aTot)
@ 025,050 MSGET oCli[2] VAR  _aCli[2]	SIZE 010,010 OF oDlgCons PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])					VALID VldCpo(oLbx,oDlgCons,"CLI",oCli,_aCLI,oTot,_aTot)
@ 025,070 MSGET oCli[3] VAR  _aCli[3]	SIZE 200,010 OF oDlgCons PIXEL FONT oFont  WHEN .F.
//
@ 015,280 Say OemToAnsi("Produto a considerar :" ) 	PIXEL OF oDlgCons FONT oFont
@ 025,280 MSGET oCli[4] VAR  _aCli[4]	SIZE 060,010 OF oDlgCons PIXEL FONT oFont  VALID VldCpo(oLbx,oDlgCons,"PROD",oCli,_aCLI,oTot,_aTot)
//
@ 200,335 SAY "TOTAL DE ITENS:" 		SIZE 050,010 OF oDlgCons PIXEL
@ 195,385 MSGET oTot[1] VAR  _aTot[1]	Picture "@E 99,999"	SIZE 035,011 OF oDlgCons PIXEL WHEN .F.

oLbx := TwBrowse():New(55,0,476,135,,_aTitCons,,oDlgCons,,,,,{|| Recalc(_aCli),oLbx:Refresh()},,oFntTW,,,,,.F.,,.T.,,.F.,,,)

oLbx:SetArray( _aVetCons )
oLbx:bLine := {|| RetVt(oLbx:nAt)}
oLbx:bLDblClick:= {|| Recalc(_aCli),oLbx:Refresh()}


oDlgCons:bInit := {|| EnchoiceBar(oDlgCons,{|| 	oDlgCons:End()},{|| oDlgCons:End()},,_aButtons)}


oDlgCons:lCentered := .T.
oDlgCons:Activate()


Return()








Static Function VISUAL(_aVetCons,_nItem,_cCli,_cLoj)

_cDoc 	:= _aVetCons[_nItem,POS("DOC")]
_cSer 	:= _aVetCons[_nItem,POS("SER")]

cCadastro := "Nota Fiscal"

//
If !Empty(_cDoc)
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+_cDoc + _cSer + _cCli + _cLoj)
		lIntegracao := .F.
		_cRecNo := RECNO()
		A100Visual("SF1", _cRecNo, 2)
	Else
		ApMsgInfo("Documento não encontrado !")
	EndIf
EndIf
Return()



           
             

//-------------------------------------------------------------------------------------------------
// FUNÇÃO QUE VALIDA CAMPOS DO JANELA PRINCIPAL
//-------------------------------------------------------------------------------------------------
Static Function VldCpo(oLbx,oDlgCons,_cPar,oCli,_aCLI,oTot,_aTot)
//-------------------------------------------------------------------------------------------------
Local _lRet := .T.
Local _aAreaIni := GETAREA()

Do Case
	Case (_cPar == "CLI")
		If !Empty(_aCli[1]) .and. !Empty(_aCli[2])
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek(xFilial("SA1") + _aCli[1] + _aCli[2])
				_aCli[3] := SA1->A1_NOME
			Else
				_aCli[1] := Space(06)
				_aCli[2] := Space(02)			
				_aCli[3] := Space(40)
				ApMsgInfo("Código de cliente não encontrado !")
				_lRet := .F.
			EndIf
		EndIf		
		If !_lRet
			oCli[1]:SetFocus()
		EndIf	
		oCli[1]:Refresh()
		oCli[2]:Refresh()
		oCli[3]:Refresh()
	OtherWise
	
EndCase

RESTAREA(_aAreaIni)


If !Empty(_aCLI[1]) .and. !Empty(_aCLI[2])
	MsAguarde({|lEnd| _aTot[1] := MONT_VET("2",oLbx,oDlgCons,{_aCLI[1],_aCLI[2],_aCli[4]})},"Aguarde","Selecionando equipamentos . . .",.T.,.F.)
EndIf
oTot[1]:Refresh()

Return(_lRet)             







//-------------------------------------------------------------------------------------------------
// Funcao que identifica e retorna o dado no formato do campo (caractere, numerico ou data) 
//-------------------------------------------------------------------------------------------------
Static Function CONVCONT(_aColuns,_xPosCpo,_cCont)
//-------------------------------------------------------------------------------------------------
Local _xRet	:= _cCont
Local _cTipo	:= ""
Local _nTam	:= 0
Local _nDec	:= 0

If _xPosCpo > 0
	_cTipo 	:= _aColuns[_xPosCpo,2]
	_nTam 	:= _aColuns[_xPosCpo,3]
	_nDec 	:= _aColuns[_xPosCpo,4]
	Do Case
		Case _cTipo == "C"
			_xRet			:= _xRet + Space(_nTam - Len(_xRet))
			
		Case _cTipo == "N"
			_xRet		:= STRTRAN(_xRet,"R$","")		
			_xRet		:= STRTRAN(_xRet,".","")		
			_xRet		:= STRTRAN(_xRet,",",".")		
			_xRet		:= Val(_xRet)		
	EndCase
EndIf

Return(_xRet)







Static Function MONT_VET(_cPar01,oLbx,oDlgCons,_aVar)
Local _aAreaAnt := GETAREA()
_aVetCons	:= {}

If _cPar01 = "0"                                                   
	_aCpo := {}
	AADD(_aCpo,oNo)
	For f:=2 to Len(_aCpoCons)-1
		AADD(_aCpo,"")
	Next
	AADD(_aCpo,.F.)
	AADD(_aVetCons,_aCpo)
	_nQtdItens := 0	 
Else

	_cQuery := ""
	_cQuery += " Select A.*,B.B1_DESC "
	_cQuery += " From " + RETSQLNAME("SZ2")	+ " A "
	_cQuery += " Join " + RETSQLNAME("SB1")	+ " B "
	_cQuery += " On B.B1_FILIAL = '" + XFILIAL("SB1") + "'"
	_cQuery += " AND B.B1_COD = A.Z2_PRODUTO "
	_cQuery += " AND B.D_E_L_E_T_ = '' "
	_cQuery += " WHERE "
	_cQuery += " A.Z2_FILIAL = '" + XFILIAL("SZ2") + "'"
	_cQuery += " AND A.Z2_CLIENTE = '"+_aVar[1]+"' "
	_cQuery += " AND A.Z2_LOJA = '"+_aVar[2]+"' "
	_cQuery += " AND A.Z2_PRODUTO like '%"+AllTrim(_aVar[3])+"%' "	
	_cQuery += " AND A.D_E_L_E_T_ = '' "
	_cQuery += " ORDER BY A.Z2_PRODUTO, A.Z2_EVENTO "
	
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"SQL", .F., .T.)

	_cNomCli := ""
	
	dbSelectArea("SQL")
	dbGoTop()
	Do While !Eof()                    
		dbSelectArea("SQL")
		_aCpo := {}
		AADD(_aCpo,oNo)
		For f:=2 to Len(_aCpoCons)
			_cCpo := _aCpoCons[f,3]
			AADD(_aCpo,&_cCpo)
		Next
		AADD(_aVetCons,_aCpo)

		dbSkip()
	EndDo

	dbCloseArea()
	RESTAREA(_aAreaAnt)
	
	If Len(_aVetCons)<=0
		_aCpo := {}
		AADD(_aCpo,oNo)
		For f:=2 to Len(_aCpoCons)-1
			AADD(_aCpo,"")
		Next
		AADD(_aCpo,.F.)
		AADD(_aVetCons,_aCpo)

	EndIf
	
	If _cPar01 $ "1|3"	                                                      
		_nQtdItens := IIF(Len(_aVetCons) = 1 .and. Empty(1,2),0,Len(_aVetCons))
	Else
		oLbx:SetArray( _aVetCons )
  		oLbx:bLine := {|| RetVt(oLbx:nAt)}
		oLbx:Refresh()
		oDlgCons:Refresh()
		//Verifica quantos itens tem no ListBox
		//_nQtdItens := IIF(Len(_aVetCons) = 1 .and. Empty(oLbx:nAt,2),0,Len(_aVetCons))
		_nQtdItens := IIF(Len(_aVetCons) = 1 .and. Empty(1,2),0,Len(_aVetCons))		
	EndIf

EndIf

Return(_nQtdItens)




Static Function POS(_xPar)
Local _nPos := 0
For f:=1 to Len(_aCpoCons)
	If _aCpoCons[f,1] == _xPar
		_nPos := f
	EndIf
Next
Return(_nPos)



Static Function RetVt(_nLin)
Local _aVt := {}
For f:=1 to Len(_aCpoCons)
	If _aCpoCons[f,5]
		AADD(_aVt,_aVetCons[_nLin,f])
	EndIf
Next
Return(_aVt)




Static Function ConvDad(_xPar1,_xPar2)
Local _xRt
Do Case
	Case _xPar2 = "STOC"
		_xRt := Substr(_xPar1,7,2) + "/" + Substr(_xPar1,5,2) + "/" + Substr(_xPar1,1,4)
	Case _xPar2 = "TRANSF"
		_xRt := Transform(_xPar1,"@E 9,999,999.99")
	Otherwise
		_xRt := ""
EndCase

Return(_xRt)



///***************************************************************************
// Função para marcar e desmarcar registro no mark browse
///***************************************************************************
Static Function Recalc(_aCli)
Local _nPosAtu 	:= oLbx:nAt
Local _lPara 	:= .F.
/// SE A LINHA ESTIVER EM BRANCO
If Empty(_aVetCons[_nPosAtu,POS("PROD")]) 		
	Return(.T.)
EndIf

_cCli		:= _aCli[1]
_cLoj		:= _aCli[2]
_cProd 	:= _aVetCons[_nPosAtu,POS("PROD")]
_cEvent := _aVetCons[_nPosAtu,POS("EVENT")]

AltSald({xFilial("SZ2"),_cCli,_cLoj,_cProd,_cEvent})

_aVetCons[_nPosAtu,POS("QTDCON")]		:= ConvDad(SZ2->Z2_QTDCON,"TRANSF")
_aVetCons[_nPosAtu,POS("DEVSIMB")]	:= ConvDad(SZ2->Z2_DEVSIMB,"TRANSF")
_aVetCons[_nPosAtu,POS("DEVFIS")]		:= ConvDad(SZ2->Z2_DEVFIS,"TRANSF")
_aVetCons[_nPosAtu,POS("FATCON")]		:= ConvDad(SZ2->Z2_FATCON,"TRANSF")

//_aVetCons[oLbx:nAt,POS("_MRK")] 	:= !(_aVetCons[oLbx:nAt,POS("_MRK")])
//_aVetCons[_nPosAtu,1]					:= Iif(_aVetCons[_nPosAtu,POS("_MRK")],oOk,oNo)

//If _aVetCons[oLbx:nAt,POS("_MRK")] 
//	For   _nIt := 1 to Len(_aVetCons)
//		If _nIt <> _nPosAtu
//			_aVetCons[_nIt,POS("_MRK")] 	:= .F.
//			_aVetCons[_nIt,1]					:= oNo
//		EndIf
//	Next
//EndIf

Return(.T.)




Static Function AltSald(_aVet)
Local _lOk 		:= .F.
Local _aButtons	:= {}
Local _cChvSZ2 	:= _aVet[1] + _aVet[2] + _aVet[3] + _aVet[4] + _aVet[5]
Local _aQtd 		:= {0,0,0,0}
Local oQtd			:= Array(4)
Local _cTitulo	:= "Ajuste de quantidades"

dbSelectArea("SZ2")
dbSetOrder(1)
If dbSeek(_cChvSZ2) 
	_aQtd 		:= {SZ2->Z2_QTDCON , SZ2->Z2_DEVSIMB , SZ2->Z2_DEVFIS , SZ2->Z2_FATCON}

	oDlgAlt := MSDIALOG():New(000,000,130,850, _cTitulo,,,,,,,,,.T.)
	oDlgAlt:lEscClose := .T.
	
	DEFINE FONT oXFont 	NAME "Arial" SIZE 7, - 12 BOLD
	
	@ 020,005 Say OemToAnsi("Quant. Consig.:" ) 	PIXEL OF oDlgAlt FONT oXFont
	@ 020,105 Say OemToAnsi("Devol. Simb.:" ) 		PIXEL OF oDlgAlt FONT oXFont
	@ 020,205 Say OemToAnsi("Devol. Fisica:" ) 	PIXEL OF oDlgAlt FONT oXFont
	@ 020,305 Say OemToAnsi("Fat. Consig.:" ) 		PIXEL OF oDlgAlt FONT oXFont
	@ 030,005 MSGET oQtd[1] VAR  _aQtd[1]	Picture "@E 999,999.99" SIZE 050,010 OF oDlgAlt PIXEL FONT oXFont
	@ 030,105 MSGET oQtd[2] VAR  _aQtd[2]	Picture "@E 999,999.99" SIZE 050,010 OF oDlgAlt PIXEL FONT oXFont
	@ 030,205 MSGET oQtd[3] VAR  _aQtd[3]	Picture "@E 999,999.99" SIZE 050,010 OF oDlgAlt PIXEL FONT oXFont
	@ 030,305 MSGET oQtd[4] VAR  _aQtd[4]	Picture "@E 999,999.99" SIZE 050,010 OF oDlgAlt PIXEL FONT oXFont

	oDlgAlt:bInit := {|| EnchoiceBar(oDlgAlt,{|| _lOk := .T., oDlgAlt:End()},{|| oDlgAlt:End()},,_aButtons)}

	oDlgAlt:lCentered := .T.
	oDlgAlt:Activate()


	If _lOk
		RECLOCK("SZ2", .F.)
		SZ2->Z2_QTDCON		:= _aQtd[1]
		SZ2->Z2_DEVSIMB		:= _aQtd[2]
		SZ2->Z2_DEVFIS	 	:= _aQtd[3]
		SZ2->Z2_FATCON	 	:= _aQtd[4]			
		MsUnlock()
	EndIf	

Else
	ApMsgInfo("E R R O : Registro não encontrado.")
EndIf
Return(.T.)

                
