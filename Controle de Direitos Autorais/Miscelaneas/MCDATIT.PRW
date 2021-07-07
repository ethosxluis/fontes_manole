#INCLUDE"RWMAKE.CH"
#INCLUDE"TOPCONN.CH"
USER FUNCTION MCDATIT()
LOCAL CQUERY := ""
PRIVATE aRecAH6	:=	{}  
PRIVATE cNumero := CD040NoDoc()     
private cnaturez := "20020"

CQUERY := " SELECT "
CQUERY += " AH6_FORNEC, "
CQUERY += " AH6_LOJAFO, "
CQUERY += " AH6_DTPRES, "
CQUERY += " SUM(AH6_VALORD) nTotForne, "
CQUERY += " SUM(AH6_DESCIR) nValIRRF "
CQUERY += " FROM "+RETSQLNAME("AH6")+" "
CQUERY += " WHERE AH6_DTPRES = '"+DTOS(GETMV("MV_CDAFECH"))+"' AND D_E_L_E_T_ <> '*' "
CQUERY += " AND AH6_FORNEC||AH6_LOJAFO NOT IN "
CQUERY += " (SELECT E2_FORNECE||E2_LOJA FROM SE2010 WHERE E2_PREFIXO = 'RYI' AND E2_EMISSAO = '"+DTOS(GETMV("MV_CDAFECH"))+"' AND D_E_L_E_T_ <> '*' AND E2_TIPO = 'RC') "
CQUERY += " AND AH6_VALORD <> 0 "
CQUERY += " GROUP BY "
CQUERY += " AH6_FORNEC, "
CQUERY += " AH6_LOJAFO, " 
CQUERY += " AH6_DTPRES "
CQUERY += " ORDER BY AH6_FORNEC, AH6_LOJAFO "         

IF SELECT("TRBA")<>0
DBSELECTAREA("TRBA")
TRBA->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS TRBA

DBSELECTAREA("TRBA")
TRBA->(DBGOTOP())

WHILE !TRBA->(EOF())
                
//nTotForne,nValIRRF,AH1->AH1_FORNEC,AH1->AH1_LOJAFO,nMoedTit,AH1->AH1_PRZOPA,"CDAA040",dPerFim,aRecAH6
CD040CtPag(nTotForne,nValIRRF,TRBA->AH6_FORNEC,TRBA->AH6_LOJAFO,1,"002","CDAA040",GETMV("MV_CDAFECH"),aRecAH6)
   
TRBA->(DBSKIP())
END


RETURN()





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CD040CtPag³ Autor ³ Elizabeth A. Eguni    ³ Data ³ 13/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera titulo de prestacao de D.A. no contas a pagar.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CD040CtPag(ExpN1,ExpN2,ExpC1,ExpC2,ExpN3,ExpC3,ExpC4)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 := valor do titulo a ser gerado                      ³±±
±±³          ³ ExpN2 := valor do IRRF do titulo                           ³±±
±±³          ³ ExpC1 := codigo do fornecedor                              ³±±
±±³          ³ ExpC2 := loja do fornecedor                                ³±±
±±³          ³ ExpN3 := numero da moeda do titulo                         ³±±
±±³          ³ ExpC3 := condicao de pagamento                             ³±±
±±³          ³ ExpC4 := nome do programa origem                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CDAA040 e CDAA020                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CD040CtPag(nValAcum,nValIRRF,cCodForn,cLojaFor,nMoedTit,cCodPraz,cPrograma,dDataTit,aRecAH6)
Local nI		:=	0	
Local aArea		:=	GetArea()	
Local cHistorico:=	""
Local aGrvSe2	:=	{}  


Private lMsErroAuto := .F.

private aRecAH6	:=	{}

aVenc := Condicao((nValAcum),cCodPraz,,dDataTit)

SA2 -> ( dbSeek( xFilial("SA2") + cCodForn + cLojaFor ) )

cHistorico := Iif(cPrograma=="CDAA020","Adiantamento","Pagamento de D.A.")

