#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGIDE    �Autor  �Microsiga           � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Pagide()

_cCgc := "0"+Left(SA2->A2_CGC,8)+Substr(SA2->A2_CGC,9,4)+Right(SA2->A2_CGC,2)

If SA2->A2_TIPO <> "J" 
   _cCgc := Left(SA2->A2_CGC,9)+"0000"+Substr(SA2->A2_CGC,10,2)
Endif

Return(_cCgc)