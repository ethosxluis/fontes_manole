#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#include "totvs.ch"
#include 'fileio.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User function COMPBROW()
Local CCADASTRO := ''
Local oFont := TFont():New('Courier new',,-18,.T.)
Local lActive := .T.

Private oSize := FwDefSize():New(.T.)
Private aCpoInfo, aCpoNF, aCpoNCC  := {}
Private aCampos , aCmpNF, aCmpNCC   := {}
Private aCpoData , aCpoDtNF , aCpoDtNCC   := {}
Private oTable,oTable1,oTable2        := Nil
Private oMarkBrow,oMarkBrow1,oMarkBrow2,oFWLayer,oPanel1,oPanel2,oPanel3,oPanel4,oButton,oButton1,oValAtu    := Nil
Private nValorTot := 0
Private cRecNF := 0
Private cPerg	:= "MNCOMP"

    ValidPerg(cPerg)

    pergunte(cPerg,.T.)


    oDlg :=MSDialog():New(oSize:aWindSize[1], oSize:aWindSize[2],oSize:aWindSize[3],oSize:aWindSize[4],'Compensação',,,,,CLR_BLACK,CLR_WHITE,,,.T.) 


	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlg, .F., .T. )
	
	//
	// Define Painel Superior
	//
	oFWLayer:AddLine( 'ESQ', 80, .F. )// Cria uma "linha" com 40% da tela
    oFWLayer:AddLine( 'DOW', 20, .F. )// Cria uma "linha" com 40% da tela
   // oFWLayer:AddLine( 'DIR', 100, .F. )// Cria uma "linha" com 40% da tela

	oFWLayer:AddCollumn( 'ALL', 20, .F., 'ESQ' )// Na "linha" criada eu crio uma coluna com 100% da tamanho dela
    oFWLayer:AddCollumn( 'ALL1', 40, .F., 'ESQ' )// Na "linha" criada eu crio uma coluna com 100% da tamanho dela
    oFWLayer:AddCollumn( 'ALL2', 40, .F., 'ESQ' )// Na "linha" criada eu crio uma coluna com 100% da tamanho dela
    oFWLayer:AddCollumn( 'ALLDOW', 100, .T., 'DOW' )// Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	

	oFWLayer:addWindow('ALL','CLIENTE' ,'Clientes'	,100,.T.,.T.,{|| /*"Clique janela 01!"*/ },'ESQ',{|| /*"Janela 01 recebeu foco!"*/ })
	oFWLayer:addWindow('ALL1','NF' ,'Titulos'	,100,.T.,.T.,{|| /*"Clique janela 02!"*/ },'ESQ',{|| /*"Janela 02 recebeu foco!"*/ })
    oFWLayer:addWindow('ALL2','NCC' ,"NCCs"	,100,.T.,.T.,{|| /*"Clique janela 02!"*/ },'ESQ',{|| /*"Janela 02 recebeu foco!"*/ })
    oFWLayer:addWindow('ALLDOW','TOTAL' ,"TOTAIS"	,100,.T.,.T.,{|| /*"Clique janela 02!"*/ },'DOW',{|| /*"Janela 02 recebeu foco!"*/ })


    oPanel1 	:= oFWLayer:GetWinPanel('ALL','CLIENTE','ESQ')
	oPanel1:FreeChildren()
	oPanel2 	:= oFWLayer:GetWinPanel('ALL1','NF','ESQ')
	//oPanel2:FreeChildren()
    oPanel3 	:= oFWLayer:GetWinPanel('ALL2','NCC','ESQ')
	oPanel3:FreeChildren()
    oPanel4 	:= oFWLayer:GetWinPanel('ALLDOW','TOTAL','DOW')
	oPanel4:FreeChildren()

    FwMsgRun(,{ || fLoadData() }, cCadastro, 'Carregando dados...')
    
    //CLIENTE
    oMarkBrow := FwMarkBrowse():New()
    oMarkBrow:SetAlias('TRB')
    oMarkBrow:SetOwner( oPanel1 )
    oMarkBrow:SetTemporary()
    oMarkBrow:SetColumns(aCampos)
    oMarkBrow:SetFieldMark('TMP_OK')
	oMarkBrow:DisableConfig()
    oMarkBrow:DisableFilter()
    oMarkBrow:DisableReport()
    oMarkBrow:SetAfterMark({|| ChangeMRK('TRB', TRB->(Recno("TRB")), @oMarkBrow)})

    oMarkBrow:Activate()

    oSay1 := TSay():New(02,01,{||"Valor da(s) NCC(s):"},oPanel4,,oFont,,,,.T.,,,,100,,,,,,)
    oValAtu := TSay():New(12,01,{||"R$ " + AllTrim(Transform( nValorTot, "@E 99,999,999.99"))},oPanel4,,oFont,,,,.T.,CLR_RED,,,100,,,,,,)


    If lActive
        oDlg:Activate(,,,.T.,{||/*msgstop('validou!')*/,.T.},,{||/*msgstop('iniciando')*/} )
        lActive := .F.
    Endif

