-- PIXVS Consulta para _-_ Reporte de Retenciones.
-- Solicitado por Claudia Castañeda.
-- Desarollado por Ing. Vicente Cueva R.
-- Objetivo: Presentar las retenciones realizadas.
-- Actualizado: Sabado 20 de Octubre del 2018; Origen
-- Actualizado: Martes 23 de Octubre del 2018; Reporte de Poliza.
-- Actualizado: Miercoles 24 de Octubre del 2018; Asignar a Pagos Retenciones. 

DECLARE @FechaIS date
DECLARE @FechaFS date
DECLARE @CodProv varchar(20) 

Set @FechaIS = CONVERT (DATE, '2018-10-24', 102)
Set @FechaFS = CONVERT (DATE, '2018-10-24', 102) 
Set @CodProv = 'P510' 


--Pagos Efectuados SIN ANTICIPOS y con Retenciones.
/*
Select  PcR.ORDEN,
		PcR.CUEBAN,
		PcR.F_PAGO,
		PcR.IDENTF,
		PcR.COD_PROV,
		PcR.PROVEEDOR,
		PcR.MONEDA,
		PcR.FOR_PAGO,
		PcR.PAGO,
		PcR.PARIDAD,
		PcR.CC_CXP,
		SUM(PcR.ORIGEN) AS MONTO,
		SUM(PcR.IVA_ACR) AS IVA,
		SUM(PcR.RET_ISR) AS R_ISR,
		SUM(PcR.RET_IVA) AS R_IVA,
		SUM(PcR.PROV_NET) AS PAG
from (
*/
Select	'REG01' AS ORDEN,
		CXPP_FechaPago AS F_PAGO,
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
		ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA,
		Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET,
		(Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' 
		then POD_Monto else 0 END) AS ORIGEN,
		POD_Monto AS IMPORTE
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
left join Polizas on CXPPD_CXPR_RegistroCXPId = POL_ReferenciaId
left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId
where  Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 and POD_CC_CuentaId is not null
and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
and PRO_CodigoProveedor = @CodProv

--Union All

Select	'REG02' AS ORDEN,
		CXPP_FechaPago AS F_PAGO,
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
		ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA,
		Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET,
		(Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' 
		then POD_Monto else 0 END) AS ORIGEN,
		POD_Monto AS IMPORTE
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
left join Polizas on CXPPD_CXPP_PagoCXPId = POL_ReferenciaId
left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId
where  Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 and POD_CC_CuentaId is not null
and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
and PRO_CodigoProveedor = @CodProv

/*
) PcR
Group by PcR.CUEBAN, PcR.F_PAGO, PcR.IDENTF, PcR.COD_PROV, PcR.PROVEEDOR, PcR.MONEDA, PcR.FOR_PAGO, PcR.PAGO,
PcR.PARIDAD, PcR.CC_CXP, PcR.ORDEN
Having PcR.COD_PROV = @CodProv
Order by PcR.CUEBAN, Cast(PcR.F_PAGO as date), PcR.PROVEEDOR, PcR.IDENTF, PcR.ORDEN 
*/




-- Consulta para macro 31 de Octubre del 2018
/*
Select PcR.ORDEN, PcR.CUEBAN, PcR.F_PAGO, PcR.IDENTF, PcR.COD_PROV, PcR.PROVEEDOR, PcR.MONEDA, PcR.FOR_PAGO, PcR.PARIDAD, PcR.CC_CXP, SUM(PcR.ORIGEN) AS MONTO, SUM(PcR.IVA_ACR) AS IVA, SUM(PcR.RET_ISR) AS R_ISR, SUM(PcR.RET_IVA) AS R_IVA, SUM(PcR.PROV_NET * -1) AS PAG from ( Select	'REG01' AS ORDEN, CXPP_FechaPago AS F_PAGO, CXPP_IdentificacionPago AS IDENTF, PRO_CodigoProveedor AS COD_PROV, PRO_Nombre AS PROVEEDOR, (Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA, CXPP_MontoPago AS DEUDA, CXPPD_Descuento AS REBAJA, CXPPD_MontoAplicado AS PAGO, CXPP_MONP_Paridad AS PARIDAD, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) AS FOR_PAGO,
(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_TipoRegistro) AS TIP_REG, ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_EstatusSolicitud),'S/E') AS ESTATUS, ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro),'S/R') AS REG_DET, (Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP, ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN,
(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO, Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR, Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR, Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA, Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET,
(Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' then POD_Monto else 0 END) AS ORIGEN, POD_Monto AS IMPORTE from CXPPagos inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId left join Polizas on CXPPD_CXPR_RegistroCXPId = POL_ReferenciaId left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId
where  Cast(CXPP_FechaPago AS date)  BETWEEN '" & FechaIS & "' and '" & FechaFS & "' and CXPP_Borrado = 0 and POD_CC_CuentaId is not null and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0' Union All Select	'REG02' AS ORDEN, CXPP_FechaPago AS F_PAGO, CXPP_IdentificacionPago AS IDENTF, PRO_CodigoProveedor AS COD_PROV, PRO_Nombre AS PROVEEDOR, (Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA, CXPP_MontoPago AS DEUDA, CXPPD_Descuento AS REBAJA, CXPPD_MontoAplicado AS PAGO, CXPP_MONP_Paridad AS PARIDAD, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_FormaPago) AS FOR_PAGO, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_TipoRegistro) AS TIP_REG,
ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPP_CMM_EstatusSolicitud),'S/E') AS ESTATUS, ISNULL((Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = CXPPD_CMM_TipoRegistro),'S/R') AS REG_DET, (Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = PRO_CMM_CuentaCxP)) AS CC_CXP, ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN, (Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,
Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR, Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR, Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA, Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET, (Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND
(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' then POD_Monto else 0 END) AS ORIGEN, POD_Monto AS IMPORTE from CXPPagos inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId left join Polizas on CXPPD_CXPP_PagoCXPId = POL_ReferenciaId left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId where  Cast(CXPP_FechaPago AS date)  BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  and CXPP_Borrado = 0 and POD_CC_CuentaId is not null
and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0' ) PcR Group by PcR.CUEBAN, PcR.F_PAGO, PcR.IDENTF, PcR.COD_PROV, PcR.PROVEEDOR, PcR.MONEDA, PcR.FOR_PAGO, PcR.PAGO, PcR.PARIDAD, PcR.CC_CXP, PcR.ORDEN Order by PcR.CUEBAN, Cast(PcR.F_PAGO as date), PcR.PROVEEDOR, PcR.IDENTF, PcR.ORDEN 
*/




