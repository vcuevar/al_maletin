-- Consulta para reporte VENTAS
-- Actualizado al 03 de Febrero del 2018
-- vcr

/*
Select	OV.OV_FechaOV as F_ORDEN, 
		Case When OV.OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV.OV_FechaOV) END AS SEMANA,
		OV.OV_CodigoOV AS ORD_VEN,
		OV.OV_ReferenciaOC AS ORD_COM,
		CL.CLI_CodigoCliente AS COD_CLI,
		CL.CLI_NombreComercial AS CLIENTE,
		CC.CCON_Nombre AS CONTACTO,
		--CC.CCON_Departamento AS TIP_CLI2, --Usar con Cliente C057
		IT.ART_CodigoArticulo AS CODIGO,
		OD.OVD_ART_Nombre AS PRODUCTO,
		IT.ART_Comentarios AS DESCRIPCION,
		IT.ART_GLN AS INSUMO,
		OD.OVD_CMUM_Nombre AS UNIDAD,
		PY.EV_Nombre AS PROYECTO,
		MN.MON_Nombre AS MONEDA,
		OV.OV_MONP_Paridad AS TIP_CAMBIO,
		OVR.OVR_FechaRequerida AS F_ENTREGA,
		OVR.OVR_FechaPromesa AS F_PROMESA,
		OVR.OVR_CantidadRequerida AS CANTIDAD,
		OVR.OVR_PrecioUnitario AS PRE_UNIT,
		OD.OVD_CMIVA_Porcentaje AS POR_IVA,
		OV.OV_Comentarios AS OBSERV,
		MM1.CMM_Valor AS EDO_OV,
		MM2.CMM_Valor AS TIP_VENTA,
		MM4.CMM_Valor AS TIP_CLIENTE,
		MM3.CMM_Valor AS EST_GRAL,
		AF.AFAM_Nombre as FAMILIA,
		AC.ACAT_Nombre as CATEGORIA	
from OrdenesVenta OV 
inner join Clientes CL on OV.OV_CLI_ClienteId = CL.CLI_ClienteId
inner join OrdenesVentaDetalle OD on OV.OV_OrdenVentaId = OD.OVD_OrdenVentaId 
inner join OrdenesVentaReq OVR on OD.OVD_OVDetalleId = OVR.OVR_OVDetalleId
inner join Articulos IT on OD.OVD_ART_ArticuloId = IT.ART_ArticuloId
left join ClientesContactos CC on OV_CCON_ContactoId = CC.CCON_ContactoId
left join Eventos PY on OV.OV_EV_EventoId = PY.EV_EventoId
inner join Monedas MN on OV.OV_MON_MonedaId = MN.MON_MonedaId
left join ControlesMaestrosMultiples MM1 on OV.OV_CMM_EstadoOVId = MM1.CMM_ControllId
left join ControlesMaestrosMultiples MM2 on OV.OV_CMM_TipoOrdenVenta = MM2.CMM_ControllId
left join ControlesMaestrosMultiples MM3 on OV.OV_CMM_EstatusSolicitud = MM3.CMM_ControllId
left join ControlesMaestrosMultiples MM4 on CL.CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId
left join ArticulosFamilias AF on IT.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ArticulosCategorias AC on IT.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
where DATEPART(YEAR, OV.OV_FechaOV) > 2017 
--and OV.OV_CodigoOV = 'OV257'
Order By SEMANA, ORD_VEN
*/



-- Consulta para reporte ESTADISTICO DE VENTAS
-- Actualizado al 08 de Febrero del 2018
-- Vicente Cueva Ramirez.
Select	OV.OV_FechaOV as F_ORDEN, 
		Cast(OV.OV_FechaOV As Date) as FECHA,
		Case When OV.OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV.OV_FechaOV) END AS SEMANA,
		OV.OV_CodigoOV AS ORD_VEN,
		CL.CLI_CodigoCliente AS COD_CLI,
		CL.CLI_NombreComercial AS CLIENTE,
		PY.EV_Nombre AS PROYECTO,
		OV.OV_ReferenciaOC AS ORD_COM,
		IT.ART_GLN AS INSUMO,
		SUBSTRING(IT.ART_GLN,8,20) AS COD, 
		IT.ART_CodigoArticulo AS CODIGO,
		OD.OVD_ART_Nombre AS PRODUCTO,
		IT.ART_Comentarios AS DESCRIPCION,	
		OD.OVD_CMUM_Nombre AS UNIDAD,
		OVR.OVR_CantidadRequerida AS CANTIDAD,
		MN.MON_Nombre AS MONEDA,
		OVR.OVR_PrecioUnitario AS PRE_UNIT,
		OV.OV_MONP_Paridad AS TIP_CAMBIO,
		MM4.CMM_Valor AS TIP_CLIENTE,
		AF.AFAM_Nombre as FAMILIA,
		AC.ACAT_Nombre as CATEGORIA,
		OVR.OVR_FechaRequerida AS F_ENTREGA,
		OV.OV_Comentarios AS OBSERV
from OrdenesVenta OV 
inner join Clientes CL on OV.OV_CLI_ClienteId = CL.CLI_ClienteId
inner join OrdenesVentaDetalle OD on OV.OV_OrdenVentaId = OD.OVD_OrdenVentaId 
inner join OrdenesVentaReq OVR on OD.OVD_OVDetalleId = OVR.OVR_OVDetalleId
inner join Articulos IT on OD.OVD_ART_ArticuloId = IT.ART_ArticuloId
left join ClientesContactos CC on OV_CCON_ContactoId = CC.CCON_ContactoId
left join Eventos PY on OV.OV_EV_EventoId = PY.EV_EventoId
inner join Monedas MN on OV.OV_MON_MonedaId = MN.MON_MonedaId
left join ControlesMaestrosMultiples MM1 on OV.OV_CMM_EstadoOVId = MM1.CMM_ControllId
left join ControlesMaestrosMultiples MM2 on OV.OV_CMM_TipoOrdenVenta = MM2.CMM_ControllId
left join ControlesMaestrosMultiples MM3 on OV.OV_CMM_EstatusSolicitud = MM3.CMM_ControllId
left join ControlesMaestrosMultiples MM4 on CL.CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId
left join ArticulosFamilias AF on IT.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ArticulosCategorias AC on IT.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
where --DATEPART(YEAR, OV.OV_FechaOV) > 2017 
Cast(OV.OV_FechaOV As Date) BETWEEN '2018/01/03' and '2018/01/03'
--and OV.OV_CodigoOV = 'OV257'
Order By SEMANA, ORD_VEN



-- Para Montar en la Macro.
