/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MANA001   ºAutor  ³Paulo Figueira      º Data ³  02/14/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controlar o desconto por cliente e por segmento do produto. º±±
±±º          ³Funcao de validacao de usuario chamada pelo campo C5_CLIENTEº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Manole                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MANA001()

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+ M->C5_CLIENTE+M->C5_LOJACLI)           
    
	M->C5_XDESC1		:= SA1->A1_XDESC1
	M->C5_XDESC2		:= SA1->A1_XDESC2
	M->C5_XDESC3		:= SA1->A1_XDESC3
	M->C5_XDESC4		:= SA1->A1_XDESC4
	M->C5_XDESC5		:= SA1->A1_XDESC5
	M->C5_XDESC6		:= SA1->A1_XDESC6	      
	M->C5_XCOMIS1		:= SA1->A1_XCOMIS1
	M->C5_XCOMIS2		:= SA1->A1_XCOMIS2
	M->C5_XCOMIS3		:= SA1->A1_XCOMIS3
	M->C5_XCOMIS4		:= SA1->A1_XCOMIS4
	M->C5_XCOMIS5		:= SA1->A1_XCOMIS5
	M->C5_XCOMIS6    	:= SA1->A1_XCOMIS6

EndIf

Return .T.
