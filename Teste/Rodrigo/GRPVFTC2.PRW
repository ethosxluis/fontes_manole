#include "protheus.ch"

//-------------------------------------------------------------------------------------------------------------------------------
//Função para importação do pedido de venda.
//-------------------------------------------------------------------------------------------------------------------------------
// 04/05/12 - SK - Suprimir a linha do preenchimento do numero do item do PV (2 digitos) com o numero do item da NFE (4 digitos)
//-------------------------------------------------------------------------------------------------------------------------------
USER FUNCTION GRPVFTC2()

	Local _lOk				:= .F.
	Local _aReg 			:= {}
	Local _cTitulo 		:= "Baixa de Notas Fiscais de Retorno de Consignação"
	Local _aButtons		:= {}
	Local _aCli 			:= {Space(006),Space(002),Space(040),Space(06),Space(30)}
	Local oCli 			:= Array(4)
	Local _aCondPg 		:= {Space(003),Space(030)}
	Local oCondPg 			:= Array(2)
	Local _aTot 			:= {0}
	Local oTot 			:= Array(1)
	Local _aRt 			:= {{.F.},{"","","",""}}
	Private lMark  	 	:= .F.
	Private oOk     		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo     		:= LoadBitmap( GetResources(), "LBNO" )
	Private _aTitCons 	:= {}
	Private _aCpoCons	:= {}
	Private _aVetCons 	:= {}
	Private _aSituaCor	:= {}
	Private _Continua := .T.
	
	Private _cMVIDUSR := GETMV("MN_UBXCSG")
	
	If !((__cUserID $ _cMVIDUSR) .or. (__cUserID == "000000" ))
		ApMsgInfo("Por motivo de segurança, essa rotina está restrita a ser executada pelos usuários cadastrados no parâmetro MN_UBXCSG.")
		Return()
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
	AADD(_aCpoCons ,{"MRK"		,""					,""												,"C",.T.})
	AADD(_aCpoCons ,{"DOC"		,"Documento"		,"SQL->Z1_DOC"									,"C",.T.})
	AADD(_aCpoCons ,{"SER"		,"Série"			,"SQL->Z1_SERIE"								,"C",.T.})
	AADD(_aCpoCons ,{"DATA"		,"Emissão"			,'ConvDad(SQL->Z1_EMISSAO,"STOC")'			,"D",.T.})
	AADD(_aCpoCons ,{"EVENTO"		,"Evento"			,"SQL->Z1_EVENTO"								,"C",.T.})
	AADD(_aCpoCons ,{"X"			,""					,""												,"C",.T.})
	AADD(_aCpoCons,{"_MRK"		,""					,".F."											,"C",.F.})
 
// Cria vetor para cabeçalho do ListBox
	_aTitCons := {}
	For j:=1 to Len(_aCpoCons)
		If _aCpoCons[j,5] // Verifica se é para exibir no ListBox
			AADD(_aTitCons, _aCpoCons[j,2])
		EndIf
	Next

	Do While _Continua
		_lOk				:= .F.
		_aReg 			:= {}
		_aButtons		:= {}
		_aCli 			:= {Space(006),Space(002),Space(040),Space(06),Space(30)}
		_aCondPg 		:= {Space(003),Space(030)}
		_aTot 			:= {0}
		_aRt 			:= {{.F.},{"","","",""}}

///           
		_aTot[1] := MONT_VET("0")
///
		oDlgCons := MSDIALOG():New(000,000,425,750, _cTitulo,,,,,,,,,.T.)
		oDlgCons:lEscClose := .F.

		DEFINE FONT oFnt01 NAME "Arial" SIZE 8, - 15 BOLD
		DEFINE FONT oFnt02 NAME "Arial" SIZE 6, - 11 BOLD
		DEFINE FONT oFnt03 NAME "Arial" SIZE 8, - 13 BOLD
		DEFINE FONT oFntTW NAME "Arial" SIZE 7, - 12
		DEFINE FONT oFont NAME "Mono AS" SIZE 9,15

		@ 015,005 Say OemToAnsi("Informe o cliente para o qual será feita a baixa do documento consignação: " ) 	PIXEL OF oDlgCons FONT oFont
		@ 025,005 MSGET oCli[1] VAR  _aCli[1]	SIZE 045,010 OF oDlgCons PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])  F3 "SA1" 	VALID VldCpo(oLbx,oDlgCons,"CLI",oCli,_aCLI,oCondPg,_aCondPg,oTot,_aTot)
		@ 025,055 MSGET oCli[2] VAR  _aCli[2]	SIZE 010,010 OF oDlgCons PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])			VALID VldCpo(oLbx,oDlgCons,"CLI",oCli,_aCLI,oCondPg,_aCondPg,oTot,_aTot)
		@ 025,075 MSGET oCli[3] VAR  _aCli[3]	SIZE 200,010 OF oDlgCons PIXEL FONT oFont  WHEN .F.
