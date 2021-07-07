#INCLUDE "rwmake.ch"
	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Nota Tabela de Precos DA0/DA1 com base na nova        º±±
±±º          ³ Formacao de Precos, incluindos os campos de Preco Minimo e º±±
±±º          ³ Preco de Lista, conforme nova regra de comissionamento.    º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para MacroPlast                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MANAT001()

Local aAreaDA1 		:= DA1->(GetArea())
Local aAreaDA0 		:= DA0->(GetArea())
Private _cPerg		:= padl("MACP77",10)
Private nItens  	:= 0
Private _nReg	 	:= 0

_CriaSX1()

If !(Pergunte(_cPerg,.t.))
	Return
Endif

Processa({||_CriaDA0()},OemToAnsi("Criando/Atualizando Tabela, aguarde ..."))

Aviso( "Atenção", str(nItens)+" Produto(s) Gravado(s) na Tabela", { "Ok" }, 2 )

RestArea(aAreaDA1)
RestArea(aAreaDA0)
Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Selecao                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MACROMS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _CriaDA0()

Local cFilSB1   := xFilial("SB1")
Local cQuery    := ""
Local lgrava	:= .F.
Local cItem     := Repl("0",Len(DA1->DA1_ITEM))

//+-----------------------
//| Cria filtro temporario
//+-----------------------
cQuery := "SELECT "
cQuery += "B1_DESC,B1_COD,B1_GRUPO,B1_TIPO,B1_PRV1 "
cQuery += "FROM "+RetSqlName("SB1")+" "
cQuery += "WHERE B1_FILIAL = '"+cFilSB1+"' "
cQuery += "AND B1_COD >= '"+mv_par01+"' "
cQuery += "AND B1_COD <= '"+mv_par02+"' "
cQuery += "AND B1_TIPO IN ('PA') AND B1_UM IN ('LI') "
cQuery += "AND D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY B1_COD"
//+-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRX", .T., .F. )

dbSelectArea("TRX")
DbGoTop()
DbEval({|| _nReg++})

If _nReg == 0
	Alert( "Não foi possível gravar Tabela de Preço", { "Ok" }, 2 )
	dbSelectArea("TRX")                 
	dbCloseArea()
	Return(nItens)
Endif

If mv_par03 == 1 .and. !Empty(mv_par04) // Atualiza Tabela
	
	dbSelectArea("TRX")
	dbGoTop()
	ProcRegua(_nReg)
	While !Eof()
		IncProc("Processando Produto: "+TRX->B1_COD)
		
		nValorEx	:= 0
		nValorExL	:= 0
		
		aAreaTRX := TRX->(GetArea())
		aAreaSB1 := SB1->(GetArea())
		dbSelectArea("SB1")
		dbSetorder(1)
		dbSeek(xFilial("SB1")+TRX->B1_COD)
		
			nItens++
			dbSelectArea("DA1")
			dbSetOrder(1)
			If !MsSeek(xFilial("DA1")+mv_par04+TRX->B1_COD)
		
				dbSetOrder(3)
				MsSeek(xFilial("DA1")+mv_par04)
				_citem :=StrZero(1,Len(DA1->DA1_ITEM))
				DbEval({|| _citem:=IIF(DA1_CODTAB = mv_par04,DA1_ITEM,_citem) })
				_cItem++
				dbSetOrder(1)
				If Reclock("DA1",.T.)
					DA1->DA1_FILIAL := xFilial("DA1")
					DA1->DA1_CODTAB := mv_par04
					DA1->DA1_ITEM   := _cItem
					DA1->DA1_PRCVEN := TRX->B1_PRV1
					DA1->DA1_INDLOT := "000000000999999.99" //StrZero(DA1->DA1_QTDLOT,18,2)
					DA1->DA1_ATIVO  := "1"
					DA1->DA1_TPOPER := "4"
					DA1->DA1_QTDLOT := 999999.99
					DA1->DA1_MOEDA  := 1
					DA1->DA1_CODPRO := TRX->B1_COD
					DA1->(MsUnLock())
				Endif
			else
				Do	While !Eof() .And. DA1->DA1_FILIAL == xFilial("DA1") .And.;
					DA1->DA1_CODTAB == mv_par04 .And. DA1->DA1_CODPRO == TRX->B1_COD
					If DA1->DA1_MOEDA  == 1
						Begin Transaction
						If Reclock("DA1",.F.)
							DA1->DA1_PRCVEN := TRX->B1_PRV1
							DA1->(MsUnLock())
						Endif
						End Transaction
					Else // DA1->DA1_MOEDA  <> 1
						Begin Transaction
						If Reclock("DA1",.F.)
							DA1->DA1_PRCVEN := TRX->B1_PRV1
							DA1->(MsUnLock())
						Endif
						End Transaction
					Endif
					
					dbSelectArea("DA1")
					DA1->(dbSkip())
				Enddo
			
		Endif
		
		RestArea(aAreaSB1)
		dbSelectArea("TRX")
		RestArea(aAreaTRX)
		
		dbSelectArea("TRX")
		TRX->(dbSkip())
	End
