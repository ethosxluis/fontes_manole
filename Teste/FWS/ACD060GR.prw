#INCLUDE "PROTHEUS.CH"
#INCLUDE "apvt100.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACD060GR  �Autor  �Paulo Figueira      � Data �  04/02/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada chamado Envio CQ                          ���
���          � Tela para entrada do tipo de ocorrencia                    ���
�������������������������������������������������������������������������͹��
���Uso       � Editora Manole                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function ACD060GR()
Local aArea     := GetArea()
Local aAreaSDA  := SDA->(GetArea())
Local cTipo     := Space(3)
Local cObs      := Space(TamSX3("PA2_OBS")[1]) 
                       
VTClear()           
   
	@ 0,0 VTSay "Envio C.Q." 
	@ 1,0 VTSay "--- Ocorrencia ---"
	@ 3,0 VTSay "Tipo:" 
	@ 4,0 VtGet cTipo Pict '@!' F3 "_B" Valid  VTLastkey() == 27 ;
	                                   .OR. (!Empty(cTipo) .AND. ExistCpo("SX5","_B" + cTipo))                                                                                            
	@ 5,0 VTSay "Observacao:" 
	@ 6,0 VtGet cObs Pict '@!' 
    	
VTRead

//�������������������������������������������������Ŀ
//�Permitir que o usuario saia abandonando com o Esc�
//���������������������������������������������������
If VtLastkey() == 27
	Return
EndIf


//���������������������������������������������������������Ŀ
//�Posicionar na NF de entrada                              �
//�Posicionar na NF de saida origem a partir da chave abaixo�
//�Pegar as invorma��es da nf de saida origem               �
//�����������������������������������������������������������               
SF1->(DBSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO                                                                                                            
If SF1->(DBSeek(xFilial("SD1")+SDA->(DA_DOC+ DA_SERIE+ DA_CLIFOR+DA_LOJA)))	                         

	//����������������������������������������Ŀ
	//�Tratar numero do RO no cabe�alho da nota�
	//������������������������������������������
	If Empty(F1_XRO)   
		
		RecLock("SF1",.F.)
		
		SF1->F1_XRO := GetSXENum("PA2","PA2_RO")
		
		SF1->(MsUnlock())                 
	
	EndIf

    
EndIf		


	 	                    
//������������������������������������������Ŀ
//�Gravar ocorrencia na tabela de ocorrencias�
//��������������������������������������������
RecLock("PA2",.T.)


PA2->PA2_DOCENT   := SDA->DA_DOC
PA2->PA2_SERIE    := SDA->DA_SERIE
PA2->PA2_CLIFOR   := SDA->DA_CLIFOR 
PA2->PA2_LOJA     := SDA->DA_LOJA 

PA2->PA2_RO       := SF1->F1_XRO
PA2->PA2_TIPO     := cTipo
PA2->PA2_ISBN     := SDA->DA_PRODUTO
PA2->PA2_QTD      := PegQtd()  //TODO PEGAR A QUANTIDADE E GRAVAR
PA2->PA2_OBS      := cObs

  /*               
//���������������������������������������������������������Ŀ
//�Posicionar na NF de entrada                              �
//�Posicionar na NF de saida origem a partir da chave abaixo�
//�Pegar as invorma��es da nf de saida origem               �
//�����������������������������������������������������������               
SD1->(DBSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
IF SD1->(DBSeek(xFilial("SD1")+SDA->(DA_DOC+ DA_SERIE+ DA_CLIFOR+DA_LOJA)))	                         

	PA2->PA2_EMISSAO   := SD1->D1_EMISSAO
	PA2->PA2_NATOPE	   := SD1->D1_TES
	
	//���������������������������������Ŀ
	//�Pegar dados da NF de origem/saida�
	//�����������������������������������
	SD2->(DbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM   
    If SD2-(DbSeek(xFilial("SD1")+SD1->(D1_NFORI+D1_SERIORI+D1_ITEMORI)))

		PA2->DOCORI := SD2->D2_DOC 
		PA2->SERORI := SD2->D2_SERIE
		PA2->EMIORI := SD2->D2_EMISSAO
			
    EndIf
    
EndIf		
    
*/
                 

PA2->(MsUnlock())					

RestArea(aAreaSDA)
RestArea(aArea)
				
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PegQtd    �Autor  �Deosdete Silva      � Data �  02/22/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Apura a quantidade distribuida                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PegQtd()
Local nRet     := 0
Local aAreaSDB := SDB->(getArea())

DbSelectArea("SDB")
DbSetOrder(1) //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM 
If SDB->(DbSeek(xFilial("SDB")+SDA->(DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)))
	While !SDB->(Eof()) .AND. SDB->(DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA) ==;
	                           SDA->(DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)
	
		nRet += SDB->DB_QUANT
		
		SDB->(DbSkip())
		
    EndDo         
    
EndIf

RestArea(aAreaSDB)

Return nRet
