#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN100VST  �Autor  �leandro duarte      � Data �  03/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �rotina para disparo de e-mail para os aprovadores           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION CN100VST()
Local cNewSituc := Paramixb[1]
Local cPara		:= ""
Local cAssunto	:= "Novo Contrato Aguardando para ser Aprovado"
Local cMsg		:= "Esta disponivel para ser aprovado a libera��o do contrato: <B>"+CN9->CN9_NUMERO
Local cNIVEL	:= "00"
Local lRet		:= .F.
if cNewSituc == "04"
	DbSelectArea("CN1") //Tipo de Contrato
	DbSetOrder(1) //CN1_FILIAL+CN1_CODIGO
	If DbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
		
		If !Empty(CN1->( FieldPos( "CN1_CTRAPR" ))) .AND. !Empty(CN1->( FieldPos( "CN1_GRPSIT" )))
			If CN1->CN1_CTRAPR == '1' .AND. !Empty(CN1->CN1_GRPSIT) //Controla alcada na mudanca de situacao do contrato
				cGrpApr := CN1->CN1_GRPSIT
				cMsg += " "+ALLTRIM(CN1->CN1_DESCRI)+"</B><BR> Data: "+dtoc(CN9->CN9_DTINIC)+" Valor R$ "+alltrim(transform(CN9->CN9_VLATU,"@E 999,999,999.99"))+"<BR>Para efetuar a Libera��o por Favor entrar no modulo Gest�o de Contrato / Libera��o / Libera��o de Doc "
				SAL->(DBSETORDER(1))//AL_FILIAL+AL_COD+AL_ITEM
				IF SAL->(DBSEEK(XFILIAL("SAL")+cGrpApr))
					SCR->(DBSETORDER(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
					IF SCR->(DBSEEK(xFilial("SCR")+"CT"+CN9->CN9_NUMERO+CN9->CN9_REVISA))
						cNIVEL	:= soma1(SCR->CR_NIVEL)
					ENDIF
					WHILE cGrpApr == SAL->AL_COD .AND. SAL->(!eof())
						// ANALISA SE DEVE ENVIAR PARA ESSE APROVADOR
						IF  ALLTRIM(cNIVEL) >= ALLTRIM(SAL->AL_NIVEL) // esse processo serve por que a grava��o da al�ada vem depois desse ponto
							IF ALLTRIM(SAL->AL_LIBAPR) == 'V'
								// TABELA DE FORNECEDOR DO CONTRATO
								//CNC_FILIAL+CNC_NUMERO+CNC_REVISA+CNC_CODIGO+CNC_LOJA
								CNC->(DBSETORDER(1))
								IF CNC->(DBSEEK(xFilial("CNC")+CN9->CN9_NUMERO+CN9->CN9_REVISA))
									WHILE CNC->(!EOF()) .AND. CN9->CN9_NUMERO+CN9->CN9_REVISA == CNC_NUMERO+CNC_REVISA
										cPara += POSICIONE("SA2",1,XfILIAL("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA,"ALLTRIM(A2_EMAIL)")+";"
										CNC->(DBSKIP())
									END
								ENDIF
							ELSE
								cPara := UsrRetMail(SAL->AL_USER)
							ENDIF
							lRet := u_EmailEnv(alltrim(cPara),'',cAssunto,cMsg)
						ENDIF
						SAL->(DBSKIP())
					END
				ENDIF
			EndIf
		EndIf
	endif
endif

RETURN(lRet)
