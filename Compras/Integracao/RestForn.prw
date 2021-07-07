#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "Tbiconn.ch" 
#Include "Topconn.ch"                                                                       
#include 'parmtype.ch'
#include 'RestFul.ch'
#Include "Rwmake.ch"

Static cLogArquivo  := 'Log_Fornec'
Static cLogProcesso := ProcName()
Static cLogError    := ''

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTFORN บAutor ณEdmar Mendes do Pradoบ Data ณ  12/06/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o cadastro de Fornecedores do Formulario Web Manole บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ              		
ฑฑบUso       ณ Manole													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบ Schedule na empresa 01,01. 	  Nome: CadForn - U_CadForn("01","01")    บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RestForn()

Local cRestForn := "https://api-totvs.manoleeducacao.com.br/?action=search"
Local nRegFor	:= 0
Local nTipo		:= 0
Local cContent 	:= ''
Local cErro 	:= ''
Local cHeadRet	:= ""
Local cXmlFor	:= ""
Local cCgcFor	:= ""
Local cTipFor	:= ""
Local sPostRet 	:= ""
Local lXml		:= .F.

Private nLoop	:= 0
Private nLoop2	:= 0
Private oObj
Private cParam   := ""
Private PassWord := "QWILBHUFTPJMLEDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBDCIZPPXMJILYOQFEPRSQPNIJSRPTXJIANYPYBEEDEFSMIEEKYTVDMLMLYOUYHXAAEOZHRYAYSD"
Private aHeadOut := {}
Private lMsErroAuto := .F.
Private lMsHelpAuto	:= .T.    
Private lAutoErrNoFile := .T.
	
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM" TABLES "SA2" 


//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'Authorization: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

// COMUNICA COM O WEBSERVICE
sPostRet := HttpGET(cRestForn,cParam,12000,aHeadOut,@cHeadRet)

//Efetua tratativas no Json
cXmlFor := (sPostRet)
cXmlFor := StrTran(cXmlFor, "\/", "")
cXmlFor := StrTran(cXmlFor, "null", '""')
cXmlFor := DecodeUtf8(cXmlFor)

//Retira caracteres especiais e acentos
cXmlFor := u_Limpar(cXmlFor)

//Grava dados no arquivo de console.log
Conout("** INICIO - Integracao FORNECEDOR " + DtoC(Date()) + " - " + Time() + " **")
conout(cXmlFor)				

//Deserializa o JSON para trabalhar com os dados
lXml 	:= FWJsonDeserialize(cXmlFor,@oObj)

