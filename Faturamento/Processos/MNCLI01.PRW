#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNCLI01   �Autor  �LEANDRO DUARTE      � Data �  04/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA DE CRIA��O DA TELA DE ALTERA��O DO CADASTRO DO CLIENTE��
���          �DO PEDIDO SELECIONADO                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MNCLI01()
lOCAL aAreaSC5	:= SC5->(GETAREA())
lOCAL aAreaSA1	:= SA1->(GETAREA())
Local cCodCli	:= SC5->C5_CLIENTE
Local cLojCli	:= SC5->C5_LOJACLI
SA1->(DBSETORDER(1))
IF SA1->(DBSEEK(xFilial("SA1")+cCodCli+cLojCli))
	cAlias	:= "SA1"
	nReg	:= SA1->(RECNO())
	nOpc	:= 4
	nOpcA := AxAltera(cAlias,nReg,nOpc)
ENDIF
RESTAREA(aAreaSA1)
RESTAREA(aAreaSC5)
RETURN()
