#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#include 'parmtype.ch'

User Function NDFCONC()
    Local cAliNDF  := GetNextAlias()
    Local lContabiliza := .F.
    Local lAglutina := .F.
    Local lDigita := .F.
    Local aRecSE2 := {}
    Local aRecNDF := {}
    Local lErro := .F.


    aAdd( aRecSE2, SE2->( RecNo() ) )

    BeginSQL Alias cAliNDF

        SELECT SE2.E2_FILIAL, SE2.E2_SALDO ,SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NUMBOR,
        SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_TIPO,SE2.E2_MOEDA, SE2.R_E_C_N_O_ SE2RECNO 
        FROM %Table:SE2% SE2 
        WHERE SE2.E2_TIPO = 'NDF' AND 
              SE2.E2_FILIAL = %xFilial:SE2% AND
              SE2.E2_FORNECE = %Exp:GETMV("FS_CONCFOR",.T.,"F97841")%  AND 
              SE2.E2_SALDO > 0 AND 
              SE2.D_E_L_E_T_ = ''
    
    EndSQL      


    If EMPTY((cAliNDF)->E2_NUM)
        Aviso("Help","Impossivel realizar compensação, não foi encontrado nenhuma NDF para o fornecedor " + (cAliNDF)->E2_FORNECE)
        Return
    EndIF

    //aAdd( aRecNDF, (cAliNDF)->SE2RECNO )
    
    While !(cAliNDF)->(Eof())
        aRecNDF := {(cAliNDF)->SE2RECNO}
        If SE2->E2_SALDO <> 0
	        If !MaIntBxCP(2,aRecSE2,,aRecNDF,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase)
	        	lErro := .T.
                EXIT
	        EndIf
        EndIf    
        (cAliNDF)->(dbskip())
    EndDo    

    iF !lErro
        Aviso("Sucesso","Compensação do título "+ SE2->E2_NUM + " realizada com sucesso " )
    else
        Aviso("Help","Impossivel realizar compensação do título "+ SE2->E2_NUM + " o mesmo devera ser compensado manualmente." )
    EndIf

Return
