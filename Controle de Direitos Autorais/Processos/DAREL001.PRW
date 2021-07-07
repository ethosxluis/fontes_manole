
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออัออออออออัออออออออออออออออออัอออออออัออออออออออปฑฑ
ฑฑบ Programa: ณ DAREL001ณ Autor: ณ E. Gallo         ณ Data: ณ 16/03/12 บฑฑ
ฑฑฬอออออออออออฯัออออออออฯออออออออฯออออออออออออออออออฯอออออออฯออออออออออนฑฑ
ฑฑบ Descricao: ณ Este ้ o Programa de geracao/impressao de Recibo de   บฑฑ
ฑฑบ            ณ direitos autorais em HTML                             บฑฑ
ฑฑฬออออออัอออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso: ณ Protheus 11  - Especifico Manole                            บฑฑ
ฑฑศออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function DAREL001()

Private aRotina := {{ OemToAnsi("Pesquisar")  ,"AxPesqui", 0,1 },;
{  OemToAnsi("Recibo")	,"U_RelMnRec" ,0,2}  ,;
{  OemToAnsi("Recibo Multiplo")	,"U_RelMult" ,0,2}  ,;
{  OemToAnsi("Paramteros")	,"U_RelMnPar" ,0,2}  }



Private cCadastro  	:= OemToAnsi("Recibos D. Autorais ")
private cObsman := supergetmv("MN_OBSREC",,"")

Public _cDir 		:= SuperGetmv("MN_DIRHTML",,"C:\RECDA\")
Public _cPict 		:=  "@e 99,999,999.99"

Dbselectarea("SE2")
SET FILTER TO (E2_PREFIXO = 'RYI' .OR. E2_PREFIXO = 'RYE') .AND. E2_FORNECE <> "UNIAO"

mBrowse( 6, 1,22,75,"SE2")

SET FILTER TO
DbSetOrder(1)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออัออออออออัออออออออออออออออออัอออออออัออออออออออปฑฑ
ฑฑบ Programa: ณRelMnRec ณ Autor: ณ E. Gallo         ณ Data: ณ 20/06/05 บฑฑ
ฑฑฬอออออออออออฯอออออออออฯออออออออฯออออออออออออออออออฯอออออออฯออออออออออนฑฑ
ฑฑบ Descricao: ROTINA DE IMPRESSAO                                     บฑฑ
ฑฑศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RelMnRec

RelMnx(1)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDAREL001  บAutor  ณMicrosiga           บ Data ณ  05/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelMnx(nTipo)
LOCAL ni := 0
Private _ATexto		:= {}
Private _cTexto		:=  ""

_cQUERY := "SELECT * FROM "
_cQUERY += RETSQLNAME("SE2")+","+RETSQLNAME("AH5")
_cQUERY += " WHERE E2_PREFIXO = '"+SE2->E2_PREFIXO + "' "
_cQUERY += " AND E2_FORNECE = '"+SE2->E2_FORNECE+"'  "
_cQUERY += " AND E2_NUM = '"+SE2->E2_NUM+"'  "
_cQUERY += " AND E2_LOJA = '"+SE2->E2_LOJA+"'  "
_cQUERY += " AND AH5_FORNEC  = E2_FORNECE "
_cQUERY += " AND AH5_LOJAFO  = E2_LOJA  "
_cQUERY += " AND AH5_DTPRES = E2_EMISSAO "
_cQUERY += " AND SE2010.D_E_L_E_T_ = ' ' "
_cQUERY += " AND AH5010.D_E_L_E_T_ = ' ' "
_cQUERY += " ORDER BY AH5_FORNEC,AH5_LOJAFO,AH5_PRODUT "

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .T., .T.)

