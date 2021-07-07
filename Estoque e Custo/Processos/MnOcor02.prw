#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

User Function MnOcor02()
Static oDlg
Static oButton1
Static oButton2
Static oGet1
Private cGet1 := SPACE(9) //"Define variable value"
Static oGet2
Private cGet2 := SPACE(3) //"Define variable value"
Static oGet3
Private cGet3 := SPACE(6) //"Define variable value"
Static oGet4
Private cGet4 := SPACE(2) //"Define variable value"
Static oGet5
Static cGet5 := SPACE(30) 
Static oSay1
Static oSay2
Static oSay3
Static oSay4
Static oSay5
Private aAlterFields := {}
Private aHeaderEx := {}
Private aColsEx := {}  
Private aColsEx1 := {}
Private nOpcProc := 0

DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
cGet1 := SF1->F1_DOC //"Define variable value"
cGet2 := SF1->F1_SERIE //"Define variable value"
cGet3 := SF1->F1_FORNECE //"Define variable value"
cGet4 := SF1->F1_LOJA //"Define variable value"
cGet5 := POSICIONE("SA1",1,XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA1->A1_NOME") //"Define variable value"

fMSNewGetDados1()
@ 008, 032 MSGET oGet1 VAR cGet1 SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 007, 152 MSGET oGet2 VAR cGet2 SIZE 053, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 025, 032 MSGET oGet3 VAR cGet3 SIZE 074, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 152 MSGET oGet4 VAR cGet4 SIZE 053, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 043, 032 MSGET oGet5 VAR cGet5 SIZE 356, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 008, 001 SAY oSay1 PROMPT "Nota Fiscal" SIZE 027, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 008, 114 SAY oSay2 PROMPT "Serie:" SIZE 035, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 024, 001 SAY oSay3 PROMPT "Cliente:" SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 025, 113 SAY oSay4 PROMPT "Loja" SIZE 033, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 042, 001 SAY oSay5 PROMPT "Nome" SIZE 028, 011 OF oDlg COLORS 0, 16777215 PIXEL
@ 183, 272 BUTTON oButton1 PROMPT "Confirmar" SIZE 050, 011 ACTION Eval( { || nOpcProc := 1, oDlg:End() } ) OF oDlg PIXEL
@ 184, 341 BUTTON oButton2 PROMPT "Cancelar" SIZE 050, 011 ACTION Eval( { || nOpcProc := 0, oDlg:End() } ) OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg

If nOpcProc == 1
	
	GravaOcor()
	
EndIf

Return

//------------------------------------------------
Static Function fMSNewGetDados1()
//------------------------------------------------
Local nX
Local aFieldFill := {}
Local aFields := {"NOUSER"}
LOCAL LACHOU := .F.
//Local aFields := {"PA2_ISBN","PA2_DESPRO","PA2_TIPO","PA2_DESOCO","PA2_QTD","PA2_OBS"}
Static oMSNewGetDados1

// Get fields from PA2
aEval(ApBuildHeader("PA2", Nil), {|x| Aadd(aFields, x[2])})
aAlterFields := aClone(aFields)

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

// Define field values

For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX



LACHOU := BuscaChave(0)
IF !LACHOU
	cSeekPA2 := xFilial("PA2") + cGet1 +cGet2+cGet3+cGet4
	cWhile   := 'PA2->PA2_FILIAL+PA2->PA2_DOCENT+PA2->PA2_SERIE+PA2->PA2_CLIFOR+PA2->PA2_LOJA'
	dbselectarea("PA2")
	PA2->(DBSETORDER(1)) 
	PA2->(DBSEEK(cSeekPA2))
	WHILE !EOF() .AND. cSeekPA2 == PA2->PA2_FILIAL+PA2->PA2_DOCENT+PA2->PA2_SERIE+PA2->PA2_CLIFOR+PA2->PA2_LOJA
		AADD(aColsEx1,{PA2->PA2_ISBN,nil,PA2->PA2_TIPO,nil,PA2->PA2_QTD,PA2->PA2_OBS})
		DBSKIP()
	END  

Endif
Aadd(aFieldFill, .F.)  
Aadd(aColsEx, aFieldFill)


oMSNewGetDados1 := MsNewGetDados():New( 060, 002, 179, 395, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return



Static Function GravaOcor()
LOCAL _nPosDel  := Len(aHeaderEx) + 1
Private _cISBN := ""
aColsEx := oMSNewGetDados1:acols
For _n := 1 to Len(aColsEx)
	If !aColsEx[_n,_nPosDel]
		_cISBN := aColsEx[_n][1]
		lInclui := BuscaChave(1)
		
		IF lINCLUI
			RECLOCK("PA2",.T.)
		ELSE
			RECLOCK("PA2",.F.)
		ENDIF
		PA2->PA2_FILIAL := XFILIAL("PA2")
		PA2->PA2_DOCENT := cGet1
		PA2->PA2_SERIE	:= cGet2
		PA2->PA2_CLIFOR	:= cGet3
		PA2->PA2_LOJA	:= cGet4
		PA2->PA2_RO		:= STRZERO(nextnum(cGet1+cGet2+cGet3+cGet4),6)
		PA2->PA2_ISBN	:= aColsEx[_n][1]
		PA2->PA2_TIPO	:= aColsEx[_n][3]
		PA2->PA2_QTD	:= aColsEx[_n][5]
		PA2->PA2_OBS	:= aColsEx[_n][6]
		PA2->(MsUnlock())
	EndIF
NEXT _N

Return()

Static Function BuscaChave(nopt)
Local _lret := .T.
Local cQry := ""

cQry := " SELECT COUNT(*) CONTAG FROM "+RETSQLNAME("PA2")+" "
cQry += " WHERE PA2_FILIAL = '"+XFILIAL("PA2")+"' AND PA2_DOCENT = '"+cGet1+"'  AND PA2_SERIE = '"+cGet2+"' AND PA2_CLIFOR = '"+cGet3+"' "
cQry += " AND PA2_LOJA = '"+cGet4+"' "
if nopt == 1
	cqry += " AND PA2_RO = '"+STRZERO(_N,4)+"' AND PA2_ISBN = '"+_cISBN+"'  "
endif

IF SELECT("TRB0")<>0
	DBSELECTAREA("TRB0")
	TRB0->(DBCLOSEAREA())
ENDIF

TCQUERY CQRY NEW ALIAS TRB0

DBSELECTAREA("TRB0")
TRB0->(DBGOTOP())

IF TRB0->CONTAG > 0
	_LRET := .F.
ENDIF

return(_lret)
                                  
STATIC FUNCTION NEXTNUM(CCHAVE)
LOCAL CQUERY := ""
LOCAL NRET := 0

CQUERY := " SELECT COUNT(*) NUMAX FROM "+RETSQLNAME("PA2")+" WHERE PA2_FILIAL = '"+XFILIAL("PA2")+"' AND PA2_DOCENT||PA2_SERIE||PA2_CLIFOR||PA2_LOJA = '"+CCHAVE+"' AND D_E_L_E_T_ <> '*' "  

IF SELECT("TRBA")<>0
DBSELECTAREA("TRBA")
TRBA->(DBCLOSEAREA())
ENDIF
TCQUERY CQUERY NEW ALIAS TRBA
DBSELECTAREA("TRBA")
TRBA->(DBGOTOP())
NRET := TRBA->NUMAX + 1

RETURN(NRET)

