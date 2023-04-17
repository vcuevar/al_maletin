-- 013 Consulta para Reporte de Entradas de Articulos por Compras.
-- SISTEMA: MULIIX
-- Ing. Vicente Cueva R.
-- Actualizado: Viernes 17 de Octubre del 2019; Origen.

--Parametros Fecha Inicial y Fecha Final
DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2022-11-30', 102)
Set @FechaFS = CONVERT (DATE, '2022-11-30', 102) 

Select	OC_CodigoOC as ORDEN,
		OCRC_FechaRecibo AS F_RECIBO,
		PRO_CodigoProveedor AS PROVEEDOR, 
		PRO_NombreComercial AS RAZON_SOC, 
		OCRC_Comentarios AS NOTAS, 
		--PRY_CodigoEvento AS C_PROY, 
		PRY_NombreProyecto AS PROYECTO, 
		ISNULL(ART_CodigoArticulo, 'MISC') AS CODE,
		OCD_DescripcionArticulo AS ARTICULO, 
		ISNULL(OCD_AFC_FactorConversion,1) AS FACT,
		 
		Isnull(OCD_CMUM_UMCompras,'No Aplica') as UMOC,

		(Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,'5A929D93-D43D-4F8F-8985-0624A61C5A82')) AS UMI, 
		CANTIDAD_RECIBIDA AS CANTIDAD, 
		
		(OCFR_PrecioUnitario * (1-(OCFR_PorcentajeDescuento/100)) / ISNULL(OCD_AFC_FactorConversion, 1)) AS COSTO_OC, 
		(CANTIDAD_RECIBIDA * (OCFR_PrecioUnitario * (1-(OCFR_PorcentajeDescuento/100)) / ISNULL(OCD_AFC_FactorConversion, 1))) AS IMPORTE,

		(Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA,
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL 
From OrdenesCompra 
inner join OrdenesCompraDetalle on OC_OrdenCompraId = OCD_OC_OrdenCompraId 
left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId 
left join (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,
	OCRC_OC_OrdenCompraId, OCRC_OCFR_FechaRequeridaId, OCRC_EMP_ModificadoPorId, 
	OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir 
	FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, 
	OCRC_OCFR_FechaRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, 
	OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPorId
) AS OCRecibos ON OC_OrdenCompraId = OCRecibos.OCRC_OC_OrdenCompraId 
  AND OCFR_FechaRequeridaId = OCRecibos.OCRC_OCFR_FechaRequeridaId 
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId 
inner join Empleados on OCRC_EMP_ModificadoPorId = EMP_EmpleadoId 
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS
order by MONEDA desc, F_RECIBO, OC_CodigoOC


