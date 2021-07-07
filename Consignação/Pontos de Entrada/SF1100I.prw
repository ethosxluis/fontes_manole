#INCLUDE "RWMAKE.CH"
//A100DEL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³TOTVS               º Data ³ 22/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I()
	Local aArea    := GetArea()
	Local aAreaSF1 := SF1->(GetArea())
	Local aAreaSD1 := SD1->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local CodEvent := ''
	Local cChave   := xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	//APMSGINFO("SF1100I")

	If SF1->F1_TIPO == 'B' // Retorno de Consignacao o tipo é beneficiamento.
	
		DbSelectArea("SD1")
		DbSetOrder(1)
		If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
			While SD1->(!Eof()) .And. xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChave
				CodEvent := Posicione("SD2",3,xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD +SD1->D1_ITEMORI,"D2_XEVENTO")
			// Cria registro com os dados da Devolucao.
				RecLock("SZ1",.T.)
				Z1_FILIAL  := xFilial("SZ1")
				Z1_CLIENTE := SD1->D1_FORNECE
				Z1_LOJA    := SD1->D1_LOJA
				Z1_PRODUTO := SD1->D1_COD
				Z1_UN      := SD1->D1_UM
				Z1_QUANT   := SD1->D1_QUANT
				Z1_DOC     := SD1->D1_DOC
				Z1_SERIE   := SD1->D1_SERIE
				Z1_EMISSAO := SD1->D1_EMISSAO
				Z1_ITEME   := SD1->D1_ITEM
				Z1_PRUNIT  := SD1->D1_VUNIT
				If SD1->D1_XOPER $ GetMv("MV_XTOPERE")  //"11"
					Z1_TIPO    := 'S' // Retorno Simbolico
				ElseIf SD1->D1_XOPER $ GetMv("MV_XTOPERF")  //"12,DM"
					Z1_TIPO    := 'D'// Retorno Fisico
				EndIf
				Z1_DOCORI  := SD1->D1_NFORI
				Z1_SERIEOR := SD1->D1_SERIORI
				Z1_ITEMORI := SD1->D1_ITEMORI
				Z1_SLDFAT  := SD1->D1_QUANT
				Z1_EVENTO  := CodEvent
				MsUnLock()
				If SD1->D1_XOPER $ GetMv("MV_XTOPERE")// Tipo de operacao fisica
					U_AtuCons(SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_COD,CodEvent,"SI",SD1->D1_QUANT)
				ElseIf SD1->D1_XOPER $ GetMv("MV_XTOPERF")
					U_AtuCons(SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_COD,CodEvent,"DI",SD1->D1_QUANT)
				EndIf
				///
				SD1->(DbSkip())
			EndDo
		
		EndIf
	EndIf

//anderson - 20121019 - validação para chave de nf-e (sefaz de entrada
	IF ALLTRIM(SF1->F1_ESPECIE) == "SPED"
		INCHVNF()
	ENDIF
//anderson

	RestArea(aAreaSD2)
	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ SF1100I  ³ Autor ³ ANDERSON CIRIACO      ³ Data ³ OUT/12   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre Get para chave de NF-e na Nota de Entrada SPED        ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION INCHVNF()
	PRIVATE _Men  := SPACE(44)

	If SF1->F1_FORMUL <> "S"
		_Men := IIF(!EMPTY(SF1->F1_CHVNFE),SF1->F1_CHVNFE,SPACE(44))
	
		@ 200,1 TO 370,600 DIALOG oDlg TITLE "Chave NF-e da N.F. de Entrada"
		@ 05,05 Say "Digite a Chave da NF-e (Ou Leitura do Código de Barras)"
		@ 15,05 get _Men size 280,10 VALID VLDCHV()
		@ 60,200 BMPBUTTON TYPE 01 action GravarF1()// Substituido pelo assistente de conversao do AP6 IDE em 04/06/03 ==>                 @ 10,150 BMPBUTTON TYPE 01 action execute(Gravar)
		ACTIVATE DIALOG oDlg center
	ENDIF

Return(NIL)
// GRAVARF1 - ANDERSON CIRIACO
Static function gravarF1()

	Reclock("SF1",.F.)
	SF1->F1_CHVNFE := alltrim(_Men)
	msunlock()
	close(odlg)

Return(NIL)
//VALIDA A CHAVE DA NOTA COM TAMANHO DE 44 CARACTERES (IDEIA INICIAL)
STATIC FUNCTION VLDCHV()
	LOCAL LRET := .T.

	IF LEN(ALLTRIM(_MEN)) < 44
		LRET := .F.
	ENDIF

RETURN(LRET)


