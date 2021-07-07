#Include 'Protheus.ch'

User Function FIETHX03(aRetInf)	

	Local aRetSE1		:= {}	
	Local aForPag		:= {}
	Local cBody			:= ""
	Local cBodyIni		:= ""
	Local cEmail		:= ""
	Local nTaxabco 	:= getmv("FS_TXBOL",.T.,2.40) //TAXA BOLETO
	Local nTxPARC1 	:= getmv("FS_TXPARC1",.T.,2.29) //TAXA a partir de 1 parcela 
	Local nTxPARC2 	:= getmv("FS_TXPARC2",.T.,2.74) //TAXA a partir de 2 parcela 
	Local nTxPARC3 	:= getmv("FS_TXPARC3",.T.,3.13) //TAXA a partir de 7 parcela 
	Local nTxANTEC 	:= getmv("FS_TXANTEC",.T.,2.49) //TAXA de antecipação 
	Local cPagFil 	:= getmv("FS_PAGFILI",.T.,"02") //Filial para gerar SE2 
	Local cNCCBOL 	:= getmv("FS_NCCBOL",.T.,"02") //Filial para gerar SE1 NCC ou BOL
	Local nTxTit	:= 0
	Local nTXTotal  := 0
	Local nCondPag	:= 0
	Local lerro		:= .F.
	
	Private cMsgErro := ""

	ProcRegua(TRB->(RECCOUNT()))
	
	DbSelectArea("TRB")
	TRB->(DbGoTop())
	
	//posiciona nas informações do titulo
	dbSelectArea("SD2")
	SD2->(DBSETORDER(3))
	dbSelectArea("SC5")
	dbSelectArea("SE1")
	SE1->(DbOrderNickName("IDVETEX"))
	//{'DTOPER','TPOPER','IDOPER','DESCRI','IDTRAN','PARCEL','METPGTO','ENTBRU','SAIBRU','TXOPER','TXANT','TXTOTAL','ENTLIQ','SAILIQ','RECNO','Cliente','loja'}

	Begin Transaction

		While TRB->(!Eof()) 

			IncProc("Processando arquivo CSV...")

			If !Empty(TRB->X1_OK)
			
				If (TRB->X1_OK == cMarca) .AND. (!TRB->RECNO == 9999999999)
					
					SE1->(dbGoto(TRB->RECNO))
			
					If (TRB->X1_TIPO == "RA")

						if GeraNewSE1(TRB->ENTLIQ,.t.,,,,cNCCBOL)
							//cFilAnt := '01'
							lerro:= .T.
							aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA,TRB->FILIAL,cMsgErro})
						Endif	
			
					ElseIf 	TRB->X1_TIPO <> "XX"
					
						nTxTit 	:= IIF( VAL(TRB->TXOPER)>0, VAL(TRB->TXOPER)/100    ,(VAL(TRB->TXOPER)*-1)/100 )
						nValtit := TRB->ENTLIQ
						aRetSE1	:= BaixaSE1(SubStr(TRB->DTOPER,0,10),nValtit+nTxTit,nTxTit,TRB->FILIAL)
							
						If !aRetSE1[1] 
							lerro:= .T.
							aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA,TRB->FILIAL,cMsgErro})
						else

							//Encontra Nota
							If SD2->(DBSEEK(xFilial('SE1') + SE1->E1_NUM))
								//Encontra Pedido
								If SC5->(DBSEEK(xFilial('SC5') + SD2->D2_PEDIDO))
		
									//Encontra e forma de pagamento
									If SE4->(DBSEEK(xFilial('SE4') + SC5->C5_CONDPAG))
		
										//verifica em quantas parcelas a condição de pagameto esta dividida
										aForPag 	:= StrTokArr( SE4->E4_COND, "," )
										nCondPag 	:= Len(aForPag)
		
										If 'BOLETO' $ UPPER(ALLTRIM(TRB->METPGTO)) .AND. nTxTit > nTaxabco
											cBody += "Titulo " + SE1->E1_NUM + ", Parcela "+ SE1->E1_PARCELA +", Taxa " + alltrim(str(nTxTit)) + "<br>"
										ElseIf !('BOLETO' $ UPPER(TRB->METPGTO))  .AND. SE1->E1_VENCREA > dDatabase .AND. nTxTit > round(((nValtit*nTxANTEC)/100),2)
											cBody += "Titulo " + SE1->E1_NUM + ", Parcela "+ SE1->E1_PARCELA +", Taxa " + alltrim(str(nTxTit)) + "<br>"
										Elseif !('BOLETO' $ UPPER(TRB->METPGTO))  .AND. nCondPag <= 1 .AND. nTxTit > round(((nValtit*nTxPARC1)/100),2)
											cBody += "Titulo " + SE1->E1_NUM + ", Parcela "+ SE1->E1_PARCELA +", Taxa " + alltrim(str(nTxTit)) + "<br>"
										Elseif !('BOLETO' $ UPPER(TRB->METPGTO))  .AND. nCondPag >= 2 .AND. nCondPag < 7 .AND. nTxTit > round(((nValtit*nTxPARC2)/100),2)
											cBody += "Titulo " + SE1->E1_NUM + ", Parcela "+ SE1->E1_PARCELA +", Taxa " + alltrim(str(nTxTit)) + "<br>"
										Elseif !('BOLETO' $ UPPER(TRB->METPGTO))  .AND. nCondPag >= 7 .AND. nTxTit > round(((nValtit*nTxPARC3)/100),2)
											cBody += "Titulo " + SE1->E1_NUM + ", Parcela "+ SE1->E1_PARCELA +", Taxa " + alltrim(str(nTxTit)) + "<br>"
										EndIf
									EndIF
								EndIF
							EndIF
						EndIF
					EndIf

				ElseIf (TRB->X1_OK == cMarca) .AND. (TRB->RECNO == 9999999999) .AND. !EMPTY(TRB->CLIENTE) .AND. !EMPTY(TRB->LOJA)

					If (TRB->X1_TIPO == "RA")
						if GeraNewSE1(TRB->ENTLIQ,.t.,TRB->CLIENTE,TRB->LOJA,TRB->IDTRAN,cNCCBOL)
							lerro:= .T.
							aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA,TRB->FILIAL,cMsgErro})
						Endif	
					EndIf	
		
				ElseIf (TRB->X1_TIPO == "TR")	
						
					if GeraNewSE1(TRB->SAILIQ,.f.,,,,cNCCBOL)
						lerro:= .T.
						aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA,TRB->FILIAL,cMsgErro})
					Endif	
				ElseiF TRB->X1_TIPO <> "XX"
					lerro:= .T.
					aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA,TRB->FILIAL,cMsgErro})	
				EndIF

				nTXTotal 	+= IIF( VAL(TRB->TXOPER)>0, VAL(TRB->TXOPER)/100    ,(VAL(TRB->TXOPER)*-1)/100 )
			EndIF

			cMsgErro:= ""
				
			TRB->(dbskip())	 		
		EndDo
			
		//If nTXTotal > 0
			//If GeraNewSE2(nTXTotal,cPagFil) //gera SE2 com a taxa cobrada pelo banco
				//aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA})
				//aAdd(aErros,{ddatabase,"Geracao do SE2 taxa de banco","","","","","","","",nTXTotal,"",nTXTotal,"","","",alltrim(getmv('FS_NDFFORN',.T.,'F77840')),alltrim(getmv('FS_NDFLOJA',.T.,'01')),cPagFil,cMsgErro })
			//EndIF
		//EndIF
		
