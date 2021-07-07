#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"     
#include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATR06  ³ Autor ³ TOTVS                    ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATR06()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := "Este relatório ira imprimir o resumo  "
Local cDesc2  := "das consignacoes por cliente."
Local cDesc3  := "."

Private cString  := "SD2"
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RFAT01"
Private NomeProg := "RFAT01"
Private nLastKey := 0
Private Limite   := 220//P=80    M=132   G=220
Private Tamanho  := "G"
Private Titulo   := "Relação de Consignacao por Cliente"
Private cPerg    := "RFAT01"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "Registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private lImp     := .F.

AjustaSX1()
Pergunte(cPerg,.F.)

//           0        10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1   := " Cliente - Loja"
Cabec2   := " I.S.B.N.                     Titulo                        Autor                      Evento                   Consig         Dev.Simbol     Devolucao      Faturado       Pendente       "


////////////////////////////////////////
//mv_par01 -  1=Analitico; 2=Sintetico//
////////////////////////////////////////
//Cabec1 := "Vendedor    Pedido     Frete        Qtd Caixas            Valor "

/*
+-----------------------+
| Parametros do aReturn |
+-----------------------+
aReturn - Preenchido pelo SetPrint()
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Comprimido 2=Normal
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Prota ou arquivo 1-Lpt1... 4-Com1...
aReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,.F.,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
	Return
Endif

//+-------------------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+-------------------------------------------------------------------------------
SetDefault(aReturn,cString)

//+-------------------------------------------------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------------------------------------------------
nTipo := Iif(aReturn[4] == 1, 15, 18)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
	Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| FATR01(@lEnd, wnrel, cString) }, "Aguarde...", "Processando Registros...", .T. )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FATR01   ³ Autor ³TOTVS                  ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  FATR01(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery    := ""
Local cChave    := ""
Local ENTERL    := CHR(13)+CHR(10)
Local cAliasNew := GetNextAlias()
Local cNomeCli  := ""
Local nTotPen   := 0
Local nTotLiq   := 0
//+-----------------------
//| Cria filtro temporario
//+-----------------------
// mv_par11 = 1 - Loja; 2 = Evento ; 3 = Ambos.
cAliasNew:= GetNextAlias()


//cQuery := " SELECT TEMP.D2_CLIENTE AS CLIENTE ,TEMP.D2_LOJA AS LOJA , TEMP.D2_COD AS PRODUTO, TEMP.D2_XEVENTO AS EVENTO , " + ENTERL
//cQuery += " SUM(TEMP.CONSIGNADO) AS CONSIG , SUM (TEMP.RETORNADO)AS RETORN ,SUM(TEMP.RSIMB) AS RSIMB ,SUM(TEMP.FATURADO)AS FATUR, SUM(TEMP.NOCLIENTE) AS NOCLI " + ENTERL
//cQuery += " FROM ( " + ENTERL
// Primeira Query.
cQuery += " SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO, " + ENTERL
cQuery += " SUM(SD2.D2_QUANT) AS CONSIGNADO, 0  AS RETORNADO, 0 AS RSIMB, 0  AS FATURADO, 0 AS NOCLIENTE " +ENTERL
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "+ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SB6")+ " SB6 ON "+ ENTERL
cQuery += " SD2.D2_IDENTB6 = SB6.B6_IDENT "+ ENTERL
cQuery += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' AND "+ENTERL
cQuery += " SD2.D2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03+ "' AND " + ENTERL
cQuery += " SD2.D2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 +"' AND " + ENTERL
cQuery += " SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "' AND " + ENTERL
// Filtro por evento
If mv_par11 == 1 // Loja
	cQuery += " SD2.D2_XEVENTO = '      ' AND " + ENTERL
ElseIf mv_par11 == 2 // Evento
	cQuery += " SD2.D2_XEVENTO BETWEEN '" + mv_par12 + "' AND '" + mv_par13+ "' AND " + ENTERL
	cQuery += " SD2.D2_XEVENTO <> '      ' AND " + ENTERL
EndIf

cQuery += " SD2.D2_EMISSAO BETWEEN '" + Dtos(mv_par09) + "' AND '" + Dtos(mv_par10)+ "' AND " + ENTERL
cQuery += " SD2.D_E_L_E_T_ = ' ' AND " + ENTERL
cQuery += " SB6.B6_FILIAL  = '"+xFilial("SB6")+"' AND "+ENTERL
cQuery += " SB6.B6_TPCF = 'C' AND B6_PODER3 = 'R' AND  SB6.D_E_L_E_T_ = ' ' "+ENTERL
cQuery += " GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO " +ENTERL

cQuery += " UNION "+ENTERL
// Segunda Query
cQuery += " SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO, "+ENTERL
cQuery += " 0 AS CONSIGNADO, SUM(SZ1.Z1_QUANT) AS RETORNADO, 0 AS RSIMB, 0 AS FATURADO, 0 AS NOCLIENTE" +ENTERL
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "+ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SD1")+ " SD1 ON "+ ENTERL
cQuery += " SD2.D2_CLIENTE = SD1.D1_FORNECE AND "+ ENTERL
cQuery += " SD2.D2_LOJA = SD1.D1_LOJA AND "+ ENTERL
cQuery += " SD2.D2_DOC = SD1.D1_NFORI AND "+ ENTERL
cQuery += " SD2.D2_SERIE = SD1.D1_SERIORI AND "+ ENTERL
cQuery += " SD2.D2_COD = SD1.D1_COD "+ ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SZ1")+ " SZ1 ON "+ ENTERL
cQuery += " SD1.D1_FORNECE = SZ1.Z1_CLIENTE AND "+ ENTERL
cQuery += " SD1.D1_LOJA = SZ1.Z1_LOJA AND "+ ENTERL
cQuery += " SD1.D1_DOC = SZ1.Z1_DOC  AND "+ ENTERL
cQuery += " SD1.D1_SERIE = SZ1.Z1_SERIE AND "+ ENTERL
cQuery += " SD1.D1_COD = SZ1.Z1_PRODUTO "+ ENTERL
cQuery += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' AND "+ENTERL
cQuery += " SD2.D2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03+ "' AND " + ENTERL
cQuery += " SD2.D2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 +"' AND " + ENTERL
cQuery += " SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 +"' AND " + ENTERL
cQuery += " SD2.D2_EMISSAO BETWEEN '" + Dtos(mv_par09) + "' AND '" + Dtos(mv_par10)+ "' AND " + ENTERL
// Filtro por evento
If mv_par11 == 1 // Loja
	cQuery += " SD2.D2_XEVENTO = '      ' AND " + ENTERL
ElseIf mv_par11 == 2 // Evento
	cQuery += " SD2.D2_XEVENTO BETWEEN '" + mv_par12 + "' AND '" + mv_par13+ "' AND " + ENTERL
	cQuery += " SD2.D2_XEVENTO <> '      ' AND " + ENTERL

EndIf

cQuery += " SD2.D_E_L_E_T_ = ' ' AND " + ENTERL
cQuery += " SD1.D1_FILIAL  = '"+xFilial("SD1")+"' AND "+ENTERL
cQuery += " SD1.D_E_L_E_T_ = ' ' AND "+ENTERL
cQuery += " SZ1.Z1_FILIAL  = '"+xFilial("SZ1")+"' AND "+ENTERL
cQuery += " SZ1.Z1_TIPO = 'D' AND SZ1.D_E_L_E_T_ = ' '"+ENTERL//ACRESCENTAR O TIPO D.
cQuery += " GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO "+ENTERL
//Terceira Query
cQuery += " UNION " +ENTERL
cQuery += " SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO, "+ENTERL
cQuery += " 0 AS CONSIGNADO, 0 AS RETORNADO, SUM(SZ1.Z1_QUANT) AS RSIMB,0 AS FATURADO, 0 AS NOCLIENTE" +ENTERL
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "+ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SD1")+ " SD1 ON "+ ENTERL
cQuery += " SD2.D2_CLIENTE = SD1.D1_FORNECE AND "+ ENTERL
cQuery += " SD2.D2_LOJA = SD1.D1_LOJA AND "+ ENTERL
cQuery += " SD2.D2_DOC = SD1.D1_NFORI AND "+ ENTERL
cQuery += " SD2.D2_SERIE = SD1.D1_SERIORI AND "+ ENTERL
cQuery += " SD2.D2_COD = SD1.D1_COD "+ ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SZ1")+ " SZ1 ON "+ ENTERL
cQuery += " SD1.D1_FORNECE = SZ1.Z1_CLIENTE AND "+ ENTERL
cQuery += " SD1.D1_LOJA = SZ1.Z1_LOJA AND "+ ENTERL
cQuery += " SD1.D1_DOC = SZ1.Z1_DOC  AND "+ ENTERL
cQuery += " SD1.D1_SERIE = SZ1.Z1_SERIE AND "+ ENTERL
cQuery += " SD1.D1_COD = SZ1.Z1_PRODUTO "+ ENTERL
cQuery += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' AND "+ENTERL
cQuery += " SD2.D2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03+ "' AND " + ENTERL
cQuery += " SD2.D2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 +"' AND " + ENTERL
cQuery += " SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 +"' AND " + ENTERL
cQuery += " SD2.D2_EMISSAO BETWEEN '" + Dtos(mv_par09) + "' AND '" + Dtos(mv_par10)+ "' AND " + ENTERL
// Filtro por evento
If mv_par11 == 1 // Loja
	cQuery += " SD2.D2_XEVENTO = '      ' AND " + ENTERL
ElseIf mv_par11 == 2 // Evento
	cQuery += " SD2.D2_XEVENTO BETWEEN '" + mv_par12 + "' AND '" + mv_par13+ "' AND " + ENTERL
	cQuery += " SD2.D2_XEVENTO <> '      ' AND " + ENTERL
EndIf

cQuery += " SD2.D_E_L_E_T_ = ' ' AND " + ENTERL
cQuery += " SD1.D1_FILIAL  = '"+xFilial("SD1")+"' AND "+ENTERL
cQuery += " SD1.D_E_L_E_T_ = ' ' AND "+ENTERL
cQuery += " SZ1.Z1_FILIAL  = '"+xFilial("SZ1")+"' AND "+ENTERL
cQuery += " SZ1.Z1_TIPO = 'S' AND SZ1.D_E_L_E_T_ = ' '"+ENTERL//ACRESCENTAR O TIPO D.
cQuery += " GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO "+ENTERL


// Quarta Query
cQuery += " UNION " +ENTERL
cQuery += " SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_XEVENTO,"+ENTERL
cQuery += " 0 AS CONSIGNADO, 0 AS RETORNADO, 0 AS RSIMB,SUM(SD2.D2_QUANT) AS FATURADO, 0 AS NOCLIENTE "+ENTERL
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "+ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SZ1")+ " SZ1 ON "+ ENTERL
cQuery += " SD2.D2_CLIENTE = SZ1.Z1_CLIENTE AND "+ ENTERL
cQuery += " SD2.D2_LOJA = SZ1.Z1_LOJA AND "+ ENTERL
cQuery += " SD2.D2_DOC = SZ1.Z1_DOC AND "+ ENTERL
cQuery += " SD2.D2_SERIE = SZ1.Z1_SERIE AND "+ ENTERL
cQuery += " SD2.D2_COD = SZ1.Z1_PRODUTO "+ ENTERL
cQuery += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' AND "+ENTERL
cQuery += " SD2.D2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03+ "' AND " + ENTERL
cQuery += " SD2.D2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 +"' AND " + ENTERL
cQuery += " SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "' AND " + ENTERL
cQuery += " SD2.D2_EMISSAO BETWEEN '" + Dtos(mv_par09) + "' AND '" + Dtos(mv_par10)+ "' AND " + ENTERL
// Filtro por evento
If mv_par11 == 1 // Loja
	cQuery += " SD2.D2_XEVENTO = '      ' AND " + ENTERL
ElseIf mv_par11 == 2 // Evento
	cQuery += " SD2.D2_XEVENTO BETWEEN '" + mv_par12 + "' AND '" + mv_par13+ "' AND " + ENTERL
	cQuery += " SD2.D2_XEVENTO <> '      ' AND " + ENTERL
EndIf

cQuery += " SD2.D_E_L_E_T_ = ' ' AND " + ENTERL
cQuery += " SZ1.Z1_FILIAL  = '"+xFilial("SZ1")+"' AND "+ENTERL
cQuery += " SZ1.Z1_TIPO = 'F' AND SZ1.D_E_L_E_T_ = ' '"+ENTERL
cQuery += " GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD,SD2.D2_XEVENTO "+ENTERL
//Quinta Query
cQuery += " UNION "+ENTERL
cQuery += " SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD , SD2.D2_XEVENTO, "+ENTERL
cQuery += " 0 AS CONSIGNADO, 0  AS RETORNADO,0 AS RSIMB, 0  AS FATURADO, SUM(B6_SALDO) AS NOCLIENTE "+ENTERL
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "+ENTERL
cQuery += " INNER JOIN "+ RetSqlName("SB6")+ " SB6 ON "+ ENTERL
cQuery += " SD2.D2_IDENTB6 = SB6.B6_IDENT "+ ENTERL
cQuery += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' AND "+ENTERL
cQuery += " SD2.D2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03 +"' AND " + ENTERL
cQuery += " SD2.D2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04+ "' AND " + ENTERL
cQuery += " SD2.D2_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "' AND " + ENTERL
cQuery += " SD2.D2_EMISSAO BETWEEN '" + Dtos(mv_par09) + "' AND '" + Dtos(mv_par10)+ "' AND " + ENTERL
// Filtro por evento
If mv_par11 == 1 // Loja
	cQuery += " SD2.D2_XEVENTO = '      ' AND " + ENTERL
ElseIf mv_par11 == 2 // Evento
	cQuery += " SD2.D2_XEVENTO BETWEEN '" + mv_par12 + "' AND '" + mv_par13+ "' AND " + ENTERL
	cQuery += " SD2.D2_XEVENTO <> '      ' AND " + ENTERL
EndIf

cQuery += " SD2.D_E_L_E_T_ = ' ' AND " + ENTERL
cQuery += " SB6.B6_FILIAL  = '"+xFilial("SB6")+"' AND "+ENTERL
cQuery += " SB6.B6_TPCF = 'C' AND B6_PODER3 = 'R' AND  SB6.D_E_L_E_T_ = ' ' "+ENTERL
cQuery += " GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD , SD2.D2_XEVENTO " +ENTERL
//cQuery += " ) AS TEMP" +ENTERL
//cQuery += " GROUP BY TEMP.D2_CLIENTE, TEMP.D2_LOJA, TEMP.D2_COD, TEMP.D2_XEVENTO " +ENTERL
//cQuery += " ORDER BY TEMP.D2_CLIENTE, TEMP.D2_LOJA, TEMP.D2_XEVENTO, TEMP.D2_COD " 

MEMOWRITE ("RFATR01.TXT",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)


(cAliasNew)->(dbGoTop())
If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

While (cAliasNew)->(!Eof())
	lImp   := .T.

	If cChave <> (cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA
	
		cNomeCli := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA,"A1_NREDUZ")
		@ Li, 000 PSay (cAliasNew)->D2_CLIENTE + " "+ (cAliasNew)->D2_LOJA +" - "+ cNomeCli
		Li++
		@ Li,000 Psay __PrtThinLine()
		Li++
		
		cChave  := (cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA
		nTotPen := 0
	EndIf
	
	@ Li, 000 PSay AllTrim((cAliasNew)->D2_COD)
	@ Li, 030 PSay AllTrim(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_DESC"))
	@ Li, 061 PSay AllTrim(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_XNMAUT"))

	@ Li, 087 PSay (cAliasNew)->D2_XEVENTO
	//@ Li, 085 PSay 50 Picture PesqPict("SD2","D2_QUANT")// Preco de Tabela
	@ Li, 105 PSay (cAliasNew)->CONSIGNADO Picture "@E 99,999,999.99"//CONSIGNADO
	@ Li, 120 PSay (cAliasNew)->RSIMB  Picture "@E 99,999,999.99"//DEV.SIMN
	@ Li, 135 PSay (cAliasNew)->RETORNADO Picture "@E 99,999,999.99"//DEV. FISICA
	@ Li, 150 PSay (cAliasNew)->FATURADO  Picture "@E 99,999,999.99"//FATURADO
	
	@ Li, 165 PSay (cAliasNew)->NOCLIENTE  Picture "@E 99,999,999.99"//PENDENTE
//	@ Li, 175 PSay 9999                Picture "@E 99,999,999.99"//Total Liquido


	nTotPen += (cAliasNew)->NOCLIENTE

  //           0        10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
  //           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//Cabec1   := " Cliente - Loja"
//Cabec2   := " I.S.B.N.           Titulo                         Autor                        Desc(%)   Prc. Bru       Consig         Faturado       Devolvido      Pendente       Total Liquido"
		//DATA DE ULTIMO ACERTO (VERIFICA DADOS DE B6)
		_DDTACERT := CTOD("  /  /    ")
		_DDTACERT := ACHAdtB6((cAliasNew)->D2_CLIENTE , (cAliasNew)->D2_LOJA)	
	Li++
	(cAliasNew)->(dbSkip())
	
	If cChave <> (cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA
		Li++
		@ Li, 000 PSay " T O T A L  - - - - - - - - - - - - > "
		@ Li, 165 PSay	nTotPen Picture "@E 99,999,999.99"
		Li++   
        IF !EMPTY(_DDTACERT)
        @ Li, 000 PSay " Data de ultima movimentação do cliente: "+dtoc(_DDTACERT) 
        Li++ 
        ELSE
        @ Li, 000 PSay " Data de ultimo acerto não encontrada "
        Li++      
        ENDIF
		@ Li,000 Psay __PrtThinLine()
		//@ Li, 000 PSay Replicate("=", Limite)
		Li++
		//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	
	If Li > 51 //.And. !TRB->(Eof())
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//		Li++
		//		@ Li,000 Psay __PrtThinLine()
		//		Li++
		//		Cabec1()
	Endif
	
EndDo


If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif


(cAliasNew)->(DbCloseArea())

If lEnd
	@ Li, 000 PSay cCancel
	Return
Endif

If 	lImp
	If Li <> 80
		Roda(cbCont,cbTxt,Tamanho)//Impressao de Rodape padrao.
	Endif
	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
Else
	MsgStop ("Nao existem dados a serem visualizados!, Verifique os parametros" )
EndIf

Ms_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    ºData  ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para incluir os grupos de perguntas OMSC01           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
PutSx1(cPerg, '01', 'Cliente de      ?', 'Cliente de     ?', 'Cliente de    ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par01', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '02', 'Loja de         ?', 'Loja de        ?', 'Loja de       ?', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '03', 'Cliente ate     ?', 'Cliente ate    ?', 'Cliente ate   ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par02', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'Loja Ate        ?', 'Loja ate       ?', 'Loja ate      ?', 'mv_ch4', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '05', 'Produto de      ?', 'Produto de     ?', 'Produto de    ?', 'mv_ch5', 'C',30, 0, 0, 'G', '', 'SB1'   , '', '', 'mv_par05', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto ate     ?', 'Produto ate    ?', 'Produto ate   ?', 'mv_ch6', 'C',30, 0, 0, 'G', '', 'SB1'   , '', '', 'mv_par06', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '07', 'Segmento de     ?', 'Segmento de    ?', 'Segmento de   ?', 'mv_ch7', 'C',10, 0, 0, 'G', '', ''   , '', '', 'mv_par07', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '08', 'Segmento ate    ?', 'Segmento ate   ?', 'Segmento ate  ?', 'mv_ch8', 'C',10, 0, 0, 'G', '', ''   , '', '', 'mv_par08', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '09', 'Emissao de      ?', 'Emissao de     ?', 'Emissao de    ?', 'mv_ch9', 'D',8, 0, 0, 'G', '', ''   , '', '', 'mv_par09', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '10', 'Emissao ate     ?', 'Emissao ate    ?', 'Emissao ate   ?', 'mv_cha', 'D',8, 0, 0, 'G', '', ''   , '', '', 'mv_par10', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '11','Tipo Consignacao ?','Tipo Consignacao?','Tipo Consig    ?', 'mv_chb', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par11',	 'Loja','Loja','Loja', '', 'Evento','Evento','Evento','Ambos','Ambos','Ambos','','','','','','','')

PutSx1(cPerg, '12', 'Evento de       ?', 'Evento de      ?', 'Evento de     ?', 'mv_chc', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par12', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '13', 'Evento ate      ?', 'Evento ate     ?', 'Evento ate    ?', 'mv_chd', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par13', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')


/*
PutSx1(cPerg, '03', 'Cliente de       ?', 'Cliente de      ?', 'Cliente de     ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'Cliente ate      ?', 'Cliente ate     ?', 'Cliente ate    ?', 'mv_ch4', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '05', 'Loja de          ?', 'Loja de         ?', 'Loja de        ?', 'mv_ch5', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '06', 'Loja Ate         ?', 'Loja Ate        ?', 'Loja Ate       ?', 'mv_ch6', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '07', 'Emissao de       ?', 'Emissao de      ?', 'Emissao de     ?', 'mv_ch7', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par05', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '08', 'Emissao ate      ?', 'Emissao ate     ?', 'Emissao ate    ?', 'mv_ch8', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par06', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '09','Tipo Frete        ?', 'Tipo Frete      ?','Tipo Frete      ?', 'mv_ch9', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par05',	 'Cif',	'Cif','Cif', '', 'Fob',	'Fob','Fob','Ambos','Ambos','Ambos','','','','','','','')
*/
Return


//ACHAdtB6((cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA))
STATIC FUNCTION ACHAdtB6(CCLI,CLOJA)
LOCAL _DRET := CTOD("  /  /    ")
LOCAL _CQUERY := ""

_CQUERY := " SELECT B6_EMISSAO FROM "+RETSQLNAME("SB6")+" WHERE B6_FILIAL = '"+XFILIAL("SB6")+"' AND B6_CLIFOR = '"+CCLI+"' AND B6_LOJA = '"+CLOJA+"' AND D_E_L_E_T_ <> '*' ORDER BY B6_EMISSAO, R_E_C_N_O_ DESC "    

IF SELECT("TRBA") <> 0
DBSELECTAREA("TRBA")
TRBA->(DBCLOSEAREA())
ENDIF

TCQUERY _CQUERY NEW ALIAS TRBA

DBSELECTAREA("TRBA")
TRBA->(DBGOTOP())

IF TRBA->B6_EMISSAO <> ""
_DRET := CTOD(SUBSTR(TRBA->B6_EMISSAO,7,2)+"/"+SUBSTR(TRBA->B6_EMISSAO,5,2)+"/"+SUBSTR(TRBA->B6_EMISSAO,1,4))
ENDIF


RETURN(_DRET)