-- 013 Consulta para Reporte de Entradas de Articulos por Compras.
-- Ing. Vicente Cueva R.
-- Jueves 17 de Mayo del 2018

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2018-05-16'
Set @FechaFS = '2018-05-16' 

Select	OC_CodigoOC as ORDEN, 
		Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO,
		PRO_CodigoProveedor AS CLIENTE,
		OC_PDOC_Nombre AS RAZON_SOC,
		OCRC_Comentarios AS NOTAS,
		EV_CodigoEvento AS C_PROY,
		EV_Descripcion AS PROYECTO,
		ART_CodigoArticulo AS CODE_ART,
		OCD_DescripcionArticulo AS ARTICULO,
		OCD_CMUM_UMCompras AS UMC,
		OCD_AFC_FactorConversion AS FACT,
		OCD_CMUM_UMInventario AS UMI,
		CANTIDAD_RECIBIDA AS CANTIDAD,
		OCRC_PrecioOrdenCompraAlRecibir AS COSTO,
		(OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / OCD_AFC_FactorConversion )AS COSTO_OC,
		EMP_CodigoEmpleado AS C_EMPL,
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL,
		OrdenesCompraFechasRequeridas.*
from OrdenesCompra
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId
INNER JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId
LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir
FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId
left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC


