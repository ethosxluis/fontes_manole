#Include "Protheus.ch"
#Include "RESTFUL.ch"
#Include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERORC    ºAutor  ³Tiago Malta      º Data ³     31/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ função para gerar o html com os dados do orçamento         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GerOrc(cAxFil, cAxOrc)

	Local cHtml  := ""
	Local cTotal := ""
	Local cItens := ""
	Local nAxTotal := 0
	Local oHtml
	Local nValIcm := 0
	Local nValIpi := 0
	Local nAliqIpi:= 0
	Local nTotIpi := 0
	Local nTotIcm := 0
	Local nAxTotI := 0
     	   
	cAxFil := SubStr(Decode64(alltrim(HttpGet->cPar1)), 3, Len(Decode64(alltrim(HttpGet->cPar1))))
	cAxEmp := SubStr(Decode64(alltrim(HttpGet->cPar1)), 1, 2)
	cAxOrc := Decode64(alltrim(HttpGet->cPar2))


	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	
	oHtml := TWFHtml():New("\workflow\orcamentos.html")
    
	dbselectarea("SCJ")
	SCJ->( dbsetorder(1) )
	SCJ->( dbseek( cAxFil + cAxOrc ) )

	dbselectarea("SA1")
	SA1->( dbsetorder(1) )
	SA1->( dbseek( xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ) )
        
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "numorc"   , SCJ->CJ_NUM )
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "emissao"  , Dtoc(SCJ->CJ_EMISSAO) )
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "cliente"  , SCJ->CJ_CLIENTE+"/"+SCJ->CJ_LOJA + " - " + SA1->A1_NOME)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "cnpj"     , Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "enderec"  , SA1->A1_END)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "munic"    , SA1->A1_MUN)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "bairro"   , SA1->A1_BAIRRO)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "uff"      , SA1->A1_EST)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "cepp"     , Transform(SA1->A1_CEP,"@R 99999-999") )
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "telefone" , SA1->A1_TEL)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "email"    , SA1->A1_EMAIL)
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "condpgto" , Posicione("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI"))
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "observa"  , "")

	dbselectarea("SCK")
	SCK->( dbsetorder(1) )
	SCK->( dbseek( SCJ->CJ_FILIAL + SCJ->CJ_NUM ) )
    
	While SCK->( !EOF() ) .AND. SCK->CK_FILIAL == SCJ->CJ_FILIAL .AND. SCK->CK_NUM == SCJ->CJ_NUM
     	
		nValIcm := 0
		nValIpi := 0
		nAliqIpi:= 0
     	
		BuscaImp(SCK->CK_ITEM,@nValIcm,@nValIpi,@nAliqIpi)
     	
		cItens += ' <tr> '
		cItens += '   <td width="74">' +SCK->CK_ITEM+'</td> '
		cItens += '   <td width="89">' +SCK->CK_PRODUTO+'</td> '
		cItens += '   <td width="181">'+SCK->CK_DESCRI+'</td> '
		cItens += '   <td width="83"><center>' +Transform(SCK->CK_QTDVEN,"@E 99999999.99")+'</center></td> '
		cItens += '   <td width="75"><center>' +Transform(SCK->CK_PRCVEN,"@E 99,999,999,999.99")+'</center></td> '
		cItens += '   <td width="95"><center>' +Transform(SCK->CK_VALOR,"@E 99,999,999,999.99")+'</center></td> '
		cItens += '   <td width="58"><center>' +Transform(nValIpi,"@E 99,999,999,999.99")+'</center></td> '
		cItens += '   <td width="66"><center>' +Transform(nAliqIpi,"@E 99999999.99")+'</center></td> '
		cItens += '   <td width="58"><center>' +Transform(nValIcm,"@E 99,999,999,999.99")+'</center></td> '
		cItens += '   <td width="93"><center>' +Transform(SCK->CK_VALOR+nValIpi+nValIcm,"@E 99,999,999,999.99")+'</center></td> '
		cItens += ' </tr> '
	 	
		nAxTotal += SCK->CK_VALOR
		nTotIpi  += nValIpi
		nTotIcm  += nValIcm
		nAxTotI  += SCK->CK_VALOR+nValIpi+nValIcm
	 	
		SCK->( dbskip() )
	Enddo
 	          
 	
	cTotal := ' <tr> '
	cTotal += '  <td>&nbsp;</td> '
	cTotal += '    <td>&nbsp;</td> '
	cTotal += '    <td>&nbsp;</td> '
	cTotal += '    <td>&nbsp;</td> '
	cTotal += '    <td>&nbsp;</td> '
	cTotal += '    <td><center>' +Transform(nAxTotal,"@E 99,999,999,999.99")+'</center></td> '
	cTotal += '    <td><center>' +Transform(nTotIpi,"@E 99,999,999,999.99")+'</center></td> '
	cTotal += '    <td>&nbsp;</td> '
	cTotal += '    <td><center>' +Transform(nTotIcm,"@E 99,999,999,999.99")+'</center></td> '
	cTotal += '    <td><center>' +Transform(nAxTotI,"@E 99,999,999,999.99")+'</center></td> '
	cTotal += '  </tr> '
    
	oHtml:cBuffer := StrTran( oHtml:cBuffer, "itens" , cItens+cTotal)
    
	cHtml 	:= oHtml:cBuffer
	
Return cHtml

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERORC    ºAutor  ³Microsiga           º Data ³  07/31/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BuscaImp(nItem,nValIcm,nValIpi,nAliqIpi)

	Local aArea		:= GetArea()
	Local aRefImp	:= {}

	IF !Empty(SCK->CK_TES)

		MaFisIni(SA1->A1_COD,SA1->A1_LOJA,"C","N",SA1->A1_TIPO,aRefImp)
	
		MaFisIniLoad(Val(nItem))
		MaFisLoad("IT_PRODUTO",SCK->CK_PRODUTO,Val(nItem))
		MaFisLoad("IT_TES"    ,SCK->CK_TES    ,Val(nItem))
		MaFisLoad("IT_QUANT"  ,SCK->CK_QTDVEN ,Val(nItem))
		MaFisLoad("IT_PRCUNI" ,SCK->CK_PRCVEN,Val(nItem))
		MaFisLoad("IT_VALMERC",SCK->CK_VALOR ,Val(nItem))
		MaFisLoad("IT_BASEIPI",SCK->CK_VALOR ,Val(nItem))
		MaFisLoad("IT_BASEICM",SCK->CK_VALOR ,Val(nItem))
		MaFisRecal("IT_TES",Val(nItem))
		MaFisRecal("IT_ALIQICM",Val(nItem))
		MaFisRecal("IT_VALIPI" ,Val(nItem))
		MaFisRecal("IT_VALICM" ,Val(nItem))
		MaFisEndLoad(Val(nItem),2)
	
		nValIpi := MaFisRet(Val(nItem),"IT_VALIPI")
		nValIcm := MaFisRet(Val(nItem),"IT_VALICM")
		nAliqIpi:= MaFisRet(Val(nItem),"IT_ALIQIPI")
	
	Endif

	RestArea(aArea)

Return