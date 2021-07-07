#Include "Totvs.ch"

/*/{Protheus.doc} CEXMBTNFE
@description 	Exemplo de ponto de entrada CEXMBTNFE
				Adiciona botão de usuario na tela da NF-e
@author 		Amedeo D. Paoli Filho
@version		1.0
@return			ExpA1, A, Array de 3 Posicoes
@type 			Function
/*/
User Function CEXMBTNFE()
	Local aRetorno	:= Array( 03 )

	aRetorno[1]	:= "EMITIR FORM"		//[01] - Descrição da Função (Será exibida no menu lateral)
	aRetorno[2]	:= "TRMIMG32.PNG"		//[02] - Imagem (Precisa estar no repositorio)
	aRetorno[3]	:= "CEXFUNUSR"			//[03] - Função de Usuário (User Function)

Return aRetorno

User Function CEXFUNUSR()
	//MATA103()
	A103NFiscal( ,,3,, )
Return Nil