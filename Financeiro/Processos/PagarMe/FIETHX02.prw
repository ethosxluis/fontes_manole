#Include 'Protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "tbiconn.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH" 

Static aTitRA 			:= {}
Static aTitRAMark 		:= {}
Static aTitOkMark 		:= {}
Static aTitParcialMark 	:= {}

/*/{Protheus.doc} FIETHX02
Função principal responsável pela chamada do CSV
@type function
@author Fernando Carvalho
@since  01/05/2018
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function FIETHX02()
	Local aArea			:=	SaveArea1({"SE1"})
	Local oDlg			:= NIL
	Local nOpc			:= 0
	Local cTitle		:= 'Importação de Titulos Via CSV'
	Local cText			:= '"Atenção" colocar o caminho completo do CSV'
	Local cDesc			:= 'Selecione o Arquivo a ser importado'
	Local lSalvar		:= .T.
	Local nFiltros		:= nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY)
	Local cFile			:= ""
	Local cExtens		:= "Arquivos CSV | *.CSV"

	aTitRA 				:= {}
	aTitRAMark 			:= {} //Titulo de RA
	aTitTRMark 			:= {} //titulo de transferencia
	aTitOkMark 			:= {}
	aTitParcialMark 	:= {}

	Private aRetInf		:= {}
	Private aErros 		:= {}
	Private cMarca	 	:= GetMark()
	Private nValorBruto := 0
	


	@ 200,001 TO 405,366 DIALOG oDlg TITLE cTitle
	@ 003,003 TO 098,182
	@ 025,025 SAY cText COLOR CLR_BLUE PIXEL OF oDlg


	@ 048,018 SAY cDesc PIXEL OF oDlg
	@ 058,018 MSGET oGetFile VAR cFile SIZE 140,006 PIXEL OF oDlg

	@ 053,160 BUTTON "..." SIZE 012,012 ACTION {|| cFile := cGetFile(cExtens,cTitLE,,,lSalvar,nFiltros)} PIXEL OF oDlg
	@ 080,098 BUTTON "Continuar"  SIZE 035,012 ACTION Processa({|| nOpc := ImpPagarMe(cFile),Close(oDlg)},"Importando Arquivo...") PIXEL OF oDlg
	@ 080,140 BUTTON "Sair" SIZE 035,012 ACTION Close(oDlg) PIXEL OF oDlg

	ACTIVATE DIALOG oDlg CENTERED

	
	if nOpc == 1

//ImpPagarMe('C:\Users\gueld\Downloads\PagarMe_07.07.csv')

		Processa({|| aErros := u_FIETHX03(aRetInf)},"Processando Arquivo...")
		MsgAlert("Arquivo Processado.")
	Endif	

	If !Empty(aErros)
		If MsgYesNo(	 "Alguns registros não foram executados."+ CRLF;
						+"Deseja visualizar os erros?")  
			
			TelaErro(aErros)
		EndIf	
	EndIf
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

	Local cParcela		:= ''
	Local aRetSE1		:= {}
	Local nopc			:= 0
	Local nPosIdOp		:= 0
	Local nPosValEnt	:= 0
	Local nPosParcel	:= 0
	Local nLoop			:= 0
	Local nLoop2		:= 0
	Local nValTit		:= 0
	Local nValorTot		:= 0
	Local nTolerancia	:= 0.10
	Local nValorBaixa 	:= 0		
	Local aClient		:= {}
	
	aErros 	:= {}
	aTitRA 	:= {}	//VARIAVEL PARA ARMAZENAR OS TITULOS QUE SERÃO GERADOS 'RA'
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
		aAdd(aRetInf, Separa(Replace(cMemo+",9999999999", ".",""), ",", .T.))
		If len(aRetInf) = 1
			aadd(aRetInf[len(aRetInf)],"Cliente")
			aadd(aRetInf[len(aRetInf)],"Loja")
			aadd(aRetInf[len(aRetInf)],"Filial")
		else
			aadd(aRetInf[len(aRetInf)],"")
			aadd(aRetInf[len(aRetInf)],"")
			aadd(aRetInf[len(aRetInf)],"")
		EndIf
		FT_FSkip()
	EndDo
	FT_FUse() // Fecha o arquivo
	aRetInf[1] := {'DTOPER','TPOPER','IDOPER','DESCRI','IDTRAN','PARCEL','METPGTO','ENTBRU','SAIBRU','TXOPER','TXANT','TXTOTAL','ENTLIQ','SAILIQ','RECNO','Cliente','Loja','Filial'}
	If !(Empty(aRetInf))
		nPosData	:= 1
		nPosTipOp	:= 2
		nPosIdOp	:= 5
		nPosParcel	:= 6
		nPosValEnt	:= 13//8
		nRecno		:= 15
		nCLient		:= 16
		nLoja		:= 17
		nFilial		:= 18
		nPosVlBrut	:= 8
		nValBrut	:= 0
		ProcRegua(Len(aRetInf))
		
		//posiciona nas informações do titulo
		DbSelectArea("SE1")
		SE1->(DbOrderNickName("IDVETEX"))
		ProcRegua(Len(aRetInf))
		For nLoop := 2 To Len(aRetInf)
			IncProc("Analisando Arquivo...")
			
			If (SubStr(aRetInf[nLoop,nPosTipOp],0,7) == 'payable') 
				cId := AllTrim(aRetInf[nLoop,nPosIdOp])

				nValTit := Val(aRetInf[nLoop,nPosValEnt])/100
				nValBrut := Val(aRetInf[nLoop,nPosVlBrut])/100
				If  (nValTit <= 0)
					LOOP
				EndIf
				
				cParcela := aRetInf[nLoop,nPosParcel]
				If cParcela == '-'
					cParcela := ''
				Else
					cParcela := u_RetParcela(aRetInf[nLoop,nPosParcel])
				Endif
				
				lSemParcela := .F.				
				If aRetInf[nLoop,7] == "credit_card" 
					lSemParcela := .T. // Alguns registros pode não conter parcela no protheus, mas vem no arquivo
				Endif
				
				aTitulosSE1	:= u_GetTitulo(cId,cParcela,lSemParcela)
				
				If Empty(aTitulosSE1)
					//aClient := BuscaCli(cId)
					//If !Empty(aClient)
					aRetInf[nLoop,nCLient] 	:= "999999"
					aRetInf[nLoop,nLoja]	:= "99"
						//aRetInf[nLoop,nCLient] 	:= aClient[1]
						//aRetInf[nLoop,nLoja]	:= aClient[2]
					//EndIF
				EndIf

				For nLoop2 := 1 To Len(aTitulosSE1)
					//tratamento para alterar a filial
					If !(cfilant ==  SubStr(aTitulosSE1[nLoop2,1],1,2))
						cfilant :=  SubStr(aTitulosSE1[nLoop2,1],1,2)
					EndIf
					nValorBaixa := 0
					lParcial 	:= .F.

					SE1->(DbsetOrder(1))
					lAchou := SE1->(Dbseek(aTitulosSE1[nLoop2,1]))
					If lAchou
						aRetInf[nLoop,nRecno] := AllTrim(Str(SE1->(RECNO()))) //GUARDA O RECNO PARA FUTURO POSICIONAMENTO NA FIETHX03
						aRetInf[nLoop,nFilial] := SubStr(aTitulosSE1[nLoop2,1],1,2) //GUARDA O RECNO PARA FUTURO POSICIONAMENTO NA FIETHX03
						//Salvar Cliente
						aRetInf[nLoop,nCLient] 	:= SE1->E1_CLIENTE
						aRetInf[nLoop,nLoja]	:= SE1->E1_LOJA
						//Salvar Cliente
						
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
							If !(lParcial)																
								aAdd(aTitOkMark,{aclone(aRetInf[nLoop])})
								aTitOkMark[Len(aTitOkMark),1,8] := AllTrim(STR(nValBrut))
								aTitOkMark[Len(aTitOkMark),1,13] := AllTrim(STR(nValorBaixa))
							Else	
								aAdd(aTitParcialMark,{aclone(aRetInf[nLoop])})
								
								aTitParcialMark[Len(aTitParcialMark),1,8] := AllTrim(STR(nValBrut))
								aTitParcialMark[Len(aTitParcialMark),1,13] := AllTrim(STR(nValorBaixa))
							Endif
						Endif															
							
						If (nValorBaixa > 0) 
							nValorTot	+= nValorBaixa
						Endif
						
					EndIf										
				Next
				
				//VERIFICIA SE VAI GERAR UMA RA PARA O CLIENTE
				If nvalTit > nTolerancia
					nValorTot += nvalTit
					//aRetInf[nLoop,8] := str(nvalTit)
					aAdd(aTitRAMark,{aclone(aRetInf[nLoop])})
					aTitRAMark[Len(aTitRAMark),1,8] := AllTrim(STR(nValBrut))
					aTitRAMark[Len(aTitRAMark),1,13] := AllTrim(STR(nvalTit))
				Endif
			ELseIf (ALLTRIM(aRetInf[nLoop,nPosTipOp]) == 'transfer') 	
				nValTit := Val(aRetInf[nLoop,nPosValEnt])/100
				nValBrut := Val(aRetInf[nLoop,nPosVlBrut])/100
				cfilant := (aRetInf[nLoop,nFilial]) := "01"
				aAdd(aTitTRMark,{aclone(aRetInf[nLoop])})
				aTitTRMark[Len(aTitTRMark),1,8] := AllTrim(STR(nValBrut))
				aTitTRMark[Len(aTitTRMark),1,13] := AllTrim(STR(nValTit))
				aTitTRMark[Len(aTitTRMark),1,18] := AllTrim("01")
//				GeraNewSE1(aRetInf[nLoop,14]*-1)
			Endif
		Next
	Endif
	nValorBruto := nValorTot
	nopc := TelaMark(aRetInf,aTitRAMark,aTitOkMark,aTitParcialMark,aTitTRMark,nValorTot)//abre a tela para marcação
Return nopc


/*/{Protheus.doc} FIETHX02
Função para exibir os registros na MSSELECT
@type function
@author Fernando Carvalho
@since  20/10/2018
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function TelaMark(aRetInf,aTitRAMark,aTitOkMark,aTitParcialMark,aTitTRMark,nValorTot)
	Local oSize			:= nil
	Local oFontArial18	:= TFont():New('arial',,-18,.T.)
	Local a2ndRow		:= {}
	Local aColuna		:= {}
	Local nLoop			:= 0
	Local nLoop2		:= 0
	Local nOpc			:= 0
	Local lInverte		:= .F.
	Local aTemp 		:= {}
	Local aColors		:= {}
	Local cTransf		:= ''
	
	Private aCampos 	:= {}
	
	//Campos que serão exibidos na tela
	Aadd(aCampos,{"X1_OK" 		,"",""})
	
	Aadd(aTemp,{"X1_OK" 		,"C",02})
	
	For nLoop := 1 to Len(aRetInf[1])	
		If nLoop == 8 
			Aadd(aTemp,{aRetInf[1][nLoop],"N",12,2})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@E 9,999,999.99"})
		ElseIf 	nLoop == 13 
			Aadd(aTemp,{aRetInf[1][nLoop],"N",12,2})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@E 9,999,999.99"})	
		ElseIf 	nLoop == 9 
			Aadd(aTemp,{aRetInf[1][nLoop],"N",12,2})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@E 9,999,999.99"})		
		ElseIf 	nLoop == 14
			Aadd(aTemp,{aRetInf[1][nLoop],"N",12,2})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@E 9,999,999.99"})				
		ElseIf nLoop == 15	
		 	Aadd(aTemp,{aRetInf[1][nLoop],"N",10})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@E 9999999999"})
		ElseIf nLoop == 5
		 	Aadd(aTemp,{aRetInf[1][nLoop],"C",50})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@!"})
		Else	
			Aadd(aTemp,{aRetInf[1][nLoop],"C",30,0})
			Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@!"})
		EndIf	
	Next
	
	Aadd(aTemp,{"X1_TIPO" 		,"C",02})

	cArqTmp := CriaTrab(aTemp)
  	
	If Select("TRB")<>0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	dbUseArea( .T.,, cArqTmp, "TRB", .F., .F. )
	
	//Obtém os Dados()
	//RA
	For nLoop := 1 to Len(aTitRAMark)	
		xnada:= ""
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := ""//cMarca
		For nLoop2 := 1 to Len(aTitRAMark[nLoop][1]) 
			If aTitRAMark[nLoop][1][16] <> ''
				nLoop2 := nLoop2
			EndIF
			If nLoop2 == 8 .OR. nLoop2 == 15
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitRAMark[nLoop][1][nLoop2])
			ElseIf 	nLoop2 == 13 
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitRAMark[nLoop][1][nLoop2])
			ElseIf 	nLoop2 == 9 
				TRB->&(aTemp[nLoop2+1, 1]) := (Val(aTitRAMark[nLoop][1][nLoop2])*-1)
			ElseIf 	nLoop2 == 14 
				TRB->&(aTemp[nLoop2+1, 1]) := (Val(aTitRAMark[nLoop][1][nLoop2])*-1)
			Else
				TRB->&(aTemp[nLoop2+1, 1]) := aTitRAMark[nLoop][1][nLoop2] 	
			Endif	
			If nLoop2 == 18 .And.  (Empty(aTitRAMark[nLoop][1][18]) .Or. aTitRAMark[nLoop][1][18] == "99")
				xNada:="1"
			EndIf
		Next	
		If !Empty(xNada)
			TRB->X1_TIPO := "XX"			
		Else	
			TRB->X1_TIPO := "RA"
		EndIf
		xNada:=""
		TRB->(MsUnlock())
	Next
	//PARCIAL
	For nLoop := 1 to Len(aTitParcialMark)	
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := cMarca
		For nLoop2 := 1 to Len(aTitParcialMark[nLoop][1])
			If nLoop2 == 8 .OR. nLoop2 == 15
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitParcialMark[nLoop][1][nLoop2])
			ElseIf 	nLoop2 == 13 
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitParcialMark[nLoop][1][nLoop2])	
			ElseIf 	nLoop2 == 9 
				TRB->&(aTemp[nLoop2+1, 1]) := (Val(aTitParcialMark[nLoop][1][nLoop2])*-1)
			ElseIf 	nLoop2 == 14 
				TRB->&(aTemp[nLoop2+1, 1]) := (Val(aTitParcialMark[nLoop][1][nLoop2])*-1)
			
			Else
				TRB->&(aTemp[nLoop2+1, 1]) := aTitParcialMark[nLoop][1][nLoop2] 	
			Endif	
		Next	
		TRB->X1_TIPO := "PC"
		TRB->(MsUnlock())
	Next
	//OK
	For nLoop := 1 to Len(aTitOkMark)
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := cMarca
		For nLoop2 := 1 to Len(aTitOkMark[nLoop][1])
			If nLoop2 == 8 .OR. nLoop2 == 15
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitOkMark[nLoop][1][nLoop2])
			ElseIf 	nLoop2 == 13 
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitOkMark[nLoop][1][nLoop2])	
			ElseIf 	nLoop2 == 9 
				TRB->&(aTemp[nLoop2+1, 1]) := (Val(aTitOkMark[nLoop][1][nLoop2])*-1)
			ElseIf 	nLoop2 == 14 
				TRB->&(aTemp[nLoop2+1, 1]) := (Val(aTitOkMark[nLoop][1][nLoop2])*-1)
			
			Else
				TRB->&(aTemp[nLoop2+1, 1]) := aTitOkMark[nLoop][1][nLoop2] 	
			Endif				
		Next
		TRB->X1_TIPO := "OK"
		TRB->(MsUnlock())
	Next

	//Transferencia
	For nLoop := 1 to Len(aTitTRMark)	
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := ""//cMarca
		cfilant := "01"
		For nLoop2 := 1 to Len(aTitTRMark[nLoop][1]) 
			If aTitTRMark[nLoop][1][16] <> ''
				nLoop2 := nLoop2
			EndIF
			If nLoop2 == 8 .OR. nLoop2 == 15
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitTRMark[nLoop][1][nLoop2])
			ElseIf 	nLoop2 == 13 
				TRB->&(aTemp[nLoop2+1, 1]) := Val(aTitTRMark[nLoop][1][nLoop2])	
			ElseIf 	nLoop2 == 9 
				cTransf:= substr(aTitTRMark[nLoop][1][nLoop2],1,len(aTitTRMark[nLoop][1][nLoop2])-2)+'.'+substr(aTitTRMark[nLoop][1][nLoop2],len(aTitTRMark[nLoop][1][nLoop2])-1,len(aTitTRMark[nLoop][1][nLoop2]))
				TRB->&(aTemp[nLoop2+1, 1]) := val(cTransf)*-1
			ElseIf 	nLoop2 == 14 
				cTransf:= substr(aTitTRMark[nLoop][1][nLoop2],1,len(aTitTRMark[nLoop][1][nLoop2])-2)+'.'+substr(aTitTRMark[nLoop][1][nLoop2],len(aTitTRMark[nLoop][1][nLoop2])-1,len(aTitTRMark[nLoop][1][nLoop2]))
				TRB->&(aTemp[nLoop2+1, 1]) := val(cTransf)*-1
			Else
				TRB->&(aTemp[nLoop2+1, 1]) := aTitTRMark[nLoop][1][nLoop2] 	
			Endif	
			
		Next	
		TRB->X1_TIPO := "TR"
		TRB->(MsUnlock())
	Next
	
	TRB->(dbGoTop())
	
	//cores da msselect -legenda
	AADD(aColors,{ 'TRB->X1_TIPO == "OK"'   , "BR_VERDE"})
	AADD(aColors,{ 'TRB->X1_TIPO == "PC"'   , "BR_AMARELO"})
	AADD(aColors,{ 'TRB->X1_TIPO == "RA"'   , "BR_VERMELHO"})
	AADD(aColors,{ 'TRB->X1_TIPO == "TR"'   , "BR_AZUL"})
	AADD(aColors,{ 'TRB->X1_TIPO == "XX"'   , "BR_BRANCO"})	
	
	//TRATAMENTO PARA EXIBIR AS TELAS
	oSize := FwDefSize():New(.T.)
	
	oSize:lLateral	:= .F.
	oSize:lProp		:= .T. // Proporcional
	
	oSize:AddObject( "1STROW" ,  100, 10, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "2NDROW" ,  100, 90, .T., .T. ) // Totalmente dimensionavel
		
	oSize:aMargins	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3

	oSize:Process() // Dispara os calculos
	
	a1stRow := {	oSize:GetDimension("1STROW","LININI"),;
		oSize:GetDimension("1STROW","COLINI"),;
		oSize:GetDimension("1STROW","LINEND"),;
		oSize:GetDimension("1STROW","COLEND")}
					
	a2ndRow := {	oSize:GetDimension("2NDROW","LININI"),;
		oSize:GetDimension("2NDROW","COLINI"),;
		oSize:GetDimension("2NDROW","LINEND"),;
		oSize:GetDimension("2NDROW","COLEND")}
					
	DEFINE MSDIALOG oDlg2 TITLE 'titulo' From oSize:aWindSize[1],oSize:aWindSize[2] to oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL
	oDlg2:lMaximized := .T.
	//------------------------------------------------------------------------------------------------------------------------
	//Painel 1 - Informações
	//------------------------------------------------------------------------------------------------------------------------
	nLinha		:= 10//a1stRow[1] + 3
	nSize 		:= 150
	aColuna		:={a1stRow[2],,,}
	aColuna[2]	:=aColuna[1]+nSize+100
	aColuna[3]	:=aColuna[2]+150
	aColuna[4]	:=aColuna[3]+nSize+5
	//@nLinha,aColuna[1] Say "Saldo anterior (CNAB)" + " (" + "Bancario" + ")"SIZE nSize,10 PIXEL Of oDlg
	oSay1 := TSay():New(nLinha,aColuna[1],{||"Valor do Arquivo:"},oDlg2,,oFontArial18,,,,.T.,,,nSize,100,,,,,,)
	
	
	nLinha += 9
	oValAtu := TSay():New(nLinha,aColuna[1],{||"R$ " + AllTrim(Transform( nValorTot, "@E 99,999,999.99"))},oDlg2,,oFontArial18,,,,.T.,CLR_RED,,nSize,100,,,,,,)
	nLinha += 18
	
	//Botões da tela
	oTButton1 := TButton():New( nLinha, aColuna[1]		, "Processar"	,oDlg2,{|| nOpc := 1, oDlg2:End()}	, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( nLinha, aColuna[1]+100	, "Legenda"		,oDlg2,{||Legenda()}				, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( nLinha, aColuna[1]+200	, "Excel"		,oDlg2,{|| GerExc()}				, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( nLinha, aColuna[1]+300	, "Sair"		,oDlg2,{|| nOpc := 0, oDlg2:End()}	, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	//------------------------------------------------------------------------------------------------------------------------
	//Painel 2 - MsSelect
	//------------------------------------------------------------------------------------------------------------------------	
	oMark := MsSelect():New("TRB","X1_OK","",aCampos,@lInverte,@cMarca,{a2ndRow[1],a2ndRow[2],a2ndRow[3],a2ndRow[4]},,,oDlg2,,aColors)
	oMark:oBrowse:lColDrag := .T.
	oMark:oBrowse:bAllMark := { || Inverte(cMarca)}
	
	ACTIVATE MSDIALOG oDlg2  CENTERED
	
	
Return nOpc

Static Function Legenda()
    LOCAL aLegenda  	:= 	{}
    
    AADD(aLegenda,{"BR_VERDE"   	, "OK"})      // "Desbloqueado e Indice atualizado"
    AADD(aLegenda,{"BR_AMARELO" 	, "Parcial"})      // "Desbloqueado e Indice desatualizado"    
    AADD(aLegenda,{"BR_VERMELHO" 	, "RA"})      		// "Desbloqueado porem Bloqueado por Indice"
	AADD(aLegenda,{"BR_AZUL" 		, "Transferido"})      // "Desbloqueado porem Bloqueado por Indice"
	AADD(aLegenda,{"BR_BRANCO" 		, "Sem Titulo"})      // "Desbloqueado porem Bloqueado por Indice"

	BrwLegenda("Legenda","Legenda", aLegenda)  
Return
Static Function Inverte(cMarca)
	Local nReg 		:= TRB->(Recno())
	
	DbSelectArea("TRB")
	DbGoTop()

	While TRB->(!Eof())
		If TRB->X1_OK == cMarca
			RecLock("TRB",.F.)
			TRB->X1_OK := ''
			TRB->(MsUnlock())
		Else
			RecLock("TRB",.F.)
			TRB->X1_OK := cMarca
			TRB->(MsUnlock())
		Endif
		TRB->(dbskip())
	EndDo
	TRB->(DbGoTo(nReg))
	
Return(NIL)


User Function GetTitulo(cId,cParcela,lSemParcela)
	
	Local cQuery 	:= " "
	Local cSE1		:= getNextAlias()
	Local aRetSE1	:= {}
	
	cQuery := " SELECT  " + CRLF
	cQuery += " E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO" + CRLF
	cQuery += " FROM " + RetSqlName("SE1") +  CRLF
	cQuery += " WHERE
	// E1_FILIAL = '" + xFilial("SE1") + "'  and " + CRLF
	cQuery += " D_E_L_E_T_ = ' '"
	cQuery += " AND E1_TIPO ='NF'
	cQuery += " AND E1_PGVTTID = '" + cId + "'"
	cQuery += " AND (E1_PARCELA = '" + cParcela + "'"
	
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
	
	(cSE1)->(dbCloseArea())


Return aRetSE1



/*/{Protheus.doc} GetFIETHX02
Função para que possa realizar a chamada via Job
@author Fernando Carvalho
@since 01/05/2018
/*/
User Function XFIETHX02()
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	
	/*RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv('99','01')*/
	
	U_FIETHX02()
Return


Static Function GerExc()
	Local nLoop
	Local oExcel := FWMSEXCEL():New()

	oExcel:AddworkSheet("PAGAR.ME")

	oExcel:AddTable("PAGAR.ME","TAB TITULOS PG")
	
	oExcel:AddColumn("PAGAR.ME","TAB TITULOS PG","Tipo titulo",1,1)
	For nLoop := 1 To Len(aRetInf[1])
		If nLoop == 8  //numerico
				oExcel:AddColumn("PAGAR.ME","TAB TITULOS PG",aRetInf[1,nLoop],1,2)
		Else	//alfanumerico
				oExcel:AddColumn("PAGAR.ME","TAB TITULOS PG",aRetInf[1,nLoop],1,1)
		EndIf	
	Next
	
	//RA
	For nLoop := 1 To Len(aTitRAMark)
		oExcel:AddRow('PAGAR.ME',"TAB TITULOS PG",{;
		"RA",;
		 aTitRAMark[nLoop,1,1],;
		 aTitRAMark[nLoop,1,2],;
		 aTitRAMark[nLoop,1,3],;
		 aTitRAMark[nLoop,1,4],;
		 aTitRAMark[nLoop,1,5],;
		 aTitRAMark[nLoop,1,6],;
		 aTitRAMark[nLoop,1,7],;
		 StrTran(aTitRAMark[nLoop,1,8],'.',','),;
		 StrTran(aTitRAMark[nLoop,1,9],'.',','),;//   /100,;
		 aTitRAMark[nLoop,1,10],;//   /100,;
		 aTitRAMark[nLoop,1,11],;//   /100,;
		 aTitRAMark[nLoop,1,12],;//   /100,;
		 aTitRAMark[nLoop,1,13],;//   /100,;
		 StrTran(aTitRAMark[nLoop,1,14],'.',','),;//   /100;
		 aTitRAMark[nLoop,1,15],;//   /100,;
		 aTitRAMark[nLoop,1,16],;//   /100;
		 aTitRAMark[nLoop,1,17],;
		 aTitRAMark[nLoop,1,18];
		 })
	Next
	//RA
	For nLoop := 1 To Len(aTitParcialMark)
		oExcel:AddRow('PAGAR.ME',"TAB TITULOS PG",{;
		"PARCIAL",;
		 aTitParcialMark[nLoop,1,1],;
		 aTitParcialMark[nLoop,1,2],;
		 aTitParcialMark[nLoop,1,3],;
		 aTitParcialMark[nLoop,1,4],;
		 aTitParcialMark[nLoop,1,5],;
		 aTitParcialMark[nLoop,1,6],;
		 aTitParcialMark[nLoop,1,7],;
		 StrTran(aTitParcialMark[nLoop,1,8],'.',','),;
		 StrTran(aTitParcialMark[nLoop,1,9],'.',','),;//   /100,;
		 aTitParcialMark[nLoop,1,10],;//   /100,;
		 aTitParcialMark[nLoop,1,11],;//   /100,;
		 aTitParcialMark[nLoop,1,12],;//   /100,;
		 aTitParcialMark[nLoop,1,13],;//   /100,;
		 StrTran(aTitParcialMark[nLoop,1,14],'.',','),;//   /100;
		 aTitParcialMark[nLoop,1,15],;//   /100,;
		 aTitParcialMark[nLoop,1,16],;//   /100;		 
		 aTitParcialMark[nLoop,1,17],;
		 aTitParcialMark[nLoop,1,18];
		 })
	Next

	//RA
	For nLoop := 1 To Len(aTitOkMark)
		oExcel:AddRow('PAGAR.ME',"TAB TITULOS PG",{;
		"OK",;
		 aTitOkMark[nLoop,1,1],;
		 aTitOkMark[nLoop,1,2],;
		 aTitOkMark[nLoop,1,3],;
		 aTitOkMark[nLoop,1,4],;
		 aTitOkMark[nLoop,1,5],;
		 aTitOkMark[nLoop,1,6],;
		 aTitOkMark[nLoop,1,7],;
		 StrTran(aTitOkMark[nLoop,1,8],'.',','),;
		 StrTran(aTitOkMark[nLoop,1,9],'.',','),;//   /100,;
		 aTitOkMark[nLoop,1,10],;//   /100,;
		 aTitOkMark[nLoop,1,11],;//   /100,;
		 aTitOkMark[nLoop,1,12],;//   /100,;
		 aTitOkMark[nLoop,1,13],;//   /100,;
		 StrTran(aTitOkMark[nLoop,1,14],'.',','),;//   /100;
		 aTitOkMark[nLoop,1,15],;//   /100,;
		 aTitOkMark[nLoop,1,16],;//   /100;
		 aTitOkMark[nLoop,1,17],;
		 aTitOkMark[nLoop,1,18];
		 })
	Next

	For nLoop := 1 To Len(aTitTRMark)
		oExcel:AddRow('PAGAR.ME',"TAB TITULOS PG",{;
		"TR",;
		 aTitTRMark[nLoop,1,1],;
		 aTitTRMark[nLoop,1,2],;
		 aTitTRMark[nLoop,1,3],;
		 aTitOkMark[nLoop,1,4],;
		 aTitOkMark[nLoop,1,5],;
		 aTitOkMark[nLoop,1,6],;
		 aTitOkMark[nLoop,1,7],;
		 StrTran(aTitTRMark[nLoop,1,8],'.',','),;
		 StrTran(aTitTRMark[nLoop,1,9],'.',','),;//   /100,;
		 aTitTRMark[nLoop,1,10],;//   /100,;
		 aTitTRMark[nLoop,1,11],;//   /100,;
		 aTitTRMark[nLoop,1,12],;//   /100,;
		 aTitTRMark[nLoop,1,13],;//   /100,;
		 StrTran(aTitTRMark[nLoop,1,14],'.',','),;//   /100;
		 aTitTRMark[nLoop,1,15],;//   /100,;
		 aTitTRMark[nLoop,1,16],;//   /100;
		 aTitTRMark[nLoop,1,17],;//   /100;
		 aTitTRMark[nLoop,1,18];//   /100;
		 })
	Next

	oExcel:Activate()
	oExcel:GetXMLFile("\pagarme.xml")
	Makedir("c:\temp")
	Makedir("c:\temp\pagarme")
	__CopyFile("\pagarme.xml","c:\temp\pagarme\pagarme.xml")
	shellExecute("Open", "c:\temp\pagarme\pagarme.xml", " /k dir", "C:\", 1 )
Return


Static Function TelaErro(aErros)
	Local oDlg
	Local oBrowse
	Local aBrowse	:= {}
	Local nFor		:= 0
		
	//{'DTOPER','TPOPER','IDOPER','DESCRI','IDTRAN',
	//'PARCEL','METPGTO','ENTBRU','SAIBRU',
	//'TXOPER','TXANT','TXTOTAL','ENTLIQ','SAILIQ',
	//'RECNO'}	
	For nFor := 1 To Len(aErros)
		aAdd(aBrowse,{	aErros[nFor,01],aErros[nFor,02],aErros[nFor,03],aErros[nFor,04],aErros[nFor,05],;
						aErros[nFor,06],aErros[nFor,07],aErros[nFor,08],aErros[nFor,09],aErros[nFor,10],;
						aErros[nFor,11],aErros[nFor,12],aErros[nFor,13],aErros[nFor,14],aErros[nFor,15],;
						aErros[nFor,16],aErros[nFor,17],aErros[nFor,18],;
						aErros[nFor,19]})
	Next 	
	DEFINE DIALOG oDlg TITLE "Erros dos SE1's" FROM 180,180 TO 550,700 PIXEL
	
		oBrowse := TcBrowse():New( 01 , 01, 260,184,,;
								{'DTOPER','TPOPER','IDOPER','DESCRI','IDTRAN',;
								'PARCEL','METPGTO','ENTBRU','SAIBRU','TXOPER',;
								'TXANT','TXTOTAL','ENTLIQ','SAILIQ','RECNO','Cliente','Loja','Filial','Erro'},;
								{20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,250},;
								oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
		oBrowse:SetArray(aBrowse) 
		oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],;
							 aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07],aBrowse[oBrowse:nAt,08],aBrowse[oBrowse:nAt,09],aBrowse[oBrowse:nAt,10],;
							 aBrowse[oBrowse:nAt,11],aBrowse[oBrowse:nAt,12],aBrowse[oBrowse:nAt,13],aBrowse[oBrowse:nAt,14],aBrowse[oBrowse:nAt,15],;
							 aBrowse[oBrowse:nAt,16],aBrowse[oBrowse:nAt,17],aBrowse[oBrowse:nAt,18],aBrowse[oBrowse:nAt,19] } }
		
		TButton():New( 160, 082, "Visualizar"	, oDlg,{||VisualErro(oBrowse,aErros) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		TButton():New( 160, 202, "Sair"			, oDlg,{||oDlg:End() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		ACTIVATE DIALOG oDlg CENTERED
return

Static Function VisualErro(oBrowse,aErros)
	Local oDlg 	:= nil
	Local oEdit 	:= nil 
		
  	DEFINE DIALOG oDlg TITLE "Erro PV" FROM 180, 180 TO 550, 700 PIXEL
  		oEdit := tSimpleEditor():New(0, 0, oDlg, 260, 184)
  		oEdit:Load(aErros[oBrowse:nAt,19])
  ACTIVATE DIALOG oDlg CENTERED
Return


STATIC function BuscaCli(cTid)

	Local cQuery 		:= ""
	Local cAliasQry		:=	GetNextAlias()
	Local aRet			:= {}
	
	cQuery += " SELECT C5_CLIENTE, C5_LOJACLI "
	cQuery += " FROM " + RETSQLNAME("SC5") + " C5 (NOLOCK)"
	cQuery += " WHERE C5.D_E_L_E_T_ =''"
	cQuery += " AND C5_XTID LIKE( '%" + cTid + "%' )"

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )

	(cAliasQry)->(dbGoTop())

	iF ! (cAliasQry)->(Eof())
		aADD(aRet,(cAliasQry)->C5_CLIENTE)
		aADD(aRet,(cAliasQry)->C5_LOJACLI)
	Else
		DbSelectArea("ZZH")
		ZZH->(Dbsetorder(1))
		If ZZH->(DBseek(xFilial("ZZH")+cTid))
			DbSelectArea("SA1")
			SA1->(Dbsetorder(3))
			If	SA1->(DBseek(xFilial("SA1")+ZZH->ZZH_CGC))
				aADD(aRet,SA1->A1_COD)
				aADD(aRet,SA1->A1_LOJA)
			EndIF
		EndIF
	EndIF
Return aRet
