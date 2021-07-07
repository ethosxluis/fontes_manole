#include "Rwmake.ch"
#INCLUDE "topconn.ch"
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁZACxZAD   ╨Autor  ЁFONTANELLI          ╨ Data Ё  19/12/16   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё Area X Categoria					                          ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6                                                        ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function ZACxZAD()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private cCadastro,cDelFunc
Private aRotina

aRotina   := {}
cCadastro := "Area X Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Matriz com botoes de opcao								     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aRotina  := {   {"Pesquisar" 	,"AxPesqui" 	   	,0,1},;
				{"Visulizar" 	,"U_ZACxZADV()" 	,0,2},;
				{"Incluir"   	,"U_ZACxZADI()" 	,0,3},;
				{"Alterar"   	,"U_ZACxZADA()" 	,0,4},;
				{"Excluir"   	,"U_ZACxZADE()" 	,0,5}  }

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta browse atraves da funcao mBrowse					     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("ZAF")
DbSetOrder(1)
ZAF->(DbGotop())
mBrowse(6,1,22,75,"ZAF")

Return(.t.)

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁZACxZADV  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de Visualizacao especificacoes Modelo 2             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZACxZADV()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 1

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())
dbSeek("ZAF")
While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAF" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAF_AREA#ZAF_DAREA" )

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

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAF")

_AREA  := ZAF->ZAF_AREA
_DAREA := ZAF->ZAF_DAREA

aCols := {}

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAF")
dbSetOrder(1)
ZAF->(DbGoTop())
dbSeek(xFilial("ZAF")+_AREA)
_nC := 0
While !Eof() .and. ZAF->ZAF_AREA == _AREA
	AADD(aCols,{ZAF->ZAF_CATEG,ZAF->ZAF_DCATEG,.f.})
	dbSelectArea("ZAF")
	_nC := _nC + 1
	ZAF->(dbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela             '                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cTitulo  := "Area X Categoria"

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

AADD(aC,{"_AREA"  	,{20,005} ,"Area" 		   		,"@!"		,,,.f.})
AADD(aC,{"_DAREA"   ,{40,005} ,"DescriГЦo"		    ,"@!"		,,,.f.})

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
╠╠ЁPrograma  ЁZACxZADI  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de inclusao de especificacoes Modelo 2              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZACxZADI()

_sAlias := Alias()
_nOrder  := dbSetOrder()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx := 3

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())

dbSeek("ZAF")
While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAF" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAF_AREA#ZAF_DAREA" )

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

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

_AREA 	:= SPACE(02)
_DAREA  := SPACE(40)

//Montando aCols
aCols := {}
Aadd(aCols,{Space(03),Space(45),.F.})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Campos Alterados GetDados											     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aGetSd := {}
Aadd(aGetSd,"ZAF_CATEG")
Aadd(aGetSd,"ZAF_DCATEG")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cTitulo  := "Area X Categoria"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Cabecalho do Modelo 2      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aC := { }

AADD(aC,{"_AREA"  ,{20,005} ,"Area"  	  		,"@!"		,"u_DAREA(_AREA)","ZAC",.t.})
AADD(aC,{"_DAREA" ,{40,005} ,"DescriГЦo"		,"@!"		,,,.f.})

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

If Empty(_AREA)
	lRetMod2 := .f.
Endif

If lRetMod2

	For I := 1 to Len(aCols)

		If !aCols[I,_nPosDel]

			DbSelectArea("ZAF")
			RecLock("ZAF",.t.)
			ZAF->ZAF_FILIAL  := xFilial("ZAF")
			ZAF->ZAF_AREA    := _AREA
			ZAF->ZAF_DAREA   := _DAREA
			ZAF->ZAF_CATEG   := aCols[I,_CATEG]
			ZAF->ZAF_DCATEG  := aCols[I,_DCATEG]
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
╠╠ЁPrograma  ЁZACxZADA  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de Alteracao de especificacoes Modelo 2             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZACxZADA()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 3

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())
dbSeek("ZAF")
While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAF" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAF_AREA#ZAF_DAREA" )

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

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAF")

_AREA  := ZAF->ZAF_AREA
_DAREA := ZAF->ZAF_DAREA

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды
aCols := {}

