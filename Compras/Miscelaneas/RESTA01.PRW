#include "protheus.ch"
#include "TbiConn.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA01   ºAutor  ³Tiago Dantas da Cruzº Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que gera as amarracoes dos cadastros de produtos    º±±
±±º          ³ com os cadastros de Cliente e Fornecedor.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTA01()

Local aAreaSA7:=SA7->(GetArea())
Local aAreaSA5:=SA5->(GetArea())
Local aAreaSA1:=SA1->(GetArea())
Local aAreaSA2:=SA2->(GetArea())
Local aAreaSB1:=SB1->(GetArea())
Local aSays 	:= {}
Local aButtons 	:= {}
Local nOpcA 	:= 0
Local cCadastro := "Rotina que ajusta amarracao de fornecedor,cliente contra Produto"

AADD(aSays,OemToAnsi(" Esta rotina tem como objetivo principal ler os cadas"))
AADD(aSays,OemToAnsi(" tros de fornecedor,cliente,produtos gerando a amar- "))
AADD(aSays,OemToAnsi(" racao de entre estas tabelas.                       "))

AADD(aButtons, { 1,.T.,{|o| nOpcA:= 1,If(MsgYesNo(OemToAnsi("Confirme a execucao da rotina ?"),OemToAnsi("Atencao")),o:oWnd:End(),nOpcA:=0) } } )//-- Botao OK - Processa
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )//-- Botao Cancelar

FormBatch( cCadastro, aSays, aButtons,,200,405 )

If nOpcA == 1 //Confirmacao de processamento

	Processa({|| RESTA1A() },"Processando...!")

EndIf

RestArea(aAreaSA7)
RestArea(aAreaSA5)
RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aAreaSB1)
Return nil





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA1A   ºAutor  ³Tiago Dantas da Cruzº Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de interface para processamento das demais rotinas. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RESTA1A()
Local _cDirDest := "/system/"
Local _cNomeArq := "RESTA01"+Strtran(Dtoc(MsDate()),"/","")+StrTran(Time(),":","")+".txt"
Private _nHdl	:= fCreate(_cDirDest+AllTrim(_cNomeArq))
Private oProcesso := Nil

If _nHdl == -1
	Alert("Erro na criacao do arquivo de LOG:"+_cDirDest+AllTrim(_cNomeArq))
Else
	fWrite(_nHdl,"Iniciando Processamento: "+Dtoc(MsDate())+' '+Time()+ Chr(13)+Chr(10))
	oProcesso := MsNewProcess():New({|lEnd| RESTA1B() },"Processando cadastros...")//Funcao de leitura do arquivo que transforma o conteudo lido em Array
	oProcesso:Activate()
Endif
fClose(_nHdl)

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA1B   ºAutor  ³Tiago Dantas da Cruzº Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de semafaro para as demais rotinas.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function RESTA1B()

oProcesso:SetRegua1( 2 )
oProcesso:IncRegua1("Processando Fornecedores") // Atualiza a barra de processamento
fWrite(_nHdl,"Processando Fornecedores: "+Time()+Chr(13)+Chr(10))
RESTA1C()
fWrite(_nHdl,"Finalizando processo de Fornecedores: "+Time()+Chr(13)+Chr(10))
oProcesso:IncRegua1("Processando Clientes") // Atualiza a barra de processamento
fWrite(_nHdl,"Processando Clientes: "+Time()+Chr(13)+Chr(10))
RESTA1D()
fWrite(_nHdl,"Finalizado Processo de Clientes: "+Time()+ Chr(13)+Chr(10))

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA1C   ºAutor  ³Tiago Dantas da Cruzº Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que grava as informacoes de Fornecedor              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RESTA1C()

oProcesso:SetRegua2(0)

cQuery := " SELECT A2_COD, A2_LOJA, A2_NOME, B1_COD, B1_DESC "
cQuery += " FROM ( "
cQuery += " SELECT A2_COD, A2_LOJA, A2_NOME, B1_COD, B1_DESC "
cQuery += " FROM "+RetSqlName("SA2")+" SA2  ,"+RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SA2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQuery += " ) TRB "
cQuery += " LEFT JOIN "+RetSqlName("SA5")+" SA5 ON SA5.D_E_L_E_T_='' AND A5_FORNECE = TRB.A2_COD "
cQuery += " AND A5_LOJA = TRB.A2_LOJA AND A5_PRODUTO = TRB.B1_COD "
cQuery += " WHERE SA5.A5_FILIAL IS NULL "
//cQuery += " ORDER BY A2_COD, A2_LOJA, A2_NOME, B1_COD, B1_DESC "

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

cQuery := Changequery(cQuery)

TCQuery cQuery New Alias "QRY"

