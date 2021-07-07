/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNWQUERY   บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบADAPTAวรO DO MPSDU E NDIQUERY (FSW-TOTVS)                              บฑฑ
ฑฑบREPITO MUITAS VEZES... CUIDADO AO USAR !!!      			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//                      CUIDADO !!!!!!
//
// ESTE PROGRAMA NรO RECEBE TRADUCAO PELAS STATICS DO CH, UMA VEZ QUE ELE ษ CARREGADO ANTES
// DO PAISLOC TER SIDO CONFIGURADO CORRETAMENTE
//
//
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBTREE.CH"    
#Include "PanelOnLine.ch"
#Include "style.ch"
#INCLUDE "FWFILTER.CH"

#define MDITOP 13
#define CLR_BACKGROUND RGB(123,161,202)
#define CLR_BACKLOGIX  RGB(232,239,247)
#define CLR_LINE       RGB(192,192,192)
#define CLR_LIGHTBLUE  RGB(217,235,255)
#define CLR_DARKBLUE   RGB(21,92,158)
#define CLR_TTVWHTBLUE RGB(235,238,247)
#define CLR_TTVBLUEWCL RGB(160,183,237)

Static aAlias := {}, aFiles := {}
Static lBreakError := .F.
static __lLicense	:= .T.
static __cFilAnt	:= 'xx'
Static __aSetKey	:= {.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.}
Static __cWalkAlias := ""
Static __aPGThreads := {}
Static __aModulos
Static __aMenuUser  := {}, __cOldMsgBar, __lShowKeys
Static __aFindAcsCut, __aMenuAcsCut

CLASS MsApp1

	METHOD New( cModule, lIsBlind, lIsOffice ) CONSTRUCTOR
	METHOD CreateEnv( lRpoUpdate)
	METHOD RunApp()
	METHOD LoadMenu( cMenu, lDummy )
	METHOD MRULoad()
	METHOD MRUShow()
	METHOD MRUChgLabel()
	METHOD MRUSave()
	METHOD MRUAdd()
	METHOD MRUClose()
	METHOD FlatApp()
	METHOD SkinP10App()

	METHOD MDIRunApp()
	METHOD MDIAddMRU()
	METHOD MDICfgMRU()
	METHOD MDICfgCUT()
	
	METHOD SignOnSave()
	
	DATA cPar01
	DATA cPar02
	DATA cVersion
	DATA cInternet
	DATA cModDesc
	DATA cModName
	DATA cModulo 
	DATA cEmpAnt
	DATA cNumEmp
	DATA cFOpened
	DATA cUsuario
	DATA cLanguage
	DATA cStartProg				// usado para inicializar um programa sem menu.
	DATA cUserId
	DATA cUserName
	DATA cUsrExtName
	DATA cArqTab
	
	DATA nModulo
	DATA nMDIModulo
	
	DATA dDataBase
	
	DATA oMainWnd
	DATA oFlatWnd
	DATA oPanelCUT
	DATA oPanelMRU
		
	DATA bMainInit
	DATA bAppStart
	DATA bAppInit
	
	DATA lIsBlind
	DATA lMenu
	DATA lShortCut
	DATA lMenuBmp
	DATA lMessageBar
	DATA lIBrowser
	DATA lCanChangeTheme 
	DATA lMainToolBar
	DATA lFlat
	DATA lLogix
	DATA lTotvs
	DATA lTouch

	DATA aMRU
	DATA aCUT
	DATA aShortCuts
	DATA aMenu
	DATA aMenuRun

	//propriedades utilizadas qdo executado via MDI
	DATA lMDI
	DATA lMDIMenuInfo
	
	DATA bMDILogOff
	
	DATA cMDIEmpFil
	
	DATA aMDIEmpFil

	DATA oMDIMenu
	DATA oMDICUT
	DATA oMDIMRU
	DATA oMDIFolder
	DATA oMDICombo
	DATA oMDILogo
	DATA oMDIMenuInfo
	DATA oMDIRun
	DATA oPMDIRun
	
	// Office TOII
	DATA lIsOfficeApp
	DATA lGoEmpFil	// SINGLESIGNON
	
	// Interface 912
	/*DATA oMDStMenu
	DATA oMenuTop
	DATA oOptGrp // Panel utilizado para os botoes dos subitens do menu*/
	
	
	DATA oPFWMenu
	DATA oPShortCut // menudef
	DATA oFWMenuP10
	DATA oSearch
	DATA oPHome
	DATA oPWorkFolder
	DATA oPPgOL
	DATA oWSOnLine
	DATA oPMenuDef
	DATA oSplitOpen
	DATA oSplitClose
	DATA oFontLabel
	DATA oFontOption
	DATA oCancel

	DATA Cargo
	
	DATA cSearch
	DATA oEventViewer // Objeto do EventViewer
	
ENDCLASS

// ------------------------------------------------------

METHOD New( cModule, lIsBlind, lIsOffice ) CLASS MsApp1
Local aRetMod 		:= {}
Local nPos		:= 0
DEFAULT lIsOffice := .F.

Public cPaisLoc := GetPvProfString(GetEnvServer(),"REGIONALLANGUAGE","BRA",GetAdv97())

aRetMod 		:= RetModName()
::lIsOfficeApp	:= lIsOffice

If ( ValType(lIsBlind) != 'L' )
	::lIsBlind := .F.
Else
	::lIsBlind := lIsBlind
	
	If ( lIsBlind )
        ::cInternet := 'AUTOMATICO'
	EndIf
	
EndIf

If ( ValType( cModule ) != 'C' )
	cModule := 'SIGAFAT'
EndIf

cModName := Upper( cModule )
::lMDI := .F.
::lFlat := .F.
::lLogix := IsLogix()
::lTotvs := IsTotvs()                                                                  
::lGoEmpFil := .F. // SINGLESIGNON
::lTouch := .F.

If ::lLogix
	__xchghcons({{"Protheus","Logix"},{"Microsiga","Logocenter"}})
EndIf

If ::lTotvs
	__xchghcons({{"Protheus","Totvs"},{"Microsiga","Totvs"},{"FW Totvs","FW Microsiga"}})
EndIf

If cModule == "SIGAMDI"
	::lShortCut := .T.
	::lMDI := .T.
	::lFlat := .T.
	::cModulo	:= "MDI"
	::nModulo	:= 99
	::nMDIModulo:= 99
	::cModDesc	:= "Multi Processo"	//
	::cModName	:= cModule	
ElseIf ( cModule == 'SIGACFG' )
	::cModulo	:= 'CFG'
	::nModulo	:= 99
	::cModDesc	:= "Multi Processo"
	::cModName	:= cModule
Else
	
	nPos := Ascan( aRetMod,{|x| x[2] == cModule })
	
	If ( nPos == 0 )
		nPos := Ascan( aRetMod,{|x| x[2] == 'SIGAFAT' })		
	EndIf
	
	::cModulo	:= Subs( cModName, 5, 3 )
	::nModulo	:= aRetMod[nPos][1]
	::cModDesc	:= aRetMod[nPos][3]
	::cModName	:= cModule

	
	If ::nModulo == 98
		::cModulo := "ESP1" 
	ElseIf ::nModulo == 96
		::cModulo := "ESP2"
	EndIf
EndIf

::cPar01		:= ''
::cPar02		:= ''
::aMRU			:= {}
::aCUT			:= {}
::aShortCuts	:= {}
::cVersion		:= GetVersao()
::dDataBase		:= Date()
::cEmpAnt		:= ''
::cNumEmp		:= ''
::cFOpened		:= 'SX5'
::cUsuario		:= ''
::cStartProg	:= ''
::cArqTab		:= ''
::cUserId		:= ''
::lMenu			:= .T.
::lShortCut 	:= .T.
::lMenuBmp  	:= .T.
::lMessageBar 	:= .T.
::lIBrowser		:= .T.
::lCanChangeTheme := .F.
::lMainToolBar  := .T.
::lMDIMenuInfo	:= .F.
::cUserName		:= ''
::cSearch       :=  Padr("Digite aqui sua busca", 200)  //Digite aqui sua busca

::bMainInit	:= NIL
::bAppStart := NIL
::bAppInit := NIL

#ifdef SPANISH
	::cLanguage := 'SPANISH'
#else
	#ifdef ENGLISH
		::cLanguage := 'ENGLISH'
	#else
		::cLanguage	:= 'PORTUGUESE'
	#endif
#endif

If ( GetRemoteType() == 2 )
	::oFontLabel := TFont():New( "Helvetica", , 12,,.T.,,, )
	::oFontOption := TFont():New( "Helvetica", , 12,,.F.,,, )
Else
	::oFontLabel := TFont():New( "FW Microsiga", , 10,,.T.,,,4 )
	::oFontOption := TFont():New( "FW MIcrosiga", , 10,,.F.,,,4 )
EndIf

Public oApp
oApp := Self

//RMVTmpFiles()

If !IsBlind() .And. !ValidPswFile()
	Final("Arquivo SIGAADV.PSS invalido")	//
EndIf

Return                                     

METHOD CreateEnv( lRpoUpdate ) CLASS MsApp1

Public _NomeExec 	:= ::cModName + '.EXE'
Public aAmbientes	:= {}							// Ambientes do Usuario
Public uSigaADV		:= .F.                  // Provisoria !!!!
Public nCampos		:= 200				// Numero de campos no help
Public cArqTel		:= ::cModName + '.SCR'      // Nome do arquivo de telas
Public cArqRel		:= ::cModName + '.REL'      // Nome do arquivo de Relatorios
Public cArqMnu		:= ::cModName + RetExtMnu()  // Nome do arquivo de Menu
Public cArqHlp		:= "SIGAHLP" + RetExtHlp()  // Nome do arquivo de HELP
Public cArqPsw		:= "SIGAMAT.PSW"      // Nome do arquivo de senhas
Public cArqEmp		:= "SIGAMAT.EMP"      // Nome do arquivo de Empresas/Filiais
Public cArqAlc		:= "SIGAMAT.ALC"      // Nome do arquivo de Alcadas
Public calc   		:= .F.					// Calculadora ja/nao ativa
Public agen			:= .F.					// Agenda ja/ano ativa
Public help			:= .F.					// Help ja/nao ativo
Public lInUtil	 	:= .F.
Public f_ASK 	 	:= "askfor"         // Nome da rotina de perguntas p/MENUH
Public Have_a_Mouse	:= .F.				// Se existe um mouse instalado
Public cAcesso		:= Replicate("S",128) // Nivel de Acesso (SENHA)
Public cEmpAut		:= ""                 // Empresas Autorizadas
Public cArqTab		:= ""
Public cMestra		:= Replicate("*",6)
Public cSenha		:= Replicate("*",6)
Public cFuncao		:= "GetEmpr"
Public MouseRet		:= ""                 //mudado Retorno do Mouse
Public aMenus		:= aEmpresas:={}
Public tInicio		:= TIME() 				// Hora de Inicio
Public D_String		:= "ACRM"             // Letras para selecao do menu
Public nOpc0		:= 1
Public cNomEmp		:= SPACE(15)
Public cNomFil		:= SPACE(15)
Public nCodEmp		:= 1
Public nPosMnu		:= 0
Public cUsuario		:= ""
Public cNivel		:= 9
Public lTes			:= .T. 					// para cadastro do Tes
Public AcBrowse
Public a_FILES[0]
Public aTrigger		:= {}				// para controle de gatilhos
Public __cInterNet
Public __cBinder	:= NIL
Public __cTerminal	:= NIL
Public MV_RELT,MV_CENT,MV_MILHAR,MV_SIMB1,MV_SIMB2,MV_SIMB3,MV_SIMB4,MV_SIMB5

// Variaveis globais

Public cModulo
Public nModulo
Public oMainWnd		
Public dDataBase
Public cEmpAnt
Public cNumEmp
Public cFilAnt
Public cVersao
Public cFOpened
Public cUserName
Public __cUserID	:= ''
Public __lLogOff := .F.

DEFAULT lRpoUpdate := .F.    

If cFilAnt == NIL
	VarSetGet( 'cFilAnt', { |x| ChkTopFil(x) }, .T. )
EndIf

VarRef('cModulo'	, 'oApp:cModulo' )
VarRef('nModulo'	, 'oApp:nModulo' )
VarRef('dDataBase'	, 'oApp:dDataBase' )
VarRef('cEmpAnt'	, 'oApp:cEmpAnt' )
VarRef('cNumEmp'	, 'oApp:cNumEmp' )
VarRef('cVersao'	, 'oApp:cVersion' )
VarRef('cFOpened'	, 'oApp:cFOpened' )
VarRef('cUsuario'	, 'oApp:cUsuario' )
VarRef('__cInternet', 'oApp:cInternet' )
VarRef('cUserName'  , 'oApp:cUserName' )
VarRef('cArqTab'  	, 'oApp:cArqTab' )
VarRef('__cUserID'	, 'oApp:cUserID' )

