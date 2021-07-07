# include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BCD       ºAutor  ³Erica M Felix       º Data ³  04/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que retorna o código do Banco do Destinatário      º±±
±±º          ³Banco Safra / Pagamento de Títulos                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BcD()

Local _cBcD 

/*
IF SEA->EA_MODELO$"30/31"
    _cBcD := SubsTR(SE2->E2_CODBAR,1,3)
  ElseIf SEA->EA_MODELO$"01/03/41/43"
    _cBcD := SA2->A2_BANCO    
EndIf    
*/

//Honorio - 20/09/2011 incluindo agencia e conta

Do Case
Case SEA->EA_MODELO$"30/31"
    _cBcD := SubsTR(SE2->E2_CODBAR,1,3) + "00000000000000000000" 

Case SEA->EA_MODELO$"01/03/08/41/43"
    _cBcD := SA2->A2_BANCO 
    _cBcD += Replicate("0", 7-Len(ALLTRIM(SA2->A2_AGENCIA)))+ ALLTRIM(SA2->A2_AGENCIA)  
    //_cBcD += IIF(EMPTY(ALLTRIM(SA2->A2_XDIGAG)),"0",ALLTRIM(SA2->A2_XDIGAG))
    _cBcD += Replicate("0",12-Len(ALLTRIM(SA2->A2_NUMCON))) + ALLTRIM(SA2->A2_NUMCON)   
    _cBcD += IIF(EMPTY(ALLTRIM(SA2->A2_XDIGCC)),"0",ALLTRIM(SA2->A2_XDIGCC))
    
OTHERWISE
    _cBcD := "00000000000000000000000"   
      
EndCase

Return(_cBcD)    