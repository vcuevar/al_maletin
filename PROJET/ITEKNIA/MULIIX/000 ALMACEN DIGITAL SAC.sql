-- Consultas relacionadas a Almacen Digital.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 03 de Junio del 2021; Origen.

-- Tabla de Empleados
select * from empleados

-- Tabla de Archivo Digital Nombre: RPT_AlmacenDigitalIndice
Select * From RPT_AlmacenDigitalIndice

-- Consulta para Cargar OV al almacen digital.
Select  'SAC'+ OV_CodigoOV + OV_CodigoOV AS LLAVE_ID
        , 'SAC'+ OV_CodigoOV AS GRUPO_ID
	, OV_CodigoOV AS DOC_ID
	, OV_CodigoOV+'.pdf' AS ARCHIVO_1
	, OV_Archivo1 AS ARCHIVO_2	
	, OV_Archivo2 AS ARCHIVO_3	
	, OV_Archivo3 AS ARCHIVO_4
        , SUM(Cast((OVD_CantidadRequerida * OVD_PrecioUnitario) - ((OVD_CantidadRequerida * OVD_PrecioUnitario) * OVD_PorcentajeDescuento) +
         ((OVD_CantidadRequerida * OVD_PrecioUnitario) - ((OVD_CantidadRequerida * OVD_PrecioUnitario) * OVD_PorcentajeDescuento)) * OVD_CMIVA_Porcentaje as decimal(16,2))) AS IMPORTE
From OrdenesVenta
Inner Join OrdenesVentaDetalle on OV_OrdenVentaId = OVD_OV_OrdenVentaId
Where OV_CodigoOV = 'OV00586' 
Group By OV_CodigoOV, OV_Archivo1, OV_Archivo2, OV_Archivo3

-- Consulta para Cargar Ordenes de Trabajo
Select 'SAC'+ OV_CodigoOV + OT_Codigo AS LLAVE_ID
        , 'SAC'+ OV_CodigoOV AS GRUPO_ID
        , OV_OrdenVentaId 
        , OT_Codigo AS DOC_ID
        , OT_Codigo+'.pdf' AS ARCHIVO_1
        , Cast(OTDA_Cantidad * (Select top(1) ((1 * OVD_PrecioUnitario) - ((1 * OVD_PrecioUnitario) * OVD_PorcentajeDescuento) +
        (((1 * OVD_PrecioUnitario) - ((1 * OVD_PrecioUnitario) * OVD_PorcentajeDescuento)) * OVD_CMIVA_Porcentaje)) from OrdenesVentaDetalle
        Where OVD_OV_OrdenVentaId = OTRE_OV_OrdenVentaId and OVD_ART_ArticuloId = OTDA_ART_ArticuloId) as decimal(16,2)) AS IMPORTE
from OrdenesTrabajo
inner join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
Where OV_CodigoOV = 'OV00586'
Order By OV_CodigoOV, OT_Codigo

-- Consulta para Cargar Facturas al almacen digital. NO CANCELADAS.
Select  'SAC' + OV_CodigoOV  + 'FAC' + FTR_NumeroFactura AS LLAVE_ID
       , 'SAC' + OV_CodigoOV  AS GRUPO_ID
       , 'FAC' + FTR_NumeroFactura AS DOC_ID       
       , FTR_NumeroFactura + '-' + CLI_RFC + '.pdf' AS ARCHIVO_1
       , FTR_NumeroFactura + '-' + CLI_RFC + '.xml' AS ARCHIVO_XML        
       , SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario *(1 + FTRD_CMIVA_Porcentaje)) AS IMPORTE
From Facturas
Inner Join FacturasDetalle on FTR_FacturaId = FTRD_FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
where FTR_Eliminado = 0 and OV_CodigoOV = 'OV00586' 
Group By OV_CodigoOV, FTR_NumeroFactura, CLI_RFC

