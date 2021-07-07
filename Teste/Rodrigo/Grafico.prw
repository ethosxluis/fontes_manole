#include "PROTHEUS.CH"
#include "TOTVS.CH"


User Function Grafico()   

Local lGraph3D := .T. // .F. Grafico 2 dimensoes  - .T. Grafico 3 dimensoes
Local lMenuGraph := .T. // .F. Nao exibe menu  - .T. Exibe menu para mudar o tipo de grafico  
Local lMudaCor := .F. 
Local nTipoGraph := 1 
Local nCorDefault := 06 
Local aDados := {{"Janeiro", 100}, {"Fevereiro", 120},{"Março", 135},{"Abril", 115},{"Maio", 90},{"Junho", 70}}
Local aStru := {}
Local cArquivo := CriaTrab(,.F.)
Local i               
If MsgYesNo("Deseja exibir o grafico com os dados do array?") 	//o grafico sera montado a partir dos dados do array aDados    	
	MatGraph("Graficos",lGraph3D,lMenuGraph,lMudaCor,nTipoGraph,nCorDefault,aDados)
Else	
	aStru := {	{"EixoX"		, "C", 20, 0}, {"EixoY"		, "N", 8, 2} }	
	dbCreate(cArquivo,aStru)	
	dbUseArea(.T.,,cArquivo,"GRAFICO",.F.,.F.)		
	For i:=1 to Len(aDados)		
		("GRAFICO")->( dbAppend() )		
		("GRAFICO")->(EixoX) := aDados[i][1]		
		("GRAFICO")->(EixoY) := aDados[i][2]	
	Next i		//o grafico sera montado a partir dos dados da area de trabalho  "GRAFICO"	
	
	MatGraph("Graficos",lGraph3D,lMenuGraph,lMudaCor,nTipoGraph,nCorDefault,,"GRAFICO",{"EixoX","EixoY"})	
	("GRAFICO")->( dbCloseArea() )
EndIf	  

Return