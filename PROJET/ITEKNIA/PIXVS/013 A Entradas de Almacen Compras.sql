-- 013 A Consulta para Reporte de Entradas de Articulos por Compras.
-- Ing. Vicente Cueva R.
-- Actualizado Jueves 17 de Mayo del 2018; Origen.
-- Actualizado Jueves 17 de Julio del 2018; Anexar las compras Misceláneas.

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2018-08-01'
Set @FechaFS = '2018-08-18' 

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
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId 
LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
--where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' 
and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 

/*
--Primer Parte del Reporte Pesos
Select OC_CodigoOC as ORDEN, Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO, PRO_CodigoProveedor AS CLIENTE, OC_PDOC_Nombre AS RAZON_SOC, OCRC_Comentarios AS NOTAS, EV_CodigoEvento AS C_PROY, EV_Descripcion AS PROYECTO, ART_CodigoArticulo AS CODE_ART, OCD_DescripcionArticulo AS ARTICULO, OCD_CMUM_UMCompras AS UMC, OCD_AFC_FactorConversion AS FACT, OCD_CMUM_UMInventario AS UMI, CANTIDAD_RECIBIDA AS CANTIDAD, OCFR_PrecioUnitario AS COSTO, (Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, (OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1)) AS COSTO_OC, EMP_CodigoEmpleado AS C_EMPL, RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL 
from OrdenesCompra inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 


-- Segunda Parte del Reporte Monedas Extranjeras.
Select OC_CodigoOC as ORDEN, Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO, PRO_CodigoProveedor AS CLIENTE, OC_PDOC_Nombre AS RAZON_SOC, OCRC_Comentarios AS NOTAS, EV_CodigoEvento AS C_PROY, EV_Descripcion AS PROYECTO, ART_CodigoArticulo AS CODE_ART, OCD_DescripcionArticulo AS ARTICULO, OCD_CMUM_UMCompras AS UMC, OCD_AFC_FactorConversion AS FACT, OCD_CMUM_UMInventario AS UMI, CANTIDAD_RECIBIDA AS CANTIDAD, OCFR_PrecioUnitario AS COSTO, (Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, (OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1)) AS COSTO_OC, EMP_CodigoEmpleado AS C_EMPL, RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL 
from OrdenesCompra inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 



*/
















