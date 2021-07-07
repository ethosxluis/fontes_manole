#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CDAR020G  ³ Autor ³ EVERALDO S. GALLO    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Gerencial de Direitos Autorais - CUSTOM MANOLE   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CDAR020G()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACDA - Controle de Direitos Autorais                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CDAR020G()

Local nLin       := 80
Local cDesc1     := "Emissao da Prestacao de Contas de Direitos Autorais"
Local cDesc2     := "Serao solicitados os parametros necessarios para a emissao"
Local cDesc3     := "do relatorio."

PRIVATE nLastKey   := 0
PRIVATE Tamanho    := "P"
PRIVATE Titulo     :="Prest. de Contas / Royalties Statement"
PRIVATE cString    := "AH4"
PRIVATE aOrd       := {}
PRIVATE aReturn    := {"Zebrado",1,"Administracao",2,2,1,"",1} //"Zebrado"###"Administracao"
PRIVATE cPerg      := "CDR0200001"
PRIVATE wnrel      := "CDAR020"
PRIVATE NomeProg   := "CDAR020"
PRIVATE m_pag      := 1
PRIVATE lEnd       := .F.
PRIVATE cSimbMda := "R$ "
PRIVATE _xValort := 0
/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis utilizadas para parametros                         ³
³ mv_par01    // Periodo da Prestacao de Contas MM/AA          ³
³ mv_par02    // Fornecedor Inicial                            ³
³ mv_par03    // Fornecedor Final                              ³
³ mv_par04    // Produto Inicial                               ³
³ mv_par05    // Produto Final                                 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_FcriaSx1()

Pergunte("CDR020",.F.)

dbSelectArea("AH4")
dbSetOrder(4)

dbSelectArea("AH5")
dbSetOrder(1)

dbSelectArea("AH6")
dbSetOrder(1)

dbSelectArea("AH7")
dbSetOrder(1)

