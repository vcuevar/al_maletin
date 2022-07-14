-- Consulta para sacar Datos de Resumen de CxC (Kardex)
-- Elaboro: Ing. Alberto Jimenez Medina.
-- Modificado: Ing, Vicente Cueva Ramirez.
-- Actualizado: Jueves 10 de Diciembre del 2020; Origen.
-- Actualizado: Miercoles 30 de Diciembre del 2020; Correccion a Pagos y NC.

--Parametros
Declare @CodeOV as nvarchar(30)
Declare @Id_OV as uniqueidentifier

Set @CodeOV = 'OV01004'
--Set @CodeOV = 'OV00457'
--Set @CodeOV = 'OV00547'
--Set @CodeOV = 'OV00548'

-- Obtener el ID del Codigo de la OV.
Set @Id_OV = (Select OV_OrdenVentaId From OrdenesVenta Where OV_CodigoOV = @CodeOV)

-- Obtener informacion de la Orden de Venta.
Select (Select Cast(OV_FechaOV as Date) from OrdenesVenta Where OV_OrdenVentaId = @Id_OV) as FECHA,
        'VENTAS' as IDENTIF,
       @CodeOV as DOCUMENT, 
       (Select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = @Id_OV) as REFERENCIA,       
       SUM(OVD_CantidadRequerida * OVD_PrecioUnitario - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) +
       ((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) *
       ISNULL(OVD_CMIVA_Porcentaje, 0.0)) as IMP_OV,
         0 as IMP_FAC,
         0 as IMP_EMB,
         0 as IMP_PAG
From OrdenesVentaDetalle
Where OVD_OV_OrdenVentaId = @Id_OV
Union All
-- Obtener información de las Facturas
Select  Cast(FTR_FechaFactura as Date) as FECHA,
        'FACTURA' as IDENTIF,
        'FT' + FTR_NumeroFactura as DOCUMENT,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = FTR_CMM_TipoRegistroId) as REFERENCIA,
        0 as IMP_OV,
        SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0) +
        ((FTRD_CantidadRequerida * FTRD_PrecioUnitario) - (FTRD_CantidadRequerida * FTRD_PrecioUnitario * 
        ISNULL(FTRD_PorcentajeDescuento, 0.0))) * ISNULL(FTRD_CMIVA_Porcentaje, 0.0)) as IMP_FAC,
         0 as IMP_EMB,
         0 as IMP_PAG   
From Facturas                
Inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
Where FTR_Eliminado = 0 and FTR_OV_OrdenVentaId = @Id_OV 
Group By FTR_FechaFactura, FTR_NumeroFactura, FTR_CMM_TipoRegistroId
Union All

-- Obtener Información de los Embarques
--Select * from Embarques

-- Obtener Información de los Pagos Contra Facturas tomar detalle del Pago Aplicado.
Select  Cast(CXCP_FechaCaptura as Date) as FECHA,
        'PAGO A F- ' + FTR_NumeroFactura  as IDENTIF,
        ISNULL(CXCP_CodigoPago, CXCP_IdentificacionPago) as DOCUMENT,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCP_CMM_TipoRegistro) as REFERENCIA,
        0 as IMP_OV,
        0 as IMP_FAC,
        0 as IMP_EMB,
        (CXCPD_MontoAplicado * CXCP_MONP_Paridad) as IMP_PAG
From CXCPagos   
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId   
Inner Join Facturas on FTR_FacturaId = CXCPD_FTR_FacturaId and FTR_OV_OrdenVentaId = @Id_OV
Where CXCP_Eliminado = 0 and CXCP_CMM_FormaPagoId <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F'
Union All

-- Nota de Credito que es para cancelar Factura, Aplica a Factura en forma Negativa.
Select  Cast(NC_FechaPoliza as Date) as FECHA,
        'NC A F- ' + FTR_NumeroFactura as IDENTIF,
        NC_Codigo as DOCUMENT,
        NCD_Descripcion as REFERENCIA,
        0 as IMP_OV,
        (CXCP_MontoPago * CXCP_MONP_Paridad * -1) as IMP_FAC,
        0 as IMP_EMB,
        0 as IMP_PAG
From CXCPagos
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId   
inner Join NotasCredito on NC_NotaCreditoId = CXCPD_NC_NotaCreditoId
inner join NotasCreditoDetalle on NCD_NC_NotaCreditoId = NC_NotaCreditoId
inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId and FTR_OV_OrdenVentaId = @Id_OV
Where CXCP_Eliminado = 0 and NC_Eliminado =  0
Order by FECHA, IDENTIF

