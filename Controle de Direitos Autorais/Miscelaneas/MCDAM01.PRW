#INCLUDE"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH"


USER FUNCTION MCDAM01()
Local nOpcA := 0
PRIVATE DDATAPROC := DTOS(GETMV("MV_CDAFECH"))
PRIVATE DNEWDT := CTOD("  /  /    ")
PRIVATE LTITPG := .T.
Private aSays :={}
Private aButtons := {} 
Private AlogDes := {}
Private llimpah8 := .F.
Private cCadastro := "Reabertura e descalculo de Direitos Autorais"


aadd(aSays,"Este programa tem como objetivo desfazer automaticamente o último fechamento de ")
aadd(aSays,"Direitos Autorais, excluindo também o calculo efetuado para esse mesmo fechamento.")
aadd(aSays,"")
aadd(aSays,"ATENÇÃO: Essa rotina irá excluir todos os lançamentos.")
aadd(aSays,"Caso o periodo não esteja fechado, utilize a rotina de CALCULO.")
aadd(aSays,"")
aadd(aSays,"DATA DO ULTIMO FECHAMENTO: "+DTOC(GETMV("MV_CDAFECH")))

aadd(aButtons, { 1,.T.,{|| nOpcA:= 1, FechaBatch() }} )
aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )
FormBatch( cCadastro, aSays, aButtons )

IF nOpcA == 1
	
	DNEWDT := LASTDAY(CTOD("01/"+StrZero(Month(GETMV("MV_CDAFECH")),2)+"/"+Str(Year(GETMV("MV_CDAFECH")))) - 1)
	
	//CONFIRMA A VALIDAÇÃO QUANTO A LIMPEZA DOS DADOS DE FINANCEIRO (CASO NÃO, SÓ FAZ A LIMPEZA DO DA)
	IF MSGYESNO("Deseja limpar também os titulos do financeiro? (Somente os titulos em aberto gerados pelo fechamento) ")
		LTITPG := .T.
	endif
	Processa( {|lEnd| Proc_LmpB(DDATAPROC,@lEnd)}, "Limpando fechamento de: "+DTOC(GETMV("MV_CDAFECH"))+"...","Apagando movimento de D.A.",.T.)
	
	//Ao final coloca no parametro mv_cdafech a data do fechamento anterior
	PUTMV("MV_CDAFECH",DNEWDT)
	Msginfo("Descalculo finalizado.")
	If Len(AlogDes) > 0
		If MsgYesNo("Deseja imprimir o relatório de processamento?")
			FImpLog(AlogDes)
		EndIf
	EndIf

ELSE
	MSGINFO("OPERAÇÃO CANCELADA")
ENDIF

RETURN NIL


STATIC FUNCTION Proc_LmpB(DDATAPROC)
Local nRec    := 0
Local nTotRec := 0
Local cQuery  := ""
Local ALIMP  := {}
Local i := 0
LOCAL CALIAS := ""
LOCAL CCPO := ""

//AADD(ALIMP,{CALIAS,CCPO})

IF LTITPG                                             
//INICIA OS MOVIMENTOS QUE GERARAM FINANCEIRO E SERÃO EXCLUIDOS (O TRATAMENTO PARA BAIXA FICA POR CONTA DA STATIC QUE SERÁ EXECUTADA POSTERIORMENTE
	AADD(ALIMP,{"SE2","E2_EMISSAO"})                
	
	// ESSA PARTE DO ARRAY BUSCA AS MOVIMENTAÇÕES DE D.A. QUE NÃO GERARAM FINANCEIRO
	AADD(ALIMP,{"AH4","AH4_DATCAL"})
	AADD(ALIMP,{"AH5","AH5_DATCAL"})
	AADD(ALIMP,{"AH6","AH6_DTPRXD"})
	AADD(ALIMP,{"AH7","AH7_DATCAL"})
	AADD(ALIMP,{"AH1","AH1_DTULTP"})
	If !llimpah8
	AADD(ALIMP,{"AH8","AH8_CODPRO"})
	llimpah8 := .t.
	Endif
	
