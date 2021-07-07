#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MnStart
Description                                                     
                                                                
@param xParam Parameter Description
@return xRet Return Description                                 
@author  - Leandro Duarte
@since 09/10/2017  
WaitRunSrv( cCommandLine , lWaitRun , cPath ) : lSuccess
cCommandLine : Instrução a ser executada
lWaitRun     : Se deve aguardar o término da Execução
Path         : Onde, no server, a função deverá ser executada
Retorna      : .T. Se conseguiu executar o Comando, caso contrário, .F.
                                                 
/*/                                                             
//--------------------------------------------------------------
User Function MnStart()
Local oButton1
Local oButton2
Local oFont1 := TFont():New("Times New Roman",,028,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("Times New Roman",,032,,.T.,,,,,.F.,.F.)
Local oFont3 := TFont():New("Times New Roman",,016,,.F.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := "Define variable value"
Local oMultiGe1
Local cMultiGe1 := "Define variable value"
Local oSay1
Local oSButton1
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Serviço Vtex" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    @ 013, 081 SAY oSay1 PROMPT "Serviço Vtex" SIZE 084, 015 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 037, 015 MSGET oGet1 VAR cGet1 SIZE 214, 022 OF oDlg COLORS 0, 16777215 FONT oFont2 READONLY PIXEL
    @ 072, 015 BUTTON oButton1 PROMPT "Parar Serviço Vtex" SIZE 067, 012 OF oDlg PIXEL
    @ 072, 162 BUTTON oButton2 PROMPT "Subir Serviço Vtex" SIZE 067, 012 OF oDlg PIXEL
    @ 108, 014 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 219, 117 COLORS 0, 16777215 FONT oFont3 HSCROLL PIXEL
    DEFINE SBUTTON oSButton1 FROM 072, 109 TYPE 02 OF oDlg ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED

Return