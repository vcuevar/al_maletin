-- PIXVS Consulta para 020 Reporte de Facturas Canceladas.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Sabado 11 de Agosto del 2018
-- Actualizado: Martes 14 de Agosto del 2018.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-06-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-06-30', 102) 

-- Ordenes de Ventas + Embarques + Facturas
-- Reporte de Facturas Canceladas. 
Select	Cast (FTR_FechaFactura as DATE) AS F_FACT,
		FTR_NumeroFactura AS NO_FACT,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		(Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD,
		OVD_CodigoOV AS O_V,
		FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMPO_FACT
from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
left join EmbarquesDetalle on EMBD_OVR_OVRequeridaId = OVR_OVRequeridaId
left join Embarques on EMBD_EmbarqueId = EMB_EmbarqueId
left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 1
left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo
left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
Where Cast (FTR_FechaFactura as DATE)  BETWEEN @FechaIS and @FechaFS
Order By FTR_NumeroFactura



Select Cast (FTR_FechaFactura as DATE) AS F_FACT, FTR_NumeroFactura AS NO_FACT, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, ART_CodigoArticulo AS CODIGO, ART_Nombre AS ARTICULO, (Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD, OVD_CodigoOV AS O_V, FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMPO_FACT from OrdenesVenta inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId left join EmbarquesDetalle on EMBD_OVR_OVRequeridaId = OVR_OVRequeridaId
left join Embarques on EMBD_EmbarqueId = EMB_EmbarqueId left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 1 left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId Where Cast (FTR_FechaFactura as DATE)  BETWEEN @FechaIS and @FechaFS Order By FTR_NumeroFactura


