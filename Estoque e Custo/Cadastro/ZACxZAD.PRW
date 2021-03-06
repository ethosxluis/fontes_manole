#include "Rwmake.ch"
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZACxZAD   �Autor  �FONTANELLI          � Data �  19/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Area X Categoria					                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZACxZAD()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCadastro,cDelFunc
Private aRotina

aRotina   := {}
cCadastro := "Area X Categoria"

//��������������������������������������������������������������Ŀ
//� Matriz com botoes de opcao								     �
//����������������������������������������������������������������
aRotina  := {   {"Pesquisar" 	,"AxPesqui" 	   	,0,1},;
				{"Visulizar" 	,"U_ZACxZADV()" 	,0,2},;
				{"Incluir"   	,"U_ZACxZADI()" 	,0,3},;
				{"Alterar"   	,"U_ZACxZADA()" 	,0,4},;
				{"Excluir"   	,"U_ZACxZADE()" 	,0,5}  }

//��������������������������������������������������������������Ŀ
//� Monta browse atraves da funcao mBrowse					     �
//����������������������������������������������������������������
dbSelectArea("ZAF")
DbSetOrder(1)
ZAF->(DbGotop())
mBrowse(6,1,22,75,"ZAF")

Return(.t.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ZACxZADV  � Autor �FONTANELLI             � Data � 19/12/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Visualizacao especificacoes Modelo 2             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ZACxZADV()

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 1

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG


//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
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

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

dbSelectArea("ZAF")

_AREA  := ZAF->ZAF_AREA
_DAREA := ZAF->ZAF_DAREA

aCols := {}

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������

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

//��������������������������������������������������������������Ŀ
//� Titulo da Janela             '                                �
//����������������������������������������������������������������

cTitulo  := "Area X Categoria"

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC := { }

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_AREA"  	,{20,005} ,"Area" 		   		,"@!"		,,,.f.})
AADD(aC,{"_DAREA"   ,{40,005} ,"Descri��o"		    ,"@!"		,,,.f.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR := { }

// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

aCGD:={90,5,80,315}

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk := ".t."
cTudoOk  := ".t."

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,,,)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ZACxZADI  � Autor �FONTANELLI             � Data � 19/12/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de inclusao de especificacoes Modelo 2              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ZACxZADI()

_sAlias := Alias()
_nOrder  := dbSetOrder()
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx := 3

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG

//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������

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

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

_AREA 	:= SPACE(02)
_DAREA  := SPACE(40)

//Montando aCols
aCols := {}
Aadd(aCols,{Space(03),Space(45),.F.})

//��������������������������������������������������������������Ŀ
//� Campos Alterados GetDados											     �
//����������������������������������������������������������������
aGetSd := {}
Aadd(aGetSd,"ZAF_CATEG")
Aadd(aGetSd,"ZAF_DCATEG")

//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������
cTitulo  := "Area X Categoria"

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC := { }

AADD(aC,{"_AREA"  ,{20,005} ,"Area"  	  		,"@!"		,"u_DAREA(_AREA)","ZAC",.t.})
AADD(aC,{"_DAREA" ,{40,005} ,"Descri��o"		,"@!"		,,,.f.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR := { }

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
aCGD:={90,5,80,315}


//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk := ".t."
cTudoOk  := ".t."

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSd)

//��������������������������������������������������������������Ŀ
//� No Windows existe a funcao de apoio CallMOd2Obj()que retorna �
//� objeto Getdados Corrente                                     �
//����������������������������������������������������������������

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ZACxZADA  � Autor �FONTANELLI             � Data � 19/12/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Alteracao de especificacoes Modelo 2             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ZACxZADA()

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 3

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG

//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������

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

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

dbSelectArea("ZAF")

_AREA  := ZAF->ZAF_AREA
_DAREA := ZAF->ZAF_DAREA

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������

cTitulo  := "Area X Categoria"

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC := { }
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_AREA"  	,{20,005} ,"Area"  		  		,"@!"		,,,.f.})
AADD(aC,{"_DAREA"   ,{40,005} ,"Descri��o"		    ,"@!"		,,,.f.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR := { }
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
aCGD:={90,5,80,315}

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk := ".t."
cTudoOk  := ".t."

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

n:=len(acols)

aGetSd := {}
Aadd(aGetSd,"ZAF_CATEG")
Aadd(aGetSd,"ZAF_DCATEG")

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSd)

//��������������������������������������������������������������Ŀ
//� No Windows existe a funcao de apoio CallMOd2Obj()que retorna �
//� objeto Getdados Corrente                                     �
//����������������������������������������������������������������

If lRetMod2

	//��������������������������������������������������������������Ŀ
	//� Apaga Todas as linhas da Tabela                              �
	//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Grava Todas as linhas da Tabela                              �
	//����������������������������������������������������������������

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ZACxZADE  � Autor �FONTANELLI             � Data � 19/12/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Exclusao de especificacoes Modelo 2              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ZACxZADE()

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

_sAlias := Alias()
_nOrder  := dbSetOrder()

nOpcx := 1

Private _FILIAL,_AREA,_DAREA,_CATEG,_DCATEG

//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
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

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������

_CATEG  := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_CATEG"})
_DCATEG := aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "ZAF_DCATEG"})

_nPosDel := Len(aHeader) + 1

//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

dbSelectArea("ZAF")

_AREA  := ZAF->ZAF_AREA
_DAREA := ZAF->ZAF_DAREA

aCols := {}

//��������������������������������������Ŀ
//� Variaveis de Posicionamento no aCols �
//����������������������������������������

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

//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������

cTitulo  := "Area X Categoria"

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC := { }

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_AREA"  	,{20,005} ,"Area"	    		,"@!"		,,,.f.})
AADD(aC,{"_DAREA"   ,{40,005} ,"Descri��o"		    ,"@!"		,,,.f.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR := { }

// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

aCGD:={90,5,80,315}


//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk := ".t."
cTudoOk  := ".t."

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,,,)

//��������������������������������������������������������������Ŀ
//� No Windows existe a funcao de apoio CallMOd2Obj()que retorna �
//� objeto Getdados Corrente                                     �
//����������������������������������������������������������������

If lRetMod2

	//��������������������������������������������������������������Ŀ
	//� Exclui todas as Linhas                                       �
	//����������������������������������������������������������������

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VALChave  � Autor �FONTANELLI             � Data � 19/12/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Valida��o Modelo 2       					      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function DAREA(xAREA)

lRet:= .T.

if !Empty(xAREA)
	_DAREA := Posicione("ZAC",1,xFilial("ZAC")+xAREA,"ZAC_DESCRI")
else
	_DAREA := SPACE(40)
endif

return(lRet)

