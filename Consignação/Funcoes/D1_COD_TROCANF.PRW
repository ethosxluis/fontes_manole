#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE POS_CODPR   2
#DEFINE POS_DESCR	3
#DEFINE POS_QTDE	4
#DEFINE POS_QALTE	5
#DEFINE POS_NFORI	6
#DEFINE POS_LOCAL	7
#DEFINE POS_EMISS	8
#DEFINE POS_DESCO	9
#DEFINE POS_VUNIT  10
#DEFINE POS_VTOTA  11
#DEFINE POS_ITORI  12
#DEFINE POS_SEORI  13
#DEFINE POS_IDEB6  14
#DEFINE POS_QTSB6  15

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³D1_COD_TROCANF ºAutor  ³Sonia Kodaira  º Data ³  02/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para incluir uma opção no menu da NFE      º±±
±±º          ³                 										      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Manole                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//	                                                                       //
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////
User Function D1_COD_TROCANF()
////////////////////////////////

Local aArea    := GetArea()

Local   nRadio  :=  1
Local   oRadio, oDlg
Local   nok := 1

Private x_prod
Private W_PROC := .F.
Private CA100FOR := Space(TamSX3("A1_COD")[1])
Private CLOJA    := Space(TamSX3("A1_LOJA")[1])
Private CNOMCLI  := Space(TamSX3("A1_NOME")[1])
Private CLOCAL   := Space(TamSX3("D1_LOCAL")[1])
Private COPER    := Space(TamSX3("D1_OPER")[1])

Private W_QT_ATU := 0
Private W_QT_ALT := 0

DEFINE MSDIALOG oDlg TITLE "INFORMAR OS DADOS DA SELECAO DA NOTA FISCAL" FROM  02,04 TO 15,50  OF oMainWnd   // Opcoes de Movimentacao

@ 08,010 SAY OemToAnsi("Cod. Cliente:") SIZE 35,08 OF oDlg PIXEL
@ 08,100 SAY OemToAnsi("Loja:")     SIZE 35,08 OF oDlg PIXEL
@ 40,010 SAY OemToAnsi("Operacao:") SIZE 35,08 OF oDlg PIXEL
@ 40,100 SAY OemToAnsi("Local:")    SIZE 35,08 OF oDlg PIXEL

@ 08,045 MSGET oCLI VAR CA100FOR PICTURE "@!" F3 "SA1" VALID VE_CLILOJA(.F.) SIZE 35,08 OF oDlg PIXEL
@ 08,120 MSGET oLOJ VAR CLOJA    PICTURE "@!" VALID VE_CLILOJA(.T.) SIZE 15,08 OF oDlg PIXEL
@ 22,020 Say OemToAnsi(CNOMCLI) SIZE 150,08 OF oDlg PIXEL

@ 40,045 MSGET oOPE VAR COPER  PICTURE "@!" VALID VE_OPER() SIZE 15,08 OF oDlg PIXEL
@ 40,120 MSGET oLOC VAR CLOCAL PICTURE "@!" VALID VE_LOCAL() SIZE 15,08 OF oDlg PIXEL

DEFINE SBUTTON FROM 65,050 TYPE 1 ACTION ( nOk := 1, oDlg:End() ) ENABLE OF oDlg
DEFINE SBUTTON FROM 65,100 TYPE 2 ACTION ( nOk := 0, oDlg:End() ) ENABLE OF oDlg

Activate MsDialog oDlg Centered

if nOk == 1 .AND. .NOT. EMPTY(CNOMCLI)
	Processa({|| D1COD_SELNF() })
ENDIF

RestArea( aArea )



////////////////////////////////////////////////
STATIC FUNCTION D1COD_SELNF()
////////////////////////////////////////////////
Local ENTERL    := CHR(13)+CHR(10)

Private lMark := .F.
Private lChk1 := .F.
Private lChk2 := .F.
Private lChk3 := .F.
Private lChk4 := .F.
Private lChk5 := .F.
Private oOk   := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Private oNo   := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Private oLbx
Private oChk1
Private oChk2
Private oChk3
Private oChk4
Private oChk5
Private cTitulo  := "Seleciona registros para NF entrada"

