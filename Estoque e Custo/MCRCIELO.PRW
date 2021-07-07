#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCRCIELO  บAutor  ณ FONTANELLI         บ Data ณ  10/20/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA DE LEITURA DO RETORNO DO LAYOUT DO CARTรO DE CREDITO บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function MCRCIELO()
Local aBotoes	:= {}
Local aSays		:= {}
Local aPergunt	:= {}
Local nOpcao	:= 0
Local oRegua    := Nil

//Parametros da rotina
mv_par01	:= space(150)

//Tela de aviso e acesso aos parametros
AAdd(aSays,"[LEITURA DOS PAGAMENTOS EM CARTีES] VER.3 ")
AAdd(aSays,"Esse programa irแ importar os pagamentos dos pedidos do portal Vtex por cartใo de credito ")
AAdd(aSays,"na base do Protheus..")
Pergunte("MNREADCR",.F.)

AAdd(aBotoes,{ 5,.T.,{|| mv_par01 := cGetFile( "Arquivo Texto (*.TXT)|*.txt|Arquivo CSV (*.CSV)|*.csv|Retorno de CNB (*.RET)|*.RET", 'Selecione o Arquivo Texto para Importa็ใo', 0,, .T. )  } } )
AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )
FormBatch( "[LEITURA DOS PAGAMENTOS EM CARTีES]", aSays, aBotoes )

If nOpcao == 1
	Processa({|| MCRCIEL1() })
