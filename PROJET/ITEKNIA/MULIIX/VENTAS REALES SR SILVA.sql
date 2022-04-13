-- Reporte de Ventas Reales segun Sr. Silva.
-- Relacionar Facturacion vs Embarcado
-- Factura Anticipo con Nota de Credito ya no juega.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 16 de Febrero del 2022; Origen.

-- Parametros: Fecha de Corte.
DECLARE @FechaFS date
Set @FechaFS = CONVERT (DATE, '2022-01-31', 102) 


-- Obtener información de las Facturas Anticipo que tienen NOTAS CREDITO, la relacion la estoy haciendo mediante la OV, ya que por factura no tienen relacion directa las
-- Notas de Credito. Ejemplo si la factura anticipo no tiene NC y la de finiquito si tiene por la cantidad del anticipo.

/*
Select ANTEMB.CLIENTE AS CLIENTE
       , SUM(ANTEMB.IMP_FAC_MXP) AS IMP_FACT_MX
       , SUM(ANTEMB.IMP_NCR_MXP) AS IMP_NCRE_MX
       , SUM(ANTEMB.IMP_EMB_MXP) AS IMP_EMBA_MX
From (
*/
Select  Cast(FTR_FechaFactura as Date) AS FECHA
        , CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS CLIENTE
        , OV_CodigoOV AS OV   
        , FTR_OV_OrdenVentaId AS ID_OV     
        , FTR_NumeroFactura AS FT_FACT        
        ,Cast(SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario *FTRD_AFC_FactorConversion -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * FTRD_AFC_FactorConversion * ISNULL(FTRD_PorcentajeDescuento, 0.0)) as decimal(16,2)) AS IMP_FAC_MXP
        --, Cast(ISNULL(B7.IMP_NC, 0) as decimal(16,2)) AS IMP_PAG_MXP 
        , Cast(ISNULL(C7.IMPORTE,0) as decimal(16,2)) AS IMP_NCR_MXP
        , Cast(ISNULL(B8.EMB_IMP_MXP, 0) as decimal(16,2)) AS IMP_EMB_MXP
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = FTR_CMM_TipoRegistroId) AS TIPO_FACT
        , (Select CMM_DefinidoPorUsuario1 from ControlesMaestrosMultiples Where CMM_ControlId = FTD_CMM_FormaPagoId) AS PAGO_CFDI
        , (Select CMM_DefinidoPorUsuario1 from ControlesMaestrosMultiples Where CMM_ControlId = FTD_CMM_UsoCfdiId) AS USO_CFDI  
From Facturas                
Inner Join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
Inner Join FacturasDatos on FTD_FTR_FacturaId = FTR_FacturaId
Inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Clientes on FTD_CLI_ClienteId = CLI_ClienteId

Left Join (Select B4.FTR_OV_OrdenVentaId as NC_ID_OV, SUM(B3.NCD_PrecioUnitario * B0.CXCP_MONP_Paridad * -1) as IMP_NC
        From CXCPagos B0
        Inner Join CXCPagosDetalle B1 on B0.CXCP_CXCPagoId = B1.CXCPD_CXCP_CXCPagoId   
        inner Join NotasCredito B2 on B2.NC_NotaCreditoId = B1.CXCPD_NC_NotaCreditoId
        inner join NotasCreditoDetalle B3 on B3.NCD_NC_NotaCreditoId = B2.NC_NotaCreditoId
        inner join Facturas B4 on B2.NC_FTR_FacturaId = B4.FTR_FacturaId 
        Inner Join Clientes B5 on B2.NC_CLI_ClienteId = B5.CLI_ClienteId
        Where B0.CXCP_Eliminado = 0 and Cast(B2.NC_FechaPoliza as Date) <= @FechaFS
        Group by B4.FTR_OV_OrdenVentaId
        ) B7 on B7.NC_ID_OV = FTR_OV_OrdenVentaId
        
Left Join (Select  C3.FTR_OV_OrdenVentaId AS OV_ID
                , Cast(C1.NC_FechaPoliza as date) AS FE_POLIZA
                , SUM(C2.NCD_Cantidad * C2.NCD_PrecioUnitario * C1.NC_MONP_Paridad) AS IMPORTE
        From NotasCredito C1
        Inner Join NotasCreditoDetalle C2 on C1.NC_NotaCreditoId = C2.NCD_NC_NotaCreditoId
        Inner join Facturas C3 on C1.NC_FTR_FacturaId = C3.FTR_FacturaId and FTR_Eliminado = 0
        Where  C1.NC_Eliminado = 0 and C1.NC_CMM_TipoRelacionId = 'BC7535B5-7123-4F95-8019-BC87311BC6DD'
        and Cast(C1.NC_FechaPoliza as date) <= @FechaFS 
        Group By C1.NC_FechaPoliza, C3.FTR_OV_OrdenVentaId) C7 on C7.OV_ID = FTR_OV_OrdenVentaId 
        
