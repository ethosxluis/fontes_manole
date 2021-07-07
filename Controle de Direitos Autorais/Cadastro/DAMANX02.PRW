#INCLUDE "rwmake.ch"
#INCLUDE "Totvs.ch"



User Function DAMANX02()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".F." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "P02"

dbSelectArea("P02")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Parceiros Digitais. . .","U_cVldExc()","U_cVldAlt()")

User function cVldExc()

Local cSufx := P02->P02_SUFX
Local lRet  := .T.

cquery := ""
 cquery := " select B1_COD "
 cquery += " from "+retsqlname("SB1")
// cquery += " where SUBSTRING(B1_COD,(LEN(B1_COD) -2),3) = '"+cSufx+"'"
 cquery += " where SUBSTRING(B1_COD,(LENGTH(B1_COD) -2),3) = '"+cSufx+"'"
 cquery += " AND D_E_L_E_T_ = ''"
 
 MemoWrite("DAMANX03E.SQL", cQuery)
  
 cQuery := ChangeQuery(cQuery)    


	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

 DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TMP", .F., .F.)


//	If Select("TMP") > 0
//		TMP->(dbCloseArea())
    if TMP->( !EOF() )
        ALERT("Este parceiro não pode ser excluído, poís existem produtos cadastrados com este sufixo")
        lRet := .F.
	EndIf



Return(lRet)


User function cVldAlt()

Local lRet  := .T.
Local cSufx := ""


IF ALTERA
    cSufx := P02->P02_SUFX
ELSEIF INCLUI
    cSufx := M->P02_SUFX
ENDIF


cquery := ""
 cquery := " select B1_COD "
 cquery += " from "+retsqlname("SB1")
// cquery += " where SUBSTRING(B1_COD,(LEN(B1_COD) -2),3) = '"+cSufx+"'"
 cquery += " where SUBSTRING(B1_COD,(LENGTH(B1_COD) -2),3) = '"+cSufx+"'"
 cquery += " AND D_E_L_E_T_ = ''"

 MemoWrite("DAMANX03A.SQL", cQuery)
 
 cQuery := ChangeQuery(cQuery)    

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf


 DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TMP", .F., .F.)


//	If Select("TMP") > 0
//		TMP->(dbCloseArea())

    if TMP->( !EOF() )
        ALERT("Este parceiro não pode ser alterado, poís existem produtos cadastrados com este sufixo")
        lRet := .F.
	EndIf

Return(lRet)