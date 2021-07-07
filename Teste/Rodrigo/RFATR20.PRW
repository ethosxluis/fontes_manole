#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE  CRLF  Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RFATR20  º Autor ³ Rodrigo            º Data ³   28/08/2015   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao - Produtos sem aquisição                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATR20()

//³ Define Variaveis                                             ³
Local cDesc1  := "Este relatório ira imprimir o resumo  "
Local cDesc2  := "das consignacoes - Produtos sem aquisição."
Local cDesc3  := "."

Private cString  := "SD2"
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RFAT20"
Private NomeProg := "RFAT20"
Private nLastKey := 0
Private Limite   := 220//P=80    M=132   G=220
Private Tamanho  := "G"
Private Titulo   := "Relação de Consignacao por Cliente"
Private cPerg    := "RFAT20"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "Registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private lImp     := .F.

Private nRecSD2 := 0
Private aCols   := {}
Private N       := 1
Private cAliasNew := GetNextAlias()
Private cNomeCli  := ""
Private cNomeVend := ""
Private cNmAutor  := ""
Private WD_AREA   := ""
Private nQtdPen   := 0

AjustaSX1()
Pergunte(cPerg,.F.)

//           0        10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1   := " Cliente - Loja " + MV_PAR01 + " - " + MV_PAR02 + " - " + POSICIONE("SA1", 1, XFILIAL("SA1") + MV_PAR01, "A1_NOME")
Cabec2   := " Data do Lançamento     I.S.B.N.            Titulo                                           Autor                Vendas    Consignados  "
///////////// 123456779D12345678  123456 123456789D123456789V123456789T1234 123456789D123456789V12345 123456  999,999  999,999  999,999  999,999  999,999  12345678 99,999.99  999.99 123456789 99 99/99/99 999,999  99,999.99   99,999.99

////////////////////////////////////////
//mv_par01 -  1=Analitico; 2=Sintetico//
////////////////////////////////////////
//Cabec1 := "Vendedor    Pedido     Frete        Qtd Caixas            Valor "
/*

| Parametros do aReturn |
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

//| Solicita ao usuario a parametrizacao do relatorio.
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,.F.,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)


//| Se teclar ESC, sair
If nLastKey == 27
	Return
Endif

//| Estabelece os padroes para impressao, conforme escolha do usuario
SetDefault(aReturn,cString)

//| Verificar se sera reduzido ou normal
nTipo := Iif(aReturn[4] == 1, 15, 18)

//| Se teclar ESC, sair
If nLastKey == 27
	Return
Endif

//| Chama funcao que processa os dados
RptStatus({|lEnd| FATR20(@lEnd, wnrel, cString) }, "Aguarde...", "Processando Registros...", .T. )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ FATR20   º Autor ³ Rodrigo           º Data ³  28/08/2015  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  FATR20(lEnd,WnRel,cString)

//³ Define Variaveis                                             ³

Local cQuery    := "" 
Local cQuery2   := "" 
Local ENTERL    := CHR(13)+CHR(10)
Local nTotPen   := 0
Local nTotLiq   := 0
Local nTpArea := 0

//| Cria filtro temporario
// mv_par11 = 1 - Loja; 2 = Evento ; 3 = Ambos.
cAliasNew := GetNextAlias()

///// CRIAR O ARQUIVO EXCEL - INICIO    //
///// CRIAR O ARQUIVO EXCEL - CLIENTE   //
/*
WDIR_ARQ  := ALLTRIM(MV_PAR13) + IIF(RIGHT(ALLTRIM(MV_PAR13),1) <> "/", "/", "") + ALLTRIM(MV_PAR14)
WNOME_ARQ := WDIR_ARQ + ".CSV"
//WNOME_CLI := WDIR_ARQ + "_CLIENTE.CSV" //
nHdl      := FCreate( WNOME_ARQ )
//nHdl_CLI  := FCreate( WNOME_CLI )  //
IF EMPTY(WDIR_ARQ)
	MSGALERT(ALLTRIM(CUSERNAME) + ", PARAMETROS PARA GERACAO DO ARQUIVO EXCEL EM BRANCO !!!")
ELSE
	W_CLIENTE := ": " + MV_PAR01 + " - " + ALLTRIM(POSICIONE("SA1", 1, XFILIAL("SA1") + MV_PAR01, "A1_NOME"))
	
	If nHdl >= 0
		FWrite( nHdl, 'Relatorio de consignacao' + W_CLIENTE + CRLF )
		FWrite( nHdl, "COD CLIENTE; LOJA; NOME CLIENTE; COD VENDEDOR; NOME VENDEDOR; ESGOTADO; ISBN (PRODUTO); TITULO; AUTOR; EVENTO; CONSIGN; DEV SIMB; DEV FISICA; FATURADO; PENDENTE; AREA" + CRLF ) // ; DESCONTO; PRECO ATUAL; NF ORIGEM; LOCAL; NF EMISSAO; SALDO; NF PRECO; PREC LIQ X SALDO;SALDOESTOQUE;NIVEL ESGOT" + CRLF )
	ELSE
		MSGALERT(ALLTRIM(CUSERNAME) + ", NÃO FOI POSSIVEL CRIAR AS INFORMACOES PARA O EXCEL: " + WNOME_ARQ )
	ENDIF
ENDIF
*/
///// CRIAR O ARQUIVO EXCEL - FINAL   //
cQuery := " SELECT B1_FILIAL, B1_COD, B1_XDTLANC, B1_XNMAUT, B1_DESC "+ ENTERL
cQuery += " FROM SB1010 B1 " +ENTERL
cQuery += " WHERE B1_XDTLANC BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND " + ENTERL
cQuery += " B1.D_E_L_E_T_ <> '*' " + ENTERL  // INCLUIR TABELA SB1
cQuery += " ORDER BY B1_COD" + ENTERL

