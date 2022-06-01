-- Consulta para comparativo de Cotizaciones
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 24 de Mayo del 2022; Origen

-- Parametros
Declare @OT_Code as nvarchar(30)
Declare @OT_Inic as nvarchar(30)
Declare @OT_Tope as nvarchar(30)

Set @OT_Code = 'OT02449'
Set @OT_Inic = 'OT02482'
Set @OT_Tope = 'OT02491'

/* -- Consulta de OT
Select OT_Codigo
		, ART_CodigoArticulo
		, ART_Nombre
		, OTDA_Cantidad AS CANT
		, ISNULL(OT_COT_MAT, 0) AS MAT
		, ISNULL(OT_COT_MOB, 0) AS MOB
		, ISNULL(OT_COT_IND, 0) AS IND
		, ISNULL(OT_COT_VEN, 0) AS VEN
		, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) AS ESTATUS
 from OrdenesTrabajo
 Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
 Inner Join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
 Where OT_Codigo BETWEEN @OT_Inic AND @OT_Tope 
 --Where ART_CodigoArticulo = '1693.3-02'
 Order By OT_Codigo

 -- Subir Informacion a Muliix
 --Update OrdenesTrabajo Set OT_COT_MAT = 300, OT_COT_MOB = 25000, OT_COT_IND = 400, OT_COT_VEN = 55000 Where OT_Codigo = 'OT02449'

*/


-- Consulta de Marteriales Cargados a la OT (REAL)

Select  OT_Codigo as OT
        , Convert(Decimal(16,3), SUM((OTARA_Cantidad * (LPC_PrecioCompra / AFC_FactorConversion)))) AS IMPORTE 
from OrdenesTrabajo
inner join OrdenesTrabajoAsignacionRecursosArticulos on OT_OrdenTrabajoId = OTARA_OT_OrdenTrabajoId
inner join Articulos A1 on A1.ART_ArticuloId = OTARA_ART_ArticuloId
left join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion on A1.ART_ArticuloId =AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
Where  OT_Codigo = @OT_Code
Group By OT_Codigo

-- Consulta de Tiempos por OT (Real)

Select  OT_Codigo as OT    
        , SUM((DATEPART(SECOND, [OTSOD_TiempoTotal])) + 
                                 (60 * DATEPART(MINUTE, [OTSOD_TiempoTotal])) +
                                 (3600 * DATEPART(HOUR, [OTSOD_TiempoTotal]))) AS TOTAL_SEC 
from OrdenesTrabajo
inner join OrdenesTrabajoSeguimiento on OT_OrdenTrabajoId = OTS_OT_OrdenTrabajoId
inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajoSeguimientoOperacionDetalle on OTSO_OrdenTrabajoSeguimientoOperacionId = OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId
Where  OT_Codigo = @OT_Code
Group By OT_Codigo

-- Importe total del la LDM (Ingenieria)
Select	@OT_Code AS OT
		,  Convert(Decimal(16,3), SUM(EAR_CantidadEnsamble * ISNULL((LPC_PrecioCompra / AFC_FactorConversion), 0))) AS IMPORTE
from EstructurasArticulos 
inner join Articulos on EAR_ART_ComponenteId = ART_ArticuloId 
inner join ArticulosFactoresConversion on ART_ArticuloId =AFC_ART_ArticuloId and ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
left join ListaPreciosCompra on ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
Where EAR_ART_ArticuloPadreId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)

-- Mano de Obra Ruta (Ingenieria)
SELECT @OT_Code AS OT
	, SUM(ROUND(ISNULL(FAD_Horas, 0.0) + CAST(ISNULL(FAD_Minutos, 0.0) AS DECIMAL(28,10)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) AS DECIMAL(28,10)) / 3600, 6)) * 1 AS TiempoEstandar
FROM Fabricacion
INNER JOIN FabricacionEstructura ON FAB_FabricacionId = FAE_FAB_FabricacionId AND FAE_Eliminado = 0
INNER JOIN FabricacionDetalle ON FAE_EstructuraId = FAD_FAE_EstructuraId AND FAD_Eliminado = 0
left Join CentrosTrabajo on CET_CentroTrabajoId=FAD_ReferenciaId
INNER JOIN Articulos ON FAB_ART_ArticuloId = ART_ArticuloId
WHERE FAB_Eliminado = 0 
AND ART_ArticuloId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)