/*
		If nValtotal > 0
			if GeraNewSE1(nValtotal,.f.)
				aAdd(aErros,{TRB->DTOPER,TRB->TPOPER,TRB->IDOPER,TRB->DESCRI,TRB->IDTRAN,TRB->PARCEL,TRB->METPGTO,TRB->ENTBRU,TRB->SAIBRU,TRB->TXOPER,TRB->TXANT,TRB->TXTOTAL,TRB->ENTLIQ,TRB->SAILIQ,TRB->RECNO,TRB->CLIENTE,TRB->LOJA})
			Endif	
		EndIF
*/


		If !Empty(cBody) .And. !lerro
			cEmail := "marcelo.franca@ethosx.com.br"
			cEmail := getMV("FS_MAILTX",.T.,"cobrancas@manole.com.br;financeiro.cr@manole.com.br;lazaro@manole.com.br")
			cBodyIni := "A Taxa bancaria do(s) titulo(s) abaixo esta(ão) maior(es) do que o informado no parâmetro: " + "<br>"

			u_FSENVMAIL("Taxa bancaria", cBodyIni + cBody, cEmail)
		EndIf

	End Transaction
	
	cFilaAnt:= xFilial("SE1") 

Return aErros
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
Static function  BaixaSE1(cDat,nValTit,nTxOper,_cFilial)

	Local aBaixa 	:= {}
	Local cBanc 	:= alltrim(getmv('FS_PAGBANC'))
	Local cAg   	:= alltrim(getmv('FS_PAGAGEN')) + Space(5 - Len(getmv('FS_PAGAGEN')))
	Local cCONT 	:= alltrim(getmv('FS_PAGCONT'))
	Local cMotBx	:= alltrim(getmv('FS_PAGMOTB',.T.,'PAG'))
	Local cHist     := 'BAIXA ROTINA PAGAR.ME'
	Local lRet		:= .F.
	Local nLoop
	
	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica

	cFilAnt:= AllTrim(_cFilial)

	aBaixa := {;
		{"E1_FILIAL"   ,SE1->E1_FILIAL             ,Nil    },;
		{"E1_PREFIXO"  ,SE1->E1_PREFIXO            ,Nil    },;
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
		{"AUTDTBAIXA"  ,ctod(cDat)                 ,Nil    },;
		{"AUTDTCREDITO",ctod(cDat)                 ,Nil    },;
		{"AUTHIST"     ,cHist        			   ,Nil    },;
		{"AUTJUROS"    ,0                          ,Nil,.T.},;
		{"AUTDESCONT"  ,nTxOper                    ,Nil    },;
		{"AUTVALREC"   ,nValTit		               ,Nil    }}

	MSExecAuto({|x,y,z| Fina070(x,y,z)},aBaixa,3) // inclusão

	If lMsErroAuto
		aErrPCAuto	:= GETAUTOGRLOG()
		cMsgErro	:= ""
		For nLoop := 1 To Len(aErrPCAuto)
			cMsgErro += aErrPCAuto[nLoop]+ "<br>"
		Next
	Else		
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