MEMOWRITE ("RFATR201.TXT",cQuery)          

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias01,.T.,.T.)

(cAlias01)->(dbGoTop())       
                     
_cCod01 := (cAlias01)->B1_COD

cQuery2 := " SELECT SUM(D2_QUANT) QTDVEN FROM SD2010 D2 "+ ENTERL
cQuery2 += " WHERE D2_FILIAL  = '"+ xFilial("SD2")+"' AND "+ENTERL
cQuery2 += " D2_CLIENTE = '" + mv_par01 + "' AND " + ENTERL
cQuery2 += " D2_LOJA = '" + mv_par02 + "' AND " + ENTERL
cQuery2 += " D2_EMISSAO BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND " + ENTERL 
cQuery2 += " D2_COD = '" + _cCod01 + "' AND " + ENTERL  
cQuery2 += " D2_TES = '510' AND " + ENTERL
cQuery2 += " D2.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery2 += " ORDER BY D2_COD" + ENTERL

MEMOWRITE ("RFATR202.TXT",cQuery2)          

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias02,.T.,.T.)

(cAlias02)->(dbGoTop())       

cQuery3 := " SELECT SUM(D2_QUANT) QTDCON FROM SD2010 D2 "+ ENTERL
cQuery3 += " WHERE D2_FILIAL  = '"+ xFilial("SD2")+"' AND "+ENTERL
cQuery3 += " D2_CLIENTE = '" + mv_par01 + "' AND " + ENTERL
cQuery3 += " D2_LOJA = '" + mv_par02 + "' AND " + ENTERL
cQuery3 += " D2_EMISSAO BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND " + ENTERL 
cQuery3 += " D2_COD = '" + _cCod01 + "' AND " + ENTERL  
cQuery3 += " D2_TES = '510' AND " + ENTERL
cQuery3 += " D2.D_E_L_E_T_ <> '*' AND " + ENTERL
cQuery3 += " ORDER BY D2_COD" + ENTERL

MEMOWRITE ("RFATR202.TXT",cQuery2)          

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias02,.T.,.T.)

(cAlias02)->(dbGoTop())




If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

WT_PENDENTE  := 0
WT_ANALITICO := 0
WT_VALOR     := 0
_cCod    := ""                 
_cCodant := ""
_cCodant := (cAlias01)->B1_COD
_nQtdVen := 0
_nQtdCon := 0

///////////////cNomeCli := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA,"A1_NREDUZ")
////@ Li, 000 PSay (cAliasNew)->D2_CLIENTE + " "+ (cAliasNew)->D2_LOJA +" - "+ cNomeCli
/////Li++
/////@ Li,000 Psay __PrtThinLine()
//////Li++  

