#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ RFATR04  ³ Autor ³ TOTVS                    ³ Data ³10/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Consignacao por produto                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                    ³±±
// 02/07/15 - Parametro para excluir clientes dposito externo (ADK-000001)   //
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß      
*/
User Function RFATR04()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := "Este relatório ira imprimir o resumo  "
Local cDesc2  := "das consignacoes por produto."
Local cDesc3  := "."

Private cString  := "SZ2"
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RFAT04"
Private NomeProg := "RFAT04"
Private nLastKey := 0
Private Limite   := 220//P=80    M=132   G=220
Private Tamanho  := "G"
Private Titulo   := "Relação de Consignacao por Produto"
Private cPerg    := "RFAT04"
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
Cabec1   := " I.S.B.N. - Titulo"
Cabec2   := " Cod/Loja Nome Cliente             Municipio       Evento         Consig         Dev.Simb       Dev.Fis        Faturado       Pendente  "                  


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
±±³Fun‡…o    ³ FATR01   ³ Autor ³TOTVS                  ³ Data ³13/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  FATR01(lEnd,WnRel,cString)

//³ Define Variaveis                                             ³
Local cQuery    := ""
Local cChave    := ""
Local ENTERL    := CHR(13)+CHR(10)
Local cAliasNew := GetNextAlias()
Local cTituloL  := ""
Local nQtdPen   := 0 
Local nTotPen   := 0
Local nTotLiq   := 0 

WDIR_ARQ  := ALLTRIM(MV_PAR11) + IIF(RIGHT(ALLTRIM(MV_PAR11),1) <> "/", "/", "") + ALLTRIM(MV_PAR12) 
WNOME_PRO := WDIR_ARQ + ".CSV" 
nHdl_PRO  := FCreate( WNOME_PRO )  
IF EMPTY(WDIR_ARQ)
	MSGALERT(ALLTRIM(CUSERNAME) + ", PARAMETROS PARA GERACAO DO ARQUIVO EXCEL EM BRANCO !!!")
ELSE

	   W_CLIENTE := ": " + MV_PAR05 + " - " + ALLTRIM(POSICIONE("SB1", 1, XFILIAL("SB1") + MV_PAR05, "B1_DESC"))
	   IF MV_PAR05 <> MV_PAR06
	      W_CLIENTE += " a: " + MV_PAR06 + " - " + ALLTRIM(POSICIONE("SB1", 1, XFILIAL("SB1") + MV_PAR06, "B1_DESC"))
       ENDIF

	If nHdl_PRO >= 0
		FWrite( nHdl_PRO, 'Relatorio de consignacao - Produto ' + W_CLIENTE + CRLF )
		FWrite( nHdl_PRO, "ISBN (PRODUTO); TITULO; COD; LOJA; NOME CLIENTE; MUNICIPIO; EVENTOS; CONSIG; DEV SIMB; DEV FIS; FATURADO; PENDENTE" + CRLF )
	ELSE
		MSGALERT(ALLTRIM(CUSERNAME) + ", NÃO FOI POSSIVEL CRIAR AS INFORMACOES PARA O EXCELL: " + WNOME_CLI )
	ENDIF
ENDIF


//+-----------------------
//| Cria filtro temporario
//+-----------------------
// mv_par11 = 1 - Loja; 2 = Evento ; 3 = Ambos.
cAliasNew:= GetNextAlias()

cQuery := " SELECT SZ2.Z2_CLIENTE, SZ2.Z2_LOJA, SZ2.Z2_PRODUTO, SZ2.Z2_EVENTO, "+ ENTERL
cQuery += " SZ2.Z2_QTDCON, SZ2.Z2_DEVSIMB, SZ2.Z2_DEVFIS, SZ2.Z2_FATCON, SA1.A1_NREDUZ, SA1.A1_MUN "+ ENTERL

cQuery += " FROM " + RetSqlName("SZ2") + " SZ2, " + RetSqlName("SA1") + " SA1 " +ENTERL // SK - 02/07/15 - INCLUIDO A TABELA SA1
cQuery += " WHERE SZ2.Z2_FILIAL  = '"+ xFilial("SZ2")+"' AND "+ENTERL
cQuery += " SA1.A1_FILIAL  = '"+ xFilial("SA1")+"' AND "+ENTERL    // SK - 02/07/15 - INCLUIDO A TABELA SA1
cQuery += " SZ2.Z2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03 +"' AND " + ENTERL
cQuery += " SZ2.Z2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04+ "' AND " + ENTERL
cQuery += " SZ2.Z2_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "' AND " + ENTERL

