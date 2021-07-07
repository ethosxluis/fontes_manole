#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH" 

User Function TstSeek()

Local cCod
Local cLoja

//           0        10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1   := " Cod. Atual    Cod. Antigo"
//Cabec2   := " I.S.B.N.                     Titulo                        Autor                      Evento                   Consig         Dev.Simbol     Dev. Fisica    Faturado       Pendente       "
//Cabec2   := " I.S.B.N.           Titulo                         Autor                        Evento    Prc. Bru       Consig         Dev.Simbol     Devolucao      Faturado       Pendente    Total Liquido"

//--------------------------------------------------------------------//
// Escreva uma funcao para mostrar os clientes em ordem alfabetica de nome.

dbSelectArea("SA1")
dbSetOrder(1)

/*
cCod := "000010"
cLoja := "01"
dbSeek(xFilial("SA1") + cCod + cLoja)
MsgAlert(SA1->A1_Nome)

MsgAlert(IIf(EOF(), "Fim de arquivo", Str(Recno())))

//cCod := "ABC123"
//cLoja := "00"
If dbSeek(xFilial("SA1") + cCod + cLoja)
   MsgAlert(SA1->A1_Nome)
 Else
   MsgAlert("Cliente nao encontrado.")
EndIf

MsgAlert(IIf(EOF(), "Fim de arquivo", Str(Recno())))
*/

While !Eof()
		cNomeCli := Posicione("SA1",1,xFilial("SA1")+(cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA,"A1_NREDUZ")
		cNomeVend := Posicione("SA3",1,xFilial("SA3")+(cAliasNew)->A1_VEND,"A3_NREDUZ")
		@ Li, 000 PSay (cAliasNew)->Z2_CLIENTE + " "+ (cAliasNew)->Z2_LOJA +" - "+ cNomeCli + " "+ (cAliasNew)->A1_VEND+ " - "+cNomeVend
		Li++
		@ Li,000 Psay __PrtThinLine()
		Li++
		
		cChave  := (cAliasNew)->Z2_CLIENTE + (cAliasNew)->Z2_LOJA
		nTotPen := 0
	End
	
	@ Li, 000 PSay ("SA1")->Z2_PRODUTO

    
    ("SA1")->(dbSkip())
	nTotPen += nQtdPen

Return Nil

User Function TstOrdem()

dbSelectArea("SA1")
dbSetOrder(2)
dbGoTop()

While !EOF()

   MsgAlert(SA1->A1_Nome)
   dbSkip()

   Exit
   
End

Return Nil