Left Join (Select OV_OrdenVentaId AS EMB_OV
        , SUM(EMBBD_Cantidad * OVD_PrecioUnitario * OVD_AFC_FactorConversion) AS EMB_IMP_MXP        
        from EmbarquesBultos
        Inner Join EmbarquesBultosDetalle on EMBBD_EMBB_EmbarqueBultoId = EMBB_EmbarqueBultoId
        Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
        Inner join BultosDetalle on BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
        Inner join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
        Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
        Left Join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OTRE_OV_OrdenVentaId and ART_ArticuloId = OVD_ART_ArticuloId
        Left Join OrdenesVenta on OV_OrdenVentaId = OVD_OV_OrdenVentaId
        Where EMBB_Eliminado = 0 and EMBBD_FechaCreacion  <= @FechaFS 
        Group By OV_OrdenVentaId) B8 on B8.EMB_OV = FTR_OV_OrdenVentaId
               
Where FTR_Eliminado = 0 and Cast(FTR_FechaFactura as Date) <= @FechaFS 
and (FTR_CMM_TipoRegistroId = '40467F7E-EA35-421A-95D1-74E57E702BF2' or FTR_CMM_TipoRegistroId = '22607E55-8B72-49C1-BB81-B58543654BAD')
and CLI_RazonSocial like '%FEELINGS%'
Group By FTR_FechaFactura, FTR_NumeroFactura, FTR_CMM_TipoRegistroId, OV_CodigoOV, FTD_CMM_FormaPagoId, FTD_CMM_UsoCfdiId,
CLI_CodigoCliente, CLI_RazonSocial, B7.IMP_NC, FTR_OV_OrdenVentaId, B8.EMB_IMP_MXP, C7.IMPORTE
Having (Cast(SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario - FTRD_CantidadRequerida * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0)) as decimal(16,2)) +
Cast(ISNULL(B7.IMP_NC, 0) as decimal(16,2)) ) <> 0 

/*
) ANTEMB
Group by ANTEMB.CLIENTE
Order By ANTEMB.CLIENTE
*/

