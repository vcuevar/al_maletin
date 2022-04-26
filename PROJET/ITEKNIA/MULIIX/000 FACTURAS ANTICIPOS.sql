-- Reporte de Facturas de Anticipos.
-- Relacionar Facturacion de Anticipo, Notas de Credito Anticipos y Embarcado
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 16 de Febrero del 2022; Origen.
-- Actualizado: Miercoles 09 de Marzo del 2022; ReOrganizar porque me perdi y no me salio bien.

-- Parametros: Fecha de Corte.
DECLARE @FechaIS date
DECLARE @FechaFS date

--Set @FechaIS = CONVERT (DATE, '2021-01-01', 102) 
Set @FechaIS = CONVERT (DATE, '2022-01-01', 102) 
Set @FechaFS = CONVERT (DATE, '2022-03-31', 102) 
/*
-- Obtener información de las Facturas Anticipo.
Select  'FACTURA ANTICIPOS' AS DOC
        ,Cast(FTR_FechaFactura as Date) AS FECHA
        , CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS CLIENTE
        , OV_CodigoOV AS OV        
        , FTR_NumeroFactura AS FT_FACT  
        ,Cast(SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario *FTR_MONP_Paridad -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * FTR_MONP_Paridad * ISNULL(FTRD_PorcentajeDescuento, 0.0)) as decimal(16,2)) AS IMP_FAC_MXP     
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = FTR_CMM_TipoRegistroId) AS TIPO_FACT
        , (Select CMM_DefinidoPorUsuario1 from ControlesMaestrosMultiples Where CMM_ControlId = FTD_CMM_FormaPagoId) AS PAGO_CFDI
        , (Select CMM_DefinidoPorUsuario1 from ControlesMaestrosMultiples Where CMM_ControlId = FTD_CMM_UsoCfdiId) AS USO_CFDI  
From Facturas                
Inner Join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
Inner Join FacturasDatos on FTD_FTR_FacturaId = FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on FTD_CLI_ClienteId = CLI_ClienteId
Where FTR_Eliminado = 0 
and Cast(FTR_FechaFactura as Date) BETWEEN @FechaIS and @FechaFS 
and (FTR_CMM_TipoRegistroId = '40467F7E-EA35-421A-95D1-74E57E702BF2' or FTR_CMM_TipoRegistroId = '22607E55-8B72-49C1-BB81-B58543654BAD')
and FTRD_CMUM_UnidadMedidaId = '950C94B3-CE1F-4237-AB1B-FFAC19C998F4'
--and CLI_CodigoCliente = 'C00119'
Group By FTR_FechaFactura, FTR_NumeroFactura, FTR_CMM_TipoRegistroId, OV_CodigoOV, FTR_OV_OrdenVentaId, 
FTD_CMM_FormaPagoId, FTD_CMM_UsoCfdiId, CLI_CodigoCliente, CLI_RazonSocial
Order by OV, FTR_FechaFactura, FTR_NumeroFactura




--Notas de Credito del Periodo seleccionado con tipo de relacion 07 CFDI por aplicacion de Anticipo
Select  'NOTAS DE CREDITO' AS DOC
        , OV_CodigoOV AS OV
        , CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS CLIENTE
        , NC_Codigo AS NC
        , Cast(NC_FechaPoliza as date) AS FE_POLIZA
        , NCD_Cantidad	AS CANT
        , NCD_PrecioUnitario AS PRECIO
        , (Select MON_Abreviacion From Monedas Where MON_MonedaId = NC_MON_MonedaId) AS MONEDA
        , NC_MONP_Paridad AS TIP_CAMB
        , (NCD_Cantidad * NCD_PrecioUnitario * NC_MONP_Paridad) AS IMPORTE
        , (Select CMM_Valor From ControlesMaestrosMultiples Where CMM_ControlId = NC_CMM_TipoRelacionId) AS TIPO_RELAC
        , (Select CMM_Valor From ControlesMaestrosMultiples Where CMM_ControlId = NC_CMM_FormaPagoId) AS FORM_PAGO
        , FTR_NumeroFactura
        , (Select MON_Abreviacion From Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MON_FAC
        , FTR_MONP_Paridad AS TIP_CAFC
From NotasCredito
Inner Join NotasCreditoDetalle on NC_NotaCreditoId = NCD_NC_NotaCreditoId
Inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId and FTR_Eliminado = 0
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where  NC_Eliminado = 0 
and NC_CMM_TipoRelacionId = 'BC7535B5-7123-4F95-8019-BC87311BC6DD'
and Cast(NC_FechaPoliza as Date) BETWEEN @FechaIS and @FechaFS 
Order By OV, NC_FechaPoliza, NC_Codigo

*/

-- Reporte de lo Embarcado en el Periodo Por OV  
-- Embarque en rango de fecha y por OV

