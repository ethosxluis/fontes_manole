#include "Protheus.ch"

User Function soma_sb2()

Local cBuffer := ""
Local cStatus := "" 
Local cData := "" 
Local cIsbn := "" 
Local nQtde := "" 
Local cLocal:= "09" 
Local cFilial:= "01" 


Private cArqTxt := "/data/tabela_sb9.txt"
Private nHdl    := fOpen(cArqTxt,68)

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

ft_fuse(cArqTxt) //abrir o arquivo texto
ft_fgotop() //vai para o topo do arquivo texto       

ProcRegua(FT_FLASTREC()) // Numero de registros a processar

//Dbselectarea("SB2")
//dbsetorder(1)    
//dbgotop() 
DbSelectArea("SB2")
SB2->(DBGOTOP())

While !FT_FEOF() // nTamFile >= nBtLidos
	cbuffer:= FT_FREADLN() 
    cIsbn := Substr(cBuffer,01,13) 
    cLocal:= Substr(cBuffer,22,02)
    nQtde := Substr(cBuffer,16,04)   
    cData := DTOS(CTOD(Substr(cBuffer,26,08)))

    IF SB2->(DBSEEK(xfilial("SB2")+padr(cIsbn,LEN(SB2->B2_COD))+cLocal))  
   	       cStatus := .F.
    else
     	   ft_fskip()
     	   Loop
    endif
   		
   	Reclock("SB2",cStatus)
   
		SB2->B2_QPEDVEN	 := Val(Substr(cBuffer,16,04)) 

   		SB2->(MSUnLock())
        ft_fskip() 
    	
End

ft_fuse()

Return