dbSelectArea("AH1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

Pergunte(cPerg,.f. )

nOpc 	:= 0
aSay 	:= {}
aButton := {}

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( Titulo, aSay, aButton )

If nOpc <> 1
	Return
EndIf

RptStatus({|| CD020Imp(@lEnd,wnrel,cString,NomeProg,Titulo)},Titulo)

Return (.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CD020Imp ³ Autor ³ Cristiano G. Cunha    ³ Data ³ 10/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CDAR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CD020Imp(lEnd,wnrel,cString,NomeProg,Titulo)

cbTxt       := SPACE(10)
Limite      := 80
cbCont      := 0
cCondFiltr  := aReturn[7]
nLin        := 80

_dVencDA := CtoD("")

SetRegua(RecCount())

dbSelectArea("AH4")
Set Filter to

CD020Prest()

dbSelectArea("AH4")
Set Filter To
dbSetOrder(1)

dbSelectArea("AH7")
dbSetOrder(1)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CD020Prest³ Autor ³ Cristiano G. Cunha    ³  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Prestacao de Contas de Direito Autoral        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CDAR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CD020Prest()
Local i := 0

_afaixa := {}
Cabec1 := ""
Cabec2 := ""

nTipo  := IIf(aReturn[4] == 1,15,18)
dbSelectArea("AH4")

dPeriodo := LastDay(CTOD("01/" + StrZero(Month(Mv_Par07),2) + "/" + Str(Year(Mv_Par07))))
aTabela := CD040AbrIR()

SetRegua(RecCount())

dbSelectArea("AH5")
dbSetOrder(3)

oPrint:=TMSPrinter():New("Prestacao de Contas")
oPrint:SetPortrait()  				//** Para Imprimir em Formato Paisagem

cChave := " "


_cquery := "SELECT AH4_PRODUT,AH4_FORNEC,AH4_LOJAFO,AH4_DTPRES,SUM(AH4_QTDACU) AS H4_QUANT,SUM(AH4_VALACU) AS H4_VENDAS,SUM(AH4_VALORD) AS H4_DA, MIN(AH4_DATCAL)  AS H4_DTCAL"
_cquery += " FROM "+ RETSQLNAME("AH4")
_cquery += " WHERE AH4_PRODUT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cquery += " AND AH4_FORNEC   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR03+"' "
_cquery += " AND AH4_LOJAFO    BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR04+"' "
_cquery += " AND AH4_DTPRES    <=  '"+DTOS(MV_PAR07)+"'  "
_cquery += " AND AH4_FILIAL    =   '"+XFILIAL("AH4")+"'  "
_cquery += " AND "+ RETSQLNAME("AH4")+".D_E_L_E_T_ <> '*'"
_cquery += " GROUP BY AH4_PRODUT,AH4_FORNEC,AH4_LOJAFO,AH4_DTPRES"
_cquery += " ORDER BY AH4_PRODUT,AH4_FORNEC,AH4_LOJAFO,AH4_DTPRES"

TCQUERY _cQuery NEW ALIAS "TH4"

TCSETFIELD("TH4","H4_VENDAS"    ,"N",14,2)
TCSETFIELD("TH4","H4_QUANT"     ,"N",14,2)
TCSETFIELD("TH4","H4_DA"        ,"N",14,2)
TCSETFIELD("TH4","AH4_DTPRES"   ,"D",08,0)
TCSETFIELD("TH4","H4_DTCAL"     ,"D",08,0)

DbSelectArea("TH4")
DBGOTOP()
_nRec := 0
DbEval({|| _nRec++  })
DBGOTOP()

if _nRec == 0
	Msgstop("Nada a Listar")
else
	Do While !TH4->(Eof())
		
		cForneced := TH4->AH4_FORNEC + TH4->AH4_LOJAFO
		
		Do While !TH4->(Eof()) .And. cForneced == TH4->AH4_FORNEC + TH4->AH4_LOJAFO
			
			_aDetalhe := {}
			_aPags    := {{"",0,0,0,0}}
			
			nTotGer   := 0
			lImpForne := .F.
			m_pag     := 1
			
			dbSelectArea("AH1")
			dbSeek(xFilial()+=TH4->AH4_PRODUT+TH4->AH4_FORNEC+TH4->AH4_LOJAFO)
			cMdaRoy := AllTrim(Str(AH1->AH1_MOEDRO,2))
			if cMdaRoy == '0'
				cMdaRoy := '1'
			endif
			
			cMdaOri := IIf(AH1->AH1_MOEDA == "1","1",GetMv("MV_MCUSTO"))
			
			dbSelectArea("SA2")
			dbSeek(xFilial("SA2")+cForneced)
			
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+TH4->AH4_PRODUT)
			
			dbSelectArea("AH3")
			dbSeek(xFilial("AH3")+TH4->AH4_PRODUT+cForneced)
		
				
			if eof()
				_adto := {{"",0}}
				_nsaldo := 0
			else
				_adto := {{"Em " + dtoc(ah3_data),transform(ah3->ah3_valor,'@E 9999,999,999.99') }}
				aadd(_aDetalhe,{"Advance ", "" ,"" ,""   , "",ah3->ah3_valor })
				_nsaldo := ah3->ah3_valor
			endif
		
			dbSelectArea("AH2")        
			dbSetOrder(2)
			dbSeek(xFilial("AH2")+AH1->AH1_CONTRA)
			
			if eof()
				_afaixa := {{""}}
			else                                                                            
				Do while !eof() .and. AH1->AH1_CONTRA == AH2->AH2_CONTRA
			 		aadd(_afaixa,{alltrim(transform(ah2->ah2_percre,'@E 99.99')) + '% -  From ' + alltrim(transform(ah2->ah2_fxinic,'@E 9999,999'))+ ' To ' + alltrim(transform(ah2->ah2_fxfina,'@E 9999,999')) })
		            dbskip()
		        Enddo    
			endif
			
			dbSelectArea("TH4")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Emite a Prestacao de Contas Aglutinada por Autor.            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			Do While !TH4->(Eof()) .And. cForneced == TH4->AH4_FORNEC + TH4->AH4_LOJAFO .AND. SB1->B1_COD == TH4->AH4_PRODUT
				
				IncRegua()
				If lAbortPrint
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				EndIf
				
				_dVencDA := CtoD("")
				_aVencDA := {}
				
				
				IF AH1->AH1_PERIOD == '12'
					dInicPres:= LastDay(CTOD("01/01" + Str(Year(Mv_Par07))))
				endif
				IF AH1->AH1_PERIOD <> '12'
					dInicPres:= CdDtInPres(TH4->AH4_PRODUT,TH4->AH4_FORNEC,TH4->AH4_LOJAFO,TH4->AH4_DTPRES)
				ENDIF
				
				_nsaldo -= TH4->H4_DA
				aadd(_aDetalhe,{dtoc(dInicPres) + " - " + dtoc(TH4->AH4_DTPRES), TH4->H4_QUANT,TH4->H4_VENDAS/TH4->H4_QUANT ,TH4->H4_VENDAS,TH4->H4_DA,_nsaldo })
				
				dbSelectArea("TH4")
				dbSkip()
				
			Enddo
			
			If SA2->A2_TIPO == "F" .And. nTotGer > 0    // Pessoa Fisica
				nValIRRF   := _calc_Irrf(nAcValDA)
				nValIRRF := xMoeda(nValIRRF,Val(cMdaOri),Val(cMdaRoy),TH4->AH4_DTPRES)
			Else
				nValIRRF := 0
			EndIf
			
			If SA2->A2_TXTRIBU > 0 .And. nTotGer > 0
				nValIRRF := nValIRRF + Round(nTotGer * SA2->A2_TXTRIBU / 100,2)
			EndIf
			
			lImpForne := .T.
			
			_Prt_PCDA(oPrint)
			
		Enddo
		
		
	Enddo
	
	if mv_par09 = 1
		cStartPath 	:= GetSrvProfString("Startpath","")
		cBmpName := "PC"+SA2->A2_COD
		oPrint:SaveAllAsJpeg(cStartPath+cBmpName,1100,1600,140)
		
		oPrint:Preview()
		
		lEnvMail := .T.
		cEmailFor := sa2->A2_email
		IF lEnvMail
			nOpceml := 0
			//PmsGrafMail(oPrint,"Pedido de Compras: "+MV_PAR01,{"Pedido de Compras: "+MV_PAR01},{}) //aSaldosM)
			@ 096,042 TO 323,505 DIALOG oDlg2 TITLE OemToAnsi("Email de Pretacao de Contas - DA")
			@ 008,010 TO 084,222
			@ 018,020 SAY "E-mail"
			@ 018,040 get  cEmailFor
			
			
			@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpceml := 1, oDlg2:End() } )
			@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpceml := 0, oDlg2:End() } )
			ACTIVATE DIALOG oDlg2 CENTERED
			
			if nOpceml == 1
				Processa({|lEnd| BrEnvMail(oPrint,"Prestacao de Contas - Direitos Autorais " ,{"Direitos Autorais "},cEmailFor,"",{},10)},titulo)
				//-Processa({|lEnd| BrEnvMail(oPrint,"Pedido de Compras: "+MV_PAR01,             {"Pedido de Compras: "+MV_PAR01    },cEmailFor,"",{},10)},titulo)
				
			endif
			
		Endif
		
		lPedido := .F.
		
		oPrint:end()
		
	endif
	
