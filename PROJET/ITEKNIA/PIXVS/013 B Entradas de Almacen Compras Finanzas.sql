-- 013B Consulta para Reporte de Entradas de Articulos por Compras.
-- Ing. Vicente Cueva R.
-- Jueves 17 de Mayo del 2018
-- Actualizado Jueves 12 de Julio del 2018
-- Actualizado Viernes 10 de Agosto del 2018 Fecha del Registro y quitar los Borrados.
-- Actualizado Jueves 16 de Agosto del 2018; Cambiar a Fecha CXPR_FechaReciboRegistro en lugar de la de Registro.
-- Actualizado: Sabado 20 de Agosto del 2018; Agregar cuentas contables para usar en reporte 13G
Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2018-10-19'
Set @FechaFS = '2018-10-19' 

-- Consulta para Cargar informacion de la compras para Finanzas (CXP)
-- Compra cargadas a CXP rango por fecha del Registro.
--Consulta cargue el 24/Octubre/ de la Macro 13C
Select  OC_CodigoOC as ORDEN, 
		OCRC_FechaRecibo AS F_RECIBO, 
		CXPR_FechaReciboRegistro AS F_FACT, 
		CXPR_FechaRegistro AS F_PASIVO, 
		PRO_CodigoProveedor AS COD_PROV,  
		PRO_Nombre AS NOM_PROV, 
		EV_CodigoEvento AS C_PROY, 
		EV_Descripcion AS PROYECTO, 
		ART_CodigoArticulo AS CODE_ART, 
		OCD_DescripcionArticulo AS ARTICULO, 
		OCD_CMUM_UMCompras AS UMC, 
		ISNULL(OCD_AFC_FactorConversion, 1) AS ARTxUNI, 
		(Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,10)) AS UMI, 
		OCRC_CantidadRecibo AS CANTIDAD, 
		OCRC_PrecioOrdenCompraAlRecibir AS COSTO, 
		(OCFR_PrecioUnitario * (1-OCFR_PorcentajeDescuento) / OCD_AFC_FactorConversion ) AS COSTO_OC, 
		EMP_CodigoEmpleado AS C_EMPL, 
		RTRIM(EMP_Nombre)+' '+RTRIM(EMP_PrimerApellido) AS NOM_EMPL, 
		CXPR_CodigoRegistro AS NUM_FACT, CXPRD_Cantidad AS CAN_REG, 
		CXPRD_PrecioUnitario AS PREC_REG, 
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPR_MON_MonedaId) AS MONEDA, 
		ISNULL(CXPR_MONP_Paridad, 1) AS PARIDAD, 
		CXPRD_CMIVA_Porcentaje AS PORC_IVA, 
		(CXPRD_PrecioUnitario * (1-CXPRD_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1) ) AS PRE_REGDESC 
from OrdenesCompraRecibos 
inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId 
left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId 
inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos on OC_EV_ProyectoId = EV_EventoId 
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join OrdenesCompraDetalle on  OCD_PartidaId = OCFR_OCD_PartidaId 
left join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
where OC_Borrado = 0 and 
--Cast(CXPR_FechaReciboRegistro As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' 
Cast(CXPR_FechaReciboRegistro As Date) BETWEEN @FechaIS and @FechaFS 
--and (EV_CodigoEvento <> 'GASTOS ADMINISTRATIVOS' and EV_CodigoEvento is not null) 
and CXPR_RegistroBorrado = 0 
and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC

--Consulta del 24 de OCtubre del 2018 del 13G (cuentas contables).
Select	OC_CodigoOC as ORDEN, 
		OCRC_FechaRecibo AS F_RECIBO, 
		CXPR_FechaReciboRegistro AS F_FACT, 
		CXPR_FechaRegistro  AS F_PASIVO, 
		Case When (ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables 
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples 
		where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA')) <> 'S/CTA' Then 
		(ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables 
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples 
		where CMM_ControllId = OCD_CMM_CuentaComprasId)),'S/CTA'))  Else 
		(ISNULL((Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables 
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples 
		where CMM_ControllId = ART_CMM_CtaInventarioId)),'S/CTA')) End AS CUCO, 
		PRO_CodigoProveedor AS COD_PROV, PRO_Nombre AS NOM_PROV, 

		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables 
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples 
		Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP, EV_CodigoEvento AS C_PROY, 
		
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
		CXPRD_CMIVA_Porcentaje AS PORC_IVA, 
		(CXPRD_PrecioUnitario * (1-CXPRD_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1) ) AS PRE_REGDESC
