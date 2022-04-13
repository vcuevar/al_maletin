

Select	OV_CodigoOV, 
		OVD_NumeroLinea,
		OVD_ART_Nombre,
		OVD_CMUM_Nombre,
		OVR_CantidadRequerida,
		OTDO_Cantidad,
		OT_Codigo,
		OV_EV_EventoId,
		OT_EV_EventoId
from OrdenesVenta
INNER JOIN OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OrdenVentaId 
INNER JOIN OrdenesVentaReq ON OVR_OVDetalleId = OVD_OVDetalleId AND OV_OrdenVentaId = OVD_OrdenVentaId 
left join OrdenesTrabajoDetalleOVR  on OVR_OVRequeridaId = OTDO_OVR_OVRequeridaId
left join OrdenesTrabajo on OT_OrdenTrabajoId = OTDO_OT_OrdenTrabajoId



Select	OV_CodigoOV, 
		OVD_NumeroLinea,
		OVD_ART_Nombre,
		OVD_CMUM_Nombre,
		OVR_CantidadRequerida,
		OTDO_Cantidad,
		OT_Codigo,
		OV_EV_EventoId,
		OT_EV_EventoId
from OrdenesVenta
INNER JOIN OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OrdenVentaId 
INNER JOIN OrdenesVentaReq ON OVR_OVDetalleId = OVD_OVDetalleId AND OV_OrdenVentaId = OVD_OrdenVentaId 
left join OrdenesTrabajoDetalleOVR  on OVR_OVRequeridaId = OTDO_OVR_OVRequeridaId
left join OrdenesTrabajo on OT_OrdenTrabajoId = OTDO_OT_OrdenTrabajoId
Where OV_CodigoOV = 'OV450'
Order by OV_CodigoOV









