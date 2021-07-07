#include "PROTHEUS.CH"
user function ACD100VG()
Local nI
Local cCodOpe
Local aRecSC9	:= {}
Local aOrdSep	:= {}
Local cArm		:= Space(Tamsx3("B1_LOCPAD")[1])
Local cPedido	:= Space(6)
Local cCliente	:= Space(6)
Local cLoja		:= Space(2)
Local cCondPag	:= Space(3)
Local cLojaEnt	:= Space(2)
Local cAgreg	:= Space(4)
Local cOrdSep	:= Space(4)
Local cTipExp	:= ""
Local nPos      := 0
Local nMaxItens	:= GETMV("MV_NUMITEN")			//Numero maximo de itens por nota (neste caso por ordem de separacao)- by Erike
Local lConsNumIt:= SuperGetMV("MV_CBCNITE",.F.,.T.) //Parametro que indica se deve ou nao considerar o conteudo do MV_NUMITEN
Local lFilItens	:= ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
Local lLocOrdSep:= .F.
Private aLogOS	:= {}
nMaxItens := If(Empty(nMaxItens),99,nMaxItens)

// analisar a pergunta '00-Separacao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque,07-Aglutina Pedido,08-Aglutina Local,09-Pre-Separacao'
If nEmbSimul == 1 // Separacao com Embalagem Simultanea
	cTipExp := "01*"
Else
	cTipExp := "00*" // Separacao Simples
EndIF
If nEmbalagem == 1 // Embalagem
	cTipExp += "02*"
EndIF
If nGeraNota == 1 // Gera Nota
	cTipExp += "03*"
EndIF
If nImpNota == 1 // Imprime Nota
	cTipExp += "04*"
EndIF
If nImpEtVol == 1 // Imprime Etiquetas Oficiais de Volume
	cTipExp += "05*"
EndIF
If nEmbarque == 1 // Embarque
	cTipExp += "06*"
EndIF
If nAglutPed == 1 // Aglutina pedido
	cTipExp +="11*"
EndIf
If nAglutArm == 1 // Aglutina armazem
	cTipExp +="08*"
EndIf
If MV_PAR10 ==1 // pre-separacao
	cTipExp +="09*"
EndIf
If nConfLote == 1 // confere lote
	cTipExp +="10*"
EndIf

ProcRegua( SC9->( LastRec() ), "oook" )
cCodOpe	 := cSeparador

SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))
SDC->(DbSetOrder(1))
CB7->(DbSetOrder(2))
CB8->(DbSetOrder(2))

