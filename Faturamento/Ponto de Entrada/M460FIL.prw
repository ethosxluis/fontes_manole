#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIL   ºAutor  ³Leandro Duarte      º Data ³  02/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para apresentar os novos filtros da tela de prepara  º±±
±±º          ³cao de documento de saida                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11      treteer                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function M460FIL()

Local aAreaSC5 	:= SC5->(GetArea())
Local cRet	:= ""

//perguntes SX1 = MT461A
// produtos vtex 1=sim;2=não;3=todos
if MV_PAR17 == 1
	cRet := " SUBSTR(SC9->C9_PEDIDO,1,1) = 'V' .AND. SC9->C9_PRCVEN >= 0 "
ELSEIF MV_PAR17 == 2
	cRet := " SUBSTR(SC9->C9_PEDIDO,1,1) <> 'V' .AND. SC9->C9_PRCVEN >= 0 "
ELSE
	cRet := " SUBSTR(SC9->C9_PEDIDO,1,1) <> ' ' .AND. SC9->C9_PRCVEN >= 0 "
ENDIF

// tipo de produto 1=curso;2=livros;3=todos
if MV_PAR18 == 1
	cRet += " .AND. SC9->C9_XTIPO =='2' .AND. SC9->C9_PRCVEN >= 0 "
ELSEIF MV_PAR18 == 2
	cRet += " .AND. SC9->C9_XTIPO =='1' .AND. SC9->C9_PRCVEN >= 0 "
ELSE
	cRet += " .AND. SC9->C9_XTIPO <>'3' .AND. SC9->C9_PRCVEN >= 0 "
ENDIF


//Validacao de Tipo de Cliente, se pessoa Fisica ou Juridica, conforme solicitação da Contabilidade
//Edmar Mendes do Prado - 23/05/2018

If MV_PAR19 == 1
	cRet += " .AND. SC9->C9_XPESSOA = 'F' "
ElseIf MV_PAR19 == 2
	cRet += " .AND. SC9->C9_XPESSOA = 'J' "
Else
	cRet += " "
EndIf


RESTAREA(aAreaSC5)

Return(cRet)