ElseIf mv_par03 == 2 // Cria Tabela
	_cNumTab 	:= MV_PAR04

	dbSelectArea("DA0")
	dbSetOrder(1)
	If !dbSeek(xFilial("DA0")+_cNumTab)
		Begin Transaction
		If Reclock("DA0",.T.)
			DA0->DA0_FILIAL := xFilial("DA0")
			DA0->DA0_CODTAB := _cNumTab
			DA0->DA0_DESCRI := "Tabela de Venda Atual"
			DA0->DA0_DATDE  := dDataBase
			DA0->DA0_HORADE := Transform(Time(),"99:99")
			DA0->DA0_HORATE := "23:59"
			DA0->DA0_TPHORA := "1"
			DA0->DA0_ATIVO  := "1"
			DA0->(MsUnlock())
			lgrava := .T.
		Endif
		End Transaction
	Endif
	// gravar DA1
	If lgrava
		Begin Transaction
		dbSelectArea("TRX")
		dbGoTop()
		ProcRegua(_nReg)
		While !Eof()
			IncProc("Processando Produto: "+TRX->B1_COD)
			
			nValorEx	:= 0
			nValorExL	:= 0
			
			aAreaTRX := TRX->(GetArea())
			aAreaSB1 := SB1->(GetArea())
			dbSelectArea("SB1")
			dbSetorder(1)
			dbSeek(xFilial("SB1")+TRX->B1_COD)
			
				nItens++
				dbSelectArea("DA1")
				dbSetOrder(1)
				cItem := Soma1(cItem,Len(DA1->DA1_ITEM))
				If Reclock("DA1",.T.)
					DA1->DA1_FILIAL := xFilial("DA1")
					DA1->DA1_CODTAB := _cNumTab
					DA1->DA1_ITEM   := cItem
					DA1->DA1_PRCVEN := TRX->B1_PRV1
					DA1->DA1_INDLOT := "000000000999999.99" //StrZero(DA1->DA1_QTDLOT,18,2)
					DA1->DA1_ATIVO  := "1"
					DA1->DA1_TPOPER := "4"
					DA1->DA1_QTDLOT := 999999.99
					DA1->DA1_MOEDA  := 1
					DA1->DA1_CODPRO := TRX->B1_COD
					DA1->(MsUnLock())
			Endif
			RestArea(aAreaSB1)
			dbSelectArea("TRX")
			RestArea(aAreaTRX)
			
			dbSelectArea("TRX")
			TRX->(dbSkip())
		End
		End Transaction

	Endif
Endif

dbSelectArea("TRX")
dbCloseArea()

Return(nItens)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para criacao das Perguntas no SX1                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Criacao de Perguntas SX1                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _CriaSX1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

//Parametros de perguntas para o relatorio
//+-----------------------------------------------------------------+
//| mv_par01 - Codigo de          ? XXXXXXXXXXXXXXX                 |
//| mv_par02 - Codigo ate         ? XXXXXXXXXXXXXXX                 |
//+-----------------------------------------------------------------+

aAdd(aReg,{_cPerg,"01","Codigo de ?        ","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SB1"})
aAdd(aReg,{_cPerg,"02","Codigo ate ?       ","mv_ch2","C",15,0,0,"G","(mv_par02>=mv_par01)","mv_par02","","","","","","","","","","","","","","","SB1"})
aAdd(aReg,{_cPerg,"03","Atualiza Tabela ?  ","mv_ch3","N",01,0,2,"C","","mv_par03","Sim","","","Não","","","","","","","","","","",""})
aAdd(aReg,{_cPerg,"04","Qual Tabela ?      ","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","DA0"})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil
