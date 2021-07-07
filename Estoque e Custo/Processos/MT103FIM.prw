#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MT103FIM   � Autor � Anderson Ciriaco    � Data � 27/10/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Ponto de entrada.                                          ���
�������������������������������������������������������������������������Ĵ��
���Cliente   � Manole                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ponto de entrada apos a gravacao da nota fiscal de entrada ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT103FIM()

Local nOpc     := PARAMIXB[1]
Local nConfirm := PARAMIXB[2]
Local cNomFunc := ""
	
If nOpc == 3 .and. nConfirm == 1 //.and. SF1->F1_TIPO == "B"
	u_MnOcor02()
EndIf

IF SF1->( FIELDPOS("F1_XORIGEM") ) > 0

	If !ISINCALLSTACK("U_CENTNFEXM") 
		cNomFunc := "DOCENTRADA"
	Else
		cNomFunc := "CENTRALXML"
	EndIf
	
	RecLock("SF1",.F.)
		SF1->F1_XORIGEM := cNomFunc
	MsUnlock()
	
EndIf

Return Nil