ENDIF

FOR I = 1 TO LEN(ALIMP)
	CALIAS := ALIMP[I][1]
	CCPO := ALIMP[I][2]
	dbSelectArea(CALIAS)
	cquery := " SELECT R_E_C_N_O_ REG
	cquery += " FROM "+RETSQLNAME(CALIAS)+" "
	cquery += " WHERE D_E_L_E_T_ <> '*'
	IF CALIAS == "AH8"
		cquery += " AND "+CCPO+" <> ' '
	ELSEIF CALIAS == "SE2"
		cquery += " AND "+CCPO+" = '"+DDATAPROC+"' "
		cquery += " AND (E2_PREFIXO = 'RYI' OR E2_PREFIXO = 'RYE')"
		cquery += " AND E2_TIPO = 'RC' "
		cquery += " AND E2_ORIGEM = 'CDAA040' "
	ELSE
		IF CALIAS == "AH6"
			cquery += " AND "+CCPO+" >= '"+DDATAPROC+"'
		ELSE
			cquery += " AND "+CCPO+" = '"+DDATAPROC+"'
		ENDIF
	ENDIF
	IF CALIAS <> "SE2" .AND. CALIAS <> "AH8"
		cquery += " AND "+CALIAS+"_FORNEC || "+CALIAS+"_LOJAFO NOT IN ( "
		cquery += " SELECT DISTINCT E2_FORNECE||E2_LOJA FROM "+RETSQLNAME("SE2")+" "
		CQUERY += " WHERE (E2_PREFIXO = 'RYI' OR E2_PREFIXO = 'RYE') "
		CQUERY += " AND E2_TIPO = 'RC' "
		CQUERY += " AND E2_EMISSAO = '"+DDATAPROC+"' "
		CQUERY += " AND (E2_BAIXA = ' ' OR E2_VALOR = E2_SALDO) "
		CQUERY += " AND D_E_L_E_T_ <> '*' ) "
	ENDIF

	IF SELECT("TQRY")<>0
		DBSELECTAREA("TQRY")
		TQRY->(DBCLOSEAREA())
	ENDIF
	
	TcQuery cQuery New Alias "TQRY"
	Count To nTotRec
	ProcRegua(0)
	
	TQRY->(dbGoTop())
	
	nRec    := 0
	While TQRY->(!EOF())
		nRec++
		IncProc(CHR(13)+CHR(10)+cAlias+" "+StrZero(nRec,7)+"/"+StrZero(nTotRec,7)+" - "+RetPerc(nRec,nTotRec))
		
		(cAlias)->(dbGoTo(TQRY->REG))
		IF cAlias == "SE2"
			//Edmar Mendes do Prado, em 11/07/2019
			//Permite refazer o descalculo do DA sem excluir o titulo no financeiro, pois ja estao baixados.
			//Processo efetuado na base teste D03 para o Descalculo de Junho/2019
			ETITPAG(TQRY->REG)
		ELSE
			Reclock(cAlias,.F.)
			IF cAlias == "AH8" .OR. cAlias == "AH1"
				IF cAlias == "AH8"
					AH8->AH8_QTDACU := AH8->AH8_QTDINI
				ELSEIF	cAlias == "AH1"
					AH1->AH1_DTULTP := DNEWDT 
					cNomfor := POSICIONE("SA2",1,XFILIAL("SA2")+AH1->AH1_FORNEC+AH1->AH1_LOJAFO,"SA2->A2_NREDUZ")
					GrvLog(ddatabase,"Descalculo: "+AH1->AH1_FORNEC+"-"+AH1->AH1_LOJAFO+" "+cNomfor+" - Produto:"+AH1->AH1_PRODUT+" concluído com sucesso. Sem Titulo de Contas a Pagar Vinculado")
				ENDIF
			ELSE
				(cAlias)->(dbDelete())
			ENDIF
			(cAlias)->(MsUnlock())
		ENDIF
		
		TQRY->(dbSkip())
		
		
	END
	IF SELECT("TQRY")<>0
		DBSELECTAREA("TQRY")
		TQRY->(DBCLOSEAREA())
	ENDIF
	(cAlias)->(DBCLOSEAREA())
	
	