cQuery += " SZ2.Z2_CLIENTE = SA1.A1_COD AND SZ2.Z2_LOJA = SA1.A1_LOJA AND " + ENTERL // SK - 02/07/15 - INCLUIDO A TABELA SA1

If mv_par07 == 1 // Loja
	cQuery += " SZ2.Z2_EVENTO = '      ' AND " + ENTERL
ElseIf mv_par07 == 2 // Evento
	cQuery += " SZ2.Z2_EVENTO BETWEEN '" + mv_par08 + "' AND '" + mv_par09+ "' AND " + ENTERL
	cQuery += " SZ2.Z2_EVENTO <> '      ' AND " + ENTERL
EndIf

IF MV_PAR10 == 1 // SOMENTE CLIENTES - SK - 02/07/15
   cQuery += " SA1.A1_UNIDVEN <> '000001' AND " + ENTERL
ELSEIF MV_PAR10 == 2 // SOMENTE DEPOSITO EXTERNO - SK - 02/07/15
   cQuery += " SA1.A1_UNIDVEN = '000001' AND " + ENTERL
ENDIF   

cQuery += " SZ2.D_E_L_E_T_ = ' ' AND " + ENTERL
cQuery += " SA1.D_E_L_E_T_ = ' ' " + ENTERL    

cQuery += " ORDER BY Z2_PRODUTO , Z2_CLIENTE, Z2_LOJA, Z2_EVENTO  " + ENTERL

MEMOWRITE ("RFATR04.TXT",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)


(cAliasNew)->(dbGoTop())
If Li > 52
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif

