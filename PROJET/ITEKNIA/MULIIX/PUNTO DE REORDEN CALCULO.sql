-- Consulta para calculo del Punto de Reorden.
-- Ing. Vicente Cueva R.
-- Actualizado: Jueves 28 de Abril del 2022; Origen.

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30), @Cod_Mat nvarchar(10)
--@ConXdia decimal(14,3), 

Set @FechaIS = CONVERT(DATE, (SELECT DATEADD(MM, -5, GETDATE())), 102)
Set @FechaFS = CONVERT (DATE, GETDATE()) 
--Set @ConXdia = 0
Set @Cod_Mat = '00233'	-- MULTIPLAY CAOBILLA 03 MM 4 X 8 MERATI BENGAL (2.5)
--Set @Cod_Mat = '01457'	--LIJA BANDA 8" DE ANCHO X 2.55MTS LARGO  080°
--Set @Cod_Mat = '00005'	-- ADHESIVO "IRIS" K-810 S NO FLAMABLE
--Set @Cod_Mat = '00997'	-- TORNILLO 5/16" X 1"  HEXAGONAL GALVANIZADO

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
	, Convert(Decimal(14,3), K.CCD_Consumo * 7) AS STK_MIN
	, Convert(Decimal(14,3), (K.CCD_Consumo * 7) + (K.CCD_Consumo * ART_NoDiasAbastecimiento)) AS PUN_REO
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
and (CMM_Valor ='Salida Producción/WIP' or CMM_Valor = 'Traspaso')
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
Where ART_CodigoArticulo = @Cod_Mat
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
and (CMM_Valor ='Salida Producción/WIP' or CMM_Valor = 'Traspaso')
and LOC_CodigoLocalidad = 'L101_GENERAL'
and TRLOT_CantidadTraspaso < 0
Order By TRAM_FechaTraspaso 


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
and (CMM_Valor ='Salida Producción/WIP' or CMM_Valor = 'Traspaso')
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


