-- PIXVS Consulta para 021 Resumen OV Importes.
-- Ing. Vicente Cueva R.
-- Solicitado por Claudia Castañeda.
-- Iniciado: Miercoles 15 de Agosto del 2018
-- Actualizado: Lunes 20 de Agosto del 2018; Origen
-- Actualizado: Jueves 21 de Agosto del 2018; Utilizo consultas Individuales, para evitar duplicidad de valores.

DECLARE @FechaIS date
DECLARE @FechaFS date
Set @FechaIS = CONVERT (DATE, '2018-08-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-08-14', 102) 

-- Resumen de OVOTE (Orden Venta, Orden Trabajo, Embarque)

--Select	OVOTE.PROYECTO,
	--	OVOTE.CLIENTE,
	--	OVOTE.CONTACTO,
	--	SUM(OVOTE.IMP_OV) AS S_IMP_OV
	--	SUM(OVOTE.IMP_FT_$) AS S_IMP_FA,
	--	SUM(OVOTE.IMP_XE_$) AS S_IMP_XE,
	--	SUM(OVOTE.IMP_EM_$) AS S_IMP_EM,
	--	SUM(OVOTE.IMP_PG_$) AS S_IMP_PG	
--From (

Select	(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
		
		OV_CodigoOV AS OV,
		Cast(OV_FechaOV AS DATE) AS F_OV,
		OV_ReferenciaOC AS REF_OV,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MON_OV,

		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		(Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD,
		OVR_CantidadRequerida AS CANT_OV,
		OVR_PrecioUnitario AS PREC_OV,
		OV_MONP_Paridad AS TIC_OV,
		OVR_CantidadRequerida * OVR_PrecioUnitario AS IMP_OV,


		MiFac.FTR_NumeroFactura,
		MiFac.FTR_FechaFactura,
		MiFac.FTR_Comentarios,
		MiFac.FTR_MON_MonedaId,
		MiFac.IMP_FT
		
from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
LEFT JOIN ( SELECT EMBD_OVR_OVRequeridaId, SUM( EMBD_CantidadEmbarcada ) AS CANT_EMB 
FROM EmbarquesDetalle Inner Join Embarques ON EMBD_EmbarqueId = EMB_EmbarqueId 
Group By EMBD_OVR_OVRequeridaId ) AS Embarques ON OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId 

LEFT JOIN (Select FTR_OV_OrdenVentaId, FTR_NumeroFactura, FTR_FechaFactura, FTR_Comentarios, FTR_MON_MonedaId,
SUM(FTRR_CantidadRequerida * FTRR_PrecioUnitario) AS IMP_FT from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
inner join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Group By FTR_OV_OrdenVentaId, FTR_NumeroFactura, FTR_FechaFactura, FTR_Comentarios, FTR_MON_MonedaId ) AS MiFac
on MiFac.FTR_OV_OrdenVentaId = OV_OrdenVentaId
Where OV_EV_EventoId = 'BC57D67D-6DC1-4B9D-A036-D2C9A1151767'

--Where OV_CMM_EstadoOVId <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA'
--and (OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 )) != 0
--AND OV_EV_EventoId = 'BEFA2429-74E0-4665-9D0D-80AA100C4F4B'

--) OVOTE
--Group By  OVOTE.CLIENTE,OVOTE.PROYECTO, OVOTE.CONTACTO






--left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 0
--left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo
--left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId







/*


		(Select ISNULL(SUM(LOCA_Cantidad), 0) from LocalidadesArticulo Where LOCA_ART_ArticuloId = OVD_ART_ArticuloId) AS CANT_EXIST,

		ISNULL ( CANT_EMB , 0.0 ) AS CANT_EMB, 
		ISNULL ( CANT_EMB , 0.0 ) * OVR_PrecioUnitario AS IMP_EM_$,
		OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 ) AS CANT_X_EMB, 
		((OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 ))  * OVR_PrecioUnitario * OV_MONP_Paridad)	AS IMP_XE_$,	

		Cast(FTR_FechaFactura AS DATE) AS F_FTR,
		FTRD_FTR_FacturaId,
		ISNULL(FTR_NumeroFactura, 0) AS NO_FTR,
		FTRR_CantidadRequerida AS CANT_FT,
		FTRR_PrecioUnitario AS PREC_FT,
		(Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MON_FT,
		FTR_MONP_Paridad AS TIC_FA,
		FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMP_FT_$,
			
		(Select SUM(CXCP_MontoPago)  from CXCPagosDetalle
		Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
		Where CXCPD_RegistroId = FTRD_FTR_FacturaId and CXCP_Borrado = 0)AS IMP_PG_$






Version Miercoles 22 de Agosto del 2018
Select	--OVOTE.OV,
		OVOTE.CLIENTE,
		OVOTE.PROYECTO,
		OVOTE.CONTACTO,
		SUM(OVOTE.IMP_OV_$ * OVOTE.TIC_OV) AS S_IMP_OV,
		SUM(OVOTE.IMP_FT_$) AS S_IMP_FA,
		SUM(OVOTE.IMP_XE_$) AS S_IMP_XE,
		SUM(OVOTE.IMP_EM_$) AS S_IMP_EM,
		SUM(OVOTE.IMP_PG_$) AS S_IMP_PG	
From (

Select	Cast(OV_FechaOV AS DATE) AS F_OV,	
		OV_CodigoOV AS OV,
		(CLI_CodigoCliente + '  ' + CLI_RazonSocial) AS CLIENTE,
		OV_EV_EventoId,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO,
		(Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
		ART_CodigoArticulo AS CODIGO,
		ART_Nombre AS ARTICULO, 
		(Select CMUM_Nombre from ControlesMaestrosUM where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UNIDAD,
		OVR_CantidadRequerida AS CANT_OV,
		OVR_PrecioUnitario AS PREC_OV,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OV_MON_MonedaId) AS MON_OV,
		OV_MONP_Paridad AS TIC_OV,
		OVR_CantidadRequerida * OVR_PrecioUnitario * OV_MONP_Paridad AS IMP_OV_$,
		OV_CMM_EstadoOVId AS STA_OV,

		(Select ISNULL(SUM(LOCA_Cantidad), 0) from LocalidadesArticulo Where LOCA_ART_ArticuloId = OVD_ART_ArticuloId) AS CANT_EXIST,

		ISNULL ( CANT_EMB , 0.0 ) AS CANT_EMB, 
		ISNULL ( CANT_EMB , 0.0 ) * OVR_PrecioUnitario AS IMP_EM_$,
		OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 ) AS CANT_X_EMB, 
		((OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 ))  * OVR_PrecioUnitario * OV_MONP_Paridad)	AS IMP_XE_$,	

		Cast(FTR_FechaFactura AS DATE) AS F_FTR,
		FTRD_FTR_FacturaId,
		ISNULL(FTR_NumeroFactura, 0) AS NO_FTR,
		FTRR_CantidadRequerida AS CANT_FT,
		FTRR_PrecioUnitario AS PREC_FT,
		(Select MON_Nombre from Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MON_FT,
		FTR_MONP_Paridad AS TIC_FA,
		FTRR_CantidadRequerida * FTRR_PrecioUnitario AS IMP_FT_$,
			
		(Select SUM(CXCP_MontoPago)  from CXCPagosDetalle
		Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
		Where CXCPD_RegistroId = FTRD_FTR_FacturaId and CXCP_Borrado = 0)AS IMP_PG_$

from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
LEFT JOIN ( SELECT EMBD_OVR_OVRequeridaId, SUM( EMBD_CantidadEmbarcada ) AS CANT_EMB 
FROM EmbarquesDetalle Inner Join Embarques ON EMBD_EmbarqueId = EMB_EmbarqueId 
Group By EMBD_OVR_OVRequeridaId ) AS Embarques ON OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId 
left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 0
left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo
left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
Where OV_CMM_EstadoOVId <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA'
and (OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 )) != 0
and OV_CodigoOV = 'OV428' 
AND OV_EV_EventoId = 'BEFA2429-74E0-4665-9D0D-80AA100C4F4B'

) OVOTE
Group By  OVOTE.CLIENTE,OVOTE.PROYECTO, OVOTE.CONTACTO

--OVOTE.OV,






Select *  from CXCPagosDetalle
		Inner Join CXCPagos  on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId
		Where CXCPD_RegistroId = '3ADF7E9D-1DD7-4BCD-BD4A-020AC558A3E6'


Version Lunes 20 de Agosto del 2018.
Select	OVOTE.OV,
		OVOTE.STA_OV,
		OVOTE.CLIENTE,
		OVOTE.PROYECTO,
		OVOTE.CODIGO,
		OVOTE.ARTICULO,
		OVOTE.CANT_OV,
		
		OVOTE.CANT_EMB,
		OVOTE.CANT_X_EMB

From (

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
		OV_CMM_EstadoOVId AS STA_OV,

		--Cast(OT_FechaRegistro AS DATE) AS F_OT,
		--OT_Codigo AS OT,
		--ISNULL(OTDA_Cantidad, 0) AS CANT_OT,
		
		--OTR_FechaRecibo AS F_RECIBO,
		--OTRD_CantidadRecibo AS CANT_TERM,

		(Select SUM(LOCA_Cantidad) from LocalidadesArticulo Where LOCA_ART_ArticuloId = OVD_ART_ArticuloId) AS CANT_XEMB,

		ISNULL ( CANT_EMB , 0.0 ) AS CANT_EMB, 
		OVR_CantidadRequerida - ISNULL ( CANT_EMB , 0.0 ) AS CANT_X_EMB, 
				
		--Cast (EMB_FechaEmbarque as DATE) AS F_EMB,
		--EMB_CodigoEmbarque AS EMBARQUE,
		--EMBD_CantidadEmbarcada AS CANT_EMB,
		
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

LEFT JOIN ( SELECT EMBD_OVR_OVRequeridaId, SUM( EMBD_CantidadEmbarcada ) AS CANT_EMB 
FROM EmbarquesDetalle Inner Join Embarques ON EMBD_EmbarqueId = EMB_EmbarqueId 
Group By EMBD_OVR_OVRequeridaId ) AS Embarques ON OVR_OVRequeridaId = EMBD_OVR_OVRequeridaId 
		
--left join EmbarquesDetalle on EMBD_OVR_OVRequeridaId = OVR_OVRequeridaId
--left join Embarques on EMBD_EmbarqueId = EMB_EmbarqueId

left join Facturas on FTR_OV_OrdenVentaId = OV_OrdenVentaId and FTR_Eliminado = 0
left join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId and FTRD_ART_CodigoArticulo = ART_CodigoArticulo
left join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId

left join CXCPagosDetalle on FTRD_FTR_FacturaId = CXCPD_RegistroId
left join CXCPagos on CXCPD_CXCP_PagoCXCId = CXCP_PagoCXCId

--left join OrdenesTrabajo on OT_CLI_ClienteId = OV_CLI_ClienteId
--left join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId and OTDA_ART_ArticuloId = OVD_ART_ArticuloId
--left join OrdenesTrabajoRecibo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId
--left join OrdenesTrabajoReciboDetalle on OTRD_OTR_OrdenTrabajoReciboId = OTR_OrdenTrabajoReciboId

Orden By 


--) OVOTE

--WHERE CANT_X_EMB != 0 and OVOTE.STA_OV <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA' 
--and OVOTE.CODIGO =  '4072.5-19'

--Group By OVOTE.OV, OVOTE.CLIENTE, OVOTE.PROYECTO, OVOTE.CODIGO, OVOTE.ARTICULO, OVOTE.CANT_OV,
--OVOTE.CANT_EMB, OVOTE.CANT_X_EMB, OVOTE.STA_OV

--Where OV_CodigoOV =	'OV486' and ISNULL(OTDA_Cantidad, 0) > 0
--OV_CMM_EstadoOVId <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA'  
--Order By OVOTE.OV, OVOTE.CODIGO

*/