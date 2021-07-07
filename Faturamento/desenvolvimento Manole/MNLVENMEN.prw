#include "protheus.ch"
           
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNLVENMEN  ºAutor  ³Edmar Mendes Prado  º Data ³  24/01/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para exibir dados de vendas Mensais de Produtos    º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manole                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MNLVENMEN() 

Local 	aArea 		:= GetArea()
Local 	_cQuery		:= ""
Local 	oDlg1
Private	aHead1		:= {}

_aStr1 := {}
Aadd( _aStr1, {"_ANO" 		,"C",06,0} )
Aadd( _aStr1, {"_MES"		,"C",04,0} )
Aadd( _aStr1, {"_QUANT" 	,"N",15,0} )
Aadd( _aStr1, {"_TOTAL"		,"N",15,2} )
Aadd( _aStr1, {"_MEDIOL"	,"N",15,2} )
Aadd( _aStr1, {"_PERCENT"	,"N",15,2} )

_Tmp1 := CriaTrab(_aStr1,.t.)
If ! Empty(_Tmp1)
	DbUseArea(.t.,,_Tmp1,"TRB",.t.,.f.)
	_cArqTRB := CriaTrab(Nil,.F.)
	DbSelectArea("TRB")
EndIf

_cQuery := " SELECT " + chr(13)+chr(10)
_cQuery += "  SUBSTR(D2_EMISSAO,1,4) AS ANO " + chr(13)+chr(10)
_cQuery += "  , SUBSTR(D2_EMISSAO,5,2) AS MES " + chr(13)+chr(10)
_cQuery += "  , D2_COD AS CODIGO " + chr(13)+chr(10)
_cQuery += "  , SUM(D2_QUANT) QUANT " + chr(13)+chr(10)
_cQuery += "  , SUM(D2_TOTAL) TOTALV " + chr(13)+chr(10)
_cQuery += "  FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4 " + chr(13)+chr(10)
_cQuery += "  WHERE SD2.D_E_L_E_T_ = ' '  AND SF4.D_E_L_E_T_ = ' ' " + chr(13)+chr(10)
_cQuery += "  AND D2_COD = '" + SB1->B1_COD + "' " + chr(13)+chr(10)
_cQuery += "  AND D2_TES = F4_CODIGO " + chr(13)+chr(10)
_cQuery += "  AND F4_DUPLIC = 'S' " + chr(13)+chr(10)
_cQuery += " GROUP BY SUBSTR(D2_EMISSAO,1,4), SUBSTR(D2_EMISSAO,5,2), D2_COD " + chr(13)+chr(10)
_cQuery += " ORDER BY D2_COD, SUBSTR(D2_EMISSAO,1,4) DESC, SUBSTR(D2_EMISSAO,5,2) DESC "
_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TMP1",.T.,.T.)

//MemoWrite("MNLVENMEN.SQL", _cQuery)

TMP1->(dbGoTop())
While TMP1->(!Eof())
	
	DbSelectArea("TRB")
	If RecLock("TRB",.t.)
		TRB->_ANO		:= TMP1->ANO
		TRB->_MES		:= TMP1->MES
		TRB->_QUANT		:= TMP1->QUANT
		TRB->_TOTAL		:= TMP1->TOTALV
		TRB->_MEDIOL	:= (TMP1->TOTALV / TMP1->QUANT )
		TRB->_PERCENT	:= (SB1->B1_PRV1 - ((TMP1->TOTALV / TMP1->QUANT ) / SB1->B1_PRV1)) //- 100
		
		MsUnlock()
	Endif
		
	TMP1->(dbSkip())
EndDo

aHead1 := {}
aAdd(aHead1,{"_ANO"		,, "Ano"	   		,"@!"				})
aAdd(aHead1,{"_MES"		,, "Mês"			,"@!"				})
aAdd(aHead1,{"_QUANT"	,, "Quantidade"		,"@E 999,999"		})
aAdd(aHead1,{"_TOTAL"	,, "Valor Total"	,"@E 999,999.99"	})
aAdd(aHead1,{"_MEDIOL"	,, "Medio Liquido"	,"@E 999,999.99"	})
aAdd(aHead1,{"_PERCENT"	,, "Percentual"		,"@E 999,999.99"	})

cTITULO := "Produto: "+ALLTRIM(SB1->B1_COD)+" - "+SB1->B1_DESC
cDatPub := "Data de Publicação: " + Dtoc(SB1->B1_PUBLIC)
cPrcVen := "Preço de Venda: R$ " + Str(SB1->B1_PRV1,12,2) 

DEFINE MSDIALOG oDlg1 TITLE "Consulta de Vendas ANO/MES por Produto." FROM 0,0 TO 400,900 PIXEL

TRB->(dbGoTop())
                            
@ 005, 005 SAY oSay1 PROMPT cTITULO SIZE 500, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
@ 013, 005 SAY oSay1 PROMPT cDatPub SIZE 500, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
@ 021, 005 SAY oSay1 PROMPT cPrcVen SIZE 500, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
                                                                       
oDADOS:=MsSelect():New("TRB",,,aHead1,,,{030,005,180,450},,,,,)
oDADOS:oBrowse:Refresh()

@ 183,300 Button "Imprimir" Size (060),(012) PIXEL OF oDlg1 ACTION oDlg1:End()
@ 183,390 Button "F E C H A R" Size (060),(012) PIXEL OF oDlg1 ACTION oDlg1:End()

ACTIVATE MSDIALOG oDlg1 CENTERED

TRB->(dbCloseArea())   

If Select("TMP1") > 0
	TMP1->(dbCloseArea())                                        
endif
                                    
RestArea(aArea)

Return()                     
                                          
