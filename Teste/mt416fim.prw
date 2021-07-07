#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MT416FIM
Ponto de entrada para preenchimento do campo C6_LOTCTL a partir do CK_LOTECTL
@type function
@author Luis
@since 20/11/2020
@version 1.0
/*/




user function MT416FIM()




_pedido  := SCJ->CJ_NUM
_client  := SCJ->CJ_CLIENTE
_lojacli := SCJ->CJ_LOJA

DBSELECTAREA("SCK")
DBGOTOP()
DBSETORDER(2)
DBSEEK(xfilial("SCK") + _client + _lojacli + _pedido )

     while !eof() .and. _pedido == SCK->CK_NUM .AND. SCK->CK_CLIENTE == _client .and. SCK->CK_LOJA == _lojacli
     _lotectl := SCK->CK_LOTECTL
     _dtvalid := dtos(SCK->CK_DTVALID)

      cQuery:= "UPDATE "+retsqlname("SC6")+" SET C6_LOTECTL='"+_lotectl+",SET C6_DTVALID='"+_dtvalid+"'  WHERE SUBSTRING(C6_NUMORC,1,6) = '"+SCK->CK_NUM+"' AND C6_ITEM='"+SCK->CK_ITEM+"' AND C6_CLI = '"+SCK->CK_CLIENTE+"'"
    //  cQuery:= "UPDATE "+retsqlname("SC6")+" SET C6_DTVALID='"+_dtvalid+"'  WHERE SUBSTRING(C6_NUMORC,1,6) = '"+SCK->CK_NUM+"' AND C6_ITEM='"+SCK->CK_ITEM+"' AND C6_CLI = '"+SCK->CK_CLIENTE+"'"
      TCSQLExec(cQuery)

      DBSKIP()

     enddo
       


RETURN()