Return


 STATIC FUNCTION NFNCC(cCLiente,cLoja)
        Local oSize2 
        Local oSize3
        Private oSay1 

        FwMsgRun(,{ || fLoadNF(cCLiente,cLoja) }, '', 'Carregando dados...')
        If Type('oMarkBrow1') == 'U'

            oMarkBrow1 := FwMarkBrowse():New()
            oMarkBrow1:SetAlias('TRBNF')
            oMarkBrow1:SetOwner( oPanel2 )
            oMarkBrow1:SetTemporary()
            oMarkBrow1:SetColumns(aCmpNF)
            oMarkBrow1:SetFieldMark('TNF_OK')
	        oMarkBrow1:DisableConfig()
            oMarkBrow1:DisableFilter()
            oMarkBrow1:DisableReport()
            oMarkBrow1:SetAfterMark({|| ChangeMRK('TRBNF', TRBNF->(Recno("TRBNF")), @oMarkBrow1,.F.)})

            oMarkBrow1:Activate()
            oMarkBrow1:Refresh()
        else
            oMarkBrow1:Refresh()
        EndIF

        FwMsgRun(,{ || fLoadNCC(cCLiente,cLoja) }, '', 'Carregando dados...')
        
        If Type('oMarkBrow2') == 'U'
        
            oMarkBrow2 := FwMarkBrowse():New()
            oMarkBrow2:SetAlias('TRBNC')
            oMarkBrow2:SetOwner( oPanel3 )
            oMarkBrow2:SetTemporary()
            oMarkBrow2:SetColumns(aCmpNCC)
            oMarkBrow2:SetFieldMark('TNC_OK')
	        oMarkBrow2:DisableConfig()
            oMarkBrow2:DisableFilter()
            oMarkBrow2:DisableReport()
            oMarkBrow2:SetAfterMark({|| NCCTOTAL('TRBNC', TRBNC->(Recno("TRBNC")), @oMarkBrow1)})

            //oMarkBrow2:SetAllMark( { || oMarkBrow2:AllMark() }  )
            oMarkBrow2:Activate()
            oMarkBrow2:Refresh()
            oButton2 := FwButtonBar():New()
	        oButton2:Init(oPanel3, 015, 015, CONTROL_ALIGN_BOTTOM, .T.)
            
            oSize2 := FwDefSize():New(.T.,,,oPanel4)

	        oButton2:AddBtnText("Conpensar", "Compensar", {|| FwMsgRun( , {|| Compensa('TRBNC', TRBNC->(Recno("TRBNC")), @oMarkBrow2)}, , "Aguarde")}, , , CONTROL_ALIGN_RIGHT, .T.) // "Adicionando o(s) Documento(s) de Reserva..."

        else
            oMarkBrow2:Refresh()
            oValAtu:Refresh()
          
            
        EndIF
    
    Return



