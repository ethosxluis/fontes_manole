#include "Protheus.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? F376QRY ?  Autor ?Edmar Mendes Prado  ? Data ?  27/06/2019 ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Filtrar c?digos de reten??o na aglutina??o de impostos     ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
??? 																	  ???
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function F376QRY()

Local cRet		:= " AND E2_CODRET BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"' "


Return(cRet)