//Se houver registros a processar
If lXml

	//Verifico a quantidade de registros a processar
	nRegFor := Len(oObj)
	
	If nRegFor > 0	

		For nLoop := 1 To nRegFor	
			
			cIdFornec	:= oObj[nLoop]:id_fornecedor
			cTipFor		:= Upper(oObj[nLoop]:tipo_fornecedor)
			cCgcFor 	:= LimpCamp(oObj[nLoop]:cnpj)
			cCpfFor		:= LimpCamp(oObj[nLoop]:cpf)
			nTipo		:= 0
			
			If Alltrim(Upper((cTipFor))) == Alltrim(Upper("F"))
	
				//Verifico se o Fornecedor PESSOA FISICA jแ existe na base
				DbSelectArea("SA2")
				Dbsetorder(3)		//Indice por CGC
				If SA2->(DbSeek(xFilial("SA2")+ Alltrim(cCpfFor)))
					//Cadastro encontrado, verificar se irแ atualizar os dados
					conout('Fornecedor FISICO ja cadastrado na base ' + cCpfFor)
					
					//Efetua a altera็ใo do Fornecedor
					nTipo	:= 4
					//CadNewFor(cIdFornec,cTipFor,"",cCpfFor,nTipo)
					
					//Atualiza status no site para nใo pegแ-lo novamente
					AtuStat(cIdFornec)										
				Else
					//Cadastro a ser incluido
					//aAdd(aVetor,{oObj:oObj[nLoop,nLoop2]:CAMPO ,oObj:oObj[nLoop,nLoop2]:conteudo,Nil})
					//aAdd(aVetor,{oObj:oObj[nLoop,nLoop2]:CAMPO ,oObj:oObj[nLoop,nLoop2]:conteudo,Nil})
					//aAdd(aVetor,{oObj:oObj[nLoop,nLoop2]:CAMPO ,oObj:oObj[nLoop,nLoop2]:conteudo,Nil})
					conout('Fornecedor FISICO a ser cadastrado')

					//Efetua a inclusใo do Fornecedor
					nTipo	:= 3
					CadNewFor(cIdFornec,cTipFor,"",cCpfFor,nTipo)

				EndIf
					
			Else  //If cTipFor == "J"
			
				//Verifico se o Fornecedor PESSOA JURIDICA jแ existe na base
				DbSelectArea("SA2")
				Dbsetorder(3)		//Indice por CGC
				If SA2->(DbSeek(xFilial("SA2")+ Alltrim(cCgcFor))) 
					conout('Fornecedor JURIDICO encontrado: ' + cCgcFor)
					
					//Efetua a atualiza็ใo do Fornecedor
					nTipo	:= 4
					//CadNewFor(cIdFornec,cTipFor,cCgcFor,"",nTipo)
					
					//Atualiza status no site para nใo pegแ-lo novamente
					AtuStat(cIdFornec)										
				Else
					conout('Fornecedor JURIDICO a ser cadastrado: ' + cCgcFor)
									
					//Efetua a inclusใo do Fornecedor
					nTipo	:= 3
					CadNewFor(cIdFornec,cTipFor,cCgcFor,"",nTipo)

				EndIf
				
			EndIf
		
		Next nLoop
	
	Else
	
	Conout("Nao ha registros para processamento. ")
	
	EndIf
	
Else
	//MsgAlert('Nใo foi dessa vez ainda!')
	ConOut("NNNNaaaaaaaaoooooooo !!! ") 
	//cErro := cRestForn:GetLastError()
EndIf

Conout("** FIM - Integracao FORNECEDOR " + DtoC(Date()) + " - " + Time() + " **")
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLimpCamp บAutor  ณEdmar Mendes do Pradoบ Data ณ  13/06/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetira os caracteres especiais                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Manole                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LimpCamp(cTxt)

Local cRet := ""
Local nX := 0

For nX := 1 To Len(cTxt)
	If SubStr(cTxt,nX,1) $ ".-"
		If SubStr(cTxt,nX,1) == "."
			cRet += ""
		ElseIf SubStr(cTxt,nX,1) == "-"
			cRet += ""
		EndIf
	Else
		cRet += SubStr(cTxt,nX,1)
	EndIf
	
next nX

Return AllTrim(Upper(cRet))






/*/{Protheus.doc} CadNewFor
Funcao para efetuar o cadastro do Fornecedor
@type function
@author Edmar Mendes do Prado
@since  14/06/2019
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static function CadNewFor(cIdFornec,cTipFor,cCgcFor,cCpfFor,nTipo)
Local aVetor 	:= {}
Local cMsgErro	:= "wallace.pereira@ethosx.com;wallace.pereira@ethosx.com"
Local cEmAudit  := "anderson@manole.com.br;caio.meirelles@manole.com.br;wallace.pereira@ethosx.com;matheus@manole.com.br;"
Local cEmResp	:= "anderson@manole.com.br;matheus@manole.com.br;financeiro.cr@manole.com.br;wallace.pereira@ethosx.com;"
Private lMsErroAuto := .F.

//Preenche registros referente Tipo de Fornecedor					
/*
1 = Professor
2 = Autor
3 = Professor/Autor
4 = Fornecedor Servico
5 = Fornecedor PA
6 = Cliente
*/