aStru := SE5->(dbStruct())

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('TRB', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

aStru := AH5->(dbStruct())

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('TRB', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

dbselectarea('TRB')
dbgotop()

_nVlrCrd := 0
_nQtdVda := 0
_nQtdDev := 0
_nVlrVda := 0
_nVlrDev := 0
_nVlrDes := 0
_nBaseIr := 0
_nVlrIR	 := 0
_nVlrLiq := 0
_nACVLRVDa := 0
_aPrest  := {}
_nAdiantamento := 0 //FERNANDO CARVALHO
_nTotAdiant := 0 //FERNANDO CARVALHO
cKey := ""
Do while !eof()

	if cKey <> TRB->(AH5_FORNEC+AH5_LOJAFO+AH5_PRODUT)
		cKey := TRB->(AH5_FORNEC+AH5_LOJAFO+AH5_PRODUT)
		//	Dbselectarea("AH5")
		//	DbSetOrder(3)

		//	Dbseek(xfilial("AH5")+TRB->(AH6_PRODUT+AH6_FORNEC+AH6_LOJAFO)+DTOS(TRB->AH6_DTPRES)  )

		_ncQtdVda  :=  0
		_ncVlrVda  :=  0
		_ncQtdDev  :=  0
		_ncVlrDev  :=  0
		_nVlrIR	   :=  ROUND(TRB->E2_IRRF,2)
		_nValorDa  := 0

		_CQUERY1 := " SELECT distinct AH4_PRODUT,SUM(AH4_QTDACU) QTDACU,SUM(AH4_VALACU) BASEDA, ROUND(SUM(AH4_VALORD),2) VALORD  "
		_CQUERY1 += " FROM "+RETSQLNAME("AH4")+" "
		_CQUERY1 += " WHERE AH4_FORNEC = '"+AH5_FORNEC+"' "
		_CQUERY1 += " AND AH4_LOJAFO = '"+AH5_LOJAFO+"' "
		_CQUERY1 += " AND AH4_PRODUT = '"+AH5_PRODUT+"' "
		_CQUERY1 += " AND D_E_L_E_T_ <> '*' "
		_CQUERY1 += " AND AH4_DTPRES = '"+dtos(AH5_DTPRES)+"' "
		_CQUERY1 += " GROUP BY AH4_FORNEC, AH4_PRODUT "
		_CQUERY1 += " ORDER BY AH4_PRODUT	"

		IF SELECT("TRB1")<>0
			DBSELECTAREA("TRB1")
			TRB1->(DBCLOSEAREA())
		ENDIF

		TCQUERY _CQUERY1 NEW ALIAS TRB1
		DBSELECTAREA("TRB1")
		TRB1->(DBGOTOP())
		Do while !TRB1->(eof()) //.and. AH5_PRODUT+AH5_FORNEC+AH5_LOJAFO+DTOS(AH5_DTPRES) == TRB->(AH6_PRODUT+AH6_FORNEC+AH6_LOJAFO)+DTOS(TRB->AH6_DTPRES)
			IF TRB1->VALORD <> 0
				if TRB1->QTDACU > 0

					_ncQtdVda  +=  TRB1->QTDACU
					_ncVlrVda  +=  TRB1->BASEDA

				else

					_ncQtdDev  +=  (TRB1->QTDACU*-1)
					_ncVlrDev  +=  (TRB1->BASEDA*-1)

				endif

				_nVlrCrd += TRB1->VALORD
				_nBaseIr += TRB1->VALORD
				_nVlrLiq += (TRB1->VALORD )
				_nValorDa+= (TRB1->VALORD )
			ENDIF
			TRB1->(Dbskip())

		Enddo
		Dbselectarea("TRB")


		Dbselectarea("SB1")
		Dbseek(xfilial("SB1")+TRB->AH5_PRODUT  )

		Dbselectarea("AH1")
		Dbsetorder(1)
		Dbseek(xfilial("AH1")+TRB->(AH5_PRODUT+AH5_FORNEC+AH5_LOJAFO ) )
		Do case
			case ah1_period == '01'
				_cPeriod := "MEN"
			case ah1_period == '02'
				_cPeriod := "BIM"
			case ah1_period == '03'
				_cPeriod := "TRI"
			case ah1_period == '04'
				_cPeriod := "QUA"
			case ah1_period == '06'
				_cPeriod := "SEM"
			otherwise
				_cPeriod := "ANO"
		Endcase


		Dbselectarea("AH2")
		Dbseek(XFILIAL("AH2")+TRB->(AH5_PRODUT+AH5_FORNEC+AH5_LOJAFO))
		_cFaixas:=''
		Do while !eof() .and.    TRB->(AH5_PRODUT+AH5_FORNEC+AH5_LOJAFO) == AH2_PRODUT+AH2_FORNEC+AH2_LOJAFO
			_nAdiantamento := TRB->(AH5_XADIPE)//FERNANDO CARVALHO
			_cFaixas +=   ALLTRIM(TRANSFORM(IIF(AH2_FXINIC<1,1,AH2_FXINIC),_cPict)) + ' - ' + ALLTRIM(TRANSFORM(AH2_FXFINA,_cPict))+ '-'  + ALLTRIM(TRANSFORM(AH2_PERCRE,'@e 99.99'))+'%   '
			Dbskip()
		Enddo
		_nTotAdiant += _nAdiantamento
		Dbselectarea("TRB")

		if _nValorDa <> 0 //AH6_VALORD > 0
			aadd(_aPrest,{ alltrim(Iif(!empty(SB1->B1_ISBN),SB1->B1_ISBN,SB1->B1_COD))+" "+ alltrim(sb1->b1_desc) ,; 	// codigo isbn e titulo
			ALLTRIM(TRANSFORM(_ncVlrVda/_ncQtdVda,_cPict)) ,; 		// preco medio de capa (vlr vda total / qtde total)
			ALLTRIM(TRANSFORM(_ncQtdVda-_ncQtdDev,_cPict)) ,; 		// Qtde das Vendas
			_cFaixas ,; 												// Faixas de DA
			_cPeriod ,; 												// Periodo
			sb1->b1_xnmaut,;											// nome do autor
			ALLTRIM(TRANSFORM(_ncQtdVda,_cPict)) 	,; 					// Qtde das Vendas
			ALLTRIM(TRANSFORM(_ncQtdDev,_cPict)) 	,; 					// Qtde das Devolucoes de Vendas
			ALLTRIM(TRANSFORM(_ncQtdVda-_ncQtdDev,_cPict)) 	,; 		// Qtde das Liqudida das Vendas
			ALLTRIM(TRANSFORM(_ncVlrVda,_cPict)) ,; 					// Valor vda total
			ALLTRIM(TRANSFORM(_nValorDa,_cPict)) ,; 					// Valor de Credito
			ALLTRIM(TRANSFORM(_nAdiantamento,_cPict)) ,; 							// Valor de descontos //FERNANDO CARVALHO
			ALLTRIM(TRANSFORM(_nValorDa-_nAdiantamento,_cPict))} 			)		// Valor de Credito liquido  - comissoes//FERNANDO CARVALHO


			_nQtdVda  +=  _ncQtdVda-_ncQtdDev
			_nVlrVda  +=  _ncVlrVda
			_nQtdDev  +=  _ncQtdDev
			_nVlrDev  +=  _ncQtdDev
		Endif
	ENDIF
	TRB->(DbSkip())

Enddo

_cVlrCrd:=ALLTRIM(TRANSFORM(_nVlrCrd,_cPict))
_cQtdVda:=ALLTRIM(TRANSFORM(_nQtdVda,_cPict))
_cVlrDes:=ALLTRIM(TRANSFORM(_nVlrDes+_nTotAdiant,_cPict))//FERNANDO CARVALHO
_cBaseIr:=ALLTRIM(TRANSFORM(_nBaseIr-_nTotAdiant,_cPict))//FERNANDO CARVALHO
_cVlrIr :=ALLTRIM(TRANSFORM(_nVlrIR ,_cPict))
_cVlrLiq:=ALLTRIM(TRANSFORM((_nVlrLiq - _nVlrIR)-_nTotAdiant,_cPict))//FERNANDO CARVALHO
_CACVLRVda:=ALLTRIM(TRANSFORM(_nACVLRVda,_cPict))
_cNumRec := SE2->E2_NUM
_cDtaRec := DTOC(SE2->E2_EMISSAO)

DbSelectArea("SA2")
Dbsetorder(1)
dbseek(Xfilial("SA2")+SE2->(E2_FORNECE+E2_LOJA))

_cAutor 	:= SE2->E2_FORNECE + " " + SA2->A2_NOME
_cEdndereco := SA2->A2_END
_cMunicipio := ALLTRIM(SA2->A2_MUN) + "/" +  SA2->A2_EST

_cMes :=  "01" + substr(dtoc(SE2->E2_EMISSAO),3) + "-"+dtoc(SE2->E2_EMISSAO)
_cBim :=  "01" + substr(dtoc(SE2->E2_EMISSAO-45),3) + "-"+dtoc(SE2->E2_EMISSAO)
_cTri :=  "01" + substr(dtoc(SE2->E2_EMISSAO-75),3) + "-"+dtoc(SE2->E2_EMISSAO)
_cQdr :=  "01" + substr(dtoc(SE2->E2_EMISSAO-105),3) + "-"+dtoc(SE2->E2_EMISSAO)
_cSem :=  "01" + substr(dtoc(SE2->E2_EMISSAO-165),3) + "-"+dtoc(SE2->E2_EMISSAO)


DbSelectArea("TRB")
DbCloseArea("TRB")

_cTexto := GeraHtm() // funcao que gera o HTML
/*
For nFor := 1 to len(_ATexto)
if len(&(cVarx)) <= 10640
&(cVarx)+= 	_ATexto[nFor]
else
nItem	+= 1
cVarx	:= "_cTexto"+strzero(nItem,2)
&(cVarx)	:= ""
endif
Next nFor
*/
memowrit(Alltrim(_cDir)+"RecDA_"+alltrim(SE2->E2_FORNECE)+"_"+alltrim(SE2->E2_NUM)+"_"+strtran(DTOC(SE2->E2_EMISSAO),"/","-")+".htm" ,_cTexto)

ViewHtml(_cTexto,nTipo) // ver o HTML



Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDAREL001  บAutor  ณMicrosiga           บ Data ณ  05/15/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraHtm
LOCAL n := 0
Local _cHtml	:= ''
Local aRet		:= {}
_cHtml := '<html xmlns="http://www.w3.org/1999/xhtml>"'
_cHtml += '<head>'
_cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
_cHtml += '<title>Recibo de Direitos Autorais</title>'
_cHtml += '</head>'
_cHtml += '<body bgcolor="#C6EFF7">'
_cHtml += '<style type = "text/css">'
_cHtml += 'strong {'
_cHtml += 'color:blue;}'
_cHtml += '.dados {'
_cHtml += 'font-size: 13px;'
_cHtml += 'padding: 5px;'
_cHtml += 'font-weight: bold;'
_cHtml += 'color: #003C72;'
_cHtml += 'background-color: #EEEEE1;'
_cHtml += 'font-variant:small-caps;'
_cHtml += 'font-family:Tahoma, Arial, Verdana;'
_cHtml += 'border-left:1px solid #DDDDDD;'
_cHtml += 'border-top:1px solid #DDDDDD;'
_cHtml += 'border-right:1px solid #DDDDDD;'
_cHtml += 'border-bottom:1px solid #DDDDDD;}'
_cHtml += '.titulo {'
_cHtml += 'font-size: 13px;'
_cHtml += 'padding: 5px;'
_cHtml += 'font-weight: bold;'
_cHtml += 'color: #003C72;'
_cHtml += 'border-bottom: 1px solid #DEDEBC;'
_cHtml += 'background-color: #EEEEE1;'
_cHtml += 'font-variant: small-caps;'
_cHtml += 'font-family:Tahoma, Arial, Verdana;'
_cHtml += '}'
_cHtml += '.autoral {'
_cHtml += 'padding:3px;'
_cHtml += 'height:24px;'
_cHtml += 'font-family:Arial, Helvetica, sans-serif;'
_cHtml += 'font-size: 11px;'
_cHtml += '}'
_cHtml += '#td-desc {'
_cHtml += 'border-bottom:1px solid #CCCCCC;'
_cHtml += 'border-right:1px solid #CCCCCC;'
_cHtml += 'padding:3px; height: 24px;'
_cHtml += 'font-family:Arial, Helvetica, sans-serif;'
_cHtml += 'font-size: 9px;'
_cHtml += '}'
_cHtml += '.tdMiolo1 {'
_cHtml += 'background-color: #F8F8F8;'
_cHtml += 'border-right:1px solid #DDDDDD;'
_cHtml += 'font-family:Arial, Helvetica, sans-serif;'
_cHtml += 'font-size: 13px;'
_cHtml += '}'
_cHtml += '.tdMiolo {'
_cHtml += 'background-color: #F8F8F8;'
_cHtml += 'font-family:Arial, Helvetica, sans-serif;'
_cHtml += 'font-size: 13px;'
_cHtml += '}'
_cHtml += '</style>'
_cHtml += '<table width="100%" align="center" border="0" bgcolor="#FFFFFF" cellpading="0" cellspacing="0">'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table width="100%">'
_cHtml += '<tr>'
_cHtml += '<td width="20%" align="left" valign="top"> <img src="http://www.manole.com.br/loja/img_prod/183996/menorlogomanole.png"</td>'
_cHtml += '<td>'
_cHtml += '<table class="dados" valign="top" align="right" width="220">'
_cHtml += '<td>'
_cHtml += '<tr>'
_cHtml += '<td bgcolor="#E0E0E0" align="center"><small>DADOS DO RECIBO</small></td>'
_cHtml += '</tr>'
_cHtml += '<td>'
_cHtml += '<table width="100%" class="dados">'
_cHtml += '<tr>'
_cHtml += '<td bgcolor="#E0E0E0" align="right"><small>N&Uacute;MERO</small></td>'
_cHtml += '<td bgcolor="#E0E0E0" align="center"><small>'+_cNumRec+'</small></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td bgcolor="#E0E0E0" align="right"><small>DATA GERA&Ccedil;&Atilde;O</small></td>'
_cHtml += '<td bgcolor="#E0E0E0" align="center"><small>'+_cDtaRec+'</small></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">'
_cHtml += '<tr>'
_cHtml += '<td class="titulo" height="45" align="center"><strong>RECIBO DE DIREITOS AUTORAIS</strong></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td class="tdMiolo1" height="45" align="center">DADOS DO AUTOR/ORGANIZADOR</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table id="td-desc" width="100%" align="center">'
_cHtml += '<tr>'
_cHtml += '<td width="30%" bgcolor="#E0E0E0" align="right">NOME           </td>'
_cHtml += '<td id="td-desc" bgcolor="#FFFFFF">' +_cAutor + '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td width="30%" bgcolor="#E0E0E0" align="right">ENDERE&Ccedil;O</td>'
_cHtml += '<td id="td-desc" bgcolor="#FFFFFF">'+_cEdndereco+'</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td width="30%" bgcolor="#E0E0E0" align="right">MUNICIPIO      </td>'
_cHtml += '<td id="td-desc" bgcolor="#FFFFFF">'+_cMunicipio+' </td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td class="titulo" height="45" align="center"><strong>MOVIMENTA&Ccedil;&Atilde;O DO ISBN</strong></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table id="td-desc" width="100%" align="center">'
_cHtml += '<tr>'
_cHtml += '<td width="24%" bgcolor="#E0E0E0" align="center">ISBN/T&Iacute;TULO</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">PR.MD.CAPA</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">VENDAS ACUM.</td>'
_cHtml += '<td width="23%" bgcolor="#E0E0E0" align="center">FAIXAS DE COMISS&Atilde;O (AT&Eacute;)</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">PERIODO</td>'
//_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">AUTORES</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">VENDAS</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">DEVOL.</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">SALDO</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">VALOR  VENDAS</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">VALOR CREDITO</td>'
_cHtml += '<td width="3%" bgcolor="#E0E0E0" align="center">VALOR  DESCONTO</td>'
_cHtml += '<td width="4%" bgcolor="#E0E0E0" align="center"> COMISS&Atilde;O</td>'
_cHtml += '</tr>'
For n:= 1 to len(_aPrest)
	_cHtml += '<tr>'
	_cHtml += '<td width="18%" bgcolor="#F8F8F8" align="left">'+_aPrest[n,1]+'</td>'
	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,2]+'</td>'
	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,3]+'</td>'
	_cHtml += '<td width="27%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,4]+'</td>'
	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,5]+'</td>'
	//	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,6]+'</td>'
	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,7]+'</td>'
	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,8]+'</td>'
	_cHtml += '<td width="3%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,9]+'</td>'
	_cHtml += '<td width="5%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,10]+'</td>'
	_cHtml += '<td width="4%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,11]+'</td>'
	_cHtml += '<td width="4%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,12]+'</td>'
	_cHtml += '<td width="4%" bgcolor="#F8F8F8" align="right">'+_aPrest[n,13]+'</td>'
	_cHtml += '</tr>'
