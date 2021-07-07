#include "rwmake.ch"        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ECOM01   ºAutor  ³Rafael Garcia de Meloº Data ³  18/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Substitui o produto digitado na solicitacao pelos itens da  º±±
±±º          ³estrutura quando possuir.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico para Editora Manole		                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ECOM01()        

Private _AAREA,_XRET,_CPRODUTO,_NQuant,_LCOND1,NESTRU,_AESTRUT, _NPACOLS,_NJ,_dDatPRF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Guarda a area atual, ordem e registro posicionado                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o gatilho disparado para definir o retorno do Execblock         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Upper(AllTrim( SX7->X7_CAMPO )) == "C1_DATPRF"
	_xRet := gdFieldGet('C1_DATPRF',n)
EndIf

_cProduto  := gdFieldGet('C1_PRODUTO',n)  // Produto Digitado
_nQuant   := gdFieldGet('C1_QUANT',n)  // Quantidade do Produto Digitado                       
_dDatPRF   := gdFieldGet('C1_DATPRF',n)  // Data da necessidade do produto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Devem estar preenchidos: Produto, Qtde e Data da necessidade.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_lCond1 := !Empty(_cProduto) .AND. !Empty(_nQuant) .AND. !EMPTY(_dDatPRF ) .AND. n == Len(aCols)

If _lCond1
	
	SB1->( dbSetOrder(1) )                                // Cadastro de Produro, ordem de codigo
	SB1->( dbSeek( xFilial("SB1") + _cProduto, .F. ) )    // Posiciona produto digitado
	
	nEstru   := 0                   // Variavel obrigatoria para a funcao Estrut()
	_aEstrut := Estrut( _cProduto ) // Busca a Estrutura do Produto
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³O produto deve possuir estrutura                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len( _aEstrut ) > 0
		
		_npaCols := n+1         // n -> Item posicionado no pedido
		
		For _nj := 1 To Len( _aEstrut )
			
			If _npaCols > n
				Aadd( aCols, aClone( aCols[n] ) )
			EndIf
			
			SG1->( dbSeek( xFilial("SB1") + _aEstrut[_nj,3], .F. ) )  // Busca o componente no SB1
			
			
			// Atualiza as variaveis do aCols
			GdFieldPut('C1_ITEM',StrZero( _npaCols, 4 ))
			GdFieldPut('C1_PRODUTO',_aEstrut[_nj,3])
			GdFieldPut('C1_UM',SB1->B1_UM)
			GdFieldPut('C1_QUANT',_aEstrut[_nj,4] * _nQuant)
			GdFieldPut('C1_DATPRF',_dDatPRF)
			GdFieldPut('C1_LOCAL',SB1->B1_LOCPAD)
			GdFieldPut('C1_DESCRI',SB1->B1_DESC)

			_npaCols=_npaCols+1
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o gatilho disparado para definir o retorno do Execblock         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _nj == 1
				If Upper(AllTrim( SX7->X7_CAMPO )) == "C1_DATPRF"
					_xRet := gdFieldGet('C1_DATPRF',n)
				EndIf
			EndIf
		Next _nj
	EndIf
EndIf

RestArea( _aArea )

Return(_xRet )