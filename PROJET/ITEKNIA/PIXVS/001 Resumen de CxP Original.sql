-- 001 Consulta para Reporte de Cuentas pos Pagar.
-- Objetivo Generar un estado de cuenta al dia de las Cuentas por Pagar.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 10 de Febrero del 2018; Consulta Origina.
-- Proporcionada por Juan (PIXVUS).

-- Cuentas pendientes por pago.

SELECT	MON_Nombre, 
		PRO_CodigoProveedor,
		PRO_Nombre, 
		CXPR_CodigoRegistro, 
		CXPR_FechaRegistro, 
		FECHAVENCIMIENTO,  
		CASE WHEN FECHAVENCIMIENTO IS NULL THEN '9000' ELSE DATEPART(ISO_WEEK, FECHAVENCIMIENTO) END AS SEMANA, 
		DIASTRANSCURRIDOS, 
		MONTOACTUAL, 
		CXPR_TERMINOSPAGOEXTRA, 
		CXPR_RegistroCXPId 
FROM (

SELECT	CXPR_RegistroCXPId, 
		CXPR_TERMINOSPAGOEXTRA, 
		CXPR_CodigoRegistro, 
		CXPR_FechaRegistro, 
		CXPR_FechaLibroMayor, 
		FECHAVENCIMIENTO, 
		ROUND ( TOTAL , 2 ) AS MONTOORIGINAL,
		CASE WHEN ROUND ( MONTOACTUAL , 2 ) < 0.09 THEN 0.0 ELSE ROUND ( MONTOACTUAL , 2 ) END AS MONTOACTUAL, 
		MON_MonedaId, 
		MON_Abreviacion, 
		MON_Nombre, 
		MON_Predeterminada, 
		PRO_ProveedorId, 
		PRO_CodigoProveedor, 
		PRO_Nombre, 
		ISNULL ( PRO_Domicilio , '' ) AS PRO_Domicilio, 
		ISNULL ( PRO_Colonia , '' ) AS PRO_Colonia, 
		ISNULL ( CIU_Nombre , '' ) AS CIU_Nombre, 
		ISNULL ( EST_Nombre , '' ) AS EST_Nombre, 
		ISNULL ( PAI_Nombre , '' ) AS PAI_Nombre, 
		ISNULL ( PRO_CodigoPostal , '' ) AS PRO_CodigoPostal, 
		ISNULL ( PRO_RFC , '' ) AS PRO_RFC, 
		PRO_Telefono, 
		CC_CodigoId, 
		CC_CodigoCuenta, 
		ISNULL ( CMDSC_TermsDescuento , '' ) AS CMDSC_TermsDescuento, 
		DIASTRANSCURRIDOS 
FROM ( 

SELECT	CXPR_RegistroCXPId, 
		ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) AS CXPR_TERMINOSPAGOEXTRA, 
		UPPER ( CXPR_CodigoRegistro ) AS CXPR_CodigoRegistro, 
		CXPR_FechaRegistro, 
		CXPR_FechaLibroMayor, 
		( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS FECHAVENCIMIENTO, 
		
		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * 
		CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario *
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
		ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS TOTAL, 
		
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
		AND CXPPD_RegistroId IS NOT NULL ) , 0.0 ) ) AS MONTOACTUAL, 
		
		MON_MonedaId, 
		MON_Abreviacion, 
		MON_Nombre, 
		MON_Predeterminada, 
		PRO_ProveedorId, 
		UPPER ( PRO_CodigoProveedor ) AS PRO_CodigoProveedor, 
		UPPER ( PRO_Nombre ) AS PRO_Nombre, 
		UPPER ( PRO_Domicilio ) AS PRO_Domicilio, 
		UPPER ( PRO_Colonia ) AS PRO_Colonia, 
		UPPER ( CIU_Nombre ) AS CIU_Nombre, 
		UPPER ( EST_Nombre ) AS EST_Nombre, 
		UPPER ( PAI_Nombre ) AS PAI_Nombre, 
		UPPER ( PRO_CodigoPostal ) AS PRO_CodigoPostal, 
		UPPER ( PRO_RFC ) AS PRO_RFC, 
		PRO_Telefono, 
		CC_CodigoId, 
		CC_CodigoCuenta, 
		UPPER ( CMDSC_TermsDescuento ) AS CMDSC_TermsDescuento,
		UPPER ( CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS CMDSC_TermsDiasVenc,
		
		CASE WHEN DATEDIFF ( DAY , ( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + 
		ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) , GETDATE() ) > 0 THEN DATEDIFF ( DAY , 
		( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) , 
		GETDATE() ) ELSE 0 END AS DIASTRANSCURRIDOS 

FROM CXPRegistros 
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN ControlesMaestrosDSC ON CXPR_CMDSC_CodigoId = CMDSC_CodigoId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
LEFT JOIN Ciudades ON PRO_CIU_Ciudad = CIU_CiudadId 
LEFT JOIN Estados ON PRO_EST_Estado = EST_EstadoId 
LEFT JOIN Paises ON PRO_PAI_Pais = PAI_PaisId 
INNER JOIN ControlesMaestrosMultiples ON CXPR_CMM_CuentaCXP = CMM_ControllId 
AND CMM_Control = 'CMM_CCXP_CUENTASCXP' 
INNER JOIN CuentasContables ON CMM_Valor = CC_CodigoId 
WHERE CXPR_RegistroBorrado = 0 
AND CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
GROUP BY CXPR_RegistroCXPId, CXPR_CodigoRegistro, CXPR_FechaRegistro, CXPR_FechaLibroMayor, 
CXPR_PRV_ProveedorId , CXPR_MON_MonedaId , MON_MonedaId , MON_Abreviacion , MON_Nombre, 
MON_Predeterminada, PRO_ProveedorId, PRO_CodigoProveedor, PRO_Nombre, PRO_Domicilio, PRO_Colonia,
CIU_Nombre, EST_Nombre, PAI_Nombre, PRO_CodigoPostal, PRO_RFC, PRO_Telefono, CC_CodigoId, 
CC_CodigoCuenta, CMDSC_TermsDescuento, CMDSC_TermsDiasVenc, CXPR_TERMINOSPAGOEXTRA 
) AS TEMP 
) AS TEMP 
WHERE MONTOACTUAL > 0 AND MON_Nombre = 'Pesos' 
ORDER BY MON_Nombre DESC , PRO_Nombre , CXPR_CodigoRegistro
