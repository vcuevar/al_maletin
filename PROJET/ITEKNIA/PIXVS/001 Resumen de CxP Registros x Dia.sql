-- 001 Consulta para Sacar los Rergistros del Dia. 
-- Objetivo: Tener todos los movimientos de un Dia, con fecha de aplicacion.
-- Desarrollado: Ing. Vicente Cueva R.
-- Solicitasdo: Por Claudia Castañeda.
-- Actualizado: Miercoles 10 de Julio del 2019; Inicio.
-- Actualizado: Sabado 27 de Julio del 2019; Conclusion


--Sacar todos los registros del dia con fecha de alteracion y que movimiento es.

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

Set @FechaIS = CONVERT (DATE, '2019-07-26', 102)
Set @FechaFS = CONVERT (DATE, '2019-07-26', 102) 
Set @xNomMon = 'Pesos'
--Set @xNomMon = 'Dolar'
Set @ProveCod = 'P323'

-- Movimientos de Compras
Select	UPPER (PRO_CodigoProveedor) as CODPRO,
		UPPER (PRO_Nombre) as NOMPRO,

		CXPR_FechaRegistro as FECH_REGIS,
		CXPR_FechaLibroMayor as FECH_MAYOR,
		CXPR_FechaReciboRegistro as FECH_APLICA,

		Cast(Case When CXPR_CMM_TipoRegistro = 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' then
		CXPR_FechaLibroMayor else CXPR_FechaReciboRegistro end as DATE) as FECH_MACRO,

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

and Cast(CXPR_FechaRegistro as DATE) BETWEEN @FechaIS and @FechaFS  
Group by CXPR_FechaLibroMayor, CXPR_CMM_TipoRegistro, PRO_CodigoProveedor, PRO_Nombre, CXPR_CodigoRegistro, 
MON_Nombre, CXPRD_CMM_CuentaCredito, CXPR_FechaReciboRegistro, CXPR_FechaRegistro

UNION ALL

-- Movimientos de Pagos

Select	PRO_CodigoProveedor as CODPRO,
		PRO_Nombre as NOMPRO,

		CXPP_FechaCaptura as FECH_REGIS,
		CXPP_FechaPago as FECH_MAYOR,  
		CXPP_FechaPago as FECH_APLICA,

		CXPP_FechaPago as FECH_MACRO,  
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

and CXPPD_CMM_TipoRegistro is not null
and CXPR_CMM_TipoRegistro IN ( 'C73B4F7F-4F68-45DD-AA08-07A333D67C89' , 'A8664AC1-4BB7-49D8-AB7F-ABD240F030D9' ) 
and Cast(CXPP_FechaCaptura as DATE) BETWEEN @FechaIS and @FechaFS  


--Select * from  CXPPagos
--INNER JOIN CXPRegistrosDetalle ON CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId 