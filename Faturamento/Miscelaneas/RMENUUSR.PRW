#include"rwmake.ch"
#include"topconn.ch"
#include"fileio.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RMENUUSR  ºAutor  ³ANDERSON CIRIACO    º Data ³  10/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RETORNA ARQUIVO CSV COM DADOS DO USUARIO SELECIONADO        º±±
±±º          ³MELHORIAS SAO BEM VINDAS DESDE QUE SEJAM COMENTADAS ABAIXO  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CREATIVE COMMONS                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//FUNCAO PROCUSER
USER FUNCTION RMENUUSR()

Local cArqTrab  := ""
Local aCampos   := {}
Local aStru     := {}
Local cMarca    := GetMark()
LOCAL AAREA := GETAREA()
LOCAL APROC := {}
PRIVATE _I := 1
PRIVATE _J := 0
PRIVATE _K := 0
PRIVATE _Y := 0
PRIVATE aRet := {}
PRIVATE cAliasTop := GetNextAlias()
PRIVATE lInverte:=.F., oDlg01
Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
	TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

aAdd(aCampos,{"OK"     		,"","  ",""})
aAdd(aCampos,{"CODUSER" 	,"","Cod.Usuario",""})
aAdd(aCampos,{"USERNAME"  	,"","Username",""})
aAdd(aCampos,{"NOME" 		,"","Nome Completo",""})

aAdd(aStru,{"OK"     	,"C",02,0 })
aAdd(aStru,{"CODUSER" 	,"C",06,0 })
aAdd(aStru,{"USERNAME"  ,"C",20,0 })
aAdd(aStru,{"NOME" 		,"C",50,0 })

cArqTrab := CriaTrab(aStru,.T.) // Nome do arquivo temporario
dbUseArea(.T.,__LocalDriver,cArqTrab,cAliasTop,.F.)

//busca array com todos os usuários do sigapss
ARET := AllUsers(.t.,.t.)

//inclui os itens no alias de gravação temporario
FOR _Y := 1 TO LEN(ARET)
	If RecLock(cAliasTop,.T.)
		(cAliasTop)->CODUSER  	:= alltrim(aret[_Y][1][1])
		(cAliasTop)->USERNAME   := alltrim(aret[_Y][1][2])
		(cAliasTop)->NOME  		:= alltrim(aret[_Y][1][4])
		(cAliasTop)->(MsUnlock())
	EndIf
NEXT _Y

(cAliasTop)->(dbGoTop())


///cria dialog
oDlg01:=MSDialog():New(000,000,500,900,"Usuários",,,,,,CLR_WHITE,,,.T.)

oMark := MsSelect():New(cAliasTop,"OK",,aCampos,@LINVERTE,@cMarca,{1,1,230,450})
oMark:oBrowse:lCanAllMark:=.T.
oMark:oBrowse:lHasMark	 :=.T.
oMark:bMark 			 := {| | APBRESCOL(cMarca,lInverte,oDlg01)}
oMark:oBrowse:bAllMark	 := {| | APBRMarkAll(cMarca,oDlg01)}

oBtn01:=tButton():New(235,340,"Processa",oDlg01,{|| nOpc := 1 , oDlg01:End() },50,12,,,,.T.)
oBtn01:=tButton():New(235,400,"Fechar"  ,oDlg01,{|| nOpc := 0 , oDlg01:End() },50,12,,,,.T.)

oDlg01:Activate(,,,.T.,,,)

IF NOPC == 1
	(cAliasTop)->(dbGoTop())
	Do While (cAliasTop)->(!EOF())
		
		IF (cAliasTop)->OK == cMarca
			aadd(aproc,(cAliasTop)->CODUSER)
		ENDIF
		(cAliasTop)->(DBSKIP())
	EndDo
	GRVLOG(APROC)
	msginfo("Processamento Finalizado")
ENDIF


