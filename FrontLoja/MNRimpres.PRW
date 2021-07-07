#include "PROTHEUS.CH"
user function mnRimpre()
Local cTickForm	:= ""								//Texto para cupom não-fiscal para Instituto Arredondar
Local cFormaPgto 	 := GetPvProfString("Instituto Arredondar", "FormaPgto", " ", GetClientDir() + "SIGALOJA.INI" )	// Ler qual cond. pagto. no Sigaloja.ini
Local cTotalizNFis := GetPvProfString("Instituto Arredondar", "Totalizador", "01", GetClientDir() + "SIGALOJA.INI" )  // Ler qual totalizador no Sigaloja.ini
Local lRetorno := .T.								// Se função executada com sucesso


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão de Cupom Não-Fiscal                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
	A impressora deverá estar cadastrada como:
	Forma de Pagamento: A VISTA ou RECEBER, ou o código cadastrado de um deles
	Totalizador não-fiscal: DOACAO
*/

nRet := -1
nRet := IFAbrCNFis( nHdlECF, cFormaPgto , Str(1,14,2) , cTotalizNFis )
		
If nRet <> 0
	MsgStop("Erro ao efetuar a Abertura Não-Fiscal.", "Atenção!") //
	lRetorno := .F.
EndIf	

// cTickform é a descrição do texto.
cTickForm := "                EDITORA MANOLE LTDA             " + chr(10) + chr(13);
           + "                   AV. CECI. 672                " + chr(10) + chr(13);
           + chr(10) + chr(13);
		   + "CNPJ:62351341000169  IE:206186863111  IM:5252600" + chr(10) + chr(13);
		   + "------------------------------------------------" + chr(10) + chr(13);
		   
		     
nRet := IFTxtNFis( nHdlECF, cTickForm , 1 )
If nRet <> 0
	MsgStop("Erro ao efetuar o Texto Não-Fiscal.", "Atenção!") //
	lRetorno := .F.
EndIf	

nRet := IFFchCNFis( nHdlECF )
If nRet <> 0
	MsgStop("Erro ao efetuar o Encerramento Não-Fiscal.", "Atenção!") //
	lRetorno := .F.
EndIf	

Return lRetorno