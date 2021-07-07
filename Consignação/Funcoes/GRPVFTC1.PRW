#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} GRPVFTC1


//Função para importação do pedido de venda.
//autor  TOTVS
//since   29/09/2010
//version P11
//param
//obs 04/05/2012 - SK - Suprimir a linha do preenchimento do numero do item do PV (2 digitos) com o numero do item da NFE (4 digitos)
//obs 03/06/2015 - SK - Informar o no da nota fiscal a ser processada
//obs 05/05/2016 - Allan Bonfim - Ajuste na query para considerar as notas originais retornadas através da operação CS (CANCELAMENTO NF SIMBOLICA)
//return

/*/
//-------------------------------------------------------------------
USER FUNCTION GRPVFTC6()

Local _lOk				:= .F.
//Local _aReg 			:= {}
Local _cTitulo 		:= "Notas Fiscais de Retorno de Consignação"
Local _aButtons		:= {}
Local _aCli 			:= {Space(006),Space(002),Space(040),Space(06),Space(30)}
Local oCli 			:= Array(4)
Local _aCondPg 		:= {Space(003),Space(030)}
Local _aTabPrc 		:= {Space(003),Space(030)}
Local oCondPg 			:= Array(2)
//Local oTabPrc 			:= nil
Local _aTot 			:= {0}
Local oTot 			:= Array(1)
Local _aMennot 			:= {Space(80)}
Local oMennot 			:= Array(1)
Local _aRt 			:= {{.F.},{"","","",""}}
local j := 0
//Private lMark  	 	:= .F.
Private oOk     		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo     		:= LoadBitmap( GetResources(), "LBNO" )
Private _aTitCons 	:= {} 
Private _aCpoCons	:= {}
Private _aVetCons 	:= {}
//Private _aSituaCor	:= {}

Private W_NFUNICO   := Space(TamSX3("D1_COD")[1]) // SK - 03/06/15
Private W_TPCONSI   := Space(TamSX3("C5_XTPCON")[1]) // SK - 03/06/15
alert('Atençao com os parametros da Tela')
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
AADD(_aCpoCons ,{"DOC"		,"Documento"		,"SQL->Z1_DOC"										,"C",.T.})
AADD(_aCpoCons ,{"SER"		,"Série"			,"SQL->Z1_SERIE"									,"C",.T.})
AADD(_aCpoCons ,{"DATA"		,"Emissão"			,'ConvDad(SQL->Z1_EMISSAO,"STOC")'		,"D",.T.})
AADD(_aCpoCons ,{"EVENTO"	,"Evento"			,"SQL->Z1_EVENTO"									,"C",.T.})
AADD(_aCpoCons ,{"X"			,""					,""														,"C",.T.})
AADD(_aCpoCons,{"_MRK"		,""					,".F."													,"C",.F.})

// Cria vetor para cabeçalho do ListBox
_aTitCons := {}
For j:=1 to Len(_aCpoCons)
	If _aCpoCons[j,5] // Verifica se é para exibir no ListBox
		AADD(_aTitCons, _aCpoCons[j,2])
	EndIf
Next

_aTot[1] := MONT_VET("0")
///oDlgCons := MSDIALOG():New(000,000,416,750, _cTitulo,,,,,,,,,.T.) // SK - 03/06/15
oDlgCons := MSDIALOG():New(000,000,716,750, _cTitulo,,,,,,,,,.T.) // SK - 03/06/15

oDlgCons:lEscClose := .F.

//DEFINE FONT oFnt01 NAME "Arial" SIZE 8, - 15 BOLD
//DEFINE FONT oFnt02 NAME "Arial" SIZE 6, - 11 BOLD
//DEFINE FONT oFnt03 NAME "Arial" SIZE 8, - 13 BOLD
DEFINE FONT oFntTW NAME "Arial" SIZE 7, - 12
DEFINE FONT oFont NAME "Mono AS" SIZE 9,15


nLinh	:= 30
@ 005+nLinh,005 Say OemToAnsi("Nota Especifica (branco = todos): " ) 	PIXEL OF oDlgCons FONT oFont
@ 015+nLinh,005 MSGET oNota VAR W_NFUNICO SIZE 055,010 OF oDlgCons PIXEL FONT oFont

@ 005+nLinh,200 Say OemToAnsi("Tipo Consignacao (R/F) " ) 	PIXEL OF oDlgCons FONT oFont
@ 015+nLinh,200 MSGET oNota VAR W_TPCONSI SIZE 010,010 OF oDlgCons PIXEL FONT oFont VALID VLD_TPCONS()

@ 030+nLinh,005 Say OemToAnsi("Informe o cliente para o qual será feita a geração do pedido de faturamento: " ) 	PIXEL OF oDlgCons FONT oFont
@ 040+nLinh,005 MSGET oCli[1] VAR  _aCli[1]	SIZE 045,010 OF oDlgCons PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])  F3 "SA1" 	VALID VldCpo(oLbx,oDlgCons,"CLI",oCli,_aCLI,oCondPg,_aCondPg,oTot,_aTot)
@ 040+nLinh,055 MSGET oCli[2] VAR  _aCli[2]	SIZE 010,010 OF oDlgCons PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])			VALID VldCpo(oLbx,oDlgCons,"CLI",oCli,_aCLI,oCondPg,_aCondPg,oTot,_aTot)
@ 040+nLinh,075 MSGET oCli[3] VAR  _aCli[3]	SIZE 200,010 OF oDlgCons PIXEL FONT oFont  WHEN .F.
//
@ 055+nLinh,005 Say OemToAnsi("Condição de Pagamento :" + SPACE(30) + "Ultima atual: 03/06/15" ) 	PIXEL OF oDlgCons FONT oFont
@ 065+nLinh,005 MSGET oCondPg[1] VAR  _aCondPg[1]	SIZE 030,010 OF oDlgCons PIXEL FONT oFont  F3 "SE4" VALID VldCpo(oLbx,oDlgCons,"CDPG",oCli,_aCli,oCondPg,_aCondPg,oTot,_aTot)
@ 065+nLinh,050 MSGET oCondPg[2] VAR  _aCondPg[2]	SIZE 100,010 OF oDlgCons PIXEL FONT oFont  When .F.
//
@ 055+nLinh,155 Say OemToAnsi("Tabela de Preços :") 	PIXEL OF oDlgCons FONT oFont
@ 065+nLinh,155 MSGET oTabprc VAR  _aTabprc[1]	SIZE 030,010 OF oDlgCons PIXEL FONT oFont  F3 "DA0" //VALID VldCpo(oLbx,oDlgCons,"CDPG",oCli,_aCli,oCondPg,_aCondPg,oTot,_aTot)
@ 065+nLinh,200 MSGET oTabprc VAR  _aTabprc[2]	SIZE 100,010 OF oDlgCons PIXEL FONT oFont  When .F.
//
@ 080+nLinh,005 Say OemToAnsi("Mensagem para nota :") 	PIXEL OF oDlgCons FONT oFont
@ 090+nLinh,005 MSGET oMennot[1] VAR  _aMennot[1]	SIZE 300,010 OF oDlgCons PIXEL FONT oFont
//
@ 200+nLinh,285 SAY "TOTAL DE ITENS:" 		SIZE 050,010 OF oDlgCons PIXEL
@ 195+nLinh,335 MSGET oTot[1] VAR  _aTot[1]	Picture "@E 99,999"	SIZE 035,011 OF oDlgCons PIXEL WHEN .F.

///oLbx := TwBrowse():New(91,0,376,135,,_aTitCons,,oDlgCons,,,,,{|| Recalc(),oLbx:Refresh()},,oFntTW,,,,,.F.,,.T.,,.F.,,,) //  SK - 03/06/15
oLbx := TwBrowse():New(111+nLinh,0,376,135,,_aTitCons,,oDlgCons,,,,,{|| Recalc(),oLbx:Refresh()},,oFntTW,,,,,.F.,,.T.,,.F.,,,)   // SK - 03/06/15

oLbx:SetArray( _aVetCons )
oLbx:bLine := {|| RetVt(oLbx:nAt)}
oLbx:bLDblClick:= {|| Recalc(),oLbx:Refresh()}
//oLbx:nFreeze := 1

//oSpdBt1 	:= tButton():New(195, 010,  "VISUALIZAR DOCUMENTO"	, oDlgCons, {|| VISUAL(_aVetCons,oLbx:nAt,_aCli[1],_aCli[2])}, 080, 012,,oFnt02,,.T.)

oDlgCons:bInit := {|| EnchoiceBar(oDlgCons,{|| 	_aRt := VtdOk(_aVetCons,_aCLI,_aCondPg,_aTabprc,_aMennot) , IIF( _aRt[1,1] ,oDlgCons:End(),.F.)},{|| _lOk := .F. , oDlgCons:End()},,_aButtons)}

oDlgCons:lCentered := .T.
oDlgCons:Activate()

If !Empty(_aRt[2,1]) .or. !Empty(_aRt[2,3]) .or. !Empty(_aRt[2,4])
	mnGeraPV(_aRt[2,1],_aRt[2,2],_aRt[2,3],_aRt[2,4],_aRt[2,5],_aRt[2,6],_aRt[2,7],_aRt[2,8])
EndIf

Return()


////////////////////////////////////////////////////
Static Function VISUAL(_aVetCons,_nItem,_cCli,_cLoj)
////////////////////////////////////////////////////

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


/////////////////////////////////////////////////////////////////
Static Function VtdOk(_aVetCons,_aCLI,_aCondPg,_aTabprc,_aMennot)
/////////////////////////////////////////////////////////////////

Local _aRet 	:= {{.F.},{"","","","","","","",""}}
local _nIt := 0
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
		_aRet[2,7]		:=	_aTabPrc[1]
		_aRet[2,8]		:=	_aMennot[1]
	EndIf
Next

If Empty(_aCondPg[1])
	ApMsgInfo("Falta informar a condição de pagamento !")
	_aRet[1,1] 	:= .F.
Else
	If !_aRet[1,1]
		ApMsgInfo("Nenhum item selecionado !")
	Else
		If !ApMsgYesNo("Confirma a geração do pedido de faturamento referente a nota selecionada ?")
			_aRet[1,1] 	:= .F.
		EndIf
	EndIf
EndIf

Return(_aRet)


/////////////////////////////////////////////////////////////////////////////////////
Static Function mnGeraPV(_xDoc,_xSer,_xCli,_xloj,_xEvent,_cCondPg, _ctabprc, _cmennota)
/////////////////////////////////////////////////////////////////////////////////////

Local _aCab 		:= {}
Local _aItem		:= {}
///
dbSelectArea("SF1")
dbSetOrder(1)
If dbSeek(xFilial("SF1")+_xDoc + _xSer + _xCli + _xloj)
	AADD(_aCab, _xCli)
	AADD(_aCab, _xloj)
	AADD(_aCab, _xEvent)
	AADD(_aCab, _cCondPg)
	AADD(_aCab, _ctabprc)
	AADD(_aCab, _cmennota)
	_cCHVSD1 := xFilial("SD1")+_xDoc + _xSer + _xCli + _xloj
	dbSelectArea("SD1")
	dbSetOrder(1)
	If dbSeek(_cCHVSD1)
		Do While !Eof() .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == _cCHVSD1
//			AADD(_aItem,{SD1->D1_COD,SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_ITEM })
			AADD(_aItem,{SD1->D1_COD,SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_ITEM, ;
			     SD1->(RECNO()) })
			dbSkip()
		EndDo
	EndIf
EndIf

Asort( _aItem,,, { |x,y| x[07] < y[07] } )


If Len(_aCab) > 0 .and. Len(_aItem)>0
	MNPVRemes(_aCab,_aItem)
EndIf
Return


//-------------------------------------------------------------------------------------------------
// FUNÇÃO GERA O EXECAUTO DO PEDIDO DE VENDA
//-------------------------------------------------------------------------------------------------
Static Function MNPVRemes(_aCab,_aItem)
//-------------------------------------------------------------------------------------------------
Local aAreaPV		:= GetArea()
Local _aCabPV 		:= {}
Local _aItemPV		:= {}
Local _cNextPV 	:= ""
Local _cRtNum 		:= Space(Len(SC5->C5_NUM))
Local _lGeraPV		:= .T.
Local _cItem		:= "01"
Local _cItemDEV	:= SPACE(LEN(SZ1->Z1_ITEME)) // 04/05/12 - SONIA
local n := 0

PRIVATE lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .T. 	// se .t. direciona as mensagens de help
Private nOpc			:= 3 		// 3-Incluir, 4-Alterar, 5- Excluir

/// Posiciona no Cliente
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+_acab[1]+_acab[2])
_cTipoCli := SA1->A1_TIPO
//-----------------------------------
/// Vendedor
_cVend := SA1->A1_VEND
If Empty(_cVend)
	dbSelectArea("SA3")
	dbsetOrder(1)
	dbGoTop()
	_cVend := SA3->A3_COD
EndIf

/// Condição de pagamento
dbSelectArea("SE4")
dbsetOrder(1)
dbGoTop()
_cCond := SE4->E4_CODIGO



//CABECALHO DO PEDIDO DE VENDA
//	aadd(_aCabPV,{"C5_NUM"  	 	, _cNextPV			,Nil}) // Numero do Item no Pedido
aadd(_aCabPV,{"C5_TIPO"   		, "N"         		,Nil})// Tipo de pedido
aadd(_aCabPV,{"C5_CLIENTE"	, _aCab[1]			,Nil}) // Codigo do cliente
aadd(_aCabPV,{"C5_LOJACLI"	, _aCab[2]  		,Nil}) // Loja do cliente
///aadd(_aCabPV,{"C5_XTPCON"		, "F"		,Nil}) // Tipo de Pedido // SK - 03/06/15
aadd(_aCabPV,{"C5_XTPCON"	, W_TPCONSI    		,Nil}) // Tipo de Pedido // SK - 03/06/15
aadd(_aCabPV,{"C5_XEVENTO"	, _aCab[3]	   		,Nil}) // Evento
aadd(_aCabPV,{"C5_CONDPAG"	, _aCab[4]	   		,Nil}) // Condição de Pagamento
aadd(_aCabPV,{"C5_TABELA"	, _aCab[5]	   		,Nil}) // Tabela de Preços
aadd(_aCabPV,{"C5_MENNOTA"	, _aCab[6]	   		,Nil}) // Mensagem para NF

//ITENS DO PEDIDO DE VENDA
_cNaoTem := ""
For n := 1 to Len(_aItem)

	//Executa o ajuste do saldo a classificar
	SB2_01(_aItem[n,1])

	//POSICIONA NO CADASTRO DE PRODUTOS
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+_aItem[n,1])
		_cLocalPad 	:= SB1->B1_LOCPAD
		_cB1UM	 		:= SB1->B1_UM
/////// SK - 03/06/15 - A PARTIR DESSA DATA PREPARA NF DE REMESSA OU FATURAMENTO
///		_cAlmox			:= "10"  //_cLocalPad
///		_cOper			:= FGETMV("MN_TOP_FT1","C",{"Código de operação utilizado","em pedidos de venda de","faturamento de consignação."},"13",,.T.)
///		_cTES				:= FGETMV("MN_TES_FT1","C",{"Código de TES utilizado","em pedidos de venda de","faturamento de consignação."},"630",,.T.)
///////

		_cOper  := IIF( W_TPCONSI == "F", "13", "10")
		_cTES   := IIF( W_TPCONSI == "F", "630", "530")
		_cAlmox	:= IIF( W_TPCONSI == "F", "10", "9 " )

	Else
		ApMsgInfo('Não achou o Produto '+AllTrim(_aItem[n,1])+' !')
		_lGeraPV	:= .F.
	EndIf


	/// Saldo no almoxarifado 10
	_cCodProd := AllTrim(_aItem[n,1]) + Space(len(SB1->B1_COD) - Len(AllTrim(_aItem[n,1])))
	dbSelectArea("SB2")
	dbsetOrder(1)
	If _lGeraPV .and. !dbSeek(xFilial("SB2") + _cCodProd + _cAlmox)
		// Se não achou, cria saldo para local 10
		RECLOCK("SB2", .T.)
		SB2->B2_FILIAL		:= xFilial("SB2")
		SB2->B2_COD		:= _cCodProd
		SB2->B2_LOCAL 	 	:= _cAlmox
		MsUnlock()
	EndIf
	cEvento := ""

	cAliasNew:= GetNextAlias()
	cQuery := " SELECT SZ1.Z1_PRODUTO, SZ1.Z1_DOCORI,SZ1.Z1_SERIEOR,SZ1.Z1_ITEMORI, SZ1.Z1_QUANT AS AFAT, SZ1.Z1_EVENTO, "+CHR(13)+CHR(10)
	cQuery += " SZ1.Z1_DOC, SZ1.Z1_SERIE,SZ1.Z1_ITEME "+CHR(13)+CHR(10)
	cQuery += " FROM "+CHR(13)+CHR(10)
	cQuery += RetSqlName("SZ1") + " SZ1 "+CHR(13)+CHR(10)
	cQuery += " WHERE SZ1.Z1_FILIAL  = '"+xFilial("SZ1")+"' "+CHR(13)+CHR(10)
	cQuery += " AND SZ1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10) // SK - 03/06/15
	cQuery += " AND SZ1.Z1_CLIENTE = '"+_aCab[1] + "' AND SZ1.Z1_LOJA = '"+_aCab[2]+"' "+CHR(13)+CHR(10)
	cQuery += " AND SZ1.Z1_PRODUTO = '"+ _cCodProd + "' "+CHR(13)+CHR(10)

	//Allan Bonfim - 05/05/2016
//	cQuery += " AND SZ1.Z1_PEDIDO  = ' ' "+CHR(13)+CHR(10)
	cQuery += " AND (SZ1.Z1_PEDIDO  = ' ' "+CHR(13)+CHR(10)
	cQuery += " 	OR EXISTS(SELECT C6_NUM, C6_PRODUTO, C6_NOTA, C6_SERIE, C6_ITEM, C6_XNFORCO, C6_XSERCON, C6_XITCON, D1_DOC, D1_SERIE, D1_ITEM "+CHR(13)+CHR(10)
	cQuery += " 		FROM "+RetSqlName("SC6") + " SC6 "+CHR(13)+CHR(10)
	cQuery += " 		INNER JOIN "+RetSqlName("SD1") + " SD1 "+CHR(13)+CHR(10)
	cQuery += " 		ON (C6_NOTA = D1_NFORI AND C6_SERIE = D1_SERIORI AND C6_ITEM = D1_ITEMORI AND SD1.D_E_L_E_T_ = '') "+CHR(13)+CHR(10)
	cQuery += " 		WHERE C6_NUM = SZ1.Z1_PEDIDO "+CHR(13)+CHR(10)
	cQuery += " 		AND SC6.D_E_L_E_T_ = '' "+CHR(13)+CHR(10)
	cQuery += " 		AND D1_XOPER = 'CS' "+CHR(13)+CHR(10)
	cQuery += " 		) "+CHR(13)+CHR(10)
	cQuery += "		) "+CHR(13)+CHR(10)

	cQuery += " AND SZ1.Z1_DOC  = '" + _aItem[n,4] + "' "+CHR(13)+CHR(10)
	cQuery += " AND SZ1.Z1_SERIE = '" + _aItem[n,5] + "' "+CHR(13)+CHR(10)
	cQuery += " AND SZ1.Z1_ITEME = '" + _aItem[n,6] + "' "+CHR(13)+CHR(10)
	// Filtro por Evento no Faturamento
	cQuery += " AND SZ1.Z1_EVENTO = '"+ cEvento + "' "+CHR(13)+CHR(10)

	///	cQuery += " AND SZ1.Z1_TIPO = 'S' AND SZ1.D_E_L_E_T_ <> '*' " // SK - 03/06/15
	IF EMPTY(W_NFUNICO) // SK - 03/06/15
	   cQuery += " AND SZ1.Z1_TIPO = 'S'"+CHR(13)+CHR(10)  // SK - 03/06/15
	ENDIF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
	MEMOWRITE ("VFATX001.TXT",cQuery)
	///		Grv_Disco("D:\TESTE.TXT",cQuery) // 04/05/12 - Alterado para c:\
	Grv_Disco("C:\TEMP\TESTE.TXT",cQuery) // 04/05/12 - Alterado para c:\

	(cAliasNew)->(dbGoTop())
	_cDocOri 	:= ""

	dbSelectArea("SZ1")
	dbSetOrder(1)
	//Z1_FILIAL+Z1_CLIENTE+Z1_LOJA+Z1_DOC+Z1_SERIE+Z1_PRODUTO+Z1_ITEME
	//Z1_FILIAL+Z1_CLIENTE+Z1_LOJA+Z1_DOCORI+Z1_SERIEOR+Z1_PRODUTO+Z1_ITEMORI
	If dbSeek(xFilial("SZ1")+_aCab[1]+_aCab[2]+_aItem[n,4]+_aItem[n,5]+_cCodProd+_aItem[n,6])
		_cDocOri 	:= SZ1->Z1_DOCORI
		_cSerOri 	:= SZ1->Z1_SERIEOR
		_cItOri 	:= SZ1->Z1_ITEMORI
		_cEvent		:= SZ1->Z1_EVENTO
		_cDoc		:= SZ1->Z1_DOC
		_cSer		:= SZ1->Z1_SERIE
//		_cItem		:= IIF(!EMPTY(SZ1->Z1_ITEME),SUBSTR(SZ1->Z1_ITEME,(LEN(SZ1->Z1_ITEME)-LEN(_cItem)+1)),_cItem)   // SONIA - 04/05/12 - Estava gravando 00 campo com 4 digitos e o c6_item com 2 digitos // SK - 03/06/15
		_cItemdev	:= SZ1->Z1_ITEME   // SONIA - 04/05/12 - Gravar o item da devolução da nota fiscal de entrada
		_nFat		:= SZ1->Z1_QUANT

		IF _cItemdev == "0001"
			_cItem := "01"
		ELSEIF _cItemdev == "0002"
			_cItem := "02"
		ELSEIF _cItemdev == "0003"
			_cItem := "03"
		ELSEIF _cItemdev == "0004"
			_cItem := "04"
		ELSEIF _cItemdev == "0005"
			_cItem := "05"
		ELSEIF _cItemdev == "0006"
			_cItem := "06"
		ELSEIF _cItemdev == "0007"
			_cItem := "07"
		ELSEIF _cItemdev == "0008"
			_cItem := "08"
		ELSEIF _cItemdev == "0009"
			_cItem := "09"
		ELSEIF _cItemdev == "0010"
			_cItem := "10"
		ELSEIF _cItemdev == "0011"
			_cItem := "11"
		ELSEIF _cItemdev == "0012"
			_cItem := "12"
		ELSEIF _cItemdev == "0013"
			_cItem := "13"
		ELSEIF _cItemdev == "0014"
			_cItem := "14"
		ELSEIF _cItemdev == "0015"
			_cItem := "15"
		ELSEIF _cItemdev == "0016"
			_cItem := "16"
		ELSEIF _cItemdev == "0017"
			_cItem := "17"
		ELSEIF _cItemdev == "0018"
			_cItem := "18"
		ELSEIF _cItemdev == "0019"
			_cItem := "19"
		ELSEIF _cItemdev == "0020"
			_cItem := "20"
		ELSEIF _cItemdev == "0021"
			_cItem := "21"
		ELSEIF _cItemdev == "0022"
			_cItem := "22"
		ELSEIF _cItemdev == "0023"
			_cItem := "23"
		ELSEIF _cItemdev == "0024"
			_cItem := "24"
		ELSEIF _cItemdev == "0025"
			_cItem := "25"
		ELSEIF _cItemdev == "0026"
			_cItem := "26"
		ELSEIF _cItemdev == "0027"
			_cItem := "27"
		ELSEIF _cItemdev == "0028"
			_cItem := "28"
		ELSEIF _cItemdev == "0029"
			_cItem := "29"
		ELSEIF _cItemdev == "0030"
			_cItem := "30"
		ELSEIF _cItemdev == "0031"
			_cItem := "31"
		ELSEIF _cItemdev == "0032"
			_cItem := "32"
		ELSEIF _cItemdev == "0033"
			_cItem := "33"
		ELSEIF _cItemdev == "0034"
			_cItem := "34"
		ELSEIF _cItemdev == "0035"
			_cItem := "35"
		ELSEIF _cItemdev == "0036"
			_cItem := "36"
		ELSEIF _cItemdev == "0037"
			_cItem := "37"
		ELSEIF _cItemdev == "0038"
			_cItem := "38"
		ELSEIF _cItemdev == "0039"
			_cItem := "39"
		ELSEIF _cItemdev == "0040"
			_cItem := "40"
		ELSEIF _cItemdev == "0041"
			_cItem := "41"
		ELSEIF _cItemdev == "0042"
			_cItem := "42"
		ELSEIF _cItemdev == "0043"
			_cItem := "43"
		ELSEIF _cItemdev == "0044"
			_cItem := "44"
		ELSEIF _cItemdev == "0045"
			_cItem := "45"
		ELSEIF _cItemdev == "0046"
			_cItem := "46"
		ELSEIF _cItemdev == "0047"
			_cItem := "47"
		ELSEIF _cItemdev == "0048"
			_cItem := "48"
		ELSEIF _cItemdev == "0049"
			_cItem := "49"
		ELSEIF _cItemdev == "0050"
			_cItem := "50"
		ELSEIF _cItemdev == "0051"
			_cItem := "51"
		ELSEIF _cItemdev == "0052"
			_cItem := "52"
		ELSEIF _cItemdev == "0053"
			_cItem := "53"
		ELSEIF _cItemdev == "0054"
			_cItem := "54"
		ELSEIF _cItemdev == "0055"
			_cItem := "55"
		ELSEIF _cItemdev == "0056"
			_cItem := "56"
		ELSEIF _cItemdev == "0057"
			_cItem := "57"
		ELSEIF _cItemdev == "0058"
			_cItem := "58"
		ELSEIF _cItemdev == "0059"
			_cItem := "59"
		ELSEIF _cItemdev == "0060"
			_cItem := "60"
		ELSEIF _cItemdev == "0061"
			_cItem := "61"
		ELSEIF _cItemdev == "0062"
			_cItem := "62"
		ELSEIF _cItemdev == "0063"
			_cItem := "63"
		ELSEIF _cItemdev == "0064"
			_cItem := "64"
		ELSEIF _cItemdev == "0065"
			_cItem := "65"
		ELSEIF _cItemdev == "0066"
			_cItem := "66"
		ELSEIF _cItemdev == "0067"
			_cItem := "67"
		ELSEIF _cItemdev == "0068"
			_cItem := "68"
		ELSEIF _cItemdev == "0069"
			_cItem := "69"
		ELSEIF _cItemdev == "0070"
			_cItem := "70"
		ELSEIF _cItemdev == "0071"
			_cItem := "71"
		ELSEIF _cItemdev == "0072"
			_cItem := "72"
		ELSEIF _cItemdev == "0073"
			_cItem := "73"
		ELSEIF _cItemdev == "0074"
			_cItem := "74"
		ELSEIF _cItemdev == "0075"
			_cItem := "75"
		ELSEIF _cItemdev == "0076"
			_cItem := "76"
		ELSEIF _cItemdev == "0077"
			_cItem := "77"
		ELSEIF _cItemdev == "0078"
			_cItem := "78"
		ELSEIF _cItemdev == "0079"
			_cItem := "79"
		ELSEIF _cItemdev == "0080"
			_cItem := "80"
		ELSEIF _cItemdev == "0081"
			_cItem := "81"
		ELSEIF _cItemdev == "0082"
			_cItem := "82"
		ELSEIF _cItemdev == "0083"
			_cItem := "83"
		ELSEIF _cItemdev == "0084"
			_cItem := "84"
		ELSEIF _cItemdev == "0085"
			_cItem := "85"
		ELSEIF _cItemdev == "0086"
			_cItem := "86"
		ELSEIF _cItemdev == "0087"
			_cItem := "87"
		ELSEIF _cItemdev == "0088"
			_cItem := "88"
		ELSEIF _cItemdev == "0089"
			_cItem := "89"
		ELSEIF _cItemdev == "0090"
			_cItem := "90"
		ELSEIF _cItemdev == "0091"
			_cItem := "91"
		ELSEIF _cItemdev == "0092"
			_cItem := "92"
		ELSEIF _cItemdev == "0093"
			_cItem := "93"
		ELSEIF _cItemdev == "0094"
			_cItem := "94"
		ELSEIF _cItemdev == "0095"
			_cItem := "95"
		ELSEIF _cItemdev == "0096"
			_cItem := "96"
		ELSEIF _cItemdev == "0097"
			_cItem := "97"
		ELSEIF _cItemdev == "0098"
			_cItem := "98"
		ELSEIF _cItemdev == "0099"
			_cItem := "99"
		ELSEIF _cItemdev == "0100"
			_cItem := "9A"
		ELSEIF _cItemdev == "0101"
			_cItem := "9B"
		ELSEIF _cItemdev == "0102"
			_cItem := "9C"
		ELSEIF _cItemdev == "0103"
			_cItem := "9D"
		ELSEIF _cItemdev == "0104"
			_cItem := "9E"
		ELSEIF _cItemdev == "0105"
			_cItem := "9F"
		ELSEIF _cItemdev == "0106"
			_cItem := "9G"
		ELSEIF _cItemdev == "0107"
			_cItem := "9H"
		ELSEIF _cItemdev == "0108"
			_cItem := "9I"
		ELSEIF _cItemdev == "0109"
			_cItem := "9J"
		ELSEIF _cItemdev == "0110"
			_cItem := "9K"
		ELSEIF _cItemdev == "0111"
			_cItem := "9L"
		ELSEIF _cItemdev == "0112"
			_cItem := "9M"
		ELSEIF _cItemdev == "0113"
			_cItem := "9N"
		ELSEIF _cItemdev == "0114"
			_cItem := "9O"
		ELSEIF _cItemdev == "0115"
			_cItem := "9P"
		ELSEIF _cItemdev == "0116"
			_cItem := "9Q"
		ELSEIF _cItemdev == "0117"
			_cItem := "9R
		ELSEIF _cItemdev == "0118"
			_cItem := "9S"
		ELSEIF _cItemdev == "0119"
			_cItem := "9T"
		ELSEIF _cItemdev == "0120"
			_cItem := "9U"
		ELSEIF _cItemdev == "0121"
			_cItem := "9V"
		ELSEIF _cItemdev == "0122"
			_cItem := "9W"
		ELSEIF _cItemdev == "0123"
			_cItem := "9X"
		ELSEIF _cItemdev == "0124"
			_cItem := "9Y"
		ELSEIF _cItemdev == "0125"
			_cItem := "9Z"
		ELSEIF _cItemdev == "0126"
			_cItem := "A0"
		ELSEIF _cItemdev == "0127"
			_cItem := "A1"
		ELSEIF _cItemdev == "0128"
			_cItem := "A2"
		ELSEIF _cItemdev == "0129"
			_cItem := "A3"
		ELSEIF _cItemdev == "0130"
			_cItem := "A4"
		ELSEIF _cItemdev == "0131"
			_cItem := "A5"
		ELSEIF _cItemdev == "0132"
			_cItem := "A6"
		ELSEIF _cItemdev == "0133"
			_cItem := "A7"
		ELSEIF _cItemdev == "0134"
			_cItem := "A8"
		ELSEIF _cItemdev == "0135"
			_cItem := "A9"
		ELSEIF _cItemdev == "0136"
			_cItem := "AA"
		ELSEIF _cItemdev == "0137"
			_cItem := "AB"
		ELSEIF _cItemdev == "0138"
			_cItem := "AC"
		ELSEIF _cItemdev == "0139"
			_cItem := "AD"
		ELSEIF _cItemdev == "0140"
			_cItem := "AE"
		ELSEIF _cItemdev == "0141"
			_cItem := "AF"
		ELSEIF _cItemdev == "0142"
			_cItem := "AG"
		ELSEIF _cItemdev == "0143"
			_cItem := "AH"
		ELSEIF _cItemdev == "0144"
			_cItem := "AI"
		ELSEIF _cItemdev == "0145"
			_cItem := "AJ"
		ELSEIF _cItemdev == "0146"
			_cItem := "AK"
		ELSEIF _cItemdev == "0147"
			_cItem := "AL"
		ELSEIF _cItemdev == "0148"
			_cItem := "AM"
		ELSEIF _cItemdev == "0149"
			_cItem := "AN"
		ELSEIF _cItemdev == "0150"
			_cItem := "AO"
		ELSEIF _cItemdev == "0151"
			_cItem := "AP"
		ELSEIF _cItemdev == "0152"
			_cItem := "AQ"
		ELSEIF _cItemdev == "0153"
			_cItem := "AR"
		ELSEIF _cItemdev == "0154"
			_cItem := "AS"
		ELSEIF _cItemdev == "0155"
			_cItem := "AT"
		ELSEIF _cItemdev == "0156"
			_cItem := "AU"
		ELSEIF _cItemdev == "0157"
			_cItem := "AV"
		ELSEIF _cItemdev == "0158"
			_cItem := "AW"
		ELSEIF _cItemdev == "0159"
			_cItem := "AX"
		ELSEIF _cItemdev == "0160"
			_cItem := "AY"
		ELSEIF _cItemdev == "0161"
			_cItem := "AZ"
		ELSEIF _cItemdev == "0162"
			_cItem := "B0"
		ELSEIF _cItemdev == "0163"
			_cItem := "B1"
		ELSEIF _cItemdev == "0164"
			_cItem := "B2"
		ELSEIF _cItemdev == "0165"
			_cItem := "B3"
		ELSEIF _cItemdev == "0166"
			_cItem := "B4"
		ELSEIF _cItemdev == "0167"
			_cItem := "B5"
		ELSEIF _cItemdev == "0168"
			_cItem := "B6"
		ELSEIF _cItemdev == "0169"
			_cItem := "B7"
		ELSEIF _cItemdev == "0170"
			_cItem := "B8"
		ELSEIF _cItemdev == "0171"
			_cItem := "B9"
		ELSEIF _cItemdev == "0172"
			_cItem := "BA"
		ELSEIF _cItemdev == "0173"
			_cItem := "BB"
		ELSEIF _cItemdev == "0174"
			_cItem := "BC"
		ELSEIF _cItemdev == "0175"
			_cItem := "BD"
		ELSEIF _cItemdev == "0176"
			_cItem := "BE"
		ELSEIF _cItemdev == "0177"
			_cItem := "BF"
		ELSEIF _cItemdev == "0178"
			_cItem := "BG"
		ELSEIF _cItemdev == "0179"
			_cItem := "BH"
		ELSEIF _cItemdev == "0180"
			_cItem := "BI"
		ELSEIF _cItemdev == "0181"
			_cItem := "BJ"
		ELSEIF _cItemdev == "0182"
			_cItem := "BK"
		ELSEIF _cItemdev == "0183"
			_cItem := "BL"
		ELSEIF _cItemdev == "0184"
			_cItem := "BM"
		ELSEIF _cItemdev == "0185"
			_cItem := "BN"
		ELSEIF _cItemdev == "0186"
			_cItem := "BO"
		ELSEIF _cItemdev == "0187"
			_cItem := "BP"
		ELSEIF _cItemdev == "0188"
			_cItem := "BQ"
		ELSEIF _cItemdev == "0189"
			_cItem := "BR"
		ELSEIF _cItemdev == "0190"
			_cItem := "BS"
		ELSEIF _cItemdev == "0191"
			_cItem := "BT"
		ELSEIF _cItemdev == "0192"
			_cItem := "BU"
		ELSEIF _cItemdev == "0193"
			_cItem := "BV"
		ELSEIF _cItemdev == "0194"
			_cItem := "BW"
		ELSEIF _cItemdev == "0195"
			_cItem := "BX"
		ELSEIF _cItemdev == "0196"
			_cItem := "BY"
		ELSEIF _cItemdev == "0197"
			_cItem := "BZ"
		ELSEIF _cItemdev == "0198"
			_cItem := "C0"
		ELSEIF _cItemdev == "0199"
			_cItem := "C1"
		ELSEIF _cItemdev == "0200"
			_cItem := "C2"
		ELSEIF _cItemdev == "0201"
			_cItem := "C3"
		ELSEIF _cItemdev == "0202"
			_cItem := "C4"
		ELSEIF _cItemdev == "0203"
			_cItem := "C5"
		ELSEIF _cItemdev == "0204"
			_cItem := "C6"
		ELSEIF _cItemdev == "0205"
			_cItem := "C7"
		ELSEIF _cItemdev == "0206"
			_cItem := "C8"
		ELSEIF _cItemdev == "0207"
			_cItem := "C9"
		ELSEIF _cItemdev == "0208"
			_cItem := "CA"
		ELSEIF _cItemdev == "0209"
			_cItem := "CB"
		ELSEIF _cItemdev == "0210"
			_cItem := "CC"
		ELSEIF _cItemdev == "0211"
			_cItem := "CD"
		ELSEIF _cItemdev == "0212"
			_cItem := "CE"
		ELSEIF _cItemdev == "0213"
			_cItem := "CF"
		ELSEIF _cItemdev == "0214"
			_cItem := "CG"
		ELSEIF _cItemdev == "0215"
			_cItem := "CH"
		ELSEIF _cItemdev == "0216"
			_cItem := "CI"
		ELSEIF _cItemdev == "0217"
			_cItem := "CJ"
		ELSEIF _cItemdev == "0218"
			_cItem := "CK"
		ELSEIF _cItemdev == "0219"
			_cItem := "CL"
		ELSEIF _cItemdev == "0220"
			_cItem := "CM"
		ELSEIF _cItemdev == "0221"
			_cItem := "CN"
		ELSEIF _cItemdev == "0222"
			_cItem := "CO"
		ELSEIF _cItemdev == "0223"
			_cItem := "CP"
		ELSEIF _cItemdev == "0224"
			_cItem := "CQ"
		ELSEIF _cItemdev == "0225"
			_cItem := "CR"
		ELSEIF _cItemdev == "0226"
			_cItem := "CS"
		ELSEIF _cItemdev == "0227"
			_cItem := "CT"
		ELSEIF _cItemdev == "0228"
			_cItem := "CU"
		ELSEIF _cItemdev == "0229"
			_cItem := "CV"
		ELSEIF _cItemdev == "0230"
			_cItem := "CW"
		ELSEIF _cItemdev == "0231"
			_cItem := "CX"
		ELSEIF _cItemdev == "0232"
			_cItem := "CY"
		ELSEIF _cItemdev == "0233"
			_cItem := "CZ"
		ELSEIF _cItemdev == "0234"
			_cItem := "D0"
		ELSEIF _cItemdev == "0235"
			_cItem := "D1"
		ELSEIF _cItemdev == "0236"
			_cItem := "D2"
		ELSEIF _cItemdev == "0237"
			_cItem := "D3"
		ELSEIF _cItemdev == "0238"
			_cItem := "D4"
		ELSEIF _cItemdev == "0239"
			_cItem := "D5"
		ELSEIF _cItemdev == "0240"
			_cItem := "D6"
		ELSEIF _cItemdev == "0241"
			_cItem := "D7"
		ELSEIF _cItemdev == "0242"
			_cItem := "D8"
		ELSEIF _cItemdev == "0243"
			_cItem := "D9"
		ELSEIF _cItemdev == "0244"
			_cItem := "DA"
		ELSEIF _cItemdev == "0245"
			_cItem := "DB"
		ELSEIF _cItemdev == "0246"
			_cItem := "DC"
		ELSEIF _cItemdev == "0247"
			_cItem := "DD"
		ELSEIF _cItemdev == "0248"
			_cItem := "DE"
		ELSEIF _cItemdev == "0249"
			_cItem := "DF"
		ELSEIF _cItemdev == "0250"
			_cItem := "DG"
		ELSEIF _cItemdev == "0251"
			_cItem := "DH"
		ELSEIF _cItemdev == "0252"
			_cItem := "DI"
		ELSEIF _cItemdev == "0253"
			_cItem := "DJ"
		ELSEIF _cItemdev == "0254"
			_cItem := "DK"
		ELSEIF _cItemdev == "0255"
			_cItem := "DL"
		ELSEIF _cItemdev == "0256"
			_cItem := "DM"
		ELSEIF _cItemdev == "0257"
			_cItem := "DN"
		ELSEIF _cItemdev == "0258"
			_cItem := "DO"
		ELSEIF _cItemdev == "0259"
			_cItem := "DP"
		ELSEIF _cItemdev == "0260"
			_cItem := "DQ"
		ELSEIF _cItemdev == "0261"
			_cItem := "DR"
		ELSEIF _cItemdev == "0262"
			_cItem := "DS"
		ELSEIF _cItemdev == "0263"
			_cItem := "DT"
		ELSEIF _cItemdev == "0264"
			_cItem := "DU"
		ELSEIF _cItemdev == "0265"
			_cItem := "DV"
		ELSEIF _cItemdev == "0266"
			_cItem := "DW"
		ELSEIF _cItemdev == "0267"
			_cItem := "DX"
		ELSEIF _cItemdev == "0268"
			_cItem := "DY"
		ELSEIF _cItemdev == "0269"
			_cItem := "DZ"
		ELSEIF _cItemdev == "0270"
			_cItem := "E0"
		ELSEIF _cItemdev == "0271"
			_cItem := "E1"
		ELSEIF _cItemdev == "0272"
			_cItem := "E2"
		ELSEIF _cItemdev == "0273"
			_cItem := "E3"
		ELSEIF _cItemdev == "0274"
			_cItem := "E4"
		ELSEIF _cItemdev == "0275"
			_cItem := "E5"
		ELSEIF _cItemdev == "0276"
			_cItem := "E6"
		ELSEIF _cItemdev == "0277"
			_cItem := "E7"
		ELSEIF _cItemdev == "0278"
			_cItem := "E8"
		ELSEIF _cItemdev == "0279"
			_cItem := "E9"
		ELSEIF _cItemdev == "0280"
			_cItem := "EA"
		ELSEIF _cItemdev == "0281"
			_cItem := "EB"
		ELSEIF _cItemdev == "0282"
			_cItem := "EC"
		ELSEIF _cItemdev == "0283"
			_cItem := "ED"
		ELSEIF _cItemdev == "0284"
			_cItem := "EE"
		ELSEIF _cItemdev == "0285"
			_cItem := "EF"
		ELSEIF _cItemdev == "0286"
			_cItem := "EG"
		ELSEIF _cItemdev == "0287"
			_cItem := "EH"
		ELSEIF _cItemdev == "0288"
			_cItem := "EI"
		ELSEIF _cItemdev == "0289"
			_cItem := "EJ"
		ELSEIF _cItemdev == "0290"
			_cItem := "EK"
		ELSEIF _cItemdev == "0291"
			_cItem := "EL"
		ELSEIF _cItemdev == "0292"
			_cItem := "EM"
		ELSEIF _cItemdev == "0293"
			_cItem := "EN"
		ELSEIF _cItemdev == "0294"
			_cItem := "EO"
		ELSEIF _cItemdev == "0295"
			_cItem := "EP"
		ELSEIF _cItemdev == "0296"
			_cItem := "EQ"
		ELSEIF _cItemdev == "0297"
			_cItem := "ER"
		ELSEIF _cItemdev == "0298"
			_cItem := "ES"
		ELSEIF _cItemdev == "0299"
			_cItem := "ET"
		ELSEIF _cItemdev == "0300"
			_cItem := "EU"
		ELSEIF _cItemdev == "0301"
			_cItem := "EV"
		ELSEIF _cItemdev == "0302"
			_cItem := "EW"
		ELSEIF _cItemdev == "0303"
			_cItem := "EX"
		ELSEIF _cItemdev == "0304"
			_cItem := "EY"
		ELSEIF _cItemdev == "0305"
			_cItem := "EZ"
		ELSEIF _cItemdev == "0306"
			_cItem := "F0"
		ELSEIF _cItemdev == "0307"
			_cItem := "F1"
		ELSEIF _cItemdev == "0308"
			_cItem := "F2"
		ELSEIF _cItemdev == "0309"
			_cItem := "F3"
		ELSEIF _cItemdev == "0310"
			_cItem := "F4"
		ELSEIF _cItemdev == "0311"
			_cItem := "F5"
		ELSEIF _cItemdev == "0312"
			_cItem := "F6"
		ELSEIF _cItemdev == "0313"
			_cItem := "F7"
		ELSEIF _cItemdev == "0314"
			_cItem := "F8"
		ELSEIF _cItemdev == "0315"
			_cItem := "F9"
		ELSEIF _cItemdev == "0316"
			_cItem := "FA"
		ELSEIF _cItemdev == "0317"
			_cItem := "FB"
		ELSEIF _cItemdev == "0318"
			_cItem := "FC"
		ELSEIF _cItemdev == "0319"
			_cItem := "FD"
		ELSEIF _cItemdev == "0320"
			_cItem := "FE"
		ELSEIF _cItemdev == "0321"
			_cItem := "FF"
		ELSEIF _cItemdev == "0322"
			_cItem := "FG"
		ELSEIF _cItemdev == "0323"
			_cItem := "FH"
		ELSEIF _cItemdev == "0324"
			_cItem := "FI"
		ELSEIF _cItemdev == "0325"
			_cItem := "FJ"
		ELSEIF _cItemdev == "0326"
			_cItem := "FK"
		ELSEIF _cItemdev == "0327"
			_cItem := "FL"
		ELSEIF _cItemdev == "0328"
			_cItem := "FM"
		ELSEIF _cItemdev == "0329"
			_cItem := "FN"
		ELSEIF _cItemdev == "0330"
			_cItem := "FO"
		ELSEIF _cItemdev == "0331"
			_cItem := "FP"
		ELSEIF _cItemdev == "0332"
			_cItem := "FQ"
		ELSEIF _cItemdev == "0333"
			_cItem := "FR"
		ELSEIF _cItemdev == "0334"
			_cItem := "FS"
		ELSEIF _cItemdev == "0335"
			_cItem := "FT"
		ELSEIF _cItemdev == "0336"
			_cItem := "FU"
		ELSEIF _cItemdev == "0337"
			_cItem := "FV"
		ELSEIF _cItemdev == "0338"
			_cItem := "FW"
		ELSEIF _cItemdev == "0339"
			_cItem := "FX"
		ELSEIF _cItemdev == "0340"
			_cItem := "FY"
		ELSEIF _cItemdev == "0341"
			_cItem := "FZ"
		ELSEIF _cItemdev == "0342"
			_cItem := "G0"
		ELSEIF _cItemdev == "0343"
			_cItem := "G1"
		ELSEIF _cItemdev == "0344"
			_cItem := "G2"
		ELSEIF _cItemdev == "0345"
			_cItem := "G3"
		ELSEIF _cItemdev == "0346"
			_cItem := "G4"
		ELSEIF _cItemdev == "0347"
			_cItem := "G5"
		ELSEIF _cItemdev == "0348"
			_cItem := "G6"
		ELSEIF _cItemdev == "0349"
			_cItem := "G7"
		ELSEIF _cItemdev == "0350"
			_cItem := "G8"
		ELSEIF _cItemdev == "0351"
			_cItem := "G9"
		ELSEIF _cItemdev == "0352"
			_cItem := "GA"
		ELSEIF _cItemdev == "0353"
			_cItem := "GB"
		ELSEIF _cItemdev == "0354"
			_cItem := "GC"
		ELSEIF _cItemdev == "0355"
			_cItem := "GD"
		ELSEIF _cItemdev == "0356"
			_cItem := "GE"
		ELSEIF _cItemdev == "0357"
			_cItem := "GF"
		ELSEIF _cItemdev == "0358"
			_cItem := "GG"
		ELSEIF _cItemdev == "0359"
			_cItem := "GH"
		ELSEIF _cItemdev == "0360"
			_cItem := "GI"
		ELSEIF _cItemdev == "0361"
			_cItem := "GJ"
		ELSEIF _cItemdev == "0362"
			_cItem := "GK"
		ELSEIF _cItemdev == "0363"
			_cItem := "GL"
		ELSEIF _cItemdev == "0364"
			_cItem := "GM"
		ELSEIF _cItemdev == "0365"
			_cItem := "GN"
		ELSEIF _cItemdev == "0366"
			_cItem := "GO"
		ELSEIF _cItemdev == "0367"
			_cItem := "GP"
		ELSEIF _cItemdev == "0368"
			_cItem := "GQ"
		ELSEIF _cItemdev == "0369"
			_cItem := "GR"
		ELSEIF _cItemdev == "0370"
			_cItem := "GS"
		ELSEIF _cItemdev == "0371"
			_cItem := "GT"
		ELSEIF _cItemdev == "0372"
			_cItem := "GU"
		ELSEIF _cItemdev == "0373"
			_cItem := "GV"
		ELSEIF _cItemdev == "0374"
			_cItem := "GW"
		ELSEIF _cItemdev == "0375"
			_cItem := "GX"
		ELSEIF _cItemdev == "0376"
			_cItem := "GY"
		ELSEIF _cItemdev == "0377"
			_cItem := "GZ"
		ELSEIF _cItemdev == "0378"
			_cItem := "H0"
		ELSEIF _cItemdev == "0379"
			_cItem := "H1"
		ELSEIF _cItemdev == "0380"
			_cItem := "H2"
		ELSEIF _cItemdev == "0381"
			_cItem := "H3"
		ELSEIF _cItemdev == "0382"
			_cItem := "H4"
		ELSEIF _cItemdev == "0383"
			_cItem := "H5"
		ELSEIF _cItemdev == "0384"
			_cItem := "H6"
		ELSEIF _cItemdev == "0385"
			_cItem := "H7"
		ELSEIF _cItemdev == "0386"
			_cItem := "H8"
		ELSEIF _cItemdev == "0387"
			_cItem := "H9"
		ELSEIF _cItemdev == "0388"
			_cItem := "HA"
		ELSEIF _cItemdev == "0389"
			_cItem := "HB"
		ELSEIF _cItemdev == "0390"
			_cItem := "HC"
		ELSEIF _cItemdev == "0391"
			_cItem := "HD"
		ELSEIF _cItemdev == "0392"
			_cItem := "HE"
		ELSEIF _cItemdev == "0393"
			_cItem := "HF"
		ELSEIF _cItemdev == "0394"
			_cItem := "HG"
		ELSEIF _cItemdev == "0395"
			_cItem := "HH"
		ELSEIF _cItemdev == "0396"
			_cItem := "HI"
		ELSEIF _cItemdev == "0397"
			_cItem := "HJ"
		ELSEIF _cItemdev == "0398"
			_cItem := "HK"
		ELSEIF _cItemdev == "0399"
			_cItem := "HL"
		ELSEIF _cItemdev == "0400"
			_cItem := "HM"
		ELSEIF _cItemdev == "0401"
			_cItem := "HN"
		ELSEIF _cItemdev == "0402"
			_cItem := "HO"
		ELSEIF _cItemdev == "0403"
			_cItem := "HP"
		ELSEIF _cItemdev == "0404"
			_cItem := "HQ"
		ELSEIF _cItemdev == "0405"
			_cItem := "HR"
		ELSEIF _cItemdev == "0406"
			_cItem := "HS"
		ELSEIF _cItemdev == "0407"
			_cItem := "HT"
		ELSEIF _cItemdev == "0408"
			_cItem := "HU"
		ELSEIF _cItemdev == "0409"
			_cItem := "HV"
		ELSEIF _cItemdev == "0410"
			_cItem := "HW"
		ELSEIF _cItemdev == "0411"
			_cItem := "HX"
		ELSEIF _cItemdev == "0412"
			_cItem := "HY"
		ELSEIF _cItemdev == "0413"
			_cItem := "HZ"
		ELSEIF _cItemdev == "0414"
			_cItem := "I0"
		ELSEIF _cItemdev == "0415"
			_cItem := "I1"
		ELSEIF _cItemdev == "0416"
			_cItem := "I2"
		ELSEIF _cItemdev == "0417"
			_cItem := "I3"
		ELSEIF _cItemdev == "0418"
			_cItem := "I4"
		ELSEIF _cItemdev == "0419"
			_cItem := "I5"
		ELSEIF _cItemdev == "0420"
			_cItem := "I6"
		ELSEIF _cItemdev == "0421"
			_cItem := "I7"
		ELSEIF _cItemdev == "0422"
			_cItem := "I8"
		ELSEIF _cItemdev == "0423"
			_cItem := "I9"
		ELSEIF _cItemdev == "0424"
			_cItem := "IA"
		ELSEIF _cItemdev == "0425"
			_cItem := "IB"
		ELSEIF _cItemdev == "0426"
			_cItem := "IC"
		ELSEIF _cItemdev == "0427"
			_cItem := "ID"
		ELSEIF _cItemdev == "0428"
			_cItem := "IE"
		ELSEIF _cItemdev == "0429"
			_cItem := "IF"
		ELSEIF _cItemdev == "0430"
			_cItem := "IG"
		ELSEIF _cItemdev == "0431"
			_cItem := "IH"
		ELSEIF _cItemdev == "0432"
			_cItem := "II"
		ELSEIF _cItemdev == "0433"
			_cItem := "IJ"
		ELSEIF _cItemdev == "0434"
			_cItem := "IK"
		ELSEIF _cItemdev == "0435"
			_cItem := "IL"
		ELSEIF _cItemdev == "0436"
			_cItem := "IM"
		ELSEIF _cItemdev == "0437"
			_cItem := "IN"
		ELSEIF _cItemdev == "0438"
			_cItem := "IO"
		ELSEIF _cItemdev == "0439"
			_cItem := "IP"
		ELSEIF _cItemdev == "0440"
			_cItem := "IQ"
		ELSEIF _cItemdev == "0441"
			_cItem := "IR"
		ELSEIF _cItemdev == "0442"
			_cItem := "IS"
		ELSEIF _cItemdev == "0443"
			_cItem := "IT"
		ELSEIF _cItemdev == "0444"
			_cItem := "IU"
		ELSEIF _cItemdev == "0445"
			_cItem := "IV"
		ELSEIF _cItemdev == "0446"
			_cItem := "IW"
		ELSEIF _cItemdev == "0447"
			_cItem := "IX"
		ELSEIF _cItemdev == "0448"
			_cItem := "IY"
		ELSEIF _cItemdev == "0449"
			_cItem := "IZ"
		ELSEIF _cItemdev == "0450"
			_cItem := "J0"
		ELSEIF _cItemdev == "0451"
			_cItem := "J1"
		ELSEIF _cItemdev == "0452"
			_cItem := "J2"
		ELSEIF _cItemdev == "0453"
			_cItem := "J3"
		ELSEIF _cItemdev == "0454"
			_cItem := "J4"
		ELSEIF _cItemdev == "0455"
			_cItem := "J5"
		ELSEIF _cItemdev == "0456"
			_cItem := "J6"
		ELSEIF _cItemdev == "0457"
			_cItem := "J7"
		ELSEIF _cItemdev == "0458"
			_cItem := "J8"
		ELSEIF _cItemdev == "0459"
			_cItem := "J9"
		ELSEIF _cItemdev == "0460"
			_cItem := "JA"
		ELSEIF _cItemdev == "0461"
			_cItem := "JB"
		ELSEIF _cItemdev == "0462"
			_cItem := "JC"
		ELSEIF _cItemdev == "0463"
			_cItem := "JD"
		ELSEIF _cItemdev == "0464"
			_cItem := "JE"
		ELSEIF _cItemdev == "0465"
			_cItem := "JF"
		ELSEIF _cItemdev == "0466"
			_cItem := "JG"
		ELSEIF _cItemdev == "0467"
			_cItem := "JH"
		ELSEIF _cItemdev == "0468"
			_cItem := "JI"
		ELSEIF _cItemdev == "0469"
			_cItem := "JJ"
		ELSEIF _cItemdev == "0470"
			_cItem := "JK"
		ELSEIF _cItemdev == "0471"
			_cItem := "JL"
		ELSEIF _cItemdev == "0472"
			_cItem := "JM"
		ELSEIF _cItemdev == "0473"
			_cItem := "JN"
		ELSEIF _cItemdev == "0474"
			_cItem := "JO"
		ELSEIF _cItemdev == "0475"
			_cItem := "JP"
		ELSEIF _cItemdev == "0476"
			_cItem := "JQ"
		ELSEIF _cItemdev == "0477"
			_cItem := "JR"
		ELSEIF _cItemdev == "0478"
			_cItem := "JS"
		ELSEIF _cItemdev == "0479"
			_cItem := "JT"
		ELSEIF _cItemdev == "0480"
			_cItem := "JU"
		ELSEIF _cItemdev == "0481"
			_cItem := "JV"
		ELSEIF _cItemdev == "0482"
			_cItem := "JW"
		ELSEIF _cItemdev == "0483"
			_cItem := "JX"
		ELSEIF _cItemdev == "0484"
			_cItem := "JY"
		ELSEIF _cItemdev == "0485"
			_cItem := "JZ"
		ELSEIF _cItemdev == "0486"
			_cItem := "K0"
		ELSEIF _cItemdev == "0487"
			_cItem := "K1"
		ELSEIF _cItemdev == "0488"
			_cItem := "K2"
		ELSEIF _cItemdev == "0489"
			_cItem := "K3"
		ELSEIF _cItemdev == "0490"
			_cItem := "K4"
		ELSEIF _cItemdev == "0491"
			_cItem := "K5"
		ELSEIF _cItemdev == "0492"
			_cItem := "K6"
		ELSEIF _cItemdev == "0493"
			_cItem := "K7"
		ELSEIF _cItemdev == "0494"
			_cItem := "K8"
		ELSEIF _cItemdev == "0495"
			_cItem := "K9"
		ELSEIF _cItemdev == "0496"
			_cItem := "KA"
		ELSEIF _cItemdev == "0497"
			_cItem := "KB"
		ELSEIF _cItemdev == "0498"
			_cItem := "KC"
		ELSEIF _cItemdev == "0499"
			_cItem := "KD"
		ELSEIF _cItemdev == "0500"
			_cItem := "KE"
		ELSEIF _cItemdev == "0501"
			_cItem := "KF"
		ELSEIF _cItemdev == "0502"
			_cItem := "KG"
		ELSEIF _cItemdev == "0503"
			_cItem := "KH"
		ELSEIF _cItemdev == "0504"
			_cItem := "KI"
		ELSEIF _cItemdev == "0505"
			_cItem := "KJ"
		ELSEIF _cItemdev == "0506"
			_cItem := "KK"
		ELSEIF _cItemdev == "0507"
			_cItem := "KL"
		ELSEIF _cItemdev == "0508"
			_cItem := "KM"
		ELSEIF _cItemdev == "0509"
			_cItem := "KN"
		ELSEIF _cItemdev == "0510"
			_cItem := "KO"
		ELSEIF _cItemdev == "0511"
			_cItem := "KP"
		ELSEIF _cItemdev == "0512"
			_cItem := "KQ"
		ELSEIF _cItemdev == "0513"
			_cItem := "KR"
		ELSEIF _cItemdev == "0514"
			_cItem := "KS"
		ELSEIF _cItemdev == "0515"
			_cItem := "KT"
		ELSEIF _cItemdev == "0516"
			_cItem := "KU"
		ELSEIF _cItemdev == "0517"
			_cItem := "KV"
		ELSEIF _cItemdev == "0518"
			_cItem := "KW"
		ELSEIF _cItemdev == "0519"
			_cItem := "KX"
		ELSEIF _cItemdev == "0520"
			_cItem := "KY"
		ELSEIF _cItemdev == "0521"
			_cItem := "KZ"
		ELSEIF _cItemdev == "0522"
			_cItem := "L0"
		ELSEIF _cItemdev == "0523"
			_cItem := "L1"
		ELSEIF _cItemdev == "0524"
			_cItem := "L2"
		ELSEIF _cItemdev == "0525"
			_cItem := "L3"
		ELSEIF _cItemdev == "0526"
			_cItem := "L4"
		ELSEIF _cItemdev == "0527"
			_cItem := "L5"
		ELSEIF _cItemdev == "0528"
			_cItem := "L6"
		ELSEIF _cItemdev == "0529"
			_cItem := "L7"
		ELSEIF _cItemdev == "0530"
			_cItem := "L8"
		ELSEIF _cItemdev == "0531"
			_cItem := "L9"
		ELSEIF _cItemdev == "0532"
			_cItem := "LA"
		ELSEIF _cItemdev == "0533"
			_cItem := "LB"
		ELSEIF _cItemdev == "0534"
			_cItem := "LC"
		ELSEIF _cItemdev == "0535"
			_cItem := "LD"
		ELSEIF _cItemdev == "0536"
			_cItem := "LE"
		ELSEIF _cItemdev == "0537"
			_cItem := "LF"
		ELSEIF _cItemdev == "0538"
			_cItem := "LG"
		ELSEIF _cItemdev == "0539"
			_cItem := "LH"
		ELSEIF _cItemdev == "0540"
			_cItem := "LI"
		ELSEIF _cItemdev == "0541"
			_cItem := "LJ"
		ELSEIF _cItemdev == "0542"
			_cItem := "LK"
		ELSEIF _cItemdev == "0543"
			_cItem := "LL"
		ELSEIF _cItemdev == "0544"
			_cItem := "LM"
		ELSEIF _cItemdev == "0545"
			_cItem := "LN"
		ELSEIF _cItemdev == "0546"
			_cItem := "LO"
		ELSEIF _cItemdev == "0547"
			_cItem := "LP"
		ELSEIF _cItemdev == "0548"
			_cItem := "LQ"
		ELSEIF _cItemdev == "0549"
			_cItem := "LR"
		ELSEIF _cItemdev == "0550"
			_cItem := "LS"
		ELSEIF _cItemdev == "0551"
			_cItem := "LT"
		ELSEIF _cItemdev == "0552"
			_cItem := "LU"
		ELSEIF _cItemdev == "0553"
			_cItem := "LV"
		ELSEIF _cItemdev == "0554"
			_cItem := "LW"
		ELSEIF _cItemdev == "0555"
			_cItem := "LX"
		ELSEIF _cItemdev == "0556"
			_cItem := "LY"
		ELSEIF _cItemdev == "0557"
			_cItem := "LZ"
		ELSEIF _cItemdev == "0558"
			_cItem := "M0"
		ELSEIF _cItemdev == "0559"
			_cItem := "M1"
		ELSEIF _cItemdev == "0560"
			_cItem := "M2"
		ELSEIF _cItemdev == "0561"
			_cItem := "M3"
		ELSEIF _cItemdev == "0562"
			_cItem := "M4"
		ELSEIF _cItemdev == "0563"
			_cItem := "M5"
		ELSEIF _cItemdev == "0564"
			_cItem := "M6"
		ELSEIF _cItemdev == "0565"
			_cItem := "M7"
		ELSEIF _cItemdev == "0566"
			_cItem := "M8"
		ELSEIF _cItemdev == "0567"
			_cItem := "M9"
		ELSEIF _cItemdev == "0568"
			_cItem := "MA"
		ELSEIF _cItemdev == "0569"
			_cItem := "MB"
		ELSEIF _cItemdev == "0570"
			_cItem := "MC"
		ELSEIF _cItemdev == "0571"
			_cItem := "MD"
		ELSEIF _cItemdev == "0572"
			_cItem := "ME"
		ELSEIF _cItemdev == "0573"
			_cItem := "MF"
		ELSEIF _cItemdev == "0574"
			_cItem := "MG"
		ELSEIF _cItemdev == "0575"
			_cItem := "MH"
		ELSEIF _cItemdev == "0576"
			_cItem := "MI"
		ELSEIF _cItemdev == "0577"
			_cItem := "MJ"
		ELSEIF _cItemdev == "0578"
			_cItem := "MK"
		ELSEIF _cItemdev == "0579"
			_cItem := "ML"
		ELSEIF _cItemdev == "0580"
			_cItem := "MM"
		ELSEIF _cItemdev == "0581"
			_cItem := "MN"
		ELSEIF _cItemdev == "0582"
			_cItem := "MO"
		ELSEIF _cItemdev == "0583"
			_cItem := "MP"
		ELSEIF _cItemdev == "0584"
			_cItem := "MQ"
		ELSEIF _cItemdev == "0585"
			_cItem := "MR"
		ELSEIF _cItemdev == "0586"
			_cItem := "MS"
		ELSEIF _cItemdev == "0587"
			_cItem := "MT"
		ELSEIF _cItemdev == "0588"
			_cItem := "MU"
		ELSEIF _cItemdev == "0589"
			_cItem := "MV"
		ELSEIF _cItemdev == "0590"
			_cItem := "MW"
		ELSEIF _cItemdev == "0591"
			_cItem := "MX"
		ELSEIF _cItemdev == "0592"
			_cItem := "MY"
		ELSEIF _cItemdev == "0593"
			_cItem := "MZ"
		ELSEIF _cItemdev == "0594"
			_cItem := "N0"
		ELSEIF _cItemdev == "0595"
			_cItem := "N1"
		ELSEIF _cItemdev == "0596"
			_cItem := "N2"
		ELSEIF _cItemdev == "0597"
			_cItem := "N3"
		ELSEIF _cItemdev == "0598"
			_cItem := "N4"
		ELSEIF _cItemdev == "0599"
			_cItem := "N5"
		ELSEIF _cItemdev == "0600"
			_cItem := "N6"
		ELSEIF _cItemdev == "0601"
			_cItem := "N7"
		ELSEIF _cItemdev == "0602"
			_cItem := "N8"
		ELSEIF _cItemdev == "0603"
			_cItem := "N9"
		ELSEIF _cItemdev == "0604"
			_cItem := "NA"
		ELSEIF _cItemdev == "0605"
			_cItem := "NB"
		ELSEIF _cItemdev == "0606"
			_cItem := "NC"
		ELSEIF _cItemdev == "0607"
			_cItem := "ND"
		ELSEIF _cItemdev == "0608"
			_cItem := "NE"
		ELSEIF _cItemdev == "0609"
			_cItem := "NF"
		ELSEIF _cItemdev == "0610"
			_cItem := "NG"
		ELSEIF _cItemdev == "0611"
			_cItem := "NH"
		ELSEIF _cItemdev == "0612"
			_cItem := "NI"
		ELSEIF _cItemdev == "0613"
			_cItem := "NJ"
		ELSEIF _cItemdev == "0614"
			_cItem := "NK"
		ELSEIF _cItemdev == "0615"
			_cItem := "NL"
		ELSEIF _cItemdev == "0616"
			_cItem := "NM"
		ELSEIF _cItemdev == "0617"
			_cItem := "NN"
		ELSEIF _cItemdev == "0618"
			_cItem := "NO"
		ELSEIF _cItemdev == "0619"
			_cItem := "NP"
		ELSEIF _cItemdev == "0620"
			_cItem := "NQ"
		ELSEIF _cItemdev == "0621"
			_cItem := "NR"
		ELSEIF _cItemdev == "0622"
			_cItem := "NS"
		ELSEIF _cItemdev == "0623"
			_cItem := "NT"
		ELSEIF _cItemdev == "0624"
			_cItem := "NU"
		ELSEIF _cItemdev == "0625"
			_cItem := "NV"
		ELSEIF _cItemdev == "0626"
			_cItem := "NW"
		ELSEIF _cItemdev == "0627"
			_cItem := "NX"
		ELSEIF _cItemdev == "0628"
			_cItem := "NY"
		ELSEIF _cItemdev == "0629"
			_cItem := "NZ"
		ELSEIF _cItemdev == "0630"
			_cItem := "O0"
		ELSEIF _cItemdev == "0631"
			_cItem := "O1"
		ELSEIF _cItemdev == "0632"
			_cItem := "O2"
		ELSEIF _cItemdev == "0633"
			_cItem := "O3"
		ELSEIF _cItemdev == "0634"
			_cItem := "O4"
		ELSEIF _cItemdev == "0635"
			_cItem := "O5"
		ELSEIF _cItemdev == "0636"
			_cItem := "O6"
		ELSEIF _cItemdev == "0637"
			_cItem := "O7"
		ELSEIF _cItemdev == "0638"
			_cItem := "O8"
		ELSEIF _cItemdev == "0639"
			_cItem := "O9"
		ELSEIF _cItemdev == "0640"
			_cItem := "OA"
		ELSEIF _cItemdev == "0641"
			_cItem := "OB"
		ELSEIF _cItemdev == "0642"
			_cItem := "OC"
		ELSEIF _cItemdev == "0643"
			_cItem := "OD"
		ELSEIF _cItemdev == "0644"
			_cItem := "OE"
		ELSEIF _cItemdev == "0645"
			_cItem := "OF"
		ELSEIF _cItemdev == "0646"
			_cItem := "OG"
		ELSEIF _cItemdev == "0647"
			_cItem := "OH"
		ELSEIF _cItemdev == "0648"
			_cItem := "OI"
		ELSEIF _cItemdev == "0649"
			_cItem := "OJ"
		ELSEIF _cItemdev == "0650"
			_cItem := "OK"
		ELSEIF _cItemdev == "0651"
			_cItem := "OL"
		ELSEIF _cItemdev == "0652"
			_cItem := "OM"
		ELSEIF _cItemdev == "0653"
			_cItem := "ON"
		ELSEIF _cItemdev == "0654"
			_cItem := "OO"
		ELSEIF _cItemdev == "0655"
			_cItem := "OP"
		ELSEIF _cItemdev == "0656"
			_cItem := "OQ"
		ELSEIF _cItemdev == "0657"
			_cItem := "OR"
		ELSEIF _cItemdev == "0658"
			_cItem := "OS"
		ELSEIF _cItemdev == "0659"
			_cItem := "OT"
		ELSEIF _cItemdev == "0660"
			_cItem := "OU"
		ELSEIF _cItemdev == "0661"
			_cItem := "OV"
		ELSEIF _cItemdev == "0662"
			_cItem := "OW"
		ELSEIF _cItemdev == "0663"
			_cItem := "OX"
		ELSEIF _cItemdev == "0664"
			_cItem := "OY"
		ELSEIF _cItemdev == "0665"
			_cItem := "OZ"
		ELSEIF _cItemdev == "0666"
			_cItem := "P0"
		ELSEIF _cItemdev == "0667"
			_cItem := "P1"
		ELSEIF _cItemdev == "0668"
			_cItem := "P2"
		ELSEIF _cItemdev == "0669"
			_cItem := "P3"
		ELSEIF _cItemdev == "0670"
			_cItem := "P4"
		ELSEIF _cItemdev == "0671"
			_cItem := "P5"
		ELSEIF _cItemdev == "0672"
			_cItem := "P6"
		ELSEIF _cItemdev == "0673"
			_cItem := "P7"
		ELSEIF _cItemdev == "0674"
			_cItem := "P8"
		ELSEIF _cItemdev == "0675"
			_cItem := "P9"
		ELSEIF _cItemdev == "0676"
			_cItem := "PA"
		ELSEIF _cItemdev == "0677"
			_cItem := "PB"
		ELSEIF _cItemdev == "0678"
			_cItem := "PC"
		ELSEIF _cItemdev == "0679"
			_cItem := "PD"
		ELSEIF _cItemdev == "0680"
			_cItem := "PE"
		ELSEIF _cItemdev == "0681"
			_cItem := "PF"
		ELSEIF _cItemdev == "0682"
			_cItem := "PG"
		ELSEIF _cItemdev == "0683"
			_cItem := "PH"
		ELSEIF _cItemdev == "0684"
			_cItem := "PI"
		ELSEIF _cItemdev == "0685"
			_cItem := "PJ"
		ELSEIF _cItemdev == "0686"
			_cItem := "PK"
		ELSEIF _cItemdev == "0687"
			_cItem := "PL"
		ELSEIF _cItemdev == "0688"
			_cItem := "PM"
		ELSEIF _cItemdev == "0689"
			_cItem := "PN"
		ELSEIF _cItemdev == "0690"
			_cItem := "PO"
		ELSEIF _cItemdev == "0691"
			_cItem := "PP"
		ELSEIF _cItemdev == "0692"
			_cItem := "PQ"
		ELSEIF _cItemdev == "0693"
			_cItem := "PR"
		ELSEIF _cItemdev == "0694"
			_cItem := "PS"
		ELSEIF _cItemdev == "0695"
			_cItem := "PT"
		ELSEIF _cItemdev == "0696"
			_cItem := "PU"
		ELSEIF _cItemdev == "0697"
			_cItem := "PV"
		ELSEIF _cItemdev == "0698"
			_cItem := "PW"
		ELSEIF _cItemdev == "0699"
			_cItem := "PX"
		ELSEIF _cItemdev == "0700"
			_cItem := "PY"
		ELSEIF _cItemdev == "0701"
			_cItem := "PZ"
		ELSEIF _cItemdev == "0702"
			_cItem := "Q0"
		ELSEIF _cItemdev == "0703"
			_cItem := "Q1"
		ELSEIF _cItemdev == "0704"
			_cItem := "Q2"
		ELSEIF _cItemdev == "0705"
			_cItem := "Q3"
		ELSEIF _cItemdev == "0706"
			_cItem := "Q4"
		ELSEIF _cItemdev == "0707"
			_cItem := "Q5"
		ELSEIF _cItemdev == "0708"
			_cItem := "Q6"
		ELSEIF _cItemdev == "0709"
			_cItem := "Q7"
		ELSEIF _cItemdev == "0710"
			_cItem := "Q8"
		ELSEIF _cItemdev == "0711"
			_cItem := "Q9"
		ELSEIF _cItemdev == "0712"
			_cItem := "QA"
		ELSEIF _cItemdev == "0713"
			_cItem := "QB"
		ELSEIF _cItemdev == "0714"
			_cItem := "QC"
		ELSEIF _cItemdev == "0715"
			_cItem := "QD"
		ELSEIF _cItemdev == "0716"
			_cItem := "QE"
		ELSEIF _cItemdev == "0717"
			_cItem := "QF"
		ELSEIF _cItemdev == "0718"
			_cItem := "QG"
		ELSEIF _cItemdev == "0719"
			_cItem := "QH"
		ELSEIF _cItemdev == "0720"
			_cItem := "QI"
		ELSEIF _cItemdev == "0721"
			_cItem := "QJ"
		ELSEIF _cItemdev == "0722"
			_cItem := "QK"
		ELSEIF _cItemdev == "0723"
			_cItem := "QL"
		ELSEIF _cItemdev == "0724"
			_cItem := "QM"
		ELSEIF _cItemdev == "0725"
			_cItem := "QN"
		ELSEIF _cItemdev == "0726"
			_cItem := "QO"
		ELSEIF _cItemdev == "0727"
			_cItem := "QP"
		ELSEIF _cItemdev == "0728"
			_cItem := "QQ"
		ELSEIF _cItemdev == "0729"
			_cItem := "QR"
		ELSEIF _cItemdev == "0730"
			_cItem := "QS"
		ELSEIF _cItemdev == "0731"
			_cItem := "QT"
		ELSEIF _cItemdev == "0732"
			_cItem := "QU"
		ELSEIF _cItemdev == "0733"
			_cItem := "QV"
		ELSEIF _cItemdev == "0734"
			_cItem := "QW"
		ELSEIF _cItemdev == "0735"
			_cItem := "QX"
		ELSEIF _cItemdev == "0736"
			_cItem := "QY"
		ELSEIF _cItemdev == "0737"
			_cItem := "QZ"
		ELSEIF _cItemdev == "0738"
			_cItem := "R0"
		ELSEIF _cItemdev == "0739"
			_cItem := "R1"
		ELSEIF _cItemdev == "0740"
			_cItem := "R2"
		ELSEIF _cItemdev == "0741"
			_cItem := "R3"
		ELSEIF _cItemdev == "0742"
			_cItem := "R4"
		ELSEIF _cItemdev == "0743"
			_cItem := "R5"
		ELSEIF _cItemdev == "0744"
			_cItem := "R6"
		ELSEIF _cItemdev == "0745"
			_cItem := "R7"
		ELSEIF _cItemdev == "0746"
			_cItem := "R8"
		ELSEIF _cItemdev == "0747"
			_cItem := "R9"
		ELSEIF _cItemdev == "0748"
			_cItem := "RA"
		ELSEIF _cItemdev == "0749"
			_cItem := "RB"
		ELSEIF _cItemdev == "0750"
			_cItem := "RC"
		ELSEIF _cItemdev == "0751"
			_cItem := "RD"
		ELSEIF _cItemdev == "0752"
			_cItem := "RE"
		ELSEIF _cItemdev == "0753"
			_cItem := "RF"
		ELSEIF _cItemdev == "0754"
			_cItem := "RG"
		ELSEIF _cItemdev == "0755"
			_cItem := "RH"
		ELSEIF _cItemdev == "0756"
			_cItem := "RI"
		ELSEIF _cItemdev == "0757"
			_cItem := "RJ"
		ELSEIF _cItemdev == "0758"
			_cItem := "RK"
		ELSEIF _cItemdev == "0759"
			_cItem := "RL"
		ELSEIF _cItemdev == "0760"
			_cItem := "RM"
		ELSEIF _cItemdev == "0761"
			_cItem := "RN"
		ELSEIF _cItemdev == "0762"
			_cItem := "RO"
		ELSEIF _cItemdev == "0763"
			_cItem := "RP"
		ELSEIF _cItemdev == "0764"
			_cItem := "RQ"
		ELSEIF _cItemdev == "0765"
			_cItem := "RR"
		ELSEIF _cItemdev == "0766"
			_cItem := "RS"
		ELSEIF _cItemdev == "0767"
			_cItem := "RT"
		ELSEIF _cItemdev == "0768"
			_cItem := "RU"
		ELSEIF _cItemdev == "0769"
			_cItem := "RV"
		ELSEIF _cItemdev == "0770"
			_cItem := "RW"
		ELSEIF _cItemdev == "0771"
			_cItem := "RX"
		ELSEIF _cItemdev == "0772"
			_cItem := "RY"
		ELSEIF _cItemdev == "0773"
			_cItem := "RZ"
		ELSEIF _cItemdev == "0774"
			_cItem := "S0"
		ELSEIF _cItemdev == "0775"
			_cItem := "S1"
		ELSEIF _cItemdev == "0776"
			_cItem := "S2"
		ELSEIF _cItemdev == "0777"
			_cItem := "S3"
		ELSEIF _cItemdev == "0778"
			_cItem := "S4"
		ELSEIF _cItemdev == "0779"
			_cItem := "S5"
		ELSEIF _cItemdev == "0780"
			_cItem := "S6"
		ELSEIF _cItemdev == "0781"
			_cItem := "S7"
		ELSEIF _cItemdev == "0782"
			_cItem := "S8"
		ELSEIF _cItemdev == "0783"
			_cItem := "S9"
		ELSEIF _cItemdev == "0784"
			_cItem := "SA"
		ELSEIF _cItemdev == "0785"
			_cItem := "SB"
		ELSEIF _cItemdev == "0786"
			_cItem := "SC"
		ELSEIF _cItemdev == "0787"
			_cItem := "SD"
		ELSEIF _cItemdev == "0788"
			_cItem := "SE"
		ELSEIF _cItemdev == "0789"
			_cItem := "SF"
		ELSEIF _cItemdev == "0790"
			_cItem := "SG"
		ELSEIF _cItemdev == "0791"
			_cItem := "SH"
		ELSEIF _cItemdev == "0792"
			_cItem := "SI"
		ELSEIF _cItemdev == "0793"
			_cItem := "SJ"
		ELSEIF _cItemdev == "0794"
			_cItem := "SK"
		ELSEIF _cItemdev == "0795"
			_cItem := "SL"
		ELSEIF _cItemdev == "0796"
			_cItem := "SM"
		ELSEIF _cItemdev == "0797"
			_cItem := "SN"
		ELSEIF _cItemdev == "0798"
			_cItem := "SO"
		ELSEIF _cItemdev == "0799"
			_cItem := "SP"
		ELSEIF _cItemdev == "0800"
			_cItem := "SQ"
		ELSEIF _cItemdev == "0801"
			_cItem := "SR"
		ELSEIF _cItemdev == "0802"
			_cItem := "SS"
		ELSEIF _cItemdev == "0803"
			_cItem := "ST"
		ELSEIF _cItemdev == "0804"
			_cItem := "SU"
		ELSEIF _cItemdev == "0805"
			_cItem := "SV"
		ELSEIF _cItemdev == "0806"
			_cItem := "SW"
		ELSEIF _cItemdev == "0807"
			_cItem := "SX"
		ELSEIF _cItemdev == "0808"
			_cItem := "SY"
		ELSEIF _cItemdev == "0809"
			_cItem := "SZ"
		ELSEIF _cItemdev == "0810"
			_cItem := "T0"
		ELSEIF _cItemdev == "0811"
			_cItem := "T1"
		ELSEIF _cItemdev == "0812"
			_cItem := "T2"
		ELSEIF _cItemdev == "0813"
			_cItem := "T3"
		ELSEIF _cItemdev == "0814"
			_cItem := "T4"
		ELSEIF _cItemdev == "0815"
			_cItem := "T5"
		ELSEIF _cItemdev == "0816"
			_cItem := "T6"
		ELSEIF _cItemdev == "0817"
			_cItem := "T7"
		ELSEIF _cItemdev == "0818"
			_cItem := "T8"
		ELSEIF _cItemdev == "0819"
			_cItem := "T9"
		ELSEIF _cItemdev == "0820"
			_cItem := "TA"
		ELSEIF _cItemdev == "0821"
			_cItem := "TB"
		ELSEIF _cItemdev == "0822"
			_cItem := "TC"
		ELSEIF _cItemdev == "0823"
			_cItem := "TD"
		ELSEIF _cItemdev == "0824"
			_cItem := "TE"
		ELSEIF _cItemdev == "0825"
			_cItem := "TF"
		ELSEIF _cItemdev == "0826"
			_cItem := "TG"
		ELSEIF _cItemdev == "0827"
			_cItem := "TH"
		ELSEIF _cItemdev == "0828"
			_cItem := "TI"
		ELSEIF _cItemdev == "0829"
			_cItem := "TJ"
		ELSEIF _cItemdev == "0830"
			_cItem := "TK"
		ELSEIF _cItemdev == "0831"
			_cItem := "TL"
		ELSEIF _cItemdev == "0832"
			_cItem := "TM"
		ELSEIF _cItemdev == "0833"
			_cItem := "TN"
		ELSEIF _cItemdev == "0834"
			_cItem := "TO"
		ELSEIF _cItemdev == "0835"
			_cItem := "TP"
		ELSEIF _cItemdev == "0836"
			_cItem := "TQ"
		ELSEIF _cItemdev == "0837"
			_cItem := "TR"
		ELSEIF _cItemdev == "0838"
			_cItem := "TS"
		ELSEIF _cItemdev == "0839"
			_cItem := "TT"
		ELSEIF _cItemdev == "0840"
			_cItem := "TU"
		ELSEIF _cItemdev == "0841"
			_cItem := "TV"
		ELSEIF _cItemdev == "0842"
			_cItem := "TW"
		ELSEIF _cItemdev == "0843"
			_cItem := "TX"
		ELSEIF _cItemdev == "0844"
			_cItem := "TY"
		ELSEIF _cItemdev == "0845"
			_cItem := "TZ"
		ELSEIF _cItemdev == "0846"
			_cItem := "U0"
		ELSEIF _cItemdev == "0847"
			_cItem := "U1"
		ELSEIF _cItemdev == "0848"
			_cItem := "U2"
		ELSEIF _cItemdev == "0849"
			_cItem := "U3"
		ELSEIF _cItemdev == "0850"
			_cItem := "U4"
		ELSEIF _cItemdev == "0851"
			_cItem := "U5"
		ELSEIF _cItemdev == "0852"
			_cItem := "U6"
		ELSEIF _cItemdev == "0853"
			_cItem := "U7"
		ELSEIF _cItemdev == "0854"
			_cItem := "U8"
		ELSEIF _cItemdev == "0855"
			_cItem := "U9"
		ELSEIF _cItemdev == "0856"
			_cItem := "UA"
		ELSEIF _cItemdev == "0857"
			_cItem := "UB"
		ELSEIF _cItemdev == "0858"
			_cItem := "UC"
		ELSEIF _cItemdev == "0859"
			_cItem := "UD"
		ELSEIF _cItemdev == "0860"
			_cItem := "UE"
		ELSEIF _cItemdev == "0861"
			_cItem := "UF"
		ELSEIF _cItemdev == "0862"
			_cItem := "UG"
		ELSEIF _cItemdev == "0863"
			_cItem := "UH"
		ELSEIF _cItemdev == "0864"
			_cItem := "UI"
		ELSEIF _cItemdev == "0865"
			_cItem := "UJ"
		ELSEIF _cItemdev == "0866"
			_cItem := "UK"
		ELSEIF _cItemdev == "0867"
			_cItem := "UL"
		ELSEIF _cItemdev == "0868"
			_cItem := "UM"
		ELSEIF _cItemdev == "0869"
			_cItem := "UN"
		ELSEIF _cItemdev == "0870"
			_cItem := "UO"
		ELSEIF _cItemdev == "0871"
			_cItem := "UP"
		ELSEIF _cItemdev == "0872"
			_cItem := "UQ"
		ELSEIF _cItemdev == "0873"
			_cItem := "UR"
		ELSEIF _cItemdev == "0874"
			_cItem := "US"
		ELSEIF _cItemdev == "0875"
			_cItem := "UT"
		ELSEIF _cItemdev == "0876"
			_cItem := "UU"
		ELSEIF _cItemdev == "0877"
			_cItem := "UV"
		ELSEIF _cItemdev == "0878"
			_cItem := "UW"
		ELSEIF _cItemdev == "0879"
			_cItem := "UX"
		ELSEIF _cItemdev == "0880"
			_cItem := "UY"
		ELSEIF _cItemdev == "0881"
			_cItem := "UZ"
		ELSEIF _cItemdev == "0882"
			_cItem := "V0"
		ELSEIF _cItemdev == "0883"
			_cItem := "V1"
		ELSEIF _cItemdev == "0884"
			_cItem := "V2"
		ELSEIF _cItemdev == "0885"
			_cItem := "V3"
		ELSEIF _cItemdev == "0886"
			_cItem := "V4"
		ELSEIF _cItemdev == "0887"
			_cItem := "V5"
		ELSEIF _cItemdev == "0888"
			_cItem := "V6"
		ELSEIF _cItemdev == "0889"
			_cItem := "V7"
		ELSEIF _cItemdev == "0890"
			_cItem := "V8"
		ELSEIF _cItemdev == "0891"
			_cItem := "V9"
		ELSEIF _cItemdev == "0892"
			_cItem := "VA"
		ELSEIF _cItemdev == "0893"
			_cItem := "VB"
		ELSEIF _cItemdev == "0894"
			_cItem := "VC"
		ELSEIF _cItemdev == "0895"
			_cItem := "VD"
		ELSEIF _cItemdev == "0896"
			_cItem := "VE"
		ELSEIF _cItemdev == "0897"
			_cItem := "VF"
		ELSEIF _cItemdev == "0898"
			_cItem := "VG"
		ELSEIF _cItemdev == "0899"
			_cItem := "VH"
		ELSEIF _cItemdev == "0900"
			_cItem := "VI"
		ELSEIF _cItemdev == "0901"
			_cItem := "VJ"
		ELSEIF _cItemdev == "0902"
			_cItem := "VK"
		ELSEIF _cItemdev == "0903"
			_cItem := "VL"
		ELSEIF _cItemdev == "0904"
			_cItem := "VM"
		ELSEIF _cItemdev == "0905"
			_cItem := "VN"
		ELSEIF _cItemdev == "0906"
			_cItem := "VO"
		ELSEIF _cItemdev == "0907"
			_cItem := "VP"
		ELSEIF _cItemdev == "0908"
			_cItem := "VQ"
		ELSEIF _cItemdev == "0909"
			_cItem := "VR"
		ELSEIF _cItemdev == "0910"
			_cItem := "VS"
		ELSEIF _cItemdev == "0911"
			_cItem := "VT"
		ELSEIF _cItemdev == "0912"
			_cItem := "VU"
		ELSEIF _cItemdev == "0913"
			_cItem := "VV"
		ELSEIF _cItemdev == "0914"
			_cItem := "VW"
		ELSEIF _cItemdev == "0915"
			_cItem := "VX"
		ELSEIF _cItemdev == "0916"
			_cItem := "VY"
		ELSEIF _cItemdev == "0917"
			_cItem := "VZ"
		ELSEIF _cItemdev == "0918"
			_cItem := "W0"
		ELSEIF _cItemdev == "0919"
			_cItem := "W1"
		ELSEIF _cItemdev == "0920"
			_cItem := "W2"
		ELSEIF _cItemdev == "0921"
			_cItem := "W3"
		ELSEIF _cItemdev == "0922"
			_cItem := "W4"
		ELSEIF _cItemdev == "0923"
			_cItem := "W5"
		ELSEIF _cItemdev == "0924"
			_cItem := "W6"
		ELSEIF _cItemdev == "0925"
			_cItem := "W7"
		ELSEIF _cItemdev == "0926"
			_cItem := "W8"
		ELSEIF _cItemdev == "0927"
			_cItem := "W9"
		ELSEIF _cItemdev == "0928"
			_cItem := "WA"
		ELSEIF _cItemdev == "0929"
			_cItem := "WB"
		ELSEIF _cItemdev == "0930"
			_cItem := "WC"
		ELSEIF _cItemdev == "0931"
			_cItem := "WD"
		ELSEIF _cItemdev == "0932"
			_cItem := "WE"
		ELSEIF _cItemdev == "0933"
			_cItem := "WF"
		ELSEIF _cItemdev == "0934"
			_cItem := "WG"
		ELSEIF _cItemdev == "0935"
			_cItem := "WH"
		ELSEIF _cItemdev == "0936"
			_cItem := "WI"
		ELSEIF _cItemdev == "0937"
			_cItem := "WJ"
		ELSEIF _cItemdev == "0938"
			_cItem := "WK"
		ELSEIF _cItemdev == "0939"
			_cItem := "WL"
		ELSEIF _cItemdev == "0940"
			_cItem := "WM"
		ELSEIF _cItemdev == "0941"
			_cItem := "WN"
		ELSEIF _cItemdev == "0942"
			_cItem := "WO"
		ELSEIF _cItemdev == "0943"
			_cItem := "WP"
		ELSEIF _cItemdev == "0944"
			_cItem := "WQ"
		ELSEIF _cItemdev == "0945"
			_cItem := "WR"
		ELSEIF _cItemdev == "0946"
			_cItem := "WS"
		ELSEIF _cItemdev == "0947"
			_cItem := "WT"
		ELSEIF _cItemdev == "0948"
			_cItem := "WU"
		ELSEIF _cItemdev == "0949"
			_cItem := "WV"
		ELSEIF _cItemdev == "0950"
			_cItem := "WW"
		ELSEIF _cItemdev == "0951"
			_cItem := "WX"
		ELSEIF _cItemdev == "0952"
			_cItem := "WY"
		ELSEIF _cItemdev == "0953"
			_cItem := "WZ"
		ELSEIF _cItemdev == "0954"
			_cItem := "X0"
		ELSEIF _cItemdev == "0955"
			_cItem := "X1"
		ELSEIF _cItemdev == "0956"
			_cItem := "X2"
		ELSEIF _cItemdev == "0957"
			_cItem := "X3"
		ELSEIF _cItemdev == "0958"
			_cItem := "X4"
		ELSEIF _cItemdev == "0959"
			_cItem := "X5"
		ELSEIF _cItemdev == "0960"
			_cItem := "X6"
		ELSEIF _cItemdev == "0961"
			_cItem := "X7"
		ELSEIF _cItemdev == "0962"
			_cItem := "X8"
		ELSEIF _cItemdev == "0963"
			_cItem := "X9"
		ELSEIF _cItemdev == "0964"
			_cItem := "XA"
		ELSEIF _cItemdev == "0965"
			_cItem := "XB"
		ELSEIF _cItemdev == "0966"
			_cItem := "XC"
		ELSEIF _cItemdev == "0967"
			_cItem := "XD"
		ELSEIF _cItemdev == "0968"
			_cItem := "XE"
		ELSEIF _cItemdev == "0969"
			_cItem := "XF"
		ELSEIF _cItemdev == "0970"
			_cItem := "XG"
		ELSEIF _cItemdev == "0971"
			_cItem := "XH"
		ELSEIF _cItemdev == "0972"
			_cItem := "XI"
		ELSEIF _cItemdev == "0973"
			_cItem := "XJ"
		ELSEIF _cItemdev == "0974"
			_cItem := "XK"
		ELSEIF _cItemdev == "0975"
			_cItem := "XL"
		ELSEIF _cItemdev == "0976"
			_cItem := "XM"
		ELSEIF _cItemdev == "0977"
			_cItem := "XN"
		ELSEIF _cItemdev == "0978"
			_cItem := "XO"
		ELSEIF _cItemdev == "0979"
			_cItem := "XP"
		ELSEIF _cItemdev == "0980"
			_cItem := "XQ"
		ELSEIF _cItemdev == "0981"
			_cItem := "XR"
		ELSEIF _cItemdev == "0982"
			_cItem := "XS"
		ELSEIF _cItemdev == "0983"
			_cItem := "XT"
		ELSEIF _cItemdev == "0984"
			_cItem := "XU"
		ELSEIF _cItemdev == "0985"
			_cItem := "XV"
		ELSEIF _cItemdev == "0986"
			_cItem := "XW"
		ELSEIF _cItemdev == "0987"
			_cItem := "XX"
		ELSEIF _cItemdev == "0988"
			_cItem := "XY"
		ELSEIF _cItemdev == "0989"
			_cItem := "XZ"
		ELSEIF _cItemdev == "0990"
			_cItem := "Y0"
		ELSEIF _cItemdev == "0991"
			_cItem := "Y1"
		ELSEIF _cItemdev == "0992"
			_cItem := "Y2"
		ELSEIF _cItemdev == "0993"
			_cItem := "Y3"
		ELSEIF _cItemdev == "0994"
			_cItem := "Y4"
		ELSEIF _cItemdev == "0995"
			_cItem := "Y5"
		ELSEIF _cItemdev == "0996"
			_cItem := "Y6"
		ELSEIF _cItemdev == "0997"
			_cItem := "Y7
		ELSEIF _cItemdev == "0998"
			_cItem := "Y8
		ELSEIF _cItemdev == "0999"
			_cItem := "Y9"
		ELSEIF _cItemdev == "1000"
			_cItem := "YA"
		ELSEIF _cItemdev == "1001"
			_cItem := "YB"
		ELSEIF _cItemdev == "1002"
			_cItem := "YC"
		ELSEIF _cItemdev == "1003"
			_cItem := "YD"
		ELSEIF _cItemdev == "1004"
			_cItem := "YE"
		ELSEIF _cItemdev == "1005"
			_cItem := "YF"
		ELSEIF _cItemdev == "1006"
			_cItem := "YG"
		ELSEIF _cItemdev == "1007"
			_cItem := "YH"
		ELSEIF _cItemdev == "1008"
			_cItem := "YI"
		ELSEIF _cItemdev == "1009"
			_cItem := "YJ"
		ELSEIF _cItemdev == "1010"
			_cItem := "YK"
		ELSEIF _cItemdev == "1011"
			_cItem := "YL"
		ELSEIF _cItemdev == "1012"
			_cItem := "YM"
		ELSEIF _cItemdev == "1013"
			_cItem := "YN"
		ELSEIF _cItemdev == "1014"
			_cItem := "YO"
		ELSEIF _cItemdev == "1015"
			_cItem := "YP"
		ELSEIF _cItemdev == "1016"
			_cItem := "YQ"
		ELSEIF _cItemdev == "1017"
			_cItem := "YR"
		ELSEIF _cItemdev == "1018"
			_cItem := "YS"
		ELSEIF _cItemdev == "1019"
			_cItem := "YT"
		ELSEIF _cItemdev == "1020"
			_cItem := "YU"
		ELSEIF _cItemdev == "1021"
			_cItem := "YV"
		ELSEIF _cItemdev == "1022"
			_cItem := "YW"
		ELSEIF _cItemdev == "1023"
			_cItem := "YX"
		ELSEIF _cItemdev == "1024"
			_cItem := "YY"
		ELSEIF _cItemdev == "1025"
			_cItem := "YZ"
		ELSEIF _cItemdev == "1026"
			_cItem := "Z0"
		ELSEIF _cItemdev == "1027"
			_cItem := "Z1"
		ELSEIF _cItemdev == "1028"
			_cItem := "Z2"
		ELSEIF _cItemdev == "1029"
			_cItem := "Z3"
		ELSEIF _cItemdev == "1030"
			_cItem := "Z4"
		ELSEIF _cItemdev == "1031"
			_cItem := "Z5"
		ELSEIF _cItemdev == "1032"
			_cItem := "Z6"
		ELSEIF _cItemdev == "1033"
			_cItem := "Z7"
		ELSEIF _cItemdev == "1034"
			_cItem := "Z8"
		ELSEIF _cItemdev == "1035"
			_cItem := "Z9"
		ELSEIF _cItemdev == "1036"
			_cItem := "ZA"
		ELSEIF _cItemdev == "1037"
			_cItem := "ZB"
		ELSEIF _cItemdev == "1038"
			_cItem := "ZC"
		ELSEIF _cItemdev == "1039"
			_cItem := "ZD"
		ELSEIF _cItemdev == "1040"
			_cItem := "ZE"
		ELSEIF _cItemdev == "1041"
			_cItem := "ZF"
		ELSEIF _cItemdev == "1042"
			_cItem := "ZG"
		ELSEIF _cItemdev == "1043"
			_cItem := "ZH"
		ELSEIF _cItemdev == "1044"
			_cItem := "ZI"
		ELSEIF _cItemdev == "1045"
			_cItem := "ZJ"
		ELSEIF _cItemdev == "1046"
			_cItem := "ZK"
		ELSEIF _cItemdev == "1047"
			_cItem := "ZL"
		ELSEIF _cItemdev == "1048"
			_cItem := "ZM"
		ELSEIF _cItemdev == "1049"
			_cItem := "ZN"
		ELSEIF _cItemdev == "1050"
			_cItem := "ZO"
		ELSEIF _cItemdev == "1051"
			_cItem := "ZP"
		ELSEIF _cItemdev == "1052"
			_cItem := "ZQ"
		ELSEIF _cItemdev == "1053"
			_cItem := "ZR"
		ELSEIF _cItemdev == "1054"
			_cItem := "ZS"
		ELSEIF _cItemdev == "1055"
			_cItem := "ZT"
		ELSEIF _cItemdev == "1056"
			_cItem := "ZU"
		ELSEIF _cItemdev == "1057"
			_cItem := "ZV"
		ELSEIF _cItemdev == "1058"
			_cItem := "ZW"
		ELSEIF _cItemdev == "1059"
			_cItem := "ZX"
		ELSEIF _cItemdev == "1060"
			_cItem := "ZY"
		ELSEIF _cItemdev == "1061"
			_cItem := "ZZ"
        ELSE
			_cItem := ""
		ENDIF
		//		Do While (cAliasNew)->(!Eof())
		//			ApMsgInfo("TESTE")
		//			_cDocOri 	:= (cAliasNew)->Z1_DOCORI
		//			_cSerOri 	:= (cAliasNew)->Z1_SERIEOR
		//			_cItOri 	:= (cAliasNew)->Z1_ITEMORI
		//			_cEvent		:= (cAliasNew)->Z1_EVENTO
		//			_cDoc		:= (cAliasNew)->Z1_DOC
		//			_cSer		:= (cAliasNew)->Z1_SERIE
		//			_cItem		:= (cAliasNew)->Z1_ITEME
		//			_nFat		:= (cAliasNew)->AFAT
		//			(cAliasNew)->(DbSkip())
		//		EndDo
	EndIf
	(cAliasNew)->(DbCloseArea())
	If Empty(_cDocOri)
		_cDocOri 	:= ""
		_cSerOri 	:= ""
		_cItOri 	:= ""
		_cEvent		:= ""
		_cDoc			:= ""
		_cSer			:= ""
//		_cItem		:= "" // SONIA - 03/06/15
		_CITEMDEV   := "" // SONIA - 04/05/12
		_nFat			:= 0
		_lGeraPV 	:= .F.
		If Empty(_cNaoTem)
			_cNaoTem := "Não achou o retorno dos produtos : "  + AllTrim(_aItem[n,1])
		Else
			_cNaoTem += ", " + AllTrim(_aItem[n,1])
		EndIf
	EndIf

	If _aCab[3] == 	_cEvent

		///
		_aLinha := {}
		/////-------------------------------------------------------------------------------------
		//		aadd(_aLinha,{"C6_NUM"  	 	, _cNextPV			  					,Nil}) // Numero do Item no Pedido
		aadd(_aLinha,{"C6_ITEM"  	 	, _cItem			  					,Nil}) // Numero do Item no Pedido
		aadd(_aLinha,{"C6_PRODUTO"	, _aItem[n,1]	  						,Nil}) // Codigo do Produto
		//		aadd(_aLinha,{"C6_QTDVEN" 	, _aItem[n,2]						,Nil}) // Quantidade Vendida
		aadd(_aLinha,{"C6_QTDVEN"  	, _nFat			  						,Nil}) // Evento
		/// Tabela de Preço
/* 
IF !EMPTY(_acab[5])
DbSelectArea("DA1") //Tabela de preco padrao Microsiga
DbSetOrder(2)
	IF DbSeek(xFilial("DA1") + _aItem[n,1] + _aCab[5],.T.)
		aadd(_aLinha,{"C6_PRCVEN" 	, DA1->DA1_PRCVEN						,Nil})
   		aadd(_aLinha,{"C6_PRUNIT" 	, DA1->DA1_PRCVEN    				    ,Nil})
	ENDIF
ENDIF
*/
		//		aadd(_aLinha,{"C6_PRCVEN" 	, _aItem[n,3]							,Nil}) // Preco Unitario Liquido
		//		aadd(_aLinha,{"C6_VALOR"  		, _aItem[n,2]*_aItem[n,3]		,Nil}) // Valor Total do Item
		aadd(_aLinha,{"C6_OPER" 		, _cOper				  				,Nil}) // Tipo de Operacao
		//		aadd(_aLinha,{"C6_TES"    	, _cTES       							,Nil}) // Tipo de Entrada/Saida do Item
		//		aadd(_aLinha,{"C6_PRUNIT" 	, _aItem[n,2]    				   ,Nil}) // PRECO DE LISTA
		//		aadd(_aLinha,{"C6_QTDLIB" 	, _aItem[n,2]						,Nil}) // Quantidade Liberada
		aadd(_aLinha,{"C6_XNFORCO"  	, _cDocOri   			  				,Nil}) // Num Nota Fiscal Original
		aadd(_aLinha,{"C6_XSERCON"  	, _cSerOri  			  				,Nil}) // Serie Nota Fiscal Original
		aadd(_aLinha,{"C6_XITCON"  	, _cItOri   			  				,Nil}) // Item Nota Fiscal Original
		aadd(_aLinha,{"C6_XEVENTO"  	, _cEvent  			  					,Nil}) // Num Nota Fiscal Original
		aadd(_aLinha,{"C6_XDOCDEV"  	, _cDoc   			  					,Nil}) // Serie Nota Fiscal Original
		aadd(_aLinha,{"C6_XSERDEV"  	, _cSer  			  					,Nil}) // Item Nota Fiscal Original
		//		aadd(_aLinha,{"C6_XITDEV"  	, _cItem    			  				,Nil}) // Saldo do SZ1
		aadd(_aLinha,{"C6_XITDEV"  	, _cItemdev   			  				,Nil}) // Saldo do SZ1 - sonia - 04/05/12
		aadd(_aLinha,{"C6_LOCAL"  		, _cAlmox    			  				,Nil}) // Almoxarifado
		/////-------------------------------------------------------------------------------------
		AAdd(_aItemPV,_aLinha)

		If n == 99
			_cItem := "A0"
		Else
			_cItem := SOMA1(_cItem)
		EndIf

	EndIf