// Mantidas por compatibilidade

Public AdvFont
Public cStrAcesso:=""

#ifdef SHELL
	Public aRegRev	:= {}
	Public CARQREV	:= 'SIGAMAT.REV'
#endif

*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*ณChamada para Binder																	ณ
*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IF Valtype(::cInternet) == "C"
	If ( Empty(::cInternet) )
		::cInternet := NIL
	ElseIf PswIsSession(::cInternet)
		__cBinder := ::cInternet
		__cInternet := nil
	Endif
Endif

SetsDefault()

CriaPublica()

Return
     

// ------------------------------------------------------

METHOD MDIRunApp() CLASS MsApp1

Local oLoginPanel
Local oMainPanel
Local oTPanel
Local oMPanel
Local oBPanel
Local oOwnerMBar
Local oPLogin
Local oPEnv
Local oEnter
Local oCancel
Local oOk

Local oUser

Local oPassword

Local oData2
Local oData4
Local oEmpFil
Local oAmb

Local cUser 	:= Space(25)
Local cPassword := Space(20)
Local cEmpFil 	:= ""
Local cAmb 		:= ""

Local bEnter
Local bCancel
Local bOk
Local bDtVld

Local aEmpFil 	:= {}
Local aAmb 		:= {{},{}}
Local aScreen   := GetScreenRes()
Local lLogin := .T.

Local nI
Local lHasPgOnl := .F.
Local aPOnLine := Array(3) // oPShowPO
Local bLogOff := {|| MDIRpoUpdate(), If( MDILogOff(), (Eval(oApp:oSplitOpen:bLClicked), oApp:oPMenuDef:Hide(), oApp:oPPgOL:Show(), oApp:oMainWnd:oMsgBar:Hide(), oApp:MRUSave(.T.,.T.)),)}
Local oPSign
Local oEnterSign
Local bEnterSign
Local oBackSign 
Local oPUser 
Local cPUser := Space(25)
Local oSOUser 
Local cSOUser := Space(25)
Local oDNS 
Local cDNS := Space(20)
Local oChkSingOn
Local lChkSignOn := .F.

Local cSSProthID := ''
Local aGoEmpFil
Local aConfig := aConfig()
Local cPyme := GetPvProfString('General', 'Pyme', '0', GetAdv97() ) 
Local cLogoLogin := ""
Local lFinal := .f.
Local lRpoUpdate := .F.
Local cVar 
Local lLogOff := .F.
	
Private __lPyme						//utilizado pela funcao XNULoad e EmprOk
Private dDataBase := ::dDataBase	//utilizado pela funcao ValidAut e EmprOk
Private cModulo := ::cModulo		//utilizado pela funcao AdvAbout
Private nModulo := ::nModulo		//utilizado pela funcao EmprOk
Private cArqEmp := "SIGAMAT.EMP"	//utilizado pela funcao OpenSM0
Private help := .F.					//utilizado pela funcao Help
Private cAcesso := ""				//utilizado pela funcao VerSenha
Private __NUSERACS := 0				//utilizado pela funcao NUSERACS
Private __cUserID := ""				//utilizado pela funcao NUSERACS e WF_MSGSTT
Private cEmpAnt := ""				//utilizado pela funcao WF_MSGSTT
Private cFilAnt := ""				//utilizado pela funcao WF_MSGSTT
Private cUsuario := ""				//utilizado pela funcao WF_MSGSTT
Private __ALTPSW := .F.				//utilizado pela funcao GetNewPass

Public aMsgItem := {}

If !::lMDI
	Return
EndIf

If aConfig[20]
	cSSProthID := SSIsAssociate()
EndIf

PtInternal(1,"Emp :/ Logged : Obj : MDI Window")

VarRef('dDataBase','oApp:dDataBase')

SetMDI(.T.)
PtSetTheme("MDI")
//SetFlatControls(.T.)
SetsDefault()
HlpTxt2SPF()
UpdateRemote()			// Sincroniza็ใo de Arquivos da Pasta REMOTE

SET KEY VK_F1 TO Helprog()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seta a tecla SHIFT-F6 de auxilio a URA                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !IsBlind() .And. FindFunction("HDMAPAURA") .And. PadR(GetBuild(),12) >=  "7.00.080806P"
	SetKEY(-15,{|| HdMapaUra()})
EndIf

If IsPlugin() .and. aScreen[2] <= 600
	lPlugin := .T.
EndIf

If HasPswSize()
	cUser 	  := Space(255)
	cPassword := Space(255)
EndIf

// Hablita cria็ใo do painel de gestใo
#IFDEF TOP
	lHasPgOnl := .T.
#ENDIF
     
DEFINE WINDOW ::oMainWnd FROM 01,01 TO 22,75 TITLE "Protheus 10 - " + ::cModDesc COLOR CLR_BLACK,CLR_WHITE
::oMainWnd:ReadClientCoors()

// -----------------------------------------------
// Tela de Principal
@ 000,000 MSPANEL oMainPanel PROMPT '' SIZE 000,000
oMainPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 000,000 MSPANEL oTPanel PROMPT '' SIZE 100,026 OF oMainPanel
	oTPanel:Align := CONTROL_ALIGN_TOP
	LoadTPanel( oTPanel, @oOwnerMBar, @::oSearch, @::cSearch, bLogOff)
	@ 000,000 MSPANEL oMPanel PROMPT '' SIZE 000,000 OF oMainPanel
	oMPanel:Align := CONTROL_ALIGN_ALLCLIENT
	LoadMPanel( oMPanel, @::oPFWMenu, @::oMDIRun, @::oPShortCut, @::oPWorkFolder, @::oPPgOL, @::oPMenuDef, @::oPHome, @::oSplitClose, @::oSplitOpen, lHasPgOnl, @aPOnLine )

// -----------------------------------------------	
// Tela de Login
@ 000,000 MSPANEL oLoginPanel PROMPT '' SIZE 000,000
oLoginPanel:Align := CONTROL_ALIGN_ALLCLIENT

bEnter 	:= {|| If(MDIPassword(@cUser,cPassword,aEmpFil,aAmb),;
				(If(!lChkSignOn,(If(__SetCentury(),(oData4:Show(),oData2:Hide()),(oData2:Show(),oData4:Hide())),;
				If(Versenha(36),(oData2:Enable(),oData4:Enable()),(oData2:Disable(),oData4:Disable())),;
				oEmpFil:SetItems(aEmpFil[1]),oAmb:SetItems(aAmb[1]),;
				oApp:oCancel:Disable(), ::lMDIMenuInfo := MDIMenuInfo(cUser),::lGoEmpFil := MDIGoEmpFil(cUser), If(::lGoEmpFil, If(!Empty(MDIModDesc(cUser)), cAmb := MDIModDesc(cUser), ),), MDISetPanel(oPLogin,oPLogin,oPEnv,oPEnv)),;
				MDISetPanel(oPLogin,oPSign,oPSign,oPSign))),) } //oSayUser:SetText(Space(3)+cUser),MDISetPanel(oPanel1,oPanel2,oBmpFaixa1,oBmpFaixa2)),) }
bCancel := {|| ::oMainWnd:End()}
				
bOk 	:= {|lExistPGOnl| If ( ValidCpos(cEmpFil,cAmb),(If(lLogin,If(SenhApLog(cUser,cPassword,::cUserID) .And. VldUserGrp(aAmb[2][oAmb:nAt][1],aEmpFil[2][oEmpFil:nAt]),;
				(cPassword := Replicate("*",6),lLogin := .F.,;
				MDILogin(cUser,oAmb:nAt,aAmb,oEmpFil:nAt,aEmpFil), SetMenuUser(aAmb),;
				OpenSX6(), Iif(Select("SX6")>0,cPaisLoc := 'BRA',), lExistPGOnl:=ExistPGOnl(__cUserId),;
				If(lHasPgOnl .And. lExistPGOnl,If(__cUserId=="000000",aPOnLine[1]:Hide(),aPOnLine[1]:Show()),),oLoginPanel:Hide(), oMainPanel:Show(), ::oMainWnd:oMsgBar:Show(),;
				aMsgItem[1]:SetText(cEmpFil),aMsgItem[2]:SetText(dDataBase),aMsgItem[3]:SetText(Rtrim(cUser)),;
				PtInternal(1,"Emp :"+Subs(oApp:cMDIEmpFil,1,2)+"/"+Subs(oApp:cMDIEmpFil,3)+" Logged :"+Padr(cUser, 25)+ " " + Padr(cModulo,9) + " Obj : MDI Window"),;
				BuildMenuBar( oOwnerMBar, @::oPFWMenu, ::cModName, @::oFWMenuP10, ::oPPgOL, ::oPMenuDef, .T., aAmb,aPOnLine, lExistPGOnl),::oMDIRun:Enable(),::oSearch:Enable()),),)),)}

bDtVld	:= {|| If(dDataBase <> MsDate(),(__DTVldRange(dDataBase) .and. (!HasPswDate() .or. ExPswDate(dDataBase,__CUSERID))),.T.)}

bEnterSign	:= {|| If(SSGravaUser(::cUserId, cDNS, cSOUser),;
				(If(__SetCentury(),(oData4:Show(),oData2:Hide()),(oData2:Show(),oData4:Hide())),;
				If(Versenha(36),(oData2:Enable(),oData4:Enable()),(oData2:Disable(),oData4:Disable())),;
				oEmpFil:SetItems(aEmpFil[1]),oAmb:SetItems(aAmb[1]),::lMDIMenuInfo := MDIMenuInfo(cUser),;
				::lGoEmpFil := MDIGoEmpFil(cUser),MDISetPanel(oPLogin,oPLogin,oPEnv,oPEnv)),)}

LoginP9( oLoginPanel, @oPLogin, @oPEnv, @::oSearch, @oData2, @oData4, @dDataBase, @oUser, @cUser, @oPassword, @cPassword, oEnter,;
		 bEnter, oCancel, bCancel, oOk, bOk, @oEmpFil, @cEmpFil, @oAmb, @cAmb, bDtVld, @::lMDIMenuInfo,,@oPSign, oEnterSign,;
		 bEnterSign,oBackSign,@oPUser, @cPUser,@oSOUser, @cSOUser,@oDNS, @cDNS, @oChkSingOn,@lChkSignOn, @::lGoEmpFil, @cssProthID,;
		 @::oMainWnd, @aAmb, @aEmpFil, ::lTouch)

// -----------------------------------------------
// WorkSpace Painel Online
::oWSOnLine := TWorkspaceFolder():New(::oPPgOL,00,00,300,300,.F.)
::oWSOnLine:Align := CONTROL_ALIGN_ALLCLIENT

// -----------------------------------------------
// WorkSpace
::oMDIFolder := TWorkspaceFolder():New(::oPWorkFolder,00,00,300,300)
::oMDIFolder:Align := CONTROL_ALIGN_ALLCLIENT
::oMDIFolder:Hide()
//::oMDIFolder:SetCSS("#STYLE0002")

/*::bMDILogOff := {|| ::MRUSave(.T.,.T.),lLogin := .T.,cUser := Space(15),cPassword := Space(6),oUser:Refresh(),oPassword:Refresh(),;
					oAmb:nAt := 1,oEmpFil:nAt := 1,::oMDIFolder:Cargo := {},If(::lMDI,Nil,MDISetPanel(oPanel2,oPanel1,oBmpFaixa2,oBmpFaixa1)),::oMDICombo:Hide(),::oMDIRun:Hide(),;
					::oMDILogo:Hide(),::oMDIMenu:Disable(),oMainPanel:Hide(),::oMainWnd:oMsgBar:Hide(),oLoginPanel:Show()}*/
::bMDILogOff := {|| lLogin := .T., lLogOff := .T., cUser := Space(25),cPassword := Space(20),oUser:Refresh(),oPassword:Refresh(),;
					oAmb:nAt := 1,oEmpFil:nAt := 1,::oMDIFolder:Cargo := {},If(::lMDI,Nil,MDISetPanel(oPanel2,oPanel1,oBmpFaixa2,oBmpFaixa1)),;
					::oFWMenuP10:Reset(), oLoginPanel:Show(), oPEnv:Hide(), oPLogin:Show(), ::oMainWnd:oMsgBar:Hide(), oApp:oCancel:Enable()}

//setCss("QTab{color:blue}") // Mansano
//SET MESSAGE OF ::oMainWnd TO OemToAnsi(GetVersao()) NOINSET

If ( cPyme == '1' )
	cLogoLogin := "fw_rodape_logo_pyme"
Else
	cLogoLogin := "fw_rodape_logo"
