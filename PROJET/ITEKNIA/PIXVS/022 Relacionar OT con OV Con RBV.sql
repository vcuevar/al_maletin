

-- Relacion de OV - OT mediante RBV
Select	OVD_ART_Nombre,
		OV_CodigoOV,
		OVR_CantidadRequerida,
		OT_CD,
		OTDA_Cantidad,
		AR_QT
From RBV_OT 
inner join OrdenesVenta on OV_ID = OV_OrdenVentaId
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId and OVD_ART_ArticuloId = AR_ID
inner join OrdenesTrabajo on OT_ID = OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
Where  OT_CD = 'OT0927'
--OV_CD = 'OV491' 
--OT_CD = 'OT0927'   




