#Include "Protheus.Ch"
#Define ENTER Chr(13)+Chr(10)

User Function MnOcor01()

Private cAlias1 := "PA2"
Private cFilPA2 := ""
Private cCadastro := "Cadastro de Ocorrencias"
Private aRotina := {}

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"    ,0,1})
aAdd( aRotina, {"Visualizar" ,'u_MnOcVisual',0,2})
aAdd( aRotina, {"Incluir"    ,'u_MnOcInclui',0,3})
aAdd( aRotina, {"Alterar"    ,'u_MnOcAltera',0,4})
aAdd( aRotina, {"Excluir"    ,'u_MnOcExclui',0,5})

If Empty(Posicione("SX3",1,cAlias1,"X3_ARQUIVO"))
   Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+ENTER+"X3, X2, IX E X7",1,0)
   RETURN
Endif

dbSelectArea(cAlias1)
dbSetOrder(1)
cFilPA2 := xFilial(cAlias1)
dbGoTop()

mBrowse(,,,,cAlias1)

dbSelectArea(cAlias1)
dbSetOrder(1)
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Visual()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de visualizacao                                          |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MnOcVisual( cAlias1, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local oTPane1
Local oTPane2

Private cCodigo := PA2->PA2_CLIFOR
Private cLOJA   := PA2->PA2_LOJA
Private cNome   := POSICIONE("SA1",1,XFILIAL("SA1")+PA2->PA2_CLIFOR+PA2->PA2_LOJA,"SA1->A1_NOME")
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias1)
If RecCount() == 0
	Return
Endif

dbSetOrder(1)
dbSeek( cFilPA2 + cCodigo )

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias1 )
While !EOF() .And. X3_ARQUIVO == cAlias1
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		                X3_CAMPO        ,;
		                X3_PICTURE      ,;
		                X3_TAMANHO      ,; 
		                X3_DECIMAL      ,; 
		                X3_VALID        ,;
		                X3_USADO        ,;
		                X3_TIPO         ,;
		                X3_ARQUIVO      ,;
		                X3_CONTEXT      })
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSeek( cFilPA2 + cCodigo )

While !Eof() .And. XFILIAL("PA2")+PA2->PA2_CLIFOR == cFilPA2 + cCodigo
   
   aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek( cAlias1 )
	While !EOF() .And. X3_ARQUIVO == cAlias1
		If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	dbSelectArea(cAlias1)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406
	
	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Loja:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Nome:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cloja   When .F. SIZE 40,7 PIXEL OF oTPane1
	@ 3, 192 MSGET cnome   When .F. SIZE 80,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406
	
	oGet := MSGetDados():New(0,0,0,0,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Inclui()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de inclusao                                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MnOcInclui(cAlias1,nReg,nOpcX)
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oTPane1
Local oTPane2

Private cCodigo := Space(Len(PA2->PA2_CLIFOR))
Private cLoja   := Space(Len(PA2->PA2_LOJA))
Private cNome   := Space(Len(SA1->A1_NOME))
Private dData   := dDataBase
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO    ,;
		               X3_PICTURE  ,;
		               X3_TAMANHO  ,;
		               X3_DECIMAL  ,;
		               X3_VALID    ,;
		               X3_USADO    ,;
		               X3_TIPO     ,;
		               X3_ARQUIVO  ,;
		               X3_CONTEXT  })
	Endif
	dbSkip()
End

aAdd( aCOLS,Array(Len(aHeader)+1))