EndIf
::oMainWnd:oMsgBar := TMsgBar():New( ::oMainWnd, SPACE(2)+OemToAnsi(GetVersao()),.F.,.F.,.F.,.F., RGB(116,116,116),,,.F., cLogoLogin )

//::oMainWnd:oMsgBar:nClrPane := CLR_BLACK
//::oMainWnd:oMsgBar:nClrText := CLR_WHITE
                       
::oMainWnd:oMsgBar:Hide()

If (ValType(::cInternet) == "C" .and. PswIsSession(::cInternet)) .or. (ValType(__cBinder) == "C" .And. PswIsSession(__cBinder))
	If ValType(::cInternet) == "C"
		cVar := ::cInternet
	Else
		cVar := __cBinder
	EndIf
	
	If PswValidSession(cVar)
		aSession   := PswInfoSession(cVar)
		cUser      := aSession[1]
		cPassword  := __Decript(aSession[2])
		dDataBase  := aSession[3]
		cEmpFil    := Trim(aSession[4])
		cSenhap    := aSession[5]
		lRpoUpdate := .T.
	Else
		lFinal := .T.
	EndIf

	oLoginPanel:Hide()
//	oMenuLeft:Show()
//	oMenuSep:Show()
	oMainPanel:Show()
	::oMainWnd:bStart := {|| ::oMainWnd:oMsgBar:Show(),If(lFinal,Final('T้rmino Normal'),),lLogin := .F., MDIStart(@cUser,@cPassword,aEmpFil,cEmpFil,aAmb,aMsgItem,cSenhap,.T.,oOwnerMBar,aPOnLine[1]),If(lHasPgOnl .And. ExistPGOnl(__cUserID),If(__cUserID <> "000000",aPOnLine[1]:Show(),aPOnLine[1]:Hide()),aPOnLine[1]:Hide())}
EndIf

If aConfig[20]
	::lGoEmpFil := FindProfDef( __cUserID, "SINGLESIGN", 'LAST', '' )
	If ::lGoEmpFil
		aGoEmpFil := StrTokArr(RetProfDef( __cUserID, "SINGLESIGN", 'LAST', '' ), ';')		
		nPos := Ascan(aAmb[2], {|x| AllTrim(x[3]) == AllTrim(aGoEmpFil[1])})
		If nPos > 0
			::cModDesc := aAmb[2][nPos][3]
			::cModName := aGoEmpFil[2]
			::cModulo := aGoEmpFil[3]
			::cEmpAnt := aGoEmpFil[4]
			::cNumEmp := aGoEmpFil[5]
			::nModulo := val(aGoEmpFil[6])
			
			If SenhApLog(cUser,cPassword,::cUserID)  
				If !lRpoUpdate
					cPassword := Replicate("*",20)
					lLogin := .F.
					oLoginPanel:Hide()
					MDILogin(cUser, ascan(aAmb[1], ::cModDesc) ,aAmb, ascan(aEmpFil[2], ::cEmpAnt),aEmpFil)
					SetMenuUser(aAmb)
					OpenSX6()
					If Select("SX6")>0 
						cPaisLoc := 'BRA'
					EndIf
					oMainPanel:Show()
					::oMainWnd:oMsgBar:Show()
			
					PtInternal(1,"Emp :"+Subs(oApp:cMDIEmpFil,1,2)+"/"+Subs(oApp:cMDIEmpFil,3)+" Logged :"+Padr(cUser, 25)+ " " + Padr(::cModName,9) + " Obj : MDI Window")

					If lHasPgOnl .And. ExistPGOnl(__cUserId)
						IF __cUserId<>"000000" //.And. !lRpoUpdate
							aPOnLine[1]:Show()      
							If !lRpoUpdate								
								BuildMenuBar( oOwnerMBar, @::oPFWMenu, ::cModName, @::oFWMenuP10, ::oPPgOL, ::oPMenuDef, .T., aAmb, aPOnLine, .T. )
							EndIf							
						Else
							aPOnLine[1]:Hide()	
							If !lRpoUpdate								
								BuildMenuBar( oOwnerMBar, @::oPFWMenu, ::cModName, @::oFWMenuP10, ::oPPgOL, ::oPMenuDef, .T., aAmb, aPOnLine )
							EndIf																					
						EndIf 
					Else
						If !lRpoUpdate								
							BuildMenuBar( oOwnerMBar, @::oPFWMenu, ::cModName, @::oFWMenuP10, ::oPPgOL, ::oPMenuDef, .T., aAmb, aPOnLine )
						EndIf					
					EndIf
				EndIf
			Endif
		EndIf
	Endif
EndIf
	
ACTIVATE WINDOW ::oMainWnd MAXIMIZED ON INIT (MDIInit(oMainPanel,oLoginPanel,aMsgItem),aConfig := aConfig(),;
											 If(aConfig[20] .And. oApp:lGoEmpFil,(aMsgItem[1]:SetText(cEmpFil), aMsgItem[2]:SetText(dDataBase), aMsgItem[3]:SetText(Rtrim(cUser))),),; 
											 If(aConfig[4], oUser:SetFocus(), oPassword:SetFocus())); 
									 VALID If(lLogin,Final("Abortado pelo Operador"),Final('T้rmino Normal',,.T.)) 	//"Abortado pelo Operador"###'T้rmino Normal'

Return

// ------------------------------------------------------

METHOD RunApp(lFlat) CLASS MsApp1
Local oBar
Local oFontBold
Local nPosBtn	:= 0
Local oIBrowser
Local oMRUPlus
Local oMRUMinus
Local oShortPlus
Local oShortMinus
Local oPanel
Local ni    
Local cPyme := GetPvProfString('General', 'Pyme', '0', GetAdv97() )

DEFAULT lFlat := .T.

If ::lMDI
	Return
EndIf 

If ( ! ::lIsBlind ) .and. !SetMDIChild(0)
	::lCanChangeTheme:= CheckTheme(.T.)
	UpdateRemote()			// Sincroniza็ใo de Arquivos da Pasta REMOTE
EndIf

If ::lMessageBar
	Private oMsgItem0
	Private oMsgItem1
	Private oMsgItem2
	Private oMsgItem3
	Private oMsgItem4
EndIf

DEFINE FONT AdvFont NAME "MS Sans Serif" SIZE 0, -9
DEFINE FONT oFontBold BOLD NAME 'MS Sans Serif' SIZE 0, -9

If lFlat .and. getRealTheme() == "FLAT"	
	::FlatApp()	
Else
	::lFlat := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seta a tecla SHIFT-F6 de auxilio a URA                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !IsBlind() .And. FindFunction("HDMAPAURA") .And. PadR(GetBuild(),12) >=  "7.00.080806P"
	SetKEY(-15,{|| HdMapaUra()})
EndIf 

If getRealTheme() == "TEMAP10" .Or. ::lTouch
	::SkinP10App()	
EndIf


DEFINE WINDOW ::oMainWnd FROM 1, 1 TO 22, 75 TITLE ::cModDesc   //"Faturamento"

	If FlatMode()
		::oMainWnd:SetCSS("#STYLE0002")
	EndIf 	

	oMainWnd := ::oMainWnd
	::oMainWnd:oFont := AdvFont
	::oMainWnd:nClrText := 0

	If ::bAppStart <> NIL
		Eval(::bAppStart)
	EndIf

//	::LoadMenu(cArqMnu,.T.)
	
	If ::lMainToolBar
		MainToolBar(@oBar)
	EndIf
	
	If ::lMessageBar
		SET MESSAGE OF oApp:oMainWnd TO OemToAnsi(oApp:cVersion) NOINSET
		::oMainWnd:oMsgBar:Hide()	//funcao BUILDMSGITEM executara o metodo SHOW
	EndIf

	//::oMainWnd:SetColor(CLR_BLACK,CLR_WHITE)
	
	If ::lShortCut
		@ 010, 000 MSPANEL oPanel PROMPT '' SIZE 080,000 OF ::oMainWnd FONT AdvFont
		oPanel:align:= CONTROL_ALIGN_RIGHT
		
		@ 000, 000 MSPANEL ::oPanelCUT PROMPT '' SIZE 000, 000 OF oPanel FONT AdvFont
		::oPanelCUT:align:= CONTROL_ALIGN_TOP
		
		@ 000, 000 MSPANEL ::oPanelMRU PROMPT '' SIZE 000, 000 OF oPanel FONT AdvFont
		::oPanelMRU:align:= CONTROL_ALIGN_TOP
		
		oShortPlus 	:= TBtnBmp2():New( 010, 004, 14, 14,'SHORTCUTPLUS.BMP', 'SHORTCUTPLUS.BMP', , ,{|| oShortPlus:Hide(), oShortMinus:Show(), ::MRUShow(.T., .F.)}, ::oPanelCUT, 'T้rmino Normal', , .T.)
		oShortMinus	:= TBtnBmp2():New( 010, 004, 14, 14,'SHORTCUTMINUS.BMP', 'SHORTCUTMINUS.BMP', , ,{|| oShortMinus:Hide(), oShortPlus:Show(), ::oPanelCUT:nHeight := 035, ::oPanelMRU:Align := 0, ::oPanelMRU:Align := CONTROL_ALIGN_TOP}, ::oPanelCUT, 'T้rmino Normal'+'...', , .T.)
		oShortMinus:Hide() 	
		::oPanelCUT:Cargo := { oShortPlus, oShortMinus }	
		@ 005, 011 SAY 'Recentes' OF ::oPanelCUT PIXEL COLOR CLR_BLUE FONT oFontBold
//	    @ 013, 005 TO 014, 076 OF ::oPanelCUT PIXEL
	
		nPosBtn := 19
	  
		For nI := 1 To 10
			TBtnBmp2():New( nPosBtn+9+(nI*9), 112, 15, 15,'SHORTCUTEDIT.BMP', 'SHORTCUTEDIT.BMP', , ,&('{|| oApp:MRUChgLabel('+Str(nI,2,0)+'), oApp:MRuShow(.T.,.F.) }'), ::oPanelCUT, 'T้rmino Normal'+'...', , .T.)
			TBtnBmp2():New( nPosBtn+9+(nI*9), 132, 15, 15,'SHORTCUTDEL.BMP', 'SHORTCUTDEL.BMP', , ,&('{|| oApp:aCUT := ADel(oApp:aCUT, '+Str(nI,2,0)+'), oApp:aCUT := ASize(oApp:aCUT,Len(oApp:aCUT)-1), oApp:MRuShow(.T.,.F.) }'), ::oPanelCUT, 'T้rmino Normal'+'...', , .T. )
			Aadd( ::aShortCuts, TBrowseButton():New( nPosBtn, 005, 'T้rmino Normal', ::oPanelCUT,{|| .T.}, 50, 08,,AdvFont,.F.,.T.,.F.,,.F.,,,) )
			nPosBtn += 9
		Next
		
		oMRUPlus	:= TBtnBmp2():New( 005, 004, 14, 14,'SHORTCUTPLUS.BMP', 'SHORTCUTPLUS.BMP', , ,{|| oMRUPlus:Hide(), oMRUMinus:Show(), ::MRUShow(.F., .T.)}, ::oPanelMRU, 'T้rmino Normal', , .T.)
		oMRUMinus	:= TBtnBmp2():New( 005, 004, 14, 14,'SHORTCUTMINUS.BMP', 'SHORTCUTMINUS.BMP', , ,{|| oMRUMinus:Hide(), oMRUPlus:Show(), ::oPanelMRU:nHeight := 035, ::oPanelCUT:Align := 0, ::oPanelCUT:Align := CONTROL_ALIGN_TOP}, ::oPanelMRU, 'T้rmino Normal'+'...', , .T.)
		oMRUMinus:Hide() 	
		::oPanelMRU:Cargo := { oMRUPlus, oMRUMinus }	

		@ 003, 011 SAY 'Favoritos' OF ::oPanelMRU PIXEL COLOR CLR_BLUE FONT oFontBold
