#Include 'Protheus.ch'
#Include 'TOTVS.CH'

//-----------------------------------------------------------------------------------//
/*/{Protheus.doc} MNA007
Cadastro de formul�rio para RPA
@type function
@author Claudio
@since 11/04/2018
@version 1.0
@example MNA007()
/*/
//-----------------------------------------------------------------------------------//
User Function MNA007()

Local aGrupos  := UsrRetGrp(cUserName)	// Carrega os grupos do usu�rio
Local cFiltro  := "(Z6_FILIAL == '" + xFilial('SZ6') + "' .AND. Z6_USUARIO = '" +RetCodUsr() + "')"
Local cGrpRPA  := SuperGetMV("MN_GRPRPA")
Local aRotAdic := {{"Imprimir RPA","U_MNR001()", 0 , 6 }}
Local nI := 0

// Verifica se usu�rio pertence ao grupo que permite visualizar RPAs de outros usu�rio
For nI := 1 to Len(aGrupos)
	If aGrupos[nI] = cGrpRPA		
		If ! Empty (cFiltro)
			cFiltro := ""
		Endif
	Endif
Next nI

dbSelectArea("SZ6")
Set Filter to &(cFiltro)
dbGoTop()

AxCadastro("SZ6" /*cAlias*/, OemToAnsi('Formul�rio RPA') /*cTitle*/, /*cDel*/, /*cOK*/, aRotAdic, /*bPre*/, /*bOK*/, /*bTTS*/, /*bNoTTS*/, /*aAuto*/, /*nOpcAuto*/, /*aButtons*/, /*aACS*/, /*cTela*/)

Return
