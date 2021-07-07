#include "Protheus.ch"
#define CRLF CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCONTRATOบAutor  ณRafael Garcia de Melo  บDataณ24/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao contrato de direitos autorais                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 							                          		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿v฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EM_IMPFR()

Local oDlg   := .F.
Local lOk    := .F.
Local   cType    := "Arquivo Texto | *.TXT"


Private cTitulo     := "Importacao de Arquivos "
Private aNotas      := {}
Private lMsErroAuto := .F.

_ncc		:=0

_clojaPad 	:= '01'

cArqTc1 	:= space(100)
cArqTd1 	:= space(100)

FormBatch(cTitulo, {	"Este programa ira importar os arquivos", ;
"Contratos de Fornecedores" }, ;
{	{5, .T., {|| cArqTc1 := cGetFile(cType,"Selecione o Arquivo de FORNECEDRES",0,,.T.,GETF_LOCALHARD )}}, ;
{1, .T., {|| lOk := .T., FechaBatch(), Nil}}, ;
{2, .T., {|| lOk := .F., FechaBatch()}}})

If lOk
	
	MsAguarde({|| xCargaTxt()},"Carregando arquivo temporแrio...")
	
	Msgstop("Foram processados " +alltrim(str( _ncc )) +" Fornecedores ")
	
Endif
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMP_FOR   บAutor  ณMicrosiga           บ Data ณ  01/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function oCancel()

Return(.F.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCONTRATOบAutor  ณMicrosiga           บ Data ณ  10/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCargaTxt()

_ccodigo    := space(6)  // 001 com 06 posicoes
_cNome      := space(40) // 008 com 40 posicoes
_cNreduz    := space(20) // 049 com 20 posicoes
_cEndereco  := space(6)  // 070 com 40 posicoes
_cUf        := space(2)  // 117 com 02 posicoes
_cCodMum    := space(5)  // 141 com 05 posicoes
_cMunic     := space(25) // 148 com 25 posicoes
_cCep       := space(8)  // 174 com 08 posicoes
_cTipo      := space(1)  // 184 com 01 posicoes
_cCNPJ      := space(14) // 186 com 14 posicoes
_cDDD       := space(3)  // 221 com 03 posicoes
_cFone      := space(8)  // 225 com 08 posicoes
_cIE        := space(14) // 243 com 14 posicoes

_nTamCod:= TamSX3("A2_COD")[1]

FT_FUSE(cArqTc1)

FT_FGOTOP()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLoop para tratamento das linhas do arquivo do EDI ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !FT_FEOF()
	
	cLinha   := FT_FREADLN()
	
	_cCODIGO	:= Substr(cLinha,1,6)
	_cNOME		:= Substr(cLinha,8,40 )
	_cNREDUZ	:= Substr(cLinha,49,20)
	_cENDERECO	:= Substr(cLinha,70,40)
	_cUF		:= Substr(cLinha,117,2)
	_cCOD_MUN	:= Substr(cLinha,141,5)
	_cCIDADE	:= Substr(cLinha,148,25)
	_cCEP		:= Substr(cLinha,174,8)
	_cTIPO_PES	:= Substr(cLinha,184,1)
	_cCNPJ		:= Substr(cLinha,186,14)
	_cDDD		:= Substr(cLinha,221,3)
	_cFONE		:= Substr(cLinha,225,8)
	_cIE		:= Substr(cLinha,243,14)
	
	FT_FSKIP()
	_ncc++
	
	_cCODIGO := SUBSTR(_cCODIGO+SPACE(_nTamCod),1,_nTamCod)
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+_cCODIGO+_clojaPad)
	if eof()
		Reclock("SA2",.T.)
		A2_FILIAL  := xFilial("SA2")
		A2_COD     := _cCODIGO
		A2_LOJA    := _clojaPad
		A2_NOME    := _cNome
		A2_NREDUZ  := _cNreduz
		A2_END     := _cEndereco
		A2_BAIRRO  := ""
		A2_MUN     := _cCidade
		A2_EST     := _cUf
		A2_CEP     := _cCEP
		A2_CGC     := _cCNPJ
		A2_TIPO    := _cTipo_Pes
		A2_TEL     := _cfone
		A2_TELEX   := ""
		A2_FAX     := ""
		A2_INSCR   := _cIe
		A2_INSCRM  := ""
		A2_CONTATO := ""
		A2_BANCO   := ""
		A2_AGENCIA := ""
		A2_CONTA   := ""
		A2_NUMCON  := ""
		A2_COND   := "002"
		A2_COD_MUN := _cCOD_MUN
	else
		Reclock("SA2",.F.)
		A2_CONTATO := ""
		A2_BANCO   := ""
		A2_AGENCIA := ""
		A2_CONTA   := ""
		A2_NUMCON  := ""
	endif
	msunlock()
	
Enddo                                                                                                   L

FT_FUSE()

return
