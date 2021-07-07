#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mnStatPV  �Autor  �Leandro Duarte      � Data �  19/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Retorna status de Liberacao do Pedido de Venda           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dual Comp                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function mnStatPV()

Local xStatcrd := " "
Local xBlcred  := " "
Local xBlsep   := " "
Local xBlest   := " "
Local xRetVend := " "
Local xBlpvabr := " "
Local xBlpvfat := " "
Local xBlest   := " "
Local xFatPar  := " "
//����������������������������������������������������������������������������SX�
//�ALTERA��O PARA N�O INFRIGIR A REGRA DO MBROWSE APOS VARIJOS SELECT E DBSEEK�
//�BY LEANDRO DUARTE 22/08/2015                                               �
//����������������������������������������������������������������������������SX�
Local aArea1 := SC5->(GETAREA())
Local aArea2 := SC9->(GETAREA())
Local cQuery := ""
//���������������������������Ŀ
//�TERMINO DA REGRA DO LEANDRO�
//�����������������������������
//
cQuery := "    SELECT DISTINCT C5_NUM, C5_LIBEROK, C5_NOTA, C9_BLEST, C9_BLCRED, C9_BLEST, C9_BLCRED, CASE WHEN C9_NFISCAL= '   ' THEN '1' ELSE '2' END AS STATUSS, A.C5_EMISSAO "+CRLF
cQuery += "      FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B, "+RETSQLNAME("SC9")+" C  "+CRLF
cQuery += "     WHERE A.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "       AND A.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF
cQuery += "       AND A.C5_EMISSAO >= TO_CHAR(SYSDATE-3,'YYYYMMDD') "+CRLF
cQuery += "       And A.C5_NOTA = ' '  "+CRLF
cQuery += "       And A.C5_BLQ = ' ' "+CRLF
cQuery += "       AND B.C6_FILIAL = '"+xFilial("SC6")+"' "+CRLF
cQuery += "       AND B.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "       AND B.C6_NUM = A.C5_NUM "+CRLF
cQuery += "       AND A.C5_VTEX <> '  ' "+CRLF
cQuery += "       AND C.C9_FILIAL = '"+xFilial("SC9")+"' "+CRLF
cQuery += "       AND C.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "       AND C.C9_PEDIDO = A.C5_NUM "+CRLF
cQuery += "       AND C.C9_PRODUTO = B.C6_PRODUTO "+CRLF
cQuery += " ORDER BY  C5_EMISSAO, C5_NUM "
IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRBTR", .T., .T.)
WHILE TRBTR->(!EOF())
	xBlpvabr 	:= TRBTR->C5_LIBEROK
	xBlpvfat 	:= TRBTR->C5_NOTA
	xBlcred  	:= TRBTR->C9_BLCRED
	xBlsep   	:= Posicione("CB9",2,xFilial("CB9")+TRBTR->C5_NUM,"SC7_STATUS")
	XBLEST		:= TRBTR->C9_BLEST
	XBLCRED		:= TRBTR2->C9_BLCRED
	xFatPar		:= TRBTR2->STATUSS
	If xBlcred == '09'
		xStatcrd:= "REJEITADO CREDITO"
	EndIf
	If xBlpvabr == ' '
		xStatcrd:= "AGUARDANDO LIBERACAO DO PEDIDO"
	EndIf
	If xBlcred == '01'
		xStatcrd:= "BLOQUEADO POR CREDITO"
	EndIf
	If  xBlcred == ' ' .and. xBlsep $ '0,1,2,3,4'
		xStatcrd:= "EM SEPARACAO"
	EndIf
	If xBlest == '02'
		xStatcrd:= "BLOQUEIO DE ESTOQUE"
	EndIf
	If  xBlcred == ' ' .and. xBlsep $ '5,6,7,8,9' .and. xBlpvabr == 'S'
		xStatcrd:= "AGUARDANDO FATURAMENTO"
	EndIf
	If  !Empty(xBlpvfat)
		xStatcrd:= "PEDIDO FATURADO"
	EndIf
	If xFatPar == '1'
		xStatcrd:= "PEDIDO FATURADO PARCIALMENTE"
	EndIf
	TRBTR->(DBSKIP())
END

//����������������������������������������������������������������������������SX�
//�ALTERA��O PARA N�O INFRIGIR A REGRA DO MBROWSE APOS VARIJOS SELECT E DBSEEK�
//�BY LEANDRO DUARTE 22/08/2015                                               �
//����������������������������������������������������������������������������SX�
RESTAREA(aArea2)
RESTAREA(aArea1)
//���������������������������Ŀ
//�TERMINO DA REGRA DO LEANDRO�
//�����������������������������
Return(xStatcrd)