Next n
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td class="titulo" height="45" bgcolor="f8f8f8" align="center">ATEN&Ccedil;&Atilde;O: O PRE&Ccedil;O M&Eacute;DIO DE CAPA &Eacute; CALCULADO CONFORME AS VENDAS DIRETAS E VENDAS PELA INTERNET </td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td class="titulo" height="45" bgcolor="f8f8f8" align="center">OS VALORES DE COMISS&Atilde;O PODER&Atilde;O SER CALCULADOS POR UM OU MAIS PERCENTUAIS, CONFORME AS FAIXAS SEJAM ATINGIDAS </td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td class="titulo" height="45" bgcolor="f8f8f8" align="center"><strong>LEGENDAS DOS PERIODOS</strong></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table id="td-desc" width="100%" align="center">'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<td bgcolor="#E0E0E0" align="right"> MEN </td>'
_cHtml += '<td width="15%" bgcolor="#F8F8F8" align="left">' + _cMes+ '</td> '
_cHtml += '<td bgcolor="#E0E0E0" align="right"> BIM </td>'
_cHtml += '<td width="15%" bgcolor="#F8F8F8" align="left">' + _cBim+ '</td> '
_cHtml += '<td bgcolor="#E0E0E0" align="right"> TRI </td>'
_cHtml += '<td width="15%" bgcolor="#F8F8F8" align="left">' + _cTri+ '</td> '
_cHtml += '<td bgcolor="#E0E0E0" align="right"> QDR </td>'
_cHtml += '<td width="15%" bgcolor="#F8F8F8" align="left">' + _cQdr+ '</td> '
_cHtml += '<td bgcolor="#E0E0E0" align="right"> SEM </td>'
_cHtml += '<td width="15%" bgcolor="#F8F8F8" align="left">' + _cSem+ '</td> '
_cHtml += '<td>'
_cHtml += '<table id="td-desc" width="100%" align="center">'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td class="titulo" height="45" bgcolor="f8f8f8" align="center"><strong>RESULTADOS FINAIS</strong></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table id="td-desc" width="100%" align="center">'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<td bgcolor="#E0E0E0" align="right">           TOTAL ACUMULADO</td>'
_cHtml += '<td width="6%" bgcolor="#F8F8F8" align="center">'+_cAcVlrVda+'</td>'
_cHtml += '<td bgcolor="#E0E0E0" align="right">           QTDE VENDAS</td>'
_cHtml += '<td width="7%" bgcolor="#F8F8F8" align="center">'+_cQtdVda+'</td>'
_cHtml += '<td bgcolor="#E0E0E0" align="right">           TOTAL DE CR&Eacute;DITO</td>'
_cHtml += '<td width="6%" bgcolor="#F8F8F8" align="center">'+_cVlrCrd+'</td>'
_cHtml += '<td bgcolor="#E0E0E0" align="right">           VALOR DESCONTO</td>'
_cHtml += '<td width="6%" bgcolor="#F8F8F8" align="center">'+_cVlrDes+'</td>'
_cHtml += '<td bgcolor="#E0E0E0" align="center">            BASE DO IRRF </td>'
_cHtml += '<td width="7%" bgcolor="#F8F8F8" align="center">'+_cBaseIr+'</td>'
_cHtml += '<td bgcolor="#E0E0E0" align="center">            VAL. IRRF </td>'
_cHtml += '<td width="07%" bgcolor="#F8F8F8" align="center">'+_cVlrIR+'</td>'
_cHtml += '<td width="6%" bgcolor="#E0E0E0" align="center">LIQUIDO</td>'
_cHtml += '<td width="6%" bgcolor="#F8F8F8" align="center">'+_cVlrLiq+'</td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table width="100%">'
_cHtml += '<tr>'
_cHtml += '<td>'
//_cHtml += '<fieldset class="tdMiolo">'
_cHtml += '<fieldset class="titulo">'
_cHtml += '<legend>OBSERVA&Ccedil;&Otilde;ES</legend>'
_cHtml += '<br> O recibo terแ validade ap๓s a efetiva็ใo do pagamento.'
_cHtml += ' Os possํveis valores de descontos correspondem aos cancelamentos de vendas do perํodo.' 
//_cHtml += cObsman
//_cHtml += '</td>'
//_cHtml += '</tr>'
//_cHtml += '<td class="titulo" height="45">'+cObsman+'</td>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td>'
_cHtml += '<table bgcolor="#F8F8F8" class="autoral" width="100%" align="center">'
_cHtml += '<tr>'
_cHtml += '<td align="center"><p><small>Direito Autoral</small> </p></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td align="center"><small>EDITORA MANOLE - Av. Ceci, 672 / Tambor&eacute; - Barueri / SP - CEP: 06460-120</small></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td align="center"><small>Copyright 2008 Editora Manole.Todos os direitos reservados. &Eacute; proibida a reprodu&ccedil;&atilde;o total ou parcial do conte&uacute;do</small></td>'
_cHtml += '</tr>'
_cHtml += '<tr>'
_cHtml += '<td align="center"><small>deste documento sem autoriza&ccedil;&atilde;o por escrito da editora. Desenvolvido por TOTVS S/A. </small></td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '</td>'
_cHtml += '</tr>'
_cHtml += '</table>'
_cHtml += '</body>'
_cHtml += '</html>'