/////////////////////////////////////////////////////////////////////////////////
// CRIANDO A QUERY COM OS ITENS DA TABELA SZ2 DO CLIENTE PARA SELECAO
/////////////////////////////////////////////////////////////////////////////////

If Select("_QRY_SZ2") > 0
	_QRY_SZ2->( DbCloseArea() )
EndIf

cQuery := " SELECT SZ2.Z2_CLIENTE, SZ2.Z2_LOJA, SZ2.Z2_PRODUTO, SZ2.Z2_EVENTO, SA1.A1_VEND, "+ ENTERL
cQuery += " SZ2.Z2_QTDCON, SZ2.Z2_DEVSIMB, SZ2.Z2_DEVFIS, SZ2.Z2_FATCON, B1_DESC "+ ENTERL   // SK - 17/12/14 - INCLUIR B1_DESC

cQuery += " FROM " + RetSqlName("SZ2") + " SZ2 " +ENTERL

cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + ENTERL
cQuery += " SA1.A1_FILIAL  = '"+ xFilial("SA1")+"' AND "+ENTERL         // SK - 17/12/14 - INCLUIR A VERIFICACAO DA FILIAL DA TABELA SA1
cQuery += " SA1.A1_COD = SZ2.Z2_CLIENTE AND "+ ENTERL
cQuery += " SA1.A1_LOJA = SZ2.Z2_LOJA "+ ENTERL

cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + ENTERL  // SK - 17/12/14 - INCLUIR TABELA SB1
cQuery += " SB1.B1_COD = SZ2.Z2_PRODUTO AND "+ ENTERL               // SK - 17/12/14 - INCLUIR TABELA SB1
cQuery += " SB1.B1_FILIAL  = '"+ xFilial("SB1")+"' "+ENTERL         // SK - 17/12/14 - INCLUIR TABELA SB1

cQuery += " WHERE SZ2.Z2_FILIAL  = '"+ xFilial("SZ2")+"' AND "+ENTERL
cQuery += " SZ2.Z2_CLIENTE  = '"     + CA100FOR + "' AND " + ENTERL
cQuery += " SZ2.Z2_LOJA = '"         + CLOJA + "' AND " + ENTERL

cQuery += " SZ2.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery += " SA1.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery += " SB1.D_E_L_E_T_ <> '*' " + ENTERL  // SK - 17/12/14/ - INCLUIR TABELA SB1

cQuery += " ORDER BY B1_DESC " + ENTERL

MEMOWRITE ("D1_COD_TROCANF.TXT",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"_QRY_SZ2",.T.,.T.)


/////////////////////////////////////////////////////////////////////////////////
// GERANDO O VETOR COM OS ITENS DO CLIENTE DA QUERY PARA A SELECAO DO USUARIO  //
/////////////////////////////////////////////////////////////////////////////////

AVETOR   := {}
W_GRAVA := .F.

DO WHILE .NOT. W_GRAVA

	LISTBOX_VETOR()

	IF .NOT. W_GRAVA
		W_GRAVA := MSGYESNO("(1) FINALIZA A SELECAO DOS ITENS PARA CONFIRMACAO DA NOTA FISCAL?")

		IF W_GRAVA
			W_GRAVA := MSGYESNO("(2) FINALIZA A SELECAO DOS ITENS PARA CONFIRMACAO DA NOTA FISCAL?")
		ENDIF
	ENDIF

ENDDO

////////////////////////////////////////////////////////////////////////////////
// MARCANDO OS TITULOS PARA A GERACAO DAS FATURAS A PAGAR
/////////////////////////////////////////////////////////////////////////////////

aCabec		:= {}
aItens      := {}

