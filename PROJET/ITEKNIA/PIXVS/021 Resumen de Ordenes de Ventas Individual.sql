-- PIXVS Consulta para 021 Resumen por Proyecto (FINANZAS).
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Miercoles 15 de Agosto del 2018
-- Actualizado: Lunes 20 de Agosto del 2018; Origen
-- Actualizado: Jueves 21 de Agosto del 2018; Utilizo consultas Individuales, para evitar duplicidad de valores.
-- Actualizado: Sabado 25 de Agosto del 2018; Rectificar pagos que no cuadra.
-- Actualizado: Miercoles 19 de Septiembre del 2018; Migracion a L.O.

DECLARE @FechaIS date
DECLARE @FechaFS date
Set @FechaIS = CONVERT (DATE, '2018-08-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-01-01', 102) 

-- Resumen de Proyectos
Select	RESV.PROYECTO,
		RESV.FF_PROY,
		RESV.MONEDA,
		SUM(RESV.IMPOR_OV) AS S_OV,
		SUM(RESV.IMPOR_FT) AS S_FT,
		SUM(RESV.IMPOR_EM) AS S_EM,
		SUM(RESV.IMPOR_PG) AS S_PG
from (
-- Datos de la Orden de Venta.
Select	'VENTAS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,	
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		OV_CodigoOV AS DOCTO,
		Cast(OV_FechaOV AS DATE) AS FECHA,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA,
		OV_MONP_Paridad AS TIC,
		SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV,
		0 AS IMPOR_FT,
		0 AS IMPOR_EM,
		0 AS IMPOR_PG		
from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
Group By OV_EV_EventoId, OV_CodigoOV, OV_FechaOV, OV_MON_MonedaId, OV_MONP_Paridad

Union All

-- Datos de Facturacion. 
Select	'FACTURAS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		FTR_NumeroFactura AS DOCTO, 
		Cast(FTR_FechaFactura AS DATE) AS FECHA, 
		(Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA,
		FTR_MONP_Paridad AS TIC,
		0 AS IMPOR_OV,
		SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT,
		0 AS IMPOR_EM,
		0 AS IMPOR_PG
from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
inner join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Where FTR_Eliminado = 0
Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad

Union All

--Datos de los Embarques
Select	'EMBARQUE' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		EMB_CodigoEmbarque AS DOCTO,
		Cast(EMB_FechaEmbarque AS DATE) AS FECHA,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA,
		OV_MONP_Paridad AS TIC,
		0 AS IMPOR_OV,
		0 AS IMPOR_FT,
		SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM,
		0 AS IMPOR_PG
from Embarques
inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId
inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId
inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId
Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad

Union All

--Datos de Pagos	
Select  'PAGOS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,		
		CXCP_NumeroPago AS DOCTO,
		Cast(CXCP_FechaCaptura AS DATE) AS FECHA,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA,
		CXCP_MONP_Paridad AS TIC,
		0 AS IMPOR_OV,
		0 AS IMPOR_FT,
		0 AS IMPOR_EM,
		Case When  CLI_RFC Like '%XEXX%' then
			(CXCPD_MontoAplicado) else
		(CXCPD_MontoAplicado / 1.16) End AS IMPOR_PG
from CXCPagosDetalle
Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId
Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId
Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Where CXCP_Borrado = 0 
) RESV
Group by RESV.PROYECTO, RESV.MONEDA, RESV.FF_PROY
having PROYECTO is not null and FF_PROY > @FechaFS
Order by RESV.FF_PROY, RESV.PROYECTO, RESV.MONEDA




-- Para Macro de Libre Oficce

--Select RESV.PROYECTO, RESV.FF_PROY, RESV.MONEDA, SUM(RESV.IMPOR_OV) AS S_OV, SUM(RESV.IMPOR_FT) AS S_FT, SUM(RESV.IMPOR_EM) AS S_EM, SUM(RESV.IMPOR_PG) AS S_PG from ( Select	'VENTAS' AS IDENTIF, OV_EV_EventoId AS EVENTO,	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, OV_CodigoOV AS DOCTO, Cast(OV_FechaOV AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV, 0 AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG	from OrdenesVenta
--inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId Group By OV_EV_EventoId, OV_CodigoOV, OV_FechaOV, OV_MON_MonedaId, OV_MONP_Paridad Union All Select	'FACTURAS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, FTR_NumeroFactura AS DOCTO, Cast(FTR_FechaFactura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA,
--FTR_MONP_Paridad AS TIC, 0 AS IMPOR_OV, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId inner join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad Union All Select	'EMBARQUE' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
--EMB_CodigoEmbarque AS DOCTO, Cast(EMB_FechaEmbarque AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, 0 AS IMPOR_OV, 0 AS IMPOR_FT, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM, 0 AS IMPOR_PG from Embarques inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad Union All Select  'PAGOS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
--(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, CXCP_NumeroPago AS DOCTO, Cast(CXCP_FechaCaptura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, CXCP_MONP_Paridad AS TIC, 0 AS IMPOR_OV, 0 AS IMPOR_FT, 0 AS IMPOR_EM, Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where CXCP_Borrado = 0 ) RESV
--Group by RESV.PROYECTO, RESV.MONEDA, RESV.FF_PROY having PROYECTO is not null and FF_PROY > @FechaFS Order by RESV.FF_PROY, RESV.PROYECTO, RESV.MONEDA






