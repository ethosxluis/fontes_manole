#Include 'Protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "tbiconn.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

Static aErros := {}
Static aTitRA := {}


/*/{Protheus.doc} FIETHX01
Função principal responsável pela chamada do CSV
@type function
@author Fernando Carvalho
@since  01/05/2018
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function FIETHX01()
	Local aArea			:=	SaveArea1({"SE1"})
	Local oEdit			:= NIL
	Local oDlg			:= NIL
	Local nRes          := 0
	Local nAtu          := 0
	Local cTitle		:= 'Importação de Titulos Via CSV'
	Local cText			:= '"Atenção" colocar o caminho completo do CSV'
	Local cDesc			:= 'Selecione o Arquivo a ser importado'
	Local lSalvar		:= .T.
	Local nFiltros		:= nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY)
	Local cFile			:= ""
	Local cExtens		:= "Arquivos CSV | *.CSV"

	@ 200,001 TO 405,366 DIALOG oDlg TITLE cTitle
	@ 003,003 TO 098,182
	@ 025,025 SAY cText COLOR CLR_BLUE PIXEL OF oDlg


	@ 048,018 SAY cDesc PIXEL OF oDlg
	@ 058,018 MSGET oGetFile VAR cFile SIZE 140,006 PIXEL OF oDlg

	@ 053,160 BUTTON "..." SIZE 012,012 ACTION {|| cFile := cGetFile(cExtens,cTitLE,,,lSalvar,nFiltros)} PIXEL OF oDlg
	@ 080,098 BUTTON "Continuar"  SIZE 035,012 ACTION Processa({|| ImpPagarMe(cFile),Close(oDlg)},"Importando Arquivo...") PIXEL OF oDlg
	@ 080,140 BUTTON "Sair" SIZE 035,012 ACTION Close(oDlg) PIXEL OF oDlg

	ACTIVATE DIALOG oDlg CENTERED
	
	msgInfo("Processo finalizado.")
	RestArea1(aArea)
Return

/*/{Protheus.doc} ImpPagarMe
Função realiza a leitura do arquivo Pagar.me
@type function
@author Fernando Carvalho
@since  01/05/2018
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ImpPagarMe(cFile)
	Local cMemo 		:= ''
	Local cRet01 		:= ''
	Local cRet02 		:= ''
	Local cParcela		:= ''
	Local aRetInf		:= {}
	Local aRetSE1		:= {}
	Local nPosIdOp		:= 0
	Local nPosValEnt	:= 0
	Local nPosValTax	:= 0
	Local nPosValLiq	:= 0
	Local nPosParcel	:= 0
	Local nLoop			:= 0
	Local nLoop2		:= 0
	Local nValTit		:= 0
	Local nValorTot		:= 0
	Local nTolerancia	:= 0.10
	Local lExiste		:= .F.
	Local lAPrefixo		:= .F.
	Local l0Prefixo		:= .F.
	Local lSPrefixo		:= .F.
	aErros := {}
	aTitRA := {}	//VARIAVEL PARA ARMAZENAR OS TITULOS QUE SERÃO GERADOS 'RA'
	//se o arquivo estiver vazio, finaliza a rotina sem tratamento
	If Empty(cFile)
		MsgInfo("Arquivo não encontrado!")
		Return
	EndIf

	//Tratamento para Ler todo o arquivo
	FT_FUse(cFile) // Abre o arquivo
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	//FT_FSkip(1) // skip no cabeçario 1

	While !FT_FEof()
		IncProc("Lendo arquivo CSV...")
		cMemo := FT_FReadln()
		aAdd(aRetInf, Separa(Replace(cMemo, ".",""), ",", .T.))
		
		FT_FSkip()
	EndDo
	FT_FUse() // Fecha o arquivo
	
	If !(Empty(aRetInf))
		nPosData	:= 1
		nPosTipOp	:= 2
		nPosIdOp	:= 5
		nPosParcel	:= 6
		nPosValEnt	:= 8
		ProcRegua(Len(aRetInf))		
		//INICIA A TRANSAÇÃO
		Begin Transaction
			//posiciona nas informações do titulo
			dbSelectArea("SE1")
			SE1->(DbOrderNickName("IDVETEX"))
			For nLoop := 2 To Len(aRetInf)
				IncProc()

				//Leitura de arquivo no layout antigo, antes 01/2019	
				If (SubStr(aRetInf[nLoop,nPosTipOp],0,7) == 'payable') 
					nValTit := Val(aRetInf[nLoop,nPosValEnt])/100
					If  (nValTit <= 0)
						LOOP
					EndIf
					nValTit := Val(aRetInf[nLoop,nPosValEnt])/100
					cParcela := subStr(aRetInf[nLoop,nPosParcel],0,1)
					If cParcela == '-'
						cParcela := ''
					Else
						cParcela := RetParcela(subStr(aRetInf[nLoop,nPosParcel],0,1))
					Endif
					lSemParcela := .F.
					cId := aRetInf[nLoop,nPosIdOp]
					If	AllTrim(cId) $ "35927135"//'45569713'
						ConOut()
					Endif

					If   aRetInf[nLoop,7] == "credit_card" 
						lSemParcela := .T. // Alguns registros pode não conter parcela no protheus, mas vem no arquivo						
					Endif
					aTitulosSE1	:= GetTitulo(cId,cParcela,lSemParcela)
					
					For nLoop2 := 1 To Len(aTitulosSE1)
						nValorBaixa := 0
						lParcial 	:= .F.
						
						SE1->(DbsetOrder(1))
						lAchou := SE1->(Dbseek(aTitulosSE1[nLoop2,1]))
						If lAchou 
							
							lTolerancia := .F.
							aRetSE1 := {}	
										
							If ( nValTit > SE1->E1_SALDO)// valor do arquivo maior que o titulo
								If nValTit > (SE1->E1_SALDO + ntolerancia)
									nValorBaixa := SE1->E1_SALDO //valor a ser baixado
									nValTit 	:= nValTit - SE1->E1_SALDO//caso exista residuo para RA
									
								Else
									nValorBaixa := SE1->E1_SALDO //valor a ser baixado
									nValTit 	:= 0
									
								Endif
							ELSEIf (SE1->E1_SALDO >  nValTit)// valor do titulo maior que o arquivo  
							 	If SE1->E1_SALDO > (nValTit + ntolerancia)//baixa parcial
									nValorBaixa := nValTit //valor a ser baixado
									nValTit 	:= 0 
									lParcial 	:= .t.
								Else
									nValorBaixa := SE1->E1_SALDO //valor a ser baixado
									nValTit 	:= 0
		
								Endif
							ELSEIf (SE1->E1_SALDO ==  nValTit)
								nValorBaixa := SE1->E1_SALDO
								nValTit := 0
							Endif
							
							If nValorBaixa > 0
								aRetSE1		:= BaixaSE1(SubStr(aRetInf[nLoop,nPosData],0,10),nValorBaixa,lParcial)
							Endif	
															
							
							If ((nValorBaixa > 0) .AND. (aRetSE1[1]))
								nValorTot	+= nValorBaixa
							Endif
						EndIf
										
					Next
				
					//VERIFICIA SE VAI GERAR UMA RA PARA O CLIENTE
					If nvalTit > nTolerancia
						GeraNewSE1(nvalTit,.t.)
					Endif


				Endif
					
			Next
		
			//VERIFICA SE HOUVE ERRO NA TRANSAÇÃO - se houve disarma a transação
			If !Empty(aErros)
				DisarmTransaction()
			Else
				If nValorTot > 0
					GeraNewSE1(nValorTot,.f.)
				Endif
			Endif
		//FINALIZA A TRANSAÇÃO 
		End Transaction
	Endif
	
	If ! Empty(aErros)
		If MsgYesNo(	 "Algumas Solicitações não foram geradas com sucesso."+ CRLF;
				+"Deseja visualizar os erros?")
			TelaErro(aErros)
		EndIf
	Elseif Len(aRetInf) < 2
		MsgInfo("Nenhum registro foi selecionado.")
	Else
		MsgInfo("Todas as Solicitações foram executadas com sucesso.")
	EndIf
	
	//imprime relatório com as diferenças
	If ! Empty(aTitRA)
		u_FIETHR01(aTitRA)	
	Endif	
