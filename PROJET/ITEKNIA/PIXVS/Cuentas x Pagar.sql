-- Reporte de Cuentas por Pagar Resumen (Ficha Terminos Pagos Facturas).
-- Sabado 27 de Enero del 2017.

/*
Select *,(B.T_MONTO-B.T_PAGOS) AS SALDOS from (select  PRO.PRO_CodigoProveedor AS CODE_PROV, PRO.PRO_Nombre AS NOMB_PROV, CXP.CXPR_CodigoRegistro AS FACTURA, CXP.CXPR_FechaRegistro AS FECH_FAC, CXP.CXPR_FechaPago AS FECH_VEN, MON.MON_Nombre AS MONEDA, Case When CXP.CXPR_TerminosPagoExtra IS NULL THEN 0 ELSE CXP.CXPR_TerminosPagoExtra END AS MAS_DIAS, CM1.CMM_Valor AS TIPO_REG, (Select SUM(((DCX.CXPRD_Cantidad * DCX.CXPRD_PrecioUnitario) * (1-DCX.CXPRD_PorcentajeDescuento))* (1+DCX.CXPRD_CMIVA_Porcentaje)) 
from CXPRegistrosDetalle DCX Where DCX.CXPRD_CXPR_RegistroCXPId = CXP.CXPR_RegistroCXPId) AS T_MONTO, (Select Case When SUM(PAD.CXPPD_MontoAplicado) IS NULL THEN 0 ELSE SUM(PAD.CXPPD_MontoAplicado) END from CXPPagosDetalle PAD where PAD.CXPPD_RegistroId = CXP.CXPR_RegistroCXPId) AS T_PAGOS, CXP.CXPR_RegistroBorrado AS BORRADO, Case When CM2.CMM_Valor IS NULL THEN 'Abierto' ELSE CM2.CMM_Valor END AS EDO_PAGO from CXPRegistros CXP inner join Proveedores PRO on CXP.CXPR_PRV_ProveedorId = PRO.PRO_ProveedorId
inner join Monedas MON on CXP.CXPR_MON_MonedaId = MON.MON_MonedaId Left join ControlesMaestrosMultiples CM1 on CXP.CXPR_CMM_TipoRegistro = CM1.CMM_ControllId Left join ControlesMaestrosMultiples CM2 on CXP.CXPR_CMM_EstadoPagoId = CM2.CMM_ControllId where  CXP.CXPR_RegistroBorrado <> 1 ) B where (B.T_MONTO - B.T_PAGOS) > 0.02 AND B.EDO_PAGO <> 'Pagado' Order By B.NOMB_PROV, B.FACTURA
*/


-- Reporte de Cuentas por Pagar Resumen.
-- Miercoles 31 de Enero del 2018.
Select *, (B.T_MONTO-B.T_PAGOS) AS SALDOS  from (
select  PRO.PRO_CodigoProveedor AS CODE_PROV,
		PRO.PRO_Nombre AS NOMB_PROV,
		CXP.CXPR_CodigoRegistro AS FACTURA,
		CXP.CXPR_FechaRegistro AS FECH_FAC,
		CXP.CXPR_FechaPago AS FECH_VEN,
		MON.MON_Nombre AS MONEDA,
		Case When CXP.CXPR_TerminosPagoExtra IS NULL THEN 0 ELSE CXP.CXPR_TerminosPagoExtra END AS MAS_DIAS,
		CM1.CMM_Valor AS TIPO_REG,
		(Select SUM(((DCX.CXPRD_Cantidad * DCX.CXPRD_PrecioUnitario) * 
		(1-DCX.CXPRD_PorcentajeDescuento))* 
		(1+DCX.CXPRD_CMIVA_Porcentaje)) 
		from CXPRegistrosDetalle DCX
		Where DCX.CXPRD_CXPR_RegistroCXPId = CXP.CXPR_RegistroCXPId) AS T_MONTO,
		(Select Case When SUM(PAD.CXPPD_MontoAplicado) IS NULL THEN 0 ELSE SUM(PAD.CXPPD_MontoAplicado) END 
		from CXPPagosDetalle PAD	
		where PAD.CXPPD_RegistroId = CXP.CXPR_RegistroCXPId) AS T_PAGOS,
		CXP.CXPR_RegistroBorrado AS BORRADO,
		Case When CM2.CMM_Valor IS NULL THEN 'Abierto' ELSE CM2.CMM_Valor END AS EDO_PAGO			
	from CXPRegistros CXP
	inner join Proveedores PRO on CXP.CXPR_PRV_ProveedorId = PRO.PRO_ProveedorId
	inner join Monedas MON on CXP.CXPR_MON_MonedaId = MON.MON_MonedaId
	Left join ControlesMaestrosMultiples CM1 on CXP.CXPR_CMM_TipoRegistro = CM1.CMM_ControllId
	Left join ControlesMaestrosMultiples CM2 on CXP.CXPR_CMM_EstadoPagoId = CM2.CMM_ControllId
	where  CXP.CXPR_RegistroBorrado <> 1 
	 ) B
	 where (B.T_MONTO - B.T_PAGOS) > 0.02 AND B.EDO_PAGO <> 'Pagado'
	 Order By B.NOMB_PROV, B.FACTURA
	
	
	
	
