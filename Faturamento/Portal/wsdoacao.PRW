#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WSDoacao บAutor  ณ Fontanelli         บ Data ณ  21/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que roda pelo WebService para cadastrar Cliente,  บฑฑ
ฑฑบ          ณ e Pedido de Venda                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSDoacao

// CHROME EXTERNO:  201.87.143.242:7070/u_WSDoacao.apw
// CHROME INTERNO:  10.10.1.4:7070/u_WSDoacao.apw

Local cHtml      := ""
Local wsRET      := ""
Local wsMENSAGEM := ""

Local lContinua  := .F.
Local cCODIGO    := SPACE(6)
Local cLOJA      := SPACE(2)
Local aCabec     := {}
Local aCab       := {}
Local aItem      := {}
Local aItens     := {}
Local cITEM      := "00"

Private wsANO
Private wsSEMESTRE
Private wsCPF
Private wsNOME
Private wsREDUZIDO
Private wsIBGE
Private wsLOGRADOURO
Private wsESTADO
Private wsBAIRRO
Private wsCEP
Private wsRG
Private wsDDD
Private wsTELEFONE
Private wsMAIL
Private wsNASCIMENTO
Private wsSEXO
Private wsAISBN
Private wsBISBN

Prepare Environment Empresa "01" Filial "01"

WEB EXTENDED INIT cHtml

conout("Iniciado processo WSDoacao " + DtoC(Date()) + " - " + Time() + " ---")

wsCPF		:= If(ValType(HttpPost->CPF) == "U",SPACE(11),HttpPost->CPF)
wsANO 		:= If(ValType(HttpPost->ANO) == "U",SPACE(4),HttpPost->ANO)
wsSEMESTRE 	:= If(ValType(HttpPost->SEMESTRE) == "U",SPACE(1),HttpPost->SEMESTRE)
wsNOME		:= If(ValType(HttpPost->NOME) == "U",SPACE(70),HttpPost->NOME)
wsREDUZIDO	:= If(ValType(HttpPost->REDUZIDO) == "U",SPACE(20),HttpPost->REDUZIDO)
wsIBGE		:= If(ValType(HttpPost->IBGE) == "U",SPACE(5),HttpPost->IBGE)
wsLOGRADOURO:= If(ValType(HttpPost->LOGRADOURO) == "U",SPACE(50),HttpPost->LOGRADOURO)
wsESTADO	:= If(ValType(HttpPost->ESTADO) == "U",SPACE(5),HttpPost->ESTADO)
wsBAIRRO	:= If(ValType(HttpPost->BAIRRO) == "U",SPACE(30),HttpPost->BAIRRO)
wsCEP		:= If(ValType(HttpPost->CEP) == "U",SPACE(8),HttpPost->CEP)
wsRG		:= If(ValType(HttpPost->RG) == "U",SPACE(15),HttpPost->RG)
wsDDD		:= If(ValType(HttpPost->DDD) == "U",SPACE(3),HttpPost->DDD)
wsTELEFONE	:= If(ValType(HttpPost->TELEFONE) == "U",SPACE(15),HttpPost->TELEFONE)
wsMAIL		:= If(ValType(HttpPost->MAIL) == "U",SPACE(60),HttpPost->MAIL)
wsNASCIMENTO:= If(ValType(HttpPost->NASCIMENTO) == "U",SPACE(8),HttpPost->NASCIMENTO)
wsSEXO		:= If(ValType(HttpPost->SEXO) == "U",SPACE(1),HttpPost->SEXO)
wsAISBN		:= If(ValType(HttpPost->AISBN) == "U",SPACE(30),HttpPost->AISBN)
wsBISBN     := If(ValType(HttpPost->BISBN) == "U",SPACE(30),HttpPost->BISBN)

