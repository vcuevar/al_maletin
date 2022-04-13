-- PIXVS Consulta para 021-A Resumen Proyecto Importes.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Miercoles 15 de Agosto del 2018
-- Actualizado: Lunes 20 de Agosto del 2018; Origen
-- Actualizado: Jueves 21 de Agosto del 2018; Utilizo consultas Individuales, para evitar duplicidad de valores.
-- Actualizado: Sabado 25 de Agosto del 2018; Presentar informacion detallada, por Proyecto.
-- Actualizado: Sabado 29 de Junio del 2019; No aparecen algunas Facturas.
-- Actualizado: Miercoles 10 de Julio del 2019; Segun factura selecciona proyecto.
-- Actualizado: Lunes 15 de Julio del 2019; Pagos pierden Evento por relacion en facturas.
-- Actualizado: Sabado 20 de Julio del 2019; Uso por Fecha de Proyecto e incluir Estatus=DefinidoPorUsuari1


Use iteknia
Declare @FechaFS as nvarchar(30)

Set @FechaFS = CONVERT (DATE, '2019-07-19', 102) 

-- Consulta Resumen Generaal

Select	RESV.PROYECTO,
		RESV.FF_PROY,
		RESV.MONEDA,
		SUM(RESV.IMPOR_OV) as IMPOR_OV, 
		SUM(RESV.IMPOR_FT) as IMPOR_FT, 
		SUM(RESV.IMPOR_EM) as IMPOR_EM, 
		SUM(RESV.IMPOR_PG) as IMPOR_PG,
		RESV.ESTATUS