//If nTipo == 3				
	cProfAut		:= oObj[nLoop]:professor_autor				
	If cProfAut == "PROFESSOR"
		cProfAut := '1'
	ElseIf cProfAut == "AUTOR"
		cProfAut := '2'
	End

	//Carrega o vetor com os dados para cadastro
	aAdd(aVetor,{"A2_XCAD"		,	Iif(cProfAut == '2',"A","F")						,Nil})
	aAdd(aVetor,{"A2_COD"		,	U_FPreen(Iif(cProfAut == '2',"A","F"))				,Nil})
	aAdd(aVetor,{"A2_LOJA" 		,	"01"												,Nil})
//EndIf

If cTipFor == "J"
	cNomFant		:= Alltrim(SubStr(Upper(oObj[nLoop]:nome_fantasia),1,20)) 
	If cNomFant == "" .Or. cNomFant == "nulo"
		cNomFant := SubStr(Upper(oObj[nLoop]:razao_social),1,20)
	End
	
	aAdd(aVetor,{"A2_NOME"		,	SubStr(Upper(oObj[nLoop]:razao_social),1,40)		,Nil})
	aAdd(aVetor,{"A2_NREDUZ"	,	cNomFant											,Nil})
	aAdd(aVetor,{"A2_XNOMRES"	,	Upper(oObj[nLoop]:nome_completo)					,Nil})					
Else
	cNomFant		:= Alltrim(SubStr(Upper(oObj[nLoop]:nome_completo),1,20)) 
	
	aAdd(aVetor,{"A2_NOME"		,	SubStr(Upper(oObj[nLoop]:nome_completo),1,40)		,Nil})
	aAdd(aVetor,{"A2_NREDUZ"	,	cNomFant											,Nil})
	aAdd(aVetor,{"A2_XNOMRES"	,	Upper(oObj[nLoop]:nome_completo)					,Nil})					

End

aAdd(aVetor,{"A2_END"		,	Upper(oObj[nLoop]:endereco)							,Nil})
aAdd(aVetor,{"A2_BAIRRO"	,	SubStr(Upper(oObj[nLoop]:bairro),1,20)				,Nil})
aAdd(aVetor,{"A2_EST"		,	Upper(oObj[nLoop]:uf)								,Nil})
aAdd(aVetor,{"A2_COD_MUN"	,	SubStr(oObj[nLoop]:codigo_municipio,3,5) 			,Nil})
//aAdd(aVetor,{"A2_ESTADO"	,	Upper(oObj[nLoop]:nome_completo						,Nil})
aAdd(aVetor,{"A2_MUN"		,	Upper(oObj[nLoop]:cidade)							,Nil})
aAdd(aVetor,{"A2_CEP"		,	LimpCamp(SubStr(Alltrim(oObj[nLoop]:cep),1,9))		,Nil})
aAdd(aVetor,{"A2_TIPO"		,	cTipFor												,Nil})
aAdd(aVetor,{"A2_CGC"		,	Iif(cCgcFor == "",cCpfFor,cCgcFor)					,Nil})
aAdd(aVetor,{"A2_DDD"		,	substr(oObj[nLoop]:celular,2,2)						,Nil})

cNumInsc	:= Upper(oObj[nLoop]:inscricao_estadual)
cNumInscM	:= Upper(oObj[nLoop]:inscricao_municipal)

aAdd(aVetor,{"A2_INSCR"		,	IIf(cNumInsc == "0","ISENTO",cNumInsc)				,Nil})
aAdd(aVetor,{"A2_INSCRM"	,	IIf(cNumInscM == "0","ISENTO",cNumInscM)			,Nil})

aAdd(aVetor,{"A2_TEL"		,	substr(oObj[nLoop]:celular,5,11)					,Nil})
aAdd(aVetor,{"A2_BANCO"		,	oObj[nLoop]:banco									,Nil})
aAdd(aVetor,{"A2_AGENCIA"	,	LimpCamp(SubStr(Alltrim(oObj[nLoop]:agencia),1,4))	,Nil})
aAdd(aVetor,{"A2_XDIGAG"	,	LimpCamp(SubStr(Alltrim(oObj[nLoop]:agencia),5,1))	,Nil})
aAdd(aVetor,{"A2_NUMCON"	,	LimpCamp(oObj[nLoop]:conta)							,Nil})
aAdd(aVetor,{"A2_EMAIL"		,	Lower(oObj[nLoop]:email)							,Nil})								

