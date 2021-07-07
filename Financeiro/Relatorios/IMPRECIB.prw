#Include 'Protheus.ch'
#include 'MSOle.Ch'

///************************************************************************************************
///************************************************************************************************
/// ROTINA ESPECIFICA DESENVOLVIDA PARA O CLIENTE MANOLE
/// PERMITE EXECUTAR A IMPRESSAO DE RECIBOS EM WORD
///************************************************************************************************
///************************************************************************************************
User Function xIMPRECIB()
///-----------------------------------------------------------------------------------------------
	Local 	lRet 		:= .T.
	LOCAL 	nOpca 		:= 0
	Local 	aSays		:= {}
	Local 	aButtons 	:= {}
	Local 	aAreaAnt
	Private aVetSel	:= {}
	PRIVATE cCadastro 	:= OemToAnsi("impressão de Recibos")
	PRIVATE cPerg		:= padr('IMPRECIB',10)
///-----------------------------------------------------------------------------------------------
/// Guarda Filial atual do sistema e posição da tabela SE2
///-----------------------------------------------------------------------------------------------
	dbSelectArea("SE2")
	aAreaAnt 	:= GETAREA()
///-----------------------------------------------------------------------------------------------
/// Cria grupo de perguntas e carrega perguntas para variáveis
///-----------------------------------------------------------------------------------------------
	AjustaSX1()
	pergunte(cPerg,.F.)
