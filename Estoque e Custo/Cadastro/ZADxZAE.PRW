#include "Rwmake.ch"
#INCLUDE "topconn.ch"
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁZADxZAE   ╨Autor  ЁFONTANELLI          ╨ Data Ё  19/12/16   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё Categoria X Sub-Categoria		                          ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6                                                        ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function ZADxZAE()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private cCadastro,cDelFunc
Private aRotina

aRotina   := {}
cCadastro := "Categoria X Sub-Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Matriz com botoes de opcao								     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aRotina  := {   {"Pesquisar" 	,"AxPesqui" 	   	,0,1},;
				{"Visulizar" 	,"U_ZADxZAEV()" 	,0,2},;
				{"Incluir"   	,"U_ZADxZAEI()" 	,0,3},;
				{"Alterar"   	,"U_ZADxZAEA()" 	,0,4},;
				{"Excluir"   	,"U_ZADxZAEE()" 	,0,5}  }

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta browse atraves da funcao mBrowse					     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("ZAG")
DbSetOrder(1)
ZAG->(DbGotop())
mBrowse(6,1,22,75,"ZAG")

Return(.t.)

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁZADxZAEV  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de Visualizacao especificacoes Modelo 2             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZADxZAEV()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 1

Private _FILIAL,_CATEG,_DCATEG,_SUBCAT,_DSUBCA


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())
dbSeek("ZAG")
While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAG" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAG_CATEG#ZAG_DCATEG" )

		nUsado++

		aadd(aHeader,{ AllTrim(X3Titulo()),;
								alltrim(SX3->X3_CAMPO), ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								SX3->X3_VALID   , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3		, ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX	, ;
								SX3->X3_RELACAO } )
	EndIf
	SX3->(dbSkip())
Enddo

nUsado++

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

_SUBCAT  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_SUBCAT"})
_DSUBCA := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_DSUBCA"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAG")

_CATEG  := ZAG->ZAG_CATEG
_DCATEG := ZAG->ZAG_DCATEG

aCols := {}

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAG")
dbSetOrder(1)
ZAG->(DbGoTop())
dbSeek(xFilial("ZAG")+_CATEG)
_nC := 0
While !Eof() .and. ZAG->ZAG_CATEG == _CATEG
	AADD(aCols,{ZAG->ZAG_SUBCAT,ZAG->ZAG_DSUBCA,.f.})
	dbSelectArea("ZAG")
	_nC := _nC + 1
	ZAG->(dbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela             '                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cTitulo  := "Categoria X Sub-Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Cabecalho do Modelo 2      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aC := { }

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_CATEG"  	 ,{20,005} ,"Categoria"    		,"@!"		,,,.f.})
AADD(aC,{"_DCATEG"   ,{40,005} ,"DescriГЦo"		    ,"@!"		,,,.f.})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Rodape do Modelo 2         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aR := { }

// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com coordenadas da GetDados no modelo2                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

aCGD:={90,5,80,315}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Validacoes na GetDados da Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cLinhaOk := ".t."
cTudoOk  := ".t."

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Chamada da Modelo2                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,,,)

Return


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁZADxZAEI  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de inclusao de especificacoes Modelo 2              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZADxZAEI()

_sAlias := Alias()
_nOrder  := dbSetOrder()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx := 3

Private _FILIAL,_CATEG,_DCATEG,_SUBCAT,_DSUBCA

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())

dbSeek("ZAG")
While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAG" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAG_CATEG#ZAG_DCATEG" )

			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
								alltrim(SX3->X3_CAMPO), ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								SX3->X3_VALID   , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3		, ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX	, ;
								SX3->X3_RELACAO } )

	endIf
	SX3->(dbSkip())
Enddo

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

_SUBCAT := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_SUBCAT"})
_DSUBCA := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_DSUBCA"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

_CATEG 	:= SPACE(03)
_DCATEG  := SPACE(45)

