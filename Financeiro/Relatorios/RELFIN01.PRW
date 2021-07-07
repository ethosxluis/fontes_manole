#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

//=======================================================================+
// PROGRAMA PARA GERAR RELATORIO DE TITULOS NO SE1 FINANCEIRO - CR 		 +
//=======================================================================+
// CRIADOR: WALLACE JOSE PEREIRA | DATA 14/05/2020 | 					 +
//=======================================================================+                               
// USO EXCLUSIVO MANOLE													 +
//=======================================================================+

User Function RELFIN01()

Local cPerg     := "RELFIN01"
Local aPergs	:= {}

CriaSx1(cPerg)
//MV_PAR01 EMISSAO DE 
//MV_PAR02 EMISSAO ATษ
//MV_PAR03 PAGAMENTO DE
//MV_PAR04 PAGAMENTO ATษ


If Pergunte(cPerg)
	Processa({|lEnd| GerXls(@lEnd)},"Aguarde...","Processando informa็๕es",.T.)
EndIF

Return Nil
 

STATIC FUNCTION GERXLS(lEnd)

Local nCont		:= 01
Local cQuery	:= ""
Local cHtml 	:= ""
Local cHtmlOk	:= ""
Local lLoop  	:= .T.
Local cPath  	:= AllTrim(GetTempPath())
Local cOrdm  	:= "01"
Local nArq   	:= Nil
Local nContArq	:= 0   

Private nRegua	:= 0

ProcRegua(nRegua)

PswOrder(1)
PswSeek(__CUSERID,.T.)
aUser := PswRet()
cNomeUser := aUser[1][4]

While lLoop
	If File(cPath+"FINR500"+cOrdm+".xls")
		FERASE(cPath+"FINR500"+cOrdm+".xls")
		cOrdm := AllTrim(Soma1(cOrdm))
	Else
		lLoop := .F.
	EndIf
End

cArq   := cPath+"FINR500"+cOrdm+".xls"
nArq   := fCreate(cArq,0)

//=======================+
// CABEวALHO DO RELATORIO+
//=======================+
cHtmlOk := HtmlCab() 
FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//===============================+
//TITULO DAS COLUNAS DO RELATำRIO+
//===============================+
cHtmlOk := HtmlTit()
fWrite(nArq,cHtmlOk,Len(cHtmlOK))

