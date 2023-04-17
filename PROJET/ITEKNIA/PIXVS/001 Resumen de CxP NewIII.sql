-- 001 Consulta para Reporte de Cuentas pos Pagar. NEW_III
-- Objetivo Generar un estado de cuenta al dia de las Cuentas por Pagar.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 08 de Junio del 2019; Sacar Saldo por separado, no con termino pagos.
-- Actualizado: Viernes 09 de Junio del 2019; Culmen de la Consulta.
-- Actualizado: Miercoles 26 de Junio del 2019; Cambio de FechaLibroMayor x FechaRegistro.
-- Actualizado: Jueves 27 de Junio del 2019; Segun documento o usa FechaRecibo o FechaRegistro.
-- Actualizado: Miercoles 03 de Julio del 2019; Dejar Registro de Plantillas con fecha de LibroMayor.

Use iteknia

--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)
Declare @xNomMon as nvarchar(30)
Declare @ProveCod as nvarchar(30) 

Set @FechaIS = CONVERT (DATE, '2019-07-04', 102)
Set @FechaFS = CONVERT (DATE, '2019-07-04', 102) 
Set @xNomMon = 'Pesos'
--Set @xNomMon = 'Dolar'
Set @ProveCod = 'P516'

Select	MT_CXP.CODPRO,
		MT_CXP.NOMPRO,
		ROUND(SUM(MT_CXP.SALINI),2) as SALINI,
		ROUND(SUM(MT_CXP.NEWCXP),2) as NEWCXP,
		ROUND(SUM(MT_CXP.PAGOS), 2) as PAGOS,
		ROUND(SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) - SUM(MT_CXP.PAGOS) ,2)as SALFIN,
		MT_CXP.MONEDA
