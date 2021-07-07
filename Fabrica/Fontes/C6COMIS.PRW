#include "Protheus.ch"
                           
//------------------------------------------------------------------------------------
// Função criada para verificar se o conteúdo do campo COMISSÃO 1 está sendo alterado 
// por digitação.                                                    
// Essa rotina é executada por validação de campo de comissão 1 do item do pedido.
//------------------------------------------------------------------------------------
User Function C6COMIS()
       
_nPComis1	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_COMIS1"})  
_nPCom1Es	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_XCOM1ES"})  

_xRET1 := &(READVAR()) 			// Novo valor digitado no campo
_xRET2 := aCols[n][_nPComis1]		// Valor anterior do campo 
                           
// Se os valores forem diferentes, ocorreu alteração por digitação
If _xRET1 <> _xRET2     
	// Atualiza com SIM o campo de Comissão 1 Específica
	aCols[n][_nPCom1Es] := "S" 
EndIf
          
Return(.T.)                      