#INCLUDE 'PROTHEUS.CH'
#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MANAUPD3 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de update dos dicionแrios para compatibiliza็ใo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MANAUPD3   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MANAUPD()

Local   aSay     := {}
Local   aButton  := {}
Local   aMarcadas:= {}
Local   cTitulo  := 'ATUALIZAวรO DE DICIONมRIOS E TABELAS'
Local   cDesc1   := 'Esta rotina tem como fun็ใo fazer  a atualiza็ใo  dos dicionแrios do Sistema ( SX?/SIX )'
Local   cDesc2   := 'Este processo deve ser executado em modo EXCLUSIVO, ou seja nใo podem haver outros'
Local   cDesc3   := 'usuแrios  ou  jobs utilizando  o sistema.  ษ extremamente recomendav้l  que  se  fa็a um'
Local   cDesc4   := 'BACKUP  dos DICIONมRIOS  e da  BASE DE DADOS antes desta atualiza็ใo, para que caso '
Local   cDesc5   := 'ocorra eventuais falhas, esse backup seja ser restaurado.'
Local   cDesc6   := ''
Local   cDesc7   := ''
Local   lOk      := .F.

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

FormBatch(  cTitulo,  aSay,  aButton )

If lOk
	aMarcadas := EscEmpresa()

	If !Empty( aMarcadas )
		If  MsgNoYes( 'Confirma a atualiza็ใo dos dicionแrios ?', cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, 'Atualizando', 'Aguarde, atualizando ...', .F. )
			oProcess:Activate()

			If lOk
				Final( 'Atualiza็ใo Concluํda.' )
			Else
				Final( 'Atualiza็ใo nใo Realizada.' )
			EndIf

		Else
			MsgStop( 'Atualiza็ใo nใo Realizada.', 'MANAUPD' )

		EndIf

	Else
		MsgStop( 'Atualiza็ใo nใo Realizada.', 'MANAUPD' )

	EndIf

EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSTProc  บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da grava็ใo dos arquivos           ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSTProc    - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSTProc( lEnd, aMarcadas )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ''
Local   cFile     := ''
Local   cFileLog  := ''
Local   cMask     := 'Arquivos Texto (*.TXT)|*.txt|'
Local   cTCBuild  := 'TCGetBuild'
Local   cTexto    := ''
Local   cTopBuild := ''
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( 'SM0' )
	dbGoTop()

	While !SM0->( EOF() )
		// So adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( 'Atualiza็ใo da empresa ' + aRecnoSM0[nI][2] + ' nใo efetuada.' )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			cTexto += Replicate( '-', 128 ) + CRLF
			cTexto += 'Empresa : ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF

			oProcess:SetRegua1( 8 )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX2         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSX2( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX3         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			FSAtuSX3( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SIX         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de ํndices - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSIX( @cTexto )

			oProcess:IncRegua1( 'Dicionแrio de dados - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			oProcess:IncRegua2( 'Atualizando campos/ํndices')

			// Alteracao fisica dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= '20090811' .AND. TcInternal( 89 ) == 'CLOB_SUPPORTED'
					If ( ( aArqUpd[nX] >= 'NQ ' .AND. aArqUpd[nX] <= 'NZZ' ) .OR. ( aArqUpd[nX] >= 'O0 ' .AND. aArqUpd[nX] <= 'NZZ' ) ) .AND.;
						!aArqUpd[nX] $ 'NQD,NQF,NQP,NQT'
						TcInternal( 25, 'CLOB' )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( 'Ocorreu um erro desconhecido durante a atualiza็ใo da tabela : ' + aArqUpd[nX] + '. Verifique a integridade do dicionแrio e da tabela.', 'ATENวรO' )
					cTexto += 'Ocorreu um erro desconhecido durante a atualiza็ใo da estrutura da tabela : ' + aArqUpd[nX] + CRLF
				EndIf

				If cTopBuild >= '20090811' .AND. TcInternal( 89 ) == 'CLOB_SUPPORTED'
					TcInternal( 25, 'OFF' )
				EndIf

			Next nX

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX6         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de parโmetros - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSX6( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX7         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de gatilhos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSX7( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SXA         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de pastas - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSXA( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SXB         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de consultas padrใo - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSXB( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX5         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de tabelas sistema - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSX5( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX9         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de relacionamentos - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSX9( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX1         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Dicionแrio de perguntas - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuSX1( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza os helps                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( 'Helps de Campo - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			FSAtuHlp( @cTexto )
			FSAtuHlpX1( @cTexto )

			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( '-', 128 ) + CRLF
			cAux += Replicate( ' ', 128 ) + CRLF
			cAux += 'LOG DA ATUALIZACAO DOS DICIONมRIOS' + CRLF
			cAux += Replicate( ' ', 128 ) + CRLF
			cAux += Replicate( '-', 128 ) + CRLF
			cAux += CRLF
			cAux += ' Dados Ambiente'        + CRLF
			cAux += ' --------------------'  + CRLF
			cAux += ' Empresa / Filial...: ' + cEmpAnt + '/' + cFilAnt  + CRLF
			cAux += ' Nome Empresa.......: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_NOMECOM', cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
			cAux += ' Nome Filial........: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_FILIAL' , cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
			cAux += ' DataBase...........: ' + DtoC( dDataBase )  + CRLF
			cAux += ' Data / Hora Inicio.: ' + DtoC( Date() ) + ' / ' + Time()  + CRLF
			cAux += ' Environment........: ' + GetEnvServer()  + CRLF
			cAux += ' StartPath..........: ' + GetSrvProfString( 'StartPath', '' )  + CRLF
			cAux += ' RootPath...........: ' + GetSrvProfString( 'RootPath', '' )  + CRLF
			cAux += ' Versao.............: ' + GetVersao(.T.)  + CRLF
			cAux += ' Usuario TOTVS    ..: ' + __cUserId + ' ' +  cUserName + CRLF
			cAux += ' Computer Name......: ' + GetComputerName()  + CRLF

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				cAux += ' '  + CRLF
				cAux += ' Dados Thread' + CRLF
				cAux += ' --------------------'  + CRLF
				cAux += ' Usuario da Rede....: ' + aInfo[nPos][1] + CRLF
				cAux += ' Estacao............: ' + aInfo[nPos][2] + CRLF
				cAux += ' Programa Inicial...: ' + aInfo[nPos][5] + CRLF
				cAux += ' Environment........: ' + aInfo[nPos][6] + CRLF
				cAux += ' Conexao............: ' + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), '' ), Chr( 10 ), '' ) )  + CRLF
			EndIf
			cAux += Replicate( '-', 128 ) + CRLF
			cAux += CRLF

			cTexto := cAux + cTexto + CRLF

			cTexto += Replicate( '-', 128 ) + CRLF
			cTexto += ' Data / Hora Final.: ' + DtoC( Date() ) + ' / ' + Time()  + CRLF
			cTexto += Replicate( '-', 128 ) + CRLF

			cFileLog := MemoWrite( CriaTrab( , .F. ) + '.log', cTexto )

			Define Font oFont Name 'Mono AS' Size 5, 12

			Define MsDialog oDlg Title 'Atualizacao concluida.' From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, '' ), If( cFile == '', .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel // Salva e Apaga //'Salvar Como...'

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX2 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX2 - Arquivos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX2   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX2( cTexto )
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ''
Local cEmpr     := ''
Local cPath     := ''
Local nI        := 0
Local nJ        := 0

cTexto  += 'Inicio da Atualizacao do SX2' + CRLF + CRLF

aEstrut := { 'X2_CHAVE', 'X2_PATH', 'X2_ARQUIVO', 'X2_NOME', 'X2_NOMESPA', 'X2_NOMEENG', 'X2_DELET', ;
             'X2_MODO' , 'X2_TTS' , 'X2_ROTINA' , 'X2_PYME', 'X2_UNICO'  , 'X2_MODULO' }

dbSelectArea( 'SX2' )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela PA2
//
aAdd( aSX2, {'PA2',cPath,'PA2'+cEmpr,'REGISTRO DE OCORRENCIAS','REGISTRO DE OCORRENCIAS','REGISTRO DE OCORRENCIAS',0,'C','','','','',0} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( 'SX2' )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( 'Atualizando Arquivos (SX2)...')

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + '/'
			cTexto += 'Foi incluํda a tabela ' + aSX2[nI][1] + CRLF
		EndIf

		RecLock( 'SX2', .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == 'X2_ARQUIVO'
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), ' ', '' ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), ' ', '' ) )
			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + '_UNQ'  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + '|' + RetSqlName( aSX2[nI][1] ) + '_UNQ' )
				cTexto += 'Foi alterada chave unica da tabela ' + aSX2[nI][1] + CRLF
			Else
				cTexto += 'Foi criada   chave unica da tabela ' + aSX2[nI][1] + CRLF
			EndIf
		EndIf

	EndIf

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX2' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX2 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX3 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX3 - Campos        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX3( cTexto )
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ''
Local cAliasAtu := ''
Local cMsg      := ''
Local cSeqAtu   := ''
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

cTexto  += 'Inicio da Atualizacao do SX3' + CRLF + CRLF

aEstrut := { 'X3_ARQUIVO', 'X3_ORDEM'  , 'X3_CAMPO'  , 'X3_TIPO'   , 'X3_TAMANHO', 'X3_DECIMAL', ;
             'X3_TITULO' , 'X3_TITSPA' , 'X3_TITENG' , 'X3_DESCRIC', 'X3_DESCSPA', 'X3_DESCENG', ;
             'X3_PICTURE', 'X3_VALID'  , 'X3_USADO'  , 'X3_RELACAO', 'X3_F3'     , 'X3_NIVEL'  , ;
             'X3_RESERV' , 'X3_CHECK'  , 'X3_TRIGGER', 'X3_PROPRI' , 'X3_BROWSE' , 'X3_VISUAL' , ;
             'X3_CONTEXT', 'X3_OBRIGAT', 'X3_VLDUSER', 'X3_CBOX'   , 'X3_CBOXSPA', 'X3_CBOXENG', ;
             'X3_PICTVAR', 'X3_WHEN'   , 'X3_INIBRW' , 'X3_GRPSXG' , 'X3_FOLDER' , 'X3_PYME'   }

//
// Tabela SF1
//
aAdd( aSX3, {'SF1','06','F1_XRO','C',6,0,'R. O','R. O','R. O','Registro de Ocorrencia','Registro de Ocorrencia','Registro de Ocorrencia','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )

//
// Tabela PA2
//
aAdd( aSX3, {'PA2','01','PA2_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','',''} )
aAdd( aSX3, {'PA2','02','PA2_DOCENT','C',9,0,'Doc Entrada','Doc Entrada','Doc Entrada','Documento de Entrada','Documento de Entrada','Documento de Entrada','','iIf(!Empty(M->PA2_SERIE),ExistCpo("SF1",M->PA2_DOCENT+M->PA2_SERIE,1), .T.)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SF102',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','INCLUI','','','',''} )
aAdd( aSX3, {'PA2','03','PA2_SERIE' ,'C',3,0,'Serie Ent','Serie Ent','Serie Ent','Serie Doc Entrada','Serie Doc Entrada','Serie Doc Entrada','','iIf(!Empty(M->PA2_DOCENT),ExistCpo("SF1",M->PA2_DOCENT+M->PA2_SERIE,1), .T.)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','INCLUI','','','',''} )
aAdd( aSX3, {'PA2','04','PA2_CLIFOR','C',6,0,'Cliente','Cliente','Cliente','Cliente ou Fornecedor','Cliente ou Fornecedor','Cliente ou Fornecedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA1',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','INCLUI','','','',''} )
aAdd( aSX3, {'PA2','05','PA2_LOJA'  ,'C',2,0,'Loja','Loja','Loja','Loja do Cliente ou Fornec','Loja do Cliente ou Fornec','Loja do Cliente ou Fornec','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','INCLUI','','','',''} )
aAdd( aSX3, {'PA2','06','PA2_RO'    ,'C',6,0,'R. O','R. O','R. O','Registro de Ocorrencia','Registro de Ocorrencia','Registro de Ocorrencia','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'GETSXENUM("PA2","PA2_RO")','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','07','PA2_ISBN'  ,'C',15,0,'ISBN','ISBN','ISBN','ISBN   DO LIVRO','ISBN   DO LIVRO','ISBN   DO LIVRO','@!','ExistCpo("SB1",M->PA2_ISBN,1)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SB1',0,	Chr(254) + Chr(192),'','S','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','08','PA2_DESPRO','C',30,0,'Desc Produto','Desc Produto','Desc Produto','Desc Produto','Desc Produto','Desc Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'iIf (!INCLUI, Posicione("SB1",1,XFILIAL("SB1")+PA2->PA2_ISBN,"B1_DESC"),"")','',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','Posicione("SB1",1,XFILIAL("SB1")+PA2->PA2_ISBN,"B1_DESC")','','',''} )
//aAdd( aSX3, {'PA2','09','PA2_ITEMNF','C',30,0,'Desc Produto','Desc Produto','Desc Produto','Desc Produto','Desc Produto','Desc Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'iIf (!INCLUI, Posicione("SB1",1,XFILIAL("SB1")+PA2->PA2_ISBN,"B1_DESC"),"")','',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','Posicione("SB1",1,XFILIAL("SB1")+PA2->PA2_ISBN,"B1_DESC")','','',''} )
aAdd( aSX3, {'PA2','09','PA2_ITEMNF','C',30,0,'Desc Produto','Desc Produto','Desc Produto','Desc Produto','Desc Produto','Desc Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'iIf (!INCLUI, Posicione("SB1",1,XFILIAL("SB1")+PA2->PA2_ISBN,"B1_DESC"),"")','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','Posicione("SB1",1,XFILIAL("SB1")+PA2->PA2_ISBN,"B1_DESC")','','',''} )
aAdd( aSX3, {'PA2','10','PA2_TIPO'  ,'C',3,0,'Tipo da Oco','Tipo da Oco','Tipo da Oco','Tipo da Ocorrencia','Tipo da Ocorrencia','Tipo da Ocorrencia','@!','ExistCpo("SX5","_B"+ M->PA2_TIPO)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','_B',0,	Chr(254) + Chr(192),'','S','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','11','PA2_DESOCO','C',30,0,'Desc Ocorren','Desc Ocorren','Desc Ocorren','Desc Ocorrencia','Desc Ocorrencia','Desc Ocorrencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'iIf (!INCLUI, Posicione("SX5",1,XFILIAL("SX5")+ "_B" + PA2->PA2_TIPO ,"X5_DESCRI"),"")','',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','Posicione("SX5",1,XFILIAL("SX5")+ "_B" + PA2->PA2_TIPO ,"X5_DESCRI")','','',''} )
aAdd( aSX3, {'PA2','12','PA2_QTD'   ,'N',12,2,'Quantidade','Quantidade','Quantidade','Quantidade em Ocorrencia','Quantidade em Ocorrencia','Quantidade em Ocorrencia','@E 999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','13','PA2_OBS'   ,'C',80,0,'Observacao','Observacao','Observacao','Observacoa da ocorrencia','Observacoa da ocorrencia','Observacoa da ocorrencia','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','',''} )

//
// Tabela SA1
//
aAdd( aSX3, {'SA1','K2','A1_XDESC1','N',5,2,'Desc Publico','Desc Publico','Desc Publico','Desconto Segmento Publico','Desconto Segmento Publico','Desconto Segmento Publico','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K3','A1_XDESC2','N',5,2,'Desc Publico','Desc Publico','Desc Publico','Desconto Segmento Publico','Desconto Segmento Publico','Desconto Segmento Publico','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K4','A1_XDESC3','N',5,2,'Desc Ex/Huma','Desc Ex/Huma','Desc Ex/Huma','Desconto Segmento Ex/Huma','Desconto Segmento Ex/Huma','Desconto Segmento Ex/Huma','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K5','A1_XDESC4','N',5,2,'Desc Civ/CLT','Desc Civ/CLT','Desc Civ/CLT','Desconto Segmento Civ/CLT','Desconto Segmento Civ/CLT','Desconto Segmento Civ/CLT','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K6','A1_XDESC5','N',5,2,'Desc Seg 5','Desc Seg 5','Desc Seg 5','Desc Segmento 5','Desc Segmento 5','Desc Segmento 5','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K7','A1_XDESC6','N',5,2,'Desc Seg 5','Desc Seg 5','Desc Seg 5','Desc Segmento 5','Desc Segmento 5','Desc Segmento 5','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K8','A1_XCOMIS1','N',5,2,'Comi Publico','Comi Publico','Comi Publico','Comissao Segmento publico','Comissao Segmento publico','Comissao Segmento publico','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','K9','A1_XCOMIS2','N',5,2,'Comi Publico','Comi Publico','Comi Publico','Comissao Segmento publico','Comissao Segmento publico','Comissao Segmento publico','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','L0','A1_XCOMIS3','N',5,2,'Comi Ex/Huma','Comi Ex/Huma','Comi Ex/Huma','Comissao Segmento Ex/Huma','Comissao Segmento Ex/Huma','Comissao Segmento Ex/Huma','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','L1','A1_XCOMIS4','N',5,2,'Coms Civ/CLT','Coms Civ/CLT','Coms Civ/CLT','Comssao Sefmento Civ/CLT','Comssao Sefmento Civ/CLT','Comssao Sefmento Civ/CLT','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','L2','A1_XCOMIS5','N',5,2,'Comi Seg 5','Comi Seg 5','Comi Seg 5','Comissao Segmento 5','Comissao Segmento 5','Comissao Segmento 5','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SA1','L3','A1_XCOMIS6','N',5,2,'Comi Seg 6','Comi Seg 6','Comi Seg 6','Comissao Segmento 6','Comissao Segmento 6','Comissao Segmento 6','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
//
// Tabela SB1
//
aAdd( aSX3, {'SB1','L5','B1_XSEGME','C',2,0,'Tipo Segment','Tipo Segment','Tipo Segment','Tipo Segmento','Tipo Segmento','Tipo Segmento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','_A',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
//
// Tabela SC5
//
aAdd( aSX3, {'SC5','92','C5_XDESC1','N',5,2,'Desc Saude','Desc Saude','Desc Saude','Desconto Segmento Saude','Desconto Segmento Saude','Desconto Segmento Saude','@E 999.99','(Positivo() .or. vazio()) .and. a410Recalc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','92','C5_XDESC2','N',5,2,'Desc Publico','Desc Publico','Desc Publico','Desconto Segmento Publico','Desconto Segmento Publico','Desconto Segmento Publico','@E 999.99','(Positivo() .or. vazio()) .and. a410Recalc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','93','C5_XDESC3','N',5,2,'Desc Ex/Huma','Desc Ex/Huma','Desc Ex/Huma','Desconto Segmento Ex/Huma','Desconto Segmento Ex/Huma','Desconto Segmento Ex/Huma','@E 999.99','(Positivo() .or. vazio()) .and. a410Recalc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','94','C5_XDESC4','N',5,2,'Desc Civ/CLT','Desc Civ/CLT','Desc Civ/CLT','Desconto Segmento Civ/CLT','Desconto Segmento Civ/CLT','Desconto Segmento Civ/CLT','@E 999.99','(Positivo() .or. vazio()) .and. a410Recalc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','95','C5_XDESC5','N',5,2,'Desc Seg 5','Desc Seg 5','Desc Seg 5','Desconto Segmento 5','Desconto Segmento 5','Desconto Segmento 5','@E 999.99','(Positivo() .or. vazio()) .and. a410Recalc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','96','C5_XDESC6','N',5,2,'Desc Seg 6','Desc Seg 6','Desc Seg 6','Desconto Segmento 6','Desconto Segmento 6','Desconto Segmento 6','@E 999.99','(Positivo() .or. vazio()) .and. a410Recalc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','97','C5_XCOMIS1','N',5,2,'Comi Saude','Comi Saude','Comi Saude','Comissao Segmento Saude','Comissao Segmento Saude','Comissao Segmento Saude','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','97','C5_XCOMIS2','N',5,2,'Comi Publico','Comi Publico','Comi Publico','Comissao Segmento Publico','Comissao Segmento Publico','Comissao Segmento Publico','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','98','C5_XCOMIS3','N',5,2,'Comi Ex/Huma','Comi Ex/Huma','Comi Ex/Huma','Comissao Segmento Ex/Huma','Comissao Segmento Ex/Huma','Comissao Segmento Ex/Huma','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','99','C5_XCOMIS4','N',5,2,'Comi Civ/CLT','Comi Civ/CLT','Comi Civ/CLT','Comissao Segmento Civ/CLT','Comissao Segmento Civ/CLT','Comissao Segmento Civ/CLT','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','9A','C5_XCOMIS5','N',5,2,'Comi Seg 5','Comi Seg 5','Comi Seg 5','Comissao Seguimento 5','Comissao Seguimento 5','Comissao Seguimento 5','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'SC5','A1','C5_XCOMIS6','N',5,2,'Comi Seg 6','Comi Seg 6','Comi Seg 6','Comissao Segmento 6','Comissao Segmento 6','Comissao Segmento 6','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
//
// Tabela SC6
//
aAdd( aSX3, {'SC6','A8','C6_XSEGME','C',2,0,'Tipo Segment','Tipo Segment','Tipo Segment','Tipo Segmento','Tipo Segmento','Tipo Segmento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )

//
// Atualizando dicionแrio
//

nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_ARQUIVO' } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_ORDEM'   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_CAMPO'   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_TAMANHO' } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == 'X3_GRPSXG'  } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( 'SX3' )
dbSetOrder( 2 )
cAliasAtu := ''

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajsuta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				cTexto += 'O tamanho do campo ' + aSX3[nI][nPosCpo] + ' nao atualizado e foi mantido em ['
				cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + ']'+ CRLF
				cTexto += '   por pertencer ao grupo de campos [' + SX3->X3_GRPSXG + ']' + CRLF + CRLF
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + '/'
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := '00'
			cAliasAtu := aSX3[nI][nPosArq]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + 'ZZ', .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( 'SX3', .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == 2    // Ordem
				FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu )

			ElseIf FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		cTexto += 'Criado o campo ' + aSX3[nI][nPosCpo] + CRLF

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					cTexto += 'O tamanho do campo ' + aSX3[nI][nPosCpo] + ' nao atualizado e foi mantido em ['
					cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + ']'+ CRLF
					cTexto += '   por pertencer ao grupo de campos [' + SX3->X3_GRPSXG + ']' + CRLF + CRLF
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			//
			// Se o campo estiver diferente da estrutura
			//
			If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), ' ', '' ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , ' ', '' ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> 'X3_ORDEM'

				cMsg := 'O campo ' + aSX3[nI][nPosCpo] + ' estแ com o ' + SX3->( FieldName( nJ ) ) + ;
				' com o conte๚do' + CRLF + ;
				'[' + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
				'que serแ substituido pelo NOVO conte๚do' + CRLF + ;
				'[' + RTrim( AllToChar( aSX3[nI][nJ] ) ) + ']' + CRLF + ;
				'Deseja substituir ? '

				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( 'ATUALIZAวรO DE DICIONมRIOS E TABELAS', cMsg, { 'Sim', 'Nใo', 'Sim p/Todos', 'Nใo p/Todos' }, 3,'Diferen็a de conte๚do - SX3' )
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )

					If lTodosSim
						nOpcA := 1
						lTodosSim := MsgNoYes( 'Foi selecionada a op็ใo de REALIZAR TODAS altera็๕es no SX3 e NรO MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma a a็ใo [Sim p/Todos] ?' )
					EndIf

					If lTodosNao
						nOpcA := 2
						lTodosNao := MsgNoYes( 'Foi selecionada a op็ใo de NรO REALIZAR nenhuma altera็ใo no SX3 que esteja diferente da base e NรO MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma esta a็ใo [Nใo p/Todos]?' )
					EndIf

				EndIf

				If nOpcA == 1
					cTexto += 'Alterado o campo ' + aSX3[nI][nPosCpo] + CRLF
					cTexto += '   ' + PadR( SX3->( FieldName( nJ ) ), 10 ) + ' de [' + AllToChar( SX3->( FieldGet( nJ ) ) ) + ']' + CRLF
					cTexto += '            para [' + AllToChar( aSX3[nI][nJ] )          + ']' + CRLF + CRLF

					RecLock( 'SX3', .F. )
					FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
					dbCommit()
					MsUnLock()

				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( 'Atualizando Campos de Tabelas (SX3)...' )

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX3' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX3 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSIX บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SIX - Indices       ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSIX   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSIX( cTexto )
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

cTexto  += 'Inicio da Atualizacao do SIX' + CRLF + CRLF

aEstrut := { 'INDICE' , 'ORDEM' , 'CHAVE', 'DESCRICAO', 'DESCSPA'  , ;
             'DESCENG', 'PROPRI', 'F3'   , 'NICKNAME' , 'SHOWPESQ' }

//
// Tabela PA2
//
aAdd( aSIX, {'PA2','1','PA2_FILIAL+PA2_DOCENT+PA2_SERIE+PA2_CLIFOR+PA2_LOJA','Doc Entrada+Serie Ent+Cliente+Loja','Doc Entrada+Serie Ent+Cliente+Loja','Doc Entrada+Serie Ent+Cliente+Loja','U','','','N'} )
aAdd( aSIX, {'PA2','2','PA2_FILIAL+PA2_RO+PA2_ISBN','R. O + Item NF','R. O+Item NF','ISBN DO LIVRO','U','','','N'} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( 'SIX' )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		RecLock( 'SIX', .T. )
		lDelInd := .F.
		cTexto += 'อndice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
	Else
		lAlt := .F.
		RecLock( 'SIX', .F. )
	EndIf

	If !StrTran( Upper( AllTrim( CHAVE )       ), ' ', '') == ;
	    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), ' ', '' )
		aAdd( aArqUpd, aSIX[nI][1] )

		If lAlt
			lDelInd := .T.  // Se for alteracao precisa apagar o indice do banco
			cTexto += 'อndice alterado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
		EndIf

		For nJ := 1 To Len( aSIX[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
			EndIf
		Next nJ

		If lDelInd
			TcInternal( 60, RetSqlName( aSIX[nI][1] ) + '|' + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] ) // Exclui sem precisar baixar o TOP
		EndIf

	EndIf

	dbCommit()
	MsUnLock()

	oProcess:IncRegua2( 'Atualizando ํndices...' )

Next nI

cTexto += CRLF + 'Final da Atualizacao do SIX' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSIX )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX6 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX6 - Parโmetros    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX6   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX6( cTexto )
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ''
Local cMsg      := ''
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

cTexto  += 'Inicio da Atualizacao do SX6' + CRLF + CRLF

aEstrut := { 'X6_FIL'    , 'X6_VAR'  , 'X6_TIPO'   , 'X6_DESCRIC', 'X6_DSCSPA' , 'X6_DSCENG' , 'X6_DESC1'  , 'X6_DSCSPA1',;
             'X6_DSCENG1', 'X6_DESC2', 'X6_DSCSPA2', 'X6_DSCENG2', 'X6_CONTEUD', 'X6_CONTSPA', 'X6_CONTENG', 'X6_PROPRI' , 'X6_PYME' }


//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( 'SX6' )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .T.
	lReclock  := .T.

	If SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lReclock  := .F.

		If !StrTran( SX6->X6_CONTEUD, ' ', '' ) == StrTran( aSX6[nI][13], ' ', '' )

			cMsg := 'O parโmetro ' + aSX6[nI][2] + ' estแ com o conte๚do' + CRLF + ;
			'[' + RTrim( StrTran( SX6->X6_CONTEUD, ' ', '' ) ) + ']' + CRLF + ;
			', que ้ serแ substituido pelo NOVO conte๚do ' + CRLF + ;
			'[' + RTrim( StrTran( aSX6[nI][13]   , ' ', '' ) ) + ']' + CRLF + ;
			'Deseja substituir ? '

			If      lTodosSim
				nOpcA := 1
			ElseIf  lTodosNao
				nOpcA := 2
			Else
				nOpcA := Aviso( 'ATUALIZAวรO DE DICIONมRIOS E TABELAS', cMsg, { 'Sim', 'Nใo', 'Sim p/Todos', 'Nใo p/Todos' }, 3,'Diferen็a de conte๚do - SX6' )
				lTodosSim := ( nOpcA == 3 )
				lTodosNao := ( nOpcA == 4 )

				If lTodosSim
					nOpcA := 1
					lTodosSim := MsgNoYes( 'Foi selecionada a op็ใo de REALIZAR TODAS altera็๕es no SX6 e NรO MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma a a็ใo [Sim p/Todos] ?' )
				EndIf

				If lTodosNao
					nOpcA := 2
					lTodosNao := MsgNoYes( 'Foi selecionada a op็ใo de NรO REALIZAR nenhuma altera็ใo no SX6 que esteja diferente da base e NรO MOSTRAR mais a tela de aviso.' + CRLF + 'Confirma esta a็ใo [Nใo p/Todos]?' )
				EndIf

			EndIf

			lContinua := ( nOpcA == 1 )

			If lContinua
				cTexto += 'Foi alterado o parโmetro ' + aSX6[nI][1] + aSX6[nI][2] + ' de [' + ;
				AllTrim( SX6->X6_CONTEUD ) + ']' + ' para [' + AllTrim( aSX6[nI][13] ) + ']' + CRLF
			EndIf

		Else
			lContinua := .F.
		EndIf

	Else
		cTexto += 'Foi incluํdo o parโmetro ' + aSX6[nI][1] + aSX6[nI][2] + ' Conte๚do [' + AllTrim( aSX6[nI][13] ) + ']'+ CRLF

	EndIf

	If lContinua

		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + '/'
		EndIf

		RecLock( 'SX6', lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		oProcess:IncRegua2( 'Atualizando Arquivos (SX6)...')

	EndIf

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX6' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX6 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX7 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX7 - Gatilhos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX7   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX7( cTexto )
Local aEstrut   := {}
Local aSX7      := {}
Local cAlias    := ''
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

cTexto  += 'Inicio da Atualizacao do SX7' + CRLF + CRLF

aEstrut := { 'X7_CAMPO', 'X7_SEQUENC', 'X7_REGRA', 'X7_CDOMIN', 'X7_TIPO', 'X7_SEEK', ;
             'X7_ALIAS', 'X7_ORDEM'  , 'X7_CHAVE', 'X7_PROPRI', 'X7_CONDIC' }

//
// Campo PA2_ISBN
//
aAdd( aSX7, {'PA2_ISBN','001','SB1->B1_DESC','PA2_DESPRO','P','S','SB1',1,'xFilial("SB1") + M->PA2_ISBN','U',''} )
//
// Campo PA2_TIPO
//
aAdd( aSX7, {'PA2_TIPO','001','SX5->X5_DESCRI','PA2_DESOCO','P','S','SX5',1,'xFilial("SX5") + "_B" + M->PA2_TIPO','U',''} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( 'SX7' )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + '/'
			cTexto += 'Foi incluํdo o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
		EndIf

		RecLock( 'SX7', .T. )
	Else

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + '/'
			cTexto += 'Foi alterado o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
		EndIf

		RecLock( 'SX7', .F. )
	EndIf

	For nJ := 1 To Len( aSX7[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
		EndIf
	Next nJ

	dbCommit()
	MsUnLock()

	oProcess:IncRegua2( 'Atualizando Arquivos (SX7)...')

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX7' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX7 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXA บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXA - Pastas        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXA   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXA( cTexto )
Local aEstrut   := {}
Local aSXA      := {}
Local cAlias    := ''
Local nI        := 0
Local nJ        := 0

cTexto  += 'Inicio da Atualizacao do SXA' + CRLF + CRLF

aEstrut := { 'XA_ALIAS', 'XA_ORDEM', 'XA_DESCRIC', 'XA_DESCSPA', 'XA_DESCENG', 'XA_PROPRI' }

cTexto += CRLF + 'Final da Atualizacao do SXA' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSXA )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXB บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXB - Consultas Pad ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXB   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXB( cTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ''
Local cMsg      := ''
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

cTexto  += 'Inicio da Atualizacao do SXB' + CRLF + CRLF

aEstrut := { 'XB_ALIAS',  'XB_TIPO'   , 'XB_SEQ'    , 'XB_COLUNA' , ;
             'XB_DESCRI', 'XB_DESCSPA', 'XB_DESCENG', 'XB_CONTEM' }

cTexto += CRLF + 'Final da Atualizacao do SXB' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSXB )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX5 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX5 - Indices       ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX5   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX5( cTexto )
Local aEstrut   := {}
Local aSX5      := {}
Local cAlias    := ''
Local nI        := 0
Local nJ        := 0

cTexto  += 'Inicio Atualizacao SX5' + CRLF + CRLF

aEstrut := { 'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE', 'X5_DESCRI', 'X5_DESCSPA', 'X5_DESCENG' }

//
// Tabela 00
//
aAdd( aSX5, {'  ','00','_A','SEGMENTOS','SEGMENTOS','SEGMENTOS'} )
//
// Tabela _A
//
aAdd( aSX5, {'  ','_A','01','SAUDE','SAUDE','SAUDE'} )
aAdd( aSX5, {'  ','_A','02','PUBLICO','PUBLICO','PUBLICO'} )
aAdd( aSX5, {'  ','_A','03','EXATAS/HUMANAS','EXATAS/HUMANAS','EXATAS/HUMANAS'} )
aAdd( aSX5, {'  ','_A','04','CODIGOS(CIVIL/CLT)','CODIGOS(CIVIL/CLT)','CODIGOS(CIVIL/CLT)'} )
aAdd( aSX5, {'  ','_A','05','SEGMENTO 5','SEGMENTO 5','SEGMENTO 5'} )
aAdd( aSX5, {'  ','_A','06','SEGMENTO 6','SEGMENTO 6','SEGMENTO 6'} )

//
// Tabela 01
//
aAdd( aSX5, {'  ','00','_B','TIPOS DE OCORRENCIA','TIPOS DE OCORRENCIA','TIPOS DE OCORRENCIA'} )
//
// Tabela _B
//
aAdd( aSX5, {'  ','_B','01','CAPA AMASSADA','CAPA AMASSADA','CAPA AMASSADA'} )
aAdd( aSX5, {'  ','_B','02','PONTA DA CAPA AMASSADA','PONTA DA CAPA AMASSADA','PONTA DA CAPA AMASSADA'} )
aAdd( aSX5, {'  ','_B','03','CAPA RISCADA E AMASSADA','CAPA RISCADA E AMASSADA','CAPA RISCADA E AMASSADA'} )
aAdd( aSX5, {'  ','_B','04','PONTA DA CAPA RASGADA','PONTA DA CAPA RASGADA','PONTA DA CAPA RASGADA'} )
aAdd( aSX5, {'  ','_B','05','PAGINA COM DEFEITO DE IMPRESSAO','PAGINA COM DEFEITO DE IMPRESSAO','PAGINA COM DEFEITO DE IMPRESSAO'} )
aAdd( aSX5, {'  ','_B','06','CAPA COM DEFEITO DE IMPRESSAO','CAPA COM DEFEITO DE IMPRESSAO','CAPA COM DEFEITO DE IMPRESSAO'} )
aAdd( aSX5, {'  ','_B','07','CAPA CORTADA','CAPA CORTADA','CAPA CORTADA'} )
aAdd( aSX5, {'  ','_B','08','DEV. SEM OCORRENCIAS','DEV. SEM OCORRENCIAS','DEV. SEM OCORRENCIAS'} )
aAdd( aSX5, {'  ','_B','09','CAPA RASGADA','CAPA RASGADA','CAPA RASGADA'} )
aAdd( aSX5, {'  ','_B','10','CAPA DANIFICADA','CAPA DANIFICADA','CAPA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','11','BORDA DA CAPA RASGADA','BORDA DA CAPA RASGADA','BORDA DA CAPA RASGADA'} )
aAdd( aSX5, {'  ','_B','12','CAPA RASGADA E AMASSADA','CAPA RASGADA E AMASSADA','CAPA RASGADA E AMASSADA'} )
aAdd( aSX5, {'  ','_B','13','FALTA DE LIVROS','FALTA DE LIVROS','FALTA DE LIVROS'} )
aAdd( aSX5, {'  ','_B','14','SEM DEFEITOS GRAFICOS/MANUSEIO','SEM DEFEITOS GRAFICOS/MANUSEIO','SEM DEFEITOS GRAFICOS/MANUSEIO'} )
aAdd( aSX5, {'  ','_B','15','BORDA DA CAPA AMASSADA','BORDA DA CAPA AMASSADA','BORDA DA CAPA AMASSADA'} )
aAdd( aSX5, {'  ','_B','16','PONTA DA CAPA DANIFICADA','PONTA DA CAPA DANIFICADA','PONTA DA CAPA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','17','SOBRAS DE LIVROS','SOBRAS DE LIVROS','SOBRAS DE LIVROS'} )
aAdd( aSX5, {'  ','_B','18','CAPA RISCADA','CAPA RISCADA','CAPA RISCADA'} )
aAdd( aSX5, {'  ','_B','19','BORDA DA CAPA DANIFICADA','BORDA DA CAPA DANIFICADA','BORDA DA CAPA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','20','LIVRO SUJO E DANIFICADO','LIVRO SUJO E DANIFICADO','LIVRO SUJO E DANIFICADO'} )
aAdd( aSX5, {'  ','_B','21','CAPA TODA RISCADA','CAPA TODA RISCADA','CAPA TODA RISCADA'} )
aAdd( aSX5, {'  ','_B','22','BORDA E CAPA DANIFICADA','BORDA E CAPA DANIFICADA','BORDA E CAPA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','23','PAGINAS EM BRANCO','PAGINAS EM BRANCO','PAGINAS EM BRANCO'} )
aAdd( aSX5, {'  ','_B','24','FALTANDO PAGINAS','FALTANDO PAGINAS','FALTANDO PAGINAS'} )
aAdd( aSX5, {'  ','_B','25','PAGINAS DESIGUAIS','PAGINAS DESIGUAIS','PAGINAS DESIGUAIS'} )
aAdd( aSX5, {'  ','_B','26','PAGINAS SOLTAS','PAGINAS SOLTAS','PAGINAS SOLTAS'} )
aAdd( aSX5, {'  ','_B','27','CAPA MANCHADA','CAPA MANCHADA','CAPA MANCHADA'} )
aAdd( aSX5, {'  ','_B','28','CAPA DESBOTADA','CAPA DESBOTADA','CAPA DESBOTADA'} )
aAdd( aSX5, {'  ','_B','29','CAPA DOBRADA','CAPA DOBRADA','CAPA DOBRADA'} )
aAdd( aSX5, {'  ','_B','30','LIVRO COM AS PAGINAS MOFADAS','LIVRO COM AS PAGINAS MOFADAS','LIVRO COM AS PAGINAS MOFADAS'} )
aAdd( aSX5, {'  ','_B','31','LIVRO COM A CAPA DESCOLADA','LIVRO COM A CAPA DESCOLADA','LIVRO COM A CAPA DESCOLADA'} )
aAdd( aSX5, {'  ','_B','32','LIVRO COM PAGINAS MOLHADAS','LIVRO COM PAGINAS MOLHADAS','LIVRO COM PAGINAS MOLHADAS'} )
aAdd( aSX5, {'  ','_B','33','CAPA INVERTIDA','CAPA INVERTIDA','CAPA INVERTIDA'} )
aAdd( aSX5, {'  ','_B','34','PAGINAS DESORDENADAS','PAGINAS DESORDENADAS','PAGINAS DESORDENADAS'} )
aAdd( aSX5, {'  ','_B','35','PAGINAS DESCOLANDO','PAGINAS DESCOLANDO','PAGINAS DESCOLANDO'} )
aAdd( aSX5, {'  ','_B','36','PAGINAS INVERTIDAS','PAGINAS INVERTIDAS','PAGINAS INVERTIDAS'} )
aAdd( aSX5, {'  ','_B','37','PAGINAS COLADAS','PAGINAS COLADAS','PAGINAS COLADAS'} )
aAdd( aSX5, {'  ','_B','38','PAGINAS RASGADAS','PAGINAS RASGADAS','PAGINAS RASGADAS'} )
aAdd( aSX5, {'  ','_B','39','CONTEUDO DIFERENTE DA CAPA','CONTEUDO DIFERENTE DA CAPA','CONTEUDO DIFERENTE DA CAPA'} )
aAdd( aSX5, {'  ','_B','40','PONTA E BORDA DA CAPA RASGADA','PONTA E BORDA DA CAPA RASGADA','PONTA E BORDA DA CAPA RASGADA'} )
aAdd( aSX5, {'  ','_B','41','PONTA E CAPA DANIFICADA','PONTA E CAPA DANIFICADA','PONTA E CAPA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','42','BORDA DA CAPA DESBOTADA','BORDA DA CAPA DESBOTADA','BORDA DA CAPA DESBOTADA'} )
aAdd( aSX5, {'  ','_B','43','PONTA E BORDA DANIFICADA','PONTA E BORDA DANIFICADA','PONTA E BORDA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','44','PAGINAS AMASSADAS','PAGINAS AMASSADAS','PAGINAS AMASSADAS'} )
aAdd( aSX5, {'  ','_B','45','LIVRO COM AS PAGINAS MANCHADAS','LIVRO COM AS PAGINAS MANCHADAS','LIVRO COM AS PAGINAS MANCHADAS'} )
aAdd( aSX5, {'  ','_B','46','PONTA DA CAPA RALADA','PONTA DA CAPA RALADA','PONTA DA CAPA RALADA'} )
aAdd( aSX5, {'  ','_B','47','LIVRO COM DEFEITO DE IMPRESSAO','LIVRO COM DEFEITO DE IMPRESSAO','LIVRO COM DEFEITO DE IMPRESSAO'} )
aAdd( aSX5, {'  ','_B','48','LIVRO TODO DANIFICADO','LIVRO TODO DANIFICADO','LIVRO TODO DANIFICADO'} )
aAdd( aSX5, {'  ','_B','49','BORDA DA CAPA RALADA','BORDA DA CAPA RALADA','BORDA DA CAPA RALADA'} )
aAdd( aSX5, {'  ','_B','50','CAPA DESIGUAL','CAPA DESIGUAL','CAPA DESIGUAL'} )
aAdd( aSX5, {'  ','_B','51','LIVRO COM AS PAGINAS SUJAS','LIVRO COM AS PAGINAS SUJAS','LIVRO COM AS PAGINAS SUJAS'} )
aAdd( aSX5, {'  ','_B','52','PAGINAS MANCHADAS','PAGINAS MANCHADAS','PAGINAS MANCHADAS'} )
aAdd( aSX5, {'  ','_B','53','CAPA RALADA','CAPA RALADA','CAPA RALADA'} )
aAdd( aSX5, {'  ','_B','54','CAPA COM DEFEITO DE IMPRESSAO','CAPA COM DEFEITO DE IMPRESSAO','CAPA COM DEFEITO DE IMPRESSAO'} )
aAdd( aSX5, {'  ','_B','55','LIVROS COM DEFEITOS GRAFICOS','LIVROS COM DEFEITOS GRAFICOS','LIVROS COM DEFEITOS GRAFICOS'} )
aAdd( aSX5, {'  ','_B','56','PONTA DA CAPA AMASSADA','PONTA DA CAPA AMASSADA','PONTA DA CAPA AMASSADA'} )
aAdd( aSX5, {'  ','_B','57','LIVRO SEM CD-ROM','LIVRO SEM CD-ROM','LIVRO SEM CD-ROM'} )
aAdd( aSX5, {'  ','_B','58','PULANDO PAGINAS','PULANDO PAGINAS','PULANDO PAGINAS'} )
aAdd( aSX5, {'  ','_B','59','CONTRACAPA RISCADA','CONTRACAPA RISCADA','CONTRACAPA RISCADA'} )
aAdd( aSX5, {'  ','_B','60','SEM CODIGO','SEM CODIGO','SEM CODIGO'} )
aAdd( aSX5, {'  ','_B','61','LIVRO COM ETIQUETA METALICA','LIVRO COM ETIQUETA METALICA','LIVRO COM ETIQUETA METALICA'} )
aAdd( aSX5, {'  ','_B','62','LIVRO COM DEFEITO GRAFICO','LIVRO COM DEFEITO GRAFICO','LIVRO COM DEFEITO GRAFICO'} )
aAdd( aSX5, {'  ','_B','63','CAPA DESCOLANDO','CAPA DESCOLANDO','CAPA DESCOLANDO'} )
aAdd( aSX5, {'  ','_B','64','REPETINDO PAGINAS','REPETINDO PAGINAS','REPETINDO PAGINAS'} )
aAdd( aSX5, {'  ','_B','65','LIVRO COM ETIQUETA','LIVRO COM ETIQUETA','LIVRO COM ETIQUETA'} )
aAdd( aSX5, {'  ','_B','66','CLIENTE RECEBEU APENAS O VOLUME 02','CLIENTE RECEBEU APENAS O VOLUME 02','CLIENTE RECEBEU APENAS O VOLUME 02'} )
aAdd( aSX5, {'  ','_B','67','PONTA DA CAPA RALADA','PONTA DA CAPA RALADA','PONTA DA CAPA RALADA'} )
aAdd( aSX5, {'  ','_B','68','PONTA E BORDA DA CAPA RALADA','PONTA E BORDA DA CAPA RALADA','PONTA E BORDA DA CAPA RALADA'} )
aAdd( aSX5, {'  ','_B','69','PAGINAS SUJAS','PAGINAS SUJAS','PAGINAS SUJAS'} )
aAdd( aSX5, {'  ','_B','70','PAGINAS DOBRADAS','PAGINAS DOBRADAS','PAGINAS DOBRADAS'} )
aAdd( aSX5, {'  ','_B','71','LIVRO COM DEFEITO GRAFICO','LIVRO COM DEFEITO GRAFICO','LIVRO COM DEFEITO GRAFICO'} )
aAdd( aSX5, {'  ','_B','72','LIVRO COM A LOMBADA DANIFICADA','LIVRO COM A LOMBADA DANIFICADA','LIVRO COM A LOMBADA DANIFICADA'} )
aAdd( aSX5, {'  ','_B','73','CLIENTE RECEBEU APENAS O VOLUME 1','CLIENTE RECEBEU APENAS O VOLUME 1','CLIENTE RECEBEU APENAS O VOLUME 1'} )
aAdd( aSX5, {'  ','_B','74','LIVROS COM A EDICAO ANTIGA','LIVROS COM A EDICAO ANTIGA','LIVROS COM A EDICAO ANTIGA'} )
aAdd( aSX5, {'  ','_B','75','LIVRO COM A LOMBADA RASGADA','LIVRO COM A LOMBADA RASGADA','LIVRO COM A LOMBADA RASGADA'} )
aAdd( aSX5, {'  ','_B','76','MIOLO DO LIVRO SOLTO DA CAPA','MIOLO DO LIVRO SOLTO DA CAPA','MIOLO DO LIVRO SOLTO DA CAPA'} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX5 ) )

dbSelectArea( 'SX5' )
SX5->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX5 )

	oProcess:IncRegua2( 'Atualizando tabelas...' )

	If !SX5->( dbSeek( aSX5[nI][1] + aSX5[nI][2] + aSX5[nI][3]) )
		cTexto += 'Item da tabela criado. Tabela '   + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + '/' + aSX5[nI][3] + CRLF
		RecLock( 'SX5', .T. )
	Else
		cTexto += 'Item da tabela alterado. Tabela ' + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + '/' + aSX5[nI][3] + CRLF
		RecLock( 'SX5', .F. )
	EndIf

	For nJ := 1 To Len( aSX5[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
		EndIf
	Next nJ

	MsUnLock()

	aAdd( aArqUpd, aSX5[nI][1] )

	If !( aSX5[nI][1] $ cAlias )
		cAlias += aSX5[nI][1] + '/'
	EndIf

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX5' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX5 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX1 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX1 - Perguntas     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX1   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX1( cTexto )
Local aEstrut   := {}
Local aSX1      := {}
Local aStruDic  := SX1->( dbStruct() )
Local cAlias    := ''
Local nI        := 0
Local nJ        := 0
Local nTam1     := Len( SX1->X1_GRUPO )
Local nTam2     := Len( SX1->X1_ORDEM )

cTexto  += 'Inicio Atualizacao SX1' + CRLF + CRLF

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX1 ) )

dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX1 )

	oProcess:IncRegua2( 'Atualizando perguntas...' )

	If !SX1->( dbSeek( PadR( aSX1[nI][1], nTam1 ) + PadR( aSX1[nI][2], nTam2 ) ) )
		cTexto += 'Pergunta Criada. Grupo/Ordem '   + aSX1[nI][1] + '/' + aSX1[nI][2] + CRLF
		RecLock( 'SX1', .T. )
	Else
		cTexto += 'Pergunta Alterada. Grupo/Ordem ' + aSX1[nI][1] + '/' + aSX1[nI][2] + CRLF
		RecLock( 'SX1', .F. )
	EndIf

	For nJ := 1 To Len( aSX1[nI] )
		If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
			SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aSX1[nI][nJ] ) )
		EndIf
	Next nJ

	MsUnLock()

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX1' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX1 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX9 บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX9 - Relacionament ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX9   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX9( cTexto )
Local aEstrut   := {}
Local aSX9      := {}
Local cAlias    := ''
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX9->X9_DOM )

cTexto  += 'Inicio da Atualizacao do SX9' + CRLF + CRLF

aEstrut := { 'X9_DOM'   , 'X9_IDENT'  , 'X9_CDOM'   , 'X9_EXPDOM', 'X9_EXPCDOM' ,'X9_PROPRI', ;
             'X9_LIGDOM', 'X9_LIGCDOM', 'X9_CONDSQL', 'X9_USEFIL', 'X9_ENABLE' }

cTexto += CRLF + 'Final da Atualizacao do SX9' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return aClone( aSX9 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuHlp บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao dos Helps de Campos    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuHlp   - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuHlp( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto += 'Inicio da Atualizacao ds Helps de Campos' + CRLF + CRLF


oProcess:IncRegua2(  'Atualizando Helps de Campos ...' )

//
// Helps Tabela PA2
//
aHlpPor := {}
aAdd( aHlpPor, 'Informe o numero do documento de entrada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_DOCENT', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_DOCENT' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe a serie do document de entrada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_SERIE ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_SERIE ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe o codigo do Cliente ou' )
aAdd( aHlpPor, 'Fornecedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_CLIFOR', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_CLIFOR' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe a loja do cliente ou fornecedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_LOJA  ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_LOJA  ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Registro de Ocorrencia   - seguencial' )
aAdd( aHlpPor, 'automatico' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_RO    ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_RO    ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe o ISBN do livro' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_ISBN  ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_ISBN  ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Tipo da Ocorrencia' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_TIPO  ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_TIPO  ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de produto nesta ocorrencia' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_QTD   ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_QTD   ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe observa็๕es gerais' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PPA2_OBS   ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo PA2_OBS   ' + CRLF

//
// Helps Tabela SA1
//
aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento Publico' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XDESC2 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XDESC2 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento Ex/Huma' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XDESC3 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XDESC3 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento Civ/CLT' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XDESC4 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XDESC4 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desc Segmento 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XDESC5 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XDESC5 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desc Segmento 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XDESC6 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XDESC6 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento publico' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XCOMIS2', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XCOMIS2' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento Ex/Huma' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XCOMIS3', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XCOMIS3' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comssao Sefmento Civ/CLT' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XCOMIS4', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XCOMIS4' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XCOMIS5', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XCOMIS5' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento 6' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PA1_XCOMIS6', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo A1_XCOMIS6' + CRLF

//
// Helps Tabela SB1
//
aHlpPor := {}
aAdd( aHlpPor, 'Tipo Segmento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PB1_XSEGME ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo B1_XSEGME ' + CRLF

//
// Helps Tabela SC5
//
aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento Publico' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XDESC1 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XDESC1 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento Ex/Huma' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XDESC3 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XDESC3 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento Civ/CLT' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XDESC4 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XDESC4 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XDESC5 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XDESC5 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Desconto Segmento 6' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XDESC6 ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XDESC6 ' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento Publico' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XCOMIS2', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XCOMIS2' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento Ex/Huma' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XCOMIS3', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XCOMIS3' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento Civ/CLT' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XCOMIS4', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XCOMIS4' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Seguimento 5' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XCOMIS5', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XCOMIS5' + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Comissao Segmento 6' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC5_XCOMIS6', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C5_XCOMIS6' + CRLF

//
// Helps Tabela SC6
//
aHlpPor := {}
aAdd( aHlpPor, 'Tipo Segmento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( 'PC6_XSEGME ', aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += 'Atualizado o Help do campo C6_XSEGME ' + CRLF

cTexto += CRLF + 'Final da Atualizacao dos Helps de Campos' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return {}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuHlpXบ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao dos Helps de Perguntas ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuHlpX1 - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuHlpX1( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto += 'Inicio da Atualizacao ds Helps de Perguntas' + CRLF + CRLF


oProcess:IncRegua2(  'Atualizando Helps de Perguntas ...' )

//
// Helps Perguntas
//
cTexto += CRLF + 'Final da Atualizacao dos Helps de Perguntas' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return {}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณESCEMPRESAบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para escolha de Empresa, montado pelo SM0_ บฑฑ
ฑฑบ          ณ Retorna vetor contendo as selecoes feitas.                 บฑฑ
ฑฑบ          ณ Se nao For marcada nenhuma o vetor volta vazio.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscEmpresa()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametro  nTipo                           ณ
//ณ 1  - Monta com Todas Empresas/Filiais      ณ
//ณ 2  - Monta so com Empresas                 ณ
//ณ 3  - Monta so com Filiais de uma Empresa   ณ
//ณ                                            ณ
//ณ Parametro  aMarcadas                       ณ
//ณ Vetor com Empresas/Filiais pre marcadas    ณ
//ณ                                            ณ
//ณ Parametro  cEmpSel                         ณ
//ณ Empresa que sera usada para montar selecao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   aSalvAmb := GetArea()
Local   aSalvSM0 := {}
Local   aRet     := {}
Local   aVetor   := {}
Local   oDlg     := NIL
Local   oChkMar  := NIL
Local   oLbx     := NIL
Local   oMascEmp := NIL
Local   oMascFil := NIL
Local   oButMarc := NIL
Local   oButDMar := NIL
Local   oButInv  := NIL
Local   oSay     := NIL
Local   oOk      := LoadBitmap( GetResources(), 'LBOK' )
Local   oNo      := LoadBitmap( GetResources(), 'LBNO' )
Local   lChk     := .F.
Local   lOk      := .F.
Local   lTeveMarc:= .F.
Local   cVar     := ''
Local   cNomEmp  := ''
Local   cMascEmp := '??'
Local   cMascFil := '??'

Local   aMarcadas  := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( 'SM0' )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := 'Tela para M๚ltiplas Sele็๕es de Empresas/Filiais'

oDlg:cTitle := 'Selecione a(s) Empresa(s) para Atualiza็ใo'

@ 10, 10 Listbox  oLbx Var  cVar Fields Header ' ', ' ', 'Empresa' Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt 'Todos'   Message 'Marca / Desmarca Todos' Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Inverter Sele็ใo' Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt 'Empresa' Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture '@!'  Valid (  cMascEmp := StrTran( cMascEmp, ' ', '?' ), cMascFil := StrTran( cMascFil, ' ', '?' ), oMascEmp:Refresh(), .T. ) ;
Message 'Mแscara Empresa ( ?? )'  Of oDlg
@ 123, 50 Button oButMarc Prompt '&Marcar'    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Marcar usando mแscara ( ?? )'    Of oDlg
@ 123, 80 Button oButDMar Prompt '&Desmarcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Desmarcar usando mแscara ( ?? )' Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop 'Confirma a Sele็ใo'  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop 'Abandona a Sele็ใo' Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( 'SM0' )
dbCloseArea()

Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCATODOSบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para marcar/desmarcar todos os itens do    บฑฑ
ฑฑบ          ณ ListBox ativo                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณINVSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para inverter selecao do ListBox Ativo     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRETSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar que monta o retorno com as selecoes        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MARCAMAS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para marcar/desmarcar usando mascaras               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == '?' .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == '?' .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] :=  lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERTODOS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para verificar se estao todos marcardos    บฑฑ
ฑฑบ          ณ ou nao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MyOpenSM0บ Autor ณ TOTVS Protheus     บ Data ณ  28/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.5.2 EFS        ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MyOpenSM0(lShared)

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , 'SIGAMAT.EMP', 'SM0', lShared, .F. )

	If !Empty( Select( 'SM0' ) )
		lOpen := .T.
		dbSetIndex( 'SIGAMAT.IND' )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	MsgStop( 'Nใo foi possํvel a abertura da tabela ' + ;
	IIf( lShared, 'de empresas (SM0).', 'de empresas (SM0) de forma exclusiva.' ), 'ATENวรO' )
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