Endif

if mv_par09 = 2
	
	oPrint:Preview()
	oPrint:end()
Endif


DbSelectArea("TH4")
Dbclosearea("TH4")

Return (.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CDAR020A  ºAutor  ³Microsiga           º Data ³  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function  _Prt_PCDA( oGraphic )

Local lBmp := !( oGraphic == NIL )

//PRIVATE	oPrint		:= ""
PRIVATE	T			:= 0
PRIVATE nQtdImp		:= 1

PRIVATE  aDadosEmp 	:= {SM0->M0_NOMECOM						,; 	//Nome da Empresa
AllTrim(SM0->M0_ENDCOB)				,; 	//Endereco
AllTrim(SM0->M0_BAIRCOB)			,; 	//Bairro
AllTrim(SM0->M0_CIDCOB)				,; 	//Cidade
ALLTRIM(SM0->M0_ESTCOB)				,; 	//UF
Substr(SM0->M0_CEPCOB,1,5) + "-" +	 ;
Substr(SM0->M0_CEPCOB,6,3)			,;	//CEP
AllTrim(SM0->M0_TEL)     			,;	//Telefone
AllTrim(SM0->M0_FAX)     			,;	//Fax
Substr(SM0->M0_CGC,1,2) + "." +     ;	//CGC
Substr(SM0->M0_CGC,3,3) + "." +     ;
Substr(SM0->M0_CGC,6,3) + "/" +     ;
Substr(SM0->M0_CGC,9,4) + "-" +     ;
Substr(SM0->M0_CGC,13,2)			,;
Substr(SM0->M0_INSC,1,3) + "." +	 ;	//I.E
Substr(SM0->M0_INSC,4,3) + "." +	 ;
Substr(SM0->M0_INSC,7,3) + "." +	 ;
Substr(SM0->M0_INSC,10,3)}
// +------------------------------+
// |    Definicao de fontes       |
// +------------------------------+
// nome            	/lar/alt/fromuser/bold/italic/underline/
PRIVATE oFont0	:= TFont():New("Arial"      	  	,07,07,,.F.,,,,,.F.)
PRIVATE oFont	:= TFont():New("Arial"      	  	,06,06,,.F.,,,,,.F.)
PRIVATE oFont1	:= TFont():New("Arial"      	  	,09,08,,.F.,,,,,.F.)
PRIVATE oFont2	:= TFont():New("Arial"      	  	,09,10,,.F.,,,,,.F.) 	//Conteudo dos Campos
PRIVATE oFont3	:= TFont():New("Times New Roman" 	,09,12,,.T.,,,,,.F.) 	//Linha Digitavel
PRIVATE oFont4	:= TFont():New("Arial"       	  	,10,13,,.T.,,,,,.F.) 	//
PRIVATE oFont5	:= TFont():New("Arial"      	  	,09,20,,.T.,,,,,.F.) 	//Titulo Relatorio

//PRIVATE oFont6  := TFont():New("Arial"      ,9,8  ,.T.,.F.,5,.T.,5,.T.,.F.)
PRIVATE oFont7  := TFont():New("Arial"      ,9,10 ,.T.,.T.,5,.T.,5,.T.,.F.)
PRIVATE oFont8  := TFont():New("Arial"      ,9,14 ,.T.,.F.,5,.T.,5,.T.,.F.)
PRIVATE oFont9  := TFont():New("Arial"      ,9,16 ,.T.,.T.,5,.T.,5,.T.,.F.)
PRIVATE oFont10 := TFont():New("Arial"      ,9,18 ,.T.,.T.,5,.T.,5,.T.,.F.)

PRIVATE oFont6 := TFont():New("Courier New"  ,9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
PRIVATE oFont11 := TFont():New("Courier New",10,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
PRIVATE oFont12 := TFont():New("Courier New",12,-14,.T.,.T.,5,.T.,5,.T.,.F.)
PRIVATE oFont13 := TFont():New("Courier New",12,-13,.T.,.F.,5,.T.,5,.T.,.F.)

PRIVATE oFont7c := TFont():New("Courier New",9,10 ,.T.,.T.,5,.T.,5,.T.,.F.)

//mv_par08 = if(SA2->A2_TIPO = 'X' .AND. MV_PAR08 == 2,1,2)



Private _nlimite := 2300

IF MV_PAR08 = 1
	
	Private _aHeader    := {;
	{"Publisher:" 				,SA2->A2_NOME},;
	{"Book:" 					,SB1->B1_DESC },;
	{"Written by:" 				,SB1->B1_XNMAUT},;
	{"Original ISBN:"			,SB1->B1_ISBN},;
	{"Payment type" 			,""},;
	{"Royalties 1st range:" 		,iif(len(_afaixa) >= 1,_afaixa[1,1],"")},;
	{"Royalties 2nd range:" 		,iif(len(_afaixa) >= 2,_afaixa[2,1],"")},;
	{"Royalties 3rd range:" 		,iif(len(_afaixa) >= 3,_afaixa[3,1],"")},;
	{"Quantity:" 				,""},;
	{"Validity:" 				,dtoc(AH1->AH1_DATAFI)},;
	{"Agency" 					,""},;
	{"Porcentagem da agência:" 	,""},;
	{"File archiving:" 			,""},;
	{"Publishing date:" 		,dtoc(sb1->b1_xdtlanc)},;
	{"Printing run" 			,""},;
	{"National ISBN:"			,iif(!empty(SB1->B1_ISBN),SB1->B1_ISBN,SB1->B1_COD) }}
	
	
	Private _aDetail := {;
	{"Period"    		,0150},;
	{"      Unit sold" 	,0600},;
	{"     Unit price"	,0850},;
	{"      Sub-total" 	,1100},;
	{"Total royalties"	,1350},;
	{"        Balance"	,1600},;
	{"Observation"		,1850}}
	
	Private _aFooter := {;
	{"Payment date"			,0150},;
	{"    Payment sum"		,0400},;
	{" Current period"		,0800},;
	{"Dolar quotation"		,1050},;
	{"Other informations"	,1500}}
	
ELSE
	Private _aHeader    := {;
	{"Autor:" 				,SA2->A2_NOME},;
	{"Titulo:" 					,SB1->B1_DESC },;
	{"Codigo ISBN:"		  		,iif(!empty(SB1->B1_ISBN),SB1->B1_ISBN,SB1->B1_COD)},;
	{"Royalties 1a Faixa:" 		,iif(len(_afaixa) >= 1,_afaixa[1,1],"")},;
	{"Royalties 2a Faixa:" 		,iif(len(_afaixa) >= 2,_afaixa[2,1],"")},;
	{"Royalties 3a Faixa:" 		,iif(len(_afaixa) >= 3,_afaixa[3,1],"")},;
	{"Vendas Acumuladas:" 		,""},;
	{"Data de Publicacao:" 		,dtoc(sb1->b1_xdtlanc)},;
	{"Tiragem" 					,""}}
	
	Private _aDetail := {;
	{"Periodo"    		,0150},;
	{"   Qtde Vendida" 	,0600},;
	{"    Preco Medio"	,0850},;
	{"Total de Vendas" 	,1100},;
	{"Total royalties"	,1350},;
	{"          Saldo"	,1600},;
	{"Observacoes"		,1850}}
	
	Private _aFooter := {;
	{"Data Pagamento"	,0150},;
	{"     Valor Pago"	,0400},;
	{"Observacoes"	    ,0700}}
	
ENDIF
PRIVATE _aCabecs 	:= {{"  ",100},{"",600},{""	,800},{"" ,1000},{"",1400},{"" ,1800}}

For nQImp := 1 To nQtdImp
	//oPrint:Setup()         				//** Para Configurar Impressora
	oPrint:StartPage()     				//** Inicia uma Nova Pagina
	
	// impressao do Box e Cabecalho
	
	oPrint:Box(0100,_aCabecs[1,2],3000,_nlimite)   	// Box que circunda a pagina
	
	IF File("logoeman.bmp")
		oPrint:SayBitmap( 115,_aCabecs[1,2]+10,"logoeman.bmp", 600, 175 )
	Else
		oPrint:Say(115,_aCabecs[1,2]+10,aDadosEmp[1],oFont7 )
	Endif
	
	if mv_par08 = 2 // portugues
		oPrint:Say(0150,0900,"DEMONSTRATIVO DE DIREITO AUTORAL",oFont7)
		
	else
		
		oPrint:Say(0150,0900,"Royalties' control",oFont7)
	endif
	
	nlinSum := 220
	FOR T = 1 TO len(_aHeader)
		oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
		if T <= LEN(_aHeader)
			oPrint:Say(nLinSum+5,200,_aHeader[T,1],oFont6)
			oPrint:Say(nLinSum+5,1000,_aHeader[T,2],oFont6)
		endif
		nLinSum := nLinSum + 40
		
	next
	
	nlinSum += 50
	oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
	oPrint:Say(nlinSum+5,0900,if(MV_PAR08 = 1,"Sales report","Relatorio de Vendas"),oFont7)
	
	nlinSum += 50
	oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
	nlinSum += 10
	FOR T := 1 TO len(_aDetail)
		oPrint:Say(nLinSum,_aDetail[t,2],iif(valtype(_aDetail[t,1]) == 'N',TRANSFORM(_aDetail[t,1],'@e 9999,999,999.99'),_aDetail[t,1] ),oFont6)
	Next
	
	nlinSum += 50
	
	oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
	nlinSum += 10
	
	FOR X:= 1 TO len(_aDetalhe)
		
		FOR Y := 1 TO len(_aDetalhe[X])
			
			oPrint:Say(nLinSum,_aDetail[y,2],iif(valtype(_aDetalhe[x,y]) == 'N',TRANSFORM(_aDetalhe[x,y],'@e 9999,999,999.99'),_aDetalhe[x,y] ),oFont6)
			
		Next Y
		nLinSum := nLinSum + 40
		
	Next X
	nlinSum += 100
	
	oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
	oPrint:Say(nlinSum+5,0900,if(MV_PAR08 = 1,"Already paid","Pagamentos Efetuados"),oFont7)
	
	nlinSum += 50
	oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
	nlinSum += 10
	FOR T := 1 TO len(_aFooter)
		oPrint:Say(nLinSum,_aFooter[t,2],_aFooter[t,1],oFont6)
	Next
	
	nlinSum += 50
	
	oPrint:Line(nLinSum,_aCabecs[1,2],nLinSum,_nlimite)
	nlinSum += 10
	
	FOR X := 1 TO len(_adto )
		
		FOR Y := 1 TO len(_adto[X] )
			oPrint:Say(nLinSum,_aFooter[y,2],iif(valtype(_aDto[x,y]) == 'N',TRANSFORM(_aDto[x,y],'@e 9999,999,999.99'),_aDto[x,y] ),oFont6)
		Next Y
		nLinSum := nLinSum + 40
		
	Next X
	nlinSum += 50
	
	oPrint:endpage()
	
	
next
return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CDAR020G  ºAutor  ³Microsiga           º Data ³  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function _Calc_Irrf(nAcValDA)

Local _cArea := getarea()

_cQUERY := "Select sum(AH5_VALORD) AS VALOR_DATOT "
_cQUERY += "FROM "+ RETSQLNAME("AH5")
_cQUERY += " WHERE AH5_FORNEC = '" +TH4->AH4_FORNEC + "' AND "
_cQUERY += " AH5_LOJAFO = '" +TH4->AH4_LOJAFO + "' AND "
_cQUERY += " AH5_DTPRES = '" +DTOS(dPeriodo) + "' AND "
_cQUERY += " D_E_L_E_T_ = ' ' "

TCQUERY _cQuery NEW ALIAS "TRB"

DBSELECTAREA("TRB")
_xValort :=TRB->VALOR_DATOT
_xValor := CD040CalIR(TRB->VALOR_DATOT,aTabela,dPeriodo)
if _xValor >= 10
	_xValor := ( nGerAcValDA * (_xValor / TRB->VALOR_DATOT ))
else
	_xValor :=0
	_xValorT :=0
endif
DBCLOSEAREA("TRB")

restarea(_cArea)

return _xvalor



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BrEnvMail ³ Autor ³ Mauricio de Barros    ³ Data ³ 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de envio do grafico por email.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Equifax                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

Local lOk			:= .F.
Local cMensagem
Local nx			:= 0
Local lBmp := !( oGraphic == NIL )
Local cBmpName, nWidth := 0
Local cError
Local aTabela

Local cMailConta	:= GETMV("MV_RELACNT")  //Conta utilizada p/envio do email
Local cMailServer	:= GETMV("MV_RELSERV")  //Server
Local cMailSenha	:= GETMV("MV_RELPSW") //Password
Local cStartPath 	:= GetSrvProfString("Startpath","")

Private cServer     := AllTrim(GetNewPar("MV_RELSERV"," ")) // "mailhost.average.com.br" //Space(50)
Private cMailConta  := AllTrim(GetNewPar("MV_RELACNT"," ")) //Space(50)
Private cMailSenha  := AllTrim(GetNewPar("MV_RELPSW" ," "))  //Space(50)
Private nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexão
Private lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
Private cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cMailConta)) //Usuário para Autenticação no Servidor de Email
Private cPassAut    := Alltrim(GetMv("MV_RELAPSW",,cMailSenha)) //Senha para Autenticação no Servidor de Email



aTexto   := IIF( aTexto == NIL,{},aTexto )
aTabela  := IIF( aTabela == NIL,{},aTabela)
nEspacos := IIF( nEspacos == NIL, 10, nEspacos )

If lBmp
	cBmpName := "PC"+SA2->A2_COD
Endif


cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
cMensagem += '<HTML><HEAD>'
cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
cMensagem += 'vLink=#551a8b><B>'

cMensagem += "<br>" + "Enviado por " + SM0->M0_NOMECOM + "</br>"
cMensagem += '<BR>&nbsp;</BR>'
cMensagem += "<CENTER>"


For nx := 1 To Len(aTexto)
	cMensagem += aTexto[nx]
Next

nX:= Len(aTexto)
If (nX > 0) .And. (Len(aTabela) > 0)
	For x := 1 to Len(aTabela[nX])
		nWidth += Len(aTabela[nX,x]) + nEspacos
	Next
EndIf

If Len(aTabela) > 1
	cMensagem += '<table border="0" width="' + Str(nWidth, 3) + '%"><tr>'
	For x := 1 to Len(aTabela[nx])
		cMensagem += '<td width="'+ Str(100 / Len(aTabela[nx]),3 ) + '%" bgcolor="#CEE7F7">'
		cMensagem += '<b><h><CENTER>' + aTabela[1,x] + '</CENTER></h></b> </td>'
	Next
	cMensagem += '</tr></table>'
EndIf

For nx := 2 to Len(aTabela)
	cMensagem += '<table border="0" width="' + Str(nWidth, 3) + '%"><tr>'
	
	For x := 1 to Len(aTabela[nx])
		cMensagem += '<td width="'+ Str(100 / Len(aTabela[nx]),3 ) + '%" bgcolor="' + If( Mod(nx,2)==0, '#CEE7F7','#FFFFFF') +  '" >'
		cMensagem += If(x == 1,"<CENTER>",'<p align="right">')+'<h>' + aTabela[nx,x] + '</h>'+If(x == 1,"</CENTER>","")+' </td>'
	Next
	cMensagem += '</tr></table>'
Next
cMensagem += '</B>'
cMensagem += '<BR>&nbsp;</BR>'

If lBmp
	for a:=1 to 1 //oGraphic:npage
		cMensagem += '<p><IMG src="' + cBmpName+"_pag"+alltrim(str(a))+".jpg" + '"></p>'
	next a
EndIf
cMensagem += "</CENTER>"
cMensagem += '</body>'

ProcRegua(8)
/*/
If lBmp
	
	oGraphic:SaveAllAsJpeg(cStartPath+cBmpName,1100,1600,140)
	
EndIf
/*/
IncProc()
IncProc("Conectando servidor...")

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	// Conecta uma vez com o servidor de e-mails
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
	IncProc()
	IncProc()
	IncProc("Enviando e-mail...")
	
	If lOk
		If lAutentica
			If !MailAuth(cMailConta, cMailSenha ) //cUserAut,cPassAut)
				MSGINFO("Falha na Autenticação do Usuário","Atenção")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					MSGINFO("Erro na Desconexão: "+cErrorMsg,"Atenção")//"Erro na Desconexão: "###"Atenção"
				ENDIF
				Return .F.
			EndIf
		EndIf
		If lBmp
			cattach :=''
			for a:=1 to oGraphic:npage
				cattach  += cStartPath + cBmpName+"_pag"+alltrim(str(a))+".jpg,"
			next a
			SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cMensagem  ATTACHMENT cattach RESULT lSendOk
		Else
			SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cMensagem  RESULT lSendOk
		EndIf
		IncProc()
		IncProc()
		IncProc("Desconectando...")
		If !lSendOk
			GET MAIL ERROR cError
			Aviso("1-Erro no envio do e-Mail",cError,{"Fechar"},2)
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Aviso("2-Erro no envio do e-Mail",cError,{"Fechar"},2)
	EndIf
EndIf

If lOk
	DISCONNECT SMTP SERVER
	IncProc()
	IncProc()
	IncProc()
EndIf

Return lOk





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fCriaSx1 ºAutor  ³Everaldo Gallo      º Data ³  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao das perguntas                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fCriaSx1()

DbSelectArea("SX1")
DbSetOrder(1)

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Fornecedor de"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_F3      := "SA2"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Loja de"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_F3      := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Fornecedor Ate"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3      := "SA2"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Loja ate"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3      := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"05",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Produto de"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_F3      := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"06",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Produto Ate"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_F3      := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"07",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Data de Prestacao"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_F3      := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"08",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Linguagem"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_F3      := ""
	SX1->X1_DEF01   := "Ingles"
	SX1->X1_DEF02   := "Portugues"
	MsUnLock()
EndIf



If ! DbSeek(cPerg+"09",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Envia Email? "
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par09"
	SX1->X1_F3      := ""
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "Nao"
	MsUnLock()
EndIf

Return .t.
