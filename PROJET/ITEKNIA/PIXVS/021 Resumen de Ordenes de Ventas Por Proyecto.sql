-- PIXVS Consulta para 021 Resumen OV Importes.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Miercoles 15 de Agosto del 2018
-- Actualizado: Lunes 20 de Agosto del 2018; Origen
-- Actualizado: Jueves 21 de Agosto del 2018; Utilizo consultas Individuales, para evitar duplicidad de valores.
-- Actualizado: Sabado 25 de Agosto del 2018; Presentar informacion detallada, por Proyecto.

Declare @Proyect uniqueidentifier
Declare @CodProy VarChar(100)

Set @CodProy = '4640.1'
--Set @Proyect = 'E4657876-14DB-4210-84C5-8FEEB507A20A'

Set @Proyect = (Select EV_EventoId 
from Eventos
where EV_CodigoEvento = @CodProy)

 /*
-- Datos de la Orden de Venta.
Select	'VENTAS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
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
Where OV_EV_EventoId =  @Proyect
Group By OV_EV_EventoId, OV_CodigoOV, OV_FechaOV, OV_MON_MonedaId, OV_MONP_Paridad,
CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId

-- Datos de Facturacion. 
Select	'FACTURAS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
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
Where FTR_Eliminado = 0 and OV_EV_EventoId =  @Proyect  
Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad

--Datos de los Embarques
Select	'EMBARQUE' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
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
Where OV_EV_EventoId =  @Proyect
Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad

--Datos de Pagos	
Select  'PAGOS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
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
Where CXCP_Borrado = 0 AND OV_EV_EventoId =  @Proyect


*/


--Resumen para Excel

Select 'VENTAS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, (Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO, OV_CodigoOV AS DOCTO, Cast(OV_FechaOV AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV from OrdenesVenta inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId Where OV_EV_EventoId =  @Proyect Group By OV_EV_EventoId, OV_CodigoOV, OV_FechaOV, OV_MON_MonedaId, OV_MONP_Paridad,CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId 

-- Datos de Facturacion. 
Select 'FACTURAS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, FTR_NumeroFactura AS DOCTO, Cast(FTR_FechaFactura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA, FTR_MONP_Paridad AS TIC, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId inner join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId 
Where OV_EV_EventoId =  @Proyect Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad

--Datos de los Embarques
Select 'EMBARQUE' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, EMB_CodigoEmbarque AS DOCTO, Cast(EMB_FechaEmbarque AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM from Embarques inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId
Where OV_EV_EventoId =  @Proyect Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad

--Datos de Pagos	
Select 'PAGOS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, CXCP_NumeroPago AS DOCTO, Cast(CXCP_FechaCaptura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, CXCP_MONP_Paridad AS TIC, Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId
Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where CXCP_Borrado = 0 AND OV_EV_EventoId =  @Proyect






 