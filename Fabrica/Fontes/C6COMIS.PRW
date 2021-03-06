#include "Protheus.ch"
                           
//------------------------------------------------------------------------------------
// Fun��o criada para verificar se o conte�do do campo COMISS�O 1 est� sendo alterado 
// por digita��o.                                                    
// Essa rotina � executada por valida��o de campo de comiss�o 1 do item do pedido.
//------------------------------------------------------------------------------------
User Function C6COMIS()
       
_nPComis1	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_COMIS1"})  
_nPCom1Es	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_XCOM1ES"})  

_xRET1 := &(READVAR()) 			// Novo valor digitado no campo
_xRET2 := aCols[n][_nPComis1]		// Valor anterior do campo 
                           
// Se os valores forem diferentes, ocorreu altera��o por digita��o
If _xRET1 <> _xRET2     
	// Atualiza com SIM o campo de Comiss�o 1 Espec�fica
	aCols[n][_nPCom1Es] := "S" 
EndIf
          
Return(.T.)                      