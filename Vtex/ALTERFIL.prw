#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "PARMTYPE.CH"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"
#include 'parmtype.ch'
#include 'RestFul.ch'

user function ALTERFIL(aNomeTab)

	nScan2:= aScan(aNomeTab,{|x| x[1] == '3' })
	IF nScan2 > 0
	

	if !(SELECT("GRVDPED")>0)
		iif(SELECT("GRVDPED")>0,GRVDPED->(DbCloseArea()),nil)
		dbUseArea(.T.,,aNomeTab[nScan2][2],"GRVDPED", .T., .F. )
		cIndCond := "C6_VTEX+C6_FILIAL+C6_PRODUTO+C6_ITEM" // INLCUIDA A FILIAL NO INDICE
		cArqNtx1 := SUBSTR(aNomeTab[nScan2][2],1,7)+'1'
		IndRegua("GRVDPED",cArqNtx1,cIndCond,,,"Selecionando Registros...")
		dbselectarea("GRVDPED")
		dbSetIndex(cArqNtx1 + OrdBagExt())
	endif
	
	GRVDPED->(dbgotop())
	while GRVDPED->(!eof())
		dbSelectArea("SB1")
		SB1->(dbSetOrder(14))
		RECLOCK("GRVDPED",.f.)
		IF SB1->(DBSEEK(xFilial("SB1")+ GRVDPED->C6_PRODUTO))
			If ALLTRIM(SB1->B1_XTIPO) == "2"
				GRVDPED->C6_FILIAL		:= "01"
			ELSE
				GRVDPED->C6_FILIAL		:= "02"
			ENDIF	
		ELSE
			SB1->(dbSetOrder(1))
			IF SB1->(DBSEEK(xFilial("SB1")+ GRVDPED->C6_PRODUTO))
				If ALLTRIM(SB1->B1_XTIPO) == "2"
					GRVDPED->C6_FILIAL		:= "01"
				ELSE
					GRVDPED->C6_FILIAL		:= "02"
				ENDIF
			Endif
		Endif
		GRVDPED->(msunlock())
		GRVDPED->(dbskip())
	ENDDO
	endif
	GRVDPED->(dbclosearea())
RETURN
