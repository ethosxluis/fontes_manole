USER FUNCTION LP650009()
LOCAL cConta	:= ""
LOCAL aAREA_ATU	:= GETAREA()

If SF2->F2_TIPO == "D" //devolucao

	DBSelectArea("SE2")
	DBSetOrder(6)
	DBSeeK(xFilial("SE2") + SF2->F2_CLIENTE+SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC )
    

	DBSelectArea("SED")
	DBSetOrder(1)
	DBSeek( XFILIAL("SED") + SE2->E2_NATUREZ )
	cConta := SED->ED_CONTA

EndIf

RESTAREA(aAREA_ATU)

RETURN(cConta)
