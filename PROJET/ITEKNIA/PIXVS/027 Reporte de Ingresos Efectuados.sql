-- PIXVS Consulta para 024 Reporte de Pagos Efectuados.
-- Solicitado por Claudia Castañeda.
-- Desarollado por Ing. Vicente Cueva R.
-- Objetivo: Presentar los pagos realizado, en detalle y agrupados por cuentas contables.
-- Actualizado: Sabado 06 de Octubre del 2018; Origen
-- Actualizado: Miercoles 10 de Octubre 2018; Separar Anticipos de Pagos.

DECLARE @FechaIS date
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2018-12-01', 102)
Set @FechaFS = CONVERT (DATE, '2018-12-12', 102) 

--Pagos Efectuados sin Anticipos.
Select	CXPP_FechaPago AS F_PAGO,
		CXPP_IdentificacionPago AS IDENTF,
		PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS PROVEEDOR,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA,
		CXPP_MontoPago AS DEUDA,
		CXPPD_Descuento AS REBAJA,
		CXPPD_MontoAplicado AS PAGO,
		CXPP_MONP_Paridad AS PARIDAD,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) AS FOR_PAGO,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_TipoRegistro) AS TIP_REG,
		ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_EstatusSolicitud),'S/E') AS ESTATUS,
		ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro),'S/R') AS REG_DET,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP,
		ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN
		
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
where  Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 
and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
--and PRO_CodigoProveedor = 'P763'
Order by ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO'), Cast(CXPP_FechaPago AS date), PRO_CodigoProveedor 

--Anticipos Efectuados.
Select	CXPP_FechaPago AS F_PAGO,
		CXPP_IdentificacionPago AS IDENTF,
		PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS PROVEEDOR,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA,
		CXPP_MontoPago AS DEUDA,
		CXPPD_Descuento AS REBAJA,
		CXPPD_MontoAplicado AS PAGO,
		CXPP_MONP_Paridad AS PARIDAD,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) AS FOR_PAGO,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_TipoRegistro) AS TIP_REG,
		ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_EstatusSolicitud),'S/E') AS ESTATUS,
		ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro),'S/R') AS REG_DET,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP, 
		ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
where  Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
and CXPPD_MontoAplicado < 0
--and PRO_CodigoProveedor = 'P763'
Order by ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO'), Cast(CXPP_FechaPago AS date), PRO_CodigoProveedor 

/*
-- --------------------------------------------------------------------------------------------------------------------
-- Optener Monto de TOTAL de TODOS los proveedores a la Fecha.
Select	PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS PROVEEDOR,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA,
		SUM(CXPPD_MontoAplicado) AS PAGO,
		AVG(CXPP_MONP_Paridad) AS PARIDAD
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
where CXPP_Borrado = 0 and Cast(CXPP_FechaPago as date) > '2018-07-01'
and CXPPD_CMM_TipoRegistro = 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
Group By PRO_CodigoProveedor, PRO_Nombre, CXPP_MON_MonedaId
Having SUM(CXPPD_MontoAplicado) <> 0
Order By PROVEEDOR

*/