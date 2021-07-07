#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDef.ch"

/*/DAMANX01
//Programa para geração de novos cadastros de produtos e contratos de DA.
@author LUIS
@since 25/09/2019
@version 1.0
@return Programa que gerna novos códigos a partir de códigos já existentes com o sufixo do parceiro digital.


@type function
/*/

User Function DAMANX01()

Private oMarkB1 := Nil  
Private oMarkP02 := Nil
Private oDlgMrk
Private aStruSB1 	:= SB1->(dbStruct())
Private aStruP02 	:= P02->(dbStruct())
Private aStruAH1 	:= AH1->(dbStruct())
Private aStruAH2 	:= AH2->(dbStruct())
Private aStruAH8 	:= AH8->(dbStruct())
Private _numcta     := 0
Private cDescPro    := ''
Private _pdto       := ''
Private cSufx      := ""
Private cData      := dDataBase
Private aVetorUser 	:= Pswret(1,1,4)[1][4]



Pergunte("DAMANX01",.T.)

Processa({|| SELPROD()},"Selecionando produtos aguarde...")

RETURN()

static function SELPROD()

P02->(DBSETORDER(1))
     While P02->(!eof())
        
         cSufx += "'" + P02->P02_SUFX+"',"  

        P02->(dbskip())

     enddo
     //cSufx := "'"+cSufx+"'"   
     cSufx := substr(cSufx,1,len(cSufx) -1)



cquery := " "
cquery := " select SB1.B1_OK,SB1.B1_COD,SB1.B1_DESC,SB1.B1_FILIAL "
cquery += " from "+retsqlname("SB1")+ " SB1 ,"+retsqlname("AH1") + ("  AH1")
cquery += " where SB1.B1_COD = AH1.AH1_PRODUT "
cquery += " and SB1.B1_FILIAL = AH1.AH1_FILIAL "
//cquery += " and SUBSTRING(B1_COD,(LEN(B1_COD) -2),3) NOT IN("+cSufx+")"
//cquery += " and SUBSTRING(B1_COD,(LENGTH(B1_COD) -2),3) NOT IN("+cSufx+")"
cquery += " and SB1.B1_COD >= '"+MV_PAR01+"' AND B1_COD <= '"+MV_PAR02+"'"
cquery += " AND SB1.B1_GRUPO >= '"+MV_PAR03+"' AND B1_GRUPO <='"+MV_PAR04+"'"
//cquery += " AND SB1.B1_MSBLQL <> '1'"

//Edmar Mendes do Prado
cquery += " AND (SB1.B1_COD NOT LIKE '%IFD%' AND SB1.B1_COD NOT LIKE '%MIB%' AND SB1.B1_COD NOT LIKE '%AMZ%')  " 

cquery += " AND SB1.D_E_L_E_T_ = ' ' AND AH1.D_E_L_E_T_ = ' ' "
cquery += " GROUP BY SB1.B1_OK,SB1.B1_COD,SB1.B1_DESC,SB1.B1_FILIAL " 
cquery += " ORDER BY SB1.B1_COD "

cQuery := ChangeQuery(cQuery)    

//Edmar Mendes do Prado
memowrite("DAMANX01.TXT",cQuery)

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TMP", .F., .F.)
	TMP->(dbGoTop())



	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	aStru := {}       
	AADD(aStru,{"TR_FILIAL"		    ,"C",TAMSX3("B1_FILIAL")[1]	    ,0	,""})
	AADD(aStru,{"TR_OK"			    ,"C",TAMSX3("B1_OK")[1]	    ,0	,""})
	AADD(aStru,{"TR_COD"			,"C",TAMSX3("B1_COD")[1]	,0	,""})
	AADD(aStru,{"TR_DESC"			,"C",TAMSX3("B1_DESC")[1]	,0	,""})


	cArqTrab := CriaTrab(aStru, .T.)

	USE &cArqTrab ALIAS TRB NEW  


	DbSelectArea("TMP")
	dbgotop()

	While ! TMP ->(EOF())        
		RECLOCK("TRB",.T.) 
		TRB->TR_FILIAL          := TMP->B1_FILIAL    
        TRB->TR_OK              := TMP->B1_OK
		TRB->TR_COD 			:= TMP->B1_COD 
		TRB->TR_DESC 			:= TMP->B1_DESC

		MsUnlock() 
		DbSelectArea("TMP")
		TMP->(DBSKIP())
	EndDo                      


