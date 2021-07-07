#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "FWMVCDEF.CH" 
#INCLUDE "FWBROWSE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MANC0001

Cadastro do Tipo de Operação do TES inteligente - SX5 - Tabela DJ

@author  Allan Bonfim

@since   06/05/2016
@version P11 
@param
@obs

@return

/*/
//-------------------------------------------------------------------   
User Function MANC0001()

Local aArea		:= GetArea()
Local aCpoBrw	:= {"X5_CHAVE", "X5_DESCRI", "X5_DESCSPA", "X5_DESCENG"}
Local oBrowse

oBrowse := FWMarkBrowse():New()
oBrowse:SetAlias("SX5")
oBrowse:SetDescription("Cadastro do Tipo de Operação do TES Inteligente")
oBrowse:SetFilterDefault("X5_TABELA = 'DJ'")   
oBrowse:SetOnlyFields(aCpoBrw)
oBrowse:DisableDetails()

oBrowse:Activate()

RestArea(aArea)

Return         
                                    

//-------------------------------------------------------------------
/*/{Protheus.doc} MENUDEF

MenuDef - Padrão MVC

@author  Allan Bonfim
@since   06/05/2016
@version P11 
@param 

@return array, Funções da Rotina

/*/
//-------------------------------------------------------------------   
Static Function MENUDEF()

Local aRotina 	:= {} 

ADD OPTION aRotina TITLE "Pesquisar"	ACTION "PesqBrw"          	OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MANC0001"	OPERATION 2 ACCESS 0 
ADD OPTION aRotina TITLE "Incluir"		ACTION "VIEWDEF.MANC0001" 	OPERATION 3 ACCESS 0 
ADD OPTION aRotina TITLE "Alterar"		ACTION "VIEWDEF.MANC0001" 	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"		ACTION "VIEWDEF.MANC0001" 	OPERATION 5 ACCESS 0
					
Return aRotina     
                                      

//-------------------------------------------------------------------
/*/{Protheus.doc} MODELDEF

ModelDef - Padrão MVC

@author  Allan Bonfim
@since   06/05/2016
@version P11 
@param 

@return objeto, Objeto do Model

/*/
//-------------------------------------------------------------------   
STATIC FUNCTION MODELDEF()

Local oStruct1
Local oModel
Local oView

oStruct1	:= FWFormStruct(1, "SX5")


oStruct1:SetProperty('X5_CHAVE', MODEL_FIELD_TAMANHO, 2)

oModel		:= MPFormModel():New("MANC01MOD",, {|oModel| MANC001OK(oModel)})
oView     	:= FWFormView():New()


oStruct1:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })

//Estrutura Model
oModel:AddFields("SX5_TIPOPER",,oStruct1)

//Define a chave primaria utilizada pelo modelo
oModel:SetPrimaryKey({'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE'})            

oModel:SetActivate({|oModel| MAN01ACT(oModel)})

oModel:GetModel("SX5_TIPOPER"):SetDescription("Tabela Generica (SX5)")

Return oModel
                                      

//-------------------------------------------------------------------
/*/{Protheus.doc} VIEWDEF

ViewDef - Padrão MVC

@author  Allan Bonfim
@since   06/05/2016
@version P11 
@param

@return objeto, Objeto da View

/*/
//-------------------------------------------------------------------   
STATIC FUNCTION VIEWDEF()

Local aCpoSX5 	:= {"X5_TABELA"} 
Local oStruct1
Local oModel
Local oView

oModel    := FWLoadModel("MANC0001") //Chamada do model utilizando o nome do fonte (PRW)

oStruct1	:= FWFormStruct(2, "SX5", {|cCampo| !MAN01CPO(cCampo, aCpoSX5)})

oStruct1:SetProperty("X5_CHAVE", MVC_VIEW_TITULO, "Cod. Tp. Operacao") 

oView     := FWFormView():New() //View da MVC

oView:SetModel(oModel)


//Estrutura View
oView:AddField("VIEW_SX5TIPOPER", oStruct1, "SX5_TIPOPER")

//Formatação da Tela
oView:CreateHorizontalBox("BOXSX5"	,100) //Uma barra horizontal com proporção de 35% da tela.

oView:SetOwnerView("VIEW_SX5TIPOPER", "BOXSX5")

oView:SetCloseOnOk({|| .T.})

Return oView
                                         

//-------------------------------------------------------------------
/*/{Protheus.doc} MAN01CPO

