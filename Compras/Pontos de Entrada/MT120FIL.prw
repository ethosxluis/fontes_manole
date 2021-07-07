#include "rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120FIL  � Autor � Edmar Mendes Prado �Data �  28/03/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro no browse do pedido de compras                      ���
���          � Cada comprador visualiza somente o seu pedido              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Manole                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120FIL

Local cArea    := GetArea()
Local _cCondicao := " "
Local _cUserFlt	 := SuperGetMV("MV_MNLPEDC")
Local _GrpManEdu := '000093'		
Local lGrupManEdu := .F.
Local aGrupos := UsrRetGrp(cUserName)	// Carrega os grupos do usu�rio
Local nI := 0

For nI := 1 to Len(aGrupos)

	//Grupo Manole Educacao - Prestacao de servi�os - em que todos podem imprimir
	If aGrupos[nI] == _GrpManEdu
		lGrupManEdu	:=	.T.
	Endif
	
Next nI

//MsgAlert(Upper(Alltrim(Substr(cUsuario,7,15))))   
If !Upper(Alltrim(Substr(cUsuario,7,15))) $ _cUserFlt .And. lGrupManEdu == .F.
	_cCondicao += " C7_USER = __cUserID "
	//MsgAlert("001 - Passei aqui")
ElseIf lGrupManEdu == .T.
	_cCondicao += " C7_APROV = '000014' "
	//MsgAlert("002 - Passei aqui")
EndIf


RestArea(cArea)
Return _cCondicao