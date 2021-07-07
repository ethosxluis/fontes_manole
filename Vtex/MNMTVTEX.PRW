#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNMTVTEX  บAutor  ณLeandro Duarte      บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de consulta da vtex                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function MNMTVTEX
Local aObjects 		:= {}
Local oFnt			:= nil
Local oGet1			:= oSay	:= oGet2 := oGet3 := oGet4 := oButton := oGet5 := oGet6 :=  oGet7 := oGet8 := nil
Local cGet1			:= cGet2 := stod('')
Local cGet5			:= space(tamsx3("C5_VTEX")[1])
Local cGet6 		:= space(tamsx3("C5_VTEX")[1])
Local cGet7			:= space(tamsx3("A1_CGC")[1])
Local cGet8 		:= space(tamsx3("A1_CGC")[1])
Local cGet3			:= cGet4 := space(tamsx3("B1_COD")[1])
Local cLin			:= 0
Local cCol			:= 0
Local oOk 			:= LoadBitmap( GetResources(), "LBOK")
Local oNo 			:= LoadBitmap( GetResources(), "LBNO")
Local lCheck1 		:= .F.
Local oCheck1		:= oCombo		:= nil
Local aFolder		:= { 'Cliente', 'Pedido', 'Expedi็ใo' }
Local lEnd			:= .F.
Local aCpoEnchA 	:= {}
Local aAlter 		:= {}
Local aAlterEnchA 	:= {}
Local aCpoEnchB 	:= {}
Local aAlterEnchB 	:= {}
Local aPos 			:= {}
Local cAliasA 		:= "SC5"
Local cAliasB 		:= "SC6"
Local nReg			:= 0
Local nOpc			:= 2
Local nModelo 		:= 3
Local lF3 			:= .F.
Local lMemoria 		:= .F.
Local lColumn 		:= .F.
Local caTela 		:= ""
Local lNoFolder 	:= .F.
Local lProperty 	:= .F.

Private cArqPd 	:= "/imp_vtex/"
private aSize     	:= MsAdvSize()
private aInfo     	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Private oFolder
Private oWBrowse1
Private aWBrowse1 	:= {}
Private oWBrowse2
Private aWBrowse2 	:= {}
Private oWBrowse3
Private aWBrowse3 	:= {}
Private QaOrder		:= {}
Private oDlg
Private oDBTree
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private cAbre :=	"SDUOPEN"
Private cFecha :=	"SDUCLOSE"
Private cBmp1 := 	'ENABLE'
Private cBmp2 := 	'DISABLE'
Private cBmp3 := 	'BR_AMARELO'
Private cBmp4 := 	'BR_AZUL'
Private cBmp5 := 	'BR_LARANJA'
Private cBmp6 := 	'UPDWARNING'
Private cBmp7 :=     LoadBitmap( GetResources(), "BR_VERDE")
Private cBmp8 :=     LoadBitmap( GetResources(), "BR_VERMELHO")
Private cBmp9 :=     LoadBitmap( GetResources(), "BR_AZUL")
Private cBmpA :=     LoadBitmap( GetResources(), "BR_PRETO")
Private oEnch1		:= oEnch2	 :=	nil
Private aListaFil 	:= {}
Private oDlg		:= nil
Private aCpo		:= {}
Private aCpos		:= {}
Private aCpoNome	:= {}
Private Bline		:= nil
Private oMultiGe1
Private cMultiGe1 := "OS ARQUIVOS ESTAO DISPONIVEL NA PASTA PROTHEUS_DATA\IMP_VTEX"
Private oMultiGe2
Private cMultiGe2 := "   "
Private aDCli	:= {}
Private _oOk := LoadBitmap( GetResources(), "ENABLE")
Private _oNo := LoadBitmap( GetResources(), 'DISABLE')
Private cEdtTela	:= ""
Private oFont1 		:= TFont():New("Arial",,017,,.T.,,,,,.F.,.F.)
Private aHeader := {}
Private aCOLS := {}
Private cArqNtx1	:= Criatrab(Nil,.F.)
Private cArqNtx2	:= Criatrab(Nil,.F.)
Private cArqNtx3	:= Criatrab(Nil,.F.)
Private oTTabs 		:= nil



SX3->(DbSetOrder(1))
SX3->(DbSeek(cAliasA))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasA
	If !(ALLTRIM(SX3->X3_CAMPO) $ "C5_FILIAL") .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		AADD(aCpoEnchA,SX3->X3_CAMPO)
	endif
	SX3->(DbSkip())
End
aAlterEnchA := aClone(aCpoEnchA)
SX3->(DbSeek(cAliasB))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasB
	If !(ALLTRIM(SX3->X3_CAMPO) $ "C6_FILIAL,C6_INFAD") .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		AADD(aCpoEnchB,SX3->X3_CAMPO)
	EndIf
	SX3->(DbSkip())
End
aAlterEnchB := aClone(aCpoEnchB)

// abre e posiciona a tabela
SC6->(DBSETORDER(1))
SC6->(DBGOTO(nReg))

// Definicoes de Resolucao da Tela
AADD(aObjects,{100,080,.T.,.F.,.F.})
AADD(aObjects,{100,085,.T.,.T.,.F.})
AADD(aObjects,{000,15, .T., .F. } )
aPosObj := MsObjSize( aInfo, aObjects )
cLin 	:=	aPosObj[1,1]
cCol	:=	aPosObj[1,2]
nTamCpo	:=	aPosObj[1,4]
nLarCpo	:=	aPosObj[1,3]
nTamLis	:=	(aSize[3]-((nLarCpo/100)*80))/2.4
aPos1 	:= {3,((nTamCpo/100)*30.3), (nTamLis-27)/3,((nTamCpo/100)*99)}
aPos2 	:= {((nTamLis-27)/3)+5,((nTamCpo/100)*30.3), (nTamLis-27)/3+(nTamLis-27)/3,((nTamCpo/100)*99)}

