#INCLUDE"PROTHEUS.CH"
#INCLUDE"TOPCONN.CH"
USER FUNCTION AJCDACAL()
LOCAL CQUERY := ""
LOCAL NI
LOCAL AGRVSE2
Private lMsErroAuto := .F.

CQUERY := " SELECT AH6_FORNEC, AH6_LOJAFO, AH6_DTPRES, SUM(AH6_VALORD - AH6_DESCIR) TOTAL FROM "+RETSQLNAME("AH6")+"  AH6  "
CQUERY += " WHERE  AH6_DTPRES = '20130131' "
CQUERY += " AND D_E_L_E_T_ <> '*' "
CQUERY += " AND AH6_FORNEC NOT IN (SELECT E2_FORNECE FROM SE2010 WHERE E2_PREFIXO = 'RYI' AND E2_EMISSAO >= '20121115' AND D_E_L_E_T_ <> '*') "
CQUERY += " AND AH6_VALORD <> 0 "
CQUERY += " GROUP  BY AH6_FORNEC, AH6_LOJAFO, AH6_DTPRES "
CQUERY += " ORDER BY AH6_FORNEC "

IF SELECT("TRB")<>0
DBSELECTAREA("TRB")
TRB->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS TRB

DBSELECTAREA("TRB")
TRB->(DBGOTOP())
_ndoc := "000001685"
WHILE !TRB->(EOF())
	aGrvSe2	:=	{	{ "E2_FILIAL"	, xFilial("SE2")							  					, Nil },;
						{ "E2_PREFIXO"	, "RYI" 													, Nil },;
						{ "E2_NUM"		, _ndoc														, Nil },;
						{ "E2_TIPO"		, "RC "														, Nil },;
						{ "E2_NATUREZ"	, "20020     "												, Nil },;
						{ "E2_PORTADO"	, "   "	 							   						, Nil },;
						{ "E2_FORNECE"	, TRB->AH6_FORNEC				 									, Nil },;
						{ "E2_LOJA"   	, TRB->AH6_LOJAFO													, Nil },;
						{ "E2_NOMFOR"	, POSICIONE("SA2",1,XFILIAL("SA2")+TRB->AH6_FORNEC+TRB->AH6_LOJAFO,"SA2->A2_NREDUZ") 											, Nil },;
						{ "E2_EMISSAO"	, CTOD("30/11/2012")													, Nil },;
						{ "E2_VENCTO"	, CTOD("29/12/2012")												, Nil },;
						{ "E2_VENCORI"	, CTOD("29/12/2012")												, Nil },;
						{ "E2_VENCREA"	, DataValida(CTOD("29/12/2012"))								, Nil },;
						{ "E2_VALOR"  	, TRB->TOTAL												, Nil },;
						{ "E2_SALDO"  	, TRB->TOTAL												, Nil },;
						{ "E2_BCOPAG" 	, SA2->A2_BANCO					     					, Nil },;
						{ "E2_EMIS1"  	, CTOD("30/11/2012")													, Nil },;
						{ "E2_MOEDA"	, 1		, Nil },;
						{ "E2_VLCRUZ" 	, TRB->TOTAL	, Nil },;
						{ "E2_HIST"   	, "1112.Pagamento de D.A."												, Nil },;
						{ "E2_PARCELA"	, "1"	 			, Nil },; 			
						{ "E2_ORIGEM" 	, "CDAA040 "											  		, Nil },;
						{ "E2_IRRF" 	, 0											  		, Nil }	}
 
	lMsErroAuto := .F.
	MsExecAuto({ | a,b,c | Fina050(a,b,c) },aGrvSe2,,3)
	If lMsErroAuto
		Help(" ", 1, "ERROGERACP")
		Exit
	Endif 
	_ndoc := SOMA1(_ndoc)
	TRB->(DBSKIP())
END

RETURN()