-- 013 G Consulta para Reporte de Entradas de Articulos por Compras agrupado por Cuentas Contables.
-- Ing. Vicente Cueva R.
-- Actualizado: Miercoles 19 de Septiembre del 2018; Origen.
-- Actualizado: Jueves 17 de Julio del 2018; Culmen.
-- Actualizado: Miercoles 10 de Octurbre del 2018; Anexar Cuenta del Proveedor y separar IVA. 
-- Actualizado: Martes 30 de Octubre del 2018; Regenerar consulta para integrar Descuentos.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-10-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-10-10', 102) 

-- Esta consulta es la que esta en el reporte 13G
Select OC_CodigoOC as ORDEN, OCRC_FechaRecibo AS F_RECIBO, CXPR_FechaReciboRegistro AS F_FACT,
 CXPR_FechaRegistro  AS F_PASIVO, 
 Case When (ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA')) <> 'S/CTA' Then (ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA'))  Else (ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples
where CMM_ControllId = ART_CMM_CtaInventarioId)),'S/CTA')) End AS CUCO, 
PRO_CodigoProveedor AS COD_PROV, 
PRO_Nombre AS NOM_PROV,
(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP,
 EV_CodigoEvento AS C_PROY, 
 EV_Descripcion AS PROYECTO, 
 ART_CodigoArticulo AS CODE_ART, 
 OCD_DescripcionArticulo AS ARTICULO, 
 OCD_CMUM_UMCompras AS UMC, 
 ISNULL(OCD_AFC_FactorConversion, 1) AS ARTxUNI, 
 OCD_CMUM_UMInventario AS UMI, 
 OCRC_CantidadRecibo AS CANTIDAD, 
 OCRC_PrecioOrdenCompraAlRecibir AS COSTO, 
 
 (OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / OCD_AFC_FactorConversion ) AS COSTO_OC,
 
EMP_CodigoEmpleado AS C_EMPL, 
RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL, 
CXPR_CodigoRegistro AS NUM_FACT, 
CXPRD_Cantidad AS CAN_REG, 
CXPRD_PrecioUnitario AS PREC_REG, 
(Select MON_Nombre from Monedas Where MON_MonedaId = CXPR_MON_MonedaId) AS MONEDA,
ISNULL(CXPR_MONP_Paridad, 1) AS PARIDAD, 
CXPRD_CMIVA_Porcentaje AS PORC_IVA, (CXPRD_PrecioUnitario * (1-CXPRD_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1) ) AS PRE_REGDESC

from OrdenesCompraRecibos inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId  inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId left join Eventos on OC_EV_ProyectoId = EV_EventoId inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId inner join OrdenesCompraDetalle on  OCD_PartidaId = OCFR_OCD_PartidaId left join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId Where OC_Borrado = 0 and (Cast(CXPR_FechaReciboRegistro As Date)  BETWEEN '" & FechaIS & "' and '" & FechaFS & "') and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' and CXPR_RegistroBorrado = 0 order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 




-- Antes del 30 de Octubre 2018
/*
-- Declare @FechaIS nvarchar(30)
-- Declare @FechaFS nvarchar(30)
-- Parametros Fecha Inicial y Fecha Final
-- Set @FechaIS = '2018-10-01'
-- Set @FechaFS = '2018-10-04' 

Select	OC_CodigoOC as ORDEN, 
		OCRC_FechaRecibo AS F_RECIBO, 
		CXPR_FechaReciboRegistro AS F_FACT, 
		CXPR_FechaRegistro AS F_PASIVO,
		Case When
		(ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA')) <> 'S/CTA' Then
		(ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA'))  Else
		(ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = ART_CMM_CtaInventarioId)),'S/CTA')) End AS CUCO,

		(PRO_CodigoProveedor) + '  ' + OC_PDOC_Nombre AS PROVEER, 
		
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP,
				
		(EV_CodigoEvento) + '   ' + EV_Descripcion AS PROYECTO, 
		(ISNULL(ART_CodigoArticulo, '0000')) + '   ' +	OCD_DescripcionArticulo AS ARTICULO, 
		OCD_CMUM_UMCompras AS UMC, 
		ISNULL(OCD_AFC_FactorConversion, 1) AS FACT, 
		(Select CMUM_Nombre from ControlesMaestrosUM
		Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,10)) AS UMI,
		CANTIDAD_RECIBIDA AS CANTIDAD, 
		OCFR_PrecioUnitario AS COSTO,
		(Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, 
		(OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1)) AS COSTO_OC,
		ISNULL(OC_CMIVA_PorcentajeIVA, 0) AS P_IVA
from OrdenesCompra 
inner join OrdenesCompraDetalle on OC_OrdenCompraId =  OCD_OC_OrdenCompraId 
left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
inner join OrdenesCompraFechasRequeridas on OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId 
LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA,OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_EMP_ModificadoPor, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir FROM OrdenesCompraRecibos GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId, OCRC_FechaRecibo, OCRC_Comentarios, OCRC_PrecioOrdenCompraAlRecibir, OCRC_EMP_ModificadoPor) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join Proveedores PRO on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos PRY on OC_EV_ProyectoId = EV_EventoId 
where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
--where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' 
and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 






		ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (
		Select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA')  AS CCM,

		ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (
		Select CMM_Valor from ControlesMaestrosMultiples
		where CMM_ControllId = ART_CMM_CtaInventarioId)),'S/CTA')  AS CCI,
		*/