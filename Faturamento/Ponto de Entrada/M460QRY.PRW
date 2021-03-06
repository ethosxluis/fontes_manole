	#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460QRY   �Autor  �Leandro Duarte      � Data �  02/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para apresentar os novos filtros da tela de prepara  ���
���          �cao de documento de saida                                   ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460QRY()
Local cQuery := paramixb[1]

//perguntes SX1 = MT461A

// produtos vtex 1=sim;2=n�o;3=todos
if MV_PAR17 == 1
	cQuery += " AND SUBSTR(SC9.C9_PEDIDO,1,1) = 'V' AND SC9.C9_PRCVEN >= 0 "
ELSEIF MV_PAR17 == 2
	cQuery += " AND SUBSTR(SC9.C9_PEDIDO,1,1) <> 'V'  AND SC9.C9_PRCVEN >= 0 "
ELSE
	cQuery += " AND SUBSTR(SC9.C9_PEDIDO,1,1) <> ' '  AND SC9.C9_PRCVEN >= 0 "
ENDIF

// tipo de produto 1=curso;2=livros;3=todos
if MV_PAR18 == 1
	cQuery += " AND SC9.C9_XTIPO = '2'  AND SC9.C9_PRCVEN >= 0 "
ELSEIF MV_PAR18 == 2
	cQuery += " AND SC9.C9_XTIPO = '1'  AND SC9.C9_PRCVEN >= 0 "
ELSE
	cQuery += " AND SC9.C9_XTIPO <> '3'  AND SC9.C9_PRCVEN >= 0 "
ENDIF

//Validacao de Tipo de Cliente, se pessoa Fisica ou Juridica, conforme solicita��o da Contabilidade
//1=Fisica;2=Juridica;3=Todos

If MV_PAR19 == 1
	cQuery += " AND SC9.C9_XPESSOA = 'F' "
ElseIf MV_PAR19 == 2
	cQuery += " AND SC9.C9_XPESSOA = 'J' "
Else
	cQuery += " "
EndIf


Return(cQuery)