For nI := 1 To Len(aVenc)
	aGrvSe2	:=	{	{ "E2_FILIAL"	, xFilial("SE2")											, Nil },;
						{ "E2_PREFIXO"	, Iif(SA2->A2_TIPO=="X","RYE","RYI")				, Nil },;
						{ "E2_NUM"		, cNumero													, Nil },;
						{ "E2_TIPO"		, "RC"													, Nil },;
						{ "E2_NATUREZ"	, IIF(!EMPTY(SA2->A2_NATUREZ),SA2->A2_NATUREZ,cNaturez)		, Nil },;
						{ "E2_PORTADO"	, SA2->A2_BANCO				   						, Nil },;
						{ "E2_FORNECE"	, cCodForn				 									, Nil },;
						{ "E2_LOJA"   	, cLojaFor													, Nil },;
						{ "E2_NOMFOR"	, SA2->A2_NREDUZ 											, Nil },;
						{ "E2_EMISSAO"	, dDataTit													, Nil },;
						{ "E2_VENCTO"	, aVenc[nI][1]												, Nil },;
						{ "E2_VENCORI"	, aVenc[nI][1]												, Nil },;
						{ "E2_VENCREA"	, DataValida(aVenc[nI][1])								, Nil },;
						{ "E2_VALOR"  	, aVenc[nI][2]												, Nil },;
						{ "E2_SALDO"  	, aVenc[nI][2]												, Nil },;
						{ "E2_BCOPAG" 	, ""					     					, Nil },;
						{ "E2_EMIS1"  	, dDataBase													, Nil },;
						{ "E2_MOEDA"	, Iif(ValType(nMoedTit)=="N",nMoedTit,Val(nMoedTit))		, Nil },;
						{ "E2_VLCRUZ" 	, xMoeda((aVenc[nI][2]-nValIRRF),nMoedTit,1,dDataTit)	, Nil },;
						{ "E2_HIST"   	, cHistorico												, Nil },;
						{ "E2_PARCELA"	, StrZero(nI, Len(SE2->E2_PARCELA))	 			, Nil },; 			
						{ "E2_ORIGEM" 	, cPrograma											  		, Nil },;
						{ "E2_DIRF" 	, "1"											  		, Nil },; 
						{ "E2_CODRET" 	, IIF(SA2->A2_TIPO=="J","1708","0588")				  		, Nil },;
						{ "E2_IRRF" 	, nValIRRF											  		, Nil }	}
 
	lMsErroAuto := .F.
	MsExecAuto({ | a,b,c | Fina050(a,b,c) },aGrvSe2,,3)

Next

cNumero := StrZero(Val(cNumero)+1,TamSX3("F2_DOC")[1])

RestArea(aArea)
Return(SE2->E2_PREFIXO + SE2->E2_NUM)                                  


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CD040NoDoc³ Autor ³ Claudinei M. Benzi    ³ Data ³ 11.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Recebe o proximo numero do contas a pagar com o prefixo de ³±±
±±³          ³ royalty (RYI).                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CDAA040                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CD040NoDoc()
	Local oDlg,cCadastro := "Titulo" ,cVarQ:="  ",oQual //"Titulo"
	Local oOk 		:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo 		:= LoadBitmap( GetResources(), "LBNO" )
	Local aTitRoy   := {}, nOPca := 0
	PRIVATE lSX5Troca := .F.
	PRIVATE cSerie := "RYI"
	
	vNumero :=""
	dbSelectArea("SX5")
	dbSeek( xFilial()+GetMv("MV_CDANUME"))
	While xFilial()+GetMv("MV_CDANUME") == X5_FILIAL+X5_TABELA
		If SX5->X5_DESCRI = "*"
			dbSkip()
			Loop
		Endif
		AADD(aTitRoy,{Trim(X5_CHAVE),StrZero(Val(X5_DESCRI),TamSX3("F2_DOC")[1])})
		dbSkip()
	End
	
	If Len(aTitRoy) == 0
		Help(" ",1,"CD040FLOCK")
		Return(.T.)
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 10,30 To 19,68 OF oMainWnd
//	@ .5,.80 LISTBOX oQual VAR cVarQ Fields HEADER OemToAnsi(STR0012),OemToAnsi(cCadastro) SIZE 130,42 ON DBLCLICK (aTitRoy:=aSX5Troca(oQual:nAt,aTitRoy,20),oQual:Refresh()) NOSCROLL //"Serie"
	@ .5,.80 LISTBOX oQual VAR cVarQ Fields HEADER "Serie" ,OemToAnsi(cCadastro) SIZE 130,42  NOSCROLL //"Serie"
	oQual:SetArray(aTitRoy)
	oQual:bLine := { || {aTitRoy[oQual:nAT,1],aTitRoy[oQual:nAT,2]}}
	DEFINE SBUTTON FROM 51,108		TYPE 1 ACTION (cNumero := aTitRoy[oQual:nAt,2], ;
	cSerie := aTitRoy[oQual:nAt,1], ;
	nOpca := 1,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
	IF nOpca == 0
		Return (.t.)
	Endif
	
	If !lSX5Troca
		vNumero := cNumero
	Endif
	If Len(aTitRoy) == 0
		Help(" ",1,"CD040FLOCK")
		Return(.T.)
	Endif
	
	dbSeek( xFilial()+GetMv("MV_CDANUME") + cSerie )
	nRegx5:=Recno()
	RecLock("SX5",.F.)
	dbSeek(xFilial()+GetMv("MV_CDANUME") + cSerie )
	If Found() .And. Val(SubStr(X5_DESCRI,1,Len(cNumero))) != Val(vNumero) .Or. X5_DESCRI == "*"
		Help(" ",1,"OUTRAEST")
		MsUnlock()
		Return(.T.)
	Endif
	MsUnLock()
Return cNumero

