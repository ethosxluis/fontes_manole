#include "protheus.ch"

#Define ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPODTER  ºAutor  ³FONTANELLI          º Data ³  22/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ralatorio GERENCIAL de Poder de Terceiro                   º±±
±±º          ³ 							                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANOLE                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      //   U_RPODTER()
User Function RPODTER()

Local   oReport
Local   aArea	  	:= GetArea()
Private cPerg     	:= "RPODTER5"
Private cAliasQRY 	:= GetNextAlias()

cPerg := PADR(cPerg,10)  // Ajusta o cperg para 10 posicoes

AjustaSX1(cPerg)

Pergunte(cPerg, .T.)

oReport := ReportDef()
oReport:PrintDialog()

if Select(cAliasQRY) > 0
	(cAliasQRY)->(DbCloseArea())
endif

RestArea( aArea )

Return nil


//----------------------------------------------------------------------------
Static Function ReportDef()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("RPODTER","Poder de Terceiro", cPerg , {|oReport| ReportPrint(oReport)} , " Poder de Terceiro " )
//oReport:SetPortrait()
oReport:SetLandscape()
//oReport:lHeaderVisible 		:= .F. 	// Não imprime cabeçalho do protheus
//oReport:lFooterVisible		:= .F.	// Não imprime rodapé do protheus
//oReport:lParamPage			:= .F.	// Não imprime pagina de parametros
oReport:oPage:nPaperSize   		:= 9	// Ajuste para papel A4

oSection := TRSection():New(oReport,"Poder de Terceiro", cAliasQRY)
oSection:SetHeaderPage(.F.)

If mv_par01 == 1 // Analitico
	TRCell():New(oSection,"CLIE"			,cAliasQRY /*"SA1"*/,"Cod_cli"				,/*Picture*/						, 06	)
	TRCell():New(oSection,"CLIENTE"			,cAliasQRY /*"SA1"*/,"Nome_Cliente"			,/*Picture*/						, 30	)
	TRCell():New(oSection,"VEND"			,cAliasQRY /*"SA1"*/,"Cod_Vend"				,/*Picture*/						, 04	)
	TRCell():New(oSection,"VENDEDOR"		,cAliasQRY /*"SA1"*/,"Nome_Vendedor"			,/*Picture*/						, 30	)
	TRCell():New(oSection,"SEGMENTO"		,cAliasQRY /*"SA1"*/,"Segmento"			,/*Picture*/						, 15	)
	TRCell():New(oSection,"PRODUTO"			,cAliasQRY /*"SA1"*/,"Cod_Prod"			,/*Picture*/						, 15	)
	TRCell():New(oSection,"DESCRICAO"		,cAliasQRY /*"SA1"*/,"Descrição"		,/*Picture*/						, 40	)
	TRCell():New(oSection,"UNITARIO"		,cAliasQRY /*"SA1"*/,"Unitario"			,"@E 999,999.99"					, 10	)
	TRCell():New(oSection,"DESCONTO"		,cAliasQRY 			,"Desconto"	 		,"@E 999"							, 03	)
	TRCell():New(oSection,"SALDO"			,cAliasQRY 			,"Saldo"	 		,"@E 999999"						, 06	)
	TRCell():New(oSection,"TOTAL"			,cAliasQRY 			,"Total"	 		,"@E 999,999,999.99"				, 14	)
endif