from ( 

-- Datos de la Orden de Venta.
Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA,
		SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV,
		0 AS IMPOR_FT,
		0 AS IMPOR_EM,
		0 AS IMPOR_PG,
		(Select EV_DefinidoPorUsuario1 from Eventos Where EV_EventoId = OV_EV_EventoId ) AS ESTATUS		
from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
Group By OV_EV_EventoId, OV_MON_MonedaId

Union All

-- Datos de Facturacion 
Select	Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = 
		(Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		is not Null then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (
		Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_CodigoEvento + '  ' + 
		EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null
		Then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = 
		FTR_Proyecto ) Else 'SIN PROYECTO ASIGNADO' End End End as PROYECTO,
		
		Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId =
		(Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId
		from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId 
		from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
		Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select EV_FechaTermina
		from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId =
		(Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_FechaTermina
		from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId =
		OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then (Select EV_FechaTermina 
		from Eventos Where EV_EventoId = FTR_Proyecto ) Else @FechaFS End End End as FF_PROY,

		(Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA,
		0 AS IMPOR_OV,
		SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT,
		0 AS IMPOR_EM,
		0 AS IMPOR_PG,
		Case When (Select EV_DefinidoPorUsuario1 from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = 
		(Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		is not Null then (Select EV_DefinidoPorUsuario1 from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (
		Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_DefinidoPorUsuario1
		from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null
		Then (Select EV_DefinidoPorUsuario1 from Eventos Where EV_EventoId = 
		FTR_Proyecto ) Else 'NO DEFINIDO' End End End as ESTATUS
from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
Where FTR_Eliminado = 0 
Group By FTR_Proyecto, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad,
FTR_CMM_TipoRegistroId, FTR_CDE_DestinatarioId, FTR_FacturaId, FTR_OV_OrdenVentaId

Union All

--Datos de los Embarques
Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA,
		0 AS IMPOR_OV,
		0 AS IMPOR_FT,
		SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM,
		0 AS IMPOR_PG,
		(Select EV_DefinidoPorUsuario1 from Eventos Where EV_EventoId = OV_EV_EventoId ) AS ESTATUS
from Embarques
inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId
inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId
inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad,
CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, EMB_FTR_FacturaId

Union All

--Datos de Pagos de Facturas de OV.	
Select  Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = 
		(Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		is not Null then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (
		Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_CodigoEvento + '  ' + 
		EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null
		Then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = 
		FTR_Proyecto ) Else 'SIN PROYECTO ASIGNADO' End End End as PROYECTO,
		
		Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId =
		(Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId
		from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId 
		from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
		Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select Cast(EV_FechaTermina
		AS DATE) from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId =
		(Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else Case When FTR_OV_OrdenVentaId is not Null Then (Select Cast(EV_FechaTermina AS DATE)
		from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId =
		OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then (Select Cast(EV_FechaTermina AS DATE)
		from Eventos Where EV_EventoId = FTR_Proyecto ) Else @FechaFS End End End as FF_PROY,

		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA,
		0 AS IMPOR_OV,				
		Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else
		((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT,
		0 AS IMPOR_EM,
		Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else
		(CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG,

		Case When (Select EV_DefinidoPorUsuario1 from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = 
		(Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		is not Null then (Select EV_DefinidoPorUsuario1 from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = 
		(Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (
		Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on 
		EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_DefinidoPorUsuario1
		from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null
		Then (Select EV_DefinidoPorUsuario1 from Eventos Where EV_EventoId = 
		FTR_Proyecto ) Else 'NO DEFINIDO' End End End as ESTATUS

from CXCPagosDetalle
Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId
inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId 
from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId)
Where CXCP_Borrado = 0 
and CXCPD_CMM_TipoRegistro = 'EA169681-AC4F-4664-986E-9302579B68B6' 

Union All

--Datos de Pagos de Facturas Miscelaneas.	
Select  (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA,
		0 AS IMPOR_OV,
		Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else
		((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT,
		0 AS IMPOR_EM,
		Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then
		Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else
		(CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG,
		(Select EV_DefinidoPorUsuario1 from Eventos Where EV_EventoId = OV_EV_EventoId ) AS ESTATUS

from CXCPagosDetalle
Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId
Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId
Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Where CXCP_Borrado = 0 
and CXCPD_CMM_TipoRegistro = '2688FE37-D52A-45D6-B2A6-1A6D34577756' 

) RESV 
Group by RESV.MONEDA, RESV.PROYECTO, RESV.FF_PROY, RESV.ESTATUS
having PROYECTO is not null and FF_PROY >= @FechaFS
Order by RESV.PROYECTO


--Select * from Eventos Where EV_Borrado = 0 AND EV_CodigoEvento = '5569.2'


/*
-- Script para Macro 021-A y C Actualizado el 20 de Julio del 2019; Para uso Fecha o Estatus.



-- Script para Macro 021-A y C actualizado el 10 de Julio del 2019.
Select	RESV.PROYECTO, RESV.FF_PROY, RESV.MONEDA, SUM(RESV.IMPOR_OV) as IMPOR_OV, SUM(RESV.IMPOR_FT) as IMPOR_FT, SUM(RESV.IMPOR_EM) as IMPOR_EM, SUM(RESV.IMPOR_PG) as IMPOR_PG from ( Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV, 0 AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from OrdenesVenta inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId Group By OV_EV_EventoId, OV_MON_MonedaId Union All Select	Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_CodigoEvento + '  ' +  EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null
Then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) Else 'SIN PROYECTO ASIGNADO' End End End as PROYECTO, Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select EV_FechaTermina from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_FechaTermina
from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then (Select EV_FechaTermina from Eventos Where EV_EventoId = FTR_Proyecto ) Else '" & FechaFS & "' End End End as FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId Where FTR_Eliminado = 0 Group By FTR_Proyecto, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad, FTR_CMM_TipoRegistroId, FTR_CDE_DestinatarioId, FTR_FacturaId, FTR_OV_OrdenVentaId Union All Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos 
Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, 0 AS IMPOR_FT, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM, 0 AS IMPOR_PG from Embarques inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad, CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, EMB_FTR_FacturaId Union All Select  Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos  Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques 
inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) Else 'SIN PROYECTO ASIGNADO' End End End as PROYECTO, Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion 
from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) Else Case When FTR_OV_OrdenVentaId is not Null Then (Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then 
(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = FTR_Proyecto ) Else '" & FechaFS & "' End End End as FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else ((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT, 0 AS IMPOR_EM, Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId  from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId) Where CXCP_Borrado = 0 
and CXCPD_CMM_TipoRegistro = 'EA169681-AC4F-4664-986E-9302579B68B6' Union All Select  (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else ((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT, 0 AS IMPOR_EM, Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId Inner Join OrdenesVenta on 
OV_OrdenVentaId = FTR_OV_OrdenVentaId Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where CXCP_Borrado = 0 and CXCPD_CMM_TipoRegistro = '2688FE37-D52A-45D6-B2A6-1A6D34577756' ) RESV Group by RESV.MONEDA, RESV.PROYECTO, RESV.FF_PROY having PROYECTO is not null and FF_PROY > '" & FechaFS & "' Order by RESV.PROYECTO 



-- Script para Macro 021-A y C actualizado el 10 de Julio del 2019.
Select	RESV.PROYECTO, RESV.FF_PROY, RESV.MONEDA, SUM(RESV.IMPOR_OV) as IMPOR_OV,  SUM(RESV.IMPOR_FT) as IMPOR_FT, SUM(RESV.IMPOR_EM) as IMPOR_EM, SUM(RESV.IMPOR_PG) as IMPOR_PG from (Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV, 0 AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from OrdenesVenta inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId Group By OV_EV_EventoId, OV_MON_MonedaId 
Union All Select	Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_CodigoEvento + '  ' + 
EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) Else 'SIN PROYECTO ASIGNADO' End End End as PROYECTO, Case When (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null then (Select EV_FechaTermina from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = (Select OVR_OrdenventaId from 
OrdenesVentaReq Where OVR_OVRequeridaId = (Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId Where EMB_FTR_FacturaId = FTR_FacturaId)))) Else Case When FTR_OV_OrdenVentaId is not Null Then (Select EV_FechaTermina from Eventos Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId)) Else Case When FTR_Proyecto is not null Then (Select EV_FechaTermina from Eventos Where EV_EventoId = FTR_Proyecto ) Else '" & FechaFS & "' End End End as FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
Where FTR_Eliminado = 0 Group By FTR_Proyecto, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad, FTR_CMM_TipoRegistroId, FTR_CDE_DestinatarioId, FTR_FacturaId, FTR_OV_OrdenVentaId Union All Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, 0 AS IMPOR_FT, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM, 0 AS IMPOR_PG from Embarques inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad, CLI_CodigoCliente, CLI_RazonSocial, OV_CCON_ContactoId, EMB_FTR_FacturaId Union All Select  (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = FTR_Proyecto ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else ((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT, 0 AS IMPOR_EM, Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG
from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId inner Join Clientes on CLI_ClienteId = (Select CDE_CLI_ClienteId  from ClientesDireccionesEmbarques Where  CDE_DireccionEmbarqueId = FTR_CDE_DestinatarioId) Where CXCP_Borrado = 0  and CXCPD_CMM_TipoRegistro = 'EA169681-AC4F-4664-986E-9302579B68B6' Union All Select  (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, 0 AS IMPOR_OV, Case When CXCP_CMM_FormaPago = 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado * -1) else ((CXCPD_MontoAplicado / 1.16)* -1) End Else 0 End AS IMPOR_FT,
0 AS IMPOR_EM, Case When CXCP_CMM_FormaPago <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' then Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End Else 0 End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where CXCP_Borrado = 0  and CXCPD_CMM_TipoRegistro = '2688FE37-D52A-45D6-B2A6-1A6D34577756' ) RESV Group by RESV.MONEDA, RESV.PROYECTO, RESV.FF_PROY having PROYECTO is not null and FF_PROY > '" & FechaFS & "' Order by RESV.PROYECTO

' Script Consulta de Informacion 16 de Septiembre del 2018.
SSQL = " Select RESV.PROYECTO, RESV.FF_PROY, RESV.MONEDA, SUM(RESV.IMPOR_OV) AS S_OV, SUM(RESV.IMPOR_FT) AS S_FT, SUM(RESV.IMPOR_EM) AS S_EM, SUM(RESV.IMPOR_PG) AS S_PG from ( Select	'VENTAS' AS IDENTIF, OV_EV_EventoId AS EVENTO,	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, OV_CodigoOV AS DOCTO, Cast(OV_FechaOV AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, SUM(OVR_CantidadRequerida * OVR_PrecioUnitario) AS IMPOR_OV, 0 AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG	from OrdenesVenta " _
& " inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId Group By OV_EV_EventoId, OV_CodigoOV, OV_FechaOV, OV_MON_MonedaId, OV_MONP_Paridad Union All Select	'FACTURAS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, FTR_NumeroFactura AS DOCTO, Cast(FTR_FechaFactura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA, " _
& " FTR_MONP_Paridad AS TIC, 0 AS IMPOR_OV, SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMPOR_FT, 0 AS IMPOR_EM, 0 AS IMPOR_PG from Facturas inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId inner join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId Where FTR_Eliminado = 0 Group By OV_EV_EventoId, FTR_NumeroFactura, FTR_FechaFactura, FTR_MON_MonedaId, FTR_MONP_Paridad Union All Select	'EMBARQUE' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, " _
& " EMB_CodigoEmbarque AS DOCTO, Cast(EMB_FechaEmbarque AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MONEDA, OV_MONP_Paridad AS TIC, 0 AS IMPOR_OV, 0 AS IMPOR_FT, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) AS IMPOR_EM, 0 AS IMPOR_PG from Embarques inner join EmbarquesDetalle on EMBD_EmbarqueId = EMB_EmbarqueId inner join OrdenesVentaReq on OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId inner join OrdenesVenta on OVR_OrdenventaId = OV_OrdenVentaId Group By OV_EV_EventoId, EMB_CodigoEmbarque, EMB_FechaEmbarque, OV_MON_MonedaId, OV_MONP_Paridad Union All Select  'PAGOS' AS IDENTIF, OV_EV_EventoId AS EVENTO, (Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO, " _
& " (Select EV_FechaTermina from Eventos Where EV_EventoId = OV_EV_EventoId ) AS FF_PROY, CXCP_NumeroPago AS DOCTO, Cast(CXCP_FechaCaptura AS DATE) AS FECHA, (Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA, CXCP_MONP_Paridad AS TIC, 0 AS IMPOR_OV, 0 AS IMPOR_FT, 0 AS IMPOR_EM, Case When  CLI_RFC Like '%XEXX%' then (CXCPD_MontoAplicado) else (CXCPD_MontoAplicado / 1.16) End AS IMPOR_PG from CXCPagosDetalle Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId Inner join Facturas on CXCPD_RegistroId = FTR_FacturaId Inner Join OrdenesVenta on OV_OrdenVentaId = FTR_OV_OrdenVentaId Inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId Where CXCP_Borrado = 0 ) RESV " _
& " Group by RESV.PROYECTO, RESV.MONEDA, RESV.FF_PROY having PROYECTO is not null and FF_PROY > '" & FechaFS & "' Order by RESV.FF_PROY, RESV.PROYECTO, RESV.MONEDA "

*/