EndIf

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCRCIEL1  บAutor  ณ FONTANELLI         บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ROTINA PARA LER O ARQUIVO ACHAR O TITULO E BAIXAR O TITULO บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION MCRCIEL1()
Local bQuerySE1			:= {|| Iif(Select("TRB_SE1") > 0, TRB_SE1->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_SE1",.T.,.T.) , dbSelectArea("TRB_SE1"),TRB_SE1->(dbGoTop())}
Local aDados			:= {}
Local cLinha			:= ""
Local nLog				:= 0
Local aMotBaixa 		:= ReadMotBx()
Local cCodMotBx 		:= "NOR" //  Codigo do Motivo de Baixa utilizado para baixa dos titulos
Local lMotExist 		:= Iif(Ascan(aMotBaixa, {|x| Substr(x,1,3) = Upper(cCodMotBx) })>0,.T.,.F.)
Local lMotBxMov 		:= MovBcoBx(cCodMotBx)
Local aBaixa			:= {}
Local lNoBrowse 		:= .F.
Local nOpcBaixa			:= 0
Local aPar := {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}

Local   cArquivo  := "CIELO_"+Str(Day(dDatabase),2)+"_"+MesExtenso(dDatabase)+"_"+str(year(dDataBase),4)+".htm"
Local   cPath     := "C:\TEMP\"
Local   cHTML

Private nArq      := fCreate(cArquivo,0)
private lMSHelpAuto := .F.
private lMsErroAuto := .F.

If !File(mv_par01)
	MsgAlert("Aten็ใo, o arquivo informado nใo foi localizado.")
	RETURN()
EndIf

FT_FUse(mv_par01)
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()
if aviso("Aten็ใo","Voce esta Rodando que Tipo de Arquivo?",{"CREDITO"}) == 1
	FT_FSkip() // PULA A LINHA
endif
FT_FSkip() // PULA A LINHA


/*
LAYOUT NOVO
1-Data de Pagamento
2-Data da venda
3-Descri็ใo
4-Resumo de Opera็ใo
5-Nฐ do cartใo
6-TID
7-NSU / DOC
8-C๓digo Autoriza็ใo
9-Valor Bruto de Vendas (R$)
10-Rejeitado
*/


cHTML := HtmlCabec()
FWrite(nArq,cHtml,Len(cHtml))


While !FT_FEof()

	cMENSAGEM := ""

	IncProc("EFETUANDO A LEITURA/BAIXA DO ARQUIVO")

	lMSHelpAuto := .F.
	lMsErroAuto := .F.
	cLinha		:= FT_FReadLn()
	aDados		:= StrTOArray(cLinha,';')

	for nFor := 1 to len(aDados)
		aDados[nFor] := replace(aDados[nFor],'"','')
	next nFor

	aDados[9]	:= VAL(replace(replace(aDados[9],'.',''),',','.'))
	aDados[1]	:= CTOD(aDados[1])

	aDados[2]	:= CTOD(aDados[2])

	if LEN(aDados)>0 .AND. !EMPTY(aDados[1])

		// SOMA AS NOTAS COM O MESMO TICKET
		cQuery := " SELECT NVL(SUM(E1_SALDO),0) SALDO "
		cQuery += " FROM " + RetSQLName("SE1")
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
		cQuery += "   AND E1_SALDO > 0 "
		cQuery += "   AND E1_STATUS <> 'B' "
		cQuery += "   AND E1_TIPO <> 'NCC' "
		cQuery += "   AND E1_PGVTTID = '" + SUBSTR(aDados[6],1,20) + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		if at("/",aDados[3]) > 0
			cQuery += "   AND E1_PARCELA = '" + aPar[val(alltrim(substr(aDados[3],at("/",aDados[3])-2,2)))] + "' "
		endif
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
		DbSelectArea("TRB")
		TRB->(DbGoTop())
		nTRB_SALDO := TRB->SALDO
		TRB->(dbCloseArea())


		// QUANTIDADE DE NOTAS
		cQuery := " SELECT COUNT(*) QTDNOTAS "
		cQuery += " FROM " + RetSQLName("SE1")
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
		cQuery += "   AND E1_TIPO <> 'NCC' "
		cQuery += "   AND E1_PGVTTID = '" + SUBSTR(aDados[6],1,20) + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		if at("/",aDados[3]) > 0
			cQuery += "   AND E1_PARCELA = '" + aPar[val(alltrim(substr(aDados[3],at("/",aDados[3])-2,2)))] + "' "
		endif
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
		DbSelectArea("TRB")
		TRB->(DbGoTop())
		nTRB_QTDNOTAS := TRB->QTDNOTAS
		TRB->(dbCloseArea())

		cMENSAGEM:=""
	    lBAIXA := .F.

		nValorDesconto  := 0
		nValorMulta     := 0

		if nTRB_QTDNOTAS == 0
		   lBAIXA := .F.
		   cMENSAGEM := "(TICKET NAO ENCONTRADO)"
		elseif nTRB_SALDO == 0
		   lBAIXA := .F.
		   cMENSAGEM := "(TITULO JA FOI BAIXADO ANTERIORMENTE)"
		elseif nTRB_SALDO == aDados[9]
		   lBAIXA := .T.
		elseif nTRB_SALDO > aDados[9] // Protheus maior Cielo
				nValorDesconto  := nTRB_SALDO - aDados[9]
				nValorMulta     := 0
			if nValorDesconto > 0.10
			   lBAIXA := .F.
			   cMENSAGEM := "(VALOR DIVERGENTE) PROTHEUS R$ "+StrTran(Str( nTRB_SALDO ),".",",")+" ษ MAIOR CIELO R$ "+StrTran(Str( aDados[9] ),".",",")
			else
			   lBAIXA := .T.
			endif
		elseif aDados[9]  > nTRB_SALDO // Cielo maior Protheus
				nValorDesconto  := 0
				nValorMulta     := aDados[9] - nTRB_SALDO
			if nValorMulta > 0.10
			   lBAIXA := .F.
			   cMENSAGEM := "(VALOR DIVERGENTE) CIELO R$ "+StrTran(Str( aDados[9] ),".",",")+" ษ MAIOR PROTHEUS R$ "+StrTran(Str( nTRB_SALDO ),".",",")
			else
			   lBAIXA := .T.
			endif
		endif

		xTITULO  := ""
		xPREFIXO := ""
		xCLIENTE := ""
		xPARCELA := ""
		xSALDO   := 0

		if lBAIXA

			cQuery := " SELECT * "
			cQuery += " FROM " + RetSQLName("SE1")
			cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
			cQuery += "   AND E1_STATUS <> 'B' "
			cQuery += "   AND E1_TIPO <> 'NCC' "
			cQuery += "   AND E1_PGVTTID = '" + SUBSTR(aDados[6],1,20) + "' "
			cQuery += "   AND D_E_L_E_T_ = ' ' "

			if at("/",aDados[3]) > 0
				cQuery += "   AND E1_PARCELA = '" + aPar[val(alltrim(substr(aDados[3],at("/",aDados[3])-2,2)))] + "' "
			endif
			cQuery += "   ORDER BY E1_PREFIXO DESC "

			Eval(bQuerySE1)

			begin Transaction

			nREGISTRO := 0

			// Monta array a ser utilizado para baixa
			while TRB_SE1->(!EOF())

				xTITULO  := TRB_SE1->E1_NUM
				xPREFIXO := TRB_SE1->E1_PREFIXO
				xCLIENTE := TRB_SE1->E1_CLIENTE
				xPARCELA := TRB_SE1->E1_PARCELA
				xSALDO   := TRB_SE1->E1_SALDO

				nValorREC := 0
				if nREGISTRO==0
					if nValorDesconto == 0 .and. nValorMulta == 0
					   nValorREC := TRB_SE1->E1_SALDO
					elseif nValorDesconto > 0
					   nValorREC := TRB_SE1->E1_SALDO - nValorDesconto
					elseif nValorMulta > 0
					   nValorREC := TRB_SE1->E1_SALDO + nValorMulta
					endif
				else
				   nValorREC := TRB_SE1->E1_SALDO
				endif


				aBaixa	:= {	{"E1_PREFIXO",		TRB_SE1->E1_PREFIXO,											Nil},;
								{"E1_NUM",			TRB_SE1->E1_NUM,												Nil},;
								{"E1_PARCELA",		TRB_SE1->E1_PARCELA,											Nil},;
								{"E1_TIPO",			TRB_SE1->E1_TIPO,												Nil},;
								{"AUTMOTBX",		cCodMotBx,														Nil},;
								{"AUTBANCO",		"237",															Nil},;
								{"AUTAGENCIA",		"6539 ",														Nil},;
								{"AUTCONTA",		"7639      ", 													Nil},;
								{"AUTDTBAIXA",		aDados[1],														Nil},;
								{"AUTDTCREDITO",	aDados[1], 														Nil},;
								{"AUTHIST",			"*** "+ALLTRIM(aDados[3])+" ***" ,								Nil},;
								{"AUTDESCONT",		iif(nREGISTRO==0,nValorDesconto,0),				 			 	Nil},; //Valores de desconto
								{"AUTDECRESC",		0,				 		 			 							Nil},; //Valore de decrescimo - deve estar cadastrado no titulo previamente
								{"AUTACRESC",		0,				 	    			 							Nil},; //Valores de acrescimo - deve estar cadastrado no titulo previamente
								{"AUTMULTA",		iif(nREGISTRO==0,nValorMulta,0),	 							Nil},; //Valores de multa
								{"AUTJUROS",		0,				 				 	 							Nil},; //Valores de Juros
								{"AUTVALREC",		nValorREC,				   	 									Nil}}  //Valor recebido

				SE1->(DBGOTO(TRB_SE1->R_E_C_N_O_))

				if 	aBaixa[17][2] > 0

					lMSErroAuto := .F.

				    MSExecAuto({|x, y | FINA070(x, y )}, aBaixa, 3)

					If lMSErroAuto

						mostraerro()
						DisarmTransaction()
						fDetail(2,aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],substr(aDados[6],1,20),aDados[7],aDados[8],iif(nREGISTRO==0,aDados[9],0),0,0,0,"(EXECAUTO ERRO)",xTITULO,xPREFIXO,xCLIENTE,xPARCELA,xSALDO )

					else

						if nValorDesconto > 0
						  fDetail(1,aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],substr(aDados[6],1,20),aDados[7],aDados[8],iif(nREGISTRO==0,aDados[9],0),TRB_SE1->E1_SALDO,iif(nREGISTRO==0,nValorDesconto,0),iif(nREGISTRO==0,nValorMulta,0),"BAIXA COM DESCONTO",xTITULO,xPREFIXO,xCLIENTE,xPARCELA,xSALDO )
						elseif nValorMulta > 0
						  fDetail(1,aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],substr(aDados[6],1,20),aDados[7],aDados[8],iif(nREGISTRO==0,aDados[9],0),TRB_SE1->E1_SALDO,iif(nREGISTRO==0,nValorDesconto,0),iif(nREGISTRO==0,nValorMulta,0),"BAIXA COM MULTA",xTITULO,xPREFIXO,xCLIENTE,xPARCELA,xSALDO )
						else
						  fDetail(1,aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],substr(aDados[6],1,20),aDados[7],aDados[8],iif(nREGISTRO==0,aDados[9],0),TRB_SE1->E1_SALDO,iif(nREGISTRO==0,nValorDesconto,0),iif(nREGISTRO==0,nValorMulta,0),"BAIXA NORMAL",xTITULO,xPREFIXO,xCLIENTE,xPARCELA,xSALDO )
						endif

					Endif

				else

					fDetail(2,aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],substr(aDados[6],1,20),aDados[7],aDados[8],iif(nREGISTRO==0,aDados[9],0),TRB_SE1->E1_SALDO,0,0,cMensagem,xTITULO,xPREFIXO,xCLIENTE,xPARCELA,xSALDO )

				endif

				nREGISTRO:= nREGISTRO + 1

				TRB_SE1->(DBSKIP())
			end

			End Transaction

		else

			fDetail(2,aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],substr(aDados[6],1,20),aDados[7],aDados[8],aDados[9],0,0,0,cMENSAGEM,"","","","",0 )

		endif


	endif

	// fDetBRANCO()

	aBaixa	:= {}
	FT_FSkip()
