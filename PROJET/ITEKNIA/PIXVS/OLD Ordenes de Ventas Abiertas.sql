-- Consulta para Ordenes de Venta Abiertas
-- Actualizado al 02 de Abril del 2018
-- Vicente Cueva Ramirez.

Select	OV_FechaOV as F_ORDEN, 
		Cast(OV_FechaOV As Date) as FECHA,
		Case When OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV_FechaOV) END AS SEMANA,
		OV_CodigoOV AS ORD_VEN,
		CLI_CodigoCliente AS COD_CLI,
		CLI_NombreComercial AS CLIENTE,
		EV_Nombre AS PROYECTO,
		OV_ReferenciaOC AS ORD_COM,
		ART_GLN AS INSUMO,
		SUBSTRING(ART_GLN,8,20) AS COD, 
		ART_CodigoArticulo AS CODIGO,
		OVD_ART_Nombre AS PRODUCTO,
		ART_Comentarios AS DESCRIPCION,	
		OVD_CMUM_Nombre AS UNIDAD,
		OVR_CantidadRequerida AS CANTIDAD,
		MN.MON_Nombre AS MONEDA,
		OVR_PrecioUnitario AS PRE_UNIT,
		OV_MONP_Paridad AS TIP_CAMBIO,
		MM4.CMM_Valor AS TIP_CLIENTE,
		AFAM_Nombre as FAMILIA,
		ACAT_Nombre as CATEGORIA,
		OVR_FechaRequerida AS F_ENTREGA,
		OV_Comentarios AS OBSERV,
		MM1.CMM_Valor AS ESTAD_OV,
		OVR_EmbarqueCompleto AS ABIERTA_0
from OrdenesVenta  
inner join Clientes on OV_CLI_ClienteId = CLI_ClienteId
inner join OrdenesVentaDetalle on OV_OrdenVentaId = OVD_OrdenVentaId 
inner join OrdenesVentaReq on OVD_OVDetalleId = OVR_OVDetalleId AND OV_OrdenVentaId = OVD_OrdenVentaId
inner join Articulos on OVD_ART_ArticuloId = ART_ArticuloId
left join ClientesContactos CC on OV_CCON_ContactoId = CC.CCON_ContactoId
left join Eventos on OV_EV_EventoId = EV_EventoId
inner join Monedas MN on OV_MON_MonedaId = MN.MON_MonedaId
left join ControlesMaestrosMultiples MM1 on OV_CMM_EstadoOVId = MM1.CMM_ControllId
--left join ControlesMaestrosMultiples MM2 on OV.OV_CMM_TipoOrdenVenta = MM2.CMM_ControllId
--left join ControlesMaestrosMultiples MM3 on OV.OV_CMM_EstatusSolicitud = MM3.CMM_ControllId
left join ControlesMaestrosMultiples MM4 on CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
left join ArticulosCategorias on ART_ACAT_CategoriaId= ACAT_CategoriaId
where  OV_CodigoOV = 'OV004'
Order By SEMANA, ORD_VEN, CODIGO

--OVR.OVR_EmbarqueCompleto = 0 and
-- MM1.CMM_Valor Los Valores que maneja son:
--		Abierta
--		Aceptada
--		Cerrada por Usuario
--		Embarcada
--		Entregada
--		Rechazada

/*
Select	OV.OV_FechaOV as F_ORDEN, Cast(OV.OV_FechaOV As Date) as FECHA, Case When OV.OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV.OV_FechaOV) END AS SEMANA, OV.OV_CodigoOV AS ORD_VEN, CL.CLI_CodigoCliente AS COD_CLI, CL.CLI_NombreComercial AS CLIENTE, PY.EV_Nombre AS PROYECTO, OV.OV_ReferenciaOC AS ORD_COM, IT.ART_GLN AS INSUMO, SUBSTRING(IT.ART_GLN,8,20) AS COD, IT.ART_CodigoArticulo AS CODIGO, OD.OVD_ART_Nombre AS PRODUCTO, IT.ART_Comentarios AS DESCRIPCION,	OD.OVD_CMUM_Nombre AS UNIDAD, OVR.OVR_CantidadRequerida AS CANTIDAD, MN.MON_Nombre AS MONEDA, OVR.OVR_PrecioUnitario AS PRE_UNIT, OV.OV_MONP_Paridad AS TIP_CAMBIO, MM4.CMM_Valor AS TIP_CLIENTE, AF.AFAM_Nombre as FAMILIA, AC.ACAT_Nombre as CATEGORIA, 
OVR.OVR_FechaRequerida AS F_ENTREGA, OV.OV_Comentarios AS OBSERV, OVR.OVR_EmbarqueCompleto AS ABIERTA_0 from OrdenesVenta OV inner join Clientes CL on OV.OV_CLI_ClienteId = CL.CLI_ClienteId inner join OrdenesVentaDetalle OD on OV.OV_OrdenVentaId = OD.OVD_OrdenVentaId inner join OrdenesVentaReq OVR on OD.OVD_OVDetalleId = OVR.OVR_OVDetalleId inner join Articulos IT on OD.OVD_ART_ArticuloId = IT.ART_ArticuloId left join ClientesContactos CC on OV_CCON_ContactoId = CC.CCON_ContactoId left join Eventos PY on OV.OV_EV_EventoId = PY.EV_EventoId inner join Monedas MN on OV.OV_MON_MonedaId = MN.MON_MonedaId left join ControlesMaestrosMultiples MM4 on CL.CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId left join ArticulosFamilias AF on IT.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ArticulosCategorias AC on IT.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId where OVR.OVR_EmbarqueCompleto = 0 and OV.OV_CodigoOV = 'OV004' Order By SEMANA, ORD_VEN

Select  
 * from Facturas FTR
 inner join FacturasDetalle FTRD on FTR.FTR_FacturaId = FTRD.FTRD_FTR_FacturaId
 where FTR.FTR_Proyecto is null
 
 --FTRD.FTRD_ART_CodigoArticulo = '3733.5-7'

--inner join OrdenesVenta OV on OV.OV_OrdenVentaId = FTR.FTR_OV_OrdenVentaId
--inner join FacturasReq FTRR on FTRD.FTRD_DetalleId = FTRR.FTRR_FTRD_DetalleId
--Where OV.OV_CodigoOV = 'OV004'


Select * from FacturasDatos

select * from FacturasDetalle

Select * from FacturasReq FTRR
inner join FacturasDetalle FTRD on FTRR.FTRR_FTRD_DetalleId = FTRD.FTRD_DetalleId  

*/