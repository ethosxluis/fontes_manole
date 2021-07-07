#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MNLITNEG º Autor ³Edmar Mendes Prado  º Data ³  28/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia lembrete sobre pedidos que integraram com valor nega-º±±
±±ºtivo                                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 																	  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MNLITNEG()

Local cErrMail1  := "ecommerce@manole.com.br; lazaro@manole.com.br;financeiro.cr@manole.com.br; cobrancas@manole.com.br; wallace.pereira@ethosx.com;"
Local cQuery1	:= ""
//Local aTabelas	:= {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","SC5","SC6","UA3","UA4","UA5"}
Local aTabelas	:= {}
Local cAlias1	:= GetNextAlias()

RPCClearEnv()																					//Limpa o ambiente
RPCSetType(3)																					//Define o ambiente nao consome licenca
Prepare Environment Empresa "01" Filial "01" 

//Verifica se existem pedidos com valores negativos
Conout("** INICIO - Verifica Pedidos " + DtoC(Date()) + " - " + Time() + " **")

cQuery1:= " SELECT DISTINCT C6_NUM, C6_CLI, C6_LOJA, C6_ENTREG, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_PRUNIT, C6_PRCVEN, C6_VALOR "+CHR(13)+CHR(10)
cQuery1+= "	FROM SC6010 SC6 WHERE SC6.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
cQuery1+= "  AND C6_ENTREG >= '20180620' "+CHR(13)+CHR(10)
cQuery1+= "	AND (C6_PRCVEN < 0 OR C6_VALOR < 0 OR C6_PRUNIT < 0 ) "+CHR(13)+CHR(10)
cQuery1+= "	AND C6_NOTA = ' ' "+CHR(13)+CHR(10)
cQuery1:= ChangeQuery(cQuery1)

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery1),cAlias1, .T., .T.)

(cAlias1)->(dbGoTop())
While !(cAlias1)->(Eof())

		U_EXPMAIL(cErrMail1, "PEDIDOS VTEX COM VALORES NEGATIVOS, ALTERE: "+(cAlias1)->C6_NUM, " ALTERE O PEDIDO "+(cAlias1)->C6_NUM+" - "+(cAlias1)->C6_PRODUTO+" - "+(cAlias1)->C6_DESCRI + " ser faturado com os valores corretos. ")

	(cAlias1)->(dbSkip())
EndDo

(cAlias1)->(dbCloseArea())
          
Conout("** FIM - Verifica Pedidos " + DtoC(Date()) + " - " + Time() + " **")

Return(Nil)


