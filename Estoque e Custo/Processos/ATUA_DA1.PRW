#include "Protheus.ch"
//#define CRLF CHR(13)+CHR(10)

User Function ATUA_DA1() 

Local nContador := 0001   
Local nMoeda    := 1 
DbSelectArea("SB1")
DbSetOrder(1)
SB1->(DBGOTOP())

DbSelectArea("DA1")
DA1->(DBGOTOP())     



//rotina de deleção. 
//While  !DA1->(eof())
//	Reclock("DA1",.F.)
//	DBDelete()
//	Msunlock()
//	DA1->(DBSkip())
//End

While  !SB1->(eof())
	
	Reclock("DA1",.T.)
  //	SB9->B9_FILIAL  := SB2->B2_FILIAL
	DA1->DA1_CODPRO     := SB1->B1_COD
	DA1->DA1_CODTAB 	:= "002"    
	DA1->DA1_ATIVO 		:= "1"           
	DA1->DA1_TPOPER 	:= "4"   
  //	DA1->DA1_MOEDA 		:= Val(Substr(nMoeda))
 //   DA1->DA1_QTDLOT 	:= "999999.99"    
    DA1->DA1_INDLOT 	:= "000000000999999.99"      
	DA1->DA1_PRCVEN		:= SB1->B1_PRV1
	DA1->DA1_ITEM		:= Strzero(nContador,4) 
  
	nContador := nContador + 1   
	
	Msunlock()
		
	SB1->(DbSkip())    
	
end
return
