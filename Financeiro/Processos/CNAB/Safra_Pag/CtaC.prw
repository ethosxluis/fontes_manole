# include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTAC      �Autor  �Erica M Felix       � Data �  04/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa retorna a Conta Corrente do Destinat�rio           ���
���          �Banco Safra / Pagamento de T�tulos                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CtaC()

Local _cCtaC

If SEA->EA_MODELO$"01/03/41/43"
  
    _cCtaC := SA2->A2_NUMCON 

Else
   If SEA->EA_MODELO$"30/31"
  
    _cCtaC := " " 
 
    EndIf
     
EndIf


Return(_cCtaC)    
       