#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOPCONN.CH"

/*
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecBlock ณ LP596CGC  บAutor  ณWALDIR ARRUDA       17/04/15             บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  CONTABILIZAวรO DE COMPENSAวรO DE TอTULO A RECEBER DEBITO   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  SALTON                                                     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
User Function LP596CGC()
********************
Local aAREA_ATU	:= GetArea()
Local aAREA_SE5	:= SE5->( GetArea() )
Local cCGC        := ""
Local cChave      := ""
Local cQuery      := ""

IF Alltrim(SE5->E5_TIPO)=="RA"
	nREGATU := SE5->(RECNO())
	
	// procurando lancamento parceiro
	
	/*
	DbSelectArea("SE5")
	// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+E5_RECPAG
	DbSetOrder(7)
	
	cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
	Substr(SE5->E5_DOCUMEN,4,9)+;
	Substr(SE5->E5_DOCUMEN,13,2)+;
	Substr(SE5->E5_DOCUMEN,15,3)+;
	Substr(SE5->E5_DOCUMEN,18,6)+;
	Substr(SE5->E5_DOCUMEN,24,4)
	
	DbSeek( xFilial("SE5") + cCHAVE )
	*/
	
	// Para pesquisa do tipo PARCEIRO estava usando a chave composta acima, porem o
	// campo E5_DOCUMEN nao tem o codigo do cliente nos lctos de tipo RA
	// assim a pesquisa com SEEK nao estava funcionando
	
	cPREFIXO := Substr(SE5->E5_DOCUMEN,1,3)  // 1-PREFIXO
	cNUMERO  := Substr(SE5->E5_DOCUMEN,4,9)  // 2-NUMERO
	cPARC    := Substr(SE5->E5_DOCUMEN,13,2) // 3-PARCELA
	cTIPO    := Substr(SE5->E5_DOCUMEN,15,3) // 4-TIPO
	
	// nao sendo NOTA CREDITO, posiciona sobre o parceiro afim de pegar o
	// codigo do cliente desse
	cQuery += "SELECT R_E_C_N_O_ REG FROM "+RETSQLNAME("SE5")+CRLF
	cQuery += " WHERE D_E_L_E_T_=' '"+CRLF
	cQuery += "   AND E5_DATA='"+DTOS(SE5->E5_DATA)+"'"+CRLF
	cQuery += "   AND E5_NUMERO='"+cNUMERO+"'"+CRLF
	cQuery += "   AND E5_PREFIXO='"+cPREFIXO+"'"+CRLF
	cQuery += "   AND E5_PARCELA='"+cPARC+"'"+CRLF
	cQuery += "   AND E5_TIPO='"+cTIPO+"'"+CRLF
	cQuery += "   AND E5_FILIAL='"+XFILIAL("SE5")+"'"+CRLF
	
	IF SELECT("TRBX") > 0
		TRBX->(DBCLOSEAREA())
	ENDIF
	
	TCQUERY cQUERY NEW ALIAS "TRBX"
	
	IF TRBX->REG=0            // se nao achou o titulo parceiro, posiciona
		SE5->(DBGOTO(nREGATU)) // de volta no tit RA e usa a A1_CONTA do cliente dessa lcto
	ELSE
		SE5->(DBGOTO( TRBX->REG )) // posicione no registro encontrado na query
	ENDIF
	
	IF ALLTRIM(SE5->E5_TIPO)=="NCC" // RELAT DESPEAS
		SA1->(DBSETORDER(1))
		cCHAVE := SE5->E5_CLIFOR + SE5->E5_LOJA
		SA1->(DBSEEK( XFILIAL("SA1") + cCHAVE ))
		cCGC := SA1->A1_CGC
	ENDIF
	
ELSEIF Alltrim(SE5->E5_TIPO)=="NCC"
	
	SA1->(DBSETORDER(1))
	cCHAVE := SE5->E5_CLIFOR + SE5->E5_LOJA
	SA1->(DBSEEK( XFILIAL("SA1") + cCHAVE ))
	cCGC := SA1->A1_CGC
ENDIF

RestArea(aAREA_SE5)
RestArea(aAREA_ATU)
Return(cCGC)

