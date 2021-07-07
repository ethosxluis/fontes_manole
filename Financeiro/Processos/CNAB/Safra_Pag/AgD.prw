# include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGD       �Autor  �Erica M Felix       � Data �  04/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que retorna a AgEncia do Destinat�rio              ���
���          �Banco Safra / Pagamento de T�tulos                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function AgD()
             
Local _cAgd 

If SEA->EA_MODELO = "01"  
    cAgd := SA2->A2_AGENCIA

Else
    If SEA->EA_MODELO = "03"
    cAgd := SA2->A2_AGENCIA

Else
	   If SEA->EA_MODELO = "41"
       cAgd := SA2->A2_AGENCIA
        
Else
	      If SEA->EA_MODELO = "43"
	      cAgd := SA2->A2_AGENCIA  
	      
Else 
	      
	     	 If SEA->EA_MODELO $ "30/31"
	     	 cAgd := " "  
    
    		  EndIf
    	  EndIf  
        EndIf
    EndIf
EndIf


Return(cAgD)    
       

