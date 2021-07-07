#INCLUDE "rwmake.ch"
/*/
+---------------------------------------------------------------------------+
|Programa : Importa  		| Autor Adalberto 	 		| Data: 20/09/12    |
|                                                                           |
|Proposito: Importacao do arquivo texto com os movtos de estoques           |
+---------------------------------------------------------------------------+
/*/

User Function Importaend_txt()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oLeTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SDB                                                          "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
+---------------------------------------------------------------------------+
|Funcao   : OKLETXT		                                |Data ³  18/11/06   |
+---------------------------------------------------------------------------+
|Descri‡„o : Funcao chamada pelo botao OK na tela inicial de processamen    |
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
Local nContador := 0001 //criado por Adalberto    
Local nContador1 := 0001 //criado por Adalberto

//nTamFile := fSeek(nHdl,0,2)
//fSeek(nHdl,0,0)
//nTamLin  := 28+Len(cEOL)

Private cString := "SDB"

dbSelectArea("SDB")
SDB->(dbSetOrder(1))

ft_fuse(cArqTxt) //abrir o arquivo texto
ft_fgotop() //vai para o topo do arquivo texto       

ProcRegua(FT_FLASTREC()) // Numero de registros a processar

While !FT_FEOF() // nTamFile >= nBtLidos
	cbuffer:= FT_FREADLN() // Leitura da primeira linha do arquivo texto
   
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grava os campos obtendo os valores da linha lida do arquivo texto.  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	dbSelectArea(cString)
	RecLock(cString,.T.) // .T. - Inclusao / .F. - Alteracao
	     
		SDB->DB_FILIAL 	 := "01" // 02
		SDB->DB_LOCAL	 := "01" // 11
		SDB->DB_SERIE	 := "001" // 13
		SDB->DB_ATIVID	 := "ZZZ" // 13  
		SDB->DB_ATUEST	 := "S" // 13 
		SDB->DB_TM   	 := "530" // 13 
		SDB->DB_ORIGEM 	 := "SC6" // 13 
		SDB->DB_STATUS	 := "M" // 13   
		SDB->DB_ORDATIV	 := "ZZ"
		SDB->DB_SERVIC	 := "999"    
		SDB->DB_DATA	 := ddatabase
		SDB->DB_NUMSEQ	 := Strzero(nContador,6) 
		SDB->DB_IDOPERA	 := Strzero(nContador1,10)
		
		SDB->DB_PRODUTO  := Substr(cBuffer,01,13) // 05	
	   //	SDB->DB_LOCALIZ	 := Substr(cBuffer,15,04) // 13		
		SDB->DB_LOCALIZ	 := Substr(cBuffer,17,07) // 13 
		SDB->DB_QUANT	 := Val(Substr(cBuffer,25,05)) // 13
	    
  		nContador := nContador + 1   
  		nContador1 := nContador1 + 1   
  		
   		SDB->(MSUnLock())
        ft_fskip() // pula para o proximo registro do arquivo texto
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ft_fuse()
Close(oLeTxt)

Return
