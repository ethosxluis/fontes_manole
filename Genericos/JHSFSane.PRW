#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �JHSFSANE  �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de Saneamento das tabelas selecionadas             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 e P12.x                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function JHSFSANE()
Local oCheckBo1
Local oCheckBo2
Local oCheckBo3
Local oCheckBo4
Local oCheckBo5
Local oCheckBo6
Local oCheckBo7
Local lCheckBo1 	:= .F.
Local lCheckBo2 	:= .F.
Local lCheckBo3 	:= .F.
Local lCheckBo4 	:= .F.
Local lCheckBo5 	:= .F.
Local lCheckBo6 	:= .F.
Local lCheckBo7 	:= .F.
Local oFont1 		:= TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
Local oGroup1
Local oSay1
Local oSButton1
Local oSButton2
Local cArqLog		:= "Analise_saneamento_"+dtos(date())+replace(time(),":","")+".txt"
Local oButton1
Local oGet1
Local cGet1 		:= space(3)
Local oSay1

Private oDlg
Private oOk 		:= LoadBitmap( GetResources(), "LBOK")
Private oNo 		:= LoadBitmap( GetResources(), "LBNO")
Private oWBrowse1
Private aWBrowse1 	:= listaX2()
Private oProcess  	:= NIL
Private cLogFile	:= "c:\temp\"+cArqLog
Private lErro		:= .f.
Private cErro		:= ""
Private axRe		:= {}
Private axObrigat   := {}
pRIVATE nFor1		:= 1
private INCLUI		:= .f.
private ALTERA		:= .f.
Private lVa			:= .f.
Private lMa			:= .f.
Private lIn			:= .f.
Private lAc			:= .f.
Private lAt			:= .f.
Private lEr			:= .f.
Private lEnd			:= .f.

makedir("c:\temp")

DEFINE MSDIALOG oDlg TITLE "Lista de Saneamento" FROM 000, 000  TO 800, 900 COLORS 0, 16777215 PIXEL
@ 019, 015 SAY oSay1 PROMPT "Caro Usuario voc� estara efetuando o Saneamento dos dados e analisando se o registro possui campos obrigatorios n�o preenchidos ou com informa��o divergente. Sera gerado um log e apresentado para Voc� no final da rotina." SIZE 419, 036 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 071, 013 GROUP oGroup1 TO 342, 432 PROMPT "   Tabelas para efetuar o Saneamento     " OF oDlg COLOR 0, 16777215 PIXEL
fWBrowse1()
@ 350, 343 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Marcar/Desmarcar Todos" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE todos() PIXEL
@ 350, 183 CHECKBOX oCheckBo4 VAR lCheckBo4 PROMPT "Executar Inicializador nos Campos Vazios" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE (lIn:= !lIn) PIXEL
@ 360, 343 CHECKBOX oCheckBo2 VAR lCheckBo2 PROMPT "Executar Valids" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE (lVa:= !lVa) PIXEL
@ 360, 183 CHECKBOX oCheckBo5 VAR lCheckBo5 PROMPT "Corrigir Acentua��o inv�lida" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE (lAc:= !lAc) PIXEL
@ 370, 343 CHECKBOX oCheckBo3 VAR lCheckBo3 PROMPT "Deixar todos Maiusculo" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE (lMa:= !lMa) PIXEL
@ 370, 183 CHECKBOX oCheckBo6 VAR lCheckBo6 PROMPT "Deseja Gravar Log de Todas as Altera��es" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE (lAt:= !lAt) PIXEL
@ 380, 183 CHECKBOX oCheckBo7 VAR lCheckBo7 PROMPT "Deseja Gravar Log dos Erros" SIZE 156, 008 OF oDlg COLORS 0, 16777215 ON CHANGE (lEr:= !lEr) PIXEL
@ 350, 012 SAY oSay1 PROMPT "Pesquisa:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 350, 041 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg  PICTURE "@!" COLORS 0, 16777215 PIXEL
@ 350, 102 BUTTON oButton1 PROMPT "Pesquisa a Tabela" SIZE 055, 011 OF oDlg  action ( iif(empty(cGet1),alert("Preenche a tabela de Pesquisa"),(nTab := ascan(aWBrowse1,{|x| UPPER(x[2])==UPPER(cGet1)}),IIF(nTab==0,alert("Tabela N�o encontrada"),oWBrowse1:nat := nTab),oWBrowse1:refresh(),oDlg:refresh() )) ) PIXEL
DEFINE SBUTTON oSButton1 FROM 373, 038 TYPE 01 OF oDlg ENABLE action( oDlg:end(), oProcess := MsNewProcess():New( { |lEnd| Sanear(@lEnd) },"Efetuando as Analises","Aguarde Trabalhando!" ,.T.) ,oProcess:Activate() )
DEFINE SBUTTON oSButton2 FROM 373, 080 TYPE 02 OF oDlg ENABLE action (oDlg:end())

