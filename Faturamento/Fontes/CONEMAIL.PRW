#INCLUDE"RWMAKE.CH"
#INCLUDE"TOPCONN.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONEMAIL  ºAutor  ³Microsiga           º Data ³  01/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³valida campo a1_email na inclusao                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CONEMAIL()
LRET := .T.
cemail := ALLTRIM(M->A1_EMAIL)

//PRIMEIRA VALIDAÇÃO VERIFICA SE POSSUI @ NO EMAIL
IF !"@" $ cemail
	ALERT("ATENÇÃO, ENDEREÇO DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF

//VALIDA QUANTIDADE DE CARACTERES ANTES DO @
IF LEN(SUBSTR(cemail,1,AT("@",cemail)-1)) < 2
	ALERT("ATENÇÃO, ENDEREÇO DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF                                       


//VALIDA QUANTOS CARACTERES POSSUI DEPOIS DO @ NO MINIMO 4
IF LEN(SUBSTR(cemail,AT("@",cemail)+1)) < 4
	ALERT("ATENÇÃO, ENDEREÇO DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF  


//VALIDA SE NAS POSIÇÕES APOS O @ TEM .
IF !"." $ SUBSTR(cemail,AT("@",cemail)+1)
	ALERT("ATENÇÃO, ENDEREÇO DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF  

 
//VALIDA no minimo 1 posição entre as POSIÇÕES APOS O @ e antes do .
IF LEN(  SUBSTR( cemail , AT("@",cemail)+1 , AT(".",SUBSTR(cemail, AT("@",cemail)+1))   )) < 3 
	ALERT("ATENÇÃO, ENDEREÇO DE E-MAIL INVALIDO")
	RETURN .F.
ENDIF      

//valida quantidade de caracteres apos o . depois do @
IF LEN(  SUBSTR( cemail , AT("@",cemail)+1+AT(".",SUBSTR(cemail, AT("@",cemail)+1)) )) < 3 
	ALERT("ATENÇÃO, ENDEREÇO DE E-MAIL INVALIDO")
	RETURN .F.
endif

RETURN(LRET)