cQuery := CRLF +"SELECT SE1.E1_FILIAL,  "
cQuery += CRLF +" SE1.E1_FILORIG,  "
cQuery += CRLF +" SE1.E1_VALOR,   "
cQuery += CRLF +" SE1.E1_SALDO,  "
cQuery += CRLF +" SE1.E1_PREFIXO,  "
cQuery += CRLF +" SE1.E1_NUM,  "
cQuery += CRLF +" SE1.E1_PARCELA,  "
cQuery += CRLF +" SE1.E1_TIPO,  "
cQuery += CRLF +" SE1.E1_CLIENTE,  "
cQuery += CRLF +" SE1.E1_LOJA,  "
cQuery += CRLF +" SE1.E1_NOMCLI,  "
cQuery += CRLF +" SE1.E1_EMISSAO,  "
cQuery += CRLF +" SE1.E1_VENCTO,  "
cQuery += CRLF +" SE1.E1_VENCREA,  "
cQuery += CRLF +" SE1.E1_BAIXA,  "
cQuery += CRLF +" SE5.E5_HISTOR,  "
cQuery += CRLF +"CASE SE5.E5_RECONC   "
cQuery += CRLF +" WHEN 'x' THEN 'CONCILIADO'  "
cQuery += CRLF +" WHEN ' ' THEN 'NรO CONCILIADO'  "
cQuery += CRLF +"END AS E5_RECONC,  " 
cQuery += CRLF +" SE5.E5_BANCO,  "
cQuery += CRLF +" SE5.E5_AGENCIA,  "
cQuery += CRLF +" SE5.E5_CONTA,  "
cQuery += CRLF +" SE5.E5_VLJUROS, "
cQuery += CRLF +" SE5.E5_VLMULTA, "
cQuery += CRLF +" SE5.E5_VLCORRE, "
cQuery += CRLF +" SE5.E5_VLDESCO, "
cQuery += CRLF +" SE5.E5_VALOR "
cQuery += CRLF +"FROM " + RetSQLName("SE5")+" SE5 "
cQuery += CRLF +"inner JOIN SE1010 SE1 ON SE1.D_E_L_E_T_ = ' '   "
cQuery += CRLF +" AND SE1.E1_PREFIXO = SE5.E5_PREFIXO  " 
cQuery += CRLF +" AND SE1.E1_NUM = SE5.E5_NUMERO   "
cQuery += CRLF +" AND SE1.E1_PARCELA = SE5.E5_PARCELA   "
cQuery += CRLF +" AND SE1.E1_CLIENTE = SE5.E5_CLIFOR   "
cQuery += CRLF +" AND SE1.E1_LOJA = SE5.E5_LOJA  "
cQuery += CRLF +"WHERE   SE1.E1_EMISSAO	>= '"+dTos(MV_PAR01)+"'  "
cQuery += CRLF +" AND SE1.E1_EMISSAO  	<= '" + dTos(MV_PAR02) +"'"
cQuery += CRLF +" AND SE5.E5_DATA   	>= '" + dTos(MV_PAR03) +"'  "
cQuery += CRLF +" AND SE5.E5_DATA		<= '" + dTos(MV_PAR04) +"'  "
IF MV_PAR05 <> ' '
	cQuery += CRLF +" AND SE5.E5_BANCO		 = '" + MV_PAR05 + "'  "
	cQuery += CRLF +" AND SE5.E5_AGENCIA	 = '" + MV_PAR06 + "'  "
	cQuery += CRLF +" AND SE5.E5_CONTA		 = '" + MV_PAR07 + "'  "
ENDIF
cQuery += CRLF +" AND SE5.E5_RECPAG		= 'R'  "
cQuery += CRLF +" AND SE5.D_E_L_E_T_	= ' '  "
If MV_PAR08 == 3  // Somente Titulos em Aberto
	cQuery += " AND SE1.E1_SALDO <> 0"   
Elseif MV_PAR08 == 1  // Somente Titulos Baixados
	cQuery += " AND SE1.E1_SALDO = 0"  
ElseIf MV_PAR08 == 2 //Somente Baixa Parcial
	cQuery += "AND SE1.E1_SALDO <> SE1.E1_VALOR AND SE1.E1_SALDO <> 0 "
Endif
If MV_PAR09 == 1  // Somente Titulos CONCILIADOS
	cQuery += " AND SE5.E5_RECONC = 'x' "   
Elseif MV_PAR09 == 2  // Somente Titulos NรO CONCILIADOS
	cQuery += " AND SE5.E5_RECONC = ' ' "   
Endif
cQuery += CRLF +" ORDER BY SE1.E1_EMISSAO, SE1.E1_NUM,  "
cQuery += CRLF +"SE1.E1_PARCELA, SE1.E1_CLIENTE, SE1.E1_LOJA, SE5.E5_DATA  "

cQuery := ChangeQuery(cQuery)

IF SELECT("TRAA") > 0
	TRAA->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAA",.F.,.F.)

tcsetfield("TRAA","E1_EMISSAO","D",8,0)
tcsetfield("TRAA","E1_VENCTO" ,"D",8,0)
tcsetfield("TRAA","E1_VENCREA","D",8,0)		
tcsetfield("TRAA","E1_BAIXA"  ,"D",8,0)

TRAA->(DBGOTOP())