dbSelectArea("SX3")
dbSeek(cAlias1)
nUsado:=0
While !EOF() .And. X3_ARQUIVO == cAlias1
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		IF X3_TIPO == "C"
			If Trim(aHeader[nUsado][2]) == "PA2_ITEM"
				aCOLS[1][nUsado] := "01"
			Else
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Endif
		ELSEIF X3_TIPO == "N"
			aCOLS[1][nUsado] := 0
		ELSEIF X3_TIPO == "D"
			aCOLS[1][nUsado] := dDataBase
		ELSEIF X3_TIPO == "M"
			aCOLS[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		ELSE
			aCOLS[1][nUsado] := .F.
		Endif
		If X3_CONTEXT == "V"
			aCols[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		Endif
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSetOrder(1)

aCOLS[1][nUsado+1] := .F.

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo F3 "SA1" PICTURE "@!" VALID PesqSA3(cCodigo) SIZE 030,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome When .F.              SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData PICTURE "99/99/99"    SIZE 40,7 PIXEL OF oTPane1

	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406

	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_MnOcLinOk()","u_MnOcTudOk()","+PA2_ITEM",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	   Mod2Grava(cAlias1)
	End Transaction
Endif
dbSelectArea(cAlias1)
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Altera()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de alteracao                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MnOcAltera( cAlias1, nRecNo, nOpcX )
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local oTPane1
Local oTPane2

Private cCodigo := PA2->PA2_CODIGO
Private cNome   := PA2->PA2_NOME
Private dData   := PA2->PA2_DATA
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias1)
If RecCount() == 0
	Return
Endif

dbSetOrder(1)
dbSeek( cFilPA2 + cCodigo )

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               X3_VALID         ,;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSeek( cFilPA2 + cCodigo )

While !EOF() .And. ZA3->ZA3_FILIAL + ZA3->ZA3_CODIGO == cFilPA2 + cCodigo
   
   aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek(cAlias1)
	While !EOF() .And. X3_ARQUIVO == cAlias1
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[Len(aCOLS),nUsado+1] := .F.
	dbSelectArea(cAlias1)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406

	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2LinOk()","u_Mod2TudOk()","+ZA3_ITEM",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
   Begin Transaction
      Mod2Grava(cAlias1)
   End Transaction
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Exclui()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de exclusao                                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MnOcExclui( cAlias1, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local nX       := 0
Local oTPane1
Local oTPane2

Private cCodigo := ZA3->ZA3_CODIGO
Private cNome   := ZA3->ZA3_NOME
Private dData   := ZA3->ZA3_DATA
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := {}

dbSelectArea(cAlias1)
If RecCount() == 0
	Return
Endif

//Fazer pesquisar para saber se o(s) registro(s) pode(m) ser excluídos

dbSetOrder(1)
dbSeek( cFilPA2 + cCodigo )

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias1 )
While !EOF() .And. X3_ARQUIVO == cAlias1
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               X3_VALID         ,;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSeek( cFilPA2 + cCodigo )

While !Eof() .And. ZA3->ZA3_FILIAL + ZA3->ZA3_CODIGO == cFilPA2 + cCodigo
   aAdd( aCOLS, Array(Len(aHeader)+1))
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek( cAlias1 )
	While !EOF() .And. X3_ARQUIVO == cAlias1
		If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	dbSelectArea(cAlias1)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406
	
	oGet := MSGetDados():New(0,0,0,0,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

If nOpcA == 1
   Begin Transaction
      dbSelectArea(cAlias1)
      dbSetOrder(1)
      For nX = 1 to Len(aCols)
	     dbSeek( cFilPA2 + cCodigo+aCols[nX][Mod2Pesq("ZA3_ITEM")] )
	     RecLock(cAlias1,.F.)
	        dbDelete()
     Next nx
     MsUnLock(cAlias1)
   End Transaction
Endif

Return

//+------------------------------------------------------------------------------+
//|******************************************************************************|
//|******************+---------------------------------------+*******************|
//|******************| FUNCOES GENEREICAS PARA ESTE PROGRAMA |*******************|
//|******************+---------------------------------------+*******************|
//|******************************************************************************|
//+------------------------------------------------------------------------------+

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2Codigo()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Validar se o codigo existe                                      |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
/*
Static Function Mod2Codigo(cCodigo)
Local cMsg := ""
Local lRet := .T.
dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+cCodigo)
If Eof()
   cMsg := "Codigo nao existe"
   Help("",1,"","Mod2Codigo",cMsg,1,0)
   lRet := .F.
Else
   cNome := SA3->A3_NOME
Endif
Return( lRet )
*/
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ModLinOk()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Verifica se a linha esta ok                                     |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MnOcLinOk()
Local lRet := .T.
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.
If !aCols[n][nUsado+1]
   If Empty(aCols[n][Mod2Pesq("ZA3_CCUSTO")])
      cMsg := "Nao sera permitido linhas sem o centro de custo."
      Help("",1,"","Mod2LinOk",cMsg,1,0)
      lRet := .F.
   Endif
Endif

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2TudOk()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Validar se todas as linhas estao OK                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MnOcTudOk()
Local lRet := .T.

lRet := u_Mod2LinOk()

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2Pesq()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Retornar a posicao do campo no vetor aHeader                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function MnOcPesq(cCampo)
Local nPos := 0
nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2]))==cCampo})
Return(nPos)

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2Grava()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de para gravar os dados                                  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function MnOcGrava(cAlias1)
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local lOk := .T.
Local cMsg := ""

dbSelectArea(cAlias1)
dbSetOrder(1)

For nI := 1 To Len(aCols)
   dbSeek( cFilPA2 + cCodigo + aCols[nI][Mod2Pesq("ZA3_ITEM")] )

   If !aCols[nI][nUsado+1]            
      If Found()
         RecLock(cAlias1,.F.)
      Else
         RecLock(cAlias1,.T.)
      Endif
      
      ZA3->ZA3_FILIAL := cFilPA2
      ZA3->ZA3_CODIGO := cCodigo
      ZA3->ZA3_NOME   := cNome
      ZA3->ZA3_DATA   := dData
            
      For nY = 1 to Len(aHeader)
         If aHeader[nY][10] # "V"
            cVar := Trim(aHeader[nY][2])
            Replace &cVar. With aCols[nI][nY]
         Endif
      Next nY
      MsUnLock(cAlias1)      
   Else
      If !Found()
         Loop
      Endif
      //Fazer pesquisa para saber se o item poderar ser deletado e
      If lOk
         RecLock(cAlias1,.F.)
            dbDelete()
         MsUnLock(cAlias1)
      Else
         cMsg := "Nao foi possivel deletar o item "+aCols[nI][Mod2Pesq("ZA3_ITEM")]+", o mesmo possui amarracao"
         Help("",1,"","NAOPODE",cMsg,1,0)
      Endif
   Endif
Next nI

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - PesqSA3()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Validar se o codigo existe                                      |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function PesqSA3(cCodigo)
Local lRet := .T.

dbSelectArea(cAlias1)
dbSetOrder(1)
If dbSeek( cFilPA2 + cCodigo )
   Help("",1,"","Cod_Existe","Este Vendedor já têm cadastro",1,0)
   lRet := .F.
Endif

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+cCodigo)

If Eof()
   lRet := .F.
Else
   cNome := SA3->A3_NOME
Endif

Return( lRet )