#include "protheus.ch"   
#include "rwmake.ch"

#Define ENTER Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TELCOR01 � Autor � FONTANELLI         � Data �  02/06/16   ���
�������������������������������������������������������������������������͹��
���Descricao � TIPO DE SERVI�O DO CORREIO                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANOLE                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
              
// U_TELCOR01()

User Function TELCOR01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Tipo de Servi�o do Correio"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := {  	{"Pesquisar"    ,"AxPesqui"		,0,1} ,;                   
						{"Visualizar"   ,"AxVisual"  	,0,2} ,;
						{"Incluir"      ,"AxInclui"  	,0,3} ,;                   
						{"Alterar"      ,"AxAltera"  	,0,4} ,;
						{"Excluir"      ,"AxDeleta"  	,0,5}		}
							
					
dbSelectArea("UA4")
dbSetOrder(1)
mBrowse(6,1,22,75,"UA4",,,,,,)
Set Key 123 To

Return

