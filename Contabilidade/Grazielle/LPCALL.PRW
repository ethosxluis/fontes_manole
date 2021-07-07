/*/{Protheus.doc} LPCALL
//TODO

Função generica para chamadas de LP grandes demais para o campo da formula.

@type function
@version 12.1.25
@author Smurfete (Cabeça de Concreto)
@since 27/08/2020
@param _cLP, param_type, param_description
@param _cSeq, param_type, param_description
@return return_type, return_description
/*/

#Include "TOTVS.CH"

User Function LPCALL(_cLP, _cSeq)

    Local _cKey  := ""
    Local _nRet  := 0
    Local _aArea := GetArea()

    Default _cLP  := "000"
    Default _cSeq := "000"

    //COFINS - SD2->D2_VALIMP5
    //PIS    - SD2->D2_VAMIMP6
    //ISS    - SD2->D2_VALISS

    //SD2 (3) - D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

    If _cLP $ '520#521' 

        _cKey := SE1->(E1_FILIAL+E1_NUM+E1_PREFIXO+E1_CLIENTE+E1_LOJA)
        
        dbSelectArea("SD2")
        SD2->(dbSetOrder(3))
        If SD2->(MsSeek(_cKey))

            While SD2->(!Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == _cKey

                dbSelectArea("SF4")
                SF4->(dbSetOrder(1))
                If SF4->(MsSeek(FWxFilial("SF4")+SD2->D2_TES))

                    If SF4->F4_GRPCON $ "S010/S011"

                        If _cSeq == '005' //PIS
                            
                            _nRet += SD2->D2_VALIMP6

                        Elseif _cSeq == '006' //COFINS

                            _nRet += SD2->D2_VALIMP5

                        Elseif _cSeq == '007' // ISS

                            _nRet += SD2->D2_VALISS

                        Endif

                    Endif

                Endif

                SD2->(dbSkip())
            End

        Endif

    Endif

    _nRet := _nRet  / fPropTit(SE1->E1_NUM, SE1->E1_PREFIXO, SE1->E1_CLIENTE, SE1->E1_LOJA)
    
    RestArea(_aArea)

Return _nRet

/*/{Protheus.doc} fPropTit

Funcao auxiliar para proporcionalizar os valores contabilizados.

@type function
@version 
@author Peder Munksgaard 
@since 13/09/2020
@param _cDoc, param_type, param_description
@param _cSerie, param_type, param_description
@param _cCliente, param_type, param_description
@param _cLoja, param_type, param_description
@return return_type, return_description
/*/
Static Function fPropTit(_cDoc, _cSerie, _cCliente, _cLoja)

    Local _cQry := ""
    Local _cTrb := ""
    Local _nRet := 1

    _cQry := "SELECT SUM(1) AS TOTAL FROM " + RetSqlName("SE1") + " SE1 " + CRLF
    _cQry += "WHERE SE1.D_E_L_E_T_ = ' '                                " + CRLF
    _cQry += "AND   SE1.E1_LOJA    = '" + _cLoja + "'                   " + CRLF
    _cQry += "AND   SE1.E1_CLIENTE = '" + _cCliente + "'                " + CRLF
    //_cQry += "AND   SE1.E1_TIPO    = 'NF'                               " + CRLF
    _cQry += "AND   SE1.E1_PREFIXO = '" + _cSerie + "'                  " + CRLF
    _cQry += "AND   SE1.E1_NUM     = '" + _cDoc   + "'                  " + CRLF
    _cQry += "AND   SE1.E1_FILIAL  = '" + FWxFilial("SE1") + "'         " + CRLF

    _cTrb := MpSysOpenQuery(_cQry)

    If (_cTrb)->(!Eof())

        _nRet := (_cTrb)->TOTAL

    Endif

    (_cTrb)->(dbCloseArea())

Return _nRet