conOut("wsCPF: ["+If(ValType(HttpPost->CPF) == "U",SPACE(11),HttpPost->CPF)+"]")
conOut("wsANO: ["+If(ValType(HttpPost->ANO) == "U",SPACE(4),HttpPost->ANO)+"]")
conOut("wsSEMESTRE: ["+If(ValType(HttpPost->SEMESTRE) == "U",SPACE(1),HttpPost->SEMESTRE)+"]")
conOut("wsNOME: ["+If(ValType(HttpPost->NOME) == "U",SPACE(70),HttpPost->NOME)+"]")
conOut("wsREDUZIDO: ["+If(ValType(HttpPost->REDUZIDO) == "U",SPACE(20),HttpPost->REDUZIDO)+"]")
conOut("wsIBGE: ["+If(ValType(HttpPost->IBGE) == "U",SPACE(5),HttpPost->IBGE)+"]")
conOut("wsLOGRADOURO: ["+If(ValType(HttpPost->LOGRADOURO) == "U",SPACE(50),HttpPost->LOGRADOURO)+"]")
conOut("wsESTADO: ["+If(ValType(HttpPost->ESTADO) == "U",SPACE(5),HttpPost->ESTADO)+"]")
conOut("wsBAIRRO: ["+If(ValType(HttpPost->BAIRRO) == "U",SPACE(30),HttpPost->BAIRRO)+"]")
conOut("wsCEP: ["+If(ValType(HttpPost->CEP) == "U",SPACE(8),HttpPost->CEP)+"]")
conOut("wsRG: ["+If(ValType(HttpPost->RG) == "U",SPACE(15),HttpPost->RG)+"]")
conOut("wsDDD: ["+If(ValType(HttpPost->DDD) == "U",SPACE(3),HttpPost->DDD)+"]")
conOut("wsTELEFONE: ["+If(ValType(HttpPost->TELEFONE) == "U",SPACE(15),HttpPost->TELEFONE)+"]")
conOut("wsMAIL: ["+If(ValType(HttpPost->MAIL) == "U",SPACE(60),HttpPost->MAIL)+"]")
conOut("wsNASCIMENTO: ["+If(ValType(HttpPost->NASCIMENTO) == "U",SPACE(8),HttpPost->NASCIMENTO)+"]")
conOut("wsSEXO: ["+If(ValType(HttpPost->SEXO) == "U",SPACE(1),HttpPost->SEXO)+"]")
conOut("wsAISBN: ["+If(ValType(HttpPost->AISBN) == "U",SPACE(30),HttpPost->AISBN)+"]")
conOut("wsBISBN: ["+If(ValType(HttpPost->BISBN) == "U",SPACE(30),HttpPost->BISBN)+"]")

lContinua := .F.