IF W_PROC

	aadd(aCabec, 	{"F1_TIPO",	   		"B"							})
	aadd(aCabec, 	{"F1_FORMUL",		"S" 						})
	aadd(aCabec, 	{"F1_DOC",			Space(TamSX3("D1_DOC")[1])	})
	aadd(aCabec, 	{"F1_SERIE",		Space(TamSX3("D1_SERIE")[1])})
	aadd(aCabec, 	{"F1_EMISSAO",		DDATABASE					})
	aadd(aCabec, 	{"F1_FORNECE",		CA100FOR					})
	aadd(aCabec, 	{"F1_LOJA",  		CLOJA						})
	aadd(aCabec, 	{"F1_ESPECIE",		"SPED"						})
	aadd(aCabec,	{"F1_COND",	  		"001"						})

	W_ITEM := 0

	FOR W_VETOR := 1 TO LEN(AVETOR)

		IF AVETOR[W_VETOR][1] == .T. // SE ESTA MARCADO PARA FAZER O PROCESSAMENTO

			IF AVETOR[W_VETOR][POS_QTSB6] > 0 // SE ESTE VETOR ESTIVER ZERO DA A MSG PADRAO NO PROTHEUS QUE NAO EXISTE SALDO EM PODDER DE TERCEIROS


				CTES  := "" // MaTESInt(1,COPER,CA100FOR,CLOJA,"C",AVETOR[W_VETOR][2],"D1_TES")
				            // RETIRADO DEVIDO A EERO NA FUNÇÃO TOTVS PADRAO

				IF EMPTY(CTES)
					CTES := IIF( COPER == "11", "001", IIF( COPER == "12", "370", "495") )
				ENDIF

				W_ITEM += 1

				Alinha := {}

				W_QTDE := IIF ( AVETOR[W_VETOR][POS_QALTE] <> 0 , AVETOR[W_VETOR][POS_QALTE], AVETOR[W_VETOR][POS_QTDE] ) //  CONSIDERA QTDE ALTERADA OU QTDE ORIGINAL

				aadd(aLinha, {'D1_ITEM'   	, STRZERO(W_ITEM,4) 						,NIL})
				aadd(aLinha, {'D1_COD'    	, AVETOR[W_VETOR][POS_CODPR]		    	,NIL})
				aadd(aLinha, {'D1_QUANT'  	, W_QTDE				 		    		,NIL})
				aadd(aLinha, {'D1_VUNIT'  	, AVETOR[W_VETOR][POS_VUNIT]   	    		,NIL})
				aadd(aLinha, {'D1_TOTAL'  	, W_QTDE * AVETOR[W_VETOR][POS_VUNIT]  		,NIL})
				aadd(aLinha, {'D1_VALIPI' 	, 0	   										,NIL})
				aadd(aLinha, {'D1_VALICM' 	, 0											,NIL})
				aadd(aLinha, {'D1_VALDESC' 	, (W_QTDE * AVETOR[W_VETOR][POS_VUNIT]) * (AVETOR[W_VETOR][POS_DESCO]/100)	,NIL})
				aadd(aLinha, {'D1_LOCAL'	, CLOCAL									,NIL})
				aadd(aLinha, {'D1_OPER'		, COPER										,NIL})
				aadd(aLinha, {'D1_TES'		, CTES		 								,NIL})
				aadd(aLinha, {'D1_DOC'    	, Space(TamSX3("D1_DOC")[1])				,NIL})
				aadd(aLinha, {'D1_SERIE'    , Space(TamSX3("D1_SERIE")[1])				,NIL})
				aadd(aLinha, {'D1_FORNECE'  , CA100FOR		    						,NIL})
				aadd(aLinha, {'D1_LOJA'     , CLOJA		    							,NIL})
				aadd(aLinha, {'D1_FORMUL'   , "N"		    							,NIL})
				aadd(aLinha, {'D1_ITEMGRD'  , Space(TamSX3("D1_ITEMGRD")[1])			,NIL})
				aadd(aLinha, {'D1_NUMSEQ'   , 	   										,NIL})
				aadd(aLinha, {'D1_NFORI'  	, AVETOR[W_VETOR][POS_NFORI]   	    		,NIL})
				aadd(aLinha, {'D1_ITEMORI' 	, AVETOR[W_VETOR][POS_ITORI]   	    		,NIL})
				aadd(aLinha, {'D1_SERIORI' 	, AVETOR[W_VETOR][POS_SEORI]   	    		,NIL})
				aadd(aLinha, {'D1_IDENTB6' 	, AVETOR[W_VETOR][POS_IDEB6]   	    		,NIL})

				AAdd(aItens,aLinha)

			ENDIF

		endif

	next

	//	Begin Transaction // se ativar da erro DBRUNLOCK quando utilizado formulario proprio

	lMsErroAuto := .F.
	N := 1

	MATA103(aCabec,aItens,3, .T. ) // Inclusão da nota fiscal de entrada

	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Endif

	///	End Transaction

