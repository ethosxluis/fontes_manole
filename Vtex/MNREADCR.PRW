#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNREADCR  �Autor  �LEANDRO DUARTE      � Data �  10/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA DE LEITURA DO RETORNO DO ALYOUT DO CART�O DE CREDITO ���
���          �PARA BAIXAR O TITULO                                        ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function MNREADCR()
Local aBotoes	:= {}
Local aSays		:= {}
Local aPergunt	:= {}
Local nOpcao	:= 0
Local oRegua    := Nil

//Parametros da rotina
mv_par01	:= space(150)

//Tela de aviso e acesso aos parametros
AAdd(aSays,"[LEITURA DOS PAGAMENTOS EM CART�ES/CNAB SEM REGISTRO] VER.1 ")
AAdd(aSays,"Esse programa ir� importar os pagamentos dos pedidos do portal Vtex por cart�o de credito ")
AAdd(aSays,"na base do Protheus..")
Pergunte("MNREADCR",.F.)

AAdd(aBotoes,{ 5,.T.,{|| mv_par01 := cGetFile( "Arquivo Texto (*.TXT)|*.txt|Arquivo CSV (*.CSV)|*.csv|Retorno de CNB (*.RET)|*.RET", 'Selecione o Arquivo Texto para Importa��o', 0,, .T. )  } } )
AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )
FormBatch( "[LEITURA DOS PAGAMENTOS EM CART�ES] VER.1 ", aSays, aBotoes )

If nOpcao == 1
	Processa({|| MNREADCA() })
EndIf

