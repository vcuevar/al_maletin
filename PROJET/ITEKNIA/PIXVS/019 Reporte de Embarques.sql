-- PIXVS Consulta para 019 Reporte de Embarques.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Martes 07 de Agosto del 2018
-- Actualizado: Martes 07 de Agosto del 2018.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-12-19', 102)
Set @FechaFS = CONVERT (DATE, '2018-12-19', 102) 

Select	Cast (EMB_FechaEmbarque as DATE) AS F_EMB,
		(Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes
		Where CLI_ClienteId = EMB_CLI_ClienteId ) AS CLIENTE,
		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		EMBD_CantidadEmbarcada AS CANTIDAD,
		
		OVR_PrecioUnitario AS PREC_UNI,
		ISNULL(OV_MONP_Paridad, 0) AS TIC_OV,
				
		--FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMPO_FACT,
		
		--ISNULL(FTR_MONP_Paridad, 0) AS TIC_FA,
		
		EMB_CodigoEmbarque AS EMBARQUE,
		
		ISNULL((Select STUFF ((Select Distinct ' F-' + FTR_NumeroFactura + ', ' from Facturas
		Where FTR_OV_OrdenVentaId = OVR_OrdenVentaId
		FOR XML PATH ('')), 1, 0, '')), 'S/F') AS NO_FACT,
		
		TRAM_ValorContableArticuloActual AS IMPORTE,
		
		TRAM_Razon AS O_V,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO
from Embarques
Inner Join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
inner join TransferenciasMovtos on EMBD_TRAM_TransferenciaMovtoId = TRAM_TransferenciaMovtoId
inner join Articulos on ART_ArticuloId = TRAM_ART_ArticuloId
inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId
inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId
Where Cast (EMB_FechaEmbarque as DATE)  BETWEEN @FechaIS and @FechaFS
Order By MONEDA DESC,  EMB_CodigoEmbarque

/*


-- Ordenes de Ventas + Embarques + Facturas

Select	FTRD_FTR_FacturaId AS ID_FACT,
		Cast (EMB_FechaEmbarque as DATE) AS F_EMB,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		EMB_CodigoEmbarque AS EMBARQUE,
		(Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD,
		EMBD_CantidadEmbarcada AS CANTIDAD,
		OVR_PrecioUnitario AS PREC_UNI,
		OVD_CodigoOV AS O_V,
		EMB_FTR_FacturaId,
		ISNULL(FTR_NumeroFactura, 0) AS NO_FACT,
		FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMPO_FACT,
		ISNULL(OV_MONP_Paridad, 0) AS TIC_OV,
		ISNULL(FTR_MONP_Paridad, 0) AS TIC_FA,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO
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
Where Cast (EMB_FechaEmbarque as DATE)  BETWEEN @FechaIS and @FechaFS
Order By EMB_CodigoEmbarque
*/





--Select	FTRD_FTR_FacturaId AS ID_FACT, Cast (EMB_FechaEmbarque as DATE) AS F_EMB, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, ART_CodigoArticulo AS CODIGO, ART_Nombre AS ARTICULO, EMB_CodigoEmbarque AS EMBARQUE, (Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD, EMBD_CantidadEmbarcada AS CANTIDAD, OVR_PrecioUnitario AS PREC_UNI, OVD_CodigoOV AS O_V, ISNULL(FTR_NumeroFactura, 0) AS NO_FACT, FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMPO_FACT, ISNULL(OV_MONP_Paridad, 0) AS TIC_OV, ISNULL(FTR_MONP_Paridad, 0) AS TIC_FA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO
--from OrdenesVenta inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId left join EmbarquesDetalle on EMBD_OVR_OVRequeridaId = OVR_OVRequeridaId left join Embarques on EMBD_EmbarqueId = EMB_EmbarqueId left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 0 left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId 
--Where Cast (EMB_FechaEmbarque as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' Order By EMB_CodigoEmbarque








/*
left join CXCPagosDetalle on FTRD_FTR_FacturaId = CXCPD_RegistroId
left join CXCPagos on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
--Where OV_CodigoOV = 'OV444'


-- Ordenes de Ventas
Select * from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
Where OV_CodigoOV = 'OV520'

-- Embarques
Select * from Embarques
inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId
where EMB_CodigoEmbarque = 'EMB0538'

--Facturas
Select * from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
where FTR_NumeroFactura = '7788'

-- Pagos
Select * from CXCPagos
inner join CXCPagosDetalle on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
where CXCPD_RegistroId = '639534E1-C6F7-4AA6-A7F2-F5E4EC43975D'
Where CXCP_PagoCXCId = '51AEE2A2-15DF-4996-94FE-D69124E8BAE6'



Select	Fecha Factura,
		Numero de Factura
		Codigo Articulo
		Descripcion
		Unidad
		Cantidad
		Precio
		iva
		total
		ov
		cliente
		proyecto

		* from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
where FTR_NumeroFactura = '7788'



Select * from Embarques
inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
Where Cast (EMB_FechaEmbarque as DATE)  BETWEEN @FechaIS and @FechaFS


Buscar ligar	Ordenes de Ventas (Llave)
				Embarques
				Facturas
				Pagos

select	Cast (EMB_FechaEmbarque as DATE) AS F_EMB,
	EMB_CodigoEmbarque AS EMBARQUE,
	FTR_NumeroFactura 
from Embarques
left join Facturas on EMB_FTR_FacturaId = FTR_FacturaId
Where Cast (EMB_FechaEmbarque as DATE)  BETWEEN @FechaIS and @FechaFS
Order By EMB_CodigoEmbarque


-- Primer Consulta con liga del campos como dijo Juan no funciona.
select	Cast (EMB_FechaEmbarque as DATE) AS F_EMB,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		EMB_CodigoEmbarque AS EMBARQUE,
		(Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD,
		EMBD_CantidadEmbarcada AS CANTIDAD,
		OVR_PrecioUnitario AS PREC_UNI,
		OVD_CodigoOV AS O_V,
		EMB_FTR_FacturaId,
		ISNULL(FTR_NumeroFactura, 0) AS NO_FACT,
		Embarques.*
from Embarques
inner Join Clientes on CLI_ClienteId = EMB_CLI_ClienteId
Inner Join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
Inner Join OrdenesVentaReq on EMBD_OVR_OVRequeridaId =  OVR_OVRequeridaId
Inner Join OrdenesVentaDetalle on OVR_OVDetalleId = OVD_OVDetalleId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
left join Facturas on EMB_FTR_FacturaId = FTR_FacturaId
Where Cast (EMB_FechaEmbarque as DATE)  BETWEEN @FechaIS and @FechaFS
Order By EMB_CodigoEmbarque



Select * from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
Where Cast (FTR_FechaFactura as DATE)  BETWEEN @FechaIS and @FechaFS




*/	