/*  ----------------------------------------------------------------------------------------------------------------------------------

Select  Cast(CXCP_FechaCaptura as Date) as FECHA,
        FTR_NumeroFactura,
        'PAGO A F- ' + FTR_NumeroFactura as IDENTIF,
        CXCP_IdentificacionPago as DOCUMENT,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCP_CMM_TipoRegistro) as REF_CXCP,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCPD_CMM_TipoRegistro) as REF_CXCPD,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCP_CMM_FormaPagoId) as FOR_PAGO,
        0 as IMP_OV,
        0 as IMP_FAC,
        0 as IMP_EMB,
        (CXCPD_MontoAplicado * CXCP_MONP_Paridad) as IMP_PAG, 
        *
From CXCPagos   
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId   
Inner Join Facturas on FTR_FacturaId = CXCPD_FTR_FacturaId --and FTR_OV_OrdenVentaId = '2AF0417B-444E-4645-B588-63E887FBDD45'
Where CXCP_Eliminado = 0 and FTR_NumeroFactura = '00210' 


Select  Cast(CXCP_FechaCaptura as Date) as FECHA,
        FTR_NumeroFactura,
        'NC A F- ' + FTR_NumeroFactura as IDENTIF,
        CXCP_IdentificacionPago as DOCUMENT,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCP_CMM_TipoRegistro) as REF_CXCP,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCPD_CMM_TipoRegistro) as REF_CXCPD,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXCP_CMM_FormaPagoId) as FOR_PAGO,
        0 as IMP_OV,
        0 as IMP_FAC,
        0 as IMP_EMB,
        (CXCPD_MontoAplicado * CXCP_MONP_Paridad) as IMP_PAG, 
        *
From CXCPagos   
Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId   
inner Join NotasCredito on NC_NotaCreditoId = CXCPD_NC_NotaCreditoId
inner join NotasCreditoDetalle on NCD_NC_NotaCreditoId = NC_NotaCreditoId
inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId --and FTR_OV_OrdenVentaId = @Id_OV
Where CXCP_Eliminado = 0 and FTR_NumeroFactura = '00368' 

or FTR_NumeroFactura = '00368' 

CXCP_Eliminado = 0 and CXCPD_CXCP_CXCPagoId = 'F8C24C43-3D8A-4A87-9BF1-4CFE18520A43'

Select * from Facturas Where FTR_FacturaId = '99EF7829-1D55-4DA2-B45E-83C543D15580'
1580942.4700000000

Select *
From OrdenesVenta
Where OV_OrdenVentaId = '4B5B2020-6B2B-470D-92BA-23C29D0C9B98'

-- Esta consulta es para obtener las facturas que no tienen relacionado la Ordene de Venta.
-- Para cargarla a la tabla. Muliix la saca del Detalle de la Factura y lo busca en detalle de OV (FTRD_Referencia).

select Distinct FTR_FacturaId, FTR_NumeroFactura, 
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = FTR_CMM_TipoFactura) as TIPO_FACT, FTR_FechaTimbrado, 
        FTR_OV_OrdenVentaId ,
        (Select top (1) OV_CodigoOV from OrdenesVentaDetalle inner join OrdenesVenta on OV_OrdenVentaId = OVD_OV_OrdenVentaId Where OVD_DetalleId = FTRD_ReferenciaId ) as OV_Numero,
        (Select top (1) OV_OrdenVentaId from OrdenesVentaDetalle inner join OrdenesVenta on OV_OrdenVentaId = OVD_OV_OrdenVentaId Where OVD_DetalleId = FTRD_ReferenciaId ) as OV_Id
from Facturas 
inner join FacturasDetalle on FTR_FacturaId = FTRD_FTR_FacturaId
--Where FTR_NumeroFactura = '00374'
--Where FTR_NumeroFactura = '00348'
--Where FTR_OV_OrdenVentaId is null 
Order By FTR_NumeroFactura


Select * from OrdenesVenta Where OV_OrdenVentaId = 'A81E613E-2FF4-4612-9512-96EA5731A6A8'

--Consulta para subir informacion a Muliix, utilizando Calc, Copiando en la linea 7 columna I.
=CONCATENAR("update Facturas set FTR_OV_OrdenVentaId = '",H7,"' where FTR_FacturaId = '",B7,"'")

update Facturas set FTR_OV_OrdenVentaId = 'C7DB1550-4C92-4FC1-BC2F-48DB3BB645A0' where FTR_FacturaId = '573EA1D6-6D44-4B75-BF95-00C79497E916'

update Facturas set FTR_OV_OrdenVentaId = '2AF0417B-444E-4645-B588-63E887FBDD45' where FTR_FacturaId = 'B115D8A0-F757-425C-BF77-07678B11D3FC'

Select * from Proyectos

Select * 
from OrdenesTrabajoReferencia

*/
