-- PIXVS Consulta para 023 Reporte de Recibos de Producción.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Actualizado: Lunes 17 de Septiembre del 2018; Origen
-- Actualizado: Sabado 22 de Septiembre del 2018; Desarrollo Consulta.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2019-03-01', 102)
Set @FechaFS = CONVERT (DATE, '2019-03-06', 102) 

Select *
from
(Select	Top 1 'SIN_REG' AS VAL_RBV,
		OTR_FechaRecibo AS F_RECIBO,
		OT_Codigo AS NUM_OT,
		ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = PR_ID ), 'SIN_RELACION') AS PROYECTO,
		ISNULL((Select ART_CodigoArticulo + '   ' + ART_Nombre from Articulos Where ART_ArticuloId = AR_ID), 'SIN RELACION') AS ARTICULO,
		OTRD_CantidadRecibo AS CANT,
		ISNULL(OV_CD, 'SIN RELACION') AS OV_RBV,
		ISNULL((Select OVR_PrecioUnitario from OrdenesVentaReq where OVR_OVDetalleId = OVD_ID), 0) AS P_VENTA,
		ISNULL((Select MON_Nombre from Monedas Where MON_MonedaId = (Select OV_MON_Monedaid from OrdenesVenta where OV_OrdenVentaId = OV_ID)),'S/REL') AS MONEDA,
		ISNULL((Select OV_MONP_Paridad from OrdenesVenta where OV_OrdenVentaId = OV_ID), 0) AS PARIDAD
from OrdenesTrabajoRecibo
inner join OrdenesTrabajoReciboDetalle on OTR_OrdenTrabajoReciboId = OTRD_OTR_OrdenTrabajoReciboId
inner join OrdenesTrabajo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId
left join RBV_OT on OTR_OT_OrdenTrabajoId = OT_ID
Union All
Select	'VAL_REG' AS VAL_RBV,
		OTR_FechaUltimaModificacion AS F_RECIBO,
		OT_Codigo AS NUM_OT,
		ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = PR_ID ), 'SIN_RELACION') AS PROYECTO,
		ISNULL((Select ART_CodigoArticulo + '   ' + ART_Nombre from Articulos Where ART_ArticuloId = AR_ID), 'SIN RELACION') AS ARTICULO,
		OTRD_CantidadRecibo AS CANT,
		ISNULL(OV_CD, 'SIN RELACION') AS OV_RBV,
		ISNULL((Select OVR_PrecioUnitario from OrdenesVentaReq where OVR_OVDetalleId = OVD_ID), 0) AS P_VENTA,
		ISNULL((Select MON_Nombre from Monedas Where MON_MonedaId = (Select OV_MON_Monedaid from OrdenesVenta where OV_OrdenVentaId = OV_ID)),'S/REL') AS MONEDA,
		ISNULL((Select OV_MONP_Paridad from OrdenesVenta where OV_OrdenVentaId = OV_ID), 0) AS PARIDAD
from OrdenesTrabajoRecibo
inner join OrdenesTrabajoReciboDetalle on OTR_OrdenTrabajoReciboId = OTRD_OTR_OrdenTrabajoReciboId
inner join OrdenesTrabajo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId
left join RBV_OT on OTR_OT_OrdenTrabajoId = OT_ID
where Cast(OTR_FechaUltimaModificacion As Date) BETWEEN @FechaIS and @FechaFS) T0
Order by T0.VAL_RBV, Cast(T0.F_RECIBO As Date)


/*
Select	'VAL_REG' AS VAL_RBV, OTR_FechaUltimaModificacion AS F_RECIBO, OT_Codigo AS NUM_OT, ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = PR_ID ), 'SIN_RELACION') AS PROYECTO, ISNULL((Select ART_CodigoArticulo + '   ' + ART_Nombre from Articulos Where ART_ArticuloId = AR_ID), 'SIN RELACION') AS ARTICULO, OTRD_CantidadRecibo AS CANT, ISNULL(OV_CD, 'SIN RELACION') AS OV_RBV, ISNULL((Select OVR_PrecioUnitario from OrdenesVentaReq where OVR_OVDetalleId = OVD_ID), 0) AS P_VENTA,
ISNULL((Select MON_Nombre from Monedas Where MON_MonedaId = (Select OV_MON_Monedaid from OrdenesVenta where OV_OrdenVentaId = OV_ID)),'S/REL') AS MONEDA, ISNULL((Select OV_MONP_Paridad from OrdenesVenta where OV_OrdenVentaId = OV_ID), 0) AS PARIDAD from OrdenesTrabajoRecibo inner join OrdenesTrabajoReciboDetalle on OTR_OrdenTrabajoReciboId = OTRD_OTR_OrdenTrabajoReciboId inner join OrdenesTrabajo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId left join RBV_OT on OTR_OT_OrdenTrabajoId = OT_ID where Cast(OTR_FechaUltimaModificacion As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' Order by Cast(OTR_FechaUltimaModificacion As Date) 
*/