Return(_cHtml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDARELPAR  บAutor  ณMicrosiga           บ Data ณ  16/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PARAMETRIZACAO DE LOCAL DE GERACAO DE RELATORIO DE DA      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RelMnPar

@ 91,58 To 438,470 Dialog oDlg Title OemToAnsi("Recibo HTML")
//@   5,5 To 69,199
@ 100,5 To 132,199 Title OemToAnsi(" Diret๓rio para Gera็ใo ")

@  1,1 Say OemToAnsi("Esta rotina irแ gerar o arquivos de Recibo DA em HTML") Size 182,8

@ 112,10 Get _cDir    Picture "@!" Size 182,10 Valid NaoVazio(_cDir)  Object oDir

@ 145,5   BmpButton Type 14 Action GetDiret()
@ 145,128 BmpButton Type  1 Action Processa({|| GrvPar(),Close(oDlg)})
@ 145,168 BmpButton Type  2 Action Close(oDlg)
Activate Dialog oDlg CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDARELPAR  บAutor  ณMicrosiga           บ Data ณ  16/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PARAMETRIZACAO DE LOCAL DE GERACAO DE RELATORIO DE DA      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDiret()
_cDir := cGetFile( "",OemToAnsi("Selecione Diret๓rio"), 0,"SERVIDOR"+_cDir,.F.,GETF_RETDIRECTORY+GETF_LOCALFLOPPY+GETF_LOCALHARD)
oDir:Refresh()
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDARELPAR  บAutor  ณMicrosiga           บ Data ณ  16/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PARAMETRIZACAO DE LOCAL DE GERACAO DE RELATORIO DE DA      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvPar()

PUTMV("MN_DIRHTML",_cDir)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDARELPAR  บAutor  ณMicrosiga           บ Data ณ  16/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualizacao de do arquivo HTML                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 11                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewHTML(_cTexto,_nTipo)

if _nTipo == 1
	//_cComando := "C:\Program Files (x86)\Internet Explorer\iexplore.exe "+Alltrim(_cDir)+alltrim(SE2->E2_NUM)+".htm"
	//WinExec(_cComando)

	lEnvMail := .T.
	cEmailFor := sa2->A2_email
	IF lEnvMail
		nOpceml := 0
		@ 096,042 TO 323,505 DIALOG oDlg2 TITLE OemToAnsi("Email de Recibos de Direitos Autorais")
		@ 008,010 TO 084,222
		@ 018,020 SAY "E-mail"
		@ 018,040 get  cEmailFor


		@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpceml := 1, oDlg2:End() } )
		@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpceml := 0, oDlg2:End() } )
		ACTIVATE DIALOG oDlg2 CENTERED


		cEmailFor:= alltrim(cEmailFor)
		// alert(cEmailFor)

		if nOpceml == 1

			Processa({|lEnd| BrEnvMail( ,"Recibo Direitos Autorais " ,{"Direitos Autorais "},cEmailFor,"",{},10)},"Recibo de Direitos Autorais")

		endif

	Endif
