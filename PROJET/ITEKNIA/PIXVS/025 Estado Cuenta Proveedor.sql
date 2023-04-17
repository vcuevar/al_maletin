-- PIXVS Consulta para 024 Reporte de Pagos Efectuados.
-- Solicitado por Claudia Castañeda.
-- Desarollado por Ing. Vicente Cueva R.
-- Objetivo: Presentar Estado de cuenta Por Proveedor Todos los Movimientos.
-- Actualizado: Miercoles 10 de Octubre del 2018; Origen
-- Actualizado: 

DECLARE @FechaIS date
DECLARE @FechaFS date
DECLARE @CodeProv nvarchar(50)

Set @FechaIS = CONVERT (DATE, '2018-01-06', 102)
Set @FechaFS = CONVERT (DATE, '2018-10-12', 102) 
Set @CodeProv = 'P299'
/*
-- Datos del Proveedor.
Select	PRO_CodigoProveedor AS CODE,
		PRO_Nombre AS NOMBRE,
		(PRO_Domicilio + '  ' + PRO_Colonia +'  CP:'  + PRO_CodigoPostal) AS DOMICILIO,
		((Select CIU_Nombre from Ciudades where CIU_CiudadId = PRO_CIU_Ciudad ) + '  ' +
		(Select EST_Nombre from Estados where EST_EstadoId = PRO_EST_Estado ) + '  ' +
		(Select PAI_Nombre from Paises where PAI_PaisId = PRO_PAI_Pais )) AS CIUDAD,
		PRO_Telefono AS TEL,
		PRO_RFC AS RFC,
		PRO_Email AS CONTACTO
from Proveedores
Where PRO_CodigoProveedor = @CodeProv

-- Optener Monto de anticipos antes de Fecha de Corte.
Select	PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS PROVEEDOR,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA,
		SUM(CXPPD_MontoAplicado) AS PAGO
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
where CXPP_Borrado = 0
and PRO_CodigoProveedor = @CodeProv 
and Cast(CXPP_FechaPago AS date)  < @FechaIS 
and CXPPD_CMM_TipoRegistro = 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
Group By PRO_CodigoProveedor, PRO_Nombre, CXPP_MON_MonedaId 
Order By MONEDA

-- Optener Detalles de la Fecha de Corte a la Fecha de Hoy.
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
where CXPP_Borrado = 0
and PRO_CodigoProveedor = @CodeProv 
and Cast(CXPP_FechaPago AS date)  >=  @FechaIS 
and CXPPD_CMM_TipoRegistro = 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
Order by ISNULL((Select (BANC_CodigoCuenta + '  ' + BAN_NombreBanco) from BancosCuentas Inner Join Bancos on BANC_BancoId = BAN_CodigoId Where BANC_CodigoId = CXPP_BANC_CodigoId),'CTA. 92-00069225-1  ANTICIPO'), Cast(CXPP_FechaPago AS date), PRO_CodigoProveedor 

-- Optener Monto de anticipos despues de la Fecha de Corte.
Select	PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS PROVEEDOR,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA,
		SUM(CXPPD_MontoAplicado) AS PAGO
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
where CXPP_Borrado = 0
and PRO_CodigoProveedor = @CodeProv
and Cast(CXPP_FechaPago AS date)  >= @FechaIS 
and CXPPD_CMM_TipoRegistro = 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
Group By PRO_CodigoProveedor, PRO_Nombre, CXPP_MON_MonedaId
*/

-- Optener Monto de TOTAL a la Fecha.
Select	PRO_CodigoProveedor AS COD_PROV,
		PRO_Nombre AS PROVEEDOR,
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA,
		SUM(CXPPD_MontoAplicado) AS PAGO
from CXPPagos
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId
where CXPP_Borrado = 0
and PRO_CodigoProveedor = @CodeProv
--and Cast(CXPP_FechaPago AS date)  >= @FechaIS 
and CXPPD_CMM_TipoRegistro = 'D9BCE353-FEEB-4D17-898D-201E6AC356C0'
Group By PRO_CodigoProveedor, PRO_Nombre, CXPP_MON_MonedaId



Select	PRO_CodigoProveedor AS COD_PROV, 
		PRO_Nombre AS PROVEEDOR, 
		(Select MON_Nombre from Monedas Where MON_MonedaId = CXPP_MON_MonedaId) AS MONEDA, 
		SUM(CXPPD_MontoAplicado) AS PAGO, 
		AVG(CXPP_MONP_Paridad) AS PARIDAD 
from CXPPagos 
inner join CXPPagosDetalle on CXPPD_CXPP_PagoCXPId = CXPP_PagoCXPId 
inner join Proveedores on  CXPP_PRV_ProveedorId = PRO_ProveedorId 
where CXPP_Borrado = 0 
and CXPPD_CMM_TipoRegistro = 'D9BCE353-FEEB-4D17-898D-201E6AC356C0' 
and PRO_CodigoProveedor = @CodeProv
Group By PRO_CodigoProveedor, PRO_Nombre, CXPP_MON_MonedaId 
Having SUM(CXPPD_MontoAplicado) <> 0 
Order By PROVEEDOR
