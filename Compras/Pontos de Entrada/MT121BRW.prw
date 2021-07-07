#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT121BRW()

Local aGrupos := UsrRetGrp(cUserName)	// Carrega os grupos do usuário
Local cGrpLib := SuperGetMV("MN_GRPLIB")	
Local cGrpImp := SuperGetMV("MN_GRPIMP")	
Local cGrpCur := SuperGetMV("MN_GRPCUR") 

Local nI := 0

//Define Array contendo as Rotinas a executar do programa     
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transação a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs     

For nI := 1 to Len(aGrupos)

	//Grupo Manole Livros - producao e grafica
	If aGrupos[nI] == cGrpLib
		AAdd(aRotina,{"Liberar Contrato"  , "U_MNCOMA01",0,2,0, nil})
		
	//Grupo Manole Livros - producao e grafica
	Elseif aGrupos[nI] == cGrpImp
		aadd(aRotina,{"Imprimir Contrato" , "U_COMR001",0,2,0, nil})
		aadd(aRotina,{"Contrato Concluido", "U_MNCOMA04",0,2,0, nil})
		
	//Grupo Manole Educacao - Prestacao de serviços - em que todos podem imprimir
	ElseIf aGrupos[nI] == cGrpCur
		aadd(aRotina,{"Imprimir Contrato" , "U_COMR001",0,2,0, nil})
	Endif
Next nI

Return 	