Static Function fLoadData
Local nI        := 0
Local _cAlias    := GetNextAlias()

    If(Type('oTable') <> 'U')

        oTable:Delete()
        oTable := Nil

    Endif

    oTable     := FwTemporaryTable():New('TRB')

    aCampos     := {}
    aCpoInfo := {}
    aCpoData := {}

    aAdd(aCpoInfo, {'Marcar'            , '@!'                         , 1})
    aAdd(aCpoInfo, {'Cliente'            , '@!'                        , 1})
    aAdd(aCpoInfo, {'Loja'                , '@!'                         , 1})
    aAdd(aCpoInfo, {'CNPJ'                , '@R 99.999.999.9999/99'    , 1})
    aAdd(aCpoInfo, {'Nome'                , '@!'                         , 1})

    aAdd(aCpoData, {'TMP_OK'    , 'C'                        , 2                            , 0})
    aAdd(aCpoData, {'TMP_CLIENT', TamSx3('A1_COD')[3]    , TamSx3('A1_COD')[1]    , 0})
    aAdd(aCpoData, {'TMP_LOJA'    , TamSx3('A1_LOJA')[3]        , TamSx3('A1_LOJA')[1]        , 0})
    aAdd(aCpoData, {'TMP_CGC'    , TamSx3('A1_CGC')[3]        , TamSx3('A1_CGC')[1]        , 0})
    aAdd(aCpoData, {'TMP_NOMCLI', TamSx3('A1_NOME')[3]    , TamSx3('A1_NOME')[1]    , 0})    


    For nI := 1 To Len(aCpoData)

        If(aCpoData[nI][1] <> 'TMP_OK' .and. aCpoData[nI][1] <> 'TMP_RECNO')

            aAdd(aCampos, FwBrwColumn():New())

            aCampos[Len(aCampos)]:SetData( &('{||' + aCpoData[nI,1] + '}') )
            aCampos[Len(aCampos)]:SetTitle(aCpoInfo[nI,1])
            aCampos[Len(aCampos)]:SetPicture(aCpoInfo[nI,2])
            aCampos[Len(aCampos)]:SetSize(aCpoData[nI,3])
            aCampos[Len(aCampos)]:SetDecimal(aCpoData[nI,4])
            aCampos[Len(aCampos)]:SetAlign(aCpoInfo[nI,3])

        EndIf

    Next nI    

    oTable:SetFields(aCpoData)

    oTable:Create()


    BeginSQL Alias _cAlias
    

        SELECT '' as A1_OK, SA1.A1_COD,SA1.A1_LOJA,SA1.A1_NOME,SA1.A1_CGC
        FROM %Table:SA1% SA1  
        INNER JOIN %Table:SE1% SE1 ON SE1.E1_FILIAL = %xFilial:SE1%  AND 
        SE1.E1_CLIENTE = SA1.A1_COD AND  
        SE1.E1_LOJA = SA1.A1_LOJA  AND 
        SE1.E1_TIPO = 'NCC'  AND 
        SE1.E1_SALDO > 0 AND 
        SE1.E1_VENCREA BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND 
        SE1.D_E_L_E_T_ = ''
        WHERE SA1.A1_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND
        SA1.D_E_L_E_T_ = ''

        GROUP BY SA1.A1_COD,SA1.A1_LOJA,SA1.A1_NOME,SA1.A1_CGC
        ORDER BY SA1.A1_COD,SA1.A1_LOJA,SA1.A1_NOME,SA1.A1_CGC

            
    EndSQL

    (_cAlias)->(DbGoTop())

    DbSelectArea('TRB')

    While(!(_cAlias)->(EoF()))

        RecLock('TRB', .T.)

            TRB->TMP_CLIENT    := (_cAlias)->A1_COD
            TRB->TMP_LOJA     := (_cAlias)->A1_LOJA
            TRB->TMP_CGC     := (_cAlias)->A1_CGC
            TRB->TMP_NOMCLI    := (_cAlias)->A1_NOME


        TRB->(MsUnlock())

        (_cAlias)->(DbSkip())

    EndDo

    TRB->(DbGoTop())

    (_cAlias)->(DbCloseArea())

Return