///-----------------------------------------------------------------------------------------------
/// Abre janela de parametros iniciais da rotina.
///-----------------------------------------------------------------------------------------------
	AADD(aSays,OemToAnsi("IMPRESSAO DE RECIBOS"))
	AADD(aSays,OemToAnsi("Este programa em como objetivo executar a impressão de "))
	AADD(aSays,OemToAnsi("recibos, baseando-se em títulos a pagar."))
	AADD(aSays,OemToAnsi("* Será exibida tela para seleção e confirmação dos titulos."))
	AADD(aButtons, { 5,.T.,{|| Pergunte("IMPRECIB",.t.) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons,,200,445 )
///-----------------------------------------------------------------------------------------------
///  Se foi confirmada a execução, chama a função que irá selecionar os registros.
///-----------------------------------------------------------------------------------------------
	If nOpca == 1
		SelPCMkb()
	EndIf
///-----------------------------------------------------------------------------------------------
/// Retorna a Filial de Origem e o posicionamento da tabela SE2
///-----------------------------------------------------------------------------------------------
	RESTAREA(aAreaAnt)
///-----------------------------------------------------------------------------------------------

Return





///************************************************************************************************
/// Função que desenja a janela para seleção dos itens de pedido de compras.
///************************************************************************************************
Static Function SelPCMkb()
///------------------------------------------------------------------------------------------------
	Local 	j
	Local 	oFnt
	Local 	aButtons 	:= {}
	Local 	aResid 		:= {}
	Local 	nTelTot 	:= 5
	Local 	cTitDlg		:= "Impressão de recibos"
	Local 	lOk			:= .F.
	Local 	cConfirm		:= "Confirma a impressão de recibos dos itens selecionados?"
	Local 	cPercent
	Local 	cTipo
	Local	cFornIni, cFornFim
	Local 	cProdIni, cProdFim
	Local 	cNumIni,  cNumFim
	Local 	cItemIni, cItemFi
	Local 	cEmisIni, cEmisFim
	Local 	cEntrIni, cEntrFim
	Private cNumSel		:= 0
	Private aCpoSel 	:= {}
	Private aTitSel 	:= {}
	Private lMark 	  	:= .F.
	Private oOk     		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo     		:= LoadBitmap( GetResources(), "LBNO" )
	Private oLbSel
	Private lMrkTudo	:= .F.

///------------------------------------------------------------------------------------------------
//	Aadd( aButtons, {"HISTORIC", {|| TestHist()}, "Histórico...", "Histórico" , {|| .T.}} )
///------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Cria vetor para controlar a posição das Colunas no TwBrowse
//-------------------------------------------------------------------------------------------------
// Posição 1 = identificador do campo
// Posição 2 = Título do ListBox
// Posição 3 = Variável ou campo a ser listado na coluna
// Posição 4 = Formato da coluna C=Caractere, N=Numerica, D=Data
// Posição 5 = .T. ou .F. (indica se a coluna será exibida no ListBox
//-------------------------------------------------------------------------------------------------
	AADD(aCpoSel,{"MRK"		,""					,""						,"C",.T.})
	AADD(aCpoSel,{"PREF"		,"Prefixo"			,'_cPREF'				,"C",.T.})
	AADD(aCpoSel,{"NUM"		,"Numero"			,'_cNUM'				,"C",.T.})
	AADD(aCpoSel,{"PARC"		,"Parcela"			,'_cPARC'  			,"C",.T.})
	AADD(aCpoSel,{"TIPO"		,"Tipo"				,'_cTIPO'  			,"C",.T.})
	AADD(aCpoSel,{"FORNE"		,"Fornecedor"		,'_cFORNE'  			,"C",.T.})
	AADD(aCpoSel,{"LOJA"		,"Loja"				,'_cLOJA'  			,"C",.T.})
	AADD(aCpoSel,{"NOME"		,"Nome"				,'_cNOME'  			,"C",.T.})
	AADD(aCpoSel,{"EMISS"		,"Emissão"			,'_cEMISS'  			,"C",.T.})
	AADD(aCpoSel,{"VENCTO"	,"Vencto"			,'_cVENCTO'  			,"C",.T.})
	AADD(aCpoSel,{"VALOR"		,"Valor"			,'_cVALOR'  			,"C",.T.})
	AADD(aCpoSel,{"IRRF"		,"IRRF"				,'_cIRRF'  			,"C",.T.})
	AADD(aCpoSel,{"RECNO"		,"Registro"		,'_cRECNO'  			,"C",.T.})
	AADD(aCpoSel,{"_MRK"		,""					,".F."					,"C",.F.})
//-------------------------------------------------------------------------------------------------
// Cria vetor para cabeçalho do ListBox
//-------------------------------------------------------------------------------------------------
	For  j:=1 to Len(aCpoSel)
		If aCpoSel[j,5] // Verifica se é para exibir no ListBox
			AADD(aTitSel, aCpoSel[j,2])
		EndIf
	Next

//-------------------------------------------------------------------------------------------------
// Define as fontes a serem utilizadas na montagem das telas
//-------------------------------------------------------------------------------------------------
	DEFINE FONT oFntBt1 	NAME "Arial" 				SIZE 6,  10 BOLD
	DEFINE FONT oFntTW 	NAME "Arial" 				SIZE 7,  12
	DEFINE FONT oFnt 		NAME "Arial" 				SIZE 12, 14 BOLD
//------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------------
// Chama a função que seleciona os dados a serem exibidos conforme parametros
//---------------------------------------------------------------------------------------------------
	MONT_SEL()

///---------------------------------------------------------------------------------------------------
/// Faz o calculo automatico de dimensoes de objetos
///---------------------------------------------------------------------------------------------------
	aSize := MSADVSIZE()

//---------------------------------------------------------------------------------------------------
// JANELA : Desenha a janela para seleção dos itens a serem processados
//---------------------------------------------------------------------------------------------------
	DEFINE MSDIALOG oDlg1 TITLE cTitDlg From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	oDlg1:lMaximized := .T.

	oPanel := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,315,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	@ 004 , 005 SAY "Número de itens selecionados" FONT oDlg1:oFont PIXEL Of oPanel
	@ 004 , 085 SAY oNumSel PROMPT cNumSel	Picture "99,999"	FONT oFnt COLOR CLR_HBLUE	PIXEL Of oPanel

	oSpdBt0 := tButton():New(014,200, "Marca / Desmarca  Tudo", 	oDlg1, {|| MrkTudo()}, 	070, 011,,oFntBt1,,.t.)

	oLbSel := TwBrowse():New(71,10,380,85,,aTitSel,,oDlg1,,,,,{|| RecMrk(),oLbSel:Refresh()},,oFntTW,,,,,.F.,,.T.,,.F.,,,)
	oLbSel:Align := CONTROL_ALIGN_ALLCLIENT
	oLbSel:SetArray( aVetSel )
	oLbSel:bLine := {|| RetSel(oLbSel:nAt)}

	ACTIVATE MSDIALOG oDlg1 ON INIT (EnchoiceBar(oDlg1,{||lOk:=ApMsgYesNo(cConfirm),IIF(lOk,oDlg1:End(),.T.)},{|| oDlg1:End()},,@aButtons)) CENTER

	///------------------------------------------------------------------
	/// Se confirmou a execução, cria vetor só com os itens marcados
	///------------------------------------------------------------------
	If lOk
		If Len(aVetSel)>0
			For j:=1 to Len(aVetSel)
				If aVetSel[j,POS("_MRK")]
					AADD(aResid,{aVetSel[j,POS("RECNO")]})
				EndIf
			Next
		EndIf
		///------------------------------------------------------------------
		/// Se existem itens marcados
		///------------------------------------------------------------------
		If Len(aResid)>0
			For j:= 1 to Len(aResid)
				///-----------------------------------------------------------------------
				/// Posiciona no registro da tabela SE2 que terá o residuo eliminado
				///-----------------------------------------------------------------------
				dbSelectArea("SE2")
				dbSetOrder(1)
				dbGoto(aResid[j,1])

				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)

				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+SE2->E2_NATUREZ)


				///-----------------------------------------------------------------------
				/// Atualiza variáveis
				///-----------------------------------------------------------------------
				//cPercent	:= MV_PAR13
				//cTipo		:= 1
				//cFornIni 	:= SC7->C7_FORNECE
				//cFornFim 	:= SC7->C7_FORNECE
				//cProdIni 	:= SC7->C7_PRODUTO
				//cProdFim 	:= SC7->C7_PRODUTO
				//cNumIni		:= SC7->C7_NUM
				//cNumFim		:= SC7->C7_NUM
				//cItemIni	:= SC7->C7_ITEM
				//cItemFim	:= SC7->C7_ITEM
				//cEmisIni	:= SC7->C7_EMISSAO
				//cEmisFim	:= SC7->C7_EMISSAO
				//cEntrIni	:= SC7->C7_DATPRF
				//cEntrFim	:= SC7->C7_DATPRF

				///-----------------------------------------------------------------------
				/// Chama a função padrão de eliminação de resíduo.
				///-----------------------------------------------------------------------
				//Processa({|lEnd| MA235PC(cPercent,1,cEmisIni,cEmisFim,cNumIni,cNumFim,cProdIni,cProdFim,cFornIni,cFornFim,cEntrIni,cEntrFim,cItemIni,cItemFim)})
				Processa( {|| ImpWord() }, cCadastro, "Processando..." )
				///-----------------------------------------------------------------------
			Next
		Else
			ApMsgInfo("Nenhum item selecionado !")
		EndIf
	EndIf


