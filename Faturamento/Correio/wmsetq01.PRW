#INCLUDE "PROTHEUS.CH" 
#INCLUDE "APVT100.CH"            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WMSETQ01 บAutor  ณ FONTANELLI         บ Data ณ  17/06/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcesso de Imprimir Etiqueta Correio				          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                      
	// U_WMSETQ01()
User Function WMSETQ01()

Local aTela     

Local oButton_Gravar
Local oButton_Fechar

Local oGetPedido
Local oGroup
Local oSay2

Static oDlg

Private cPedido:= Space(6)
  
if Alltrim(cModulo) == 'ACD'

	aTela:= VtSave() 

	//if cFilAnt <> '01'              
	//	VtBeep(2)
	//   VtAlert("Rotina apenas disponivel na Filial 01 - Manole","Aviso",.t.,4000,3)
	//    VtRestore(,,,,aTela)
	//	Return .F.
	//endif	

	VtSetKey(14,NIL) //Desabilita a tecla CTRL+N   
	VtSetKey(16,NIL) //Desabilita a tecla CTRL+P   
	VtSetKey(17,NIL) //Desabilita a tecla CTRL+Q
	VtSetKey(24,NIL) //Desabilita a tecla CTRL+W
		
	While .T.

		cPedido	 := Space(6)

		VtClear()   

		If VtLastkey() == 27             
	       VtRestore(,,,,aTela)
		   Return
		EndIf
		
		DLVTCabec("Etiqueta Correio",.F.,.F.,.T.)           
  
		@ 01,00 VTSay "Pedido: "
		
		@ 02,00 VTGet cPedido  Picture '@!' VALID VTLastkey() == 5 .or. VldPedido()
		
		VTRead
		If VTLastKey() == 27
		   VtRestore(,,,,aTela)
		   Return
		EndIf
	
	end-While

endif

if Alltrim(cModulo) <> 'ACD'                                

	//if cFilAnt <> '01'              
	//	Aviso("Aviso","Rotina apenas disponivel na Filial 01 - Manole",{"Ok"})		
	//	Return
	//endif

   DEFINE MSDIALOG oDlg TITLE "Etiqueta do Correio" FROM 000, 000  TO 250, 320 COLORS 0, 16777215 PIXEL
    @ 004, 005 GROUP oGroup TO 107, 155 PROMPT " Digite " OF oDlg COLOR 0, 16777215 PIXEL
    @ 028, 013 MSGET oGetPedido VAR cPedido SIZE 039, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 018, 014 SAY oSay2 PROMPT "Pedido" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 109, 055 BUTTON oButton_Gravar PROMPT "Imprimir" ACTION(GravarWLog()) SIZE 051, 012 OF oDlg PIXEL
    @ 109, 103 BUTTON oButton_Fechar PROMPT "Fechar" ACTION(oDlg:End()) SIZE 051, 012 OF oDlg PIXEL
   ACTIVATE MSDIALOG oDlg CENTERED           

endif
	
Return nil

                                                                     
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravarWLog()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	If Empty(cPedido)
		Aviso("Aviso","Pedido nao informado!",{"Ok"})
	    Return .F.                                              
	Endif

	SC5->(dbSetOrder(1))
	if !SC5->(dbSeek(xFilial("SC5")+cPedido))
		Aviso("Aviso","Pedido inexistente!",{"Ok"})		
		Return .F.                                             
	endif
		
	if EMPTY(SC5->C5_OBJETO)
		Aviso("Aviso","Pedido nใo possui Objeto relacionado!",{"Ok"})		
		Return .F.                                             
	endif

	U_EtiqCorreio(cPedido)

	cPedido:= Space(6)
	
	//oDlg:End()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VldPedido()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if Alltrim(cModulo) == 'ACD'
    
	If Empty(cPedido)
		VtBeep(2)
	    VtAlert("Pedido nao informado!","Aviso",.t.,4000,3)
		VtKeyboard(Chr(20))
	    Return .F.                                              
	Endif

	SC5->(dbSetOrder(1))
	if !SC5->(dbSeek(xFilial("SC5")+cPedido))
		VtBeep(2)
		VtAlert("Pedido inexistente!","Aviso",.t.,4000,3)
		VtKeyboard(Chr(20))
		Return .F.                                             
	endif
	
	if EMPTY(SC5->C5_OBJETO) 
		VtBeep(2)
		VtAlert("Pedido nใo possui Objeto relacionado!","Aviso",.t.,4000,3)
		VtKeyboard(Chr(20))
		Return .F.                                             
	endif

	 U_EtiqCorreio(cPedido)

endif
		
Return .T.


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function EtiqCorreio(cPedido)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LOCAL cPORTA