While TRAA->(!EoF()) 	

	If lEnd
    	MsgInfo("Cancelado pelo usuแrio")
    	Exit
	Endif

	nCont ++
	IF nCont%2 == 0
		cBgColor := "#FFFFFF"
	else 
		cBgColor := "#CAE4FF"
	ENDIF
	
	cHtml += CRLF+' <TABLE border="1" cellpadding="0" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF">
	cHtml += CRLF+' 	<TR bgcolor='+cBgColor+' valign="middle" align="center" style="font-family:Arial; font-size:10px"> '
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_TIPO+'&nbsp</td>'
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_PREFIXO+'</td>'	
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_NUM+'&nbsp</td>'		 
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_PARCELA+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+DTOC(TRAA->E1_EMISSAO)+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+DTOC(TRAA->E1_VENCTO)+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+DTOC(TRAA->E1_VENCREA)+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+DTOC(TRAA->E1_BAIXA)+'</td>'		
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E1_VALOR ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E5_VALOR ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E5_VLJUROS ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E5_VLMULTA ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_CLIENTE+'&nbsp</td>'
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_LOJA+'&nbsp</td>'
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_NOMCLI+'&nbsp</td>'		
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E5_HISTOR+'&nbsp</td>'	
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E5_RECONC+'&nbsp</td>'	
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E5_BANCO+'&nbsp</td>'	
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E5_AGENCIA+'&nbsp</td>'	
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E5_CONTA+'&nbsp</td>'	
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E5_VLCORRE ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E5_VLDESCO ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_FILIAL+'&nbsp</td>'
	cHtml += CRLF +'		<TD align="LEFT">'+TRAA->E1_FILORIG+'&nbsp</td>'
	cHtml += CRLF +'		<TD align="RIGHT">'+TRANSFORM(TRAA->E1_SALDO ,"@E 999,999,999.99")+'</td>'
	cHtml += CRLF +' 	</tr> ' 
	cHtml += CRLF +' </TABLE>
   
	nContArq++
	
	IF nContArq >= 500
		cHtmlOk 	:= cHtml
		FWrite(nArq,cHtmlOk,Len(cHtmlOk))
		cHtml  	 	:= ' '
		cHtmlOk 	:= ' '
		nContArq 	:= 0
	ENDIF
 
	INCPROC()

	TRAA->(DBSKIP())
	
End

TRAA->(DBCLOSEAREA())
	
cHtmlOk := cHtml
FWrite(nArq,cHtmlOk,Len(cHtmlOk))
cHtml   	:= ' '
cHtmlOk 	:= ' '
nContArq 	:= 0

//==============================+
// EXECUTA O RODAPษ DO RELATำRIO+
//==============================+
cHtmlOk := HtmlRodap()  
FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Fecha Arquivo
fClose(nArq)
fClose(cArq)
IF !lEnd	
	If ApOleClient("MsExcel") 
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArq)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		ShellExecute("open",cArq,"","",1)
	EndIf
ELSE
	FERASE(cPath+"FINR500"+cOrdm+".xls")
ENDIF

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSx1  บAutor  ณWallace Jos้ Pereira บ Data ณ  14/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaSx1(cPerg)