Static Function fLoadNF(cCLiente,cLoja)
Local nI        := 0
Local _cAliNf    := GetNextAlias()

    If(Type('oTable1') <> 'U')

        oTable1:Delete()
        oTable1 := Nil

    Endif

    oTable1     := FwTemporaryTable():New('TRBNF')

    aCmpNF     := {}
    aCpoNF := {}
    aCpoDtNF := {}

    aAdd(aCpoNF, {'Marcar'            , '@!'                         , 1})
    aAdd(aCpoNF, {'Titulo'            , '@!'                        , 1})
    aAdd(aCpoNF, {'Parcela'           , '@!'                         , 1})
    aAdd(aCpoNF, {'Tipo'              , '@!'                          , 1})
    aAdd(aCpoNF, {'Cliente'           , '@!'                         , 1})
    aAdd(aCpoNF, {'Loja'              , '@!'                         , 1})
    aAdd(aCpoNF, {'Emissão'           , '@D'                         , 1})
    aAdd(aCpoNF, {'Vencimento'        , '@D'                         , 1})
    aAdd(aCpoNF, {'Saldo'             , "@E 999,999,999.99"                         , 1})

    aAdd(aCpoDtNF, {'TNF_OK'      , 'C'                        , 2                            , 0})
    aAdd(aCpoDtNF, {'TNF_NUM'     , TamSx3('E1_NUM')[3]    , TamSx3('E1_NUM')[1]    , 0})
    aAdd(aCpoDtNF, {'TNF_PARC' , TamSx3('E1_PARCELA')[3]        , TamSx3('E1_PARCELA')[1]        , 0})
    aAdd(aCpoDtNF, {'TNF_TIPO'    , TamSx3('E1_TIPO')[3]        , TamSx3('E1_TIPO')[1]        , 0})
    aAdd(aCpoDtNF, {'TNF_CLIENT' , TamSx3('E1_CLIENTE')[3]    , TamSx3('E1_CLIENTE')[1]    , 0})    
    aAdd(aCpoDtNF, {'TNF_LOJA'    , TamSx3('E1_LOJA')[3]    , TamSx3('E1_LOJA')[1]    , 0})    
    aAdd(aCpoDtNF, {'TNF_EMISS' , TamSx3('E1_EMISSAO')[3]    , TamSx3('E1_EMISSAO')[1]    , 0})    
    aAdd(aCpoDtNF, {'TNF_VENC' , TamSx3('E1_VENCREA')[3]    , TamSx3('E1_VENCREA')[1]    , 0})    
    aAdd(aCpoDtNF, {'TNF_SALDO'   , TamSx3('E1_SALDO')[3]    , TamSx3('E1_SALDO')[1]    , 0})   
    aAdd(aCpoDtNF, {'TNF_RECNO'     , 'N'    , 15   , 0}) 


    For nI := 1 To Len(aCpoDtNF)

        If(aCpoDtNF[nI][1] <> 'TNF_OK' .and. aCpoDtNF[nI][1] <> 'TNF_RECNO')

            aAdd(aCmpNF, FwBrwColumn():New())

            aCmpNF[Len(aCmpNF)]:SetData( &('{||' + aCpoDtNF[nI,1] + '}') )
            aCmpNF[Len(aCmpNF)]:SetTitle(aCpoNF[nI,1])
            aCmpNF[Len(aCmpNF)]:SetPicture(aCpoNF[nI,2])
            aCmpNF[Len(aCmpNF)]:SetSize(aCpoDtNF[nI,3])
            aCmpNF[Len(aCmpNF)]:SetDecimal(aCpoDtNF[nI,4])
            aCmpNF[Len(aCmpNF)]:SetAlign(aCpoNF[nI,3])

        EndIf

    Next nI    

    oTable1:SetFields(aCpoDtNF)

    oTable1:Create()


    BeginSQL Alias _cAliNf
    

        SELECT '' as E1_OK, SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_EMISSAO, SE1.E1_VENCREA,SE1.E1_SALDO,SE1.R_E_C_N_O_ as SE1RECNO
        FROM %Table:SA1% SA1  
        INNER JOIN %Table:SE1% SE1 ON SE1.E1_FILIAL = %xFilial:SE1%  AND SE1.E1_CLIENTE = SA1.A1_COD AND  SE1.E1_LOJA = SA1.A1_LOJA  AND SE1.E1_TIPO = 'NF'  AND SE1.E1_SALDO > 0 AND SE1.D_E_L_E_T_ = '' AND
        SE1.E1_VENCREA BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND 
        SE1.E1_NUM BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% 
        WHERE SA1.D_E_L_E_T_ = '' AND
        SA1.A1_COD = %Exp:cCLiente% AND
        SA1.A1_LOJA = %Exp:cLoja%
        
        ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_EMISSAO, SE1.E1_VENCREA

            
    EndSQL

    (_cAliNf)->(DbGoTop())

    DbSelectArea('TRBNF')

    While(!(_cAliNf)->(EoF()))

        RecLock('TRBNF', .T.)


            
            TRBNF->TNF_NUM        := (_cAliNf)->E1_NUM
            TRBNF->TNF_PARC    := (_cAliNf)->E1_PARCELA
            TRBNF->TNF_TIPO       := (_cAliNf)->E1_TIPO
            TRBNF->TNF_CLIENT    := (_cAliNf)->E1_CLIENTE
            TRBNF->TNF_LOJA       := (_cAliNf)->E1_LOJA
            TRBNF->TNF_EMISS    := stod((_cAliNf)->E1_EMISSAO)
            TRBNF->TNF_VENC     := stod((_cAliNf)->E1_VENCREA)
            TRBNF->TNF_SALDO      := (_cAliNf)->E1_SALDO
            TRBNF->TNF_RECNO   := (_cAliNf)->SE1RECNO


        TRBNF->(MsUnlock())

        (_cAliNf)->(DbSkip())

    EndDo

    TRBNF->(DbGoTop())

    (_cAliNf)->(DbCloseArea())