Return



///************************************************************************************************
/// Função que retorna o conteúdo de uma coluna
///************************************************************************************************
Static Function RetSel(nLin)
///----------------------------------------------------------------------------------------------
	Local aSel := {}
	Local f
///----------------------------------------------------------------------------------------------

	For f:=1 to Len(aCpoSel)
		If aCpoSel[f,5]
			AADD(aSel,aVetSel[nLin,f])
		EndIf
	Next

Return(aSel)



///************************************************************************************************
/// FUNCAO QUE MONTA O VETOR CONTENDO OS DADOS DOS PEDIDOS
///************************************************************************************************
Static Function MONT_SEL()
///----------------------------------------------------------------------------------------------
	Local cQuery 	:= ""
	Local f
	Local nCount 	:= 0			/// Contador para o número de itens filtrados
	Local nLimite 	:= 1000   	/// Numero limite de itens a serem exibidos
	Local cMsgInfo	:= ""
///----------------------------------------------------------------------------------------------
	aVetSel	:= {}
///----------------------------------------------------------------------------------------------
	cQuery := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, "
	cQuery += "       E2_VALOR, E2_IRRF, E2_EMISSAO, E2_VENCTO, E2_NATUREZ ,  "
	cQuery += "       R_E_C_N_O_ SE2RECNO
	cQuery += " FROM " + RetSqlName("SE2") + " "
	cQuery += " WHERE "
	cQuery += "   E2_FILIAL ='" + xFilial("SE2") + "' "
	cQuery += "   AND E2_EMISSAO = '" + dtos(mv_par01) + "' "
	cQuery += "   AND E2_TIPO <> 'TX ' "
	cQuery += "   AND D_E_L_E_T_<>'*'"
	cQuery += " ORDER BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO "
	///----------------------------------------------------------------------------------------
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL1", .F., .T.)
	///----------------------------------------------------------------------------------------
	dbSelectArea("SQL1")
	dbGoTop()
	Do While !Eof()
		nCount += 1

		If nCount <= nLimite
		//-------------------------------------------------
		// Atualiza o vetor para exibição
		//-------------------------------------------------
			aCpo 			:= {}
			_cFilial	:= SQL1->E2_FILIAL
			_cPREF 		:= SQL1->E2_PREFIXO
			_cNUM 		:= SQL1->E2_NUM
			_cPARC		:= SQL1->E2_PARCELA
			_cTIPO		:= SQL1->E2_TIPO
			_cFORNE		:= SQL1->E2_FORNECE
			_cLOJA		:= SQL1->E2_LOJA
			_cVALOR		:= Transform(SQL1->E2_VALOR,PesqPict("SE2","E2_VALOR"))
			_cIRRF		:= Transform(SQL1->E2_IRRF,PesqPict("SE2","E2_IRRF"))
			_cEMISS		:= Substr(SQL1->E2_EMISSAO,7,2) + "/" + Substr(SQL1->E2_EMISSAO,5,2) +"/"+Substr(SQL1->E2_EMISSAO,1,4)
			_cVENCTO	:= Substr(SQL1->E2_VENCTO,7,2) + "/" + Substr(SQL1->E2_VENCTO,5,2) +"/"+Substr(SQL1->E2_VENCTO,1,4)
			_cNOME		:= GETADVFVAL("SA2","A2_NOME",xFilial("SA2")+_cForne+_cLoja,1,"")
			_cRECNO		:= SQL1->SE2RECNO
			AADD(aCpo,oNo)
			For f:=2 to Len(aCpoSel)
				_cCpo := aCpoSel[f,3]
				AADD(aCpo,&_cCpo)
			Next
			AADD(aVetSel,aCpo)
		EndIf
		dbSkip()
	EndDo
	dbCloseArea()

	If nCount > nLimite
		cMsgInfo := "O numero de títulos (para os parametros informados) excedeu "
		cMsgInfo += "a quantidade de "+AllTrim(Str(nLimite))+" itens.   "
		cMsgInfo += "Para evitar lentidão no processamento, apenas os "+AllTrim(Str(nLimite))+" primeiros títulos "
		cMsgInfo += "serão exibidos.   "
		cMsgInfo += "Caso o(s) título(s) que deseja eliminar não esteja(m) entre os apresentados, "
		cMsgInfo += "abandone a rotina e altere os parametros iniciais de forma mais adequada."
		ApMsgInfo(cMsgInfo)
	EndIf

		//--------------------------------------------------------
		// Se nehum item for obtido, criar uma linha em branco
		//--------------------------------------------------------
	If Len(aVetSel)<=0
		aCpo := {}
		AADD(aCpo,oNo)
		For f:=2 to Len(aCpoSel)
			AADD(aCpo,"")
		Next
		AADD(aVetSel,aCpo)
	EndIf