//
		@ 202,285 SAY "TOTAL DE ITENS:" 		SIZE 050,010 OF oDlgCons PIXEL
		@ 200,335 MSGET oTot[1] VAR  _aTot[1]	Picture "@E 99,999"	SIZE 035,011 OF oDlgCons PIXEL WHEN .F.

		oLbx := TwBrowse():New(66,0,376,135,,_aTitCons,,oDlgCons,,,,,{|| Recalc(),oLbx:Refresh()},,oFntTW,,,,,.F.,,.T.,,.F.,,,)

		oLbx:SetArray( _aVetCons )
		oLbx:bLine := {|| RetVt(oLbx:nAt)}
		oLbx:bLDblClick:= {|| Recalc(),oLbx:Refresh()}

		oDlgCons:bInit := {|| EnchoiceBar(oDlgCons,{|| 	_aRt := VtdOk(_aVetCons,_aCLI,_aCondPg) , IIF( _aRt[1,1] ,oDlgCons:End(),.F.)},{|| _lOk := .F. ,_Continua := .F. ,oDlgCons:End()},,_aButtons)}


		oDlgCons:lCentered := .T.
		oDlgCons:Activate()


		If !Empty(_aRt[2,1]) .or. !Empty(_aRt[2,3]) .or. !Empty(_aRt[2,4])
	
			BAIXANF(_aRt[2,1],_aRt[2,2],_aRt[2,3],_aRt[2,4],_aRt[2,5],_aRt[2,6])

		EndIf

	EndDo

Return()



Static Function VtdOk(_aVetCons,_aCLI,_aCondPg)
	Local _aRet 	:= {{.F.},{"","","","","",""}}
/////                                         
	For _nIt:=1 to Len(_aVetCons)
		If _aVetCons[_nIt,POS("_MRK")]
			_aRet[1,1] 	:= .T.
			_aRet[2,1]		:= _aVetCons[_nIt,POS("DOC")]
			_aRet[2,2]		:= _aVetCons[_nIt,POS("SER")]
			_aRet[2,3]		:= _aCli[1]
			_aRet[2,4]		:=	_aCli[2]
			_aRet[2,5]		:=	_aVetCons[_nIt,POS("EVENTO")]
			_aRet[2,6]		:=	_aCondPg[1]
		EndIf
	Next
	
	If !_aRet[1,1]
		ApMsgInfo("Nenhum item selecionado !")
	Else
		If !ApMsgYesNo("Confirma a baixa do documento de consignação referente a nota selecionada ?")
			_aRet[1,1] 	:= .F.
		EndIf
	EndIf

Return(_aRet)


Static Function BAIXANF(_xDoc,_xSer,_xCli,_xloj,_xEvent,_cCondPg)
	Local _aCab 		:= {}
	Local _aItem		:= {}
///
//	dbSelectArea("SF1")
//	dbSetOrder(1)
//	If dbSeek(xFilial("SF1")+_xDoc + _xSer + _xCli + _xloj)
//		AADD(_aCab, _xCli)
//		AADD(_aCab, _xloj)
//		AADD(_aCab, _xEvent)
//		AADD(_aCab, _cCondPg)
//		_cCHVSD1 := xFilial("SD1")+_xDoc + _xSer + _xCli + _xloj
//		dbSelectArea("SD1")
//		dbSetOrder(1)
//		If dbSeek(_cCHVSD1)
//			Do While !Eof() .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == _cCHVSD1
//				AADD(_aItem,{SD1->D1_COD,SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_ITEM })
//				dbSkip()
//			EndDo
//		EndIf
//	EndIf

//	If Len(_aCab) > 0 .and. Len(_aItem)>0
//		For n := 1 to Len(_aItem)
//			_cCodProd := AllTrim(_aItem[n,1]) + Space(len(SB1->B1_COD) - Len(AllTrim(_aItem[n,1])))
			dbSelectArea("SZ1")
			dbSetOrder(1)       
			If dbSeek(xFilial("SZ1")+_xCli+_xloj+_xDoc+_xSer) 
//			If dbSeek(xFilial("SZ1")+_aCab[1]+_aCab[2]+_aItem[n,4]+_aItem[n,5]+_cCodProd+_aItem[n,6])
				While !Eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_CLIENTE == _xCli .and. SZ1->Z1_LOJA == _xloj .and. SZ1->Z1_DOC == _xDoc .and. SZ1->Z1_SERIE == _xSer
					If Empty(SZ1->Z1_PEDIDO)
						RECLOCK("SZ1", .F.)
						SZ1->Z1_PEDIDO	:= "xxxxxx"
						MsUnlock()
					EndIf
					dbskip()
				End	
			EndIf
