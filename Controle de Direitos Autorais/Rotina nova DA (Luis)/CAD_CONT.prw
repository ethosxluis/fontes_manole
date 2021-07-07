#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDef.ch"

user function CAD_CONT()


Private aStruAH1 	:= AH1->(dbStruct())
Private aStruAH2 	:= AH2->(dbStruct())
Private aStruP04 	:= P04->(dbStruct())
Private aStruP05 	:= P05->(dbStruct())



Processa({|| SELPROD()},"Selecionando produtos aguarde...")

RETURN()

static function SELPROD()

Local n:= 0
// GRAVAÇÃO DA TABELA TR4(temporária) que vai gravar na AH1

AH1->(DBSETORDER(1))
P04->(DBSETORDER(1))

        While AH1->( !eof() ) 

				reclock("P04",.T.)				      

				  FOR n:= 1 to len( aStruAH1)

				      	_campo2 := "P04->" + aStruP04[n][1]
				        _campo  := "AH1->" + aStruAH1[n][1]
				        &(_campo2) := &(_campo)
				    	
				  NEXT

			    msunlock()

			    AH1->(DBSKIP())
		Enddo

AH2->(DBSETORDER(1))
P05->(DBSETORDER(1))

        While AH2->( !eof() ) 

				reclock("P05",.T.)				      

				  FOR n:= 1 to len( aStruAH2)

				      	_campo2 := "P05->" + aStruP05[n][1]
				        _campo  := "AH2->" + aStruAH2[n][1]
				        &(_campo2) := &(_campo)
				    	
				  NEXT

			    msunlock()

			    AH2->(DBSKIP())
		Enddo





return()