Campos que serão listados na tela

@author  Allan Bonfim
@since   06/05/2016
@version P11 

@param [cCpo], caracter, Campo do objeto Model
@param [aCpo], array, Array com os campos que serão demonstrados na tela

@return lógico, Gravação dos dados

/*/
//------------------------------------------------------------------- 
STATIC FUNCTION MAN01CPO(cCpo, aCpo)

Return aScan(aCpo, {|x| ALLTRIM(x) == ALLTRIM(cCpo)}) > 0      


//-------------------------------------------------------------------
/*/{Protheus.doc} MAN01ACT

Função para ativar o model

@author Allan Constantino Bonfim
@since 06/05/2016
@version 1.0

@return
/*/
//-------------------------------------------------------------------
Static Function MAN01ACT(oModelAct) 

Local lRet       	:= .T.
Local oModelTmp 	:= oModelAct:GetModel("SX5_TIPOPER")
Local nOper			:= oModelAct:GetOperation() 

If nOper == MODEL_OPERATION_INSERT
	oModelTmp:SetValue("X5_TABELA", "DJ")
EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} MANC001OK

Validação final da rotina (Tudo Ok)

@author  Allan Bonfim
@since   06/05/2016
@version P11 
@param	[oModelCab], objeto, Objeto do Model

@return

/*/
//------------------------------------------------------------------- 
STATIC FUNCTION MANC001OK(oModelCab)

Local aArea	 	:= GetArea()
Local lRet	 	:= .T.
Local nOper		:= oModelCab:GetOperation() 
Local cQuery	:= ""  
Local cTmpQuery	:= GetNextAlias()

If nOper == MODEL_OPERATION_INSERT .OR. nOper == MODEL_OPERATION_UPDATE

	If lRet .AND. EMPTY(oModelCab:GetValue('SX5_TIPOPER', 'X5_CHAVE'))
		oModelCab:SetValue('X5_TABELA','21')
	Endif

	If lRet .AND. EMPTY(oModelCab:GetValue('SX5_TIPOPER', 'X5_CHAVE'))
   		HELP(,, 'Tipo Operação', "X5_CHAVE", "O preenchimento do campo Tipo de operação é obrigatório." , 1, 0)
		lRet := .F.
	Endif
	
	If lRet .AND. EMPTY(oModelCab:GetValue('SX5_TIPOPER', 'X5_DESCRI'))
 		HELP(,, 'Tipo Operação', "X5_DESCRI", "O preenchimento do campo Descrição é obrigatório." , 1, 0)
		lRet := .F.
	Endif

	cQuery 	:= "SELECT X5_CHAVE AS OPER, COUNT(1) AS QTD_OPER FROM "+RETSQLNAME("SX5")+" SX5 "+CHR(13)+CHR(10)	
	cQuery 	+= "WHERE SX5.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
	cQuery 	+= "AND X5_TABELA = 'DJ' "+CHR(13)+CHR(10)
	cQuery 	+= "AND (X5_CHAVE = '"+ALLTRIM(oModelCab:GetValue("SX5_TIPOPER", "X5_CHAVE"))+"' "+CHR(13)+CHR(10)
	cQuery 	+= "OR X5_DESCRI = '"+ALLTRIM(oModelCab:GetValue("SX5_TIPOPER", "X5_DESCRI"))+"') "+CHR(13)+CHR(10)	

	If nOper == MODEL_OPERATION_UPDATE
		cQuery 	+= "AND SX5.R_E_C_N_O_ <> "+CVALTOCHAR(SX5->(RECNO()))+" "+CHR(13)+CHR(10)
	EndIf   

	cQuery 	+= "GROUP BY X5_CHAVE "+CHR(13)+CHR(10)
	
	If Select(cTmpQuery) > 0
		(cTmpQuery)->(DbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery), cTmpQuery, .T., .T.)
	      
	If (cTmpQuery)->QTD_OPER > 0
		HELP(,, 'Tipo Operação',, "O Código ou a Descrição do Tipo de Operação já está cadastrado. Verifique o Código ou a Descrição do Tipo informado ou utilize o Tipo de Operação existente." , 1, 0)		
		lRet := .F.	
	EndIf