if Alltrim(cModulo) == 'ACD'
	VtBeep(2)
	VtAlert("Imprimindo Etiqueta...","Aviso",.t.,4000,3)
	VtKeyboard(Chr(20))
endif                                                              
            
////////////                
nReduzir:= 6 
////////////
                   
//MSCBPrinter - Configura Impressora ( [ cModelPrt ] [ cPorta ] [ nDensidade ] [ nTamanho ] [ lSrv ] [ nPorta ] [ cServer ] [ cEnv ] [ nMemoria ] [ cFila ] [ lDrvWin ] [ cPathSpool ] )
  
if Alltrim(cModulo) <> 'ACD'
   MSCBPRINTER("ZEBRA","LPT1",,,.f.,,,,,,)    
endif

if Alltrim(cModulo) == 'ACD'     
  // MSCBPRINTER("ZEBRA","LPT1:",NIL,NIL,.f.,0,"","",99999,"Expedicao",.t.,"")    
  MSCBPRINTER("ZEBRA","LPT1:",NIL,NIL,.f.,0,"","",99999,"Correio",.t.,"")    
endif
   
MSCBCHKSTATUS(.f.)  

MSCBBEGIN(1,6)                   
               
MSCBBOX(03,65,100,115-nReduzir)                       

SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+cPedido))

cTRANSPORT := ALLTRIM(UPPER(POSICIONE("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_NOME")))

MSCBGRAFIC(5,5,cTRANSPORT)
MSCBGRAFIC(45,5,"QRCODE")
MSCBGRAFIC(80,5,"MANOLE")

MSCBSAY(05,28,"Nota Fiscal:" ,"N","0","025,035")
MSCBSAY(27,28,SC5->C5_NOTA,"N","0","025,025")

MSCBSAY(37,32,SC5->C5_OBJETO,"N","0","025,035")
MSCBSAYBAR(07,35,SC5->C5_OBJETO,"N","C",20,.F.,.F.,.F.,,4,3,.F.,.F.,"1",.T.)

MSCBSAY(05,57,"u8ivel: "  ,"N","0","025,025")
MSCBLineH(25,59,100,03) 
MSCBSAY(05,61,"Documento:"  ,"N","0","025,025")
MSCBLineH(25,63,100,03) 

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
MSCBSAY(04,66,"Destinatแrio:"  ,"N","0","025,035")
MSCBSAY(04,70,AllTrim(Upper(SA1->A1_NOME)),"N","0","025,025")
MSCBSAY(04,73,substr(AllTrim(Upper(SA1->A1_END)),1,52),"N","0","025,025")
nlf := 73
if !empty(substr(AllTrim(Upper(SA1->A1_END)),53,52))
	nlf += 3
	MSCBSAY(04,nlf,substr(AllTrim(Upper(SA1->A1_END)),53,52),"N","0","025,025")
endif
if !empty(substr(AllTrim(Upper(SA1->A1_END)),105,52))
	nlf += 3
	MSCBSAY(04,nlf,substr(AllTrim(Upper(SA1->A1_END)),105,52),"N","0","025,025")
endif
nlf += 3
MSCBSAY(04,nlf,AllTrim(Upper(SA1->A1_BAIRRO)),"N","0","025,025")

MSCBSAYBAR(10,88-nReduzir,SA1->A1_CEP,"N","MB07",20,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)

MSCBSAY(04,110-nReduzir,AllTrim(SubStr(SA1->A1_CEP,1,5)+"-"+SubStr(SA1->A1_CEP,6,3)),"N","0","025,035")
MSCBSAY(30,110-nReduzir,AllTrim(Upper(SA1->A1_MUN))+" / "+AllTrim(Upper(SA1->A1_EST)),"N","0","025,035")

MSCBSAY(04,116-nReduzir,"Remetente:"    ,"N","0","025,035")

MSCBSAY(04,120-nReduzir,AllTrim(Upper(SM0->M0_NOMECOM)),"N","0","025,025")
MSCBSAY(04,123-nReduzir,AllTrim(Upper(SM0->M0_ENDCOB))+" - "+AllTrim(Upper(SM0->M0_BAIRCOB)),"N","0","025,025")
MSCBSAY(04,126-nReduzir,AllTrim(Upper(SM0->M0_CIDCOB))+" / "+AllTrim(Upper(SM0->M0_ESTCOB)),"N","0","025,025")
MSCBSAY(04,129-nReduzir,AllTrim(SubStr(SM0->M0_CEPCOB,1,5)+"-"+SubStr(SM0->M0_CEPCOB,6,3)),"N","0","025,025")
            
MSCBEND()
MSCBCLOSEPRINTER()
   
Return