While (cAliasNew)->(!Eof())
	lImp   := .T.

	If cChave <> (cAliasNew)->Z2_PRODUTO
	
		cTituloL := AllTrim(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC"))
 //		@ Li, 000 PSay (cAliasNew)->Z2_PRODUTO +" - "+ cTituloL
//		Li++
//		@ Li,000 Psay __PrtThinLine()
//		Li++
		
		cChave  := (cAliasNew)->Z2_PRODUTO
		nTotPen := 0
	EndIf


	@ Li, 000 PSay (cAliasNew)->Z2_CLIENTE+"-"+(cAliasNew)->Z2_LOJA
//	@ Li, 010 PSay AllTrim(Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE+(cAliasNew)->Z2_LOJA,"A1_NREDUZ")) // SK 02/07/15
//	@ Li, 035 PSay AllTrim(Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE+(cAliasNew)->Z2_LOJA,"A1_MUN"))    // SK 02/0715

	@ Li, 010 PSay(cAliasNew)->A1_NREDUZ   // SK - 02/07/15
	@ Li, 035 PSay(cAliasNew)->A1_MUN      // SK - 02/07/15

	@ Li, 052 PSay (cAliasNew)->Z2_EVENTO
	@ Li, 060 PSay (cAliasNew)->Z2_QTDCON  Picture "@E 99,999,999.99"//CONSIGNADO
	@ Li, 075 PSay (cAliasNew)->Z2_DEVSIMB Picture "@E 99,999,999.99"//DEV.SIMN
	@ Li, 090 PSay (cAliasNew)->Z2_DEVFIS  Picture "@E 99,999,999.99"//DEV. FISICA
	@ Li, 105 PSay (cAliasNew)->Z2_FATCON  Picture "@E 99,999,999.99"//FATURADO
	nQtdPen := ((cAliasNew)->Z2_QTDCON - (cAliasNew)->Z2_DEVSIMB -(cAliasNew)->Z2_DEVFIS)
	@ Li, 120 PSay nQtdPen  Picture "@E 99,999,999.99"//PENDENTE
	//@ Li, 175 PSay 9999                Picture PesqPict("SD2","D2_QUANT")//Total Liquido 

// Linha inluida por Adalberto em 03/05/12 por solicitação do Márcio
 		@ Li, 140 PSay (cAliasNew)->Z2_PRODUTO +" - "+ cTituloL
//Adalberto
		
	nTotPen += nQtdPen
    
	FWrite( nHdl_PRO,;
   	ALLTRIM((cAliasNew)->Z2_PRODUTO) + ";" + ;
	ALLTRIM(Posicione("SB1",1,xFilial("SB1")+(cAliasNew)->Z2_PRODUTO,"B1_DESC")) + ";" + ;    
	(cAliasNew)->Z2_CLIENTE + ";" + ;  
	(cAliasNew)->Z2_LOJA + ";" + ;    
	(cAliasNew)->A1_NREDUZ + ";" + ; 
	(cAliasNew)->A1_MUN + ";" + ;  
	(cAliasNew)->Z2_EVENTO + ";" + ; 
	STR((cAliasNew)->Z2_QTDCON) + ";" + ;   
	STR((cAliasNew)->Z2_DEVSIMB) + ";" + ; 
	STR((cAliasNew)->Z2_DEVFIS) + ";" + ;   
	STR((cAliasNew)->Z2_FATCON) + ";" + ; 
	STR(nQtdPen) + ";" + ; 
	CRLF )

	Li++
	(cAliasNew)->(dbSkip())
	
	If cChave <> (cAliasNew)->Z2_PRODUTO
		Li++
		@ Li, 000 PSay " T O T A L  - - - - - - - - - - - - > "
		@ Li, 120 PSay	nTotPen Picture "@E 99,999,999.99"
		Li++          
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

FClose( nHdl_PRO )

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
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    ºData  ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para incluir os grupos de perguntas OMSC01           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
PutSx1(cPerg, '01', 'Cliente de      ?', 'Cliente de     ?', 'Cliente de    ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par01', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '02', 'Loja de         ?', 'Loja de        ?', 'Loja de       ?', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par03', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '03', 'Cliente ate     ?', 'Cliente ate    ?', 'Cliente ate   ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par02', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '04', 'Loja Ate        ?', 'Loja ate       ?', 'Loja ate      ?', 'mv_ch4', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par04', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '05', 'Produto de      ?', 'Produto de     ?', 'Produto de    ?', 'mv_ch5', 'C',30, 0, 0, 'G', '', 'SB1'   , '', '', 'mv_par05', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto ate     ?', 'Produto ate    ?', 'Produto ate   ?', 'mv_ch6', 'C',30, 0, 0, 'G', '', 'SB1'   , '', '', 'mv_par06', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '07','Tipo Consignacao ?','Tipo Consignacao?','Tipo Consig    ?', 'mv_ch7', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par07',	 'Loja','Loja','Loja', '', 'Evento','Evento','Evento','Ambos','Ambos','Ambos','','','','','','','')

PutSx1(cPerg, '08', 'Evento de       ?', 'Evento de      ?', 'Evento de     ?', 'mv_ch8', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par08', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')
PutSx1(cPerg, '09', 'Evento ate      ?', 'Evento ate     ?', 'Evento ate    ?', 'mv_ch9', 'C',6, 0, 0, 'G', '', 'ACD'   , '', '', 'mv_par09', 'Sim', 'Si', 'Yes', '', 'Nao', 'No', 'No','','','','','','','','','','')

PutSx1(cPerg, '10','Tipo de impressao?','Tipo de impressao?','Tipo de impressao?', 'mv_chA', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par10',	 'Clientes','Clientes','Clientes', '', 'Deposito Externo','Deposito Externo','Deposito Externo','Ambos','Ambos','Ambos','','','','','','','') // SONIA - 02/07/15

PutSx1(cPerg, '11', 'Pasta arquivo Excel?', 'Pasta arquivo Excel    ?', 'Pasta arquivo Excel   ?', 'mv_chb', 'C',50, 0, 0, 'G', '', ''   , '', '', 'mv_par11', '', '', '', '', '', '', '','','','','','','','','','','') 
PutSx1(cPerg, '12', 'Nome arquivo Excel?', 'Nome arquivo Excel    ?', 'Nome arquivo Excel   ?', 'mv_chc', 'C',20, 0, 0, 'G', '', ''   , '', '', 'mv_par12', '', '', '', '', '', '', '','','','','','','','','','','')   

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