-- 013 A Consulta para Reporte de Entradas de Articulos por Compras.
-- Ing. Vicente Cueva R.
-- Actualizado: Lunes 12 de Agosto del 2018; Origen.
-- Actualizado: 

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2019-10-08'
Set @FechaFS = '2019-10-08' 

-- NOTAS: En tabla OrdenesCompraDetalle 
-- OCD_CMM_TipoPartidaId = '2AF823A9-0979-4844-A35B-8F2AE756B412'= Miscelaneos
-- OCD_CMM_TipoPartidaId = '780769BC-1DF2-4F79-ADC4-A9AEC21370F5'= Articulos


-- 24 registros a la fecha del 08 de Octubre del 2019
--Select *
--from OrdenesCompraRecibos
--where Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 

Select	OC_CodigoOC as OC,
		OCRC_FechaRecibo as FECH_RECIBO,
		PRO_CodigoProveedor as COD_PROV,
		PRO_Nombre as RAZON_SOC,
		PRY_CodigoEvento as COD_PRY,
		PRY_NombreProyecto as NOM_PRY,
		
		ISNULL((Select ART_CodigoArticulo from Articulos Where ART_ArticuloId = OCD_ART_ArticuloId),'Miscelaneo') as COD_ART,
		ISNULL((Select ART_Nombre from Articulos Where ART_ArticuloId = OCD_ART_ArticuloId),OCD_DescripcionArticulo) as ARTICULO,
		
		OCRC_CantidadRecibo as CANT_REC,
		OCD_CMUM_UMCompras as UMC,
		ISNULL(OCD_AFC_FactorConversion, 1) as FACT_CONV,
		
		(Select MON_Abreviacion from Monedas where MON_MonedaId = OC_MON_MonedaId) as MONEDA,
		OCRC_TipoCambio as TIP_CA,
		OCFR_PrecioUnitario as PRECIO,
		OCD_CMIVA_PorcentajeIVA as IVA,
		OCFR_PorcentajeDescuento as DESCU,
		ISNULL(OCD_CMUM_UMInventario,OCD_CMUM_UMCompras)  as UMI
from OrdenesCompraRecibos
inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join Proveedores on PRO_ProveedorId = OC_PRO_ProveedorId
inner join Proyectos on PRY_ProyectoId = OC_EV_ProyectoId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId
inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId
where Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
























/*
Select	OC_CodigoOC as ORDEN, 
		Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO, 
		PRO_CodigoProveedor AS CLIENTE, 
		OC_PDOC_Nombre AS RAZON_SOC, 
		OCRC_Comentarios AS NOTAS, 
		PRY_CodigoEvento AS C_PROY, 
		PRY_NombreProyecto AS PROYECTO, 
		ART_CodigoArticulo AS CODE_ART, 
		OCD_DescripcionArticulo AS ARTICULO, 
		OCD_CMUM_UMCompras AS UMC, 
		OCD_AFC_FactorConversion AS FACT, 
		--OCD_CMUM_UMInventario AS UMI, 
		(Select CMUM_Nombre from ControlesMaestrosUM
		Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,'5A929D93-D43D-4F8F-8985-0624A61C5A82')) AS UMI,
		--CANTIDAD_RECIBIDA AS CANTIDAD, 
		OCFR_PrecioUnitario AS COSTO,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, 
		 OC_MON_MonedaId   ,
		(OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1)) AS COSTO_OC
		--EMP_CodigoEmpleado AS C_EMPL, 
		--RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL 
from OrdenesCompra 
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId 
left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId 
LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Proyectos PRY on OC_EV_ProyectoId = PRY_ProyectoId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
-- where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' 
-- and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 


-- Select * from Proyectos



SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, 
OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, 
OCRC_PrecioOrdenCompraAlRecibir 
FROM OrdenesCompraRecibos 
GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, 
OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor

) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 

*/