If mv_par01 == 2 // Sintetico
	TRCell():New(oSection,"CLIE"			,cAliasQRY /*"SA1"*/,"Cod_Cli"					,/*Picture*/						, 06	)
	TRCell():New(oSection,"CLIENTE"			,cAliasQRY /*"SA1"*/,"Nome_Cliente"				,/*Picture*/						, 30	)
	TRCell():New(oSection,"VEND"			,cAliasQRY /*"SA1"*/,"Cod_Vend"					,/*Picture*/						, 04	)
	TRCell():New(oSection,"VENDEDOR"		,cAliasQRY /*"SA1"*/,"Nome_Vendedor"			,/*Picture*/						, 30	)
	TRCell():New(oSection,"SALDO"			,cAliasQRY 			,"Saldo"	 				,"@E 999999"						, 06	)
	TRCell():New(oSection,"TOTAL"			,cAliasQRY 			,"Total"	 				,"@E 999,999,999.99"				, 14	)
	TRCell():New(oSection,"ACERTO12M"		,cAliasQRY 			,"Acerto_12_Meses" 			,"@E 999,999,999.99"				, 14	)
	TRCell():New(oSection,"ACERTO6M"		,cAliasQRY 			,"Acerto_6_Meses"	 		,"@E 999,999,999.99"				, 14	)
	TRCell():New(oSection,"ACERTO3M"		,cAliasQRY 			,"Acerto_3_Meses"	 		,"@E 999,999,999.99"				, 14	)
	TRCell():New(oSection,"ULTACERTO"		,cAliasQRY 			,"Dt_Ultimo_Acerto" 		,""									, 08	)
	
	//Edmar Mendes do Prado
	//Inclusão do numero da ultima nota e valor
	TRCell():New(oSection,"NFULTACERTO"		,cAliasQRY 			,"Nf_Utimo_Acerto" 			,/*Picture*/						, 09	)
	TRCell():New(oSection,"VALORULTACERTO"	,cAliasQRY 			,"Valor_Ultimo_acerto"		,"@E 999,999,999.99"				, 14	)

	TRCell():New(oSection,"ULTCONSIG"		,cAliasQRY 			,"Dt_Ultima_Consignação" 	,""									, 08	)
	TRCell():New(oSection,"STATUS"			,cAliasQRY 			,"Status" 					,""		 							, 04	)
	TRCell():New(oSection,"VOLCONSIG"		,cAliasQRY 			,"Qtd_Consignação" 			,"@E 999999"						, 06	)

endif

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Ricardo Berti 		³ Data ³24.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection  := oReport:Section(1)