EndIf

If lRet .AND. (nOper == MODEL_OPERATION_UPDATE .OR. nOper == MODEL_OPERATION_DELETE)

	cQuery 	:= "SELECT TMP.OPER, SUM(TMP.QTD_OPER) AS TOTAL_OPER "+CHR(13)+CHR(10)	
	cQuery 	+= "FROM	( "+CHR(13)+CHR(10)		
	cQuery 	+= "		SELECT D1_XOPER AS OPER, COUNT(1) AS QTD_OPER FROM "+RETSQLNAME("SD1")+" SD1 "+CHR(13)+CHR(10)	
	cQuery 	+= "		WHERE SD1.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
	cQuery 	+= "		AND D1_XOPER = '"+ALLTRIM(oModelCab:GetValue("SX5_TIPOPER", "X5_CHAVE"))+"' "+CHR(13)+CHR(10)
	cQuery 	+= "		GROUP BY D1_XOPER "+CHR(13)+CHR(10)
	
	cQuery 	+= "		UNION ALL "+CHR(13)+CHR(10)

	cQuery 	+= "		SELECT D2_XOPER AS OPER, COUNT(1) AS QTD_OPER FROM "+RETSQLNAME("SD2")+" SD2 "+CHR(13)+CHR(10)	
	cQuery 	+= "		WHERE SD2.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
	cQuery 	+= "		AND D2_XOPER = '"+ALLTRIM(oModelCab:GetValue("SX5_TIPOPER", "X5_CHAVE"))+"' "+CHR(13)+CHR(10)
	cQuery 	+= "		GROUP BY D2_XOPER "+CHR(13)+CHR(10)
	
	cQuery 	+= "		UNION ALL "+CHR(13)+CHR(10)

	cQuery 	+= "		SELECT C6_XOPER AS OPER, COUNT(1) AS QTD_OPER FROM "+RETSQLNAME("SC6")+" SC6 "+CHR(13)+CHR(10)	
	cQuery 	+= "		WHERE SC6.D_E_L_E_T_ = ' ' "+CHR(13)+CHR(10)
	cQuery 	+= "		AND C6_XOPER = '"+ALLTRIM(oModelCab:GetValue("SX5_TIPOPER", "X5_CHAVE"))+"' "+CHR(13)+CHR(10)
	cQuery 	+= "		GROUP BY C6_XOPER "+CHR(13)+CHR(10)	
	cQuery 	+= "		) TMP "+CHR(13)+CHR(10)		
	cQuery 	+= "GROUP BY TMP.OPER "+CHR(13)+CHR(10)		
    
	If Select(cTmpQuery) > 0
		(cTmpQuery)->(DbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery), cTmpQuery, .T., .T.)
	      
	If (cTmpQuery)->TOTAL_OPER > 0
		If nOper == MODEL_OPERATION_UPDATE
			HELP(,, 'Tipo Operação',, "O tipo de operação não poderá ser alterado pois existem movimentações (notas de entrada/saída ou pedidos de vendas) vinculados." , 1, 0)
		ElseIf nOper == MODEL_OPERATION_DELETE
			HELP(,, 'Tipo Operação',, "O tipo de operação não poderá ser excluído pois existem movimentações (notas de entrada/saída ou pedidos de vendas) vinculados." , 1, 0)		
		EndIf
		
		lRet := .F.	
	EndIf
		
EndIf

If Select(cTmpQuery) > 0
	(cTmpQuery)->(DbCloseArea())
EndIf
	
RestArea(aArea)

Return lRet