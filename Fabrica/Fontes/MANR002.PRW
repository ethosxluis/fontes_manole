#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANR002   บAutor  ณPaulo Figueira      บ Data ณ  01/31/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRELATORIO DE OCORRENCIAS DE MERCADORIAS                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑ                                                                           ฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MANR002()

Local aord			:= {}
Local cString	 	:= "PA2"
Local Titulo	  	:= "Relat๓rio de ocorrencias de mercadorias"
Local Tamanho	 	:= "M" //p m g P-> SO RETRATO M-> RETRATO E PAISAGEM E G-> SO PAISAGEM
Local wnrel		   	:= "MANR002"
Local cDesc1	  	:= "Este programa ira imprimir o "
Local cDesc2	  	:= "relat๓rio de ocorrencias"
Local cDesc3  		:= "de mercadorias"
Local cabec1		:= ""
Local cabec2		:= ""

Private aReturn  	:= { "Zebrado",1,"Administracao",1,2,1,"",1 }
Private cPerg    	:= PADR("MANR002",10)
Private nLastKey	:= 0
Private m_Pag		:= 0

CriaSX1(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.F.,,/*cDrive,,,cPorta*/)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe teclar ESC, sairณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|lEnd| Imprel(cabec1,cabec2,@lEnd,wnRel,Titulo,Tamanho)},Titulo) // alterar nome

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Set Device To Screen //ABRE A TELA DE VISIALIZAวรO
//Set Filter To
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return  Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPRIME   บAutor  ณPaulo Figueira      บ Data ณ  01/31/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVALIDACAO DOS DADOS IMPRESSOS NO RELATORIO                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANOLE                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Imprel(cabec1,cabec2,lEnd,wnRel,titulo,tamanho)

Local cQuery	:= ""
Local _cRO      := ""
Local _cDesOco  := ""
Local cQryPA2   := getNextAlias()

Private nLin	:= 0

cQuery := " SELECT PA2.* "
cQuery += " FROM "+retsqlname("PA2")+" PA2, "+RETSQLNAME("SF1")+" SF1 "
cQuery += " WHERE PA2.PA2_FILIAL = '"+XFILIAL("PA2")+"' AND SF1.F1_DOC = PA2.PA2_DOCENT "
cQuery += " AND SF1.F1_SERIE = PA2.PA2_SERIE "
cQuery += " AND SF1.F1_FORNECE = PA2.PA2_CLIFOR "
cQuery += " AND SF1.F1_LOJA = PA2.PA2_LOJA "
cQuery += " AND PA2.PA2_DOCENT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += " AND PA2.PA2_SERIE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND PA2.PA2_CLIFOR BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"' "
cQuery += " AND PA2.PA2_LOJA BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"' "
cQuery += " AND SF1.F1_EMISSAO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
cQuery += " AND PA2.D_E_L_E_T_ <> '*' "
cQuery += " AND SF1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY PA2_FILIAL, PA2_DOCENT, PA2_SERIE, PA2_CLIFOR, PA2_LOJA, PA2_RO "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQryPA2,.T.,.F.)

While ! (cQryPA2)->(Eof())
	
	If nLin >= 51 .or. _cRO <> (cQryPA2)->PA2_RO .OR. nLin = 0
	    if nlin <> 0 // sonia - 04/05/12 - para nao imprimir uma pagina somente com rodape
			ImpRodPe()
	    endif        // sonia - 04/05/12 - para nao imprimir uma pagina somente com rodape
		nLin :=	Cabec(titulo,Cabec1,Cabec2,wnRel,tamanho)
		
		nLin := 7//PRow()
//		@nLin,	00 Psay 'NUM. R.O:'
//		@nLin,	15 Psay (cQryPA2)->PA2_RO
		@nLin,	40 Psay 'CODIGO :'
		@nLin,	55 Psay (cQryPA2)->PA2_CLIFOR
		nLin++
		@nLin,	00 Psay 'NF:'
		@nLin,	05 Psay (cQryPA2)->PA2_DOCENT
//		DbSelectArea("SA2") // SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
		DbSelectArea("SA1") // SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
		DbSetOrder(1)
//		If DbSeek(xFilial("SA2")+(cQryPA2)->PA2_CLIFOR+(cQryPA2)->PA2_LOJA)// SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
		If DbSeek(xFilial("SA1")+(cQryPA2)->PA2_CLIFOR+(cQryPA2)->PA2_LOJA)// SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
//			@nLin,	55 Psay "CLIENTE: " + SA2->A2_NOME  // SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
			@nLin,	55 Psay "CLIENTE: " + SA1->A1_NOME  // SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
		Else