ENDIF       // IF W_PROC

_QRY_SZ2->( DbCloseArea() )

RETURN()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// CRIANDO O VETOR COM OS REGISTROS SELECIONADOS
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

Static Function ListBox_VETOR()

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+

IF LEN(AVETOR) == 0

	WCONT := 0

	DO WHILE .NOT. _QRY_SZ2->(EOF()) //.AND. WCONT < 300

		WCONT += 1

		INCPROC("Processando saldo (" + ALLTRIM(STR(WCONT)) + ") " + _QRY_SZ2->Z2_PRODUTO)

		nQtdPen := (_QRY_SZ2->Z2_QTDCON - _QRY_SZ2->Z2_DEVSIMB -_QRY_SZ2->Z2_DEVFIS)

		U_VE_SLDSB6(_QRY_SZ2->Z2_CLIENTE,_QRY_SZ2->Z2_LOJA, _QRY_SZ2->Z2_PRODUTO, nQtdPen, _QRY_SZ2->Z2_EVENTO )

		_QRY_SZ2->(DBSKIP())

	ENDDO

ENDIF

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existe registros para selecionar", {"Ok"} )
	W_GRAVA := .T.
	Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo + " - " + ALLTRIM(CNOMCLI) + " (" + CA100FOR + "/" + CLOJA + ")" FROM 0,0 TO 550,1300 PIXEL

@ 10,05 LISTBOX oLbx FIELDS HEADER ;
" ","ISBN","Descricao","Qtde","Qtde Alt","NF Origem","Local","Emissao","Desc","Vr Unit","Total","Item","Serie","Ident SB6","Sld SB6" ;
SIZE 630,235 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])


oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif( aVetor[oLbx:nAt,1],oOk,oNo),;
						aVetor[oLbx:nAt,POS_CODPR],;   // 02 CODIGO DO PRODUTO
						aVetor[oLbx:nAt,POS_DESCR],;   // 03 DESCRICAO
						aVetor[oLbx:nAt,POS_QTDE],;    // 04 QTDE
						aVetor[oLbx:nAt,POS_QALTE],;   // 05 QTDE ALTERADA
						aVetor[oLbx:nAt,POS_NFORI],;   // 06 NF ORIGEM
						aVetor[oLbx:nAt,POS_LOCAL],;   // 07 LOCAL ORIGEM
						aVetor[oLbx:nAt,POS_EMISS],;   // 08 EMISSAO
						aVetor[oLbx:nAt,POS_DESCO],;   // 09 DESCONTO
						aVetor[oLbx:nAt,POS_VUNIT],;   // 10 VR UNITARIO
						aVetor[oLbx:nAt,POS_VTOTA],;   // 10 TOTAL
						aVetor[oLbx:nAt,POS_ITORI],;   // 11 ITEM ORIGEM
						aVetor[oLbx:nAt,POS_SEORI],;   // 12 SERIE ORIGEM
						aVetor[oLbx:nAt,POS_IDEB6],;   // 13 IDENT SB6
						aVetor[oLbx:nAt,POS_QTSB6],;   // 14 SALDO EM PODER TERCEIROS
						}}

