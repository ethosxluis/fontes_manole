#INCLUDE"RWMAKE.CH"
#INCLUDE"TOPCONN.CH"   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONEMAIL  �Autor  �Microsiga           � Data �  01/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �valida campo a1_email na inclusao                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION CONEMAIL()
LRET := .T.
cemail := ALLTRIM(M->A1_EMAIL)

//PRIMEIRA VALIDA��O VERIFICA SE POSSUI @ NO EMAIL
IF !"@" $ cemail
	ALERT("ATEN��O, ENDERE�O DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF

//VALIDA QUANTIDADE DE CARACTERES ANTES DO @
IF LEN(SUBSTR(cemail,1,AT("@",cemail)-1)) < 2
	ALERT("ATEN��O, ENDERE�O DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF                                       


//VALIDA QUANTOS CARACTERES POSSUI DEPOIS DO @ NO MINIMO 4
IF LEN(SUBSTR(cemail,AT("@",cemail)+1)) < 4
	ALERT("ATEN��O, ENDERE�O DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF  


//VALIDA SE NAS POSI��ES APOS O @ TEM .
IF !"." $ SUBSTR(cemail,AT("@",cemail)+1)
	ALERT("ATEN��O, ENDERE�O DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF  

 
//VALIDA no minimo 1 posi��o entre as POSI��ES APOS O @ e antes do .
IF LEN(  SUBSTR( cemail , AT("@",cemail)+1 , AT(".",SUBSTR(cemail, AT("@",cemail)+1))   )) < 3 
	ALERT("ATEN��O, ENDERE�O DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF      

//valida quantidade de caracteres apos o . depois do @
IF LEN(  SUBSTR( cemail , AT("@",cemail)+1+AT(".",SUBSTR(cemail, AT("@",cemail)+1)) )) < 3 
	ALERT("ATEN��O, ENDERE�O DE E-MAIL INVALIDO")
	RETURN .F.
endif

RETURN(LRET)
