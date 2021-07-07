#Include "Protheus.ch"
#Include "ApWizard.ch"
User Function Tst10WZ()
U_ACDIWZ(1,{'090504001','UNI','1     ','1 '})
Return

user Function ACDIWZ(nOrigem,aParIni)
Local oWizard
Local oPanel
Local nTam

Local oOrigem
Local aOrigem := {}

Local aparNF	:={	{1,"Nota Fiscal"		,Space(9),"","","CBW"	,If(aParIni==NIL,".T.",".F."),0,.F.},;
							{1,"Serie"				,Space(3) ,"","",			,If(aParIni==NIL,".T.",".F."),0,.F.},;
					  		{1,"Fornecedor"		,Space(6) ,"","","SA2"	,If(aParIni==NIL,".T.",".F."),0,.F.},;
							{1,"Loja"				,Space(2) ,"","",			,If(aParIni==NIL,".T.",".F."),0,.F.}}

Local aRetNF	:= {Space(9),Space(3),Space(6),Space(2)}

Local aParPR	:=	{	{1,"Produto"					,Space(15),"","","SB1"	,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetPR   := {Space(15)}

Local aParOP	:=	{	{1,"OP"				,Space(13),"","","SC2"	,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetOP   := {Space(13)}

Local aParImp  := {	{1,"Local de Impressão"	,Space(06),"","","CB5"	,".T.",0,.F.}}
Local aRetImp  := {Space(6)}

Local aParam 	:= {}

Local nx:= 1

Private cCondSF1 := ' 1234567890'  // variavel utilizada na consulta sxb CBW, favor nao remover esta linha
Private oLbx
Private aLbx:={{	.f., Space(15),Space(20),Space(10),Space(10),Space(10),Space(10),Space(20)}}

DEFAULT nOrigem := 1

aParam:={	{"Nota Fiscal"			,aParNF,aRetNF,{|| AWzVNF()}},;
				{"Produto"				,aParPR,aRetPR,{|| AWzVPR()}},;
				{"Ordem de Producao"	,aParOP,aRetOP,{|| AWzVOP()}}}

// criar ponto de entrada aqui

// carrega parametros vindo da funcao pai
If aParIni <> NIL
	For nX := 1 to len(aParIni)
		nTam := len( aParam[nOrigem,3,nX ] )
		aParam[nOrigem,3,nX ] := Padr(aParIni[nX],nTam )
	Next
EndIf

For nx:= 1 to len(aParam)
	aadd(aOrigem,aParam[nX,1])
Next

DEFINE WIZARD oWizard TITLE "Etiqueta de Produto ACD" ;
       HEADER "Rotina de Impressão de etiquetas termica." ;
       MESSAGE "";
       TEXT "Esta rotina tem por objetivo realizar a impressao das etiquetas termicas de identificação de produto no padrão codigo natural/EAN conforme as opcoes disponives a seguir." ;
       NEXT {|| .T.} ;
		 FINISH {|| .T. } ;
       PANEL

   // Primeira etapa
   CREATE PANEL oWizard ;
          HEADER "Informe a origem das informações para impressão" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
 	       NEXT {|| nc:= 0,aeval(aParam,{|| &("oP"+str(++nc,1)):Hide()} ),&("oP"+str(nOrigem,1)+":Show()"),A11WZIniPar(nOrigem,aParIni,aParam) ,.T. } ;
          FINISH {|| .F. } ;
          PANEL

   oPanel := oWizard:GetPanel(2)

   oOrigem := TRadMenu():New(30,10,aOrigem,BSetGet(nOrigem),oPanel,,,,,,,,100,8,,,,.T.)
   If aParIni <> NIL
	   oOrigem:Disable()
	EndIf


   // Segunda etapa
   CREATE PANEL oWizard ;
          HEADER "Preencha as solicitações abaixo para a seleção do produto" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
          NEXT {|| Eval(aParam[nOrigem,4]) } ;
          FINISH {|| .F. } ;
          PANEL

   oPanel := oWizard:GetPanel(3)

	For nx:= 1 to len(aParam)
  		&("oP"+str(nx,1)) := TPanel():New( 028, 072, ,oPanel, , , , , , 120, 20, .F.,.T. )
		&("oP"+str(nx,1)):align:= CONTROL_ALIGN_ALLCLIENT
		ParamBox(aParam[nX,2],"Parâmetros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))
		&("oP"+str(nx,1)):Hide()
	Next

   CREATE PANEL oWizard ;
          HEADER "Parametrização por produto" ;
          MESSAGE "Marque os produtos que deseja imprimir" ;
          BACK {|| .T. } ;
          NEXT {|| VldaLbx()} ;
          FINISH {|| .T. } ;
          PANEL
   oPanel := oWizard:GetPanel(4)
   ListBoxMar(oPanel)

   CREATE PANEL oWizard ;
          HEADER "Parametrização da impressora" ;
          MESSAGE "Informe o Local de Impressão" ;
          BACK {|| .T. } ;
          NEXT {|| Imprime() } ;
          FINISH {|| .T.  } ;
          PANEL
   oPanel := oWizard:GetPanel(5)
   ParamBox(aParImp,"Parâmetros...",aRetImp,,,,,,oPanel)

     CREATE PANEL oWizard ;
          HEADER "Impressão Finalizada" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
          NEXT {|| .T. } ;
          FINISH {|| .T.  } ;
          PANEL



ACTIVATE WIZARD oWizard CENTERED

Return

Static Function A11WZIniPar(nOrigem, aParIni,aParam)
Local nX
If aParIni <> NIL
	For nx:= 1 to len(aParIni)
		&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParIni[ nX ]
	Next
EndIf

For nx:= 1 to len(aParam[nOrigem,3])
	&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParam[nOrigem,3,nX ]
Next
Return .t.

Static Function AWzVNF()
Local	cNota 	:= Padr(MV_PAR01,9)
Local	cSerie	:= Padr(MV_PAR02,3)
Local	cForn 	:= Padr(MV_PAR03,6)
Local cLoja 	:= Padr(MV_PAR04,2)
Local nQE
Local nQVol
Local nResto
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO

If Empty(cNota+cSerie+cForn+cLoja)
  	MsgAlert(" Necessario informar a nota e o fornecedor. ")
 	Return .F.
EndIf
SF1->(DbSetOrder(1))
If ! SF1->(DbSeek(xFilial('SF1')+cNota+cSerie+cForn+cLoja))
  	MsgAlert(" Nota fiscal não encontrada. ")
  	Return .F.
EndIf

aLbx:={}
SD1->(DbSetOrder(1))
SD1->(dbSeek(xFilial('SD1')+cNota+cSerie+cForn+cLoja)	)
While SD1->(!EOF()  .and. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xFilial('SD1')+cNota+cSerie+cForn+cLoja)

	SB1->(dbSeek(xFilial('SB1')+SD1->D1_COD))

	If ! CBImpEti(SB1->B1_COD)
		SD1->(dbSkip()	)
		Loop
	EndIf

	nQE   := CBQEmbI()
	nQE	:= If(Empty(nQE),1,nQE)
	nQVol := Int(SD1->D1_QUANT/nQE)
	nResto  :=SD1->D1_QUANT%nQE
	If nResto >0
	   nQVol++
	EndIf
	SD1->(aadd(aLbx,{.f.,D1_COD,Str(SD1->D1_QUANT,10),Str(nQe,10),Str(nResto,10),Str(nQVol,10),SD1->D1_LOTECTL,Space(20),"SD1",Recno()}))
	SD1->(dbSkip()	)
End
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
oLbx:Refresh()

Return .t.

Static Function AWzVPR()
Local	cProduto := Padr(MV_PAR01,15)
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO

If Empty(cProduto)
  	MsgAlert(" Necessario informar o codigo do produto. ")
  	Return .F.
EndIf

SB1->(DbSetOrder(1))
If ! SB1->(DbSeek(xFilial('SB1')+cProduto))
  	MsgAlert(" Produto não encontrado ")
  	Return .F.
EndIf

If ! CBImpEti(SB1->B1_COD)
  	MsgAlert(" Este Produto está configurado para nao imprimir etiqueta ")
  	Return .F.
EndIf
aLbx:={{	.f., SB1->B1_COD,Space(10),Str(CBQEmbI(),10),Str(0,10),Str(0,10),Space(10),Space(20),"SB1",SB1->(Recno())}}
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
oLbx:Refresh()
Return .t.

Static Function AWzVOP()
Local	cOp		:= Padr(MV_PAR01,13)
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local nQtde
Local nQE
Local nQVol
Local nResto

If Empty(cOP)
  	MsgAlert(" Necessario informar o codigo do ordem de produção. ")
  	Return .F.
EndIf

SC2->(DbSetOrder(1))
If ! SC2->(DbSeek(xFilial('SC2')+cOP))
  	MsgAlert(" Ordem de Produção não encontrado ")
 	Return .F.
EndIf
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
If ! CBImpEti(SB1->B1_COD)
  	MsgAlert(" Este Produto está configurado para nao imprimir etiqueta ")
  	Return .F.
EndIf

nQtde := SC2->(C2_QUANT-C2_QUJE)
nQE   := CBQEmbI()
nQE	:= If(Empty(nQE),1,nQE)
nQVol := Int(SD1->D1_QUANT/nQE)
nResto  :=SD1->D1_QUANT%nQE
If nResto >0
   nQVol++
EndIf


aLbx:={{	.f., SB1->B1_COD,Str(nQtde,10),Str(nQE,10),Str(nResto,10),Str(nQVol,10),Space(10),Space(20),"SC2",SC2->(Recno())}}
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
oLbx:Refresh()

Return .t.

Static Function ListBoxMar(oDlg)
Local oChk1
Local oChk2
Local lChk1 := .F.
Local lChk2 := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oP


@ 10,10 LISTBOX oLbx FIELDS HEADER " ", "Produto", "Qtde do Item","Qtde Emb.","Resto","Qtde Volumes", "Lote", "Serie"  SIZE 230,095 OF oDlg PIXEL ;
        ON dblClick(aLbx[oLbx:nAt,1] := !aLbx[oLbx:nAt,1])

oLbx:SetArray( aLbx )
oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
oLbx:align:= CONTROL_ALIGN_ALLCLIENT

oP := TPanel():New( 028, 072, ,oDlg, , , , , , 120, 20, .F.,.T. )
oP:align:= CONTROL_ALIGN_BOTTOM

@ 5,010  BUTTON "Alterar"	 SIZE 55,11 ACTION FormProd(1) OF oP PIXEL
@ 5,080  BUTTON "Copiar"	 SIZE 55,11 ACTION FormProd(2) OF oP PIXEL
@ 5,160 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 	PIXEL OF oP ON CLICK( aEval( aLbx, {|x| x[1] := lChk1 } ),oLbx:Refresh() )
@ 5,230 CHECKBOX oChk2 VAR lChk2 PROMPT "Iverter a seleção" 	SIZE 70,7 	PIXEL OF oP ON CLICK( aEval( aLbx, {|x| x[1] := !x[1] } ), oLbx:Refresh() )

Return

Static Function FormProd(nopcao)
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local aRet := {}
Local aParamBox := {}
Local cProduto := aLbx[oLbx:nAt,2]
Local nQtde    := Val(aLbx[oLbx:nAt,3])
Local nQEmb    := Val(aLbx[oLbx:nAt,4])
Local cQtde    := aLbx[oLbx:nAt,3]
Local cQEmb		:= aLbx[oLbx:nAt,4]

Local nQVol		:= 0
Local nResto	:= 0
Local cLote		:= aLbx[oLbx:nAt,7]
Local cNumSer	:= aLbx[oLbx:nAt,8]
Local nAt		:= oLbx:nAt

Local nMv
Local aMvPar:={}
Local lRastro :=Rastro(cProduto)
Local lEndere :=Localiza(cProduto)

For nMv := 1 To 40
     aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
Next nMv


aParamBox :={	{1,"Produto"				,cProduto	,"","",""	,".F.",0,.F.},;
					{1,"Quantidade"			,cQtde 		,"","99999999",""	,".T.",0,.F.},;
					{1,"Qtd por Embalagem"	,cQEmb 		,"","99999999",""	,".T.",0,.t.},;
					{1,"Lote"					,cLote 		,"","",""	,If(lRastro,".T.",".F."),0,.F.},;
					{1,"Serie"					,cNumSer 	,"","",""	,If(lEndere,".T.",".F."),0,.F.}}



If ! ParamBox(aParamBox,"Parametros",@aRet,,,,,,,,.f.)
	For nMv := 1 To Len( aMvPar )
  	  &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
	oLbx:Refresh()
	Return
EndIf

nQtde 	:= val(aRet[2])
If Empty(nQtde)
	If nOpcao == 2
		MsgAlert("Para a copia a quantidade não pode estar em branco!")
	EndIf
	If MsgYesNo("Quantidade informada igual a zero, deseja excluir esta linha?")
	   aDel(aLbx,nAt)
	   aSize(aLbx,len(albx)-1)
   EndIf
Else
	nQEmb    := val(aRet[3])
	cLote 	:= aRet[4]
	cNumSer 	:= aRet[5]

	nQVol		:= Int(nQtde/nQEmb)
	nResto	:= nQtde%nQEmb
	If nResto >0
	   nQVol++
	EndIf

	If nOpcao == 2
		aadd(aLbx,aClone(aLbx[nAt]))
		nAt := Len(aLbx)
	EndIf
	aLbx[nAt,3] := str(nQtde,10)
	aLbx[nAt,4] := str(nQEmb,10)
	aLbx[nAt,5] := str(nResto,10)
	aLbx[nAt,6] := str(nQVol,10)

	aLbx[nAt,7] := cLote
	aLbx[nAt,8] := cNumSer

EndIf

oLbx:SetArray( aLbx )
oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8]}}
oLbx:Refresh()

For nMv := 1 To Len( aMvPar )
    &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
Next nMv
Return .t.

Static Function VldaLbx()
Local nx
SB1->(DbSetOrder(1))
For nX := 1 to Len(aLbx)
	If aLbx[nx,1]
		exit
	EndIf
Next
If nX > len(aLbx)
	MsgAlert("Necessario marcar pelo menos um item para imprimir!")
	Return .f.
EndIf
Return .t.

Static Function Imprime()
Local cLocImp := MV_PAR01
Local nX
Local cProduto
Local nQtde
Local nQE
Local nQVol
Local nResto
Local cAliasOri
Local nRecno
Local cLote
Local cNumSerie

If ! CBYesNo("Confirma a Impressao de Etiquetas","Aviso")
	Return .f.
EndIf

If ! CB5SetImp(cLocImp)
	MsgAlert("Local de Impressão "+cLocImp+" nao Encontrado!")
	Return .f.
Endif


SB1->(DbSetOrder(1))
For nX := 1 to Len(aLbx)
	If ! aLbx[nx,1]
		Loop
	EndIf
	cProduto:= aLbx[nx,2]
	nQtde := val(aLbx[nx,3])
	If Empty(nQtde)
		Loop
	EndIf
	nQE	:= val(aLbx[nx,4])
	nResto:= val(aLbx[nx,5])
	nQVol := val(aLbx[nx,6])
	If nResto > 0
		nQVol--
	EndIf
	cLote := aLbx[nx,7]
	cNumSerie:=aLbx[nx,8]
	cAliasOri:=aLbx[nx,9]
	nRecno:=aLbx[nx,10]

	(cAliasOri)->(DbGoto(nRecno)) //posiciona na tabela de origem da informação

	SB1->(DbSeek(xFilial('SB1')+cProduto))
ExecBlock("Img05OFI",,,{nQE,,,nQVol,,,,,,,,cLote,Space(6),,,,,cNumSerie})
	//ExecBlock("IMG01",,,{nQE,,,nQVol,,,,,,,,cLote,Space(6),,,,,cNumSerie})
	If nResto > 0
		//ExecBlock("IMG01",,,{nResto,,,1,,,,,,,,cLote,Space(6),,,,,cNumSerie})
ExecBlock("Img05OFI",,,{nResto,,,1,,,,,,,,cLote,Space(6),,,,,cNumSerie})
	EndIf
Next
MSCBCLOSEPRINTER()

Return .t.