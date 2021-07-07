User Function NCCCONC()
    Local cAliNCC  := GetNextAlias()
    Local lContabiliza := .F.
    Local lAglutina := .F.
    Local lDigita := .F.
    Local aRecSE1 := {}
    Local aRecNCC := {}
    Local lErro := .F.

    aAdd( aRecSE1, SE1->( RecNo() ) )

    BeginSQL Alias cAliNCC
    
        SELECT SC5.C5_FILIAL,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_PGVTTID,SE1.E1_TIPO,SE1.E1_SALDO,SE1.E1_NUM,SE1.R_E_C_N_O_ SE1RECNO  FROM %Table:SC5% SC5 
        INNER JOIN %Table:SE1% SE1  ON SE1.E1_FILIAL = SC5.C5_FILIAL AND 
            SE1.E1_CLIENTE = SC5.C5_CLIENTE AND 
            SE1.E1_LOJA = SC5.C5_LOJACLI  AND
            SE1.E1_PGVTTID = SC5.C5_PGVTTID AND
            SE1.E1_TIPO = 'NCC' AND
            SE1.E1_SALDO > 0 AND 
            SE1.D_E_L_E_T_ = ''
        WHERE 
        SC5.C5_FILIAL = %xFilial:SC5% AND
        SC5.C5_PGVTTID = %Exp:SC5->C5_PGVTTID% AND
        SC5.C5_CLIENTE = %Exp:SC5->C5_CLIENTE% AND
        SC5.C5_LOJACLI = %Exp:SC5->C5_LOJACLI% AND
        SC5.D_E_L_E_T_ = ''
    
    EndSQL

    If EMPTY((cAliNCC)->E1_NUM)
        Aviso("Help","Impossivel realizar compensação, não foi encontrado nenhuma NCC para o Cliente " + (cAliNCC)->C5_CLIENTE)
        Return
    EndIF

    While !(cAliNCC)->(Eof())
        aRecNCC := {(cAliNCC)->SE1RECNO}
        If SE1->E1_SALDO <> 0
	        If !MaIntBxCR(3,aRecSE1,,aRecNCC,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase )
	        	lErro := .T.
                EXIT
	        EndIf
        EndIf    
        (cAliNCC)->(dbskip())
    EndDo  

    iF !lErro
        Aviso("Sucesso","Compensação do título "+ SE1->E1_NUM + " realizada com sucesso " )
    else
        Aviso("Help","Impossivel realizar compensação do título "+ SE1->E1_NUM + " o mesmo devera ser compensado manualmente." )
    EndIf


Return