//	Local aCampos := {}
	Private aColumns := {}
	Private oBrowse 	:= Nil
	Private cFiltro	:= ""




	oMarkB1:=FWMarkBrowse():New()
	oMarkB1:SetDescription('Selecione os produtos')
	oMarkB1:SetAlias('TRB')


	aCampos:={	{"TR_COD" 		,"Codigo		" 	},;
				{"TR_DESC" 		,"Descrição		" 	}}




	For nQ := 1 To Len(aCampos)
		AAdd(aColumns, FWBrwColumn():New())
		aColumns[Len(aColumns)]:SetData(&("{||" + aCampos[nQ][1] + "}"))
		aColumns[Len(aColumns)]:SetTitle(aCampos[nQ][2])
	Next
	oMarkB1:SetColumns(aColumns)
	oMarkB1:SetFieldMark("TR_OK")
    oMarkB1:AddButton("Confirma","U_CONFMARK",,4,)



	oMarkB1:Activate()




Return(Nil)

Static Function MenuDef()
Local aRotina := {}

//ADD OPTION aRotina TITLE 'Conferir Marcacao' ACTION 'U_CONFMARK()' OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Conferir 2' ACTION 'U_GRAVA()' OPERATION 2 ACCESS 0



Return(aRotina)

Static Function ModelDef()
Return(FWLoadModel("DAMANX01"))

User Function CONFMARK()

Local aProds    := {}
//Local aStruSB1 	:= SB1->(dbStruct())


  	aArqTrb  := {}

  	FOR nx := 1 to len(aStruSB1)


//  		if x3obrigat(aStruSB1[nx][1])
  		
  			AADD(aArqTrb,{aStruSB1[nx][1],aStruSB1[nx][2],aStruSB1[nx][3],aStruSB1[nx][4]})
         
//         endif

  	NEXT

  	If Select("TR2") > 0
		TR2->(dbCloseArea())
	EndIf
  	
  	

     cArqTrb  :=   CriaTrab(aArqTrb, .T.)
     dbUseArea(.T.,,cArqTrb,"TR2",.F.)

n := 0

//SB1->(dbGoTop())
//While SB1->(!Eof())


TRB->(dbGoTop())
While TRB->(!Eof())
	If oMark:IsMark(oMarkB1:Mark())

	
	  TR2->(DBGOTOP())
				reclock("TR2",.T.)
						TR2->B1_FILIAL := TRB->TR_FILIAL
						TR2->B1_COD    := TRB->TR_COD
				msunlock()
	EndIf
  
//	SB1->(dbSkip())
	TRB->(dbSkip())
EndDo

SB1->(DBSETORDER(1))
TR2->(DBGOTOP())

While TR2->(!eof())
  IF SB1->(DBSEEK(xFilial() + TR2->B1_COD))
     
				reclock("TR2",.F.)
				 
				   FOR n:= 1 to len(aStruSB1)
					  _campo  := "TR2->" + aStruSB1[n][1]
					  _campo2 := "SB1->" + aStruSB1[n][1]
					
					    &(_campo) := &(_campo2)

				   NEXT

				msunlock()
  
  ENDIF
  TR2->(DBSKIP())
ENDDO


oMarkP02 := FWMarkBrowse():New()
oMarkP02:SetAlias("P02")
oMarkP02:SetSemaphore(.T.)
oMarkP02:SetDescription("Selecione os parceiros que vão gerar os novos códigos e contratos")
oMarkP02:SetFieldMark("P02_OK")

oMarkP02:AllMark()
oMarkP02:SetOwner(oDlgMrk)
oMarkP02:AddButton("Confirma","U_GRAVA",,4,)

oMarkP02:Activate()


//oMarkP02:Destroy()


RETURN()


//ALIMENTAR A TABELA TR3 EQUVALENTE A P02
USER FUNCTION GRAVA()

