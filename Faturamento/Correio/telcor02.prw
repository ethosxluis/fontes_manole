#include "protheus.ch"   
#include "rwmake.ch"   
#include "topconn.ch"
#include "tbiconn.ch"


#Define ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TELCOR02 º Autor ³ FONTANELLI         º Data ³  02/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ OBJETOS RASTREIO DO CORREIO 			                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANOLE                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
              
	// U_TELCOR02()

User Function TELCOR02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Objetos Rastreio do Correio"
Private cLegenda  := "Legenda"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := {  	{"Pesquisar"    ,"AxPesqui"										,0,1} ,;
						{"Visualizar"   ,"AxVisual"  									,0,2} ,;
						{"Gerar" 	    ,"U_TELCORG()"				  					,0,3} ,;
						{"Excluir"      ,"AxDeleta"  					  				,0,5} ,;
						{"Legenda"   	,"BrwLegenda(cCadastro,cLegenda,aCoresLeg)" 	,0,10 }		}


						//{"Incluir"      ,"AxInclui"  									,0,3} ,;
						//{"Alterar"      ,"AxAltera"  									,0,4} ,;
						//{"Excluir"      ,"AxDeleta"  					  				,0,5} ,;

							
Private aCores := {	{ " UA5->UA5_NF == '         ' "	,	"BR_VERDE" 				} ,;
					{ " UA5->UA5_NF <> '         ' "	,	"BR_VERMELHO" 			} 	}
							
Private aCoresLeg := {	{ "BR_VERDE"   		, "Livre" 		 	} ,;
						{ "BR_VERMELHO"	 	, "Usado"			}  }

						
dbSelectArea("UA5")
dbSetOrder(1)
mBrowse(6,1,22,75,"UA5",,,,,,aCores)
Set Key 123 To

Return                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TELCORG   ºAutor  ³FONTANELLI          º Data ³  01/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geraçao de Novas sequencias por Tipo de Servico do Correio º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TELCORG()

Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oGet3
Local oGet4
Local oGet5
Local oGroup1
Local oSay1
Local oSay2
Local oSay3                          
Local oSay4                          
Local oSay5
Static oDlg
Public cGet1 := SPACE(06)
Public cGet2 := SPACE(02)
Public cGet3 := 0
Public cGet4 := 0
Public cGet5 := dDataBase

DEFINE MSDIALOG oDlg TITLE "Novas Sequencias por Tipo de Serviço do Correio" FROM 000, 000  TO 335, 400 COLORS 0, 16777215 PIXEL

    @ 003, 004 GROUP oGroup1 TO 146, 196 PROMPT " I N F O R M E" OF oDlg COLOR 0, 16777215 PIXEL
    @ 150, 118 BUTTON oButton1 PROMPT "G E R A R" SIZE 037, 012 OF oDlg PIXEL ACTION (U_TELCORS(cGet1,cGet2,cGet3,cGet4,cGet5),oDlg:End()) 
    @ 150, 159 BUTTON oButton2 PROMPT "S A I R" SIZE 037, 012 OF oDlg PIXEL ACTION (oDlg:End())
    @ 020, 011 SAY oSay1 PROMPT "Transportadora" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 028, 011 MSGET oGet1 VAR cGet1 F3 "UA4" WHEN .T. VALID (U_TELCORV(cGet1)) SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 045, 011 SAY oSay2 PROMPT "Tipo de Serviço" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 053, 011 MSGET oGet2 VAR cGet2 WHEN .F. SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL                    
    
    @ 070, 011 SAY oSay3 PROMPT "Sequência Inicial" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 078, 011 MSGET oGet3 VAR cGet3 WHEN .T. SIZE 035, 010 PICTURE "99999999" OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 095, 011 SAY oSay4 PROMPT "Sequência Final" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 103, 011 MSGET oGet4 VAR cGet4 WHEN .T. SIZE 035, 010 PICTURE "99999999" OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 120, 011 SAY oSay5 PROMPT "Data" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 128, 011 MSGET oGet5 VAR cGet5 WHEN .F. SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TELCORV  ³ Autor ³FONTANELLI             ³ Data ³ 07/06/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Tipo de Servico do Correio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TELCORV(cGet1)             
	lRet := .T.
	IF !Empty(cGet1)
		dbSelectArea("UA4")
		dbSetOrder(1)
		UA4->(DbGoTop())       
		if dbSeek(xFilial("UA4")+cGet1) 
		   lRet := .T.  
		else
			lRet := .F.
			Aviso("Aviso","Transportadora e Tipo de Serviço: "+cGet1+", não existe !", {"OK"})   
		endif
    endif
Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TELCORS  ³ Autor ³FONTANELLI             ³ Data ³ 07/06/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Geracao da Sequencia por Tipo de Serviço                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TELCORS(cGet1,cGet2,cGet3,cGet4,cGet5)     

             
	if Empty(cGet1) .or. Empty(cGet2) .or. Empty(ALLTRIM(STR(cGet3))) .or. Empty(ALLTRIM(STR(cGet4)))
		Aviso("Aviso","Obrigatorio preencher todos os campos !", {"OK"})   
	else

		cQuery := " SELECT COUNT(*) QTD FROM "+RetSqlName("UA5")+" "+CHR(13)+CHR(10)
 		cQuery += "  WHERE UA5_FILIAL = '"+xFilial("UA5")+"' "+CHR(13)+CHR(10)
   	    cQuery += "    AND SUBSTR(UA5_OBJETO,1,2) = '"+cGet2+"' "+CHR(13)+CHR(10)
        cQuery += "    AND SUBSTR(UA5_OBJETO,3,8) BETWEEN '"+STRZERO(cGet3,8)+"' AND '"+STRZERO(cGet4,8)+"' "+CHR(13)+CHR(10)
        cQuery += "    AND D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMPQTD',.F.,.F.)
		DbSelectArea("TMPQTD")
		TMPQTD->(DbGoTop())   
		nQTD := TMPQTD->QTD
		TMPQTD->(dbCloseArea())	\

		if nQTD > 0 
			Aviso("Aviso","Sequencia informada já existe !", {"OK"})   
		else
        
			For nSEQ:= cGet3 to cGet4
			
				RecLock("UA5",.T.)
				UA5->UA5_FILIAL := xFilial("UA5")
				UA5->UA5_TRANSP := cGet1
				UA5->UA5_TIPO   := cGet2
				UA5->UA5_DATA   := cGet5
                                                
				nDIGITO := ;
				VAL(SUBSTR(STRZERO(nSEQ,8),1,1))*8+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),2,1))*6+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),3,1))*4+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),4,1))*2+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),5,1))*3+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),6,1))*5+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),7,1))*9+ ;
				VAL(SUBSTR(STRZERO(nSEQ,8),8,1))*7  
				
				nRESTO :=  MOD(nDIGITO,11)
				
				if nRESTO == 0
				   cDV := '5'
				elseif nRESTO == 1		
					cDV := '0'
				else
					cDV := ALLTRIM(STR(11 - nRESTO))
				endif	
				
				UA5->UA5_OBJETO := cGet2+STRZERO(nSEQ,8)+cDV+"BR"

				UA5->UA5_NF     := SPACE(9)
				UA5->UA5_SERIE  := SPACE(3)
				UA5->(msunlock())
			Next nSEQ

			Aviso("Aviso","Sequência criada com sucesso !", {"OK"})   

		endif              

	endif
		
Return