If mv_par01 == 1 // Analitico
    cQuery:= " SELECT * FROM ( "
    cQuery+= " SELECT CLIE, CLIENTE, VEND, " + ENTER
    cQuery+= "        ( SELECT A3_NOME FROM "+RETSQLNAME("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3_COD = VEND AND D_E_L_E_T_ = ' ' ) VENDEDOR, " + ENTER
    cQuery+= "         CODSEG, SEGMENTO, PRODUTO, DESCRICAO, UNITARIO, DESCONTO, SUM(SALDO) SALDO, ((((UNITARIO*SUM(SALDO)))*(100-DESCONTO))/100) TOTAL " + ENTER
    cQuery+= "   FROM (" + ENTER
    cQuery+= "         SELECT  Z2_CLIENTE CLIE, " + ENTER
    cQuery+= "                 ( SELECT A1_NREDUZ FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' AND ROWNUM = 1 ) CLIENTE," + ENTER
    cQuery+= "                 ( SELECT A1_VEND FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' AND ROWNUM = 1 ) VEND," + ENTER
    cQuery+= "                 TO_NUMBER(B1_XSEGME) CODSEG, " + ENTER
    cQuery+= "                 ( CASE TO_NUMBER(B1_XSEGME) " + ENTER
    cQuery+= "                     WHEN 1 THEN 'MEDICINA'" + ENTER
    cQuery+= "                     WHEN 2 THEN 'PUBLICO'" + ENTER
    cQuery+= "                     WHEN 3 THEN 'HUMANAS/EXATAS'" + ENTER
    cQuery+= "                     WHEN 4 THEN 'CIVIL'" + ENTER
    cQuery+= "                     ELSE 'OUTROS' END " + ENTER
    cQuery+= "                 ) SEGMENTO," + ENTER
    cQuery+= "                 SUBSTR(Z2_PRODUTO,1,40) PRODUTO, " + ENTER
    cQuery+= "                 B1_DESC DESCRICAO, " + ENTER
    cQuery+= "                 B1_PRV1 UNITARIO," + ENTER
    cQuery+= "                 ( CASE TO_NUMBER(B1_XSEGME) " + ENTER
    cQuery+= "                       WHEN 1 THEN ( SELECT NVL(MAX(A1_XDESC1),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                       WHEN 2 THEN ( SELECT NVL(MAX(A1_XDESC2),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                       WHEN 3 THEN ( SELECT NVL(MAX(A1_XDESC3),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                       WHEN 4 THEN ( SELECT NVL(MAX(A1_XDESC4),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                       ELSE 0 END " + ENTER
    cQuery+= "                 ) DESCONTO," + ENTER
    cQuery+= "                 Z2_QTDCON - ( Z2_DEVSIMB + Z2_DEVFIS ) SALDO " + ENTER
    cQuery+= "    FROM "+RETSQLNAME("SZ2")+", "+RETSQLNAME("SB1")+"" + ENTER
    cQuery+= "   WHERE Z2_FILIAL = '"+xFilial("SZ2")+"'" + ENTER
    cQuery+= "     AND Z2_CLIENTE BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'" + ENTER
    cQuery+= "     AND Z2_PRODUTO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'" + ENTER
    cQuery+= "     AND "+RETSQLNAME("SZ2")+".D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "     AND B1_FILIAL = '"+xFilial("SB1")+"'" + ENTER
    cQuery+= "     AND B1_COD = Z2_PRODUTO " + ENTER
    cQuery+= "     AND "+RETSQLNAME("SB1")+".D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "   )" + ENTER
    cQuery+= " WHERE CLIE NOT IN ('000169','002401','99OQTQ') " + ENTER
    cQuery+= "   AND CLIENTE <> ' ' " + ENTER
    cQuery+= " GROUP BY CLIE, CLIENTE, VEND, CODSEG, SEGMENTO, PRODUTO, DESCRICAO, UNITARIO, DESCONTO" + ENTER
    cQuery+= " ) "+ ENTER
    cQuery+= " WHERE SALDO > 0 "+ ENTER
    cQuery+= "   AND VEND BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'" + ENTER
    cQuery+= " ORDER BY CLIE, VEND, CODSEG, PRODUTO " + ENTER
endif

