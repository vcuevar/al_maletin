-- Consulta para calculo del Punto de Reorden.
-- Ing. Vicente Cueva R.
-- Actualizado: Jueves 28 de Abril del 2022; Origen.

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30), @Cod_Mat nvarchar(10)
--@ConXdia decimal(14,3), 

Set @FechaIS = CONVERT(DATE, (SELECT DATEADD(MM, -5, GETDATE())), 102)
Set @FechaFS = CONVERT (DATE, GETDATE()) 
--Set @ConXdia = 0
--Set @Cod_Mat = '00233'	-- MULTIPLAY CAOBILLA 03 MM 4 X 8 MERATI BENGAL (2.5)
--Set @Cod_Mat = '01457'	--LIJA BANDA 8" DE ANCHO X 2.55MTS LARGO  080�
--Set @Cod_Mat = '00005'	-- ADHESIVO "IRIS" K-810 S NO FLAMABLE
--Set @Cod_Mat = '00997'	-- TORNILLO 5/16" X 1"  HEXAGONAL GALVANIZADO
 Set @Cod_Mat = '12741'         --  ADHESIVO "IRIS" K-812 NO FLAMABLE
-- Set @Cod_Mat = '00016'          -- BANDASTIC ULTRA PLUS NACIONAL 100% D 5CM. R.50 HYM
--Set @Cod_Mat = '00832'
-- Con esta consulta se obtiene el material entregado por almacen de Materias Primas a WIP de hoy a 5
-- Meses hacia atras. Todas las salidas del Almacen de Materias Primas Localidad L101_GENERAL.
-- Minimo consumo diario por 7 dias.
-- Punto Reorden Consumo diario + LET TIME + Minimo
-- Maximo Minimo mas PR mas consumo de 7 dias.
-- Integras Consumo Diario al Reporte de Max Min

-- Para Existencia se toman las siguientes localidades 'L101_GENERAL', 'L212_HULES', 'L214_HERRAMIENTAS'
-- 'L222_LACA', 'L223_MADERAS', 'L225_METALMX'

Select ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS DESCRPCION
	, CMUM_Nombre AS UDM
	, Convert(Decimal(14,3), E.EXI_Inventario) AS EXISTENCIA
	, Convert(Decimal(14,3), K.CCD_Consumo) AS CONS_DIA
	, Convert(Decimal(28,4),ART_CantMinimaOrden) as MINIMO
	, Convert(Decimal(14,3), K.CCD_Consumo * 7) AS STK_MIN
	, Convert(Decimal(14,3), (K.CCD_Consumo * 7) + (K.CCD_Consumo * ART_NoDiasAbastecimiento)) AS PUN_REO
	, Convert(Decimal(28,4),ART_CantMaximaOrden) as MAXIMO
	, Convert(Decimal(14,3), (K.CCD_Consumo *14) + (K.CCD_Consumo * ART_NoDiasAbastecimiento)) AS STK_MAX
	, Convert(Decimal(14,3), K.CCD_Consumo*152) AS CONS_152
	, Convert(Decimal(14,3), ART_NoDiasAbastecimiento) AS LED_TIME
FROM Articulos
Left Join (Select A1.ART_CodigoArticulo AS CCD_Codigo
, Convert(Decimal(14,3), ((SUM(TRAM_CantidadATraspasar)*-1)/152)) AS CCD_Consumo
FROM TraspasosMovtos
Inner Join TraspasosLotes on TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
Inner Join LotesLocalidades on LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
Inner Join Localidades on LOC_LocalidadId = LOTL_LOC_LocalidadId
Inner Join Articulos A1 on TRAM_ART_ArticuloId = A1.ART_ArticuloId
Inner Join ControlesMaestrosMultiples on CMM_ControlId =  TRAM_CMM_TipoTransferenciaId
Where  Cast(TRAM_FechaTraspaso as date) Between @FechaIS and @FechaFS 
and CMM_Control = 'CMM_CDA_MovimientoEnInventario'
and LOC_CodigoLocalidad = 'L101_GENERAL'
and TRLOT_CantidadTraspaso < 0
Group By  A1.ART_CodigoArticulo ) K on K.CCD_Codigo = ART_CodigoArticulo