DbSelectArea("SA1")
DbSetOrder(3) // A1_FILIAL+A1_CGC
if DbSeek(xFilial("SA1")+wsCPF)

	cCODIGO   := SA1->A1_COD
	cLOJA     := SA1->A1_LOJA

	RecLock( "SA1", .F. )

	SA1->A1_NOME     := SUBSTR(wsNOME,1,70)
	SA1->A1_NREDUZ   := SUBSTR(wsREDUZIDO,1,20)
	SA1->A1_END      := SUBSTR(wsLOGRADOURO,1,80)
	SA1->A1_EST      := SUBSTR(wsESTADO,1,2)
	SA1->A1_COD_MUN  := SUBSTR(wsIBGE,1,5)
	SA1->A1_MUN      := POSICIONE("CC2",1,XFILIAL("CC2")+SUBSTR(wsESTADO,1,2)+SUBSTR(wsIBGE,1,5),"CC2->CC2_MUN")
	SA1->A1_BAIRRO   := SUBSTR(wsBAIRRO,1,30)
	SA1->A1_CEP 	 := SUBSTR(wsCEP,1,8)

	SA1->A1_ENDCOB   := SUBSTR(wsLOGRADOURO,1,80)
	SA1->A1_MUNC     := POSICIONE("CC2",1,XFILIAL("CC2")+SUBSTR(wsESTADO,1,2)+SUBSTR(wsIBGE,1,5),"CC2->CC2_MUN")
	SA1->A1_ESTC     := SUBSTR(wsESTADO,1,2)
	SA1->A1_CEPC     := SUBSTR(wsCEP,1,8)

	SA1->A1_DDD      := SUBSTR(wsDDD,1,3)
	SA1->A1_TEL      := SUBSTR(wsTELEFONE,1,15)
	SA1->A1_EMAIL 	 := SUBSTR(wsMAIL,1,60)
	SA1->A1_DTNASC   := STOD(SUBSTR(wsNASCIMENTO,1,8))
	SA1->A1_SEXO     := SUBSTR(wsSEXO,1,1)

	SA1->A1_PROFSN   := "1"

	if empty(SA1->A1_PFISICA)
		SA1->A1_PFISICA := SUBSTR(wsRG,1,15)
	endif

	if empty(SA1->A1_TIPO)
	   SA1->A1_TIPO := "S"
	endif

	if empty(SA1->A1_PAIS)
		SA1->A1_PAIS := "105"
	endif

	if empty(SA1->A1_INSCR)
		SA1->A1_INSCR := "ISENTO"
	endif

	if empty(SA1->A1_NATUREZ)
		SA1->A1_NATUREZ := "10084"
	endif

	if empty(SA1->A1_VEND)
		SA1->A1_VEND := "016"
	endif

	if empty(SA1->A1_CONTA)
		SA1->A1_CONTA := "331020067"
	endif

	if empty(SA1->A1_TPFRET)
		SA1->A1_TPFRET := "C"
	endif

	if empty(SA1->A1_TPESSOA)
		SA1->A1_TPESSOA := "PF"
	endif

	if empty(SA1->A1_CODPAIS)
		SA1->A1_CODPAIS := "01058"
	endif

	if empty(SA1->A1_TRANSP)
		SA1->A1_TRANSP := "191"
	endif

	if empty(SA1->A1_COND)
		SA1->A1_COND := "12"
	endif

	if empty(SA1->A1_RISCO)
		SA1->A1_RISCO := "A"
	endif

	if SA1->A1_LC == 0
		SA1->A1_LC := 1000
	endif

	if empty(SA1->A1_MENSAGE)
		SA1->A1_MENSAGE := "002"
	endif

    MsUnLock()

	wsMENSAGEM := "CLIENTE: "+cCODIGO
	conout("OK, Alterado Cliente! " + DtoC(Date()) + " - " + Time() + " ---")
	lContinua := .T.

