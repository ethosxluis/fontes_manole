#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

USER FUNCTION RCDAR040()
Local cDescFina := "Scanner Contex XD2490"
Local cQuery1 := ""
Local dHoje := ctod("")
Local nLastKey:= 0
Local cDiaOrc := ""
Local cHora:= ""
Local cMinutos:= ""
Local cSegundos:= ""
Local cFilename := ""
Local nValAces := 0
Local cTime
Local cDiretorio
Local cFunAK := ""
Local cNomeUser := ""
Local cFunDepto := ""
Local cFunEmail := ""
Local cObserv := ""
local cNomeUser := ""  
Local cCatalogo := lower(alltrim("\catalogo\catalogo_ctx_xd2490.pdf"))
Local nCoef12x := 0
Local nCoef24x := 0
Local nCoef36x := 0
Local nCoef48x := 0

Private nlin := 0
PRIVATE oArial08N	:= TFont():New("Arial"			,10,10,,.F.,,,,.T.,.F.)		// Negrito
PRIVATE oArial09N	:= TFont():New("Arial"			,09,09,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial10N	:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial11N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial12N	:= TFont():New("Arial"			,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial14N	:= TFont():New("Arial"			,14,14,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12S	:= TFont():New("Courier New",12,12,,.T.,,,,.F.,.F.)		    // SubLinhado

oFont1 := TFont():New('Arial',,-12,.T.,.T.)
oFont2 := TFont():New('Arial',,-10,.T.,.T.)
oFont3 := TFont():New('Arial',,-10,.T.)
oFont4 := TFont():New('Arial',,-22,.T.)
oFont5 := TFont():New('Arial',,-9,.T.,.T.)
oFont6 := TFont():New('Arial',,-14,.T.,.T.)

dHoje := Str(Day(dDatabase),2)+" de "+MesExtenso(dDatabase)+" de "+str(year(dDataBase),4)
cDiaOrc := DTOS(dDatabase)
cTime := TIME() // Resultado: 10:37:17
cHora := SUBSTR(cTime, 1, 2) // Resultado: 10
cMinutos := SUBSTR(cTime, 4, 2) // Resultado: 37
cSegundos := SUBSTR(cTime, 7, 2) // Resultado: 17
cFilename := LOWER("Proposta_XD2490_"+(IIF(ALLTRIM(cEmpresa)=="",alltrim(cNome),alltrim(cEmpresa)))+"_"+cDiaOrc+cHora+cMinutos+cSegundos+".pdf")
cFunAK := alltrim(USRRETNAME(RETCODUSR()))


cNomeUser := substr(cUsuario,7,15)
PswOrder(2)                               // Defino a ordem  // Ordem de nome
If PswSeek(cNomeUser,.T.)                 // Efetuo a pesquisa, definindo se pesquiso usu�rio ou grupo
	aRetUser := PswRet(1)                  // Obtenho o resultado conforme vetor
	cFunDepto := upper(alltrim(aRetUser[1,12]))
	cFunEmail := lower(alltrim(aRetUser[1,14]))
EndIf

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
// Ordem obrig�toria de configura��o do relat�rio
oPrint:SetResolution(72)
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
oPrint:cPathPDF := "C:\" // Caso seja utilizada impress�o em IMP_PDF
cDiretorio := oPrint:cPathPDF
oPrint:StartPage()


If nLastKey == 27
	Set Filter to
	Return
Endif

IMPCABEC()
nlin := 262

oBrush1 := TBrush():New( , CLR_HGRAY )
oPrint:FillRect({nlin-30,30,nlin+10,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin,30,OEMTOANSI("S�o Paulo, "+dHoje),oFont6,1600,CLR_BLACK )


nlin:= nlin+60
oPrint:Say(nlin,35,OEMTOANSI("�"),oFont1,2280,CLR_BLACK );nlin:= nlin+40

IF Len(ALLTRIM(cCnpj)) < 14
	oPrint:Say(nlin,35,OEMTOANSI("CPF: "+SUBSTR(ALLTRIM(cCnpj),0,3)+"."+SUBSTR(ALLTRIM(cCnpj),4,3)+"."+SUBSTR(ALLTRIM(cCnpj),7,3)+"."+SUBSTR(ALLTRIM(cCnpj),10,13)),oFont1,2280,CLR_BLACK );nlin:= nlin+40
	nCoef12x := NOROUND(GETMV("MV_GF12XPF"),5) 
	nCoef24x := NOROUND(GETMV("MV_GF24XPF"),5)
	nCoef36x := NOROUND(GETMV("MV_GF36XPF"),5) 
ELSE
	oPrint:Say(nlin,35,OEMTOANSI("CNPJ: "+SUBSTR(ALLTRIM(cCnpj),0,2)+"."+SUBSTR(ALLTRIM(cCnpj),3,3)+"."+SUBSTR(ALLTRIM(cCnpj),6,3)+"/"+SUBSTR(ALLTRIM(cCnpj),9,4)+"-"+SUBSTR(ALLTRIM(cCnpj),13,15)),oFont1,2280,CLR_BLACK );nlin:= nlin+40
	nCoef12x := NOROUND(GETMV("MV_GF12XPJ"),5)
	nCoef24x := NOROUND(GETMV("MV_GF24XPJ"),5)
	nCoef36x := NOROUND(GETMV("MV_GF36XPJ"),5) 
ENDIF

oPrint:Say(nlin,35,OEMTOANSI("Empresa: "+ALLTRIM(cEmpresa)),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("Contato: "+ALLTRIM(cNome)),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("Telefone:"+"("+SUBSTR(M->Z4_TELEF1,0,2)+") "+SUBSTR(M->Z4_TELEF1,3,4)+"-"+SUBSTR(M->Z4_TELEF1,7,5)),oFont1,2280,CLR_BLACK );nlin:= nlin+60
oPrint:Say(nlin,35,OEMTOANSI("Ref.: Cota��o de Scanner de Grande Formato Contex XD2490 - FORMATO A1"),oFont1,2280,CLR_BLACK );nlin:= nlin+50

oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+100,2280}, oBrush1)
oBrush1:End()
nlin := nlin+65
oPrint:Say(nlin,750,OEMTOANSI("Solu��es Para Digitaliza��o de Grande Formato Contex"),oFont6,2280,CLR_WHITE );nlin:= nlin+80
oPrint:Say(nlin,35,OEMTOANSI("Fundada em 1923 na Dinamarca, a divis�o Contex Technology foi estabelecida em 1980 e em 1988 desenvolveu o primeiro scanner modular monocrom�tico em grandes  "),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("formatos; O primeiro scanner colorido foi desenvolvido em 1996 nos formatos 25''.36'',40'' e 54'' (polegadas). Atualmente a Contex � l�der mundial de tecnologia "),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("de scanners de grande formato com mais de 170 pontos de distribui��o no mundo."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
nlin := nlin+65
oPrint:Say(nlin,35,OEMTOANSI("ALGUNS MERCADOS DE ATUA��O DA LINHA CONTEX"),oFont6,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("S�o ideais para Digitaliza��o de Desenhos, projetos e plantas em v�rios mercados como por exemplo:"),oFont1,2280,CLR_BLACK );nlin:= nlin+60
oPrint:Say(nlin,35,OEMTOANSI("- Arquitetura e Engenharia"),oFont1,2280,CLR_BLACK );oPrint:Say(nlin,1000,OEMTOANSI("- Bureaux de servi�os de reprodu��o e artes gr�ficas"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Toprografia, Fotoplanialtimetria e Imagens de Sat�lite"),oFont1,2280,CLR_BLACK );oPrint:Say(nlin,1000,OEMTOANSI("- Estudo de Solo e Mapeamentos geogr�ficos - GIS"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Renderiza��o e imagens 3D"),oFont1,2280,CLR_BLACK );oPrint:Say(nlin,1000,OEMTOANSI("- Marcenarias, Marmorarias,Esquadrias e Estruturas Met�licas"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Mec�nica, Metalurgia e Usinagem"),oFont1,2280,CLR_BLACK );;oPrint:Say(nlin,1000,OEMTOANSI("- El�trica e Hidr�ulica"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Eletr�nica e Telecomunica��es"),oFont1,2280,CLR_BLACK );;oPrint:Say(nlin,1000,OEMTOANSI("- Moldes em Tecido"),oFont1,2280,CLR_BLACK );nlin:= nlin+60

oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,900,OEMTOANSI("Scanner Contex XD2490 - Formato A1"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
oPrint:SayBitmap(nlin,33,"\imagens\xd2490.bmp",500,350);nlin:= nlin+20
oPrint:Say(nlin,600,OEMTOANSI("CONTEX XD2490"),oFont6,2280,CLR_LARANJA);nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("O scanner Contex XD2490 � um scanner colorido que captura imagens no formato de at� 24 polegadas de largura"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("(aproximadamente 610mm), possui resolu��o de at� 1200 dpi �ticos e velocidade de digitaliza��o de at� 1 polegada por"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("segundo (no modo 400dpi-Turbo 8 bit index color), contando apenas o tempo de digitaliza��o.."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("Com o XD2490 � poss�vel tamb�m capturar imagens com at� 9600 dpi interpolados e digitalizar originais com espessura de at�"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("2 mm gra�as ao novo sistema de alimenta��o de originais AWD (All Wheel Drive) que possibilita uma melhor ader�ncia dos"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("originais."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("Ideal para digitaliza��o de documenta��es t�cnicas coloridas como plantas de engenharia, documentos de arquitetura, croquis"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("planta baixa, esquemas el�tricos e hidr�ulicos entre outras aplica��es CAD-CAM. O scanner XD2490 � a ferramenta perfeita"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("para o profissional que necessita qualidade, velocidade e fidelidade de informa��es."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("Com o software NEXTIMAGE (opcional) o cliente pode aumentar sua produtividade de digitaliza��o com muita facilidade, atrav�s"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("de recursos como digitaliza��o em lotes, remo��o de ru�do, supress�o de fundo entre outros, al�m de dar mais qualidade aos"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("documentos digitalizados."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("O Nextimage software permite salvar arquivos nos formatos TIFF, JPG e PDF e em rede ou em disco local. Gerenciando rapidamente"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("a digitaliza��o para disco, o software NEXTIMAGE � a conex�o perfeita entre os scanners Contex e os mais populares softwares"),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("para gr�ficos, reprogr�ficos, GIS, CAD, Desktop Publishin e arquivamento de Desenhos."),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,850,OEMTOANSI("Condi��es de Pagamento - � Vista"),oFont6,2280,CLR_WHITE );nlin:= nlin+60

oBrush1 := TBrush():New( , CLR_HGRAY )
oPrint:FillRect({nlin,29,nlin+40,1000}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,45,OEMTOANSI("Modelo"),oFont2,2280,CLR_BLACK )
oPrint:Box(nlin,1000,NLIN+40,2000)
oBrush1 := TBrush():New( , CLR_HGRAY )
oPrint:FillRect({nlin,1000,nlin+40,2001}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,1070,OEMTOANSI("Pre�o Promocional com Garantia Balc�o"),oFont2,2280,CLR_BLACK );nlin:= nlin+40

oPrint:Box(nlin,30,NLIN+40,1000)
oPrint:Say(nlin+25,40,OEMTOANSI("Contex XD2490 + NextImage Scan for XD2490"),oFont2,2280,CLR_BLACK )
oPrint:Box(nlin,1000,NLIN+40,2000)
oPrint:Say(nlin+25,1025,"R$ "+ALLTRIM(TRANSFORM(VAL(nValProd),"@E 99,999,999.99")),oFont2,2280,CLR_BLACK );nlin:= nlin+40

For nI := 1 to len(aBrowse)
	IF (aBrowse[nI][1])
		oPrint:Box(nlin,30,NLIN+40,1000)
		oPrint:Say(nlin+25,40,OEMTOANSI(aBrowse[nI][3]),oFont2,2280,CLR_BLACK )
		oPrint:Box(nlin,1000,NLIN+40,2000)
		oPrint:Say(nlin+25,1025,"R$ "+ALLTRIM(TRANSFORM((aBrowse[nI][4]),"@E 999,999.99")),oFont2,2280,CLR_BLACK );nlin:= nlin+40
		nValAces := nValAces+(aBrowse[nI][4])
		cDescFina += " + "+OEMTOANSI(aBrowse[nI][3])
	ENDIF
Next nI

nlin:= nlin+40


oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,900,OEMTOANSI("Condi��es de Financiamento"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
oPrint:Say(nlin+25,30,"Objetos de Financiamento: "+ALLTRIM(cDescFina),oFont2,2280,CLR_BLACK );nlin:= nlin+60

IF nFinancia == "2"
	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano de Financiamento"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,OEMTOANSI("Entrada"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("Presta��es"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	
	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano A"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,"R$"+TRANSFORM(VAL(nValEnt),"@E 99,999,999.99"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("36 presta��es de R$")+TRANSFORM(((val(nValProd)+nValAces)-val(nValEnt))*nCoef36x,"@E 99,999,999.99"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	
	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano B"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,"R$"+TRANSFORM(VAL(nValEnt),"@E 99,999,999.99"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("24 Presta��es de R$")+TRANSFORM(((val(nValProd)+nValAces)-val(nValEnt))*nCoef24x,"@E 99,999,999.99"),oFont2,2280,CLR_BLACK );nlin:= nlin+40

	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano C"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,"R$"+TRANSFORM(VAL(nValEnt),"@E 99,999,999.99"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("12 Presta��es de R$")+TRANSFORM(((val(nValProd)+nValAces)-val(nValEnt))*nCoef12x,"@E 99,999,999.99"),oFont2,2280,CLR_BLACK );nlin:= nlin+50
	

ENDIF
oPrint:Say(nlin+25,30,OEMTOANSI("Financiamento pelo Banco ABN-Aymore, sujeito a an�lise do Banco"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin+25,30,OEMTOANSI("Entrega: Consulte"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin+25,30,OEMTOANSI("Frete: Por conta do cliente"),oFont2,2280,CLR_BLACK );nlin:= nlin+70
oPrint:Say(nlin+25,350,OEMTOANSI("CONSULTE NOSSAS CONDI��ES PARA PAGAMENTO PARCELADO DAS IMPRESSORAS EM AT� 36 MESES"),oFont2,2280,CLR_HBLUE );nlin:= nlin+40

IF nlin >= 2518
	IMPRODAPE(nlin)
	nlin := 262
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,850,OEMTOANSI("Servi�os Inclusos No Fornecimento"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	oPrint:Say(nlin,30,OEMTOANSI("Os servi�os abaixo j� est�o inclusos no pre�o desta proposta."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Suporte Telef�nico: Durante o per�odo de garantia, a AKAD tamb�m oferece suporte telef�nico por meio de seu CALL CENTER (11-3829-7700)"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("das 8 as 18 horas em dias �t�is de acordo com o calend�rio da cidade de S�o Paulo, sendo que as liga�oes s�o limitadas a uma dura��o"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de at� 15 minutos por chamada."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Treinamento: a AKAD oferece treinamendo gratuito de 4 horas para utiliza��o do equipamento. At� 60 dias da compra o cliente ter� direito"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de inscrever gratuitamente de at� 2 (duas) pessoas para o treinamento em turma regular mensal da AKAD - S�o Paulo - SP, sendo que as"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("despesas de locomo��o, estadia e refei��o ser�o por conta do cliente. Ap�s este prazo ser� cobrado treinamneto. As incri��es dever�o ser"),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	oPrint:Say(nlin,30,OEMTOANSI("efetuadas com anteced�ncia pelo telefone (11) 3829-7700 ramais 113,145,147,102."),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	 
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,900,OEMTOANSI("Condi��es Gerais de Garantia"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	
	oPrint:Say(nlin,30,OEMTOANSI("Garantia Balc�o: Garantia de 12 (doze) meses para o scanner e 90 (noventa) dias para a cess�o de direito de uso e hardlock posto laborat�rio AKAD-SP"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Os custos de transporte para ida e volta do produto para manuten��o s�o de responsabilidade do cliente. Caso o cliente solicite visita t�cnica em "),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("campo adicional ser� cobrado a hora t�cnica."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	
ELSE
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,850,OEMTOANSI("Servi�os Inclusos No Fornecimento"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	oPrint:Say(nlin,30,OEMTOANSI("Os servi�os abaixo j� est�o inclusos no pre�o desta proposta."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Suporte Telef�nico: Durante o per�odo de garantia, a AKAD tamb�m oferece suporte telef�nico por meio de seu CALL CENTER (11-3829-7700)"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("das 8 as 18 horas em dias �t�is de acordo com o calend�rio da cidade de S�o Paulo, sendo que as liga�oes s�o limitadas a uma dura��o"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de at� 15 minutos por chamada."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Treinamento: a AKAD oferece treinamendo gratuito de 4 horas para utiliza��o do equipamento. At� 60 dias da compra o cliente ter� direito"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de inscrever gratuitamente de at� 2 (duas) pessoas para o treinamento em turma regular mensal da AKAD - S�o Paulo - SP, sendo que as"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("despesas de locomo��o, estadia e refei��o ser�o por conta do cliente. Ap�s este prazo ser� cobrado treinamneto. As incri��es dever�o ser"),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	oPrint:Say(nlin,30,OEMTOANSI("efetuadas com anteced�ncia pelo telefone (11) 3829-7700 ramais 113,145,147,102."),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,900,OEMTOANSI("Condi��es Gerais de Garantia"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	oPrint:Say(nlin,30,OEMTOANSI("Garantia Balc�o: Garantia de 12 (doze) meses para o scanner e 90 (noventa) dias para a cess�o de direito de uso e hardlock posto laborat�rio AKAD-SP"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Os custos de transporte para ida e volta do produto para manuten��o s�o de responsabilidade do cliente. Caso o cliente solicite visita t�cnica em "),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("campo adicional ser� cobrado a hora t�cnica."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	IMPRODAPE(nlin)
	nlin := 262
ENDIF

oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,1000,OEMTOANSI("Condi��es Gerais"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
oPrint:Say(nlin,30,OEMTOANSI("1 - Quanto ao Equipamento:"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("1.1 - A instala��o el�trica deve ser 110/220Vac, 60Hz, com terra independente e tens�o estabilizada. Os equipamentos vendidos pela AKAD tem componentes eletr�nicos"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("de alta tecnologia e varia��es de tens�o/voltagem podem prejudic�-los, desregul�-los ou at� danific�-los. Para evitar isto o cliente deve ligar o equipamento em"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("rede el�trica estabilizada."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("Os equipamentos devem operar em abiente com temperatura entre 15�C a 35�C e de 10% a 70% de umidade relativa n�o condensada. "),oFont2,2280,CLR_BLACK );nlin:= nlin+40

oPrint:Say(nlin,30,OEMTOANSI("2 - Condi��es Gerais"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.1 - Impostos Inclusos"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.2 - A garantia n�o inclui pe�as de desgaste e os prazos de garantia descritos na proposta j� englobam as previs�es do C�digo de Defesa do Consumidor"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.3 - Prazo de Entrega: IMEDIATO AP�S A COMPROVA��O E LIBERA��O DO PAGAMENTO"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.4 - Os custos de frete do nosso armaz�m em Santa Catarina - SC at� o destino correm por conta do cliente"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.5 - Pagamento parcelado est� sujeito a aprova��o de cr�dito"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.6 - A AKAD n�o se resposabiliza por preju�zos eventuais decorrentes da utiliza��o ou paralisa��o para conserto do equipamento. Caso o cliente v� utilizar"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("o equipamento para presta��o de servi�os, sugerimos contratar por sua conta um seguro de lucros cessantes com sua seguradora."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.7 - A AKAD n�o � respons�vel pela integridade e ou longevidade de qualquer texto, otografias digitais, imagens digitalizadas, imagens hologr�ficas, c�digos de barra,"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("codifica��o de c�digo magn�tico ou combina��es que s�o produzidas, geradas e tranferidas para m�dias e cart�es atrav�s do uso dos equipamentos e programas da Encad,"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("Graphtec, Fargo, Ioline,Canon e Scanvec Amiable."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.8 - Estou ciente e concordo que em caso de cancelamento do pedido n�o terei direito a devolu��o do sinal pago para a AKAD (no limite m�ximo de at� 25% do valor total"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("deste pedido) pois a importa��o est� sendo feita de maneira casada com esse pedido, e em caso de cancelamento a AKAD estar� incorrendo em preju�zos, que ser�o"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("recompensados parcialmente desta maneira"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.9 - Validade da proposta 5 (cinco) dias a partir da sua data."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(""),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(""),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(""),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("Visando informar-lhes sobre a tradi��o e qualidade de nossos produtos, convidamos V.S.as. para uma visita a nossa empresa, atrav�s do endere�o na internet"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("www.AKAD.com.br. Colocamos tamb�m nossos showrooms a vossa disposi��o para visitas acompanhadas pela nossa Ger�ncia de Produto e �rea t�cnica que poder� "),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("oferecer informa��es t�cnicas sobre nossas solu��es."),oFont2,2280,CLR_BLACK );nlin:= nlin+80
nlin:= nlin+80
oPrint:Say(nlin,30,OEMTOANSI("Atenciosamente"),oFont2,2280,CLR_BLACK )
nlin:= nlin+60
oPrint:Say(nlin,30,OEMTOANSI(cFunAK),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(cFunDepto),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("AKAD COMPUTA��O GR�FICA"),oFont2,2280,CLR_BLACK );nlin:= nlin+40

IMPFINAL()

oPrint:Preview()

If MSGYESNO("DESEJA ENVIAR ESTE OR�AMENTO AO CLIENTE")
	U_MAILPROP(cEmpresa,cNome,cTelefone,cEmail,cDiretorio,cFilename,cCatalogo)
Endif

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PROPIPF710�Autor  �RENATO FREIRE         Data �  03/22/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA PARA IMPRIMIR CABE�ALHO E RODAPE DAS PROPOSTAS   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AKAD                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


//�����������������������������������Ŀ
//�IMPRIME CABE�ALHO DA PAGINA INICIAL�
//�������������������������������������
STATIC FUNCTION IMPCABEC
nlin := 22
DO CASE
	CASE SM0->M0_CODIGO == '05'
		oPrint:SayBitmap(nlin,26,"\sigaadv\lgrl05.bmp",380,180 )
	CASE SM0->M0_CODIGO == '08'
		oPrint:SayBitmap(nlin,26,"\sigaadv\lgrl08.bmp",380,180 )
ENDCASE
nlin:= nlin+50
DO CASE
	CASE SM0->M0_CODIGO == '05'
		oPrint:Say(nlin,508,OEMTOANSI("Av. Francisco Matarazzo, 404 1� andar Cj 101 CEP 05001-000 - S�o Paulo - SP - AKAD.com.br"),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("Telefone: ( 11 ) 3829 - 7700   /  Fax : ( 11 ) 3667-0050   Email: info@akad.com.br "),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("CNPJ.: 59.476.598/0001-32  Inscr. Estadual: 112.083.893.116"),oFont3,2280,CLR_BLACK )
	CASE SM0->M0_CODIGO == '08'
		oPrint:Say(nlin,508,OEMTOANSI("Rua C�ndido Espinheira, 866 2� andar CEP 05004-000 - S�o Paulo - SP - IDSUPRI.com.br"),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("Telefone: ( 11 ) 3673 - 2209   /  Fax : ( 11 ) 3667-0050   Email: lojaid@idsupri.com.br"),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("CNPJ.: 59.476.598/0001-32  Inscr. Estadual: 112.083.893.116"),oFont3,2280,CLR_BLACK )
ENDCASE
nlin:= nlin+70
RETURN

//�����������������������������������Ŀ
//�IMPRIME RODAP� E ABRE NOVA P�GINA�
//�������������������������������������
STATIC FUNCTION IMPRODAPE
nlin:= 2857
oPrint:Say(nlin,30,Replicate("_",2280),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,400,OEMTOANSI("Avenida Francisco Matarazzo 404 1�Andar - CEP 05001-000  - S�o Paulo -  SP - Fone: (11) 3829-7700 - Fax: (11) 3667-0050 "),oFont5,2280,CLR_BLACK,);nlin:= nlin+40
oPrint:Say(nlin,950,OEMTOANSI("www.AKAD.com.br"),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:EndPage()
oPrint:StartPage()
IMPCABEC()
RETURN

//�����������������������������������Ŀ
//�IMPRIME RODAP� FINAL�
//�������������������������������������
STATIC FUNCTION IMPFINAL(nlin)
nlin:= 2857
oPrint:Say(nlin,30,Replicate("_",2280),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,400,OEMTOANSI("Avenida Francisco Matarazzo 404 1�Andar - CEP 05001-000  - S�o Paulo -  SP - Fone: (11) 3829-7700 - Fax: (11) 3667-0050 "),oFont5,2280,CLR_BLACK,);nlin:= nlin+40
oPrint:Say(nlin,950,OEMTOANSI("www.AKAD.com.br"),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:EndPage()
RETURN
