#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNLMKT01  �Autor  �LEANDRO DUARTE      � Data �  05/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA APRESENTAR O BOWSE PARA O MARKETING             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MNLMKT01()
LOCAL aCores  := {{ 'SA1->A1_MSBLQL=="1"' , 'DISABLE'},;    // Ativo
				  { 'SA1->A1_MSBLQL=="2"' , 'ENABLE' }}    // Inativo
 
PRIVATE cAlias   	:= "TRB"
PRIVATE aFixe		:= {}
Private cCpo		:= "A1_MSBLQL"
PRIVATE cCadastro 	:= "Consulta de Cliente"
PRIVATE aRotina     := {{"Pesquisar" , "AxPesqui"       , 0, 1 },;
						{"Legenda"   , "U_SA1LEG()"	, 0, 2 }}       //"Legenda"

aFixe := {}
cAlias := "SA1"
SX3->(DBSETORDER(1))
SX3->(DBSEEK("SA1"))
WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "SA1"
	IF SX3->X3_CONTEXT <> 'V'
		aadd(aFixe,{SX3->X3_TITULO, SX3->X3_CAMPO}) 
	endif
	SX3->(DBSKIP())
END
mBrowse(,,,,cAlias,aFixe, cCpo,,,,aCores,,,,,.f.,.t.,.t.,,,,)

RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SA1LEG    �Autor  �LEANDRO DUARTE      � Data �  05/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA APRESENTAR A TELA DE LEGENDA                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION SA1LEG()
BrwLegenda(cCadastro,"Legenda",{{'DISABLE',"Cliente Bloqueado"},;
								{'ENABLE',"Cliente Ativo"}})            
Return()