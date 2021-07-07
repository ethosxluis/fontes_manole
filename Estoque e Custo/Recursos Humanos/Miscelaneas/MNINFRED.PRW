#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNINFRED  บAutor  ณLeandro Duarte      บ Data ณ  02/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para disparar o informe de rendimento buscando de umaบฑฑ
ฑฑบ          ณpasta no servidor os arquivos em pdf com o nome de cada por บฑฑ
ฑฑบ          ณCPF                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION MNINFRED()
Local cLoc			:= ""
Local nRetorno		:= 0
Local cDesc			:= "LOCAL NO SERVIDOR QUE ESTARA OS ARQUIVOS PDF DO INFORME DE RENDIMENTO DOS USUARIOS OS ARQUIVOS SERAO EM PDF COM O NOME DE CPF DE CADA USUARIO"
Local cCnt			:= "/informe_de_rendimento/"
Local cParam		:= "LOC_INFRED"
Local aDir			:= {}
Local oButton1
Local oButton2
Local oCheckBo1
Local lCheckBo1 := .F.
Local oFont1 := TFont():New("Times New Roman",,024,,.T.,,,,,.F.,.F.)
Local oSay1
Static oDlg
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Private oWBrowse1
Private aDados := {}
Private xErro	:= ""

If !ExisteSX6(cParam)
	CriarSX6(cParam,"C",cDesc,cCnt)
Endif
cLoc			:= getnewpar("LOC_INFRED","/informe_de_rendimento")

if !empty(cLoc)
	nRetorno		:= MAKEDIR(cLoc)
	aDir			:= DIRECTORY(cLoc+'/*.pdf', "D", nil,.T., 1 )
endif
nTipPesq := Aviso("Pesquisa","Aten็ใo voce deseja que a rotina busque os dados em qual cadastro?",{"Funcionario","Fornecedor","Todos"},3)