RETURN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³gravação do arquivo xml no diretorio de destino                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION GRVLOG(APROC)
local aUsers := {}
local aMenu := {}
local cuser := ""
LOCAL CNOME := ""
local _i := 0
local _j := 0
LOCAL _L := 0
LOCAL _M := 0
Local nHandle  := 0
local ccrlf := chr(13)+chr(10)
local amodulos := retmodname()
local amnu := {}
local cnomarq := ""
//local aretusr := AllUsers(.t.,.t.)
PRIVATE ccrlf1 := ";"
PRIVATE CCAMLOCAL := SUPERGETMV("MV_XMNUCAM",,"C:\")
//PRIVATE CCAMLOCAL := SUPERGETMV("MV_XMNUCAM",,"C:\TEMP\")
FOR _M := 1 TO LEN(APROC)
	
	for _l := 1 to len(aret)
		if alltrim(aret[_l][1][1]) == APROC[_M]
			
			cnomarq := "UserMenu_"+ALLTRIM(APROC[_M])+".csv"
			
			
			nHandle := FCreate(cnomarq)
			
			PSWORDER(1)
			If ( PSWSEEK(APROC[_M]) )
				
				cuser := alltrim(PSWRET()[1][1])
				FWrite(nHandle,AllTrim("Cod.Usuário: "+cuser))
				FWrite(nHandle,AllTrim(ccrlf1))
				
				cnome := alltrim(PSWRET()[1][2])
				FWrite(nHandle,AllTrim("Nome: "+cnome))
				FWrite(nHandle,AllTrim(ccrlf1))
				
				cfnome := alltrim(PSWRET()[1][4])
				FWrite(nHandle,AllTrim("NomeCompleto: "+cfnome))
				FWrite(nHandle,AllTrim(ccrlf1))
				FWrite(nHandle,AllTrim(ccrlf))
				
				// cabeçalho do arquivo
				FWrite(nHandle,AllTrim("Usuário"+ccrlf1+"Nome"+ccrlf1+"Módulo"+ccrlf1+"Caminho"+ccrlf1+"Item"+ccrlf1+"Tipo"+ccrlf1+"Caminho no Menu"+ccrlf1+"Função"))
				FWrite(nHandle,AllTrim(ccrlf))
				
				auser := aclone(aret[_l][3])
				
				for _j := 1 to len(auser)
					_cvar := ""
					_cmodulo := ""
					if upper(substr(auser[_j],3,1)) <> "X"
						aadd(amenu,{auser[_j]})
						_cvar := alltrim(auser[_j])
						if val(substr(_cvar,1,2)) >= 80
							_cmodulo := "Específico"
						else
							_cmodulo := amodulos [val(substr(_cvar,1,2))][3]
						endif
						//<Title lang="pt">Fornecedores</Title>
						//USUÁRIO
						FWrite(nHandle,AllTrim(cuser))
						FWrite(nHandle,AllTrim(ccrlf1))
						//NOME
						FWrite(nHandle,AllTrim(cnome))
						FWrite(nHandle,AllTrim(ccrlf1))
						//MODULO
						FWrite(nHandle,AllTrim(_cmodulo))
						FWrite(nHandle,AllTrim(ccrlf1))
						FWrite(nHandle,AllTrim(_cvar))
						//traz dados do menu item a item
						FWrite(nHandle,AllTrim(ccrlf1))
						FWrite(nHandle,AllTrim(ccrlf))
						amnu := achamnu(substr(AllTrim(_cvar),4))
						IF len(amnu) <> 0
							for _k := 1 to len(amnu)
								_citem := ""
								_citem := strtran(amnu[_k][1],"</Title>","")
								_cTPIT := ""
								_cTPIT := strtran(amnu[_k][2],"</Type>","")
								_ccam := ""
								_ccam := _cmodulo+"/"+strtran(amnu[_k][3],"</Title>","") 
								_cfunc1 := ""
								_CFUNC1 := strtran(amnu[_k][4],"</Function>","")
								//USUÁRIO
								FWrite(nHandle,AllTrim(cuser))
								FWrite(nHandle,AllTrim(ccrlf1))
								//NOME
								FWrite(nHandle,AllTrim(cnome))
								FWrite(nHandle,AllTrim(ccrlf1))
								//MODULO
								FWrite(nHandle,AllTrim(_cmodulo))
								FWrite(nHandle,AllTrim(ccrlf1))
								FWrite(nHandle,AllTrim(_cvar))
								//traz dados do menu item a item
								FWrite(nHandle,AllTrim(ccrlf1))
								//traz dados do menu item a item
								//ITEM
								FWrite(nHandle,AllTrim(_citem))
								FWrite(nHandle,AllTrim(ccrlf1))
								//tipo de item no menu
								FWrite(nHandle,AllTrim(_cTPIT)) 
								FWrite(nHandle,AllTrim(ccrlf1))
								//caminho de item no menu
								FWrite(nHandle,AllTrim(_ccam))	
								FWrite(nHandle,AllTrim(ccrlf1))
								//FUNÇÃO de item no menu
								FWrite(nHandle,AllTrim(_CFUNC1))															
								FWrite(nHandle,AllTrim(ccrlf))
								
							next _k
						ENDIF
						
						FWrite(nHandle,AllTrim(ccrlf))
						
						
					endif
				next _j
				
				//grava valores em arquivo texto especifico
				FWrite(nHandle,AllTrim(ccrlf))
				
				
			EndIf
			FClose(nHandle)
		ENDIF
	next _l
NEXT _M


RETURN


static function achamnu(_cmnu)
local aretMNU := {}
local _cArquivo := _cmnu
local _cBuffer  := ""
local _NhA
LOCAL _CVARMNU := ""
LOCAL _CVARTIPO := ""
LOCAL _CPRVMNU := ""
local _CCAMMNU := ""
local _CCAMMNU2 := ""     
LOCAL _cfunc := ""

If !File(_cArquivo)		  						// Verifica se a Pasta no parametro existe
	//	Connout("Não foi possível criar LOCALIZAR '" + _cCamiLid + "'")
	Return(ARETMNU)
Endif

_nHa    := FT_FUse(_cArquivo)
FT_FGOTOP()
While !FT_FEOF()
	_CBUFFER := FT_FREADLN()
	IF !EMPTY(_CBUFFER)
		_cBuffer := ALLTRIM(STRTRAN(_CBUFFER,CHR(9),"*"))
		_cbuffer := strtran(_cbuffer,chr(34),chr(39))
		IF SUBSTR(_CBUFFER,1,21) == "****<Title lang='pt'>"
			_CVARMNU := SUBSTR(_CBUFFER,22)
		ENDIF
		IF SUBSTR(_CBUFFER,1,10) == "****<Type>"
			_CVARTIPO := SUBSTR(_CBUFFER,11)
		ENDIF
		IF SUBSTR(_CBUFFER,1,19) == "**<Title lang='pt'>"
			_CCAMMNU := SUBSTR(_CBUFFER,20)
		ENDIF
		IF SUBSTR(_CBUFFER,1,20) == "***<Title lang='pt'>"
			_CCAMMNU2 := _CCAMMNU + "/" + SUBSTR(_CBUFFER,21)
		ENDIF     
		IF SUBSTR(_CBUFFER,1,14) == "****<Function>" 
		_cfunc := SUBSTR(_CBUFFER,15)
		ENDIF
	ENDIF
	
	
	IF !EMPTY(_CVARMNU) .AND. _CVARMNU <> _CPRVMNU
		AADD(ARETMNU,{_CVARMNU,_CVARTIPO,_CCAMMNU2,_cfunc})
		_CPRVMNU := _CVARMNU
	ENDIF
	FT_FSKIP()
	
END
FT_FUSE()

return(aretMNU)







//função APBREscol
Static Function APBREscol(cMarca,lInverte,oDlg)
iF IsMark("OK",cMarca,lInverte)
	RecLock((cAliasTop),.F.)
	If !lInverte
		Replace (cAliasTop)->OK With cMarca
	Else
		Replace (cAliasTop)->OK With "  "
	Endif
	MsUnlock()
Else
	RecLock((cAliasTop),.F.)
	If !lInverte
		Replace (cAliasTop)->OK With "  "
	Else
		Replace (cAliasTop)->OK With cMarca
	Endif
	MsUnlock()
Endif
oDlg:Refresh()
Return .T.


//função APBRMarkAll
Static Function APBRMarkAll(cMarca,oDlg)
LOCAL nRecno:=Recno()
dbGotop()
Do While !Eof()
	RecLock((cAliasTop),.F.)
	If Empty((cAliasTop)->OK)
		Replace (cAliasTop)->OK With cMarca
	Else
		Replace (cAliasTop)->OK With "  "
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
Return .T.


