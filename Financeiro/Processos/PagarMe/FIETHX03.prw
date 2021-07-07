#Include 'Protheus.ch'

User Function FIETHX03(aRetInf)
	Local cMemo 		:= ''
	Local cRet01 		:= ''
	Local cRet02 		:= ''
	Local cParcela		:= ''
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
	Local lContinua		:= .F.
	aErros := {}
	aTitRA := {}	//VARIAVEL PARA ARMAZENAR OS TITULOS QUE SERÃO GERADOS 'RA'
	
	
	nPosData	:= 1
	nPosTipOp	:= 2
	nPosIdOp	:= 5
	nPosParcel	:= 6
	nPosValEnt	:= 8
		
	ProcRegua(TRB->(RECCOUNT()))
	
	DbSelectArea("TRB")
	TRB->(DbGoTop())
	
	//posiciona nas informações do titulo
	dbSelectArea("SE1")
	SE1->(DbOrderNickName("IDVETEX"))
	//{'DTOPER','TPOPER','IDOPER','DESCRI','IDTRAN','PARCEL','METPGTO','ENTBRU','SAIBRU','TXOPER','TXANT','TXTOTAL','ENTLIQ','SAILIQ'}
	Begin Transaction
		While TRB->(!Eof())
			IncProc("Processando arquivo CSV...")
			If TRB->X1_OK == cMarca
			
				nLoop := aScan(aRetInf,{|x| x[5]+x[6] == AllTrim(TRB->(AllTrim(IDTRAN)+PARCEL))})

				If nLoop > 0  
									
					cId := aRetInf[nLoop,nPosIdOp]
					
					//conout("001 - Processando Id: " + alltrim(cId))				
					//Leitura de arquivo no layout antigo, até 01/2019
					If (SubStr(aRetInf[nLoop,nPosTipOp],0,7) == 'payable')  
						
						nValTit := Val(aRetInf[nLoop,nPosValEnt])/100
						
						//conout("002 - Processando: " + str(nLoop) + "  Id: " + alltrim(cId) + " de Valor: "  + Str(nValTit))
						If  ((nValTit <= 0)) 
							//conout("003 - Valor Menor ou = 0 - LOOP: " + alltrim(cId) + " de Valor: "  + Str(nValTit))
							TRB->(dbskip())
							LOOP							
						EndIf
						
						//nValTit := Val(aRetInf[nLoop,nPosValEnt])/100
						cParcela := subStr(aRetInf[nLoop,nPosParcel],0,1)
						
						If cParcela == '-'
							cParcela := ''
						Else
							cParcela := u_RetParcela(subStr(aRetInf[nLoop,nPosParcel],0,1))
						Endif
						
						lSemParcela := .F.
						
						If aRetInf[nLoop,7] == "credit_card"
							lSemParcela := .T. // Alguns registros pode não conter parcela no protheus, mas vem no arquivo
						Endif
						
						aTitulosSE1	:= u_GetTitulo(cId,cParcela,lSemParcela)
					
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
												
				Endif
			
			Endif
			
			TRB->(dbskip())
			
		EndDo
	
	//VERIFICA SE HOUVE ERRO NA TRANSAÇÃO - se houve disarma a transação
	If nValorTot > 0
		GeraNewSE1(nValorTot,.f.)
	Endif

	//FINALIZA A TRANSAÇÃO 		
	End Transaction
		
Return
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