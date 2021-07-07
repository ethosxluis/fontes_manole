#include "Protheus.ch"
#define CRLF CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCONTRATOºAutor  ³Rafael Garcia de Melo  ºData³24/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao contrato de direitos autorais                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 							                          		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßvßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPCx2a()


Local oDlg   := .F.
Local lOk    := .F.                                      
Local   cType    := "Arquivo Texto | *.TXT"


Private cTitulo     := "Importacao de Arquivos "                                       

Private aNotas      := {}
Private lMsErroAuto := .F. 

cArqTc1 := space(100)                                     
cArqTd1 := space(100)                                     

FormBatch(cTitulo, {	"Este programa ira importar os arquivos", ;
						"Fornecedores" }, ;
					{	{5, .T., {|| cArqTc1 := cGetFile(cType,"Selecione o Arquivo de Cabecalho",0,,.T.,GETF_LOCALHARD )}}, ;
						{5, .T., {|| cArqTd1 := cGetFile(cType,"Selecione o Arquivo de detalhes",0,,.T.,GETF_LOCALHARD )}}, ;
						{1, .T., {|| lOk := .T., FechaBatch(), Nil}}, ;
						{2, .T., {|| lOk := .F., FechaBatch()}}})

If lOk

   MsAguarde({|| xCriaTr()},"Criando arquivo temporário...")

   MsAguarde({|| xCargaTxt()},"Carregando arquivo temporário...")

   MsAguarde({|| ImpCont()},"Importando Contratos...")

Endif
Dbselectarea("TRC")
DbClosearea("TRC")

// Dbselectarea("TRA")
// DbClosearea("TRA")
Return(.T.)


Return

Static Function oCancel()

Return(.F.)

