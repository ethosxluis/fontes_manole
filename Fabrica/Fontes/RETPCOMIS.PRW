#include "Protheus.ch"

///-----------------------------------------------------------------------------------
/// Função com os percentuais de comissão a serem pagos para cada percentual de 
/// desconto informado.
///-----------------------------------------------------------------------------------
User Function RETPCOMIS(_nPDesc)
Local _nPComis
	
	Do Case
		case _nPDesc > 0 .and. _nPDesc <= 35
			_nPComis := 7
		case _nPDesc > 35 .and. _nPDesc <= 40
			_nPComis := 6			 
		case _nPDesc > 40 .and. _nPDesc <= 45
			_nPComis := 3			 
		case _nPDesc > 45 .and. _nPDesc <= 50
			_nPComis := 2			 
		case _nPDesc > 50 
			_nPComis := 1
		OtherWise
			_nPComis := 0	
	Endcase
	                   
Return(_nPComis)