//Local aStruP02 	:= P02->(dbStruct())


     bArqTrb  := {}


     FOR nx := 1 to len(aStruP02)
     	AADD(bArqTrb,{aStruP02[nx][1],aStruP02[nx][2],aStruP02[nx][3],aStruP02[nx][4]})
     NEXT

	If Select("TR3") > 0
		TR3->(dbCloseArea())
	EndIf

     dArqTrb  :=   CriaTrab(bArqTrb, .T.)
     dbUseArea(.T.,,dArqTrb,"TR3",.F.)



n := 0

P02->(dbGoTop())
While P02->(!Eof())
	If oMark:IsMark(oMarkP02:Mark())
//		Alert("Item Marcado !!!")

	TR3->(DBGOTOP())
			
				reclock("TR3",.T.)
				 
				 FOR n:= 1 to len(aStruP02)
					_campo  := "TR3->" + aStruP02[n][1]
					_campo2 := "P02->" + aStruP02[n][1]

					    &(_campo) := &(_campo2)

				 NEXT

				msunlock()

	EndIf
  
	P02->(dbSkip())

EndDo


TR3->(DBGOTOP())

///////////////////////
/*
   While TR3->(!Eof())
    TR2->(DBGOTOP())
     	while TR2->(!Eof())	

				  FOR n:= 1 to len( aStruSB1)
				      	_campo2 := aStruSB1[n][1]
				        _campo  := "TR2->" + aStruSB1[n][1]
				      
				    	
				     if _campo2 == 'B1_COD'
				    		_pdto := alltrim(&(_campo))+TR3->P02_SUFX
				    		SB1->(DBSETORDER(1))
 				    		if SB1->(dbseek(xFilial() + _pdto))
				    		  msgalert("Produto:   "+_pdto+ "   já existe" )

				    		  oMarkP02:GetOwner():End()
				    		  oMarkB1:GetOwner():End()
				    		  return()
 				    		endif
				     endif		



				  NEXT  		

   	    TR2->(dbSkip())	
   	    ENDDO
///////////////gravacao com reclock
   
   TR3->(dbSkip())
   enddo
*/
TR3->(DBGOTOP())
SB1->(DBSETORDER(1))


   While TR3->(!Eof())
   	TR2->(DBGOTOP())
     	while TR2->(!Eof())	
		

//   		if SB1->(!dbseek(xFilial() + _pdto))				    
   		if SB1->(!dbseek(xFilial() + (ALLTRIM(TR2->B1_COD) + TR3->P02_SUFX)))
				reclock("SB1",.T.)
				  FOR n:= 1 to len( aStruSB1)
				      	_campo2 := aStruSB1[n][1]
				        _campo  := "TR2->" + aStruSB1[n][1]
				      
				    	
				     if _campo2 == 'B1_COD'
				    		_pdto := alltrim(&(_campo))+TR3->P02_SUFX
				       	   &(_campo2) := _pdto
				     else
				    	    &(_campo2) := &(_campo)
				     endif				    	   
				  NEXT
				    
			    msunlock()
        endif			    
			 cLog := "Produto incluído com sucesso - SB1- (DAMANX01): " + SB1->B1_COD + dtoc(cData) +" " + time() + " "+ "- Incluído por: " +ALLTRIM(aVetorUser)
			_Log(cLog)			    
			_pdto := (ALLTRIM(TR2->B1_COD) + TR3->P02_SUFX)

				
				Processa({|| GRAVA_CONTRATO(_pdto)},"Gravando Contratos...")
				Processa({|| GRAVA_MASTER(_pdto)},"Gravando Produto Master...")



			
   	    TR2->(dbSkip())	
   	    ENDDO
   
   TR3->(dbSkip())
   enddo


oMarkP02:GetOwner():End()
oMarkB1:GetOwner():End()

Return(Nil)
//////////////até aqui


static function GRAVA_CONTRATO(_pdto)

     eArqTrb  := {}

     FOR nx := 1 to len(aStruAH1)
     	AADD(eArqTrb,{aStruAH1[nx][1],aStruAH1[nx][2],aStruAH1[nx][3],aStruAH1[nx][4]})
     NEXT

	If Select("TR4") > 0
		TR4->(dbCloseArea())
	EndIf

     gArqTrb  :=   CriaTrab(eArqTrb, .T.)
     dbUseArea(.T.,,gArqTrb,"TR4",.F.)

