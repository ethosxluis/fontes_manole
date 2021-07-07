#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MNCOMA05  � Autor � Edmar Mendes Prado �Data �  18/04/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilhos para preenchimento de grupos no cadastro de       ���
���          � produtos													  ���
���          � Gatilho para o campo B1_GRUPO			   				  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Manole                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MNCOMA05()
                         
Local cGrupoTrib	:=	""

//Valida��o de produtos para o TIPO SS e grupos de CURSO

If M->B1_TIPO == "PA"

	If !(M->B1_GRUPO $ "4001/4002/4003")  
		Alert("Grupo de Produto invalido para esse Tipo PA - Produto Acabado")
		cGrupoTrib := " "
	ElseIf M->B1_GRUPO $ "4001"  	
		cGrupoTrib := "016"
	ElseIf M->B1_GRUPO $ "4002"   
		cGrupoTrib := "018"
	ElseIf M->B1_GRUPO $ "4003" 
		cGrupoTrib := "017"
	EndIf
	
ElseIf M->B1_TIPO	== "AI"

	If !(M->B1_GRUPO $ "2001")  
		Alert("Grupo de Produto invalido para esse Tipo AI - Ativo Fixo")
		cGrupoTrib := " "
	EndIf

ElseIf M->B1_TIPO	== "SS"

	If !(M->B1_GRUPO $ "3001/3002/3003/3004/3005/3006/3007")  
		Alert("Grupo de Produto invalido para esse Tipo SS - Servicos")
		cGrupoTrib := " "
	ElseIf M->B1_GRUPO $ "3001/3002/3003"
		cGrupoTrib := "013"
	ElseIf M->B1_GRUPO $ "3004/3005/3006/3007"
		cGrupoTrib := "003"
	EndIf

ElseIf M->B1_TIPO	== "MC"

	If !(M->B1_GRUPO $ "5001/5002")  
		Alert("Grupo de Produto invalido para esse Tipo MC - Material para Consumo")
		cGrupoTrib := " "
	EndIf		
		
EndIf

Return(cGrupoTrib)