else

	aCabec:={}
	aAdd( aCabec,{"A1_FILIAL"	, xFILIAL('SA1')																			, Nil} )
	aAdd( aCabec,{"A1_COD"		, GETSXENUM("SA1","A1_COD")																	, Nil} )
	aAdd( aCabec,{"A1_LOJA"		, "01"																						, Nil} )
	aAdd( aCabec,{"A1_PESSOA"	, "F"  																						, Nil} )
	aAdd( aCabec,{"A1_NOME"		, SUBSTR(wsNOME,1,70)																		, Nil} )
	aAdd( aCabec,{"A1_NREDUZ"	, SUBSTR(wsREDUZIDO,1,20)																	, Nil} )
	aAdd( aCabec,{"A1_END"		, SUBSTR(wsLOGRADOURO,1,80)																	, Nil} )
	aAdd( aCabec,{"A1_TIPO"		, "S"  																						, Nil} )
	aAdd( aCabec,{"A1_EST"		, SUBSTR(wsESTADO,1,2)																		, Nil} )
	aAdd( aCabec,{"A1_COD_MUN"	, SUBSTR(wsIBGE,1,5)																		, Nil} )
	aAdd( aCabec,{"A1_MUN"		, POSICIONE("CC2",1,XFILIAL("CC2")+SUBSTR(wsESTADO,1,2)+SUBSTR(wsIBGE,1,5),"CC2_MUN")		, Nil} )
	aAdd( aCabec,{"A1_BAIRRO"	, SUBSTR(wsBAIRRO,1,30)																		, Nil} )
	aAdd( aCabec,{"A1_CEP"		, SUBSTR(wsCEP,1,8)																			, Nil} )
	aAdd( aCabec,{"A1_DDD"		, SUBSTR(wsDDD,1,3)																			, Nil} )
	aAdd( aCabec,{"A1_TEL"		, SUBSTR(wsTELEFONE,1,15)																	, Nil} )
	aAdd( aCabec,{"A1_DTNASC"	, STOD(SUBSTR(wsNASCIMENTO,1,8))															, Nil} )
	aAdd( aCabec,{"A1_SEXO"		, SUBSTR(wsSEXO,1,1)																		, Nil} )
	aAdd( aCabec,{"A1_PAIS"		, "105"																						, Nil} )
	aAdd( aCabec,{"A1_CGC"		, SUBSTR(wsCPF,1,11)																		, Nil} )
	aAdd( aCabec,{"A1_INSCR"	, "ISENTO"																					, Nil} )
	aAdd( aCabec,{"A1_PFISICA"	, SUBSTR(wsRG,1,15)																			, Nil} )
	aAdd( aCabec,{"A1_EMAIL"	, LOWER(SUBSTR(wsMAIL,1,60))																, Nil} )
	aAdd( aCabec,{"A1_MSBLQL"	, "2"																						, Nil} )
	aAdd( aCabec,{"A1_PROFSN"	, "1"																						, Nil} )
	aAdd( aCabec,{"A1_NATUREZ"	, "10084"																					, Nil} )
	aAdd( aCabec,{"A1_ENDCOB"	, SUBSTR(wsLOGRADOURO,1,80)																	, Nil} )
	aAdd( aCabec,{"A1_MUNC"		, POSICIONE("CC2",1,XFILIAL("CC2")+SUBSTR(wsESTADO,1,2)+SUBSTR(wsIBGE,1,5),"CC2_MUN")		, Nil} )
	aAdd( aCabec,{"A1_ESTC"		, SUBSTR(wsESTADO,1,2)																		, Nil} )
	aAdd( aCabec,{"A1_CEPC"		, SUBSTR(wsCEP,1,8)																			, Nil} )
	aAdd( aCabec,{"A1_VEND"		, "016"																						, Nil} )
	aAdd( aCabec,{"A1_CONTA"	, "331020067"																				, Nil} )
	aAdd( aCabec,{"A1_TPFRET"	, "C"																						, Nil} )
	aAdd( aCabec,{"A1_TPESSOA"	, "PF"																						, Nil} )
	aAdd( aCabec,{"A1_CODPAIS"	, "01058"																					, Nil} )
	aAdd( aCabec,{"A1_TRANSP"	, "191"																						, Nil} )
	aAdd( aCabec,{"A1_COND"		, "12"																						, Nil} )
	aAdd( aCabec,{"A1_RISCO"	, "A"																						, Nil} )
	aAdd( aCabec,{"A1_LC"		, 1000																						, Nil} )
	aAdd( aCabec,{"A1_MENSAGE"	, "002"																						, Nil} )

	lMsErroAuto    := .F.
	lAutoErrNoFile := .T.
	MSExecAuto({|x,y| MATA030(x,y)}, aCabec, 3)
	If lMsErroAuto
		CONOUT( MostraErro() )
		wsRET      := "2"
		wsMENSAGEM := "[ERRO] Inclusใo do Cliente!"
		conout("[ERRO]  Inclusใo do Cliente! " + DtoC(Date()) + " - " + Time() + " ---")
		lContinua  := .F.
	else
		DbSelectArea("SA1")
		DbSetOrder(3) // A1_FILIAL+A1_CGC
		if DbSeek(xFilial("SA1")+wsCPF)
			cCODIGO   := SA1->A1_COD
			cLOJA     := SA1->A1_LOJA
	    endif
		wsMENSAGEM := "CLIENTE: "+cCODIGO
		conout("OK, Incluido Cliente! " + DtoC(Date()) + " - " + Time() + " ---")
		lContinua := .T.
	endif

endif


