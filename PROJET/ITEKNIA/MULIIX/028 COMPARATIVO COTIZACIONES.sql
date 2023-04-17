-- Consulta para comparativo de Cotizaciones
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 24 de Mayo del 2022; Origen
-- Actualizado: Miercoles 07 de Septiembre 2022; Precio de Materiales uso Moneda dolar.

-- Parametros
Declare @OT_Code as nvarchar(30)
Declare @OT_Inic as nvarchar(30)
Declare @OT_Tope as nvarchar(30)
Declare @MO_Hora as Decimal(16,3)

Set @OT_Code = 'OT02422'
Set @OT_Inic = 'OT02422'
Set @OT_Tope = 'OT02422'
Set @MO_Hora = 72.60

/*
-- Consulta de OT por Rango con para capturar Importes de Cotizacion
Select OT_Codigo
    , A3.ART_CodigoArticulo
	, A3.ART_Nombre
	, (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) AS PROYECTO
	, OTDA_Cantidad AS CANT
	, ISNULL(OT_COT_MAT, 0) AS MAT
	, ISNULL(OT_COT_MOB, 0) AS MOB	
	, ISNULL(OT_COT_IND, 0) AS IND
	, ISNULL(OT_COT_VEN, 0) AS VEN
	, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) AS ESTATUS
from OrdenesTrabajo
Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
Inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId
Inner Join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Inner Join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
Inner Join Proyectos on  PRY_ProyectoId = OV_PRO_ProyectoId
Where OT_Codigo BETWEEN @OT_Inic AND @OT_Tope 
Order By OT_Codigo

-- Subir Informacion a Muliix
--Update OrdenesTrabajo Set OT_COT_MAT = 300, OT_COT_MOB = 25000, OT_COT_IND = 400, OT_COT_VEN = 55000 Where OT_Codigo = 'OT02449'
*/

-- Consulta OT Comparaciones Cotizacion - Ingenieria - Real 
Select O1.OT_Codigo 
    , A3.ART_CodigoArticulo 
	, A3.ART_Nombre
	, (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) AS PROYECTO
	, OTDA_Cantidad AS CANT
	, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS CT_MAT
	, Convert(Decimal(16,3), ISNULL(OT_COT_MOB, 0)) AS CT_HOM	
	, Convert(Decimal(16,3), ISNULL(QMP.MP_INGE, 0)) AS ING_MAT
	, Convert(Decimal(16,3), ISNULL(WMO.MO_INGE, 0)) AS ING_HOB
	, Convert(Decimal(16,3), ISNULL(SUM(EMP.MP_REAL), 0)) AS REA_MAT
	, Convert(Decimal(16,3), ISNULL(RMO.MO_REAL, 0)) AS REA_HOB
	, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) AS ESTATUS
from OrdenesTrabajo O1
Inner Join OrdenesTrabajoDetalleArticulos on O1.OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
Inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId
Inner Join OrdenesTrabajoReferencia on O1.OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Inner Join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
Inner Join Proyectos on  PRY_ProyectoId = OV_PRO_ProyectoId
LEFT JOIN (Select	Q1.ART_ArticuloId AS ID_PT
, Convert(Decimal(16,3), SUM(Q2.EAR_CantidadEnsamble * ISNULL((Q5.LPC_PrecioCompra / Q4.AFC_FactorConversion), 0))) AS MP_INGE
from Articulos Q1
INNER JOIN EstructurasArticulos Q2  on Q1.ART_ArticuloId  = Q2.EAR_ART_ArticuloPadreId 
INNER JOIN Articulos Q3 on Q3.ART_ArticuloId = Q2.EAR_ART_ComponenteId
INNER JOIN ArticulosFactoresConversion Q4 on Q3.ART_ArticuloId = Q4.AFC_ART_ArticuloId and Q3.ART_CMUM_UMConversionOCId = Q4.AFC_CMUM_UnidadMedidaId  
LEFT JOIN ListaPreciosCompra Q5 on Q3.ART_ArticuloId = Q5.LPC_ART_ArticuloId and Q5.LPC_ProvPreProgramado = 1
Group By Q1.ART_ArticuloId, Q1.ART_CodigoArticulo, Q1.ART_Nombre ) QMP on A3.ART_ArticuloId = QMP.ID_PT
LEFT JOIN (Select W1.ART_ArticuloId AS ID_ART
	, SUM(CAST(ISNULL(FAD_Horas, 0.0) as decimal(16,3))  + CAST(ISNULL(FAD_Minutos, 0.0) as decimal(16,3)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) as decimal(16,3)) / 3600) AS MO_INGE
