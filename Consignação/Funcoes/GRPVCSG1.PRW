#include "protheus.ch"   

//-------------------------------------------------------------------------------------------------
//Função para importação do pedido de venda.
//-------------------------------------------------------------------------------------------------
USER FUNCTION GRPVCSG1() 
//-------------------------------------------------------------------------------------------------
Local 	_aCli 		:= {Space(006),Space(002),Space(040)}
Local 	_cTexto 	:= ""
Local  	oDlg
Local 	oCli 			:= Array(3)
Local 	_cMaxItem	:= "500"
Local 	_lOk			:= .F.

/// Verifica se essa rotina já não está sendo utilizada por outro usuário!
If !MayIUseCode("GRPVCSG1")
	ApMsgInfo("Essa rotina já está sendo executada por outra estação. Por motivo de segurança, essa rotina só pode ser utilizada de forma exclusiva !")
	Return()
EndIf

///MONTA TELA DE ABERTURA:
DEFINE FONT oFont NAME "Mono AS" SIZE 9,15
Define MsDialog oDlg Title "Importação de Pedido de Venda referente a Remessa em Consignação - Anterior ao sistema Protheus:" From 116,090 To 630,850 Pixel
@ 005,005 to 100,342	PIXEL OF oDlg 
@ 008,007 Say OemToAnsi("Essa rotina tem como objetivo  efetuar a importação do Pedido de Venda de")		PIXEL OF oDlg FONT oFont
@ 018,007 Say OemToAnsi("remessa de consignação, a partir de uma planilha em EXCEL.") 							PIXEL OF oDlg FONT oFont
@ 028,007 Say OemToAnsi("Somente deve ser utilizada para importar pedidos já emitidos pelo sistema")		PIXEL OF oDlg FONT oFont
@ 038,007 Say OemToAnsi("anterior, de forma a atualizar os saldos da remessa em poder de terceiros.")	PIXEL OF oDlg FONT oFont
@ 048,007 Say OemToAnsi("Os pedidos gerados por esse processo  terão numeração  diferenciada e sua ")	PIXEL OF oDlg FONT oFont
@ 058,007 Say OemToAnsi('data de inclusão será "01/01/2011".')																	PIXEL OF oDlg FONT oFont
@ 068,007 Say OemToAnsi('A primeira linha da planilha representa o título das colunas, sendo que a')		PIXEL OF oDlg FONT oFont
@ 078,007 Say OemToAnsi('mesma deverá possuir obrigatoriamente os títulos : "ISBN", "VALOR CAPA" e')		PIXEL OF oDlg FONT oFont
@ 088,007 Say OemToAnsi('"PENDENTE".')																										PIXEL OF oDlg FONT oFont
//---------------------------------------------------------------------------
@ 105,005 Say OemToAnsi("Informe o cliente para o qual será feita a geração do pedido de remessa :" ) 	PIXEL OF oDlg FONT oFont
@ 115,005 MSGET oCli[1] VAR  _aCli[1]	SIZE 040,010 OF oDlg PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])  F3 "SA1" 	VALID VldCpo(oDlg,"CLI",oCli,_aCLI)
@ 115,050 MSGET oCli[2] VAR  _aCli[2]	SIZE 010,010 OF oDlg PIXEL FONT oFont  WHEN Empty(_aCli[1]) .or. Empty(_aCli[2])					VALID VldCpo(oDlg,"CLI",oCli,_aCLI)
@ 115,070 MSGET oCli[3] VAR  _aCli[3]	SIZE 200,010 OF oDlg PIXEL FONT oFont  WHEN .F.
//---------------------------------------------------------------------------
@ 135,005 Say OemToAnsi("Copie do Excel e cole abaixo os dados a serem importados:" ) 							PIXEL OF oDlg FONT oFont
@ 145,005 GET oMens VAR _cTexto MEMO SIZE 370,110 OF oDlg PIXEL
oMens:bRClicked := {||AllwaysTrue()}
oMens:oFont:=oFont
oSpdBtX := SButton():New(010,350, 1,{|| _lOk := VldOk(_aCli,_cTexto), IIF(_lOk,_lOk:=GeraArq(_cMaxItem,_aCli,_cTexto),.T.),IIF(_lOk,oDlg:End(),.T.)}, oDlg,.T.,,)
oSpdBtY := SButton():New(030,350, 2,{|| oDlg:End() }, oDlg,.T.,,)
Activate MsDialog oDlg Center
///
Return(.T.)