//If nTipo == 3
	aAdd(aVetor,{"A2_PROFAUT"	,	cProfAut											,Nil})
	//Demais campos obrigatorios no cadastro, informar padrao para revisao
	//aAdd(aVetor,{"A2_NATUREZ"	,	""					,Nil})
	aAdd(aVetor,{"A2_PAIS"		,	"105"												,Nil})
	aAdd(aVetor,{"A2_CONTA"		,	"211070001"											,Nil})
	aAdd(aVetor,{"A2_RECISS"	,	"N"													,Nil})
	aAdd(aVetor,{"A2_TPESSOA"	,	"OS"												,Nil})
	aAdd(aVetor,{"A2_RECINSS"	,	"S"													,Nil})
	aAdd(aVetor,{"A2_CODPAIS"	,	"01058"												,Nil})
	aAdd(aVetor,{"A2_GRPTRIB"	,	"003"												,Nil})
	aAdd(aVetor,{"A2_CALCIRF"	,	"1"													,Nil})
//EndIf

aAdd(aVetor,{"A2_MSBLQL"	,	"1"													,Nil})

cNumPIS		:= LimpCamp(oObj[nLoop]:pis)
If cNumPis	!= "0"
	aAdd(aVetor,{"A2_XPIS"		,	cNumPIS											,Nil})
EndIf
					
aAdd(aVetor,{"A2_XORIGEM"	,	Upper(oObj[nLoop]:origemcadastro)					,Nil})
					
MSExecAuto({|x,y| Mata020(x,y)},aVetor,nTipo) //3- Inclusใo, 4- Altera็ใo, 5- Exclusใo
					
If lMsErroAuto
	aErrPCAuto	:= GETAUTOGRLOG()
	cMsgErro	:= ""
	For nLoop := 1 To Len(aErrPCAuto)
		cMsgErro += aErrPCAuto[nLoop]+ "<br>"
	Next
		
	//U_LogFunction(cLogArquivo,cLogError,cLogProcesso)
						
	//If Findfunction("u_FSENVMAIL")
	//	u_FSENVMAIL("Log_Fornec",cLogError,cLogmail)
	//EndIf	
						
	ConOut("Cadastro de Fornecedor NAO EFETUADO !!! ")
	ConOut(cMsgErro)

	Conout("** CADFORN-001 - Enviando e-mail de Cadastro NรO efetuado" + DtoC(Date()) + " - " + Time() + " **")
	U_EXPMAIL(cEmAudit , "ERRO NA INTEGRACAO FORNECEDOR, FAวA CORRECAO PARA INSERIR NO PROTHEUS: ", " Verifique: " + cMsgErro + " ")
	
Else	
	ConOut("Cadastro de Fornecedor efetuado com sucesso")
	ConfirmSX8()

	//Atualiza status no site para nใo pegแ-lo novamente
	AtuStat(cIdFornec)
		
	//cHtml := u_StatPed(SC5->C5_NUM)
	//EnviaEmail(cHtml,cMailSta)
	Conout("** CADFORN-002 - Enviando e-mail de Fornecedor Bloqueado " + DtoC(Date()) + " - " + Time() + " **")
	U_EXPMAIL(cEmResp , "Novo FORNECEDOR inserido, bloqueado, fa็a ANALISE e desbloqueio: " + cNomFant, " Fa็a a analise do cadastro, verifique os IMPOSTOS e as consultas aos orgaos competentes, para o c๓digo " + Iif(cCgcFor == "",cCpfFor,cCgcFor) + " . ")
	U_EXPMAIL(cEmAudit , "Novo FORNECEDOR inserido, bloqueado, fa็a ANALISE e desbloqueio: " + cNomFant, " Fa็a a analise do cadastro, verifique os IMPOSTOS e as consultas aos orgaos competentes, para o c๓digo " + Iif(cCgcFor == "",cCpfFor,cCgcFor) + " . ")
										
