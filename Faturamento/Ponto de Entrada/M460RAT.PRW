#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460RAT   �Autor  �Leandro Duarte      � Data �  08/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para normalizar o Frete n�o descobri o por ���
���          �que ele esta duplicando porem para apagar o incendio coloquei��
���          �esse ponto para normalizar o valor do frete                  ��
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function M460RAT
Local aPed := paramixb
Local aArea := SC5->(GETAREA())
//���������������������������������Ŀ
//�Regra de Frete que esta Duplicado�
//�By Leandro Duarte                �
//�����������������������������������
IF LEN(aPed)>0
	fOR NFor := 1 to len(aPed)
		SC5->(DbSetOrder(1))
		if SC5->(DbSeek(xFilial("SC5")+aPed[nFor][1]))
		 //	if aPed[nFor][4] > SC5->C5_FRETE
				aPed[nFor][4] := SC5->C5_FRETE /len(aPed)
		 //	ENDIF
		endif
	next nFor
ENDIF
RESTAREA(aArea)
return(aPed)