Static function GeraNewSE1(nValor,lCliente,cCliRA, cLojaRA,cTID,_cFilial)
	
	Local cCliente	:= alltrim(getmv('FS_PAGCLI',.T.,'093632'))
	Local cLoja		:= alltrim(getmv('FS_PAGLOJA',.T.,'01'))
	Local cTipo		:= alltrim(getmv('FS_PAGTIPO',.T.,'BOL'))
	Local cNaturez	:= alltrim(getmv('FS_PAGNATU',.T.,'21000'))
	Local nLoop
	Local cNum

	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica

	cFilAnt:= AllTrim(_cFilial)
	//cFilAnt:= AllTrim("01")

	If Empty(cCliRA)

		
		If (cCliente == "093632" .and. cFilAnt == "02") 
			cFilAnt	:= "01"
			
			//Gera o contas a reeceber do pagar.me na filial 01
			DBSELECTAREA('SE1')
        	DbSetOrder(2) //filial+cliente+loja+prefixo_numero

			cNum := GetSxeNum("SE1","E1_NUM")	
			
        	While SE1->(DBSEEK(xFilial('SE1')+cCliente+cLoja+"   "+cNum))
				cNum := GetSxeNum("SE1","E1_NUM")
			EndDo

		Else
		 	cFilAnt := AllTrim(_cFilial)
			cNum := GetSxeNum("SE1","E1_NUM")

		EndIf

		aVetor := {	;
		{"E1_FILIAL" 	,cFilAnt								,Nil},;
		{"E1_PREFIXO" 	,''										,Nil},;
		{"E1_NUM"	  	,cNum  									,Nil},;
		{"E1_PARCELA" 	,''										,Nil},;
		{"E1_TIPO"	  	,Iif(lCliente,'NCC',cTipo)				,Nil},;
		{"E1_NATUREZ" 	,Iif(lCliente,SE1->E1_NATUREZ,cNaturez)	,Nil},;
		{"E1_CLIENTE" 	,Iif(lCliente,SE1->E1_CLIENTE,cCliente)	,Nil},;
		{"E1_LOJA"	  	,Iif(lCliente,SE1->E1_LOJA,cLoja)		,Nil},;
		{"E1_PGVTTID" 	,Iif(lCliente,SE1->E1_PGVTTID,'')		,Nil},;
		{"E1_EMISSAO" 	,dDataBase								,Nil},;
		{"E1_VENCTO"  	,dDataBase								,Nil},;
		{"E1_VENCREA" 	,dDataBase								,Nil},;
		{"E1_VALOR"		,nValor		 							,Nil}}
	else
		aVetor := {	;
		{"E1_FILIAL" 	,AllTrim(_cFilial)						,Nil},;
		{"E1_PREFIXO" 	,''										,Nil},;
		{"E1_NUM"	  	,GetSxeNum("SE1","E1_NUM")  			,Nil},;
		{"E1_PARCELA" 	,''										,Nil},;
		{"E1_TIPO"	  	,'NCC'									,Nil},;
		{"E1_NATUREZ" 	,cNaturez								,Nil},;
		{"E1_CLIENTE" 	,alltrim(cCliRA)						,Nil},;
		{"E1_LOJA"	  	,alltrim(cLojaRA)						,Nil},;
		{"E1_PGVTTID" 	,cTID									,Nil},;
		{"E1_EMISSAO" 	,dDataBase								,Nil},;
		{"E1_VENCTO"  	,dDataBase								,Nil},;
		{"E1_VENCREA" 	,dDataBase								,Nil},;
		{"E1_VALOR"		,nValor		 							,Nil}}
	EndIf

	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao
			
	If lMsErroAuto
		aErrPCAuto	:= GETAUTOGRLOG()
		cMsgErro	:= ""
		For nLoop := 1 To Len(aErrPCAuto)
			cMsgErro += aErrPCAuto[nLoop]+ "<br>"
		Next
	Else
		ConfirmSX8()
	EndIf

