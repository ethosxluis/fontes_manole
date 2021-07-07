#Include 'Protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "tbiconn.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

Static aErros 			:= {}
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
	Local oEdit			:= NIL
	Local oDlg			:= NIL
	Local nRes          := 0
	Local nAtu          := 0
	Local nOpc			:= 0
	Local cTitle		:= 'Importação de Titulos Via CSV'
	Local cText			:= '"Atenção" colocar o caminho completo do CSV'
	Local cDesc			:= 'Selecione o Arquivo a ser importado'
	Local lSalvar		:= .T.
	Local nFiltros		:= nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY)
	Local cFile			:= ""
	Local cExtens		:= "Arquivos CSV | *.CSV"
	
	Private aRetInf		:= {}
	PRIVATE cMarca	 	:= GetMark()

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
		Processa({|| u_FIETHX03(aRetInf)},"Processando Arquivo...")
		MsgAlert("Arquivo Processado.")
	Endif	
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
	Local aRetSE1		:= {}
	Local nopc			:= 0
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
		aAdd(aRetInf, Separa(Replace(cMemo, ".",""), ",", .T.))
		
		FT_FSkip()
	EndDo
	FT_FUse() // Fecha o arquivo
	aRetInf[1] := {'DTOPER','TPOPER','IDOPER','DESCRI','IDTRAN','PARCEL','METPGTO','ENTBRU','SAIBRU','TXOPER','TXANT','TXTOTAL','ENTLIQ','SAILIQ'}
	If !(Empty(aRetInf))
		nPosData	:= 1
		nPosTipOp	:= 2
		nPosIdOp	:= 5
		nPosParcel	:= 6
		nPosValEnt	:= 8
				
		ProcRegua(Len(aRetInf))
			//posiciona nas informações do titulo
		dbSelectArea("SE1")
		SE1->(DbOrderNickName("IDVETEX"))
		ProcRegua(Len(aRetInf))
		For nLoop := 2 To Len(aRetInf)
			IncProc("Analisando Arquivo...")
			
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
					cParcela := u_RetParcela(subStr(aRetInf[nLoop,nPosParcel],0,1))
				Endif
				lSemParcela := .F.
				cId := aRetInf[nLoop,nPosIdOp]

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
							If !(lParcial)
								aAdd(aTitOkMark,{aRetInf[nLoop]})
							Else
								aAdd(aTitParcialMark,{aRetInf[nLoop]})
							Endif
						Endif
															
							
						If (nValorBaixa > 0) 
							nValorTot	+= nValorBaixa
						Endif
					EndIf
										
				Next
				
					//VERIFICIA SE VAI GERAR UMA RA PARA O CLIENTE
				If nvalTit > nTolerancia
					aAdd(aTitRAMark,{aRetInf[nLoop]})
				Endif

			Endif

		Next
	Endif
	
	nopc := TelaMark(aRetInf,aTitRAMark,aTitOkMark,aTitParcialMark,nValorTot)//abre a tela para marcação
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

Static Function TelaMark(aRetInf,aTitRAMark,aTitOkMark,aTitParcialMark,nValorTot)
	Local oDlg			:= nil
	Local oSize			:= nil
	Local oFontArial18	:= TFont():New('arial',,-18,.T.)
	Local a1stRow		:= {}
	Local a1stRow		:= {}
	Local a2ndRow		:= {}
	Local aColuna		:= {}
	Local aButtons 		:= {}
	Local nLoop			:= 0
	Local nLoop2		:= 0
	Local nOpc			:= 0
	Local lInverte		:= .F.
	Local aTemp 		:=	{}
	Local aColors		:= {}
	
	Private aCampos 	:=	{}
	
	
	//Campos que serão exibidos na tela
	Aadd(aCampos,{"X1_OK" 		,"",""})
	
	Aadd(aTemp,{"X1_OK" 		,"C",02})
	
	For nLoop := 1 to Len(aRetInf[1])	
		Aadd(aCampos,{aRetInf[1][nLoop],"",aRetInf[1][nLoop],"@!"})
		Aadd(aTemp,{aRetInf[1][nLoop],"C",30,0})
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
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := cMarca
		For nLoop2 := 1 to Len(aTitRAMark[nLoop][1])
			TRB->&(aTemp[nLoop2+1, 1]) := aTitRAMark[nLoop][1][nLoop2]
		Next	
		TRB->X1_TIPO := "RA"
		TRB->(MsUnlock())
	Next
	//PARCIAL
	For nLoop := 1 to Len(aTitParcialMark)	
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := cMarca
		For nLoop2 := 1 to Len(aTitParcialMark[nLoop][1])
			TRB->&(aTemp[nLoop2+1, 1]) := aTitParcialMark[nLoop][1][nLoop2]
		Next	
		TRB->X1_TIPO := "PC"
		TRB->(MsUnlock())
	Next
	//OK
	For nLoop := 1 to Len(aTitOkMark)
		reclock('TRB',.T.)
		TRB->&(aTemp[1, 1]) := cMarca
		For nLoop2 := 1 to Len(aTitOkMark[nLoop][1])
			TRB->&(aTemp[nLoop2+1, 1]) := aTitOkMark[nLoop][1][nLoop2]
		Next
		TRB->X1_TIPO := "OK"
		TRB->(MsUnlock())
	Next
	
	TRB->(dbGoTop())
	
	//cores da msselect -legenda
	AADD(aColors,{ 'TRB->X1_TIPO == "OK"'   , "BR_VERDE"})
	AADD(aColors,{ 'TRB->X1_TIPO == "PC"'   , "BR_AMARELO"})
	AADD(aColors,{ 'TRB->X1_TIPO == "RA"'   , "BR_VERMELHO"})
	
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
	oTButton1 := TButton():New( nLinha, aColuna[1], "Processar",oDlg2,{|| nOpc := 1, oDlg2:End()}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( nLinha, aColuna[1]+100, "Legenda",oDlg2,{||Legenda()}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( nLinha, aColuna[1]+200, "Sair",oDlg2,{|| nOpc := 0, oDlg2:End()}, 40,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	
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
    
    AADD(aLegenda,{"BR_VERDE"   , "OK"})      // "Desbloqueado e Indice atualizado"
    AADD(aLegenda,{"BR_AMARELO" , "Parcial"})      // "Desbloqueado e Indice desatualizado"    
    AADD(aLegenda,{"BR_VERMELHO" , "RA"})      // "Desbloqueado porem Bloqueado por Indice"

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
	(cSE1)->(dbCloseArea())
Return aRetSE1



/*/{Protheus.doc} GetFIETHX02
Função para que possa realizar a chamada via Job
@author Fernando Carvalho
@since 01/05/2018
/*/
User Function XFIETHX02()
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
	
	/*RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv('99','01')*/
	
	U_FIETHX02()
Return

User Function RetParcela(cParcela)
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