Return


Static Function GetTitulo(cId,cParcela,lSemParcela)
	Local cQuery 	:= " "
	Local cSE1	:= getNextAlias()
	Local aRetSE1	:= {}
	
	cQuery := " SELECT  " + CRLF
	cQuery += " E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO" + CRLF
	cQuery += " FROM " + RetSqlName("SE1") +  CRLF
	cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' " + CRLF
	cQuery += " AND D_E_L_E_T_ = ' '"
	cQuery += " AND E1_TIPO ='NF' 
	cQuery += " AND E1_PGVTTID = '"+cId+"'"
	cQuery += " AND (E1_PARCELA = '"+cParcela+"'"
	If lSemParcela
		cQuery += " OR E1_PARCELA = ''"	
	Endif
	cQuery += " )"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery), cSE1,.F.,.T.)
	
	dbSelectArea(cSE1)
	(cSE1)->(dbGotop())
	
	While !((cSE1)->(EOF()))

		AADD(aRetSE1,{(cSE1)->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO)})
		(cSE1)->(dbSkip()) 
	EndDo
Return aRetSE1

/*/{Protheus.doc} BaixaSE1
Função para baixar os títulos (SE1) 
@type function
@author Fernando Carvalho
@since  01/05/2018
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static function  BaixaSE1(cDat,nValTit,lParcial)
	Local aBaixa 	:= {}
	Local cBanc 	:= getmv('FS_PAGBANC')
	Local cAg   	:= getmv('FS_PAGAGEN') + Space(5 - Len(getmv('FS_PAGAGEN')))
	Local cCONT 	:= getmv('FS_PAGCONT')
	Local cMotBx	:= getmv('FS_PAGMOTB',.T.,'PGM')
	Local nValli   	:= 0
	Local nDESC1    := 0
	Local cHist     := 'BAIXA ROTINA PAGAR.ME'
	Local dDat		:= dDatabase
	Local lRet		:= .F.
	Local nLoop
	Local cMsgErro	:= ""
	
	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica


	aBaixa := {	{"E1_PREFIXO"  ,SE1->E1_PREFIXO            ,Nil    },;
		{"E1_NUM"      ,SE1->E1_NUM                ,Nil    },;
		{"E1_PARCELA"  ,SE1->E1_PARCELA            ,Nil    },;
		{"E1_TIPO"     ,SE1->E1_TIPO               ,Nil    },;
		{"E1_CLIENTE"  ,SE1->E1_CLIENTE            ,Nil    },;
		{"E1_NATUREZ"  ,SE1->E1_NATUREZ            ,Nil    },;
		{"E1_EMISSAO"  ,SE1->E1_EMISSAO            ,Nil    },;
		{"E1_VENCTO"   ,SE1->E1_VENCTO             ,Nil    },;
		{"AUTMOTBX"    ,cMotBx                     ,Nil    },;
		{"AUTBANCO"    ,cBanc                      ,Nil    },;
		{"AUTAGENCIA"  ,cAg                        ,Nil    },;
		{"AUTCONTA"    ,cCONT                      ,Nil    },;
		{"AUTDTBAIXA"  ,dDat                       ,Nil    },;
		{"AUTDTCREDITO",dDat                       ,Nil    },;
		{"AUTHIST"     ,cHist        			   ,Nil    },;
		{"AUTJUROS"    ,0                          ,Nil,.T.},;
		{"AUTDESCONT"  ,nDesc1                     ,Nil    },;
		{"AUTVALREC"   ,nValTit		               ,Nil    }}

	MSExecAuto({|x,y,z| Fina070(x,y,z)},aBaixa,3) // inclusão


	If lMsErroAuto
		aErrPCAuto	:= GETAUTOGRLOG()
		cMsgErro	:= ""
		For nLoop := 1 To Len(aErrPCAuto)
			cMsgErro += aErrPCAuto[nLoop]+ "<br>"
		Next
	Else
		If lParcial
			AADD(aTitRA, {SE1->E1_FILIAL,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_TIPO,SE1->E1_PARCELA,SE1->E1_PGVTTID,SE1->E1_VALOR,"BAIXA PARCIAL"})
		Endif
		lRet := .T.
	Endif
	
Return {lRet,cMsgErro}

/*/{Protheus.doc} GeraNewSE1
Função gerar o novo titulo no nome do cliente (financeira) 
@type function
@author Fernando Carvalho
@since  01/05/2018
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static function GeraNewSE1(nValor,lCliente)
	Local cCliente	:= getmv('FS_PAGCLI',.T.,'')
	Local cLoja		:= getmv('FS_PAGLOJA',.T.,'')
	Local cBanc 	:= getmv('FS_PAGBANC',.T.,'')
	Local cAg   	:= getmv('FS_PAGAGEN',.T.,'') + Space(5 - Len(getmv('FS_PAGAGEN')))
	Local cCONT 	:= getmv('FS_PAGCONT',.T.,'')
	Local cTipo		:= getmv('FS_PAGTIPO',.T.,'')
	Local cNaturez	:= getmv('FS_PAGNATU',.T.,'')
	
	Private lMsErroAuto := .F.
	
	aVetor := {	;
		{"E1_PREFIXO" 	,''										,Nil},;
		{"E1_NUM"	  	,GetSxeNum("SE1","E1_NUM")  			,Nil},;
		{"E1_PARCELA" 	,''										,Nil},;
		{"E1_TIPO"	  	,Iif(lCliente,'RA ',cTipo)				,Nil},;
		{"CBCOAUTO"		,cBanc									,Nil},;
		{"CAGEAUTO"		,cAg									,Nil},;
		{"CCTAAUTO"		,cCONT									,Nil},;
		{"E1_NATUREZ" 	,Iif(lCliente,SE1->E1_NATUREZ,cNaturez)	,Nil},;
		{"E1_CLIENTE" 	,Iif(lCliente,SE1->E1_CLIENTE,cCliente)	,Nil},;
		{"E1_LOJA"	  	,Iif(lCliente,SE1->E1_LOJA,cLoja)		,Nil},;
		{"E1_EMISSAO" 	,dDataBase								,Nil},;
		{"E1_VENCTO"  	,dDataBase								,Nil},;
		{"E1_VENCREA" 	,dDataBase								,Nil},;
		{"E1_PGVTTID" 	,Iif(lCliente,SE1->E1_PGVTTID,'')		,Nil},;
		{"E1_VALOR"		,nValor		 							,Nil}}
	
	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao
		
	If lMsErroAuto
		//MostraErro()
	Else
		If lCliente
			AADD(aTitRA, {SE1->E1_FILIAL,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_TIPO,SE1->E1_PARCELA,SE1->E1_PGVTTID,SE1->E1_VALOR,"GEROU RA PARA O CLIENTE."})
		Endif	
		ConfirmSX8()
	EndIf
