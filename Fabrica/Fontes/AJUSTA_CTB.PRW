#include "protheus.ch"   

///-----------------------------------------------------------------
//Função para ajuste de dados para contabilizacao
//------------------------------------------------------------------   
// Configuração do Lancamento padrão 100
//------------------------------------------------------------------   
// Conta debito LERSTR(10,10)
// Conta credito LERSTR(20,10) 
// Centro Custo Deb  LERSTR(84,09)                                                                                                                                                                                           
// Centro Custo Cred LERSTR(93,09)                                                                                                                                                                                           
// Valor LERVAL(30,14)
// Historico LERSTR(44,40)                                                                                                                                                                                           
// HP Aglutin LERSTR(44,40)
// Data (origem) LERDATA(04,06)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
// 
//----------------------------------------------------------------- 
// Contabilização TXT     -  Miscelanea
//----------------------------------------------------------------- 
// Tamanho da linha em bytes = 103
//------------------------------------------------------------------ 

USER FUNCTION AJUSTA_CTB() 

Private _cTexto := "" 
Private _cArquivo := "TEXTOCTB"
Private oDlgOBS
///MONTA TELA DE ABERTURA:
DEFINE FONT oFont NAME "Mono AS" SIZE 8,15
Define MsDialog oDlgOBS Title "Atualização de dados cadastrais" From 116,090 To 630,850 Pixel

@ 012,010 Say OemToAnsi("Rotina para geração de arquivo texto para importar no modulo contabil   ") 	PIXEL OF oDlgOBS FONT oFont
//---------------------------------------------------------------------------
@ 022,010 Say OemToAnsi("Copie do Excel e cole abaixo os dados a serem atualizados:" ) 					PIXEL OF oDlgOBS FONT oFont
@ 032,010 SAY "Arquivo: "  SIZE 050,010 OF oDlgOBS PIXEL
@ 032,050 MSGET _cArquivo  SIZE 030,010 OF oDlgOBS PIXEL 
@ 055,005 GET oMens VAR _cTexto MEMO SIZE 370,200 OF oDlgOBS PIXEL                        

oMens:bRClicked := {||AllwaysTrue()}
oMens:oFont:=oFont
oSpdBtX := SButton():New(010,345, 1,{|| GeraArq(_cTexto), oDlgOBS:End() }, oDlgOBS,.T.,,)
oSpdBtY := SButton():New(030,345, 2,{|| oDlgOBS:End() }, oDlgOBS,.T.,,)
Activate MsDialog oDlgOBS Center
///

Return(.T.)

///-----------------------------------------------------------------
/// Função que processa os dados da planilha e grava no SA1
///-----------------------------------------------------------------
Static Function GeraArq(_cTXT)

/// Cria arquivo TXT (temporário) com os dados do Excel
_cArqDsc := "TMP_CTB.TXT"
Grv_Disco(_cArqDsc,_cTXT)

/// Cria arquivo temporário de trabalho e grava nele os dados do Excel.
Cria_TMP()
dbSelectArea("TMP")
APPEND FROM &_cArqDsc SDF    

