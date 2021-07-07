/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para atualizacao da Tabela de Produtos, a partir de º±±
±±º          ³ um arquivo texto (csv)                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Atualizacao da tabela de produtos                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ATUA_SB2()

Local cBuffer := ""
Local cStatus := "" 
Local cData := "" 
Local cIsbn := "" 
Local nQtde := "" 
Local cLocal:= "01" 
Local cFilial:= "01" 


Private cArqTxt := "/data/tabela_sb2.csv"
Private nHdl    := fOpen(cArqTxt,68)

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

ft_fuse(cArqTxt) //abrir o arquivo texto
ft_fgotop() //vai para o topo do arquivo texto       

DbSelectArea("SB1")
SB1->(DBSETORDER(1))



While !FT_FEOF() 
	cbuffer:= FT_FREADLN() 
    cIsbn := Substr(cBuffer,01,at(';',cbuffer)-1)

   IF SB1->(DBSEEK(xfilial("SB1")+padr(cIsbn,LEN(SB1->B1_COD))))
        DbSelectArea("SB2")
     	SB2->(DBSETORDER(1))
  		IF SB2->(DBSEEK(xfilial("SB2")+SB1->B1_COD+cLocal))    
      		 IF  SB2->B2_QATU > 0
        	   ft_fskip() 
        	   loop
     		  endif
       
   		   cStatus := .F.
   	   
   		else                     
      	   cStatus := .T.
	    endif  
   else 
     ft_fskip() 
     loop
   endif   		
   
   	Reclock("SB2",cStatus)
   	
    IF cStatus := .F.
		SB2->B2_QATU	 := Val(Alltrim(Substr(cBuffer,at(';',cbuffer)+1)))
   		SB2->B2_QATU     += B2_QACLASS + B2_RESERVA
    else  
       	SB2->B2_FILIAL	 := "01"     
    	SB2->B2_LOCAL 	 := "01"
    	SB2->B2_COD 	 := cIsbn := Substr(cBuffer,01,at(';',cbuffer)-1)                   
     	SB2->B2_QATU	 := Val(Alltrim(Substr(cBuffer,at(';',cbuffer)+1)))   
     	SB2->B2_QFIM	 := Val(Alltrim(Substr(cBuffer,at(';',cbuffer)+1)))
    	_VINI1           := POSICIONE("SB1",1,xFILIAL("SB1")+SB2->B2_COD,"SB1->B1_CUSTD")
	    SB2->B2_CM1      := _VINI1 * 0.25 * SB2->B2_QATU   
	    SB2->B2_VFIM1    := SB2->B2_CM1 * SB2->B2_QATU
    endif   	   
   	
   		SB2->(MSUnLock())
        ft_fskip() 	
End

ft_fuse()

msginfo("Atualizacao de Cadastro de Produtos Concluido!!")

Return

