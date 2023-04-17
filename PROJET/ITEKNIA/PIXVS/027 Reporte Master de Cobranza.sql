-- PIXVS Consulta para 027 Reporte Master de Cobranza.
-- Solicitado por Claudia Castañeda.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 08 de Diciembre del 2018; Origen
-- Actualizado: Miercoles 12 de Diciembre del 2018; Culmen.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-12-13', 102)
Set @FechaFS = CONVERT (DATE, '2018-12-13', 102) 


-- ---------------------------------------------------------------------------
-- Consulta Bajar Facturas.

Select	FTR_NumeroFactura AS NUMFACT,
		DATEPART (MONTH,FTR_FechaFactura) AS MES,
		DATEPART (WK,FTR_FechaFactura) AS SEM,
		FTR_FechaFactura AS FECHFACT,
		FTR_FechaFactura AS FECHVENCE,
		0 AS DIASVENC,
		'00 a 30 DIAS' AS AGING,

		Isnull((Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes
		Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta
		Where OV_OrdenVentaId = FTR_OV_OrdenVentaId)),'X') AS CLIENTE,

		(select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = FTR_CMM_TipoFactura ) AS TIPFAC,

		(select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = FTR_CMM_TipoRegistroId ) AS TIPREG,

		Isnull(FTR_PorcentajeAnticipo, 100) AS PORCPAG,

		Isnull((Select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = FTR_OV_OrdenVentaId),'X') AS OC,

		Isnull((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = 
		(Select OV_EV_EventoId from OrdenesVenta Where OV_OrdenVentaId = FTR_OV_OrdenVentaId)), 'X') AS PROY,

		(Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA,

		FTR_MONP_Paridad AS TIPCAM,

		(Select SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) 
		from FacturasReq where FTRR_FTR_FacturaId = FTR_FacturaId) AS IMPORT,

		(Select top 1 FTRD_PorcentajeDescuento from FacturasDetalle
		Where FTRD_FTR_FacturaId = FTR_FacturaId ) AS PORCDESC,

		(Select top 1 FTRD_CMIVA_Porcentaje from FacturasDetalle
		Where FTRD_FTR_FacturaId = FTR_FacturaId ) AS PORCIVA,

		Isnull((Select CCON_Nombre from ClientesContactos
		Where CCON_ContactoId = 
		(Select OV_CCON_ContactoId from OrdenesVenta
		Where OV_OrdenVentaId = FTR_OV_OrdenVentaId)), 'X') AS CONTACTO,


		(Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes
		Where CLI_ClienteId = (Select top 1 OV_CLI_ClienteId from OrdenesVenta
		Where OV_EV_EventoId = FTR_Proyecto)) AS CLIENTE2,

		(Select top 1 OV_CodigoOV from OrdenesVenta 
		Where OV_EV_EventoId = FTR_Proyecto) AS OC2,
	
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = FTR_Proyecto) AS PROY2,
			
		(Select CCON_Nombre from ClientesContactos
		Where CCON_ContactoId = 
		(Select top 1 OV_CCON_ContactoId from OrdenesVenta
		Where OV_EV_EventoId = FTR_Proyecto)) AS CONTACTO2
		,*
from Facturas
where Cast(FTR_FechaFactura As Date) BETWEEN @FechaIS and @FechaFS
and FTR_Eliminado = 0
Order By FTR_NumeroFactura

/*

-- ---------------------------------------------------------------------------
-- Consulta Bajar Pagos Recibidos.
 
 Select	Isnull((Select FTR_NumeroFactura from Facturas Where FTR_FacturaId = (
		Select top 1 FTRD_FTR_FacturaId from FacturasDetalle
 		Where FTRD_FTR_FacturaId =CXCPD_RegistroId)), 'SIN REF.') AS NUMFACT,

		CXCP_FechaCaptura AS FECHPAGO,

		Isnull((Select CLI_CodigoCliente + '  ' + CLI_NombreComercial from Clientes
		Where CLI_ClienteId = CXCP_CLI_ClienteId),CXCP_Pagador) AS CLIENTE,

		(select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = CXCP_CMM_TipoRegistro ) AS TIPREG,
	
		(select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = CXCP_CMM_FormaPago ) AS FOMPAGO,
 
		CXCP_IdentificacionPago AS IDENTI,

		(Select MON_Nombre from Monedas Where MON_MonedaId = CXCP_MON_MonedaId) AS MONEDA,

		CXCP_MONP_Paridad as TIPCAMB,

		Isnull(CXCPD_SubTotal,CXCPD_MontoAplicado)  AS IMPORTE
		
 from CXCPagos 
 inner join CXCPagosDetalle on CXCP_PagoCXCId = CXCPD_CXCP_PagoCXCId
 where Cast(CXCP_FechaCaptura As Date) BETWEEN @FechaIS and @FechaFS
 and CXCP_Borrado = 0
 Order By CXCP_FechaCaptura

 */
 
--Datos de los Embarques Por Factura.
Select ENVA.EMBARQUE, ENVA.O_V,  ENVA.NO_FACT, SUM(ENVA.CANTIDAD * ENVA.PREC_UNI) AS IMPORTE
from (
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
Where FTR_NumeroFactura = '7881'
--EMB_FTR_FacturaId = '23894CB8-E31A-41BA-A16B-44941E4F7EDB'
--Cast (EMB_FechaEmbarque as DATE)  BETWEEN @FechaIS and @FechaFS
) ENVA
Group by ENVA.EMBARQUE, ENVA.O_V,  ENVA.NO_FACT
Order By ENVA.EMBARQUE

Select EMB_CodigoEmbarque, EMB_FechaEmbarque, SUM(EMBD_CantidadEmbarcada * OVR_PrecioUnitario) IMPORTE

from Embarques 
inner join Facturas on EMB_FTR_FacturaId = FTR_FacturaId and FTR_Eliminado = 0
inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
inner join OrdenesVentaReq on EMBD_OVR_OVRequeridaId = OVR_OVRequeridaId
Where FTR_NumeroFactura = '7881'
Group By EMB_CodigoEmbarque, EMB_FechaEmbarque
