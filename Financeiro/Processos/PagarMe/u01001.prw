/*
{Protheus.doc} U01001
Função de instalação de dicionario especifico.
@author	FsTools V6.2.14
@since 14/05/2018
@param lOnlyInfo Indica se deve retornar so as informacoes sobre o update ou todos os ajustes a serem realizados
@Project NÃO IDENTIFICADO
@Obs Fontes: FIETHX01.PRW
@Obs manual desmark
*/
#INCLUDE 'PROTHEUS.CH'
User Function U01001(lOnlyInfo)
Local aInfo := {'01','001','INTEGRACAO PAGAR.ME','14/05/18','11:03','001843012010100511U0110','14/05/18','11:03','843110051201'}
Local aSIX	:= {}
Local aSX1	:= {}
Local aSX2	:= {}
Local aSX3	:= {}
Local aSX6	:= {}
Local aSX7	:= {}
Local aSXA	:= {}
Local aSXB	:= {}
Local aSX3Hlp := {}
Local aCarga  := {}
DEFAULT lOnlyInfo := .f.
If lOnlyInfo
	Return {aInfo,aSIX,aSX1,aSX2,aSX3,aSX6,aSX7,aSXA,aSXB,aSX3Hlp,aCarga}
EndIf
aAdd(aSIX,{'SE1','T','E1_FILIAL+E1_PGVTTID+E1_PARCELA+E1_PREFIXO','E1_PGVTTID+E1_PARCELA+E1_PREFIXO','E1_PGVTTID+E1_PARCELA+E1_PREFIXO','E1_PGVTTID+E1_PARCELA+E1_PREFIXO','U','','IDVETEX','N','','','2018051411:02:21'})
aAdd(aSX6,{'','FS_PAGAGEN','C','Agencia da integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
aAdd(aSX6,{'','FS_PAGBANC','C','Banco da integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
aAdd(aSX6,{'','FS_PAGCLI','C','Codigo cliente da integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
aAdd(aSX6,{'','FS_PAGCONT','C','Conta da integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
aAdd(aSX6,{'','FS_PAGLOJA','C','Loja cliente da integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
aAdd(aSX6,{'','FS_PAGTIPO','C','Tipo do titulo da integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
aAdd(aSX6,{'','FS_PAGNATU','C','Natureza titulo integracao Pagar.me','','','','','','','','','','','','U','N','','','','','','2018051411:02:23'})
Return {aInfo,aSIX,aSX1,aSX2,aSX3,aSX6,aSX7,aSXA,aSXB,aSX3Hlp,aCarga}
