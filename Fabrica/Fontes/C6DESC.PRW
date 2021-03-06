#include "Protheus.ch"
                           
//------------------------------------------------------------------------------------
// Fun��o criada para verificar se o conte�do do campo DESCONTO est� sendo alterado 
// por digita��o.                                                    
// Essa rotina � executada por valida��o de campo de desconto do item.
//------------------------------------------------------------------------------------
User Function C6DESC()
       
_nPDesc		:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_DESCONT"})
_nPDescEs	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_XDESCES"}) 
_nPCom1Es	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_XCOM1ES"})  

_xRET1 := &(READVAR()) 			// Novo valor digitado no campo
_xRET2 := aCols[n][_nPDesc]		// Valor anterior com campo 
                           
// Se os valores forem diferentes, ocorreu altera��o por digita��o
If _xRET1 <> _xRET2     
	// Atualiza com SIM o campo de Desconto Espec�fico
	aCols[n][_nPDescEs] := "S" 
	// Se o campo de comiss�o espec�fica estiver diferente de SIM, 
	// atualiza percentual de comiss�o.
	If aCols[n][_nPCom1Es] <> "S"
		nPerComis := U_RETPCOMIS(_xRET1)
		GdFieldPut("C6_COMIS1", nPerComis, n) 
	EndIf
EndIf
          
Return(.T.)                      