-- Consulta para Cargar Facturas al almacen digital. CANCELADAS con ACUSE.
Select  'SAC' + OV_CodigoOV  + 'FAC' + FTR_NumeroFactura AS LLAVE_ID
       , 'SAC' + OV_CodigoOV  AS GRUPO_ID
       , 'FAC' + FTR_NumeroFactura AS DOC_ID       
       , 'CANCELADO - '+ FTR_NumeroFactura + '-' + CLI_RFC + '.pdf' AS ARCHIVO_1
       , 'ACUSE - '+ FTR_NumeroFactura + '-' + CLI_RFC + '.pdf' AS ARCHIVO_2
       , 'CANCELADO - '+ FTR_NumeroFactura + '-' + CLI_RFC + '.xml' AS ARCHIVO_4
       , 'ACUSE - '+ FTR_NumeroFactura + '-' + CLI_RFC + '.xml' AS ARCHIVO_XML        
       , SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario *(1 + FTRD_CMIVA_Porcentaje)) AS IMPORTE
From Facturas
Inner Join FacturasDetalle on FTR_FacturaId = FTRD_FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
where FTR_Eliminado = 1 and OV_CodigoOV = 'OV00586' 
Group By OV_CodigoOV, FTR_NumeroFactura, CLI_RFC

-- Consulta para Cargar Notas de Credito a Clientes al almacen digital, NO CANCELADAS.
Select  'SAC' + OV_CodigoOV  + NC_Codigo AS LLAVE_ID
       , 'SAC' + OV_CodigoOV  AS GRUPO_ID
       , NC_Codigo AS DOC_ID       
       , NC_Codigo + '-' + CLI_RFC + '.pdf' AS ARCHIVO_1
       , NC_Codigo + '-' + CLI_RFC + '.xml' AS ARCHIVO_XML        
       , SUM(NCD_Cantidad * NC_MONP_Paridad * NCD_PrecioUnitario * (1 + NCD_CMIVA_Porcentaje)) AS IMPORTE
from NotasCredito 
Inner Join NotasCreditoDetalle on NC_NotaCreditoId = NCD_NC_NotaCreditoId
Inner Join Facturas on FTR_FacturaId = NC_FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where NC_Eliminado= 0 and OV_CodigoOV = 'OV00586'
Group By OV_CodigoOV, NC_Codigo, CLI_RFC

-- Consulta para Cargar Notas de Credito a Clientes al almacen digital, CANCELADAS con ACUSE.
Select  'SAC' + OV_CodigoOV  + NC_Codigo AS LLAVE_ID
       , 'SAC' + OV_CodigoOV  AS GRUPO_ID
       , NC_Codigo AS DOC_ID       
       , 'CANCELADO - '+ NC_Codigo + '-' + CLI_RFC + '.pdf' AS ARCHIVO_1
       , 'ACUSE - '+ NC_Codigo + '-' + CLI_RFC + '.pdf' AS ARCHIVO_2
       , 'CANCELADO - '+ NC_Codigo + '-' + CLI_RFC + '.xml' AS ARCHIVO_4
       , 'ACUSE - '+ NC_Codigo + '-' + CLI_RFC + '.xml' AS ARCHIVO_XML        
       , SUM(NCD_Cantidad * NC_MONP_Paridad * NCD_PrecioUnitario * (1 + NCD_CMIVA_Porcentaje)) AS IMPORTE
from NotasCredito 
Inner Join NotasCreditoDetalle on NC_NotaCreditoId = NCD_NC_NotaCreditoId
Inner Join Facturas on FTR_FacturaId = NC_FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where NC_Eliminado= 1 and OV_CodigoOV = 'OV00586'
Group By OV_CodigoOV, NC_Codigo, CLI_RFC


-- Consulta para Cargar Complemnento de Pagos al almacen digital, NO CANCELADOS..
Select  'SAC' + OV_CodigoOV  + CXCP_CodigoPago AS LLAVE_ID
        , 'SAC' + OV_CodigoOV  AS GRUPO_ID
        , CXCP_CodigoPago AS DOC_ID       
        , CXCP_CodigoPago + '-' + CLI_RFC + '.pdf' AS ARCHIVO_1
        , CXCP_CodigoPago + '-' + CLI_RFC + '.xml' AS ARCHIVO_XML        
        , CXCP_MontoPago AS IMPORTE 
