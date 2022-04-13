-- 001 Consulta para Reporte de Cuentas pos Pagar.
-- Objetivo Generar un estado de cuenta al dia de las Cuentas por Pagar.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Lunes 20 de Mayo del 2019; Inicio en base del Resumen de CxP.
-- Actualizado: Viernes 24 de Mayo del 2019; Limitar a una fecha de inicio.
-- Actualizado: Martes 28 de Mayo del 2019; Concluir

--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)
Declare @ProveCod as nvarchar(30) 
Declare @MonedNom as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2019-05-29', 102)
Set @FechaFS = CONVERT (DATE, '2019-06-02', 102) 
Set @ProveCod = 'P598'
Set @MonedNom = 'Pesos'


--Use iteknia
Select	MT_CXP.CODPRO,
		MT_CXP.NOMPRO,
		SUM(MT_CXP.SALINI) as SALINI,
		SUM(MT_CXP.NEWCXP) as NEWCXP,
		SUM(MT_CXP.PAGOS) as PAGOS,
		SUM(MT_CXP.SALFIN) as SALFIN,
		MT_CXP.MONEDA
from (

-- Generar Saldo inicial lo que sea menor a la fecha de inicio.
Select	PRO_CodigoProveedor as CODPRO, 
		PRO_Nombre as NOMPRO,
		CASE WHEN ROUND ( MONTOACTUAL , 2 ) < 0.09 THEN 0.0 ELSE ROUND ( MONTOACTUAL , 2 ) END AS SALINI,
		0 as NEWCXP,
		0 as PAGOS,
		0 as SALFIN, 
		MON_Nombre as MONEDA
from ( 

Select	PRO_CodigoProveedor, 
		PRO_Nombre,
		(ROUND ( MONTOACTUAL , 2 )) as MONTOACTUAL,
		MON_Nombre
from ( 
Select	CXPR_RegistroCXPId, 
		ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) AS CXPR_TERMINOSPAGOEXTRA, 
		UPPER ( CXPR_CodigoRegistro ) AS CXPR_CodigoRegistro, 
		CXPR_FechaRegistro, 
		CXPR_FechaLibroMayor, 
		( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS FECHAVENCIMIENTO,

		--Monto del Registro
		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS TOTAL,

		--Lo Registrado menos los Pagos realizados antes de la Fecha Inicio
		CASE WHEN ROUND (
		( ( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) 
		- ISNULL ( (Select SUM ( ROUND ( ISNULL ( CXPPD_MontoAplicado , 0.0 ) , 2 ) ) AS CXPPD_MontoAplicado from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
		WHERE CXPP_PRV_ProveedorId = CXPR_PRV_ProveedorId AND CXPP_MON_MonedaId = CXPR_MON_MonedaId AND CXPPD_RegistroId = CXPR_RegistroCXPId AND CXPP_Borrado = 0 AND CXPPD_RegistroId IS NOT NULL
		and Cast(CXPP_FechaCaptura as DATE) < @FechaIS ) , 0.0 ) ) 
		, 2 ) < 0.09 THEN 0.0 ELSE 
		( ( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) 
		- ISNULL ( (Select SUM ( ROUND ( ISNULL ( CXPPD_MontoAplicado , 0.0 ) , 2 ) ) AS CXPPD_MontoAplicado from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
		WHERE CXPP_PRV_ProveedorId = CXPR_PRV_ProveedorId AND CXPP_MON_MonedaId = CXPR_MON_MonedaId AND CXPPD_RegistroId = CXPR_RegistroCXPId AND CXPP_Borrado = 0 AND CXPPD_RegistroId IS NOT NULL
		and Cast(CXPP_FechaCaptura as DATE) < @FechaIS ) , 0.0 ) )
		 END
		AS MONTOACTUAL, 
	 
		MON_Nombre, 
	 
		UPPER ( PRO_CodigoProveedor ) AS PRO_CodigoProveedor, 
		UPPER ( PRO_Nombre ) AS PRO_Nombre, 
		UPPER ( CMDSC_TermsDescuento ) AS CMDSC_TermsDescuento, 
		UPPER ( CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS CMDSC_TermsDiasVenc,
		CASE WHEN DATEDIFF ( DAY , ( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) , GETDATE() ) > 0 THEN DATEDIFF ( DAY , ( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) , GETDATE() ) ELSE 0 END AS DIASTRANSCURRIDOS 
FROM CXPRegistros 
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN ControlesMaestrosDSC ON CXPR_CMDSC_CodigoId = CMDSC_CodigoId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
INNER JOIN ControlesMaestrosMultiples ON CXPR_CMM_CuentaCXP = CMM_ControllId AND CMM_Control = 'CMM_CCXP_CUENTASCXP' 
INNER JOIN CuentasContables ON CMM_Valor = CC_CodigoId 
WHERE CXPR_RegistroBorrado = 0 
and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPR_FechaRegistro as DATE) < @FechaIS and MON_Nombre = @MonedNom
--and PRO_CodigoProveedor = @ProveCod
Group By CXPR_RegistroCXPId, CXPR_TERMINOSPAGOEXTRA, CXPR_CodigoRegistro,
CXPR_RegistroCXPId, CXPR_FechaRegistro, CXPR_FechaLibroMayor, CMDSC_TermsDiasVenc, 
CXPR_PRV_ProveedorId, MON_Nombre, PRO_CodigoProveedor, 
PRO_Nombre, CMDSC_TermsDescuento, CXPR_MON_MonedaId

) as SAL_INI
Group By PRO_CodigoProveedor, PRO_Nombre, MON_Nombre, MONTOACTUAL
--Having MONTOACTUAL <> 0

) as SAL_IN0
 
UNION ALL

-- Cargos a CxP en la tabla de Registros.
Select CODPRO, NOMPRO,
		0 as SALINI, 
		SUM(ROUND (CARGO2, 2)) as NEWCXP,
		0 as PAGOS,
		0 as SALFIN,
		MON_Nombre as MONEDA
from (
Select	CXPR_FechaRegistro as FECHA,
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO,
		UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,
		CXPR_CodigoRegistro as FACTURA,
		--SUM(ISNULL(CXPR_MontoRegistro, 0)) as CARGO, 
		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS CARGO2,
		MON_Nombre
from CXPRegistros
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
Where CXPR_RegistroBorrado = 0 and MON_Nombre = @MonedNom
--and PRO_CodigoProveedor = @ProveCod
and Cast(CXPR_FechaRegistro as DATE) BETWEEN @FechaIS and @FechaFS 
Group by CXPR_FechaRegistro, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre
) CAR_GERAL
Group By CODPRO, NOMPRO, MON_Nombre

UNION ALL

 -- Pagos Realizados.
 Select PAGG.CODPRO, PAGG.NOMPRO,
		0 as SALINI,
		0 as NEWCXP,
		SUM(ROUND (PAGG.PAGO2, 2)) as PAGOS,
		0 as SALFIN,
		MON_Nombre as MONEDA
 from (
 Select	CXPP_FechaPago as FECHA,  
	(Select CMM_Valor from ControlesMaestrosMultiples
	Where CMM_ControllId = CXPP_CMM_FormaPago) as REGISTRO,
	PRO_CodigoProveedor as CODPRO,
	PRO_Nombre as NOMPRO,
	--CXPP_IdentificacionPago as PAGO,
	--CXPP_MontoPago as PAGO,
	ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGO2,
	MON_Nombre 
from CXPPagos 
Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId 
left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  
Where CXPP_Borrado = 0 and MON_Nombre = @MonedNom
--and PRO_CodigoProveedor = @ProveCod
and CXPR_RegistroCXPId is not null
and Cast(CXPP_FechaPago as DATE) BETWEEN @FechaIS and @FechaFS 
) PAGG
Group By CODPRO, NOMPRO, MON_Nombre

UNION ALL

-- Consulta de Saldos actualizado al Dia
Select	PRO_CodigoProveedor as CODPRO,
		PRO_Nombre as NOMPRO, 
		0 as SALINI,
		0 as NEWCXP,
		0 as PAGOS,
		MONTOACTUAL as SALFIN,
		MON_Nombre as MONEDA
from (

Select	MON_Nombre,		
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
from (

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
		PRO_Telefono, CC_CodigoId, 
		CC_CodigoCuenta, 
		ISNULL ( CMDSC_TermsDescuento , '' ) AS CMDSC_TermsDescuento, 
		DIASTRANSCURRIDOS 
		from ( 
		
		SELECT CXPR_RegistroCXPId, ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) AS CXPR_TERMINOSPAGOEXTRA, 
		UPPER ( CXPR_CodigoRegistro ) AS CXPR_CodigoRegistro, 
		CXPR_FechaRegistro, 
		CXPR_FechaLibroMayor, 
		( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS FECHAVENCIMIENTO,
		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS TOTAL,
		( ( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) 
		
		- ISNULL ( (
		SELECT SUM ( ROUND ( ISNULL ( CXPPD_MontoAplicado , 0.0 ) , 2 ) ) AS CXPPD_MontoAplicado 
		from CXPPagos 
		INNER JOIN CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
		WHERE CXPP_PRV_ProveedorId = CXPR_PRV_ProveedorId 
		AND CXPP_MON_MonedaId = CXPR_MON_MonedaId 
		AND CXPPD_RegistroId = CXPR_RegistroCXPId AND CXPP_Borrado = 0 
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
		UPPER ( PRO_RFC ) AS PRO_RFC, PRO_Telefono, 
		CC_CodigoId, CC_CodigoCuenta, 
		UPPER ( CMDSC_TermsDescuento ) AS CMDSC_TermsDescuento, 
		UPPER ( CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) AS CMDSC_TermsDiasVenc,
		CASE WHEN DATEDIFF ( DAY , ( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) , GETDATE() ) > 0 THEN DATEDIFF ( DAY , ( CXPR_FechaRegistro + CMDSC_TermsDiasVenc + ISNULL ( CXPR_TERMINOSPAGOEXTRA , 0.0 ) ) , GETDATE() ) ELSE 0 END AS DIASTRANSCURRIDOS 	
FROM CXPRegistros 
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN ControlesMaestrosDSC ON CXPR_CMDSC_CodigoId = CMDSC_CodigoId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
LEFT JOIN Ciudades ON PRO_CIU_Ciudad = CIU_CiudadId 
LEFT JOIN Estados ON PRO_EST_Estado = EST_EstadoId 
LEFT JOIN Paises ON PRO_PAI_Pais = PAI_PaisId 
INNER JOIN ControlesMaestrosMultiples ON CXPR_CMM_CuentaCXP = CMM_ControllId AND CMM_Control = 'CMM_CCXP_CUENTASCXP' 
INNER JOIN CuentasContables ON CMM_Valor = CC_CodigoId WHERE CXPR_RegistroBorrado = 0 AND CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 

GROUP BY CXPR_RegistroCXPId, CXPR_CodigoRegistro, CXPR_FechaRegistro, 
CXPR_FechaLibroMayor, CXPR_PRV_ProveedorId, CXPR_MON_MonedaId, MON_MonedaId, 
MON_Abreviacion, MON_Nombre, MON_Predeterminada, PRO_ProveedorId, 
PRO_CodigoProveedor, PRO_Nombre, PRO_Domicilio, PRO_Colonia, CIU_Nombre, 
EST_Nombre, PAI_Nombre, PRO_CodigoPostal, PRO_RFC, PRO_Telefono, CC_CodigoId,
CC_CodigoCuenta, CMDSC_TermsDescuento, CMDSC_TermsDiasVenc, 
CXPR_TERMINOSPAGOEXTRA) AS TEMP 
) AS TEMP 
WHERE MONTOACTUAL > 0 AND MON_Nombre = 'Pesos' 
--and PRO_CodigoProveedor = @ProveCod
) SAL_FIN
Group by PRO_CodigoProveedor, PRO_Nombre, MON_Nombre, MONTOACTUAL 

) MT_CXP
Group By MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA