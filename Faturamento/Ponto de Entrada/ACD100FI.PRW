#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACD100FI  ºAutor  ³Leandro Duarte      º Data ³  04/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³rotina para colocar o filtro quando a ordem de separação foiº±±
±±º          ³feita pela rotina do pedido                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function ACD100FI()
Local cTipoFil	:= paramixb[1]
Local cFilSC9   := ".T."
Local cFilSD2   := ".T."
Local cFilSC2   := ".T."
Local aRet		:= {1,".t."}
Local cQuery	:= ""

IF FUNNAME() == 'MATA410'

	if cTipoFil == 1

		cQuery	:= " SELECT DISTINCT C6_NUM FROM (" + Chr(13) + Chr(10)
		cQuery	+= "         SELECT DISTINCT C6_NUM, C6_ITEM, C6_PRODUTO " + Chr(13) + Chr(10)
 		cQuery	+= "          FROM ( " + Chr(13) + Chr(10)
		cQuery	+= "                 SELECT * " + Chr(13) + Chr(10)
		cQuery	+= "                   FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B, "+RETSQLNAME("SB1")+" C  " + Chr(13) + Chr(10)
 		cQuery	+= "                 WHERE A.C5_FILIAL = '"+xFilial("SC5")+"'" + Chr(13) + Chr(10)
 		cQuery	+= "                   AND A.C5_EMISSAO >= '"+Dtos(DDATABASE-30)+"'" + Chr(13) + Chr(10)
		//cQuery+= "                    AND A.C5_NOTA = ' '" + Chr(13) + Chr(10)
		//cQuery+= "                    AND A.C5_BLQ = ' '" + Chr(13) + Chr(10)
		cQuery	+= "                    AND A.C5_VTEX <> '  '" + Chr(13) + Chr(10)
		cQuery	+= "                    AND A.D_E_L_E_T_ = ' '" + Chr(13) + Chr(10)
		cQuery	+= "                    AND B.C6_FILIAL = '"+xFilial("SC6")+"'" + Chr(13) + Chr(10)
		cQuery	+= "                    AND B.C6_NUM = A.C5_NUM" + Chr(13) + Chr(10)
		cQuery	+= "                    AND B.C6_TES NOT IN ('560','561')" + Chr(13) + Chr(10)
		cQuery	+= "                    AND B.D_E_L_E_T_ = ' '" + Chr(13) + Chr(10)
		cQuery	+= "                   AND C.B1_FILIAL = '"+xFilial("SB1")+"'" + Chr(13) + Chr(10)
		cQuery	+= "                    AND C.B1_COD = B.C6_PRODUTO " + Chr(13) + Chr(10)
		cQuery	+= "                    AND C.B1_XTIPO = '1'" + Chr(13) + Chr(10)
		cQuery	+= "                    AND C.D_E_L_E_T_ = ' ' " + Chr(13) + Chr(10)
		cQuery	+= "                 ) TMP" + Chr(13) + Chr(10)
 		cQuery	+= "         WHERE  C6_NUM||C6_ITEM||C6_PRODUTO NOT IN (SELECT A1.CB7_PEDIDO||B1.CB8_ITEM||B1.CB8_PROD " + Chr(13) + Chr(10)
		cQuery	+= "                                                      FROM "+RETSQLNAME("CB7")+" A1, "+RETSQLNAME("CB8")+" B1" + Chr(13) + Chr(10)
		cQuery	+= "                                                     WHERE A1.CB7_FILIAL = '"+xFilial("CB7")+"'" + Chr(13) + Chr(10)
 		cQuery	+= "                                                       AND A1.D_E_L_E_T_ = ' ' " + Chr(13) + Chr(10)
		cQuery	+= "                                                       AND B1.CB8_FILIAL = '"+xFilial("CB8")+"' " + Chr(13) + Chr(10)
		cQuery	+= "                                                       AND B1.CB8_ORDSEP = A1.CB7_ORDSEP " + Chr(13) + Chr(10)
		cQuery	+= "                                                       AND B1.D_E_L_E_T_ = ' ')" + Chr(13) + Chr(10)
		cQuery	+= "     ) TMP2" + Chr(13) + Chr(10)
		cQuery	+= " WHERE C6_NUM||C6_ITEM||C6_PRODUTO IN ( SELECT C9_PEDIDO||C9_ITEM||C9_PRODUTO FROM "+RETSQLNAME("SC9")+" " + Chr(13) + Chr(10)
 		cQuery	+= "                                         WHERE C9_FILIAL = '"+xFilial("SC9")+"' " + Chr(13) + Chr(10)
		cQuery	+= "                                           AND C9_NFISCAL = '         '" + Chr(13) + Chr(10)
		cQuery	+= "                                           AND C9_BLEST = '  ' " + Chr(13) + Chr(10)
 		cQuery	+= "                                           AND C9_BLCRED = '  '" + Chr(13) + Chr(10)
 		cQuery	+= "                                           AND D_E_L_E_T_ = ' ' )" + Chr(13) + Chr(10)
		cQuery	+= "   AND ROWNUM < 101 " + Chr(13) + Chr(10)
		cQuery	+= " ORDER BY C6_NUM " + Chr(13) + Chr(10)

		IIF(SELECT("TRBSC9")>0,TRBSC9->(DBCLOSEAREA()),NIL)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSC9",.T.,.T.)
		IF TRBSC9->(!EOF())
			cFilSC9		:= " C9_PEDIDO $ '"
			WHILE TRBSC9->(!EOF())
				cFilSC9 += TRBSC9->C6_NUM+","
				TRBSC9->(DBSKIP())
			END
			cFilSC9	:= SUBSTR(cFilSC9,1,LEN(cFilSC9)-1)
			cFilSC9 += "' .AND. LEN(alltrim(C9_PRODUTO))>6 "
		ELSE

		  cFilSC9 := " C9_PEDIDO $ '9A9A9A'"

		ENDIF
		aRet		:= {1,cFilSC9}
	elseif cTipoFil == 2
		cFilSD2   := ".T."
		aRet		:= {2,cFilSD2}
	else
		cFilSC2   := ".T."
		aRet		:= {3,cFilSC2}
	endif
ENDIF
return(aRet)
