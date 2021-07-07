#Include 'TOTVS.ch'
#Include 'Protheus.ch'
#INCLUDE "Tbiconn.CH"



User Function baixacsv()
    Local cAlias := ""
	
    If Type('cFilAnt') == 'U'
	    RpcClearEnv()
	 //   RpcSetType(3)

	    RpcSetEnv("01","01") 
    Endif 


	cAlias := GetNextAlias()

	BEGINSQL ALIAS cAlias
        SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,P06_VALLIQ,P06_VALBRU,P06_TAXA
		,P06_IDTRAN,P06_PARCEL
		FROM  %TABLE:SC5% SC5
        INNER JOIN  %TABLE:P06% P06 ON  P06.P06_FILIAL = %xFilial:P06% 
			AND P06.P06_IDTRAN =  SUBSTRING(SC5.C5_VTEX,5)  
			AND P06.P06_STATUS = '1'
			AND P06.D_E_L_E_T_ = ''
		INNER JOIN  %TABLE:SE1% SE1 ON  SE1.E1_FILIAL = %xFilial:SE1% AND E1_CLIENTE = C5_CLIENTE AND E1_LOJA = C5_LOJACLI 
		AND E1_NUM = C5_NOTA AND E1_PREFIXO = C5_SERIE AND SE1.D_E_L_E_T_ = ''
        WHERE 
		SC5.C5_FILIAL =  %xFilial:SC5%
		AND SC5.D_E_L_E_T_ = ''
	ENDSQL

    (cAlias)->( dbGotop() )
    While !(cAlias)->( Eof() )
        
		dbSelectArea("SE1")
		SE1->(DbSetorder(1))
		If SE1->(DbSeek(xFilial("SE1")+(cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
        	BaixaSE1( (cAlias)->(P06_VALBRU) , (cAlias)->(P06_TAXA)  ,(cAlias)->(P06_IDTRAN),(cAlias)->(P06_PARCEL)   )
		Else
			If P06->(DbSeek(xFilial("P06")+cId+cParcela) )
				RecLock("P06",.f.)
				P06->P06_STATUS = '4'//nao encontrou o titulo e por isso nao realizou a baixa
				SE5->(MsUnlock())
			Endif
        EndIf
        
        (cAlias)->(dbSkip())
    EndDo

Return




Static function  BaixaSE1( nValor,nJuros ,cId, cParcela)
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
	Private lMsHelpAuto		:= .T. //Define se mostra ou n�o os erros na tela (T= Nao mostra; F=Mostra)
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
	MSExecAuto({|x,y,z| Fina070(x,y,z)},aBaixa,3) // inclus�o
	If lMsErroAuto
		aErrPCAuto	:= GETAUTOGRLOG()
		cMsgErro	:= ""
		For nLoop := 1 To Len(aErrPCAuto)
			cMsgErro += aErrPCAuto[nLoop]+ "<br>"
		Next
		If P06->(DbSeek(xFilial("P06")+cId+cParcela) )
			RecLock("P06",.f.)
			P06->P06_STATUS = '3'//processou mas com erro e nao realizou a baixa
			SE5->(MsUnlock())
		Endif
	Else
		RecLock("SE5",.f.)
		SE5->E5_ORIGEM = 'AUTO'
		SE5->(MsUnlock())
		dbSelectArea('P06')
		DbSetorder(2)
		If P06->(DbSeek(xFilial("P06")+cId+cParcela) )
			RecLock("P06",.f.)
			P06->P06_STATUS = '2' //realizou a baixa
			SE5->(MsUnlock())
		Endif
		lRet := .T.
	Endif
Return