SC9->(dbGoTop())
While !SC9->(Eof())
	If ! SC9->(IsMark("C9_OK",ThisMark(),ThisInv()))
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If !Empty(SC9->(C9_BLEST+C9_BLCRED+C9_BLOQUEI))
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If lFilItens
		If !ExecBlock("ACDA100I",.F.,.F.)
			SC9->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	//pesquisa se este item tem saldo a separar, caso tenha, nao gera ordem de separacao
	If CB8->(DbSeek(xFilial('CB8')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN+SC9->C9_PRODUTO)) .and. CB8->CB8_SALDOS > 0
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Existe saldo a separar deste item","NAO_GEROU_OS"}) //"Pedido"###"Existe saldo a separar deste item"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf

	If ! SC5->(DbSeek(xFilial('SC5')+SC9->C9_PEDIDO))
		// neste caso a base tem sc9 e nao tem sc5, problema de incosistencia de base
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Inconsistencia de base (SC5 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC5 x SC9)"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf
	If ! SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
		// neste caso a base tem sc9,sc5 e nao tem sc6,, problema de incosistencia de base
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Inconsistencia de base (SC6 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC6 x SC9)"
		SC9->(DbSkip())
		IncProc()
		Loop
	EndIf

	If !("08*" $ cTipExp)  // gera ordem de separacao por armazem
		cArm :=SC6->C6_LOCAL
	Else  // gera ordem de separa com todos os armazens
		cArm :=Space(Tamsx3("B1_LOCPAD")[1])
	EndIf
	If "11*" $ cTipExp //AGLUTINA TODOS OS PEDIDOS DE UM MESMO CLIENTE
		cPedido := Space(6)
	Else   // Nao AGLUTINA POR PEDIDO
		cPedido := SC9->C9_PEDIDO
	EndIf
	If "09*" $ cTipExp // AGLUTINA PARA PRE-SEPARACAO
		cPedido  := Space(6) // CASO SEJA PRE-SEPARACAO TEM QUE CONSIDERAR TODOS OS PEDIDOS
		cCliente := Space(Tamsx3("C6_CLI")[1])
		cLoja    := Space(Tamsx3("C6_LOJA")[1])
		cCondPag := Space(3)
		cLojaEnt := Space(2)
		cAgreg   := Space(4)
	Else   // NAO AGLUTINA PARA PRE-SEPARACAO
		cCliente := SC6->C6_CLI
		cLoja    := SC6->C6_LOJA
		cCondPag := SC5->C5_CONDPAG
		cLojaEnt := SC5->C5_LOJAENT
		cAgreg   := SC9->C9_AGREG
	EndIf

	lLocOrdSep := .F.
	If CB7->(DbSeek(xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg))
		While CB7->(!Eof() .and. CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG==;
								xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg)
			If CB7->CB7_ORDSEP==cOrdSep
				lLocOrdSep := .T.
				Exit
			EndIf
			CB7->(DbSkip())
		EndDo
	EndIf

	If Localiza(SC9->C9_PRODUTO)
		If ! SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
			// neste caso nao existe composicao de empenho
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Nao existe composicao de empenho (SDC)","NAO_GEROU_OS"}) //"Pedido"###"Nao existe composicao de empenho (SDC)"
			SC9->(DbSkip())
			IncProc()
			Loop
		EndIf
	EndIf

	If !lLocOrdSep .or. (("03*" $ cTipExp) .and. !("09*" $ cTipExp) .and. lConsNumIt .And. CB7->CB7_NUMITE >=nMaxItens)

		cOrdSep := CB_SXESXF("CB7","CB7_ORDSEP",,1)
		ConfirmSX8()

		CB7->(RecLock( "CB7",.T.))
		CB7->CB7_FILIAL := xFilial( "CB7" )
		CB7->CB7_ORDSEP := cOrdSep
		CB7->CB7_PEDIDO := cPedido
		CB7->CB7_CLIENT := cCliente
		CB7->CB7_LOJA   := cLoja
		CB7->CB7_COND   := cCondPag
		CB7->CB7_LOJENT := cLojaEnt
		CB7->CB7_LOCAL  := cArm
		CB7->CB7_DTEMIS := dDataBase
		CB7->CB7_HREMIS := Time()
		CB7->CB7_STATUS := " "
		CB7->CB7_CODOPE := cCodOpe
		CB7->CB7_PRIORI := "1"
		CB7->CB7_ORIGEM := "1"
		CB7->CB7_TIPEXP := cTipExp
		CB7->CB7_TRANSP := SC5->C5_TRANSP
		CB7->CB7_AGREG  := cAgreg
		If	ExistBlock("A100CABE")
			ExecBlock("A100CABE",.F.,.F.)
		EndIf
		CB7->(MsUnlock())

		aadd(aOrdSep,CB7->CB7_ORDSEP)
	EndIf
	//Grava o historico das geracoes:
	nPos := Ascan(aLogOS,{|x| x[01]+x[02]+x[03]+x[04]+x[05]+x[10] == ("1"+"Pedido"+SC9->(C9_PEDIDO+C9_CLIENTE+C9_LOJA)+CB7->CB7_ORDSEP)})
	If nPos == 0
		aadd(aLogOS,{"1","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"","",cArm,"",CB7->CB7_ORDSEP}) //"Pedido"
	Endif

	If Localiza(SC9->C9_PRODUTO)
		While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+;
			DC_ITEM+DC_SEQ==xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM+C9_SEQUEN))

			SB1->(DBSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+SDC->DC_PRODUTO)) .AND. Alltrim(SB1->B1_TIPO) == "MO"
				SDC->(DbSkip())
				Loop
			Endif

			CB8->(RecLock("CB8",.T.))
			CB8->CB8_FILIAL := xFilial("CB8")
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_ITEM   := SC9->C9_ITEM
			CB8->CB8_PEDIDO := SC9->C9_PEDIDO
			CB8->CB8_PROD   := SDC->DC_PRODUTO
			CB8->CB8_LOCAL  := SDC->DC_LOCAL
			CB8->CB8_QTDORI := SDC->DC_QUANT
			If "09*" $ cTipExp
				CB8->CB8_SLDPRE := SDC->DC_QUANT
			EndIf
			CB8->CB8_SALDOS := SDC->DC_QUANT
			If ! "09*" $ cTipExp .AND. nEmbalagem == 1
				CB8->CB8_SALDOE := SDC->DC_QUANT
			EndIf
			CB8->CB8_LCALIZ := SDC->DC_LOCALIZ
			CB8->CB8_NUMSER := SDC->DC_NUMSERI
			CB8->CB8_SEQUEN := SC9->C9_SEQUEN
			CB8->CB8_LOTECT := SC9->C9_LOTECTL
			CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
			CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1"," ")
			CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
			If	ExistBlock("ACD100GI")
				ExecBlock("ACD100GI",.F.,.F.)
			EndIf
			CB8->(MsUnLock())
			//Atualizacao do controle do numero de itens a serem impressos
			RecLock("CB7",.F.)
			CB7->CB7_NUMITE++
			CB7->(MsUnLock())
			SDC->( dbSkip() )
		EndDo
	Else
		CB8->(RecLock("CB8",.T.))
		CB8->CB8_FILIAL := xFilial("CB8")
		CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
		CB8->CB8_ITEM   := SC9->C9_ITEM
		CB8->CB8_PEDIDO := SC9->C9_PEDIDO
		CB8->CB8_PROD   := SC9->C9_PRODUTO
		CB8->CB8_LOCAL  := SC9->C9_LOCAL
		CB8->CB8_QTDORI := SC9->C9_QTDLIB
		If "09*" $ cTipExp
			CB8->CB8_SLDPRE := SC9->C9_QTDLIB
		EndIf
		CB8->CB8_SALDOS := SC9->C9_QTDLIB
		If ! "09*" $ cTipExp .AND. nEmbalagem == 1
			CB8->CB8_SALDOE := SC9->C9_QTDLIB
		EndIf
		CB8->CB8_LCALIZ := ""
		CB8->CB8_NUMSER := SC9->C9_NUMSERI
		CB8->CB8_SEQUEN := SC9->C9_SEQUEN
		CB8->CB8_LOTECT := SC9->C9_LOTECTL
		CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
		CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1"," ")
		CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
		If	ExistBlock("ACD100GI")
			ExecBlock("ACD100GI",.F.,.F.)
		EndIf
		CB8->(MsUnLock())

		//Atualizacao do controle do numero de itens a serem impressos
		RecLock("CB7",.F.)
		CB7->CB7_NUMITE++
		CB7->(MsUnLock())
	EndIf
	aadd(aRecSC9,{SC9->(Recno()),CB7->CB7_ORDSEP})
	IncProc()
	SC9->( dbSkip() )