Next


If _lGeraPV
	MsAguarde({|lEnd| MEXECAUTO(_aCabPv,_aItemPV,nOpc) },"Aguarde","Gerando pedido. . .",.T.,.F.)
Else
	ApMsgStop(_cNaoTem)
EndIf

RestArea(aAreaPV)

Return(_cRtNum)


/////////////////////////////////////////////////////////////////////////////////////
Static Function MEXECAUTO(_aCabPv,_aItemPV,nOpc)
/////////////////////////////////////////////////////////////////////////////////////
private lOnUpdate := .T.
dbSelectArea("SC5")
MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCabPv,_aItemPV,nOpc)

If lMsErroAuto
	MostraErro()
	DisarmTransaction()
Else
	_cRtNum := SC5->C5_NUM
	ApMsgInfo("Gerado o pedido de venda " + SC5->C5_NUM + " para faturamento da consignação.")
EndIf

Return(.T.)


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
local k := 0
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


/////////////////////////////////////////////////////////////////////////////////////
Static Function MONT_VET(_cPar01,oLbx,oDlgCons,_aVar)
/////////////////////////////////////////////////////////////////////////////////////
Local _aAreaAnt := GETAREA()
local f := 0
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

	_cQuery := " Select Z1_DOC, Z1_SERIE, Z1_EMISSAO, Z1_EVENTO, COUNT(*) "+CHR(13)+CHR(10)
	_cQuery += " From " + RETSQLNAME("SZ1")	+ " "+CHR(13)+CHR(10)
	_cQuery += " WHERE Z1_FILIAL  = '"+xFilial("SZ1")+"' "+CHR(13)+CHR(10)
	_cQuery += " AND D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10) // SK - 03/06/15
	_cQuery += " AND Z1_CLIENTE = '"+_aVar[1] + "' AND Z1_LOJA = '"+_aVar[2]+"' "+CHR(13)+CHR(10)

	//Allan Bonfim - 05/05/2016