ACTIVATE MSDIALOG oDlg CENTERED

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fWBrowse1 �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para efetuar a Lista das tabelas doProtheus          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12.X                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fWBrowse1()

@ 084, 019 LISTBOX oWBrowse1 Fields HEADER "","Alias","Tabela","Descri��o" SIZE 407, 253 OF oDlg PIXEL ColSizes 50,50
oWBrowse1:SetArray(aWBrowse1)
oWBrowse1:bLine := {|| {;
iIf(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
aWBrowse1[oWBrowse1:nAt,2],;
aWBrowse1[oWBrowse1:nAt,3],;
aWBrowse1[oWBrowse1:nAt,4];
}}
// DoubleClick event
oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
oWBrowse1:DrawSelect()}

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �listaX2   �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para listar as tabelas da estrutura SX2              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12.X                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function listaX2()
Local aRet := {}
SX2->(DBGOTOP())
while SX2->(!EOF())
	aadd(aRet,{.f.,SX2->X2_CHAVE,SX2->X2_ARQUIVO, SX2->X2_NOME})
	SX2->(DBSKIP())
END
Return(aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Todos     �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �apresenta todos selecionados                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � p12.x                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function todos()
aeval(aWBrowse1,{|z| z[1] := !z[1] })
oWBrowse1:refresh()
oDlg:refresh()
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Sanear    �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de principio de regras para analise dos dados e dos  ���
���          � campos obrigatorios                                        ���
�������������������������������������������������������������������������͹��
���Uso       � P12.x                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Sanear(lEnd)
Local nFor := 1
Private bErro 		:= ErrorBlock({|e| VerErro(e,@lErro,@cErro,nFor1)})

oProcess:SetRegua1(len(aWBrowse1)+2)
// CRIA AS TABELA SY?
CCRIATSY()
For nFor := 1 to len(aWBrowse1)
	oProcess:IncRegua1("Analisando CPO Obrigatorio/Real da tabela "+aWBrowse1[nFor][3])
	//���������������������������������������������������������������������������������������Ŀ
	//�Analise primeiro os campos obrigatorios se est�o preenchidos e com a informa��o correta�
	//�����������������������������������������������������������������������������������������
	if lEnd
		return()
	endif
	if aWBrowse1[nFor][1]
	  	//Begin Sequence
		Sanear01(aWBrowse1[nFor][2],@lEnd)
		//End Sequence
	endif
Next nFor
aviso("Aten��o","Arquivo gerado esta na Pasta "+cLogFile,{"ok"})
Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Sanear01  �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para listar os Campos obrigatorios e listar se est�o ���
���          �preenchidos e se estiver preenchidos com a informa��o correta��
�������������������������������������������������������������������������͹��
���Uso       � P12.x                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Sanear01(cAlias,lEnd)
Local cQuery 		:= ""
Local nQtd			:= 0
Local aTabs				:= {}
Local cTabs				:= ""
Local nFor2			:= 1
Local nFor1		:= 1
Local nvt			:= 0
//���������������������������
//�ANALISAR A ESTRUTURA REAL�
//���������������������������
axRe			:= Listsx3(2,cAlias)// 1=obrigatorio;2real
axObrigat      	:= Listsx3(1,cAlias)// 1=obrigatorio;2real

//���������������������������������������Ŀ
//�SELECT DA TABELA DOS CAMPOS OBRIGATORIO�
//�����������������������������������������
cQuery := " SELECT "
AEVAL(axObrigat,{|Z| cQuery += Z[3]+", " })
cQuery += "R_E_C_N_O_  AS REC "
cQuery += " FROM "+RETSQLNAME(cAlias) +" A "
cQuery += " WHERE A.D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ "
IIF(SELECT("TRBOBRI")>0,TRBOBRI->(DBCLOSEAREA()),NIL)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBOBRI", .F., .T.)
TRBOBRI->( DBEval( { || nQtd++ } ) )
TRBOBRI->( DBGOTOP() )
//���������������������������������������Ŀ
//�SELECT DA TABELA DOS CAMPOS REAIS      �
//�����������������������������������������
cQuery := " SELECT "
AEVAL(axRe,{|Z| cQuery += Z[3]+", " })
cQuery += "R_E_C_N_O_  AS REC "
cQuery += " FROM "+RETSQLNAME(cAlias) +" A "
cQuery += " WHERE A.D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_  "
IIF(SELECT("TRBREAL")>0,TRBREAL->(DBCLOSEAREA()),NIL)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBREAL", .F., .T.)
oProcess:IncRegua2("Contando os Registros" )
TRBREAL->( DBEval( { || nQtd++ } ) )
TRBREAL->( DBGOTOP() )

oProcess:SetRegua2( nQtd )
oProcess:IncRegua1("Analisando Campos Real da tabela "+cAlias)
//�����������������������������������������������������Ŀ
//�ABRE A TABELA E COME�A A ANALISE  DOS CAMPOS REAIS   �
//�������������������������������������������������������
WHILE TRBREAL->(!EOF())
	Private lMsErroauto		:= .f.
	Private lMsHelpAuto		:= .t.
	Private lautoErrNoFile	:= .T.
	Public lMostraTela		:= .F. 
	DBUNLOCKALL() // regra para evitar o estouro
	if lEnd
		return()
	endif
	nvt	+= 1
	oProcess:IncRegua2("Processado de "+strzero(nvt,8)+" at� "+strzero(nQtd,8) )
	(cAlias)->(dbgoto(TRBREAL->REC))
	RegToMemory(cAlias,.f.)
	RECLOCK(CALIAS,.F.)
	For nFor1 := 1 to len(axRe)
		//��������������������������������������������������������Ŀ
		//�Abertura de tabelas para analisar se existe regras nelas�
		//����������������������������������������������������������
		cTabs := axRe[nFor1][8]
		while at("'",cTabs) > 0
			cTabs := substr(cTabs,at("'",cTabs)+1)
			if substr(alltrim(cTabs),4,1)== "'"
				aadd(aTabs,substr(cTabs,1,3))
			endif
		end
		cTabs := axRe[nFor1][8]
		while at('"',cTabs) > 0
			cTabs := substr(cTabs,at('"',cTabs)+1)
			if substr(alltrim(cTabs),4,1)== '"'
				aadd(aTabs,substr(cTabs,1,3))
			endif
		end
		if len(aTabs)>0
			For nFor2 := 1 to len(aTabs)
				if SX2->(DBSEEK(aTabs[nFor2]))
					dbselectarea(aTabs[nFor2])
				ENDIF
			next nFor2
		endif
		//alert(axRe[nFor1][3])
		//������������������Ŀ
		//�retira os acentos �
		//��������������������
		if axRe[nFor1][4]$ 'C,M'
			if lIn // EXECUTA O INICIALIZADOR PADR�O
				if !Empty(axRe[nFor1][9]) .and. empty(&('TRBREAL->'+axRe[nFor1][3]))
					//alert(&(axRe[nFor1][9]))
					&(cAlias+'->'+axRe[nFor1][3]) := &(axRe[nFor1][9])
					if lAt
						If !File(cLogFile)
							If (nHandle := MSFCreate(cLogFile,0)) <> -1
								cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Altera��o: O Campo:|"+axRe[nFor1][3]+"|. Estava vazio e foi alimentado com o inicializador padr�o:|"+&(cAlias+'->'+axRe[nFor1][3])+CRLF
								FWrite( nHandle,cErro1)
								FCLOSE(nHandle)
							EndIf
						Else
							If (nHandle := FOpen(cLogFile,2)) <> -1
								FSeek(nHandle,0,2)
								cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Altera��o: O Campo:|"+axRe[nFor1][3]+"|. Estava vazio e foi alimentado com o inicializador padr�o:|"+&(cAlias+'->'+axRe[nFor1][3])+CRLF
								FWrite( nHandle,cErro1)
								FCLOSE(nHandle)
							EndIf
						EndIf
					endif
				endif
			endif
			if lMa .AND. &('TRBREAL->'+axRe[nFor1][3]) !=  UPPER(&('TRBREAL->'+axRe[nFor1][3]))// EXECUTA TODOS COMO MAIUSCULO
				&(cAlias+'->'+axRe[nFor1][3]) := UPPER(&('TRBREAL->'+axRe[nFor1][3]))
				if lAt
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Altera��o: O Campo:|"+axRe[nFor1][3]+"|. foi alterado para maiusculo:|"+&(cAlias+'->'+axRe[nFor1][3])+CRLF
							FWrite( nHandle,cErro1)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Altera��o: O Campo:|"+axRe[nFor1][3]+"|. foi alterado para maiusculo:|"+&(cAlias+'->'+axRe[nFor1][3])+CRLF
							FWrite( nHandle,cErro1)
							FCLOSE(nHandle)
						EndIf
					EndIf
				endif
			endif 
			if lAc .and. RodAnt(&('TRBREAL->'+axRe[nFor1][3])) // EXECUTA O AJUSTE DE CARACTERES INVALIDOS
				&(cAlias+'->'+axRe[nFor1][3]) := TIRACENTO(&('TRBREAL->'+axRe[nFor1][3]))
				if lAt
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Altera��o: O Campo:|"+axRe[nFor1][3]+"|. Possuia Caracters invalidos e foi trocado para:|"+&(cAlias+'->'+axRe[nFor1][3])+CRLF
							FWrite( nHandle,cErro1)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Altera��o: O Campo:|"+axRe[nFor1][3]+"|. Possuia Caracters invalidos e foi trocado para:|"+&(cAlias+'->'+axRe[nFor1][3])+CRLF
							FWrite( nHandle,cErro1)
							FCLOSE(nHandle)
						EndIf
					EndIf
				endif
			endif
		ENDIF
		aTabs				:= {}
		cTabs				:= ""
		//������������������������������������������Ŀ
		//�Analiso se o campo tem rela��o com o Valid�
		//��������������������������������������������
		if lVa
			begin sequence
			if axRe[nFor1][4]$ 'C' .and. !empty(axRe[nFor1][8])
				IF  !('PERTENCE' $ UPPER(axRe[nFor1][8]))
					if !('EXIST' $ UPPER(axRe[nFor1][8]))
						cValidx	:= upper(axRe[nFor1][8])
						//alert(cValidx)
						//alert(&('TRBREAL->'+axRe[nFor1][3]))
						if 'VAZIO' $ cValidx .and. !EMPTY(&('M->'+axRe[nFor1][3]))
							cValidx	:= replace(replace(replace(replace(cValidx,'VAZIO() .OR.',''),'VAZIO() .AND.',''),'.AND. VAZIO()',''),'.OR. VAZIO()','')
						endif
					   IF ('CGC'$axRe[nFor1][3]) .AND. cAlias$'SA1,SA2'
					   		c_xcgc 	:= &('M->'+SUBSTR(cAlias,2,2)+"_CGC")
					   		c_xtipo := &('M->'+SUBSTR(cAlias,2,2)+"_PESSOA")
					   		IF c_xtipo == 'J' .AND. LEN(c_xcgc)>11
					   			cValidx := '.T.'
					   		ELSEIF c_xtipo == 'J' .AND. LEN(c_xcgc)<=11
					   			&('M->'+SUBSTR(cAlias,2,2)+"_PESSOA") := 'F'
								&(cAlias+'->'+SUBSTR(cAlias,2,2)+"_PESSOA") := 'F'
					   		ENDIF
					   ENDIF
					   //IF alltrim(axRe[nFor1][3]) == "B1_COD"
					   //		cValidx := '.T.'
					   //endif
						lErro := &(cValidx)
					//	ALERT(lErro)
						lErro := !lErro 
						//ErrorBlock(bErro)
					   //	alert(lErro)
					endif
				ENDIF
				if lErro .and. lEr // ANALISE SE IMPRIME OS ERROS
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Erro: O valid apresentou erro para o Campo:|"+axRe[nFor1][3]+"|. Por Favor Corrige esse Campo. Informa��o capturada:|"+&('TRBREAL->'+axRe[nFor1][3])+cErro+CRLF
							FWrite( nHandle,cErro1)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							cErro1	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Erro: O valid apresentou erro para o Campo:|"+axRe[nFor1][3]+"|. Por Favor Corrige esse Campo. Informa��o capturada:|"+&('TRBREAL->'+axRe[nFor1][3])+cErro+CRLF
							FWrite( nHandle,cErro1)
							FCLOSE(nHandle)
						EndIf
					EndIf
				endif
			ENDIF
			end sequence
		endif
		if axRe[nFor1][4]$ 'D'
			dx1 := &('TRBREAL->'+alltrim(axRe[nFor1][3]))
			dx2 := stod(dx1)
			if empty(dx2) .and. !empty(dx1)
				lErro		:= .t.
				if lEr // ANALISE SE IMPRIME OS ERROS
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							cErro	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Erro: A informa��o de Data do Campo:|"+axRe[nFor1][3]+"|esta errada. Por Favor Corrige esse Campo. Informa��o capturada esta em formato String para melhor apresentar:|"+dx1+CRLF
							FWrite( nHandle,cErro)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							cErro	:= "RECNO:|"+padr(cvaltochar(TRBREAL->REC),10)+"|Erro: A informa��o de Data do Campo:|"+axRe[nFor1][3]+"|esta errada. Por Favor Corrige esse Campo. Informa��o capturada esta em formato String para melhor apresentar:|"+dx1+CRLF
							FWrite( nHandle,cErro)
							FCLOSE(nHandle)
						EndIf
					EndIf
				endif
			endif
		ENDIF
	Next nFor1
	MSUNLOCK()
	TRBREAL->(DBSKIP())
END
//�����������������������������������������������������������Ŀ
//�ABRE A TABELA E COME�A A ANALISE DOS CAMPOS OBRIGATORIOS   �
//�������������������������������������������������������������
oProcess:IncRegua1("Analisando Campo Obrigatorio da tabela "+cAlias)
WHILE TRBOBRI->(!EOF())
	DBUNLOCKALL() // regra para evitar o estouro
	nvt	+= 1
	oProcess:IncRegua2("Processado de "+strzero(nvt,8)+" at� "+strzero(nQtd,8) )
	(cAlias)->(dbgoto(TRBOBRI->REC))
	RECLOCK(cAlias,.f.)
	For nFor1 := 1 to len(axObrigat)
		//������������������Ŀ
		//�retira os acentos �
		//��������������������
		if axObrigat[nFor1][4]$ 'C,M,D'
			
			// campo vazil e possui inicializador padr�o
			if !Empty(axObrigat[nFor1][9]) .and. empty(&('TRBOBRI->'+axObrigat[nFor1][3]))
				&(cAlias+'->'+axObrigat[nFor1][3]) := &(axObrigat[nFor1][9])
			endif
			// campo vazil loga
			if empty(&(cAlias+'->'+axObrigat[nFor1][3]))
				lErro		:= .t.
				if lEr // ANALISE SE IMPRIME OS ERROS
					If !File(cLogFile)
						If (nHandle := MSFCreate(cLogFile,0)) <> -1
							cErro	:= "RECNO:|"+padr(cvaltochar(TRBOBRI->REC),10)+"|Erro: O Campo:|"+axObrigat[nFor1][3]+"|. � OBRIGATORIO e n�o foi preenchido. Por Favor Corrige esse Campo."+CRLF
							FWrite( nHandle,cErro)
							FCLOSE(nHandle)
						EndIf
					Else
						If (nHandle := FOpen(cLogFile,2)) <> -1
							FSeek(nHandle,0,2)
							cErro	:= "RECNO:|"+padr(cvaltochar(TRBOBRI->REC),10)+"|Erro: O Campo:|"+axObrigat[nFor1][3]+"|. � OBRIGATORIO e n�o foi preenchido. Por Favor Corrige esse Campo."+CRLF
							FWrite( nHandle,cErro)
							FCLOSE(nHandle)
						EndIf
					EndIf
				endif
			endif
		ENDIF
	Next nFor1
	MSUNLOCK()
	TRBOBRI->(DBSKIP())
END
return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Listsx3  �Autor  �Leandro Duarte       � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para listar a estrutura SX3 para pegar os campos     ���
���          �obrigatorio e os campos reais                               ���
�������������������������������������������������������������������������͹��
���Uso       � P12.x                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Listsx3(nOpc,cAlias)
Local aXRet1	:= {}


SX3->(DBSETORDER(1))
IF SX3->(DBSEEK(cAlias))
	if nOpc == 1 // BUSCA OS CAMPOS OBRIGATORIOS
		WHILE SX3->X3_ARQUIVO == cAlias
			IF X3Obrigat(SX3->X3_CAMPO) .AND. ALLTRIM(SX3->X3_CONTEXT) <> "V"  .AND. X3Usado(SX3->X3_CAMPO) .AND. ALLTRIM(SX3->X3_VISUAL) <> "V"
				aadd(aXRet1,{SX3->X3_ARQUIVO, SX3->X3_ORDEM, SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_PICTURE, SX3->X3_VALID, SX3->X3_RELACAO, SX3->X3_F3, SX3->X3_TRIGGER, SX3->X3_VISUAL, SX3->X3_CONTEXT, SX3->X3_CBOX})
			ENDIF
			SX3->(DBSKIP())
		END
		//MEMOWRITE('C:\TEMP\CAMPOS_OBRIGATORIO.HTML','<HTML><HEAD></HEAD><BODY>'+VARINFO('AOBRIGATORIOS',aXRet1)+'</BODY></HTML>')
	elseif nOpc == 2 // CAMPOS REAL
		WHILE SX3->X3_ARQUIVO == cAlias
			IF ALLTRIM(SX3->X3_CONTEXT) <> "V" .AND. X3Usado(SX3->X3_CAMPO) .AND. ALLTRIM(SX3->X3_VISUAL) <> "V"
				aadd(aXRet1,{SX3->X3_ARQUIVO, SX3->X3_ORDEM, SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_PICTURE, SX3->X3_VALID, SX3->X3_RELACAO, SX3->X3_F3, SX3->X3_TRIGGER, SX3->X3_VISUAL, SX3->X3_CONTEXT, SX3->X3_CBOX})
			ENDIF
			SX3->(DBSKIP())
		END
		//MEMOWRITE('C:\TEMP\CAMPOS_REAL.HTML','<HTML><HEAD></HEAD><BODY>'+VARINFO('AOBRIGATORIOS',aXRet1)+'</BODY></HTML>')
	ENDIF
endif
memowrite("f:\teste_"+replace(time(),":","")+".html","<html><body>"+varinfo('',aXRet1)+"</body></html>")
return(aXRet1)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TIRACENTO �Autor  �Leandro Duarte      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para retirar os acentos dos campos Caracteres        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12.x                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION TIRACENTO(_cVar)
Local _nPos := 0
Local _cnt := 0
If Empty(_cVar)
	_cVar:=" "
	Return(_cVar)
Endif
_cVar := alltrim(_cVar)
//�������������������������������������������������Ŀ
//� Matriz de codigos ASCII para procura de posicao �
//���������������������������������������������������
_aAce := { ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),;
ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�")}
//�����������������������������������������Ŀ
//� Matriz de caracteres que serao trocados �
//�������������������������������������������
_aSac := { "a","A","a","A","a","A","a","A","e","E","e","E","e","E","i","I","i","I","i","I","o","O","o","O","o","O","o","O","u","U","u","U","u","U","c","C","a","e","i","o","u","A","E","I","O","U","Y","a","o","*","*","o"}
//��������������������������������������Ŀ
//� Matriz ASCII referentes aos acentuos �
//����������������������������������������
_aMat := { "�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�"}

_cnt := 0
_nPos:=0
//�������������������������������������������������Ŀ
//� Laco para verificar todas as posicoes da string �
//���������������������������������������������������
For _cnt := 1 to len(_cVar)
	
	_nPos := ascan(_aAce, ASC(substr(_cVar,_cnt,1)))	    // Identifica posicao
	
	If !_nPos==0
		_cVar:=replace(_cVar,_aMAT[_nPos],_aSac[_nPos])	// Faz a troca
	Endif
	
Next _cnt

_cVar:= replace(_cVar,'�','')
_cVar:= replace(_cVar,"'","")
_cVar:= replace(_cVar,"`","")
_cVar:= replace(_cVar,"~","")
_cVar:= replace(_cVar,'"','')
_cVar:= replace(_cVar,';','')
_cVar:= replace(_cVar,'#','')

//�������������������������������������Ŀ
//�ANALISE DE VIRGULA CONFORME DANCARINO�
//���������������������������������������
IF AT(',',_cVar)>0 
	nV1 := AT(',',_cVar)
	WHILE nV1>0
		if type(substr(_cVar,nV1-1,1)) == "N"
			_cVar	:= substr(_cVar,1,nV1-1)+'.'+substr(_cVar,nV1+1)
		ELSE
			_cVar	:= substr(_cVar,1,nV1-1)+' '+substr(_cVar,nV1+1)
		ENDIF
		nV1 := AT(',',_cVar)
	END
ENDIF
Return(_cVar)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerErro   �Autor  �LEANDRO DUARTE      � Data �  12/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA ANALISAR O ERRO DO VALID E GRAVAR EM LOG        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12.X                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerErro(e,lErro,cErro,nFor1)
Local lRet				:= .F.
cErro := ""
lErro	:= .f.
If e:Gencode > 0 .and. !('__RUN' $ e:Description) .and. !empty(e:Description)
	//alert('linha 516')
	cErro += "Descri��o : " + e:Description + CRLF
	//cErro += e:ErrorStack + CRLF
	lErro := .T.
	lRet := .T.
	Break
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �JHSFSANE  �Autor  �Microsiga           � Data �  12/23/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC fUNCTION CCRIATSY()
LOCAL CXTTAB := "SY0"
DBSELECTAREA(CXTTAB)
SX2->(DBSETORDER(1))
SX3->(DBSETORDER(1))
WHILE CXTTAB <= 'SYZ'
	CXTTAB := SOMA1(CXTTAB)
	if SX2->(DBSEEK(CXTTAB)) .and. SX3->(DBSEEK(CXTTAB))
		DBSELECTAREA(CXTTAB)
	endif
END
CXTTAB := "SE0"
DBSELECTAREA(CXTTAB)
SX2->(DBSETORDER(1))
SX3->(DBSETORDER(1))
WHILE CXTTAB <= 'SEZ'
	CXTTAB := SOMA1(CXTTAB)
	if SX2->(DBSEEK(CXTTAB)) .and. SX3->(DBSEEK(CXTTAB))
		DBSELECTAREA(CXTTAB)
	endif
END
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XPinvld   �Autor  �Leandro Duarte      � Data �  01/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Analisa se existe a regra para a troca de caracetres invalid���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12.x                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RodAnt(cVar)
Local xlRet := .F.
Local _nPos := 0
Local _cnt := 0

If Empty(cVar)
	Return(xlRet)
Endif

cVar := alltrim(cVar)
//�������������������������������������������������Ŀ
//� Matriz de codigos ASCII para procura de posicao �
//���������������������������������������������������
_aAce := { ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),;
ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC("�"),ASC(",")}

//�����������������������������������������Ŀ
//� Matriz de caracteres que serao trocados �
//�������������������������������������������
_aSac := { "a","A","a","A","a","A","a","A","e","E","e","E","e","E","i","I","i","I","i","I","o","O","o","O","o","O","o","O","u","U","u","U","u","U","c","C","a","e","i","o","u","A","E","I","O","U","Y","a","o","*","*","o"," "}
//��������������������������������������Ŀ
//� Matriz ASCII referentes aos acentuos �
//����������������������������������������
_aMat := { "�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�",","}

_cnt := 0
_nPos:=0
//�������������������������������������������������Ŀ
//� Laco para verificar todas as posicoes da string �
//���������������������������������������������������

For _cnt := 1 to len(cVar)

	_nPos := ascan(_aAce, ASC(substr(cVar,_cnt,1)))	    // Identifica posicao

	if _nPos > 0

		xlRet := .T.
		Return(xlRet)
	endif
Next _cnt

IF AT('�',cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT("'",cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT("`",cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT("~",cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT('"',cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT(',',cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT(';',cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF
IF AT('#',cVar) > 0
	xlRet := .T.
	Return(xlRet)
ENDIF

Return(xlRet)
