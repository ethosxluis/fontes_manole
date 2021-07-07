#include"rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A410ReCalc³ Autor ³ Eduardo Riera         ³ Data ³ 19.02.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao corrige os dados entre o cabecalho e a GetDados ³±±
±±³          ³avaliando Desconto, CFOP , Tipo do Pedido e Tabela de Preco ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1: Indica se o recalculo eh somente do desconto de cabe ³±±
±±³          ³calho.                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³12/11/99  ³ Alves         ³ Quando estiver sendo executada a partir de ³±±
±±³          ³               ³ uma rotina automatica nao deixar sobrescre-³±±
±±³          ³               ³ ver o aCols                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A410Retab()


Local aArea		:= GetArea()
Local aAreaSX3	:= SX3->(GetArea())
Local aCont    := {}
Local aStruSC6 := {}
Local aDadosCfo := {}
Local cEstado   :=SuperGetMv("MV_ESTADO")
Local cAliasQry:= ""
Local cAltPreco:= GetNewPar( "MV_ALTPREC", "T" )
Local cCliTab  := ""
Local cLojaTab := ""
Local lAltPreco:= .F.
Local nDesc		:= 0
Local ni		:= 0
Local nTmp	:=	1
Local nx		:= 0
Local nCntFor 	:= 0
Local nPCFOP 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF" })
Local nPTes		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPProd	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPPrUnit	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPDescon	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nPVlDesc	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPValor	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPLoteCtl	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPNumLote	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
Local nPItem	:= GDFieldPos( "C6_ITEM" )
Local nPGrdQtd	:= 0
Local nPGrdPrc	:= 0
Local nPGrdTot	:= 0
Local nPGrdVDe	:= 0
Local nPGrdPrU	:= 0
Local nVlrTabela:= 0
Local nScan    := 0
Local nLinha	:= 0
Local nColuna	:= 0
Local lGrade	:= MaGrade()
Local lGradeReal:= .F.
Local cProduto	:= ""
Local lCondPg   := (ReadVar()=="M->C5_CONDPAG")
Local lCondTab  := .F. 							// Verifica se a condicao escolhida esta na tabela de precos
Local nDescont	:= 0

Local lDescEsca	:=	GetNewPar("MV_DESCLOT",.F.)
Local lTabCli   := (SuperGetMv("MV_TABCENT",.F.,"2") == "1")
Local lGrdMult  := FindFunction("MATGRADE_V") .And. MATGRADE_V() >= 20110425 .And. "MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"")

// Indica se o preco unitario sera arredondado em 0 casas decimais ou nao. Se .T. respeita MV_CENT (Apenas Chile).
Local lPrcDec   := SuperGetMV("MV_PRCDEC",,.F.)
l410Auto := If (Type("l410Auto") == "U", .F., l410Auto)
PRIVATE lDescCab := GetNewPar("MV_PVRECAL",.F.) //Desabilita o recalculo automatico do Pedido de Venda.

If Type("lShowOpc") == "L"
	lShowOpc := .T.
EndIf

If !lDescCab
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zera os descontos caso o Pedido seja de Complemento.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( At(M->C5_TIPO,"CIP") != 0 )
		M->C5_DESC1 := M->C5_DESC2 := M->C5_DESC3 := M->C5_DESC4 := 0
		For nCntFor := 1 To 4
			nDesc := Ascan(aGets,{ |x| Subs(x,9,10) == "C5_DESC"+Str(nCntFor,1,0)+"  " } )
			If nDesc != 0
				ni := Val(Subs(aGets[nDesc],1,2))
				nx := Val(Subs(aGets[nDesc],3,1))*2
				If Val(aTela[ni][nx]) != 0
					dbSelectArea("SX3")
					dbSetOrder(2)
					MsSeek("C5_DESC"+Str(nCntFor,1,0)+"  ")
					aTela[ni][nx] := Str(0,SX3->X3_DECIMAL+3,SX3->X3_DECIMAL)
				EndIf
			EndIf
		Next nCntFor
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Corrige o Codigo Fiscal, caso o Cliente tenha sido alterado.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( INCLUI .Or. ALTERA )
		dbSelectArea(IIF(M->C5_TIPO$"DB","SA2","SA1"))
		dbSetOrder(1)
		MsSeek(xFilial()+IIf(!Empty(M->C5_CLIENT),M->C5_CLIENT,M->C5_CLIENTE)+M->C5_LOJAENT)

		For nCntFor := 1 to Len(aCols)
			dbSelectArea("SF4")
			dbSetOrder(1)
			If ( MsSeek(xFilial("SF4")+aCols[nCntFor][nPTes],.F.) )
				If At(M->C5_TIPO,"DB") == 0

				 	Aadd(aDadosCfo,{"OPERNF","S"})
				 	Aadd(aDadosCfo,{"TPCLIFOR",M->C5_TIPOCLI})
				 	Aadd(aDadosCfo,{"UFDEST",SA1->A1_EST})
					Aadd(aDadosCfo,{"INSCR" ,SA1->A1_INSCR})
					If SA1->(FieldPos("A1_CONTRIB")) > 0
						Aadd(aDadosCfo,{"CONTR", SA1->A1_CONTRIB})
					EndIf
					aCols[nCntFor][nPCFOP] := MaFisCfo(,SF4->F4_CF,aDadosCfo)

				Else

				 	Aadd(aDadosCfo,{"OPERNF","S"})
				 	Aadd(aDadosCfo,{"TPCLIFOR",M->C5_TIPOCLI})
					Aadd(aDadosCfo,{"UFDEST",SA2->A2_EST})
					Aadd(aDadosCfo,{"INSCR" ,SA2->A2_INSCR})
					aCols[nCntFor][nPCFOP] := MaFisCfo(,SF4->F4_CF,aDadosCfo)

				EndIf
			EndIf
		Next nCntFor
	EndIf