Return

Static Function fLoadNCC(cCLiente,cLoja)
Local nI        := 0
Local _cAliNCC    := GetNextAlias()

    If(Type('oTable2') <> 'U')

        oTable2:Delete()
        oTable2 := Nil

    Endif

    oTable2     := FwTemporaryTable():New('TRBNC')

    aCmpNCC     := {}
    aCpoNCC := {}
    aCpoDtNCC := {}

    aAdd(aCpoNCC, {'Marcar'            , '@!'                         , 1})
    aAdd(aCpoNCC, {'Titulo'            , '@!'                        , 1})
    aAdd(aCpoNCC, {'Parcela'           , '@!'                         , 1})
    aAdd(aCpoNCC, {'Tipo'              , '@!'                          , 1})
    aAdd(aCpoNCC, {'Cliente'           , '@!'                         , 1})
    aAdd(aCpoNCC, {'Loja'              , '@!'                         , 1})
    aAdd(aCpoNCC, {'Emissão'           , '@D'                         , 1})
    aAdd(aCpoNCC, {'Vencimento'        , '@D'                         , 1})
    aAdd(aCpoNCC, {'Saldo'             , "@E 999,999,999.99"                         , 1})

    aAdd(aCpoDtNCC, {'TNC_OK'      , 'C'                        , 2                            , 0})
    aAdd(aCpoDtNCC, {'TNC_NUM'     , TamSx3('E1_NUM')[3]    , TamSx3('E1_NUM')[1]    , 0})
    aAdd(aCpoDtNCC, {'TNC_PARC' , TamSx3('E1_PARCELA')[3]        , TamSx3('E1_PARCELA')[1]        , 0})
    aAdd(aCpoDtNCC, {'TNC_TIPO'    , TamSx3('E1_TIPO')[3]        , TamSx3('E1_TIPO')[1]        , 0})
    aAdd(aCpoDtNCC, {'TNC_CLIENT' , TamSx3('E1_CLIENTE')[3]    , TamSx3('E1_CLIENTE')[1]    , 0})    
    aAdd(aCpoDtNCC, {'TNC_LOJA'    , TamSx3('E1_LOJA')[3]    , TamSx3('E1_LOJA')[1]    , 0})    
    aAdd(aCpoDtNCC, {'TNC_EMISS' , TamSx3('E1_EMISSAO')[3]    , TamSx3('E1_EMISSAO')[1]    , 0})    
    aAdd(aCpoDtNCC, {'TNC_VENC' , TamSx3('E1_VENCREA')[3]    , TamSx3('E1_VENCREA')[1]    , 0})    
    aAdd(aCpoDtNCC, {'TNC_SALDO'   , TamSx3('E1_SALDO')[3]    , TamSx3('E1_SALDO')[1]    , 0})    
    aAdd(aCpoDtNCC, {'TNC_RECNO'     , 'N'    , 15   , 0})


    For nI := 1 To Len(aCpoDtNCC)

        If(aCpoDtNCC[nI][1] <> 'TNC_OK' .and. aCpoDtNCC[nI][1] <> 'TNC_RECNO')

            aAdd(aCmpNCC, FwBrwColumn():New())

            aCmpNCC[Len(aCmpNCC)]:SetData( &('{||' + aCpoDtNCC[nI,1] + '}') )
            aCmpNCC[Len(aCmpNCC)]:SetTitle(aCpoNCC[nI,1])
            aCmpNCC[Len(aCmpNCC)]:SetPicture(aCpoNCC[nI,2])
            aCmpNCC[Len(aCmpNCC)]:SetSize(aCpoDtNCC[nI,3])
            aCmpNCC[Len(aCmpNCC)]:SetDecimal(aCpoDtNCC[nI,4])
            aCmpNCC[Len(aCmpNCC)]:SetAlign(aCpoNCC[nI,3])

        EndIf

    Next nI    

    oTable2:SetFields(aCpoDtNCC)

    oTable2:Create()


    BeginSQL Alias _cAliNCC
    

        SELECT '' as E1_OK, SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_EMISSAO, SE1.E1_VENCREA,SE1.E1_SALDO,SE1.R_E_C_N_O_ as SE1RECNO
        FROM %Table:SA1% SA1  
        INNER JOIN %Table:SE1% SE1 ON SE1.E1_FILIAL = %xFilial:SE1%  AND SE1.E1_CLIENTE = SA1.A1_COD AND  SE1.E1_LOJA = SA1.A1_LOJA  AND SE1.E1_TIPO = 'NCC'  AND SE1.E1_SALDO > 0 AND SE1.D_E_L_E_T_ = '' AND
        SE1.E1_VENCREA BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
        WHERE SA1.D_E_L_E_T_ = '' AND
        SA1.A1_COD = %Exp:cCLiente% AND
        SA1.A1_LOJA = %Exp:cLoja%
        
        ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_EMISSAO, SE1.E1_VENCREA

            
    EndSQL

    (_cAliNCC)->(DbGoTop())

    DbSelectArea('TRBNC')

    While(!(_cAliNCC)->(EoF()))

        RecLock('TRBNC', .T.)


            
            TRBNC->TNC_NUM        := (_cAliNCC)->E1_NUM
            TRBNC->TNC_PARC    := (_cAliNCC)->E1_PARCELA
            TRBNC->TNC_TIPO       := (_cAliNCC)->E1_TIPO
            TRBNC->TNC_CLIENT    := (_cAliNCC)->E1_CLIENTE
            TRBNC->TNC_LOJA       := (_cAliNCC)->E1_LOJA
            TRBNC->TNC_EMISS    := stod((_cAliNCC)->E1_EMISSAO)
            TRBNC->TNC_VENC     := stod((_cAliNCC)->E1_VENCREA)
            TRBNC->TNC_SALDO      := (_cAliNCC)->E1_SALDO
            TRBNC->TNC_RECNO   := (_cAliNCC)->SE1RECNO


        TRBNC->(MsUnlock())

        (_cAliNCC)->(DbSkip())

    EndDo

    TRBNC->(DbGoTop())

    (_cAliNCC)->(DbCloseArea())