DEFINE MSDIALOG oDlg TITLE "Auditoria em Saldo no Estoque/Loja" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
// Loja de e Loja at้
oSay:= tSay():New(cLin,cCol,{||'Data de:'},oDlg,,oFont1,,,,.T.,,,100,20)
oGet1:= TGet():New(cLin,cCol+35,{|u| if(PCount()>0,cGet1:=u,cGet1)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,,'cGet1')
oSay:= tSay():New(cLin+13,cCol,{||'Data at้:'},oDlg,,oFont1,,,,.T.,,,100,20)
oGet2:= TGet():New(cLin+13,cCol+35,{|u| if(PCount()>0,cGet2:=u,cGet2)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,,'cGet2')
// Produto de e Produto at้
oSay:= tSay():New(cLin,((nTamCpo/100)*12),{||'Produto de:'},oDlg,,oFont1,,,,.T.,,,((nTamCpo/100)*7),20)
oGet3:= TGet():New(cLin,((nTamCpo/100)*17),{|u| if(PCount()>0,cGet3:=u,cGet3)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,"SB1",'cGet3')
oSay:= tSay():New(cLin+13,((nTamCpo/100)*12),{||'Produto at้:'},oDlg,,oFont1,,,,.T.,,,((nTamCpo/100)*7),20)
oGet4:= TGet():New(cLin+13,((nTamCpo/100)*17),{|u| if(PCount()>0,cGet4:=u,cGet4)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,"SB1",'cGet4')
// Reserva de e Reserva at้
oSay:= tSay():New(cLin,((nTamCpo/100)*25),{||'Cod Vetx de:'},oDlg,,oFont1,,,,.T.,,,((nTamCpo/100)*7),20)
oGet5:= TGet():New(cLin,((nTamCpo/100)*30),{|u| if(PCount()>0,cGet5:=u,cGet5)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,,'cGet5')
oSay:= tSay():New(cLin+13,((nTamCpo/100)*25),{||'Cod Vetx at้:'},oDlg,,oFont1,,,,.T.,,,((nTamCpo/100)*7),20)
oGet6:= TGet():New(cLin+13,((nTamCpo/100)*30),{|u| if(PCount()>0,cGet6:=u,cGet6)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,,'cGet6')
// CPF de e CPF at้
oSay:= tSay():New(cLin,((nTamCpo/100)*38),{||'CPF/CNPJ de:'},oDlg,,oFont1,,,,.T.,,,((nTamCpo/100)*7),20)
oGet7:= TGet():New(cLin,((nTamCpo/100)*44),{|u| if(PCount()>0,cGet7:=u,cGet7)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,,'cGet7')
oSay:= tSay():New(cLin+13,((nTamCpo/100)*38),{||'CPF/CNPJ at้:'},oDlg,,oFont1,,,,.T.,,,((nTamCpo/100)*7),20)
oGet8:= TGet():New(cLin+13,((nTamCpo/100)*44),{|u| if(PCount()>0,cGet8:=u,cGet8)}, oDlg, ((nTamCpo/100)*7),7,'@!',{|o| .t. },,,,,,.T.,,,,,,,,,,'cGet8')
// bot๕es
oButton:=tButton():New(cLin, ((nTamCpo/100)*57),'Pesquisar',oDlg,{|| Processa({|lEnd| rodapesq(cGet1,cGet2,cGet3,cGet4,cGet5,cGet6,cGet7,cGet8,@aWBrowse2,aCpo)},"Aguarde","Pesquisando a base de dados",.T.), oWBrowse2:refresh() },((nTamCpo/100)*7),10,,,,.T.)
oButton:=tButton():New(cLin+13, ((nTamCpo/100)*57),'Sair',oDlg,{|| oDlg:end() },((nTamCpo/100)*7),10,,,,.T.)
oButton:=tButton():New(cLin+26, ((nTamCpo/100)*57),'Reprocessar',oDlg,{|| Processa({|lEnd| PROCREG(oFolder:NOPTION,oWBrowse2:nAT,aCpo,@oDBTree,oDBTree:GetCargo()), rodapesq(cGet1,cGet2,cGet3,cGet4,cGet5,cGet6,cGet7,cGet8,@aWBrowse2,aCpo) },"Aguarde","Processando o Registro",.T.), oWBrowse2:refresh()  },((nTamCpo/100)*7),10,,,,.T.)
oButton:=tButton():New(cLin, ((nTamCpo/100)*65),'Editar Cad.',oDlg,{|| EditCad(oFolder:NOPTION,aCpo,aWBrowse2[oWBrowse2:nAT][len(aWBrowse2[oWBrowse2:nAT])],oWBrowse2:nAT,@oDBTree,oDBTree:GetCargo(),@oDlg,@oEnch1,@oEnch2 )},((nTamCpo/100)*7),10,,,,.T.)
oButton:=tButton():New(cLin+13, ((nTamCpo/100)*65),'Importar',oDlg,{|| IMPVTX() },((nTamCpo/100)*7),10,,,,.T.)

//ABAS
oFolder := TFolder():New( ((nLarCpo/100)*80), ((nTamCpo/100)*0.5), aFolder, aFolder, oDlg,,,, .T., , ((nTamCpo/100)*99.5), nTamLis )

//PRIMEIRA ABA Listagem dos Clientes
UA1->(DBSETORDER(3))
UA1->(DBSEEK(XFILIAL("UA1")+'1'+'1'))
cVelhoArq := u_Velhoarq('1')
if !empty(cVelhoArq)
	iif(SELECT("TRBCLI")>0,TRBCLI->(DbCloseArea()),nil)
	dbUseArea(.T.,,cVelhoArq,"TRBCLI", .T., .F. )
	while !(select("TRBCLI")>0)
		dbUseArea(.T.,,cVelhoArq,"TRBCLI", .T., .F. )
	end
	cIndCon3 := "A1_CGC"
	IndRegua("TRBCLI",cArqNtx3,cIndCon3,,,"Selecionando Registros...")
	dbselectarea("TRBCLI")
	dbSetIndex(cArqNtx3 + OrdBagExt())
	dbselectarea("TRBCLI")
	TRBCLI->(dbgotop())
	TRBCLI->(DBSETORDER(1))

	aCpos	:= Extrut(cVelhoArq,@aWBrowse2,@Bline)
	aEval(aCpos,{|x| aadd(aCpoNome,x[4]), aadd(aCpo,x[2]) })
	// objeto de clientes
	@ cLin,cCol LISTBOX oWBrowse2 Fields HEADER " " SIZE ((nTamCpo/100)*98.3), (nTamLis-27)/2 OF oFolder:aDialogs[1] PIXEL
	oWBrowse2:aHeaders := aCpoNome
	oWBrowse2:SetArray(aWBrowse2)
	oWBrowse2:bLine := &Bline
	oWBrowse2:bchange := {|| BusqArq(aCpo,oWBrowse2:nAT) }
	//	oWBrowse2:bHeaderClick := {|x,y| (qAC1111rd(y,1),aviso("Aviso","Ordena็ใo Concluida",{"Ok"})) }

	// objeto de erros clientes
	@ ((nTamLis-27)/2)+8 , cCol GET oMultiGe1 VAR cMultiGe1 OF oFolder:aDialogs[1] MULTILINE SIZE ((nTamCpo/100)*98.3), (nTamLis-27)/2  COLORS 0, 16777215 READONLY HSCROLL PIXEL

endif
// SEGUNDA ABA lista os itens reservados
oDBTree := dbTree():New(cLin,cCol,nTamLis-27,((nTamCpo/100)*30), oFolder:aDialogs[2],{|| ATuEcho(@oDBTree,oDBTree:GetCargo(),@oDlg,@oEnch1,@oEnch2) },{|| ATuEcho(@oDBTree,oDBTree:GetCargo(),@oDlg,@oEnch1,@oEnch2) },.T.)

// CRIA A ENCHOICE DA RESERVA OU DO PEDIDO
RegToMemory(cAliasA, .F., .F.)
oEnch1 := MsMGet():New(cAliasA,nReg,4,,,,aCpoEnchA, aPos1, {},,,,,oFolder:aDialogs[2],,.T.)
RegToMemory(cAliasB, .F., .F.)
oEnch2 := MsMGet():New(cAliasB,nReg,4,,,,aCpoEnchB, aPos2, {},,,,,oFolder:aDialogs[2],,.T.)
@ ((nTamLis-27)/3+(nTamLis-27)/3)+3 , ((nTamCpo/100)*30.3) GET oMultiGe2 VAR cMultiGe2 OF oFolder:aDialogs[2] MULTILINE SIZE ((nTamCpo/100)*68.5), (nTamLis-27)/3  COLORS 0, 16777215 READONLY HSCROLL PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณParte da expedi็ใo apresentando os browse dos itens aguardando faturamento e os itens ja faturadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oTTabs:=TTabs():New(cLin,cCol,{'Aberto','Faturado'},{|| iif( oTTabs:nOption==1,(oPanel01:LVISIBLECONTROL:=.t.,oPanel02:LVISIBLECONTROL:=.f.),(oPanel01:LVISIBLECONTROL:=.F.,oPanel02:LVISIBLECONTROL:=.T.))},oFolder:aDialogs[3],,RGB(255,0,0),RGB(255,255,0),.T.,,((nTamCpo/100)*98.3),(nTamLis-27),)
oPanel01 := TPanel():New( 000, 000,'',oTTabs,,,,,,((nTamCpo/100)*98.4),(nTamLis-37.8),,.T. )
oPanel01:lVisibleControl := .T.
aadd(aWBrowse1,{.t.," "," ","     ","  ","   ","   ","    "," ",stod(" ")})
@ cLin+5,cCol LISTBOX oWBrowse1 Fields HEADER " " SIZE ((nTamCpo/100)*97.9), (nTamLis-48) OF oPanel01 PIXEL ColSizes 2,30,30,160,30,160,55,55,60,55
oWBrowse1:aHeaders := {"","Pedido","Cliente", "Nome", "Transportadora","Descri็ใo","Rastreio","Nota Fiscal", "Produto/Servi็o", "Emissใo"}
oWBrowse1:SetArray(aWBrowse1)
oWBrowse1:bLine := {|| {If(aWBrowse1[oWBrowse1:nAT,1],cBmp7,cBmp8),aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3],aWBrowse1[oWBrowse1:nAt,4],aWBrowse1[oWBrowse1:nAt,5],aWBrowse1[oWBrowse1:nAt,6],aWBrowse1[oWBrowse1:nAt,7],aWBrowse1[oWBrowse1:nAt,8],aWBrowse1[oWBrowse1:nAt,9],aWBrowse1[oWBrowse1:nAt,10]}}


oPanel02 := TPanel():New( 000, 000,'',oTTabs,,,,,,((nTamCpo/100)*98.4),(nTamLis-37.8),,.T. )
oPanel02:lVisibleControl := .F.
aadd(aWBrowse3,{.t.," "," ","     ","  ","   ","   ","    "," ",stod(" ")})
@ cLin+5,cCol LISTBOX oWBrowse3 Fields HEADER " " SIZE ((nTamCpo/100)*97.9), (nTamLis-48) OF oPanel02 PIXEL ColSizes 2,30,30,160,30,160,55,55,60,55
oWBrowse3:aHeaders := {"","Pedido","Cliente", "Nome", "Transportadora","Descri็ใo","Rastreio","Nota Fiscal", "Produto/Servi็o", "Emissใo"}
oWBrowse3:SetArray(aWBrowse3)
oWBrowse3:bLine := {|| {If(aWBrowse3[oWBrowse3:nAT,1],cBmp9,cBmpA),aWBrowse3[oWBrowse3:nAt,2],aWBrowse3[oWBrowse3:nAt,3],aWBrowse3[oWBrowse3:nAt,4],aWBrowse3[oWBrowse3:nAt,5],aWBrowse3[oWBrowse3:nAt,6],aWBrowse3[oWBrowse3:nAt,7],aWBrowse3[oWBrowse3:nAt,8],aWBrowse3[oWBrowse3:nAt,9],aWBrowse3[oWBrowse3:nAt,10]}}


ACTIVATE MSDIALOG oDlg
ferase(cArqNtx1)
ferase(cArqNtx2)
ferase(cArqNtx3)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExtrut    บAutor  ณLeandro Duarte      บ Data ณ  01/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para capturar os campos da estrutura atual de clientesฑฑ
ฑฑบ          ณdo de para                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Extrut(cNomEstr,aWBrowse2,Bline)
Local aStr	:= {}
Local nVolt1:= 1
Local cAnt	:= ""
Bline := "{|| {Iif(aWBrowse2[oWBrowse2:nAT,1]==1,_oOk,_oNo),"

UA1->(dbsetorder(1))
SX3->(Dbsetorder(2))
if UA1->(DBSEEK(XFILIAL("UA1")+cNomEstr))
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	//cria็ใo do campo de processado sim ou nใo
	aadd(aStr,{"1","UXU_PROQUE","N"," "})
	aadd(aDCli,0)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlimenta o Array Astr com a informa็ใo do De para cadastrado na tabela UA1ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		// carrega o objeto da vtex para aliemntar esse campo
		aadd(aStr,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL,nil,nil})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		//nome do campo
		aStr[LEN(aStr)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		// tipo de campo
		aStr[LEN(aStr)][3] := tamsx3(aStr[LEN(aStr)][2])[3]
		SX3->(DBSEEK(aStr[LEN(aStr)][2]))
		// titulo do campo
		aStr[LEN(aStr)][4] := ALLTRIM(X3Titulo())
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlimenta a variavel aDcli para depois alimentar a variavel aWBrowseณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aadd(aDCli,IIF(aStr[LEN(aStr)][3]=='C',SPACE(1),IIF(aStr[LEN(aStr)][3]=='N',0,IIF(aStr[LEN(aStr)][3]=='D',STOD(' '),IIF(aStr[LEN(aStr)][3]=='L',.T.," ")))))
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVariavel para carregar a posi็ใo correta do Acolsณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nVolt1++
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlimenta o Bloco de Linha para rodar encapsulado no bloco do objeto oBrowseณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Bline+="aWBrowse2[oWBrowse2:nAT,"+cvaltochar(nVolt1)+"],"
	END
endif
AADD(aWBrowse2,aDCli)
Bline := substr(Bline,1,len(Bline)-1)+"}}"
Return(aStr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusqArq   บAutor  ณLeandro Duarte      บ Data ณ  01/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para cpturar o arquivo e ler o mesmo para jogar na   บฑฑ
ฑฑบ          ณvariavel do erro do cliente                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BusqArq(aCpo, nAt)
Local nPosCGC 	:= ascan(aCpo,"A1_CGC")
Local nPosUXU 	:= ascan(aCpo,"UXU_PROQUE")
Local cNomeArq	:= alltrim(oWBrowse2:AARRAY[nAt][nPosCGC])+'.log'
Local cArqTxt := "/imp_vtex/" +cNomeArq
Local nHdl    := fOpen(cArqTxt,68)
Local cEOL    := "CHR(13)+CHR(10)"
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local aMemo		:= {}
Local nF		:= 0
cMultiGe1 := ""

if file(cArqTxt)
	FT_FUse(cArqTxt)
	FT_FGoTop()

	While !FT_FEof()
		cLinha	:= FT_FReadLn()
		aadd(aMemo,cLinha)
		FT_FSkip()
	EndDo
	FT_FUSE()
	for nF := len(aMemo) to 1 step -1
		cMultiGe1 += aMemo[nf]+CRLF
		if LEN(cMultiGe2) > 48884
			nF := 0
		endif
	next nf
elseIF oWBrowse2:AARRAY[nAt][nPosUXU] == 1
	cMultiGe1 := "Cliente Processado com Sucesso!"
else
	cMultiGe1 := "Cliente aguardando para ser Processado!"
endif

oMultiGe1:refresh()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณrodapesq   บAutor  ณLeandro Duarte     บ Data ณ  09/01/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para listar os dados na tela                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function rodapesq(cGet1,cGet2,cGet3,cGet4,cGet5,cGet6,cGet7,cGet8,aWBrowse2,aCpo)
Local aRetCpo := {}
Local nFor	:= 0
Local aVtex := {}
Local cQuery := ""

procregua(0)

if EMPTY(cGet2)
	Alert("Selecione pelo menos uma data de Termino")
	return()
endif
if EMPTY(cGet4)
	Alert("Selecione pelo menos um Produto Final!")
	return()
endif
if EMPTY(cGet6)
	Alert("Selecione pelo menos codigo da Vtex Final!")
	return()
endif
if EMPTY(cGet8)
	Alert("Selecione pelo menos Cpf ou CNPJ final!")
	return()
endif

aWBrowse2 := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIniciando o processo de pesquisa cadastro de Clienteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TRBCLI->(DBGOTOP())
while TRBCLI->(!EOF())
	IF TRBCLI->A1_CGC < cGet7 .OR. TRBCLI->A1_CGC > cGet8
		TRBCLI->(DBSKIP())
		LOOP
	ENDIF
	For nFor := 1 to len(aCpo)
		aadd(aRetCpo, &("TRBCLI->"+aCpo[nFor]) )
	next nFor
	aadd(aRetCpo, TRBCLI->(RECNO()) )
	aadd(aWBrowse2,aRetCpo)
	aRetCpo := {}
	TRBCLI->(DBSKIP())
END
IF LEN(aWBrowse2) <= 0
	AADD(aWBrowse2,aDCli)
ENDIF
oWBrowse2:SetArray(aWBrowse2)
oWBrowse2:bLine := &Bline
oWBrowse2:refresh()
BusqArq(aCpo,oWBrowse2:nAT)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessando o cadastro de pedidosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
UA1->(DBSETORDER(3))
UA1->(DBSEEK(XFILIAL("UA1")+'1'+'2'))
cVelhoArq := u_Velhoarq('2')
if !empty(cVelhoArq)
	iif(SELECT("TRBPED")>0,TRBPED->(DbCloseArea()),nil)
	dbUseArea(.T.,,cVelhoArq,"TRBPED", .T., .F. )
	while !(select("TRBPED")>0)
		dbUseArea(.T.,,cVelhoArq,"TRBPED", .T., .F. )
	end
	cIndCond := "C5_VTEX"
	IndRegua("TRBPED",cArqNtx1,cIndCond,,,"Selecionando Registros...")
	dbselectarea("TRBPED")
	dbSetIndex(cArqNtx1 + OrdBagExt())
	TRBPED->(DBSETORDER(1))
endif
UA1->(DBSETORDER(3))
UA1->(DBSEEK(XFILIAL("UA1")+'1'+'3'))
cVelhoArq := u_Velhoarq('3')
if !empty(cVelhoArq)
	iif(SELECT("TRBDET")>0,TRBDET->(DbCloseArea()),nil)
	dbUseArea(.T.,,cVelhoArq,"TRBDET", .T., .F. )
	while !(select("TRBDET")>0)
		dbUseArea(.T.,,cVelhoArq,"TRBDET", .T., .F. )
	end
	cIndConV := "C6_VTEX+C6_PRODUTO+C6_ITEM"
	IndRegua("TRBDET",cArqNtx2,cIndConV,,,"Selecionando Registros...")
	dbselectarea("TRBDET")
	dbSetIndex(cArqNtx2 + OrdBagExt())
	TRBDET->(DBSETORDER(1))
	TRBDET->(dbgotop())
endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCOLOCANDO O PROCESSO NA ARVOREณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDBTree:Reset()

while TRBPED->(!eof())
	if TRBPED->C5_EMISSAO < cGet1 .OR. TRBPED->C5_EMISSAO > cGet2
		TRBPED->(dbskip())
		LOOP
	ENDIF
	if TRBPED->C5_VTEX < cGet5 .OR. TRBPED->C5_VTEX > cGet6
		TRBPED->(dbskip())
		LOOP
	ENDIF
	if TRBPED->A1_CGC < cGet7 .OR. TRBPED->A1_CGC > cGet8
		TRBPED->(dbskip())
		LOOP
	ENDIF
	if !TRBDET->(DBSEEK(TRBPED->C5_VTEX))
		TRBPED->(dbskip())
		LOOP
	endif
	if TRBDET->C6_PRODUTO < cGet3 .OR. TRBDET->C6_PRODUTO > cGet4
		TRBPED->(dbskip())
		LOOP
	ENDIF
	IF ascan(aVtex,TRBPED->C5_VTEX)<=0
		oDBTree:AddTree("CodVtex: "+TRBPED->C5_VTEX+' Nosso numero: '+TRBPED->C5_NOSSONU,.T.,cFecha,cAbre,,,TRBPED->C5_VTEX)
		aadd(aVtex,TRBPED->C5_VTEX)
	endif
	while TRBPED->C5_VTEX == TRBDET->C6_VTEX
		oDBTree:AddTreeItem("Produto: "+TRBDET->C6_PRODUTO+' Item: '+alltrim(TRBDET->C6_ITEM),iif(TRBDET->UXU_PROQUE==1,cBmp2,cBmp1),,(TRBPED->C5_VTEX)+(TRBDET->C6_PRODUTO)+(TRBDET->C6_ITEM))
		TRBDET->(DBSKIP())
	END
	TRBPED->(DbSkip())
	if ascan(aVtex,TRBPED->C5_VTEX)<=0
		oDBTree:EndTree()
	ENDIF
end
aWBrowse1 := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBuscar os pedidos que incluiram no sistema conforme as datas mencionadas ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//"","Pedido","Cliente", "Nome", "Transportadora","Descri็ใo","Rastreio","Nota Fiscal"
cQuery := " SELECT A.C5_NUM, A.C5_CLIENTE, C.A1_NOME, D.A4_COD, D.A4_NOME, A.C5_OBJETO, B.C6_NOTA, CASE WHEN E.B1_XTIPO IN ('1','4') THEN 'PRODUTO' ELSE 'SERVIวO' END AS PROD_SERV, A.C5_EMISSAO		"
cQuery += "   FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B, "+RETSQLNAME("SA1")+" C, "+RETSQLNAME("SA4")+" D, "+RETSQLNAME("SB1")+" E "
cQuery += "  WHERE A.C5_NUM = B.C6_NUM 		"
cQuery += "    AND A.C5_CLIENTE = B.C6_CLI 		"
cQuery += "    AND A.C5_FILIAL = '"+Xfilial("SC5")+"' 		"
cQuery += "    AND B.C6_FILIAL = '"+Xfilial("SC6")+"' 		"
cQuery += "    AND C.A1_FILIAL = '"+Xfilial("SA1")+"' 		"
cQuery += "    AND D.A4_FILIAL = '"+Xfilial("SA4")+"'  		"
cQuery += "    AND E.B1_FILIAL = '"+Xfilial("SB1")+"' 		"
cQuery += "    AND A.D_E_L_E_T_ = ' '  		"
cQuery += "    AND B.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND C.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND D.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND E.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND A.C5_EMISSAO >= '"+DTOS(cGet1)+"' "
cQuery += "    AND A.C5_EMISSAO <= '"+DTOS(cGet2)+"' "
cQuery += "    AND A.C5_CLIENTE = C.A1_COD 		"
cQuery += "    AND A.C5_LOJACLI = C.A1_LOJA		"
cQuery += "    AND A.C5_TRANSP = D.A4_COD		"
cQuery += "    AND B.C6_PRODUTO = E.B1_COD 		"
cQuery += "    AND A.C5_VTEX <> '    ' 		"
IIF(SELECT("TRB")>0,TRB->(DBCLOSEAREA()),NIL)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB", .T., .F. )

WHILE TRB->(!EOF())
	AADD(aWBrowse1,{EMPTY(TRB->C6_NOTA), TRB->C5_NUM, TRB->C5_CLIENTE, TRB->A1_NOME, TRB->A4_COD, TRB->A4_NOME, TRB->C5_OBJETO, TRB->C6_NOTA, TRB->PROD_SERV, STOD(TRB->C5_EMISSAO)})
	TRB->(DBSKIP())
END
IF LEN(aWBrowse1)<= 0
	AADD(aWBrowse1,{.T., " ", " ", " ", " ", " ", " ", " ", " ", STOD(" ")})
Endif
oWBrowse1:SetArray(aWBrowse1)
oWBrowse1:bLine := {|| {If(aWBrowse1[oWBrowse1:nAT,1],cBmp7,cBmp8),aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3],aWBrowse1[oWBrowse1:nAt,4],aWBrowse1[oWBrowse1:nAt,5],aWBrowse1[oWBrowse1:nAt,6],aWBrowse1[oWBrowse1:nAt,7],aWBrowse1[oWBrowse1:nAt,8],aWBrowse1[oWBrowse1:nAt,9],aWBrowse1[oWBrowse1:nAt,10]}}
oWBrowse1:refresh()

aWBrowse3 := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBuscar os pedidos que incluiram no sistema conforme as datas mencionadas ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//"","Pedido","Cliente", "Nome", "Transportadora","Descri็ใo","Rastreio","Nota Fiscal"
cQuery := " SELECT A.C5_NUM, A.C5_CLIENTE, C.A1_NOME, D.A4_COD, D.A4_NOME, A.C5_OBJETO, B.C6_NOTA, CASE WHEN E.B1_XTIPO IN ('1','4') THEN 'PRODUTO' ELSE 'SERVIวO' END AS PROD_SERV, A.C5_EMISSAO		"
cQuery += "   FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B, "+RETSQLNAME("SA1")+" C, "+RETSQLNAME("SA4")+" D, "+RETSQLNAME("SB1")+" E "
cQuery += "  WHERE A.C5_NUM = B.C6_NUM 		"
cQuery += "    AND A.C5_CLIENTE = B.C6_CLI 		"
cQuery += "    AND A.C5_FILIAL = '"+Xfilial("SC5")+"' 		"
cQuery += "    AND B.C6_FILIAL = '"+Xfilial("SC6")+"' 		"
cQuery += "    AND C.A1_FILIAL = '"+Xfilial("SA1")+"' 		"
cQuery += "    AND D.A4_FILIAL = '"+Xfilial("SA4")+"'  		"
cQuery += "    AND E.B1_FILIAL = '"+Xfilial("SB1")+"' 		"
cQuery += "    AND A.D_E_L_E_T_ = ' '  		"
cQuery += "    AND B.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND C.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND D.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND E.D_E_L_E_T_ = ' ' 		"
cQuery += "    AND A.C5_EMISSAO >= '"+DTOS(cGet1)+"' "
cQuery += "    AND A.C5_EMISSAO <= '"+DTOS(cGet2)+"' "
cQuery += "    AND A.C5_CLIENTE = C.A1_COD 		"
cQuery += "    AND A.C5_LOJACLI = C.A1_LOJA		"
cQuery += "    AND A.C5_TRANSP = D.A4_COD		"
cQuery += "    AND B.C6_PRODUTO = E.B1_COD 		"
cQuery += "    AND B.C6_NOTA <> '   ' 		"
cQuery += "    AND A.C5_VTEX <> '    ' 		"
IIF(SELECT("TRB")>0,TRB->(DBCLOSEAREA()),NIL)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB", .T., .F. )

WHILE TRB->(!EOF())
	AADD(aWBrowse3,{EMPTY(TRB->C5_OBJETO), TRB->C5_NUM, TRB->C5_CLIENTE, TRB->A1_NOME, TRB->A4_COD, TRB->A4_NOME, TRB->C5_OBJETO, TRB->C6_NOTA, TRB->PROD_SERV, STOD(TRB->C5_EMISSAO)})
	TRB->(DBSKIP())
END
IF LEN(aWBrowse3)<= 0
	AADD(aWBrowse1,{.f., " ", " ", " ", " ", " ", " ", " ", " ", STOD(" ")})
Endif
oWBrowse3:SetArray(aWBrowse3)
oWBrowse3:bLine := {|| {If(aWBrowse3[oWBrowse3:nAT,1],cBmp9,cBmpA),aWBrowse3[oWBrowse3:nAt,2],aWBrowse3[oWBrowse3:nAt,3],aWBrowse3[oWBrowse3:nAt,4],aWBrowse3[oWBrowse3:nAt,5],aWBrowse3[oWBrowse3:nAt,6],aWBrowse3[oWBrowse3:nAt,7],aWBrowse3[oWBrowse3:nAt,8],aWBrowse3[oWBrowse3:nAt,9],aWBrowse3[oWBrowse3:nAt,10]}}
oWBrowse3:refresh()

RETURN()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditCad   บAutor  ณLeandro Duarte      บ Data ณ  01/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para efetuar a abertura do registro e a edi็ใo dele  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EditCad(nFolder,aCpo,nRec,nLiact,oObj,cKey,oDlg,oEnch1,oEnch2)
Local cAliasCLI		:= "SA1"
Local oEncCli		:= oEncPed := oEncDed  := nil
Local aTamTl1		:= {((nTamCpo/100)*0.5),((nLarCpo/100)*10), nTamLis+((nTamLis/100)*19), ((nTamCpo/100)*99.5) }
Local aTamTl2		:= {((nTamCpo/100)*1.5),((nLarCpo/100)*10), (nTamLis/2), ((nTamCpo/100)*99.5) }
Local aTamTl3		:= {(nTamLis/2)+((nTamLis/100)*2),((nLarCpo/100)*10), nTamLis+((nTamLis/100)*19), ((nTamCpo/100)*99.5) }
Local oDlge			:= nil
Local aButtons 		:= {}
Local nFor1			:= nFor2			:= 0
Local nAct			:= 0
Local cDescr		:= OOBJ:GetPrompt()
Local cProduto		:= padr(substr(cDescr,10,tamsx3("C6_PRODUTO")[1]),tamsx3("C6_PRODUTO")[1])
Local oGet
Local oTPanel1
Local aEdtSC5		:= {}
Private aHeader 	:= {}
Private aCOLS 		:= {}
Private aREG 		:= {}
Private aRotina := {}
AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
AADD( aRotina, {"Visualizar" ,'XXXXXXX',0,2})
AADD( aRotina, {"Incluir" ,'XXXXXXX',0,3})
AADD( aRotina, {"Alterar" ,'XXXXXXX',0,4})
AADD( aRotina, {"Excluir" ,'XXXXXXX',0,5})

SX3->(DBSETORDER(2))
if nFolder == 1 .and. nRec > 0// Cadastro do Cliente
	// CRIA A ENCHOICE DO CLIENTE
	TRBCLI->(dbgoto(nRec))
	DEFINE MSDIALOG oDlge TITLE "Edi็ใo do Cadastro do Futuro Cliente" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	RegToMemory(cAliasCLI, .F., .F.)
	For nFor1	:= 1 to len(aCpo)
		if aCpo[nFor1]<>"UXU_PROQUE"
			&("M->"+aCpo[nFor1]) := &("TRBCLI->"+aCpo[nFor1])
		ENDIF
	Next nFor1
	oEncCli := MsMGet():New(cAliasCLI,0,4,,,,aCpo,aTamTl1,aCpo,,,,,oDlge,,.T.)
	EnchoiceBar(oDlge, {|| nAct:=1,oDlge:end()  }, {|| nAct:=0,oDlge:end() },,aButtons)
	ACTIVATE MSDIALOG oDlge CENTERED
	if nAct==1
		reclock("TRBCLI",.f.)
		For nFor1	:= 1 to len(aCpo)
			if aCpo[nFor1]<>"UXU_PROQUE"
				&("TRBCLI->"+aCpo[nFor1])	:= &("M->"+aCpo[nFor1])
				aWBrowse2[nLiact][nFor1]		:= &("M->"+aCpo[nFor1])
			else
				TRBCLI->UXU_PROQUE := 0
			ENDIF
		Next nFor1
		MsUnlock()
		oWBrowse2:refresh()
	endif
elseif nFolder == 2
	// CRIA A ENCHOICE DO Pedido e do detalhe
	n := 1
	TRBPED->(DBSETORDER(1))
	TRBPED->(DBSEEK(ALLTRIM(cKey)))
	SA1->(DBSETORDER(3))
	IF SA1->(DBSEEK(XfILIAL("SA1")+TRBPED->A1_CGC))
		M->C5_CLIENTE	:= SA1->A1_COD
		M->C5_LOJA		:= SA1->A1_LOJA
	ELSE
		M->C5_CLIENTE	:= "      "
		M->C5_LOJA		:= "  "
	ENDIF
	TRBDET->(DBSETORDER(1))
	TRBDET->(DBSEEK(cKey+cProduto))
	aStrSC5 := TRBPED->(dbstruct())
	aStrSC6 := TRBDET->(dbstruct())
	RegToMemory("SC5", .F., .F.)
	For nFor1	:= 1 to len(aStrSC5)
		if aStrSC5[nFor1][1]<>"UXU_PROQUE"
			&("M->"+aStrSC5[nFor1][1]) := &("TRBPED->"+aStrSC5[nFor1][1])
			aadd(aEdtSC5,aStrSC5[nFor1][1])
		ENDIF
	Next nFor1
	RegToMemory("SC6", .F., .F.)
	Mod2Header( "SC6" )
	Mod2COLS( "SC6", 0, 4, cKey)
	if len(aCols)>0
		DEFINE MSDIALOG oDlge TITLE "Pedidos da Vetex a serem importados" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		//oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		//oTPane1:Align := CONTROL_ALIGN_TOP
		oEncPed := MsMGet():New("SC5",0,4,,,,aEdtSC5,aTamTl2,aEdtSC5,,,,,oDlge,,.T.)
		//oTPanel2 := TPanel():New(0,0,"",oDlge,NIL,.T.,	.F.,NIL,NIL,50,16,.T.,.F.)
		oGet := MSGetDados():New((nTamLis/2)+((nTamLis/100)*2),((nLarCpo/100)*10), nTamLis+((nTamLis/100)*19), ((nTamCpo/100)*99.5),4,"AllwaysTrue()","AllwaysTrue()","",.T.,,,,len(aCols))
		ACTIVATE MSDIALOG oDlge CENTER ON INIT 	EnchoiceBar(oDlge,{|| nAct := 1, oDlge:End()  },	{|| oDlge:End() })

		if nAct==1
			reclock("TRBPED",.f.)
			For nFor1	:= 1 to len(aStrSC5)
				if aStrSC5[nFor1][1]<>"UXU_PROQUE"
					&("TRBPED->"+aStrSC5[nFor1][1])	:= &("M->"+aStrSC5[nFor1][1])
				else
					TRBCLI->UXU_PROQUE := 0
				ENDIF
			Next nFor1
			MsUnlock()
			For nFor1 := 1 to len(aCols)
				cChave := (TRBPED->C5_VTEX)+(TRBDET->C6_PRODUTO)+(TRBDET->C6_ITEM)
				IF TRBDET->(!EOF())
					reclock("TRBDET",.f.)
					For nFor2	:= 1 to len(aStrSC6)
						if aStrSC6[nFor2][1]<>"UXU_PROQUE"
							&("TRBDET->"+aStrSC6[nFor2][1])	:= aCols[nFor1][ascan(aHeader,{|x| alltrim(x[2]) == ALLTRIM(aStrSC6[nFor2][1]) })]
						else
							TRBDET->UXU_PROQUE := 0
						ENDIF
					Next nFor2
					MsUnlock()
				ENDIF
			Next nFor1
			oDBTree:ChangeBmp("FOLDER10","FOLDER11",,,cChave)
		endif
	endif
endif
if nAct == 1
	aviso("Atualiza็ใo","Foi salvo com sucesso a atualiza็ใo do registro informado"+CRLF+"Por Favor clic em Reprocessar para subir os registro para o Protheus",{"OK"},3)
endif
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACHAMUN   บAutor  ณLEANDRO DUARTE      บ Data ณ  08/31/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA PARA BUSCAR OS DADOS DOS MUNICIPIOS                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION ACHAMUN(ESTADO,CIDADE,UF)
LOCAL CRET := ""
LOCAL cQuery := ""
if UF != 'EX'
	cQuery := " SELECT CC2_CODMUN FROM "+RETSQLNAME("CC2")+" WHERE CC2_EST = '"+ESTADO+"' AND substr(CC2_MUN,1,15) = '"+REPLACE(PADR(ALLTRIM(u_TIRACENTO(CIDADE)),15),"'"," ")+"' AND D_E_L_E_T_ = ' ' "
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	TRBU->(DBGOTOP())
	IF TRBU->(!EOF())
		CRET := TRBU->CC2_CODMUN
	ELSE
		cQuery := " SELECT CC2_CODMUN FROM "+RETSQLNAME("CC2")+" WHERE CC2_EST = '"+ESTADO+"' AND D_E_L_E_T_ = ' ' "
		IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
		TRBU->(DBGOTOP())
		IF TRBU->(!EOF())
			CRET := TRBU->CC2_CODMUN
		ELSE
			CRET := "50308"
		ENDIF
	ENDIF
ELSE
	CRET := "99999"
ENDIF
RETURN(CRET)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROCREG   บAutor  ณLEANDRO DUARTE      บ Data ณ  01/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPROCESSA O CADASTRO DO CLIENTE SELECIONADO                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC function PROCREG(nFold, nLiact, aCpo,oObj,cKey)
Local cPdCpf	:= tamsx3("A1_CGC")[1]
Local cPdVTex	:= tamsx3("C5_VTEX")[1]
Local NOPC		:= 3
Local cLoja		:= ""
Local cCodigo	:= ""
Local aLog		:= {}
Local lPedOk 	:= .T.
Local nFor1		:= 0
Local nFor2		:= 0
Local cTpTab	:= iif(nFold==1,'1','2')
Local cNomeArq	:= ""
Local cNomeArk	:= ""
Local nPosCGC	:= aScan(aCpo,"A1_CGC")
Local cCliente	:= ""
Local aLog		:= {}
Local aItensSC6			:= {}
Private lMsErroauto		:= .T.
Private lMsHelpAuto		:= .T.
Private lautoErrNoFile	:= .T.
Private aGrvSa1		:= {}
Private aGrvSC5 	:= {}
Private aCposSc5	:= {}
Private aCposSc6	:= {}

UA1->(DBSETORDER(3))
UA1->(DBSEEK(XFILIAL("UA1")+'1'+cTpTab))
cNomeArq	:= u_Velhoarq(cTpTab)
aCposSc5	:= Extruc(cNomeArq)
UA1->(DBSETORDER(3))
UA1->(DBSEEK(XFILIAL("UA1")+'1'+'3'))
cNomeArk	:= u_Velhoarq('3')
aCposSc6	:= Extruc(cNomeArk)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณcapturo a tabela que estamos usando analisa se deve gravar os dados na tabela de Cliente, para saber se ja existe a estrutura da tabela DEPARA de cliente   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if nFold == 1
	UA1->(DBSETORDER(3))
	UA1->(DBSEEK(XFILIAL("UA1")+'1'+cTpTab))
	cNomeArq	:= u_Velhoarq(cTpTab)
	aCpos	:= Extruc(cNomeArq)
	cVTex	:= aWBrowse2[nLiact][nPosCGC]
	TRBCLI->(DBSEEK(cVTex))   

	WHILE TRBCLI->(!EOF()) .and. cVTex == TRBCLI->A1_CGC
		lMsErroauto		:= .f.
		lMsHelpAuto		:= .f.
		lautoErrNoFile	:= .T.
		aGrvSa1 := {}
		if TRBCLI->UXU_PROQUE == 0 .AND. cVTex == TRBCLI->A1_CGC
			For nFor1 := 1 to LEN(aCpos)
				aadd(aGrvSa1,{aCpos[nFor1][2],&("TRBCLI->"+aCpos[nFor1][2]),nil})
				&("M->"+aCpos[nFor1][2]) := &("TRBCLI->"+aCpos[nFor1][2])
			Next
			if (nLoc := ascan(aGrvSa1,{|z| alltrim(z[1])=='A1_PAIS'}) ) >0
				aGrvSa1[nLoc][2] := "105"
				&("M->"+aGrvSa1[nLoc][1]) := aGrvSa1[nLoc][2]
			else
				aadd(aGrvSa1,{"A1_PAIS"	,"105", nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			if ascan(aCpos,{|z| alltrim(z[2])=='A1_IE'})>0
				aadd(aGrvSa1,{"A1_INSCR"	,IIF(LEN(ALLTRIM(StrTran(TRBCLI->A1_IE,"-","")))<10,"ISENTO", StrTran(TRBCLI->A1_IE,"-","")), nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			else
				aadd(aGrvSa1,{"A1_INSCR"	,"ISENTO", nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			if ascan(aCpos,{|z| alltrim(z[2])=='A1_CGC'})>0
				aadd(aGrvSa1,{"A1_TPESSOA"		,IIF(LEN(StrTran(TRBCLI->A1_CGC,"-",""))<14,"PF","PJ"), nil })
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			if (ascan(aCpos,{|z| alltrim(z[2])=='A1_ESTADO'})>0 .and. ascan(aCpos,{|z| alltrim(z[2])=='A1_MUN'})>0)
				aadd(aGrvSa1,{"A1_CODMUN"			,ACHAMUN(ALLTRIM(TRBCLI->A1_ESTADO),ALLTRIM(TRBCLI->A1_MUN),ALLTRIM(TRBCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
				aadd(aGrvSa1,{"A1_COD_MUN"			,ACHAMUN(ALLTRIM(TRBCLI->A1_ESTADO),ALLTRIM(TRBCLI->A1_MUN),ALLTRIM(TRBCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			ELSEIF (ascan(aCpos,{|z| alltrim(z[2])=='A1_ESTE'})>0 .and. ascan(aCpos,{|z| alltrim(z[2])=='A1_MUN'})>0)
				aadd(aGrvSa1,{"A1_CODMUN"			,ACHAMUN(ALLTRIM(TRBCLI->A1_ESTE),ALLTRIM(TRBCLI->A1_MUN),ALLTRIM(TRBCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
				aadd(aGrvSa1,{"A1_COD_MUN"			,ACHAMUN(ALLTRIM(TRBCLI->A1_ESTE),ALLTRIM(TRBCLI->A1_MUN),ALLTRIM(TRBCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณanalisa se existe o cliente caso nใo exista crie caso contrario atualizeณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			if ascan(aCpos,{|z| alltrim(z[2])=='A1_CGC'})>0
				DBSELECTAREA("SA1")
				SA1->(DBSETORDER(3))
				IF SA1->(DBSEEK(XFILIAL("SA1")+PADR(TRBCLI->A1_CGC,cPdCpf))) .AND. U_BUSCAEND(ALLTRIM(M->A1_CGC),ALLTRIM(M->A1_END)) == 1
					NOPC	:= 4
					cCodigo	:= SA1->A1_COD
					cLoja	:= SA1->A1_LOJA
					cxFil	:= xfilial("SA1")
					M->A1_FILIAL := xfilial("SA1")
					aadd(aGrvSa1,{"A1_FILIAL",cxFil,nil})
				ELSEIF SA1->(DBSEEK(XFILIAL("SA1")+PADR(TRBCLI->A1_CGC,cPdCpf))) .AND. U_BUSCAEND(ALLTRIM(M->A1_CGC),ALLTRIM(M->A1_END)) == 2
				/*				
					NOPC	:= 3
					cCodigo	:= SA1->A1_COD
					cLoja	:= SOMA1(SA1->A1_LOJA) // SOMA A LOJA ATUAL
					cxFil	:= xfilial("SA1")
					M->A1_FILIAL := xfilial("SA1")
					aadd(aGrvSa1,{"A1_FILIAL",cxFil,nil})
				*/
					
					//Edmar Mendes do Prado - 01/11/2018
					//Verifica se o cadastro do cliente estแ bloqueado para nใo utilizar
					If SA1->A1_MSBLQL == '1'		//1= Inativo
						//Enviar email
						Conout("002 - Cliente com cadastro bloqueado no Protheus: "+cVTex)
						U_EXPMAIL(cErItNgC , "002 - Cliente com cadastro bloqueado no Protheus: " + SA1->A1_COD, " Altere o cadastro " + SA1->A1_COD + " para ser faturado. ")

						//Loop
						TRBCLI->(DBSKIP())
					Else					
						NOPC	:= 3
						cCodigo	:= SA1->A1_COD
						cLoja	:= SA1->A1_LOJA
						cxFil	:= xfilial("SA1")
						M->A1_FILIAL := xfilial("SA1")
						aadd(aGrvSa1,{"A1_FILIAL",cxFil,nil})

						//
						RecLock("SA1",.F.)
							SA1->A1_TEL 		:= TRBCLI->A1_TEL
							SA1->A1_CEPE		:= TRBCLI->A1_CEPE
							SA1->A1_ESTE 		:= TRBCLI->A1_ESTE
							SA1->A1_END 		:= TRBCLI->A1_END 
							SA1->A1_ESTADO		:= TRBCLI->A1_ESTADO
							SA1->A1_EST 		:= TRBCLI->A1_EST
							//SA1->A1_COD_MUN	:= 
							SA1->A1_MUN 		:= TRBCLI->A1_MUN
							SA1->A1_BAIRRO 		:= TRBCLI->A1_BAIRRO 
							SA1->A1_CEP 		:= TRBCLI->A1_CEP
							SA1->A1_DDD 		:= TRBCLI->A1_DDD
							SA1->A1_ENDENT 		:= TRBCLI->A1_ENDENT
							SA1->A1_ENDCOB 		:= TRBCLI->A1_ENDCOB
							SA1->A1_CEPC 		:= TRBCLI->A1_CEPC
							SA1->A1_ESTC 		:= TRBCLI->A1_ESTC
							SA1->A1_MUNC 		:= TRBCLI->A1_MUNC
							SA1->A1_COMPLEM		:= TRBCLI->A1_COMPLEM
							
							If SA1->A1_CODMUN = '99999'
								SA1->A1_EST 		:= "EX"
								SA1->A1_COD_MUN		:= "99999"
								SA1->A1_MUN 		:= "EXTERIOR"
								SA1->A1_ESTADO		:= "EX"
								SA1->A1_TIPO 		:= "X"
								SA1->A1_MUNC 		:= "EXTERIOR"
								SA1->A1_ESTE		:= "EX"
								//SA1->A1_PAIS 		:= ""
							EndIf
							
						MSUnlock()
						//
					EndIf
					
				ELSE
					NOPC	:= 3
					cCodigo := GETSXENUM("SA1","A1_COD")
					CONFIRMSX8()
					cLoja	:= IIF(EMPTY(CRIAVAR("A1_LOJA")),'01',CRIAVAR("A1_LOJA"))
					cxFil	:= xfilial("SA1")
					M->A1_FILIAL := xfilial("SA1")
					aadd(aGrvSa1,{"A1_FILIAL",cxFil,nil})
				ENDIF
			ELSE
				NOPC	:= 3
				cCodigo := GETSXENUM("SA1","A1_COD")
				CONFIRMSX8()
				cLoja	:= IIF(EMPTY(CRIAVAR("A1_LOJA")),'01',CRIAVAR("A1_LOJA"))
				cxFil	:= xfilial("SA1")
				M->A1_FILIAL := xfilial("SA1")
				aadd(aGrvSa1,{"A1_FILIAL",cxFil,nil})
			endif
			IF (nLoc := ascan(aGrvSa1,{|z| alltrim(z[2])=='A1_COD'}) ) > 0
				aGrvSa1[nLoc][2] := cCodigo
			else
				aadd(aGrvSa1,{"A1_COD"			,cCodigo	,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			IF (nLoc := ascan(aGrvSa1,{|z| alltrim(z[2])=='A1_LOJA'}) ) > 0
				aGrvSa1[nLoc][2] := cLoja
			else
				aadd(aGrvSa1,{"A1_LOJA"			,cLoja		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			SX3->(DBSETORDER(2))
			SX3->(DBSEEK("A1_EST"))
			xValid := SX3->X3_VALID
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ""
			MSUNLOCK()
			SX3->(DBSEEK("A1_CONTA"))
			YValid := SX3->X3_VALID
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ""
			MSUNLOCK()
			SX3->(DBSEEK("A1_CODMUN"))
			ZValid := SX3->X3_VALID
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ""
			MSUNLOCK()
			BeginTran()
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณefetua a grava็ใo na matriz para rodar o execautoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			MSEXECAUTO( {|X,Y| MATA030(X,Y) },aGrvSa1,NOPC)

			SX3->(DBSETORDER(2))
			SX3->(DBSEEK("A1_EST"))
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := xValid
			MSUNLOCK()
			SX3->(DBSEEK("A1_CONTA"))
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := YValid
			MSUNLOCK()
			SX3->(DBSEEK("A1_CODMUN"))
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ZValid
			MSUNLOCK()

			IF lMsErroauto
				DisarmTransaction()
				cLogFile := cArqPd+alltrim(TRBCLI->A1_CGC)+".log"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
				aLog := GetAutoGRLog()	                            //efetua o tratamento para validar se o arquivo de log jแ existe
				file(cLogFile)
				ferase(cLogFile)
				ferase(cLogFile)
				If (nHandle := MSFCreate(cLogFile,0)) <> -1
					For nFor2 := 1 to len(aLog)
						FWrite( nHandle,aLog[nFor2]+CRLF)
					next nFor2
					FCLOSE(nHandle)
				EndIf
			else
				EndTran()
				Reclock("TRBCLI",.F.)
				TRBCLI->UXU_PROQUE	:= 1
				MsUnlock()
				cLogFile := cArqPd+alltrim(TRBCLI->A1_CGC)+".log"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
				file(cLogFile)
				ferase(cLogFile)
				ferase(cLogFile)
			endif
		else
			cLogFile := cArqPd+alltrim(TRBCLI->A1_CGC)+".log"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
			file(cLogFile)
				ferase(cLogFile)
				ferase(cLogFile)
		endif
		TRBCLI->(DBSKIP())
	end
elseif nFold == 2
	TRBPED->(DBSETORDER(1))
	IF TRBPED->(DBSEEK(ALLTRIM(cKey)))
		SA1->(DBSETORDER(3))
		SA1->(DBSEEK(XfILIAL("SA1")+TRBPED->A1_CGC))
		lMsErroauto		:= .T.
		lMsHelpAuto		:= .t.
		lautoErrNoFile	:= .T.
		aGrvSC5 	:= {}
		cCliente	:= ""
		aLog		:= {}
		if TRBPED->UXU_PROQUE == 0
			For nFor1 := 1 to LEN(aCposSc5)
				if substr(aCposSc5[nFor1][2],1,3) == 'C5_' .and. alltrim(aCposSc5[nFor1][2]) != 'C5_CONDPAG'
					aadd(aGrvSC5,{aCposSc5[nFor1][2],&("TRBPED->"+aCposSc5[nFor1][2]),nil})
					&("M->"+aCposSc5[nFor1][2]) := &("TRBPED->"+aCposSc5[nFor1][2])
				ELSEIF alltrim(aCposSc5[nFor1][2]) == 'C5_CONDPAG'
					xCond := alltrim(&("TRBPED->"+aCposSc5[nFor1][2]))
					SE4->(DBSETORDER(2))
					IF !SE4->(DBSEEK(XFILIAL("SE4")+xCond))
						SE4->(DBSEEK(XFILIAL("SE4")+"01"))
					Else
						!SE4->(DBSEEK(XFILIAL("SE4")+xCond))
						SE4->(DBSEEK(XFILIAL("SE4")+"02"))
					ENDIF
					aadd(aGrvSC5,{aCposSc5[nFor1][2],SE4->E4_CODIGO ,nil})
					&("M->"+aCposSc5[nFor1][2]) := SE4->E4_CODIGO
				ELSE
					cCliente		:= posicione("SA1",3,xfilial("SA1")+&("TRBPED->"+aCposSc5[nFor1][2]),"A1_COD")
					cLoja			:= SA1->A1_LOJA
					aadd(aGrvSC5,{'C5_CLIENTE',cCliente,nil})
					M->C5_CLIENTE	:= cCliente
					aadd(aGrvSC5,{'C5_LOJACLI',cLoja,nil})
					M->C5_LOJA		:= cLoja
					aadd(aGrvSC5,{'C5_CLIENT',cCliente,nil})
					M->C5_CLIENT	:= cCliente
					aadd(aGrvSC5,{'C5_LOJAENT',cLoja,nil})
					M->C5_LOJAENT	:= cLoja
				ENDIF
			Next nFor1
			aadd(aGrvSC5,{"C5_FILIAL",XFILIAL("SC5"),nil})
			&("M->C5_FILIAL") := XFILIAL("SC5")
			//aadd(aGrvSC5,{"C5_TRANSP",iif(empty(SA1->A1_TRANSP),'08',SA1->A1_TRANSP),nil})
			&("M->C5_TRANSP") := iif(empty(SA1->A1_TRANSP),'08',SA1->A1_TRANSP)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAnalisando se possui o endere็o correto no sistema   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nPosEndTrg		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_ENDTREG" })
			nPosCodCli		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_CLIENTE" })
			nPosCodEnt		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_CLIENT" })
			nPosCodLoj		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_LOJACLI" })
			nPosLojCli		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_LOJAENT" })
			if nPosEndTrg > 0 .and. nPosCodCli > 0
				if !EMPTY(aGrvSC5[nPosEndTrg][2])
					IF U_BUSCAEND(ALLTRIM(SA1->A1_CGC),ALLTRIM(aGrvSC5[nPosEndTrg][2]),ALLTRIM(aGrvSC5[nPosCodCli][2])) == 1
						cCliente		:= SA1->A1_COD
						cLoja			:= SA1->A1_LOJA
						aGrvSC5[nPosCodCli][2] := cCliente
						aGrvSC5[nPosCodEnt][2] := cCliente
						aGrvSC5[nPosCodLoj][2] := cLoja
						aGrvSC5[nPosLojCli][2] := cLoja
						M->C5_CLIENTE	:= cCliente
						M->C5_LOJA		:= cLoja
						M->C5_CLIENT	:= cCliente
						M->C5_LOJAENT	:= cLoja
					ENDIF
				ENDIF
			endif
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณanalisa se existe o pedido  caso nใo exista crie caso contrario atualizeณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			if ascan(aGrvSC5,{|z| alltrim(z[1])=='C5_VTEX'})>0
				DBSELECTAREA("SC5")
				SC5->(DBORDERNICKNAME("VTEX"))
				IF SC5->(DBSEEK(XFILIAL("SC5")+PADR(TRBPED->C5_VTEX,cPdVTex)+cCliente))
					NOPC	:= 4
					cPedido	:= SC5->C5_NUM
				ELSE
					NOPC	:= 3
					xParSC5	:= PADR(getmv("MV_MNLSC5"),TAMSX3("C5_NUM")[1])
					xParSC5	:= GetSC5Num(xParSC5) // analisa se ja existe esse pedido na tabela SC5
					cPedido := xParSC5
				ENDIF
			ELSE
				NOPC	:= 3
				xParSC5	:= PADR(getmv("MV_MNLSC5"),TAMSX3("C5_NUM")[1])
				xParSC5	:= GetSC5Num(xParSC5) // analisa se ja existe esse pedido na tabela SC5
				cPedido := xParSC5
			endif
			IF (nLoc := ascan(aGrvSC5,{|z| alltrim(z[1])=='C5_NUM'}) ) > 0
				aGrvSC5[nLoc][2] := cPedido
			else
				aadd(aGrvSC5,{"C5_NUM"	,cPedido	,nil})
				&("M->"+aGrvSC5[LEN(aGrvSC5)][1]) := aGrvSC5[LEN(aGrvSC5)][2]
			endif
			aItensSC6	:= {}
			nTem		:= 0
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณProcesso para a grava็ใo dos pedidosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			TRBDET->(dbgotop())
			TRBDET->(DBSETORDER(1))
			IF (nLoc := ascan(aGrvSC5,{|z| alltrim(z[1])=='C5_VTEX'}) ) > 0
				cVTex	:= aGrvSC5[nLoc][2]
			else
				cVTex	:= ""
			endif
			TRBDET->(DBSEEK(cVTex))
			while cVTex == TRBDET->C6_VTEX .and. TRBDET->(!eof())
				aGrvSC6 	:= {}
				if TRBDET->UXU_PROQUE == 0
					For nFor1 := 1 to LEN(aCposSc6)
						aadd(aGrvSC6,{aCposSc6[nFor1][2],&("TRBDET->"+aCposSc6[nFor1][2]),nil})
						&("M->"+aCposSc6[nFor1][2]) := &("TRBDET->"+aCposSc6[nFor1][2])
					Next nFor1
					aadd(aGrvSC6,{"C6_FILIAL",XFILIAL("SC6"),nil})
					&("M->C6_FILIAL") := XFILIAL("SC6")
					aadd(aGrvSC6,{"C6_NUM",cPedido,nil})
					&("M->C6_NUM") := cPedido
					aadd(aGrvSC6,{"C6_CLI",M->C5_CLIENTE,nil})
					&("M->C6_CLI") := M->C5_CLIENTE
					aadd(aGrvSC6,{"C6_LOJA",M->C5_LOJA,nil})
					&("M->C6_LOJA") := M->C5_LOJA

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณRegra para saber se o Produto possui no sistema para permitir a inclusใo e a altera็ใo do status do pedido na Vtexณ
					//ณa opcใo .F. quer dizer que nใo existe o produto no sistema e nใo deve gravar e nem alterar o status do pedido     ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					nProd 		:= ascan(aGrvSC6,{|x| alltrim(x[1]) == "C6_PRODUTO"})
					nPrdVtex	:= ascan(aGrvSC6,{|x| alltrim(x[1]) == "C6_PRDVTEX"})
					nTem		:= ascan(aGrvSC6,{|x| alltrim(x[1]) == "C6_CODISS"})
					if  nTem > 0 .and. !empty(aGrvSC6[nTem][2])
						aadd(aGrvSC5,{'C5_INCISS',"S",nil})
					endif
					if nProd > 0 .AND. (EMPTY(aGrvSC6[nProd][2]) .or. posicione("SB1",1,xFilial("SB1")+ALLTRIM(aGrvSC6[nProd][2]),"ALLTRIM(B1_COD)")!=ALLTRIM(aGrvSC6[nProd][2]))
						lPedOk	:= .F.
						cLogFile := cArqPd+alltrim(TRBPED->C5_VTEX)+".LOG"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
						file(cLogFile)
						ferase(cLogFile)
						ferase(cLogFile)
						If !File(cLogFile)
							If (nHandle := MSFCreate(cLogFile,0)) <> -1
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido nใo possui amarra็ใo no Protheus, por favor verificar o codigo do produto Vtex no protheus: "+iif(nPrdVtex>0,ALLTRIM(aGrvSC6[nPrdVtex][2]),'')+CRLF)
								FCLOSE(nHandle)
							EndIf
						Else
							If (nHandle := FOpen(cLogFile,2)) <> -1
								FSeek(nHandle,0,2)
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido nใo possui amarra็ใo no Protheus, por favor verificar o codigo do produto Vtex no protheus: "+iif(nPrdVtex>0,ALLTRIM(aGrvSC6[nPrdVtex][2]),'')+CRLF)
								FCLOSE(nHandle)
							EndIf
						EndIf
					elseif nProd == 0
						lPedOk	:= .F.
						cLogFile := cArqPd+alltrim(TRBPED->C5_VTEX)+".LOG"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
						file(cLogFile)
						ferase(cLogFile)
						ferase(cLogFile)
						If !File(cLogFile)
							If (nHandle := MSFCreate(cLogFile,0)) <> -1
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" O campo codigo do produto nใo esta no de-para do protheus, por favor cadastrar no DE-PARA: "+CRLF)
								FCLOSE(nHandle)
							EndIf
						Else
							If (nHandle := FOpen(cLogFile,2)) <> -1
								FSeek(nHandle,0,2)
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" O campo codigo do produto nใo esta no de-para do protheus, por favor cadastrar no DE-PARA: "+CRLF)
								FCLOSE(nHandle)
							EndIf
						EndIf
					endif
					AADD(aItensSC6,ACLONE(aGrvSC6))
				ENDIF
				TRBDET->(DBSKIP())
			END

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณefetua a grava็ใo na matriz para rodar o execautoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//MSExecAuto({|x,y,z| Mata410(x,y,z)},aGrvSC5,aItensSC6,NOPC)

			if lPedOk
				U_grvPed(aGrvSC5,aItensSC6,NOPC,cVTex,"TRBPED","TRBDET")
			endif

			IF lMsErroauto
				cLogFile := cArqPd+alltrim(TRBPED->C5_VTEX)+".LOG"					//fun็ใo que retorna as informa็๕es de erro ocorridos durante o processo da rotina automแtica
				aLog := GetAutoGRLog()
				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						For nFor2 := 1 to len(aLog)
							FWrite( nHandle,aLog[nFor2]+CRLF)
						next nFor2
						FCLOSE(nHandle)
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						For nFor2 := 1 to len(aLog)
							FWrite( nHandle,aLog[nFor2]+CRLF)
						next nFor2
						FCLOSE(nHandle)
					EndIf
				EndIf
			else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณGera o titulo Antecipado para o Financeiro efetuar a concilia็ใoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				//GerRA(cArqPd+cNomArq+".LOG")
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFim da Gera็ใo do Titulo RAณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				CONFIRMSX8()
				Reclock("TRBPED",.F.)
				TRBPED->UXU_PROQUE	:= 1
				MsUnlock()
				TRBDET->(dbgotop())
				TRBDET->(DBSEEK(cVTex))
				while cVTex == TRBDET->C6_VTEX .and. TRBDET->(!eof())
					Reclock("TRBDET",.F.)
					TRBDET->UXU_PROQUE	:= 1
					MsUnlock()
					TRBDET->(DBSKIP())
				END
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณApos processamento com sucesso altera o status do pedido no vtex para nใo pegar ele novamenteณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				//if lPedOk
				//	u_AltPed(alltrim(TRBPED->C5_VTEX))
				//endif
			endif
			lPedOk := .T.
		endif
		TRBPED->(DBSKIP())
	end
endif
oDBTree:PTRefresh()
return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATuEcho   บAutor  ณLeandro Duarte      บ Data ณ  07/15/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para atualiza็ใo da Enchoice conforme sele็ใo do usuaบฑฑ
ฑฑบ          ณrio                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ATuEcho(oObj,cKey,oDlg,oEnch1,oEnch2)
Local cDescr	:= iif(valtype(OOBJ:GetPrompt())<> "U",OOBJ:GetPrompt(),"")
Local cProduto	:= padr(substr(cDescr,10,tamsx3("C6_PRODUTO")[1]),tamsx3("C6_PRODUTO")[1])
IF !EMPTY(cDescr)
	TRBPED->(DBSETORDER(1))
	IF TRBPED->(DBSEEK(ALLTRIM(cKey)))
		SA1->(DBSETORDER(3))
		IF SA1->(DBSEEK(XfILIAL("SA1")+TRBPED->A1_CGC))
			M->C5_CLIENTE	:= SA1->A1_COD
			M->C5_LOJA		:= SA1->A1_LOJA
		ELSE
			M->C5_CLIENTE	:= "   "
			M->C5_LOJA		:= "  "
		ENDIF
		RegToMemory("TRBPED", .F., .F.)
		TRBDET->(DBSETORDER(1))
		if TRBDET->(DBSEEK(cKey+cProduto))
			RegToMemory("TRBDET", .F., .F.)
			oDlg:refresh()
			oFolder:aDialogs[2]:refresh()
			oEnch1:EnchRefreshAll()
			oEnch1:Refresh()
			oEnch2:EnchRefreshAll()
			oEnch2:Refresh()
		ENDIF
		BusqSCE(cKey)
	ENDIF
ENDIF
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusqSCE   บAutor  ณLeandro Duarte      บ Data ณ  01/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para cpturar o arquivo e ler o mesmo para jogar na   บฑฑ
ฑฑบ          ณvariavel do erro do Pedido                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BusqSCE(cKey)
Local cNomeArq	:= alltrim(cKey)+'.log'
Local cArqTxt := "/imp_vtex/" +cNomeArq
Local cLinha	:= ""
Local aMemo		:= {}
Local nF		:= 0
cMultiGe2 := ""

if file(cArqTxt)
	FT_FUse(cArqTxt)
	FT_FGoTop()
	FT_FGoTop()
	While !FT_FEof()
		cLinha	:= FT_FReadLn()
		aadd(aMemo,cLinha)
		FT_FSkip()
	EndDo
	FT_FUSE()
	for nF := len(aMemo) to 1 step -1
		cMultiGe2 += aMemo[nf]+CRLF
		if LEN(cMultiGe2) > 48884
			nF := 0
		endif
	next nf
elseIF TRBDET->UXU_PROQUE == 1
	cMultiGe2 := "Produto Processado com Sucesso!"
else
	cMultiGe2 := "Produto aguardando para ser Processado!"
endif

oMultiGe2:refresh()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMod2HeaderบAutor  ณLeandro Duarte      บ Data ณ  02/20/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para trazer o aheader preenchido                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Mod2Header( cAlias )
Local aArea := GetArea()
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		AADD( aHeader, { Trim( X3Titulo() ),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,;
		X3_DECIMAL,;
		".T.",;
		X3_USADO,;
		X3_TIPO,;
		X3_ARQUIVO,;
		X3_CONTEXT})
	Endif
	dbSkip()
End
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMod2COLS  บAutor  ณLeandro Duarte      บ Data ณ  02/20/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para alimentar o Acols da rotina                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Mod2COLS( cAlias, nReg, nOpc, cKey, cProduto )
Local aArea := GetArea()
Local nI := 0
Local nTamVt := tamsx3("C6_VTEX")[1]
Local aStrc	:= TRBDET->(DBSTRUCT())
If nOpc <> 3
	TRBDET->(DBSETORDER(1))
	TRBDET->(DBSEEK(cKey))
	While TRBDET->(!EOF()) .And. TRBDET->( C6_VTEX ) == substr(cKey,1,nTamVt)
		AADD( aREG, TRBDET->( RecNo() ) )
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			ElseIF ASCAN(aStrc,{|X| ALLTRIM(X[1]) == ALLTRIM(aHeader[nI,2]) }) > 0
				aCOLS[Len(aCOLS),nI] := &("TRBDET->"+aHeader[nI,2])
			ELSE
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Endif
			if aCOLS[Len(aCOLS),nI] == nil
				aCOLS[Len(aCOLS),nI] := iif(aHeader[nI,8]=='N',0,iif(aHeader[nI,8]=='D',STOD(' '),iif(aHeader[nI,8]=='L',.T.," ")))
			endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		TRBDET->(dbSkip())
	End
Else
	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[1, Len( aHeader )+1 ] := .F.
Endif
Restarea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExtruc    บAutor  ณLeandro Duarte      บ Data ณ  02/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para gerar a estrutura de trabalho                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Extruc(cNomEstr)
Local aStr	:= {}
UA1->(dbsetorder(1))
if UA1->(DBSEEK(XFILIAL("UA1")+cNomEstr))
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aadd(aStr,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL,nil})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aStr[LEN(aStr)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		aStr[LEN(aStr)][3] := tamsx3(aStr[LEN(aStr)][2])[3]
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
	END
endif
Return(aStr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetSC5Num บAutor  ณLeandro Duarte      บ Data ณ  12/16/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLista se esse pedido ja existe na base de dados, caso existaบฑฑ
ฑฑบ          ณsomar mais um e aliemntar o parametro                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetSC5Num(xParSC5)
Local cQuery := " "
Private xnumsc5 := xParSC5
Private lRoda	:= .T.

while lRoda
	cQuery := " SELECT COUNT(*) AS QTD FROM "+RETSQLNAME("SC5")+ " A WHERE A.C5_NUM = '"+xnumsc5+"' AND A.D_E_L_E_T_ = ' ' AND A.C5_FILIAL = '"+xFilial("SC5")+"' "
	IiF(SELECT("GETSC5")>0,GETSC5->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC5", .T., .T.)
	IF GETSC5->QTD <= 0
		lRoda := .f.
		PUTMV("MV_MNLSC5", xnumsc5)
		RETURN(xnumsc5)
	ENDIF
	xnumsc5 := SOMA1(xnumsc5)
END
Return(xnumsc5)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPVTX    บAutor  ณLeandro Duarte      บ Data ณ  03/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para importar os pedidos que o job ainda nใo importouบฑฑ
ฑฑบ          ณe gravar a area de uso da tabela                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P12                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPVTX()
Local aRetTRB := TRBCLI->(Getarea())
u_MNPdPerd()
UA1->(DBSETORDER(3))
UA1->(DBSEEK(XFILIAL("UA1")+'1'+'1'))
cVelhoArq := u_Velhoarq('1')
if !empty(cVelhoArq)
	iif(SELECT("TRBCLI")>0,TRBCLI->(DbCloseArea()),nil)
	dbUseArea(.T.,,cVelhoArq,"TRBCLI", .T., .F. )
	while !(select("TRBCLI")>0)
		dbUseArea(.T.,,cVelhoArq,"TRBCLI", .T., .F. )
	end
	cIndCon3 := "A1_CGC"
	IndRegua("TRBCLI",cArqNtx3,cIndCon3,,,"Selecionando Registros...")
	dbselectarea("TRBCLI")
	dbSetIndex(cArqNtx3 + OrdBagExt())
	dbselectarea("TRBCLI")
	TRBCLI->(dbgotop())
	TRBCLI->(DBSETORDER(1))
endif
Restarea(aRetTRB)
Return()