NEXT I

RETURN nil


Static Function RetPerc(nRec,nTotRec)

Local nPerc := 0
Local cPerc := ""

nPerc := NoRound((100*nRec)/nTotRec,0)
cPerc := AllTrim(Str(nPerc))+"%"

Return cPerc


STATIC FUNCTION ETITPAG(nRecE2)
LOCAL aPagar := {}
Local aLimp1 := {}
local CALIAS1 := ""
local CCPO1 := ""   
LOCAL CFORNEC := "" 
LOCAL CLOJFOR := ""

//Excluir o título do Contas à Pagar
DBSELECTAREA("SE2")
SE2->(DBGOTO(nRecE2))

If SE2->(RECNO()) == nRecE2 .AND. (SE2->E2_PREFIXO == "RYI" .OR. SE2->E2_PREFIXO == "RYE")  
CFORNEC := SE2->E2_FORNECE
CLOJAFO := SE2->E2_LOJA

	AADD(aPagar,{"E2_FILIAL"	, xFilial("SE2")	,".T."})
	AADD(aPagar,{"E2_PREFIXO"	, SE2->E2_PREFIXO	,".T."})
	AADD(aPagar,{"E2_NUM"		, SE2->E2_NUM	  	,".T."})
	AADD(aPagar,{"E2_PARCELA"	, SE2->E2_PARCELA	,".T."})
	AADD(aPagar,{"E2_TIPO"		, SE2->E2_TIPO		,".T."})
	AADD(aPagar,{"E2_FORNECE"	, SE2->E2_FORNECE	,".T."})
	AADD(aPagar,{"E2_LOJA"		, SE2->E2_LOJA		,".T."})
	
	lMsErroAuto := .F.
	MsgRun(OemToAnsi("Excluindo título do Contas à Pagar"),,{||MsExecAuto({|a,b,c| FINA050(a,b,c) },aPagar,,5)})
	
	If !lMSErroAuto
		AADD(ALIMP1,{"AH4","AH4_DATCAL"})
		AADD(ALIMP1,{"AH5","AH5_DATCAL"})
		AADD(ALIMP1,{"AH6","AH6_DTPRXD"})
		AADD(ALIMP1,{"AH7","AH7_DATCAL"})
		AADD(ALIMP1,{"AH1","AH1_DTULTP"})
	If !llimpah8
	AADD(ALIMP1,{"AH8","AH8_CODPRO"})
	llimpah8 := .t.
	Endif

		
		FOR I = 1 TO LEN(ALIMP1)
			CALIAS1 := ALIMP1[I][1]
			CCPO1 := ALIMP1[I][2]
			dbSelectArea(CALIAS1)
			cquery1 := " SELECT R_E_C_N_O_ REG
			cquery1 += " FROM "+RETSQLNAME(CALIAS1)+" "
			cquery1 += " WHERE D_E_L_E_T_ <> '*'    
			IF CALIAS1 == "AH8"
				cquery1 += " AND "+CCPO1+" <> ' '
			ELSEIF CALIAS1 == "AH6"
				cquery1 += " AND "+CCPO1+" >= '"+DDATAPROC+"'
			ELSE
				cquery1 += " AND "+CCPO1+" = '"+DDATAPROC+"'
			ENDIF

				IF CALIAS1 <> "AH8"
							CQUERY1 += " AND "+CALIAS1+"_FORNEC = '"+CFORNEC+"'"
							CQUERY1 += " AND "+CALIAS1+"_LOJAFO = '"+CFORNEC+"'"
				ENDIF
			
			IF SELECT("TQRX")<>0
				DBSELECTAREA("TQRX")
				TQRX->(DBCLOSEAREA())
			ENDIF
			
			TcQuery cQuery1 New Alias "TQRX"
			Count To nTotRec
			ProcRegua(0)
			
			TQRX->(dbGoTop())
			
			nRec    := 0
			While TQRX->(!EOF())
				nRec++
				IncProc(CHR(13)+CHR(10)+cAlias1+" "+StrZero(nRec,7)+"/"+StrZero(nTotRec,7)+" - "+RetPerc(nRec,nTotRec))
				
				(cAlias1)->(dbGoTo(TQRX->REG))
				
				Reclock(cAlias1,.F.)
				IF cAlias1 == "AH8" .OR. cAlias1 == "AH1"
					IF cAlias1 == "AH8"
						AH8->AH8_QTDACU := AH8->AH8_QTDINI
					ELSEIF	cAlias1 == "AH1"
						AH1->AH1_DTULTP := DNEWDT      
						cNomfor := POSICIONE("SA2",1,XFILIAL("SA2")+AH1->AH1_FORNEC+AH1->AH1_LOJAFO,"SA2->A2_NREDUZ")
						GrvLog(ddatabase,"Descalculo: "+AH1->AH1_FORNEC+"-"+AH1->AH1_LOJAFO+" "+cNomfor+" - Produto:"+AH1->AH1_PRODUT+" concluído com sucesso.")
					ENDIF
				ELSE
					(cAlias1)->(dbDelete())
				ENDIF
				(cAlias1)->(MsUnlock())
				
				TQRX->(dbSkip())
				
				
			END
			IF SELECT("TQRX")<>0
				DBSELECTAREA("TQRX")
				TQRX->(DBCLOSEAREA())
			ENDIF
			(cAlias1)->(DBCLOSEAREA())
			
			
		NEXT I
		
		
	Else    
	cNomfor := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"SA2->A2_NREDUZ")
	GrvLog(ddatabase,"Descalculo: "+AH1->AH1_FORNEC+"-"+AH1->AH1_LOJAFO+" "+cNomfor+" Não pode ser efetivado, pois o mesmo possui titulo do financeiro ("+SE2->E2_PREFIXO+" "+SE2->E2_NUM+") baixado ou vinculado a uma baixa.")
	EndIf
	
