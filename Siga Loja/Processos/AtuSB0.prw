#Include 'rwmake.ch'
#include "Protheus.ch"

User Function AtuSB0()


If CBYesNo("Confirma Atualiza��o da Carga de Pre�o dos Produtos ?","Aviso")

	DbSelectArea("SB0")
	SB0->(DBGOTOP())
	While  !SB0->(eof())
		Reclock("SB0",.F.)
		DBDelete()
		Msunlock()
		SB0->(DBSkip())
	Enddo

	DbSelectArea("SB1")
	DbSetOrder(1)
	SB1->(DBGOTOP())
	Do While !SB1->(eof()) .and. SB1->B1_FILIAL == xFilial("SB1")

		If SB1->B1_PRV1 == 0
			DbSkip()
			Loop
		Endif

		If SB1->B1_TIPO <> "PA"
			DbSkip()
			Loop
		Endif

		DbSelectArea("SB0")
		Reclock("SB0",.T.)
		SB0->B0_FILIAL  := SB1->B1_FILIAL
		SB0->B0_COD     := SB1->B1_COD
		SB0->B0_PRV1    := SB1->B1_PRV1
		SB0->B0_ECFLAG  :=  '1'
		Msunlock()

		DbSelectArea("SB1")
		SB1->(DbSkip())

	endDO

  	MsgAlert("Carga de Pre�o dos Produtos Atualizada ! ")

else

  	MsgAlert("Cancelado pelo Usu�rio a Carga de Pre�o dos Produtos ! ")

endif


return