Return lMsErroAuto

Static function GeraNewSE2(nTXTotal,_cFilial)

	Local cFornec	:= alltrim(getmv('FS_NDFFORN',.T.,'F77840'))
	Local cLoja		:= alltrim(getmv('FS_NDFLOJA',.T.,'01'))
	Local cTipo		:= alltrim(getmv('FS_NDFTIPO',.T.,'NDF'))
	Local cNaturez	:= alltrim(getmv('FS_NDFNATU',.T.,'21000'))
	Local nLoop		:= 1

	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica

	cFilAnt:= AllTrim(_cFilial)
 
	aVetor := {	;
		{"E2_FILIAL" 	,AllTrim(_cFilial)						,Nil},;
		{"E2_PREFIXO" 	,''										,Nil},;
		{"E2_NUM"	  	,GetSxeNum("SE2","E2_NUM")  			,Nil},;
		{"E2_PARCELA" 	,''										,Nil},;
		{"E2_TIPO"	  	,cTipo									,Nil},;
		{"E2_NATUREZ" 	,cNaturez								,Nil},;
		{"E2_FORNECE" 	,cFornec								,Nil},;
		{"E2_LOJA"	  	,cLoja									,Nil},;
		{"E2_EMISSAO" 	,dDataBase								,Nil},;
		{"E2_VENCTO"  	,dDataBase								,Nil},;
		{"E2_VENCREA" 	,dDataBase								,Nil},;
		{"E2_VALOR"		,nTXTotal		 						,Nil}}
	
	MSExecAuto({|x,y| Fina050(x,y)},aVetor,3) //Inclusao
			
	If lMsErroAuto
		aErrPCAuto	:= GETAUTOGRLOG()
		cMsgErro	:= ""
		For nLoop := 1 To Len(aErrPCAuto)
			cMsgErro += aErrPCAuto[nLoop]+ "<br>"
		Next
	Else
		ConfirmSX8()
	EndIf

Return lMsErroAuto
