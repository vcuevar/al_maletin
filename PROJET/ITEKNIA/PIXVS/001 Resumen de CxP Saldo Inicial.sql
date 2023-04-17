-- 001 Consulta para Reporte de Cuentas pos Pagar.
-- Objetivo Generar un estado de cuenta al a Un dia especifico de las Cuentas por Pagar Reducido.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 01 de Junio del 2019; Consulta Origina, bloquea a fecha de corte.

--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2019-05-28', 102)
Set @FechaFS = CONVERT (DATE, '2019-06-02', 102) 

-- Cuentas pendientes por pago.

SELECT	PRO_CodigoProveedor as CODPRO,
		PRO_Nombre as NOMPRO, 
		--CXPR_CodigoRegistro as CXPDOC, 
		--CXPR_FechaLibroMayor as CXPFEC, 
		--FECHAVENCIMIENTO as PAGFEC,  
		SUM(MONTOORIGINAL) as CXPIMP,
		SUM(PAGOS) as PAGOS, 
		SUm(MONTOACTUAL) as SALFIN,
		MON_Nombre 
FROM (

SELECT	PRO_CodigoProveedor, 
		PRO_Nombre,
		CXPR_CodigoRegistro, 
		CXPR_FechaLibroMayor, 
		FECHAVENCIMIENTO,
		ROUND ( TOTAL , 2 ) AS MONTOORIGINAL,
		ROUND ( PAGOS , 2) as PAGOS,
		CASE WHEN ROUND ( MONTOACTUAL , 2 ) < 0.09 THEN 0.0 ELSE ROUND ( MONTOACTUAL , 2 ) END AS MONTOACTUAL, 
		MON_Nombre 
FROM ( 

SELECT	UPPER ( PRO_CodigoProveedor ) AS PRO_CodigoProveedor, 
		UPPER ( PRO_Nombre ) AS PRO_Nombre, 
		UPPER ( CXPR_CodigoRegistro ) AS CXPR_CodigoRegistro,
		CXPR_FechaLibroMayor,
		( CXPR_FechaLibroMayor + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS FECHAVENCIMIENTO,  

		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * 
		CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario *
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
		ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS TOTAL,

		ISNULL ( (
		SELECT SUM ( ROUND ( ISNULL ( CXPPD_MontoAplicado , 0.0 ) , 2 ) ) AS CXPPD_MontoAplicado 
		FROM CXPPagos 
		INNER JOIN CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
		WHERE CXPP_PRV_ProveedorId = CXPR_PRV_ProveedorId 
		AND CXPP_MON_MonedaId = CXPR_MON_MonedaId 
		AND CXPPD_RegistroId = CXPR_RegistroCXPId 
		AND CXPP_Borrado = 0 
		and Cast(CXPP_FechaPago as date) < @FechaIS 
		AND CXPPD_RegistroId IS NOT NULL ) , 0.0 ) AS PAGOS,

		( ( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - 
		ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * 
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario *
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
		ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) - 
		ISNULL ( (
		SELECT SUM ( ROUND ( ISNULL ( CXPPD_MontoAplicado , 0.0 ) , 2 ) ) AS CXPPD_MontoAplicado 
		FROM CXPPagos 
		INNER JOIN CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
		WHERE CXPP_PRV_ProveedorId = CXPR_PRV_ProveedorId 
		AND CXPP_MON_MonedaId = CXPR_MON_MonedaId 
		AND CXPPD_RegistroId = CXPR_RegistroCXPId 
		AND CXPP_Borrado = 0 
		and Cast(CXPP_FechaPago as date) < @FechaIS
		AND CXPPD_RegistroId IS NOT NULL ) , 0.0 ) ) AS MONTOACTUAL, 
		MON_Nombre
FROM CXPRegistros 
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN ControlesMaestrosDSC ON CXPR_CMDSC_CodigoId = CMDSC_CodigoId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
INNER JOIN ControlesMaestrosMultiples ON CXPR_CMM_CuentaCXP = CMM_ControllId 
AND CMM_Control = 'CMM_CCXP_CUENTASCXP' 
INNER JOIN CuentasContables ON CMM_Valor = CC_CodigoId 
WHERE CXPR_RegistroBorrado = 0 and MON_Nombre = 'Pesos' 
and Cast(CXPR_FechaLibroMayor as DATE) < @FechaIS
AND CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
GROUP BY CXPR_FechaLibroMayor, PRO_CodigoProveedor, PRO_Nombre, MON_Nombre, CXPR_CodigoRegistro,
CMDSC_TermsDiasVenc, CXPR_TERMINOSPAGOEXTRA,CXPR_PRV_ProveedorId , CXPR_MON_MonedaId,
CXPR_RegistroCXPId
) AS TEMP 
) AS TEMP 
Group By PRO_CodigoProveedor, PRO_Nombre, MON_Nombre

ORDER BY PRO_Nombre