@ 255,50 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 PIXEL OF oDlg ;
ON CLICK( aEval( aVetor, {|x| x[1] := lChk1 } ),oLbx:Refresh() )

@ 255,150 CHECKBOX oChk2 VAR lChk2 PROMPT "Inverter a seleção" SIZE 70,7 PIXEL OF oDlg ;
ON CLICK( aEval( aVetor, {|x| x[1] := !x[1] } ), oLbx:Refresh() )

@ 255,220 CHECKBOX oChk3 VAR lChk3 PROMPT "Altera Qtde" SIZE 60,7 PIXEL OF oDlg;
ON CLICK( aVetor[oLbx:nAT,POS_QALTE] := IIF(aVetor[oLbx:nAT,1] = .T., D1ALT_QTDE( aVetor[oLbx:nAT,POS_QTDE], aVetor[oLbx:nAT,POS_QALTE]),aVetor[oLbx:nAT,POS_QALTE]) , oLbx:Refresh() )

@ 255,290 CHECKBOX oChk4 VAR lChk4 PROMPT "Pesquisa" SIZE 60,7 PIXEL OF oDlg;
ON CLICK( oLbx:nAT := VE_ASCAN(), oLbx:Refresh() )

@ 255,350 CHECKBOX oChk5 VAR lChk5 PROMPT "Soma Itens" SIZE 60,7 PIXEL OF oDlg;
ON CLICK( D1COD_SOMA() )

DEFINE SBUTTON FROM 255,450 TYPE 01 ENABLE OF oDlg ACTION (W_PROC := .T., oDlg:End())
DEFINE SBUTTON FROM 255,550 TYPE 02 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

Return (W_PROC)



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USER FUNCTION VE_SLDSB6(x_cliente, x_loja, x_produto, nQtdPen, x_evento)                                        //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If Select("_QRYPSB6") > 0
	_QRYSB6_SD2->( DbCloseArea() )
EndIf

cQuery := "SELECT * FROM " + RetSqlName( "SB6" ) + " SB6, " +  RetSqlName( "SD2" ) + " SD2
cQuery += " WHERE SB6.D_E_L_E_T_= ' '  AND B6_SALDO <> 0"
cQuery += " AND B6_FILIAL = '"  + XFILIAL("SB6") + "'"
cQuery += " AND B6_CLIFOR = '"  + x_cliente  + "'"
cQuery += " AND B6_LOJA = '"    + x_loja + "'"
cQuery += " AND B6_PRODUTO = '" + x_produto + "'"
cQuery += " AND SD2.D_E_L_E_T_= ' '  "                      // SONIA - 17/03/14 - TRATAMENTO COM AS NFS DE ORIGEM
cQuery += " AND D2_FILIAL = '"  + XFILIAL("SD2") + "'"
cQuery += " AND D2_CLIENTE = '" + x_cliente  + "'"
cQuery += " AND D2_LOJA  = '"   + x_loja + "'"
cQuery += " AND D2_COD = '" + x_produto + "'"
cQuery += " AND D2_LOCAL = B6_LOCAL AND D2_DOC = B6_DOC AND D2_SERIE = B6_SERIE "
cQuery += " AND D2_NUMSEQ = B6_IDENT"
cQuery += " AND D2_XEVENTO = '" + X_EVENTO + "'"            // SONIA - 02/04/14

TcQuery CQUERY New Alias _QRYSB6_SD2

MEMOWRIT("C:\WINDOWS\TEMP\VE_SLDSB6", cQuery)

