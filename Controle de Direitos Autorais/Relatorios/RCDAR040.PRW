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
If PswSeek(cNomeUser,.T.)                 // Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
	aRetUser := PswRet(1)                  // Obtenho o resultado conforme vetor
	cFunDepto := upper(alltrim(aRetUser[1,12]))
	cFunEmail := lower(alltrim(aRetUser[1,14]))
EndIf

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
// Ordem obrigátoria de configuração do relatório
oPrint:SetResolution(72)
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
oPrint:cPathPDF := "C:\" // Caso seja utilizada impressão em IMP_PDF
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
oPrint:Say(nlin,30,OEMTOANSI("São Paulo, "+dHoje),oFont6,1600,CLR_BLACK )


nlin:= nlin+60
oPrint:Say(nlin,35,OEMTOANSI("À"),oFont1,2280,CLR_BLACK );nlin:= nlin+40

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
oPrint:Say(nlin,35,OEMTOANSI("Ref.: Cotação de Scanner de Grande Formato Contex XD2490 - FORMATO A1"),oFont1,2280,CLR_BLACK );nlin:= nlin+50

oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+100,2280}, oBrush1)
oBrush1:End()
nlin := nlin+65
oPrint:Say(nlin,750,OEMTOANSI("Soluções Para Digitalização de Grande Formato Contex"),oFont6,2280,CLR_WHITE );nlin:= nlin+80
oPrint:Say(nlin,35,OEMTOANSI("Fundada em 1923 na Dinamarca, a divisão Contex Technology foi estabelecida em 1980 e em 1988 desenvolveu o primeiro scanner modular monocromático em grandes  "),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("formatos; O primeiro scanner colorido foi desenvolvido em 1996 nos formatos 25''.36'',40'' e 54'' (polegadas). Atualmente a Contex é líder mundial de tecnologia "),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("de scanners de grande formato com mais de 170 pontos de distribuição no mundo."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
nlin := nlin+65
oPrint:Say(nlin,35,OEMTOANSI("ALGUNS MERCADOS DE ATUAÇÃO DA LINHA CONTEX"),oFont6,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("São ideais para Digitalização de Desenhos, projetos e plantas em vários mercados como por exemplo:"),oFont1,2280,CLR_BLACK );nlin:= nlin+60
oPrint:Say(nlin,35,OEMTOANSI("- Arquitetura e Engenharia"),oFont1,2280,CLR_BLACK );oPrint:Say(nlin,1000,OEMTOANSI("- Bureaux de serviços de reprodução e artes gráficas"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Toprografia, Fotoplanialtimetria e Imagens de Satélite"),oFont1,2280,CLR_BLACK );oPrint:Say(nlin,1000,OEMTOANSI("- Estudo de Solo e Mapeamentos geográficos - GIS"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Renderização e imagens 3D"),oFont1,2280,CLR_BLACK );oPrint:Say(nlin,1000,OEMTOANSI("- Marcenarias, Marmorarias,Esquadrias e Estruturas Metálicas"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Mecânica, Metalurgia e Usinagem"),oFont1,2280,CLR_BLACK );;oPrint:Say(nlin,1000,OEMTOANSI("- Elétrica e Hidráulica"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,35,OEMTOANSI("- Eletrônica e Telecomunicações"),oFont1,2280,CLR_BLACK );;oPrint:Say(nlin,1000,OEMTOANSI("- Moldes em Tecido"),oFont1,2280,CLR_BLACK );nlin:= nlin+60

oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,900,OEMTOANSI("Scanner Contex XD2490 - Formato A1"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
oPrint:SayBitmap(nlin,33,"\imagens\xd2490.bmp",500,350);nlin:= nlin+20
oPrint:Say(nlin,600,OEMTOANSI("CONTEX XD2490"),oFont6,2280,CLR_LARANJA);nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("O scanner Contex XD2490 é um scanner colorido que captura imagens no formato de até 24 polegadas de largura"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("(aproximadamente 610mm), possui resolução de até 1200 dpi óticos e velocidade de digitalização de até 1 polegada por"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("segundo (no modo 400dpi-Turbo 8 bit index color), contando apenas o tempo de digitalização.."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("Com o XD2490 é possível também capturar imagens com até 9600 dpi interpolados e digitalizar originais com espessura de até"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("2 mm graças ao novo sistema de alimentação de originais AWD (All Wheel Drive) que possibilita uma melhor aderência dos"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("originais."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("Ideal para digitalização de documentações técnicas coloridas como plantas de engenharia, documentos de arquitetura, croquis"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("planta baixa, esquemas elétricos e hidráulicos entre outras aplicações CAD-CAM. O scanner XD2490 é a ferramenta perfeita"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("para o profissional que necessita qualidade, velocidade e fidelidade de informações."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("Com o software NEXTIMAGE (opcional) o cliente pode aumentar sua produtividade de digitalização com muita facilidade, através"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("de recursos como digitalização em lotes, remoção de ruído, supressão de fundo entre outros, além de dar mais qualidade aos"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("documentos digitalizados."),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI(""),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("O Nextimage software permite salvar arquivos nos formatos TIFF, JPG e PDF e em rede ou em disco local. Gerenciando rapidamente"),oFont1,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,600,OEMTOANSI("a digitalização para disco, o software NEXTIMAGE é a conexão perfeita entre os scanners Contex e os mais populares softwares"),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oPrint:Say(nlin,600,OEMTOANSI("para gráficos, reprográficos, GIS, CAD, Desktop Publishin e arquivamento de Desenhos."),oFont1,2280,CLR_BLACK );nlin:= nlin+30
oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,850,OEMTOANSI("Condições de Pagamento - À Vista"),oFont6,2280,CLR_WHITE );nlin:= nlin+60

oBrush1 := TBrush():New( , CLR_HGRAY )
oPrint:FillRect({nlin,29,nlin+40,1000}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,45,OEMTOANSI("Modelo"),oFont2,2280,CLR_BLACK )
oPrint:Box(nlin,1000,NLIN+40,2000)
oBrush1 := TBrush():New( , CLR_HGRAY )
oPrint:FillRect({nlin,1000,nlin+40,2001}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,1070,OEMTOANSI("Preço Promocional com Garantia Balcão"),oFont2,2280,CLR_BLACK );nlin:= nlin+40

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
oPrint:Say(nlin+25,900,OEMTOANSI("Condições de Financiamento"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
oPrint:Say(nlin+25,30,"Objetos de Financiamento: "+ALLTRIM(cDescFina),oFont2,2280,CLR_BLACK );nlin:= nlin+60

IF nFinancia == "2"
	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano de Financiamento"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,OEMTOANSI("Entrada"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("Prestações"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	
	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano A"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,"R$"+TRANSFORM(VAL(nValEnt),"@E 99,999,999.99"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("36 prestações de R$")+TRANSFORM(((val(nValProd)+nValAces)-val(nValEnt))*nCoef36x,"@E 99,999,999.99"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	
	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano B"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,"R$"+TRANSFORM(VAL(nValEnt),"@E 99,999,999.99"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("24 Prestações de R$")+TRANSFORM(((val(nValProd)+nValAces)-val(nValEnt))*nCoef24x,"@E 99,999,999.99"),oFont2,2280,CLR_BLACK );nlin:= nlin+40

	oPrint:Box(nlin,30,NLIN+40,700)
	oPrint:Say(nlin+25,40,OEMTOANSI("Plano C"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,700,NLIN+40,1400)
	oPrint:Say(nlin+25,712,"R$"+TRANSFORM(VAL(nValEnt),"@E 99,999,999.99"),oFont2,2280,CLR_BLACK )
	oPrint:Box(nlin,1400,NLIN+40,2280)
	oPrint:Say(nlin+25,1488,OEMTOANSI("12 Prestações de R$")+TRANSFORM(((val(nValProd)+nValAces)-val(nValEnt))*nCoef12x,"@E 99,999,999.99"),oFont2,2280,CLR_BLACK );nlin:= nlin+50
	

ENDIF
oPrint:Say(nlin+25,30,OEMTOANSI("Financiamento pelo Banco ABN-Aymore, sujeito a análise do Banco"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin+25,30,OEMTOANSI("Entrega: Consulte"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin+25,30,OEMTOANSI("Frete: Por conta do cliente"),oFont2,2280,CLR_BLACK );nlin:= nlin+70
oPrint:Say(nlin+25,350,OEMTOANSI("CONSULTE NOSSAS CONDIÇÕES PARA PAGAMENTO PARCELADO DAS IMPRESSORAS EM ATÉ 36 MESES"),oFont2,2280,CLR_HBLUE );nlin:= nlin+40

IF nlin >= 2518
	IMPRODAPE(nlin)
	nlin := 262
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,850,OEMTOANSI("Serviços Inclusos No Fornecimento"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	oPrint:Say(nlin,30,OEMTOANSI("Os serviços abaixo já estão inclusos no preço desta proposta."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Suporte Telefônico: Durante o período de garantia, a AKAD também oferece suporte telefônico por meio de seu CALL CENTER (11-3829-7700)"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("das 8 as 18 horas em dias útéis de acordo com o calendário da cidade de São Paulo, sendo que as ligaçoes são limitadas a uma duração"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de até 15 minutos por chamada."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Treinamento: a AKAD oferece treinamendo gratuito de 4 horas para utilização do equipamento. Até 60 dias da compra o cliente terá direito"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de inscrever gratuitamente de até 2 (duas) pessoas para o treinamento em turma regular mensal da AKAD - São Paulo - SP, sendo que as"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("despesas de locomoção, estadia e refeição serão por conta do cliente. Após este prazo será cobrado treinamneto. As incrições deverão ser"),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	oPrint:Say(nlin,30,OEMTOANSI("efetuadas com antecedência pelo telefone (11) 3829-7700 ramais 113,145,147,102."),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	 
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,900,OEMTOANSI("Condições Gerais de Garantia"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	
	oPrint:Say(nlin,30,OEMTOANSI("Garantia Balcão: Garantia de 12 (doze) meses para o scanner e 90 (noventa) dias para a cessão de direito de uso e hardlock posto laboratório AKAD-SP"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Os custos de transporte para ida e volta do produto para manutenção são de responsabilidade do cliente. Caso o cliente solicite visita técnica em "),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("campo adicional será cobrado a hora técnica."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	
ELSE
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,850,OEMTOANSI("Serviços Inclusos No Fornecimento"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	oPrint:Say(nlin,30,OEMTOANSI("Os serviços abaixo já estão inclusos no preço desta proposta."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Suporte Telefônico: Durante o período de garantia, a AKAD também oferece suporte telefônico por meio de seu CALL CENTER (11-3829-7700)"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("das 8 as 18 horas em dias útéis de acordo com o calendário da cidade de São Paulo, sendo que as ligaçoes são limitadas a uma duração"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de até 15 minutos por chamada."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Treinamento: a AKAD oferece treinamendo gratuito de 4 horas para utilização do equipamento. Até 60 dias da compra o cliente terá direito"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("de inscrever gratuitamente de até 2 (duas) pessoas para o treinamento em turma regular mensal da AKAD - São Paulo - SP, sendo que as"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("despesas de locomoção, estadia e refeição serão por conta do cliente. Após este prazo será cobrado treinamneto. As incrições deverão ser"),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	oPrint:Say(nlin,30,OEMTOANSI("efetuadas com antecedência pelo telefone (11) 3829-7700 ramais 113,145,147,102."),oFont2,2280,CLR_BLACK );nlin:= nlin+40	
	oBrush1 := TBrush():New( , CLR_LARANJA )
	oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
	oBrush1:End()
	oPrint:Say(nlin+25,900,OEMTOANSI("Condições Gerais de Garantia"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
	oPrint:Say(nlin,30,OEMTOANSI("Garantia Balcão: Garantia de 12 (doze) meses para o scanner e 90 (noventa) dias para a cessão de direito de uso e hardlock posto laboratório AKAD-SP"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("Os custos de transporte para ida e volta do produto para manutenção são de responsabilidade do cliente. Caso o cliente solicite visita técnica em "),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	oPrint:Say(nlin,30,OEMTOANSI("campo adicional será cobrado a hora técnica."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
	IMPRODAPE(nlin)
	nlin := 262
ENDIF

oBrush1 := TBrush():New( , CLR_LARANJA )
oPrint:FillRect({nlin,30,nlin+40,2280}, oBrush1)
oBrush1:End()
oPrint:Say(nlin+25,1000,OEMTOANSI("Condições Gerais"),oFont6,2280,CLR_WHITE );nlin:= nlin+60
oPrint:Say(nlin,30,OEMTOANSI("1 - Quanto ao Equipamento:"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("1.1 - A instalação elétrica deve ser 110/220Vac, 60Hz, com terra independente e tensão estabilizada. Os equipamentos vendidos pela AKAD tem componentes eletrônicos"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("de alta tecnologia e variações de tensão/voltagem podem prejudicá-los, desregulá-los ou até danificá-los. Para evitar isto o cliente deve ligar o equipamento em"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("rede elétrica estabilizada."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("Os equipamentos devem operar em abiente com temperatura entre 15°C a 35°C e de 10% a 70% de umidade relativa não condensada. "),oFont2,2280,CLR_BLACK );nlin:= nlin+40

oPrint:Say(nlin,30,OEMTOANSI("2 - Condições Gerais"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.1 - Impostos Inclusos"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.2 - A garantia não inclui peças de desgaste e os prazos de garantia descritos na proposta já englobam as previsões do Código de Defesa do Consumidor"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.3 - Prazo de Entrega: IMEDIATO APÓS A COMPROVAÇÃO E LIBERAÇÃO DO PAGAMENTO"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.4 - Os custos de frete do nosso armazém em Santa Catarina - SC até o destino correm por conta do cliente"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.5 - Pagamento parcelado está sujeito a aprovação de crédito"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.6 - A AKAD não se resposabiliza por prejuízos eventuais decorrentes da utilização ou paralisação para conserto do equipamento. Caso o cliente vá utilizar"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("o equipamento para prestação de serviços, sugerimos contratar por sua conta um seguro de lucros cessantes com sua seguradora."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.7 - A AKAD não é responsável pela integridade e ou longevidade de qualquer texto, otografias digitais, imagens digitalizadas, imagens holográficas, códigos de barra,"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("codificação de código magnético ou combinações que são produzidas, geradas e tranferidas para mídias e cartões através do uso dos equipamentos e programas da Encad,"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("Graphtec, Fargo, Ioline,Canon e Scanvec Amiable."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.8 - Estou ciente e concordo que em caso de cancelamento do pedido não terei direito a devolução do sinal pago para a AKAD (no limite máximo de até 25% do valor total"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("deste pedido) pois a importação está sendo feita de maneira casada com esse pedido, e em caso de cancelamento a AKAD estará incorrendo em prejuízos, que serão"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("recompensados parcialmente desta maneira"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("2.9 - Validade da proposta 5 (cinco) dias a partir da sua data."),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(""),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(""),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(""),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("Visando informar-lhes sobre a tradição e qualidade de nossos produtos, convidamos V.S.as. para uma visita a nossa empresa, através do endereço na internet"),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("www.AKAD.com.br. Colocamos também nossos showrooms a vossa disposição para visitas acompanhadas pela nossa Gerência de Produto e área técnica que poderá "),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("oferecer informações técnicas sobre nossas soluções."),oFont2,2280,CLR_BLACK );nlin:= nlin+80
nlin:= nlin+80
oPrint:Say(nlin,30,OEMTOANSI("Atenciosamente"),oFont2,2280,CLR_BLACK )
nlin:= nlin+60
oPrint:Say(nlin,30,OEMTOANSI(cFunAK),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI(cFunDepto),oFont2,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,30,OEMTOANSI("AKAD COMPUTAÇÃO GRÁFICA"),oFont2,2280,CLR_BLACK );nlin:= nlin+40

IMPFINAL()

oPrint:Preview()

If MSGYESNO("DESEJA ENVIAR ESTE ORÇAMENTO AO CLIENTE")
	U_MAILPROP(cEmpresa,cNome,cTelefone,cEmail,cDiretorio,cFilename,cCatalogo)
Endif

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROPIPF710ºAutor  ³RENATO FREIRE         Data ³  03/22/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PROGRAMA PARA IMPRIMIR CABEÇALHO E RODAPE DAS PROPOSTAS   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AKAD                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IMPRIME CABEÇALHO DA PAGINA INICIAL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		oPrint:Say(nlin,508,OEMTOANSI("Av. Francisco Matarazzo, 404 1° andar Cj 101 CEP 05001-000 - São Paulo - SP - AKAD.com.br"),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("Telefone: ( 11 ) 3829 - 7700   /  Fax : ( 11 ) 3667-0050   Email: info@akad.com.br "),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("CNPJ.: 59.476.598/0001-32  Inscr. Estadual: 112.083.893.116"),oFont3,2280,CLR_BLACK )
	CASE SM0->M0_CODIGO == '08'
		oPrint:Say(nlin,508,OEMTOANSI("Rua Cândido Espinheira, 866 2° andar CEP 05004-000 - São Paulo - SP - IDSUPRI.com.br"),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("Telefone: ( 11 ) 3673 - 2209   /  Fax : ( 11 ) 3667-0050   Email: lojaid@idsupri.com.br"),oFont3,2280,CLR_BLACK )
		nlin := nlin+50
		oPrint:Say(nlin,508,OEMTOANSI("CNPJ.: 59.476.598/0001-32  Inscr. Estadual: 112.083.893.116"),oFont3,2280,CLR_BLACK )
ENDCASE
nlin:= nlin+70
RETURN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IMPRIME RODAPÉ E ABRE NOVA PÁGINA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION IMPRODAPE
nlin:= 2857
oPrint:Say(nlin,30,Replicate("_",2280),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,400,OEMTOANSI("Avenida Francisco Matarazzo 404 1°Andar - CEP 05001-000  - São Paulo -  SP - Fone: (11) 3829-7700 - Fax: (11) 3667-0050 "),oFont5,2280,CLR_BLACK,);nlin:= nlin+40
oPrint:Say(nlin,950,OEMTOANSI("www.AKAD.com.br"),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:EndPage()
oPrint:StartPage()
IMPCABEC()
RETURN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IMPRIME RODAPÉ FINAL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION IMPFINAL(nlin)
nlin:= 2857
oPrint:Say(nlin,30,Replicate("_",2280),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:Say(nlin,400,OEMTOANSI("Avenida Francisco Matarazzo 404 1°Andar - CEP 05001-000  - São Paulo -  SP - Fone: (11) 3829-7700 - Fax: (11) 3667-0050 "),oFont5,2280,CLR_BLACK,);nlin:= nlin+40
oPrint:Say(nlin,950,OEMTOANSI("www.AKAD.com.br"),oFont5,2280,CLR_BLACK );nlin:= nlin+40
oPrint:EndPage()
RETURN
