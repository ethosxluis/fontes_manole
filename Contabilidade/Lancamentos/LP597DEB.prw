#INCLUDE "rwmake.ch"
/*
臼浜様様様様用様様様様様曜様様様用様様様様様様様様様様僕様様用様様様様様様融臼
臼?ExecBlock ? LP597     ?Autor  ?WALDIR ARRUDA       12/01/12             艮?
臼麺様様様様謡様様様様様擁様様様溶様様様様様様様様様様瞥様様溶様様様様様様郵臼
臼?Desc.     ?  CONTABILIZA巴O DE COMPENSA巴O DE T?TULO A RECEBER DEBITO   艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様郵臼
臼?Uso       ?  SALTON                                                     艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕臼
*/
User Function LP597DEB()
********************
Local aAREA_ATU	:= GetArea()
Local aAREA_SE5	:= SE5->( GetArea() )
Local cConta	:= ""
Local cChave      := ""

If Alltrim(SE5->E5_TIPO)=="PA"
	
	DbSelectArea("SE5")
	
	DbSetOrder(7)
	
	// Procurando o parceiro
	
	cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
	         Substr(SE5->E5_DOCUMEN,4,9)+;
	         Substr(SE5->E5_DOCUMEN,13,2)+;
	         Substr(SE5->E5_DOCUMEN,15,3)+;
	         Substr(SE5->E5_DOCUMEN,18,6)+;
	         Substr(SE5->E5_DOCUMEN,24,4)

	DbSeek( xFilial("SE5") + cCHAVE )
	
	IF ALLTRIM(SE5->E5_TIPO)=="RD" 
		SE2->(DBSETORDER(1))
		cCHAVE := SE5->E5_PREFIXO + SE5->E5_NUMERO  + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
		SE2->(DBSEEK( XFILIAL("SE2") + cCHAVE ))
		cConta := SED->ED_DEBITO
	
	ELSE
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
		cConta	:= SA2->A2_CONTA
	ENDIF
	
Else
	
	DbSelectArea("SE5")
	// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+E5_RECPAG
	DbSetOrder(7)

	cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
	         Substr(SE5->E5_DOCUMEN,4,9)+;
	         Substr(SE5->E5_DOCUMEN,13,2)+;
	         Substr(SE5->E5_DOCUMEN,15,3)+;
	         Substr(SE5->E5_DOCUMEN,18,6)+;
	         Substr(SE5->E5_DOCUMEN,24,4)
	
	DbSeek( xFilial("SE5") + cCHAVE )
	
		
		IF ALLTRIM(SE5->E5_TIPO)=="RD"  // RELAT DESPEAS
			SE2->(DBSETORDER(1))
			cCHAVE := SE5->E5_PREFIXO + SE5->E5_NUMERO  + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
			SE2->(DBSEEK( XFILIAL("SE2") + cCHAVE ))
			cConta := SED->ED_DEBITO
		ELSE
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
			cConta	:= SA2->A2_CONTA
		ENDIF	
EndIf

RestArea(aAREA_SE5)
RestArea(aAREA_ATU)
Return(cConta)

