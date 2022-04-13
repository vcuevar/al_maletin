-- Consulta para sacar Estado de Cuenta por Contacto.
-- Elaboro: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 06 de Enero del 2021; Origen.

-- Parametros Contacto, Fecha Inicio (Para mostrar en reporte no para calculo del Saldo). 

Declare @ContactoId as uniqueidentifier 
Declare @NombCont as nvarchar(50)

-- Seleccion de Contacto.
--Select CCON_Nombre, CCON_Puesto, CLI_CodigoCliente, CLI_RazonSocial from ClientesContactos
--left join Clientes on CCON_CLI_ClienteId = CLI_ClienteId
--Where CCON_Eliminado = 0
--Order By CCON_Nombre, CLI_RazonSocial

Set @NombCont = 'ING. EDUARDO MACIAS'

Set @ContactoId = (Select top (1) CCON_ContactoId from ClientesContactos where CCON_Nombre = @NombCont)


-- Obtener Información de los Embarques
Select TOP (10) * from Embarques
Select TOP (10) * from EmbarquesDetalle
Select TOP (10) * from EmbarquesDevoluciones
Select TOP (10) * from EmbarquesDevolucionesDetalle



Select TOP (10) * from EmbarquesBultos

Select TOP (10) * from EmbarquesBultosDetalle

Select Top (10) * from PreembarqueBulto

Select Top (10) * from PreembarqueBultoDetalle Where PREBD_Eliminado = 0


Select Top (10) * from Bultos Where BUL_Eliminado = 0

Select Top (10) * from BultosDetalle Where BULD_Eliminado = 0

--Caracteristicas del Bulto, el empaque.
Select Top (10) * from BultosDetalleCaracteristicas Where BULDC_Eliminado = 0


Select TOP (10) * 
from EmbarquesBultos 
Inner Join EmbarquesBultosDetalle on EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId


Select Top (10) * 
from Bultos 
Inner Join BultosDetalle on BUL_BultoId = BULD_BUL_BultoId
        -- Orden de Trabajo BULD_OT_OrdenTrabajoId 07872305-BD46-4391-AE00-32F5122E5317
        -- Articulo BULD_ART_ArticuloId F55AF35F-841C-4EF0-9133-275A3A087EC9
Where BUL_Eliminado = 0 and BULD_Eliminado = 0



Select top (10) * from OrdenesVenta
Where OV_CodigoOV = 'OV00697'           Paridad. 19.8537000000

Select top(10) * from CXCPagos 
inner join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId
Where CXCP_CodigoPago = 'CP00129'


(null)CXCP_IdentificacionPago like '%Pago De Cliente%'
Nota N° NC00001 contra Factura(s):  00056













-- Obtener informacion de la Orden de Venta.

Select top (10) 
        CCON_Nombre as COMPRADOR,
        (CLI_CodigoCliente + '  ' + CLI_RazonSocial) as CLIENTE,
        (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) as PROYECTO,
        Cast(OV_FechaOV as Date) as FECHA_OV,
        OV_CodigoOV,
        OV_ReferenciaOC,
        SUM(OVD_CantidadRequerida * OVD_PrecioUnitario - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) +
       ((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) *
       ISNULL(OVD_CMIVA_Porcentaje, 0.0)) as IMP_OV
From OrdenesVenta
inner join OrdenesVentaDetalle on OV_OrdenVentaId = OVD_OV_OrdenVentaId
left join ClientesContactos on CCON_ContactoId = OV_CCON_ContactoId
left join Clientes on CCON_CLI_ClienteId = CLI_ClienteId
left join Proyectos on PRY_ProyectoId = OV_PRO_ProyectoId 
Where OV_Eliminado = 0 and CCON_ContactoId = @ContactoId
Group By OV_FechaOV, OV_CodigoOV, OV_ReferenciaOC, CCON_Nombre, CLI_CodigoCliente, CLI_RazonSocial,PRY_NombreProyecto,PRY_CodigoEvento


/*
select top (10) * from OrdenesVenta Where OV_CCON_ContactoId is null
select top (10) * from proyectos


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
Where CXCP_Eliminado = 0
Order by FECHA, IDENTIF

*/


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
Where FTR_NumeroFactura = '00340'
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
