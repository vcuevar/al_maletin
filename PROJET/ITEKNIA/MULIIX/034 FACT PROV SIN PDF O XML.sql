-- Reporte de Facturas de Proveedor que no tienen cargado PDF y CFDI.
-- Macro: 034 Pendiente de PDF o Complementos Proveedores
-- Elaboro: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 06 de Noviembre del 2020; Origen.
-- Actualizado: Viernes 13 de Noviembre del 2020; Agregar Remitente.
-- Actualizado; Viernes 15 de Enero del 2021; Quitar Anticipos y Saldos de Pagos.
-- Actualizado; Miercoles 07 de Abril del 2021; Agrupar y quitar Sistema Cancelacion de Saldos.

-- Parametros.
-- Ningunos, Filtras las facturas que les falte PDF o CFDI.

-- Consulta Detallada.

Select Distinct Cast(FP_FechaReciboFactura as Date) as FE_FACTURA,
        FP_CodigoFactura as NUM_FACT,
        (Select PRO_CodigoProveedor + '  ' + PRO_Nombre from Proveedores where FP_PRO_ProveedorId = PRO_ProveedorId) + ' / ' +
        ISNULL((Select PRP_Nombre from ProveedoresRemisionesPagos Where PRP_ProveedorRemisionPagoId = FP_PRP_ProveedorRemisionPagoId),'') as PROVEEDOR,
        (Select TEP_TerminoPago from TerminosPago where FP_TEP_TerminoPagoId = TEP_TerminoPagoId) as TERM_PAGO,
        (Select CMM_Valor from ControlesMaestrosMultiples Where FP_CMM_EstatusFacturaId = CMM_ControlId) as STATUS,
        (Select CMM_Valor from ControlesMaestrosMultiples Where FP_CMM_MetodoPagoId = CMM_ControlId) as MET_PAG,
        FP_ArchivoPdf as PDF,
        FP_ArchivoXml as XML
from FacturasProveedores
inner join FacturasProveedoresDetalle on FPD_FP_FacturaProveedorId = FP_FacturaProveedorId
Where (FP_FechaReciboFactura > '2019-31-12 00:00:00' and FP_Eliminado = 0) and 
(FP_ArchivoPdf is null or FP_ArchivoXml is null)
Group By FP_FechaReciboFactura, FP_CodigoFactura, FP_PRO_ProveedorId, FP_PRP_ProveedorRemisionPagoId, FP_TEP_TerminoPagoId, FP_CMM_EstatusFacturaId
, FP_CMM_MetodoPagoId, FP_ArchivoPdf, FP_ArchivoXml
Order By Cast(FP_FechaReciboFactura as Date), PROVEEDOR


select  Cast(CXPP_FechaCaptura as Date) as FE_CAPTURA,
        CXPP_ReferenciaBancaria as REF_BANCO,
        (ISNULL((Select PRO_CodigoProveedor + '  ' + PRO_Nombre from Proveedores where CXPP_PRO_ProveedorId = PRO_ProveedorId), '/') +
        ISNULL(CXPP_CXCP_Pagador, '')) as PROVEEDOR,
        CXPP_IdentificacionPago as IDENTIFICADOR,
        CMM_Valor as TIPO_PAGO,
        (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = CXPPD_CMM_TipoRegistro) as TIPO_REG,
        CXPP_ArchivoPdf as PDF,
        CXPP_ArchivoXml as XML 
from CXPPagos
inner join CXPPagosDetalle on CXPP_CXPPagoId = CXPPD_CXPP_CXPPagoId
inner join FacturasProveedores on CXPPD_FP_FacturaProveedorId = FP_FacturaProveedorId
inner join ControlesMaestrosMultiples on CMM_ControlId = CXPP_CMM_FormaPagoId
Where CXPP_FechaCaptura > '2019-31-12 00:00:00' and FP_CMM_MetodoPagoId = '6B764654-75FF-4010-82F3-8EF0AF180790' 
and FP_CodigoFactura = '1778'
and CXPP_Eliminado = 0 and CXPP_ArchivoXml is null and CMM_Valor <> 'Saldo A Favor' 
--and CMM_Valor <> 'Aplicar Anticipo CXP'
and CMM_Valor <> 'Sistema Cancelacion de Saldos'
Group by CXPP_FechaCaptura, CXPP_ReferenciaBancaria, CXPP_PRO_ProveedorId, CXPP_CXCP_Pagador, CXPP_IdentificacionPago
, CMM_Valor, CXPPD_CMM_TipoRegistro, CXPP_ArchivoPdf, CXPP_ArchivoXml
Order By Cast(CXPP_FechaCaptura as Date)


Select top (20) * from FacturasProveedores
Where FP_CodigoFactura = '1778'


Select  CXPP_IdentificacionPago as IDENTIFICADOR
        , CXPP_ArchivoPdf as PDF
        , CXPP_ArchivoXml as XML 
from CXPPagos
Where CXPP_IdentificacionPago = 'NB00017'

Update CXPPagos set  CXPP_ArchivoPdf = 'NB00017.pdf', CXPP_ArchivoXml = 'NB00017.xml' Where CXPP_IdentificacionPago = 'NB00017'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00019.pdf', CXPP_ArchivoXml = 'NB00019.xml' Where CXPP_IdentificacionPago = 'NB00019'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00020.pdf', CXPP_ArchivoXml = 'NB00020.xml' Where CXPP_IdentificacionPago = 'NB00020'

Update CXPPagos set  CXPP_ArchivoPdf = 'NB00006.pdf', CXPP_ArchivoXml = 'NB00006.xml' Where CXPP_IdentificacionPago = 'NB00006'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00007.pdf', CXPP_ArchivoXml = 'NB00007.xml' Where CXPP_IdentificacionPago = 'NB00007'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00011.pdf', CXPP_ArchivoXml = 'NB00011.xml' Where CXPP_IdentificacionPago = 'NB00011'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00013.pdf', CXPP_ArchivoXml = 'NB00013.xml' Where CXPP_IdentificacionPago = 'NB00013'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00014.pdf', CXPP_ArchivoXml = 'NB00014.xml' Where CXPP_IdentificacionPago = 'NB00014'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00015.pdf', CXPP_ArchivoXml = 'NB00015.xml' Where CXPP_IdentificacionPago = 'NB00015'
Update CXPPagos set  CXPP_ArchivoPdf = 'NB00016.pdf', CXPP_ArchivoXml = 'NB00016.xml' Where CXPP_IdentificacionPago = 'NB00016'







CXPP_ArchivoPdf like '%FELDER%'