//	Local aRegs     := {}

	//Aadd(aRegs, {cPerg,"01","Emissao De:  ","Emissao De:  ","Emissao De:  ","mv_ch1","D",08,00,00,"G","NAOVAZIO()","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo inicial da emissao no Formato DD/MM/AAAA","","" })
	//Aadd(aRegs, {cPerg,"02","Emissao At้: ","Emissao At้: ","Emissao At้: ","mv_ch2","D",08,00,00,"G","NAOVAZIO()","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo final da emissao no Formato DD/MM/AAAA"  ,"","" })
	//Aadd(aRegs, {cPerg,"03","Baixa De:    ","Baixa De:    ","Baixa De:    ","mv_ch3","D",08,00,00,"G","NAOVAZIO()","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo inicial da Baixa no Formato DD/MM/AAAA"  ,"","" })
	//Aadd(aRegs, {cPerg,"04","Baixa At้:   ","Baixa At้:   ","Baixa At้:   ","mv_ch4","D",08,00,00,"G","NAOVAZIO()","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo final da Baixa no Formato DD/MM/AAAA"    ,"","" })
	//Aadd(aRegs, {cPerg,"05","Do Banco:    ","Baixa At้:   ","Baixa At้:   ","mv_ch5","G",03,00,00,"G","NAOVAZIO()","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""  															 ,"","" })
	//Aadd(aRegs, {cPerg,"07","Da Agencia:  ","Baixa At้:   ","Baixa At้:   ","mv_ch7","G",05,00,00,"G","NAOVAZIO()","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""  															 ,"","" })
	//Aadd(aRegs, {cPerg,"09","Da Conta:    ","Baixa At้:   ","Baixa At้:   ","mv_ch9","G",11,00,00,"G","NAOVAZIO()","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""  															 ,"","" })
	//Aadd(aRegs, {cPerg,"11","Titulos:     ","Baixa At้:   ","Baixa At้:   ","mv_chb","C",01,00,00,"C","NAOVAZIO()","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","",""    														 ,"","" })
	//Aadd(aRegs, {cPerg,"12","Concilia็ใo: ","Baixa At้:   ","Baixa At้:   ","mv_chc","C",01,00,00,"C","NAOVAZIO()","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","",""    														 ,"","" })

	PutSx1(cPerg,"01","Emissao De:  ","Emissao De:  ","Emissao De:  ","mv_ch1","D",08,00,00,"G","NAOVAZIO()","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo inicial da emissao no Formato DD/MM/AAAA","","" )
	PutSx1(cPerg,"02","Emissao At้: ","Emissao At้: ","Emissao At้: ","mv_ch2","D",08,00,00,"G","NAOVAZIO()","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo final da emissao no Formato DD/MM/AAAA"  ,"","" )
	PutSx1(cPerg,"03","Baixa De:    ","Baixa De:    ","Baixa De:    ","mv_ch3","D",08,00,00,"G","NAOVAZIO()","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo inicial da Baixa no Formato DD/MM/AAAA"  ,"","" )
	PutSx1(cPerg,"04","Baixa At้:   ","Baixa At้:   ","Baixa At้:   ","mv_ch4","D",08,00,00,"G","NAOVAZIO()","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","Selecione o perํodo final da Baixa no Formato DD/MM/AAAA"    ,"","" )
	PutSx1(cPerg,"05","Do Banco:    ","Baixa At้:   ","Baixa At้:   ","mv_ch5","G",03,00,00,"G","NAOVAZIO()","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""  															 ,"","" )
	PutSx1(cPerg,"07","Da Agencia:  ","Baixa At้:   ","Baixa At้:   ","mv_ch7","G",05,00,00,"G","NAOVAZIO()","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""  															 ,"","" )
	PutSx1(cPerg,"09","Da Conta:    ","Baixa At้:   ","Baixa At้:   ","mv_ch9","G",11,00,00,"G","NAOVAZIO()","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""  															 ,"","" )
	PutSx1(cPerg,"11","Titulos:     ","Baixa At้:   ","Baixa At้:   ","mv_chb","C",01,00,00,"C","NAOVAZIO()","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","",""    														 ,"","" )
	PutSx1(cPerg,"12","Concilia็ใo: ","Baixa At้:   ","Baixa At้:   ","mv_chc","C",01,00,00,"C","NAOVAZIO()","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","",""    														 ,"","" )
	
	
Return() 



//=========================================+
//FUNCAO PARA GERAR CABEวALHO DO HTML      +
//=========================================+
STATIC FUNCTION HtmlCab()

	cHtml := CRLF +''
	cHtml += CRLF +'<HTML>'
	cHtml += CRLF +'<HEAD><TITLE>RELATORIO:BASE DE FATURAMENTO</TITLE></HEAD>'
	cHtml += CRLF +'<BODY bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" link="#000000" vlink="#000000" alink="#000000">'
	cHtml += CRLF +'<TABLE bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0">'
	cHtml += CRLF +'	<TD align="Left" ><IMG SRC="C:\relatorios\logo.jpg" HEIGHT="100"></TD>'
	cHtml += CRLF +'		<TR valign="top" width="10%" style=" font-family:Calibri; font-size:16px">'
	cHtml += CRLF +'			<TD height="35" colspan="14"  align="center" valign="middle"><B>MANOLE</B></TD>'
	cHtml += CRLF +'		</TR>'
	cHtml += CRLF +'		<TR valign="top" width="10%" style=" font-family:Calibri; font-size:14px">'
	cHtml += CRLF +'			<TD height="35" colspan="14" width="10%" align="center" valign="middle"><b>Relat๓rio de altera็ใo - tabela SE1 </b></TD>'
	cHtml += CRLF +'		</TR>'
	cHtml += CRLF +'		<TR valign="top" width="10%" style=" font-family:Calibri; font-size:12px">'
	cHtml += CRLF +'			<TD height="35" colspan="14" width="10%"  align="center" valign="middle">Emissใo: '+DTOC(MV_PAR01)+' at้: '+DTOC(MV_PAR02)+'</TD>'
	cHtml += CRLF +'		</TR>'
	cHtml += CRLF +'		<TR>'
	cHtml += CRLF +'		<TR valign="top" width="10%" style=" font-family:Calibri; font-size:12px">'
	cHtml += CRLF +'			<TD height="35" colspan="14" width="10%"  align="center" valign="middle">Baixa: '+DTOC(MV_PAR03)+' at้: '+DTOC(MV_PAR04)+'</TD>'
	cHtml += CRLF +'		</TR>'
	cHtml += CRLF +'	</TD>'
	cHtml += CRLF +'</TABLE>'
	cHtml += CRLF +'<br>'
	
RETURN(cHTML)


//=========================================+
//  TITULO DOS CAMPOS DO HTML              +
//=========================================+
STATIC FUNCTION HtmlTit()

	Local cHtml := " "
	 
	cHtml +=   '<TABLE Bgcolor="#FFFFFF" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF">'
	cHtml +=   '	<TR>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Tipo</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Prefixo</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Numero</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Parcela</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Emissao</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vencto</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vencto Real</B></TD>'	
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Baixa</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Valor Fatura</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vlr Baixado</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vlr Juros</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vlr Multa</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Cliente</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Loja</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Nome Cliente.</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Historico</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Conciliado</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Banco</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Agencia</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Conta</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vlr Corre็ใo</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Vlr Desconto</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Filial</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Fil. Orig</B></TD>'
	cHtml +=   '		<TD align="CENTER"  bgcolor="#00BFFF"><B>Saldo Fatura</B></TD>'	
	cHtml +=   '	</TR>'
	cHtml +=   '</TABLE>'



Return(cHtml)

//========================================+
// RODAPE DO HTML                         +
//========================================+
Static Function HtmlRodap()

	Local cHtml := ' '
	
	cHtml +=  '<br>'
	cHtml +=  '<TABLE bgcolor="#FFFFFF" border="1" width="780" cellpadding="0" cellspacing="0">	
	cHtml +=  '	<TR valign="top" width="10%" style=" font-family:Arial; font-size:12px">
	cHtml +=  ' 		<td height="15" width="10%" align="center" COLSPAN="2"><b>Dados da Emissใo</b></td> 
	cHtml +=  ' 	</TR> 
	cHtml +=  '	<TR valign="top" width="100%" style=" font-family:Arial; font-size:12px"> 
	cHtml +=  ' 		<td height="15" width="10%" align="CENTER"><B>Data:&nbsp;</B></td> 
	cHtml +=  ' 		<td height="15" width="10%" align="left">&nbsp;'+DtoC(Date())+'</td> 
	cHtml +=  ' 	</TR> 
	cHtml +=  '</TABLE>
	
	cHtml +=  '<br>'
	cHtml +=  '<b>Siga/FINR500</b>'
	
	cHtml += ' </body> '
	cHtml += ' </html> '


Return(cHtml)