EndDo

CB7->(DbSetOrder(1))
For nI := 1 to len(aOrdSep)
	CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
	CB7->(RecLock("CB7"))
	CB7->CB7_STATUS := "0"  // nao iniciado
	CB7->(MsUnlock())
	If	ExistBlock("ACDA100F")
		ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
	EndIf
Next
For nI := 1 to len(aRecSC9)
	SC9->(DbGoto(aRecSC9[nI,1]))
	SC9->(RecLock("SC9"))
	SC9->C9_ORDSEP := aRecSC9[nI,2]
	SC9->(MsUnlock())
Next
//If !Empty(aLogOS)
//	LogACDA100()
//Endif
Return

STATIC Function GeraOSepNota( cMarca, lInverte, cNotaSerie)
Local cChaveDB
Local cTipExp
Local nI
Local cCodOpe
Local aRecSD2 := {}
Local aOrdSep := {}
Local lFilItens  := ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
Private aLogOS:= {}

// analisar a pergunta '00-Separcao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque'
If nEmbSimuNF == 1
	cTipExp := "01*"
Else
	cTipExp := "00*"
EndIF
If nEmbalagNF == 1
	cTipExp += "02*"
EndIF
If nImpNotaNF == 1
	cTipExp += "04*"
EndIF
If nImpVolNF == 1
	cTipExp += "05*"
