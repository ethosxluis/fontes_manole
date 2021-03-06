#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SUBSPLACE �Autor  �Microsiga           � Data �  07/25/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION SUBSPLACE()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt
Private cFileOpen := ""

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " ECF                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

RETURN()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SUBSPLACE �Autor  �Microsiga           � Data �  07/25/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function OkLeTxt
Local cExtAnex	:= "Arquivos TXT| *.txt"
Local cTitAnex := "Selecionar Arquivo" 
Local cNome	:=  "ECF_CONVERTIDO_"+replace(time(),":","")+".TXT"
//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������
cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.T.)
FT_FUse(cFileOpen)
Private nHd2    := fCreate("C:\TEMP\ECF_CONVERTIDO.TXT")
Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  25/07/16   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont
Local aECF	:= {}
Local aDepara	:= {}
Local nTamFile, nTamLin, cBuffer, nBtLidos, cLin, cCpo
local nVolta	:= 0

// CORRENDO O DEPARA
cQuery := "SELECT * FROM DEPARA"
IIF(SELECT("TRB")>0,TRB->(DBCLOSEAREA()),NIL)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
WHILE TRB->(!EOF())
	IncProc()
	AADD(aDepara,{ALLTRIM(TRB->CODIGO),ALLTRIM(TRB->CONTA_VELHA),ALLTRIM(TRB->DESCRICAO),ALLTRIM(TRB->SALDO),ALLTRIM(TRB->CONTA_NOVA)})
	TRB->(DBSKIP())
END


FT_FGoTop()
nVoltaTot	:= FT_FLastRec()
ProcRegua(nVoltaTot*4)
FT_FGoTop()

// processo para armazenar no array o ecf
While !FT_FEof()
	nVolta	+= 1
	cBuffer   := FT_FReadLn()
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	AADD(aECF,ARRAY(35))
	IncProc(cValtochar(nVolta)+' de '+cValtochar(nVoltaTot))
	nCol := 1
	while at('|',cBuffer)>0
		cBuffer := substr(cBuffer,at('|',cBuffer)+1)
		aECF[LEN(aECF)][nCol] := alltrim(substr(cBuffer,1,at('|',cBuffer)-1))
		nCol += 1
	end
	aECF[LEN(aECF)][nCol] := alltrim(cBuffer)
	for nFor := nCol to 35
		aECF[LEN(aECF)][nFor] := "&"
	next nFor
	// COORENDO O FOR PARA SABER SE ACHA A CONTA REDUZIDA NO ARRAY DO ECF E SUBSTITUIR POR CONTA NOVA
	FOR nFor1 := 1 to len(aDepara)
		For nFor2 := 1 to len(aECF[LEN(aECF)])
			if aECF[LEN(aECF)][nFor2] == aDepara[nFor1][1]
				aECF[LEN(aECF)][nFor2] := aDepara[nFor1][5]
			ENDIF
		Next nFor2
	Next nFor1
	cLin := ""
    FOR nFor3 := 1 to len(aECF[LEN(aECF)])
    	if alltrim(aECF[LEN(aECF)][nFor3]) != '&'
    		cLin += "|"+alltrim(aECF[LEN(aECF)][nFor3])
    	endif
    next nFor3
    cLin+=cEOL
    //���������������������������������������������������������������������Ŀ
    //� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
    //� linha montada.                                                      �
    //�����������������������������������������������������������������������

    If fWrite(nHd2,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif
    aECF := {}
	FT_FSkip()
 EndDo
FT_FUSE()
fclose(nHd2)
Return

