#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNCOMA03ºAutor  ³Microsiga             º Data ³  15/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação no campo Status do Cadastro de Clientes que      º±±
±±º          ³ preenche os campos Código e Loja                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EMP Manole                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßdßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNCOMA03()
	Local _aAreaSA2	:=	SA2->(GetArea())
	
	Private _lFecha 	:= .F.
	Private _lRet1		:= .T.
	Private oDlg
	Private oButton1
	Private oButton2
	Private oGet1
	Private cGet1 	:= Space(TamSx3("A2_COD")[1])
	Private oGet2
	Private cGet2 	:= Space(TamSx3("A2_LOJA")[1])
	Private oSay1
	Private oSay2
	Private oSay3
	
	IF INCLUI
		If M->A2_XCAD == "L"
		
			DEFINE MSDIALOG oDlg TITLE "Nova Loja de Fornecedor" FROM 000, 000  TO 190, 270 COLORS 0, 16777215 PIXEL
			
			@ 011, 004 SAY oSay1 PROMPT "Informe o Codigo e Loja do Fornecedor:" SIZE 116, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 030, 004 SAY oSay2 PROMPT "Código" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 045, 004 SAY oSay3 PROMPT "Loja" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 030, 042 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
			@ 045, 042 MSGET oGet2 VAR cGet2 SIZE 017, 010 OF oDlg COLORS 0, 16777215 PIXEL
			@ 068, 091 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg PIXEL ACTION U_fPreen(M->A2_XCAD)
			@ 068, 049 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION(_lFecha := .T., _lRet1 := .F., oDlg:End())
			
			ACTIVATE MSDIALOG oDlg VALID _lFecha

		ElseIf M->A2_XCAD == "A"
			M->A2_COD	:=	U_fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	"01"					
		ElseIf M->A2_XCAD == "B"
			M->A2_COD	:=	"BRASPR" //fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	U_fPreenLj(M->A2_XCAD)
		ElseIf M->A2_XCAD == "C"
			M->A2_COD	:=	U_fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	"01"
		ElseIf M->A2_XCAD == "E"
			M->A2_COD	:=	U_fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	"01"											
		ElseIf M->A2_XCAD == "F"
			M->A2_COD	:=	U_fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	"01"						
		ElseIf M->A2_XCAD == "T"
			M->A2_COD	:=	U_fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	"01"				
		Else
			M->A2_COD	:=	U_fPreen(M->A2_XCAD)
			M->A2_LOJA	:=	"01"
		EndIf
	
	Endif

	RestArea(_aAreaSA2)

Return(_lRet1)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FPREEN  ºAutor  ³Microsiga             º Data ³  15/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação no campo Status do Cadastro de Clientes que      º±±
±±º          ³ preenche os campos Código e Loja                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EMP Manole                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßdßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fPreen(cTipo)
	Local _aArea		:=	GetArea()
	Local _aAreaSA2		:=	SA2->(GetArea())
	Local cQuery		:= ""
	Local cTabQry		:= ""
	Local cRetorno		:= ""
	Local cCodNew		:= ""

	If cTipo == "L"
		If SA2->(DbSeek(xFilial("SA2")+Alltrim(cGet1)))
			If !SA2->(DbSeek(xFilial("SA2")+Alltrim(cGet1)+Alltrim(cGet2)))
				M->A2_COD 	:=	cGet1
				M->A2_LOJA	:=	cGet2
				_lFecha	:=	.T.
				oDlg:End()
			Else
				Aviso("MNCOMA03", "A Loja informada ja esta sendo usada para esse Fornecedor. Verifique!!", {"Fechar"})
				M->A2_COD 	:=	Space(TamSx3("A2_COD")[1])
				M->A2_LOJA	:=	Space(TamSx3("A2_LOJA")[1])
				_lRet1		:=	.F.
				_lFecha	:=	.T.
				oDlg:End()
			Endif
		Else
			Aviso("MNCOMA03", "O Codigo informado não foi utilizado! Não será possível incluir uma nova Loja para o mesmo!!", {"Fechar"})
			M->A2_COD 	:=	Space(TamSx3("A2_COD")[1])
			M->A2_LOJA	:=	Space(TamSx3("A2_LOJA")[1])
			_lRet1	:=	.F.
			_lFecha	:=	.T.
			oDlg:End()
		Endif
	Else
		cTabQry	:= GetNextAlias()

		cCodNew := Alltrim(cTipo) + '00000'
		cQuery 	+= "SELECT	CASE WHEN MAX(A2_COD) IS NULL THEN '" + cCodNew + "' ELSE MAX(A2_COD) END CODIGO" + CRLF
		cQuery 	+= "FROM		" + RetSqlName("SA2") + " SA2" + CRLF
		cQuery 	+= "WHERE		SA2.A2_FILIAL = '" + xFilial("SA2") + "'" + CRLF
		cQuery 	+= "AND		SA2.A2_COD NOT IN ('ESTADO','MUNIC', 'UNIAO')" + CRLF
		cQuery 	+= "AND		SA2.D_E_L_E_T_ = ''" + CRLF
		cQuery	+= "AND		SUBSTR(SA2.A2_COD,1,1) = '" + cTipo + "' " + CRLF
				
		MemoWrite("MNCOMA03.SQL", cQuery)
		
		cQuery 	:= ChangeQuery(cQuery)
			
		DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTabQry, .T., .T.)
			
		While !(cTabQry)->(Eof())
			cRetorno := Soma1((cTabQry)->CODIGO) 
		
			(cTabQry)->(DbSkip())
		End
		
		If Select(cTabQry) > 0
			(cTabQry)->(DbCloseArea())
		EndIf
	EndIf

	RestArea(_aAreaSA2)
	RestArea(_aArea)
Return cRetorno






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FPREENLJ  ºAutor  ³Microsiga           º Data ³  18/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Loja                                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EMP Manole                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßdßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fPreenLj(cTipo)
	Local _aArea		:=	GetArea()
	Local _aAreaSA2		:=	SA2->(GetArea())
	Local cQuery1		:= ""
	Local cTabQry1		:= ""
	Local cRetorno		:= ""

	cTabQry1	:= GetNextAlias()

	cCodNew1 := Alltrim(cTipo) + '00000'
	cQuery1 	+= "SELECT A2_COD, MAX(A2_LOJA) LOJA " + CRLF
	cQuery1 	+= "FROM		" + RetSqlName("SA2") + " SA2" + CRLF
	cQuery1 	+= "WHERE		SA2.A2_FILIAL = '" + xFilial("SA2") + "'" + CRLF
	cQuery1 	+= "AND		SA2.A2_COD NOT IN ('ESTADO','MUNIC', 'UNIAO')" + CRLF
	cQuery1 	+= "AND		SA2.D_E_L_E_T_ = ''" + CRLF
	cQuery1		+= "AND		SUBSTR(SA2.A2_COD,1,1) = '" + cTipo + "' " + CRLF
  	cQuery1		+= "GROUP BY A2_COD " + CRLF
  

	//MemoWrite("FPREENLJ.SQL", cQuery)
		
	cQuery1 	:= ChangeQuery(cQuery1)
			
	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery1), cTabQry1, .T., .T.)
			
	While !(cTabQry1)->(Eof())
		cRetorno := Soma1((cTabQry1)->LOJA) 
		
		(cTabQry1)->(DbSkip())
	End
		
	If Select(cTabQry1) > 0
		(cTabQry1)->(DbCloseArea())
	EndIf

	RestArea(_aAreaSA2)
	RestArea(_aArea)
Return cRetorno
