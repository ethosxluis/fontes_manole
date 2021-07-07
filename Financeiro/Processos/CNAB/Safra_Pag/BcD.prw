# include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BCD       �Autor  �Erica M Felix       � Data �  04/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que retorna o c�digo do Banco do Destinat�rio      ���
���          �Banco Safra / Pagamento de T�tulos                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BcD()

Local _cBcD 

/*
IF SEA->EA_MODELO$"30/31"
    _cBcD := SubsTR(SE2->E2_CODBAR,1,3)
  ElseIf SEA->EA_MODELO$"01/03/41/43"
    _cBcD := SA2->A2_BANCO    
EndIf    
*/

//Honorio - 20/09/2011 incluindo agencia e conta

Do Case
Case SEA->EA_MODELO$"30/31"
    _cBcD := SubsTR(SE2->E2_CODBAR,1,3) + "00000000000000000000" 

Case SEA->EA_MODELO$"01/03/08/41/43"
    _cBcD := SA2->A2_BANCO 
    _cBcD += Replicate("0", 7-Len(ALLTRIM(SA2->A2_AGENCIA)))+ ALLTRIM(SA2->A2_AGENCIA)  
    //_cBcD += IIF(EMPTY(ALLTRIM(SA2->A2_XDIGAG)),"0",ALLTRIM(SA2->A2_XDIGAG))
    _cBcD += Replicate("0",12-Len(ALLTRIM(SA2->A2_NUMCON))) + ALLTRIM(SA2->A2_NUMCON)   
    _cBcD += IIF(EMPTY(ALLTRIM(SA2->A2_XDIGCC)),"0",ALLTRIM(SA2->A2_XDIGCC))
    
OTHERWISE
    _cBcD := "00000000000000000000000"   
      
EndCase

Return(_cBcD)    