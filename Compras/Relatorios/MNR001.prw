#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "FWPrintSetup.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"

#DEFINE	nCol	010
#DEFINE	nEsp	"-2"

//-----------------------------------------------------------\\
/*/{Protheus.doc} MNR001
//Imprimir formulário RPA.
@author Claudio
@since 15/04/2018
@version 1.0
@type function
/*/
//-----------------------------------------------------------\\
User Function MNR001()
	
Local cNumRPA   := SZ6->Z6_NUM
Local cPathFile := U_GetPathFile(RetCodUsr())
Local cNomeArq  := "RPA_" + cNumRPA
Local cSession  := GetPrinterSession()
Local lAdjust   := .F.
Local nFlags    := PD_ISTOTVSPRINTER
Local nLocal    := 1
Local nOrdem 	:= 1
Local nOrient   := 1
Local nPrintType:= 6
Local oPrinter 	:= Nil

Private cRootPath := GetSrvProfString("StartPath","\system\")
Private nLinha	  := 15
Private oFont12N  := TFont():New('Arial',,-12,.F.)
Private oFont12B  := TFont():New('Arial',,-12,.T.)
Private nMaxLin   :=800
Private nMaxCol   :=600

cSession := GetPrinterSession()

oPrinter := FWMSPrinter():New(cNomeArq, nPrintType, lAdjust, cPathFile, .T.)
	
oPrinter:lServer := .F.
oPrinter:SetDevice(nPrintType)
oPrinter:SetPortrait()
oPrinter:SetPaperSize(2)
oPrinter:setCopies(1)
oPrinter:nDevice := IMP_PDF
oPrinter:cPathPDF := cPathFile
oPrinter:SetViewPDF(.T.)
oPrinter:SetFont(oFont12N)
		
RptStatus({|lEnd| U_MNR001A(@lEnd,nOrdem, @oPrinter, cNumRPA)},"Imprimindo Formulário RPA ...")

oSetup   := Nil
oPrinter := Nil
	
Return Nil
//-----------------------------------------------------------\\
/*/{Protheus.doc} MNR001A
// Função para impressão do formulário.
@author Claudio
@since 15/04/2018
@version 1.0
@type function
/*/
//-----------------------------------------------------------\\
User Function MNR001A(lEnd, nOrdem, oPrinter, cNumRPA)

Local cAliasSZ5 := GetNextAlias()
Local cAliasSZ6 := GetNextAlias()
Local nLinMemo  := 0
Local cTxtLinha := ""

// -------------- Select para listar os dependentes -------------\\
BeginSQL Alias cAliasSZ5 

SELECT Z5_NOME, Z5_DTNASC, Z5_CPF, CASE Z5_PARENT 
		   						   WHEN '1' THEN 'Pai'
								   WHEN '2' THEN 'Mae'
								   WHEN '3' THEN 'Filho'
								   WHEN '4' THEN 'Conjuge'
								   WHEN '5' THEN 'Outros' END AS Z5_PARENT                                                                                          
		
FROM %Table:SZ6% SZ6 INNER JOIN %Table:SC7% SC7 ON 
		C7_NUM = Z6_NUMPED
	AND SC7.%notDel% INNER JOIN %Table:SA2% SA2 ON
		A2_COD  = C7_FORNECE
	AND A2_LOJA = C7_LOJA
	AND A2_MSBLQL <> '1'
	AND SA2.%notDel% INNER JOIN %Table:SZ5% SZ5 ON
		Z5_FORNEC = A2_COD
	AND Z5_LOJA   = A2_LOJA
	AND SZ5.%notDel%

WHERE Z6_NUM = %Exp:cNumRPA%

EndSQL

// -------------- Select para listar o formulário RPA -------------\\
BeginSQL Alias cAliasSZ6 

	SELECT Z6_NUM, Z6_DTINI, Z6_DTFIM, Z6_VALOR, CASE Z6_FORMPAG 
							             		 	WHEN '1' THEN 'Transferência' END AS Z6_FORMPAG, 
							             		 			             				 
			A2_NOME, A2_END, A2_CEP, A2_BAIRRO, A2_MUN, A2_EST, A2_CGC, A2_INSCR,
			Z4_BANCO, Z4_AGENCIA, Z4_CONTA, Z4_DTNASC, Z4_NACIO, Z4_NATUR, Z4_PIS,
			B1_VTTITUL,
			CASE C7_XTPREC 
				WHEN 'B' THEN 'Bruto' 
				WHEN 'L' THEN 'Líquido' END AS C7_XTPREC                                                                                       
			
	FROM %Table:SZ6% SZ6 INNER JOIN %Table:SC7% SC7 ON 
			C7_NUM = Z6_NUMPED
		AND SC7.%notDel% INNER JOIN %Table:SA2% SA2 ON
			A2_COD  = C7_FORNECE
		AND A2_LOJA = C7_LOJA
		AND A2_MSBLQL <> '1'
		AND SA2.%notDel% INNER JOIN %Table:SZ4% SZ4 ON
			Z4_FORNEC = A2_COD
		AND Z4_LOJA   = A2_LOJA
		AND SZ4.%notDel% JOIN %Table:SB1% SB1 ON
		   SB1.B1_COD = C7_XISBN
	    AND SB1.%notDel%
	
	WHERE Z6_NUM = %Exp:cNumRPA%
EndSQL

While !Eof()
	IF lEnd
		oPrinter:StartPage()
		oPrinter:Say(nLinha,010,"CANCELADO PELO OPERADOR")
		oPrinter:EndPage()
		oPrinter:Print()
		Exit
	EndIF

	oPrinter:StartPage()

	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,,nEsp)
	nLinha += 5
	oPrinter:SayBitmap(nLinha,nCol, cRootPath+"lgmid99.png", 50, 50)
	nLinha += 40
	oPrinter:SayAlign(nLinha,nCol,"SOLICITAÇÃO DE RPA Nº " + (cAliasSZ6)->Z6_NUM,oFont12B,590,10,,1,0 )
	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,,nEsp)
	nLinha += 30
	oPrinter:SayAlign(nLinha,nCol,"DADOS DO PRESTADOR",oFont12B,nMaxCol,10,,0,0 )
	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,, nEsp)
	nLinha += 5
	oPrinter:SayAlign(nLinha,nCol,"Nome .............:",oFont12N,65,10,,1,0)
	oPrinter:SayAlign(nLinha,80,(cAliasSZ6)->A2_NOME,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,450,"Data Nascimento:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,535,DTOC(STOD((cAliasSZ6)->Z4_DTNASC)),oFont12N,nMaxCol,10,,0,0)
	nLinha += 15
	oPrinter:SayAlign(nLinha,nCol,"Endereço .......:",oFont12N,65,10,,1,0)
	oPrinter:SayAlign(nLinha,80,(cAliasSZ6)->A2_END,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,450,"CEP:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,535,(cAliasSZ6)->A2_CEP,oFont12N,nMaxCol,10,,0,0)
	nLinha += 15
	oPrinter:SayAlign(nLinha,nCol,"Bairro .............:",oFont12N,65,10,,1,0)
	oPrinter:SayAlign(nLinha,80,(cAliasSZ6)->A2_BAIRRO,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,250,"Cidade:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,335,(cAliasSZ6)->A2_MUN,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,450,"Estado:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,535,(cAliasSZ6)->A2_EST,oFont12N,nMaxCol,10,,0,0)
	nLinha += 15
	oPrinter:SayAlign(nLinha,nCol,"CPF ...............:",oFont12N,65,10,,1,0)
	oPrinter:SayAlign(nLinha,80,(cAliasSZ6)->A2_CGC,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,250,"RG:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,335,(cAliasSZ6)->A2_INSCR,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,450,"PIS:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,535,(cAliasSZ6)->Z4_PIS,oFont12N,nMaxCol,10,,0,0)
	nLinha += 15
	oPrinter:SayAlign(nLinha,nCol,"Nacionalidade:",oFont12N,65,10,,1,0)
	oPrinter:SayAlign(nLinha,80,(cAliasSZ6)->Z4_NACIO,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,250,"Naturalidade:",oFont12N,80,10,,1,0)
	oPrinter:SayAlign(nLinha,335,(cAliasSZ6)->Z4_NATUR,oFont12N,nMaxCol,10,,0,0)
	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,,nEsp)
	nLinha += 30
	oPrinter:SayAlign(nLinha,nCol,"DEPENDENTES IRRF",oFont12B,nMaxCol,10,,0,0 )
	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,, nEsp)
	nLinha += 5
	
	oPrinter:SayAlign(nLinha,nCol,"NOME",oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,300 ,"NASCIMENTO",oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,400 ,"PARENTESCO",oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,500 ,"CPF",oFont12N,nMaxCol,10,,0,0)

	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,, nEsp)
	nLinha += 5

	(cAliasSZ5)->(DbGoTop())

	While (cAliasSZ5)->(!Eof())
	
		oPrinter:SayAlign(nLinha,nCol,(cAliasSZ5)->Z5_NOME,oFont12N,nMaxCol,10,,0,0)
		oPrinter:SayAlign(nLinha,300 ,DTOC(STOD((cAliasSZ5)->Z5_DTNASC)),oFont12N,nMaxCol,10,,0,0)
		oPrinter:SayAlign(nLinha,400 ,(cAliasSZ5)->Z5_PARENT,oFont12N,nMaxCol,10,,0,0)
		oPrinter:SayAlign(nLinha,500 ,(cAliasSZ5)->Z5_CPF,oFont12N,nMaxCol,10,,0,0)
		nLinha += 15

		(cAliasSZ5)->(DbSkip())
		
	Enddo

	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,,nEsp)
	nLinha += 30
	
	oPrinter:SayAlign(nLinha,nCol,"SERVIÇOS",oFont12B,nMaxCol,10,,0,0 )
	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,, nEsp)
	nLinha += 5
	
	oPrinter:SayAlign(nLinha,nCol,"Período de ..................:",oFont12N,100,10,,1,0)
	oPrinter:SayAlign(nLinha,115,DTOC(STOD((cAliasSZ6)->Z6_DTINI)),oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,170,"até",oFont12N,50,10,,0,0)
	oPrinter:SayAlign(nLinha,190,DTOC(STOD((cAliasSZ6)->Z6_DTFIM)),oFont12N,nMaxCol,10,,0,0)
	nLinha += 15

	oPrinter:SayAlign(nLinha,nCol,"Obra/Curso .................:",oFont12N,100,10,,1,0)
	oPrinter:SayAlign(nLinha,115,(cAliasSZ6)->B1_VTTITUL,oFont12N,nMaxCol,10,,0,0)
	nLinha += 15
	oPrinter:SayAlign(nLinha,nCol,"Valor a pagar ..............:",oFont12N,100,10,,1,0)
	oPrinter:SayAlign(nLinha,115,TRANSFORM((cAliasSZ6)->Z6_VALOR, "@E 9,999,999.99"),oFont12N,nMaxCol,10,,0,0)
	nLinha += 15

	oPrinter:SayAlign(nLinha,nCol,"Recebimento ..............:",oFont12N,100,10,,1,0)
	oPrinter:SayAlign(nLinha,115,(cAliasSZ6)->C7_XTPREC,oFont12N,nMaxCol,10,,0,0)
	nLinha += 15

	oPrinter:SayAlign(nLinha,nCol,"Forma de Pagamento :",oFont12N,100,10,,1,0)
	oPrinter:SayAlign(nLinha,115,(cAliasSZ6)->Z6_FORMPAG,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,200,"Banco:",oFont12N,50,10,,0,0)
	oPrinter:SayAlign(nLinha,230,(cAliasSZ6)->Z4_BANCO,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,260,"Agência:",oFont12N,50,10,,0,0)
	oPrinter:SayAlign(nLinha,300,(cAliasSZ6)->Z4_AGENCIA,oFont12N,nMaxCol,10,,0,0)
	oPrinter:SayAlign(nLinha,350,"Conta:",oFont12N,50,10,,0,0)
	oPrinter:SayAlign(nLinha,380,(cAliasSZ6)->Z4_CONTA,oFont12N,nMaxCol,10,,0,0)

	nLinha += 30
	
	oPrinter:SayAlign(nLinha,nCol,"OBSERVAÇÕES COMPLEMENTARES",oFont12B,nMaxCol,10,,0,0 )
	nLinha += 15
	oPrinter:Line(nLinha, nCol, nLinha, nMaxCol,, nEsp)
	nLinha += 5
	
	
	SZ6->(DbSetOrder(1))
	SZ6->(DbSeek(xFilial("SZ6") + cNumRPA))
	
	nLinMemo := MLCount(SZ6->Z6_OBS,250)

	For nI := 1 to nLinMemo
		cTxtLinha := MemoLine(SZ6->Z6_OBS,250,nI)
        If ! Empty(cTxtLinha)
			oPrinter:SayAlign(nLinha,nCol,cTxtLinha,oFont12N,nMaxCol,10,,0,0)
			nLinha += 15
        EndIf
    Next nI
	
	(cAliasSZ6)->(DbSkip())
	
Enddo

(cAliasSZ5)->(dbCloseArea())
(cAliasSZ6)->(dbCloseArea())

oPrinter:Print()
	
Return Nil
	
	