/*
-- Detalle de Consulta antes de Agrupar.
Select	'REG01' AS ORDEN,
		CXPP_FechaPago AS F_PAGO,
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
		ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA,
		Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET,
		(Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' 
		then POD_Monto else 0 END) AS ORIGEN,
		POD_Monto AS IMPORTE,
		CXPPagosDetalle.*
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
left join Polizas on CXPPD_CXPR_RegistroCXPId = POL_ReferenciaId
left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId
where  Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 and POD_CC_CuentaId is not null
and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
and PRO_CodigoProveedor = @CodProv

--Union All

Select	'REG02' AS ORDEN,
		CXPP_FechaPago AS F_PAGO,
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
		ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA,
		Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET,
		(Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' 
		then POD_Monto else 0 END) AS ORIGEN,
		POD_Monto AS IMPORTE,
		CXPPagosDetalle.*
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
left join Polizas on CXPPD_CXPP_PagoCXPId = POL_ReferenciaId
left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId
where  Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 and POD_CC_CuentaId is not null
and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
and PRO_CodigoProveedor = @CodProv 

*/




/*
Select	ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO') AS CUEBAN,	
		CXPP_FechaPago AS F_PAGO,
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
		
				
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,

		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '105-005' then POD_Monto else 0 END AS IVA_ACR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-001' then POD_Monto else 0 END AS RET_ISR,
		Case When (Select Left(CC_CodigoCuenta,7) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '215-002' then POD_Monto else 0 END AS RET_IVA,
		Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '201' or
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) = '202' then POD_Monto else 0 END AS PROV_NET,

		(Case When (Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '201'  AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '215' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '105' AND
		(Select Left(CC_CodigoCuenta,3) from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) <> '202' 
		then POD_Monto else 0 END) AS ORIGEN,

		POD_Monto AS IMPORTE
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId

--left join Polizas on CXPPD_CXPR_RegistroCXPId = POL_ReferenciaId
left join Polizas on CXPPD_CXPP_PagoCXPId = POL_ReferenciaId
left join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId

where POL_NumeroPoliza = '41911'  
--Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 
and CXPP_Borrado = 0 
--and CXPPD_CMM_TipoRegistro <> 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
--and PRO_CodigoProveedor = @CodProv



Select	POL_NumeroPoliza AS NUMPOL,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = POL_CMM_TipoId) AS TIPO,
		(Select CMOP_Nombre from ControlesMaestrosOP where POL_CMOP_OrigenId = CMOP_OrigenId) AS ORIGEN,
		POL_FechaPoliza AS FECHPOLI,
		POL_Referencias AS CODEPROV,

		(Select top(1) CXPP_IdentificacionPago from CXPPagos INNER JOIN CXPPagosDetalle ON CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId Where CXPPD_CXPR_RegistroCXPId = POL_ReferenciaId) AS IDENTIF,					
		POD_Referencia AS REFERENCIA,
		(Select CC_CodigoCuenta + '  ' + CC_Descripcion from CuentasContables Where CC_CodigoId = POD_CC_CuentaId) AS CUCO,

		POD_Monto AS IMPORTE,
		
		(Select MON_Nombre from Monedas Where MON_MonedaId = POL_MON_MonedaId) AS MONEDA,		
		POL_MONP_Paridad AS PARIDAD	,
		*
from Polizas
inner join PolizasDetalle on POD_POL_PolizaId = POL_PolizaId
where POL_NumeroPoliza = '41977'


Select * 
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
Where PRO_CodigoProveedor = @CodProv
and Cast(CXPP_FechaPago AS date)  BETWEEN @FechaIS and @FechaFS 


*/