//	    @ 011, 005 TO 012, 076 OF ::oPanelMRU PIXEL

		nPosBtn := 19

		For nI := 1 To 10
			TBtnBmp2():New( nPosBtn+9+(nI*9), 112, 15, 15,'SHORTCUTNEW.BMP', 'SHORTCUTNEW.BMP', , ,&('{|| If ( Len( oApp:aCUT ) <= 10, ( Aadd(oApp:aCUT, oApp:aMRU ['+Str(nI,2)+']), oApp:aMRU := ADel(oApp:aMRU, '+Str(nI,2,0)+'), oApp:aMRU := ASize(oApp:aMRU,Len(oApp:aMRU)-1), oApp:MRuShow(.T.,.T.)),) }'), ::oPanelMRU, 'T้rmino Normal'+'...', , .T.)
			TBtnBmp2():New( nPosBtn+9+(nI*9), 132, 15, 15,'SHORTCUTDEL.BMP', 'SHORTCUTDEL.BMP', , ,&('{|| oApp:aMRU := ADel(oApp:aMRU, '+Str(nI,2,0)+'), oApp:aMRU := ASize(oApp:aMRU,Len(oApp:aMRU)-1), oApp:MRuShow(.F.,.T.) }'), ::oPanelMRU, 'T้rmino Normal'+'...', , .T.)
			Aadd( ::aShortCuts, TBrowseButton():New( nPosBtn, 005, 'MRU  ', ::oPanelMRU,{|| .T.}, 50, 08,,AdvFont,.F.,.T.,.F.,,.F.,,,) )
			nPosBtn += 9
		Next

		::oPanelCUT:nHeight := 035
		::oPanelMRU:nHeight := 035
	EndIf
	
	If ::lIBrowser .AND. (GetPvProfString("CONFIG","BROWSERINITENABLED","ERRO",GetRemoteIniName()) $ "ERRO|1")
		oIBrowser:= tIBrowser():New(0,0,0,0, "", oMainWnd )
		oIBrowser:= tIBrowser():New(0,0,100,100, "mp.htm", oMainWnd )
		oIBrowser:Align:= CONTROL_ALIGN_ALLCLIENT
	EndIf
	
	If ( ::bMainInit == NIL )
		::oMainWnd:bInit := {|| AppInit(),Abertura(oMainWnd),If(::bAppInit <> NIL,Eval(::bAppInit),)} //BuildMsgItem(oMainWnd),
	Else
		::oMainWnd:bInit := {|| Eval(::bMainInit)} //BuildMsgItem(oMainWnd),
	EndIf
	
	If ( cPyme == '1' )
		If !( uSigaAdv )
			If !( ModIsPyme( ::cModulo ) )
				Final( ,'T้rmino Normal' )
			EndIf 
		EndIf
	EndIf

ACTIVATE WINDOW ::oMainWnd MAXIMIZED ;
		VALID  IIF(Abandona(),Final("T้rmino Normal"),.F.)		//"Trmino Normal"

SET RESOURCES TO

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNWQUERY   บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณNรO ME PERGUNTE PORQUE EU MONTEI ISSO, MAS PELAMORDEDEUS    บฑฑ
ฑฑบ          ณ    TOME MUITO CUIDADO NA HORA DE USAR                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบADAPTAวรO DO MPSDU E NDIQUERY (FSW-TOTVS)                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USER FUNCTION NWQUERY
Local 	nOpca	:= 0
Local 	cRotina	:= Space(30) 
PRIVATE cSvAlias := Alias()
PRIVATE oBanner
PRIVATE nI
PRIVATE cSvMsgRec
PRIVATE cSvMsgRdd
PRIVATE cSvMsgSts
PRIVATE oError	:= ErrorBlock({|e| ApQryError(e,@cError,@lError)})
PRIVATE oJanela     

Private	cLoginX	:= Space(40)
Private cSenhaX	:= Space(40)
Private oDlgPr


DEFINE MSDIALOG oDlgPr TITLE "NWQUERY - Query Analyzer" FROM 0,0 TO 245,450 PIXEL 

DEFINE FONT  oBold  	NAME "Arial" 	SIZE 0, -13 BOLD
DEFINE FONT  oBold2 	NAME "Arial" 	SIZE 0, -12 BOLD
DEFINE FONT  oBold3 	NAME "Arial" 	SIZE 0, -11 BOLD
DEFINE FONT  oBoldC 	NAME "CALIBRI"	SIZE 0, -15 BOLD

@ 000, 000 BITMAP oBmp RESNAME "LOGIN" OF oDlgPr SIZE 50, 126 NOBORDER WHEN .F. PIXEL
@ 006, 060 SAY "Digite seu usuแrio e senha para efetuar o login:" FONT oBoldC COLOR CLR_GRAY OF oDlgPr PIXEL
@ 023, 055 TO 080 ,220 LABEL "" OF oDlgPr  PIXEL 
//@ 036, 058 SAY "Usuแrio:"	FONT oBold2 PIXEL
@ 060, 058 SAY "Senha:"		FONT oBold2 PIXEL

//@ 033,085 MSGET cLoginX  OF oDlgPr  SIZE 130,12 FONT oBold3 PIXEL
@ 055,085 MSGET oPas 	VAR cSenhaX PASSWORD OF oDlgPr  SIZE 130,12 FONT oBold3 PIXEL
@ 095, 125 BUTTON "Confirma" SIZE 040,12 PIXEL OF oDlgPr ACTION (nOpca := 1, oDlgPr:End()) 
@ 095, 173 BUTTON "Cancela"  SIZE 040,12 PIXEL OF oDlgPr ACTION (nOpca := 0,oDlgPr:End())

ACTIVATE MSDIALOG oDlgPr CENTER

If	nOpca != 1
	Return()
EndIf   
	    
///-- Somente com senha do PQP+HORA. 
If !Alltrim(cSenhaX) == 'PQP' + Substr( Time(), 1, 2 ) 
	MsgStop("Senha Incorreta","Aten็ใo")
	RpcClearEnv()
	U_NWQUERY()
	Return()
Endif
/*
If !RPCSETENV("01", "52" )// MATRIZ
	MsgStop("Nใo foi possํvel incializar ambiente!","Aten็ใo")
	RpcClearEnv()
	U_NWQUERY()
	Return()
Endif 
*/
OpenSm0()

//-- variaveis ambiente
Private cCadastro		:= "Ferramenta para analistas TOTVS"
Private	acbrowse 		:= Replicate("x", 50)
Private __cInternet := Nil
Private lMsHelpAuto := .F.

MsApp1():New('APSDU')
oApp:cModname	:= "NWQUERY - Query Analyzer"
oApp:lMenu 		:= .F.  
oApp:lFLAT 		:= .T.
oApp:cInternet 	:= ""  
oApp:CreateEnv()
oApp:cModDesc	:= "NWQUERY - Query Analyzer"
oApp:nModulo 	:= 0
oApp:bMainInit 	:= {|| BeginFlatMode(), u_TIQUERY(), EndFlatMode()}
oApp:RunApp()     

RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNWQUERY  บAutor  ณANDERSON CIRIACO     บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao de arquivo temporario, atraves de filtro pela      บฑฑ
ฑฑบ          ณ query, possibilidade de geracao do arquivo em Excel.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

USER FUNCTION TIQUERY()
// Variaveis Locais da Funcao
Local oSBtn1
Local aSize    	:= MsAdvSize()
Local nGet1		:= 40
Local aObjects	:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local cServer	:= AllTrim(GetSrvProfString("TopServer", ""))
Local cBase		:= AllTrim(GetSrvProfString("TopDataBase", "") + "/" + GetSrvProfString("TopAlias", ""))
Local cPorta	:= AllTrim(GetSrvProfString("TopPort", "7890"))
Local cAdvTop	:= cBase + "@" + cServer + ":" + cPorta
Local cSenhaP	:= ""
Local aConnect	:= {}

// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL 		:= .F.                        
Private INCLUI 		:= .F.                        
Private ALTERA 		:= .F.                        
Private DELETA 		:= .F.                        
Private cMemo2		:= ""
Private aBtnQRY 	:= Array(7)
Private	lGeraExcel	:= .F.
Private cVQuery		:= ""
Private cTopSrv		:= cAdvTop
Private aTopConns	:= {cAdvTop}
Private aActConns	:= {{cAdvTop,AdvConnection()}}
Private oTopSrv
Private oMemo1	
Private cMemo1		:= ""
Private oGet1
Private nValBuffer	:=  0
Private cPathPlan	:= ""
Private	ALIAS		:= ""
Private oChkChange  
Private lChkChange 	:= .T.
Private oChkRefresh 
Private lChkRefresh	:= .T.
Private cGet2		:= ""
Private __aConnections := {}
Private __aServers := {}
Private __aQuery := {}
Private __nConnect
Private __nQuery
Private __cQuery := ""
Private __oQuery
Private __lChangeQuery := .T.
Private __nBuffer := 40
Private oPanelClose
Private oPanelResult
Private cError := ""
Private lError := .F.      

Public __LocalDriver    := "DBFCDX"
Public cUserId
Public cUserName

If ( Type("oMsgRec") <> "U" )
	cSvMsgRec	:= oMsgRec:cMsg
	cSvMsgRdd	:= oMsgRdd:cMsg
	cSvMsgSts	:= oMsgSts:cMsg

	oMsgRec:SetText(' ')
	oMsgRdd:SetText(' ')
	oMsgSts:SetText(' ')
	
	oMsgIt2 := oMsgRec
	oMsgIt3	:= oMsgRdd
	oMsgIt4 := oMsgSts
EndIf

If oApp:oFlatWnd != NIL
	oJanela:=oApp:oFlatWnd
Else
	oJanela := oApp:oMainWnd
EndIf                                                                                                    

DEFINE MSDIALOG oDlgQry TITLE 'ApQA - Protheus ' + Subs(GetADV97(), 3, 1) + ' Query Analyzer' OF oJanela PIXEL;
	FROM oJanela:nTop+22, oJanela:nLeft TO oJanela:nBottom-58, oJanela:nRight-10 STYLE nOR(WS_VISIBLE,WS_POPUP)

oDlgQry:Owner():lEscClose:= .F. // desabilita o fechamento por ESC da tela

@000,000 BITMAP oBanner RESNAME "FAIXASUPERIOR4" SIZE 1200,040 NOBORDER PIXEL
oBanner:align:= CONTROL_ALIGN_TOP
oBanner:lStretch := .F.

ACTIVATE MSDIALOG oDlgQry ON INIT (If(ApQrySConnect(),ApQryRunEnv(),oDlgQry:End()))

For nI:=1 To Len(__aConnections)
	TcUnLink(__aConnections[nI])
Next nI

If !Empty(cSvAlias)
	DbSelectArea(cSvAlias)
EndIf
If ( Type("oMsgRec") <> "U" )
	oMsgRec:SetText(cSvMsgRec)
	oMsgRdd:SetText(cSvMsgRdd)
	oMsgSts:SetText(cSvMsgSts)
EndIf
ErrorBlock(oError)
Return









AADD(aObjects, {100,50, .T., .T., .F. } )
AADD(aObjects, {100,50, .T., .T., .F. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects, .T., .F. )

DEFINE MSDIALOG oDlg TITLE "Ferramenta de analistas TOTVS - Query Analyzer" FROM aSize[7], 0 TO aSize[6], aSize[5] OF oMainWnd PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP) 