/*
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
		OCFR_PrecioUnitario AS COSTO,
		(OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / OCD_AFC_FactorConversion )AS COSTO_OC, 
		EMP_CodigoEmpleado AS C_EMPL, 
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL ,
		OrdenesCompraFechasRequeridas.*
from OrdenesCompra 
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId 
Left join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId 
left join (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, 
OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos 
GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, 
OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND 
OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC



Select	OC_CodigoOC as ORDEN, 
		Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO,
		PRO_CodigoProveedor AS COD_PROV,
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
		
		--(Select CXPR_CodigoRegistro 
		--from OrdenesCompraRecibos
		--left join CXPRegistrosDetalle on OCRC_ReciboId = CXPRD_OCRC_ReciboId
		--left join CXPRegistros on CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
		--where OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId) AS NUM_FACT,

		OC_OrdenCompraId, OCRC_OC_OrdenCompraId, OCFR_FechaRequeridaId, OCRC_OCR_OCRequeridaId,
		EMP_CodigoEmpleado AS C_EMPL,
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL
from OrdenesCompra
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId
INNER JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId
LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA, OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir
FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId
left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId
--where OC_OrdenCompraId = '778F973B-DA57-4FF8-AC96-2D030208967E'
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS
order by F_RECIBO, ORDEN



Select CXPR_CodigoRegistro, *
from OrdenesCompraRecibos
left join CXPRegistrosDetalle on OCRC_ReciboId = CXPRD_OCRC_ReciboId
left join CXPRegistros on CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
--where OCRC_OCR_OCRequeridaId = 'C4D64A07-CCFF-4AE7-B574-E42DDCC1BE2F'
where OCRC_OC_OrdenCompraId  = '778F973B-DA57-4FF8-AC96-2D030208967E'
AND OCRC_OCR_OCRequeridaId = '778F973B-DA57-4FF8-AC96-2D030208967E'

--) AS NUM_FACT,

Select * from OrdenesCompraFechasRequeridas
Where OCFR_FechaRequeridaId = 'C4D64A07-CCFF-4AE7-B574-E42DDCC1BE2F'

Select CXPR_CodigoRegistro, CXPRD_PRY_ProyectoId , CXPRegistrosDetalle.* 
from OrdenesCompraRecibos
left join CXPRegistrosDetalle on OCRC_ReciboId = CXPRD_OCRC_ReciboId
left join CXPRegistros on CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
Where Cast(OCRC_FechaRecibo As Date) BETWEEN '2018-07-14' and '2018-07-14'

where OCRC_OCR_OCRequeridaId = 'C4D64A07-CCFF-4AE7-B574-E42DDCC1BE2F'


where OCRC_OC_OrdenCompraId = '778F973B-DA57-4FF8-AC96-2D030208967E'





--Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
--and OCRC_OC_OrdenCompraId = '778F973B-DA57-4FF8-AC96-2D030208967E'






Select	OC_CodigoOC as ORDEN, 
		Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO,
		PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS NOM_PROV,
		OCRC_Comentarios AS NOTAS,
		EV_CodigoEvento AS C_PROY,
		EV_Descripcion AS PROYECTO,
	--	ART_CodigoArticulo AS CODE_ART,
		--OCD_DescripcionArticulo AS ARTICULO,
		--OCD_CMUM_UMCompras AS UMC,
		--OCD_AFC_FactorConversion AS FACT,
		--OCD_CMUM_UMInventario AS UMI,
		OCRC_CantidadRecibo AS CANTIDAD,
		OCRC_PrecioOrdenCompraAlRecibir AS COSTO,
		EMP_CodigoEmpleado AS C_EMPL,
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL

from OrdenesCompraRecibos
inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId 
--inner join OrdenesCompraFechasRequeridas on OCFR_OC_OrdenCompraId = OC_OrdenCompraId and  OCFR_OCD_PartidaId = OCD_PartidaId
left join CXPRegistrosDetalle on OCRC_ReciboId = CXPRD_OCRC_ReciboId
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId
left join Eventos on OC_EV_ProyectoId = EV_EventoId
--inner join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId



Select * from OrdenesCompraRecibos
Where Cast(OCRC_FechaRecibo As Date) BETWEEN '2018-07-13' and '2018-07-13'
--where OCRC_ReciboId = 'E5C957F9-A076-4565-BC4F-095644B6471D'





Select * from OrdenesCompra
--where OC_CodigoOC = 'OC2125'
where OC_OrdenCompraId = '778F973B-DA57-4FF8-AC96-2D030208967E'

Select * from OrdenesCompraDetalle
where OCD_OC_OrdenCompraId = '778F973B-DA57-4FF8-AC96-2D030208967E'



Where OCFR_OC_OrdenCompraId = '818B2AD5-2B41-478F-B77C-0DD4F311767C' and OCFR_OCD_PartidaId = '2EAE2A90-9FFD-48C3-945D-93929F22DECA'

where OCRC_OC_OrdenCompraId  = '818B2AD5-2B41-478F-B77C-0DD4F311767C'
where OCRC_ReciboId = 'E5C957F9-A076-4565-BC4F-095644B6471D'


Select * from CXPRegistros
where CXPR_RegistroCXPId = '855C9DEF-4883-4C61-9C36-F6D4D543B330'

Select * from CXPRegistrosDetalle 
Where CXPRD_OCRC_ReciboId = 'E5C957F9-A076-4565-BC4F-095644B6471D'

Select * from CXPPagos
Where CXPP_PagoCXPId = '76A6C2F0-13A9-42FD-BB67-D294AA959098'

Select * from CXPPagosDetalle
where CXPPD_CXPR_RegistroCXPId = '855C9DEF-4883-4C61-9C36-F6D4D543B330'

Select * from ControlesMaestrosMultiples
where CMM_ControllId = '42B7AE60-A156-4647-A85B-56581A74B2B8'

(Select MON_Nombre from Monedas Where MON_MonedaId = CXPR_MON_MonedaId) AS MONEDA
748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1


Select * from OrdenesCompra
where OC_CodigoOC = 'OC2243'
--where OC_OrdenCompraId = '8B2D9EC0-FB2F-4E20-9C97-1B0BFC32E0AE' -- Id de la Orden de Compra

Select * from OrdenesCompraRecibos
where OCRC_OC_OrdenCompraId = '8B2D9EC0-FB2F-4E20-9C97-1B0BFC32E0AE' --Orden de Compra 

Select * from CXPRegistrosDetalle 
Where CXPRD_OCRC_ReciboId = 'CF4151EF-8A84-4B1C-B98F-6423757CB419'  -- Id Recibo de Compras

Select * from CXPRegistros
where CXPR_RegistroCXPId = 'C5C1045F-FD3E-42DC-ABB3-1CF52BECDDF1'

Select * from CXPRegistros
where CXPR_RegistroCXPId = 'B18A2467-C717-4B53-A8B2-00DD107FD517'

Select * from OrdenesCompraFechasRequeridas
Where OCFR_FechaRequeridaId = '2D717D95-1C65-41F3-977A-03AE03C964B1'


Select * from OrdenesCompraDetalle
where OCD_PartidaId = OCFR_OCD_PartidaId
2EAE2A90-9FFD-48C3-945D-93929F22DECA'2EAE2A90-9FFD-48C3-945D-93929F22DECA'




Select CXPR_CodigoRegistro, * 
from OrdenesCompraRecibos 
left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId
inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
Where CXPRD_OCRC_ReciboId = 'E5C957F9-A076-4565-BC4F-095644B6471D'



*/