Return lMsErroAuto

/*/{Protheus.doc} TelaErro
Tela de erros dos processos, 
@author Fernando Carvalho
@since 23/08/2016
/*/
Static Function TelaErro(aErros)
	Local oDlg
	Local oBrowse
	Local aBrowse	:= {}
	Local nFor		:= 0
		
	For nFor := 1 To Len(aErros)
		aAdd(aBrowse,{	aErros[nFor,1] ,aErros[nFor,2] ,aErros[nFor,3] ,aErros[nFor,4] ,aErros[nFor,5],;
			aErros[nFor,6] ,aErros[nFor,7] ,aErros[nFor,8] ,aErros[nFor,9] ,aErros[nFor,10],;
			aErros[nFor,11],aErros[nFor,12],aErros[nFor,13],aErros[nFor,14],aErros[nFor,15]})
	Next
	DEFINE DIALOG oDlg TITLE "Erros dos Pagar.me" FROM 180,180 TO 700,1000 PIXEL
	
	oBrowse := TcBrowse():New( 01 , 01, 405,260,,	{"Data da operação","Tipo da operação","Id da operação","Descrição da operação","Id da transação","Parcela","Método de pagamento","Entrada bruta","Saída bruta","Taxa de operação","Taxa de antecipação","Taxa total da operação","Entrada líquida	","Saída líquida","Erro na Baixa"},;
		{40,40,40,40,40,40,40,40,40,40,40,40,40,40,40},;
		oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
	oBrowse:SetArray(aBrowse)
	oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],;
		aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07],aBrowse[oBrowse:nAt,08],;
		aBrowse[oBrowse:nAt,09],aBrowse[oBrowse:nAt,10],aBrowse[oBrowse:nAt,11],aBrowse[oBrowse:nAt,12],;
		aBrowse[oBrowse:nAt,13],aBrowse[oBrowse:nAt,14],aBrowse[oBrowse:nAt,15]} }
		
	ACTIVATE DIALOG oDlg CENTERED