From CXCPagos   
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId  
Inner Join Facturas on  FTR_FacturaId = CXCPD_FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where CXCP_CMM_TipoRegistro = '42B7AE60-A156-4647-A85B-56581A74B2B8' and CXCP_Timbrado = 1
and CXCP_Eliminado = 0
and OV_CodigoOV = 'OV00586'
Order By CXCP_CodigoPago


-- Consulta para Cargar Complemnento de Pagos al almacen digital, NO CANCELADOS..
Select  'SAC' + OV_CodigoOV  + CXCP_CodigoPago AS LLAVE_ID
        , 'SAC' + OV_CodigoOV  AS GRUPO_ID
        , CXCP_CodigoPago AS DOC_ID       
        , 'CANCELADO - ' +CXCP_CodigoPago + '-' + CLI_RFC + '.pdf' AS ARCHIVO_1
        , 'ACUSE - ' +CXCP_CodigoPago + '-' + CLI_RFC + '.pdf' AS ARCHIVO_2
        , 'CANCELADO - ' +CXCP_CodigoPago + '-' + CLI_RFC + '.xml' AS ARCHIVO_4
        , 'ACUSE - ' + CXCP_CodigoPago + '-' + CLI_RFC + '.xml' AS ARCHIVO_XML        
        , CXCP_MontoPago AS IMPORTE 
From CXCPagos   
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId  
Inner Join Facturas on  FTR_FacturaId = CXCPD_FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where CXCP_CMM_TipoRegistro = '42B7AE60-A156-4647-A85B-56581A74B2B8' and CXCP_Timbrado = 1
and CXCP_Eliminado = 1 
and OV_CodigoOV = 'OV00615'
Order By CXCP_CodigoPago

--CMM_ControlId	                          CMM_Control	                    CMM_Valor	                      CMM_ValorPredeterminado
6DB96A70-0564-463C-8DF6-12033E32BEDD	CMM_CCXC_TipoRegistroCXC	Pago Cancelar Saldos Facturas CXC	      false
42B7AE60-A156-4647-A85B-56581A74B2B8	CMM_CCXC_TipoRegistroCXC	Pago De Cliente	                              true
092DA85A-22D4-426A-98B7-215211363E85	CMM_CCXC_TipoRegistroCXC	Pago Miscelaneo CXC	                      false
CC700FF3-3B37-4C14-87D5-C2491327BC48	CMM_CCXC_TipoRegistroCXC	Pago Miscelaneo CXP	                      false

-- Consulta para cargar Embarque de Bultos.
Select * from  EmbarquesBultos 
inner join EmbarquesBultosDetalle on EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId

Where EMBB_EmbarqueBultoId = 'BF0BB06E-5F48-4C1B-8F40-889DDAC896CC' and EMBB_Eliminado = 0



EMBBD_PREBD_PreembarqueBultoDetalleId
9EB669CE-C172-4698-A830-5650ED24BD63

Select * from PreembarqueBulto
Select * from PreembarqueBultoDetalle
Select * from EmbarquesBultos
Select * from EmbarquesBultosDetalle

-- Nombre documento Codigo Embarque

-- Consulta para Cargar Cotizaciones (Archivo 1 como CT0000n

Select * from Cotizaciones Where Cast(COT_FechaAlta as date) > Cast('2021-06-01' as date)
-- Concatenar COT + COdigo de Cotizacion

2021-07-28 15:50:22

Select top (10) OVD_COT_CotizacionId
        , OVD_COTD_CotizacionDetalleId
        , OrdenesVenta.* from OrdenesVenta
inner join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OV_OrdenVentaId
Order By OV_CodigoOV DESC


Falta la consulta de Embarques y de Cotizaciones (Definir con Will, que las guarde y donde saco la relación OV->Cotización). Completarlas y enviarlas a Juan.
211124; Dijo Will. Serían OVD_COT_CotizacionId y OVD_COTD_CotizacionDetalleId todavía no los agrego al real ni al de pruebas pero así van a quedar



Select top(10) *
From EmbarquesBultos

Select top(10) *
from ControlesMaestrosMultiples
Where CMM_Control = 'CMM_CCXC_TipoRegistroCXC'
Where CMM_ControlID = '42B7AE60-A156-4647-A85B-56581A74B2B8'