RETURN()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNREADCA  �Autor  �LEANDRO DUARTE      � Data �  10/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � ROTINA PARA LER O ARQUIVO ACHAR O TITULO E BAIXAR O TITULO ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION MNREADCA()
Local bQuerySE1			:= {|| Iif(Select("TRB_SE1") > 0, TRB_SE1->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_SE1",.T.,.T.) , dbSelectArea("TRB_SE1"),TRB_SE1->(dbGoTop())}
Local aDados			:= {}
Local cLinha			:= ""
Local nLog				:= 0
Local aMotBaixa 		:= ReadMotBx()
Local cCodMotBx 		:= "NOR"						&& Codigo do Motivo de Baixa utilizado para baixa dos titulos
Local lMotExist 		:= Iif(Ascan(aMotBaixa, {|x| Substr(x,1,3) = Upper(cCodMotBx) })>0,.T.,.F.)
Local lMotBxMov 		:= MovBcoBx(cCodMotBx)
Local aBaixa			:= {}
Local lNoBrowse 		:= .F.
Local nOpcBaixa			:= 0
Local nCartao			:= 0
Local aPar := {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
private lMSHelpAuto := .F.
private lMsErroAuto := .F.

If !File(mv_par01)
	MsgAlert("Aten��o, o arquivo informado n�o foi localizado.")
	RETURN()
EndIf

FT_FUse(mv_par01)
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()
if aviso("Aten��o","Voce esta Rodando que Tipo de Arquivo?",{"CREDITO","CNAB"}) == 1
	FT_FSkip() // PULA A LINHA
	nCartao := 1
endif
FT_FSkip() // PULA A LINHA

/*
LAYOUT
1 - NUMERO DO CART�O TID
2 - DESCRI��O CONTEM A INFORMA��O DA PARCELA
3 - VALOR TOTAL DA VENDA
4 - VALOR DA PARCELA
5 - RESUMO APRESENTA SE � CREDITO OU DEBITO
*/
While !FT_FEof()
	IncProc("EFETUANDO A LEITURA/BAIXA DO ARQUIVO")
	lMSHelpAuto := .F.
	lMsErroAuto := .F.
	cLinha		:= FT_FReadLn()
	if nCartao == 0
		aDados		:= leCnab(cLinha)
	else
		aDados		:= StrTOArray(cLinha,';')
		for nFor := 1 to len(aDados)
			aDados[nFor] := replace(aDados[nFor],'"','')
		next nFor
		aDados[5]	:= VAL(replace(replace(aDados[5],'.',''),',','.'))
		aDados[2]	:= CTOD(aDados[2])
	endif
	if LEN(aDados)>0
		cQuery := " SELECT * "
		cQuery += " FROM " + RetSQLName("SE1")
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
		cQuery += "   AND E1_STATUS <> 'B' "
		cQuery += "   AND E1_TIPO <> 'NCC' "
		if nCartao == 0
			cQuery += "   AND E1_NOSSVTX = '" + aDados[1] + "' "
		else
			cQuery += "   AND E1_PGVTTID = '" + aDados[1] + "' "
		endif
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		if nCartao != 0 .and. at("/",aDados[4]) > 0
			cQuery += "   AND E1_PARCELA = '" + aPar[val(alltrim(substr(aDados[4],at("/",aDados[4])-2,2)))] + "' "
		endif
		Eval(bQuerySE1)
		begin Transaction
		//���������������������������������
		//�ROTINA PARA EXECUTAR O EXECAUTO�
		//���������������������������������
		// Monta array a ser utilizado para baixa
		while TRB_SE1->(!EOF())
			aBaixa	:= {	{"E1_PREFIXO",		TRB_SE1->E1_PREFIXO,				Nil},;
							{"E1_NUM",			TRB_SE1->E1_NUM,					Nil},;
							{"E1_PARCELA",		TRB_SE1->E1_PARCELA,				Nil},;
							{"E1_TIPO",			TRB_SE1->E1_TIPO,					Nil},;
							{"AUTMOTBX",		cCodMotBx,							Nil},;
							{"AUTVALREC",		iif(TRB_SE1->E1_SALDO>=aDados[5],aDados[5],TRB_SE1->E1_SALDO),							Nil},;
							{"AUTDTBAIXA",		IIF(aDados[2]>STOD(TRB_SE1->E1_EMISSAO),aDados[2],iif(STOD(TRB_SE1->E1_VENCREA)>ddatabase,STOD(TRB_SE1->E1_EMISSAO),STOD(TRB_SE1->E1_VENCREA))),			Nil},;
							{"AUTHIST",			"Baixa por Cart�o de credito", 		Nil},;
							{"E1_DESCONT",		IIF(nCartao == 0,aDados[7],0),		Nil},;
							{"E1_MULTA",		IIF(nCartao == 0,aDados[6],0),		Nil},;
							{"E1_JUROS",		0,									Nil},;
							{"E1_VALJUR",		0,									Nil},;
							{"AUTDTCREDITO",	IIF(aDados[2]>STOD(TRB_SE1->E1_EMISSAO),aDados[2],iif(STOD(TRB_SE1->E1_VENCREA)>ddatabase,STOD(TRB_SE1->E1_EMISSAO),STOD(TRB_SE1->E1_VENCREA))), Nil}}

			SE1->(DBGOTO(TRB_SE1->R_E_C_N_O_))
			aDados[5]	-= TRB_SE1->E1_SALDO
			//�����������������������������������������������������������������������������������������������Ŀ
			//�Regra do Calculo das dizimas periodicas                                                        �
			//�conforme foi passado pelo Leandro Financeiro a Contabilidade Planus pediu para colocar em Juros�
			//�������������������������������������������������������������������������������������������������
			if aDados[5]<=0.5 .and. aDados[5] > 0
				aBaixa[10][2] := aDados[5]
			endif
			if 	aBaixa[6][2] > 0
				MSExecAuto({|x, y | FINA070(x, y )}, aBaixa, 3)

				//�����������Ŀ
				//�GRAVA O LOG�
				//�������������
				If lMSErroAuto
					mostraerro()
					DisarmTransaction()
				Endif
			endif
			TRB_SE1->(DBSKIP())
		END
		End Transaction
	endif
	aBaixa	:= {}
	FT_FSkip()
EndDo

Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �StrTOArray�Autor  �Leandro Duarte      � Data �  10/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para converter a string com o separador passado em   ���
���          �array                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � p11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function StrTOArray(cLinha,cSeparador)
Local aVetor	:= {}

while at(cSeparador,cLinha) > 0
	aadd(aVetor,substr(cLinha,1,at(cSeparador,cLinha)-1))
	cLinha := substr(cLinha,at(cSeparador,cLinha)+1)
end
aadd(aVetor,substr(cLinha,1))
Return(aVetor)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �leCnab    �Autor  �Leandro Duarte      � Data �  12/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de leitura do arquivo Cnab para pegar os dados neces ���
���          �sarios                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � p12                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function leCnab(cLinha)
Local aRet 		:= {}
Local cNsNum1	:= cValtoChar(val(substr(cLinha,71,11)))
Local cNsNum	:= cValtoChar(val(substr(cLinha,71,12)))
Local cVALOR	:= substr(cLinha,153,13)

if !empty(cNsNum1)
	cQuery 	:= " SELECT R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_FILIAL = '"+xFilial("SE1")+"' AND A.D_E_L_E_T_ = ' ' AND A.E1_NOSSVTX = '"+cNsNum1+"' "
	Iif(Select("TMPLOG") > 0,TMPLOG->(dbCloseArea()),nil)
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPLOG", .T., .T.)
	IF TMPLOG->(!EOF())
		SE1->(dbgoto(TMPLOG->REC))
		RECLOCK("SE1",.F.)
		SE1->E1_NUMBCO  := STRZERO(VAL(cNsNum),12)
		SE1->E1_IDCNAB	:= STRZERO(VAL(cNsNum),10)
		MSUNLOCK()
		aRet 		:= {SE1->E1_NOSSVTX,;
		'',;
		'',;
		'',;
		VAL(cVALOR)/100,;
		IIF(VAL(cVALOR)/100>SE1->E1_VALOR,(VAL(cVALOR)/100)-SE1->E1_VALOR,0),;
		IIF(VAL(cVALOR)/100<SE1->E1_VALOR,SE1->E1_VALOR - (VAL(cVALOR)/100),0)}
	ELSE
		cQuery 	:= " SELECT R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SE1")+" A WHERE A.E1_FILIAL = '"+xFilial("SE1")+"' AND A.D_E_L_E_T_ = ' ' AND A.E1_NUM IN ( SELECT A.C5_NOTA FROM "+RETSQLNAME("SC5")+" A WHERE A.C5_NOSSONU = '"+cNsNum1+"' AND A.D_E_L_E_T_ = ' ' )"
		Iif(Select("TMPLOG") > 0,TMPLOG->(dbCloseArea()),nil)
		cQuery := ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPLOG", .T., .T.)
		IF TMPLOG->(!EOF())
			SE1->(dbgoto(TMPLOG->REC))
			RECLOCK("SE1",.F.)
			SE1->E1_NUMBCO  := STRZERO(VAL(cNsNum),12)
			SE1->E1_IDCNAB	:= STRZERO(VAL(cNsNum),10)
			SE1->E1_NOSSVTX	:= cNsNum1
			MSUNLOCK()
			aRet 		:= {SE1->E1_NOSSVTX,;
			'',;
			'',;
			'',;
			VAL(cVALOR)/100,;
			IIF(VAL(cVALOR)/100>SE1->E1_VALOR,(VAL(cVALOR)/100)-SE1->E1_VALOR,0),;
			IIF(VAL(cVALOR)/100<SE1->E1_VALOR,SE1->E1_VALOR - (VAL(cVALOR)/100),0)}
		ENDIF
	ENDIF
endif
Return(aRet)