Return()





///**********************************************************************************************
// Função para marcar e desmarcar registro no mark browse
///**********************************************************************************************
Static Function RecMrk()
///----------------------------------------------------------------------------------------------
	Local nPosAtu 		:= oLbSel:nAt
	Local f
	cNumSel := 0
///----------------------------------------------------------------------------------------------
	If !Empty(aVetSel[nPosAtu,POS("NUM")] )
		aVetSel[nPosAtu,POS("_MRK")] 	:= !aVetSel[nPosAtu,POS("_MRK")]
		aVetSel[nPosAtu,1]					:= Iif(aVetSel[nPosAtu,POS("_MRK")],oOk,oNo)
	EndIf
///----------------------------------------------------------------------------------------------
/// Soma os itens selecionados
///----------------------------------------------------------------------------------------------
	For f:=1 to Len(aVetSel)
		If !Empty(aVetSel[f,POS("NUM")] ) .and. aVetSel[f,POS("_MRK")]
			cNumSel += 1
		EndIf
	Next
	oNumSel:Refresh()

Return(.T.)




///**********************************************************************************************
// Função para marcar e desmarcar TODOS os registros no mark browse
///**********************************************************************************************
Static Function MrkTudo()
///----------------------------------------------------------------------------------------------
	Local f
	lMrkTudo 	:= !lMrkTudo
	cNumSel 	:= 0
