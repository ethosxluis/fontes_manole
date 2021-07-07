#include "Protheus.ch"

/*������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������
����������������������������������������������������������������������������������Ŀ��
���Fun�ao    � FT080DSC  | Autor � Deosdete Silva                � Data � 03/01/11 ���
����������������������������������������������������������������������������������Ĵ��
���Descri�ao � Desconto                                                            ���
���          � Ponto de entrada para customizar o desconto                         ���
���          � Considera o seguimento do produto de acordo com o cliente           ���
����������������������������������������������������������������������������������Ĵ��
���Uso       � Editora Manole                                                      ���
����������������������������������������������������������������������������������Ĵ��
���Parametros� PARMIXB[1] = Preco de lista                                         ���
���          � PARMIXB[2] = Pre�o de venda com o desconto do padrao                ���
����������������������������������������������������������������������������������Ĵ��
���Retorno   � nPrcVen = Pre�o de Venda calculado desconto                         ���
����������������������������������������������������������������������������������Ĵ��
���              ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                  ���
����������������������������������������������������������������������������������Ĵ��
���  Analista     � Data   �BOPS/PL�         Manutencoes efetuadas                 ���
����������������������������������������������������������������������������������Ĵ��
���               �        �       �                                               ���
�����������������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������������
������������������������������������������������������������������������������������*/
User Function FT080DSC()
Local nPrcLista  := PARAMIXB[1] 
Local nPrcVen    := PARAMIXB[2] 
Local nX		:= 0
Local lVldCab   := SubStr(ReadVar(),1,5) == "M->C5"		


If lVldCab
	For nX :=1 To Len(aCols)
		AtuaCols(nX,nPrcLista,nPrcVen)
   	Next nX
Else
	AtuaCols(n,nPrcLista,nPrcVen)
EndIf

nPrcVen := nPrcLista


Return nPrcVen


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT080DSC  �Autor  �Microsiga           � Data �  04/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuaCols(nLin,nPrcLista,nPrcVen)
Local nVlrDUn    	:= 0
Local nPerDsc    	:= 0
Local nPosComi	 	:= 0
Local nPosDesc		:= 0
Local nPosVlDesc 	:= 0
Local nPosValor 	:= 0 
Local nPosPrUn		:= 0
Local nPosSegm      := 0
Local cCampo		:= ReadVar()
Local cSegme      	:= ""
Local cProduto    	:= ""
Local nPerComis		:= 0

//������������������������������Ŀ
//�Verificar o produto           �
//��������������������������������
If cCampo == "M->C6_PRODUTO"
	cProduto := M->C6_PRODUTO
Else
	cProduto := GdFieldGet("C6_PRODUTO", nLin)
EndIf 

//������������������������������Ŀ
//�Verificar o seguimento do item�
//��������������������������������
DbSelectArea("SB1")
DbSetOrder(1) 
If DbSeek(xFilial("SB1")+ cProduto)
	cSegme := SB1->B1_XSEGME
Else
	Return
EndIf 

If !Empty(cSegme)
	If RetiraZero(cSegme) $ "123456"
		nPerDsc 	:= &("M->C5_XDESC"+RetiraZero(cSegme))
		nPerComis	:= &("M->C5_XCOMIS"+RetiraZero(cSegme))
	EndIf
Else
    Aviso("Aten��o!","Nao foi possivel definir o desconto. Segmento em branco. Verifique cadastro do produto " + cProduto,{"Ok"})
EndIf                   
           
_nPDesc		:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_DESCONT"})
_nPDescEs	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_XDESCES"})
_nPCom1Es	:= Ascan(aHeader, { |x| Upper (Alltrim (x[2])) == "C6_XCOM1ES"}) 
If _nPDescEs > 0
	_cDescEs 	:= aCols[nLin][_nPDescEs]
Else 
	_cDescEs 	:= " "
EndIf
                            
If _cDescEs == "S"
	//Busca o percentual de comissao baseando-se no percenntual de desconto que j� est� no item 
	//(n�o obtem o percentual de desconto novamente do cabe�alho)
	nPerComis := U_RETPCOMIS(aCols[nLin][_nPDesc]) 
	GdFieldPut("C6_XSEGME"	, SB1->B1_XSEGME, nLin) 
	If aCols[nLin][_nPCom1Es] <> "S"
		GdFieldPut("C6_COMIS1", nPerComis, nLin)
	EndIf	
Else
	//����������������������������Ŀ
	//�Atualizar campos na GetDados�
	//������������������������������  
	GdFieldPut("C6_XSEGME"	, SB1->B1_XSEGME, nLin) 
	GdFieldPut("C6_DESCONT"	, nPerDsc		, nLin) 
	If aCols[nLin][_nPCom1Es] <> "S"
		GdFieldPut("C6_COMIS1", nPerComis, nLin)
	EndIf
EndIf
                              
Return         
       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetiraZero�Autor  �Paulo Figueira      � Data �  02/17/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retirar zero a esquerda do codigo do segmento              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                          

Static Function RetiraZero(cSegme)
Local cRet   := ""

cRet:= SubStr(cSegme,2,2)

Return cRet

                       