//	_cQuery += " AND Z1_PEDIDO  = ' ' "+CHR(13)+CHR(10)
	_cQuery += " AND (Z1_PEDIDO  = ' ' "+CHR(13)+CHR(10)
	_cQuery += " 	OR EXISTS(SELECT C6_NUM, C6_PRODUTO, C6_NOTA, C6_SERIE, C6_ITEM, C6_XNFORCO, C6_XSERCON, C6_XITCON, D1_DOC, D1_SERIE, D1_ITEM "+CHR(13)+CHR(10)
	_cQuery += " 		FROM "+RetSqlName("SC6") + " SC6 "+CHR(13)+CHR(10)
	_cQuery += " 		INNER JOIN "+RetSqlName("SD1") + " SD1 "+CHR(13)+CHR(10)
	_cQuery += " 		ON (C6_NOTA = D1_NFORI AND C6_SERIE = D1_SERIORI AND C6_ITEM = D1_ITEMORI AND SD1.D_E_L_E_T_ = '') "+CHR(13)+CHR(10)
	_cQuery += " 		WHERE C6_NUM = Z1_PEDIDO "+CHR(13)+CHR(10)
	_cQuery += " 		AND SC6.D_E_L_E_T_ = '' "+CHR(13)+CHR(10)
	_cQuery += " 		AND D1_XOPER = 'CS' "+CHR(13)+CHR(10)
	_cQuery += " 		) "+CHR(13)+CHR(10)
	_cQuery += "	) "+CHR(13)+CHR(10)

	//	_cQuery += " AND Z1_EVENTO = '"+ _aVar[3] + "' "
	//	_cQuery += " AND Z1_TIPO = 'S' AND D_E_L_E_T_ <> '*' " // SK - 03/06/15
    IF EMPTY(W_NFUNICO)
	   _cQuery += " AND Z1_TIPO = 'S' "+CHR(13)+CHR(10) // SK - 03/06/15
	   ELSE
	   _cQuery += " AND Z1_DOC LIKE ('%" + ALLTRIM(W_NFUNICO) + "%')"+CHR(13)+CHR(10) // SK - 03/06/15
    ENDIF
	_cQuery += " GROUP BY Z1_DOC, Z1_SERIE, Z1_EMISSAO, Z1_EVENTO "+CHR(13)+CHR(10)
	_cQuery += " ORDER BY Z1_DOC, Z1_SERIE, Z1_EMISSAO, Z1_EVENTO "+CHR(13)+CHR(10)

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


