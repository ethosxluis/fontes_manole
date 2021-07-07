#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050CIRF  �Autor  �Leandro Duarte      � Data �  04/26/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para efetuar o calculo conforme autores que moram fora��
���          �do pais deve gerar 15% da Darf e a Darf ~e utilizada a parti���
���          �do campo e2_irrf por esse motivo fui obrigado a colocar esse���
���          �campo com o valor sempre de 15% pois o contador Roberto pass���
���          �ou para o Walter que qualquer valor deve ser 15%            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 e P12                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function F050CIRF()
local nRet	:= 0
nBaseIrrf := PARAMIXB
mv_par04		:= 2 	// contabiliza��o off line
if M->E2_PREFIXO == 'RYI' .AND. SA2->A2_EST == 'EX' .AND. ALLTRIM(M->E2_TIPO) == 'RC'
	nRet := (nBaseIrrf * 0.15)
ELSE
	nRet := M->E2_IRRF
endif
Return(nRet)