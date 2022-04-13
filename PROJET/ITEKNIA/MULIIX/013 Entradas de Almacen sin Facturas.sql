-- 013 Consulta para Sacar las Enradas que aun no tienen Factura de Proveedor.
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: 28 de Enero del 2021; Origen.
-- Actualizado: Viernes 19 de Febrero del 2021; Terminada la consulta.


-- Parametros Fecha Inicial para comienzo del Año 2021
-- Set @FechaIS = '2020-12-31'


-- Consulta para sacar Entradas que no cuentan con factura de Proveedor.

select  Cast(OC_FechaOC as Date) as FE_OC
        , ORCG_Codigo as ENTRADA
        , OC_CodigoOC as OC
        , (select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OC_CMM_EstadoOC) as ESTADO
        , (select PRO_CodigoProveedor + '  ' + PRO_Nombre from Proveedores Where PRO_ProveedorId = OC_PRO_ProveedorId) as PROVEEDOR
        , Cast(OCRC_FechaRecibo as Date) as FE_REC
        , Case When OCD_ART_ArticuloId is null then 'MISC' else 'ARTI' end as TIPO
        , OCD_DescripcionArticulo
        , OCFR_CantidadRequerida as SOLICITADO
        , OCRC_CantidadRecibo as RECIBIDO
        , (select EMP_CodigoEmpleado + '  ' + EMP_Nombre + '  ' + EMP_PrimerApellido from Empleados Where OCRC_EMP_ModificadoPorId = EMP_EmpleadoId)  as EMPLEADO
from OrdenesCompraRecibos
inner join OrdenesCompraRecibosGeneral on ORCG_ReciboGeneralId = OCRC_OCRG_ReciboGeneralId
inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId
inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId
left join FacturasProveedoresDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId and FPD_Eliminado = 0
left join FacturasProveedores on FPD_FP_FacturaProveedorId = FP_FacturaProveedorId
Where FP_CodigoFactura is null 
and (Select SUM(T01.OCRC_CantidadRecibo) from OrdenesCompraRecibos T01 Where OCRC_OCFR_FechaRequeridaId = OCFR_FechaRequeridaId) > 0
and OC_Borrado = 0
and Cast(OCRC_FechaRecibo as Date) > '2020-12-31'
Order by FE_REC, OC, OCD_DescripcionArticulo, ENTRADA





select  Cast(OC_FechaOC as Date) as FE_OC, ORCG_Codigo as ENTRADA, OC_CodigoOC as OC, (select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OC_CMM_EstadoOC) as ESTADO, (select PRO_CodigoProveedor + '  ' + PRO_Nombre from Proveedores Where PRO_ProveedorId = OC_PRO_ProveedorId) as PROVEEDOR, Cast(OCRC_FechaRecibo as Date) as FE_REC, Case When OCD_ART_ArticuloId is null then 'MISC' else 'ARTI' end as TIPO, OCD_DescripcionArticulo, OCFR_CantidadRequerida as SOLICITADO, OCRC_CantidadRecibo as RECIBIDO, (select EMP_CodigoEmpleado + '  ' + EMP_Nombre + '  ' + EMP_PrimerApellido from Empleados Where OCRC_EMP_ModificadoPorId = EMP_EmpleadoId)  as EMPLEADO from OrdenesCompraRecibos inner join OrdenesCompraRecibosGeneral on ORCG_ReciboGeneralId = OCRC_OCRG_ReciboGeneralId inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId left join FacturasProveedoresDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId and FPD_Eliminado = 0 left join FacturasProveedores on FPD_FP_FacturaProveedorId = FP_FacturaProveedorId Where FP_CodigoFactura is null and (Select SUM(T01.OCRC_CantidadRecibo) from OrdenesCompraRecibos T01 Where OCRC_OCFR_FechaRequeridaId = OCFR_FechaRequeridaId) > 0 and OC_Borrado = 0 and Cast(OCRC_FechaRecibo as Date) > '2020-12-31' Order by FE_REC, OC, OCD_DescripcionArticulo, ENTRADA 