Static Function GravaCont(nOpc)
//Begin Transaction
If nOpc == 2
	Processa({|| ImpCont(3) },"Processando...")
	If lMsErroAuto
		MostraErro('\spool\','ErroCliente.aut') // job
		Alert("FIM DO Processo. Erros "+Str(_nContador))
		Return .f.
	Else
		Msgstop("Transacao Finalizada com Sucesso")
	Endif
EndIf
//End Transaction


Return .F.

Static Function ImpCont(nOpc)
Local _aCab :={}
Local _aItem :={}
Local nCodCont := 1
Local nContador:=1
local nCond:=0
local erros:=""
LOCAL nProduto:=0
LOCAL nFornecedor:=0
LOCAL nCXI:=0
LOCAL nOk:=0
LOCAL TEXTO:=""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Correr todos os registros marcados para prepara‡„o...           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Erros :=MSFCREATE("\DATA\erros.TXT",0) // Inicia (abre) arquivo
DbSelectArea("TRC")
DbGotop()
ProcRegua(Recno()) // Numero de registros a processar
While !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Incluindo ... " + ALLTRIM(TRC->AH1_CONTRA))
	DbSelectArea("SB1")
	DbSetOrder(1)
	if DbSeek(xFilial("SB1")+ALLTRIM(TRC->AH1_PRODUT))
		DbSelectArea("SA2")
		DbSetOrder(1)                                                   
  		if DbSeek(xFilial("SA2")+ALLTRIM(TRC->AH1_FORNEC)+ALLTRIM(TRC->AH1_LOJAFO))
			nCond:='002'
			DbselectArea("TRA")
			IF DBSEEK(TRC->AH1_CONTRA+TRC->AH1_SEQCON)
				IF (ALLTRIM(TRC->AH1_PRODUT)+ALLTRIM(TRC->AH1_FORNEC)+ALLTRIM(TRC->AH1_LOJAFO))==(ALLTRIM(TRA->AH2_PRODUT)+ALLTRIM(TRA->AH2_FORNEC)+ALLTRIM(TRA->AH2_LOJAFO))
	                Dbselectarea("AH1")
	                dbsetorder(3)
	        		IF DBSEEK(xfilial("AH1")+TRC->(AH1_CONTRA))  // // AH1_FILIAL + AH1_PRODUT + AH1_FORNEC + AH1_LOJAFO
			            _lnew := .f.
			        else
			        	_lnew := .t.
			        endif
			        
					RECLOCK("AH1",_lnew)
			
					AH1->AH1_FILIAL := XFILIAL("AH1")
					AH1->AH1_CONTRA	:= ALLTRIM(TRC->AH1_CONTRA)
					AH1->AH1_SEQCON	:= ALLTRIM(TRC->AH1_SEQCON)
					AH1->AH1_PRODUT := ALLTRIM(TRC->AH1_PRODUT)
				//	AH1->AH1_INICVI	:= AH1->AH1_INICVI
				//	AH1->AH1_DTACON := AH1->AH1_DTACON
					AH1->AH1_INICVI	:= TRC->AH1_INICVI      //Mudança feita por Adalberto para atualizar os campos de datas
					AH1->AH1_DTACON := TRC->AH1_DTACON      //Feito por Adalberto
					
					AH1->AH1_CARTRE := "1"
					AH1->AH1_SUB_LI := "1"
					AH1->AH1_MOEDA  := "1"
					AH1->AH1_TIPOGA := "2"
					AH1->AH1_TERRIT := "001"
					AH1->AH1_PRESTA := "1"
					AH1->AH1_PAGAME := "1"
					AH1->AH1_FORNEC	:= ALLTRIM(TRC->AH1_FORNEC)
					AH1->AH1_LOJAFO := ALLTRIM(TRC->AH1_LOJAFO)
					AH1->AH1_PRZOPA := nCond
					AH1->AH1_PERIOD := ALLTRIM(TRC->AH1_PERIOD)
					AH1->AH1_DATAFI := TRC->AH1_DATAFI //CTOD(SUBSTR(Alltrim(TRC->AH1_DATAFI),7,2)+"/"+SUBSTR(Alltrim(TRC->AH1_DATAFI),5,2)+"/"+SUBSTR(Alltrim(TRC->AH1_DATAFI),3,2))
					AH1->AH1_MOEDRO := VAL(ALLTRIM(TRC->AH1_MOEDRO))
					AH1->AH1_VIGEIN := '1'
				 //	AH1->AH1_VIGENC := '1'
					AH1->AH1_VIGENC := TRC->AH1_VIGENC //Mudança feita por Adalberto para atualizar tempo de vigencia de contrato
					AH1->AH1_MASTER := ALLTRIM(TRC->AH1_PRODUT)
			//		AH1->AH1_XDTANT	:=CTOD(SUBSTR(Alltrim(TRC->AH1_INICVI),7,2)+"/"+SUBSTR(Alltrim(TRC->AH1_INICVI),5,2)+"/"+SUBSTR(Alltrim(TRC->AH1_INICVI),3,2))
					MSUNLOCK("AH1")
					DbselectArea("TRA")
					WHILE (TRC->AH1_CONTRA+TRC->AH1_SEQCON)==(TRA->AH2_CONTRA+TRA->AH2_SEQCON)
					    
					    Dbselectarea("AH2")
		                dbsetorder(2)
		       			IF DBSEEK(xfilial("AH2")+TRa->(AH2_CONTRA + AH2_SEQCON +AH2_PRODUT + AH2_FORNEC + AH2_LOJAFO + ALLTRIM(TRA->AH2_ITEM)))  // // AH1_FILIAL + AH1_PRODUT + AH1_FORNEC + AH1_LOJAFO
						   _lnew := .f.
				        else
				        	_lnew := .t.
				        endif
				       
						
						RECLOCK("AH2",_lnew)
						AH2->AH2_FILIAL := XFILIAL("AH2")
						AH2->AH2_CONTRA	:= ALLTRIM(TRA->AH2_CONTRA)
						AH2->AH2_SEQCON	:= ALLTRIM(TRA->AH2_SEQCON)
						AH2->AH2_PRODUT	:= ALLTRIM(TRA->AH2_PRODUT)
						AH2->AH2_FORNEC	:= ALLTRIM(TRA->AH2_FORNEC)
						AH2->AH2_LOJAFO := ALLTRIM(TRA->AH2_LOJAFO)
						AH2->AH2_ITEM	:= ALLTRIM(TRA->AH2_ITEM)
						AH2->AH2_FXINIC	:= TRA->AH2_FXINIC
						AH2->AH2_FXFINA	:= TRA->AH2_FXFINA
						AH2->AH2_DESCMI	:= TRA->AH2_DESCMI
						AH2->AH2_PERCRE	:= TRA->AH2_PERCRE
						AH2->AH2_VALREG	:= TRA->AH2_VALREG
					 //	AH2->AH2_PRBRUT := "1"   
						AH2->AH2_PRBRUT := ALLTRIM(TRA->AH2_PRBRUT)   //mudança feita por Adalberto para atualizar o tipo de venda
						AH2->AH2_DESCCO := "2"
						AH2->AH2_ICMS 	:= "2"
						AH2->AH2_IPI 	:= "2"
						AH2->AH2_COFINS := "2"
						
						MSUNLOCK("AH2")
						DBSELECTAREA("TRA")
						DBSKIP()
						nOk++
					ENDDO
				else
					TEXTO:="informacoes entre cabecalho e item nao batem, contrato:"+TRC->AH1_CONTRA+TRC->AH1_SEQCON+";"
					FWrite(Erros,TEXTO+CRLF)//GRAVA HEADER DO ARQUIVO
					nCXI++
				END
			else
				TEXTO:="Nao encontrado itens desse cabecalho, contrato:"+TRC->AH1_CONTRA+TRC->AH1_SEQCON+";"
				FWrite(Erros,TEXTO+CRLF)//GRAVA HEADER DO ARQUIVO
				nCXI++
			end
		else
			TEXTO:="nao encontrado o codigo de fornecedor "+ALLTRIM(TRC->AH1_FORNEC)+" loja "+ALLTRIM(TRC->AH1_LOJAFO)+" , contrato:"+TRC->AH1_CONTRA+TRC->AH1_SEQCON+";"
			FWrite(Erros,TEXTO+CRLF)//GRAVA HEADER DO ARQUIVO
			nFornecedor++
		end
 	else
 		TEXTO:="nao encontrado o codigo de produto "+ALLTRIM(TRC->AH1_PRODUT)+" , contrato: "+TRC->AH1_CONTRA+TRC->AH1_SEQCON+";"
 		FWrite(Erros,TEXTO+CRLF)//GRAVA HEADER DO ARQUIVO
 		nProduto++
 	END
	DBSELECTAREA("TRC")
	DBSKIP()
	
enddo
alert("Produto" + str( nProduto))
alert("Fornecedor" + str( nFornecedor))
Alert("Cabeçalho x Item " + str(nCXI))
alert ("ok " + Str(nOk))
FClose(Erros)
return()






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCONTRATOºAutor  ³Microsiga           º Data ³  10/13/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCriaTr()

dbSelectArea("AH1")
aStruct := AH1->(dbStruct())
cNomArq := CriaTrab(aStruct)
cIndex  := cNomArq
dbUseArea( .T.,, cNomArq, "TRC", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRC",cIndex,"AH1_CONTRA+AH1_SEQCON",,,"Selecionando Registros...")
dbSetIndex( cNomArq +OrdBagExt())
Dbsetorder(1)

RETURN
                                                                                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCONTRATOºAutor  ³Microsiga           º Data ³  10/13/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCargaTxt()
                                
_ccontrato := space(6) // 1 com 6 posicoes
_cdtinicio := space(8) // 8 com 8 posicoes
_ccodisbn  := space(13) // 17 com 13 posicoes
_ccodforn  := space(6)  // 31 com 6 posicoes
_ccond     := space(3)  // 38 com 3 posicoes
_cperiodo  := space(2) // 42 com 2 posicoes
_cdtfim    := space(8) // 45 com 8 posicoes
_cmoeda    := space(3) // 54 com 3 posicoes
_cdatcont  := space(8) // 58 com 8 posicoes - Criado por Adalberto para atualizar a data de contrato 
_cvigenc   := space(2) // 67 com 2 posicoes - Criado por Adalberto para atualizar ano de vigencia do contrato

FT_FUSE(cArqTc1)

FT_FGOTOP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop para tratamento das linhas do arquivo do EDI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

cQtdeReg   := FT_FREADLN()   // Linha criada por Adalberto para saber a qtde de registros no arquivo

For _ncc := 1 to FT_FLASTREC()
	
	cLinha   := FT_FREADLN()
	                          
	_ccontrato := Substr(cLinha,1,6) // 1 com 6 posicoes
	_cdtinicio := Substr(cLinha,8,8) // 8 com 8 posicoes
	_ccodisbn  := Substr(cLinha,17,13) // 17 com 13 posicoes
	_ccodforn  := Substr(cLinha,31,6)  // 31 com 6 posicoes
	_ccond     := Substr(cLinha,38,3)  // 38 com 3 posicoes
	_cperiodo  := Substr(cLinha,42,2) // 42 com 2 posicoes
	_cdtfim    := Substr(cLinha,45,8) // 45 com 8 posicoes
	_cmoeda    := Substr(cLinha,56,1) // 54 com 3 posicoes    
	_cdatcont  := Substr(cLinha,58,8) // 58 com 8 posicoes
	_cvigenc   := Substr(cLinha,67,2) // 67 com 2 posicoes
	
	FT_FSKIP()
   //	_ncc++
    
    Reclock("TRC",.T.)
	TRC->AH1_FILIAL := XFILIAL()
	TRC->AH1_CONTRA	:= ALLTRIM(_ccontrato)
	TRC->AH1_PRODUT := ALLTRIM(_ccodisbn)
	TRC->AH1_INICVI	:= stod(_cdtinicio)
	TRC->AH1_DTACON := stod(_cdatcont)
	TRC->AH1_SEQCON := "01"
	TRC->AH1_CARTRE := "1"
	TRC->AH1_SUB_LI := "1"
	TRC->AH1_MOEDA  := "1"
	TRC->AH1_TIPOGA := "2"
	TRC->AH1_TERRIT := "001"
	TRC->AH1_PRESTA := "1"
	TRC->AH1_PAGAME := "1"
	TRC->AH1_FORNEC	:= ALLTRIM(_cCodForn)
	TRC->AH1_LOJAFO := ALLTRIM("01")
	TRC->AH1_PRZOPA := alltrim(_cCond)
	TRC->AH1_PERIOD := ALLTRIM(_cperiodo)
	TRC->AH1_DATAFI := stod(_cdtfim)
	TRC->AH1_MOEDRO := VAL(ALLTRIM(_cMoeda))
	TRC->AH1_VIGEIN := '1'
	TRC->AH1_VIGENC := VAL(ALLTRIM(_cvigenc))
	TRC->AH1_MASTER := alltrim(_ccodisbn)
	//TRC->AH1_XDTANT	:= stod(_cdtinicio)
	MSUNLOCK("TRC")
			    
Next _Ncc        
      
FT_FUSE()

FT_FUSE(cArqTd1)

FT_FGOTOP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop para tratamento das linhas do arquivo do EDI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _ncc := 1 to FT_FLASTREC()
	
	cLinha   := FT_FREADLN()
		                            
	_ccodisbn  := Substr(cLinha,1,13) // 1 com 13 posicoes
	_ccodforn  := Substr(cLinha,15,6)  // 15 com 6 posicoes
	_cSeqCont  := Substr(cLinha,22,1)  // 22 com 1 posicoes
	_cFxinic   := Substr(cLinha,24,9) // 24 com 9 posicoes
	_cFxFinal  := Substr(cLinha,34,9) // 34 com 9 posicoes
	_Pdesconto := Substr(cLinha,44,8) // 44 com 8 posicoes
	_Pda       := Substr(cLinha,53,8) // 53 com 8 posicoes
	_vnaousa   := Substr(cLinha,62,15) // 62 com 15 posicoes
	_ccontrato := Substr(cLinha,77,6) // 77 com 6 posicoes
	_cnsusa2   := Substr(cLinha,84,2) // 84 com 2 posicoes
	_ctipo     := Substr(cLinha,87,1) // 87 com 1 posicoes - corrigido por Adalberto p/ atualizar preço aplicado

	RECLOCK("TRA",.T.)
	TRA->AH2_FILIAL := XFILIAL("AH2")
	TRA->AH2_CONTRA	:= ALLTRIM(_ccontrato)
	TRA->AH2_SEQCON	:= "01"
	TRA->AH2_PRODUT	:= ALLTRIM(_ccodisbn)
	TRA->AH2_FORNEC	:= ALLTRIM(_ccodforn)
	TRA->AH2_LOJAFO := ALLTRIM("01")
	TRA->AH2_ITEM	:= strzero(val(_cSeqCont),len(TRA->AH2_ITEM))
	TRA->AH2_FXINIC	:= val(_cFxinic)
	TRA->AH2_FXFINA	:= val(_cFxFinal)
	TRA->AH2_DESCMI	:= 0
	TRA->AH2_PERCRE	:= val(_pda)
	TRA->AH2_VALREG	:= val(_vnaousa)
	TRA->AH2_PRBRUT := ALLTRIM(_ctipo)
	TRA->AH2_DESCCO := "2"
	TRA->AH2_ICMS 	:= "2"
	TRA->AH2_IPI 	:= "2"
	TRA->AH2_COFINS := "2"
    MSUNLOCK("TRA")
                     
	FT_FSKIP()
 //	_ncc++                                                                      
	
Next _Ncc                               

FT_FUSE()

return