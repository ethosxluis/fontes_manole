/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para atualizacao da Tabela de Produtos, a partir de ���
���          � um arquivo texto (csv)-Atualiza��o de Preco                ���
���          � Adalberto - 11/2013                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Atualizacao da tabela de produtos                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ATUA_PRC()

Local cBuffer := ""
Local cStatus := ""                                                                            
Local cData := "" 
Local cIsbn := "" 
Local nQtde := "" 
Local cLocal:= "01" 
Local cFilial:= "01" 


Private cArqTxt := "/data/tabela-preco.csv"
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
	cbuffer:= strtran(cbuffer,'"','') 
    cIsbn := Substr(cBuffer,01,at(';',cbuffer)-1)

   IF SB1->(DBSEEK(xfilial("SB1")+padr(cIsbn,LEN(SB1->B1_COD))))
          
     	Reclock("SB1",.F.)
   	
        SB1->B1_PRV1	 := Val(Alltrim(Substr(cBuffer,at(';',cbuffer)+1)))
   	      	
   		SB1->(MSUnLock())   
   Endif
        ft_fskip() 	
EndDo

ft_fuse()

msginfo("Atualizacao de Cadastro de Produtos Concluido!!")

Return