DO WHILE .NOT. _QRYSB6_SD2->(EOF())

	asaldosb6 := CalcTerc(_QRYSB6_SD2->D2_COD,_QRYSB6_SD2->D2_CLIENTE,_QRYSB6_SD2->D2_LOJA,_QRYSB6_SD2->D2_IDENTB6,_QRYSB6_SD2->D2_TES,_QRYSB6_SD2->D2_TIPO)

	aAdd( aVetor, { lMark, ;
					substr(_QRY_SZ2->Z2_PRODUTO,1,15)					,;  //POSICAO 2- CODIGO
					substr(_QRY_SZ2->B1_DESC,1,40) 						,;  //POSICAO 3 - DESCRICAO
					_QRYSB6_SD2->B6_SALDO         						,; // POSICAO 4 - QTDE
					0					          						,; // POSICAO 5 - QTDE ALTERADA
					_QRYSB6_SD2->B6_DOC           						,; // POSICAO 6 - NF DE ORIGEM
					_QRYSB6_SD2->B6_LOCAL         						,; // POSICAO 7 - LOCAL DE ORIGEM
					STOD(_QRYSB6_SD2->B6_EMISSAO) 						,; // POSICAO 8 - EMISSAO DE ORIGEM
					_QRYSB6_SD2->D2_DESC          						,; // POSICAO 9 - DESCONTO
					_QRYSB6_SD2->D2_PRUNIT        						,; // POSICAO 10 - VR UNITARIO
					(_QRYSB6_SD2->D2_PRUNIT * _QRYSB6_SD2->B6_SALDO)  	,; // POSICAO 11 - TOTAL
					_QRYSB6_SD2->D2_ITEM      							,; // POSICAO 12 - ITEM DA NF
					_QRYSB6_SD2->D2_SERIE     							,; // POSICAO 13 - SERIE DA NF
					_QRYSB6_SD2->B6_IDENT     							,; // POSICAO 14 - IDENT SB6
					asaldosb6[1] - asaldosb6[2]              			,; // POSICAO 15 - SALDO EM PODER TERCEIROS
		})

	_QRYSB6_SD2->(DBSKIP())

ENDDO

_QRYSB6_SD2->( DbCloseArea() )
RETURN()



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION D1ALT_QTDE(X_QT_ATU, X_QT_ALT)  // ALTERA A QUANTIDADE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local  oDlg1

W_QT_ATU := X_QT_ATU
W_QT_ALT := X_QT_ALT

DEFINE MSDIALOG oDlg1 TITLE "Altera Qtde" FROM  02,04 TO 10,30  OF oMainWnd

@ 08,010 SAY OemToAnsi("Qtde Atual: "  ) SIZE 35,08 OF oDlg1 PIXEL
@ 20,010 SAY OemToAnsi("Qtde Atual: "  ) SIZE 35,08 OF oDlg1 PIXEL

@ 08,045 MSGET oQtde  VAR W_QT_ATU PICTURE "999" WHEN .F. SIZE 35,08 OF oDlg1 PIXEL
@ 20,045 MSGET oQtde1 VAR W_QT_ALT PICTURE "999" VALID VL_ALTQTDE(W_QT_ATU, W_QT_ALT) SIZE 35,08 OF oDlg1 PIXEL

DEFINE SBUTTON FROM 45,050 TYPE 1 ACTION ( nOk1 := 1, oDlg1:End() ) ENABLE OF oDlg1

Activate MsDialog oDlg1 Centered

RETURN( W_QT_ALT )


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION D1COD_SOMA()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

X_TOT_ITENS := 0
X_TOT_QTDE  := 0
X_SEL_ITENS := 0
X_SEL_QTDE  := 0

WSOMA := 0
FOR W_VETOR := 1 TO LEN(AVETOR)
	IF AVETOR[W_VETOR][1] == .T. // SE ESTA MARCADO PARA FAZER O PROCESSAMENTO
		X_SEL_ITENS += 1
		X_SEL_QTDE += AVETOR[W_VETOR] [POS_QTDE]
	ENDIF
	X_TOT_ITENS += 1
	X_TOT_QTDE += AVETOR[W_VETOR] [POS_QTDE]
NEXT

MSGALERT( "Total itens: " + ALLTRIM(TRANSFORM(X_TOT_ITENS, "@E 99,999,999")) + " - qtde: " + ALLTRIM(TRANSFORM(X_TOT_QTDE, "@E 99,999,999")) + CHR(13) + CHR(10) + ;
          "Total selec: " + ALLTRIM(TRANSFORM(X_SEL_ITENS, "@E 99,999,999")) + " - qtde: " + ALLTRIM(TRANSFORM(X_SEL_QTDE, "@E 99,999,999")) )