Left Join (
Select	T1.ART_CodigoArticulo as EXI_Codigo 
 , Convert(Decimal(28,4),SUM(T0.LOCA_Cantidad)) as EXI_Inventario 
from LocalidadesArticulo T0
inner join Articulos T1 on T1.ART_ArticuloId = T0.LOCA_ART_ArticuloId 
Inner join Localidades T2 on T0.LOCA_LOC_LocalidadId = T2.LOC_LocalidadId 
Where (LOC_CodigoLocalidad = 'L101_GENERAL'
or  LOC_CodigoLocalidad = 'L212_HULES'
or  LOC_CodigoLocalidad = 'L214_HERRAMIENTAS'
or  LOC_CodigoLocalidad = 'L222_LACA'
or  LOC_CodigoLocalidad = 'L223_MADERAS'
or  LOC_CodigoLocalidad = 'L225_METALMX')
Group By T1.ART_CodigoArticulo) E on E.EXI_Codigo = ART_CodigoArticulo

inner join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
-- Where ART_CodigoArticulo = @Cod_Mat
Where ART_CantMinimaOrden > 1

Order By ART_Nombre

 -- Detalle de los Consumos.
Select Cast(TRAM_FechaTraspaso as date) AS FEC_TRASP
	, ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS DESCRPCION
	, Convert(Decimal(14,3), TRAM_CantidadATraspasar*-1) AS TRASLADO
	, Convert(Decimal(14,3), ART_NoDiasAbastecimiento) AS LED_TIME
	, CMM_Valor AS MOVIMIENTO
	, LOC_CodigoLocalidad AS COD_LOC
	, @FechaIS AS FEC_INI
	, @FechaFS  AS FEC_FIN
FROM TraspasosMovtos
Inner Join TraspasosLotes on TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
Inner Join LotesLocalidades on LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
Inner Join Localidades on LOC_LocalidadId = LOTL_LOC_LocalidadId
Inner Join Articulos on TRAM_ART_ArticuloId = ART_ArticuloId
Inner Join ControlesMaestrosMultiples on CMM_ControlId =  TRAM_CMM_TipoTransferenciaId
Where  Cast(TRAM_FechaTraspaso as date) Between @FechaIS and @FechaFS 
and ART_CodigoArticulo = @Cod_Mat
and CMM_Control = 'CMM_CDA_MovimientoEnInventario'
and LOC_CodigoLocalidad = 'L101_GENERAL'
and TRLOT_CantidadTraspaso < 0
Order By TRAM_FechaTraspaso 

