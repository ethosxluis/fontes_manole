#include "Protheus.ch"
#INCLUDE "DBTREE.CH"
#INCLUDE "MSOLE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONTRXDOT ºAutor  ³LEANDRO DUARTE      º Data ³  06/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA IMPRESSAO DOS CONTRATOS VIA WORD                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CONTRXDOT()
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROFESSO  ºAutor  ³LEANDRO DUARTE      º Data ³  06/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³IMPRESSÃO DO CONTRATO DE PROFESSOR                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION PROFESSO()
LOCAL aDados 		:= {}
Local cPathOri		:= lower(alltrim(UA7->UA7_LOCAL))
Local cDot			:= lower(alltrim(UA7->UA7_ARQUIV))
Local cQuery		:= ""
Local hWord 		:= ""
Local cNewDoc		:= LOWER(alltrim(UA2->UA2_CONTRA)+alltrim(UA2->UA2_SEQCON)+alltrim(UA2->UA2_FORNEC)+alltrim(UA2->UA2_PRODUT))+'.dot'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo para Criar a pasta Temp do Usuario e copiar o arquivo para a maquina do usuario para poder executar o Word³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MAKEDIR( "C:\TEMP")
__CopyFile( cPathOri+cDot , "C:\TEMP\" + cDot )


cQuery := " SELECT *	"
cQuery += "   FROM "+RETSQLNAME("UA2")+" A,	"+RETSQLNAME("SA2")+" B, "+RETSQLNAME("SB1")+" C	"
cQuery += "  WHERE A.UA2_FILIAL = '"+xFilial("UA2")+"'  "+CRLF
cQuery += "    AND A.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "    AND B.A2_COD = A.UA2_FORNEC  "+CRLF
cQuery += "    AND B.A2_FILIAL = '"+xfilial("SA2")+"'  "+CRLF
cQuery += "    AND B.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "    AND A.UA2_PRODUT = C.B1_COD  "+CRLF
cQuery += "    AND C.B1_FILIAL = '"+xFilial("SB1")+"'  "+CRLF
cQuery += "    AND C.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "    AND A.UA2_CONTRA = '"+UA2->UA2_CONTRA+"'  "+CRLF
cQuery += "    AND A.UA2_SEQCON = '"+UA2->UA2_SEQCON+"'  "+CRLF
IIF(SELECT("TRBCN9")>0,TRBCN9->(DBCLOSEAREA()),NIL)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRBCN9", .F., .T.)

IF TRBCN9->(!EOF())
	hWord 	:= OLE_CreateLink("TMSOLEWORD97")
	
	OLE_SetProperty(hWord,oleWdWindowState,"MAX" )
	OLE_SetProperty(hWord,oleWdVisible,.F.)
	Ole_NewFile(hWord,"C:\TEMP\" + cDot)
	
	Ole_SetDocumentVar(hWord,'contratado',TRBCN9->A2_NOME)
	cEndereco	:= alltrim(TRBCN9->A2_END)
	xDia	:=	substr(dtos(date()),7,2)
	xMes	:=	MesExtenso(date())
	xAno	:=	substr(dtos(date()),1,4)
	Ole_SetDocumentVar(hWord,'end_contratado',cEndereco)
	Ole_SetDocumentVar(hWord,'bairro_contratado',alltrim(TRBCN9->A2_BAIRRO))
	Ole_SetDocumentVar(hWord,'cidade_contratado',TRBCN9->A2_MUN)
	Ole_SetDocumentVar(hWord,'UF_contratado',TRBCN9->A2_EST)
	Ole_SetDocumentVar(hWord,'CEP_contratado',TRBCN9->A2_CEP)
	Ole_SetDocumentVar(hWord,'RG_contratado',TRBCN9->A2_PFISICA)
	Ole_SetDocumentVar(hWord,'CPF_contratado',TRBCN9->A2_CGC)
	Ole_SetDocumentVar(hWord,'PIS_contratado',"")
	Ole_SetDocumentVar(hWord,'EMAIL_contratado',TRBCN9->A2_EMAIL)
	Ole_SetDocumentVar(hWord,'FONE_contratado',"")
	Ole_SetDocumentVar(hWord,'nome_coordenador',"")
	Ole_SetDocumentVar(hWord,'cnpj_coordenador',"")
	Ole_SetDocumentVar(hWord,'end_coordenador',"")
	Ole_SetDocumentVar(hWord,'numero_coordenador',"")
	Ole_SetDocumentVar(hWord,'bairro_coordenador',"")
	Ole_SetDocumentVar(hWord,'cidade_coordenador',"")
	Ole_SetDocumentVar(hWord,'UF_coordenador',"")
	Ole_SetDocumentVar(hWord,'CEP_coordenador',"")
	Ole_SetDocumentVar(hWord,'natural_coordenador',"")
	Ole_SetDocumentVar(hWord,'cpf_coordenador',"")
	Ole_SetDocumentVar(hWord,'rg_coordenador',"")
	Ole_SetDocumentVar(hWord,'nome2_coordenador',"")
	Ole_SetDocumentVar(hWord,'cnpj2_coordenador',"")
	Ole_SetDocumentVar(hWord,'end2_coordenador',"")
	Ole_SetDocumentVar(hWord,'numero2_coordenador',"")
	Ole_SetDocumentVar(hWord,'bairro2_coordenador',"")
	Ole_SetDocumentVar(hWord,'cidade2_coordenador',"")
	Ole_SetDocumentVar(hWord,'uf2_coordenador',"")
	Ole_SetDocumentVar(hWord,'cep2_coordenador',"")
	Ole_SetDocumentVar(hWord,'cpf2_coordenador',"")
	Ole_SetDocumentVar(hWord,'rg2_coordenador',"")
	
	/*
	Ole_SetDocumentVar(hWord,'CINSFOR',TRBCN9->A2_INSCR)
	Ole_SetDocumentVar(hWord,'CINSCFOR',TRBCN9->A2_INSCRM)
	Ole_SetDocumentVar(hWord,'CCONTFOR',TRBCN9->A2_XUSRSOL)
	Ole_SetDocumentVar(hWord,'CTELFOR',TRBCN9->A2_TEL)
	Ole_SetDocumentVar(hWord,'CEMAILFOR',TRBCN9->A2_EMAIL)
	Ole_SetDocumentVar(hWord,'COBJETO',MSMM(TRBCN9->CN9_CODOBJ))
	Ole_SetDocumentVar(hWord,'CVALOR1',ALLTRIM(TRANSFORM(TRBCN9->CN9_VLATU,"@E 999,999,999,999,999.99")))
	Ole_SetDocumentVar(hWord,'CVALOR2',Extenso(TRBCN9->CN9_VLATU))
	Ole_SetDocumentVar(hWord,'CCONDPG1',TRBCN9->E4_COND)
	Ole_SetDocumentVar(hWord,'CCONDPG2',TRBCN9->E4_DESCRI)
	Ole_SetDocumentVar(hWord,'CFAT1'," ")
	Ole_SetDocumentVar(hWord,'CCLAUSULAS',SZE->ZE_OBS1)
	Ole_SetDocumentVar(hWord,'CINDICE',TRBCN9->CN9_INDICE)
	Ole_SetDocumentVar(hWord,'CPENA1',SZE->ZE_OBS2)
	Ole_SetDocumentVar(hWord,'CPENA2',SZE->ZE_OBS3)
	Ole_SetDocumentVar(hWord,'COBRIGAT1',SZE->ZE_OBS4)
	Ole_SetDocumentVar(hWord,'COBRIGAT2',SZE->ZE_OBS5)
	Ole_SetDocumentVar(hWord,'CANEXO',SZE->ZE_OBS6)
	Ole_SetDocumentVar(hWord,'CDIA',xDia)
	Ole_SetDocumentVar(hWord,'CMES',xMes)
	Ole_SetDocumentVar(hWord,'CANO',xAno)
	*/
	OLE_UpdateFields(hWord)
	If File ( "c:\temp\"+cNewDoc)
		FErase( "c:\temp\a"+cNewDoc)
	EndIf
	
	Ole_SaveAsFile(hWord, "c:\temp\"+cNewDoc)
	
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
	__copyfile( "c:\temp\" + cNewDoc,"/web/pp/docs/" + cNewDoc)
	shellexecute( "open", cNewDoc, " ", "c:\temp\", 3 )
ELSE
	ALERT("CONTRATO SELECIONADO NÃO APRESENTA REGISTROS VALIDOS")
ENDIF
RETURN()