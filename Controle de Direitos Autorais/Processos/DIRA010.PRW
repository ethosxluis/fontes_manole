#include"protheus.ch"
#include"topconn.ch"

USER FUNCTION DIRA010()      
Local aArea     := GetArea()
LOCAL CQRY := ""          
local CQRYCNT := ""
LOCAL CFUNNAME2 := ALLTRIM(FUNNAME())  
local dPerIni
local dPerFim       
local NREGISTRO := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Periodo de processamento, do dia 01 do mes e ano informados  ³
//³ ate o ultimo dia do mes.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dPerIni := CTOD("01/"+StrZero(Month(mv_par01),2)+"/"+Str(Year(mv_par01)))
dPerFim := LastDay(dPerini)


IF UPPER(CFUNNAME2) == UPPER("CDAA030")
	CQRY := " SELECT DISTINCT AH4.R_E_C_N_O_ REGIST, 'AH4' NALIAS  "
	CQRY += " FROM AH1010 AH1, AH4010 AH4"
	CQRY += " WHERE AH1_FORNEC = AH4_FORNEC"
	CQRY += " AND AH1_LOJAFO = AH4_LOJAFO"
	CQRY += " AND AH1_PRODUT = AH4_PRODUT"
	CQRY += " AND AH4_DATCAL BETWEEN '"+dtos(dPerIni)+"' AND '"+dtos(dPerFim)+"'"
	CQRY += " AND AH4_DTPRES = '"+dtos(dPerFim)+"'"
	CQRY += " AND AH4.D_E_L_E_T_ <> '*'"
	CQRY += " AND AH1.D_E_L_E_T_<> '*'"
//	CQRY += " AND AH1_PERIOD = '"+XPERIODO+"'"
	CQRY += " UNION"
	CQRY += " SELECT DISTINCT AH5.R_E_C_N_O_ REGIST, 'AH5' NALIAS"
	CQRY += " FROM AH1010 AH1, AH5010 AH5"
	CQRY += " WHERE AH1_FORNEC = AH5_FORNEC"
	CQRY += " AND AH1_LOJAFO = AH5_LOJAFO"
	CQRY += " AND AH1_PRODUT = AH5_PRODUT"
	CQRY += " AND AH5_DATCAL BETWEEN '"+dtos(dPerIni)+"' AND '"+dtos(dPerFim)+"'"
	CQRY += " AND AH5_DTPRES = '"+dtos(dPerFim)+"'"
	CQRY += " AND AH5.D_E_L_E_T_ <> '*'"
	CQRY += " AND AH1.D_E_L_E_T_<> '*'"
//	CQRY += " AND AH1_PERIOD = '"+XPERIODO+"'"
	CQRY += " UNION"
	CQRY += " SELECT DISTINCT AH6.R_E_C_N_O_ REGIST, 'AH6' NALIAS"
	CQRY += " FROM AH1010 AH1, AH6010 AH6"
	CQRY += " WHERE AH1_FORNEC = AH6_FORNEC"
	CQRY += " AND AH1_LOJAFO = AH6_LOJAFO"
	CQRY += " AND AH1_PRODUT = AH6_PRODUT"
	//CQRY += " AND AH6_DTPRES = '"+dtos(dPerFim)+"'"
	//AH6_DTPRES Igual a   /  /     and AH6_DTPRXD Maior que ou igual a 31/08/2014 and  ( AH6_DTULTI Igual a   /  /     or AH6_DTULTI Menor que 31/08/2014 )
	//anderson - 20140903
	CQRY += " AND AH6_DTPRES = '        ' "
	CQRY += " AND AH6_DTPRXD >= '"+dtos(dPerFim)+"' "
	CQRY += " AND (AH6_DTULTI = '        ' OR AH6_DTULTI <= '"+dtos(dPerFim)+"' )"
	//anderson - 20140903
	CQRY += " AND AH6.D_E_L_E_T_ <> '*'"
	CQRY += " AND AH1.D_E_L_E_T_<> '*'"
//	CQRY += " AND AH1_PERIOD = '"+XPERIODO+"'"
	CQRY += " UNION"
	CQRY += " SELECT DISTINCT AH7.R_E_C_N_O_ REGIST, 'AH7' NALIAS"
	CQRY += " FROM AH1010 AH1, AH7010 AH7"
	CQRY += " WHERE AH1_PRODUT = AH7_PRODUT"
	CQRY += " AND AH7_DATCAL BETWEEN '"+dtos(dPerIni)+"' AND '"+dtos(dPerFim)+"'"
	CQRY += " AND AH7.D_E_L_E_T_ <> '*'"
	CQRY += " AND AH1.D_E_L_E_T_<> '*'"
//	CQRY += " AND AH1_PERIOD = '"+XPERIODO+"'"
	
	
	CQRYCNT := " SELECT COUNT(*) CNTCOUNT FROM ("+CQRY+") "
	
	IF SELECT("TRBCNT")<>0
		DBSELECTAREA("TRBCNT")
		TRBCNT->(DBCLOSEAREA())
	ENDIF
	
	IF SELECT("TRBZ")<>0
		DBSELECTAREA("TRBZ")
		TRBZ->(DBCLOSEAREA())
	ENDIF
	
	TCQUERY CQRYCNT NEW ALIAS TRBCNT
	TCQUERY CQRY NEW ALIAS TRBZ
	
	DBSELECTAREA("TRBCNT")
	TRBCNT->(DBGOTOP())
	
	DBSELECTAREA("TRBZ")
	TRBZ->(DBGOTOP())
	
	If nRegistro == 0
		nRegistro := TRBCNT->CNTCOUNT //(AH4->(RecCount())+AH5->(RecCount())+AH1->(RecCount())+AH7->(RecCount())+1)
	Endif
	ProcRegua(nRegistro)
	
	dbSelectArea("AH4")
	dbSelectArea("AH5")
	dbSelectArea("AH6")
	dbSelectArea("AH7")
	
	WHILE !TRBZ->(EOF())
		IncProc("Deletando registros do periodo ...") //
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga todos os registros do periodo (AH4 - cabecalho da apuracao do DA)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF TRBZ->NALIAS == "AH4"
			AH4->(DBGOTO(TRBZ->REGIST))
			RecLock("AH4",.F.,.T.)
			AH4->(dbDelete())
			AH4->(MSUNLOCK())
		ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga todos os registros do periodo (AH5 - itens da apuracao do DA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF TRBZ->NALIAS == "AH5"
			AH5->(DBGOTO(TRBZ->REGIST))
			RecLock("AH5",.F.,.T.)
			AH5->(dbDelete())
			AH5->(MSUNLOCK())
		ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga todos os registros do periodo (AH6 - fechamentos do DA)            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF TRBZ->NALIAS == "AH6"
			AH6->(DBGOTO(TRBZ->REGIST))
			RecLock("AH6",.F.,.T.)
			AH6->(dbDelete())
			AH6->(MSUNLOCK())
		ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga todos os registros do periodo (AH7 - qtdes acumuladas por mes)     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF TRBZ->NALIAS == "AH7"
			AH7->(DBGOTO(TRBZ->REGIST))
			RecLock("AH7",.F.,.T.)
			AH7->(dbDelete())
			AH7->(MSUNLOCK())
		ENDIF
		TRBZ->(DBSKIP())
	END
	
	
ENDIF

restarea(aarea)
RETURN(0)