/*

Select top(10) * from TraspasosMovtos Where TRAM_ART_ArticuloId = 'BDB20AAC-77A9-4E45-9C23-B4EA33A710EE'
Order By TRAM_FechaTraspaso

Select * from ControlesMaestrosMultiples 
Where CMM_Control = 'CMM_CDA_MovimientoEnInventario'
--Where CMM_ControlID = '39B95B52-F380-40E0-B543-F132A769E819'
Where CMM_ControlID = 'D7D22076-0400-4C59-B88E-1AA98C910B9F'

CMM_ControlId	CMM_Control	CMM_Valor
D42F56BA-7A6F-4B84-B993-BA1158252741	CMM_CDA_MovimientoEnInventario	Adm Devolución
A9032E9D-294F-4BBB-A9AF-C0DD82891CED	CMM_CDA_MovimientoEnInventario	Ajuste De Inventario
CB1B1C98-8711-4504-8BB1-B6816328B471	CMM_CDA_MovimientoEnInventario	Ajuste Por Merma
50D25D91-547C-4DB0-8314-F1CC36518647	CMM_CDA_MovimientoEnInventario	Asignación de Recurso OT
33F13AE6-AD89-4181-B899-F094A44CACFF	CMM_CDA_MovimientoEnInventario	Cancelación De Devolución De Embarque
67CC2D5E-26D8-42A9-BB17-42F6A6B639E5	CMM_CDA_MovimientoEnInventario	Cancelación De Devolución De Traspaso
B18BBD9C-E9EE-4830-A30F-7CA6E2FAD3E4	CMM_CDA_MovimientoEnInventario	Cancelación De Devolución De Traspaso Recibo
EC617F9E-CC2A-4294-BE6F-341425A861EF	CMM_CDA_MovimientoEnInventario	Cancelación De Embarque
934C2C6F-0E97-479E-95EB-9556DC979B62	CMM_CDA_MovimientoEnInventario	Cancelación De Traspaso
61318E28-9E96-4522-8CF2-29D9A568C2D1	CMM_CDA_MovimientoEnInventario	Cancelación Devolución Recibo OC
CF6E3FCD-2859-474C-844B-77E0F0BB4241	CMM_CDA_MovimientoEnInventario	Cancelación Recibo De Traspaso
741B6B0A-363E-4085-8B45-5B3A4FB3E59D	CMM_CDA_MovimientoEnInventario	Cantidad Trabajada OT
1B9249E8-3281-473E-A2EB-AD9D496A858A	CMM_CDA_MovimientoEnInventario	Devolucion Cantidad Trabajada OT
80D22B29-2BFF-4044-9FD5-AFA580C175D8	CMM_CDA_MovimientoEnInventario	Devolucion Cedi
EF0C7188-7ECD-4190-BB30-52048051F3FC	CMM_CDA_MovimientoEnInventario	Devolucion Empaque Recorte
8C5E596C-B2A9-4172-947C-5FE5F7C46990	CMM_CDA_MovimientoEnInventario	Devolución Asignación Recurso
6645F4F4-76F2-4340-AC4E-0F636A26FE89	CMM_CDA_MovimientoEnInventario	Devolución Cantidad Trabajada Ajuste
68A54A6E-1B81-4B0B-B4A2-DAE8D0618DA0	CMM_CDA_MovimientoEnInventario	Devolución De Embarque
A3AD0ED0-8193-4311-8017-42A35D1277AE	CMM_CDA_MovimientoEnInventario	Devolución De Traspaso
9E3ECC26-E706-4A77-ACB0-009B63783CB2	CMM_CDA_MovimientoEnInventario	Devolución Entrega OT WIP
819A7E9B-E9FA-4503-ABB5-1C6848BC14B6	CMM_CDA_MovimientoEnInventario	Devolución Recibo de OC
EC078623-5E78-4047-9672-543D0DB5AB3D	CMM_CDA_MovimientoEnInventario	Devolución Recibo OT WIP
5B9A6E9C-0CEF-456A-8213-61138D183940	CMM_CDA_MovimientoEnInventario	Devolución Recibo Surtimiento OT
C244EBF6-D08A-4760-BA98-7FA8A1534BFF	CMM_CDA_MovimientoEnInventario	Devolución Reevaluación Lote
6747AB62-7A35-4D41-BCF5-D2035028D62E	CMM_CDA_MovimientoEnInventario	Devolución Surtimiento OT
FB9DD40D-14AB-4AD4-AB2E-AD887C80FDE3	CMM_CDA_MovimientoEnInventario	Embarque
CAB5829F-1C50-4481-8A1F-7A41E6DF304C	CMM_CDA_MovimientoEnInventario	Empaque Consignable
958E6430-F874-48A0-A26E-1502F1BC39CB	CMM_CDA_MovimientoEnInventario	Empaque Recorte
ECB88DFF-00A2-440C-9374-FC7158B68EDF	CMM_CDA_MovimientoEnInventario	Entrada Producción/WIP
4AF9B573-8933-4325-B20A-7851797F4EC5	CMM_CDA_MovimientoEnInventario	Entrega OT WIP
23479CD0-B6EA-409C-BA67-6F0780E6DC9C	CMM_CDA_MovimientoEnInventario	Entrega Recibo Lote
47BAE709-47AE-4A36-94A7-60C2BE02299D	CMM_CDA_MovimientoEnInventario	Entrega WIP
BF702FBF-907C-4BF9-AF8F-A2C45AE2DD59	CMM_CDA_MovimientoEnInventario	Facturación Detalle
39B95B52-F380-40E0-B543-F132A769E819	CMM_CDA_MovimientoEnInventario	Inventario Físico
C9919E06-142F-4316-B675-B7EABDDA3885	CMM_CDA_MovimientoEnInventario	Recibo De Lote
034717C3-1A76-485F-AA10-0F2E83829B32	CMM_CDA_MovimientoEnInventario	Recibo de OC
1267D672-3920-48DA-9FE7-5C35E31C1BF6	CMM_CDA_MovimientoEnInventario	Recibo De Traspaso
4FDCBC10-5D9B-43BC-92E7-34B64930EBD1	CMM_CDA_MovimientoEnInventario	Recibo Devolución Cedi
A98EEB00-F422-46CA-A45D-6B6AF2DEEF2A	CMM_CDA_MovimientoEnInventario	Recibo OT
7B7A8265-B195-499D-BC9A-BC3C54CB322C	CMM_CDA_MovimientoEnInventario	Recibo OT Bultos
4B25E664-9098-43EF-AFF1-3F9BFFA814C6	CMM_CDA_MovimientoEnInventario	Recibo OT Implosionado
CA975215-DD43-4060-9DF4-306D8325E99A	CMM_CDA_MovimientoEnInventario	Recibo OT WIP
AC79620A-6B6D-44A3-983D-D2FD89E3B776	CMM_CDA_MovimientoEnInventario	Recibo Surtimiento de Solicitud Traspaso
21B19AC6-3DA1-4723-8FDC-41223C9AA4D6	CMM_CDA_MovimientoEnInventario	Recibo Surtimiento OT
AE7A488F-3C40-457E-877C-7B3305559B7E	CMM_CDA_MovimientoEnInventario	Recibo WIP
AD790CE9-9BA3-4444-AF56-771DE98933C8	CMM_CDA_MovimientoEnInventario	Reevaluacion Libre
0AB89E09-1E8D-42B5-8947-8A02BC4C0F73	CMM_CDA_MovimientoEnInventario	Reevaluación Congelamiento
F15CF9B5-21F3-4D6F-BFF3-3E274B0877F4	CMM_CDA_MovimientoEnInventario	Reevaluación Lote
689F221C-DB76-4824-8D5C-71955013B1A7	CMM_CDA_MovimientoEnInventario	Salida Producción/WIP
8CD8B776-2B8F-40DB-9FB3-0A3A7F95C099	CMM_CDA_MovimientoEnInventario	Surtimiento de Solicitud Traspaso
0E70E1AC-F566-4393-ADEE-6715D73A8BF0	CMM_CDA_MovimientoEnInventario	Surtimiento OT
25B0EE46-48D1-4E47-B97C-33C3C67D6801	CMM_CDA_MovimientoEnInventario	Surtimiento OTG
D7D22076-0400-4C59-B88E-1AA98C910B9F	CMM_CDA_MovimientoEnInventario	Traspaso

*/


