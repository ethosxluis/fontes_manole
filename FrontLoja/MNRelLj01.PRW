#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNRELLJ01 ºAutor  ³Leandro Duarte      º Data ³  06/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de impressão de itens vendidos no loja por caixa  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MNRelLj01()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RANKING DE PRODUTOS"
Local cPict          := ""
Local titulo         := "RANKING DE PRODUTOS"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aDados		:= {}
Private aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "MNRELLJ001"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private cPerg       := "MNRELLJ001"
Private wnrel       := "MNRELLJ001"

Private cString := "SL1"

dbSelectArea("SL1")
dbSetOrder(1)

ValidPerg(cPerg)

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca os Dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| 	BuscaDados(@aDados) },Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF LEN(aDados)>0
	RptStatus({|| Imprim(aDados,Cabec1,Cabec2,Titulo,nLin) },Titulo)
ELSE
	ALERT('Não encontrou Registro com a parametrização informada')
END
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXPR041   ºAutor  ³Microsiga           º Data ³  04/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)
Local nY, nX
Local aRegs  	:= {}
Local nSX1Order	:= SX1->(IndexOrd())

SX1->(dbSetOrder(1))
cPerg :=PADR(cPerg,len(sx1->x1_grupo))

Aadd(aRegs,{cPerg,"01","PERIODO DE",	"",	"",	"mv_ch1",	"D",	8						,	0,	0,	"G",	"",	"mv_par01",	"",	"",	"",	"",	"",				"",  					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","",""	})
Aadd(aRegs,{cPerg,"02","PERIODO ATÉ",	"",	"",	"mv_ch2",	"D",	8						,	0,	0,	"G",	"",	"mv_par02",	"",	"",	"",	"",	"",				"",  					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","",""	})
Aadd(aRegs,{cPerg,"03","PRODUTO DE",	"",	"",	"mv_ch3",	"C",	TamSx3('B1_COD')[1]		,	0,	0,	"G",	"",	"mv_par03",	"",	"",	"",	"",	"",				"",  					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","SB1","SB1"	})
Aadd(aRegs,{cPerg,"04","PRODUTO ATÉ",	"",	"",	"mv_ch4",	"C",	TamSx3('B1_COD')[1]		,	0,	0,	"G",	"",	"mv_par04",	"",	"",	"",	"",	"",				"", 					"",	"",	"",	"",  		"",  					"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",		"","","SB1","SB1"	})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaDadosºAutor  ³Leandro Duarte      º Data ³  06/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³captura as informações nas base de dados para gerar o relatoº±±
±±º          ³rio                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaDados(aDados)
Local aAreaSL1 := SL1->(GETAREA())
Local aAreaSL2 := SL2->(GETAREA())
Local aAreaSB1 := SB1->(GETAREA())
Local aRet		:= {}
dbselectarea("SL1")
SL1->(DBSETORDER(4))// EMISSAO
dbselectarea("SL2")
SL2->(DBSETORDER(1))
dbselectarea("SBI")
SBI->(DBSETORDER(1))

SL1->(DBSEEK(XFILIAL("SL1")+DTOS(MV_PAR01),.T.))
WHILE SL1->(!EOF()) .AND. SL1->L1_EMISSAO >= MV_PAR01 .AND. SL1->L1_EMISSAO <= MV_PAR02
	IF SL2->(DBSEEK(XFILIAL("SL2")+SL1->L1_NUM))
		WHILE SL2->(!EOF()) .AND. SL2->L2_NUM == SL1->L1_NUM
			IF SL2->L2_PRODUTO >= MV_PAR03 .AND. SL2->L2_PRODUTO <= MV_PAR04
				SBI->(DBSEEK(XFILIAL("SBI")+SL2->L2_PRODUTO))
				//AADD(aRet,{SL2->L2_PRODUTO, SBI->BI_DESC, SL2->L2_QUANT, SL2->L2_VLRITEM, 0, SL1->L1_DESCONT})
				//Edmar Mendes do Prado - 11/01/2018
				AADD(aRet,{SL2->L2_PRODUTO, SBI->BI_DESC, SL2->L2_QUANT, SL2->L2_VLRITEM, 0, SL2->L2_DESCPRO})
			ENDIF
			SL2->(DBSKIP())
		END
	ENDIF
	SL1->(DBSKIP())
END
Restarea(aAreaSL1)
Restarea(aAreaSL2)
Restarea(aAreaSB1)
ASORT(aRet,,,{|x,y| x[1]<y[1]})
For nFor := 1 to len(aRet) 
	nPos := ascan(aDados,{|x| x[1] == aRet[nFor][1] })
	if nPos <= 0
		AADD(aDados,{aRet[nFor][1], aRet[nFor][2], aRet[nFor][3], aRet[nFor][4], aRet[nFor][3]*aRet[nFor][4],aRet[nFor][6]})
	else
		aDados[nPos][3] += aRet[nFor][3]
		aDados[nPos][4] := aRet[nFor][4]
		aDados[nPos][5] += aRet[nFor][3]*aRet[nFor][4]
		aDados[nPos][6] += aRet[nFor][6]
	endif
Next nFor
ASORT(aDados,,,{|x,y| x[3]>y[3]})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imprim    ºAutor  ³Leandro Duarte      º Data ³  06/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para imprimir o relatorio                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imprim(aDados,Cabec1,Cabec2,Titulo,nLin)
Local nFor	:= 0

		 //          0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2         2         2
		 //          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
		 //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		 //|Fornecedor                             | Fl | Contrato                 | -------------- Total do Contrato ------------- | -------------- Baixado do Contrato ----------- | -------------- Saldo do Contrato ------------- |
 		 //|                                       |    |                          |     Principal |         Juros |          Total |     Principal |         Juros |          Total |     Principal |         Juros |          Total |
		 // ######-###############################   ##   ###### (###############)   XX.XXX.XXX,XX   XX.XXX.XXX,XX   XXX.XXX.XXX,XX   XX.XXX.XXX,XX   XX.XXX.XXX,XX   XXX.XXX.XXX,XX   XX.XXX.XXX,XX   XX.XXX.XXX,XX   XXX.XXX.XXX,XX  
Local Titulo += ": Vendas de "+DToC(mv_par01)+" ate "+DToC(mv_par02)
Local Cabec1 := "|Codigo            | Produto                                                                                                          |        Quanti |         Valor |          Total |"
Local Cabec2 := ""
lOCAL nLin := 157
Local nTtQTD := nTtVLR := nTtTOT := nTtDes := 0

For nFor := 1 to len(aDados)

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			If nLin < 80
				Roda()
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf


		@nLin, 001 PSay PadR(aDados[nFor][1],tamsx3("B1_COD")[1])
		@nLin, 021 PSay PadR(aDados[nFor][2],tamsx3("B1_DESC")[1])
		@nLin, 135 PSay Transform(aDados[nFor][3],  '@E 99,999,999.99')
		//@nLin, 151 PSay Transform(aDados[nFor][4],  '@E 99,999,999.99')
		@nLin, 168 PSay Transform(aDados[nFor][5], '@E 999,999,999.99')
		nLin++

		nTtQTD += aDados[nFor][3]
	   //	nTtVLR += aDados[nFor][4]
		nTtTOT += aDados[nFor][5]
		nTtDes += aDados[nFor][6]
Next nFor

	nLin += 1
	@nLin, 075 PSay 'Total do Desconto realizado: '+Transform(nTtdes,  '@E 99,999,999.99')
	@nLin, 135 PSay Transform(nTtQTD,  '@E 99,999,999.99')
	//@nLin, 151 PSay Transform(nTtVLR,  '@E 99,999,999.99')
	@nLin, 168 PSay Transform(nTtTOT, '@E 999,999,999.99')

	nLin += 2
	@nLin, 075 PSay 'Total Geral'
	@nLin, 168 PSay Transform(nTtTOT-nTtdes, '@E 999,999,999.99')

Roda()

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