//Montando aCols
aCols := {}
Aadd(aCols,{Space(03),Space(45),.F.})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Campos Alterados GetDados											     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aGetSd := {}
Aadd(aGetSd,"ZAG_SUBCAT")
Aadd(aGetSd,"ZAG_DSUBCA")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cTitulo  := "Categoria X Sub-Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Cabecalho do Modelo 2      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aC := { }

AADD(aC,{"_CATEG"  ,{20,005} ,"Categoria"  	  	,"@!"		,"u_DCATEG(_CATEG)","ZAD",.t.})
AADD(aC,{"_DCATEG" ,{40,005} ,"DescriГЦo"		,"@!"		,,,.f.})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Rodape do Modelo 2         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aR := { }

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com coordenadas da GetDados no modelo2                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aCGD:={90,5,80,315}


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Validacoes na GetDados da Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cLinhaOk := ".t."
cTudoOk  := ".t."

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Chamada da Modelo2                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSd)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё No Windows existe a funcao de apoio CallMOd2Obj()que retorna Ё
//Ё objeto Getdados Corrente                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If Empty(_CATEG)
	lRetMod2 := .f.
Endif

If lRetMod2

	For I := 1 to Len(aCols)

		If !aCols[I,_nPosDel]

			DbSelectArea("ZAG")
			RecLock("ZAG",.t.)
			ZAG->ZAG_FILIAL  := xFilial("ZAG")
			ZAG->ZAG_CATEG    := _CATEG
			ZAG->ZAG_DCATEG   := _DCATEG
			ZAG->ZAG_SUBCAT   := aCols[I,_SUBCAT]
			ZAG->ZAG_DSUBCA   := aCols[I,_DSUBCA]
			MsUnLock()

		    dbSelectArea(_sAlias)
		    dbSetOrder(_nOrder)

		EndIf

	Next I

EndIf

Return



/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁZADxZAEA  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de Alteracao de especificacoes Modelo 2             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZADxZAEA()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 3

Private _FILIAL,_CATEG,_DCATEG,_SUBCAT,_DSUBCA

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())
dbSeek("ZAG")
While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAG" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAG_CATEG#ZAG_DCATEG" )

			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
								alltrim(SX3->X3_CAMPO), ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								SX3->X3_VALID   , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3		, ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX	, ;
								SX3->X3_RELACAO } )

	endIf
	SX3->(dbSkip())
Enddo

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

_SUBCAT := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_SUBCAT"})
_DSUBCA := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_DSUBCA"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAG")

_CATEG  := ZAG->ZAG_CATEG
_DCATEG := ZAG->ZAG_DCATEG

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды
aCols := {}

dbSelectArea("ZAG")
dbSetOrder(1)
ZAG->(DbGoTop())
dbSeek(xFilial("ZAG")+_CATEG)
_nC := 0
While !Eof() .and. ZAG->ZAG_CATEG == _CATEG
	AADD(aCols,{ZAG->ZAG_SUBCAT,ZAG->ZAG_DSUBCA,.f.})
	_nC := _nC + 1
	ZAG->(dbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cTitulo  := "Categoria X Sub-Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Cabecalho do Modelo 2      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aC := { }
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_CATEG"  	 ,{20,005} ,"Categoria"   		,"@!"		,,,.f.})
AADD(aC,{"_DCATEG"   ,{40,005} ,"DescriГЦo"		    ,"@!"		,,,.f.})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Rodape do Modelo 2         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aR := { }
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com coordenadas da GetDados no modelo2                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aCGD:={90,5,80,315}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Validacoes na GetDados da Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cLinhaOk := ".t."
cTudoOk  := ".t."

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Chamada da Modelo2                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

n:=len(acols)

aGetSd := {}
Aadd(aGetSd,"ZAG_SUBCAT")
Aadd(aGetSd,"ZAG_DSUBCA")

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSd)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё No Windows existe a funcao de apoio CallMOd2Obj()que retorna Ё
//Ё objeto Getdados Corrente                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If lRetMod2

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apaga Todas as linhas da Tabela                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("ZAG")
	dbSetOrder(1)
	ZAG->(DbGoTop())
	dbSeek(xFilial("ZAG")+_CATEG)
	While !Eof() .and. ZAG->ZAG_CATEG == _CATEG
		RecLock("ZAG",.f.)
		Delete
		MsUnLock()
		ZAG->(dbSkip())
	EndDo

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava Todas as linhas da Tabela                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	For I := 1 to Len(aCols)

		If !aCols[I,_nPosDel]

			DbSelectArea("ZAG")
			RecLock("ZAG",.t.)
			ZAG->ZAG_FILIAL  := xFilial("ZAG")
			ZAG->ZAG_CATEG   := _CATEG
			ZAG->ZAG_DCATEG  := _DCATEG
			ZAG->ZAG_SUBCAT  := aCols[I,_SUBCAT]
			ZAG->ZAG_DSUBCA  := aCols[I,_DSUBCA]
			MsUnLock()

		    dbSelectArea(_sAlias)
		    dbSetOrder(_nOrder)

		EndIf

	Next I