Select  'RES_EMB' AS DOC
		, CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS CLIENTE
                
	, SUM((EMBBD_Cantidad * OVD_PrecioUnitario - (EMBBD_Cantidad * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) +
       ((EMBBD_Cantidad * OVD_PrecioUnitario) - (EMBBD_Cantidad * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) *
       ISNULL(OVD_CMIVA_Porcentaje, 0.0))*OV_MONP_Paridad) as IMP_EMB    
	   
	   --  , Cast(EMBBD_FechaCreacion as date) AS FECHA
	, OV_CodigoOV AS OV
		 -- , ART_CodigoArticulo AS CODIGO
		 -- , ART_Nombre AS DESCRIPCION
        --, EMBBD_Cantidad AS CANTIDAD
from EmbarquesBultos
Inner Join EmbarquesBultosDetalle on EMBBD_EMBB_EmbarqueBultoId = EMBB_EmbarqueBultoId
Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
Inner join BultosDetalle on BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
Inner join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Inner Join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Inner Join OrdenesVenta  on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
Inner Join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OV_OrdenVentaId and OVD_ART_ArticuloId = ART_ArticuloId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where Cast(EMBBD_FechaCreacion as Date) BETWEEN @FechaIS and @FechaFS
and OV_CodigoOV > 'OV00873'
 Group By CLI_CodigoCliente, CLI_RazonSocial, OV_CodigoOV
 Order By CLI_RazonSocial, OV_CodigoOV
 
 -- Resumen de Facturas de Anticipos Fiscales (Agrupada por cliente, base a OV).
-- Criterio Factura Tipo Parcial o De Anticipo.
-- Unidad de medida igual a Actividad.



Select CLI_CodigoCliente AS COD_CLIE, CLI_RazonSocial AS CLIENTE, SUM((EMBBD_Cantidad * OVD_PrecioUnitario - (EMBBD_Cantidad * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) + ((EMBBD_Cantidad * OVD_PrecioUnitario) - (EMBBD_Cantidad * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0))*OV_MONP_Paridad) as IMP_EMB, OV_CodigoOV AS OV from EmbarquesBultos Inner Join EmbarquesBultosDetalle on EMBBD_EMBB_EmbarqueBultoId = EMBB_EmbarqueBultoId Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId Inner join BultosDetalle on BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId Inner join Articulos on BULD_ART_ArticuloId = ART_ArticuloId Inner Join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Inner Join OrdenesVenta  on OV_OrdenVentaId = OTRE_OV_OrdenVentaId Inner Join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OV_OrdenVentaId and OVD_ART_ArticuloId = ART_ArticuloId Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId Where Cast(EMBBD_FechaCreacion as Date) BETWEEN @FechaIS and @FechaFS and OV_CodigoOV > 'OV00873' Group By CLI_CodigoCliente, CLI_RazonSocial, OV_CodigoOV Order By CLI_RazonSocial, OV_CodigoOV
 













/*

Select 'RES_ANTICIPOS' AS DOC
        , CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS CLIENTE
        , SUM(ANTICIPO.SAL_ANT) AS SALDOS	
From OrdenesVenta
Inner Join (
Select ANTI.OV, SUM(ANTI.IMP_ANT) AS ANTIC, SUM(ANTI.IMP_APL) AS APLIC, (SUM(ANTI.IMP_ANT)-SUM(ANTI.IMP_APL)) AS SAL_ANT, SUM(ANTI.IMP_EMB) AS SAL_EMB
From
(Select  OV_CodigoOV AS OV   
        , 'ANTICIPO' AS DOC             
        ,Cast(SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario * FTR_MONP_Paridad -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * FTR_MONP_Paridad * ISNULL(FTRD_PorcentajeDescuento, 0.0)) as decimal(16,2)) AS IMP_ANT
        , 0 AS IMP_APL
		, 0 AS IMP_EMB
From Facturas                
Inner Join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
Inner Join FacturasDatos on FTD_FTR_FacturaId = FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on FTD_CLI_ClienteId = CLI_ClienteId
Where FTR_Eliminado = 0 
and Cast(FTR_FechaFactura as Date) BETWEEN @FechaIS and @FechaFS 
and (FTR_CMM_TipoRegistroId = '40467F7E-EA35-421A-95D1-74E57E702BF2' or FTR_CMM_TipoRegistroId = '22607E55-8B72-49C1-BB81-B58543654BAD')
and FTRD_CMUM_UnidadMedidaId = '950C94B3-CE1F-4237-AB1B-FFAC19C998F4'
Group By OV_CodigoOV, FTR_OV_OrdenVentaId
Union All
Select  (Select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = FTR_OV_OrdenVentaId) AS OV
        , 'APLICACION' AS DOC
        , 0 AS IMP_ANT
        , SUM(NCD_Cantidad * NCD_PrecioUnitario * NC_MONP_Paridad) AS IMP_APL
		, 0 AS IMP_EMB
From NotasCredito
Inner Join NotasCreditoDetalle on NC_NotaCreditoId = NCD_NC_NotaCreditoId
Inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId and FTR_Eliminado = 0
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where  NC_Eliminado = 0 
and NC_CMM_TipoRelacionId = 'BC7535B5-7123-4F95-8019-BC87311BC6DD'
and Cast(NC_FechaPoliza as Date) BETWEEN @FechaIS and @FechaFS 
Group By FTR_OV_OrdenVentaId
Union All
Select 'OV00751' AS OV, 'AJUST' AS DOC, 218408.18 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All
Select 'OV00696' as OV, 'AJUST' as DOC, 2635032.09 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All 
Select 'OV00833' as OV, 'AJUST' as DOC, 32758.62 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All
Select 'OV00784' as OV, 'AJUST' as DOC, 277988.90 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All 
Select 'OV00804' as OV, 'AJUST' as DOC, 50459.40 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All
Select 'OV00630' as OV, 'AJUST' as DOC, 191304 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All
Select 'OV00551' as OV, 'AJUST' as DOC, 35096.99 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB Union All
Select 'OV00747' as OV, 'AJUST' as DOC, 384213.06 as IMP_ANT, 0 as IMP_APL, 0 as IMP_EMB 

) ANTI
Group By ANTI.OV
) ANTICIPO on ANTICIPO.OV =  OV_CodigoOV
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Group By CLI_CodigoCliente, CLI_RazonSocial
Having SUM(ANTICIPO.SAL_ANT) <> 0
Order by CLI_RazonSocial


*/



/*
-- Detalle por OV
Select 'DETALL_OV' AS DOC
        , ANTI.OV, SUM(ANTI.IMP_ANT) AS ANTIC, SUM(ANTI.IMP_APL) AS APLIC,  (SUM(ANTI.IMP_ANT)-SUM(ANTI.IMP_APL)) AS SAL_ANT  
From (

-- Importe de Facturas de Anticipos
Select  OV_CodigoOV AS OV   
        , 'ANTICIPO' AS DOC             
        ,Cast(SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario *FTRD_AFC_FactorConversion -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * FTRD_AFC_FactorConversion * ISNULL(FTRD_PorcentajeDescuento, 0.0)) as decimal(16,2)) AS IMP_ANT
        , 0 AS IMP_APL
From Facturas                
Inner Join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
Inner Join FacturasDatos on FTD_FTR_FacturaId = FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on FTD_CLI_ClienteId = CLI_ClienteId
Where FTR_Eliminado = 0 
and Cast(FTR_FechaFactura as Date) BETWEEN @FechaIS and @FechaFS 
and (FTR_CMM_TipoRegistroId = '40467F7E-EA35-421A-95D1-74E57E702BF2' or FTR_CMM_TipoRegistroId = '22607E55-8B72-49C1-BB81-B58543654BAD')
and CLI_CodigoCliente = 'C00015'
Group By OV_CodigoOV, FTR_OV_OrdenVentaId

Union All

Select  OV_CodigoOV AS OV
        , 'APLICACION' AS DOC
        , 0 AS IMP_ANT
        , SUM(NCD_Cantidad * NCD_PrecioUnitario * NC_MONP_Paridad) AS IMP_APL
From NotasCredito
Inner Join NotasCreditoDetalle on NC_NotaCreditoId = NCD_NC_NotaCreditoId
Inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId and FTR_Eliminado = 0
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where  NC_Eliminado = 0 
and NC_CMM_TipoRelacionId = 'BC7535B5-7123-4F95-8019-BC87311BC6DD'
and Cast(NC_FechaPoliza as Date) BETWEEN @FechaIS and @FechaFS 
and CLI_CodigoCliente = 'C00015'
Group By OV_CodigoOV

Union All

Select 'OV00751' AS OV, 'AJUST' AS DOC, 436816.36 as IMP_ANT, 0 as IMP_APL Union All -- 06 CONSUTRUCTORA Y DESARROLLADORA INMOBILIARIA TURISTICA
Select 'OV00696' as OV, 'AJUST' as DOC, 2416623.91 as IMP_ANT, 0 as IMP_APL Union All -- 15 CONSTRUCTORA Y DESARROLLADORA DE INMUEBLES
Select 'OV00833' as OV, 'AJUST' as DOC, 32758.62 as IMP_ANT, 0 as IMP_APL Union All -- JEFT TIMNOW
Select 'OV00784' as OV, 'AJUST' as DOC, 277988.90 as IMP_ANT, 0 as IMP_APL Union All  -- 42 OPERADORA TURISTICA HOTELERA
Select 'OV00804' as OV, 'AJUST' as DOC, 50459.40 as IMP_ANT, 0 as IMP_APL Union All -- 90 RIVERA MAYA
Select 'OV00630' as OV, 'AJUST' as DOC, 191304 as IMP_ANT, 0 as IMP_APL Union All -- 262 BRAND STANDARD FURNISHINGS
Select 'OV00551' as OV, 'AJUST' as DOC, 35096.99 as IMP_ANT, 0 as IMP_APL Union All -- 276 SERGIO OLIVARES GONZALEZ
Select 'OV00747' as OV, 'AJUST' as DOC, 384213.06 as IMP_ANT, 0 as IMP_APL -- 262 BRAND STANDARD FURNISHINGS

) ANTI
Group By ANTI.OV
Order By OV

*/