If mv_par01 == 2 // Sintetico

    cQuery:= " SELECT * FROM ( "
    cQuery+= " SELECT CLIE, CLIENTE, VEND, " + ENTER
    cQuery+= "       ( SELECT A3_NOME FROM "+RETSQLNAME("SA3")+" WHERE A3_FILIAL = '"+xFilial("SA3")+"' AND A3_COD = VEND AND D_E_L_E_T_ = ' ' ) VENDEDOR, " + ENTER
	cQuery+= "       SUM(SALDO) SALDO, SUM(TOTAL) TOTAL, " + ENTER
    cQuery+= "       (" + ENTER
    cQuery+= "         SELECT NVL(SUM(D2_TOTAL),0) FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "          WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "            AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "            AND D2_EMISSAO BETWEEN '"+dtos(ddatabase-360)+"' AND '"+dtos(ddatabase)+"'" + ENTER // 12 MESES
    cQuery+= "            AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "            AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "       ) ACERTO12M," + ENTER
    cQuery+= "       (" + ENTER
    cQuery+= "         SELECT NVL(SUM(D2_TOTAL),0) FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "          WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "            AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "            AND D2_EMISSAO BETWEEN '"+dtos(ddatabase-180)+"' AND '"+dtos(ddatabase)+"'" + ENTER // 6 MESES
    cQuery+= "            AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "            AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "       ) ACERTO6M," + ENTER
    cQuery+= "      (" + ENTER
    cQuery+= "         SELECT NVL(SUM(D2_TOTAL),0) FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "          WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "            AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "            AND D2_EMISSAO BETWEEN '"+dtos(ddatabase-90)+"' AND '"+dtos(ddatabase)+"'" + ENTER // 3 MESES
    cQuery+= "            AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "            AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "       ) ACERTO3M," + ENTER
    cQuery+= "       (" + ENTER
    cQuery+= "         SELECT NVL(SUBSTR(MAX(D2_EMISSAO),7,2)||'/'||SUBSTR(MAX(D2_EMISSAO),5,2)||'/'||SUBSTR(MAX(D2_EMISSAO),3,2),' ') FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "          WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "            AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "            AND D2_EMISSAO BETWEEN '"+dtos(ddatabase-360)+"' AND '"+dtos(ddatabase)+"'" + ENTER // 12 MESES
    cQuery+= "            AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "            AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "       ) ULTACERTO,   " + ENTER
    cQuery+= "       (" + ENTER
    cQuery+= "          SELECT NVL(SUBSTR(MAX(D2_EMISSAO),7,2)||'/'||SUBSTR(MAX(D2_EMISSAO),5,2)||'/'||SUBSTR(MAX(D2_EMISSAO),3,2),' ') FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "           WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "             AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "             AND D2_CF IN ('5917', '6917')" + ENTER
    cQuery+= "             AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "        ) ULTCONSIG," + ENTER

    cQuery+= "       (" + ENTER
    cQuery+= "           SELECT MAX(D2_DOC) FROM SD2010 " + ENTER
    cQuery+= "            WHERE D2_FILIAL = '01'" + ENTER
    cQuery+= "           	AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "              AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "              AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "        ) NFULTACERTO," + ENTER


    cQuery+= "       (" + ENTER
    cQuery+= "           SELECT NVL(SUM(D2_TOTAL),0) FROM SD2010 " + ENTER
    cQuery+= "            WHERE D2_FILIAL = '01'" + ENTER
    cQuery+= "              AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "              AND D2_EMISSAO >= (" + ENTER
    cQuery+= "                                 SELECT MAX(D2_EMISSAO)  FROM SD2010" + ENTER
    cQuery+= "                                  WHERE D2_FILIAL = '01'" + ENTER
    cQuery+= "                                    AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "                                    AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "                                    AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "                                 ) " + ENTER
    cQuery+= "              AND D2_CF IN ('5113', '6113')" + ENTER
    cQuery+= "              AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "        ) VALORULTACERTO," + ENTER



    cQuery+= "       (" + ENTER
    cQuery+= "          SELECT NVL(SUM(D2_QUANT),0) FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "           WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "             AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "             AND D2_EMISSAO >= (" + ENTER
    cQuery+= "                                SELECT MAX(D2_EMISSAO)-5 FROM "+RETSQLNAME("SD2")+" " + ENTER
    cQuery+= "                                WHERE D2_FILIAL = '"+xFilial("SD2")+"'" + ENTER
    cQuery+= "                                   AND D2_CLIENTE = CLIE" + ENTER
    cQuery+= "                                   AND D2_CF IN ('5917', '6917')" + ENTER
    cQuery+= "                                   AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "                                )" + ENTER
    cQuery+= "             AND D2_CF IN ('5917', '6917')" + ENTER
    cQuery+= "             AND D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "       ) VOLCONSIG" + ENTER
    cQuery+= " FROM (" + ENTER
    cQuery+= "         SELECT CLIE, CLIENTE, VEND, CODSEG, SEGMENTO, PRODUTO, DESCRICAO, UNITARIO, DESCONTO, SUM(SALDO) SALDO, ((((UNITARIO*SUM(SALDO)))*(100-DESCONTO))/100) TOTAL" + ENTER
    cQuery+= "          FROM (" + ENTER
    cQuery+= "                 SELECT  Z2_CLIENTE CLIE, " + ENTER
    cQuery+= "                         ( SELECT A1_NREDUZ FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' AND ROWNUM = 1) CLIENTE," + ENTER
    cQuery+= "                         ( SELECT A1_VEND FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' AND ROWNUM = 1) VEND," + ENTER
    cQuery+= "                         TO_NUMBER(B1_XSEGME) CODSEG, " + ENTER
    cQuery+= "                         ( CASE TO_NUMBER(B1_XSEGME) " + ENTER
    cQuery+= "                             WHEN 1 THEN 'MEDICINA'" + ENTER
    cQuery+= "                             WHEN 2 THEN 'PUBLICO'" + ENTER
    cQuery+= "                             WHEN 3 THEN 'HUMANAS/EXATAS'" + ENTER
    cQuery+= "                             WHEN 4 THEN 'CIVIL'" + ENTER
    cQuery+= "                             ELSE 'OUTROS' END " + ENTER
    cQuery+= "                         ) SEGMENTO," + ENTER
    cQuery+= "                         SUBSTR(Z2_PRODUTO,1,40) PRODUTO, " + ENTER
    cQuery+= "                         B1_DESC DESCRICAO, " + ENTER
    cQuery+= "                         B1_PRV1 UNITARIO," + ENTER
    cQuery+= "                         ( CASE TO_NUMBER(B1_XSEGME)" + ENTER
    cQuery+= "                               WHEN 1 THEN ( SELECT NVL(MAX(A1_XDESC1),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                               WHEN 2 THEN ( SELECT NVL(MAX(A1_XDESC2),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                               WHEN 3 THEN ( SELECT NVL(MAX(A1_XDESC3),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                               WHEN 4 THEN ( SELECT NVL(MAX(A1_XDESC4),0) FROM "+RETSQLNAME("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z2_CLIENTE AND D_E_L_E_T_ = ' ' )" + ENTER
    cQuery+= "                               ELSE 0 END " + ENTER
    cQuery+= "                         ) DESCONTO," + ENTER
    cQuery+= "                         Z2_QTDCON - ( Z2_DEVSIMB + Z2_DEVFIS ) SALDO " + ENTER
    cQuery+= "            FROM "+RETSQLNAME("SZ2")+", "+RETSQLNAME("SB1")+"" + ENTER
    cQuery+= "           WHERE Z2_FILIAL = '"+xFilial("SZ2")+"'" + ENTER
    cQuery+= "             AND Z2_CLIENTE BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'" + ENTER
    cQuery+= "             AND Z2_PRODUTO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'" + ENTER
    cQuery+= "             AND "+RETSQLNAME("SZ2")+".D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "             AND B1_FILIAL = '"+xFilial("SB1")+"'" + ENTER
    cQuery+= "             AND B1_COD = Z2_PRODUTO " + ENTER
    cQuery+= "             AND "+RETSQLNAME("SB1")+".D_E_L_E_T_ = ' '" + ENTER
    cQuery+= "           )" + ENTER
    cQuery+= "         WHERE CLIE NOT IN ('000169','002401','99OQTQ') " + ENTER
    cQuery+= "         AND CLIENTE <> ' '" + ENTER
    cQuery+= "         GROUP BY CLIE, CLIENTE, VEND, CODSEG, SEGMENTO, PRODUTO, DESCRICAO, UNITARIO, DESCONTO" + ENTER
    cQuery+= "      ) " + ENTER
    cQuery+= " GROUP BY CLIE, CLIENTE, VEND" + ENTER
    cQuery+= " ) "+ ENTER
    cQuery+= " WHERE SALDO > 0 "+ ENTER
    cQuery+= "   AND VEND BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'" + ENTER
    cQuery+= " ORDER BY CLIE" + ENTER

endif

conout(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )
oSection:Init()

xTOTAL := 0
xSALDO := 0
xGTOTAL := 0
xGSALDO := 0

xCLIENTE:= (cAliasQry)->CLIE

While (cAliasQry)->(!EOF())

	xSALDO := xSALDO + (cAliasQry)->SALDO
	xTOTAL := xTOTAL + (cAliasQry)->TOTAL

	xGSALDO := xGSALDO + (cAliasQry)->SALDO
	xGTOTAL := xGTOTAL + (cAliasQry)->TOTAL

	If mv_par01 == 1 // Analitico
		osection:cell("CLIE"):setValue((cAliasQry)->CLIE)
		osection:cell("CLIENTE"):setValue((cAliasQry)->CLIENTE)
		osection:cell("VEND"):setValue((cAliasQry)->VEND)
		osection:cell("VENDEDOR"):setValue((cAliasQry)->VENDEDOR)
		osection:cell("SEGMENTO"):setValue((cAliasQry)->SEGMENTO)
		osection:cell("PRODUTO"):setValue((cAliasQry)->PRODUTO)
		osection:cell("DESCRICAO"):setValue((cAliasQry)->DESCRICAO)
		osection:cell("UNITARIO"):setValue((cAliasQry)->UNITARIO)
		osection:cell("DESCONTO"):setValue((cAliasQry)->DESCONTO)
		osection:cell("SALDO"):setValue((cAliasQry)->SALDO)
		osection:cell("TOTAL"):setValue((cAliasQry)->TOTAL)
	endif

	If mv_par01 == 2 // Sintetico
		osection:cell("CLIE"):setValue((cAliasQry)->CLIE)
		osection:cell("CLIENTE"):setValue((cAliasQry)->CLIENTE)
		osection:cell("VEND"):setValue((cAliasQry)->VEND)
		osection:cell("VENDEDOR"):setValue((cAliasQry)->VENDEDOR)
		osection:cell("SALDO"):setValue((cAliasQry)->SALDO)
		osection:cell("TOTAL"):setValue((cAliasQry)->TOTAL)
		osection:cell("ACERTO12M"):setValue((cAliasQry)->ACERTO12M)
		osection:cell("ACERTO6M"):setValue((cAliasQry)->ACERTO6M)
		osection:cell("ACERTO3M"):setValue((cAliasQry)->ACERTO3M)
		osection:cell("ULTACERTO"):setValue((cAliasQry)->ULTACERTO)
		osection:cell("NFULTACERTO"):setValue((cAliasQry)->NFULTACERTO)
		osection:cell("VALORULTACERTO"):setValue((cAliasQry)->VALORULTACERTO)

		osection:cell("ULTCONSIG"):setValue((cAliasQry)->ULTCONSIG)
		
		if (cAliasQry)->SALDO == (cAliasQry)->VOLCONSIG
			osection:cell("STATUS"):setValue("NOVO")
	    else
			osection:cell("STATUS"):setValue("")
		endif
		osection:cell("VOLCONSIG"):setValue((cAliasQry)->VOLCONSIG)
	endif

	oSection:PrintLine()

	(cAliasQry)->(DbSkip())

	if 	xCLIENTE <> (cAliasQry)->CLIE

		If mv_par01 == 1 // Analitico
			osection:cell("CLIE"):setValue("TOTAL")
			osection:cell("CLIENTE"):setValue("")
			osection:cell("VEND"):setValue("")
			osection:cell("VENDEDOR"):setValue("")
			osection:cell("SEGMENTO"):setValue("")
			osection:cell("PRODUTO"):setValue("")
			osection:cell("DESCRICAO"):setValue("")
			osection:cell("UNITARIO"):setValue(0)
			osection:cell("DESCONTO"):setValue(0)
			osection:cell("SALDO"):setValue(xSALDO)
			osection:cell("TOTAL"):setValue(XTOTAL)
			oSection:PrintLine() //Imprime Linha
			oReport:Thinline()
		endif

		xSALDO := 0
		xTOTAL := 0

	endif

	xCLIENTE := (cAliasQry)->CLIE

EndDO

If mv_par01 == 1 // Analitico
	osection:cell("CLIE"):setValue("GERAL")
	osection:cell("CLIENTE"):setValue("")
	osection:cell("VEND"):setValue("")
	osection:cell("VENDEDOR"):setValue("")
	osection:cell("SEGMENTO"):setValue("")
	osection:cell("PRODUTO"):setValue("")
	osection:cell("DESCRICAO"):setValue("")
	osection:cell("UNITARIO"):setValue(0)
	osection:cell("DESCONTO"):setValue(0)
	osection:cell("SALDO"):setValue(xGSALDO)
	osection:cell("TOTAL"):setValue(XGTOTAL)
	oSection:PrintLine() //Imprime Linha
	oReport:Thinline()
endif

If mv_par01 == 2 // Sintetico
	osection:cell("CLIE"):setValue("GERAL")
	osection:cell("CLIENTE"):setValue("")
	osection:cell("VEND"):setValue("")
	osection:cell("VENDEDOR"):setValue("")
	osection:cell("SALDO"):setValue(xGSALDO)
	osection:cell("TOTAL"):setValue(XGTOTAL)
	osection:cell("ACERTO12M"):setValue(0)
	osection:cell("ACERTO6M"):setValue(0)
	osection:cell("ACERTO3M"):setValue(0)
	osection:cell("ULTACERTO"):setValue("")
	
	osection:cell("NFULTACERTO"):setValue("")
	osection:cell("VALORULTACERTO"):setValue(0)
	osection:cell("ULTCONSIG"):setValue("")				
	osection:cell("STATUS"):setValue("")
	osection:cell("VOLCONSIG"):setValue(0)
	oSection:PrintLine() //Imprime Linha
	oReport:Thinline()
endif


oSection:Finish()

Return NIL


//---------------------------------------------------------------
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()

dbSelectArea( "SX1" )
dbSetOrder( 1 )

If !dbSeek( cPerg )
	PutSx1(cPerg, '01', 'Impressao ?', 'Impressao ?','Impressao ?', 'mv_ch1', 'N', 1, 0, 2,'C',  '',  ''  ,'' ,	 '','mv_par01',	 'Analitico',	'Analitico','Analitico', '', 'Sintetico', 'Sintetico','Sintetico','','','','','','','','','','')
	PutSx1(cPerg, '02', 'Cliente de ?', 'Cliente de ?', 'Cliente de ?', 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par02','','','','','','','','','','','','','','','','','')
	PutSx1(cPerg, '03', 'Cliente ate ?', 'Cliente ate ?', 'Cliente ate ?', 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03','','','','','','','','','','','','','','','','','')
	PutSx1(cPerg, '04', 'Produto de ?', 'Produto de ?', 'Produto de ?', 'mv_ch4', 'C', 30, 0, 0, 'G', '', 'SB1', '', '', 'mv_par04','','','','','','','','','','','','','','','','','')
	PutSx1(cPerg, '05', 'Produto ate ?', 'Produto ate ?', 'Produto ate ?', 'mv_ch5', 'C', 30, 0, 0, 'G', '', 'SB1', '', '', 'mv_par05','','','','','','','','','','','','','','','','','')
	PutSx1(cPerg, '06', 'Vendedor de ?', 'Vendedor de ?', 'Vendedor de ?', 'mv_ch6', 'C', 6, 0, 0, 'G', '', 'SA3', '', '', 'mv_par06','','','','','','','','','','','','','','','','','')
	PutSx1(cPerg, '07', 'Vendedor ate ?', 'Vendedor ate ?', 'Vendedor ate ?', 'mv_ch7', 'C', 6, 0, 0, 'G', '', 'SA3', '', '', 'mv_par07','','','','','','','','','','','','','','','','','')
Endif

RestArea( aArea )
Return Nil