#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNDPTAB   �Autor  �leandro durte       � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotin para saber se deve ou n�o criar a tabela com a estrutu���
���          �ra localizada na UA1                                        ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MNDPTAB(lBANCO)
Local aStruVT	:= {}
Local aStruPH	:= {}
Local aStruVL	:= {}
Local cArq		:=	cNovoArq	:=	cVelhoArq	:= ""
Local cMemo		:= ""
Local lRet		:= .F.
Local aRet		:= {}
Local nFor		:= 0
Local nFor1		:= 0

UA1->(DBSETORDER(3))
// CADASTRO DE CLIENTE
if UA1->(DBSEEK(XFILIAL("UA1")+'1'+'1')) // FILIAL + ATIVO + ROTINA + COD + VERSAO
	cVelhoArq := Velhoarq()
	//��������������������������������������������������������������������������Ŀ
	//�L� os dados da tabela para saber se existe estrutura de cria��o temporaria�
	//����������������������������������������������������������������������������
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aadd(aStruVT,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aStruVT[LEN(aStruVT)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
	END

	//�������������������������������������������������������������������������������Ŀ
	//�Cria a estrutura temporaria para efetuar a compara��o da estrutura ja existente�
	//���������������������������������������������������������������������������������
	SX3->(dbsetorder(2))
	For nFor := 1 to len(aStruVT)
		if SX3->(DBSEEK(alltrim(aStruVT[nFor][2]))) .AND. ASCAN(aStruPH,{|Z| Z[1] == PADR(aStruVT[nFor][2],10) }) <= 0
			AAdd( aStruPH , {  SX3->X3_CAMPO , SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL } )
		endif
	Next nFor
	AAdd( aStruPH , {  'UXU_PROQUE' , 'N' , 1 , 0 } )

	//��������������������������������������������������������������������������������������Ŀ
	//�Efetua a compara��o da estrutura lida e da que ja existe para recriar a nova estrutura�
	//����������������������������������������������������������������������������������������
	IF lBANCO
		if U_listbl(cVelhoArq,0,"TRBOLD")// VERIFICA SE EXISTE A TABELA
			aStruVL := U_listbl(cVelhoArq,1,"TRBOLD")// le a estrutura do banco 
			for nFor1 := 1 to len(aStruVL)
				if aScan(aStruPH,{|z| z[1] == aStruVL[nFor1][1]})==0
					lRet	:= .T.
				endif
			next nFor1
			//�����������������������������������������������������������������������������������������������������������Ŀ
			//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
			//�������������������������������������������������������������������������������������������������������������
			lEXCLU := .t.
			TRBOLD->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
			TRBOLD->(DBCLOSEAREA())
			if lEXCLU .or. lRet
				U_listbl(cVelhoArq,3,"TRBOLD")//drop a estrutura e a base 
			else
				U_listbl(cVelhoArq,5,"TRBOLD")//Limpa os deletados
				aadd(aRet,{'1',cVelhoArq})
			endif
		endif
	ELSE
		if !empty(cVelhoArq) .or. file(cVelhoArq+'.dtc')
			DbUseArea(.t.,,cVelhoArq,"TRBOLD",.T.)
			if select("TRBOLD") <= 0
				aStruVL := TRBOLD->(DBSTRUCT())
				for nFor1 := 1 to len(aStruVL)
					if aScan(aStruPH,{|z| z[1] == aStruVL[nFor1][1]})==0
						lRet	:= .T.
					endif
				next nFor1
				if !lRet
					for nFor1 := 1 to len(aStruPH)
						if aScan(aStruVL,{|z| z[1] == aStruPH[nFor1][1]})==0
							lRet	:= .T.
						endif
					next nFor1
				endif
			else
				//�����������������������������������������������������������������������������������������������������������Ŀ
				//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
				//�������������������������������������������������������������������������������������������������������������
				lEXCLU := .F.
				TRBOLD->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
				TRBOLD->(DBCLOSEAREA())
				if lEXCLU
					ferase(cVelhoArq)
				else
					aadd(aRet,{'1',cVelhoArq})
				endif
			endif
		endif
	ENDIF
	//���������������������������������������������8�
	//�Cria a nova estrutura para trabalhar com ela�
	//���������������������������������������������8�
	cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
	if lBANCO
		if U_listbl(cNovoArq,0,"TRBATU")// VERIFICAR SE EXISTE A TABELA
			IF lRet
				U_listbl(cVelhoArq,3,"TRBATU",aStruPH)// DROPA A TABELA
				U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
			else
				U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
			endif
		else
			cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
			U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
		endif
	ELSE
		if file(cNovoArq+'.dtc') .or. file(cNovoArq+'.dbf')
			DbUseArea(.t.,,cNovoArq,"TRBATU",.T.)
			if select("TRBATU") <= 0
				cNovoArqq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
				if cNovoArqq != cNovoArq
					dbCreate(cNovoArqq,aStruPH, __LocalDriver )
				endif
				cNovoArq := cNovoArqq
			Elseif lRet
				cNovoArqq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
				if cNovoArqq != cNovoArq
					dbCreate(cNovoArqq,aStruPH, __LocalDriver )
				endif
				cNovoArq := cNovoArqq
			endif
			//�����������������������������������������������������������������������������������������������������������Ŀ
			//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
			//�������������������������������������������������������������������������������������������������������������
			lEXCLU := .F.
			TRBATU->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
			iif(SELECT("TRBATU")>0,TRBATU->(DbCloseArea()),nil)
			if lEXCLU
				ferase(cNovoArq)
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
		   		dbCreate(cNovoArq,aStruPH, __LocalDriver )
			endif
		else
			cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
			dbCreate(cNovoArq,aStruPH, __LocalDriver )
		endif
	ENDIF
	aadd(aRet,{'1',cNovoArq})
endif
aStruVT := {}
// CABE�ALHO DE PEDIDO
if UA1->(DBSEEK(XFILIAL("UA1")+'1'+'2')) // FILIAL + ATIVO + ROTINA + COD + VERSAO
	cVelhoArq := Velhoarq()
	//��������������������������������������������������������������������������Ŀ
	//�L� os dados da tabela para saber se existe estrutura de cria��o temporaria�
	//����������������������������������������������������������������������������
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aadd(aStruVT,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aStruVT[LEN(aStruVT)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
	END
	aStruPH := {}
	//�������������������������������������������������������������������������������Ŀ
	//�Cria a estrutura temporaria para efetuar a compara��o da estrutura ja existente�
	//���������������������������������������������������������������������������������
	SX3->(dbsetorder(2))
	For nFor := 1 to len(aStruVT)
		if SX3->(DBSEEK(alltrim(aStruVT[nFor][2]))) .AND. ASCAN(aStruPH,{|Z| Z[1] == PADR(aStruVT[nFor][2],10) }) <= 0
			AAdd( aStruPH , {  SX3->X3_CAMPO , SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL } )
		endif
	Next nFor
	AAdd( aStruPH , {  'UXU_PROQUE' , 'N' , 1 , 0 } )

	//��������������������������������������������������������������������������������������Ŀ
	//�Efetua a compara��o da estrutura lida e da que ja existe para recriar a nova estrutura�
	//����������������������������������������������������������������������������������������
	if lBanco
		if U_listbl(cVelhoArq,0,"TRBOLD")// VERIFICA SE EXISTE A TABELA
			aStruVL := U_listbl(cVelhoArq,1,"TRBOLD")// le a estrutura do banco 
			for nFor1 := 1 to len(aStruVL)
				if aScan(aStruPH,{|z| z[1] == aStruVL[nFor1][1]})==0
					lRet	:= .T.
				endif
			next nFor1
			//�����������������������������������������������������������������������������������������������������������Ŀ
			//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
			//�������������������������������������������������������������������������������������������������������������
			lEXCLU := .f.
			TRBOLD->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
			TRBOLD->(DBCLOSEAREA())
			if lEXCLU .or. lRet
				U_listbl(cVelhoArq,3,"TRBOLD")//drop a estrutura e a base 
			else
				U_listbl(cVelhoArq,5,"TRBOLD")//Limpa os deletados
				aadd(aRet,{'1',cVelhoArq})
			endif
		endif
	else
		if !empty(cVelhoArq)
			DbUseArea(.t.,,cVelhoArq,"TRBOLD",.T.)
			if select("TRBOLD") <= 0
				aStruVL := TRBOLD->(DBSTRUCT())
				for nFor1 := 1 to len(aStruVL)
					if aScan(aStruPH,{|z| z[1] == aStruVL[nFor1][1]})==0
						lRet	:= .T.
					endif
				next nFor1
				if !lRet
					for nFor1 := 1 to len(aStruPH)
						if aScan(aStruVL,{|z| z[1] == aStruPH[nFor1][1]})==0
							lRet	:= .T.
						endif
					next nFor1
				endif
			else
				//�����������������������������������������������������������������������������������������������������������Ŀ
				//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
				//�������������������������������������������������������������������������������������������������������������
				lEXCLU := .F.
				TRBOLD->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
				TRBOLD->(DBCLOSEAREA())
				if lEXCLU
					ferase(cVelhoArq)
				else
					aadd(aRet,{'1',cVelhoArq})
				endif
			endif
		endif
	endif
	//���������������������������������������������8�
	//�Cria a nova estrutura para trabalhar com ela�
	//���������������������������������������������8�
	cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
	if lBANCO
		if U_listbl(cNovoArq,0,"TRBATU")// VERIFICAR SE EXISTE A TABELA
			IF lRet
				U_listbl(cVelhoArq,3,"TRBATU",aStruPH)// DROPA A TABELA
				U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
			else
				U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
			endif
		else
			cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
			U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
		endif
	else
		if file(cNovoArq+'.dtc') .or. file(cNovoArq+'.dbf')
			DbUseArea(.t.,,cNovoArq,"TRBATU",.T.)
			if select("TRBATU") <= 0
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
				dbCreate(cNovoArq,aStruPH, __LocalDriver )
			Elseif lRet
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
				dbCreate(cNovoArq,aStruPH, __LocalDriver )
			endif
			//�����������������������������������������������������������������������������������������������������������Ŀ
			//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
			//�������������������������������������������������������������������������������������������������������������
			lEXCLU := .F.
			TRBATU->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
			iif(SELECT("TRBATU")>0,TRBATU->(DbCloseArea()),nil)
			if lEXCLU
				ferase(cNovoArq)
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
		   		dbCreate(cNovoArq,aStruPH, __LocalDriver )
			endif
		else
			cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
			dbCreate(cNovoArq,aStruPH, __LocalDriver )
		endif
	endif
	aadd(aRet,{'2',cNovoArq})
endif
aStruVT := {}
// DETALHE DE PEDIDO
if UA1->(DBSEEK(XFILIAL("UA1")+'1'+'3')) // FILIAL + ATIVO + ROTINA + COD + VERSAO
	cVelhoArq := Velhoarq()
	//��������������������������������������������������������������������������Ŀ
	//�L� os dados da tabela para saber se existe estrutura de cria��o temporaria�
	//����������������������������������������������������������������������������
	cMemo	:= ALLTRIM(UA1->UA1_DEPARA)
	WHILE AT('|',cMemo) >0
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aadd(aStruVT,{SUBSTR(cMemo,1,AT(';',cMemo)-1),NIL})
		cMemo	:= SUBSTR(cMemo,AT(';',cMemo)+1)
		aStruVT[LEN(aStruVT)][2] := alltrim(SUBSTR(cMemo,1,AT('|',cMemo)-1))
		cMemo	:= SUBSTR(cMemo,AT('|',cMemo)+1)
	END
	aStruPH := {}
	//�������������������������������������������������������������������������������Ŀ
	//�Cria a estrutura temporaria para efetuar a compara��o da estrutura ja existente�
	//���������������������������������������������������������������������������������
	SX3->(dbsetorder(2))
	For nFor := 1 to len(aStruVT)
		if SX3->(DBSEEK(alltrim(aStruVT[nFor][2]))) .AND. ASCAN(aStruPH,{|Z| Z[1] == PADR(aStruVT[nFor][2],10) }) <= 0
			AAdd( aStruPH , {  SX3->X3_CAMPO , SX3->X3_TIPO , SX3->X3_TAMANHO , SX3->X3_DECIMAL } )
		endif
	Next nFor
	AAdd( aStruPH , {  'UXU_PROQUE' , 'N' , 1 , 0 } )

	//��������������������������������������������������������������������������������������Ŀ
	//�Efetua a compara��o da estrutura lida e da que ja existe para recriar a nova estrutura�
	//����������������������������������������������������������������������������������������
	if lBanco
		if U_listbl(cVelhoArq,0,"TRBOLD")// VERIFICA SE EXISTE A TABELA
			aStruVL := U_listbl(cVelhoArq,1,"TRBOLD")// le a estrutura do banco 
			for nFor1 := 1 to len(aStruVL)
				if aScan(aStruPH,{|z| z[1] == aStruVL[nFor1][1]})==0
					lRet	:= .T.
				endif
			next nFor1
			//�����������������������������������������������������������������������������������������������������������Ŀ
			//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
			//�������������������������������������������������������������������������������������������������������������
			lEXCLU := .f.
			TRBOLD->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
			TRBOLD->(DBCLOSEAREA())
			if lEXCLU .or. lRet
				U_listbl(cVelhoArq,3,"TRBOLD")//drop a estrutura e a base 
			else
				U_listbl(cVelhoArq,5,"TRBOLD")//Limpa os deletados
				aadd(aRet,{'1',cVelhoArq})
			endif
		endif
	else
		if !empty(cVelhoArq)
			DbUseArea(.t.,,cVelhoArq,"TRBOLD",.T.)
			if select("TRBOLD") <= 0
				aStruVL := TRBOLD->(DBSTRUCT())
				for nFor1 := 1 to len(aStruVL)
					if aScan(aStruPH,{|z| z[1] == aStruVL[nFor1][1]})==0
						lRet	:= .T.
					endif
				next nFor1
				if !lRet
					for nFor1 := 1 to len(aStruPH)
						if aScan(aStruVL,{|z| z[1] == aStruPH[nFor1][1]})==0
							lRet	:= .T.
						endif
					next nFor1
				endif
			else
				//�����������������������������������������������������������������������������������������������������������Ŀ
				//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
				//�������������������������������������������������������������������������������������������������������������
				lEXCLU := .F.
				TRBOLD->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
				TRBOLD->(DBCLOSEAREA())
				if lEXCLU
					ferase(cVelhoArq)
				else
					aadd(aRet,{'1',cVelhoArq})
				endif
			endif
		endif
	endif
	//���������������������������������������������8�
	//�Cria a nova estrutura para trabalhar com ela�
	//���������������������������������������������8�
	cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
	if lBANCO
		if U_listbl(cNovoArq,0,"TRBATU")// VERIFICAR SE EXISTE A TABELA
			IF lRet
				U_listbl(cVelhoArq,3,"TRBATU",aStruPH)// DROPA A TABELA
				U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
			else
				U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
			endif
		else
			cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
			U_listbl(cNovoArq,4,"TRBATU",aStruPH)// CRIA A TABELA
		endif
	else
		if file(cNovoArq+'.dtc') .or. file(cNovoArq+'.dbf')
			DbUseArea(.t.,,cNovoArq,"TRBATU",.T.)
			if select("TRBATU") <= 0
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
				dbCreate(cNovoArq,aStruPH, __LocalDriver )
			Elseif lRet
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
				dbCreate(cNovoArq,aStruPH, __LocalDriver )
			endif
			//�����������������������������������������������������������������������������������������������������������Ŀ
			//�analisa se existe registro n�o processado. Caso contrario se ja todos estiverem processados apage o arquivo�
			//�������������������������������������������������������������������������������������������������������������
			lEXCLU := .F.
			TRBATU->(DBEVAL({|| IIF(UXU_PROQUE==0,lEXCLU := .F.,nil)})) //0 nao processado; 1 processado
			iif(SELECT("TRBATU")>0,TRBATU->(DbCloseArea()),nil)
			if lEXCLU
				ferase(cNovoArq)
				cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
		   		dbCreate(cNovoArq,aStruPH, __LocalDriver )
			endif
		else
			cNovoArq	:= UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
			dbCreate(cNovoArq,aStruPH, __LocalDriver )
		endif
	endif
	aadd(aRet,{'3',cNovoArq})
endif
RETURN(aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Velhoarq  �Autor  �Leandro Duarte      � Data �  08/20/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para capturar o nome antigo da tabela                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function Velhoarq()
Local aArea		:= UA1->(GETAREA())
Local cVersold	:= strzero(val(UA1->UA1_VERSAO)-1,4)
lOCAL cCod		:= UA1->UA1_COD
Local cRet		:= ""

if !UA1->(dbSeek( xFilial( "UA1" ) + cCod + cVersold ))
	cVersold	:= strzero(val(cVersold)-1,4)
	while !UA1->(dbSeek( xFilial( "UA1" ) + cCod + cVersold )) .and. cVersold>= '0000'
		cVersold	:= strzero(val(cVersold)-1,4)
	end
endif
cRet := UA1->(ALLTRIM(UA1_COD)+ALLTRIM(UA1_VERSAO)+ALLTRIM(UA1_ROTINA))
Restarea(aArea)
Return(cRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �listbl    �Autor  �Leandro Duarte      � Data �  30/09/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para capturar o 0 Analisa se a tabela existe         ���
���          �                       1 estrutura da tabela                ���
���          �                       2 Carrega a tabela                   ���
���          �                       3 Dropa a tabela                     ���
���          �                       4 Cria a tabela                      ���
���          �                       5 Limpa a tabela                     ���
���          �                       6 Inseri ou atualiza a tabela        ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function listbl(cNomTab,nOpc,cAlias,aCampos)
local cQuery 	:= "SELECT * from "+cNomTab+" A where A.D_E_L_E_T_ = ' ' "
Local cTabExit	:= "SELECT COUNT(*) AS QTD FROM ALL_TABLES A WHERE A.OWNER = 'ODBP12' AND A.TABLE_NAME = '"+cNomTab+"' "
lOCAL aStruc	:= {}


if nOpc == 0 
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	Return(TRB->QTD>0)
elseif nOpc == 1
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	IF TRB->QTD > 0
		TCSQLEXEC("DELETE "+cNomTab+" WHERE D_E_L_E_T_ = '*' .OR. UXU_PROQUE = 1 ")
		IIF(SELECT(cAlias)>0,(cAlias)->(DBCLOSEAREA()),NIL)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .T.)
		aStruc := (cAlias)->(DBSTRUCT())
		Return(aStruc)
	ENDIF
elseif  nOpc == 2
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	IF TRB->QTD > 0
		IIF(SELECT(cAlias)>0,(cAlias)->(DBCLOSEAREA()),NIL)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .T.)
		RETURN(.T.)
	ELSE
		RETURN(.F.)
	ENDIF
elseif nOpc == 3
	tcsqlexec("Drop Table "+cNomTab+";")
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	Return(TRB->QTD<=0)
elseif nOpc == 4 
	cQuery := "Create table "+cNomTab+" ( "
	For nQ := 1 to len(aCampos)
		cQuery := alltrim(aCampos[nQ][1])+" "+iif(aCampos[nQ][2]=="N","number("+cValtochar(aCampos[nQ][3])+")","VARCHAR("+cValtochar(aCampos[nQ][3])+")")+" not null "+iif(aCampos[nQ][2]=="N"," DEFAULT ((0))"," DEFAULT '"+SPACE(aCampos[nQ][3])+"',") 
	Next nQ
	cQuery := "D_E_L_E_T_  VARCHAR(1) not null DEFAULT ' ',"
	cQuery := "R_E_C_N_O_  NUMBER(999999) not null DEFAULT ((0)) )"
	TCsqlExec(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	Return(TRB->QTD>0)
elseif nOpc == 5 
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	IF TRB->QTD > 0
		TCSQLEXEC("DELETE "+cNomTab+" WHERE D_E_L_E_T_ = '*' .OR. UXU_PROQUE = 1 ")
		Return(.T.)
	ENDIF
elseif nOpc == 6
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cTabExit),"TRB", .T., .T.)
	IF TRB->QTD > 0
		TCSQLEXEC("DELETE "+cNomTab+" WHERE D_E_L_E_T_ = '*' .OR. UXU_PROQUE = 1 ")
		Return(.T.)
	ENDIF
endif

return()