#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "PARMTYPE.CH"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"
#include 'parmtype.ch'
#include 'RestFul.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNPED01   ºAutor  ³LEANDRO DUARTE      º Data ³  08/19/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EFETUA O CADASTRO DO PEDIDO E DO CLIENTE CONFORME REGRAS   º±±
±±º          ³DA MIT DE LEVANTAMENTO                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNPED01(aNomeTab)
Local cPdCpf	:= tamsx3("A1_CGC")[1]
Local cPdVTex	:= tamsx3("C5_VTEX")[1]
Local NOPC		:= 3
Local cLoja		:= ""
Local cCodigo	:= ""
Local aLog		:= {}
Local lPedOk 	:= .T.
Local nFor1		:= 0
Local nFor2		:= 0
Local lDisEmail	:= .T.
Local aTables := {"PAE","SF2","SD2","SF1","SD1","SE1","SA1","SA2","SE2","SD3","SL1","SL2","SL3","SL4","UA1","CC2","SB1","SB2","SC9","AFA","AF9"}

Local cErItNgC	:= "ecommerce@manole.com.br;lazaro@manole.com.br;wallace.pereira@ethosx.com;t.i@manole.com.br"
Local cErItNgL	:= "ecommerce@manole.com.br;lazaro@manole.com.br;wallace.pereira@ethosx.com;t.i@manole.com.br"
Local nFor := 0

Private lMsErroauto		:= .f.
Private lMsHelpAuto		:= .f.
Private lautoErrNoFile	:= .T.
Private aGrvSa1	:= {}
Private aGrvSC5 := {}
Private aGrvSC6 := {}
private xParSC5	:= "V00000"
Private lJob		:= GETNEWPAR("MV_VTEXJOB",.F.)
Private _pedant  := "      "
Private _cFilant := "  "
Private _cFilatu := "  "
Private lMsmped   := .F.
Private _pedgrv   := .F.


