#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA020TOK  ºAutor  ³BNotoroberto        º Data ³  10/08/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada utilizado para validar a inclusao do       º±±
±±º          ³cadastro de Fornecedor ao que se refere aos campos de abaixoº±±
±±º          ³não deixar o campo em branco exceto nos casos onde o clienteº±±
±±º          ³seja estrangeiro.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MA020TOK()
Local aArea   := GetArea()
Local lReturn := .T. 
Local Inclui
Local Altera

////////////////////// B A I R R O ///////////////////////////////////// 

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_BAIRRO)
		Aviso(OemtoAnsi("MA020TOK"),"O Campo BAIRRO está vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   B A I R R O"))
		lReturn := .F.	
	EndIf
EndIf

////////////////////// C E P ///////////////////////////////////// 

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_CEP)
		Aviso(OemtoAnsi("MA020TOK"),"O Campo CEP está vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   C E P"))
		lReturn := .F.	
	EndIf
EndIf

////////////////////// C N P J ///////////////////////////////////// 

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_CGC)
		Aviso(OemtoAnsi("MA020TOK"),"O Campo de CNPJ / CPF está vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   CGC / CPF"))
		lReturn := .F.	
	EndIf
EndIf

/////////////////////I N S C R  E S T A D U A L ////////////////////////////

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_INSCR) .And. M->A2_TIPO $ "J"
		Aviso(OemtoAnsi("MA020TOK"),"O Campo de Inscr. Estadual está vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   INSCR ESTADUAL"))
		lReturn := .F.	
	EndIf
EndIf
 
//////////////////// RG - PF ////////////////////////////

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_PFISICA) .And. M->A2_TIPO $ "F"
		Aviso(OemtoAnsi("MA020TOK"),"O Campo de RG/Ced.Estr. está vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   R.G."))
		lReturn := .F.	
	EndIf
EndIf

RestArea(aArea)
Return(lReturn)