EndIf

If cAltPreco <> "T"

	aCont := {}

	#IFDEF TOP

		cAliasQry := GetNextAlias()

		cQuery := "SELECT C6_NUM, C6_ITEM, C6_QTDENT, C6_QTDEMP FROM " + SC6->( RetSqlName( "SC6" ) ) + " "
		cQuery += "WHERE "
		cQuery += "C6_FILIAL='" + xFilial("SC6") + "' AND "
		cQuery += "C6_NUM='" + M->C5_NUM      + "' AND "
		cQuery += "D_E_L_E_T_=' '"

		cQuery := ChangeQuery( cQuery )

		dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )

		aStruSC6 := SC6->( dbStruct())

		If !Empty( nScan := AScan( aStruSC6, { |x| x[1]=="C6_QTDENT" } ) )
			TcSetField( cAliasQry, aStruSC6[ nScan, 1 ], aStruSC6[ nScan, 2 ], 	aStruSC6[ nScan, 3 ], 	aStruSC6[ nScan, 4 ] )
		EndIf

		If !Empty( nScan := AScan( aStruSC6, { |x| x[1]=="C6_QTDEMP" } ) )
			TcSetField( cAliasQry, aStruSC6[ nScan, 1 ], aStruSC6[ nScan, 2 ], 	aStruSC6[ nScan, 3 ], 	aStruSC6[ nScan, 4 ] )
		EndIf

		While !Eof()
			AAdd( aCont, { C6_NUM + C6_ITEM, C6_QTDENT, C6_QTDEMP  } )
			dbSkip()
		EndDo

		dbCloseArea()

		dbSelectArea( "SC6" )

	#ELSE

		SC6->( dbSetOrder( 1 ) )
		If SC6->( dbSeek( xFilial( "SC6" ) + M->C5_NUM ) )
			While !SC6->( Eof() ) .And. xFilial( "SC6" ) + M->C5_NUM == SC6->C6_FILIAL + SC6->C6_NUM
				AAdd( aCont, { SC6->C6_NUM + SC6->C6_ITEM, SC6->C6_QTDENT, SC6->C6_QTDEMP  } )
				SC6->( dbSkip() )
			EndDo
		EndIf

	#ENDIF

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corrige o preco de tabela e preco unitario p/ tab.alterada    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If (M->C5_TIPO == "N" .And. !("M->C5_CLIENT"==Alltrim(ReadVar()).Or."M->C5_LOJAENT"==ReadVar()) ) .Or.;
	(M->C5_TIPO == "N" .And. lTabCli)

	If lCondPg
		dbSelectArea("DA0")
		dbSetOrder(1)
		If MsSeek(xFilial("DA0")+M->C5_TABELA)
			lCondTab := DA0_CONDPG == M->C5_CONDPAG
		Endif
	Endif

	nTmp	:=	n
	For nCntFor := 1 to Len(aCols)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se deve atualizar os precos conforme a regra         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cAltPreco == "T"
			lAltPreco := .T.
		ElseIf  cAltPreco $ "LF"
			lAltPreco := .T.

			If !Empty( nScan := AScan( aCont, { |x| x[1] == M->C5_NUM + aCols[nCntFor,nPItem] } ) )
				If cAltPreco == "L"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao permite itens liberados                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lAltPreco := Empty( aCont[ nScan, 2 ] ) .And. Empty( aCont[ nScan, 3 ] )
				ElseIf cAltPreco == "F"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao permite itens faturados                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lAltPreco := Empty( aCont[ nScan, 2 ] )
				EndIf
			EndIf
		Else
			lAltPreco := .F.
		EndIf

		If lAltPreco
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se eh grade para calcular o valor total por item da grade³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProduto := aCols[nCntFor][nPProd]
			If lGrade .And.	MatGrdPrrf(@cProduto)
				lGradeReal := .T.
			Else
				lGradeReal := .F.
			Endif

			If lTabCli
				Do Case
					Case !Empty(M->C5_LOJAENT) .And. !Empty(M->C5_CLIENT)
						cCliTab   := M->C5_CLIENT
						cLojaTab  := M->C5_LOJAENT
					Case Empty(M->C5_CLIENT)
						cCliTab   := M->C5_CLIENTE
						cLojaTab  := M->C5_LOJAENT
					OtherWise
						cCliTab   := M->C5_CLIENTE
						cLojaTab  := M->C5_LOJACLI
				EndCase
			Else
				cCliTab   := M->C5_CLIENTE
				cLojaTab  := M->C5_LOJACLI
			Endif

			If !lDescCab
                If !(lGrdMult .And. FindFunction("MsMatGrade") .And. IsAtNewGrd() .And. lGrade .And. lGradeReal)
					nVlrTabela := A410Tabela(	aCols[nCntFor][nPProd],;
												M->C5_TABELA,;
												nCntFor,;
												aCols[nCntFor][nPQtdVen],;
												cCliTab,;
												cLojaTab,;
												If(nPLoteCtl>0,aCols[nCntFor][nPLoteCtl],""),;
												If(nPNumLote>0,aCols[nCntFor][nPNumLote],"")	)
				EndIf
			Else
				nVlrTabela := aCols[nCntFor][nPPrUnit]
			EndIf

			If !(lGrdMult .And. FindFunction("MsMatGrade") .And. IsAtNewGrd() .And. lGrade .And. lGradeReal)

			   	If lCondPg
					n	:=	nCntFor
					If ( nPPrcVen > 0 ) .And. ( nVlrTabela <> 0 )

						nDescont := FtRegraDesc(1)

						If(lCondTab .And. aPesqDA1(M->C5_TABELA,aCols[nCntFor][nPProd])) .Or. M->C5_DESC4 > 0 .Or. nDescont >0
							aCols[nCntFor][nPPrcVen] := FtDescCab(nVlrTabela,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4},If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
							aCols[nCntFor][nPValor]  := a410Arred( aCols[nCntFor][nPQtdVen]*aCols[nCntFor][nPPrcVen],"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
							aCols[nCntFor,nPDescon]  := 0
							aCols[nCntFor,nPVlDesc]  := 0

							If ( nPPrUnit > 0 )
							    aCols[nCntFor][nPPrUnit] := nVlrTabela
							EndIf

							aCols[nCntFor,nPDescon] := nDescont

							If ( nPDescon > 0 .And. nPVlDesc > 0 .And. nPPrcVen > 0 .And. nPValor > 0 .And. nPPrUnit>0 )
								aCols[nCntFor][nPPrcVen] := FtDescItem(If(aCols[nCntFor][nPPrUnit] == 0, aCols[nCntFor][nPPrUnit],@aCols[nCntFor][nPPrcVen]),;
									@aCols[nCntFor,nPPrcVen],;
									aCols[nCntFor,nPQtdVen],;
									@aCols[nCntFor,nPValor],;
									@aCols[nCntFor,nPDescon],;
									@aCols[nCntFor,nPVlDesc],;
									@aCols[nCntFor,nPVlDesc],1,,If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
							EndIf
						EndIf
					EndIf
				Else
					If ( nPPrcVen > 0 ) .And. ( nVlrTabela <> 0 )
						aCols[nCntFor][nPPrcVen] := FtDescCab(nVlrTabela,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4},If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
					EndIf
					If ( nPPrUnit > 0 )
						aCols[nCntFor][nPPrUnit] := nVlrTabela
					EndIf

					n	:=	nCntFor
					nDescont := FtRegraDesc(1)

					If nDescont > 0
						aCols[nCntFor,nPDescon] := nDescont
					EndIf


					If ( nPDescon > 0 .And. nPVlDesc > 0 .And. nPPrcVen > 0 .And. nPValor > 0 .And. nPPrUnit>0 )
						aCols[nCntFor][nPPrcVen] := FtDescItem(If(aCols[nCntFor][nPPrUnit] == 0, aCols[nCntFor][nPPrUnit],@aCols[nCntFor][nPPrcVen]),;
							@aCols[nCntFor,nPPrcVen],;
							aCols[nCntFor,nPQtdVen],;
							@aCols[nCntFor,nPValor],;
							@aCols[nCntFor,nPDescon],;
							@aCols[nCntFor,nPVlDesc],;
							@aCols[nCntFor,nPVlDesc],1,,If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
					EndIf
				EndIf
			EndIf

			If FindFunction("MsMatGrade") .And. IsAtNewGrd()
			   	If lGrade .And. lGradeReal .And. Type("oGrade")=="O" .And. Len(oGrade:aColsGrade) > 0
					If !lGrdMult
			   			aCols[nCntFor,nPValor] := 0
			   			nPGrdQtd := oGrade:GetFieldGrdPos("C6_QTDVEN")
						For nLinha := 1 To Len(oGrade:aColsGrade[nCntFor])
							For nColuna := 2 To Len(oGrade:aHeadGrade[nCntFor])
								If ( oGrade:aColsGrade[nCntFor,nLinha,nColuna][nPGrdQtd] <> 0 )
									aCols[nCntFor,nPValor]  += a410Arred( oGrade:aColsGrade[nCntFor,nLinha,nColuna][nPGrdQtd]*aCols[nCntFor,nPPrcVen],"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
								Endif
							Next nColuna
						Next nLinha
					Else
						n	:=	nCntFor
			   			aCols[n,nPValor] := 0
			   			nPGrdQtd := oGrade:GetFieldGrdPos("C6_QTDVEN")
			   			nPGrdPrc := oGrade:GetFieldGrdPos("C6_PRCVEN")
			   			nPGrdTot := oGrade:GetFieldGrdPos("C6_VALOR")
			   			nPGrdVDe := oGrade:GetFieldGrdPos("C6_VALDESC")
			   			nPGrdPrU := oGrade:GetFieldGrdPos("C6_PRUNIT")
						For nLinha := 1 To Len(oGrade:aColsGrade[n])
							For nColuna := 2 To Len(oGrade:aHeadGrade[n])
								If ( oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd] <> 0 )

									nVlrTabela := A410Tabela(	oGrade:GetNameProd(,nLinha,nColuna),;
																M->C5_TABELA,;
																nCntFor,;
																oGrade:aColsFieldByName("C6_QTDVEN",,nLinha,nColuna),;
																cCliTab,;
																cLojaTab,;
																,;
																,;
																,;
																,;
																,;
																oGrade:aColsGrade[n,nLinha,nColuna,oGrade:GetFieldGrdPos("C6_OPC")])

									If nVlrTabela <> 0
										oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrU] := nVlrTabela
										oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc] := FtDescCab(nVlrTabela,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4},If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
										oGrade:aColsGrade[n,nLinha,nColuna,nPGrdVDe] := A410Arred((nVlrTabela - oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc])*oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd],"C6_VALOR")
										oGrade:aColsGrade[n,nLinha,nColuna,nPGrdTot] := A410Arred(oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd] * oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc],"C6_VALOR")
									EndIf
								Endif
							Next nColuna
						Next nLinha

						aCols[n,nPPrcVen] := oGrade:SomaGrade("C6_PRCVEN",n)
						aCols[n,nPDescon] := FtRegraDesc(1)

						If ( nPDescon > 0 .And. nPVlDesc > 0 .And. nPPrcVen > 0 .And. nPValor > 0 .And. nPPrUnit>0 )
							For nLinha := 1 To Len(oGrade:aColsGrade[n])
								For nColuna := 2 To Len(oGrade:aHeadGrade[n])
									oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc] := FtDescItem(0,;
										@oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc],;
										oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd],;
										@oGrade:aColsGrade[n,nLinha,nColuna,nPGrdTot],;
										@aCols[nCntFor,nPDescon],;
										@oGrade:aColsGrade[n,nLinha,nColuna,nPGrdVDe],;
										0,1,,If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
								Next nColuna
							Next nLinha
						EndIf
						aCols[n,nPPrcVen] := oGrade:SomaGrade("C6_PRCVEN",n)
						aCols[n,nPValor] := oGrade:SomaGrade("C6_VALOR",n)
						aCols[n,nPVlDesc] := oGrade:SomaGrade("C6_VALDESC",n)
					EndIf
				EndIf
			Else
			   	If lGrade .And. lGradeReal .And. Len(aColsGrade) > 0
		   			aCols[nCntFor,nPValor] := 0
					For nLinha := 1 To Len(aColsGrade[nCntFor])
						For nColuna := 2 To Len(aHeadGrade[nCntFor])
							If ( aColsGrade[nCntFor][nLinha][nColuna][1] <> 0 )
								aCols[nCntFor,nPValor]  += a410Arred(aColsGrade[nCntFor][nLinha][nColuna][1]*aCols[nCntFor,nPPrcVen],"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
							Endif
						Next nColuna
					Next nLinha
				EndIf
			EndIf

		EndIf

	Next nCntFor
	n	:=	nTmp
EndIf

If Type('oGetDad:oBrowse')<>"U"
	oGetDad:oBrowse:Refresh()
	Ma410Rodap()
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna o estado de entrada da rotina                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSX3)
RestArea(aArea)

Return (.T.)
