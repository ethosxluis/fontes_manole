#INCLUDE "rwmake.ch"


User Function LP597CRE()
********************
Local aAREA_ATU	:= GetArea()
Local aAREA_SE5	:= SE5->( GetArea() )
Local cConta      := ""
Local cChave      := ""

If Alltrim(SE5->E5_TIPO)$"NF/PA"

	nREGATU := SE5->(RECNO())

	// procurando lancamento parceiro
	
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
	
		IF Alltrim(SE5->E5_TIPO)=="NF"
		   // se parceiro for NF --> volta no registro ref ao PA
		   SE5->(DBGOTO(nREGATU))
			SED->(dbSetOrder(1))
			SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ))
			cConta	:= SED->ED_DEBITO
		ELSEIF Alltrim(SE5->E5_TIPO)=="PA"
		   // se parceiro for PA --> mantem posicao e pega conta desse
			SED->(dbSetOrder(1))
			SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ))
			cConta	:= SED->ED_DEBITO
		
		ENDIF
	
Else
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+SE5->E5_CLIFOR+SE5->E5_LOJA))
		cConta	:= SA2->A2_CONTA

EndIf

RestArea(aAREA_SE5)
RestArea(aAREA_ATU)
Return(cConta)