Return

Static Function ChangeMRK(_cAliasMED, _nRecno, oBrwMrk,lRecno)


    (_cAliasMED)->(dbGoTOp())
    While !(_cAliasMED)->(Eof())
    
    	If (_cAliasMED)->(Recno()) <> _nRecno .and. oBrwMrk:IsMark()
    		oBrwMrk:MarkRec()
    	EndIf

        If _cAliasMED == "TRBNF" .AND. oBrwMrk:IsMark()
            cRecNF := (_cAliasMED)->TNF_RECNO
            lRecno := .T.
        EndIf

        If _cAliasMED == "TRBNF" .AND. !oBrwMrk:IsMark() .AND. !lRecno
            cRecNF := ''
        EndIf

        If _cAliasMED == 'TRB' .AND. !Empty((_cAliasMED)->TMP_OK)
            nValorTot := 0
            
            NFNCC(TMP_CLIENT,TMP_LOJA)

        EndIf

    	(_cAliasMED)->(dbSkip())
    
    EndDo
    oBrwMrk:GoTo(_nRecno)


Return

Static Function NCCTOTAL(_cAliasNCC, _nRecno, oBrwMrk)

        If _cAliasNCC == 'TRBNC' .AND. !Empty((_cAliasNCC)->TNC_OK)
            nValorTot += TNC_SALDO
            oValAtu:Refresh()

        else
            nValorTot -= TNC_SALDO
            oValAtu:Refresh()
        EndIf
    

