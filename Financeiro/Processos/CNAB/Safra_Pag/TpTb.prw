# include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPTB      �Autor  �Erica M Felix      � Data �  04/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa que retorna o Tipo de Tributo                    ���
���          � Banco Safra / Pagamento de Tributos                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/




User Function TpTb()

Local _cTpTb

Do Case
   Case SEA->EA_MODELO == "17" //GPS =
   _CTPTB := "01"
   Case SEA->EA_MODELO == "16" //DARF NORMAL =
   _CTPTB := "02"
   Case SEA->EA_MODELO == "18" //DARF SIMPLES =
   _CTPTB := "03"   
   Case SEA->EA_MODELO == "13" //CONCESSIONARIAS =
   _CTPTB := "99"   
   Case SEA->EA_MODELO == "19" //GARE - ICMS = 
   _CTPTB := "05" 
   Case SEA->EA_MODELO == "11" //FGTS  =
   _CTPTB := "08" 
   Case SEA->EA_MODELO == "12" //DARE SP =
   _CTPTB := "07"    
OtherWise
   _CTPTB := "99"   
EndCase
   
//_cTpTb := IF(SEA->EA_MODELO $ "17","01",IF(SEA->EA_MODELO $ "16","02",IF(SEA->EA_MODELO $ "18","03",IF(SEA->EA_MODELO $ "13","99"," "))))  
          
Return(_cTpTb)       

