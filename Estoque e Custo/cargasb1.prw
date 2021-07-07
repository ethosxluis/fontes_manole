#include "Protheus.ch"
#include "FileIo.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CargaSB1  �Autor  �Ivan Caproni        � Data �  11/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CargaSB1
Local cArquivo	:= ""
Local nHandle	:= 0
Local cTime		:= ""
Local nHLog		:= 0
Local aPath		:= {}
Local cPasta	:= ""
//���������������������������Ŀ
//�Solicita arquivo ao usu�rio�
//�����������������������������
If Empty((cArquivo := cGetFile("Arquivo CSV|*.CSV","Selecione arquivo",1,"C:\",.F.,GETF_LOCALHARD,.F.)))
	MsgStop(cCancel)
	Return
Endif
//���������������������������������������A�
//�Obt�m o tempo inicial de processamento�
//���������������������������������������A�
cTime := Time()
//����������������������������������������������������
//�Abre o arquivo planilha enviado pela contabilidade�
//����������������������������������������������������
If ( nHandle := FT_FUse(cArquivo) ) == -1
	MsgStop('Erro ao abrir o arquivo.')
	Return
Endif
//������������������������������������������������������������������Ŀ
//�Separa o arquivo informado pelo usu�rio e retira o nome do arquivo�
//��������������������������������������������������������������������
aPath := Separa(cArquivo,"\") ; aEval(aPath,{|x| cPasta += x + "\" },1,Len(aPath)-1)
//�����������������������������������������������������Ŀ
//�Verifica se o arquivo existe e se for o caso, apaga-o�
//�������������������������������������������������������
//Iif(File(cPasta+"log.csv"),Ferase(cPasta+"log.csv"),)
//�����������������������������������������Ŀ
//�Cria um novo arquivo para armazenar o log�
//�������������������������������������������
If ( nHLog := FCreate(cPasta+"log.csv", FC_NORMAL) ) == -1
	MsgStop('Erro ao criar o arquivo de log.')
	Return
Endif
//����������������������Ŀ
//�Inicia o processamento�
//������������������������
//Processa({||U_ProcCSV(nHLog)},"Processando","000000/000000",.T.)
//U_PROCCSV()
//����������������������������������������������������������������������
//�Calcula o tempo de processamento e o mostra na tela e no console log�
//����������������������������������������������������������������������
//cTime := ElapTime(cTime,Time())
//MsgInfo("Tempo de processamento: "+cTime)
//CONOUT("[CARGASB1] Tempo de processamento: "+cTime)
//Return .T.
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CargaSB1  �Autor  �Ivan Caproni        � Data �  11/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
//user Function ProcCSV(nHandle)
//user Function PROCCSV()


//Local nContador	:= 1
//Local nLast			:= 0
/*Local nInd			:= 0
Local aCabecalho	:= {}
Local aLinha		:= {}
Local cOrdem1		:= "B1_FILIAL+B1_COD"
//Local cOrdem2		:= "B1_FILIAL+B1_PNUMBER"
Local lAltera		:= .T.
*/
nLast			:= 0
nLast := FT_FLastRec()
aLinha		:= {}
MSGSTOP("PROCCSV")

If nLast > 0
	ProcRegua(nLast)
//	SB1->( dbSetOrder(RetOrder("SB1",cOrdem1)) )
	FT_FGoTop()
	While ! FT_FEof()


	
//		IncProc(StrZero(nContador,6)+"/"+StrZero(nLast,6))
		aLinha := Separa(FT_FReadLn(),";")
/*		If ! SB1->( dbSeek(xFilial("SB1")+aLinha[1]) )
			If SB1->( IndexKey() == cOrdem1 )
				SB1->( dbSetOrder(RetOrder("SB1",cOrdem2)) )
			Else
				SB1->( dbSetOrder(RetOrder("SB1",cOrdem1)) )
			Endif
			If ! SB1->( dbSeek(xFilial("SB1")+aLinha[1]) )
				lAltera := .F. // N�o encontrou
			Endif
		Endif		
  */

		  DBSELECTAREA("ZAC")
  		  DBSETORDER(2)
  			IF DBSEEK(xfilial("ZAC")+UPPER(ALLTRIM(aLinha[2])))
     			_area := ZAC->ZAC_CODIGO
  			ENDIF

  		  DBSELECTAREA("ZAF")
  		  DBSETORDER(2)
  			IF DBSEEK(xfilial("ZAF")+UPPER(ALLTRIM(aLinha[3])))
				IF _area == ZAF->ZAF_AREA
     				_categ := ZAF->ZAF_CATEG
				else
					WHILE !EOF().AND.UPPER(ALLTRIM(aLinha[3])) == alltrim(ZAF->ZAF_DCATEG)
		  				if _area == ZAF->ZAF_AREA
		    				_categ := ZAF->ZAF_CATEG
		  				Endif
					dbskip()
					enddo
				endif
  			ENDIF
  
  
  			DBSELECTAREA("ZAG")
  			DBSETORDER(2)
    		IF DBSEEK(xfilial("ZAG")+UPPER(ALLTRIM(aLinha[4])))
	  			if ZAG->ZAG_CATEG == _categ
     				_subcat := ZAG->ZAG_SUBCAT
	  			else
		  			while !eof().and.ALLTRIM(ZAG->ZAG_DSUBCA) == UPPER(ALLTRIM(aLinha[4]))
		    	  		if ZAG->ZAG_CATEG == _categ
    			 			_subcat := ZAG->ZAG_SUBCAT
				  		Endif
				   dbskip()
		  			enddo
    			ENDIF
			ENDIF
		    dbselectarea("SB1")
			dbsetorder(1)
			dbgotop()
    			If dbseek(xFilial("SB1")+aLinha[1])
					Begin Transaction
					RecLock("SB1",.F.)
						SB1->B1_DEPVTEX	    := _area 
						SB1->B1_CATEGOR		:= _categ 
						SB1->B1_VTSUBCA		:= _subcat 
					SB1->( MsUnlock() )
					End Transaction
				Endif
		/*	_area := " "
			_categ:= " "
			_subcat:= " "*/
//		lAltera := .T.
	FT_FSkip()
//		nContador++
		//If nContador > 500 ; Exit ; Endif
	End
Endif

FT_FUse() //Fecha arquivo CSV
FClose(nHandle) //Fecha o arquivo de log
Return