//		Next
//	EndIf

Return

                            
//-------------------------------------------------------------------------------------------------
// FUNÇÃO QUE VALIDA CAMPOS DO JANELA PRINCIPAL
//-------------------------------------------------------------------------------------------------
Static Function VldCpo(oLbx,oDlgCons,_cPar,oCli,_aCLI,oCondPg,_aCondPg,oTot,_aTot)
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
  
		RESTAREA(_aAreaIni)
		If !Empty(_aCLI[1]) .and. !Empty(_aCLI[2])
			MsAguarde({|lEnd| _aTot[1] := MONT_VET("2",oLbx,oDlgCons,{_aCLI[1],_aCLI[2],_aCli[4]})},"Aguarde","Processando. . .",.T.,.F.)
		EndIf
		oTot[1]:Refresh()

	Case (_cPar == "CDPG")
		If !Empty(_aCondPg[1])
			dbSelectArea("SE4")
			dbSetOrder(1)
			If dbSeek(xFilial("SE4") + _aCondPg[1])
				_aCondPg[2] := SE4->E4_DESCRI
			Else
				_aCondPg[1] := Space(03)
				_aCondPg[2] := Space(30)
				ApMsgInfo("Código não encontrado !")
				_lRet := .F.
			EndIf
		EndIf
		If !_lRet
			oCondPg[1]:SetFocus()
		EndIf
		oCondPg[1]:Refresh()
		oCondPg[2]:Refresh()
	Case (_cPar == "DT")
		If Empty(DTOS(_aCli[4]))
			ApMsgInfo("Obrigatório informar a data.")
			oCli[1]:SetFocus()
			_lRet := .F.
		Else
			If _aCli[4] > date()
				ApMsgInfo("Data futura inválida !")
				oCli[1]:SetFocus()
				_lRet := .F.
			EndIf
		EndIf
	OtherWise
	
	EndCase

	RESTAREA(_aAreaIni)

//If !Empty(_aCLI[1]) .and. !Empty(_aCLI[2])
//	MsAguarde({|lEnd| _aTot[1] := MONT_VET("2",oLbx,oDlgCons,{_aCLI[1],_aCLI[2],_aCli[4]})},"Aguarde","Processando. . .",.T.,.F.)
//EndIf
	oTot[1]:Refresh()

Return(_lRet)


//-------------------------------------------------------------------------------------------------
// FUNÇÃO QUE VALIDA OS DADOS ANTES DE INICIAR A IMPORTACAO
//-------------------------------------------------------------------------------------------------
Static Function VldOk(_aCli,_cTexto)
//-------------------------------------------------------------------------------------------------
	Local _lRet := .T.

	If _lRet .and. Empty(_aCli[1]) .or.Empty(_aCli[2])
		ApMsgInfo("Falta informar o cliente !")
		_lRet := .F.
	EndIf
	If _lRet .and. Empty(_cTexto)
		ApMsgInfo("Faltam os dados da planilha Excel a importar !")
		_lRet := .F.
	EndIf

	If _lRet .and. !ApMsgYesNo("Confirma a geração do pedido de remessa ?")
		_lRet := .F.
	EndIf

Return(_lRet)


//-------------------------------------------------------------------------------------------------
// Funcao que identifica e retorna a posicao do campo no SX3, de acordo com o nome do campo 
// passado como referência no cabeçalho da planilha.
//-------------------------------------------------------------------------------------------------
Static Function RetPosCpo(_aColuns,_cCampo)
//-------------------------------------------------------------------------------------------------

	Local _xPosCpo := 0

	_xPosCpo 	:= Ascan(_aColuns,{|x| AllTrim(x[1]) == _cCampo})
	IF _xPosCpo <=0
		_xPosCpo 	:= 0
	EndIf
			
Return(_xPosCpo)


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


//-----------------------------------------------------------------------------------------------
// Função criada para permitir consultar e atualizar parametros.
//-----------------------------------------------------------------------------------------------
Static Function FGETMV(_xVAR,_xTipo,_xDescr,_xConteud,_xFil,_xAtu)
//-----------------------------------------------------------------------------------------------
	Local _xArea 	:= GETAREA()
	Local _xRet 	:= ""
// Inicializa a variável de Atualização
	If _xAtu == Nil
		_xAtu := .F.
	EndIf
// Inicializa a variável de Filial
	If _xFil == Nil .or. Empty(_xFil)
		_xFil := Space(Len(xFilial()))
	EndIf
// Inicializa a variável de Tipo
	If _xTipo == Nil
		_xTipo := " "
	EndIf