// Cria as Groups do Sistema
@ aPosObj[1,1] + 10, aPosObj[1,2] TO aPosObj[1,3] - 20/*aPosObj[1,3] - 50, aPosObj[1,4] LABEL "Sintaxe SQL" PIXEL OF oDlg
@ aPosObj[1,1] + 2, aPosObj[1,4]  - 350 Say "TopServer: " Size C(090), C(008) COLOR CLR_BLUE PIXEL OF oDlg
@ aPosObj[1,1], aPosObj[1,4]  - 320 ComboBox oTopSrv Var cTopSrv Items aTopConns Size C(110),C(009) COLOR CLR_BLACK  PIXEL OF oDlg
@ aPosObj[1,1] + 2, aPosObj[1,4]  - 075 Say "Buffer de Leitura: " Size C(090), C(008) COLOR CLR_BLUE PIXEL OF oDlg
@ aPosObj[1,1], aPosObj[1,4]  - 29 MsGet oGet1 Var nGet1 Size C(025), C(009) COLOR CLR_BLACK PIXEL OF oDlg Picture "999" Valid (nGet1 > 0 .And. nGet1 <= 400)
@ aPosObj[1,1] + 2, aPosObj[1,4]  - 170 Say "Tempo Processamento: " Size C(090), C(008) COLOR CLR_BLUE PIXEL OF oDlg	                                      
@ aPosObj[1,1], aPosObj[1,4]  - 112 MsGet oGet2 Var cGet2 Size C(025), C(009) COLOR CLR_BLACK PIXEL OF oDlg Picture "99:99:99" WHEN .F.
@ aPosObj[1,1] + 1, aPosObj[1,2] CheckBox oChkChange Var lChkChange Prompt "ChangeQuery" Size C(048),C(008) COLOR CLR_BLUE PIXEL OF oDlg
@ aPosObj[1,1] + 1, aPosObj[1,2] + 070 CheckBox oChkRefresh Var lChkRefresh Prompt "Refresh" Size C(048),C(008) COLOR CLR_BLUE PIXEL OF oDlg


oTopSrv:BChange	:= {||TROCACONN(aActConns)}	
oMemo1			:= TMultiget():New(aPosObj[1,1] + 18, aPosObj[1,2] + 2, bSetGet(cMemo1),oDlg, aPosObj[1,4] - 8, aPosObj[1,3] - 055/*aPosObj[1,3] - 87,,,,,,.T.)
oMemo1:BKeyDown	:= SetKey(VK_F5, {||EXECQRY(cMemo1, nGet1)})
oMemo1:BChange	:= {||oMemo1:Refresh()}
oMemo1:Refresh()

DEFINE BUTTONBAR oBar SIZE C(20), C(20) 3D TOP OF oDlg
DEFINE BUTTON aBtnQRY[1] RESOURCE "NEXT" 		OF oBar TOOLTIP "Start <F5>"	ACTION EXECQRY(cMemo1, nGet1)
DEFINE BUTTON aBtnQRY[2] RESOURCE "PMSEXCEL"	OF oBar TOOLTIP "Excel" 		ACTION MsgRun("Gerando Excel ..."	, "Aguarde", {||GERAEXCEL()})	
DEFINE BUTTON aBtnQRY[3] RESOURCE "SALVAR" 		OF oBar TOOLTIP "Salvar" 		ACTION MsgRun("Salvando Query ...", "Aguarde", {||QRYSALVAR(cMemo1)})				
DEFINE BUTTON aBtnQRY[4] RESOURCE "OPEN"		OF oBar TOOLTIP "Abrir"  		ACTION MsgRun("Abrindo Query ..."	, "Aguarde", {||cMemo1 := QRYABRIR(cMemo1)})
DEFINE BUTTON aBtnQRY[5] RESOURCE "CADEADO"		OF oBar TOOLTIP "Conectar..."	ACTION QRYTCONN(@aConnect)
DEFINE BUTTON aBtnQRY[6] RESOURCE "PRODUTO"		OF oBar TOOLTIP "Estrutura..."	ACTION MsgRun("Carregando tabelas ..."	, "Aguarde", {|| ESTRUTAB()})
DEFINE BUTTON aBtnQRY[7] RESOURCE "FINAL"		OF oBar TOOLTIP "Sair" 			ACTION QRYEXIT(oDlg, aConnect)
ACTIVATE MSDIALOG oDlg CENTERED
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXECQRY   บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao e execucao da query e geracao do arquivo         บฑฑ
ฑฑบ          ณ temporario.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION EXECQRY(cTEXTO, nTOTLINHA)
Local cQuery		:= ""
Local nRet			:= 0
Local oMemo2
Local aStru			:= {}
Local nI			:= 0
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aSize			:= MsAdvSize()
Local cHoraInicio	:= TIME()
Local cElapsed 
Local lAltera		:= .T.
LOCAL lAtualiza		:= .F.

cPathPlan	:= ""
cQuery		:= cTEXTO                

ALIAS := GetNextAlias()

If (Upper(AllTrim(cQuery)) == Upper(AllTrim(cVQuery))) .And. (nValBuffer == nTOTLINHA) .And. !lChkRefresh
	Return .F.
EndIf
	
cVQuery			:= cQuery
nValBuffer	:= nTOTLINHA
            

If AT("INSERT", Upper(AllTrim(cQuery))) != 0 .Or. AT("UPDATE", Upper(AllTrim(cQuery))) != 0 .Or.; 
	 AT("DELETE", Upper(AllTrim(cQuery))) != 0 .Or. AT("CREATE", Upper(AllTrim(cQuery))) != 0 .Or. AT("VIEW", Upper(AllTrim(cQuery))) != 0 .Or.;
	 AT("TRUNCATE", Upper(AllTrim(cQuery))) != 0 .Or. AT("ALTER", Upper(AllTrim(cQuery))) != 0
	lAtualiza := .T.
EndIf

MsgRun("Verificando Query ...", "Aguarde", {||nRet := TcSqlExec(cQuery)})	
AADD(aObjects, {100,50, .T., .T., .F. } )
AADD(aObjects, {100,50, .T., .T., .F. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3}
aPosObj := MsObjSize( aInfo, aObjects, .T., .F.)

IF !lAtualiza
If nRet <> 0
	If ValType(oMemo2) <> "O"		
		@ aPosObj[2,1] - 20, aPosObj[2,2] GET oMemo2 Var cMemo2 MEMO Size aPosObj[2,4] - 3, aPosObj[1,3] + 05 PIXEL READONLY OF oDlg	
	Else
		oMemo2:LControlVisible	:= .T.	
	EndIf
	cMemo2	:= TcSqlError()
	oMemo2:SetFocus()                              
	nRet				:= 0
	lGeraExcel	:= .F.
Else		
	If (Select(ALIAS) > 0)
		(ALIAS)->(DbCloseArea())	
		FErase(ALIAS + GetDBExtension())
		FErase(ALIAS + OrdBagExt())
	EndIf
	
	If lChkChange
		cQuery := ChangeQuery(cQuery)
	EndIf
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery ), ALIAS, .T., .T.)  	
	DbSelectArea(ALIAS)	
	aStru := DbStruct()	
	
	For	nI	:= 1 To Len(aStru)
		If aStru[nI][2] == "D"
			TcSetField(ALIAS, aStru[nI][1], "D", 8, 0)
		ElseIf aStru[nI][2] ==  "N" .And. aStru[nI][4] > 2
			TcSetField(ALIAS, aStru[nI][1], "N", aStru[nI][3], 2)	  
	  EndIf
		
		If Len(aStru[nI][1]) > 10 	.And. Upper(AllTrim(aStru[nI][1])) <> "R_E_C_D_E_L_"
			Aviso("Erro", "Sintaxe Errada, os campos nใo podem ter o nome com tamanho maior que 10", {"OK"})
			Return .F.			
		EndIf
		  
	  If Val(aStru[nI][1]) == 1
			Aviso("Erro", "Sintaxe Errada, nomear campo(s)", {"OK"})
			Return .F.							
		EndIf
	Next		
	
	DbSelectArea(ALIAS)
	DbGoTop()
 
	If ValType(oMemo2) == "O"
		oMemo2:LVisibleControl	:= .F.	
	EndIf
	cHoraInicio	:= TIME()
	MsgRun("Gerando Visualiza็ใo ...", "Aguarde", {||lGeraExcel := GETCUSTOMI(nTOTLINHA, ALIAS)})	
	oGet1:SetFocus()
EndIf        
ENDIF
cElapsed  := ELAPTIME(cHoraInicio, TIME())
cGet2			:= AllTrim(cElapsed)
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPATHARQ   บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que disponibiliza ao usuario a opcao de escolher    บฑฑ
ฑฑบ          ณ o caminho (path) para ser salvo o arquivo em excel         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION PATHARQ(nTipo)
Local cFileOpen := ""
Local cTitAnex 	:= ""
Local cExtAnex  := ""

If nTipo == 1
	cExtAnex	:= "Arquivos em Excel| *.xls"
	cTitAnex := "Salvar Arquivo"
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.F.)
ElseIf nTipo == 2
		cExtAnex	:= "Arquivos Query| *.nqy"
		cTitAnex := "Salvar Arquivo"
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.F.)
ElseIf nTipo == 3
		cExtAnex	:= "Arquivo Query| *.nqy"
		cTitAnex := "Selecionar Arquivo"
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.T.)	
ElseIf nTipo == 4
		cExtAnex	:= "Arquivos em Excel| *.xls"
		cTitAnex 	:= "Selecionar Arquivo"
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.T.)
EndIf
RETURN(cFileOpen)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETCUSTOMIบAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui as informacoes geradas pela query na GetDados       บฑฑ
ฑฑบ          ณ para ser mostrado na tela                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION GETCUSTOMI(nTOTCOL, ALIAS)
Local aSize		:= MSAdvSize()
Local aObjects	:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local nX		:= 0                                                                                                              
Local aCpoGDa	:= {""}                                                                                                 
Local aAlter	:= {""}
Local nSuperior	:= C(120)
Local nEsquerda	:= C(001)
Local nInferior	:= C(275)
Local nDireita	:= C(445)
Local nOpc		:= 0
Local cLinOk	:= ""
Local cTudoOk	:= "AllwaysTrue"
Local cIniCpos	:= ""
Local nFreeze	:= 000
Local nMax		:= 000
Local cFieldOk	:= "AllwaysTrue"
Local cSuperDel	:= ""
Local cDelOk	:= "AllwaysTrue"
Local oWnd		:= oDlg                                                                                                  
Local aHead		:= {}
Local aCol		:= {}			
Local aStru		:= {}

Local aAux		:= {}
Local nPos		:= 0
Local nPonto	:= 0


AADD(aObjects, {100,50, .T., .T., .F. } )
AADD(aObjects, {100,50, .T., .T., .F. } )
aInfo	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj	:= MsObjSize( aInfo, aObjects, .T., .F. )

nSuperior	:= aPosObj[2,1] - 20
nEsquerda	:= aPosObj[2,2] 
nInferior	:= aPosObj[2,3] 
nDireita	:= aPosObj[2,4]

DbSelectArea(ALIAS)
aStru	:= DbStruct()
                                                                                                                                
aCpoGDa	:= aClone(aStru)

DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2))
For nX := 1 To Len(aCpoGDa)                                                                                                     
		AADD(aHead,{AllTrim(aCpoGDa[nX][1]),;                                                                                         
			AllTrim(aCpoGDa[nX][1]),;                                                                                                       			
			"",;
			aCpoGDa[nX][3],;                                                                                                       
			aCpoGDa[nX][4]})                                                                                                        	
Next nX                                                                                                                         

aAux := {}                          

DbSelectArea(ALIAS)
(ALIAS)->(DbGoTop())
While !(ALIAS)->(Eof())
  For nX := 1 To Len(aHead)
  	AADD(aAux, &(aHead[nX][2]))
	Next	
		AADD(aAux, .F.)
		If Len(aCol) < nTOTCOL                                      
			AADD(aCol, aAux)		
		Else
			Exit
		EndIf
		aAux	:= {}                                                        
	(ALIAS)->(DbSkip())
EndDo
                                  
oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)
RETURN (IIf(Len(aCol) > 0, .T., .F.))                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAEXCEL บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que efetua a geracao do arquivo em Excel no caminho บฑฑ
ฑฑบ          ณ informado pelo usuario                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION GERAEXCEL()
Local cArq	:= ""
Local cAlias:= ""

cAlias	:= GetNextAlias() 

If lGeraExcel 
	cArq	:= PATHARQ(1)
	If Empty(cArq)
			Return .F.			
	EndIf
	
	DbSelectArea(aFiles[Len(aFiles)])                          
	DbGoTop()		
	
	COPY TO (cAlias) + ".DBF" VIA "DBFCDXADS"
	
	If __CopyFile(cAlias + ".DBF", cArq + ".xls")
		ShellExecute("Open", cArq + ".xls","","",1)
		cPathPlan	:= cArq + ".xls"
	Else		
		Aviso("Erro", "Nใo foi possํvel gerar o arquivo Excel", {"OK"})	
		cPathPlan	:= ""
	EndIf
Else
	Aviso("Erro", "Nใo existe registros a serem gerados", {"OK"})
EndIf

FErase(cAlias + ".DBF")
RETURN(.T.)              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYEXIT   บAutor  ณMicrosiga           บ Data ณ  02/20/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que efetua a saida da rotina e deleta o arquivo     บฑฑ
ฑฑบ          ณ temporario                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYEXIT(oForm, aConexao)
Local nI := 0
If !Empty(ALIAS)
	If (Select(ALIAS) > 0)
		(ALIAS)->(DbCloseArea())	
		FErase(ALIAS + GetDBExtension())
		FErase(ALIAS + OrdBagExt())
	EndIf
EndIf
If Len(aConexao) > 0
	For nI := 1 To Len(aConexao)
		TcUnLink(aConexao[nI])
	Next nI
EndIf

oForm:End()
RETURN Nil  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYSALVAR บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Salva query no caminho especificado pelo usuแrio           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYSALVAR(cTEXTO)
Local cArq		:= ""
Local nHandle	:= 0

If !lGeraExcel 
	If !MsgYesNo("Nใo foi gerado nenhum registro !" + Chr(13) + Chr(10) + "Deseja Salvar o Arquivo mesmo assim ?")
		Return .F.	
	EndIf
EndIf

cArq := PATHARQ(2)

If Empty(cArq)
	Aviso("Erro", "Nใo ้ possํvel gravar, poํs nใo foi selecionado o caminho", {"OK"})
	Return .F.
Else
	If (nHandle := FCreate(cArq + ".NQY", 1)) == -1  
			MsgStop("Nao foi possํvel criar arquivo " + cArq, FError())	
	Else
		FWrite(nHandle,	AllTrim(cTEXTO))  
		FClose(nHandle)
		MsgAlert("Arquivo Gravado com sucesso !")
	EndIf
EndIf
RETURN(.T.)         


STATIC FUNCTION QRYABRIR(cTEXTO)
Local cArq		:= ""                                        	
Local cLinha	:= ""

cArq	:= PATHARQ(3)

If Empty(cArq)
	Return cTEXTO
EndIf
	
FT_FUse(cArq)
FT_FGoTop()
While !FT_FEof()       
	cLinha	+= AllTrim(FT_FReadLn())
	cLinha	+= Chr(13) + Chr(10)
	FT_FSkip()
EndDo
If Empty(cLinha)
	cLinha	:= cTEXTO
EndIf
oGet1:SetFocus()
RETURN(cLinha)      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
If "MP8" $ oApp:cVersion .Or. "P10" $ oApp:cVersion
	If (Alltrim(GetTheme()) $ "FLAT.TEMAP10") .Or. (Alltrim(GetTheme()) $ "CLASSIC") .Or. (Empty(GetTheme())) .Or. SetMdiChild() .Or. Empty(GetTheme())  //Tratamento para tema "Flat"
		nTam *= 0.91
	EndIf
EndIf
RETURN Int(nTam)        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYTCONN  บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua conexao no Banco de Dados informado pelo usuario     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDQUERY                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYTCONN(aConexao)
// Variaveis Locais da Funcao
Local cServer	:= Space(40)
Local cBase		:= Space(40)
Local cPorta	:= Space(40)
Local cStrBase	:= ""
Local cStrSrv	:= ""
Local cStrPort	:= ""
Local cStrLnk	:= ""
Local nOpc		:= 0
Local nConexao	:= -1
Local oServer
Local oBase
Local oPorta

// Variaveis Private da Funcao
Private oDlgConn				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL	:= .F.                        
Private INCLUI	:= .F.                        
Private ALTERA	:= .F.                        
Private DELETA	:= .F.

cServer	:= PadR(GetSrvProfString("TopServer", ""),40)
cBase	:= PadR(GetSrvProfString("TopDataBase", "") + "/" + GetSrvProfString("TopAlias", ""),40)
cPorta	:= PadR(GetSrvProfString("TopPort", "7890"),40)

DEFINE MSDIALOG oDlgConn TITLE "Conectar no Top Connect ..." FROM C(178),C(181) TO C(369),C(439) PIXEL

	// Cria as Groups do Sistema
	@ C(003),C(006) TO C(080),C(130) LABEL "" PIXEL OF oDlgConn

	@ C(010),C(007) Say "Servidor" Size C(022),C(008) COLOR CLR_BLACK  PIXEL OF oDlgConn
	@ C(018),C(007) MsGet oServer Var cServer Size C(117),C(009) COLOR CLR_BLACK PIXEL OF oDlgConn
	@ C(033),C(007) Say "DBMS / Base de Dados" Size C(058),C(008) COLOR CLR_BLACK PIXEL OF oDlgConn
	@ C(041),C(008) MsGet oBase Var cBase Size C(116),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgConn
	@ C(055),C(008) Say "Porta" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgConn
	@ C(064),C(008) MsGet oPorta Var cPorta Size C(037),C(009) COLOR CLR_BLACK Picture "9999" PIXEL OF oDlgConn
	@ C(083),C(025) Button "Conectar" Size C(037),C(012) PIXEL OF oDlgConn ACTION (nOpc:=1, oDlgConn:End())
	@ C(083),C(074) Button "Cancelar" Size C(037),C(012) PIXEL OF oDlgConn ACTION (nOpc:= 0, oDlgConn:End())
	
ACTIVATE MSDIALOG oDlgConn CENTERED

If nOpc = 1

	cStrBase:= AllTrim(cBase)
	cStrSrv	:= AllTrim(cServer)
	cStrPort:= AllTrim(cPorta)
	cStrLnk	:= cStrBase + "@" + cStrSrv + ":" + cStrPort
    
	MsgRun("Conectando a: " + cStrSrv + ":" + cStrPort + ". Base: " + cStrBase, "Aguarde...", {||nConexao := TcLink(cStrBase,cStrSrv)})
	
	If 	nConexao < 0
		cMensagem := "Nao foi possํvel estabelecer conexao com o TopConnect Server, retorno: " + AllTrim(Str(nConexao))
		MsgStop(cMensagem)
		Return(.F.)
	EndIf
	
	AADD(aConexao, nConexao)
	
	TcSetConn(nConexao)
	nPosCon	:= AScan(oTopSrv:aItems, {|x| x == cStrLnk})
	
	If nPosCon == 0
		AADD(aActConns, {cStrLnk,nConexao})	
		AADD(oTopSrv:aItems, cStrLnk)	
	EndIf
	
	oTopSrv:SetItems(oTopSrv:aItems)
	oTopSrv:Refresh()
	nPosCon 		:= AScan(oTopSrv:aItems, {|x| x == cStrLnk})
	oTopSrv:nAt	:= nPosCon
	oTopSrv:Refresh()
EndIf
RETURN(.T.)   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTRUTAB  บAutor  ณANDERSON CIRIACO    บ Data ณ  12/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra as estruturas das tabelas referente a conexใo que   บฑฑ
ฑฑบ          ณ esta aberta                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NWQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION ESTRUTAB()
Local cGet1	:= Space(25)
Local oGet1

Private oDlgT
Private aListBox1	:= {}
Private oListBox1

DEFINE MSDIALOG oDlgT TITLE "Tabelas" FROM C(184),C(179) TO C(437),C(550) PIXEL

	@ C(113),C(107) Button "Ok" Size C(037),C(012) PIXEL OF oDlgT Action MsgRun("Lendo Estrutura..."	, "Aguarde", {||SX3TABLE(AllTrim(aListBox1[oListBox1:nAt,02]))})	
	@ C(113),C(147) Button "Cancelar" Size C(037),C(012) PIXEL OF oDlgT Action(oDlgT:End())
	@ C(114),C(003) Say "Procurar" Size C(024),C(008) COLOR CLR_BLACK PIXEL OF oDlgT
	@ C(114),C(031) MsGet oGet1 Var cGet1 Size C(069),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgT
  
  SX2->(DbGoTop())
	SX2->(DbSetOrder(1)	)
	While !SX2->(Eof())
		AADD(aListBox1,{AllTrim(SX2->X2_ARQUIVO), AllTrim(SX2->X2_CHAVE), ""})
		SX2->(DbSkip())
	EndDo
	
	@ C(001),C(001) ListBox oListBox1 Fields ;
		HEADER "TABELA", "CHAVE";
		Size C(184),C(108) Of oDlgT Pixel;
		ColSizes 50,50
		oListBox1:SetArray(aListBox1)		
		oListBox1:bLine 		:= {|| {;
		aListBox1[oListBox1:nAt,01],;
		aListBox1[oListBox1:nAt,02],;
		aListBox1[oListBox1:nAt,03]}}
	  oGet1:bChange	:= {|| SEEKTABLE(aListBox1, @oListBox1, AllTrim(cGet1)), oListBox1:Refresh()}
ACTIVATE MSDIALOG oDlgT CENTERED 
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCheckSenhaบAutor  ณMicrosiga           บ Data ณ07/01/03     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se o SenhaP esta ou nao habilitado para utilizar o   บฑฑ
ฑฑบ          ณDiario Tecnico                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Microsiga - Chamada Remote com Programa Inicial Diario     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

USER FUNCTION CHECKSENHAP(cLoginX,cPwd)
Local cSenhapNumber	:= ""
Local lRet			:= .T.

If !(GetSrvProfString("JUMPSENHAP", "0") = "1")
	cSenhapNumber := GetSenhaP(PadR(cLoginX,20), PadR(cPwd,8), "MSG005")
	If cSenhapNumber == '00000000'
		lRet	:= .F.
	EndIf
Else
	MsgStop("Rotina de Seguranca SenhaP Desabilitada")
	lRet := .T.
EndIf

If lRet
	U_NWQUERY()
EndIf
Return Nil

//TROCACONN - MUDA CONEXOES
STATIC FUNCTION TROCACONN(aConexoes)
//TcSetConn(aConexoes[oTopSrv:nAt][2])
LOCAL CSTR := ACONEXOES[1][1] 
LOCAL NPOSAT := 0
local cdatabase := SUBSTR(ACONEXOES[1][1],1,AT("/",ACONEXOES[1][1])-1)
local cserver   := SUBSTR(ACONEXOES[1][1],AT("@",ACONEXOES[1][1])+1,(AT(":",ACONEXOES[1][1])-1)-AT("@",ACONEXOES[1][1]))
local CALIAS := SUBSTR(ACONEXOES[1][1],AT("/",ACONEXOES[1][1])+1,(AT("@",ACONEXOES[1][1])-1)-AT("/",ACONEXOES[1][1]))
local nport := VAL(SUBSTR(ACONEXOES[1][1],AT(":",ACONEXOES[1][1])+1))              
LOCAL oConnect
cDatabase := cDatabase+"/"+CALIAS
TCLink(cDataBase+"/"+cAlias,cServer,nPort)
RETURN(.T.)


STATIC FUNCTION SEEKTABLE(aList, oList, cBusca)
Local nPos	:= 0                             

If AScan(aList, {|x| x[2] == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| x[2] == AllTrim(cBusca)})
ElseIf AScan(aList, {|x| x[1] == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| x[1] == AllTrim(cBusca)})
ElseIf AScan(aList, {|x| Left(x[1],4) == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| Left(x[1],4) == AllTrim(cBusca)})
ElseIf AScan(aList, {|x| Left(x[1],5) == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| Left(x[1],5) == AllTrim(cBusca)})
Else
	MsgAlert("Tabela nใo Encontrada: " + AllTrim(cBusca))	
EndIf
RETURN(.T.)



STATIC FUNCTION SX3TABLE(cTabela)
Local aListSX3 := {}
Local oListSX3
Local oOk 	   := LoadBitmap( GetResources(), "LBOK")
Local oNo 	   := LoadBitmap( GetResources(), "LBNO")
Private oDlgSX3				// Dialog Principal
Private oMenu


DEFINE MSDIALOG oDlgSX3 TITLE "Estrutura da tabela [" + AllTrim(cTabela) + "]" FROM C(184),C(179) TO C(538),C(648) PIXEL


	@ C(163),C(099) Button "Ok" Size C(037),C(012) PIXEL OF oDlgSX3 Action(INCAMPOS(aListSX3),oDlgSX3:End())
	SX3->(DbSetOrder(1))
	If SX3->(DbSeek(cTabela))
		While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cTabela
			AADD(aListSX3,{.F., AllTrim(SX3->X3_CAMPO), AllTrim(SX3->X3_TIPO), SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, AllTrim(SX3->X3_TITULO),""})
			SX3->(DbSkip())
		EndDo
	EndIf
	
	@ C(001),C(001) ListBox oListSX3 Fields ;
		HEADER "","Nome do Campo","Tipo","Tamanho","Decimal","Tํtulo";
		Size C(235),C(159) Of oDlgSX3 Pixel;
		ColSizes 50,50;
		On DBLCLICK(aListSX3[oListSX3:nAt,01] := !(aListSX3[oListSX3:nAt,1]), oListSX3:Refresh())
		
		aListSX3 := ASort(aListSX3,,, {|x,y| x[1]  < y[1]})		
		oListSX3:SetArray(aListSX3)    
		oListSX3:bLine	:= {|| {If(	aListSX3[oListSX3:nAT,01],oOk,oNo),;
									aListSX3[oListSX3:nAt,02],;
									aListSX3[oListSX3:nAt,03],;
									aListSX3[oListSX3:nAt,04],;
									aListSX3[oListSX3:nAt,05],;
									aListSX3[oListSX3:nAt,06],;
									aListSX3[oListSX3:nAt,07]}}
ACTIVATE MSDIALOG oDlgSX3 CENTERED 
RETURN(.T.)


STATIC FUNCTION INCAMPOS(aCAMPOS)
Local nI		:= 0
Local cCampos	:= ""
For nI	:= 1 To Len(aCAMPOS)
	If aCAMPOS[nI,1]
		cCampos	+= AllTrim(aCAMPOS[nI,2]) + ","
	EndIf
Next
cMemo1 += SubStr(cCampos,1,Len(cCampos)-1)
oMemo1:Refresh()
RETURN(.T.)



// -------------------------------------
Static Function ApQryConnect(cDatabase,cServer,oConnect, nPort)
Local nConnect
Local nAt
Local lConnect

cDatabase := AllTrim(cDatabase)
cServer	  := AllTrim(cServer)

nAt := Ascan(__aServers,cServer+"/"+cDatabase)
If nAt > 0
	nConnect := __aConnections[nAt]
	__nQuery := nAt
Else	
	nConnect := TcLink(cDatabase,cServer, nPort)
	If nConnect > -1
		Aadd( __aConnections, nConnect)
		Aadd( __aServers,cServer+"/"+cDatabase)
		__nQuery := Len(__aConnections)

		// Seta observa็ใo pro TOP que o Query Analizer usa esta conexใo 
		TCInternal(1,"Protheus Query Analyzer")
		
	Else
		ApMsgAlert("Falha de conexใo","Connect")
		Return .F.
	EndIf
EndIf
__nConnect := nConnect
lConnect := TcSetConn(__nConnect)
If lConnect 
	If ( Type("oMsgRec") <> "U" )
		oMsgIt3:SetText(cDatabase)
		oMsgIt4:SetText(cServer)
	EndIf
	If oConnect <> Nil .And. oConnect:nAt > 0
		__aQuery[oConnect:nAt][2] := __cQuery
	EndIf
	Aadd(__aQuery,{__nConnect,""})
	__cQuery := ""
	If __oQuery <> Nil
		__oQuery:Refresh()
	EndIf
EndIf
Return lConnect


// -------------------------------------
Static Function ApQrySConnect(oConnect,aButtons)
Local oDlg
Local oOk
Local oCancel
Local oServer
Local oDatabase
Local cServer	:= Space(50)
Local cDatabase	:= Space(50)
Local cAlias
Local cIniFile	:= GetADV97()
Local lReturn := .F.                                  
Local oPort
Local nPort := 0


cDataBase := GetPvProfString("TopConnect","DataBase","ERROR",cInIfile )
cAlias	  := GetPvProfString("TopConnect","Alias","ERROR",cInIfile )
cServer	  := GetPvProfString("TopConnect","Server","ERROR",cInIfile )
nPort     := Val(GetPvProfString("TopConnect","Port","",cInIfile ))

// Ajuste pelo Environment do Server
cDataBase := GetSrvProfString("TopDataBase",cDatabase)
cAlias	  := GetSrvProfString("TopAlias",cAlias)
cServer	  := GetSrvProfString("TopServer",cServer)
nPort     := Val(GetSrvProfString("TopPort",Str(nPort)))

cDatabase += "/" + cAlias
cDatabase := Padr(cDatabase,50)
cServer	  := Padr(cServer,50)
If nPort == 0
	nPort := 7890
EndIf

DEFINE MSDIALOG oDlg FROM 000,000 TO 170,316 PIXEL TITLE "Conectar como..." //"Connect as..."

@ 003,005 SAY "Server" SIZE 060,007 OF oDlg PIXEL

@ 012,005 GET oServer VAR cServer PICTURE "@!" SIZE 150,009 PIXEL

@ 024,005 SAY "DBMS/Data Base" SIZE 060,007 OF oDlg PIXEL

@ 033,005 GET oDatabase VAR cDatabase PICTURE "@!" SIZE 150,009 OF oDlg PIXEL

@ 045,005 SAY "Port" SIZE 060,007 OF oDlg PIXEL

@ 054,005 GET oPort VAR nPort SIZE 150,009 OF oDlg PIXEL

DEFINE SBUTTON oOk FROM 070,097 TYPE 1 ENABLE OF oDlg PIXEL;
	WHEN (!Empty(cServer) .And. !Empty(cDatabase));
	ACTION (If(lReturn:=ApQryConnect(cDatabase,cServer,oConnect, nPort),(If(oConnect<>Nil,(oConnect:SetItems(__aServers),oConnect:nAt:=__nQuery,oConnect:Refresh(),oConnect:nAt:=Len(__aServers)),),oDlg:End()),))

DEFINE SBUTTON oCancel FROM 070,127 TYPE 2 ENABLE OF oDlg PIXEL;
	ACTION ( oDlg:End(), lReturn:=.F.)

ACTIVATE MSDIALOG oDlg CENTERED

Return lReturn




// -------------------------------------
Static Function ApQryRunEnv()
Local oToolBar
Local oPanel
Local oSep
Local oDum
Local aButtons  := {}
Local nCol		:= -14
Local cList

__nQuery := 1

oDlgQry:ReadClientCoors()

@ 000, 000 MSPANEL oToolBar OF oDlgQry SIZE __DlgWidth(oDlgQry), 014 RAISED
oToolBar:Align := CONTROL_ALIGN_TOP

@ 001,002 BITMAP oSep RESNAME "BMPSEP2" SIZE 6,11 OF oToolBar NOBORDER PIXEL

Aadd( aButtons, TBtnBmp2():New( 001, nCol+=26, 25, 25, "RPMNEW2"	,,,, {|| oDum:SetFocus(), ApQryNewQry()}, oToolBar, "New...", {|| __nQuery<>0},,))
Aadd( aButtons, TBtnBmp2():New( 001, nCol+=26, 25, 25, "RPMOPEN"	,,,, {|| oDum:SetFocus(), ApQryOpenQry()}, oToolBar, "Abrir...", {|| __nQuery<>0},,)) //"Open..."
Aadd( aButtons, TBtnBmp2():New( 001, nCol+=26, 25, 25, "SALVAR"	,,,, {|| ApQrySvQry()}, oToolBar, "Salvar...", {|| __nQuery<>0},,)) //"Save..."
Aadd( aButtons, TBtnBmp2():New( 001, nCol+=26, 25, 25, "NEXT"		,,,, {|| oDum:SetFocus(), ApQryRun()}, oToolBar, "Executar...", {|| __nQuery<>0},,)) //"Run..."

@ 001,060 BITMAP oSep RESNAME "BMPSEP2" SIZE 6,11 OF oToolBar NOBORDER PIXEL

Aadd( aButtons, TBtnBmp2():New( 001, nCol+=40, 25, 25, "PMSRELA"	,,,, {|| ApQrySConnect(aButtons[7],aButtons),__oQuery:Enable()}, oToolBar, "Conectar como...", {|| .T.},,)) //"Connect as..."
Aadd( aButtons, TBtnBmp2():New( 001, nCol+=26, 25, 25, "NOCONNECT"	,,,, {|| ApQryDisconnect(aButtons[7]),__oQuery:Disable()}, oToolBar, "Desconectar...", {|| __nQuery<>0},,)) //"Disconnect..."
Aadd( aButtons, TComboBox():New( 001, 095, bSETGET(cList),__aServers, 150, 009, oToolBar,,{|| ApQrySetConn(aButtons[7]:nAt)},,,, .T.,,,,{|| __nQuery<>0},,,))
Aadd( aButtons, TCheckBox():New( 001, __DlgWidth(oToolBar)-50, 'Change Query', bSETGET(__lChangeQuery), oToolBar, 050, 009,,,,,,,, .T.,,,)) //"Change Query"

@ 002,260 SAY "Buffer de Leitura" OF oToolBar PIXEL //
Aadd( aButtons, TGet():New( 001, 305, bSETGET(__nBuffer), oToolBar, 025, 008, "9999999999",,,,,,, .T.,,, {|| __nQuery<>0},,.T.,,,,,))

@ 001,350 BITMAP oSep RESNAME "BMPSEP2" SIZE 6,11 OF oToolBar NOBORDER PIXEL

Aadd( aButtons, TBtnBmp2():New( 001, nCol+=555, 25, 25, "FINAL"		,,,, {|| ApQryCloseQry(aAlias,aFiles), oDlgQry:End()}, oToolBar, "Sair...", {|| .T.},,)) //"Exit..."

//DEFINE BUTTON aBtnQRY[2] RESOURCE "PMSEXCEL"	OF oBar TOOLTIP "Excel" 		ACTION MsgRun("Gerando Excel ..."	, "Aguarde", {||GERAEXCEL()})	

Aadd( aButtons, TBtnBmp2():New( 001, nCol+=26, 25, 25, "PMSEXCEL"		,,,, {|| oDum:SetFocus(), GERAEXCEL()}, oToolBar, "Excel...", {|| __nQuery<>0},,)) //"Excel..."


@ 000, 000 MSPANEL oPanel OF oDlgQry SIZE __DlgWidth(oDlgQry)-2, __DlgHeight(oDlgQry) RAISED
oPanel:Align := CONTROL_ALIGN_ALLCLIENT

@ -100,000 BUTTON oDum PROMPT "ZE" SIZE 050,010 OF oPanel PIXEL
oDum:bGotFocus := {|| __oQuery:SetFocus()}

@ 001,001 GET __oQuery VAR __cQuery MULTILINE OF oPanel SIZE __DlgWidth(oPanel), __DlgHeight(oPanel) PIXEL
__oQuery:Align := CONTROL_ALIGN_ALLCLIENT

@ 000, 000 MSPANEL oPanelClose OF oDlgQry SIZE 200, 010 RAISED;
	COLOR CLR_GRAY,CLR_GRAY

@ 000, 000 MSPANEL oPanelResult OF oDlgQry SIZE __DlgWidth(oDlgQry)-2, __DlgHeight(oDlgQry)/2 RAISED;
	COLOR CLR_GRAY,CLR_GRAY
oPanelResult:Align := CONTROL_ALIGN_BOTTOM
oPanelClose:Align := CONTROL_ALIGN_BOTTOM
oPanelClose:Hide()
oPanelResult:Hide()
Return



// -------------------------------------
Static Function ApQryRun()
Local oDlg
Local oPanel
Local oBrowse	:= {}
Local oTabs
//Local oError	:= ErrorBlock({|e| ApQryError(e,@cError,@lError)})
Local oTime
Local oClose
Local nTop
Local nBottom
Local nRight
Local nI            
Local nX
Local nCount	:= 1
Local nSec1
Local nSec2
Local aQuerys	:= {}
Local aError	:= {}
Local cQuery
Local cTime		:= "00:00:00"
Local bSETGET
Local aStruct
Local aFieldEsp := {} 
LOCAL LATUALIZA := .F.

If Empty(__cQuery)
	Return
EndIf

If __nBuffer < 40
	ApMsgAlert("O Buffer especificado deve ser maior ou igual a 40!","Aten็ใo") //###
	Return
EndIf

Aadd(aFieldEsp,{"D_E_L_E_T_"	,"C", 1,0})

cQuery  := StrTran(__cQuery,CRLF," ") + ";"
aQuerys := StrTokArr(cQuery,";")

oDlgQry:ReadClientCoors()

nTop	:= oDlgQry:nClientHeight/3+145
nBottom	:= oDlgQry:nClientHeight - 4
nRight  := oDlgQry:nClientWidth - 4

ApQryCloseQry(aAlias,aFiles)

oPanelClose:Show()
oPanelResult:Show()

//DEFINE MSDIALOG oDlg FROM nTop,000 TO nBottom,nRight PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)

@ 000, 000.5 MSPANEL oPanel OF oPanelResult SIZE __DlgWidth(oPanelResult)-5, __DlgHeight(oPanelResult)-1 RAISED

@ 000.5,__DlgWidth(oPanelResult)-68 SAY "Tempo de execu็ใo : " SIZE 030,009 OF oPanel PIXEL //"Run Time : "
@ 000.5,__DlgWidth(oPanelResult)-42 SAY oTime VAR cTime SIZE 024,011 OF oPanel PIXEL
@ 004,oPanel:nWidth-10 BTNBMP oClose RESOURCE "XCLOSE" SIZE 018, 014 ACTION ApQryCloseQry(aAlias,aFiles) OF oPanelClose ADJUST

If AT("INSERT", Upper(AllTrim(cQuery))) != 0 .Or. AT("UPDATE", Upper(AllTrim(cQuery))) != 0 .Or.; 
	 AT("DELETE", Upper(AllTrim(cQuery))) != 0 .Or. AT("CREATE", Upper(AllTrim(cQuery))) != 0 .Or. AT("VIEW", Upper(AllTrim(cQuery))) != 0 .Or.;
	 AT("TRUNCATE", Upper(AllTrim(cQuery))) != 0 .Or. AT("ALTER", Upper(AllTrim(cQuery))) != 0
	lAtualiza := .T.
EndIf

IF !lAtualiza
For nI:=1 To Len(aQuerys)
	cQuery := AllTrim(aQuerys[nI])
	If __lChangeQuery
		Begin Sequence
		lBreakError := .T.
		cQuery := ChangeQuery(cQuery)
		End Sequence
		lBreakError := .F.
	EndIf
	If !Empty(cQuery)
		Aadd( aAlias, "QRY"+StrZero(nCount,3) )
		If !lError
			nSec1 := Seconds()
			Begin Sequence
			lBreakError := .T.
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), aAlias[nCount], .F., .F. )
			End Sequence
			lBreakError := .F.
			nSec2 := Seconds()
		EndIf
		If lError
			Aadd( aError, cError )
			bSETGET := &("{|U| If( PCount() == 0, aError["+Str(Len(aError))+"], aError["+Str(Len(aError))+"] := U ) }")
			Aadd( oBrowse, TMultiGet():New( 8, 3, bSETGET, oPanel, __DlgWidth(oPanelResult)-10, __DlgHeight(oPanelResult)-23,,,,,, .T.,,,,,, .T.,,,,, ) )
			lError := .F.
		Else
			
			// Pega estrutura retornada pela Query
			aStruct := (aAlias[nCount])->(dbStruct())
			
			// Verifica por campos especiais retornados. ( D_E_L_E_T_, por exemplo ) 
			For nX:=1 To Len(aFieldEsp)
				If (aAlias[nCount])->(FieldPos(aFieldEsp[nX][1])) > 0
					Aadd(aStruct,aFieldEsp[nX])
				EndIf
			Next nX
			
			// Ajusta precisใo num้rica, FIXA em 18,4
			// E verifica se tem retorno de coluna caractere tamanho ZERO ! 
			For nX := 1 To Len(aStruct)
				If aStruct[nX,2] == "N"
					aStruct[nX,3] := 18
					aStruct[nX,4] := 4
				ElseIf aStruct[nX,2] == "C" .and. aStruct[nX,3] == 0 
					// Pode acontecer com Postgres ... coloca 1 byte de tamanho.
					aStruct[nX,3] := 1
				EndIf			
			Next nX
			
			Aadd( aFiles, CriaTrab(ChgStrFName(aStruct)) )
			dbUseArea( .T., "DBFCDX", aFiles[Len(aFiles)], aFiles[Len(aFiles)], .F., .F. )
			
			Aadd( oBrowse, MsBrGetDBase():New( 8, 3, __DlgWidth(oPanelResult)-10, __DlgHeight(oPanelResult)-23,,,, oPanelResult,,,,,,,,,,,, .F., aFiles[Len(aFiles)], .T.,, .F.,,,) )
			For nX:=1 To (aFiles[Len(aFiles)])->(FCount())
				// Colunas do Browse : Monta titulo baseado no nome da coluna originalmente
				// retornado, mas o Fieldget() da coluna baseado no nome da coluna
				// usada para gerar o arquivo temporario.
				oBrowse[nCount]:AddColumn( TCColumn():New( aStruct[nX][1] , &("{ || "+aFiles[Len(aFiles)]+"->"+(aFiles[Len(aFiles)])->(FieldName(nX))+"}"),,,,,"LEFT") )
			Next nX
			
			ApQryPutInFile(aAlias[nCount],aFiles[Len(aFiles)])
			
			oBrowse[nCount]:lColDrag	:= .T.
			oBrowse[nCount]:lLineDrag	:= .T.
			oBrowse[nCount]:lJustific	:= .T.
			oBrowse[nCount]:nColPos		:= 1
			oBrowse[nCount]:Cargo		:= {|| __NullEditcoll()}
			oBrowse[nCount]:bSkip		:= &("{|N| ApQryPutInFile('"+aAlias[nCount]+"','"+aFiles[Len(aFiles)]+"',N), "+aFiles[Len(aFiles)]+"->(_DBSKIPPER(N))}")
			oBrowse[nCount]:cCaption	:= APSec2Time(nSec2-nSec1)
		EndIf
		oBrowse[nCount]:Hide()
		If oTabs == Nil
			@ __DlgHeight(oPanelResult)-15,3 TABS oTabs PROMPT "Query # "+AllTrim(Str(nCount)) OF oPanel PIXEL SIZE __DlgWidth(oPanelResult)-11,10;
				ACTION ( ApQrySetTabs(oTabs:nOption,oBrowse,oTime))
		Else
			oTabs:AddItem("Query # "+AllTrim(Str(nCount)))
			
		EndIf
		nCount += 1
	EndIf
Next nI
oTabs:SetOption(1) 

	MsgRun("Gerando Visualiza็ใo ...", "Aguarde", {||lGeraExcel := GETCUSTOMI(nCount, aFiles[Len(aFiles)])})	

ELSEIF LATUALIZA  

	MsgRun("Verificando Query ...", "Aguarde", {||nRet := TcSqlExec(cQuery)})	
	If AT("INSERT", Upper(AllTrim(cQuery))) != 0 
   		MSGINFO("INSERT EFETUADO COM SUCESSO!!!")
	elseif AT("UPDATE", Upper(AllTrim(cQuery))) != 0 
   		MSGINFO("UPDATE EFETUADO COM SUCESSO!!!")
	elseif AT("DELETE", Upper(AllTrim(cQuery))) != 0 
  		MSGINFO("DELETE EFETUADO COM SUCESSO!!!")
	elseif AT("CREATE", Upper(AllTrim(cQuery))) != 0 
  		MSGINFO("CREATE EFETUADO COM SUCESSO!!!")
	elseif AT("VIEW", Upper(AllTrim(cQuery))) != 0 
  		MSGINFO("VIEW EFETUADO COM SUCESSO!!!")
	elseif AT("TRUNCATE", Upper(AllTrim(cQuery))) != 0 
 		MSGINFO("TRUNCATE EFETUADO COM SUCESSO!!!")
	elseif AT("ALTER", Upper(AllTrim(cQuery))) != 0
		MSGINFO("ALTER EFETUADO COM SUCESSO!!!")
	EndIf
	
ENDIF

//ACTIVATE MSDIALOG oDlg

//ErrorBlock(oError)
Return


// -------------------------------------
Static Function ApQrySetTabs(nOption,oBrowse,oTime)
Local nI
For nI:=1 To Len(oBrowse)
	If ( nI == nOption )
		oBrowse[nI]:Show()
		oTime:SetText(oBrowse[nI]:cCaption)
	Else
		oBrowse[nI]:Hide()
	EndIf
Next nI
Return

// -------------------------------------
Static Function ApQryError(e,cError,lError)
cError := e:Description
lError := .T.
If !lBreakError
	Return "DEFAULTERRORPROC"
EndIf
Break
Return

// -------------------------------------
Static Function APSec2Time(nTime,nStr)
Local nHour
Local nMinute
Local nSecond
Local cTime
Local nTemp

DEFAULT nTime := 0
DEFAULT nStr := 2

nTemp := Int(nTime/60)

nHour := Int(nTemp/60)

nMinute := nTemp - (nHour*60)

nSecond := nTime - ((nHour*3600)+(nMinute*60))

cTime := StrZero(nHour,nStr,0)+":"+StrZero(nMinute,2,0)+":"+StrZero(nSecond,2,0)

Return cTime

// -------------------------------------
Static Function APTime2Sec(cTime)
Local nHour
Local nMinute
Local nSecond
Local nTime

DEFAULT cTime := "00:00:00"

nHour := Val(Subs(cTime,1,2))

nMinute := Val(Subs(cTime,4,2))

nSecond := Val(Subs(cTime,7,2))

nTime := (nHour*3600)+(nMinute*60)+nSecond

Return nTime

// -------------------------------------
Static Function ApQryCloseQry(aAlias,aFiles)
Local nI

oPanelClose:Hide()
oPanelResult:Hide()
oPanelResult:FreeChildren()

For nI:=1 To Len(aAlias)
	If Select(aAlias[nI]) > 0
		(aAlias[nI])->(dbCloseArea())
	EndIf
Next nI
For nI:=1 To Len(aFiles)
	(aFiles[nI])->(dbCloseArea())
	FErase(aFiles[nI]+GetDbExtension())
Next nI
aAlias := {}
aFiles := {}
Return

/* ----------------------------------------------------------------------------
Funcao		ChgStrFName(aStru)
Argumento	Array com estrutura de tabela vinda de uma Query
Retorno 	Array com mesma estrutura, porem nomes diferenciados
Uso			Interno do APSDU, para execu็ใo de Queries
---------------------------------------------------------------------------- */
STATIC Function ChgStrFName(aTmpStruct)
Local aRetStruct := aclone(aTmpStruct)
Local nI , nT := len(aRetStruct)
For nI := 1 to nT
	aRetStruct[nI][1] := "CPO"+aRetStruct[nI][2]+strzero(nI,4)
