#INCLUDE "PROTHEUS.CH"


//-------------------------------------------------------------------
User Function VFATX002(cCliente,cLoja)
Local dDtAcer	:= ""
Local nMaxdias	:= 0
Local lRet		:= .F.


//Allan Bonfim - 13/05/2016 - Retirada a validação conforme solicitação do Daniel e aprovação do Rogério
/*
nMaxDias := GetMv("MV_XDIASCO",,40)

dDtAcer := U_VFATX003(cCliente,cLoja)

If dDatabase - dDtAcer < nMaxDias .Or. dDtAcer == Ctod("01/01/1970")
	lRet := .T.
Else
	Aviso(OemToAnsi('VFATX002'), ;
	'O cliente tem mais de 30 dias que nÃo faz acerto de consignacao. Consignação nÃo permitida ' , {'Ok'})
Endif
*/
lRet := .T.

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VFATX003  ºAutor  ³TOTVS               º Data ³  10/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para retornar a data do ultimo acerto de onsignacao  º±±
±±º          ³do cliente.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VFATX003(cCliente,cLoja)
Local dDtAcer   := DDATABASE
Local cQuery    := ''
Local ENTERL    := CHR(13)+CHR(10)
Local cAliasNew := GetNextAlias()
//NVL PARA ORACLE
cQuery := " SELECT NVL(MAX(Z1_EMISSAO),'19700101') AS DTACER " + ENTERL
cQuery += " FROM " + RetSqlName("SZ1") + " SZ1 "+ENTERL
cQuery += " WHERE SZ1.Z1_FILIAL  = '"+ xFilial("SZ1")+"' AND "+ENTERL
cQuery += " SZ1.Z1_CLIENTE = '"+ cCliente +"' AND "+ENTERL
cQuery += " SZ1.Z1_LOJA = '"+ cLoja    +"' AND "+ENTERL
cQuery += " (SZ1.Z1_TIPO = 'D' OR SZ1.Z1_TIPO = 'S') AND  "+ENTERL
cQuery += " SZ1.D_E_L_E_T_ = ' ' " + ENTERL

MEMOWRITE ("VFATX003.TXT",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

dDtAcer := Stod((cAliasNew)->DTACER)

(cAliasNew)->(DbCloseArea())


Return(dDtAcer)