Else
	lEnvMail := .T.

	cEmailFor := "" // "e.gallo@uol.com.br"//sa2->A2_email

	Processa({|lEnd| BrEnvMail( ,"Recibo Direitos Autorais " ,{"Direitos Autorais "},cEmailFor,"",{},10)},"Recibo de Direitos Autorais")


Endif

Return .t.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณBrEnvMail ณ Autor ณ Mauricio de Barros    ณ Data ณ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณFuncao de envio do grafico por email.                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณEquifax                                                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)
Local lRet := .F.
Local cArq	:= ""
makedir('c:\temp\')
lRet := U_ENVMAIL(alltrim(cTo),cArq,cAssunto,_cTexto,"LOCAWEB",_ATexto,.F.,'roberta.lima@manole.com.br;bianca@manole.com.br')
memowrite('c:\temp\'+alltrim(cTo)+".htm",_cTexto)
return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDAREL001  บAutor  ณMicrosiga           บ Data ณ  05/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RelMult

cPerg := "MANREC0001"

_fcriasx1()

IF pergunte(cPerg)
	If msgyesno("Confirma Envio dos Emails ???")
		Geral_rec()
	endif
Endif

Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDAREL001  บAutor  ณMicrosiga           บ Data ณ  05/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function  Geral_rec()

_cQUERY := "SELECT R_E_C_N_O_ AS REGISTRO FROM "
_cQUERY += RETSQLNAME("SE2")
_cQUERY += " WHERE E2_EMISSAO = '"+DTOS(MV_PAR05) + "' "
_cQUERY += " AND E2_FORNECE BETWEEN '"+MV_PAR01+"'  AND '"+MV_PAR03+"' "
_cQUERY += " AND E2_LOJA    BETWEEN '"+MV_PAR02+"'  AND '"+MV_PAR04+"' "
_cQUERY += " AND SE2010.D_E_L_E_T_ = '' "
_cQUERY += "  AND E2_PREFIXO = 'RYI' AND E2_FORNECE <> 'UNIAO' "

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TSE2', .T., .T.)
TCSetField('TSE2', "REGISTRO", "N",9,0)

dbselectarea('TSE2')
dbgotop()


Do while !eof()
	Dbselectarea("SE2")
	dbgoto(tse2->registro)

	RelMnx(2)

	Dbselectarea("TSE2")
	Dbskip()
Enddo
TSE2->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fCriaSx1 บAutor  ณEveraldo Gallo      บ Data ณ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCriacao das perguntas                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSx1()

DbSelectArea("SX1")
DbSetOrder(1)

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Fornecedor de"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_F3      := "SA2"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Loja de"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_F3      := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Fornecedor Ate"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3      := "SA2"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Loja ate"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3      := ""
	MsUnLock()
EndIf


If ! DbSeek(cPerg+"05",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Data de Prestacao"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_F3      := ""
	MsUnLock()
EndIf


Return .t.