Next
Return aRetStruct


// --------------------------------------------------------------------------------
STATIC Function SduCreateNode()
Local nPx
Local cCargo
Local nPanel
Local cLast := oExplorer:oTree:GetCargo()

SET DELETED &(__cDeleted)

__TreeChg := .F.
__nFile	+=1
nPanel := Len(oExplorer:aPanel)+1 
cCargo	:= '#'+StrZero(__nFile,3)+__cFile+'#&'+__cAlias+'#*'+__cRdd+'#}P'+StrZero(nPanel,3)

If !Empty(cLast) .and. ( '#%ORD' $ cLast )
	oExplorer:oTree:TreeSeek(Subs(cLast,1,At('#%ORD',cLast)-1))
EndIf

oExplorer:AddTItem(Padr(__cFile,150), Padr(cCargo,100), 'BMPTABLE', 'BMPTABLE',,,1)

nPx := Ascan(__aFiles,{|x| x[1]=__cFile})
If ( nPx > 0 )
	__aFiles[nPx,10] := cCargo
	__aFiles[nPx,3] := oExplorer:GetPanel(nPanel)
	If ( 'CDX' $ __cRdd .Or. __cRdd == "TOPCONN" )
		SduTreeKeyInd(cCargo)
	EndIf
EndIf

__TreeChg := .T.
oExplorer:oTree:TreeSeek(cCargo)