//-------------------------------------------------------------------------------------------------
/// Função que processa os dados da planilha e grava no SA1
//-------------------------------------------------------------------------------------------------
Static Function GeraArq(_cMaxItem,_aCli,_cTXT)
Local 	lEnd 			:= .F.
Local 	_aColuns	:= {}
Local 	_aCabDad 	:= {}
Local 	_cCab			:= ""
Local 	_aExcel		:= {}
Private _aVetImp 	:= {}


//-------------------------------------------------------------------------------------------------
// Obtem extrutura da tabela SX3
//-------------------------------------------------------------------------------------------------
_cAlias := "SC6"
dbSelectArea("SX3")
dbSetOrder(1)
If dbSeek(_cAlias)
	Do While !EOF() .And. SX3->X3_ARQUIVO == _cAlias
		Do Case
			Case 	AllTrim(SX3->X3_CAMPO) == "C6_PRODUTO"	
				AADD(_aColuns,{"ISBN"			,X3_TIPO, X3_TAMANHO, X3_DECIMAL })
			Case 	AllTrim(SX3->X3_CAMPO) == "C6_QTDVEN"	
				AADD(_aColuns,{"PENDENTE"		,X3_TIPO, X3_TAMANHO, X3_DECIMAL })
			Case 	AllTrim(SX3->X3_CAMPO) == "C6_PRCVEN" 	
				AADD(_aColuns,{"VALOR CAPA"	,X3_TIPO, X3_TAMANHO, X3_DECIMAL })
		Endcase
		dbSkip()
	EndDo
Else
	ApMsgInfo("Estrutura da tabela não encontrada !") 
	RETURN(.F.)
EndIf

/// Cria arquivo TXT (temporário) com os dados do Excel
_cArqDsc := "TMP_SC5.TXT"
Grv_Disco(_cArqDsc,_cTXT)

/// Cria arquivo temporário de trabalho e grava nele os dados do Excel.
Cria_TMP()
dbSelectArea("TMP")
APPEND FROM &_cArqDsc SDF

/// Executa a leitura do início ao fim do arquivo temporário, 
/// obtendo as colunas de dados necessárias
dbSelectArea("TMP")
dbGoTop()
_nLin := 1
Do While !Eof()
	
	xReg := TMP->T_TXT1
	If !Empty(AllTrim(xReg))
		If _nLin == 1
			For j:=1 to 1000	
				_cCab	  := UPPER(AllTrim(GetNextCPO(xReg,1)))
				If !Empty(_cCab)
					AADD(_aCabDad,_cCab)
				EndIf
			Next
		Else
			AADD(_aExcel,Array(Len(_aCabDad)))
			///VARIAVEIS PARA A IMPORTACAO DOS DADOS //////////////////////
			For j := 1 to Len(_aCabDad)
				_cCont  		:= AllTrim(GetNextCPO(xReg,1))
				_cNomeCpo	:= UPPER(_aCabDad[j])
				_xPosCpo	:= RetPosCpo(_aColuns,_cNomeCpo)
				If _xPosCPO > 0
					_cCont		:= CONVCONT(_aColuns,_xPosCpo,_cCont)
				Else
					_cCont		:= ""	
				EndIf	
				_aExcel[Len(_aExcel)][j] := _cCont
			NEXT	
		EndIf
		///	
	EndIf   
	_nLin += 1                    
	
 	dbSelectArea("TMP")
	dbSkip()
EndDo   

/// Apaga o arquivo temporário
dbSelectarea("TMP")
dbCloseArea()
Ferase(_cArqTMP+".DBF")
///

_lCont := .T.
If Len(_aColuns) > 0
	For k:=1 to Len(_aColuns)
		_xPosCpo 	:= Ascan(_aCabDad,_aColuns[k,1])
		If _xPosCpo <= 0
			_lCont := .F.		
		EndIf 	
	Next
	If !(_lCont)
		ApMsgInfo('O nome de alguma coluna não foi informado na primeira linha de dados !    A primeira linha deverá conter pelo menos as colunas "ISBN", "VALOR CAPA" e "PENDENTE" .')
		Return(.F.)
	EndIf
EndIf

If Len(_aExcel) > 0 .and. Len(_aCabDad)>0
	For k:=1 to Len(_aExcel)
		AADD(_aVetImp,Array(Len(_aColuns)))
		For l:=1 to Len(_aCabDad)
			_xPosCpo	:= RetPosCpo(_aColuns,_aCabDad[l])
			If _xPosCpo > 0
				_aVetImp[k,_xPosCpo]	:= _aExcel[k,l]
			EndIf
		Next
	Next
EndIf