dbSelectArea("ZAF")
dbSetOrder(1)
ZAF->(DbGoTop())
dbSeek(xFilial("ZAF")+_AREA)
_nC := 0
While !Eof() .and. ZAF->ZAF_AREA == _AREA
	AADD(aCols,{ZAF->ZAF_CATEG,ZAF->ZAF_DCATEG,.f.})
	_nC := _nC + 1
	ZAF->(dbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cTitulo  := "Area X Categoria"

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

AADD(aC,{"_AREA"  	,{20,005} ,"Area"  		  		,"@!"		,,,.f.})
AADD(aC,{"_DAREA"   ,{40,005} ,"DescriГЦo"		    ,"@!"		,,,.f.})

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
Aadd(aGetSd,"ZAF_CATEG")
Aadd(aGetSd,"ZAF_DCATEG")

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSd)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё No Windows existe a funcao de apoio CallMOd2Obj()que retorna Ё
//Ё objeto Getdados Corrente                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If lRetMod2

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apaga Todas as linhas da Tabela                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("ZAF")
	dbSetOrder(1)
	ZAF->(DbGoTop())
	dbSeek(xFilial("ZAF")+_AREA)
	While !Eof() .and. ZAF->ZAF_AREA == _AREA
		RecLock("ZAF",.f.)
		Delete
		MsUnLock()
		ZAF->(dbSkip())
	EndDo

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava Todas as linhas da Tabela                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	For I := 1 to Len(aCols)

		If !aCols[I,_nPosDel]

			DbSelectArea("ZAF")
			RecLock("ZAF",.t.)
			ZAF->ZAF_FILIAL  := xFilial("ZAF")
			ZAF->ZAF_AREA    := _AREA
			ZAF->ZAF_DAREA   := _DAREA
			ZAF->ZAF_CATEG   := aCols[I,_CATEG]
			ZAF->ZAF_DCATEG  := aCols[I,_DCATEG]
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
╠╠ЁPrograma  ЁZACxZADE  Ё Autor ЁFONTANELLI             Ё Data Ё 19/12/16 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina de Exclusao de especificacoes Modelo 2              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function ZACxZADE()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de acesso para o Modelo 2                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 1

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nUsado:=0
aHeader:={}
dbSelectArea("SX3")
dbSetOrder(1)
SX3->(DbGoTop())
dbSeek("ZAF")

While ( !Eof() .And. SX3->X3_ARQUIVO=="ZAF" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
		!AllTrim(SX3->X3_CAMPO)$"ZAF_AREA#ZAF_DAREA" )

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

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAF")

_AREA  := ZAF->ZAF_AREA
_DAREA := ZAF->ZAF_DAREA

aCols := {}

//здддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis de Posicionamento no aCols Ё
//юдддддддддддддддддддддддддддддддддддддды

dbSelectArea("ZAF")
dbSetOrder(1)
ZAF->(DbGoTop())
dbSeek(xFilial("ZAF")+_AREA)
_nC := 0
While !Eof() .and. ZAF->ZAF_AREA == _AREA
	AADD(aCols,{ZAF->ZAF_CATEG,ZAF->ZAF_DCATEG,.f.})
	_nC := _nC + 1
	ZAF->(dbSkip())
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cTitulo  := "Area X Categoria"

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

AADD(aC,{"_AREA"  	,{20,005} ,"Area"	    		,"@!"		,,,.f.})
AADD(aC,{"_DAREA"   ,{40,005} ,"DescriГЦo"		    ,"@!"		,,,.f.})

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

	dbSelectArea("ZAF")
	dbSetOrder(1)
	ZAF->(DbGoTop())
	dbSeek(xFilial("ZAF")+_AREA)
	While !Eof() .and. ZAF->ZAF_AREA == _AREA
		RecLock("ZAF",.f.)
		Delete
		MsUnLock()
		ZAF->(dbSkip())
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
User Function DAREA(xAREA)

lRet:= .T.

if !Empty(xAREA)
	_DAREA := Posicione("ZAC",1,xFilial("ZAC")+xAREA,"ZAC_DESCRI")
else
	_DAREA := SPACE(40)
endif

return(lRet)