Dbselectarea("QRY")
QRY->(DbgoTop())
While !QRY->(Eof())
	oProcesso:IncRegua2(QRY->A2_NOME+'-'+QRY->B1_COD ) // Atualiza a barra de processamento
	Reclock("SA5",.T.)
		SA5->A5_FILIAL := xFilial("SA5")
		SA5->A5_FORNECE := QRY->A2_COD
		SA5->A5_LOJA    := QRY->A2_LOJA
		SA5->A5_NOMEFOR := QRY->A2_NOME
		SA5->A5_PRODUTO	:= QRY->B1_COD
		SA5->A5_NOMPROD := QRY->B1_DESC
	SA5->(MsUnlock())

QRY->(Dbskip())
EndDo
QRY->(DbCloseArea())

/*
oProcesso:SetRegua2(0)

Dbselectarea("SA2")
Dbsetorder(1)
SA2->(Dbgotop())

While !SA2->(Eof())
	Dbselectarea("SB1")
	Dbsetorder(1)
	SB1->(Dbgotop())
	While !SB1->(Eof())
		oProcesso:IncRegua2(SA2->A2_NOME+'-'+SB1->B1_COD ) // Atualiza a barra de processamento
		Dbselectarea("SA5")
		Dbsetorder(1)
		If !DbSeek(xFilial("SA5")+SA2->(A2_COD+A2_LOJA)+SB1->B1_COD )
			Reclock("SA5",.T.)
				SA5->A5_FILIAL := xFilial("SA5")
				SA5->A5_FORNECE := SA2->A2_COD
				SA5->A5_LOJA    := SA2->A2_LOJA
				SA5->A5_NOMEFOR := SA2->A2_NOME
				SA5->A5_PRODUTO	:= SB1->B1_COD
				SA5->A5_NOMPROD := SB1->B1_DESC
			SA5->(MsUnlock())
		EndIf
	SB1->(Dbskip())
	EndDo
SA2->(Dbskip())
EndDo
*/

Return nil




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA1C   ºAutor  ³Tiago Dantas da Cruzº Data ³  12/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que grava as informacoes de Cliente                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RESTA1D()


oProcesso:SetRegua2(0)

cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, B1_COD, B1_DESC "
cQuery += " FROM ( "
cQuery += " SELECT A1_COD, A1_LOJA, A1_NOME, B1_COD, B1_DESC "
cQuery += " FROM "+RetSqlName("SA1")+" SA1  ,"+RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SA1.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQuery += " ) TRB "
cQuery += " LEFT JOIN "+RetSqlName("SA7")+" SA7 ON SA7.D_E_L_E_T_='' AND A7_CLIENTE = TRB.A1_COD "
cQuery += " AND A7_LOJA = TRB.A1_LOJA AND A7_PRODUTO = TRB.B1_COD "
cQuery += " WHERE SA7.A7_FILIAL IS NULL "
//cQuery += " ORDER BY A1_COD, A1_LOJA, A1_NOME, B1_COD, B1_DESC "

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

cQuery := Changequery(cQuery)

TCQuery cQuery New Alias "QRY"

Dbselectarea("QRY")
QRY->(DbgoTop())
While !QRY->(Eof())
	oProcesso:IncRegua2( alltrim(QRY->A1_NOME)+'-'+Alltrim(QRY->B1_COD) ) // Atualiza a barra de processamento
	Reclock("SA7",.T.)
		SA7->A7_FILIAL := xFilial("SA7")
		SA7->A7_CLIENTE := QRY->A1_COD
		SA7->A7_LOJA    := QRY->A1_LOJA
		SA7->A7_DESCCLI := QRY->A1_NOME
		SA7->A7_PRODUTO	:= QRY->B1_COD
	SA7->(MsUnlock())

QRY->(Dbskip())
EndDo
QRY->(DbCloseArea())

/*
oProcesso:SetRegua2(0)
Dbselectarea("SA1")
Dbsetorder(1)
SA1	->(Dbgotop())

While !SA1->(Eof())
	Dbselectarea("SB1")
	Dbsetorder(1)
	SB1->(Dbgotop())
	While !SB1->(Eof())

		oProcesso:IncRegua2(SA1->A1_NOME+'-'+SB1->B1_COD ) // Atualiza a barra de processamento
		Dbselectarea("SA7")
		Dbsetorder(1)
		If !DbSeek(xFilial("SA7")+SA1->(A1_COD+A1_LOJA)+SB1->B1_COD )
			Reclock("SA7",.T.)
				SA7->A7_FILIAL := xFilial("SA7")
				SA7->A7_CLIENTE := SA1->A1_COD
				SA7->A7_LOJA    := SA1->A1_LOJA
				SA7->A7_DESCCLI := SA1->A1_NOME
				SA7->A7_PRODUTO	:= SB1->B1_COD
			SA7->(MsUnlock())
		EndIf
		SB1->(Dbskip())
	EndDo
SA1->(Dbskip())
EndDo
*/
Return nil