DO While (cAlias01)->(!Eof())
	
	_cCod := (cAlias01)->B1_COD
	
	If _cCod == _cCodant   
		If (cAlias01)->D2_TES == "510"
			_nQtdCon := _nQtdCon + (cAlias01)->D2_QUANT
		ElseIf (cAlias01)->D2_TES == "501" .or. (cAliasNew)->D2_TES == "530" .or. (cAlias01)->D2_TES == "531" .or. (cAlias01)->D2_TES == "540" .or. (cAlias01)->D2_TES == "630" .or. (cAlias01)->D2_TES == "631" .or. (cAlias01)->D2_TES == "760"
			_nQtdVen := _nQtdVen + (cAlias01)->D2_QUANT
        Endif
	else   
		@ Li, 004 PSay Stod((cAlias01)->B1_XDTLANC)  //(cAliasNew)->B1_XDTLANC  //LEFT( Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_XDTLANC"), 25) // LIMITADO A 25
   		@ Li, 024 PSay (cAlias01)->D2_COD            //STRZERO(DAY(W_EMISSAO),2) + "/" + STRZERO(MONTH(W_EMISSAO),2) + "/" + RIGHT(STRZERO(YEAR(W_EMISSAO),4),2)
   		@ Li, 045 PSay (cAlias01)->B1_DESC           // left( AllTrim(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_DESC")), 34)
// 		if cNmAutor == " "
//			cNmAutor := "."
// 		Endif
   		@ Li, 094 PSay (cAlias01)->B1_XNMAUT   // cNmAutor := LEFT( Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->D2_COD,"B1_XNMAUT"), 25) // LIMITADO A 25
   		@ Li, 114 PSay _nQtdVen Picture "@E 999,999"//Vendas 
   		@ Li, 129 PSay _nQtdCon Picture "@E 999,999"//CONSIGNADO 
		_nQtdVen := 0
		_nQtdCon := 0
		_cCodant := _cCod    
		Li++
	Endif
	
	lImp   := .T.
	
	(cAlias01)->(dbSkip())
	
	If Li > 51 //.And. !TRB->(Eof())
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//		Li++
		//		@ Li,000 Psay __PrtThinLine()
		//		Li++
		//		Cabec1()
	Endif
	
EndDo 
@ Li, 000 PSay (cAlias01)->B1_XDTLANC
@ Li, 014 PSay (cAlias01)->D2_COD
@ Li, 029 PSay (cAlias01)->B1_DESC
@ Li, 080 PSay (cAlias01)->B1_XNMAUT
@ Li, 114 PSay _nQtdVen
@ Li, 129 PSay _nQtdCon
_nQtdVen := 0
_nQtdCon := 0
_cCodant := _cCod

//U_GRV_NHDL(SPACE(1), SPACE(1), "TOTAL GERAL", STR(WT_ANALITICO), "0", STR(WT_VALOR), "TOT", .T., WT_PENDENTE ) //


//FClose( nHdl ) //

//FClose( nHdl_CLI ) //

If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

(cAlias01)->(DbCloseArea())

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
* rotina para geração de arquivo em formato excel (xls)               *
* desenvolvida por Adalberto em 25/10/11                              *

cArqExcel := __RELDIR+NomeProg="_"+Substr(cUsuario,7,4)+".XLS"
Copy To &cArqExcel

#IFNDEF TOP
	dbSelectArea(CAliasImp)
	RetIndex(cAliasImp)
	Set Filter TO
#ELSE
	dbSelectArea(CAliasImp)
	dbCloseArea()
#ENDIF

dbSetOrder(1)
dbGoTop()

If aReturn[5] ==1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

