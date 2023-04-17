-- PIXVS Consulta para 021 Resumen OV Importes.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Miercoles 15 de Agosto del 2018
-- Actualizado: Lunes 20 de Agosto del 2018; Origen

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-08-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-08-14', 102) 

-- Ordenes de Ventas + Orden de Trabajo + Recibo de OT + F. Embarcar + Embarques + Facturas + Pagos

Select	Cast(OV_FechaOV AS DATE) AS F_OV,	
		OV_CodigoOV AS OV,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		(Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD,
		OVR_CantidadRequerida AS CANT_OV,
		OVR_PrecioUnitario AS PREC_OV,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MON_OV,
		OV_MONP_Paridad AS TIC_OV,
		OVR_CantidadRequerida * OVR_PrecioUnitario * OV_MONP_Paridad AS IMP_OV_$,

		Cast(OT_FechaRegistro AS DATE) AS F_OT,
		OT_Codigo AS OT,
		ISNULL(OTDA_Cantidad, 0) AS CANT_OT,
		
		OTR_FechaRecibo AS F_RECIBO,
		OTRD_CantidadRecibo AS CANT_TERM,

		(Select SUM(LOCA_Cantidad) from LocalidadesArticulo Where LOCA_ART_ArticuloId = OVD_ART_ArticuloId) AS CANT_XEMB,

		Cast (EMB_FechaEmbarque as DATE) AS F_EMB,
		EMB_CodigoEmbarque AS EMBARQUE,
		EMBD_CantidadEmbarcada AS CANT_EMB,
		
		Cast(FTR_FechaFactura AS DATE) AS F_FTR,
		ISNULL(FTR_NumeroFactura, 0) AS NO_FTR,
		FTRR_CantidadRequerida AS CANT_FT,
		FTRR_PrecioUnitario AS PREC_FT,
		(Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MON_FT,
		FTR_MONP_Paridad AS TIC_FA,
		FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMP_FT_$,
		
		Cast(CXCP_FechaPago AS DATE) AS F_PAG,
		CXCP_IdentificacionPago AS ID_PAG,
		CXCP_MontoPago AS IMP_PAG,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MON_PAG,
		CXCP_MONP_Paridad AS TIC_PA,
		(Select CMIVA_Porcentaje from ControlesMaestrosIVA Where CMIVA_CodigoId = CXC_IVAplidado) AS POR_IVA,
		((CXCP_MontoPago * CXCP_MONP_Paridad) / (1+(Select CMIVA_Porcentaje from ControlesMaestrosIVA Where CMIVA_CodigoId = CXC_IVAplidado))) AS IMP_PAG_$		

from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId

inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId

left join EmbarquesDetalle on EMBD_OVR_OVRequeridaId = OVR_OVRequeridaId
left join Embarques on EMBD_EmbarqueId = EMB_EmbarqueId

left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 0
left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo
left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId

left join CXCPagosDetalle on FTRD_FTR_FacturaId = CXCPD_RegistroId
left join CXCPagos on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId

left join OrdenesTrabajo on OT_CLI_ClienteId = OV_CLI_ClienteId
left join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId and OTDA_ART_ArticuloId = OVD_ART_ArticuloId
left join OrdenesTrabajoRecibo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId
left join OrdenesTrabajoReciboDetalle on OTRD_OTR_OrdenTrabajoReciboId = OTR_OrdenTrabajoReciboId
Where  (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) like '5140.2'
--OV_CodigoOV =	'OV004' and ART_CodigoArticulo = '3733.5-31' --and ISNULL(OTDA_Cantidad, 0) > 0
Order By OV_CodigoOV, ART_CodigoArticulo