Private lWin 	:= file('c:\windows')
Private cArqPd 	:= iif(lWin,"\imp_vtex\","/imp_vtex/")
Private cNomArq	:= dtos(date())+replace(time(),':','')



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³capturo a tabela que estamos usando analisa se deve gravar os dados na tabela de Cliente, para saber se ja existe a estrutura da tabela DEPARA de cliente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nScan:= aScan(aNomeTab,{|x| x[1] == '1' })
if nScan > 0
	iif(SELECT("GRVCLI")>0,GRVCLI->(DbCloseArea()),nil)
	iif(SELECT("TRBCLI")>0,TRBCLI->(DbCloseArea()),nil)
	dbUseArea(.T.,,aNomeTab[nScan][2],"GRVCLI", .T., .F. )
	Private aCpos	:= Extrut(aNomeTab[nScan][2])
	iif(SELECT("GRVCLI")>0,nil,dbUseArea(.T.,,aNomeTab[nScan][2],"GRVCLI", .T., .F. ))
	dbselectarea("GRVCLI")
	GRVCLI->(dbgotop())
	while GRVCLI->(!eof())
		lMsErroauto		:= .f.
		lMsHelpAuto		:= .f.
		lautoErrNoFile	:= .T.
		aGrvSa1 := {}
		if GRVCLI->UXU_PROQUE == 0
			For nFor1 := 1 to LEN(aCpos)
				aadd(aGrvSa1,{aCpos[nFor1][2],&("GRVCLI->"+aCpos[nFor1][2]),nil})
				&("M->"+aCpos[nFor1][2]) := &("GRVCLI->"+aCpos[nFor1][2])
			Next
			if (nLoc := ascan(aGrvSa1,{|z| alltrim(z[1])=='A1_PAIS'}) ) >0
				aGrvSa1[nLoc][2] := "105"
				&("M->"+aGrvSa1[nLoc][1]) := aGrvSa1[nLoc][2]
			else
				aadd(aGrvSa1,{"A1_PAIS"	,"105", nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			if ascan(aCpos,{|z| alltrim(z[2])=='A1_IE'})>0
				aadd(aGrvSa1,{"A1_INSCR"	,IIF(LEN(ALLTRIM(StrTran(GRVCLI->A1_IE,"-","")))<10,"ISENTO", StrTran(GRVCLI->A1_IE,"-","")), nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			else
				aadd(aGrvSa1,{"A1_INSCR"	,"ISENTO", nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			if ascan(aCpos,{|z| alltrim(z[2])=='A1_CGC'})>0
				aadd(aGrvSa1,{"A1_TPESSOA"		,IIF(LEN(StrTran(GRVCLI->A1_CGC,"-",""))<14,"PF","PJ"), nil })
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			if (ascan(aCpos,{|z| alltrim(z[2])=='A1_ESTADO'})>0 .and. ascan(aCpos,{|z| alltrim(z[2])=='A1_MUN'})>0)
				aadd(aGrvSa1,{"A1_CODMUN"			,ACHAMUN(ALLTRIM(GRVCLI->A1_ESTADO),ALLTRIM(GRVCLI->A1_MUN),ALLTRIM(GRVCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
				aadd(aGrvSa1,{"A1_COD_MUN"			,ACHAMUN(ALLTRIM(GRVCLI->A1_ESTADO),ALLTRIM(GRVCLI->A1_MUN),ALLTRIM(GRVCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			ELSEIF (ascan(aCpos,{|z| alltrim(z[2])=='A1_ESTE'})>0 .and. ascan(aCpos,{|z| alltrim(z[2])=='A1_MUN'})>0)
				aadd(aGrvSa1,{"A1_CODMUN"			,ACHAMUN(ALLTRIM(GRVCLI->A1_ESTE),ALLTRIM(GRVCLI->A1_MUN),ALLTRIM(GRVCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
				aadd(aGrvSa1,{"A1_COD_MUN"			,ACHAMUN(ALLTRIM(GRVCLI->A1_ESTE),ALLTRIM(GRVCLI->A1_MUN),ALLTRIM(GRVCLI->A1_EST))		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³analisa se existe o cliente caso não exista crie caso contrario atualize³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if ascan(aCpos,{|z| alltrim(z[2])=='A1_CGC'})>0
				DBSELECTAREA("SA1")
				SA1->(DBSETORDER(3))
				IF SA1->(DBSEEK(XFILIAL("SA1")+PADR(GRVCLI->A1_CGC,cPdCpf))) .AND. U_BUSCAEND(ALLTRIM(M->A1_CGC),ALLTRIM(M->A1_END)) == 1
				
					//Edmar Mendes do Prado - 01/11/2018
					//Verifica se o cadastro do cliente está bloqueado para não utilizar
					If SA1->A1_MSBLQL == '1'		//1= Inativo
						//Enviar email
						Conout("001 - Cliente com cadastro bloqueado no Protheus: "+cVTex)
						U_EXPMAIL(cErItNgC , "001 - Cliente com cadastro bloqueado no Protheus: " + SA1->A1_COD, " Altere o cadastro " + SA1->A1_COD + " para ser faturado. ")
						
						//Loop
						GRVCLI->(DBSKIP())
					Else						
						NOPC	:= 4
						cCodigo	:= SA1->A1_COD
						cLoja	:= SA1->A1_LOJA
						M->A1_COD := SA1->A1_COD
						M->A1_LOJA	:= cLoja
					EndIf
						
				ELSEIF SA1->(DBSEEK(XFILIAL("SA1")+PADR(GRVCLI->A1_CGC,cPdCpf))) .AND. U_BUSCAEND(ALLTRIM(M->A1_CGC),ALLTRIM(M->A1_END)) == 2
				
					//Edmar Mendes do Prado - 01/11/2018
					//Verifica se o cadastro do cliente está bloqueado para não utilizar
					If SA1->A1_MSBLQL == '1'		//1= Inativo
						//Enviar email
						Conout("002 - Cliente com cadastro bloqueado no Protheus: "+cVTex)
						U_EXPMAIL(cErItNgC , "002 - Cliente com cadastro bloqueado no Protheus: " + SA1->A1_COD, " Altere o cadastro " + SA1->A1_COD + " para ser faturado. ")

						//Loop
						GRVCLI->(DBSKIP())
					Else	
						//Nopc = 3 para novos registros de loja				
						//NOPC	:= 3
						NOPC	:= 4
						
						/*
						//28/12/2018
						//Edmar Mendes do Prado - tratativa para atualizar o endereço do cliente ja cadastrado
						cCodigo	:= SA1->A1_COD
						cLoja	:= SOMA1(SA1->A1_LOJA) // SOMA A LOJA ATUAL
						M->A1_COD := SA1->A1_COD
						M->A1_LOJA	:= cLoja
						*/
						cCodigo := SA1->A1_COD
						cLoja	:= SA1->A1_LOJA
						M->A1_COD 	:= cCodigo
						M->A1_LOJA	:= cLoja
						//
						
						Conout("00201 - Endereco cliente: "+SA1->A1_END)
						Conout("00202 - Endereco Vtex: "+GRVCLI->A1_END)
						
						RecLock("SA1",.F.)
							SA1->A1_TEL 		:= GRVCLI->A1_TEL
							SA1->A1_CEPE		:= GRVCLI->A1_CEPE
							SA1->A1_ESTE 		:= GRVCLI->A1_ESTE
							SA1->A1_END 		:= GRVCLI->A1_END 
							SA1->A1_ESTADO		:= GRVCLI->A1_ESTADO
							SA1->A1_EST 		:= GRVCLI->A1_EST
							//SA1->A1_COD_MUN	:= 
							SA1->A1_MUN 		:= GRVCLI->A1_MUN
							SA1->A1_BAIRRO 		:= GRVCLI->A1_BAIRRO 
							SA1->A1_CEP 		:= GRVCLI->A1_CEP
							SA1->A1_DDD 		:= GRVCLI->A1_DDD
							SA1->A1_ENDENT 		:= GRVCLI->A1_ENDENT
							SA1->A1_ENDCOB 		:= GRVCLI->A1_ENDCOB
							SA1->A1_CEPC 		:= GRVCLI->A1_CEPC
							SA1->A1_ESTC 		:= GRVCLI->A1_ESTC
							SA1->A1_MUNC 		:= GRVCLI->A1_MUNC
							SA1->A1_COMPLEM		:= GRVCLI->A1_COMPLEM
							
							//If GRVCLI->A1_CODMUN = '99999'
							If SA1->A1_CODMUN = '99999'
								SA1->A1_EST 		:= "EX"
								SA1->A1_COD_MUN		:= "99999"
								SA1->A1_MUN 		:= "EXTERIOR"
								SA1->A1_ESTADO		:= "EX"
								SA1->A1_TIPO 		:= "X"
								SA1->A1_MUNC 		:= "EXTERIOR"
								SA1->A1_ESTE		:= "EX"
								//SA1->A1_PAIS 		:= ""
							EndIf
							
						MSUnlock()
						//
						
					EndIf
				ELSE
					NOPC	:= 3
					cCodigo := U_MNANACLI(GETSXENUM("SA1","A1_COD"))//GETSXENUM("SA1","A1_COD")
					cLoja	:= IIF(EMPTY(CRIAVAR("A1_LOJA")),'01',CRIAVAR("A1_LOJA"))
					M->A1_COD := cCodigo
					M->A1_LOJA	:= cLoja

					//Edmar Mendes do Prado
					//Cliente Extrangeiro
					If Len(GRVCLI->A1_EST) > 2
						M->A1_EST 		:= "EX"
						M->A1_COD_MUN	:= "99999"
						M->A1_MUN 		:= "EXTERIOR"
						M->A1_ESTADO	:= "EX"
						M->A1_TIPO 		:= "X"
						M->A1_MUNC 		:= "EXTERIOR"
						M->A1_ESTE		:= "EX"
						//SA1->A1_PAIS 		:= ""

						Conout("** Cliente EXTRANGEIRO cadastrado " + DtoC(Date()) + " - " + Time() + " **")
//						U_EXPMAIL("wallace.pereira@ethosx.com;ecommerce@manole.com.br;lazaro@manole.com.br;financeiro.cr@manole.com.br;cobrancas@manole.com.br;" , "CLIENTE EXTRANGEIRO, VERIFIQUE CADASTRO: " + M->A1_COD + "-" + M->A1_LOJA, " VERIFIQUE O CADASTRO DE CLIENTE " + M->A1_COD + " - " + M->A1_LOJA + " EXTRANGEIRO, PAIS, TIPO PESSOA, CEP, MUNICIPIO, ETC... ")
						U_EXPMAIL("ecommerce@manole.com.br;lazaro@manole.com.br;financeiro.cr@manole.com.br;cobrancas@manole.com.br;" , "CLIENTE EXTRANGEIRO, VERIFIQUE CADASTRO: " + M->A1_COD + "-" + M->A1_LOJA, " VERIFIQUE O CADASTRO DE CLIENTE " + M->A1_COD + " - " + M->A1_LOJA + " EXTRANGEIRO, PAIS, TIPO PESSOA, CEP, MUNICIPIO, ETC... ")

					EndIf
					
				ENDIF
			ELSE
				NOPC	:= 3
				cCodigo := GETSXENUM("SA1","A1_COD")
				cLoja	:= IIF(EMPTY(CRIAVAR("A1_LOJA")),'01',CRIAVAR("A1_LOJA"))
			endif
			IF (nLoc := ascan(aCpos,{|z| alltrim(z[2])=='A1_COD'}) ) > 0
				aGrvSa1[nLoc][2] := cCodigo
			else
				aadd(aGrvSa1,{"A1_COD"			,cCodigo	,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif
			IF (nLoc := ascan(aCpos,{|z| alltrim(z[2])=='A1_LOJA'}) ) > 0
				aGrvSa1[nLoc][2] := cLoja
			else
				aadd(aGrvSa1,{"A1_LOJA"			,cLoja		,nil})
				&("M->"+aGrvSa1[LEN(aGrvSa1)][1]) := aGrvSa1[LEN(aGrvSa1)][2]
			endif

			Reclock("SA1",IIF(nOpc==4,.f.,.t.))
			For nFor := 1 to len(aGrvSa1)
				&("SA1->"+aGrvSa1[nFor][1]) := aGrvSa1[nFor][2]
			next nFor
			MsUnlock()
			lMsErroauto := .f.
			/*
			SX3->(DBSETORDER(2))
			SX3->(DBSEEK("A1_EST"))
			xValid := SX3->X3_VALID
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ""
			MSUNLOCK()
			SX3->(DBSEEK("A1_CONTA"))
			YValid := SX3->X3_VALID
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ""
			MSUNLOCK()
			SX3->(DBSEEK("A1_CODMUN"))
			ZValid := SX3->X3_VALID
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ""
			MSUNLOCK()
			BeginTran()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³efetua a gravação na matriz para rodar o execauto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MSEXECAUTO( {|X,Y| MATA030(X,Y) },aGrvSa1,NOPC)

			SX3->(DBSETORDER(2))
			SX3->(DBSEEK("A1_EST"))
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := xValid
			MSUNLOCK()
			SX3->(DBSEEK("A1_CONTA"))
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := YValid
			MSUNLOCK()
			SX3->(DBSEEK("A1_CODMUN"))
			RECLOCK("SX3",.F.)
			SX3->X3_VALID := ZValid
			MSUNLOCK()
			*/
			IF lMsErroauto
				RollbackSx8()
				DisarmTransaction()
				cLogFile := cArqPd+alltrim(GRVCLI->A1_CGC)+".LOG"					//função que retorna as informações de erro ocorridos durante o processo da rotina automática
				ferase(cLogFile)
				ferase(cLogFile)
				aLog := GetAutoGRLog()	                            //efetua o tratamento para validar se o arquivo de log já existe
				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						For nFor2 := 1 to len(aLog)
							FWrite( nHandle,aLog[nFor2]+CRLF)
						next nFor2
						FCLOSE(nHandle)
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						For nFor2 := 1 to len(aLog)
							FWrite( nHandle,aLog[nFor2]+CRLF)
						next nFor2
						FCLOSE(nHandle)
					EndIf
				EndIf
			else
				CONFIRMSX8()
				EndTran()
				Reclock("GRVCLI",.F.)
				GRVCLI->UXU_PROQUE	:= 1
				MsUnlock()
				cLogFile := cArqPd+alltrim(GRVCLI->A1_CGC)+".LOG"
				ferase(cLogFile)
				ferase(cLogFile)
			endif
		endif
		
		//Envia email sobre o cliente cadastrado, se for extrangeiro, para analise do cadastro e correcao do pedido de vendas
		//Edmar Mendes do Prado
		//04/01/2019
		If SA1->A1_CODMUN = "99999"
			Conout("** Cliente EXTRANGEIRO cadastrado " + DtoC(Date()) + " - " + Time() + " **")
			U_EXPMAIL("wallace.pereira@ethosx.com;ecommerce@manole.com.br;lazaro@manole.com.br;financeiro.cr@manole.com.br;" , "CLIENTE EXTRANGEIRO, VERIFIQUE CADASTRO: " + SA1->A1_COD + "-" + SA1->A1_LOJA, " VERIFIQUE O CADASTRO DE CLIENTE " + SA1->A1_COD + " - " + SA1->A1_LOJA + " EXTRANGEIRO, PAIS, TIPO PESSOA, CEP, MUNICIPIO, ETC... ")
		Else
			Conout("** Cliente NACIONAL cadastrado " + DtoC(Date()) + " - " + Time() + " **")
			//U_EXPMAIL("wallace.pereira@ethosx.com" , "CLIENTE NACIONAL, VERIFIQUE CADASTRO: " + SA1->A1_COD + "-" + SA1->A1_LOJA, " VERIFIQUE O CADASTRO DE CLIENTE " + SA1->A1_COD + " - " + SA1->A1_LOJA + " NACIONAL... ")
		EndIf
		
		GRVCLI->(DBSKIP())
	end
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabeçalho do pedido de venda esse deve ser em conjunto com o detalhe do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nScan1:= aScan(aNomeTab,{|x| x[1] == '2' })
nScan2:= aScan(aNomeTab,{|x| x[1] == '3' })
if nScan1 > 0 .and. nScan2 > 0
	if !(SELECT("GRVCPED")>0)
		iif(SELECT("GRVCPED")>0,GRVCPED->(DbCloseArea()),nil)
		dbUseArea(.T.,,aNomeTab[nScan1][2],"GRVCPED", .T., .F. )
	endif
	if !(SELECT("TRBPEDC")>0)
		iif(SELECT("TRBPEDC")>0,TRBPEDC->(DbCloseArea()),nil)
	endif
	if !(SELECT("GRVDPED")>0)
		iif(SELECT("GRVDPED")>0,GRVDPED->(DbCloseArea()),nil)
		dbUseArea(.T.,,aNomeTab[nScan2][2],"GRVDPED", .T., .F. )
//		cIndCond := "C6_VTEX+C6_PRODUTO+C6_ITEM"
		cIndCond := "C6_VTEX+C6_FILIAL+C6_PRODUTO+C6_ITEM" // INLCUIDA A FILIAL NO INDICE
		cArqNtx1 := SUBSTR(aNomeTab[nScan2][2],1,7)+'1'
		IndRegua("GRVDPED",cArqNtx1,cIndCond,,,"Selecionando Registros...")
		dbselectarea("GRVDPED")
		dbSetIndex(cArqNtx1 + OrdBagExt())
	endif
	if !(SELECT("TRBPEDD")>0)
		iif(SELECT("TRBPEDD")>0,TRBPEDD->(DbCloseArea()),nil)
	endif
	Private aCposSc5	:= Extrut(aNomeTab[nScan1][2])
	Private aCposSc6	:= Extrut(aNomeTab[nScan2][2])


	GRVCPED->(dbgotop())
	while GRVCPED->(!eof())
		lMsErroauto		:= .f.
		lMsHelpAuto		:= .f.
		lautoErrNoFile	:= .T.
		aGrvSC5 	:= {}
		cCliente	:= ""
		aLog		:= {}

		
		_Numped := GRVCPED->C5_VTEX
		
		if GRVCPED->UXU_PROQUE == 0
			For nFor1 := 1 to LEN(aCposSc5)
				if substr(aCposSc5[nFor1][2],1,3) == 'C5_' .and. alltrim(aCposSc5[nFor1][2]) != 'C5_CONDPAG'
					aadd(aGrvSC5,{aCposSc5[nFor1][2],&("GRVCPED->"+aCposSc5[nFor1][2]),nil})
					&("M->"+aCposSc5[nFor1][2]) := &("GRVCPED->"+aCposSc5[nFor1][2])
				ELSEIF alltrim(aCposSc5[nFor1][2]) == 'C5_CONDPAG'
					xCond := alltrim(&("GRVCPED->"+aCposSc5[nFor1][2]))
					SE4->(DBSETORDER(3))
					IF !SE4->(DBSEEK(XFILIAL("SE4")+xCond))
						SE4->(DBSEEK(XFILIAL("SE4")+"01"))
					ENDIF
					aadd(aGrvSC5,{aCposSc5[nFor1][2],SE4->E4_CODIGO ,nil})
					&("M->"+aCposSc5[nFor1][2]) := SE4->E4_CODIGO
				ELSE
					SA1->(DBSETORDER(3))
					IF SA1->(DBSEEK(XFILIAL("SA1")+PADR(&("GRVCPED->"+aCposSc5[nFor1][2]),cPdCpf))) .AND. U_BUSCAEND(ALLTRIM(&("GRVCPED->"+aCposSc5[nFor1][2])),ALLTRIM(&("GRVCPED->"+aCposSc5[nFor1][2]))) == 1
						//Edmar Mendes do Prado
						//Nao utilizar cadastro de cliente que estiver bloqueado
						If SA1->A1_MSBLQL == '1'
							//Enviar email
							Conout("003 - Cliente com cadastro bloqueado no Protheus: "+cVTex)
							U_EXPMAIL(cErItNgC , "001 - Cliente com cadastro bloqueado no Protheus: " + SA1->A1_COD, " Altere o cadastro " + SA1->A1_COD + " para ser faturado. ")
						
							Loop
							//GRVCLI->(DBSKIP())
						Else
							cCliente	:= SA1->A1_COD
							cLoja		:= SA1->A1_LOJA
						EndIf
					ELSE
						cCliente		:= posicione("SA1",3,xfilial("SA1")+&("GRVCPED->"+aCposSc5[nFor1][2]),"A1_COD")
						cLoja			:= SA1->A1_LOJA
					ENDIF
					aadd(aGrvSC5,{'C5_CLIENTE',cCliente,nil})
					M->C5_CLIENTE	:= cCliente
					aadd(aGrvSC5,{'C5_LOJACLI',cLoja,nil})
					M->C5_LOJA		:= cLoja
					aadd(aGrvSC5,{'C5_CLIENT',cCliente,nil})
					M->C5_CLIENT	:= cCliente
					aadd(aGrvSC5,{'C5_LOJAENT',cLoja,nil})
					M->C5_LOJAENT	:= cLoja
				ENDIF
			Next nFor1
//			aadd(aGrvSC5,{"C5_FILIAL",XFILIAL("SC5"),nil})
//			&("M->C5_FILIAL") := XFILIAL("SC5")
			//aadd(aGrvSC5,{"C5_TRANSP",iif(empty(SA1->A1_TRANSP),'08',SA1->A1_TRANSP),nil})
			&("M->C5_TRANSP") := iif(empty(SA1->A1_TRANSP),'08',SA1->A1_TRANSP)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Analisando se possui o endereço correto no sistema   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosEndTrg		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_ENDTREG" })
			nPosCodCli		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_CLIENTE" })
			nPosCodEnt		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_CLIENT" })
			nPosCodLoj		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_LOJACLI" })
			nPosLojCli		:= aScan(aGrvSC5,{|x| alltrim(x[1]) == "C5_LOJAENT" })
			if nPosEndTrg > 0 .and. nPosCodCli > 0
				if !EMPTY(aGrvSC5[nPosEndTrg][2])
					IF U_BUSCAEND(ALLTRIM(SA1->A1_CGC),ALLTRIM(aGrvSC5[nPosEndTrg][2]),ALLTRIM(aGrvSC5[nPosCodCli][2])) == 1
						cCliente		:= SA1->A1_COD
						cLoja			:= SA1->A1_LOJA
						aGrvSC5[nPosCodCli][2] := cCliente
						aGrvSC5[nPosCodEnt][2] := cCliente
						aGrvSC5[nPosCodLoj][2] := cLoja
						aGrvSC5[nPosLojCli][2] := cLoja
						M->C5_CLIENTE	:= cCliente
						M->C5_LOJA		:= cLoja
						M->C5_CLIENT	:= cCliente
						M->C5_LOJAENT	:= cLoja
					ENDIF
				ENDIF
			endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³analisa se existe o pedido  caso não exista crie caso contrario atualize³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if ascan(aGrvSC5,{|z| alltrim(z[1])=='C5_VTEX'})>0
				DBSELECTAREA("SC5")
				SC5->(DBORDERNICKNAME("VTEX"))
				IF SC5->(DBSEEK(XFILIAL("SC5")+PADR(GRVCPED->C5_VTEX,cPdVTex)+cCliente)) .and. !lMsmped //mesmo pedido VTEX porem para filial diferente
					NOPC	:= 4
					cPedido	:= SC5->C5_NUM
				ELSE
					NOPC	:= 3
//					xParSC5	:= PADR(GETMV("MV_MNLSC5"),TAMSX3("C5_NUM")[1])
					if lMsmped
					  xParSC5 := ALLTRIM(POSICIONE("SX6",1,"  "+"MV_MNLSC5","X6_CONTEUD"))
					else
					  xParSC5 := ALLTRIM(POSICIONE("SX6",1,"  "+"MV_MNLSC5","X6_CONTEUD"))
					endif
										
					xParSC5	:= GetSC5Num(xParSC5,lMsmped) // analisa se ja existe esse pedido na tabela SC5
					cPedido := xParSC5
				ENDIF
			ELSE
				NOPC	:= 3
				xParSC5	:= PADR(getMV("MV_MNLSC5"),TAMSX3("C5_NUM")[1])
				xParSC5	:= GetSC5Num(xParSC5) // analisa se ja existe esse pedido na tabela SC5
				cPedido := xParSC5
			endif
			IF (nLoc := ascan(aGrvSC5,{|z| alltrim(z[1])=='C5_NUM'}) ) > 0
				aGrvSC5[nLoc][2] := cPedido
			else
				aadd(aGrvSC5,{"C5_NUM"	,cPedido	,nil})
				&("M->"+aGrvSC5[LEN(aGrvSC5)][1]) := aGrvSC5[LEN(aGrvSC5)][2]
			endif
			aItensSC6	:= {}
			nTem		:= 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
			//³Processo para a gravação dos pedidos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
			GRVDPED->(dbgotop())
			GRVDPED->(DBSETORDER(1))
			IF (nLoc := ascan(aGrvSC5,{|z| alltrim(z[1])=='C5_VTEX'}) ) > 0
				cVTex	:= aGrvSC5[nLoc][2]
			else
				cVTex	:= ""
			endif
			////
			/*if _cfilant == "  "
			   GRVDPED->(dbgotop())
			   GRVDPED->(DBSEEK(cVTex))
			else
			   GRVDPED->(DBSEEK(cVTex + GRVDPED->C6_FILIAL))
			endif*/
			
			if  GRVDPED->(DBSEEK(cVTex + "01"))
			  _cfilant := "01"
			elseif GRVDPED->(DBSEEK(cVTex + "02"))
			  _cfilant := "02"
			endif
			
			

			//GUARDO A FILIAL
//			_cfilant := GRVDPED->C6_FILIAL
//			while cVTex == GRVDPED->C6_VTEX .and. GRVDPED->(!eof()) 

			while cVTex == GRVDPED->C6_VTEX .and. GRVDPED->(!eof()) .AND. GRVDPED->C6_FILIAL == _cFilant //.and. _cFilial <> " " 

				aGrvSC6 	:= {}
				
				_cFilial := GRVDPED->C6_FILIAL
				_pedant  := GRVDPED->C6_VTEX
				
			if GRVDPED->UXU_PROQUE == 0
				//Edmar - 04/12/2017
				If Empty(GRVDPED->C6_DESCRI) .Or. Empty(GRVDPED->C6_UM)
					Reclock("GRVDPED",.F.)
					GRVDPED->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+GRVDPED->C6_PRODUTO,"B1_DESC")
					GRVDPED->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+GRVDPED->C6_PRODUTO,"B1_UM")
					MsUnlock()
				EndIf
			
//			if GRVDPED->UXU_PROQUE == 0
					For nFor1 := 1 to LEN(aCposSc6)
						aadd(aGrvSC6,{aCposSc6[nFor1][2],&("GRVDPED->"+aCposSc6[nFor1][2]),nil})
						&("M->"+aCposSc6[nFor1][2]) := &("GRVDPED->"+aCposSc6[nFor1][2])
					Next nFor1
					//aadd(aGrvSC6,{"C6_FILIAL",XFILIAL("SC6"),nil})
					//&("M->C6_FILIAL") := XFILIAL("SC6")
					aadd(aGrvSC6,{"C6_FILIAL",M->C6_FILIAL,nil})
					&("M->C6_FILIAL") := M->C6_FILIAL
					aadd(aGrvSC6,{"C6_NUM",cPedido,nil})
					&("M->C6_NUM") := cPedido
					aadd(aGrvSC6,{"C6_CLI",M->C5_CLIENTE,nil})
					&("M->C6_CLI") := M->C5_CLIENTE
					aadd(aGrvSC6,{"C6_LOJA",M->C5_LOJA,nil})
					&("M->C6_LOJA") := M->C5_LOJA

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Regra para saber se o Produto possui no sistema para permitir a inclusão e a alteração do status do pedido na Vtex³
					//³a opcão .F. quer dizer que não existe o produto no sistema e não deve gravar e nem alterar o status do pedido     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nProd 		:= ascan(aGrvSC6,{|x| alltrim(x[1]) == "C6_PRODUTO"})
					nPrdVtex	:= ascan(aGrvSC6,{|x| alltrim(x[1]) == "C6_PRDVTEX"})
					nTem		:= ascan(aGrvSC6,{|x| alltrim(x[1]) == "C6_CODISS"})
					if  nTem > 0 .and. !empty(aGrvSC6[nTem][2])
						aadd(aGrvSC5,{'C5_INCISS',"S",nil})
					endif
					if nProd > 0 .AND. (EMPTY(aGrvSC6[nProd][2]) .or. posicione("SB1",1,xFilial("SB1")+ALLTRIM(aGrvSC6[nProd][2]),"ALLTRIM(B1_COD)")!=ALLTRIM(aGrvSC6[nProd][2]))
						lPedOk	:= .F.
						cLogFile := cArqPd+alltrim(GRVCPED->C5_VTEX)+".LOG"					//função que retorna as informações de erro ocorridos durante o processo da rotina automática
						ferase(cLogFile)
						ferase(cLogFile)
						If !File(cLogFile)
							If (nHandle := MSFCreate(cLogFile,0)) <> -1
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido não possui amarração no Protheus, por favor verificar o codigo do produto Vtex no protheus: "+iif(nPrdVtex>0,ALLTRIM(aGrvSC6[nPrdVtex][2]),'')+CRLF)
								FCLOSE(nHandle)
							EndIf
						Else
							If (nHandle := FOpen(cLogFile,2)) <> -1
								FSeek(nHandle,0,2)
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" Os produtos contido nesse pedido não possui amarração no Protheus, por favor verificar o codigo do produto Vtex no protheus: "+iif(nPrdVtex>0,ALLTRIM(aGrvSC6[nPrdVtex][2]),'')+CRLF)
								FCLOSE(nHandle)
							EndIf
						EndIf
					elseif nProd == 0
						lPedOk	:= .F.
						cLogFile := cArqPd+alltrim(GRVCPED->C5_VTEX)+".LOG"					//função que retorna as informações de erro ocorridos durante o processo da rotina automática
						ferase(cLogFile)
						ferase(cLogFile)
						If !File(cLogFile)
							If (nHandle := MSFCreate(cLogFile,0)) <> -1
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" O campo codigo do produto não esta no de-para do protheus, por favor cadastrar no DE-PARA: "+CRLF)
								FCLOSE(nHandle)
							EndIf
						Else
							If (nHandle := FOpen(cLogFile,2)) <> -1
								FSeek(nHandle,0,2)
								FWrite( nHandle,"Para o Pedido da Vtex: "+cVTex+" O campo codigo do produto não esta no de-para do protheus, por favor cadastrar no DE-PARA: "+CRLF)
								FCLOSE(nHandle)
							EndIf
						EndIf
					endif
					
					AADD(aItensSC6,ACLONE(aGrvSC6))
			ENDIF
		
				_cfilant := GRVDPED->C6_FILIAL
				_pedant  := GRVDPED->C6_VTEX
		
				GRVDPED->(DBSKIP())
			/*
					if _cfilant <> GRVDPED->C6_FILIAL .AND. _pedant == GRVDPED->C6_VTEX
						 lDisEmail := .T.
  						 lDisEmail  := STARTJOB('U_grvPedJB',GetEnvServer(),.T.,{ SM0->M0_CODIGO, "01", aTables, aGrvSC5,aItensSC6,NOPC,cVTex,GRVCPED->(RECNO()),GRVDPED->(RECNO()),aNomeTab[nScan1][2],aNomeTab[nScan2][2],lPedOk,_cFilant})
						 _pedgrv := .T.  
					endif
			*/
			END



					//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³efetua a gravação na matriz para rodar o execauto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//MSExecAuto({|x,y,z| Mata410(x,y,z)},aGrvSC5,aItensSC6,NOPC)

			if lPedOk .AND. !lJob
				u_grvPed(aGrvSC5,aItensSC6,NOPC,cVTex,"GRVCPED","GRVDPED")
			elseif lPedOk .AND. lJob
				lDisEmail := .T.
//				lDisEmail  := STARTJOB('U_grvPedJB',GetEnvServer(),.T.,{ SM0->M0_CODIGO, SM0->M0_CODFIL, aTables, aGrvSC5,aItensSC6,NOPC,cVTex,GRVCPED->(RECNO()),GRVDPED->(RECNO()),aNomeTab[nScan1][2],aNomeTab[nScan2][2],lPedOk,_cFilant})

			
//			MSGSTOP("CHAMADA DO GRVPEDJB")
			
			if _cFilant == "01"
					lDisEmail  := STARTJOB('U_grvPedJB',GetEnvServer(),.T.,{ SM0->M0_CODIGO, "01", aTables, aGrvSC5,aItensSC6,NOPC,cVTex,GRVCPED->(RECNO()),GRVDPED->(RECNO()),aNomeTab[nScan1][2],aNomeTab[nScan2][2],lPedOk,_cFilant})
			else
				    lDisEmail  := STARTJOB('U_grvPedJB',GetEnvServer(),.T.,{ SM0->M0_CODIGO, "02", aTables, aGrvSC5,aItensSC6,NOPC,cVTex,GRVCPED->(RECNO()),GRVDPED->(RECNO()),aNomeTab[nScan1][2],aNomeTab[nScan2][2],lPedOk,_cFilant})
			endif				


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Apos o Retorno do Job a rotina retornara FALSE  se der tudo certo³
				//³caso gerou erro o mesmo retornara diferente de FALSO ai deve     ³
				//³manda o e-mail para o Alexandre e compania By Leandro Duarte     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				if VALTYPE(lDisEmail) == 'U'
					cTo 		:= "logistica@manole.com.br"
					cArq		:= ""
					cAssunto	:= "Erro na Importação da Vtex"
					_cTexto		:= "Senhores"+CRLF+"Foi diagnosticado uma inconformidade na importação do pedido: <B>"+cVTex+"</B>"+CRLF+"Por Favor Averiguar!"+CRLF+CRLF+"TECNOLOGIA MANOLE"
					MAIL_ADDRESS:= "logistica@manole.com.br"
					//U_ENVMAIL(cTo,cArq,cAssunto,_cTexto,"LOCAWEB",,.F.,'ecommerc@manole.com.br;wallace.pereira@ethosx.com;rogerio@manole.com.br;isaias@manole.com.br;lucas.silva@manole.com.br')
					//U_ENVMAIL(cTo,cArq,cAssunto,_cTexto,"NFE",,.F.,'ecommerce@manole.com.br;wallace.pereira@ethosx.com;rogerio@manole.com.br;isaias@manole.com.br;lucas.silva@manole.com.br')
					cErrMail	:= "ecommerce@manole.com.br; lazaro@manole.com.br;wallace.pereira@ethosx.com"
					U_EXPMAIL(cErrMail, "Erro na importação da Vtex: "+cVtex, _cTexto)
					
				endif
			endif

			if  !lJob
				IF lMsErroauto
					cLogFile := cArqPd+alltrim(GRVCPED->C5_VTEX)+".LOG"					//função que retorna as informações de erro ocorridos durante o processo da rotina automática
					ferase(cLogFile)
					ferase(cLogFile)
					aLog := GetAutoGRLog()	                            //efetua o tratamento para validar se o arquivo de log já existe
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							For nFor2 := 1 to len(aLog)
								FWrite( nHandle,aLog[nFor2]+CRLF)
							next nFor2
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							For nFor2 := 1 to len(aLog)
								FWrite( nHandle,aLog[nFor2]+CRLF)
							next nFor2
							FCLOSE(nHandle)
						EndIf
					EndIf
				else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Gera o titulo Antecipado para o Financeiro efetuar a conciliação³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//U_MNGerRA(cArqPd+cNomArq+".LOG")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Fim da Geração do Titulo RA³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CONFIRMSX8()
					Reclock("GRVCPED",.F.)
					GRVCPED->UXU_PROQUE	:= 1
					MsUnlock()
					GRVDPED->(dbgotop())
					GRVDPED->(DBSEEK(cVTex))
//					while cVTex == GRVDPED->C6_VTEX .and. GRVDPED->(!eof())
					while cVTex == GRVDPED->C6_VTEX .and. GRVDPED->(!eof()) .and. GRVDPED->C6_FILIAL == _cfilant
						Reclock("GRVDPED",.F.)
						GRVDPED->UXU_PROQUE	:= 1
						MsUnlock()
						GRVDPED->(DBSKIP())
					END
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Apos processamento com sucesso altera o status do pedido no vtex para não pegar ele novamente³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if lPedOk
						u_AltPed(alltrim(GRVCPED->C5_VTEX))
					endif
					if file(cArqPd+alltrim(GRVDPED->C6_VTEX)+".LOG")
						ferase(cArqPd+alltrim(GRVDPED->C6_VTEX)+".LOG")
					endif
				endif
			endif
			lPedOk := .T.
		endif
		
		

		GRVCPED->(DBSKIP())
	
		if  GRVDPED->C6_VTEX == _pedant .AND. GRVDPED->C6_FILIAL <> _cfilant
			GRVCPED->(DBSKIP(-1))
			lMsmped := .T.
			Reclock("GRVCPED",.F.)
		    	GRVCPED->UXU_PROQUE	:= 0
			MsUnlock()
		elseif  GRVDPED->C6_VTEX <> _pedant .AND. GRVDPED->C6_FILIAL == _cfilant
			lMsmped := .F.
/*			Reclock("GRVCPED",.F.)
		    	GRVCPED->UXU_PROQUE	:= 1
			MsUnlock()*/
		endif

		
	end
	GRVDPED->(dbCloseArea())
	FErase(cArqNtx1+OrdBagExt())
endif
RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACHAMUN   ºAutor  ³LEANDRO DUARTE      º Data ³  08/31/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA BUSCAR OS DADOS DOS MUNICIPIOS                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION ACHAMUN(ESTADO,CIDADE,UF)
LOCAL CRET := ""
LOCAL cQuery := ""
IF UF != 'EX'
	cQuery := " SELECT CC2_CODMUN FROM "+RETSQLNAME("CC2")+" WHERE CC2_EST = '"+ESTADO+"' AND substr(CC2_MUN,1,15) = '"+REPLACE(PADR(ALLTRIM(u_TIRACENTO(CIDADE)),15),"'"," ")+"' AND D_E_L_E_T_ = ' ' "
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	TRBU->(DBGOTOP())
	IF TRBU->(!EOF())
		CRET := TRBU->CC2_CODMUN
	ELSE
		cQuery := " SELECT CC2_CODMUN FROM "+RETSQLNAME("CC2")+" WHERE CC2_EST = '"+ESTADO+"' AND D_E_L_E_T_ = ' ' "
		IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
		TRBU->(DBGOTOP())
		IF TRBU->(!EOF())
			CRET := TRBU->CC2_CODMUN
		ELSE
			CRET := "50308"
		ENDIF
	ENDIF
ELSE
	CRET := '99999'
ENDIF

RETURN(CRET)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNALIMDP  ºAutor  ³Microsiga           º Data ³  08/25/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Extrut(cNomEstr)
Local aStr	:= {}
UA1->(dbsetorder(1))
if UA1->(DBSEEK(XFILIAL("UA1")+cNomEstr))
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aadd(aStr,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL,nil})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aStr[LEN(aStr)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		aStr[LEN(aStr)][3] := tamsx3(aStr[LEN(aStr)][2])[3]
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
	END
endif
Return(aStr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltPed    ºAutor  ³Leandro Duarte      º Data ³  09/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera o pedido de Venda como ja processado                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FUNCTION AltPed(cIdPedido)

Local cUrlProc 	:= "https://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/start-handling/?an=manole"
//Local cUrlProc 	:= "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/"+cIdPedido+"/start-handling/?an=manole"
//Local cUrlAguar	:= "http://oms.vtexcommerce.com.br/api/oms/pvt/orders/?an=manole&f_status=ready-for-handling"
Local sPostRet := ""
private cParam   := ""
private UserCode := "vtexappkey-manole-UMVGHE"
private PassWord := "QWILBHUFTPJMLDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBCIZPPXMJILYOQFEPRSQPNIJSRPTXJANYPYBEEDEFSMIEEKYTVDLMLYOUYHXAEOZHYAYSD"
private aHeadOut := {}
private oXMLped

//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'X-VTEX-API-Appkey: '+UserCode)
aadd(aHeadOut,'X-VTEX-API-AppToken: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

// COMUNICA COM O WEBSERVICE
// SERVE PARA INFORMAR QUE ESTOU TRABALHANDO COM ESSE PEDIDO  PARA NÀO PEGA-LO NOVAMENTE
sPostRet := HttpPOST(cUrlProc,"","",,aHeadOut)
// SERVE SOMENTE PARA LISTAR OS READY-FOR-HANDLING
//sPostRet := HttpGET(cUrlAguar,cParam,12000,aHeadOut,@cHeadRet)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³grvPed    ºAutor  ³Leandro Duarte      º Data ³  10/28/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a gravação do pedido, pois o execauto esta dando ±±
±±º          ³varios problemas inexistentes                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function grvPed(aGrvSC5,aItensSC6,NOPC,cVTex,cAlias1,cAlias2)
lOCAL nCli		:= ascan(aGrvSC5,{|x| alltrim(x[1]) == "C5_CLIENTE" })
Local cCli		:= ""
Local nFor		:= 0
Local nFor1		:= 0
if nCli > 0
	cCli := aGrvSC5[nCli][2]
endif
Conout("Efetuando a Gravação do Pedido: "+cVTex)
lMsErroauto := .T.
BEGIN TRANSACTION
IF LEN(aItensSC6) > 0
	IF !empty(cCli)
		if NOPC == 3 // inclusão
		CONOUT("INCLUINDO O PEDIDO")
			RECLOCK("SC5",.T.)
			FOR nFor := 1 to len(aGrvSC5)
				&("SC5->"+aGrvSC5[nFor][1]) := aGrvSC5[nFor][2]
			next nFor
			MSUNLOCK()
			FOR nFor := 1 to len(aItensSC6)
				DBSELECTAREA("SC6")
				SC6->(DBORDERNICKNAME("VTEX"))
				nItem	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_ITEM"})
				nProd	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_PRODUTO"})
				LSEEK	:= !SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
				RECLOCK("SC6",LSEEK)
				For nFor1	:= 1 to len(aItensSC6[nFor])
					&("SC6->"+aItensSC6[nFor][nFor1][1]) := aItensSC6[nFor][nFor1][2]
				next nFor1
				SC6->C6_CF := IIF(POSICIONE("SA1",1,XFILIAL("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_EST") == "SP",POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),"6"+SUBSTR(POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),2))
				MSUNLOCK()
				(cAlias2)->(dbSeek(cVTex+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])))
				Reclock((cAlias2),.F.)
				(cAlias2)->UXU_PROQUE	:= 1
				(cAlias2)->(DBDELETE())
				MsUnlock()
				IF SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
					//GERA A SC9
					cQuery := " SELECT COUNT(*) AS QTD "
					cQuery += "   FROM "+retsqlname("SC9")+" A  "
					cQuery += "  WHERE A.C9_PEDIDO = '"+SC6->C6_NUM+"'  "
					cQuery += "    AND A.C9_PRODUTO = '"+SC6->C6_PRODUTO+"'  "
					cQuery += "    AND A.D_E_L_E_T_ = ' '  "
					cQuery += "    AND A.C9_FILIAL = '"+xFilial("SC9")+"' "
					IiF(SELECT("GETSC9")>0,GETSC9->(DBCLOSEAREA()),nil)
					cQuery := ChangeQuery(cQuery)
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC9", .T., .T.)
					IF GETSC9->QTD <= 0
						/*If RecLock("SC5")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Recalcula a Quantidade Liberada                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SC6") //Forca a atualizacao do Buffer no Top
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Libera por Item de Pedido                                               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Begin Transaction
							/*
							±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
							±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99  ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Descri+.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
							±±³          ³controlar a Transacao e os Locks                            ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Parametros³ExpN1: Registro do SC6                                      ³±±
							±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
							±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
							±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
							±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
							±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
							±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
							±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
							±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
							±±³          ³       apenas avalia ).                                     ³±±
							±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
							±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
							±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
							±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
							±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
							±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±

							MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.T.,.F.,.F.)
							SC9->(DBSETORDER(1))
							cKey := xFilial("SC9")+SC6->C6_NUM
							IF SC9->(DbSeek(cKey))
								while SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO == cKey
									reclock("SC9",.F.)
										SC9->C9_BLCRED := " "
									MsUnlock()
									SC9->(DBSKIP())
								end
							ENDIF
							End Transaction
						EndIf
						*/
						
						//Edmar Mendes do Prado - 02/03/2018 - Adicionar validação do TES
						//xReserv(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_ITEM,SC6->C6_VALOR,SC6->C6_LOCAL)
						//xReserv(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_ITEM,SC6->C6_VALOR,SC6->C6_LOCAL,SC6->C6_TES)
						
						
						// Retirado em 14/05/2018
						//Incluido por Edmar Mendes do Prado - 07/03/2018
						RecLock("SC6") //Forca a atualizacao do Buffer no Top
						If RecLock("SC5")
							Begin Transaction
								MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,.T.,.F.)
								SC9->(DBSETORDER(1))
								cKey := xFilial("SC9")+SC6->C6_NUM
								IF SC9->(DbSeek(cKey))
									while SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO == cKey
										reclock("SC9",.F.)
											SC9->C9_BLCRED := " "
										MsUnlock()

										//Edmar Mendes do Prado
										//28/06/2018
										//Se o item estiver com valor negativo, enviar email
										//If SC9->C9_PRCVEN < 0
										//	cErItNeg	:= "ecommerce@manole.com.br; lazaro@manole.com.br;wallace.pereira@ethosx.com"
										//	U_EXPMAIL(cErItNeg, "PEDIDOS VTEX COM VALORES NEGATIVOS, ALTERE: "+SC9->C9_PEDIDO, " ALTERE O PEDIDO "+SC9->C9_PEDIDO+" - "+SC9->C9_PRODUTO+" - "+SC9->C9_PRCVEN + " ser faturado com os valores corretos. ")
										//EndIF								
										
										SC9->(DBSKIP())
									end
								ENDIF
								
							End Transaction
						EndIf
						//até aqui retirado em 14/05/2018 */
						
					ENDIF
					lMsErroauto := .F.

					Reclock((cAlias1),.F.)
					(cAlias1)->UXU_PROQUE	:= 1
					(cAlias1)->(DBDELETE())
					MsUnlock()
				ELSE
					cLogFile := cArqPd+alltrim(cVTex)+".LOG"
					nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
							FCLOSE(nHandle)
						EndIf
					EndIf
					lMsErroauto := .T.
					rETURN()
				ENDIF
			next nFor
			MSUNLOCK()

		elseif NOPC == 4 //alteração
			CONOUT("ALTERANDO O PEDIDO")
			SC5->(DBSETORDER(10))
			SC5->(DBSEEK(XfILIAL("SC5")+cVTex))
			RECLOCK("SC5",.F.)
			FOR nFor := 1 to len(aGrvSC5)
				&("SC5->"+aGrvSC5[nFor][1]) := aGrvSC5[nFor][2]
			next nFor
			MSUNLOCK()
			//conout("linha 747 mnped01")
			FOR nFor := 1 to len(aItensSC6)
				DBSELECTAREA("SC6")
				SC6->(DBORDERNICKNAME("VTEX"))
				nItem	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_ITEM"})
				nProd	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_PRODUTO"})
				nNum	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_NUM"})
				LSEEK	:= !SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
				IF lSeek
					SC6->(DBSETORDER(1))
					LSEEK	:= !SC6->(DBSEEK(XFILIAL("SC6")+padr(aItensSC6[nFor][nNum][2],tamsx3("C6_NUM")[1])+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]) ))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					SC6->(DBORDERNICKNAME("VTEX"))
				endif
				RECLOCK("SC6",LSEEK)
				For nFor1	:= 1 to len(aItensSC6[nFor])
					&("SC6->"+aItensSC6[nFor][nFor1][1]) := aItensSC6[nFor][nFor1][2]
				next nFor1
				SC6->C6_CF := IIF(POSICIONE("SA1",1,XFILIAL("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_EST") == "SP",POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),"6"+SUBSTR(POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),2))
				MSUNLOCK()
				(cAlias2)->(dbSeek(cVTex+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])))
				Reclock((cAlias2),.F.)
				(cAlias2)->UXU_PROQUE	:= 1
				(cAlias2)->(DBDELETE())
				MsUnlock()
				//conout("linha 771 mnped01")
				IF SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
					//GERA A SC9
					cQuery := " SELECT COUNT(*) AS QTD "
					cQuery += "   FROM "+retsqlname("SC9")+" A  "
					cQuery += "  WHERE A.C9_PEDIDO = '"+SC6->C6_NUM+"'  "
					cQuery += "    AND A.C9_PRODUTO = '"+SC6->C6_PRODUTO+"'  "
					cQuery += "    AND A.D_E_L_E_T_ = ' '  "
					cQuery += "    AND A.C9_FILIAL = '"+xFilial("SC9")+"' "
					IiF(SELECT("GETSC9")>0,GETSC9->(DBCLOSEAREA()),nil)
					cQuery := ChangeQuery(cQuery)
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC9", .T., .T.)
					IF GETSC9->QTD <= 0
						If RecLock("SC5")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Recalcula a Quantidade Liberada                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SC6") //Forca a atualizacao do Buffer no Top
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Libera por Item de Pedido                                               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Begin Transaction
							//conout("linha 793 mnped01")
							/*
							±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
							±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99  ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Descri+.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
							±±³          ³controlar a Transacao e os Locks                            ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Parametros³ExpN1: Registro do SC6                                      ³±±
							±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
							±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
							±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
							±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
							±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
							±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
							±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
							±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
							±±³          ³       apenas avalia ).                                     ³±±
							±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
							±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
							±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
							±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
							±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
							±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
							*/
							//MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.T.,.F.,.F.)
							MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,.T.,.F.)
							SC9->(DBSETORDER(1))
							cKey := xFilial("SC9")+SC6->C6_NUM
							IF SC9->(DbSeek(cKey))
								while SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO == cKey
									reclock("SC9",.F.)
										SC9->C9_BLCRED := " "
									MsUnlock()
									
										//Edmar Mendes do Prado
										//28/06/2018
										//Se o item estiver com valor negativo, enviar email
										//If SC9->C9_PRCVEN < 0
										//	cErItNeg	:= "ecommerce@manole.com.br; lazaro@manole.com.br;wallace.pereira@ethosx.com"
										//	U_EXPMAIL(cErItNeg, "PEDIDOS VTEX COM VALORES NEGATIVOS, ALTERE: "+SC9->C9_PEDIDO, " ALTERE O PEDIDO "+SC9->C9_PEDIDO+" - "+SC9->C9_PRODUTO+" - "+SC9->C9_PRCVEN + " ser faturado com os valores corretos. ")
										//EndIF								
									
									SC9->(DBSKIP())
								end
							ENDIF
							End Transaction
						EndIf
						//MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,,,.T.,.T.,.T.,.F.)
					ENDIF
					lMsErroauto := .F.

					Reclock((cAlias1),.F.)
					(cAlias1)->UXU_PROQUE	:= 1
					(cAlias1)->(DBDELETE())
					MsUnlock()
					//conout("linha 834 mnped01")
				ELSE
					cLogFile := cArqPd+alltrim(cVTex)+".LOG"
					nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
							FCLOSE(nHandle)
						EndIf
					EndIf
					lMsErroauto := .T.
					rETURN(.T.)
				ENDIF
			next nFor
		endif
	ELSE
		lMsErroauto := .T.
		cLogFile := cArqPd+alltrim(cVTex)+".LOG"
		nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
		If !File(cLogFile)
			If (nHandle := MSFCreate(cLogFile,0)) <> -1
				FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O cliente não foi importado!! "+CRLF)
				FCLOSE(nHandle)
			EndIf
		Else
			If (nHandle := FOpen(cLogFile,2)) <> -1
				FSeek(nHandle,0,2)
				FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+"  O cliente não foi importado!!  "+CRLF)
				FCLOSE(nHandle)
			EndIf
		EndIf
	ENDIF
ELSE
	lMsErroauto := .T.
	cLogFile := cArqPd+alltrim(cVTex)+".LOG"
	nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
	If !File(cLogFile)
		If (nHandle := MSFCreate(cLogFile,0)) <> -1
			FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O pedido da Vtex não possui itens Completos, por favor complete os itens"+CRLF)
			FCLOSE(nHandle)
		EndIf
	Else
		If (nHandle := FOpen(cLogFile,2)) <> -1
			FSeek(nHandle,0,2)
			FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O pedido da Vtex não possui itens Completos, por favor complete os itens"+CRLF)
			FCLOSE(nHandle)
		EndIf
	EndIf
	Reclock((cAlias1),.F.)
	(cAlias1)->UXU_PROQUE	:= 1
	(cAlias1)->(DBDELETE())
	MsUnlock()
ENDIF
END TRANSACTION
if lMsErroauto
	conout("Falha na gravação do Pedido: "+cVTex)
else
	conout("Sucesso na gravação do Pedido: "+cVTex)
endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetSC5Num ºAutor  ³Leandro Duarte      º Data ³  12/16/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Lista se esse pedido ja existe na base de dados, caso existaº±±
±±º          ³somar mais um e aliemntar o parametro                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSC5Num(xParSC5,lMsmped)
Local cQuery := " "
Private xnumsc5 := xParSC5
Private lRoda	:= .T.


/*
while lRoda
	cQuery := " SELECT COUNT(*) AS QTD FROM "+RETSQLNAME("SC5")+ " A WHERE A.C5_NUM = '"+xnumsc5+"' AND A.D_E_L_E_T_ = ' ' AND A.C5_FILIAL = '"+xFilial("SC5")+"' "
	IiF(SELECT("GETSC5")>0,GETSC5->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC5", .T., .T.)
	IF GETSC5->QTD <= 0
		lRoda := .f.
		PUTMV("MV_MNLSC5", xnumsc5)
		RETURN(xnumsc5)
	ENDIF
	xnumsc5 := SOMA1(xnumsc5)
END
*/
if .T.//!lMsmped
  while lRoda
	cQuery := " SELECT COUNT(*) AS QTD FROM "+RETSQLNAME("SC5")+ " A WHERE A.C5_NUM = '"+xnumsc5+"' AND A.D_E_L_E_T_ = ' ' "// AND A.C5_FILIAL = '01' "
	IiF(SELECT("GETSC5")>0,GETSC5->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC5", .T., .T.)
	IF GETSC5->QTD <= 0
		lRoda := .f.
//		PUTMV("MV_MNLSC5", xnumsc5)
		SX6->(DBGOTOP())
		SX6->(DBSETORDER(1))
		SX6->(DBSEEK('  '+'MV_MNLSC5'))
		RECLOCK("SX6",.F.)
		  SX6->X6_CONTEUD := xnumsc5
		MSUNLOCK()
		RETURN(xnumsc5)
	ENDIF
	xnumsc5 := SOMA1(xnumsc5)
  END
else
  while lRoda
	cQuery := " SELECT COUNT(*) AS QTD FROM "+RETSQLNAME("SC5")+ " A WHERE A.C5_NUM = '"+xnumsc5+"' AND A.D_E_L_E_T_ = ' ' AND A.C5_FILIAL = '02' "
	IiF(SELECT("GETSC5")>0,GETSC5->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC5", .T., .T.)
	IF GETSC5->QTD <= 0
		lRoda := .f.
//		PUTMV("MV_MNLSC5", xnumsc5)
		SX6->(DBGOTOP())
		SX6->(DBSETORDER(1))		
		SX6->(DBSEEK('  '+'MV_MNLSC5'))
        RECLOCK("SX6",.F.)
		  SX6->X6_CONTEUD := xnumsc5
		MSUNLOCK()

		RETURN(xnumsc5)
	ENDIF
	xnumsc5 := SOMA1(xnumsc5)
  END
endif




Return(xnumsc5)


STATIC FUNCTION LASTNUMBER(__cfil, __cnum)
	Local aArea := GettArea()
	Local lRet	:= .T.
	lRet := SC5->(dbseek(__cFil+ __cNum))
	
	RestArea(aArea)
	
RETURN LRET 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerRA()   ºAutor  ³Leandro Duarte      º Data ³  02/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o titulo de Recebimento Antecipado para o pessoal do   º±±
±±º          ³Financeiro efetuar a Conciliação financeira corretamente    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pela Srta Andreia Financeiro copelcolchoes      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MNGerRA(cLogFile)
Local lExiste	:= .F.
IF ALLTRIM(SC5->C5_TIPOPGT) == 'BANKINVOICE'
	conout("GERANDO O TITULO DE RA")
	cHistorico	:= alltrim(SC5->C5_MENNOTA)
	cNatureza	:= 'RECE'
	nValor		:= xValorPed(SC5->C5_NUM)
	SA6->(DBSETORDER(1))
	IF nValor > 0 .AND. SA6->(DBSEEK(XFILIAL("SA6")+"2376539 7639      "))
		DBSelectArea("SE1")
		// rotina para saber se ja existe o titulo de RA do cliente referente a essa compra
		lExiste := BusqSe1()
		if !lExiste
			cNumTit := SE1->(GetSxeNum("SE1","E1_NUM"))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta array com dados do Titulo.			                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aTituloSE1  := {	{"E1_PREFIXO"	,"RA"							,Nil},;
			{"E1_NUM"	  	,cNumTit 						,Nil},;
			{"E1_PARCELA" 	,'1'			     			,Nil},;
			{"E1_TIPO"	 	,'RA'							,Nil},;
			{"E1_NATUREZ" 	,cNatureza						,Nil},;
			{"E1_CLIENTE" 	,SC5->C5_CLIENTE				,Nil},;
			{"E1_LOJA"	  	,SC5->C5_LOJACLI				,Nil},;
			{"E1_EMISSAO" 	,DATE()			 				,Nil},;
			{"E1_VENCTO"  	,DATAVALIDA(DATE())							,Nil},;
			{"E1_VENCREA" 	,DATAVALIDA(DATE())							,Nil},;
			{"E1_HIST" 		,cHistorico						,Nil},;
			{"E1_MOEDA" 	,1								,Nil},;
			{"E1_ORIGEM"	,"FINA040"						,Nil},;
			{"E1_FLUXO"		,"S"							,Nil},;
			{"E1_VALOR"	  	,nValor							,Nil},;
			{"CBANCOADT" 	,SA6->A6_COD					,Nil},;
			{"CAGENCIAADT"	,SA6->A6_AGENCIA				,Nil},;
			{"CNUMCON"		,SA6->A6_NUMCON					,Nil},;
			{"E1_PGVTTID"	,SC5->C5_PGVTTID				,Nil},;
			{"E1_NOSSVTX"	,SC5->C5_NOSSONU				,Nil} }

			lMSHelpAuto := .F. //.F. // para nao mostrar os erro na tela
			lMSErroAuto := .F. //.F. // inicializa como falso, se voltar verdadeiro e' que deu erro

			MsExecAuto({|x,y| Fina040(x,y)},aTituloSE1,3) //Inclusao
		ENDIF
			If 	lMsErroAuto
				SE1->(RollBackSX8())
				cFileLogAux	:= NomeAutoLog()
				cMemoErro 	:= MemoRead(cFileLogAux)

				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						FWrite( nHandle,"erro ao Gerar o titulo de Recebimento Antecipado"+CRLF+cMemoErro+CRLF)
						FCLOSE(nHandle)
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						FWrite( nHandle,"erro ao Gerar o titulo de Recebimento Antecipado"+CRLF+cMemoErro+CRLF)
						FCLOSE(nHandle)
					EndIf
				EndIf
			ELSE
				SE1->(ConfirmSX8())
			EndIf

	EndIf
ENDIF
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xValorPed ºAutor  ³Leandro Duarte      º Data ³  02/15/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para saber o verdadeiro valor do Boleto antecipado   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xValorPed(cPedido)
Local aAreaSC5 	:= SC5->(getarea())
Local aAreaSC6 	:= SC6->(getarea())
Local xValor	:= 0
SC5->(dbsetorder(1))
SC6->(dbsetorder(1))
IF SC5->(DBSEEK(XFILIAL("SC5")+cPedido))
	xValor += SC5->C5_FRETE
	IF SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
		WHILE SC6->C6_NUM == cPedido
			xValor += SC6->C6_VALOR
			SC6->(DBSKIP())
		END
	ENDIF
ENDIF
restarea(aAreaSC5)
restarea(aAreaSC6)
Return(xValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSQSE1   ºAutor  ³Leandro Duarte      º Data ³  02/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para sasbermos se ja existe o titulo na base de dadosº±±
±±º          ³para não duplicar                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BusqSe1()
Local lRet := .F.
Local cQuery := ""
cQuery := " SELECT count(*) AS QTD FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND A.E1_LOJA = '"+SC5->C5_LOJACLI+"' AND D_E_L_E_T_ = ' ' AND A.E1_NOSSVTX = '"+SC5->C5_NOSSONU+"'"
IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
TRBU->(DBGOTOP())
IF TRBU->QTD > 0
	lRet := .T.
	cQuery := " SELECT A.R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND A.E1_LOJA = '"+SC5->C5_LOJACLI+"' AND D_E_L_E_T_ = ' ' AND A.E1_NOSSVTX = '"+SC5->C5_NOSSONU+"'"
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	TRBU->(DBGOTOP())
	SE1->(DBGOTO(TRBU->REC))
endif

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCAEND  ºAutor  ³Leandro Duarte      º Data ³  01/20/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para sabermos se ja existe o endereço correto do Cli º±±
±±º          ³nte caso não exista o endereço para esse cliente adicionar  º±±
±±º          ³loja nova                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function BUSCAEND(cCGC,cEND,cCodCli)
Local NRet 	:= 3 // representa que o Cliente possui endereço novo
Local cQuery	:= ""
Default cCodCli := ""

if Empty(cCodCli)

//Edmar Mendes do Prado
//	cQuery	:= " SELECT A1_COD, A1_LOJA, TRIM(A.A1_END) AS A1_END, R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SA1")+" A WHERE TRIM(A.A1_CGC) = '"+ALLTRIM(cCGC)+"' AND A.D_E_L_E_T_ = ' ' "
	cQuery	:= " SELECT A1_COD, A1_LOJA, TRIM(A.A1_END) AS A1_END, R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SA1")+" A WHERE TRIM(A.A1_CGC) = '"+ALLTRIM(cCGC)+"' AND A.D_E_L_E_T_ = ' ' AND A.A1_MSBLQL <> '1' "
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	WHILE TRBU->(!EOF())
		IF Alltrim(SUBSTR(TRBU->A1_END,1,11)) == Alltrim(SUBSTR(cEND,1,11))
			SA1->(DBGOTO(TRBU->REC))
			Return(1)
		END
		TRBU->( DBSKIP() )
	END

//Edmar Mendes do Prado
//cQuery	:= " SELECT A1_COD, A1_LOJA, R_E_C_N_O_ AS REC  FROM "+RETSQLNAME("SA1")+" A WHERE TRIM(A.A1_CGC) = '"+ALLTRIM(cCGC)+"' AND A.D_E_L_E_T_ = ' '  ORDER BY 2 DESC "
	cQuery	:= " SELECT A1_COD, A1_LOJA, R_E_C_N_O_ AS REC  FROM "+RETSQLNAME("SA1")+" A WHERE TRIM(A.A1_CGC) = '"+ALLTRIM(cCGC)+"' AND A.D_E_L_E_T_ = ' '  AND A.A1_MSBLQL <> '1' ORDER BY 2 DESC "
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	IF TRBU->(!EOF())
		SA1->(DBGOTO(TRBU->REC))
		RETURN(2)
	END
else
	//Edmar Mendes do Prado
	//cQuery	:= " SELECT A1_COD, A1_LOJA, TRIM(A.A1_END) AS A1_END, R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SA1")+" A WHERE TRIM(A.A1_COD) = '"+ALLTRIM(cCodCli)+"' AND A.D_E_L_E_T_ = ' '  "
	cQuery	:= " SELECT A1_COD, A1_LOJA, TRIM(A.A1_END) AS A1_END, R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SA1")+" A WHERE TRIM(A.A1_COD) = '"+ALLTRIM(cCodCli)+"' AND A.D_E_L_E_T_ = ' ' AND A.A1_MSBLQL <> '1' "
	IiF(SELECT("TRBU")>0,TRBU->(DBCLOSEAREA()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBU", .T., .T.)
	WHILE TRBU->(!EOF())
		IF Alltrim(SUBSTR(TRBU->A1_END,1,11)) == Alltrim(SUBSTR(cEND,1,11))
			SA1->(DBGOTO(TRBU->REC))
			RETURN(1)
		END
		TRBU->( DBSKIP() )
	END
endif
Return(NRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xReserv   ºAutor  ³Leandro Duarte      º Data ³  08/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para criar a sc9 e liberar a sb2                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_ITEM,SC6->C6_VALOR,SC6->C6_LOCAL)
(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_ITEM,SC6->C6_VALOR,SC6->C6_LOCAL,SC6->C6_TES)
*/
Static Function xReserv(Pedido,Item,Cliente,Loja,Produto,QtdLib,Seq,Valor,_Local,Tes)
Local aAreaC9	:= {}
Local xSeek		:= .T.

SB2->(DBSETORDER(1))
//IF SB2->(DBSEEK(xFilial("SB2")+Produto))				
IF SB2->(DBSEEK(xFilial("SB2")+Produto+_Local))		//Edmar Mendes do Prado - validação de local

	//if SB2->B2_QATU >0 .AND. SB2->B2_QATU > SB2->B2_RESERVA .AND. (SB2->B2_QATU- SB2->B2_RESERVA) >= QtdLib
		dbSelectArea("SC9")
		aAreaC9 := GetArea("SC9")
		SC9->(dbSetOrder(1))//C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, C9_BLEST, C9_BLCRED, R_E_C_N_O_, D_E_L_E_T_
		xSeek := !SC9->(DBSEEK(XfILIAL("SC9")+Pedido+Item+"01"+Produto))
		Reclock("SC9",xSeek)
		SC9->C9_FILIAL	:= XfILIAL("SC9")
		SC9->C9_PEDIDO 	:= Pedido
		SC9->C9_ITEM 	:= Item
		SC9->C9_CLIENTE := Cliente
		SC9->C9_LOJA   	:= Loja
		SC9->C9_PRODUTO := Produto
		SC9->C9_QTDLIB 	:= QtdLib	
		SC9->C9_DATALIB := dDatabase
		SC9->C9_SEQUEN  := "01"
		SC9->C9_GRUPO  	:= POSICIONE("SB1",1,xFilial("SB1")+produto,"B1_GRUPO")
		SC9->C9_PRCVEN  := Valor
		SC9->C9_LOCAL	:= _Local
				
		SF4->(DbSetOrder(1))
		If SF4->(DbSeek(xFilial("SF4")+Tes))
	
			If SF4->F4_ESTOQUE = "S"

				If SB2->B2_QATU >0 .AND. SB2->B2_QATU > SB2->B2_RESERVA .AND. (SB2->B2_QATU- SB2->B2_RESERVA) >= QtdLib
					SC9->C9_BLEST	:= " "
				Else
					SC9->C9_BLEST	:= "02"			//Bloqueado no estoque - SEM SALDO
				EndIf	
			
			Else 
				
				SC9->C9_BLEST	:= " "
				
			EndIf
				
		EndIf

		SC9->C9_BLCRED	:= " "						//Edmar Mendes do Prado - 01/12/2017 - Para os pedidos Vtex nao bloquear no credito, pagamento efetuado no site
		SC9->C9_DATENT  := dDatabase				//Edmar Mendes do Prado - 02/03/2018
		SC9->C9_TPCARGA	:= "2"						//Edmar Mendes do Prado - 07/03/2018 - alterado de "1" para "2"
		SC9->C9_XTIPO 	:= Posicione("SB1",1, xFIlial("SB1") + produto , "B1_XTIPO")
		SC9->C9_XPESSOA := Posicione("SA1",1, xFilial("SA1") + Cliente + Loja, "A1_PESSOA")
		SC9->C9_RETOPER	:= "2"						//Edmar Mendes do Prado - 07/03/2018
		SC9->C9_TPOP	:= "1"						//Edmar Mendes do Prado - 07/03/2018		
		SC9->(MsUnLock())
		RESTAREA(aAreaC9)
	//ENDIF

/*
Else				//Se nao encontrar o produto na SB2, adicionado em 14/05/2018

		dbSelectArea("SC9")
		aAreaC9 := GetArea("SC9")
		SC9->(dbSetOrder(1))//C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, C9_BLEST, C9_BLCRED, R_E_C_N_O_, D_E_L_E_T_
		xSeek := !SC9->(DBSEEK(XfILIAL("SC9")+Pedido+Item+"01"+Produto))
		Reclock("SC9",xSeek)
		SC9->C9_FILIAL	:= XfILIAL("SC9")
		SC9->C9_PEDIDO 	:= Pedido
		SC9->C9_ITEM 	:= Item
		SC9->C9_CLIENTE := Cliente
		SC9->C9_LOJA   	:= Loja
		SC9->C9_PRODUTO := Produto
		SC9->C9_QTDLIB 	:= QtdLib	
		SC9->C9_DATALIB := dDatabase
		SC9->C9_SEQUEN  := "01"
		SC9->C9_GRUPO  	:= POSICIONE("SB1",1,xFilial("SB1")+produto,"B1_GRUPO")
		SC9->C9_PRCVEN  := Valor
		SC9->C9_LOCAL	:= _Local
				
		SF4->(DbSetOrder(1))
		If SF4->(DbSeek(xFilial("SF4")+Tes))
	
			If SF4->F4_ESTOQUE = "S"

				If SB2->B2_QATU >0 .AND. SB2->B2_QATU > SB2->B2_RESERVA .AND. (SB2->B2_QATU- SB2->B2_RESERVA) >= QtdLib
					SC9->C9_BLEST	:= " "
				Else
					SC9->C9_BLEST	:= "02"			//Bloqueado no estoque - SEM SALDO
				EndIf	
			
			Else 
				
				SC9->C9_BLEST	:= " "
				
			EndIf
				
		EndIf

		SC9->C9_BLCRED	:= " "						//Edmar Mendes do Prado - 01/12/2017 - Para os pedidos Vtex nao bloquear no credito, pagamento efetuado no site
		SC9->C9_DATENT  := dDatabase				//Edmar Mendes do Prado - 02/03/2018
		SC9->C9_TPCARGA	:= "2"						//Edmar Mendes do Prado - 07/03/2018 - alterado de "1" para "2"
		SC9->C9_XTIPO 	:= Posicione("SB1",1, xFIlial("SB1")+produto , "B1_XTIPO")
		SC9->C9_RETOPER	:= "2"						//Edmar Mendes do Prado - 07/03/2018
		SC9->C9_TPOP	:= "1"						//Edmar Mendes do Prado - 07/03/2018		
		SC9->(MsUnLock())
		RESTAREA(aAreaC9)
*/
	
ENDIF

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³grvPedJB  ºAutor  ³Leandro Duarte      º Data ³  08/14/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a gravação do pedido, via job para erros ocasio º±±
±±º          ³pois o execauto esta dando varios problemas inexistentes    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
{ SM0->M0_CODIGO, SM0->M0_CODFIL, aTables, aGrvSC5,aItensSC6,NOPC,cVTex})
*/
user Function grvPedJB(aDados)
Local aGrvSC5		:= aDados[4]
Local aItensSC6		:= aDados[5]
Local NOPC			:= aDados[6]
Local cVTex			:= aDados[7]
Local nRecSC5		:= aDados[8]
Local nRecSC6		:= aDados[9]
Local cNameSC5		:= aDados[10]
Local cNameSC6		:= aDados[11]
Local lPedOk		:= aDados[12]
Local _cFilant       := aDados[13]
lOCAL nCli		:= ascan(aGrvSC5,{|x| alltrim(x[1]) == "C5_CLIENTE" })
Local cCli		:= ""
Local nFor		:= 0
Local nFor1		:= 0

Private lWin 	:= file('c:\windows')
Private cArqPd 	:= iif(lWin,"\imp_vtex\","/imp_vtex/")
Private cNomArq	:= dtos(date())+replace(time(),':','')


//msgstop("GRVPEDJB")

if nCli > 0
	cCli := aGrvSC5[nCli][2]
endif
RpcSetType(3)
RpcSetEnv( aDados[1], aDados[2] ,,, "FAT", "GRAVACAO DE PEDIDOS VIA JOB", aDados[3], , , ,  )

iif(SELECT("GRVCPED")>0,GRVCPED->(DbCloseArea()),nil)
iif(SELECT("TRBPEDC")>0,TRBPEDC->(DbCloseArea()),nil)
iif(SELECT("GRVDPED")>0,GRVDPED->(DbCloseArea()),nil)
iif(SELECT("TRBPEDD")>0,TRBPEDD->(DbCloseArea()),nil)
dbUseArea(.T.,,cNameSC5,"GRVCPED", .T., .F. )
dbUseArea(.T.,,cNameSC6,"GRVDPED", .T., .F. )

cIndCond := "C6_VTEX+C6_PRODUTO+C6_ITEM+CVALTOCHAR(UXU_PROQUE)"
cArqNtx1 := CriaTrab(Nil, .F.)
IndRegua("GRVDPED",cArqNtx1,cIndCond,,,"Selecionando Registros...")
dbselectarea("GRVDPED")
dbSetIndex(cArqNtx1 + OrdBagExt())

cIndCon2 := "C5_VTEX+CVALTOCHAR(UXU_PROQUE)"
cArqNtx2 := CriaTrab(Nil, .F.)
IndRegua("GRVCPED",cArqNtx2,cIndCon2,,,"Selecionando Registros...")
dbselectarea("GRVCPED")

GRVCPED->(dbSeek(cVTex+"0"))





Conout("Efetuando a Gravação do Pedido: "+cVTex)
lMsErroauto := .F.
BEGIN TRANSACTION
IF LEN(aItensSC6) > 0
	IF !empty(cCli)
		if NOPC == 3 // inclusão
		CONOUT("INCLUINDO O PEDIDO")
			SC5->(DBSETORDER(10))
			LSEEK	:= !SC5->(DBSEEK(_cfilant+cVTex))
//			RECLOCK("SC5",.T.)
			RECLOCK("SC5",LSEEK)
			FOR nFor := 1 to len(aGrvSC5)
				if ("SC5->"+aGrvSC5[nFor][1]) == "SC5->C5_FILIAL"
					&("SC5->"+aGrvSC5[nFor][1]) := _cfilant
				/*elseif ("SC5->"+aGrvSC5[nFor][1]) == "SC5->C5_NUM"
					cNumFer	:= aGrvSC5[nFor][2]
					
					IF LASTNUMBER(_cFilAnt,cNumFer )
					
						cNumFer := GetSC5Num(cNumFer,lMsmped)
					ENDIF
					&("SC5->"+aGrvSC5[nFor][1]) := cNumFer*/
				else
					&("SC5->"+aGrvSC5[nFor][1]) := aGrvSC5[nFor][2]
				endif
			next nFor
			MSUNLOCK()
			FOR nFor := 1 to len(aItensSC6)

				DBSELECTAREA("AF9")
				AF9->(DBORDERNICKNAME("PDTO"))

				DBSELECTAREA("SC6")
				SC6->(DBORDERNICKNAME("VTEX"))
				nItem	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_ITEM"})
				nProd	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_PRODUTO"})
//				LSEEK	:= !SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
				LSEEK	:= !SC6->(DBSEEK(_cFilant+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
				RECLOCK("SC6",LSEEK)
				For nFor1	:= 1 to len(aItensSC6[nFor])
					&("SC6->"+aItensSC6[nFor][nFor1][1]) := aItensSC6[nFor][nFor1][2]
				next nFor1
				SC6->C6_CF := IIF(POSICIONE("SA1",1,XFILIAL("SA1")+SC6->C6_CLI,"A1_EST") == "SP",POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),"6"+SUBSTR(POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),2))

				//Edmar 04/12/2017
				//Conout('MNPED01.PRW - 00101 - Verifica descrição do Produto: ' )//+  SC6->C6_VTEX + ' - ' + SC6->C6_PRODUTO + ' - ' + SC6->C6_DESCRI)
				If Empty(padr(aItensSC6[nFor][nProd][2],tamsx3("C6_DESCRI")[1])) .Or. Empty(padr(aItensSC6[nFor][nProd][2],tamsx3("C6_UM")[1]))
				//Conout('Entrei para verificar - MNPED01.PRW - 00101')
				//If Empty(Alltrim(SC6->C6_DESCRI)) .OR. Empty(Alltrim(SC6->C6_UM))
						SC6->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"B1_DESC")
						SC6->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"B1_UM")
					If Empty(SC6->C6_DESCRI)
						Conout('nao carregou descricao')
					EndIf
				EndIf
				//Conout('MNPED01.PRW - 00201 - Verifica descrição do Produto: ' )//+  SC6->C6_VTEX + ' - ' + SC6->C6_PRODUTO + ' - ' + SC6->C6_DESCRI)	
/////// ALIMENTAÇÃO DOS CAMPOS DO PMS
//			SC6->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"B1_DESC")		
			SC6->C6_PROJPMS := Posicione("AFA",7,xfilial("AFA")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"AFA_PROJET")
			if empty(SC6->C6_PROJPMS)
			   			SC6->C6_PROJPMS := Posicione("AF9",,xfilial("AF9")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"AF9_PROJET")			
			endif
			SC6->C6_TASKPMS := Posicione("AF9",,xfilial("AF9")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"AF9_TAREFA")
			SC6->C6_EDTPMS  := Posicione("AF9",,xfilial("AF9")+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]),"AF9_PROJET") 




/////ATÉ AQUI




				
				MSUNLOCK()
				GRVDPED->(dbSeek(cVTex+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+"0"))
				Reclock("GRVDPED",.F.)
				GRVDPED->UXU_PROQUE	:= 1
				GRVDPED->(DBDELETE())
				MsUnlock()
//				IF SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
	
//LUIS
			 ////-------------LUIS 06/12/2020
				IF SC6->(DBSEEK(_cfilant+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
					//GERA A SC9
					cQuery := " SELECT COUNT(*) AS QTD "
					cQuery += "   FROM "+retsqlname("SC9")+" A  "
					cQuery += "  WHERE A.C9_PEDIDO = '"+SC6->C6_NUM+"'  "
					cQuery += "    AND A.C9_PRODUTO = '"+SC6->C6_PRODUTO+"'  "
					cQuery += " AND A.C9_ITEM = '"+SC6->C6_ITEM+"' "
					cQuery += "    AND A.D_E_L_E_T_ = ' '  "
//					cQuery += "    AND A.C9_FILIAL = '"+xFilial("SC9")+"' "
					cQuery += "    AND A.C9_FILIAL = '"+SC6->C6_FILIAL+"' "
					IiF(SELECT("GETSC9")>0,GETSC9->(DBCLOSEAREA()),nil)
					cQuery := ChangeQuery(cQuery)
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC9", .T., .T.)
					IF GETSC9->QTD <= 0 
					
//---------LUIS 06/12/2020
					If RecLock("SC5")
							Begin Transaction
								//MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.T.,.F.,.F.)
								MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,.T.,.F.)
								SC9->(DBSETORDER(1))
//								cKey := xFilial("SC9")+SC6->C6_NUM
								cKey := _cFilant+SC6->C6_NUM+SC6->C6_ITEM
								IF SC9->(DbSeek(cKey))
									while SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == cKey
										reclock("SC9",.F.)
											SC9->C9_BLCRED := " "
										MsUnlock()
										
										//Edmar Mendes do Prado
										//28/06/2018
										//Se o item estiver com valor negativo, enviar email
										//If SC9->C9_PRCVEN < 0
										//	cErItNeg	:= "ecommerce@manole.com.br; lazaro@manole.com.br;wallace.pereira@ethosx.com"
										//	U_EXPMAIL(cErItNeg, "PEDIDOS VTEX COM VALORES NEGATIVOS, ALTERE: "+SC9->C9_PEDIDO, " ALTERE O PEDIDO "+SC9->C9_PEDIDO+" - "+SC9->C9_PRODUTO+" - "+SC9->C9_PRCVEN + " ser faturado com os valores corretos. ")
										//EndIF								
										
										SC9->(DBSKIP())
									end
								ENDIF								
							End Transaction
					EndIf
						//retirado ate aqui em 14/05/2018 */
						
					ENDIF
					lMsErroauto := .F.
				ELSE
					cLogFile := cArqPd+alltrim(cVTex)+".LOG"
					nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
							FCLOSE(nHandle)
						EndIf
					EndIf
					lMsErroauto := .T.
					rETURN()
				ENDIF
					lMsErroauto := .F.
			next nFor
			MSUNLOCK()
/*
		elseif NOPC == 4 //alteração
			CONOUT("ALTERANDO O PEDIDO")
			SC5->(DBSETORDER(10))
			SC5->(DBSEEK(XfILIAL("SC5")+cVTex))
			RECLOCK("SC5",.F.)
			FOR nFor := 1 to len(aGrvSC5)
				&("SC5->"+aGrvSC5[nFor][1]) := aGrvSC5[nFor][2]
			next nFor
			MSUNLOCK()
			FOR nFor := 1 to len(aItensSC6)
				DBSELECTAREA("SC6")
				SC6->(DBORDERNICKNAME("VTEX"))
				nItem	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_ITEM"})
				nProd	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_PRODUTO"})
				nNum	:= ascan(aItensSC6[nFor],{|z| alltrim(z[1]) == "C6_NUM"})
				LSEEK	:= !SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
				IF lSeek
					SC6->(DBSETORDER(1))
					LSEEK	:= !SC6->(DBSEEK(XFILIAL("SC6")+padr(aItensSC6[nFor][nNum][2],tamsx3("C6_NUM")[1])+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1]) ))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					SC6->(DBORDERNICKNAME("VTEX"))
				endif
				RECLOCK("SC6",LSEEK)
				For nFor1	:= 1 to len(aItensSC6[nFor])
					&("SC6->"+aItensSC6[nFor][nFor1][1]) := aItensSC6[nFor][nFor1][2]
				next nFor1
				SC6->C6_CF := IIF(POSICIONE("SA1",1,XFILIAL("SA1")+SC6->C6_CLI,"A1_EST") == "SP",POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),"6"+SUBSTR(POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_CF"),2))
		
				//Edmar 04/12/2017
				//Conout('MNPED01.PRW - 00101 - Verifica descrição do Produto: ' +  SC6->C6_VTEX + ' - ' + SC6->C6_PRODUTO + ' - ' + SC6->C6_DESCRI)
				If Empty(Alltrim(SC6->C6_DESCRI)) .OR. Empty(Alltrim(SC6->C6_UM))
						SC6->C6_DESCRI 	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")
						SC6->C6_UM		:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_UM")
				EndIf
				//Conout('MNPED01.PRW - 00201 - Verifica descrição do Produto: ' +  SC6->C6_VTEX + ' - ' + SC6->C6_PRODUTO + ' - ' + SC6->C6_DESCRI)
				
				MSUNLOCK()
				if GRVDPED->(dbSeek(cVTex+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+"0"))
					Reclock("GRVDPED",.F.)
					GRVDPED->UXU_PROQUE	:= 1
					GRVDPED->(DBDELETE())
					MsUnlock()
				endif
				IF SC6->(DBSEEK(XFILIAL("SC6")+cVTex+padr(aItensSC6[nFor][nItem][2],tamsx3("C6_ITEM")[1])+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])))
					//GERA A SC9
					cQuery := " SELECT COUNT(*) AS QTD "
					cQuery += "   FROM "+retsqlname("SC9")+" A  "
					cQuery += "  WHERE A.C9_PEDIDO = '"+SC6->C6_NUM+"'  "
					cQuery += "    AND A.C9_PRODUTO = '"+SC6->C6_PRODUTO+"'  "
					cQuery += "    AND A.D_E_L_E_T_ = ' '  "
					cQuery += "    AND A.C9_FILIAL = '"+xFilial("SC9")+"' "
					IiF(SELECT("GETSC9")>0,GETSC9->(DBCLOSEAREA()),nil)
					cQuery := ChangeQuery(cQuery)
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"GETSC9", .T., .T.)
					IF GETSC9->QTD <= 0
					/*	If RecLock("SC5")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Recalcula a Quantidade Liberada                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SC6") //Forca a atualizacao do Buffer no Top
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Libera por Item de Pedido                                               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Begin Transaction
							/*
							±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
							±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99  ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Descri+.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
							±±³          ³controlar a Transacao e os Locks                            ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Parametros³ExpN1: Registro do SC6                                      ³±±
							±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
							±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
							±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
							±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
							±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
							±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
							±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
							±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
							±±³          ³       apenas avalia ).                                     ³±±
							±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
							±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
							±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
							±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
							±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
							±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±

							MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.T.,.F.,.F.)
							SC9->(DBSETORDER(1))
							cKey := xFilial("SC9")+SC6->C6_NUM
							IF SC9->(DbSeek(cKey))
								while SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO == cKey
									reclock("SC9",.F.)
										SC9->C9_BLCRED := " "
									MsUnlock()
									SC9->(DBSKIP())
								end
							ENDIF
							End Transaction
						EndIf
						
						
						*/  
						//Edmar Mendes do Prado - 02/03/2018 - Adicionar validação do TES
						//xReserv(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_ITEM,SC6->C6_VALOR,SC6->C6_LOCAL)
						//xReserv(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC6->C6_ITEM,SC6->C6_VALOR,SC6->C6_LOCAL,SC6->C6_TES)
						
						//Retirado em 14/05/2018
						//Incluido por Edmar Mendes do Prado - 07/03/2018
						//RecLock("SC6") //Forca a atualizacao do Buffer no Top
						//If RecLock("SC5")
						//	Begin Transaction
								//MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.T.,.F.,.F.)
						//		MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,.T.,.F.)
						//		SC9->(DBSETORDER(1))
						//		cKey := xFilial("SC9")+SC6->C6_NUM
						//		IF SC9->(DbSeek(cKey))
						//			while SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO == cKey
						//				reclock("SC9",.F.)
						//					SC9->C9_BLCRED := " "
						//				MsUnlock()
						//				SC9->(DBSKIP())
						//			end
						//		ENDIF							
						//	End Transaction
						//EndIf
						
						//Retirado ate aqui em 14/05/2018 */
						
					//ENDIF
					//lMsErroauto := .F.
				//ELSE
				//	cLogFile := cArqPd+alltrim(cVTex)+".LOG"
				//	nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
				//	If !File(cLogFile)
				//		If (nHandle := MSFCreate(cLogFile,0)) <> -1
				//			FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
				//			FCLOSE(nHandle)
				//		EndIf
				//	Else
				//		If (nHandle := FOpen(cLogFile,2)) <> -1
				//			FSeek(nHandle,0,2)
				//			FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O Produto não foi importado "+padr(aItensSC6[nFor][nProd][2],tamsx3("C6_PRODUTO")[1])+"!! "+CRLF)
				//			FCLOSE(nHandle)
				//		EndIf
				//	EndIf
				//	lMsErroauto := .T.
				//	rETURN()
				//ENDIF
			//next nFor
		*/
		endif
	/*	
	ELSE
		lMsErroauto := .T.
		cLogFile := cArqPd+alltrim(cVTex)+".LOG"
		nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
		If !File(cLogFile)
			If (nHandle := MSFCreate(cLogFile,0)) <> -1
				FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O cliente não foi importado!! "+CRLF)
				FCLOSE(nHandle)
			EndIf
		Else
			If (nHandle := FOpen(cLogFile,2)) <> -1
				FSeek(nHandle,0,2)
				FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+"  O cliente não foi importado!!  "+CRLF)
				FCLOSE(nHandle)
			EndIf
		EndIf
	ENDIF
ELSE
	lMsErroauto := .T.
	cLogFile := cArqPd+alltrim(cVTex)+".LOG"
	nItem	:= ascan(aGrvSC5,{|z| alltrim(z[1]) == "C5_VTEX"})
	If !File(cLogFile)
		If (nHandle := MSFCreate(cLogFile,0)) <> -1
			FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O pedido da Vtex não possui itens Completos, por favor complete os itens"+CRLF)
			FCLOSE(nHandle)
		EndIf
	Else
		If (nHandle := FOpen(cLogFile,2)) <> -1
			FSeek(nHandle,0,2)
			FWrite( nHandle,"Para o Pedido da Vtex: "+aGrvSC5[nItem][2]+" O pedido da Vtex não possui itens Completos, por favor complete os itens"+CRLF)
			FCLOSE(nHandle)
		EndIf
	*/
	EndIf
	
	Reclock("GRVCPED",.F.)
	GRVCPED->UXU_PROQUE	:=  1
//	GRVCPED->(DBDELETE())
	MsUnlock()
ENDIF
END TRANSACTION
if lMsErroauto
	conout("Falha na gravação do Pedido: "+cVTex)
else
	conout("Sucesso na gravação do Pedido: "+cVTex)
endif
IF !lMsErroauto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera o titulo Antecipado para o Financeiro efetuar a conciliação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//U_MNGerRA(cArqPd+cNomArq+".LOG")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fim da Geração do Titulo RA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONFIRMSX8()
	Reclock("GRVCPED",.F.)
	GRVCPED->UXU_PROQUE	:= 1
	MsUnlock()
/*	GRVDPED->(dbgotop())
	GRVDPED->(DBSEEK(cVTex))
	while cVTex == GRVDPED->C6_VTEX .and. GRVDPED->(!eof())
		Reclock("GRVDPED",.F.)
		GRVDPED->UXU_PROQUE	:= 1
		MsUnlock()
		GRVDPED->(DBSKIP())
	END*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apos processamento com sucesso altera o status do pedido no vtex para não pegar ele novamente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lPedOk
		u_AltPed(alltrim(GRVCPED->C5_VTEX))
	endif
	if file(cArqPd+alltrim(GRVDPED->C6_VTEX)+".LOG")
		ferase(cArqPd+alltrim(GRVDPED->C6_VTEX)+".LOG")
	endif
ENDIF
RpcClearEnv()
Return(.T.)// para não disparar o e-mail
