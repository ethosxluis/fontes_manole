#include 'protheus.ch'
#include 'parmtype.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2  �Autor  �Wallace             � Data �  07/04/20   ���
�������������������������������������������������������������������������͹��
���Desc.   � Ponto de Entrada para grava�oa de Campos de Centro de Custo  ���
���        � e Unidade de Negocio do Documento de Entrada para o          ���
���        � Contas a Pagar                                               ���
�������������������������������������������������������������������������͹��
���Uso     � Ponto de Entrada                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100GE2()
Local aTitAtual := PARAMIXB[1]
Local nOpc := PARAMIXB[2]
Local aHeadSE2:= PARAMIXB[3]
Local aParcelas := ParamIXB[5]
Local nX := ParamIXB[4]
If nOpc == 1 //.. inclusao
          SE2->E2_CCUSTO  := SD1->D1_CC
          SE2->E2_XDESCCC := POSICIONE("CTT", 1, XFILIAL("CTT") + SD1->D1_CC, "CTT_DESC01")
          SE2->E2_XCLVL   := SD1->D1_CLVL
          SE2->E2_XDCLVL  := POSICIONE("CTH", 1, XFILIAL("CTH") + SD1->D1_CLVL, "CTH_DESC01")
Endif

Return(Nil)