// Inicializa a variável de conteúdo
	If _xConteud == Nil
		_xConteud := " "
	EndIf
// Inicializa o vetor de descrição
	If Len(_xDescr)<=0
		_xDescr := {}
	EndIf
	For k:=1 to 3
		If Len(_xDescr) < k
			AADD(_xDescr,"")
		EndIf
		If _xDescr[k] == Nil
			_xDescr[k] := ""
		EndIf
	Next

	dbSelectArea("SX6")
	dbSetOrder(1)
// Procura pela Filial + parametro 
	IF .NOT. SX6->( DBSEEK ( _xFil + _xVar ) )
	// Se não encontrou, cria o parametro conforme especificação
		If !Empty(_xVar) .and. !Empty(_xTipo) .and. !Empty(_xConteud)
			RecLock("SX6",.T.)
			SX6->X6_FIL     	:= _xFil
			SX6->X6_VAR     	:= _xVar
			SX6->X6_TIPO    	:= _xTipo
			SX6->X6_DESCRIC	:= _xDescr[1]
			SX6->X6_DESC1   	:= _xDescr[2]
			SX6->X6_DESC2   	:= _xDescr[3]
			SX6->X6_CONTEUD	:= _xConteud
			SX6->X6_PROPRI 	:= "U"
			SX6->(MsUnLock())
			_xRet := AllTrim(_xConteud)
		EndIf
	ELSE
	// Se encontrou, obtem o conteúdo do parametro.
		_xRet := AllTrim(SX6->X6_CONTEUD)
	
//	If _xAtu
//		RecLock("SX6",.F.)
//		SX6->X6_CONTEUD := _xConteud
//		SX6->(MsUnLock())
//	EndIf 		
	ENDIF

	RESTAREA(_xArea)

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
		_cQuery += " Select Z1_DOC, Z1_SERIE, Z1_EMISSAO, Z1_EVENTO, COUNT(*) "
		_cQuery += " From " + RETSQLNAME("SZ1")	+ " "
		_cQuery += " WHERE Z1_FILIAL  = '"+xFilial("SZ1")+"' "
		_cQuery += " AND Z1_CLIENTE = '"+_aVar[1] + "' AND Z1_LOJA = '"+_aVar[2]+"' "
		_cQuery += " AND Z1_PEDIDO  = ' ' "
//	_cQuery += " AND Z1_EVENTO = '"+ _aVar[3] + "' "
		_cQuery += " AND Z1_TIPO = 'S' AND D_E_L_E_T_ <> '*' "
		_cQuery += " GROUP BY Z1_DOC, Z1_SERIE, Z1_EMISSAO, Z1_EVENTO "
		_cQuery += " ORDER BY Z1_DOC, Z1_SERIE, Z1_EMISSAO, Z1_EVENTO "
	
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
Static Function Recalc()
	Local _nPosAtu 	:= oLbx:nAt
	Local _lPara 	:= .F.
/// SE A LINHA ESTIVER EM BRANCO
	If Empty(_aVetCons[_nPosAtu,POS("DOC")])
	Return(.T.)
	EndIf

	_aVetCons[oLbx:nAt,POS("_MRK")] 	:= !(_aVetCons[oLbx:nAt,POS("_MRK")])
	_aVetCons[_nPosAtu,1]					:= Iif(_aVetCons[_nPosAtu,POS("_MRK")],oOk,oNo)

	If _aVetCons[oLbx:nAt,POS("_MRK")]
		For   _nIt := 1 to Len(_aVetCons)
			If _nIt <> _nPosAtu
				_aVetCons[_nIt,POS("_MRK")] 	:= .F.
				_aVetCons[_nIt,1]					:= oNo
			EndIf
		Next
	EndIf

Return(.T.)


///---------------------------------------------------------------------------
/// Grava um arquivo em disco
///---------------------------------------------------------------------------
Static Function Grv_Disco(_cArqDsc,_cTXT)
/// VERIFICA SE EXISTEM LINHAS
	If !File(_cArqDsc)
		If (_nHdlTxt := FCreate( _cArqDsc,0 )) < 0
			MsgBox("Nao conseguiu criar o arquivo "+ _cArqDsc )
		Return
		Endif
	Else
		fErase( _cArqDsc )
		If (_nHdlTxt := FCreate( _cArqDsc,0 )) < 0
			MsgBox("O arquivo "+_cArqDsc+" ja' existia, foi apagado e mesmo assim, nao consegui-se criar um novo arquivo")
		Return
		Endif
	EndIf
/// Gerando novo arquivo
	FSeek(_nHdlTxt,0)
	FWrite(_nHdlTxt,_cTXT)
	FClose(_nHdlTxt)
Return()