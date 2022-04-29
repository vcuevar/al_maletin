-- Consulta para calculo del Punto de Reorden.
-- Ing. Vicente Cueva R.
-- Actualizado: Jueves 28 de Abril del 2022; Origen.

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)

Set @FechaIS = CONVERT(DATE, (SELECT DATEADD(MM, -5, GETDATE())), 102)
Set @FechaFS = CONVERT (DATE, GETDATE()) 

-- Con esta consulta se obtiene el material entregado por almacen de Materias Primas a WIP de hoy a 5
-- Meses hacia atras. Todas las salidas del Almacen de Materias Primas Localidad L101_GENERAL.

Select Cast(TRAM_FechaTraspaso as date) AS FEC_TRASP
	, ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS DESCRPCION
	, Convert(Decimal(14,3), TRAM_CantidadATraspasar) AS CANTIDAD
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
and ART_CodigoArticulo = '01457'
and LOC_CodigoLocalidad = 'L101_GENERAL'
and TRLOT_CantidadTraspaso < 0
Order By TRAM_FechaTraspaso 

-- 00233	MULTIPLAY CAOBILLA 03 MM 4 X 8 MERATI BENGAL (2.5)
-- 01457	LIJA BANDA 8" DE ANCHO X 2.55MTS LARGO  080°
	
/*
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


