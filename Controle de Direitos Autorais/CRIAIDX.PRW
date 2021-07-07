#INCLUDE"RWMAKE.CH"
#INCLUDE"TOPCONN.CH"
USER FUNCTION CRIAIDX()
LOCAL CQUERY := ""
LOCAL NCONTA := 0
PRIVATE cBanco 	 := ""
PRIVATE	cDbAlias := ""
PRIVATE	cServer	 := ""
PRIVATE	nPort	 := ""
PRIVATE _NCOUNT := 0
PRIVATE cIniFile:= GetADV97()

cBanco	 := GetPvProfString( 'TopConnect', 'DataBase', cBanco, cInIfile )
cDbAlias := GetPvProfString( 'TopConnect', 'Alias'	 , cDbAlias, cInIfile )
cServer	 := GetPvProfString( 'TopConnect', 'Server'  , cServer, cInIfile )
//nPort	 := Val(GetPvProfString( 'TopConnect', 'Port'  , StrZero(nPort, 4, 0), cInIfile ))
// Ajuste pelo Environment do Server
cBanco 	 := GetSrvProfString( 'TopDataBase', cBanco  )
cDbAlias := GetSrvProfString( 'TopAlias'   , cDbAlias)
cServer	 := GetSrvProfString( 'TopServer'  , cServer )
//nPort	 := Val(GetSrvProfString( 'TopPort', StrZero(nPort, 4, 0) ) )
// Ajuste pelo Environment do Server (TOTVSDBACESS)
cBanco	 := GetPvProfString( 'TotvsDbAccess', 'DataBase', cBanco, cInIfile )
cDbAlias := GetPvProfString( 'TotvsDbAccess', 'Alias'	 , cDbAlias, cInIfile )
cServer	 := GetPvProfString( 'TotvsDbAccess', 'Server'  , cServer, cInIfile )
//nPort	 := Val(GetPvProfString( 'TotvsDbAccess', 'Port'  , StrZero(nPort, 4, 0), cInIfile ))
// Ajuste pelo Environment do Server (DBACESS)
cBanco 	 := GetSrvProfString( 'DBDataBase', cBanco  )
cDbAlias := GetSrvProfString( 'DBAlias'   , cDbAlias)
cServer	 := GetSrvProfString( 'DBServer'  , cServer )
//nPort	 := Val(GetSrvProfString( 'DBPort', StrZero(nPort, 4, 0) ) )
// Ajuste pelo Environment do Server (DBACESS)
cBanco	 := GetPvProfString( 'DbAccess', 'DataBase', cBanco, cInIfile )
cDbAlias := GetPvProfString( 'DbAccess', 'Alias'	 , cDbAlias, cInIfile )
cServer	 := GetPvProfString( 'DbAccess', 'Server'  , cServer, cInIfile )
//nPort	 := Val(GetPvProfString( 'TotvsDbAccess', 'Port'  , StrZero(nPort, 4, 0), cInIfile ))
// Ajuste pelo Environment do Server (DBACESS)
cBanco 	 := GetSrvProfString( 'DBDataBase', cBanco  )
cDbAlias := GetSrvProfString( 'DBAlias'   , cDbAlias)
cServer	 := GetSrvProfString( 'DBServer'  , cServer )
//nPort	 := Val(GetSrvProfString( 'DBPort', StrZero(nPort, 4, 0) ) )

//ORACLE
IF ALLTRIM(cBanco) == "ORACLE"
	CQUERY := " SELECT SUBSTR(t.table_name,1,3) AS NOMETBL "
	CQUERY += " FROM dba_tables t"
	CQUERY += " WHERE LENGTH(t.table_name) = 6 "
	CQUERY += " AND t.table_name NOT LIKE '%$%'"
	CQUERY += " AND TABLE_NAME NOT LIKE 'INC%'"
	CQUERY += " AND TABLE_NAME NOT LIKE 'TOP%'"
	CQUERY += " ORDER BY TABLE_NAME "
ELSEIF ALLTRIM(cBanco) == "DB2"
	CQUERY := " SELECT DISTINCT SUBSTR(TabName,1,3) NOMETBL"
	CQUERY += " FROM SysIbmAdm.AdminTabInfo"
	CQUERY += " WHERE SUBSTR(TabSchema,1,15) LIKE 'DB2INST%'"
	CQUERY += " AND SUBSTR(TabName,4,3) = '"+XFILIAL()+"0'"
ELSEIF ALLTRIM(cBanco) == "MSSQL" .OR. ALLTRIM(cBanco) == "MSSQL7"
	CQUERY := " SELECT SUBSTR(name,1,3) AS NOMETBL"
	CQUERY += " FROM sys.all_objects a1 WHERE XTYPE='U' " 
	CQUERY += " AND TABLE_NAME NOT LIKE 'TOP%'" 
	CQUERY += " AND SUBSTR(TabName,4,3) = '"+XFILIAL()+"0'"	
ENDIF

IF SELECT("TRB")<>0
	DBSELECTAREA("TRB")
	TRB->(DBCLOSEAREA())
ENDIF
TCQUERY CQUERY NEW ALIAS TRB
DBSELECTAREA("TRB")
TRB->(DBGOTOP())

WHILE !TRB->(EOF())
	_arq	:= TRB->NOMETBL
	IF  CHKFILE (_arq)
		DbselectArea(_arq)
		DbCloseArea(_arq)
	ENDIF
	NCONTA := NCONTA + 1
	TRB->(DBSKIP())
END
MSGINFO("PROCESSO FINALIZADO, CRIADOS "+STR(NCONTA)+" INDICES")


RETURN