EndIf			


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTFORN บAutor ณEdmar Mendes do Pradoบ Data ณ  12/06/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza para consumido no web service Manole			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ              		
ฑฑบUso       ณ Manole													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบ 																	  บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuStat(cIdFornec)

Local cPostForn := "https://api-totvs.manoleeducacao.com.br/?action=update"
Local sPostRet 	:= ""
Local cTextEnv	:= ""

Private aHeadOut := {}
Private cParam   := ""
Private PassWord := "QWILBHUFTPJMLEDZRQJQTJLUUJYZVQESXDCSADAEMESTDEVQPDYPYATCECOBDCIZPPXMJILYOQFEPRSQPNIJSRPTXJIANYPYBEEDEFSMIEEKYTVDMLMLYOUYHXAAEOZHRYAYSD"
Private aHeadOut := {}
Private lMsErroAuto := .F.
Private lMsHelpAuto	:= .T.    
Private lAutoErrNoFile := .T.

//ARRAY COM OS DADOS DE HEADER PARA O JSON
aadd(aHeadOut,'Authorization: '+PassWord)
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

cTExtEnv := '{"id" : "' +cIdFornec+ '","read" : "true"}'

//Altera status do cadastro para NAO trazer novamente
sPostRet := HttpPOST(cPostForn,"",cTextEnv,,aHeadOut)

Conout(aHeadOut)
Conout(sPostRet)

//ENVIAR PARA O CESAR EM JSON
//body: {"id" : "<id do usuแrio>","read" : "<true para consumido e false para nใo consumido>"}

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณFun…o    ณ Enviaemail  ณ Autor ณ Edmar Mendes do Prado ณ Data ณ14/06/2019ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณEnvio de email referente cadastro de fornecedor novo           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                    ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Enviaemail(cHTML,cEmail)

Local lOk			:= .F.
Local cError
Local cMailConta	:= "acertos@manole.com.br"				//Alltrim(GetMv("MN_CSGCONT"))
Local cMailSenha	:= "@c3rt05!+" 							//Alltrim(GetMv("MN_CSGSENH"))
Local cMailServer	:= "smtp.gmail.com:587"					//Alltrim(GetMv("MN_CSGSERV"))
local nRelTime 	    := 300									//GetMv("MN_CSGTIME")	//300	
Local lSSL	        := .T.									//GetMv("MN_CSGSSL")	//.T. 
Local lTLS	        := .T.									//GetMv("MN_CSGTLS")	//.T. 
Local lAutentica    := .T.									//GetMv("MN_CSGAUTH")	//.T. 
Local cAssunto	    := "Novo FORNECEDOR - Analisar/Desbloquear"
Local cTo           := cEmail
Local cCC           := ""
Local cTexto        := cHTML

ProcRegua(8)
IncProc()
IncProc("Conectando SERVIDOR...")

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	// Conecta uma vez com o servidor de e-mails
	IF lSSL .AND. lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime SSL TLS RESULT lOk
	ELSEIF lSSL .AND. !lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime SSL RESULT lOk
	ELSEIF !lSSL .AND. lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime TLS RESULT lOk
	ELSEIF !lSSL .AND. !lTLS
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nRelTime RESULT lOk
	ENDIF

	IncProc()
	IncProc()
	IncProc("Enviando e-mail...")

	If lOk
		If lAutentica
			If !MailAuth(cMailConta, cMailSenha )
				ALERT("Falha na Autentica็ใo do Usuแrio")
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
					ALERT("Erro na Desconexใo: "+cError)
				ENDIF
				Return .F.
			EndIf
		EndIf
		//
		SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cTexto ATTACHMENT RESULT lSendOk
		IncProc()
		IncProc()
		IncProc("Desconectando...")
		If !lSendOk
			GET MAIL ERROR cError
			ALERT("1-Erro no envio do e-Mail",cError)
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		ALERT("2-Erro no envio do e-Mail",cError)
	EndIf
EndIf

If lOk
	DISCONNECT SMTP SERVER
	IncProc()
	IncProc()
	IncProc()
EndIf

Return lOk