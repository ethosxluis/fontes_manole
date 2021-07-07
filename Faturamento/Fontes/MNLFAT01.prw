#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNLFAT01  �Autor  �Edmar Mendes Prado  � Data �  16/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueia altera��o de desconto nos produtos do Pedido de   ���
���          � Vendas - liberado somente para a Andrea (Financeiro)       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�� Fun��o adicionado no X3_WHEN - U_MNLFAT01() do C6_DESCONT              ���
�� Fun��o adicionado no X3_WHEN - U_MNLFAT01() do C6_PRUNIT               ���
�������������������������������������������������������������������������ͼ��    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MNLFAT01()

Local aArea     := getArea()
Local lRet      := .F.
Local cUsrDesc := SuperGetMV("MV_MNLDESC", NIL, "Admin|Administrador|Administrator|")

If Upper(Alltrim(cUserName)) $ Upper(Alltrim(cUsrDesc))
	lRet := .T.
EndIf

RestArea(aArea)
Return(lRet)