//////////////////////////////////////////////////////////////////////////////////////////
     fArqTrb  := {}


     FOR nx := 1 to len(aStruAH2)
     	AADD(fArqTrb,{aStruAH2[nx][1],aStruAH2[nx][2],aStruAH2[nx][3],aStruAH2[nx][4]})
     NEXT

	If Select("TR5") > 0
		TR5->(dbCloseArea())
	EndIf

     hArqTrb  :=   CriaTrab(fArqTrb, .T.)
     dbUseArea(.T.,,hArqTrb,"TR5",.F.)
///////////////////////////////////////////////////////////////////////////////////////////
     iArqTrb  := {}


     FOR nx := 1 to len(aStruAH8)
     	AADD(iArqTrb,{aStruAH8[nx][1],aStruAH8[nx][2],aStruAH8[nx][3],aStruAH8[nx][4]})
     NEXT

	If Select("TR6") > 0
		TR6->(dbCloseArea())
	EndIf

     jArqTrb  :=   CriaTrab(iArqTrb, .T.)
     dbUseArea(.T.,,jArqTrb,"TR6",.F.)


///////////////////////////////////////////////////////////////////////////////////////////
// GRAVAÇÃO DA TABELA TR4(temporária) que vai gravar na AH1
AH1->(DBSETORDER(1))

IF AH1->(DBSEEK(xFilial() + SUBSTR(_pdto,1,LEN(_PDTO)-3)))
   cFornec := ''
        While AH1->(!eof()) .and. (SUBSTR(_pdto,1,LEN(_PDTO)-3) == alltrim(AH1->AH1_PRODUT) .AND. AH1->AH1_FORNEC + AH1->AH1_LOJAFO <> cFornec) 

				reclock("TR4",.T.)				      

				  FOR n:= 1 to len( aStruAH1)
				      	_campo2 := "TR4->" + aStruAH1[n][1]
				        _campo  := "AH1->" + aStruAH1[n][1]
				        
				    	
				     if (_campo2 == 'TR4->AH1_PRODUT' .OR. _campo2 == 'TR4->AH1_MASTER') 
//				    		_pdto := alltrim(&(_campo))+TR3->P02_SUFX
				       	   &(_campo2) := _pdto
				     else
				    	    &(_campo2) := &(_campo)
				     endif				    	   
				  NEXT

			    msunlock()
			       cFornec := AH1->AH1_FORNEC + AH1->AH1_LOJAFO

			    AH1->(DBSKIP())
		Enddo

ENDIF

TR4->(DBSETORDER())
AH1->(DBSETORDER(1))
TR4->(DBGOTOP())

	 While TR4->(!eof())

   		_numcta  := getsx8num('AH1','AH1_CONTRA')
   		
    		IF AH1->(!DBSEEK(TR4->AH1_FILIAL + TR4->AH1_PRODUT + TR4->AH1_FORNEC + TR4->AH1_LOJAFO))
    			//_numcta  := getsx8num('AH1','AH1_CONTRA')
				reclock("AH1",.T.)				      

				  FOR n:= 1 to len( aStruAH1)
				      	_campo2 :=  aStruAH1[n][1]
				        _campo  := "TR4->" + aStruAH1[n][1]
				    	
				      if _campo2 == "AH1_CONTRA"
				         &(_campo2) := _numcta
				      elseif _campo2 == "AH1_QTDEVD"
				    	    &(_campo2) := 0
				      else
				    	    &(_campo2) := &(_campo)
				      endif
				  
				  NEXT

			    msunlock()
			    
			    ConfirmSX8()
	    	ENDIF
	         cLog := "Contrato incluído com sucesso(AH1): " + AH1->AH1_CONTRA +" PRODUTO "+ AH1->AH1_PRODUT +" FORNECEDOR " +AH1->AH1_FORNECE +"  "+dtoc(cData) +" " + time()+ " "+ "- Incluído por: " +ALLTRIM(aVetorUser)
			_Log(cLog)			    
	    
			    
		TR4->(DBSKIP())
      ENDDO

