-- PIXVS Consulta para 021 Resumen Proyecto Importes.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Miercoles 15 de Agosto del 2018
-- Actualizado: Lunes 20 de Agosto del 2018; Origen
-- Actualizado: Jueves 21 de Agosto del 2018; Utilizo consultas Individuales, para evitar duplicidad de valores.
-- Actualizado: Sabado 25 de Agosto del 2018; Presentar informacion detallada, por Proyecto.
-- Actualizado: Sabado 29 de Junio del 2019; No aparecen algunas Facturas.

Use iteknia

--Parametros Fecha Inicial y Fecha Final
Declare @Proyect uniqueidentifier
Declare @CodProy VarChar(100)
Declare @FechaFS as nvarchar(30)

Set @FechaFS = CONVERT (DATE, '2018-01-01', 102) 
Set @CodProy = '5468.3'

Set @Proyect = (Select EV_EventoId 
from Eventos
where EV_CodigoEvento = @CodProy)

-- Consulta por proyectos

Select	RESV.IDENTIF, 
		RESV.DOCTO, 
		RESV.REFDOS, 
		RESV.FECHA,
		RESV.MONEDA,
		RESV.IMPOR_OV, 
		RESV.IMPOR_FT, 
		RESV.IMPOR_EM, 
		RESV.IMPOR_PG,
		RESV.PROYECTO, 
		RESV.FF_PROY
from ( 

-- Datos de la Orden de Venta.
Select	'VENTAS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
		OV_CodigoOV AS DOCTO,
		OV_ReferenciaOC as REFDOS,
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
CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, OV_ReferenciaOC

Union All

--FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6' Factura OV
--FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756' Miscelanea
--FTR_CMM_TipoFactura = '523ECA13-30BC-4E8D-BE15-B2323E7A7EEB' Normal Sin registros
--FTR_CMM_TipoFactura = '8655086E-8F52-40FB-A743-8E03BEEDE6D4' Nota de Credito sin Registros

-- Datos de Facturacion para FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756' Miscelanea
Select	'FACT-MISC' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
		FTR_NumeroFactura as DOCTO, 
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = FTR_CMM_TipoRegistroId) as REFDOS,
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
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Where FTR_Eliminado = 0 and OV_EV_EventoId =  @Proyect  and FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756' 
Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad,
FTR_CMM_TipoRegistroId, CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId

Union All

-- Datos de Facturacion para FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6' Factura OV
Select	'FACT-OV' AS IDENTIF,
		FTR_Proyecto AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = FTR_Proyecto ) AS FF_PROY,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		'CONTACTO' as CONTACTO,
		FTR_NumeroFactura as DOCTO, 
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = FTR_CMM_TipoRegistroId) as REFDOS,
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
inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId 
from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId)
Where FTR_Eliminado = 0 and FTR_Proyecto =  @Proyect  and FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6' 
Group By FTR_Proyecto, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad,
FTR_CMM_TipoRegistroId, FTR_CDE_DestinatarioId, CLI_CodigoCliente, CLI_RazonSocial

Union All

--Datos de los Embarques
Select	'EMBARQUE' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
		EMB_CodigoEmbarque AS DOCTO,
		('FAC- '+ ISNULL((Select FTR_NumeroFactura from Facturas 
		where FTR_FacturaId = EMB_FTR_FacturaId),'S/F')) as REFDOS,
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
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Where OV_EV_EventoId =  @Proyect
Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad,
CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, EMB_FTR_FacturaId


Union All

