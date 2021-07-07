
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP532DEB  ºAutor  ³Edmar Mendes Prado  º Data ³  07/22/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP532DEB()
Local aAREA_ATU	:= GetArea()
Local aAREA_SE5	:= SE5->( GetArea() )
Local cConta      := ""
Local cChave      := ""


If Alltrim(SE5->E5_TIPO)$ "FOL/FIS/TX/INS/ISS/IRF"

	SED->(dbSetOrder(1))
	SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ))
	cConta	:= SED->ED_CONTA

ElseIf Alltrim(SE5->E5_TIPO) == "RPA"

	// AUTONOMOS A PAGAR
	cConta	:= "215010007"			
	
Else

	// 50066 - DIREITO AUTORAL PJ
	// 20020 - DIREITO AUTORAL PF C/ IR
	If Alltrim(SE5->E5_NATUREZ) $ ("50066/20020")
	
		// DIREITOS AUTORAIS A PAGAR	
		cConta	:= "211090001"
		
	ElseIf Alltrim(SE5->E5_NATUREZ) == "10005"
	
		// FORNECEDORES
		cConta	:= "211070001"
	
	Else
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2")+SE5->E5_CLIFOR+SE5->E5_LOJA))
			cConta	:= SA2->A2_CONTA
	EndIf

EndIf

RestArea(aAREA_SE5)
RestArea(aAREA_ATU)
Return(cConta)