if lContinua .AND. ( !EMPTY(wsAISBN) .OR. !EMPTY(wsBISBN) )

	aCab:= {}
	aAdd(aCab, {"C5_FILIAL"		, xfilial("SC5")												, NIL})
	AAdd(aCab, {"C5_TIPO"   	, "N"															, Nil})
	AAdd(aCab, {"C5_CLIENTE"	, cCODIGO														, Nil})
	AAdd(aCab, {"C5_LOJACLI"	, cLOJA															, Nil})
	AAdd(aCab, {"C5_XTPCON"		, "N"															, Nil})
	AAdd(aCab, {"C5_TIPOCLI"	, "F"															, Nil})
	AAdd(aCab, {"C5_NATUREZ"	, "10084"														, Nil})
	AAdd(aCab, {"C5_MENNOTA"	, "DOACAO PROFESSOR, "+alltrim(wsSEMESTRE)+" SEMESTRE DE "+wsANO, Nil})

	aItens := {}
	cITEM  := "00"

	IF !EMPTY(wsAISBN)
		cITEM := soma1(cITEM)
		AAdd(aItem, {"C6_FILIAL"	, xfilial("SC6")	, NIL})
		AAdd(aItem, {"C6_ITEM"		, cITEM				, NIL})
		AAdd(aItem, {"C6_PRODUTO"	, wsAISBN			, Nil})
		AAdd(aItem, {"C6_QTDVEN" 	, 1					, Nil})
		//AAdd(aItem, {"C6_QTDLIB" 	, 1					, Nil})
		AAdd(aItem, {"C6_OPER"		, "DO"				, Nil})
		AAdd( aItens, aClone(aItem) )
	endif

	IF !EMPTY(wsBISBN)
		cITEM := soma1(cITEM)
		AAdd(aItem, {"C6_FILIAL"	, xfilial("SC6")	, NIL})
		AAdd(aItem, {"C6_ITEM"		, cITEM				, NIL})
		AAdd(aItem, {"C6_PRODUTO"	, wsBISBN			, Nil})
		AAdd(aItem, {"C6_QTDVEN" 	, 1					, Nil})
		//AAdd(aItem, {"C6_QTDLIB" 	, 1					, Nil})
		AAdd(aItem, {"C6_OPER"		, "DO"				, Nil})
		AAdd( aItens, aClone(aItem) )
	endif

	lMsErroAuto    := .F.
	lAutoErrNoFile := .T.
	MsExecAuto({|x,y,z|MATA410(x,y,z)},aCab,aItens,3)
	If lMsErroAuto
		CONOUT( MostraErro() )
		wsRET      := "2"
		wsMENSAGEM := "[ERRO] Inclusใo do Pedido de Venda!"
		conout("[ERRO] Inclusใo do Pedido de Venda! " + DtoC(Date()) + " - " + Time() + " ---")
		lContinua  := .F.
	else
		wsMENSAGEM := wsMENSAGEM + " PEDIDO: "+SC5->C5_NUM
		conout("OK, Inclusใo do Pedido de Venda! " + DtoC(Date()) + " - " + Time() + " ---")
		lContinua := .T.
	endif
endif

if lContinua
	wsRET	   := "1"
endif

cHtml:=  wsRET+";"+wsMENSAGEM

conout("cHtml: ["+cHtml+"]")

conout("Finalizado processo WSDoacao " + DtoC(Date()) + " - " + Time() + " ---")

WEB EXTENDED END

Return cHtml


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WSSaldo  บAutor  ณ Fontanelli         บ Data ณ  21/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que roda pelo WebService para retornar o Saldo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSSaldo

// CHROME EXTERNO:  201.87.143.242:7070/u_WSSaldo.apw
// CHROME INTERNO:  10.10.1.3:7070/u_WSSaldo.apw

Local cHtml   := ""
Local json    := ""

Private wsISBN

Prepare Environment Empresa "01" Filial "01"

WEB EXTENDED INIT cHtml

conout("Iniciado processo WSSaldo " + DtoC(Date()) + " - " + Time() + " ---")

wsISBN := If(ValType(HttpPost->ISBN) == "U",SPACE(5),HttpPost->ISBN)