--Datos de Pagos de Facturas de OV.	
Select  'PA-FOV' AS IDENTIF,
		FTR_Proyecto AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = FTR_Proyecto ) AS FF_PROY,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		'CONTACTO' as CONTACTO,

		CXCP_NumeroPago AS DOCTO,
		CXCP_IdentificacionPago as REFDOS, 
		Cast(CXCP_FechaCaptura AS DATE) AS FECHA,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA,
		CXCP_MONP_Paridad AS TIC,
		0 AS IMPOR_OV,
				
		Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else
		((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT,
		0 AS IMPOR_EM,
		Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else
		(CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG

from CXCPagosDetalle
Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId
inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId 
from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId)
--Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId
Where CXCP_Borrado = 0 AND FTR_Proyecto =  @Proyect
and CXCPD_CMM_TipoRegistro = 'EA169681-AC4F-4664-986E-9302579B68B6' 

Union All

--Datos de Pagos de Facturas Miscelaneas.	
Select  'PA-MIS' AS IDENTIF,
		OV_EV_EventoId AS EVENTO,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,

		(Select (CLI_CodigoCliente + '  ' + CLI_RazonSocial) from Clientes
		Where CLI_ClienteId = (Select CDE_CLI_ClienteId from ClientesDireccionesEmbarques
		Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId)) as CLIENTE,
		'CONTACTO' as CONTACTO,

		CXCP_NumeroPago AS DOCTO,
		CXCP_IdentificacionPago as REFDOS, 
		Cast(CXCP_FechaCaptura AS DATE) AS FECHA,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA,
		CXCP_MONP_Paridad AS TIC,
		0 AS IMPOR_OV,
		Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else
		((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT,
		0 AS IMPOR_EM,
		Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else
		(CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG
from CXCPagosDetalle
Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId
Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId
Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Where CXCP_Borrado = 0 AND OV_EV_EventoId =  @Proyect
and CXCPD_CMM_TipoRegistro = '2688FE37-D52A-45D6-B2A6-1A6D34577756' 

) RESV 
Group by RESV.IDENTIF, RESV.DOCTO, RESV.REFDOS, RESV.FECHA,	RESV.MONEDA, RESV.IMPOR_OV, RESV.IMPOR_FT, 
RESV.IMPOR_EM, RESV.IMPOR_PG, RESV.PROYECTO, RESV.FF_PROY
having PROYECTO is not null and FF_PROY > @FechaFS
Order by RESV.FECHA, RESV.DOCTO

/*


-- Datos de Facturacion 
Select	DISTINCT FTR_CMM_TipoFactura, (Select CMM_Valor from ControlesMaestrosMultiples 
Where CMM_ControllId = FTR_CMM_TipoFactura) as TIPOFACT
from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId


Select * 
from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
Where FTR_Eliminado = 0 
and FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6'
--and FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756'
--and FTR_OV_OrdenVentaId is null
and FTR_Proyecto is null
Order By FTR_FechaFactura



--Select * from ControlesMaestrosMultiples
--where CMM_Control = 'CXC_TipoRegistro'
--Where CMM_ControllId = '39AF436A-E011-4372-8D63-3FFC199E5718'

--FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6' Factura OV
--FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756' Miscelanea



-- Script Consulta de Informacion 03 de Julio del 2019.
Select	RESV.IDENTIF, RESV.DOCTO, RESV.REFDOS, RESV.FECHA, RESV.MONEDA, RESV.IMPOR_OV, RESV.IMPOR_FT, RESV.IMPOR_EM, RESV.IMPOR_PG, RESV.PROYECTO, RESV.FF_PROY from (Select	'VENTAS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, (Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO, OV_CodigoOV AS DOCTO, OV_ReferenciaOC as REFDOS, Cast(OV_FechaOV AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV, 0 AS IMPOR_FT, 
0 AS IMPOR_EM, 0 AS IMPOR_PG from OrdenesVenta inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId Where OV_EV_EventoId =  '" & Proyect & "' Group By OV_EV_EventoId, OV_CodigoOV, OV_FechaOV, OV_MON_MonedaId, OV_MONP_Paridad, CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, OV_ReferenciaOC Union All Select	'FACT-MISC' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, (Select CCON_Nombre 
from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO, FTR_NumeroFactura as DOCTO, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = FTR_CMM_TipoRegistroId) as REFDOS, Cast(FTR_FechaFactura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA, FTR_MONP_Paridad AS TIC, 0 AS IMPOR_OV, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId inner join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where FTR_Eliminado = 0 and OV_EV_EventoId =  '" & Proyect & "'  and FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756' 
Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad, FTR_CMM_TipoRegistroId, CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId Union All Select	'FACT-OV' AS IDENTIF, FTR_Proyecto AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = FTR_Proyecto ) AS FF_PROY, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, 'CONTACTO' as CONTACTO, FTR_NumeroFactura as DOCTO, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = FTR_CMM_TipoRegistroId) as REFDOS, Cast(FTR_FechaFactura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA, FTR_MONP_Paridad AS TIC, 0 AS IMPOR_OV, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT,
0 AS IMPOR_EM, 0 AS IMPOR_PG from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId  from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId) Where FTR_Eliminado = 0 and FTR_Proyecto =  '" & Proyect & "'  and FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6' Group By FTR_Proyecto, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad, FTR_CMM_TipoRegistroId, FTR_CDE_DestinatarioId, CLI_CodigoCliente, CLI_RazonSocial Union All Select	'EMBARQUE' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) 
from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, (Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO, EMB_CodigoEmbarque AS DOCTO, ('FAC- '+ ISNULL((Select FTR_NumeroFactura from Facturas where FTR_FacturaId = EMB_FTR_FacturaId),'S/F')) as REFDOS, Cast(EMB_FechaEmbarque AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, 0 AS IMPOR_OV, 0 AS IMPOR_FT, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM, 0 AS IMPOR_PG from Embarques inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Where OV_EV_EventoId =  '" & Proyect & "' Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad, CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, EMB_FTR_FacturaId Union All Select  'PA-FOV' AS IDENTIF, FTR_Proyecto AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = FTR_Proyecto ) AS FF_PROY, (CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE, 'CONTACTO' as CONTACTO, CXCP_NumeroPago AS DOCTO, CXCP_IdentificacionPago as REFDOS, Cast(CXCP_FechaCaptura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, CXCP_MONP_Paridad AS TIC, 0 AS IMPOR_OV, Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then 
Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else ((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT, 0 AS IMPOR_EM, Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId  from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId) Where CXCP_Borrado = 0 AND FTR_Proyecto =  '" & Proyect & "' and CXCPD_CMM_TipoRegistro = 'EA169681-AC4F-4664-986E-9302579B68B6' Union All Select  'PA-MIS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion
from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select (CLI_CodigoCliente + '  ' + CLI_RazonSocial) from Clientes Where CLI_ClienteId = (Select CDE_CLI_ClienteId from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId)) as CLIENTE, 'CONTACTO' as CONTACTO, CXCP_NumeroPago AS DOCTO, CXCP_IdentificacionPago as REFDOS, Cast(CXCP_FechaCaptura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, CXCP_MONP_Paridad AS TIC, 0 AS IMPOR_OV, Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else ((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT, 0 AS IMPOR_EM,
Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where CXCP_Borrado = 0 AND OV_EV_EventoId =  '" & Proyect & "' and CXCPD_CMM_TipoRegistro = '2688FE37-D52A-45D6-B2A6-1A6D34577756' ) RESV Group by RESV.IDENTIF, RESV.DOCTO, RESV.REFDOS, RESV.FECHA,	RESV.MONEDA, RESV.IMPOR_OV, RESV.IMPOR_FT, RESV.IMPOR_EM, RESV.IMPOR_PG, RESV.PROYECTO, RESV.FF_PROY having PROYECTO is not null and FF_PROY > '" & FechaIS & "' Order by RESV.FECHA, RESV.DOCTO
*/
