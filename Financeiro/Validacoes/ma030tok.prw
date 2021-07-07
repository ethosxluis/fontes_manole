#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK  �Autor  �TOTVS               � Data �  14/05/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada utilizado TOTVS para validar a inclusao do ���
���          �cadastro de cliente no que se refere ao campo de A1_CGC nao ���
���          �deixar o campo em branco exceto nos casos onde o cliente eh ���
���          �estrangeiro.                                                ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA030TOK()

Local aArea   := GetArea()
Local lReturn := .T.

If Inclui .Or. Altera
	If M->A1_EST # 'EX' .And. Empty(M->A1_CGC)
		Aviso(OemtoAnsi("MA030TOK"),"O Campo de CNPJ/CPF est� vazio, verifique o conteudo deste campo",{"Ok"},,;
			OemtoAnsi("   CGC / CPF"))
		lReturn := .F.	
	EndIf
EndIf

RestArea(aArea)

Return(lReturn)