wsISBN := Alltrim(PADR(wsISBN,TAMSX3("B1_COD")[1]))

/*
cQuery:= " SELECT B1_COD, B1_DESC, B1_XNMAUT, B2_QATU "+CHR(13)+CHR(10)
cQuery+= "   FROM "+RetSqlName("SB1")+", "+RetSqlName("SB2")+" "+CHR(13)+CHR(10)
cQuery+= "  WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_COD = '"+wsISBN+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_XTIPO IN ('1') "+CHR(13)+CHR(10)
cQuery+= "    AND B1_MSBLQL <> 1 "+CHR(13)+CHR(10)
cQuery+= "    AND "+RetSqlName("SB1")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= "    AND B2_FILIAL = '"+xFilial("SB2")+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B2_COD = B1_COD "+CHR(13)+CHR(10)
cQuery+= "    AND B2_LOCAL = '01' "+CHR(13)+CHR(10)
cQuery+= "    AND B2_QATU > 0 "+CHR(13)+CHR(10)
cQuery+= "    AND "+RetSqlName("SB2")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
*/

//Envio de informa็๕es de Livros e Ebook (B1_XTIPO = 1 ou 4)
//Retirado valida็ใo de saldo visto que o Ebook nใo tem saldo
//A tratativa de tipo e saldo serแ efetuada no portal, para que utilizem essa fun็ใo em outras rotinas

//SUBSTR(B1_DESC,1,50)

cQuery:= " SELECT B1_COD, B1_DESC, B1_XNMAUT, B2_QATU "+CHR(13)+CHR(10)
cQuery+= "   FROM "+RetSqlName("SB1")+" "+CHR(13)+CHR(10)
cQuery+= "  LEFT JOIN "+RetSqlName("SB2")+" "+CHR(13)+CHR(10)
cQuery+= "    SB2 ON ( SB2.B2_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
cQuery+= " 		AND SB2.B2_LOCAL = '01' 	"+CHR(13)+CHR(10)
cQuery+= " 		AND SB2.B2_COD = B1_COD 	"+CHR(13)+CHR(10)
cQuery+= " 		AND SB2.D_E_L_E_T_ = ' ' )  "+CHR(13)+CHR(10)
cQuery+= "  WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_COD = '"+wsISBN+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_XTIPO IN ('1','4') "+CHR(13)+CHR(10)
cQuery+= "    AND B1_MSBLQL <> 1 "+CHR(13)+CHR(10)
cQuery+= "    AND "+RetSqlName("SB1")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)

cQuery:= ChangeQuery(cQuery)