-- Detalle de las Existencias
Select	T1.ART_CodigoArticulo as EXI_Codigo 
		, T1.ART_Nombre AS DESCRIPCION
		, Convert(Decimal(28,4),T0.LOCA_Cantidad) as EXI_Inventario 
		, LOC_CodigoLocalidad AS LOCALIDAD
from LocalidadesArticulo T0
inner join Articulos T1 on T1.ART_ArticuloId = T0.LOCA_ART_ArticuloId 
Inner join Localidades T2 on T0.LOCA_LOC_LocalidadId = T2.LOC_LocalidadId 
Where (LOC_CodigoLocalidad = 'L101_GENERAL'
or  LOC_CodigoLocalidad = 'L212_HULES'
or  LOC_CodigoLocalidad = 'L214_HERRAMIENTAS'
or  LOC_CodigoLocalidad = 'L222_LACA'
or  LOC_CodigoLocalidad = 'L223_MADERAS'
or  LOC_CodigoLocalidad = 'L225_METALMX') and T1.ART_CodigoArticulo = @Cod_Mat

-- Datos para Requisicion.
Select	ART_ArticuloID AS ID
        , ART_CodigoArticulo as CODIGO
        , ART_Nombre as NOMBRE
        , UM.CMUM_Nombre as UDM 
        , Convert(Decimal(28,4),ART_CantMinimaOrden) as MINIMO
        , Convert(Decimal(28,4),ART_CantPuntoOrden) as P_REORDEN 
        , Convert(Decimal(28,4),ART_CantMaximaOrden) as MAXIMO
        , Convert(Decimal(28,2), ART_NoDiasAbastecimiento) AS DIA_ABS    