FROM Articulos W1
INNER JOIN Fabricacion W2 ON  W1.ART_ArticuloId = W2.FAB_ART_ArticuloId
INNER JOIN FabricacionEstructura W3 ON W2.FAB_FabricacionId = W3.FAE_FAB_FabricacionId AND W3.FAE_Eliminado = 0
INNER JOIN FabricacionDetalle W4 ON W3.FAE_EstructuraId = W4.FAD_FAE_EstructuraId AND W4.FAD_Eliminado = 0
Group By W1.ART_ArticuloId, W1.ART_CodigoArticulo, W1.ART_Nombre) WMO on A3.ART_ArticuloId = WMO.ID_ART
LEFT JOIN (Select  E1.OT_Codigo
	, ISNULL(Convert(Decimal(16,3), SUM((OTARA_Cantidad * (LPC_PrecioCompra / AFC_FactorConversion)))* (Case When LPC_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3' then 
              (select MONP_TipoCambioOficial from MonedasParidad where Cast(MONP_FechaInicio as Date) = CONVERT (date, GETDATE()) and MONP_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3')
              Else 1 End)), 0) AS MP_REAL
from OrdenesTrabajo E1
inner join OrdenesTrabajoAsignacionRecursosArticulos E2 on E1.OT_OrdenTrabajoId = E2.OTARA_OT_OrdenTrabajoId
inner join Articulos E3 on E2.OTARA_ART_ArticuloId = E3.ART_ArticuloId
left join ListaPreciosCompra E4 on E3.ART_ArticuloId = E4.LPC_ART_ArticuloId and E4.LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion E5 on E3.ART_ArticuloId = E5.AFC_ART_ArticuloId and E3.ART_CMUM_UMConversionOCId = E5.AFC_CMUM_UnidadMedidaId  
Group By E1.OT_Codigo,LPC_MON_MonedaId) EMP on O1.OT_Codigo = EMP.OT_Codigo
LEFT JOIN (Select  R1.OT_Codigo as OT    
		, CAST((SUM(DATEPART(HOUR, [OTSOD_TiempoTotal])) +	(SUM(DATEPART(MI, [OTSOD_TiempoTotal])) / 60) +
		(SUM(DATEPART(SECOND, [OTSOD_TiempoTotal])) / 3600)) as decimal(16,3)) AS MO_REAL 
from OrdenesTrabajo R1
inner join OrdenesTrabajoSeguimiento R2 on R1.OT_OrdenTrabajoId = R2.OTS_OT_OrdenTrabajoId
inner join OrdenesTrabajoSeguimientoOperacion R3 on R2.OTS_OrdenesTrabajoSeguimientoId = R3.OTSO_OTS_OrdenesTrabajoSeguimientoId  
inner join OrdenesTrabajoSeguimientoOperacionDetalle R4 on  R3.OTSO_OrdenTrabajoSeguimientoOperacionId = R4.OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId 
Group By OT_Codigo) RMO on O1.OT_Codigo = RMO.OT
Where O1.OT_Codigo BETWEEN @OT_Inic AND @OT_Tope 
Group By O1.OT_Codigo, A3.ART_CodigoArticulo, A3.ART_Nombre, PRY_CodigoEvento, PRY_NombreProyecto, OTDA_Cantidad,
OT_COT_MAT, OT_COT_MOB, QMP.MP_INGE, WMO.MO_INGE, RMO.MO_REAL, OT_CMM_Estatus
Order By O1.OT_Codigo

-- Para Montar a la Macro

Select O1.OT_Codigo, A3.ART_CodigoArticulo, A3.ART_Nombre, (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) AS PROYECTO, OTDA_Cantidad AS CANT, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS CT_MAT, Convert(Decimal(16,3), ISNULL(OT_COT_MOB, 0)) AS CT_HOM, Convert(Decimal(16,3), ISNULL(QMP.MP_INGE, 0)) AS ING_MAT, Convert(Decimal(16,3), ISNULL(WMO.MO_INGE, 0)) AS ING_HOB, Convert(Decimal(16,3), ISNULL(SUM(EMP.MP_REAL), 0)) AS REA_MAT, Convert(Decimal(16,3), ISNULL(RMO.MO_REAL, 0)) AS REA_HOB, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) AS ESTATUS from OrdenesTrabajo O1 Inner Join OrdenesTrabajoDetalleArticulos on O1.OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId Inner Join OrdenesTrabajoReferencia on O1.OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Inner Join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId Inner Join Proyectos on  PRY_ProyectoId = OV_PRO_ProyectoId LEFT JOIN (Select	Q1.ART_ArticuloId AS ID_PT, Convert(Decimal(16,3), SUM(Q2.EAR_CantidadEnsamble * ISNULL((Q5.LPC_PrecioCompra / Q4.AFC_FactorConversion), 0))) AS MP_INGE from Articulos Q1 INNER JOIN EstructurasArticulos Q2  on Q1.ART_ArticuloId  = Q2.EAR_ART_ArticuloPadreId INNER JOIN Articulos Q3 on Q3.ART_ArticuloId = Q2.EAR_ART_ComponenteId INNER JOIN ArticulosFactoresConversion Q4 on Q3.ART_ArticuloId = Q4.AFC_ART_ArticuloId and Q3.ART_CMUM_UMConversionOCId = Q4.AFC_CMUM_UnidadMedidaId LEFT JOIN ListaPreciosCompra Q5 on Q3.ART_ArticuloId = Q5.LPC_ART_ArticuloId and Q5.LPC_ProvPreProgramado = 1 Group By Q1.ART_ArticuloId, Q1.ART_CodigoArticulo, Q1.ART_Nombre ) QMP on A3.ART_ArticuloId = QMP.ID_PT 
LEFT JOIN (Select W1.ART_ArticuloId AS ID_ART, SUM(CAST(ISNULL(FAD_Horas, 0.0) as decimal(16,3))  + CAST(ISNULL(FAD_Minutos, 0.0) as decimal(16,3)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) as decimal(16,3)) / 3600) AS MO_INGE FROM Articulos W1 INNER JOIN Fabricacion W2 ON  W1.ART_ArticuloId = W2.FAB_ART_ArticuloId INNER JOIN FabricacionEstructura W3 ON W2.FAB_FabricacionId = W3.FAE_FAB_FabricacionId AND W3.FAE_Eliminado = 0 INNER JOIN FabricacionDetalle W4 ON W3.FAE_EstructuraId = W4.FAD_FAE_EstructuraId AND W4.FAD_Eliminado = 0 Group By W1.ART_ArticuloId, W1.ART_CodigoArticulo, W1.ART_Nombre) WMO on A3.ART_ArticuloId = WMO.ID_ART LEFT JOIN (Select  E1.OT_Codigo, ISNULL(Convert(Decimal(16,3), SUM((OTARA_Cantidad * (LPC_PrecioCompra / AFC_FactorConversion)))* (Case When LPC_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3' then 
(select MONP_TipoCambioOficial from MonedasParidad where Cast(MONP_FechaInicio as Date) = CONVERT (date, GETDATE()) and MONP_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3') Else 1 End)), 0) AS MP_REAL from OrdenesTrabajo E1 inner join OrdenesTrabajoAsignacionRecursosArticulos E2 on E1.OT_OrdenTrabajoId = E2.OTARA_OT_OrdenTrabajoId inner join Articulos E3 on E2.OTARA_ART_ArticuloId = E3.ART_ArticuloId left join ListaPreciosCompra E4 on E3.ART_ArticuloId = E4.LPC_ART_ArticuloId and E4.LPC_ProvPreProgramado = 1 inner join ArticulosFactoresConversion E5 on E3.ART_ArticuloId = E5.AFC_ART_ArticuloId and E3.ART_CMUM_UMConversionOCId = E5.AFC_CMUM_UnidadMedidaId  Group By E1.OT_Codigo,LPC_MON_MonedaId) EMP on O1.OT_Codigo = EMP.OT_Codigo LEFT JOIN (Select  R1.OT_Codigo as OT, CAST((SUM(DATEPART(HOUR, [OTSOD_TiempoTotal])) +
(SUM(DATEPART(MI, [OTSOD_TiempoTotal])) / 60) + (SUM(DATEPART(SECOND, [OTSOD_TiempoTotal])) / 3600)) as decimal(16,3)) AS MO_REAL from OrdenesTrabajo R1 inner join OrdenesTrabajoSeguimiento R2 on R1.OT_OrdenTrabajoId = R2.OTS_OT_OrdenTrabajoId inner join OrdenesTrabajoSeguimientoOperacion R3 on R2.OTS_OrdenesTrabajoSeguimientoId = R3.OTSO_OTS_OrdenesTrabajoSeguimientoId inner join OrdenesTrabajoSeguimientoOperacionDetalle R4 on  R3.OTSO_OrdenTrabajoSeguimientoOperacionId = R4.OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId Group By OT_Codigo) RMO on O1.OT_Codigo = RMO.OT Where O1.OT_Codigo BETWEEN @OT_Inic AND @OT_Tope Group By O1.OT_Codigo, A3.ART_CodigoArticulo, A3.ART_Nombre, PRY_CodigoEvento, PRY_NombreProyecto, OTDA_Cantidad, OT_COT_MAT, OT_COT_MOB, QMP.MP_INGE, WMO.MO_INGE, RMO.MO_REAL, OT_CMM_Estatus Order By O1.OT_Codigo


/*
-- ORIGEN SEPARADOS ANTERIOR SE CONJUGAN TODAS
-- Consulta OT Comparaciones Cotizacion - Ingenieria - Real 
Select OT_Codigo 
    , A3.ART_CodigoArticulo 
	, A3.ART_Nombre
	, (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) AS PROYECTO
	, OTDA_Cantidad AS CANT
	, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS CT_MAT
	, Convert(Decimal(16,3), ISNULL(OT_COT_MOB, 0)) AS CT_MOB	

	, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS ING_MAT
	, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS ING_MOB

	, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS REA_MAT
	, Convert(Decimal(16,3), ISNULL(OT_COT_MAT, 0)) AS REA_MOB

	, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) AS ESTATUS
from OrdenesTrabajo
Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
Inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId
Inner Join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Inner Join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
Inner Join Proyectos on  PRY_ProyectoId = OV_PRO_ProyectoId

Where OT_Codigo BETWEEN @OT_Inic AND @OT_Tope 
Order By OT_Codigo

-- Tabla de Importe total del la LDM (Ingenieria)
Select	Q1.ART_ArticuloId AS ID_PT
	, Q1.ART_CodigoArticulo AS COD_PT
	, Q1.ART_Nombre
     , Convert(Decimal(16,3), SUM(Q2.EAR_CantidadEnsamble * ISNULL((Q5.LPC_PrecioCompra / Q4.AFC_FactorConversion), 0))) AS MP_INGE
from Articulos Q1
INNER JOIN EstructurasArticulos Q2  on Q1.ART_ArticuloId  = Q2.EAR_ART_ArticuloPadreId 
INNER JOIN Articulos Q3 on Q3.ART_ArticuloId = Q2.EAR_ART_ComponenteId
INNER JOIN ArticulosFactoresConversion Q4 on Q3.ART_ArticuloId = Q4.AFC_ART_ArticuloId and Q3.ART_CMUM_UMConversionOCId = Q4.AFC_CMUM_UnidadMedidaId  
LEFT JOIN ListaPreciosCompra Q5 on Q3.ART_ArticuloId = Q5.LPC_ART_ArticuloId and Q5.LPC_ProvPreProgramado = 1
Group By Q1.ART_ArticuloId, Q1.ART_CodigoArticulo, Q1.ART_Nombre

-- Tabla para Mano de Obra Ruta (Ingenieria)
Select W1.ART_ArticuloId AS ID_ART
	, W1.ART_CodigoArticulo COD_PT
	, W1.ART_Nombre NOM_PT
	, SUM(CAST(ISNULL(FAD_Horas, 0.0) as decimal(16,3))  + CAST(ISNULL(FAD_Minutos, 0.0) as decimal(16,3)) / 60 + CAST(ISNULL(FAD_Segundos, 0.0) as decimal(16,3)) / 3600) AS MO_INGE
FROM Articulos W1
INNER JOIN Fabricacion W2 ON  W1.ART_ArticuloId = W2.FAB_ART_ArticuloId
INNER JOIN FabricacionEstructura W3 ON W2.FAB_FabricacionId = W3.FAE_FAB_FabricacionId AND W3.FAE_Eliminado = 0
INNER JOIN FabricacionDetalle W4 ON W3.FAE_EstructuraId = W4.FAD_FAE_EstructuraId AND W4.FAD_Eliminado = 0
Group By W1.ART_ArticuloId, W1.ART_CodigoArticulo, W1.ART_Nombre


-- Tabla de Materiales cargados a la OT (REAL)
Select  E1.OT_Codigo
	, Convert(Decimal(16,3), SUM((OTARA_Cantidad * (LPC_PrecioCompra / AFC_FactorConversion)))) AS MP_REAL
from OrdenesTrabajo E1
inner join OrdenesTrabajoAsignacionRecursosArticulos E2 on E1.OT_OrdenTrabajoId = E2.OTARA_OT_OrdenTrabajoId
inner join Articulos E3 on E2.OTARA_ART_ArticuloId = E3.ART_ArticuloId
left join ListaPreciosCompra E4 on E3.ART_ArticuloId = E4.LPC_ART_ArticuloId and E4.LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion E5 on E3.ART_ArticuloId = E5.AFC_ART_ArticuloId and E3.ART_CMUM_UMConversionOCId = E5.AFC_CMUM_UnidadMedidaId  
Group By E1.OT_Codigo


-- Consulta de Tiempos por OT (Real)
Select  R1.OT_Codigo as OT    
		, CAST((SUM(DATEPART(HOUR, [OTSOD_TiempoTotal])) +	(SUM(DATEPART(MI, [OTSOD_TiempoTotal])) / 60) +
		(SUM(DATEPART(SECOND, [OTSOD_TiempoTotal])) / 3600)) as decimal(16,3)) AS MO_REAL 
from OrdenesTrabajo R1
inner join OrdenesTrabajoSeguimiento R2 on R1.OT_OrdenTrabajoId = R2.OTS_OT_OrdenTrabajoId
inner join OrdenesTrabajoSeguimientoOperacion R3 on R2.OTS_OrdenesTrabajoSeguimientoId = R3.OTSO_OTS_OrdenesTrabajoSeguimientoId  
inner join OrdenesTrabajoSeguimientoOperacionDetalle R4 on  R3.OTSO_OrdenTrabajoSeguimientoOperacionId = R4.OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId 
Group By OT_Codigo


*/



