#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNLVENANU  ºAutor  ³Edmar Mendes Prado  º Data ³  24/01/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para exibir dados de vendas Anuais de Produtos     º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manole                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MNLVENANU() 

Local 	aArea 		:= GetArea()
Local 	_cQuery2	:= ""
Local 	oDlg1
Private	aHead1		:= {}

_aStr2 := {}
Aadd( _aStr2, {"_ANO" 	 	,"C",06,0} )
Aadd( _aStr2, {"_QUANT"	  	,"N",15,0} )
Aadd( _aStr2, {"_TOTAL" 	,"N",15,2} )
Aadd( _aStr2, {"_MEDIOL"	,"N",15,2} )
Aadd( _aStr2, {"_PERCENT"	,"N",15,2} )

_Tmp2 := CriaTrab(_aStr2,.t.)
If ! Empty(_Tmp2)
	DbUseArea(.t.,,_Tmp2,"TRB2",.t.,.f.)
	_cArqTRB2 := CriaTrab(Nil,.F.)
	DbSelectArea("TRB2")
EndIf

_cQuery2 := " SELECT " + chr(13)+chr(10)
_cQuery2 += "  SUBSTR(D2_EMISSAO,1,4) AS ANO " + chr(13)+chr(10)
_cQuery2 += "  , D2_COD AS CODIGO " + chr(13)+chr(10)
_cQuery2 += "  , SUM(D2_QUANT) VENDAS " + chr(13)+chr(10)
_cQuery2 += "  , SUM(D2_TOTAL) TOTALV " + chr(13)+chr(10)
_cQuery2 += "  FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4 " + chr(13)+chr(10)
_cQuery2 += "  WHERE SD2.D_E_L_E_T_ = ' '  AND SF4.D_E_L_E_T_ = ' ' " + chr(13)+chr(10)
_cQuery2 += "  AND D2_COD = '" + SB1->B1_COD + "' " + chr(13)+chr(10)
_cQuery2 += "  AND D2_TES = F4_CODIGO " + chr(13)+chr(10)
_cQuery2 += "  AND F4_DUPLIC = 'S' " + chr(13)+chr(10)
_cQuery2 += " GROUP BY SUBSTR(D2_EMISSAO,1,4), D2_COD " + chr(13)+chr(10)
_cQuery2 += " ORDER BY D2_COD, SUBSTR(D2_EMISSAO,1,4) DESC "
_cQuery2 := ChangeQuery(_cQuery2)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"TMP2",.T.,.T.)

//MemoWrite("MNLVENMEN.SQL", _cQuery)

TMP2->(dbGoTop())
While TMP2->(!Eof())
	
	DbSelectArea("TRB2")
	If RecLock("TRB2",.t.)
		TRB2->_ANO		:= TMP2->ANO
		TRB2->_QUANT	:= TMP2->VENDAS
		TRB2->_TOTAL	:= TMP2->TOTALV
		TRB2->_MEDIOL	:= (TMP2->TOTALV / TMP2->VENDAS )
		TRB2->_PERCENT	:= (SB1->B1_PRV1 - ((TMP2->TOTALV / TMP2->VENDAS ) / SB1->B1_PRV1)) //- 100

		MsUnlock()
	Endif
		
	TMP2->(dbSkip())
EndDo

aHead1 := {}
aAdd(aHead1,{"_ANO"		,, "Ano"	   		,"@!"				})
aAdd(aHead1,{"_QUANT"	,, "Quantidade"		,"@E 999,999"		})
aAdd(aHead1,{"_TOTAL"	,, "Valor Total"	,"@E 999,999.99"	})
aAdd(aHead1,{"_MEDIOL"	,, "Medio Liquido"	,"@E 999,999.99"	})
aAdd(aHead1,{"_PERCENT"	,, "Percentual"		,"@E 999,999.99"	})

cTITULO := "Produto: "+ALLTRIM(SB1->B1_COD)+" - "+SB1->B1_DESC
cDatPub := "Data de Publicação: " + Dtoc(SB1->B1_PUBLIC)
cPrcVen := "Preço de Venda: R$ " + Str(SB1->B1_PRV1,12,2)

DEFINE MSDIALOG oDlg1 TITLE "Consulta de Vendas ANO/MES por Produto." FROM 0,0 TO 400,900 PIXEL

TRB2->(dbGoTop())
                            
@ 005, 005 SAY oSay1 PROMPT cTITULO SIZE 500, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
@ 013, 005 SAY oSay1 PROMPT cDatPub SIZE 500, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
@ 021, 005 SAY oSay1 PROMPT cPrcVen SIZE 500, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
                                                                                                               
oDADOS:=MsSelect():New("TRB2",,,aHead1,,,{030,005,180,450},,,,,)
oDADOS:oBrowse:Refresh()

@ 183,300 Button "Imprimir" Size (060),(012) PIXEL OF oDlg1 ACTION oDlg1:End()
@ 183,390 Button "F E C H A R" Size (060),(012) PIXEL OF oDlg1 ACTION oDlg1:End()

ACTIVATE MSDIALOG oDlg1 CENTERED

TRB2->(dbCloseArea())   

If Select("TMP2") > 0
	TMP2->(dbCloseArea())                                        
endif
                                    
RestArea(aArea)

Return()                     
                                          

