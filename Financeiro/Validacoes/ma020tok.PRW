#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA020TOK  �Autor  �BNotoroberto        � Data �  10/08/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada utilizado para validar a inclusao do       ���
���          �cadastro de Fornecedor ao que se refere aos campos de abaixo���
���          �n�o deixar o campo em branco exceto nos casos onde o cliente���
���          �seja estrangeiro.                                           ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MA020TOK()
Local aArea   := GetArea()
Local lReturn := .T. 
Local Inclui
Local Altera

////////////////////// B A I R R O ///////////////////////////////////// 

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_BAIRRO)
		Aviso(OemtoAnsi("MA020TOK"),"O Campo BAIRRO est� vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   B A I R R O"))
		lReturn := .F.	
	EndIf
EndIf

////////////////////// C E P ///////////////////////////////////// 

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_CEP)
		Aviso(OemtoAnsi("MA020TOK"),"O Campo CEP est� vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   C E P"))
		lReturn := .F.	
	EndIf
EndIf

////////////////////// C N P J ///////////////////////////////////// 

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_CGC)
		Aviso(OemtoAnsi("MA020TOK"),"O Campo de CNPJ / CPF est� vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   CGC / CPF"))
		lReturn := .F.	
	EndIf
EndIf

/////////////////////I N S C R  E S T A D U A L ////////////////////////////

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_INSCR) .And. M->A2_TIPO $ "J"
		Aviso(OemtoAnsi("MA020TOK"),"O Campo de Inscr. Estadual est� vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   INSCR ESTADUAL"))
		lReturn := .F.	
	EndIf
EndIf
 
//////////////////// RG - PF ////////////////////////////

If Inclui .Or. Altera
	If M->A2_EST # 'EX' .And. Empty(M->A2_PFISICA) .And. M->A2_TIPO $ "F"
		Aviso(OemtoAnsi("MA020TOK"),"O Campo de RG/Ced.Estr. est� vazio, preencha este campo!",{"Ok"},,;
			OemtoAnsi("   R.G."))
		lReturn := .F.	
	EndIf
EndIf

RestArea(aArea)
Return(lReturn)