//			@nLin,	55 Psay "CLIENTE: " + "Nใo cadastrado como fornecedor" // SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
			@nLin,	55 Psay "CLIENTE: " + "Nใo cadastrado                " // SONIA - 04/05/12 - Foi solicitado pelo Adalberto / Daniel que esse relat๓rio ira emitir somente cliente
		EndIf
		nLin++
		
		_cRO := (cQryPA2)->PA2_RO
				_cDesOco := Posicione("SX5",1,XFILIAL("SX5")+ "_B" + (cQryPA2)->PA2_TIPO ,"X5_DESCRI")
		
		/*
		@nLin,	00 Psay 'NATUREZA:'
		@nLin,	40 Psay 'EMISSAO:'
		nLin++
		*/
		@nLin,	00 Psay  '[------------ISBN------------]'
		@nLin,	35 Psay  'QTD  [T.DEF.]'
		@nLin,	90 Psay  '[--------DESCR. DEFEITO--------]'
		nLin++
		@nLin,	00 Psay REPLICATE("-",132)
		nLin++
		@nLin,	00 Psay (cQryPA2)->PA2_ISBN
		@nLin,	35 Psay (cQryPA2)->PA2_QTD
		@nLin,	41 Psay _cDesOco
		@nLin,	90 Psay (cQryPA2)->PA2_OBS
/*
	Else
		If _cRO = (cQryPA2)->PA2_RO
			_cDesOco := Posicione("SX5",1,XFILIAL("SX5")+ "_B" + (cQryPA2)->PA2_TIPO ,"X5_DESCRI")
			nLin++
			@nLin,	00 Psay (cQryPA2)->PA2_ISBN
			@nLin,	35 Psay (cQryPA2)->PA2_QTD
			@nLin,	41 Psay _cDesOco
			@nLin,	90 Psay (cQryPA2)->PA2_OBS
		EndIf 
		*/
	Endif
	
	(cQryPA2)->(DbSkip())
	
EndDo

/*
If nLin >= 51
nLin :=	Cabec(titulo,Cabec1,Cabec2,wnRel,tamanho)
ImpCabec()
nLin ++
Endif
*/
ImpRodPe()


(cQryPA2)->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณImpCabec    บ Autor ณ Paulo Figueira		     บ Data ณ 14/07/08 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Imprime Cabecalho                                               บฑฑ
ฑฑบ          ณ                                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMANOLE      							     	                   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImpCabec()

Local nLin		:= 0

//          10        20        30        40        50        60        70        80        90        100       110       120       130
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//PONTA DA...
//NUM. R.O                                CLIENTE
//NATUREZA                                EMISSAO Nao cadastrado como Fornecedor
//[-------------ISBN-------------]   QTD [T.DEF.]                                            [-------DESCR. DEFEITO-------]
//-------------------------------------------------------------------------------------------------------------------------------------


SetPrc(0,0)
nLin := 7//PRow()
@nLin,	00 Psay 'NUM. R.O:'
@nLin,	40 Psay 'CLIENTE:'
nLin++
/*
@nLin,	00 Psay 'NATUREZA:'
@nLin,	40 Psay 'EMISSAO:'
nLin++
*/
@nLin,	00 Psay  '[------------ISBN------------]'
@nLin,	35 Psay  'QTD  [T.DEF.]'
@nLin,	90 Psay  '[--------DESCR. DEFEITO--------]'
nLin++
@nLin,	00 Psay REPLICATE("-",134)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณImprodPe    บ Autor ณ Paulo Figueira				 บ Data ณ 14/07/08 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Imprime Rodape                                                  บฑฑ
ฑฑบ          ณ                                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMANOLE      							     	                            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImpRodPe()

SetPrc(0,0)
nLin := 53//PRow()
//          10        20        30        40        50        60        70        80        90        100       110       120       130
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//RESPONSAVEL R. O.      :

@nLin,	00 Psay 'RESPONSAVEL R. O.      :'
@nLin,	25 Psay Subs(cUsuario,7,15)
@nLin,	65 Psay '..../..../....'
nLin++
nLin++

@nLin,	00 Psay 'CONFERENTE EXPEDICAO   : .....................................'
@nLin,	65 Psay '..../..../....'
nLin++
nLin++

@nLin,	00 Psay 'RESPONS. CONSIGNACAO   : .....................................'
@nLin,	65 Psay '..../..../....'
nLin++
nLin++

@nLin,	00 Psay 'RESPONS. ADMINISTRADOR : .....................................'
@nLin,	65 Psay '..../..../....'

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCriaSx1   ณAutor  ณPaulo Figueira         ณData  ณ 02/02/11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Montagem do grupo de Perguntas  			                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaSx1( cPerg )

Local aPergs 		:= {}

Aadd(aPergs,{"NF de?"	  	  		,"","","mv_ch1","C",09,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"NF ate?"  	 		,"","","mv_ch2","C",09,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Serie de?"	  	  		,"","","mv_ch3","C",03,00,00,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Serie ate?"  	 		,"","","mv_ch4","C",03,00,00,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Cliente de?"	  	  		,"","","mv_ch5","C",06,00,00,"G","","mv_par05","","","","","","","","","","","","","","","SA1","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Loja de?"	  	  		,"","","mv_ch6","C",02,00,00,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Cliente ate?"  	 		,"","","mv_ch7","C",06,00,00,"G","","mv_par07","","","","","","","","","","","","","","","SA1","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Loja ate?"  	 		,"","","mv_ch8","C",02,00,00,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}}) 
Aadd(aPergs,{"Emissao de?"  	 		,"","","mv_ch9","D",08,00,00,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})
Aadd(aPergs,{"Emissao ate?"  	 		,"","","mv_cha","D",08,00,00,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",{},{},{}})


AjustaSX1(cPerg,aPergs)

Return
