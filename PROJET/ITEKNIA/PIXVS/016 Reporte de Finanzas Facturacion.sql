-- PIXVS Consulta para Reporte de Reporte de Finanzas.
-- Ing. Vicente Cueva R.
-- Iniciado: Sabado 16 de Junio del 2018
-- Actualizado: Lunes 02 de Julio del 2018.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-06-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-06-07', 102) 

--Detalles de Facturas para Pesos.
SET LANGUAGE Español;
Select	FTR_NumeroFactura AS NO_FAC,
		UPPER(DATENAME ( mm , FTR_FechaFactura )) AS MES,
		Case When FTR_FechaFactura IS NULL Then '9000' Else DATEPART(WK, FTR_FechaFactura) END AS SEMANA,
		Cast (FTR_FechaFactura as DATE) AS F_FACT,
		Cast (FTR_FechaFactura as DATE) AS F_VENC,
		DATEDIFF ( dd , FTR_FechaFactura , GETDATE ( )   ) AS DIAS_VENCIM,
		FTD_RazonSocial AS CLIENTE,	
		(Select CMDSC_TermsDescuento from ControlesMaestrosDSC Where CMDSC_CodigoId = (select OV_CMDSC_CodigoId from OrdenesVenta where OV_OrdenVentaId = FTR_OV_OrdenVentaId)) AS TIPO_PAGO,
		FTR_PorcentajeAnticipo AS PORC_PAG,
		(select OV_CodigoOV from OrdenesVenta where OV_OrdenVentaId = FTR_OV_OrdenVentaId) AS OV,
		(select OV_ReferenciaOC from OrdenesVenta where OV_OrdenVentaId = FTR_OV_OrdenVentaId) AS OC,
		(Select EV_Nombre from Eventos Where EV_EventoId = (select OV_EV_EventoId from OrdenesVenta where OV_OrdenVentaId = FTR_OV_OrdenVentaId)) AS PROYECTO,
		(select OV_Comentarios from OrdenesVenta where OV_OrdenVentaId = FTR_OV_OrdenVentaId) AS CONCEPTO,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = (select OV_CCON_ContactoId from OrdenesVenta where OV_OrdenVentaId = FTR_OV_OrdenVentaId)) AS CONTACTO,
		(Select MON_Nombre from Monedas where MON_MonedaId = FTR_MON_MonedaId) AS MONEDA,
		FTR_MONP_Paridad AS PARIDAD,
		FTRD_CMIVA_Porcentaje AS IVA,
		SUM((FTRR_CantidadRequerida * FTRR_PrecioUnitario)) AS IMPORTE,
		ISNULL ((Select TOP 1 OVR_FechaPromesa from OrdenesVentaReq where OVR_OrdenventaId = FTR_OV_OrdenVentaId), (Select TOP 1 OVR_FechaRequerida from OrdenesVentaReq where OVR_OrdenventaId = FTR_OV_OrdenVentaId)) AS FEC_PROM,
		CXCP_Descripcion AS DESCRIPCION,
		CXCPD_MontoAplicado AS MONTOAPLICADO,
		CXCP_IdentificacionPago AS REFERENCIA,
		CXCP_MontoPago AS MONTOPAGO,
		CXCP_Borrado AS BORRADO
from Facturas
inner join FacturasDetalle ON FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasDatos ON FTD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq ON FTRD_DetalleId = FTRR_FTRD_DetalleId
left join CXCPagosDetalle on FTR_FacturaId =CXCPD_RegistroId 
inner join CXCPagos on CXCP_PagoCXCId = CXCPD_CXCP_PagoCXCId
Where Cast (FTR_FechaFactura as DATE)  BETWEEN @FechaIS and @FechaFS and
(Select MON_Nombre from Monedas where MON_MonedaId = FTR_MON_MonedaId) = 'Pesos'
Group by FTR_NumeroFactura, FTR_FechaFactura, FTD_RazonSocial, FTR_PorcentajeAnticipo, 
FTR_OV_OrdenVentaId, FTR_MON_MonedaId, FTR_MONP_Paridad, FTRD_CMIVA_Porcentaje,
CXCP_Descripcion, CXCPD_MontoAplicado, CXCP_IdentificacionPago, CXCP_MontoPago,
CXCP_Borrado
Order By NO_FAC


/*
--a de Facturas tiene el campo FTR_FacturaId tabla de CXPPagosDetalle con el campo de CXCPD_RegistroId
Select	FTR_NumeroFactura AS NO_FAC,
		UPPER(DATENAME ( mm , FTR_FechaFactura )) AS MES,
		Case When FTR_FechaFactura IS NULL Then '9000' Else DATEPART(WK, FTR_FechaFactura) END AS SEMANA,
		Cast (FTR_FechaFactura as DATE) AS F_FACT,
		Cast (FTR_FechaFactura as DATE) AS F_VENC,
		DATEDIFF ( dd , FTR_FechaFactura , GETDATE ( )   ) AS DIAS_VENCIM,
		CXCP_Descripcion AS DESCRIPCION,
		CXCPD_MontoAplicado AS MONTOAPLICADO,
		CXCP_IdentificacionPago AS REFERENCIA,
		CXCP_MontoPago AS MONTOPAGO,
		CXCP_Borrado AS BORRADO
from Facturas
left join CXCPagosDetalle on FTR_FacturaId =CXCPD_RegistroId 
inner join CXCPagos on CXCP_PagoCXCId = CXCPD_CXCP_PagoCXCId
Where Cast (FTR_FechaFactura as DATE)  BETWEEN @FechaIS and @FechaFS
Order By NO_FAC


--Select * from CXCPagosDetalle
--Select * from CXCPagos

*/