EndIf

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁZADxZAEE  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de Exclusao de especificacoes Modelo 2              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZADxZAEE()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 1

Private _FILIAL,_CATEG,_DCATEG,_SUBCAT,_DSUBCA

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())
dbSeek("ZAG")

While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAG" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAG_CATEG#ZAG_DCATEG" )

		nUsado++

		aadd(aHeader,{ AllTrim(X3Titulo()),;
								alltrim(SX3->X3_CAMPO), ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								SX3->X3_VALID   , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3		, ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX	, ;
								SX3->X3_RELACAO } )

	EndIf
	SX3->(dbSkip())
Enddo

nUsado++

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

_SUBCAT := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_SUBCAT"})
_DSUBCA := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAG_DSUBCA"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAG")

_CATEG  := ZAG->ZAG_CATEG
_DCATEG := ZAG->ZAG_DCATEG

aCols := {}

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAG")
dbSetOrder(1)
ZAG->(DbGoTop())
dbSeek(xFilial("ZAG")+_CATEG)
_nC := 0
While !Eof() .and. ZAG->ZAG_CATEG == _CATEG
	AADD(aCols,{ZAG->ZAG_SUBCAT,ZAG->ZAG_DSUBCA,.f.})
	_nC := _nC + 1
	ZAG->(dbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cTitulo  := "Categoria X Sub-Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Cabecalho do Modelo 2      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aC := { }

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_CATEG"   ,{20,005} ,"Categoria"	    	,"@!"		,,,.f.})
AADD(aC,{"_DCATEG"  ,{40,005} ,"DescriГЦo"		    ,"@!"		,,,.f.})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Rodape do Modelo 2         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aR := { }

// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com coordenadas da GetDados no modelo2                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

aCGD:={90,5,80,315}


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Validacoes na GetDados da Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cLinhaOk := ".t."
cTudoOk  := ".t."

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Chamada da Modelo2                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,,,)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё No Windows existe a funcao de apoio CallMOd2Obj()que retorna Ё
//Ё objeto Getdados Corrente                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If lRetMod2

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Exclui todas as Linhas                                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	dbSelectArea("ZAG")
	dbSetOrder(1)
	ZAG->(DbGoTop())
	dbSeek(xFilial("ZAG")+_CATEG)
	While !Eof() .and. ZAG->ZAG_CATEG == _CATEG
		RecLock("ZAG",.f.)
		Delete
		MsUnLock()
		ZAG->(dbSkip())
	EndDo

Endif

dbSelectArea(_sAlias)
dbSetOrder(_nOrder)

Return


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁVALChave  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de ValidaГЦo Modelo 2       					      Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function DCATEG(xCATEG)

lRet:= .T.

if !Empty(xCATEG)
	_DCATEG := Posicione("ZAD",1,xFilial("ZAD")+xCATEG,"ZAD_DESCRI")
else
	_DCATEG := SPACE(45)
endif

return(lRet)