Select * from Proveedores
where PRO_ProveedorId = 'F1CB8D68-5957-4BF6-A101-78AFC1FEF1F9'
--where PRO_CodigoProveedor = 'P194'

Select * from CXPRegistros
where CXPR_PRV_ProveedorId = 'F1CB8D68-5957-4BF6-A101-78AFC1FEF1F9'


select * from Facturas
where Facturas.FTR_FacturaId = 'F5521DFF-7302-40B0-B719-E169211341C6'


/*



Select * from CXPPlantillas

where CXPR_CodigoRegistro like '%255442%'


Select * from CXPPagosDetalle
where CXPPD_CXPR_RegistroCXPId = '9FEC8D51-3A45-4513-BC31-A8D893661210'

	(Case When (
	
	Select Case When SUM(PAD.CXPPD_MontoAplicado) IS NULL THEN 0 ELSE SUM(PAD.CXPPD_MontoAplicado) END AS T_PAGOS
		from CXPPagosDetalle PAD	
		where PAD.CXPPD_RegistroId = '9FEC8D51-3A45-4513-BC31-A8D893661210') IS NULL THEN 0 END) AS T_PAGOS,
	


where  CXPP_IdentificacionPago like '%8510%'

	
	
-- Consulta para Reporte de Cuentas por Pagar con Detalles de la Compra.
-- Actualizado 20 de Enero del 2018.
	select	PRO.PRO_CodigoProveedor AS CODE_PROV,
			PRO.PRO_Nombre AS NOMB_PROV,
			CXP.CXPR_CodigoRegistro AS FACTURA,
			CXP.CXPR_FechaRegistro AS FECH_FAC,
			CXP.CXPR_FechaPago AS FECH_VEN,
			MON.MON_Nombre AS MONEDA,
			CXP.CXPR_MontoRegistro AS MONTO,
			CXP.CXPR_TerminosPagoExtra AS MAS_DIAS,
			CM1.CMM_Valor AS TIPO_REG,
			CM2.CMM_Valor AS EDO_PAGO,
			CM3.CMM_Valor AS TIPO_PAGO,
			DCX.CXPRD_NumeroLinea AS NUMLINE,
			DCX.CXPP_Descripcion AS DESCRI,
			DCX.CXPRD_Cantidad AS CANT,
			DCX.CXPRD_PrecioUnitario AS PRICE,
			DCX.CXPRD_CMIVA_Porcentaje AS IVA,
			DCX.CXPRD_PorcentajeDescuento AS POR_DESC,
			PAD.CXPPD_MontoAplicado AS PAGOS,
			PAG.CXPP_FechaPago AS FEC_PAGO			
	from CXPRegistros CXP
	inner join Proveedores PRO on CXP.CXPR_PRV_ProveedorId = PRO.PRO_ProveedorId
	inner join CXPRegistrosDetalle DCX on CXP.CXPR_RegistroCXPId = DCX.CXPRD_CXPR_RegistroCXPId
	inner join Monedas MON on CXP.CXPR_MON_MonedaId = MON.MON_MonedaId
	inner Join CXPPagosDetalle PAD on PAD.CXPPD_RegistroId = CXP.CXPR_RegistroCXPId
	inner join CXPPagos PAG on PAG.CXPP_PagoCXPId = PAD.CXPPD_CXPP_PagoCXPId
	Left join ControlesMaestrosMultiples CM1 on CXP.CXPR_CMM_TipoRegistro = CM1.CMM_ControllId
	Left join ControlesMaestrosMultiples CM2 on CXP.CXPR_CMM_EstadoPagoId = CM2.CMM_ControllId
	Left join ControlesMaestrosMultiples CM3 on CXP.CXPR_CMM_TipoPagoId = CM3.CMM_ControllId
	where 
	PRO.PRO_CodigoProveedor = 'P81'
	and CXP.CXPR_CodigoRegistro = 'B9070' 
	--and CXP.CXPR_MontoRegistro > 0 and DCX.CXPRD_NumeroLinea < 2
*/


	
/*

Select	* 
from OrdenesCompraRecibos COM
inner join OrdenesCompra OC on  OC.OC_OrdenCompraId = COM.OCRC_OC_OrdenCompraId
inner join OrdenesCompraDetalle OCD on OCD.OCD_OC_OrdenCompraId = COM.OCRC_OC_OrdenCompraId
inner join Proveedores on OC.OC_PRO_ProveedorId = Proveedores.PRO_ProveedorId

select * from OrdenesCompra 
Select * from OrdenesCompraDetalle
Select * from OrdenesCompraRecibos

Select * from CXPPagos
where  CXPP_IdentificacionPago like '%8510%'

Select * from CXPPagosDetalle
where  CXPP_IdentificacionPago like '%8510%'

Select * from CXPPagos
inner join CXPPagosDetalle on CXPPagos.CXPP_PagoCXPId = CXPPagosDetalle.CXPPD_CXPP_PagoCXPId
where  CXPP_IdentificacionPago like '%8510%'

-- Facturacion de Ventas.
Select * from Facturas			-- Cabecera de Factura
Select * from FacturasDatos     -- Datos de Domicilio
Select * from FacturasDetalle	-- Mercancia Facturada
Select * from FacturasReq

Select * from FacturasRetenciones	-- VACIA
Select * from FacturasCxPPartidas$	-- VACIA
select * from FacturasCxP$			-- VACIA
Select * from FacturasComandas		-- VACIA

-- Consulta para Reporte de Pagos

Select * from CXPPagos

Select * from Proveedores
--where PRO_ProveedorId = '09A73D89-A350-4488-A808-3C9211AB3766'
where PRO_CodigoProveedor = 'P194'

Select * from CXPPagos
where 
--CXPP_PRV_ProveedorId = '09A73D89-A350-4488-A808-3C9211AB3766'
 CXPP_IdentificacionPago = 'GD8510'
--and CXPP_MontoPago = 2865.07

Select * from CXPPagosDetalle

Select * from CobroMultiple

select * from OrdenesCompraRecibos

select * from OrdenesCompra
Where OC_PRO_ProveedorId = 'A2C864D5-97C9-4733-A42B-F6169095BA82'

Select * from CXPRegistros
where  
CXPR_PRV_ProveedorId = 'CFAB29F9-F4DA-44A4-8245-0DF2B52BAC76'

--and CXPR_CodigoRegistro like '7565%'
and CXPR_MontoRegistro > 0

select * from CXPRegistrosDetalle
where CXPRD_CXPR_RegistroCXPId = 'CFAB29F9-F4DA-44A4-8245-0DF2B52BAC76'

select * from ControlesMaestrosMultiples      -- CXPR_CMM_EstadoPagoId = CMM_ControlIId
where CMM_Control = 'CMM_CCXP_EstadoPago'


where CMM_ControllId = '8212C46A-D439-4DB3-94F2-29AA5A27A7C1'
-- where CMM_ControllId = 'C73B4F7F-4F68-45DD-AA08-07A333D67C89'

CXPR_CMM_TipoRegistro
C73B4F7F-4F68-45DD-AA08-07A333D67C89

Select * from MonedaDatos
Select * from Monedas

-- Consulta para Reporte de Cuentas por Pagar Solo Totales.
	select	PRO.PRO_CodigoProveedor AS CODE_PROV,
			PRO.PRO_Nombre AS NOMB_PROV,
			CXP.CXPR_CodigoRegistro AS FACTURA,
			CXP.CXPR_FechaRegistro AS FECH_FAC,
			CXP.CXPR_FechaPago AS FECH_VEN,
			MON.MON_Nombre AS MONEDA,
			CXP.CXPR_MontoRegistro AS MONTO,
			CXP.CXPR_TerminosPagoExtra AS MAS_DIAS
	from CXPRegistros CXP
	inner join Proveedores PRO on CXP.CXPR_PRV_ProveedorId = PRO.PRO_ProveedorId
	inner join Monedas MON on CXP.CXPR_MON_MonedaId = MON.MON_MonedaId
	where 
	PRO.PRO_CodigoProveedor = 'P33'
	and CXP.CXPR_MontoRegistro > 0
	
*/


