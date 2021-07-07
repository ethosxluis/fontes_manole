#Include 'TOTVS.ch'
#Include 'Protheus.ch'
#INCLUDE "Tbiconn.CH"



User Function baixacsv()
    Local cAlias := ""
	
    If Type('cFilAnt') == 'U'
	    RpcClearEnv()
	    RpcSetType(3)

	    RpcSetEnv("99","01") 
    Endif 


	cAlias := GetNextAlias()

	BEGINSQL ALIAS cAlias
        SELECT E1_XIDTRAN,E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,P02_VALLIQ,P02_VALBRU,P02_TAXA FROM %TABLE:SE1% SE1
        INNER JOIN %TABLE:P02% P02 ON  P02.P02_FILIAL = %xFilial:P02% AND P02.P02_IDTRAN = SE1.E1_XIDTRAN AND P02.P02_PARCEL = SE1.E1_PARCELA AND P02.%NotDel%
        WHERE 
		SE1.E1_FILIAL = %xFilial:SE1% AND
		SE1.%NotDel%
	ENDSQL

    (cAlias)->( dbGotop() )
    While !(cAlias)->( Eof() )
        
		dbSelectArea("SE1")
		SE1->(DbSetorder(1))
		If SE1->(DbSeek(xFilial("SE1")+(cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
        	BaixaSE1( (cAlias)->(P02_VALBRU) , (cAlias)->(P02_TAXA)     )
        EndIf
        
        (cAlias)->(dbSkip())
    EndDo

Return




Static function  BaixaSE1( nValor,nJuros )
	Local aBaixa 	:= {}
	Local cBanc 	:= getmv('FS_PAGBANC',.T.,'999')
	Local cAg   	:= getmv('FS_PAGAGEN',.T.,'99999')
	Local cCONT 	:= getmv('FS_PAGCONT',.T.,'9999999999')
	Local cMotBx	:= getmv('FS_PAGMOTB',.T.,'NOR')
	Local nValli   	:= 0
	Local nDESC1    := 0
	Local cHist     := 'BAIXA ROTINA AUTOMATICA'
	Local dDat		:= ddatabase
	Local lRet		:= .F.
	Local nLoop
	Local cMsgErro	:= ""
	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica
	aBaixa := {	{"E1_PREFIXO"  ,SE1->E1_PREFIXO            ,Nil    },;
				{"E1_NUM"      ,SE1->E1_NUM                ,Nil    },;
				{"E1_PARCELA"  ,SE1->E1_PARCELA            ,Nil    },;
				{"E1_TIPO"     ,SE1->E1_TIPO               ,Nil    },;
				{"E1_CLIENTE"  ,SE1->E1_CLIENTE            ,Nil    },;
				{"E1_NATUREZ"  ,SE1->E1_NATUREZ            ,Nil    },;
				{"E1_EMISSAO"  ,SE1->E1_EMISSAO            ,Nil    },;
				{"E1_VENCTO"   ,SE1->E1_VENCTO             ,Nil    },;
				{"AUTMOTBX"    ,cMotBx                     ,Nil    },;
				{"AUTBANCO"    ,cBanc	           		   ,Nil    },;
				{"AUTAGENCIA"  ,cAg	           			   ,Nil    },;
				{"AUTCONTA"    ,cCONT              		   ,Nil    },;
				{"AUTDTBAIXA"  ,dDat                       ,Nil    },;
				{"AUTDTCREDITO",dDat                       ,Nil    },;
				{"AUTHIST"     ,cHist        			   ,Nil    },;
				{"AUTJUROS"    ,nJuros                     ,Nil,.T.},;
				{"AUTDESCONT"  ,nDesc1                     ,Nil    },;
				{"AUTVALREC"   ,nValor              ,Nil    }}
	MSExecAuto({|x,y,z| Fina070(x,y,z)},aBaixa,3) // inclusão
	If lMsErroAuto
		aErrPCAuto	:= GETAUTOGRLOG()
		cMsgErro	:= ""
		For nLoop := 1 To Len(aErrPCAuto)
			cMsgErro += aErrPCAuto[nLoop]+ "<br>"
		Next
	Else
		RecLock("SE5",.f.)
		SE5->E5_ORIGEM = 'AUTO'
		SE5->(MsUnlock())
		lRet := .T.
	Endif
Return