/////////////////////////////////////////////////////////////////////////////////////
Static Function POS(_xPar)
/////////////////////////////////////////////////////////////////////////////////////
Local _nPos := 0
local f := 0
For f:=1 to Len(_aCpoCons)
	If _aCpoCons[f,1] == _xPar
		_nPos := f
	EndIf
Next
Return(_nPos)


/////////////////////////////////////////////////////////////////////////////////////
Static Function RetVt(_nLin)
/////////////////////////////////////////////////////////////////////////////////////

Local _aVt := {}
local f := 0
For f:=1 to Len(_aCpoCons)
	If _aCpoCons[f,5]
		AADD(_aVt,_aVetCons[_nLin,f])
	EndIf
Next
Return(_aVt)


/////////////////////////////////////////////////////////////////////////////////////
Static Function ConvDad(_xPar1,_xPar2)
/////////////////////////////////////////////////////////////////////////////////////
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
local _nIt := 0
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


///------------------------------------------------------------------------------------------------
/// FUNÇÃO QUE AJUSTA OS SALDO A CLASSIFICAR.
///------------------------------------------------------------------------------------------------
Static Function SB2_01(cCodAtu)
Local cLogINI := ""
Local cLogFim := ""
Local nQtdClas := 0

dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial("SB2")+cCodAtu)
	Do While !Eof() .and. SB2->B2_FILIAL = xFilial("SB1") .and. SB2->B2_COD = cCodAtu
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SB2->B2_COD)
		If SB1->B1_LOCALIZ == "S"
			nQtdClas := 0
			dbSelectArea("SDA")
			dbSetOrder(1)
			If dbSeek(xFilial("SDA")+SB2->B2_COD+SB2->B2_LOCAL)
				Do While !Eof() .and. SDA->DA_FILIAL == xFilial("SDA") .and. SDA->DA_PRODUTO == SB2->B2_COD .AND. SDA->DA_LOCAL == SB2->B2_LOCAL
					nQtdClas += SDA->DA_SALDO
					dbSkip()
				EndDo
			EndIf
			If SB2->B2_QACLASS <> nQtdClas
				cLogIni += SB2->B2_COD + "|" + SB2->B2_LOCAL + "|" + Transform(nQtdClas,"@E 9999999999.99")  + "|" + Transform(SB2->B2_QACLASS,"@E 9999999999.99") + CHR(13)+CHR(10)
			EndIf
			dbSelectArea("SB2")
			RecLock("SB2",.F.)
			SB2->B2_QACLASS := nQtdClas
			MsUnlock()
			If SB2->B2_QACLASS <> nQtdClas
				cLogFim += SB2->B2_COD + "|" + SB2->B2_LOCAL + "|" + Transform(nQtdClas,"@E 9999999999.99")  + "|" + Transform(SB2->B2_QACLASS,"@E 9999999999.99") + CHR(13)+CHR(10)
			EndIf
		EndIf
		dbSelectArea("SB2")
		dbSkip()
	EndDo
EndIf

MEMOWRITE("D:\LOG_SB2_INI",cLogIni)
MEMOWRITE("D:\LOG_SB2_FIM",cLogfim)

Return


////////////////////////////
STATIC FUNCTION VLD_TPCONS()
////////////////////////////
X_RET := .T.

IF .NOT. W_TPCONSI $ "R/F" // SE NAO PERTENCER A REMESSA / FATURAMENTO
	ApMsgInfo("Tipo invalido - Digitar R(emessa) ou F(aturamento) !")
	X_RET := .F.
ENDIF

RETURN(X_RET)
