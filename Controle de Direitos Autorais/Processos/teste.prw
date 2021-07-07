#include "protheus.ch"
user function testee2()
	Local nI		:=	0
	Local aArea		:=	GetArea()
	Local cHistorico:=	""
	Local aGrvSe2	:=	{}
	Local nValAcum := 500
	Local cCodPraz	:= '001'
	Local dDataTit	:= stod('20171231')
	Local cCodForn	:= 'A00414'
	Local cLojaFor	:= '01'

	Private lMsErroAuto := .F.

	aVenc := Condicao(ROUND(nValAcum,2),cCodPraz,,dDataTit)

	SA2 -> ( dbSeek( xFilial("SA2") + cCodForn + cLojaFor ) )

	cHistorico := "Pagamento de D.A."

	For nI := 1 To Len(aVenc)
		aGrvSe2	:=	{	{ "E2_FILIAL"	, xFilial("SE2")											, Nil },;
			{ "E2_PREFIXO"	, "RYI"				, Nil },;
			{ "E2_NUM"		, '9A9A9A9A9'													, Nil },;
			{ "E2_TIPO"		, 'RC'													, Nil },;
			{ "E2_NATUREZ"	, '20020'													, Nil },;
			{ "E2_PORTADO"	, '341'				   						, Nil },;
			{ "E2_FORNECE"	, cCodForn				 									, Nil },;
			{ "E2_LOJA"   	, cLojaFor													, Nil },;
			{ "E2_NOMFOR"	, 'SAMPAIO FERRAZ' 											, Nil },;
			{ "E2_EMISSAO"	, dDataTit													, Nil },;
			{ "E2_VENCTO"	, aVenc[nI][1]												, Nil },;
			{ "E2_VENCORI"	, aVenc[nI][1]												, Nil },;
			{ "E2_VENCREA"	, DataValida(aVenc[nI][1])								, Nil },;
			{ "E2_VALOR"  	, aVenc[nI][2]												, Nil },;
			{ "E2_SALDO"  	, aVenc[nI][2]												, Nil },;
			{ "E2_BCOPAG" 	, '341'					     					, Nil },;
			{ "E2_EMIS1"  	, dDataBase													, Nil },;
			{ "E2_MOEDA"	, 1		, Nil },;
			{ "E2_VLCRUZ" 	, xMoeda((aVenc[nI][2]-0),1,1,dDataTit)	, Nil },;
			{ "E2_HIST"   	, cHistorico												, Nil },;
			{ "E2_PARCELA"	, StrZero(nI, Len(SE2->E2_PARCELA))	 			, Nil },;
			{ "E2_ORIGEM" 	, 'TESTE'											  		, Nil },;
			{ "E2_DIRF" 	, '2'					  		, Nil },;
			{ "E2_CODRET" 	, '    '					  	, Nil },;
			{ "E2_IRRF" 	, 10											  		, Nil },;
			{ "E2_LA"       ,' '                            ,NIL}	}
			/*E2_DIRF PROCESSO PARA A GERAÇÃO DA DARF 1=SIM;2=NÃO*/
			/*E2_CODRET PROCESSO PARA A GERAÇÃO DA DARF CODIGO DE RETENSÃO*/
		lMsErroAuto := .F.
		Public mv_par04		:= 2 	// contabilização off line
		Public lOnline		:= nil	// contabilização off line
		MsExecAuto({ | a,b,c | Fina050(a,b,c) },aGrvSe2,,3)
		If lMsErroAuto
			Help(" ", 1, "ERROGERACP")
			Exit
		Endif
	Next


	RestArea(aArea)
RETURN