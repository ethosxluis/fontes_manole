#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNPRPIC   �Autor  �LEANDRO DUARTE      � Data �  03/29/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �RELATORIO DE PR� PIC                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 E P12                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


USER FUNCTION MNPRPIC()

Local oReport
PRIVATE aRecno:={}

//Configuracoes da pergunte AIA106 (Pedidos de Venda), ativado pela tecla F12:
PRIVATE nConfLote
PRIVATE nEmbSimul
PRIVATE nEmbalagem
PRIVATE nGeraNota
PRIVATE nImpNota
PRIVATE nImpEtVol
PRIVATE nEmbarque
PRIVATE nAglutPed
PRIVATE nAglutArm
//Configuracoes da pergunte AIA107 (Notas Fiscais), ativado pela tecla F12:
PRIVATE nEmbSimuNF
PRIVATE nEmbalagNF
PRIVATE nImpNotaNF
PRIVATE nImpVolNF
PRIVATE nEmbarqNF
//Configuracoes da pergunte AIA108 (Ordens de Producao), ativado pela tecla F12:
PRIVATE nReqMatOP
PRIVATE nAglutArmOP
PRIVATE nPreSep
PUBLIC cPed := ""

u_MNSEP01()

oReport := ReportDef()
oReport:PrintDialog()

u_MXTR730(cPed) // u_MATR731(cPed)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �LEANDRO DUARTE      � Data �  03/29/14   ���
�������������������������������������������������������������������������͹��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������͹��
���Uso       � P11 E P12                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()

Local oReport
Local cTitulo	:= "PR�-PIC"
Local cISBN		:= ""
Local cDesc		:= ""
Local nQtd		:= 0
Local cORDS		:= ""
Local cLoca		:= ""
Private cPerg   :=PADR("PREPIC001",10)