If Len(_aVetImp) > Val(_cMaxItem)
	ApMsgInfo("Existe um limite de "+_cMaxItem+" itens por pedido de venda a ser gerado !")
	_aVetImp := {}
EndIf

If Len(_aVetImp) > 0
	MsAguarde({|lEnd| ImportExec(_aCli,_aVetImp)},"Aguarde","Aguarde: Gerando Pedido . . .",.T.)
EndIf		


Return(.T.)








//-------------------------------------------------------------------------------------------------
// FUNÇÃO QUE GRAVA O ARQUIVO EXCEL EM DISCO.
//-------------------------------------------------------------------------------------------------
Static Function Grv_Disco(_cArqDsc,_cTXT)
//-------------------------------------------------------------------------------------------------
/// VERIFICA SE EXISTEM LINHAS
If !File(_cArqDsc)
	If (_nHdlTxt := FCreate( _cArqDsc,0 )) < 0
		ApMsgInfo("Nao conseguiu criar o arquivo "+ _cArqDsc )
		Return
	Endif
Else
	fErase( _cArqDsc )
	If (_nHdlTxt := FCreate( _cArqDsc,0 )) < 0
		ApMsgInfo("O arquivo "+_cArqDsc+" ja' existia, foi apagado e mesmo assim, nao consegui-se criar um novo arquivo")
		Return
	Endif
EndIf
/// Gerando novo arquivo
FSeek(_nHdlTxt,0)
FWrite(_nHdlTxt,_cTXT)
FClose(_nHdlTxt)
Return()







//-------------------------------------------------------------------------------------------------
//-- Funcao que cria arquivo temporário
//-------------------------------------------------------------------------------------------------
Static Function Cria_TMP()
//-------------------------------------------------------------------------------------------------
Public _cArqTMP,_aTmp
_aTmp:= {}
AADD(_aTmp,{"T_TXT1" 	,"C",500,0})
_cArqTMP := CriaTrab(_aTmp,.T.)
dbUseArea(.T.,,_cArqTMP,"TMP")
dbSelectArea("TMP")
Return





                          
//-------------------------------------------------------------------------------------------------
/// Função que obtem o dado da próxima coluna. 
//-------------------------------------------------------------------------------------------------
Static Function GETNEXTCPO(_xTXT,_nTp)
/// Função que retira de uma STRING um pedaço do TEXTO
/// que vai da posição inicial até encontrar a primeira
/// marcação de TABULACAO, ou até chegar ao final do
/// texto.
//-------------------------------------------------------------------------------------------------
If _nTp = 1
	_nQuebra 	:= at(CHR(9),_xTXT)
Else
	_nQuebra 	:= at(CHR(13),_xTXT)
EndIf
If _nQuebra = 0
	_nQuebra = Len(AllTrim(_xTxt))+1
EndIf
_cRet := Substr(_xTXT,1,_nQuebra-1)
xReg := AllTrim(Substr(_xTXT,_nQuebra+1,Len(_xTXT)))
Return(_cRet)


          
                           

//-------------------------------------------------------------------------------------------------
// FUNÇÃO QUE CHAMA A GERAÇÃO DO EXECAUTO DO PEDIDO
//-------------------------------------------------------------------------------------------------
Static Function ImportExec(_aCab,_aItem)
//-------------------------------------------------------------------------------------------------
Local _cNumPV := ""
Local _dDtAtu := dDatabase
dDatabase := CTOD("01/01/11")
If Len(_aCab) > 0 .and. Len(_aItem)>0
	_cNumPv := PVRemes(_aCab,_aItem)
	If !Empty(_cNumPv)
		//ApMsgInfo("GERADO !!!")
	EndIf
EndIf
dDatabase := _dDtAtu
Return

                            

//-------------------------------------------------------------------------------------------------
// FUNÇÃO GERA O EXECAUTO DO PEDIDO DE VENDA
//-------------------------------------------------------------------------------------------------
Static Function PVRemes(_aCab,_aItem)
//-------------------------------------------------------------------------------------------------
Local aAreaPV		:= GetArea()
Local _aCabPV 	:= {}
Local _aItemPV	:= {}
Local _cNextPV 	:= ""
Local _cRtNum 	:= Space(Len(SC5->C5_NUM))
Local _lGeraPV	:= .T.
Local _cItem	:= "01"
PRIVATE lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .T. 	// se .t. direciona as mensagens de help
Private nOpc				:= 3 		// 3-Incluir, 4-Alterar, 5- Excluir