//////////////////////////////////////////////////////
//GRAVAÇÃO NA TABELA TR5(temporária que vai gravar na AH2)

AH2->(DBSETORDER(1))

IF AH2->(DBSEEK(xFilial() + SUBSTR(_pdto,1,LEN(_PDTO)-3)))

cFornec := ""

           While AH2->(!eof()) .and. (SUBSTR(_pdto,1,LEN(_PDTO)-3) == alltrim(AH2->AH2_PRODUT) .AND. AH2->AH2_FORNEC + AH2->AH2_LOJAFO <> cFornec)

				reclock("TR5",.T.)				      

				  FOR n:= 1 to len( aStruAH2)
				      	_campo2 := "TR5->" + aStruAH2[n][1]
				        _campo  := "AH2->" + aStruAH2[n][1]
				        
				    	
				     if _campo2 == 'TR5->AH2_PRODUT'
				       	   &(_campo2) := _pdto
				     else
				    	    &(_campo2) := &(_campo)
				     endif				    	   
				  NEXT

			    msunlock()

			    AH2->(DBSKIP())
		Enddo

ENDIF

AH1->(DBSETORDER(1))
TR5->(DBSETORDER())
AH2->(DBSETORDER(1))
TR5->(DBGOTOP())

	 While TR5->(!eof())
	 	if AH1->(DBSEEK(xFilial()+ TR5->AH2_PRODUT + TR5->AH2_FORNEC + TR5->AH2_LOJAFO))
            
            _numcta := AH1->AH1_CONTRA
        
        endif
        
             IF AH2->(!DBSEEK(TR5->AH2_FILIAL + TR5->AH2_PRODUT + TR5->AH2_FORNEC + TR5->AH2_LOJAFO + TR5->AH2_ITEM))     
				reclock("AH2",.T.)				      

				  FOR n:= 1 to len( aStruAH2)
				      	_campo2 :=  aStruAH2[n][1]
				        _campo  := "TR5->" + aStruAH2[n][1]
				        
				    	
				      if _campo2 == "AH2_CONTRA"
				         &(_campo2) := _numcta
				      else
				    	    &(_campo2) := &(_campo)
				      endif
				  
				  NEXT

			    msunlock()
			 ENDIF
	              cLog := "Contrato incluído com sucesso(AH2): " + AH2->AH2_CONTRA +" PRODUTO "+ AH2->AH2_PRODUT +" FORNECEDOR " +AH2->AH2_FORNECE +"  "+dtoc(cData) +" " + time()+ " "+ "- Incluído por: " +ALLTRIM(aVetorUser)			    
	              _Log(cLog)			    
			    

		TR5->(DBSKIP())
      ENDDO

return()


static function GRAVA_MASTER(_pdto)
AH8->(DBSETORDER(1))
SB1->(DBSETORDER(1))
  if SB1->(dbseek(xFilial() + _pdto))
     
     cDescPro = SB1->B1_DESC
     if AH8->(!DBSEEK(xFilial() + _pdto))
      
      reclock("AH8",.T.)
      	AH8->AH8_FILIAL := xFilial()
      	AH8->AH8_PRODUT := _pdto
      	AH8->AH8_DESCMA := cDescPro
      	AH8->AH8_CODPRO := _pdto
      	AH8->AH8_QTDACU := 0
      	AH8->AH8_QTDINI := 0
      msunlock()

	              cLog := "Produto Master incluído com sucesso(AH8): PRODUTO "+ AH8->AH8_PRODUT +dtoc(cData) +" " + time()+ " "+ "- Incluído por: " +ALLTRIM(aVetorUser)			    
	              _Log(cLog)			    


     
     endif
  
  endif

return()

Static Function _Log (cLog)
local _nPlg    := 0
//local _sArqLog := "PARAM_MV"
local _sArqLog := "DUPLICA"
if file (_sArqLog + ".log")
	_nPlg = fopen(_sArqLog + ".log", 1)
else
	_nPlg = fcreate(_sArqLog + ".log", 0)
endif
fseek (_nPlg, 0, 2)  // Encontra final do arquivo
fwrite (_nPlg, cLog + chr (13) + chr (10))
fclose (_nPlg)
return

