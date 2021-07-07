#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA470CTA  � Autor � Totvs              � Data �  26/08/2009 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para adequar o retorno do arquivo de      ���
���          � extrato para localizar o banco no cadastro de bancos.      ���
�������������������������������������������������������������������������͹��
���Uso       � Cardios - Financeiro                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA470CTA()

Local aArea    := GetArea()
Local cBanco   := PARAMIXB[1]
Local cAgencia := PARAMIXB[2]
Local cConta   := PARAMIXB[3]
Local aRetorno := {}

If cBanco == "422"
	cBanco    := cBanco
	cAgencia  := SubStr(cAgencia,2,4)+"0"
	cConta    := StrZero(VAL(cConta),9)
	cConta    :=SubStr(cConta,1,8)+"-"+SubStr(cConta,9,1)
EndIf

aRetorno := {cBanco,cAgencia,cConta}

RestArea(aArea)

Return(aRetorno)