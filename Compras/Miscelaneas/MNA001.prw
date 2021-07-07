#Include 'Protheus.ch'
#Include 'TOTVS.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//-----------------------------------------------------------------------------------//
/*/{Protheus.doc} MNA001
Cadastro de Autores
@type function
@author Claudio
@since 26/12/2017
@version 1.0
@example MNA001()
/*/
//-----------------------------------------------------------------------------------//
User Function MNA001()
	//AxCadastro("ZZB", OemToAnsi('Cadastro de Autores'))
	AxCadastro("SA2", OemToAnsi('Cadastro de Professores'))

	Dbselectarea("SA2")
	//SET FILTER TO A2_PROFAUT = '1' .AND. A2_CODIGO <> "UNIAO"
	SET FILTER TO A2_CODIGO = "UNIAO"
	
	mBrowse( 6, 1,22,75,"SA2")
	
	SET FILTER TO
	DbSetOrder(1)

Return