// Abrindo a planilha em Excel
If mv_par8 ==1
	__CopyFile(cArqExcel, "c:\"+NomeProg+"_"=Substr(cUsuario,7,4)+".XLS")
	If ! ApOleClient("MsExcel")
		MsgAlert("MsExcel não instalado !")
		Return
	Endif
	oExcelApp := MsExcel() :New()
	oExcelApp:WorkBooks:Open( "c:\"+NomeProg+"_"+Substr(cUsuario,7,4)+".XLS" )
	oExcelApp:SetVisible(.T.)
Endif
*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    ºData  ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para incluir os grupos de perguntas OMSC01           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
PutSx1(cPerg, '01', 'Cliente       ?', 'Cliente      ?', 'Cliente     ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par01', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '02', 'Loja          ?', 'Loja         ?', 'Loja        ?', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par02', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '03', 'Emissao de       ?', 'Emissao de      ?', 'Emissao de     ?', 'mv_ch3', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'Emissao ate      ?', 'Emissao ate     ?', 'Emissao ate    ?', 'mv_ch4', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
///
///PutSx1(cPerg, '09','Tipo Frete        ?', 'Tipo Frete      ?','Tipo Frete      ?', 'mv_ch9', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par05',	 'Cif',	'Cif','Cif', '', 'Fob',	'Fob','Fob','Ambos','Ambos','Ambos','','','','','','','')
////*/

Return
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USER FUNCTION GRV_NHDL(x_nota, x_local, x_emissao, x_saldo, x_preco, x_total, X_DIFERE, XPRIM_ITEM, X_QtdPen ) //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// FWrite( nHdl, "COD CLIENTE; LOJA; NOME CLIENTE; COD VENDEDOR; NOME VENDEDOR; ISBN; TITULO; AUTOR; EVENTO; CONSIGN; DEV SIMB; DEV FISICA; FATURADO; PENDENTE; AREA; DESCONTO; PRECO TABELA; NF ORIGEM; NFLOCAL; NF EMISSAO; SALDO; NF PRECO" + CRLF )

WSALDO_SB2 := POSICIONE("SB2", 1, XFILIAL("SB2") + (cAliasNew)->Z2_PRODUTO + "01", "B2_QATU")  //
WESGOT_SB1 := POSICIONE("SB1", 1, XFILIAL("SB1") + (cAliasNew)->Z2_PRODUTO , "B1_XESGOT") //

WESGOTADO  := IIF(WSALDO_SB2 <= WESGOT_SB1, "(E)", "")  //
WSALDO_SB2 := IIF(EMPTY(WESGOTADO), "", STR(WSALDO_SB2) ) //
WESGOT_SB1 := IIF(EMPTY(WESGOTADO), "", STR(WESGOT_SB1) ) //

FWrite( nHdl, ALLTRIM((cAliasNew)->Z2_CLIENTE) + ";" + ALLTRIM((cAliasNew)->Z2_LOJA)  + ";" + cNomeCli + ";" + ;
ALLTRIM((cAliasNew)->A1_VEND) + ";" + cNomeVend + ";" + ;
WESGOTADO  + ";" + ; //
ALLTRIM((cAliasNew)->Z2_PRODUTO) + ";" + ;
ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")) + ";" + ;
cNmAutor + ";" + ;
(cAliasNew)->Z2_EVENTO + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_QTDCON) , "") , "") + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_DEVSIMB), "") , "") + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_DEVFIS ), "") , "") + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR((cAliasNew)->Z2_FATCON ), "") , "") + ";" + ;
IIF(XPRIM_ITEM, STR(X_QTDPEN), "" ) + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, WD_AREA, "") , IIF(X_DIFERE == "DIF", "(*) DIF. sALDO", "")) + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR(WDESCONTO), "") , "") + ";" + ;
IIF(EMPTY(X_DIFERE), IIF(XPRIM_ITEM, STR(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_PRV1")), ""), "") + ";" + ;
//	x_nota + ";" + ;
//	x_local + ";" + ;
//	x_emissao + ";" + ;
//	x_saldo + ";" + ;
//  x_preco + ";" + ;
//	STRTRAN(x_total, ".", ",") + ";" + ;
//	WSALDO_SB2  + ";" + ;  //
//	WESGOT_SB1  + ";" + ;  //
CRLF ) //

//FWrite( nHdl_CLI, "ISBN (PRODUTO); TITULO; AUTOR; AREA; DESCONTO; NF ORIGEM; NF EMISSAO; SALDO; PRECO ORIGEM" + CRLF ) //

FWrite( nHdl_CLI,;
WESGOTADO  + ";" + ; //
ALLTRIM((cAliasNew)->Z2_PRODUTO) + ";" + ;
ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")) + ";" + ;
cNmAutor + ";" + ;
(cAliasNew)->Z2_EVENTO + ";" + ;
IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", WD_AREA) , IIF(X_DIFERE == "DIF", "(*) DIF. SALDO", "")) + ";" + ;
IIF(EMPTY(X_DIFERE), IIF("TOTAL" $ X_EMISSAO, "", STR(WDESCONTO) ) , "") + ";" + ;
//	x_nota + ";" + ;
//	x_emissao + ";" + ;
//	x_saldo + ";" + ;
//  STRTRAN(x_preco,".", ",") + ";" + ;
CRLF ) //

RETURN()                 
*/