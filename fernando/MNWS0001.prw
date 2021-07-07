#include "totvs.ch"
#include "restful.ch"
#Include "TBICONN.CH"

/*/{Protheus.doc} MNWS0001
Fonte responsavel por receber o nome do arquivo e adquirente dos arquivos já baixados pelo NODE.JS
@type function
@version 1.0  
@author Guelder A. Santos
@since 24/02/2021
/*/

WsRestFul MNWS0001 Description "Solicita a copia de dados - MANOLE"

WSDATA cArquivo As String
WSDATA cMarketP As String

WsMethod post Description "MNWS0001" WsSyntax "/MNWS0001/post"

End WsRestFul

WsMethod post QUERYPARAM cArquivo,cMarketP WsService MNWS0001


Local cArquivo      := IIF (!empty(self:cArquivo)               ,self:cArquivo          , '') //Arquivo Header
Local cMarketP      := IIF (!empty(self:cMarketP)			    ,self:cMarketP			, '') //market Place  Header

Local cBody   := ::GetContent()
Local cRet   := "false"

::SetContentType("Application/Json") 

    cRet := u_MNFINX01(cArquivo,cMarketP)

    ::SetResponse( cRet )
Return .T.
