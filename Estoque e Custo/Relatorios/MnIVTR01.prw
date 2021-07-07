#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMnIVTR01  บAutor  ณLeandro Duarte      บ Data ณ  14/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExporta a consulta para Excel                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user Function MnIVTR01()
Local aCabExcel :={}
Local aItensExcel := {}
PRIVATE cPerg		:= "MNINVENTAR"
AjustaSX1("MNINVENTAR")
IF PERGUNTE("MNINVENTAR",.T.)
// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
AADD(aCabExcel, {"PRODUTO" ,TAMSX3("B2_COD")[3], TAMSX3("B2_COD")[1], TAMSX3("B2_COD")[2]})
AADD(aCabExcel, {"DESCRIวรO" ,TAMSX3("B1_DESC")[3], TAMSX3("B1_DESC")[1], TAMSX3("B1_DESC")[2]})
AADD(aCabExcel, {"ARMAZEM" ,TAMSX3("B2_LOCAL")[3], TAMSX3("B2_LOCAL")[1], TAMSX3("B2_LOCAL")[2]})
AADD(aCabExcel, {"PRIORIDADE" ,TAMSX3("BF_PRIOR")[3], TAMSX3("BF_PRIOR")[1], TAMSX3("BF_PRIOR")[2]})
AADD(aCabExcel, {"ENDEREวO" ,TAMSX3("BF_LOCALIZ")[3], TAMSX3("BF_LOCALIZ")[1], TAMSX3("BF_LOCALIZ")[2]})
AADD(aCabExcel, {"EMPENHO" ,TAMSX3("BF_EMPENHO")[3], TAMSX3("BF_EMPENHO")[1], TAMSX3("BF_EMPENHO")[2]})
AADD(aCabExcel, {"QUANTIDADE_ATUAL" ,TAMSX3("BF_QUANT")[3], TAMSX3("BF_QUANT")[1], TAMSX3("BF_QUANT")[2]})
AADD(aCabExcel, {"CONTAGEM_1" ,"C", 50, 0})
AADD(aCabExcel, {"CONTAGEM_2" ,"C", 50, 0})
	
If !ApOleClient("MsExcel") 
	aviso("Excel","Esta maquina nใo possui Excel"+CRLF+"O relatorio nใo pode ser Aberto!",{"OK"})