from (

-- Saldo INICIAL CARGOS a la antes de FECHA Inicial.
Select	CODPRO, 
		NOMPRO,
		ROUND(SUM(CARGO) - SUM(NOTDB),2) as SALINI, 
		--SUM(ROUND (CARGO, 2))  as SALINI, 
		0 as NEWCXP,
		0 as PAGOS,
		0 as SALFIN,
		MON_Nombre as MONEDA
from (

Select	Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECHA,
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO,
		UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,
		CXPR_CodigoRegistro as FACTURA,
		( SUM ( ( ROUND (ISNULL( CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) , 2 ) - 
		ROUND ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * 
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario,0) ) - 
		( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * 
		ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * 
		ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS CARGO,
		
		Case When(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito'
		and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' 
		and Left(CXPR_CodigoRegistro,2) <> 'ND' then
		SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB,
		
		MON_Nombre
from CXPRegistros
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
Where CXPR_RegistroBorrado = 0 and MON_Nombre = @xNomMon
--and PRO_CodigoProveedor = @ProveCod
and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) < @FechaIS  
Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, 
CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro
) CAR_GERAL
Group By CODPRO, NOMPRO, MON_Nombre

UNION ALL

-- Pagos realizados antes de la Fecha Inicial.
Select PAGG.CODPRO, PAGG.NOMPRO,
		SUM(ROUND (PAGG.PAGO2, 2))*-1 as SALINI,
		0 as NEWCXP,
		0 as PAGOS,
		0 as SALFIN,
		MON_Nombre as MONEDA
from (
Select	CXPP_FechaPago as FECHA,  
	(Select CMM_Valor from ControlesMaestrosMultiples
	Where CMM_ControllId = CXPP_CMM_FormaPago) as REGISTRO,
	PRO_CodigoProveedor as CODPRO,
	PRO_Nombre as NOMPRO,
	CXPP_IdentificacionPago as DOCPAG,
	ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGO2,
	MON_Nombre,
	(Select CMM_Valor from ControlesMaestrosMultiples
	Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as TIPO_REG
from CXPPagos 
Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId 
left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  
Where CXPP_Borrado = 0 and MON_Nombre = @xNomMon
--and PRO_CodigoProveedor = @ProveCod
and CXPPD_CMM_TipoRegistro is not null
and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPP_FechaPago as DATE) < @FechaIS 
) PAGG
Group By CODPRO, NOMPRO, MON_Nombre

Union All

-- COBROS en el Periodo.
Select	CODPRO, 
		NOMPRO,
		0 as SALINI, 
		SUM(ROUND (CARGO, 2)) as NEWCXP,
		SUM(ROUND (PAGOS, 2))  as PAGOS,
		0 as SALFIN,
		MON_Nombre as MONEDA
from (

Select	Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECHA,
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO,
		UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,
		CXPR_CodigoRegistro as FACTURA,
		( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
		ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS CARGO,
		
		Case When(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito'
		and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' 
		and Left(CXPR_CodigoRegistro,2) <> 'ND' then
		SUM(CXPRD_PrecioUnitario) else 0 end as PAGOS,
		MON_Nombre
from CXPRegistros
INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId 
Where CXPR_RegistroBorrado = 0 and MON_Nombre = @xNomMon
--and PRO_CodigoProveedor = @ProveCod
and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) BETWEEN @FechaIS and @FechaFS  
Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre,
CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro
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
	CXPP_IdentificacionPago as DOCPAG,
	ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGO2,
	MON_Nombre,
	(Select CMM_Valor from ControlesMaestrosMultiples
	Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as TIPO_REG 
from CXPPagos
Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId
INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId 
INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId 
left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  
Where CXPP_Borrado = 0 and MON_Nombre = @xNomMon
--and PRO_CodigoProveedor = @ProveCod
and CXPPD_CMM_TipoRegistro is not null
and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPP_FechaPago as DATE) BETWEEN @FechaIS and @FechaFS  
) PAGG
Group By CODPRO, NOMPRO, MON_Nombre

) MT_CXP
Group By MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA
--Having (SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) + SUM(MT_CXP.PAGOS)) > 0 
--and SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) - SUM(MT_CXP.PAGOS) > 0.09 
Order By MT_CXP.NOMPRO



 /* Script para Macro 001, 03/Julio Cambio plantillas usar fecha de LibroMayor. 

Select MT_CXP.CODPRO, MT_CXP.NOMPRO, ROUND(SUM(MT_CXP.SALINI),2) as SALINI, ROUND(SUM(MT_CXP.NEWCXP),2) as NEWCXP, ROUND(SUM(MT_CXP.PAGOS), 2) as PAGOS, ROUND(SUM(MT_CXP.SALINI) + SUM(MT_CXP.NEWCXP) - SUM(MT_CXP.PAGOS) ,2)as SALFIN, MT_CXP.MONEDA from (Select	CODPRO, NOMPRO, ROUND(SUM(CARGO) - SUM(NOTDB),2) as SALINI, 0 as NEWCXP, 0 as PAGOS, 0 as SALFIN, MON_Nombre as MONEDA from (Select	Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO, UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, CXPR_CodigoRegistro as FACTURA,
( SUM ( ( ROUND (ISNULL( CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) , 2 ) - ROUND ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + ROUND ( ( ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario,0) ) - ( ISNULL(CXPRD_Cantidad * CXPRD_PrecioUnitario, 0.0) * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS CARGO, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as NOTDB, MON_Nombre from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 
INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId Where CXPR_RegistroBorrado = 0 and MON_Nombre = '" & xNomMon & "' and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) < '" & FechaIS & "'  Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro ) CAR_GERAL Group By CODPRO, NOMPRO, MON_Nombre UNION ALL Select PAGG.CODPRO, PAGG.NOMPRO, SUM(ROUND (PAGG.PAGO2, 2))*-1 as SALINI, 0 as NEWCXP, 0 as PAGOS, 0 as SALFIN, MON_Nombre as MONEDA from (Select	CXPP_FechaPago as FECHA,  
(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) as REGISTRO, PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, CXPP_IdentificacionPago as DOCPAG, ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGO2, MON_Nombre, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as TIPO_REG from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre = '" & xNomMon & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPP_FechaPago as DATE) < '" & FechaIS & "' ) PAGG Group By CODPRO, NOMPRO, MON_Nombre Union All Select	CODPRO, NOMPRO, 0 as SALINI, SUM(ROUND (CARGO, 2)) as NEWCXP, SUM(ROUND (PAGOS, 2))  as PAGOS, 0 as SALFIN, MON_Nombre as MONEDA from (Select	Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECHA, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) as REGISTRO, UPPER (PRO_CodigoProveedor) as CODPRO, UPPER (PRO_Nombre) as NOMPRO, CXPR_CodigoRegistro as FACTURA, ( SUM ( ( ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario , 2 ) - ROUND ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) , 2 ) ) + 
ROUND ( ( ( CXPRD_Cantidad * CXPRD_PrecioUnitario ) - ( CXPRD_Cantidad * CXPRD_PrecioUnitario * ISNULL ( CXPRD_PorcentajeDescuento , 0.0 ) ) ) * ISNULL ( CXPRD_CMIVA_Porcentaje , 0.0 ) , 2 ) ) ) AS CARGO, Case When(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPR_CMM_TipoRegistro) = 'Nota de Debito' and CXPRD_CMM_CuentaCredito = '6ED86360-8129-4481-B191-036D6727195A' and Left(CXPR_CodigoRegistro,2) <> 'ND' then SUM(CXPRD_PrecioUnitario) else 0 end as PAGOS, MON_Nombre from CXPRegistros INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId INNER JOIN Proveedores ON CXPR_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPR_MON_MonedaId = MON_MonedaId Where CXPR_RegistroBorrado = 0 and MON_Nombre = '" & xNomMon & "'
and Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro ) CAR_GERAL Group By CODPRO, NOMPRO, MON_Nombre UNION ALL Select PAGG.CODPRO, PAGG.NOMPRO, 0 as SALINI, 0 as NEWCXP, SUM(ROUND (PAGG.PAGO2, 2)) as PAGOS, 0 as SALFIN, MON_Nombre as MONEDA from (Select	CXPP_FechaPago as FECHA,  (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) as REGISTRO, PRO_CodigoProveedor as CODPRO, PRO_Nombre as NOMPRO, CXPP_IdentificacionPago as DOCPAG,
ISNULL(ROUND ( CXPPD_MontoAplicado , 2), 0.00) AS PAGO2, MON_Nombre, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro) as TIPO_REG from CXPPagos Inner Join CXPPagosDetalle ON CXPP_PagoCXPId = CXPPD_CXPP_PagoCXPId INNER JOIN Proveedores ON CXPP_PRV_ProveedorId = PRO_ProveedorId INNER JOIN Monedas ON CXPP_MON_MonedaId = MON_MonedaId left join CXPRegistros on CXPPD_RegistroId = CXPR_RegistroCXPId  Where CXPP_Borrado = 0 and MON_Nombre = '" & xNomMon & "' and CXPPD_CMM_TipoRegistro is not null and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) and Cast(CXPP_FechaPago as DATE) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  ) PAGG Group By CODPRO, NOMPRO, MON_Nombre
) MT_CXP Group By MT_CXP.CODPRO, MT_CXP.NOMPRO, MT_CXP.MONEDA Order By MT_CXP.NOMPRO 

*/