//Obtem o número do próximo pedido a ser gerado.
_cNextPV := FGETMV("MN_NPV_RC1","C",{"Controla a próxima numeração","de nota fiscal de remessa em","consignação de pedidos antigos"},"00001",,.T.)
If Empty(_cNextPV)
	ApMsgInfo("ERRO no controle de numeração de pedido de remessa em consignação do sistema anterior !")
	Return("")
Else
	_cNextPV := "_" + _cNextPV 	
EndIf

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
	aadd(_aCabPV,{"C5_NUM"  	 	, _cNextPV			,Nil}) // Numero do Item no Pedido
	aadd(_aCabPV,{"C5_TIPO"   		, "N"         		,Nil})// Tipo de pedido
	aadd(_aCabPV,{"C5_CLIENTE"	, _aCab[1]			,Nil}) // Codigo do cliente
	aadd(_aCabPV,{"C5_LOJACLI"	, _aCab[2]  		,Nil}) // Loja do cliente
	aadd(_aCabPV,{"C5_XTPCON"		, "R"			   		,Nil}) // Tipo de Pedido
	
	//ITENS DO PEDIDO DE VENDA 
	For n := 1 to Len(_aItem)
		
		//POSICIONA NO CADASTRO DE PRODUTOS
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+_aItem[n,1])
			_cLocalPad 	:= SB1->B1_LOCPAD
			_cB1UM	 		:= SB1->B1_UM      
			_cAlmox			:= "10"  //_cLocalPad 
			_cOper			:= FGETMV("MN_TOP_RC1","C",{"Código de operação utilizado","em pedidos de venda de","consignação antigos"},"95",,.T.) 
			_cTES				:= FGETMV("MN_TES_RC1","C",{"Código de TES utilizado","em pedidos de venda de","consignação antigos"},"950",,.T.)
		Else
			ApMsgInfo('Nao achou o Produto '+AllTrim(_aItem[n,1])+' !')
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
			SB2->B2_COD			:= _cCodProd
			SB2->B2_LOCAL 	 	:= _cAlmox
			MsUnlock()
		EndIf
		///
		_aLinha := {}
		aadd(_aLinha,{"C6_NUM"  	 	, _cNextPV			  					,Nil}) // Numero do Item no Pedido
		aadd(_aLinha,{"C6_ITEM"  	 	, _cItem		  					,Nil}) // Numero do Item no Pedido
		aadd(_aLinha,{"C6_PRODUTO"	, _aItem[n,1]	  						,Nil}) // Codigo do Produto
		aadd(_aLinha,{"C6_QTDVEN" 	, _aItem[n,2]							,Nil}) // Quantidade Vendida
		aadd(_aLinha,{"C6_PRCVEN" 	, _aItem[n,3]							,Nil}) // Preco Unitario Liquido
		aadd(_aLinha,{"C6_VALOR"  		, _aItem[n,2]*_aItem[n,3]		,Nil}) // Valor Total do Item
		aadd(_aLinha,{"C6_OPER" 		, _cOper				  				,Nil}) // Tipo de Operacao
//		aadd(_aLinha,{"C6_TES"    	, _cTES       							,Nil}) // Tipo de Entrada/Saida do Item
		aadd(_aLinha,{"C6_LOCAL"  		, _cAlmox    			  				,Nil}) // Almoxarifado
//		aadd(_aLinha,{"C6_PRUNIT" 	, _aItem[n,2]    				   		,Nil}) // PRECO DE LISTA
		aadd(_aLinha,{"C6_QTDLIB" 	, _aItem[n,2]							,Nil}) // Quantidade Liberada
		AAdd(_aItemPV,_aLinha)
	                                                
		If n == 99
			_cItem := "A0"
		Else
			_cItem := SOMA1(_cItem)
		EndIf
	Next
	
If _lGeraPV	
	dbSelectArea("SC5") 	
	MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCabPv,_aItemPV,nOpc)
	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Else
		_cRtNum := SC5->C5_NUM
		ApMsgInfo("Gerado o pedido de venda " + SC5->C5_NUM + " para remessa em consignação.")
		_cNextPV := SOMA1(GETMV("MN_NPV_RC1"))
		PUTMV("MN_NPV_RC1",_cNextPV)
	EndIf
EndIf

RestArea(aAreaPV)

Return(_cRtNum)


                
             
             

//-------------------------------------------------------------------------------------------------
// FUNÇÃO QUE VALIDA CAMPOS DO JANELA PRINCIPAL
//-------------------------------------------------------------------------------------------------
Static Function VldCpo(oDlg,_cPar,oCli,_aCLI)
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