conout(cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
DbSelectArea("TRB")
TRB->(DbGoTop())
json := '['

conout(json)

if !TRB->(Eof())
	While TRB->(!EOF())
		
	   json += '{
	   json += ' "isbn":"'+alltrim(TRB->B1_COD)+'",
	   json += ' "descricao":"'+alltrim(TRB->B1_DESC)+'",
	   json += ' "autor":"'+alltrim(TRB->B1_XNMAUT)+'",
	   json += ' "saldo":"'+alltrim(transform(TRB->B2_QATU,"@E 999999999"))+'"
	   json += '}

	   TRB->(dbskip())

	   If !TRB->(Eof()) .AND. LEN(json) > 1
    	  json += ','
   	   endif

	 Enddo
	json +=']'
endif
TRB->(DbCloseArea())

cHtml:= json

conout("SALDO: "+cHtml)

conout("Finalizado processo WSSaldo " + DtoC(Date()) + " - " + Time() + " ---")

WEB EXTENDED END

Return cHtml




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WSLista  บAutor  ณ Fontanelli         บ Data ณ  21/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que roda pelo WebService para retornar o Lista de บฑฑ
ฑฑบ          ณ Produtos                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSLista

// CHROME EXTERNO:  201.87.143.242:7070/u_WSLista.apw
// CHROME INTERNO:  10.10.1.3:7070/u_WSLista.apw

Local cHtml := ""
Local json  := ""

Prepare Environment Empresa "01" Filial "01"

WEB EXTENDED INIT cHtml

conout("Iniciado processo WSLista " + DtoC(Date()) + " - " + Time() + " ---")

cQuery:= " SELECT B1_COD, B1_DESC, B1_XNMAUT, B2_QATU "+CHR(13)+CHR(10)
cQuery+= "   FROM "+RetSqlName("SB1")+", "+RetSqlName("SB2")+" "+CHR(13)+CHR(10)
cQuery+= "  WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_XTIPO = '1' "+CHR(13)+CHR(10)
cQuery+= "    AND B1_MSBLQL <> 1 "+CHR(13)+CHR(10)
cQuery+= "    AND "+RetSqlName("SB1")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery+= "    AND B2_FILIAL = '"+xFilial("SB2")+"' "+CHR(13)+CHR(10)
cQuery+= "    AND B2_COD = B1_COD "+CHR(13)+CHR(10)
cQuery+= "    AND B2_LOCAL = '01' "+CHR(13)+CHR(10)
cQuery+= "    AND B2_QATU > 0 "+CHR(13)+CHR(10)
cQuery+= "    AND "+RetSqlName("SB2")+".D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
DbSelectArea("TRB")
TRB->(DbGoTop())
json := '['
if !TRB->(Eof())
	While TRB->(!EOF())

	   json += '{
	   json += ' "isbn":"'+alltrim(TRB->B1_COD)+'",
	   json += ' "descricao":"'+alltrim(TRB->B1_DESC)+'",
	   json += ' "autor":"'+alltrim(TRB->B1_XNMAUT)+'",
	   json += ' "saldo":"'+alltrim(transform(TRB->B2_QATU,"@E 999999999"))+'"
	   json += '}

	   TRB->(dbskip())

	   If !TRB->(Eof()) .AND. LEN(json) > 1
    	  json += ','
   	   endif

	 Enddo
	json +=']'
endif
TRB->(DbCloseArea())

cHtml:= json

conout("LISTA: "+cHtml)

conout("Finalizado processo WSLista " + DtoC(Date()) + " - " + Time() + " ---")

WEB EXTENDED END

Return cHtml



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WSRastro บAutor  ณ Fontanelli         บ Data ณ  21/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que roda pelo WebService para retornar o Saldo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSRastro

// CHROME EXTERNO:  201.87.143.242:7070/u_WSRastro.apw
// CHROME INTERNO:  10.10.1.3:7070/u_WSRastro.apw

Local cHtml   := ""
Local cRASTRO := ""

Private wsPEDIDO

Prepare Environment Empresa "01" Filial "01"

WEB EXTENDED INIT cHtml

conout("Iniciado processo WSRastro " + DtoC(Date()) + " - " + Time() + " ---")

wsPEDIDO := If(ValType(HttpPost->PEDIDO) == "U",SPACE(5),HttpPost->PEDIDO)

wsPEDIDO := PADR(wsPEDIDO,TAMSX3("C5_NUM")[1])

DbSelectArea("SC5")
DbSetOrder(1) // B2_FILIAL+B2_COD+B2_LOCAL
if DbSeek(xFilial("SC5")+wsPEDIDO)

   if EMPTY(SC5->C5_NOTA)
      cRASTRO := SC5->C5_NOTA+";"+SC5->C5_SERIE+";"+"NAO FATURADO"
   endif

   if !EMPTY(SC5->C5_NOTA)
      if EMPTY(SC5->C5_OBJETO)
         cRASTRO := SC5->C5_NOTA+";"+SC5->C5_SERIE+";"+"FATURADO"
      else
         cRASTRO := SC5->C5_NOTA+";"+SC5->C5_SERIE+";"+SC5->C5_OBJETO
      endif
   endif

endif

cHtml:= cRASTRO

conout("PEDIDO: ["+alltrim(wsPEDIDO)+"] RASTRO: ["+cHtml+"]")

conout("Finalizado processo WSRastro " + DtoC(Date()) + " - " + Time() + " ---")

WEB EXTENDED END

Return cHtml
