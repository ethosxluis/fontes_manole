#INCLUDE "rwmake.ch"
/*/
+---------------------------------------------------------------------------+
|Programa : Importa  		| Autor Adalberto 	 		| Data: 20/09/12    |
|                                                                           |
|Proposito: Importacao do arquivo texto com os movtos de estoques           |
+---------------------------------------------------------------------------+
/*/

User Function Importa_txt()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Private oLeTxt

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Montagem da tela de processamento.                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SB2                                                         "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
+---------------------------------------------------------------------------+
|Funcao   : OKLETXT		                                |Data �  18/11/06   |
+---------------------------------------------------------------------------+
|Descri뇙o : Funcao chamada pelo botao OK na tela inicial de processamen    |
|          : to. Executa a leitura do arquivo texto.                        |
+---------------------------------------------------------------------------+
/*/

Static Function OkLeTxt
/*/
+---------------------------------------------------------------------------+
| Abertura do arquivo texto                                                 |    
+---------------------------------------------------------------------------+     
/*/
Private cArqTxt := "/data/teste.txt"
Private nHdl    := fOpen(cArqTxt,68)

Private cEOL    := CHR(13)+CHR(10)

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicializa a regua de processamento                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Processa({|| RunCont() },"Processando...")
Return

/*/
+---------------------------------------------------------------------------+
|Programa : Importa  		| Autor Adalberto 	 		| Data: 20/09/12    |
|                                                                           |
|Descricao: Funcao auxiliar chamada pela PROCESSA. A funcao PROCESSA        |
|            monta a janela com a regua de processamento.                   |
+---------------------------------------------------------------------------+
/*/       

Static Function RunCont

Local nTamFile     //ultimo registro lido
Local nTamLin
Local cBuffer := ""
Local nBtLidos     
Local cStatus := ""   
Local nContador := 0001 //criado por Adalberto    
Local nContador1 := 0001 //criado por Adalberto

//nTamFile := fSeek(nHdl,0,2)
//fSeek(nHdl,0,0)
//nTamLin  := 28+Len(cEOL)

Private cString := "SB2"

dbSelectArea("SB2")
SB2->(dbSetOrder(1))

ft_fuse(cArqTxt) //abrir o arquivo texto
ft_fgotop() //vai para o topo do arquivo texto       

ProcRegua(FT_FLASTREC()) // Numero de registros a processar

While !FT_FEOF() // nTamFile >= nBtLidos
	cbuffer:= FT_FREADLN() // Leitura da primeira linha do arquivo texto
    IF DBSEEK(xfilial("SB2")+Substr(cBuffer,01,13))  
		   cStatus := .F.
       else
    	   cStatus := .T.
	   endif
    
    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

//	dbSelectArea(cString)
	RecLock(cString,cStatus) // .T. - Inclusao / .F. - Alteracao
	IF  cStatus     
		SB2->B2_FILIAL 	 := "01" // 02
		SB2->B2_LOCAL	 := "01" // 11
	 //	SB2->B2_DINVEN	 := "ZZZ" // 13  
		SB2->B2_COD      := Substr(cBuffer,01,13) // 05	
   //		SB2->B2_LOCALIZ	 := Substr(cBuffer,47,07) // 13 
		SB2->B2_QATU	 := Val(Substr(cBuffer,25,05)) // 13     
	else
		SB2->B2_QATU	 += Val(Substr(cBuffer,25,07)) // 13
    endif
   
   		SB2->(MSUnLock())
        ft_fskip() // pula para o proximo registro do arquivo texto
	
EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

ft_fuse()
Close(oLeTxt)

Return
