#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNStVce   �Autor  �Leandro Duarte      � Data �  12/14/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �altera o status dos pedidos ja faturados para invoice quando���
���          �n�o houve a altera��o                                       ���
�������������������������������������������������������������������������͹��
���Uso       � p11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MNStVce()


  Local cQuery := "SELECT  A.C5_FILIAL,A.C5_VTEX, B.C6_NOTA||'-'||B.C6_SERIE as C6_NOTA  FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B WHERE A.D_E_L_E_T_ = ' ' AND B.C6_NOTA <> ' '  AND A.C5_INVOICE in ('2',' ') AND B.C6_FILIAL = A.C5_FILIAL AND B.C6_NUM = A.C5_NUM AND B.D_E_L_E_T_ = ' ' AND A.C5_VTEX <> '  '  AND B.C6_DATFAT >= '20201201' " //'20181001' "
//  Local cQuery := "SELECT  A.C5_FILIAL,A.C5_VTEX, B.C6_NOTA||'-'||B.C6_SERIE as C6_NOTA  FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B WHERE A.D_E_L_E_T_ = ' ' AND B.C6_NOTA <> ' '  AND A.C5_INVOICE in ('2',' ') AND B.C6_FILIAL = A.C5_FILIAL AND B.C6_NUM = A.C5_NUM AND B.D_E_L_E_T_ = ' ' AND A.C5_VTEX <> '  '  AND B.C6_DATFAT = '20191203' " 
//Local cQuery := "SELECT A.C5_FILIAL, A.C5_VTEX, B.C6_NOTA||'-'||B.C6_SERIE as C6_NOTA  FROM "+RETSQLNAME("SC5")+" A, "+RETSQLNAME("SC6")+" B WHERE A.D_E_L_E_T_ = ' ' AND B.C6_NOTA <> ' '  AND A.C5_INVOICE in ('2',' ') AND B.C6_FILIAL = A.C5_FILIAL AND B.C6_NUM = A.C5_NUM AND B.D_E_L_E_T_ = ' ' AND A.C5_VTEX <> '  '  AND A.C5_VTEX in ('980142237946-01')"

//����������������������������������������������������������������������������������������Ŀ
//�Processo Para ajustes os dados para a Vtex quando o pedido aqui no Protheus foi Faturado�
//������������������������������������������������������������������������������������������

IiF(SELECT("MNSTVCE")>0,MNSTVCE->(DBCLOSEAREA()),nil)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"MNSTVCE", .T., .T.)
CONOUT("ANALISANDO SE JA TRANSFORMOU OS PEDIDOS FATURADOS EM INVOICED")
WHILE MNSTVCE->(!EOF())
	conout("Processando a nota "+alltrim(MNSTVCE->C6_NOTA)+" do pedido da Vtex "+alltrim(MNSTVCE->C5_VTEX))
	U_libVtex(alltrim(MNSTVCE->C5_VTEX),alltrim(MNSTVCE->C6_NOTA))
	MNSTVCE->(DBSKIP())
	conout("saiu do LibVtex - mnstvce ")
END

//�����������������������������������������������������������������������������������������������������������������|�
//�Processo para as regras do Titulo para passar a informa��o para o Site da Vtex que estamos trabalhando no pedido�
//�����������������������������������������������������������������������������������������������������������������|�
cQuery := "SELECT A.C5_FILIAL,A.C5_VTEX, A.C5_INVOICE, A.C5_NOSSONU, R_E_C_N_O_  as REC  FROM "+RETSQLNAME("SC5")+" A WHERE A.D_E_L_E_T_ = ' ' AND A.C5_SEQ IN (' ','2') AND A.C5_VTEX <> ' ' "
//cQuery := "SELECT A.C5_FILIAL, A.C5_VTEX, A.C5_INVOICE, A.C5_NOSSONU, R_E_C_N_O_  as REC  FROM "+RETSQLNAME("SC5")+" A WHERE A.D_E_L_E_T_ = ' ' AND A.C5_SEQ IN (' ','2') AND A.C5_VTEX <> ' ' AND A.C5_VTEX in ('1101122726363-01') "
IiF(SELECT("MNSTVCE")>0,MNSTVCE->(DBCLOSEAREA()),nil)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"MNSTVCE", .T., .T.)
CONOUT("ANALISANDO SE OS PEDIDOS PODEM SER TRANSFORMADO EM START HANGLED")
WHILE MNSTVCE->(!EOF())
	conout("AnaliPed "+alltrim(MNSTVCE->C5_NOSSONU)+" do pedido da Vtex "+alltrim(MNSTVCE->C5_VTEX))
	AnaliPed(ALLTRIM(MNSTVCE->C5_NOSSONU),MNSTVCE->REC, MNSTVCE->C5_VTEX, MNSTVCE->C5_INVOICE)
	conout("saiu do analiped - 002 ")
	MNSTVCE->(DBSKIP())