for nFor := 1 to len(aDir)
	SRA->(DBSETORDER(3))
	SA2->(DBSETORDER(2))
	if aDir[nFor][5] == 'A'
		cNome := upper(replace(replace(replace(replace(replace(UPPER(alltrim(aDir[nFor][1])),'.',''),'-',''),'PDF',''),'/',''),'\',''))
//		cNome := upper(replace(replace(replace(replace(replace(UPPER(alltrim(aDir[nFor][1])),'.',''),'-',''),'pdf',''),'/',''),'\',''))
		IF SRA->(DBSEEK(xFilial("SRA")+substr(cNome,1,25))) .and. (nTipPesq	== 1 .or. nTipPesq	== 3 )
			aadd(aDados,{.f.,SRA->RA_MAT, SRA->RA_NOME, SRA->RA_EMAIL,alltrim(aDir[nFor][1]) })
		elseIF  SA2->(DBSEEK(xFilial("SA2")+substr(cNome,1,25))) .and. (nTipPesq	== 2 .or. nTipPesq	== 3 )
			aadd(aDados,{.f.,SA2->A2_COD, SA2->A2_NOME, SA2->A2_EMAIL,alltrim(aDir[nFor][1]) })
		else
			SRA->(DBSETORDER(5))
			SA2->(DBSETORDER(3))
			IF SRA->(DBSEEK(xFilial("SRA")+cNome)).and. (nTipPesq	== 1 .or. nTipPesq	== 3 )
				aadd(aDados,{.f.,SRA->RA_MAT, SRA->RA_NOME, SRA->RA_EMAIL,alltrim(aDir[nFor][1]) })
			elseIF  SA2->(DBSEEK(xFilial("SA2")+cNome)) .and. (nTipPesq	== 2 .or. nTipPesq	== 3 )
				aadd(aDados,{.f.,SA2->A2_COD, SA2->A2_NOME, SA2->A2_EMAIL,alltrim(aDir[nFor][1]) })
			ENDIF
		ENDIF
	ENDIF
next nFor
asort(aDados,,,{|z,y| z[3] < y[3]})
if len(aDados) > 0
 DEFINE MSDIALOG oDlg TITLE "Lista de Disparo de e-mail" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

    @ 017, 114 SAY oSay1 PROMPT "Sele็ใo de Disparo dos informe de Rendimento" SIZE 218, 016 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    fWBrowse1()
    @ 228, 009 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Marcar/ Desmarcar" SIZE 103, 008 OF oDlg COLORS 0, 16777215  ON CHANGE todos() PIXEL
    @ 227, 175 BUTTON oButton1 PROMPT "Enviar" SIZE 037, 012 OF oDlg PIXEL action(Processa({|| rotEnv(aDados)},"Aguarde","Enviando E-mail"),oDlg:end())
    @ 227, 229 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL action(oDlg:end())

  ACTIVATE MSDIALOG oDlg CENTERED
else
	aviso("Aten็ใo","Nใo houve nenhuma amarra็ใo com os arquivos localizados na Pasta "+cLoc+" Com os dados dos funcionarios existentes",{"Ok"})
endif
RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNINFRED  บAutor  ณMicrosiga           บ Data ณ  02/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fWBrowse1()

	if len(aDados)<=0
	    // Insert items here
	    Aadd(aDados,{.F.," "," "," "})
    endif

    @ 036, 008 LISTBOX oWBrowse1 Fields HEADER " ","Matricula/Codigo","Nome","Email" SIZE 429, 184 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aDados)
    oWBrowse1:bLine := {|| {;
      If(aDados[oWBrowse1:nAT,1],oOk,oNo),;
      aDados[oWBrowse1:nAt,2],;
      aDados[oWBrowse1:nAt,3],;
      aDados[oWBrowse1:nAt,4];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aDados[oWBrowse1:nAt,1] := !aDados[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNINFRED  บAutor  ณMicrosiga           บ Data ณ  02/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function todos()
Local nTT	:= 0
aeval(aDados,{|z| (nTT++,z[1] := !z[1]) })
oWBrowse1:refresh()
oDlg:refresh()
alert("Total Selecionado foi: "+cvaltochar(nTT))
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณrotEnv    บAutor  ณLeandro Duarte      บ Data ณ  02/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para o envio de e-mail somente dos itens selecionadosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function rotEnv(aDados)
Local cMsg 		:= ""
Local cAssunto 	:= ""
Private cArqTxt := "/informe_de_rendimento/log_"+dtos(date())+".txt"
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"
Private aVolta := {}
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif


ProcRegua(len(aDados)*2)
For nFor := 1 to len(aDados)
//	cMsg := "Ola "+aDados[nFor][3]+"<br>Voc๊ esta recebendo o informe de rendimento sobre seus servi็os prestados para a empresa<br>Manole<br><br>Obs nใo responder esse e-mail<br>"
	cMsg := "Ola "+aDados[nFor][3]+"<br>Segue informe de rendimentos da Editora Manole referente ao ano de 2020.<br>Obs nใo responder esse e-mail<br>"
	cAssunto := "Informe de Rendimento"
	IncProc("Proc. a Pessoa: " + aDados[nFor][3] )
	if aDados[nFor][1]
		xErro	:= ""
		cNomeArq := aDados[nFor][5]
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEnviar o Boletoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//aDados[nFor][4] := iif(empty(aDados[nFor][4]),aDados[nFor][4],aDados[nFor][4]+";bianca@manole.com.br")
		aDados[nFor][4] := iif(empty(aDados[nFor][4]),aDados[nFor][4],aDados[nFor][4]+";roberta.lima@manole.com.br;direitosautorais@manole.com.br")
	//	u_ENVMAIL(aDados[nFor][4], '/informe_de_rendimento/'+alltrim(cNomeArq)+';',cAssunto,cMsg,'INFORME',@xErro,.F.,';roberta.lima@manole.com.br;direitosautorais@manole.com.br')

		lRetMail := .T.
		lRetMail := U_FSENVMAIL(cAssunto, cMsg, aDados[nFor][4],LOWER('/informe_de_rendimento/'+alltrim(cNomeArq)),"informe@manole.com.br","informe@manole.com.br","smtp.gmail.com","manole1969",.T.,.T.,.T.,,"luis.balestrero@ethosx.com")
	
//		U_FSENVMAIL(cAssunto, cBody, cEmail,cAttach,cMailConta,cUsuario,cMailServer,cMailSenha,lMailAuth,lUseSSL,lUseTLS,cCopia,cCopiaOculta)
	

//		u_ENVMAIL(aDados[nFor][4], '',cAssunto,cMsg,'INFORME',@xErro,.F.,';roberta.lima@manole.com.br;direitosautorais@manole.com.br')
//		if alltrim(xErro) != "E-mail Disparado Com sucesso"
		if !lRetmail
//			u_ENVMAIL(aDados[nFor][4], '/informe_de_rendimento/'+alltrim(cNomeArq)+';',cAssunto,cMsg,'INFORME',@xErro,.F.,'roberta.lima@manole.com.br;direitosautorais@manole.com.br')
			lRetMail := U_FSENVMAIL(cAssunto, cMsg, aDados[nFor][4],LOWER('/informe_de_rendimento/'+alltrim(cNomeArq)),"informe@manole.com.br","informe@manole.com.br","smtp.gmail.com","manole1969",.T.,.T.,.T.,,)
//			if alltrim(xErro) != "E-mail Disparado Com sucesso"
//				u_ENVMAIL(aDados[nFor][4], '/informe_de_rendimento/'+alltrim(cNomeArq)+';',cAssunto,cMsg,'INFORME',@xErro,.F.,'roberta.lima@manole.com.br;direitosautorais@manole.com.br')
		endif
		if !lRetmail
			U_FSENVMAIL(cAssunto, cMsg, aDados[nFor][4],LOWER('/informe_de_rendimento/'+alltrim(cNomeArq)),"informe@manole.com.br","informe@manole.com.br","smtp.gmail.com","manole1969",.T.,.T.,.T.,,)
		endif
		cLin	:= "Log do Registro "+padr(aDados[nFor][2],20)+" Nome: "+padr(aDados[nFor][3],30)+" Email: "+aDados[nFor][4]+" -- "+xErro+cEOL
		fWrite(nHdl,cLin,Len(cLin))
//		if alltrim(xErro) != "E-mail Disparado Com sucesso"
		if !lRetmail
			aadd(aVolta,aDados[nFor])
		elseif  !empty(aDados[nFor][4])
			__CopyFile('/informe_de_rendimento/'+cNomeArq,'/informe_de_rendimento/ok_'+cNomeArq)
			ferase('/informe_de_rendimento/'+cNomeArq)
		endif
	endif
Next nFor
For nFor := 1 to len(aVolta)
//	cMsg := "Ola "+aVolta[nFor][3]+"<br>Voc๊ esta recebendo o informe de rendimento sobre seus servi็os prestados para a empresa<br>Manole<br><br>Obs nใo responder esse e-mail<br>"
	cMsg := "Ola "+aVolta[nFor][3]+"<br>Segue informe de rendimentos da Editora Manole referente ao ano de 2020.<br>Obs nใo responder esse e-mail
	cAssunto := "Informe de Rendimento"
	IncProc("Proc. a Pessoa: " + aVolta[nFor][3] )
	if aVolta[nFor][1]
		xErro	:= ""
		cNomeArq := aVolta[nFor][5]
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEnviar o Boletoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		u_ENVMAIL(aDados[nFor][4], '/informe_de_rendimento/'+alltrim(cNomeArq)+';',cAssunto,cMsg,'INFORME',@xErro,.F.,'roberta.lima@manole.com.br;direitosautorais@manole.com.br')
//		if alltrim(xErro) != "E-mail Disparado Com sucesso"
		if !lRetmail
//			u_ENVMAIL(aDados[nFor][4], '/informe_de_rendimento/'+alltrim(cNomeArq)+';',cAssunto,cMsg,'INFORME',@xErro,.F.,'roberta.lima@manole.com.br;direitosautorais@manole.com.br')
			U_FSENVMAIL(cAssunto, cMsg, aDados[nFor][4],LOWER('/informe_de_rendimento/'+alltrim(cNomeArq)),"informe@manole.com.br","informe@manole.com.br","smtp.gmail.com","manole1969",.T.,.T.,.T.,,)
//			if alltrim(xErro) != "E-mail Disparado Com sucesso"
		if !lRetmail
//			u_ENVMAIL(aDados[nFor][4], '/informe_de_rendimento/'+alltrim(cNomeArq)+';',cAssunto,cMsg,'INFORME',@xErro,.F.,'roberta.lima@manole.com.br;direitosautorais@manole.com.br')
			U_FSENVMAIL(cAssunto, cMsg, aDados[nFor][4],LOWER('/informe_de_rendimento/'+alltrim(cNomeArq)),"informe@manole.com.br","informe@manole.com.br","smtp.gmail.com","manole1969",.T.,.T.,.T.,,)
			endif
		endif
		cLin	:= "Log2 do Registro "+padr(aVolta[nFor][2],20)+" Nome: "+padr(aVolta[nFor][3],30)+" Email: "+aVolta[nFor][4]+" -- "+xErro+cEOL
		fWrite(nHdl,cLin,Len(cLin))
//		if alltrim(xErro) == "E-mail Disparado Com sucesso" .and. !empty(aDados[nFor][4])
		if lRetmail .and. !empty(aDados[nFor][4])
			__CopyFile('/informe_de_rendimento/'+cNomeArq,'/informe_de_rendimento/ok_'+cNomeArq)
			ferase('/informe_de_rendimento/'+cNomeArq)
		endif
	endif
Next nFor
fClose(nHdl)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEmailEnv  บAutor  ณLeandro Duarte      บ Data ณ  02/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para o processamento e envio do e-mail               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function ENVMAIL(cEmailCC,cArq,cAssunto,cMsg,cConta )
Local lResulConn := .T.
Local lResulSend := .T.
Local lResult := .T.
Local cError := ""
Local cCc := ""
Local cBcc := ""
Local cAnexo1 := ""
Local cAnexo2 := ""
Local cEmail	:= ""
Local cPass		:= ""


WF7->(DBSETORDER(1))
WF7->(dbgotop())
WF7->(DBSEEK(XFILIAL("WF7")+cConta))

cEmail	:= AllTrim(WF7->WF7_AUTUSU)
cPass	:= AllTrim(WF7->WF7_AUTSEN)

oMail := TMailManager():New()
oMail:SetUseSSL(.T.)
//oMail:SetUseTLS(.T.)
oMail:Init( ALLTRIM(WF7->WF7_POP3SR), AllTrim(WF7->WF7_SMTPSR) , AllTrim(WF7->WF7_AUTUSU), AllTrim(WF7->WF7_AUTSEN), WF7->WF7_POP3PR ,WF7->WF7_SMTPPR )
oMail:SetSmtpTimeOut( WF7->WF7_TEMPO )
conout('Conectando do SMTP')

nErro := oMail:SmtpConnect()
if nErro <> 0
	conout("ERROR:" + oMail:GetErrorString(nErro))
	//alert("ERROR:" + oMail:GetErrorString(nErro))
	cErro := "ERROR: Nใo conseguiu conectar no e-mail para disparo " + oMail:GetErrorString(nErro)
	oMail:SMTPDisconnect()
	return cErro
Endif

nErro := oMail:SmtpAuth(cEmail ,cPass)
If nErro <> 0
	conout("ERROR:" + oMail:GetErrorString(nErro))
	//alert("ERROR:" + oMail:GetErrorString(nErro))
	cErro := "ERROR: Nใo conseguiu autenticar no servidor SMTP " + oMail:GetErrorString(nErro)
	oMail:SMTPDisconnect()
	return cErro
Endif
cPara := cEmailCC
nVolta:= 0
while at(';',cPara)>0
	nVolta+= 1
	setprvt("cPara"+cvaltochar(nVolta))
	&("cPara"+cvaltochar(nVolta)) := substr(cPara,1,at(';',cPara)-1)
	cPara := substr(cPara,at(';',cPara)+1)
end
if at('@',cPara)>0
	nVolta+= 1
	setprvt("cPara"+cvaltochar(nVolta))
	&("cPara"+cvaltochar(nVolta)) := alltrim(cPara)
endif
cAnexo1 := cArq
For nForq := 1 to nVolta
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnvia o Emailณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if empty(&("cPara"+cvaltochar(nForq)))
		cErro := "ERROR: Email nใo Cadastrado "
		oMail:SMTPDisconnect()
		return cErro
	endif
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom 			:= cEmail
	oMessage:cTo	 		:= &("cPara"+cvaltochar(nForq))
	oMessage:cBcc 			:= ""
	oMessage:cCc 			:= IIF(EMPTY(cPara),"","")
	oMessage:cSubject 		:= IIF(EMPTY(cPara),'Boleto '+cAssunto,cAssunto)
	oMessage:cBody 			:= cMsg+"<br><img src='cid:manole.jpg'>"


	//Adiciona um attach
	If oMessage:AttachFile(cAnexo1) < 0
		Conout( "Erro ao atachar o arquivo" )
	Else                     		//adiciona uma tag informando que ้ um attach e o nome do arq
		oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cArq)
	EndIf
	oMessage:AttachFile( '\system\manole.jpg' )
	oMessage:AddAttHTag( 'Content-ID: <manole.jpg>' )

	nErro := oMessage:Send( oMail )
	if nErro <> 0
		conout("ERROR:" + oMail:GetErrorString(nErro))
		cErro := "ERROR: O disparo do e-mail nใo foi realizado com sucesso " + oMail:GetErrorString(nErro)
		oMail:SMTPDisconnect()
		return cErro
	ELSE
		lResulSend := .t.
	Endif
next nForq

//FERASE(cAnexo1)
//DISCONNECT SMTP SERVER
conout('Desconectando do SMTP')
cErro := "E-mail Disparado Com sucesso"
oMail:SMTPDisconnect()

return(cErro)*/