from Articulos
inner join ControlesMaestrosUM UM on ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId 
--Where ART_CantMaximaOrden > 1
Where ART_CodigoArticulo = @Cod_Mat

/*
Select * from ControlesMaestrosMultiples where CMM_Control = 'CMM_CDA_MovimientoEnInventario'


	

-- Asignar Consumo del Material por dia
Set @ConXdia = (
Select Convert(Decimal(14,3), ((SUM(TRAM_CantidadATraspasar)*-1)/152)) AS CONS_DIA
FROM TraspasosMovtos
Inner Join TraspasosLotes on TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
Inner Join LotesLocalidades on LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
Inner Join Localidades on LOC_LocalidadId = LOTL_LOC_LocalidadId
Inner Join Articulos on TRAM_ART_ArticuloId = ART_ArticuloId
Inner Join ControlesMaestrosMultiples on CMM_ControlId =  TRAM_CMM_TipoTransferenciaId
Where  Cast(TRAM_FechaTraspaso as date) Between @FechaIS and @FechaFS 
and ART_CodigoArticulo = @Cod_Mat
and (CMM_Valor ='Salida Producci�n/WIP' or CMM_Valor = 'Traspaso')
and LOC_CodigoLocalidad = 'L101_GENERAL'
and TRLOT_CantidadTraspaso < 0)
 
-- Reporte de Max y Min
Select ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS DESCRPCION
	, Convert(Decimal(14,3), @ConXdia) AS CONS_DIA
	, Convert(Decimal(14,3), @ConXdia * 7) AS STK_MIN
	, Convert(Decimal(14,3), (@ConXdia * 7) + (@ConXdia * ART_NoDiasAbastecimiento)) AS PUN_REO
	, Convert(Decimal(14,3), (@ConXdia *14) + (@ConXdia * ART_NoDiasAbastecimiento)) AS STK_MAX
	, Convert(Decimal(14,3), @ConXdia*152) AS CONS_152
	, Convert(Decimal(14,3), ART_NoDiasAbastecimiento) AS LED_TIME
FROM Articulos
Where ART_CodigoArticulo = @Cod_Mat
Order By ART_Nombre

-- Calculo del Consumo en los Ultimos 5 meses	
Select  ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS DESCRPCION
	, SUM(TRAM_CantidadATraspasar) AS CANTIDAD
	, ART_NoDiasAbastecimiento AS LED_TIME
FROM TraspasosMovtos
Inner Join TraspasosLotes on TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
Inner Join LotesLocalidades on LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
Inner Join Localidades on LOC_LocalidadId = LOTL_LOC_LocalidadId
Inner Join Articulos on TRAM_ART_ArticuloId = ART_ArticuloId
Inner Join ControlesMaestrosMultiples on CMM_ControlId =  TRAM_CMM_TipoTransferenciaId
Where  Cast(TRAM_FechaTraspaso as date) Between @FechaIS and @FechaFS 
and LOC_CodigoLocalidad = 'L101_GENERAL'
and TRLOT_CantidadTraspaso < 0
Group By ART_CodigoArticulo, ART_Nombre
Order By  ART_Nombre
*/