Return

// -------------------------------------
Static Function ApQryPutInFile(cSource,cTarget,n)
Local nX
Local nI		:= 1
Local nRecno	:= (cTarget)->(Recno())
Local aFields
Local nFields

Default n := __nBuffer

If Select(cSource) == 0 .Or. (cSource)->(Eof()) .Or. !( n > 0 .And. ( n+(cTarget)->(Recno()) > (cTarget)->(RecCount())-__nBuffer ) )
	Return
EndIf

aFields := (cTarget)->(dbStruct())
nFields := Len(aFields)

While (cSource)->(!Eof()) .And. nI <= __nBuffer
	(cTarget)->(dbAppend())
	For nX:=1 To nFields
		If aFields[nX][2] == "N"
			(cTarget)->(fieldput(nX,val(str((cSource)->(Fieldget(nX)),aFields[nX][3],aFields[nX][4]))))
		Else
			(cTarget)->(FieldPut(nX,(cSource)->(Fieldget(nX))))
		EndIf
	Next nX
	nI += 1
	(cSource)->(dbSkip())
End
(cTarget)->(dbCommit())
(cTarget)->(dbGoto(nRecno))
Return

// -------------------------------------
Static Function ApQryOpenQry()
Local cFile
Local cBuffer
Local nLength
Local nHdl