EndIF
If nEmbarqNF == 1
	cTipExp += "06*"
EndIF
/*Ponto de entrada, permite que o usuário realize o processamento conforme suas particularidades.*/
If	ExistBlock("ACD100VG")
	If ! ExecBlock("ACD100VG",.F.,.F.,)
		Return
	EndIf
EndIf

SF2->(DbSetOrder(1))
SD2->(DbSetOrder(nIndice))
SD2->( dbGoTop() )

If cNotaSerie == Nil
	ProcRegua( SD2->( LastRec() ), "oook" )
	cCodOpe	 := cSeparador
Else
	SD2->(DbSetOrder(nIndece))
	SD2->(DbSeek(xFilial("SD2")+cNotaSerie))
	cCodOpe := Space(06)
EndIf

ProcRegua( SD2->( LastRec() ), "oook" )
cCodOpe := cSeparador

While !SD2->( Eof() ) .and. (cNotaSerie == Nil .or. cNotaSerie == SD2->(D2_DOC+D2_SERIE))
	If (cNotaSerie==NIL) .and. ! (SD2->(IsMark("D2_OK",ThisMark(),ThisInv())))
		SD2->( dbSkip() )
		IncProc()
		Loop
	EndIf
	If lFilItens
		If !ExecBlock("ACDA100I",.F.,.F.)
			SD2->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	cChaveDB :=xFilial("SDB")+SD2->(D2_COD+D2_LOCAL+D2_NUMSEQ+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
	If Localiza(SD2->D2_COD)
		SDB->(dbSetOrder(1))
		If ! SDB->(dbSeek( cChaveDB ))
			// neste caso nao existe composicao de empenho
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2","Nota",SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"Inconsistencia de base, nao existe registro de movimento (SDB)","NAO_GEROU_OS"})				 //"Nota"###"Inconsistencia de base, nao existe registro de movimento (SDB)"
			SD2->(DbSkip())
			If cNotaSerie==Nil
				IncProc()
			EndIf
			Loop
		EndIf
	EndIf

	CB7->(DbSetOrder(4))
	If ! CB7->(DbSeek(xFilial("CB7")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_LOCAL+" "))
		CB7->(RecLock( "CB7", .T. ))
		CB7->CB7_FILIAL := xFilial( "CB7" )
		CB7->CB7_ORDSEP := GetSX8Num( "CB7", "CB7_ORDSEP" )
		CB7->CB7_NOTA   := SD2->D2_DOC
		CB7->CB7_SERIE  := SD2->D2_SERIE
		CB7->CB7_CLIENT := SD2->D2_CLIENTE
		CB7->CB7_LOJA   := SD2->D2_LOJA
		CB7->CB7_LOCAL  := SD2->D2_LOCAL
		CB7->CB7_DTEMIS := dDataBase
		CB7->CB7_HREMIS := Time()
		CB7->CB7_STATUS := " "   // gravar STATUS de nao iniciada somente depois do processo
		CB7->CB7_CODOPE := cCodOpe
		CB7->CB7_PRIORI := "1"
		CB7->CB7_ORIGEM := "2"
		CB7->CB7_TIPEXP := cTipExp
		If SF2->(DbSeek(xFilial("SF2")+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
			CB7->CB7_TRANSP := SF2->F2_TRANSP
		EndIf
		If	ExistBlock("A100CABE")
			ExecBlock("A100CABE",.F.,.F.)
		EndIf
		CB7->(MsUnLock())
		ConfirmSX8()
		//Grava o historico das geracoes:
		aadd(aLogOS,{"1","Nota",SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"",CB7->CB7_ORDSEP})
		aadd(aOrdSep,CB7->CB7_ORDSEP)
	EndIf
	If Localiza(SD2->D2_COD)
		While SDB->(!Eof() .And. cChaveDB == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA)
			If SDB->DB_ESTORNO == "S"
				SDB->(dbSkip())
				Loop
			EndIf
			CB8->(DbSetorder(4))
			If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+SD2->(D2_ITEM+D2_COD+D2_LOCAL+SDB->DB_LOCALIZ+D2_LOTECTL+D2_NUMLOTE+D2_NUMSERI)))
				CB8->(RecLock( "CB8", .T. ))
				CB8->CB8_FILIAL := xFilial( "CB8" )
				CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
				CB8->CB8_ITEM   := SD2->D2_ITEM
				CB8->CB8_PEDIDO := SD2->D2_PEDIDO
				CB8->CB8_NOTA   := SD2->D2_DOC
				CB8->CB8_SERIE  := SD2->D2_SERIE
				CB8->CB8_PROD   := SD2->D2_COD
				CB8->CB8_LOCAL  := SD2->D2_LOCAL
				CB8->CB8_LCALIZ := SDB->DB_LOCALIZ
				CB8->CB8_SEQUEN := SDB->DB_ITEM
				CB8->CB8_LOTECT := SD2->D2_LOTECTL
				CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
				CB8->CB8_NUMSER := SD2->D2_NUMSERI
				CB8->CB8_CFLOTE := "1"
				aadd(aRecSD2,{SD2->(Recno()),CB7->CB7_ORDSEP})
			Else
				CB8->(RecLock( "CB8", .f. ))
			EndIf
			CB8->CB8_QTDORI += SDB->DB_QUANT
			CB8->CB8_SALDOS += SDB->DB_QUANT
			If nEmbalagem == 1
				CB8->CB8_SALDOE += SDB->DB_QUANT
			EndIf
			If	ExistBlock("ACD100GI")
				ExecBlock("ACD100GI",.F.,.F.)
			EndIf
			CB8->(MsUnLock())
			SDB->(dbSkip())
		Enddo
	Else
		CB8->(DbSetorder(4))
		If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+SD2->(D2_ITEM+D2_COD+D2_LOCAL+Space(15)+D2_LOTECTL+D2_NUMLOTE+D2_NUMSERI)))
			CB8->(RecLock( "CB8", .T. ))
			CB8->CB8_FILIAL := xFilial( "CB8" )
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_ITEM   := SD2->D2_ITEM
			CB8->CB8_PEDIDO := SD2->D2_PEDIDO
			CB8->CB8_NOTA   := SD2->D2_DOC
			CB8->CB8_SERIE  := SD2->D2_SERIE
			CB8->CB8_PROD   := SD2->D2_COD
			CB8->CB8_LOCAL  := SD2->D2_LOCAL
			CB8->CB8_LCALIZ := Space(15)
			CB8->CB8_SEQUEN := SD2->D2_ITEM
			CB8->CB8_LOTECT := SD2->D2_LOTECTL
			CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
			CB8->CB8_NUMSER := SD2->D2_NUMSERI
			CB8->CB8_CFLOTE := "1"
			aadd(aRecSD2,{SD2->(Recno()),CB7->CB7_ORDSEP})
		Else
			CB8->(RecLock( "CB8", .f. ))
		EndIf
		CB8->CB8_QTDORI += SD2->D2_QUANT
		CB8->CB8_SALDOS += SD2->D2_QUANT
		If nEmbalagem == 1
			CB8->CB8_SALDOE += SD2->D2_QUANT
	    EndIf
		If	ExistBlock("ACD100GI")
			ExecBlock("ACD100GI",.F.,.F.)
		EndIf
		CB8->(MsUnLock())
	EndIf

	If cNotaSerie==Nil
		IncProc()
	EndIf
	SD2->( dbSkip() )
EndDo

CB7->(DbSetOrder(1))
For nI := 1 to len(aOrdSep)
	CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
	CB7->(RecLock("CB7"))
	CB7->CB7_STATUS := "0"  // nao iniciado
	CB7->(MsUnlock())
	If	ExistBlock("ACDA100F")
		ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
	EndIf
Next
For nI := 1 to len(aRecSD2)
	SD2->(DbGoto(aRecSD2[nI,1]))
	SD2->(RecLock("SD2",.F.))
	SD2->D2_ORDSEP := aRecSD2[nI,2]
	SD2->(MsUnlock())
Next
//If !Empty(aLogOS)
//	LogACDA100()
//Endif

Return(.F.)