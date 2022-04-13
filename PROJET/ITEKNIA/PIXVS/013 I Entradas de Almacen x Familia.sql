-- 013 I Consulta para Reporte de Entradas de Articulos por Familia.
-- Ing. Vicente Cueva R.
-- Actualizado: Martes 19 de Febrero del 2019; Origen.

-- Declaración de Variables

DECLARE @FechaIS date
DECLARE @FechaFS date
DECLARE @Familia VarChar(30)

Set @FechaIS = CONVERT (DATE, '2019-01-01', 102)
Set @FechaFS = CONVERT (DATE, '2019-02-19', 102) 
Set @Familia = 'MP METALES'

-- Consulta de Compras de acuerdo a la Familia del Articulo.
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
		AF.AFAM_Nombre as FAMILIA,
	   AC.ACAT_Nombre as CATEGORIA,
	   SC.CMM_Valor as SUB_CAT,
	   
		OCD_AFC_FactorConversion AS FACT, 
		--OCD_CMUM_UMInventario AS UMI, 
		(Select CMUM_Nombre from ControlesMaestrosUM
		Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,10)) AS UMI,
		CANTIDAD_RECIBIDA AS CANTIDAD, 
		OCFR_PrecioUnitario AS COSTO,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, 
		 OC_MON_MonedaId   ,
		(OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1)) AS COSTO_OC, 
		EMP_CodigoEmpleado AS C_EMPL, 
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL 
from OrdenesCompra 
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId 
left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 

left join ArticulosFamilias AF on ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ArticulosCategorias AC on ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
left join ControlesMaestrosMultiples SC on ART_SubCategoriaId = SC.CMM_ControllId
	
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId 
Left  Join (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
and AF.AFAM_Nombre = @Familia
order by ARTICULO, Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 