nArquivo := fcreate("c:\temp\"+ Alltrim(_cArquivo) + ".TXT", 0)

/// Executa a leitura do início ao fim do arquivo temporário, 
/// obtendo as colunas de dados necessárias
dbSelectArea("TMP")
dbGoTop()
Do While !Eof()
	
	// Variaveis
	_cLpad	  	:= ""
	_cData		:= "  /  /  "
	_cDebit		:= ""	
	_cCredi		:= ""	
	_cvalor     := ""
	_nValor		:= 0
	_cDescr		:= ""	
	_cCustoD	:= ""		
	_cCustoC	:= ""		
	
	xReg := TMP->T_TXT1
	If !Empty(AllTrim(xReg))
		///VARIAVEIS PARA A IMPORTACAO DOS DADOS ///
		_cLpad		:= AllTrim(GetNextCPO(xReg,1))
		_cData		:= AllTrim(GetNextCPO(xReg,1))		
		_cData		:= Substr(_cData,1,2) +Substr(_cData,4,2)+ Substr(_cData,7,2)  
		_cData		:=STRTRAN(_cData,"/","")	
		_dData		:= CTOD(_cData)
		_cDebit		:= AllTrim(GetNextCPO(xReg,1)) 
		_cDebit		:= STRTRAN(_cDebit,".","")	
		_cCredi		:= AllTrim(GetNextCPO(xReg,1)) 
		_cCredi		:= STRTRAN(_cCredi,".","")	
		_cvalor		:= AllTrim(GetNextCPO(xReg,1))
		_cValor		:= STRTRAN(_cValor,".","")
		_cValor		:= STRTRAN(_cValor,",","")
		_nValor		:= Val(_cValor)		
		_cDescr		:= AllTrim(GetNextCPO(xReg,1)) 
		_cDescr		:= NoAcento(_cDescr)
		_cCustoD	:= AllTrim(GetNextCPO(xReg,1))    
		_cCustoC	:= AllTrim(GetNextCPO(xReg,1))    
	
		_cLinha := _cLpad + strzero(Val(_cData),6) + PADR(_cDebit,10) + PADR(_cCredi,10) + Padl(_cValor, 14) + PADR(_cDescr,40) + PADR(_cCustoD,9)+ PADR(_cCustoC,9)

        fwrite(nArquivo, _cLinha + chr(13) + chr(10))    
        if ferror() # 0
           msgalert ("ERRO AO GRAVAR NO ARQUIVO, ERRO: " + str(ferror()))
        endif


	EndIf                       
	dbSelectArea("TMP")
	dbSkip()
EndDo 


fclose(nArquivo) 
 
//
/// Apaga o arquivo temporário
dbSelectarea("TMP")
dbCloseArea()
Ferase(_cArqTMP+".DBF")
//

Return



//-------------------------------------------------------
// FUNÇÃO QUE GRAVA O ARQUIVO EXCEL EM DISCO.
//-------------------------------------------------------
Static Function Grv_Disco(_cArqDsc,_cTXT)
/// VERIFICA SE EXISTEM LINHAS
If !File(_cArqDsc)
	If (_nHdlTxt := FCreate( _cArqDsc,0 )) < 0
		ApMsgInfo("Nao conseguiu criar o arquivo "+ _cArqDsc )
		Return
	Endif
Else
	fErase( _cArqDsc )
	If (_nHdlTxt := FCreate( _cArqDsc,0 )) < 0
		ApMsgInfo("O arquivo "+_cArqDsc+" ja' existia, foi apagado e mesmo assim, nao consegui-se criar um novo arquivo")
		Return
	Endif
EndIf
/// Gerando novo arquivo
FSeek(_nHdlTxt,0)
FWrite(_nHdlTxt,_cTXT)
FClose(_nHdlTxt)
Return()


//-------------------------------------------------------
//-- Funcao que cria arquivo temporário
//-------------------------------------------------------
Static Function Cria_TMP()
Public _cArqTMP,_aTmp
_aTmp:= {}
AADD(_aTmp,{"T_TXT1" 	,"C",500,0})
_cArqTMP := CriaTrab(_aTmp,.T.)
dbUseArea(.T.,,_cArqTMP,"TMP")
dbSelectArea("TMP")
Return

                         
///---------------------------------------------------------
/// Função que obtem o dado da próxima coluna. 
///---------------------------------------------------------
Static Function GETNEXTCPO(_xTXT,_nTp)
/// Função que retira de uma STRING um pedaço do TEXTO
/// que vai da posição inicial até encontrar a primeira
/// marcação de TABULACAO, ou até chegar ao final do
/// texto.
///---------------------------------------------------------
If _nTp = 1
	_nQuebra 	:= at(CHR(9),_xTXT)
Else
	_nQuebra 	:= at(CHR(13),_xTXT)
EndIf
If _nQuebra = 0
	_nQuebra = Len(AllTrim(_xTxt))+1
EndIf
_cRet := Substr(_xTXT,1,_nQuebra-1)
xReg := AllTrim(Substr(_xTXT,_nQuebra+1,Len(_xTXT)))
Return(_cRet)


          
static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
Return(cString)
                           