cFile := cGetFile('Protheus Query Analyzer |*.APQ |SQL Query Analyzer |*.SQL |All Files|*.*',"Abrir arquivo",,,.T.,GETF_ONLYSERVER) //'Open File'
If Empty(cFile)
	Return
EndIf

If At(".",cFile) == 0
	cFile += ".APQ"
EndIf

nHdl := FOpen(cFile,0)
If nHdl < 0
	ApMsgAlert("Falha na leitura do arquivo "+cFile ) //
	Return
EndIf

nLength := FSeek(nHdl,0,2)
cBuffer := Space(nLength)
FSeek(nHdl,0)
FRead(nHdl,@cBuffer,nLength)
FClose(nHdl)
__cQuery := cBuffer
__oQuery:Refresh()
Return

// -------------------------------------
Static Function ApQrySvQry()
Local cFile
Local nHdl

cFile := cGetFile('Protheus Query Analyzer |*.APQ |SQL Query Analyzer |*.SQL |All Files|*.*',"Salvar Arquivo",,,.F.,GETF_ONLYSERVER) //'Save File'
If Empty(cFile)
	Return
EndIf
If At(".",cFile) == 0
	cFile += ".APQ"
EndIf

If File(cFile) 
	If ApMsgYesNo("Sobrescrever o arquivo existente?","Aten็ใo") //###
		FErase(cFile)
	Else 
		Return
	EndIf
EndIf

nHdl := FCreate(cFile,0)
If nHdl < 0
	ApMsgAlert("Falha na grava็ใo do arquivo "+cFile ) //
	Return
EndIf
FWrite(nHdl,__cQuery)
FClose(nHdl)
Return

// -------------------------------------
Static Function ApQryNewQry()
If !Empty(__cQuery) .And. ApMsgYesNo("Salvar script corrente?","Aten็ใo") //###
	ApQrySvQry()
EndIf
__cQuery := ""
__oQuery:Refresh()
Return

// -------------------------------------
Static Function __NullEditcoll()
Return

// -------------------------------------