//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New(cPerg,cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cTitulo)
oReport:SetPortrait(.T.)
oReport:nfontbody:=10
//oReport:cfontbody:="Arial"

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
// regra para gravar a localiza��o do SIGAMAT.EMP
oEmpFil := TRSection():New(oReport,"BUSCA EM ESTOQUE",{"SC5"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)
oEmpFil:SetTotalInLine(.F.)
	//������������������������������������������������������������������������Ŀ
	//�Criacao da celulas da secao do relatorio                                �
	//�                                                                        �
	//�TRCell():New                                                            �
	//�ExpO1 : Objeto TSection que a secao pertence                            �
	//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
	//�ExpC3 : Nome da tabela de referencia da celula                          �
	//�ExpC4 : Titulo da celula                                                �
	//�        Default : X3Titulo()                                            �
	//�ExpC5 : Picture                                                         �
	//�        Default : X3_PICTURE                                            �
	//�ExpC6 : Tamanho                                                         �
	//�        Default : X3_TAMANHO                                            �
	//�ExpL7 : Informe se o tamanho esta em pixel                              �
	//�        Default : False                                                 �
	//�ExpB8 : Bloco de c�digo para impressao.                                 �
	//�        Default : ExpC2                                                 �
	//�                                                                        �
	//��������������������������������������������������������������������������

	TRCell():New(oEmpFil,"cORDS" ,/*Tabela*/,"Ordem de Separa��o",/*Picture*/,15,/*lPixel*/,{|| cORDS  })
	TRCell():New(oEmpFil,"cISBN" ,/*Tabela*/,"ISBN",/*Picture*/,TamSx3("B1_COD")[1],/*lPixel*/,{|| cISBN  })
	TRCell():New(oEmpFil,"cDesc" ,/*Tabela*/,"Nome",/*Picture*/,150,/*lPixel*/,{|| cDesc  })
	TRCell():New(oEmpFil,"cLoca" ,/*Tabela*/,"Endere�o",/*Picture*/,20,/*lPixel*/,{|| cLoca  })
	TRCell():New(oEmpFil,"nQtd" ,/*Tabela*/,"Quantidade",/*Picture*/,5,/*lPixel*/,{|| nQtd  })

//������������������������������������������������������������������������Ŀ
//� Impressao do Cabecalho no top da pagina                                �
//��������������������������������������������������������������������������
oReport:Section(1):SetHeaderPage()

//������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 									   �
//��������������������������������������������������������������������������

Pergunte(oReport:uParam,.F.)

Return(oReport)
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint�Autor  �LEANDRO DUARTE      � Data �  03/29/14   ���
��������������������������������������������������������������������������͹��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������͹��
���Uso       � P11 E P12                                                   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

Local cISBN		:= ""
Local cDesc		:= ""
Local nQtd		:= 0
Local cWhere	:= ""
Local cORDS		:= ""
Local cLoca		:= ""
Local cAliasTRB	:= GETNEXTALIAS()


//������������������������������������������������������������������������Ŀ
//� SetBlock: faz com que as variaveis locais possam ser                   �
//� utilizadas em outras funcoes nao precisando declara-las                �
//� como private.                                                          �
//��������������������������������������������������������������������������
oReport:Section(1):Cell("cORDS"	):SetBlock({|| 	cORDS	})
oReport:Section(1):Cell("cISBN"	):SetBlock({|| 	cISBN	})
oReport:Section(1):Cell("cDesc"	):SetBlock({|| cDesc	})
oReport:Section(1):Cell("cLoca" ):SetBlock({|| 	cLoca	})
oReport:Section(1):Cell("nQtd" 	):SetBlock({|| 	nQtd	})

cISBN		:= ""
cDesc		:= ""
nQtd		:= 0
cWhere		:= ""
cORDS		:= ""
cLoca		:= ""

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Posiciona SB1 para antes da impressao                                   �
//��������������������������������������������������������������������������
//TRPosition():New(oReport:Section(1),"SB1",1,{|| xFilial("SB1") + TRB->D2_COD })
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//�Obs: Utilizamos SetFilter no SD1 e nao Query pois e dado dbSeek         �
//�no SD1 na funcao CALCDEVR4.                                             �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//� Inclui Devolucao                                                       �
//��������������������������������������������������������������������������


	cAlias := GetNextAlias()

	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasTRB

		SELECT C.B1_COD, C.B1_DESC, E.CB8_ORDSEP, SUM(B.C6_QTDVEN) AS C6_QTDVEN, CB8_LCALIZ
		  FROM %table:SC5% A, %table:SC6% B, %table:SB1% C , %table:CB7% D, %table:CB8% E
		 WHERE A.%NotDel%
		   AND A.C5_FILIAL = %xFilial:SC5%
		   AND A.C5_EMISSAO >= %Exp:Dtos(DDATABASE-3)%
		   And A.C5_NOTA = ' '
		   And A.C5_BLQ = ' '
		   AND B.C6_FILIAL = %xFilial:SC6%
		   AND B.%NotDel%
		   AND B.C6_NUM = A.C5_NUM
		   AND C.B1_FILIAL = %xFilial:SB1%
		   AND C.%NotDel%
		   AND C.B1_COD = B.C6_PRODUTO
		   AND C.B1_XTIPO = '1'
		   AND A.C5_VTEX <> '  '
		   AND D.CB7_FILIAL = %xFilial:CB7%
		   AND D.%NotDel%
		   AND D.CB7_PEDIDO = A.C5_NUM
		   AND D.CB7_CLIENT = A.C5_CLIENTE
		   AND D.CB7_LOJA = A.C5_LOJACLI
		   AND D.CB7_DTEMIS = %Exp:Dtos(DDATABASE)%
		   AND E.CB8_FILIAL = %xFilial:CB8%
		   AND E.%NotDel%
		   AND E.CB8_PEDIDO = A.C5_NUM
		   AND E.CB8_SALDOS > 0
		   AND E.CB8_PROD = B.C6_PRODUTO
		   AND E.CB8_PEDIDO = D.CB7_PEDIDO
		   AND E.CB8_ORDSEP = D.CB7_ORDSEP
		   AND B.C6_TURNO = ' '
		GROUP BY C.B1_COD, C.B1_DESC, E.CB8_ORDSEP, CB8_LCALIZ
		ORDER BY 5, 4 DESC
	EndSql
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//������������������������������������������������������������������������Ŀ
//� Gera Arqiuvo Temporario                                                �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//� Notas de Saida                                                         �
//��������������������������������������������������������������������������

(cAliasTRB)->(dbGoTop())
oReport:Section(1):Init()
oReport:SetMeter(RecCount())
lPrt	:= .F.
While !oReport:Cancel() .And. !(cAliasTRB)->(Eof())
	lPrt	:= !lPrt
	cORDS	:= (cAliasTRB)->CB8_ORDSEP
	cISBN	:= (cAliasTRB)->B1_COD
	cDesc	:= (cAliasTRB)->B1_DESC
	nQtd	:= (cAliasTRB)->C6_QTDVEN
	cLoca	:= (cAliasTRB)->CB8_LCALIZ
	cPed 	+= Posicione("CB7",1,xfilial("CB7")+(cAliasTRB)->CB8_ORDSEP,"ALLTRIM(CB7_PEDIDO)")+"','"
	SC6->(DBSETORDER(2))
	IF SC6->(DBSEEK(xfilial("SC6")+cISBN+CB7->CB7_PEDIDO))
		reclock("SC6",.F.)
			SC6->C6_TURNO	:= '1' // processo para n�o rodar o pr� pic de novo
		MSUNLOCK()
	ENDIF
	if lPrt
		oReport:Section(1):Cell("cORDS"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cORDS"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("cISBN"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cISBN"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("cDesc"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cDesc"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("nQtd"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("nQtd"):SetClrBack(CLR_HGRAY) //cor do fundo
		oReport:Section(1):Cell("cLoca"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cLoca"):SetClrBack(CLR_HGRAY) //cor do fundo
	else
		oReport:Section(1):Cell("cORDS"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cORDS"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("cISBN"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cISBN"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("cDesc"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cDesc"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("nQtd"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("nQtd"):SetClrBack(CLR_WHITE) //cor do fundo
		oReport:Section(1):Cell("cLoca"):SetClrFore(CLR_BLACK) //cor da fonte
		oReport:Section(1):Cell("cLoca"):SetClrBack(CLR_WHITE) //cor do fundo
	endif
	oReport:Section(1):Cell("cORDS"	):Show()
	oReport:Section(1):Cell("cISBN"	):Show()
	oReport:Section(1):Cell("cDesc"	):Show()
	oReport:Section(1):Cell("cLoca"):Show()
	oReport:Section(1):Cell("nQtd"	):Show()
	oReport:Section(1):PrintLine()
	oReport:IncMeter()
	(cAliasTRB)->(dbskip())
EndDo

oReport:Section(1):SetTotalText("PR� PIC DA DATA DE: "+DTOC(DDATABASE-1)+" DATA AT�:"+DTOC(DDATABASE))
oReport:Section(1):Finish()
oReport:Section(1):Init()


oReport:Section(1):SetPageBreak()
(cAliasTRB)->(dbCloseArea())

Return


