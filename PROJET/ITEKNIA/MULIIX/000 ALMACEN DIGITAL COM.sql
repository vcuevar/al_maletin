-- Consultas relacionadas a Almacen Digital para modulo de Compras.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 07 de Junio del 2021; Origen.
-- Actualizado: Miercoles 12 de Enero del 2021; Modificacion para Requisiciones.

-- Cosnulta para cargar Requisiciones
Select  'COM'+ OC_CodigoOC + REQ_CodigoRequisicion AS LLAVE_ID
        , OC_CodigoOC AS GRUPO_ID
	, REQ_CodigoRequisicion AS DOC_ID
        , REQ_CodigoRequisicion +'.pdf' AS ARCHIVO_1
	, REQ_ArchivoCotizacion1 AS ARCHIVO_2	
	, REQ_ArchivoCotizacion2 AS ARCHIVO_3	
	, REQ_ArchivoCotizacion3 AS ARCHIVO_4
        , SUM(Cast(REQD_CantidadRequerida * REQD_PrecioUnitario as decimal(16,2)))AS IMPORTE      
From Requisiciones
Inner Join RequisicionesDetalle on REQD_REQ_RequisicionId = REQ_RequisicionId 
Left Join OrdenesCompra on REQD_OC_OrdenCompraId = OC_OrdenCompraId 
Where REQ_Eliminado = 0 --and REQ_CodigoRequisicion = 'REQ01695'
Group By OC_CodigoOC, REQ_CodigoRequisicion, REQ_ArchivoCotizacion1, REQ_ArchivoCotizacion2, REQ_ArchivoCotizacion3

-- Consulta para cargar Ordenes de Compra.
Select  'COM'+ OC_CodigoOC + OC_CodigoOC AS LLAVE_ID
        , 'COM'+ OC_CodigoOC AS GRUPO_ID
        , OC_CodigoOC AS DOC_ID
        , OC_CodigoOC +'.pdf' AS ARCHIVO_1
   
        , OC_FechaOC             
From OrdenesCompra

Where OC_Borrado = 0 and OC_CodigoOC = 'OC05391'




-- Tabla de Facturas de Proveedor.
SELECT  FP_CodigoFactura
        , FP_FechaFactura
        , FP_ArchivoXml
        , FP_ArchivoPdf
        , OC_CodigoOC
FROM FacturasProveedores
INNER JOIN FacturasProveedoresDetalle on FPD_FP_FacturaProveedorId = FP_FacturaProveedorId
LEFT JOIN OrdenesCompraDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId
LEFT JOIN OrdenesCompra on OCD_OC_OrdenCompraId = OC_OrdenCompraId
WHERE FP_Eliminado = 0

-- ---------------------------------------------------------------------------------------------------------------




select top (5) * from FacturasProveedores Order BY FP_FechaFactura desc

select top (5) * from FacturasProveedoresDetalle Order BY FP_FechaFactura desc

select top (5) * from OrdenesCompraDetalle 

select top (5) * from OrdenesCompra
inner JOIN OrdenesCompraDetalle on OCD_OC_OrdenCompraId = OC_OrdenCompraId
Where OC_CodigoOC = 'OC02055'