/*

-- EMbarques
Select  --Cast(EMBBD_FechaCreacion as date) AS FECHA_EMB
        --, EMBB_CodigoEmbarqueBulto AS EMBARQUE
         OV_CodigoOV AS OV
        --, OVD_Concepto AS CONCEPTO
        --, (EMBBD_Cantidad) AS CANTIDAD
        --, (OVD_PrecioUnitario * OVD_AFC_FactorConversion) AS PREC_MXP        
        , SUM(EMBBD_Cantidad * OVD_PrecioUnitario * OVD_AFC_FactorConversion) AS IMP_EMB_MXP        
from EmbarquesBultos
Inner Join EmbarquesBultosDetalle on EMBBD_EMBB_EmbarqueBultoId = EMBB_EmbarqueBultoId
Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
Inner join BultosDetalle on BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
Inner join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Left Join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OTRE_OV_OrdenVentaId and ART_ArticuloId = OVD_ART_ArticuloId
Left Join OrdenesVenta on OV_OrdenVentaId = OVD_OV_OrdenVentaId
Where EMBB_Eliminado = 0 and EMBBD_FechaCreacion  <= @FechaFS 

--ART_CodigoArticulo = '1085.5-23'
Group By OV_CodigoOV


-- Seguimiento de Bultos del Articulos.
Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BUL_PRINC
        , IsNull(BUL_Complemento, '0000') AS BUL_COMPL
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
       -- , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
       -- , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
       -- , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        -- , BUL_CMM_EstatusBultoId
        , (Select CMM_Control + ' -> ' + CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlID =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , BUL_Eliminado AS ELIM_BULTO
        , BULD_Eliminado AS ELIM_DETALLE
        , BULD_PreEmbarcado AS EMBARCADO
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId

Where ART_CodigoArticulo = '1085.5-23'

-- Nota de Credito que es para cancelar Factura, Aplica a Factura en forma Negativa.


Select B4.FTR_NumeroFactura as NC_FACT
        --, SUM(B0.CXCP_MontoPago * B0.CXCP_MONP_Paridad * -1) as IMP_FAC
From CXCPagos B0
Inner Join CXCPagosDetalle B1 on B0.CXCP_CXCPagoId = B1.CXCPD_CXCP_CXCPagoId   
inner Join NotasCredito B2 on B2.NC_NotaCreditoId = B1.CXCPD_NC_NotaCreditoId
inner join NotasCreditoDetalle B3 on B3.NCD_NC_NotaCreditoId = B2.NC_NotaCreditoId
inner join Facturas B4 on B2.NC_FTR_FacturaId = B4.FTR_FacturaId 
Inner Join Clientes B5 on B2.NC_CLI_ClienteId = B5.CLI_ClienteId
Where B0.CXCP_Eliminado = 0 and Cast(B2.NC_FechaPoliza as Date) <= @FechaFS
Group by B4.FTR_NumeroFactura 


-- Nota de Credito que es para cancelar Factura, Aplica a Factura en forma Negativa.
Select  Cast(NC_FechaPoliza as Date) as FECHA
        , FTR_NumeroFactura as NC_FACT
        , NC_Codigo as DOCUMENT
        , NCD_Descripcion as REFERENCIA
         , CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS CLIENTE
        , (CXCP_MontoPago * CXCP_MONP_Paridad * -1) as IMP_FAC
        , NCD_PrecioUnitario
        , NCD_CMIVA_Porcentaje
From CXCPagos
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId   
inner Join NotasCredito on NC_NotaCreditoId = CXCPD_NC_NotaCreditoId
inner join NotasCreditoDetalle on NCD_NC_NotaCreditoId = NC_NotaCreditoId
inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId 
Inner Join Clientes on NC_CLI_ClienteId = CLI_ClienteId
Where CXCP_Eliminado = 0 and (
FTR_NumeroFactura = '00755' or FTR_NumeroFactura = '00858' or FTR_NumeroFactura = '00859')
--Cast(NC_FechaPoliza as Date) <= @FechaFS
Order by FECHA, NC_FACT

--Select top(10) * from OrdenesVenta




-- Martes 08 de Marzo del 2022
-- Notas de Credito Forma de Pago 30 Anticipos y Tipo de Relacion 07 CFDI Pago Anticipos
 




Select  (Select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = FTR_OV_OrdenVentaId) AS OV
        , FTR_OV_OrdenVentaId AS OV_ID
        , NC_Codigo AS NC
        , Cast(NC_FechaPoliza as date) AS FE_POLIZA
        
        , NCD_Cantidad	AS CANT
        , NCD_PrecioUnitario AS PRECIO
        , (Select MON_Abreviacion From Monedas Where MON_MonedaId = NC_MON_MonedaId) AS MONEDA
        , NC_MONP_Paridad AS TIP_CAMB
        , (NCD_Cantidad * NCD_PrecioUnitario * NC_MONP_Paridad) AS IMPORTE
        
        , (Select CMM_Valor From ControlesMaestrosMultiples Where CMM_ControlId = NC_CMM_MetodoPagoId) AS METODO_PAGO
        , (Select CMM_Valor From ControlesMaestrosMultiples Where CMM_ControlId = NC_CMM_UsoCfdiId) AS USO_CFDI
        , (Select CMM_Valor From ControlesMaestrosMultiples Where CMM_ControlId = NC_CMM_TipoRelacionId) AS TIPO_RELAC
        , NC_CMM_TipoRelacionId
        , (Select CMM_Valor From ControlesMaestrosMultiples Where CMM_ControlId = NC_CMM_FormaPagoId) AS FORM_PAGO

        
        , (Select MON_Abreviacion From Monedas Where MON_MonedaId = FTR_MON_MonedaId) AS MON_FAC
        , FTR_MONP_Paridad AS TIP_CAFC
        

From NotasCredito
Inner Join NotasCreditoDetalle on NC_NotaCreditoId = NCD_NC_NotaCreditoId
Inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId and FTR_Eliminado = 0
Where  NC_Eliminado = 0 and NC_CMM_TipoRelacionId = 'BC7535B5-7123-4F95-8019-BC87311BC6DD'
and NC_Codigo = 'NC00277'


*/

/*

Select *from ControlesMaestrosMultiples 
--Where CMM_ControlId = '10F40946-D465-4337-8A2C-B8308190A5AB' --uso
Where CMM_ControlId = 'BC7535B5-7123-4F95-8019-BC87311BC6DD' -- Tipo Relacion CFDI por aplicacion de anticipo
Where CMM_ControlId = 'E92F998F-1FC4-4ACE-B8E7-2E35EFDE2E14' -- Forma de Pago Aplicacion de Anticipo

Select * from ControlesMaestrosMultiples Where CMM_Control =  'CMM_CCXC_CFDI_TipoRelacion'


Where CMM_Control = 'CMM_TipoRegistroFactura'
Where CMM_ControlId = '40467F7E-EA35-421A-95D1-74E57E702BF2' -- OV Parcial
Where CMM_ControlId = '22607E55-8B72-49C1-BB81-B58543654BAD' -- Anticipo

Where CMM_ControlId = '91F1007D-A29E-42C3-8B6B-C84DCE65C620' -- Liquidacion.



Select *from ControlesMaestrosMultiples 
Where CMM_Control = 'CMM_CCXC_MetodoPagoCFDI'
Where CMM_ControlId = '6B764654-75FF-4010-82F3-8EF0AF180790' 


Select *from ControlesMaestrosMultiples 
Where CMM_Control = 'CMM_CCXC_CFDIUso'
Where CMM_ControlId = '10F40946-D465-4337-8A2C-B8308190A5AB'


FTRD_CMM_TipoPartidaId
56C6FE8F-1AF8-4CC5-A3F2-CA0A8C5136DB

*/