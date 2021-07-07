#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPAUX   ºAutor  ³Edmar Mendes do Prado º Data ³  25/05/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Sintaxe de valor de Lp's maiores que o campo               º±±
±±º³ Incluir no campo CT5_VLR01 do Lancamento 650-038: U_LPAUX("650","038")±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Proxxi					                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LPAUX(_cLp,_cSeq)

LOCAL cConta	:= ""
LOCAL aAREA_ATU	:= GETAREA()


If _cLp == "650"
	
	If _cSeq=="038" 

		DBSelectArea("SE2")
		DBSetOrder(6)
		DBSeeK(xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC )
		    
		If Alltrim(SE2->E2_NATUREZ) $ ("50066/20020")
		
			//DIREITOS AUTORAIS A PAGAR
			cConta := "211090001"
			
		Else
		
			//FORNECEDORES
			cConta := "211070001"
		
		EndIf
		
	EndIf
	
EndIf



//IF(ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF"),SED->ED_CONTA,IIF(SE5->E5_TIPO="RPA",215010007,IIF(SE5->E5_NATUREZ="20020","211090001",IIF(SE5->E5_NATUREZ="10005","211070001",SA2->A2_CONTA))))  
If _cLp == "532"
	
	If _cSeq=="001" 
	
		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2") + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA )

		IF ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF")
			
			If  ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF") .And. SE2->E2_CODRET == "0588" .And. SE2->E2_NATUREZ == "50027"	
				cConta := "214010588"							
			ElseIf ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF") .And. SE2->E2_CODRET == "1708" .And. SE2->E2_NATUREZ == "10161"			
				cConta := "214011708"							
			ElseIf ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF") .And. SE2->E2_CODRET == "5952" .And. SE2->E2_NATUREZ == "10167"			
				cConta := "214015952"				
			ElseIf ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF") .And. SE2->E2_CODRET == "8045" .And. SE2->E2_NATUREZ == "10159"			
				cConta := "214018045"				
			ElseIf ALLTRIM(SE5->E5_TIPO) $ ("FOL/FIS/TX/INS/ISS/IRF") .And. SE2->E2_CODRET == "0561" .And. SE2->E2_NATUREZ == "10160"			
				cConta := "214010561"							
			Else					
				DBSelectArea("SED")
				DBSetOrder(1)
				DBSeek( xFilial("SED") + SE2->E2_NATUREZ )
				cConta := SED->ED_CONTA				
			EndIf			
		ElseIf Alltrim(SE5->E5_TIPO) == "RPA"		
			cConta := "215010007"			
		Else
			If Alltrim(SE5->E5_NATUREZ) == "20020" 		
				cConta := "211090001"
			ElseIf 	Alltrim(SE5->E5_NATUREZ) == "10005"
				cConta := "211070001"	
			ElseIf Alltrim(SE5->E5_NATUREZ) =="10127" // Incuido Wallace J. Pereira - 23/04/2020 - solciitado por Carol (Plano Contabil) via e-mail
				cConta := "331020109"
			Else
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA )				
				cConta := SA2->A2_CONTA
				
				
				/*
				Edmar Mendes do Prado - 30/09/2019
				Aplicar após solicitação da Crowe
				*
				DBSelectArea("SED")
				DBSetOrder(1)
				DBSeek( xFilial("SED") + SE2->E2_NATUREZ )
				cConta := SED->ED_CONTA					
				*/
			EndIf
		EndIf
	EndIf
	
EndIf



RESTAREA(aAREA_ATU)

Return(cConta)