RETURN()



////////////////////////////////////////////////
STATIC FUNCTION VE_CLILOJA(x_nomcli)
////////////////////////////////////////////////

CNOMCLI := Space(TamSX3("A1_NOME")[1])

IF X_NOMCLI
	CNOMCLI := POSICIONE("SA1", 1, XFILIAL("SA1") + CA100FOR + CLOJA, "A1_NOME")

	IF EMPTY(CNOMCLI)
		MSGALERT(alltrim(cusername) + ", favor verificar o codigo / loja do cliente !!! " )
	ENDIF

ENDIF

RETURN(.T.)


////////////////////////////////////////////////
STATIC FUNCTION VE_LOCAL()
////////////////////////////////////////////////
Local LRET :=  .T.

IF .NOT. ALLTRIM(CLOCAL) $ "9/10"
	MSGALERT(alltrim(cusername) + ", Local aceito - 9 ou 10 !!! " )
	LRET :=.F.
ENDIF

IF .NOT. EMPTY(COPER) .AND. .NOT. EMPTY(CLOCAL)
	IF COPER == "11" .AND. CLOCAL <> "10"
		MSGALERT(alltrim(cusername) + ", Operacao 11 aceita somente local 10 !!! " )
		LRET :=.F.
	ENDIF
ENDIF

RETURN(LRET)



////////////////////////////////////////////////
STATIC FUNCTION VE_OPER()
////////////////////////////////////////////////
Local LRET :=  .T.

IF .NOT. COPER $ "11/12/D2"
	MSGALERT(alltrim(cusername) + ", Operacao aceita - 11, 12 ou D2 !!! " )
	LRET :=.F.
ENDIF

IF .NOT. EMPTY(COPER) .AND. .NOT. EMPTY(CLOCAL)
	IF COPER == "11" .AND. CLOCAL <> "10"
		MSGALERT(alltrim(cusername) + ", Operacao 11 aceita somente local 10 !!! " )
		LRET :=.F.
	ENDIF
ENDIF

RETURN(LRET)


////////////////////////////////////////////////
STATIC FUNCTION VL_ALTQTDE()
////////////////////////////////////////////////
X_LRET := .T.

IF W_QT_ALT > W_QT_ATU
	MSGALERT(alltrim(cusername) + ", Qtde alterada invalida !!! " )
	W_QT_ALT := W_QT_ATU
	X_LRET := .F.
ENDIF

RETURN(X_LRET)



////////////////////////////////////////////////
STATIC FUNCTION VE_ASCAN()
////////////////////////////////////////////////

Local  oDlg2

X_AT := oLbx:nAT

X_TEXTO := Space(TamSX3("B1_COD")[1])

DEFINE MSDIALOG oDlg2 TITLE "Pesquisa" FROM  02,04 TO 10,30  OF oMainWnd

@ 08,010 SAY OemToAnsi("Texto: "  ) SIZE 35,08 OF oDlg2 PIXEL

@ 08,045 MSGET oTexto  VAR X_TEXTO PICTURE "@!"  SIZE 50,08 OF oDlg2 PIXEL

DEFINE SBUTTON FROM 45,050 TYPE 1 ACTION ( nOk2 := 1, oDlg2:End() ) ENABLE OF oDlg2

Activate MsDialog oDlg2 Centered

FOR W_VETOR := 1 TO LEN(AVETOR)
	IF ALLTRIM(X_TEXTO) $ AVETOR[W_VETOR][POS_CODPR]  .OR. ALLTRIM(X_TEXTO) $ AVETOR[W_VETOR][POS_DESCR]
		X_AT    := W_VETOR
		W_VETOR := LEN(AVETOR) + 1
	ENDIF
NEXT

RETURN(X_AT)