from OrdenesCompraRecibos 
inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId 
left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId  
inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos on OC_EV_ProyectoId = EV_EventoId 
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join OrdenesCompraDetalle on  OCD_PartidaId = OCFR_OCD_PartidaId 
left join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
Where OC_Borrado = 0 
and (Cast(CXPR_FechaReciboRegistro As Date) BETWEEN @FechaIS and @FechaFS ) 
and CXPR_RegistroBorrado = 0 
--and OC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' 
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 






/*
-- Consulta anterior del 21/Octubre/2018
Select	OC_CodigoOC as ORDEN, 
		OCRC_FechaRecibo AS F_RECIBO,
		CXPR_FechaReciboRegistro AS F_FACT,
		CXPR_FechaRegistro  AS F_PASIVO,
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



		PRO_CodigoProveedor AS COD_PROV, 
		PRO_Nombre AS NOM_PROV, 

		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP,
	

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
		CXPRD_CMIVA_Porcentaje AS PORC_IVA,
		(CXPRD_PrecioUnitario * (1-CXPRD_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1) ) AS PRE_REGDESC 
		
from OrdenesCompraRecibos 
inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId
left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId 
inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos on OC_EV_ProyectoId = EV_EventoId 
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join OrdenesCompraDetalle on  OCD_PartidaId = OCFR_OCD_PartidaId 
left join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
Where OC_Borrado = 0 and (Cast(CXPR_FechaReciboRegistro As Date) BETWEEN @FechaIS and @FechaFS )
and OC_MON_MonedaId <> '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'

-- ESTO ES PARA 13C -- and (EV_CodigoEvento <> 'GASTOS ADMINISTRATIVOS' and EV_CodigoEvento is not null) and CXPR_RegistroBorrado = 0 
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 



--where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' 
-- and (EV_CodigoEvento = 'GASTOS ADMINISTRATIVOS' or EV_CodigoEvento is null) and CXPR_RegistroBorrado = 0 
--where OC_CodigoOC = 'OC2611'


-- Consulta antes del 10 de Agosto

-- Consulta para Cargar informacion de la compras para Finanzas (CXP)
-- Compra de Materiales 
Select	OC_CodigoOC as ORDEN, 
		Cast (OCRC_FechaRecibo AS DATE) AS F_RECIBO,
		PRO_CodigoProveedor AS COD_PROV, 
		PRO_Nombre AS NOM_PROV, 
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
		CXPRD_CMIVA_Porcentaje AS PORC_IVA,
		(CXPRD_PrecioUnitario * (1-CXPRD_PorcentajeDescuento) / ISNULL(OCD_AFC_FactorConversion, 1) ) AS PRE_REGDESC 
from OrdenesCompraRecibos 
inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId
left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId 
inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
inner join Empleados on OCRC_EMP_ModificadoPor = EMP_EmpleadoId 
inner join Proveedores on OC_PRO_ProveedorId = PRO_ProveedorId 
left join Eventos on OC_EV_ProyectoId = EV_EventoId 
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId 
inner join OrdenesCompraDetalle on  OCD_PartidaId = OCFR_OCD_PartidaId 
left join Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
where OC_Borrado = 0 and (Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS )
--where OC_Borrado = 0 and Cast(OCRC_FechaRecibo As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "' 
and (EV_CodigoEvento <> 'GASTOS ADMINISTRATIVOS' and EV_CodigoEvento is not null)
order by Cast(OCRC_FechaRecibo AS DATE), OC_CodigoOC 
*/
