-- 001 Consulta para Kardex de Cuentas por Pagar. 
-- Objetivo: Realizar Kardex de Cuentas por pagar por un Proveedor.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 15 de Junio del 2019; Inicio del reporte.
-- Actualizado: Lunes 17 de Junio del 2019; Culmen del Reporte.
-- Actualizado: Miercoles 26 de Junio del 2019; Cambio de FechaLibroMayor x FechaRegistro.
-- Actualizado: Jueves 04 de Julio del 2019; Usar en Plantillas FechaLibroMayor.

/*
Tipos de Registros para Cargos y Abonos a CxP
CMM_Control					CMM_Valor					CMM_ControllId
CMM_CCXP_TipoRegistroCXP	Cargo a proveedores			8B6357DB-5D23-4686-A566-B47E78E51DBE
CMM_CCXP_TipoRegistroCXP	Factura a proveedores		8DE7A83D-F674-461D-AD35-EF0FD2999EC6
CMM_CCXP_TipoRegistroCXP	Factura CXP					C73B4F7F-4F68-45DD-AA08-07A333D67C89
CMM_CCXP_TipoRegistroCXP	Nota de Debito				EACC069A-30E4-4C97-AA53-011AE2CFCE2C
CMM_CCXP_TipoRegistroCXP	Pago a Proveedor			AB008975-70E4-BC97-AA53-AFEBB0021394
CMM_CCXP_TipoRegistroCXP	PlantillaCXP				A8664AC1-4BB7-49D8-AB7F-ABD240F030D9
CMM_CCXP_TipoRegistroCXP	Transferencia Bancaria		E8D2CA9E-38BD-49F4-BDCF-9B2E0469BA67

En caso que sea PlantillaCXP A8664AC1-4BB7-49D8-AB7F-ABD240F030D9 se toma fecha de Registro. 
*/


Use iteknia
--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)
Declare @xNomMon as nvarchar(30)
Declare @ProveCod as nvarchar(30) 

Set @FechaIS = CONVERT (DATE, '2019-06-17', 102)
Set @FechaFS = CONVERT (DATE, '2019-06-26', 102) 
Set @xNomMon = 'Pesos'
--Set @xNomMon = 'Dolar'
Set @ProveCod = 'P323'
--Set @ProveCod = 'P598'

Select	MT_CXP.CODPRO,
		MT_CXP.NOMPRO,
		MT_CXP.FECHA,
		MT_CXP.REGISTRO, 
		MT_CXP.DOCTO,
		ROUND(SUM(MT_CXP.SALINI),2) as SALINI,
		ROUND(SUM(MT_CXP.CARGOS),2) as CARGOS,
		ROUND(SUM(MT_CXP.PAGOS),2) as PAGOS,
		ROUND(SUM(MT_CXP.NOTDB),2) as NOTDB,
		MT_CXP.MONEDA
from (

Select	UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,
		@FechaIS as FECHA,
		' SALDO INICIAL' AS REGISTRO,
		'INICIAL' AS DOCTO,
		( SUM ( ( ROUND (ISNULL( CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) , 2 ) - 
		ROUND ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * 
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario,0) ) - 
		( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * 
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
		ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS SALINI,
		0 as CARGOS,
		0 as PAGOS,
		Case When(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito
		= '6ED86360-8129-4481-B191-036D6727195A' 
		and Left(CXPR_CodigoRegistro,2) <> 'ND' then
		SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB,
		MON_Nombre as MONEDA
from CXPRegistros
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
Where CXPR_RegistroBorrado = 0 and MON_Nombre = @xNomMon
and PRO_CodigoProveedor = @ProveCod
and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) < @FechaIS  
Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito

UNION ALL

Select	PRO_CodigoProveedor as CODPRO,
		PRO_Nombre as NOMPRO,
		@FechaIS as FECHA,
		' SALDO INICIAL' AS REGISTRO,
		'INICIAL' AS DOCTO,
		ISNULL(ROUND ( CXPPD_MontoAplicado*-1 , 2), 0.00) AS SALINI,
		0 AS CARGOS,
		0 AS PAGOS,
		0 as NOTDB,
		MON_Nombre AS MONEDA
from CXPPagos 
Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId 
left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  
Where CXPP_Borrado = 0 and MON_Nombre = @xNomMon
and PRO_CodigoProveedor = @ProveCod
and CXPPD_CMM_TipoRegistro is not null
and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPP_FechaPago as DATE) < @FechaIS 

Union All

Select	UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,
		--CXPR_FechaRegistro as FECHA,
		Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECHA,

		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO,
		CXPR_CodigoRegistro as DOCTO,
		0 as SALINI,
		ISNULL(( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ),0) AS CARGOS,
		0 as PAGOS,
		Case When(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito
		= '6ED86360-8129-4481-B191-036D6727195A' 
		and Left(CXPR_CodigoRegistro,2) <> 'ND' then
		SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB,
		MON_Nombre as MONEDA
from CXPRegistros
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
Where CXPR_RegistroBorrado = 0 and MON_Nombre = @xNomMon
and PRO_CodigoProveedor = @ProveCod
and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) BETWEEN @FechaIS and @FechaFS  
Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, 
MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro

UNION ALL

Select	PRO_CodigoProveedor as CODPRO,
		PRO_Nombre as NOMPRO,
		CXPP_FechaPago as FECHA,  
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPP_CMM_FormaPago) + '  ' + (Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as REGISTRO,
		CXPP_IdentificacionPago as DOCTO,
		0 as SALINI,
		0 as CARGOS,
		ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGOS,
		0 as NOTDB,
		MON_Nombre as MONEDA
from CXPPagos
Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId 
left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  
Where CXPP_Borrado = 0 and MON_Nombre = @xNomMon
and PRO_CodigoProveedor = @ProveCod
and CXPPD_CMM_TipoRegistro is not null
and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPP_FechaPago as DATE) BETWEEN @FechaIS and @FechaFS  

) MT_CXP
Group By MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA
Order By MT_CXP.FECHA, MT_CXP.REGISTRO

 /* Script para Macro 17 Junio Edo de cuenta por proveedor.
    Script para Macro 20 Junio Integrar Notas de Debito. Quitar las que son ND
	Script para Macro 001, 27/Junio Segun Documento uso de Fecha. 

Select MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, ROUND(SUM(MT_CXP.SALINI),2) as SALINI, ROUND(SUM(MT_CXP.CARGOS),2) as CARGOS, ROUND(SUM(MT_CXP.PAGOS),2) as PAGOS, ROUND(SUM(MT_CXP.NOTDB),2) as NOTDB, MT_CXP.MONEDA from (Select	UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, '" & FechaIS & "' as FECHA, ' SALDO INICIAL' AS REGISTRO, 'INICIAL' AS DOCTO, ( SUM ( ( ROUND (ISNULL( CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) , 2 ) - ROUND ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario,0) ) - ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS SALINI, 0 as CARGOS, 0 as PAGOS, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre as MONEDA from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId Where CXPR_RegistroBorrado = 0 and MON_Nombre =  '" & xNomMon & "' and PRO_CodigoProveedor = '" & ProveCod & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
CXPR_FechaRegistro else CXPR_FechaReciboRegistro end as DATE) < '" & FechaIS & "'  Group by CXPR_FechaRegistro, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito UNION ALL Select	PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, '" & FechaIS & "' as FECHA, ' SALDO INICIAL' AS REGISTRO, 'INICIAL' AS DOCTO, ISNULL(ROUND ( CXPPD_MontoAplicado*-1 , 2), 0.00) AS SALINI, 0 AS CARGOS, 0 AS PAGOS, 0 as NOTDB, MON_Nombre AS MONEDA from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre =  '" & xNomMon & "'
and PRO_CodigoProveedor = '" & ProveCod & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) < '" & FechaIS & "' Union All Select	UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaRegistro else CXPR_FechaReciboRegistro end as DATE) as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO, CXPR_CodigoRegistro as DOCTO, 0 as SALINI, ISNULL(( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ),0) AS CARGOS, 0 as PAGOS, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre as MONEDA from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId  Where CXPR_RegistroBorrado = 0 and MON_Nombre =  '" & xNomMon & "'
and PRO_CodigoProveedor = '" & ProveCod & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaRegistro else CXPR_FechaReciboRegistro end as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  Group by CXPR_FechaRegistro, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro UNION ALL Select	PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, CXPP_FechaPago as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) + '  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as REGISTRO, CXPP_IdentificacionPago as DOCTO, 0 as SALINI, 0 as CARGOS, ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGOS,
0 as NOTDB, MON_Nombre as MONEDA from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre =  '" & xNomMon & "' and PRO_CodigoProveedor = '" & ProveCod & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  ) MT_CXP Group By MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA Order By MT_CXP.FECHA, MT_CXP.REGISTRO 







Select MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, ROUND(SUM(MT_CXP.SALINI),2) as SALINI, ROUND(SUM(MT_CXP.CARGOS),2) as CARGOS, ROUND(SUM(MT_CXP.PAGOS),2) as PAGOS, ROUND(SUM(MT_CXP.NOTDB),2) as NOTDB, MT_CXP.MONEDA from (Select	UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, '" & FechaIS & "' as FECHA, ' SALDO INICIAL' AS REGISTRO, 'INICIAL' AS DOCTO, ( SUM ( ( ROUND (ISNULL( CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) , 2 ) - ROUND ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario,0) ) - ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS SALINI, 0 as CARGOS, 0 as PAGOS, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre as MONEDA from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId Where CXPR_RegistroBorrado = 0 and MON_Nombre =  '" & xNomMon & "' and PRO_CodigoProveedor = '" & ProveCod & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
CXPR_FechaRegistro else CXPR_FechaReciboRegistro end as DATE) < '" & FechaIS & "'  Group by CXPR_FechaRegistro, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito UNION ALL Select	PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, '" & FechaIS & "' as FECHA, ' SALDO INICIAL' AS REGISTRO, 'INICIAL' AS DOCTO, ISNULL(ROUND ( CXPPD_MontoAplicado*-1 , 2), 0.00) AS SALINI, 0 AS CARGOS, 0 AS PAGOS, 0 as NOTDB, MON_Nombre AS MONEDA from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre =  '" & xNomMon & "'
and PRO_CodigoProveedor = '" & ProveCod & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) < '" & FechaIS & "' Union All Select	UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaRegistro else CXPR_FechaReciboRegistro end as DATE) as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO, CXPR_CodigoRegistro as DOCTO, 0 as SALINI, ISNULL(( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ),0) AS CARGOS, 0 as PAGOS, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre as MONEDA from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId  Where CXPR_RegistroBorrado = 0 and MON_Nombre =  '" & xNomMon & "'
and PRO_CodigoProveedor = '" & ProveCod & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaRegistro else CXPR_FechaReciboRegistro end as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  Group by CXPR_FechaRegistro, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro UNION ALL Select	PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, CXPP_FechaPago as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) + '  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as REGISTRO, CXPP_IdentificacionPago as DOCTO, 0 as SALINI, 0 as CARGOS, ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGOS,
0 as NOTDB, MON_Nombre as MONEDA from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre =  '" & xNomMon & "' and PRO_CodigoProveedor = '" & ProveCod & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  ) MT_CXP Group By MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA Order By MT_CXP.FECHA, MT_CXP.REGISTRO 



' Script para Macro 001, 04 de Julio Plantillas usar FechaLibroMayor. 
SSQL = "Select MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, ROUND(SUM(MT_CXP.SALINI),2) as SALINI, ROUND(SUM(MT_CXP.CARGOS),2) as CARGOS, ROUND(SUM(MT_CXP.PAGOS),2) as PAGOS, ROUND(SUM(MT_CXP.NOTDB),2) as NOTDB, MT_CXP.MONEDA from (Select	UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, '" & FechaIS & "' as FECHA, ' SALDO INICIAL' AS REGISTRO, 'INICIAL' AS DOCTO, ( SUM ( ( ROUND (ISNULL( CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) , 2 ) - ROUND ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario,0) ) - ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) *  " _
& " ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS SALINI, 0 as CARGOS, 0 as PAGOS, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre as MONEDA from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId Where CXPR_RegistroBorrado = 0 and MON_Nombre =  '" & xNomMon & "' and PRO_CodigoProveedor = '" & ProveCod & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then " _
& " CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) < '" & FechaIS & "'  Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito UNION ALL Select	PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, '" & FechaIS & "' as FECHA, ' SALDO INICIAL' AS REGISTRO, 'INICIAL' AS DOCTO, ISNULL(ROUND ( CXPPD_MontoAplicado*-1 , 2), 0.00) AS SALINI, 0 AS CARGOS, 0 AS PAGOS, 0 as NOTDB, MON_Nombre AS MONEDA from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre =  '" & xNomMon & "' " _
& " and PRO_CodigoProveedor = '" & ProveCod & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) < '" & FechaIS & "' Union All Select	UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO, CXPR_CodigoRegistro as DOCTO, 0 as SALINI, ISNULL(( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) +  " _
& " ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ),0) AS CARGOS, 0 as PAGOS, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre as MONEDA from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId  Where CXPR_RegistroBorrado = 0 and MON_Nombre =  '" & xNomMon & "' " _
& " and PRO_CodigoProveedor = '" & ProveCod & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro UNION ALL Select	PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, CXPP_FechaPago as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) + '  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as REGISTRO, CXPP_IdentificacionPago as DOCTO, 0 as SALINI, 0 as CARGOS, ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGOS, " _
& " 0 as NOTDB, MON_Nombre as MONEDA from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre =  '" & xNomMon & "' and PRO_CodigoProveedor = '" & ProveCod & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  ) MT_CXP Group By MT_CXP.FECHA, MT_CXP.REGISTRO, MT_CXP.DOCTO, MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA Order By MT_CXP.FECHA, MT_CXP.REGISTRO  " 
& ") MT_CXP Group By MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA Order By MT_CXP.NOMPRO  "

/*