ENDIF

RETURN


Static Function GrvLog(dData,cMsg)

	aAdd(AlogDes,{dData,cMsg})

Return Nil


Static Function FImpLog(AlogDes)

	Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2  := "de acordo com os parametros informados pelo usuario."
	Local cDesc3  := ""
	Local cPict   := ""
	Local Titulo  := "Relatório de Log de Processamento"
	Local nLin    := 80
	Local Cabec1  := ""
	Local Cabec2  := ""
	Local imprime := .T.
	Local aOrd    := {}
	
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite     	:= 220
	Private tamanho    	:= "G"
	Private nomeprog   	:= "RELLOG" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo      	:= 18
	Private aReturn    	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   	:= 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "RELLOG" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString     := ""
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,AlogDes) },Titulo)
	
Return Nil

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,AlogDes)

	Local nOrdem := 0
	Local dData  := CTOD("  /  /  ")
	
	AlogDes := aSort(AlogDes,,,{|x,y| x[1] < y[1] })	
	For nI:=1 To Len(AlogDes)
	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		dData := AlogDes[nI,1]
		@nLin,010 PSAY "Data: " + DTOC(dData)
		nLin++
		@nLin,010 PSAY Replicate("-",200)
		nLin++
		Do While dData == AlogDes[nI,1]
			@nLin,010 PSAY AlogDes[nI,2]
			nLin++
			nI++
			If Len(AlogDes) < nI
				Exit
			EndIf
		EndDo
		nI--
		
		nLin++ // Avanca a linha de impressao
	
	Next nI
	
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return Nil