///----------------------------------------------------------------------------------------------
	For f:=1 to Len(aVetSel)
		If !Empty(aVetSel[f,POS("NUM")] )
			aVetSel[f,POS("_MRK")] 	:= lMrkTudo
			aVetSel[f,1]					:= Iif(lMrkTudo,oOk,oNo)
			If lMrkTudo
				cNumSel += 1
			EndIf
		EndIf
	Next
	oNumSel:Refresh()

Return(.T.)




///**********************************************************************************************
/// Função que retorna o número da coluna.
///**********************************************************************************************
Static Function POS(xPar)
///----------------------------------------------------------------------------------------------
	Local nPos := 0
	Local f
	Local aCpoCopy := {}
	Local cCpoCopy := ""
///----------------------------------------------------------------------------------------------
	cCpoCopy := "aCpoSEL"
	aCpoCopy := ACLONE( &(cCpoCopy))
	For f:=1 to Len(aCpoCopy)
		nPos := IIF(aCpoCopy[f,1] == xPar,f,nPos)
	Next

Return(nPos)





///**********************************************************************************************
/// Função que cria o grupo de perguntas
///**********************************************************************************************
Static Function AjustaSX1()
///----------------------------------------------------------------------------------------------
	Local aArea    	:= GetArea()
	Local aAreaDic 	:= SX1->( GetArea() )
	Local aEstrut  	:= {}
	Local aStruDic 	:= SX1->( dbStruct() )
	Local aDados   	:= {}
	Local nI       		:= 0
	Local nJ       		:= 0
	Local nTam1    	:= Len( SX1->X1_GRUPO )
	Local nTam2    	:= Len( SX1->X1_ORDEM )

	aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
		"X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
		"X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
		"X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
		"X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
		"X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
		"X1_IDFIL"   }
///---------------------------------
/// Perguntas
///---------------------------------
	aAdd( aDados, {cPerg	,'01','Data de Emissao de ?','¿A Fecha Emision ?','From Issue Date ?','mv_ch1','D',8,0,0,'G','','mv_par01','','','','01/01/2000','','','','','','','','','','','','','','','','','','','','','','S','','','',''} )
	aAdd( aDados, {cPerg	,'02','Pasta do arq. DOT  ?','¿A Fecha Emision ?','From Issue Date ?','mv_ch2','C',80,0,0,'G','','mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','','S','','','',''} )
	aAdd( aDados, {cPerg	,'03','Nome do arquivo DOT?','¿A Fecha Emision ?','From Issue Date ?','mv_ch3','C',40,0,0,'G','','mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','','S','','','',''} )
	aAdd( aDados, {cPerg	,'04','Referente a        ?','¿A Fecha Emision ?','From Issue Date ?','mv_ch4','C',40,0,0,'G','','mv_par04','','','','','','','','','','','','','','','','','','','','','','','','','','S','','','',''} )
///---------------------------------
/// Atualizando dicionário
///---------------------------------
	dbSelectArea( "SX1" )
	SX1->( dbSetOrder( 1 ) )

	For nI := 1 To Len( aDados )
		If !SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
			RecLock( "SX1", .T. )
			For nJ := 1 To Len( aDados[nI] )
				If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
					SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
				EndIf
			Next nJ
			MsUnLock()
		EndIf
	Next nI

	RestArea( aAreaDic )
	RestArea( aArea )

Return NIL



