
/*
�����������������������������������������������������������������������������
���Programa  �SD1100E   �Autor  �TOTVS               � Data �  16/11/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�����������������������������������������������������������������������������
*/

User Function SD1100E
Local aArea := GetArea()
Local cCodEvent := Posicione("SD2",3,xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD +SD1->D1_ITEMORI,"D2_XEVENTO")
If SF1->F1_TIPO == "B"

	If SD1->D1_XOPER $ GetMv("MV_XTOPERE")
		U_AtuCons(SF1->F1_FORNECE,SF1->F1_LOJA,SD1->D1_COD,cCodEvent,"SE",SD1->D1_QUANT)
	ElseIf SD1->D1_XOPER $ GetMv("MV_XTOPERF")
		U_AtuCons(SF1->F1_FORNECE,SF1->F1_LOJA,SD1->D1_COD,cCodEvent,"DE",SD1->D1_QUANT)
	EndIf
	
EndIf

///22222  *****  EXCLUS�O  *****
/*
RECLOCK("SZ3", .T.)
SZ3->Z3_FILIAL	:= xFilial("SD1")
SZ3->Z3_ITEM	:= SD1->D1_ITEM
SZ3->Z3_COD		:= SD1->D1_COD
SZ3->Z3_UM      := SD1->D1_UM
SZ3->Z3_QUANT   := SD1->D1_QUANT
SZ3->Z3_VUNIT   := SD1->D1_VUNIT
SZ3->Z3_TOTAL   := SD1->D1_TOTAL
SZ3->Z3_CF   	:= SD1->D1_CF
//SZ3->Z3_OPER   	:= SD1->D1_OPER  /// CAMPO VIRTUAL
SZ3->Z3_TES   	:= SD1->D1_TES
SZ3->Z3_NFORI   := SD1->D1_NFORI
SZ3->Z3_DESC    := SD1->D1_DESC
SZ3->Z3_VALIPI  := SD1->D1_VALIPI
SZ3->Z3_VALICM  := SD1->D1_VALICM
SZ3->Z3_IPI     := SD1->D1_IPI
SZ3->Z3_PICM    := SD1->D1_PICM
SZ3->Z3_PESO    := SD1->D1_PESO
SZ3->Z3_CONTA   := SD1->D1_CONTA
SZ3->Z3_ITEMCTA := SD1->D1_ITEMCTA
SZ3->Z3_CC      := SD1->D1_CC
SZ3->Z3_FORNECE := SD1->D1_FORNECE
SZ3->Z3_LOJA    := SD1->D1_LOJA
SZ3->Z3_OP      := SD1->D1_OP
SZ3->Z3_DOC     := SD1->D1_DOC
SZ3->Z3_EMISSAO := SD1->D1_EMISSAO
SZ3->Z3_PEDIDO  := SD1->D1_PEDIDO
SZ3->Z3_DTDIGIT := SD1->D1_DTDIGIT
SZ3->Z3_ITEMPC  := SD1->D1_ITEMPC
SZ3->Z3_SERIE   := SD1->D1_SERIE
SZ3->Z3_GRUPO   := SD1->D1_GRUPO
SZ3->Z3_TIPO    := SD1->D1_TIPO
SZ3->Z3_CUSTO2  := SD1->D1_CUSTO2
SZ3->Z3_CUSTO3  := SD1->D1_CUSTO3
SZ3->Z3_CUSTO4  := SD1->D1_CUSTO4
SZ3->Z3_CUSTO5  := SD1->D1_CUSTO5
SZ3->Z3_NUMSEQ  := SD1->D1_NUMSEQ
SZ3->Z3_SEGUM   := SD1->D1_SEGUM
SZ3->Z3_TP      := SD1->D1_TP
SZ3->Z3_QTSEGUM := SD1->D1_QTSEGUM
SZ3->Z3_ITEMORI := SD1->D1_ITEMORI
SZ3->Z3_DATACUS := SD1->D1_DATACUS
SZ3->Z3_SERIORI := SD1->D1_SERIORI
SZ3->Z3_ORIGLAN := SD1->D1_ORIGLAN
SZ3->Z3_QTDEDEV := SD1->D1_QTDEDEV
SZ3->Z3_VALDEV  := SD1->D1_VALDEV
SZ3->Z3_NUMCQ   := SD1->D1_NUMCQ
SZ3->Z3_ICMSRET := SD1->D1_ICMSRET
SZ3->Z3_BRICMS  := SD1->D1_BRICMS
SZ3->Z3_DATORI  := SD1->D1_DATORI
SZ3->Z3_IDENTB6 := SD1->D1_IDENTB6
SZ3->Z3_BASEICM := SD1->D1_BASEICM
SZ3->Z3_SKIPLOT := SD1->D1_SKIPLOT
SZ3->Z3_VALDESC := SD1->D1_VALDESC
SZ3->Z3_SEQCALC := SD1->D1_SEQCALC
SZ3->Z3_LOTEFOR := SD1->D1_LOTEFOR
SZ3->Z3_BASEIPI := SD1->D1_BASEIPI
SZ3->Z3_LOTECTL := SD1->D1_LOTECTL
SZ3->Z3_NUMLOTE := SD1->D1_NUMLOTE
SZ3->Z3_DTVALID := SD1->D1_DTVALID
SZ3->Z3_PLACA   := SD1->D1_PLACA
SZ3->Z3_CHASSI  := SD1->D1_CHASSI
SZ3->Z3_ANOFAB  := SD1->D1_ANOFAB
SZ3->Z3_MODFAB  := SD1->D1_MODFAB
SZ3->Z3_MODELO  := SD1->D1_MODELO
SZ3->Z3_COMBUST := SD1->D1_COMBUST
SZ3->Z3_FORMUL  := SD1->D1_FORMUL
SZ3->Z3_COR     := SD1->D1_COR
SZ3->Z3_EQUIPS  := SD1->D1_EQUIPS
SZ3->Z3_II      := SD1->D1_II
//SZ3->Z3_GERAPV  := GdFieldGet("D1_GERAPV")  
SZ3->Z3_NUMPV   := SD1->D1_NUMPV
SZ3->Z3_ITEMPV  := SD1->D1_ITEMPV
SZ3->Z3_TEC     := SD1->D1_TEC
SZ3->Z3_CONHEC  := SD1->D1_CONHEC
SZ3->Z3_CUSFF1  := SD1->D1_CUSFF1
SZ3->Z3_CUSFF2  := SD1->D1_CUSFF2
SZ3->Z3_CUSFF3  := SD1->D1_CUSFF3
SZ3->Z3_CUSFF4  := SD1->D1_CUSFF4
SZ3->Z3_CLASFIS := SD1->D1_CLASFIS
SZ3->Z3_CUSFF5  := SD1->D1_CUSFF5
SZ3->Z3_REMITO  := SD1->D1_REMITO
SZ3->Z3_SERIREM := SD1->D1_SERIREM
SZ3->Z3_CODCIAP := SD1->D1_CODCIAP
SZ3->Z3_BASIMP1 := SD1->D1_BASIMP1
SZ3->Z3_BASIMP4 := SD1->D1_BASIMP4
SZ3->Z3_BASIMP3 := SD1->D1_BASIMP3
SZ3->Z3_CUSTO   := SD1->D1_CUSTO
SZ3->Z3_BASIMP5 := SD1->D1_BASIMP5
SZ3->Z3_BASIMP6 := SD1->D1_BASIMP6
SZ3->Z3_VALIMP1 := SD1->D1_VALIMP1
SZ3->Z3_VALIMP2 := SD1->D1_VALIMP2
SZ3->Z3_VALIMP3 := SD1->D1_VALIMP3
SZ3->Z3_VALIMP4 := SD1->D1_VALIMP4
SZ3->Z3_VALIMP5 := SD1->D1_VALIMP5
SZ3->Z3_VALIMP6 := SD1->D1_VALIMP6
SZ3->Z3_CIF     := SD1->D1_CIF
SZ3->Z3_ITEMREM := SD1->D1_ITEMREM
SZ3->Z3_CBASEAF := SD1->D1_CBASEAF
SZ3->Z3_TIPO_NF := SD1->D1_TIPO_NF
SZ3->Z3_ICMSCOM := SD1->D1_ICMSCOM
SZ3->Z3_BASIMP2 := SD1->D1_BASIMP2
SZ3->Z3_ALQIMP1 := SD1->D1_ALQIMP1
SZ3->Z3_ALQIMP2 := SD1->D1_ALQIMP2
SZ3->Z3_ALQIMP3 := SD1->D1_ALQIMP3
SZ3->Z3_ALQIMP4 := SD1->D1_ALQIMP4
SZ3->Z3_ALQIMP5 := SD1->D1_ALQIMP5
SZ3->Z3_ALQIMP6 := SD1->D1_ALQIMP6
SZ3->Z3_VALFRE  := SD1->D1_VALFRE
SZ3->Z3_QTDPEDI := SD1->D1_QTDPEDI
SZ3->Z3_RATEIO  := SD1->D1_RATEIO
SZ3->Z3_SEGURO  := SD1->D1_SEGURO
SZ3->Z3_DESPESA := SD1->D1_DESPESA
SZ3->Z3_BASEIRR := SD1->D1_BASEIRR
SZ3->Z3_ALIQIRR := SD1->D1_ALIQIRR
SZ3->Z3_VALIRR  := SD1->D1_VALIRR
SZ3->Z3_BASEISS := SD1->D1_BASEISS
SZ3->Z3_ALIQISS := SD1->D1_ALIQISS
SZ3->Z3_VALISS  := SD1->D1_VALISS
SZ3->Z3_BASEINS := SD1->D1_BASEINS
SZ3->Z3_CUSORI  := SD1->D1_CUSORI
SZ3->Z3_ALIQINS := SD1->D1_ALIQINS
SZ3->Z3_VALINS  := SD1->D1_VALINS
SZ3->Z3_LOCPAD  := SD1->D1_LOCPAD
SZ3->Z3_CLVL    := SD1->D1_CLVL
SZ3->Z3_ORDEM   := SD1->D1_ORDEM
//SZ3->Z3_CODGRP  := SD1->D1_CODGRP  // campo virtual
//SZ3->Z3_CODITE  := SD1->D1_CODITE  // campo virtual
SZ3->Z3_SERVIC  := SD1->D1_SERVIC
SZ3->Z3_STSERV  := SD1->D1_STSERV
SZ3->Z3_ENDER   := SD1->D1_ENDER
SZ3->Z3_TPESTR  := SD1->D1_TPESTR
//SZ3->Z3_DESEST  := SD1->D1_DESEST
SZ3->Z3_REGWMS  := SD1->D1_REGWMS
SZ3->Z3_PCCENTR := SD1->D1_PCCENTR
SZ3->Z3_TIPODOC := SD1->D1_TIPODOC
SZ3->Z3_QTPCCEN := SD1->D1_QTPCCEN
SZ3->Z3_ITPCCEN := SD1->D1_ITPCCEN
SZ3->Z3_POTENCI := SD1->D1_POTENCI
SZ3->Z3_TRT     := SD1->D1_TRT
SZ3->Z3_TESACLA := SD1->D1_TESACLA
SZ3->Z3_GRADE   := SD1->D1_GRADE
SZ3->Z3_ITEMGRD := SD1->D1_ITEMGRD
SZ3->Z3_NUMDESP := SD1->D1_NUMDESP
SZ3->Z3_ABATISS := SD1->D1_ABATISS
SZ3->Z3_BASECSL := SD1->D1_BASECSL
SZ3->Z3_BASEPS3 := SD1->D1_BASEPS3
SZ3->Z3_BASECF3 := SD1->D1_BASECF3
SZ3->Z3_VALCF3  := SD1->D1_VALCF3
SZ3->Z3_VALACRS := SD1->D1_VALACRS
SZ3->Z3_BASECOF := SD1->D1_BASECOF
SZ3->Z3_CRDZFM  := SD1->D1_CRDZFM
SZ3->Z3_ORIGEM  := SD1->D1_ORIGEM
SZ3->Z3_VALCOF  := SD1->D1_VALCOF
SZ3->Z3_DESCICM := SD1->D1_DESCICM
SZ3->Z3_VALPS3  := SD1->D1_VALPS3
SZ3->Z3_ALIQCF3 := SD1->D1_ALIQCF3
SZ3->Z3_CODISS  := SD1->D1_CODISS
SZ3->Z3_SLDDEP  := SD1->D1_SLDDEP
SZ3->Z3_CRPRSIM := SD1->D1_CRPRSIM
SZ3->Z3_ALIQPS3 := SD1->D1_ALIQPS3
SZ3->Z3_ALIQSOL := SD1->D1_ALIQSOL
SZ3->Z3_NFVINC  := SD1->D1_NFVINC
SZ3->Z3_MARGEM  := SD1->D1_MARGEM
SZ3->Z3_VALANTI := SD1->D1_VALANTI
SZ3->Z3_PRUNDA  := SD1->D1_PRUNDA
SZ3->Z3_ABATMAT := SD1->D1_ABATMAT
// SZ3->Z3_ITEMMED := SD1->D1_ITEMMED
SZ3->Z3_ITMVINC := SD1->D1_ITMVINC
SZ3->Z3_BASEPIS := SD1->D1_BASEPIS
SZ3->Z3_CFPS    := SD1->D1_CFPS
SZ3->Z3_ICMSDIF := SD1->D1_ICMSDIF
SZ3->Z3_CONBAR  := SD1->D1_CONBAR
SZ3->Z3_ESTCRED := SD1->D1_ESTCRED
SZ3->Z3_SERVINC := SD1->D1_SERVINC
SZ3->Z3_VALSES  := SD1->D1_VALSES
SZ3->Z3_GARANTI := SD1->D1_GARANTI
SZ3->Z3_ALQCSL  := SD1->D1_ALQCSL
SZ3->Z3_ALIQII  := SD1->D1_ALIQII
SZ3->Z3_VALFDS  := SD1->D1_VALCSL
SZ3->Z3_VALFDS  := SD1->D1_VALFDS
SZ3->Z3_ICMNDES := SD1->D1_ICMNDES
SZ3->Z3_RGESPST := SD1->D1_RGESPST
SZ3->Z3_CUSRP1  := SD1->D1_CUSRP1
SZ3->Z3_CUSRP4  := SD1->D1_CUSRP4
SZ3->Z3_CUSRP3  := SD1->D1_CUSRP3
SZ3->Z3_ALQCOF  := SD1->D1_ALQCOF
SZ3->Z3_VALPIS  := SD1->D1_VALPIS
SZ3->Z3_BASESES := SD1->D1_BASESES
SZ3->Z3_UFERMS  := SD1->D1_UFERMS
SZ3->Z3_CUSRP5  := SD1->D1_CUSRP5
SZ3->Z3_ALQPIS  := SD1->D1_ALQPIS
SZ3->Z3_ALIQSES := SD1->D1_ALIQSES
SZ3->Z3_CRPRESC := SD1->D1_CRPRESC
SZ3->Z3_BASNDES := SD1->D1_BASNDES
SZ3->Z3_TRANSIT := SD1->D1_TRANSIT
SZ3->Z3_CUSRP2  := SD1->D1_CUSRP2
SZ3->Z3_PRFDSUL := SD1->D1_PRFDSUL
SZ3->Z3_QTDCONF := SD1->D1_QTDCONF
SZ3->Z3_XOPER   := SD1->D1_XOPER
SZ3->Z3_DFABRIC := SD1->D1_DFABRIC
SZ3->Z3_ABATINS := SD1->D1_ABATINS
SZ3->Z3_AVLINSS := SD1->D1_AVLINSS
SZ3->Z3_BASEFAB := SD1->D1_BASEFAB
SZ3->Z3_ALIQFAB := SD1->D1_ALIQFAB
SZ3->Z3_VALFAB  := SD1->D1_VALFAB
SZ3->Z3_BASEFAC := SD1->D1_BASEFAC
SZ3->Z3_ALIQFAC := SD1->D1_ALIQFAC
SZ3->Z3_VALFAC  := SD1->D1_VALFAC
SZ3->Z3_BASEFET := SD1->D1_BASEFET
SZ3->Z3_ALIQFET := SD1->D1_ALIQFET
SZ3->Z3_VALFET  := SD1->D1_VALFET
SZ3->Z3_CODLAN  := SD1->D1_CODLAN
SZ3->Z3_XDI     := SD1->D1_XDI
SZ3->Z3_XDESC   := SD1->D1_XDESC
SZ3->Z3_XNCM    := SD1->D1_XNCM
SZ3->Z3_XADICAO := SD1->D1_XADICAO
SZ3->Z3_XSEQADI := SD1->D1_XSEQADI
SZ3->Z3_XFABRIC := SD1->D1_XFABRIC
SZ3->Z3_XII     := SD1->D1_XII
SZ3->Z3_XDSCADI := SD1->D1_XDSCADI
SZ3->Z3_VLINCMG := SD1->D1_VLINCMG
SZ3->Z3_PRINCMG := SD1->D1_PRINCMG
SZ3->Z3_BASEFUN := SD1->D1_BASEFUN
SZ3->Z3_ALIQFUN := SD1->D1_ALIQFUN
SZ3->Z3_TNATREC := SD1->D1_TNATREC
SZ3->Z3_VALFUN  := SD1->D1_VALFUN
SZ3->Z3_CNATREC := SD1->D1_CNATREC
SZ3->Z3_GRUPONC := SD1->D1_GRUPONC
SZ3->Z3_DTFIMNT := SD1->D1_DTFIMNT
SZ3->Z3_CODBAIX := SD1->D1_CODBAIX
SZ3->Z3_VALINA  := SD1->D1_VALINA
SZ3->Z3_BASEINA := SD1->D1_BASEINA
SZ3->Z3_VALCMAJ := SD1->D1_VALCMAJ
SZ3->Z3_ALIQINA := SD1->D1_ALIQINA
SZ3->Z3_CRPREPR := SD1->D1_CRPREPR
SZ3->Z3_VLSENAR := SD1->D1_VLSENAR
SZ3->Z3_BSSENAR := SD1->D1_BSSENAR
SZ3->Z3_ALSENAR := SD1->D1_ALSENAR
SZ3->Z3_VALPMAJ := SD1->D1_VALPMAJ
SZ3->Z3_OKISS   := SD1->D1_OKISS
SZ3->Z3_IDCFC   := SD1->D1_IDCFC
SZ3->Z3_PROJ    := SD1->D1_PROJ
SZ3->Z3_CONIMP  := SD1->D1_CONIMP
SZ3->Z3_FCICOD  := SD1->D1_FCICOD
SZ3->Z3_VLCIDE  := SD1->D1_VLCIDE
SZ3->Z3_BASECID := SD1->D1_BASECID
SZ3->Z3_ALQCIDE := SD1->D1_ALQCIDE
SZ3->Z3_VALCPM  := SD1->D1_VALCPM
SZ3->Z3_BASECPM := SD1->D1_BASECPM
SZ3->Z3_ALQCPM  := SD1->D1_ALQCPM
SZ3->Z3_VALFMP  := SD1->D1_VALFMP
SZ3->Z3_BASEFMP := SD1->D1_BASEFMP
SZ3->Z3_ALQFMP  := SD1->D1_ALQFMP
SZ3->Z3_BASEFMD := SD1->D1_BASEFMD
SZ3->Z3_ALQFMD  := SD1->D1_ALQFMD
SZ3->Z3_VALFMD  := SD1->D1_VALFMD
MsUnlock()
*/


RestArea(aArea)
Return