END

//������������������������������������������������������������������������������������������������������Ŀ
//�Processando as tabelas de integra��o para deixar elas com os dados excluidos, para dinamizar a rotina �
//��������������������������������������������������������������������������������������������������������
UA1->(DBSETORDER(3))
For nFor4 := 1 to 3
	UA1->(DBSEEK(XFILIAL("UA1")+'1'+cValtoChar(nFor4)))
	cVelhoArq := u_Velhoarq(cValtoChar(nFor4))  // captura o nome da tabela de cliente, pedidos e detalhe do pedido
	iif(SELECT("TABPROC")>0,TABPROC->(DbCloseArea()),nil)
	dbUseArea(.T.,,cVelhoArq,"TABPROC", .T., .F. )
	while !(select("TABPROC")>0)
		dbUseArea(.T.,,cVelhoArq,"TABPROC", .T., .F. )
	end
	//CONOUT("LIMPANDO A TABELA "+CVELHOARQ+" PARA DEIXAR MAIS RAPIDO O PROCESSAMENTO" )
	TABPROC->(DBGOTOP())
	WHILE TABPROC->(!EOF())
		IF TABPROC->UXU_PROQUE == 1
			RECLOCK("TABPROC")
			DBDELETE()
			MSUNLOCK()
		ENDIF
		TABPROC->(DBSKIP())
	END
	//TABPROC->(__DBPack())
next nFor4

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AnaliPed  �Autor  �Leandro Duarte      � Data �  12/16/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que efetua a troca do pedido caso ele ja tenha sido  ���
���          �lido pelo portal da educacao                                ���
�������������������������������������������������������������������������͹��
���Uso       � p12 e p11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION AnaliPed(cIdPedido, nRec, cVetx, cInvoiced)
//Local cUrlProc 	:= "https://vtex.manoleeducacao.com.br/checkorder.php?ped_id="+cIdPedido
Local cUrlProc 	:= "http://vtex.manoleeducacao.com.br/checkorder.php?ped_id="+cIdPedido
local oxml
Local sPostRet := ""
local lXml := .f.
private cParam   := ""
private aHeadOut := {}
private oXMLped

//ARRAY COM OS DADOS DE HEADER PARA O JSON

aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/json')

// COMUNICA COM O WEBSERVICE
// SERVE PARA INFORMAR QUE ESTOU TRABALHANDO COM ESSE PEDIDO  PARA N�O PEGA-LO NOVAMENTE
sPostRet := HttpPOST(cUrlProc,"","",,aHeadOut)	
sPostRet := DecodeUtf8(sPostRet)
Lxml := FWJsonDeserialize(sPostRet,@oxml)
			
conout('AnaliPed - 001 - Antes do IF lXml')

IF lXml
	conout('AnaliPed - 002 - Entrei no IF lXml')
	if upper(oxml:CAPTURADO) == 'SIM' .OR. cInvoiced == '1'
		conout('AnaliPed - 003 - Entrei no IF capturado ou invoice ' + cIdPedido)
		SC5->(DBGOTO(nRec))
		RECLOCK("SC5",.F.)
		SC5->C5_SEQ := '1'
		MSUNLOCK()
		conout('AnaliPed - 004 - C5_SEQ alterado do pedido '+ cIdPedido)
		u_AltPed(alltrim(cVetx))
		conout('AnaliPed - 005 - STATUS alterado na VTEX '+ cIdPedido)
	endif

endif

Return