-- Consulta que me envio Jorge para las Rutas
/*
SELECT
      FAE_EstructuraId
    , ART_ArticuloId
    , FAE_Codigo
	, '(' + UPPER(FAE_Codigo) + ') - ' + UPPER(FAE_Descripcion) AS Descripcion
	,TiempoEstandarSC
	,TiempoEstandar
	, CASE WHEN FAE_Nivel = 0 THEN SUM(TiempoEstandar)
	   ELSE 0 END AS SUMTiemEst
	, '' AS CENTROTRABAJO
FROM Fabricacion
INNER JOIN FabricacionEstructura ON FAB_FabricacionId = FAE_FAB_FabricacionId AND FAE_Eliminado = 0
INNER JOIN Articulos ON FAB_ART_ArticuloId = ART_ArticuloId
LEFT  JOIN (
			SELECT
				  FAE_PadreInmediatoId AS ID_PADRE
				--, SUM(ROUND(ISNULL(FAD_Horas, 0.0) + CAST(ISNULL(FAD_Minutos, 0.0) AS DECIMAL(28,10)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) AS DECIMAL(28,10)) / 3600, 6)) AS TiempoEstandar
				, CAST(SUM(FAD_Horas) AS VARCHAR) + ':' + CAST(SUM(FAD_Minutos) AS VARCHAR) + ':' + CAST(SUM(CAST(FAD_Segundos AS decimal(28,3))) AS VARCHAR) AS TiempoEstandarSC
			    , SUM(ROUND(ISNULL(FAD_Horas, 0.0) + CAST(ISNULL(FAD_Minutos, 0.0) AS DECIMAL(28,10)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) AS DECIMAL(28,10)) / 3600, 6)) * $P{Cantidad_Trabajada} AS TiempoEstandar
			FROM FabricacionEstructura
			INNER JOIN FabricacionDetalle ON FAE_EstructuraId = FAD_FAE_EstructuraId AND FAD_Eliminado = 0
			WHERE FAE_Eliminado = 0 AND FAE_Nivel > 0
			GROUP BY FAE_PadreInmediatoId
		   ) AS TIEMPOS ON FAE_EstructuraId = ID_PADRE
WHERE FAB_Eliminado = 0 AND FAE_Nivel = 0
--AND ART_ArticuloId = '928F2952-C7F1-4B15-9C25-D7A1F5BC0127' --Articulo
AND ART_ArticuloId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)
GROUP BY
FAE_EstructuraId,
ART_ArticuloId,
FAE_Codigo,
FAE_Descripcion,
TiempoEstandar,
ID_PADRE,
TiempoEstandarSC,
FAE_Nivel
--ORDER BY
--FAE_Codigo

--UNION ALL

SELECT
    FAE_EstructuraId
    , ART_ArticuloId
    , FAE_Codigo
	, '(' + UPPER(FAE_Codigo) + ') - ' + UPPER(FAE_Descripcion) AS Descripcion
	, CAST(SUM(FAD_Horas) AS VARCHAR) + ':' + CAST(SUM(FAD_Minutos) AS VARCHAR) + ':' + CAST(SUM(CAST(FAD_Segundos AS decimal(28,3))) AS VARCHAR) AS TiempoEstandarSC
	, SUM(ROUND(ISNULL(FAD_Horas, 0.0) + CAST(ISNULL(FAD_Minutos, 0.0) AS DECIMAL(28,10)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) AS DECIMAL(28,10)) / 3600, 6)) * 1 AS TiempoEstandar
	, 0
	, CET_Nombre
FROM Fabricacion
INNER JOIN FabricacionEstructura ON FAB_FabricacionId = FAE_FAB_FabricacionId AND FAE_Eliminado = 0
INNER JOIN FabricacionDetalle ON FAE_EstructuraId = FAD_FAE_EstructuraId AND FAD_Eliminado = 0
left Join CentrosTrabajo on CET_CentroTrabajoId=FAD_ReferenciaId
INNER JOIN Articulos ON FAB_ART_ArticuloId = ART_ArticuloId
WHERE FAB_Eliminado = 0 --AND FAE_Nivel = 0
--AND ART_ArticuloId = '928F2952-C7F1-4B15-9C25-D7A1F5BC0127' --Articulo
AND ART_ArticuloId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)

--AND FAE_PadreInmediatoId = 'DA901644-9A13-4B6A-8961-635375B8B26D'
GROUP BY
FAE_EstructuraId,
ART_ArticuloId,
FAE_Codigo,
FAE_Descripcion,
CET_Nombre,
FAE_PadreInmediatoId,
FAE_Nivel
--TiempoEstandarSC
ORDER BY
FAE_Codigo



SELECT
    FAE_EstructuraId
    , ART_ArticuloId
    , FAE_Codigo
	, '(' + UPPER(FAE_Codigo) + ') - ' + UPPER(FAE_Descripcion) AS Descripcion
	, CAST(SUM(FAD_Horas) AS VARCHAR) + ':' + CAST(SUM(FAD_Minutos) AS VARCHAR) + ':' + CAST(SUM(CAST(FAD_Segundos AS decimal(28,3))) AS VARCHAR) AS TiempoEstandarSC
	, SUM(ROUND(ISNULL(FAD_Horas, 0.0) + CAST(ISNULL(FAD_Minutos, 0.0) AS DECIMAL(28,10)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) AS DECIMAL(28,10)) / 3600, 6)) * 1 AS TiempoEstandar
	, 0
	, CET_Nombre
FROM Fabricacion
INNER JOIN FabricacionEstructura ON FAB_FabricacionId = FAE_FAB_FabricacionId AND FAE_Eliminado = 0
INNER JOIN FabricacionDetalle ON FAE_EstructuraId = FAD_FAE_EstructuraId AND FAD_Eliminado = 0
left Join CentrosTrabajo on CET_CentroTrabajoId=FAD_ReferenciaId
INNER JOIN Articulos ON FAB_ART_ArticuloId = ART_ArticuloId
WHERE FAB_Eliminado = 0 --AND FAE_Nivel = 0
--AND ART_ArticuloId = '928F2952-C7F1-4B15-9C25-D7A1F5BC0127' --Articulo
AND ART_ArticuloId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)

--AND FAE_PadreInmediatoId = 'DA901644-9A13-4B6A-8961-635375B8B26D'
GROUP BY
FAE_EstructuraId,
ART_ArticuloId,
FAE_Codigo,
FAE_Descripcion,
CET_Nombre,
FAE_PadreInmediatoId,
FAE_Nivel
--TiempoEstandarSC
ORDER BY
FAE_Codigo

*/