Return

Static Function Compensa(_cAliasCOMP, _nRecno, oBrwMrk)
    Local lContabiliza := .F.
    Local lAglutina := .F.
    Local lDigita := .F.
    Local cCliente := ''
    Local cLoja := ''
    Local LERRO := .F.

    

    If Empty(cRecNF)
        Aviso("Help","Para que possa realizar a compensação é necessário selecionar um título e uma ou mais NCC's. " )
        Return

    EndIf

    (_cAliasCOMP)->(dbGoTOp())

    While !(_cAliasCOMP)->(Eof())
        
        If !Empty((_cAliasCOMP)->TNC_OK)
       
	        If !MaIntBxCR(3,{cRecNF},,{(_cAliasCOMP)->TNC_RECNO},,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase )

	        	lErro := .T.
                EXIT
            else
                cCliente := (_cAliasCOMP)->TNC_CLIENT
                cLoja := (_cAliasCOMP)->TNC_LOJA    
	        EndIf
 
        EndIF  

        (_cAliasCOMP)->(dbskip())
    EndDo  



    iF !lErro
        Aviso("Sucesso","Compensação do título realizada com sucesso " )
        nValorTot := 0
        cRecNF := ''
        NFNCC(cCliente,cLoja) 
    else
        
        Aviso("Help","Impossivel realizar compensação do título, o mesmo devera ser compensado manualmente." )
    EndIf
   
Return

Static Function ValidPerg(cPerg)
	Local aArea := GetArea()

	xPUTSX1(cPerg   ,"01","Vencimento De ?"            ,"Vencimento De ?" ,"Vencimento De ?"     ,"MV_CH1"   ,"D",8                      ,0,0,"G","" ,""     ,"","","MV_PAR01","","","","","","","","","","","","","","","","")
    xPUTSX1(cPerg   ,"02","Vencimento Até ?"           ,"Vencimento Até ?" ,"Vencimento Até ?"   ,"MV_CH2"   ,"D",8                      ,0,0,"G","" ,""     ,"","","MV_PAR02","","","","","","","","","","","","","","","","")   
    xPUTSX1(cPerg	,"03","Cliente De ?" 	        ,''             ,''                 ,"MV_CH3"   ,"C",TAMSX3("B2_COD")[1] 	,0, ,"G",""	,"SA1"  ,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPUTSX1(cPerg	,"04","Cliente Ate?"            ,''             ,''                 ,"MV_CH4"	,"C",TAMSX3("B2_COD")[1] 	,0, ,"G",""	,"SA1"  ,"","","mv_par04","","","","","","","","","","","","","","","","")
    xPutSx1(cPerg	,"05","Titulo De ?" 	        ,''             ,''                 ,"MV_CH5"	,"C",TAMSX3("E1_NUM")[1]    ,0, ,"G",""	,""	    ,"","","mv_par05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg	,"06","Titulo Até ?" 	        ,''             ,''                 ,"MV_CH6"	,"C",TAMSX3("E1_NUM")[1]    ,0, ,"G",""	,""	    ,"","","mv_par06","","","","","","","","","","","","","","","","")

	RestArea( aArea )

Return

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)
	*********************************************************************
	Local aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme       == Nil, " ", cPyme       )
	cF3      := Iif( cF3         == NIl, " ", cF3         )
	cGrpSxg  := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01      == Nil, "" , cCnt01      )
	cHelp    := Iif( cHelp       == Nil, "" , cHelp       )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		//     PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
