#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTDescrNFEºAutor  ³Honorio Borges Jr   º Data ³  04/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Descricao da NF eletronica                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Matsuo                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßdßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MTDescrNFE()

Local cDocto:= PARAMIXB[1]
Local cSerie:= PARAMIXB[2]
Local cCliente:= PARAMIXB[3]
Local cloja	  := PARAMIXB[3]
Local _cPCC   := 0
Local _IRRF   := 0
Local _PIRF   := 0
Local _cTot   := 0
local _cIRRF := 0

SD2->(DBSETORDER(3))
SD2->(DBSEEK(XFILIAL("SD2")+cDocto+cSerie))

_CDESC:=""
_cMensNf := ""

While !SD2->(eof()) .AND. SD2->D2_DOC==cDocto .AND. SD2->D2_SERIE==cSerie
	if alltrim(SD2->D2_GRUPO) == "1021"
		_CDESC+= "Acessos limitados e por tempo determinado do conteudo On-Line do curso |"
	endif
	_CDESC+=alltrim(Posicione("SC6",1,xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV,"C6_DESCRI"))+" - R$ "+ALLTRIM(TRANSFORM(SD2->D2_TOTAL,"@E 999,999.99"))+" |"
	
	//Edmar Mendes do Prado - 15/02/2019
	//_CDESC+=alltrim(Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_MENNOTA"))+" |"
	_cMensNf := alltrim(Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_MENNOTA"))+" |"
	
	SF2->(DBSETORDER(2))
	SF2->(DbSeek(xFilial("SF2")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE))
	
	_cIRRF:= Posicione("SF2",2,xFilial("SF2")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE,"SF2->F2_VALIRRF")
	_cPCC:= Posicione("SF2",2,xFilial("SF2")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE,"SF2->F2_VALPIS + SF2->F2_VALCOFI+SF2->F2_VALCSLL")
	_cTot:= Posicione("SF2",2,xFilial("SF2")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE,"SF2->F2_VALMERC")
	_PIRF:= SD2->D2_ALQIRRF
	
	SD2->(DBSKIP())
enddo

//Edmar Mendes do Prado - 09/04/2019
//Tratativa para inserir somente uma vez a mensagem para nota
If Len(_cMensNF) > 0
	_CDESC += _cMensNf
EndIf

if _cIRRF + _cPCC  > 0
	//	_CDESC+= "|"
	_CDESC+= "|"
	_CDESC+= "| Retençoes"
	if _cIRRF > 0
		_CDESC+= "| IRRF Aliquota " + alltrim(TRANSFORM(_PIRF,"@E 999.99")) + "- R$ "+alltrim(TRANSFORM(_cIRRF,"@E 999,999.99")) + "|"
	endif
	if _cPCC > 0 .and. _cTot > getmv("MV_VL10925")
		_CDESC+= "| PIS/COFINS/CSLL (LEI 10.833 - art. 30) - R$ "+alltrim(TRANSFORM(_cPCC,"@E 999,999.99"))
	endif
endif

//Alteração de tamanho conforme Manual da Prefeitura, de 600 para 1000
//08/04/2019

IF LEN(_CDESC) >= 999	//600 //se o tamanho do texto de descrição foi maior que o limite aceito pela prefeitura no arquivo txt
	_CDESC := STRTRAN(_CDESC, "Acessos limitados e por tempo determinado do conteudo On-Line do curso |", "Acesso On-Line por tempo determinado ao curso|")
	If _cIRRF + _cPCC  > 0 //reduz também os caracteres da string de PCC
		_cDesc := STRTRAN(_CDESC, "| PIS/COFINS/CSLL (LEI 10.833 - art. 30) - R$ ","| PCC(LEI 10.833-art.30)-R$ ")
	Endif
	IF LEN(_CDESC) >= 999 	//600 //não satisfeito - verifica novamente a quantidade de caracteres
		_CDESC := STRTRAN(_CDESC, "Acesso On-Line por tempo determinado ao curso|", "Acesso On-Line ao curso:")
		IF LEN(_CDESC) >= 9999	///600 //eu sei - sou teimoso, mas isso gerou muito problema
			_CDESC := STRTRAN(_CDESC, "Acesso On-Line ao curso:", "Acesso ao curso:")
			IF LEN(_CDESC) >= 900	///600 // esse é o limite, caso não haja mais opções, ainda assim, no proximo if se for necessario os caracteres serão cortados 
				_CDESC := STRTRAN(_CDESC, "Acesso ao curso:", "")
				IF LEN(_CDESC) >= 900	//600 // isso se mesmo com todo o resumo não couberem os dados da NF de serviço
					_CDESC := SubStr(_CDESC,1,999) 		///substr(_CDESC,1,600)
				Endif
			Endif
		Endif
	Endif
ENDIF

Return(_CDESC)