EndDo


cHtml := CRLF+' </table></body></html>'
FWrite(nArq,cHtml,Len(cHtml))

fClose(nArq)

CpyS2T(GetSrvProfString("Startpath","")+cArquivo, cPath, .T.)

If (MsgYesNo("Deseja abrir a rela็ใo ?","Informa็๕es processadas"))
	If ApOleClient("MsExcel")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		ShellExecute("open",cPath + cArquivo,"","",1)
	endif
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStrTOArrayบAutor  ณFontanelli          บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para converter a string com o separador passado em   บฑฑ
ฑฑบ          ณarray                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function StrTOArray(cLinha,cSeparador)
Local aVetor	:= {}

while at(cSeparador,cLinha) > 0
	aadd(aVetor,substr(cLinha,1,at(cSeparador,cLinha)-1))
	cLinha := substr(cLinha,at(cSeparador,cLinha)+1)
end

aadd(aVetor,substr(cLinha,1))

Return(aVetor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDetail  บAutor  ณ Foontanelli         บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenchimento do detalhe 								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDetail(nCor,cDados1,cDados2,cDados3,cDados4,cDados5,cDados6,cDados7,cDados8,cDados9,nValorBaixa,nValorDesconto,nValorMulta,cMENSAGEM )
Local cHtml
Local aCor := {"00FF00","FFF000","FF0000"}

cHtml := CRLF + "<tr>"
cHtml += "<td>" + DTOC(cDados1)				   											+ "</td>"
cHtml += "<td>" + DTOC(cDados2)   					 									+ "</td>"
cHtml += "<td>" + cDados3																+ "</td>"
cHtml += "<td>" + cDados4																+ "</td>"
cHtml += "<td>" + cDados5																+ "</td>"
cHtml += "<td>" + cDados6																+ "</td>"
cHtml += "<td>" + cDados7																+ "</td>"
cHtml += "<td>" + cDados8																+ "</td>"
cHtml += "<td>" + StrTran(Str( cDados9 ),".",",")										+ "</td>"
cHtml += "<td bgcolor='#" + aCor[nCor] + "'>"+ iif(nCor==1," X "," E ")					+ "</td>"
cHtml += "<td>" + StrTran(Str( nValorBaixa ),".",",")									+ "</td>"
cHtml += "<td>" + StrTran(Str( nValorDesconto ),".",",")								+ "</td>"
cHtml += "<td>" + StrTran(Str( nValorMulta ),".",",")									+ "</td>"
cHtml += "<td>" + cMENSAGEM										 						+ "</td>"
cHtml += "<td>" + xTITULO																+ "</td>"
cHtml += "<td>" + xPREFIXO																+ "</td>"
cHtml += "<td>" + xCLIENTE																+ "</td>"
cHtml += "<td>" + xPARCELA																+ "</td>"
cHtml += "<td>" + StrTran(Str( xSALDO ),".",",")										+ "</td></tr>"

FWrite(nArq,cHtml,Len(cHtml))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDetBRANCOบAutor  ณ Foontanelli         บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenchimento do detalhe 								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDetBRANCO()
Local cHtml
Local aCor := {"00FF00","FFF000","FF0000"}

cHtml := CRLF + "<tr>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + "" 									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td>"
cHtml += "<td>" + ""									+ "</td></tr>"

FWrite(nArq,cHtml,Len(cHtml))

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHtmlCabec บAutor  ณ fontanelli         บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o cabe็alho HTML e folhas de estilho CSS + forma-  บฑฑ
ฑฑบ          ณ ta็ใo do inํcio da planilha                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UnoTech                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HtmlCabec()
Local cHtml
cHtml := CRLF+' <html> '
cHtml += CRLF+' <head> '
cHtml += CRLF+' <title>Relat๓rio de Processamento Cielo por Tiket em ' + DTOC(dDataBase) + '</title> '
cHtml += CRLF+' <style type="text/css"> '
cHtml += CRLF+' <!-- '
cHtml += CRLF+' .borda { '
cHtml += CRLF+' 	text-align:center; '
cHtml += CRLF+' 	vertical-align: top; '
cHtml += CRLF+' 	background-color: #DDDDDD; '
cHtml += CRLF+' 	font-weight:bold; '
cHtml += CRLF+' } '
cHtml += CRLF+' --> '
cHtml += CRLF+' </style> '
cHtml += CRLF+' </head> '
cHtml += CRLF+' <body> '
cHtml += CRLF+' <table border="1"> '
cHtml += CRLF+' <tr><td colspan="13" valign="middle" align="center"><b><font size="4">Relat๓rio de Processamento Cielo por Tiket em ' + DTOC(dDataBase) +'</font></td></tr>'
cHtml += CRLF+' <tr> '
cHtml += CRLF+' <td class="borda">Data de Pagamento</td>'
cHtml += CRLF+' <td class="borda">Data da venda</td>'
cHtml += CRLF+' <td class="borda">Descri็ใo</td>'
cHtml += CRLF+' <td class="borda">Resumo de Opera็ใo</td>'
cHtml += CRLF+' <td class="borda">Nฐ do cartใo</td>'
cHtml += CRLF+' <td class="borda">TID</td>'
cHtml += CRLF+' <td class="borda">NSU - DOC</td>'
cHtml += CRLF+' <td class="borda">C๓digo Autoriza็ใo</td>'
cHtml += CRLF+' <td class="borda">Valor Bruto de Vendas</td>'
cHtml += CRLF+' <td class="borda">&nbsp;&nbsp;&nbsp;</td>'
cHtml += CRLF+' <td class="borda">Valor Baixa</td>'
cHtml += CRLF+' <td class="borda">Valor Desconto</td>
cHtml += CRLF+' <td class="borda">Valor Multa</td>'
cHtml += CRLF+' <td class="borda">Motivo Erro</td>
cHtml += CRLF+' <td class="borda">Titulo</td>'
cHtml += CRLF+' <td class="borda">Prefixo</td>'
cHtml += CRLF+' <td class="borda">Cliente</td>'
cHtml += CRLF+' <td class="borda">Parcela</td>'
cHtml += CRLF+' <td class="borda">Saldo</td>'

cHtml += CRLF+' </tr>'
Return cHtml