else
	cQuery := " SELECT A.BF_PRODUTO PRODUTO, "
	cQuery += "        B.B1_DESC DESCRICAO, "
	cQuery += "        A.BF_LOCAL LOCAIS, "
	cQuery += "        BF_PRIOR PRIORIDADE, "
	cQuery += "        BF_LOCALIZ ENDERECO, "
	cQuery += "        BF_EMPENHO EMPENHO, "
	cQuery += "        BF_QUANT QUANTIDADE_ATUAL, "
	cQuery += "        '[                                   ]' AS CONTAGEM_1, "
	cQuery += "        '[                                   ]' AS CONTAGEM_2 "
	cQuery += "   FROM "+retsqlname("SBF")+" A, "+retsqlname("SB1")+" B "
	cQuery += "  WHERE A.BF_PRODUTO = B.B1_COD "
	cQuery += "    AND A.BF_FILIAL = '"+XfILIAL("SBF")+"' "
   	cQuery += "    AND B.B1_FILIAL = '"+XfILIAL("SB1")+"' "
	cQuery += "    AND A.D_E_L_E_T_ = ' ' "
	cQuery += "    AND B.D_E_L_E_T_ = ' ' "
	cQuery += "    AND B.B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "    AND A.BF_LOCAL = '01' "
	cQuery += " UNION "
	cQuery += " SELECT C.B2_COD PRODUTO, "
	cQuery += "        B.B1_DESC DESCRICAO, "
	cQuery += "        C.B2_LOCAL, "
	cQuery += "        ' ', "
	cQuery += "        B2_LOCALIZ ENDERECO, "
	cQuery += "        B2_RESERVA EMPENHO, "
	cQuery += "        B2_QATU QUANTIDADE_ATUAL, "
	cQuery += "        '[                                   ]' AS CONTAGEM_1, "
	cQuery += "        '[                                   ]' AS CONTAGEM_2 "
	cQuery += "   FROM "+retsqlname("SB2")+" C, "+retsqlname("SB1")+" B "
	cQuery += "  WHERE C.B2_COD = B.B1_COD "
	cQuery += "    AND C.B2_FILIAL = '"+XfILIAL("SB2")+"' "
	cQuery += "    AND B.B1_FILIAL = '"+XfILIAL("SB1")+"' "
	cQuery += "    AND C.D_E_L_E_T_ = ' ' "
	cQuery += "    AND B.D_E_L_E_T_ = ' ' "
	cQuery += "    AND C.B2_LOCAL = '01' "
	cQuery += "    AND B.B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "    AND C.B2_COD NOT IN (SELECT A.BF_PRODUTO "
	cQuery += "                           FROM "+retsqlname("SBF")+" A, "+retsqlname("SB1")+" B "
	cQuery += "                          WHERE A.BF_PRODUTO = B.B1_COD "
	cQuery += "                            AND A.BF_FILIAL = '"+XfILIAL("SBF")+"' "
	cQuery += "                            AND B.B1_FILIAL = '"+XfILIAL("SB1")+"' "
	cQuery += "                            AND A.D_E_L_E_T_ = ' ' "
	cQuery += "                            AND B.D_E_L_E_T_ = ' ' "
	cQuery += "    						   AND B.B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "                            AND A.BF_LOCAL = '01') "
	cQuery += "  ORDER BY 5 "
		
	iif(select("TMP")>0,TMP->(dbclosearea()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
	WHILE TMP->(!EOF())
		aadd(aItensExcel,{PRODUTO,DESCRICAO,LOCAIS,PRIORIDADE,ENDERECO,EMPENHO,QUANTIDADE_ATUAL,CONTAGEM_1,CONTAGEM_2,1} )
		TMP->(DBSKIP())
	END

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS","POSIวรO DO ESTOQUE PARA INVENTARIO",aCabExcel,aItensExcel}})})
endif
ENDIF
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ao    ณ MnIVTR01.prw ณ Autor ณ Leandro duarte ณ Data  ณ 26/10/2016 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ao ณcria os perguntes                                           ณฑฑ
ฑฑณDescri็ao ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1()

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "INFORME O PRODUTO INICIAL PARA APRESENTAR" )
Aadd( aHelpPor, "NA LISTA DE CONTAGEM                    " )

Aadd( aHelpEng, "INFORME O PRODUTO INICIAL PARA APRESENTAR" )
Aadd( aHelpEng, "NA LISTA DE CONTAGEM                    ")

Aadd( aHelpSpa, "INFORME O PRODUTO INICIAL PARA APRESENTAR" )
Aadd( aHelpSpa, "NA LISTA DE CONTAGEM                    ")

PutSx1(cPerg,"01","Produto De  ?","De Producto ?","From Product?","mv_ch1","C",30,0,0,"G","","SB1","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "INFORME O PRODUTO FINAL PARA APRESENTAR" )
Aadd( aHelpPor, "NA LISTA DE CONTAGEM                    " )

Aadd( aHelpEng, "INFORME O PRODUTO FINAL PARA APRESENTAR" )
Aadd( aHelpEng, "NA LISTA DE CONTAGEM                    ")

Aadd( aHelpSpa, "INFORME O PRODUTO FINAL PARA APRESENTAR" )
Aadd( aHelpSpa, "NA LISTA DE CONTAGEM                    ")

PutSx1(cPerg,"02","Produto ate ?","De Producto ?","From Product?","mv_ch2","C",30,0,0,"G","","SB1","","S","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return Nil