///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AP_Word.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ImpWord()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que descarrega as variaveis nas variaveis do word        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function ImpWord()
	Local oWord := Nil
	Local cFileOpen := "" //"D:\RECIBO_MANOLE.DOTX"
	Local cFileSave := "D:\TESTE.DOC"
	Local nSaida := 3
	Local cMainPath	:= ""
	Local aSaida := {"1-Na Impressora","2-Em Arquivo","3-Deixar Word Aberto"}
	Local cTxtIRRF	:= ""
	Local cDataExt := ""
	Local aDiaSem := {}
	Local aMes := {}
	Local aPARAM := {}
	//Local aRET := {}

	//aAdd( aPARAM, { 6, "Arquivo Modelo Word", Space(50), ""    , "", ""   , 50 , .T., "Modelo MS-Word |*.dot", cMainPath })

	//If !ParamBox(aPARAM,"Parâmetros",@aRET)
	//	Return
	//Endif

	//cFileOpen := AllTrim(MV_PAR02) + Alltrim(MV_PAR03)
	cFileOpen := 'dirdoc/financeiro/recibo_manole.dot'
	MAKEDIR( "C:\RECIBO\")
	__CopyFile(cFileOpen, 'C:\RECIBO\recibo_manole.dot')
	cFileOpen := 'C:\RECIBO\recibo_manole.dot'


	AADD(aMes,"janeiro")
	AADD(aMes,"fevereiro")
	AADD(aMes,"março")
	AADD(aMes,"abril")
	AADD(aMes,"maio")
	AADD(aMes,"junho")
	AADD(aMes,"julho")
	AADD(aMes,"agosto")
	AADD(aMes,"setembro")
	AADD(aMes,"outubro")
	AADD(aMes,"novembro")
	AADD(aMes,"dezembro")

	AADD(aDiaSem,"São Paulo")
	AADD(aDiaSem,"São Paulo")
	AADD(aDiaSem,"São Paulo")
	AADD(aDiaSem,"São Paulo")
	AADD(aDiaSem,"São Paulo")
	AADD(aDiaSem,"São Paulo")
	AADD(aDiaSem,"São Paulo")

	/*
	AADD(aDiaSem,"Segunda-feira")
	AADD(aDiaSem,"Terça-feira")
	AADD(aDiaSem,"Quarta-feira")
	AADD(aDiaSem,"Quinta-feira")
	AADD(aDiaSem,"Sexta-feira")
	AADD(aDiaSem,"Sábado")
	AADD(aDiaSem,"Domingo")
	*/

	dDataImp:= SE2->E2_EMISSAO

	cDataExt := aDiaSem[DOW(dDataImp)] + ", " + AllTrim(Str(Day(dDataImp))) + " de " + aMes[MONTH(dDataImp)] + " de " + AllTrim(Str(Year(dDataImp))) + "."

//	aAdd( aPARAM, { 1, "Nº Pedido de venda" , Space(6) , ""    , "", "SC5", "" , 0  , .T. })
//	aAdd( aPARAM, { 6, "Arquivo Modelo Word", Space(50), ""    , "", ""   , 50 , .T., "Modelo MS-Word |*.dot", cMainPath })
//	aAdd( aPARAM, { 2, "Qual saída"         , 1        , aSaida, 80, ""   , .F.})

	If !File(cFileOpen)
		MsgInfo("Arquivo não localizado",cCadastro)
		Return
	Endif

	//+--------------------------------------------------------------------------------------------------
	//| Ao final deste fonte está a explicação de cada função para a integração do Protheus com o Ms-Word
	//+--------------------------------------------------------------------------------------------------
	oWord := OLE_CreateLink()

	OLE_NewFile( oWord, cFileOpen )

	OLE_SetDocumentVar( oWord, 'w_NOME'   , SA2->A2_NOME  )
	If Len(AllTrim(SA2->A2_CGC)) <= 11
		OLE_SetDocumentVar( oWord, 'w_CGC'    , TRANSFORM(SA2->A2_CGC,"@R 999.999.999-99")  )
	Else
		OLE_SetDocumentVar( oWord, 'w_CGC'    , TRANSFORM(SA2->A2_CGC,"@R 99.999.999/9999-99")  )
	EndIf
	OLE_SetDocumentVar( oWord, 'w_VALOR'    , AllTrim(TRANSFORM(SE2->E2_VALOR,"@E 99,999,999.99"))  )

	OLE_SetDocumentVar( oWord, 'w_VENCTO', Substr(DTOS(SE2->E2_VENCTO),7,2) + "/" + Substr(DTOS(SE2->E2_VENCTO),5,2) +"/"+Substr(DTOS(SE2->E2_VENCTO),1,4) )

	If SE2->E2_IRRF = 0
		cTxtIRRF := ""
	Else
		cTxtIRRF := ", sendo o valor Bruto de R$ " + AllTrim(TRANSFORM(SE2->E2_VALOR + SE2->E2_IRRF,"@E 99,999,999.99")) + " e com desconto de IR de R$ " + AllTrim(TRANSFORM(SE2->E2_IRRF,"@E 99,999,999.99"))
	EndIf

	cTxtNat	:= ""
	If Empty(MV_PAR04)
		cTxtNat	:= Lower(AllTrim(SED->ED_DESCRIC) )
	Else
		cTxtNat	:= AllTrim(MV_PAR04)
	EndIf

	OLE_SetDocumentVar( oWord, 'w_IRRF'    , cTxtIRRF )

	OLE_SetDocumentVar( oWord, 'w_DATAEXT'    , cDataExt )

	OLE_SetDocumentVar( oWord, 'w_NATUREZ'    , cTxtNat )

	cExtenso 	:= Lower(Alltrim(EXTENSO(SE2->E2_VALOR)))
	cMesExt		:= 	Alltrim( MesExtenso( Month(dDataBase)) )

	OLE_SetDocumentVar( oWord, 'w_VALEXT'    , cExtenso  )

	OLE_UpDateFields( oWord )

	If nSaida <> 3
		If nSaida == 1
			OLE_PrintFile( oWord )
		Elseif nSaida == 2
			cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)
			OLE_SaveAsFile( oWord, cFileSave+SC5->C5_NUM+"_protheus.doc" )
		Endif
	Endif

	OLE_CloseLink( oWord, .F. )

Return

//+-----------------------------------------------------------------
//+-----------------------------------------------------------------
//| Descritivo de cada função para integrar o Protheus com o Ms-Word
//+-----------------------------------------------------------------
//+-----------------------------------------------------------------
/*

- Funcao que abre o Link com o Word tendo como parametro a versao
  oWord := OLE_CreateLink( "TMSOLEWORD97" )

- Funcao que faz o Word aparecer na Area de Transferencia do Windows, sendo que para habilitar/desabilitar e so colocar .T. ou .F.
  OLE_SetProperty( oWord, OLEWDVISIBLE, .T. )
  OLE_SetProperty( oWord, OLEWDPRINTBACK,.T. )

- Funcoes que configuram o tamanho da janela do Word
  OLE_SetProperty( oWord, OLEWDLEFT  , 000 )
  OLE_SetProperty( oWord, OLEWDTOP   , 090 )
  OLE_SetProperty( oWord, OLEWDWIDTH , 480 )
  OLE_SetProperty( oWord, OLEWDHEIGHT, 250 )

- Funcao de abertura do Documento com os parametros lReadOnly (Somente Leitura), com SENHAXXX (senha de abertura do Documento)
  e com SENHAWWW (senha de gravacao)
  OLE_OPENFILE( oWord, "C:\WINDOWS\TEMP\EXEMPLO.DOC", lReadOnly, "SENHAXXX","SENHAWWW")

- Funcao para criar um Documento com Modelo(DOT) especificado no parametro
  OLE_NewFile( oWord, "C:\WINDOWS\TEMP\EXEMPLO.DOT" )

- Funcao que salva o Documento com o nome especificado, com senha e no formato Word
  OLE_SaveAsFile( oWord, "C:\WINDOWS\TEMP\EXEMPLO1.DOC", "SENHAXXX", "SENHAWWW", .F., OLEWDFORMATDOCUMENT )

- Funcao salva o Documento corrente
  OLE_SaveFile( oWord )

- Funcao que atualiza as variaveis do Word, conforme exemplo ira atualizar a variavel "AdvNomeFilial" com o conteudo
  "Microsiga Software S/A". O RdMake GPEWORD podera servir de exemplo para atualizacao de variaveis
  OLE_SetDocumentVar( oWord, "Adv_NomeFilial", "Microsiga Software S/A" )

- Funcao que atualiza os campos da memoria para o Documento, utilizada logo apos a funcao OLE_SetDocumentVar()
  OLE_Updatefields( oWord )

- Funcao que imprime o Documento corrente podendo ser especificado o numero de copias, podedo tambem imprimir
  com um intervalo especificado nos parametros "nPagInicial" ate "nPagFinal" retirando o parametro"ALL"
  OLE_PrintFile( oWord, "ALL", nPagInicial, nPagFinal, nCopias )

- Funcao que fecha o Documento sem fechar o Link com o Word, utilizado para manipulacao de dois ou mais arquivos
  (recomendado fechar todos os arquivos antes de fechar o Link com Word)
  OLE_CloseFile( oWord )

- Funcao que fecha o Link com o Word
  OLE_CloseLink( oWord )
*/
