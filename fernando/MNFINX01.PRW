#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Topconn.ch"
#Include "Fileio.ch"
#INCLUDE "stdwin.ch"
#include "Rwmake.ch"
#INCLUDE "Ap5Mail.ch"
#Include 'ApWebEx.ch'

/*/{Protheus.doc} MNFINX01
Fonte chamado pelo WS responsavel por verificar a adquirente e chamar a fun��o responsavel pelo tratamento do arquivo de baixas financeiras.
@type function
@version  
@author Guelder A. Santos
@since 24/02/2021
@param cArquivo, character, param_description
@param cMarketP, character, param_description
@return return_type, return_description
/*/

User Function MNFINX01(cArquivo,cMarketP)
Local lCabec    := .T.
Local cMemo     := ""
Local aDados    := {}

    If Type('cFilAnt') == 'U'
	    RpcClearEnv()
	    RpcSetType(3)

	    RpcSetEnv("01","01") 
    Endif  


    If UPPER(cMarketP) == "MAGALU" .OR. "MAGAZINE" $ UPPER(cMarketP) 
        u_MNFINX02(cArquivo)
    ElseIf UPPER(cMarketP) == "CARREFOUR"
        u_MNFINX03(cArquivo)
    EndIf



Return