return


/*/{Protheus.doc} GetFiethx01
Função para que possa realizar a chamada via Job
@author Fernando Carvalho
@since 01/05/2018
/*/
User Function GetFiethx01()
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
	
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv('99','01')
	
	U_FIETHX01()
Return

Static Function RetParcela(cParcela)
	Local cLetra := ''
	
	If cParcela == '1'
		cLetra := 'A'
	ElseIf cParcela == '2'
		cLetra := 'B'
	ElseIf cParcela == '3'
		cLetra := 'C'
	ElseIf cParcela == '4'
		cLetra := 'D'
	ElseIf cParcela == '5'
		cLetra := 'E'
	ElseIf cParcela == '6'
		cLetra := 'F'
	ElseIf cParcela == '7'
		cLetra := 'G'
	ElseIf cParcela == '8'
		cLetra := 'H'
	ElseIf cParcela == '9'
		cLetra := 'I'
	ElseIf cParcela == '10'
		cLetra := 'J'
	ElseIf cParcela == '11'
		cLetra := 'K'
	ElseIf cParcela == '12'
		cLetra := 'L'
	ElseIf cParcela == '13'
		cLetra := 'M'
	ElseIf cParcela == '14'
		cLetra := 'N'
	ElseIf cParcela == '15'
		cLetra := 'O'
	ElseIf cParcela == '16'
		cLetra := 'P'
	ElseIf cParcela == '17'
		cLetra := 'Q'
	ElseIf cParcela == '18'
		cLetra := 'R'
	ElseIf cParcela == '19'
		cLetra := 'S'
	ElseIf cParcela == '20'
		cLetra := 'T'
	ElseIf cParcela == '21'
		cLetra := 'U'
	ElseIf cParcela == '22'
		cLetra := 'V'
	ElseIf cParcela == '23'
		cLetra := 'X'
	Endif
Return cLetra