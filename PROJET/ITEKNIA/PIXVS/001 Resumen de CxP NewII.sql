-- 001 Consulta para Reporte de Cuentas pos Pagar. NEW_II
-- Objetivo Generar un estado de cuenta al dia de las Cuentas por Pagar.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 01 de Junio del 2019; Nuevas Cuentas por Pagar.

--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)
Declare @xNomMon as nvarchar(30)
Declare @ProveCod as nvarchar(30) 

Set @FechaIS = CONVERT (DATE, '2019-06-07', 102)
Set @FechaFS = CONVERT (DATE, '2019-06-08', 102) 
Set @xNomMon = 'Pesos'
--Set @xNomMon = 'Dolar'
Set @ProveCod = 'P60'

-- Saldo INICIAL a la FECHA.
Select	MT_CXP.CODPRO,
		MT_CXP.NOMPRO,
		SUM(MT_CXP.SALINI) as SALINI,
		SUM(MT_CXP.NEWCXP) as NEWCXP,
		SUM(MT_CXP.PAGOS) as PAGOS,
		SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) - SUM(MT_CXP.PAGOS) as SALFIN,
		MT_CXP.MONEDA
from (
SELECT	PRO_CodigoProveedor as CODPRO,
		PRO_Nombre as NOMPRO,    
		SUM(MONTOACTUAL) as SALINI,
		0 as NEWCXP,
		0 as PAGOS,
		0 as SALFIN,
		MON_Nombre  as MONEDA
FROM (

SELECT	PRO_CodigoProveedor, 
		PRO_Nombre,
		CXPR_CodigoRegistro, 
		CXPR_FechaLibroMayor, 
		FECHAVENCIMIENTO,
		ROUND ( TOTAL , 2 ) AS MONTOORIGINAL,
		ROUND ( PAGOS , 2) as PAGOS,
		ROUND (MONTOACTUAL,2) as MONTOACTUAL,
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
WHERE CXPR_RegistroBorrado = 0 and MON_Nombre = @xNomMon 
--and PRO_CodigoProveedor = @ProveCod
and Cast(CXPR_FechaLibroMayor as DATE) < @FechaIS
AND CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
GROUP BY CXPR_FechaLibroMayor, PRO_CodigoProveedor, PRO_Nombre, MON_Nombre, CXPR_CodigoRegistro,
CMDSC_TermsDiasVenc, CXPR_TERMINOSPAGOEXTRA,CXPR_PRV_ProveedorId , CXPR_MON_MonedaId,
CXPR_RegistroCXPId
) AS TEMP 
) AS TEMP 
Group By PRO_CodigoProveedor, PRO_Nombre, MON_Nombre

UNION ALL

-- Cargos a CxP en la tabla de Registros.
Select	CODPRO, 
		NOMPRO,
		0 as SALINI, 
		SUM(ROUND (CARGO, 2)) as NEWCXP,
		0 as PAGOS,
		0 as SALFIN,
		MON_Nombre as MONEDA
from (

Select	CXPR_FechaLibroMayor as FECHA,
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO,
		UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,
		CXPR_CodigoRegistro as FACTURA,
		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS CARGO,
		MON_Nombre
from CXPRegistros
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
Where CXPR_RegistroBorrado = 0 and MON_Nombre = @xNomMon
--and PRO_CodigoProveedor = @ProveCod
and Cast(CXPR_FechaLibroMayor as DATE) BETWEEN @FechaIS and @FechaFS 
Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre
) CAR_GERAL
Group By CODPRO, NOMPRO, MON_Nombre

UNION ALL

-- Pagos realizados en el periodo.
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
Where CXPP_Borrado = 0 and MON_Nombre = @xNomMon
--and PRO_CodigoProveedor = @ProveCod
and CXPPD_CMM_TipoRegistro is not null
and Cast(CXPP_FechaPago as DATE) BETWEEN @FechaIS and @FechaFS 
) PAGG
Group By CODPRO, NOMPRO, MON_Nombre

) MT_CXP
Group By MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA
Having (SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) + SUM(MT_CXP.PAGOS)) > 0
and SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) - SUM(MT_CXP.PAGOS) > 0.09
Order By NOMPRO
		