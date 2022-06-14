-- Consulta para calculo del Punto de Reorden.
-- Ing. Vicente Cueva R.
-- Actualizado: Jueves 28 de Abril del 2022; Origen.
-- Actualizado: Viernes 10 de Junio del 2022; Ajustar para montar en Macro y Ordenes Pendientes por recibir.

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30), @Cod_Mat nvarchar(10)

Set @FechaIS = CONVERT(DATE, (SELECT DATEADD(MM, -5, GETDATE())), 102)
Set @FechaFS = CONVERT (DATE, GETDATE()) 

 Set @Cod_Mat = '12741'         --  ADHESIVO "IRIS" K-812 NO FLAMABLE

-- Con esta consulta se obtiene el material entregado por almacen de Materias Primas a WIP de hoy a 5
-- Meses hacia atras. Todas las salidas del Almacen de Materias Primas Localidad L101_GENERAL.
-- Minimo consumo diario por 7 dias.
-- Punto Reorden Consumo diario * LET TIME + Minimo
-- Maximo Minimo mas PR mas consumo de 7 dias.
-- Integras Consumo Diario al Reporte de Max Min

-- Para Existencia se toman las siguientes localidades 'L101_GENERAL', 'L212_HULES', 'L214_HERRAMIENTAS'
-- 'L222_LACA', 'L223_MADERAS'

-- Para identificar los articulos que se manejan mediante Maximos y Minimos se toma que la cantidad capturada en Muliix 
-- como Minimo sea mayor de 1 y ya que se actualice a que queden en cero las capturas sera entonces Minimo > 0

-- Relacion de Articulos que se requieren por Maximos y Minimos
Select ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS DESCRPCION
	, CMUM_Nombre AS UDM
	, Convert(Decimal(14,3), ISNULL(E.EXI_Inventario,0)) AS EXISTENCIA
	, Convert(Decimal(14,3), ISNULL(ART_CantMaximaOrden, 0)) as MAXIMO
	, Convert(Decimal(14,3), ISNULL((K.CCD_Consumo * 7) + (K.CCD_Consumo * ART_NoDiasAbastecimiento), 0)) AS PUN_REO
	, Convert(Decimal(14,3), ISNULL(ART_CantMinimaOrden, 0)) as MINIMO
	, Convert(Decimal(14,3), ISNULL(OC_OPN.CANT_PEND, 0)) AS OC_SURTIR

	, Convert(Decimal(14,3), ISNULL(ART_NoDiasAbastecimiento, 0)) AS LED_TIME
	, Convert(Decimal(14,3), ISNULL(K.CCD_Consumo, 0)) AS CONS_DIA
	, Convert(Decimal(14,3), ISNULL(K.CCD_Consumo * 7, 0)) AS STK_MIN
	, Convert(Decimal(14,3), ISNULL((K.CCD_Consumo *14) + (K.CCD_Consumo * ART_NoDiasAbastecimiento), 0)) AS STK_MAX
FROM Articulos
inner join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId

Left Join (Select A1.ART_CodigoArticulo AS CCD_Codigo, Convert(Decimal(14,3), ((SUM(TRAM_CantidadATraspasar)*-1)/152)) AS CCD_Consumo
FROM TraspasosMovtos
Inner Join TraspasosLotes on TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
Inner Join LotesLocalidades on LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
Inner Join Localidades on LOC_LocalidadId = LOTL_LOC_LocalidadId
Inner Join Articulos A1 on TRAM_ART_ArticuloId = A1.ART_ArticuloId
Inner Join ControlesMaestrosMultiples on CMM_ControlId =  TRAM_CMM_TipoTransferenciaId
Where  Cast(TRAM_FechaTraspaso as date) Between @FechaIS and @FechaFS 
and CMM_Control = 'CMM_CDA_MovimientoEnInventario' and LOC_CodigoLocalidad = 'L101_GENERAL' and TRLOT_CantidadTraspaso < 0
Group By  A1.ART_CodigoArticulo ) K on K.CCD_Codigo = ART_CodigoArticulo

Left Join (Select	T1.ART_CodigoArticulo as EXI_Codigo, Convert(Decimal(28,4),SUM(T0.LOCA_Cantidad)) as EXI_Inventario 
from LocalidadesArticulo T0
inner join Articulos T1 on T1.ART_ArticuloId = T0.LOCA_ART_ArticuloId 
Inner join Localidades T2 on T0.LOCA_LOC_LocalidadId = T2.LOC_LocalidadId 
Where (LOC_CodigoLocalidad = 'L101_GENERAL' or  LOC_CodigoLocalidad = 'L212_HULES' or  LOC_CodigoLocalidad = 'L214_HERRAMIENTAS'
or  LOC_CodigoLocalidad = 'L222_LACA' or  LOC_CodigoLocalidad = 'L223_MADERAS')
Group By T1.ART_CodigoArticulo) E on E.EXI_Codigo = ART_CodigoArticulo

Left join (Select OC_ABI.ID AS ID_ART, (SUM(OC_ABI.CANT_SOL) - SUM(OC_ABI.CANT_REC)) AS CANT_PEND
From (Select	ART_CodigoArticulo AS ID, SUM(OCFR_CantidadRequerida) AS CANT_SOL, SUM(OCRC_CantidadRecibo) as CANT_REC
from OrdenesCompraRecibos
inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId
inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId
inner join Articulos on ART_ArticuloId = OCD_ART_ArticuloId
where OCFR_Borrado = 0 and OCD_Borrado = 0 and OC_Borrado = 0
Group By ART_CodigoArticulo
Having (SUM(OCFR_CantidadRequerida) - SUM(OCRC_CantidadRecibo)) > 0
) OC_ABI Group By OC_ABI.ID) OC_OPN  on OC_OPN.ID_ART = ART_CodigoArticulo

Where ART_CantMinimaOrden > 1 
Order By ART_Nombre

/*
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


Select top(10) * from TraspasosMovtos Where TRAM_ART_ArticuloId = 'BDB20AAC-77A9-4E45-9C23-B4EA33A710EE'
Order By TRAM_FechaTraspaso

Select * from ControlesMaestrosMultiples 
Where CMM_Control = 'CMM_CDA_MovimientoEnInventario'
--Where CMM_ControlID = '39B95B52-F380-40E0-B543-F132A769E819'
Where CMM_ControlID = 'D7D22076-0400-4C59-B88E-1AA98C910B9F'


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

-- Reporte de Ordenes de Compras Abiertas.
Select	OC_OrdenCompraId AS ID
	, OC_CodigoOC as OC
	, ART_CodigoArticulo AS CODIGO 
	, ART_Nombre AS DESCRIPCION
	, OCD_CMUM_UMCompras as UMC
	, SUM(OCFR_CantidadRequerida) AS CANT_SOL
	, SUM(OCRC_CantidadRecibo) as CANT_REC
from OrdenesCompraRecibos
inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId
inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId
inner join Articulos on ART_ArticuloId = OCD_ART_ArticuloId
where OCFR_Borrado = 0 and OCD_Borrado = 0 and OC_Borrado = 0
Group By OC_OrdenCompraId, OC_CodigoOC, ART_CodigoArticulo, ART_Nombre, OCD_CMUM_UMCompras
Having (SUM(OCFR_CantidadRequerida) - SUM(OCRC_CantidadRecibo)) > 0

*/


