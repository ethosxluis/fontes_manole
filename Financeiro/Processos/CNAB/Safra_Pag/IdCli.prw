#include "rwmake.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?IDCLI     ?Autor  ?Erica M Felix        ? Data ?  04/10/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Programa que retorna o Id do Cliente                       ???
???          ? Banco Safra / Pagamento de T?tulos                         ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP11                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function IdCli()

Local _cIdCli

  If SEA->EA_MODELO$"01/03/41/43"

	_cIdCli := If(SA2->A2_TIPO == "F","1","2")

    Else

	_cIdCli := " "

	EndIf

Return(_cIdCli)
