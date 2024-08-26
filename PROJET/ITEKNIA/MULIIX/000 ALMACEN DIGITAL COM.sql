-- Consultas relacionadas a Almacen Digital para modulo de Compras.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 12 de Julio del 2023; Origen.
-- Actualizado: Domingo 23 de Julio del 2023; Completar Filtros y Consulta General.
-- Consulta para los botones de los Filtros.

/*
-- Boton Filtro Requisiciones Convertidas
-- Seleccionas Registro y se guarda
Select  REQ_CodigoRequisicion AS REQUISION
		, OC_CodigoOC AS CODIGO_OC   
From Requisiciones
Inner Join RequisicionesDetalle on REQD_REQ_RequisicionId = REQ_RequisicionId 
Inner Join OrdenesCompra on REQD_OC_OrdenCompraId = OC_OrdenCompraId  
Where REQ_Eliminado = 0
Order by REQ_CodigoRequisicion 


-- Boton Ordenes de Compras
-- Se selecciona la OC y se guarda el Codigo de OC
Select OC_CodigoOC AS ORDEN_COMPRA
	, PRY_CodigoEvento + ' ' + PRY_NombreProyecto AS PROYECTO
From OrdenesCompra
left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId


-- Boton Facturas de Proveedor.
-- Se selecciona Factura y se guarda Codigo de OC	
Select Distinct FP_CodigoFactura AS CODIGO_FACTURA
		, OC_CodigoOC AS ORDEN_COMPRA
From FacturasProveedores 
inner join FacturasProveedoresDetalle on FP_FacturaProveedorId = FPD_FP_FacturaProveedorId
left join OrdenesCompraDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId
left join OrdenesCompra on OC_OrdenCompraId = OCD_OC_OrdenCompraId 
Where OC_CodigoOC is not null

-- Boton Pago de Facturas 
-- Se selecciona Pago y se guarda la OC
Select FP_CodigoFactura AS CODIGO_FACTURA
		, OC_CodigoOC AS ORDEN_COMPRA
From CXPPagos 
inner join CXPPagosDetalle on CXPPD_CXPP_CXPPagoId = CXPP_CXPPagoId
inner join FacturasProveedores on CXPPD_FP_FacturaProveedorId = FP_FacturaProveedorId
inner join FacturasProveedoresDetalle on FP_FacturaProveedorId = FPD_FP_FacturaProveedorId
left join OrdenesCompraDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId
left join OrdenesCompra on OC_OrdenCompraId = OCD_OC_OrdenCompraId
Where OC_CodigoOC is not null
 
-- Boton Filtro por Proyecto.
-- Se muestra Codigo y Proyecto y se guarda el ID seleccionado.
Select PRY_ProyectoId AS ID_PRY
		, PRY_CodigoEvento  AS CODIGO 
		, PRY_NombreProyecto  AS PROYECTO
from Proyectos  
Where PRY_CMM_EstatusId  = 'DF14DEDB-9879-49F7-AE2C-64A9A05A4152'
and PRY_Activo = 1 and PRY_Borrado = 0
Order By PRY_CodigoEvento
*/



-- Tabla para la vista.
-- Consulta General.
Select  ADC.ID_PROY
		, ADC.PROYECTO
    	, ADC.GRUPO_ID
		, DOC_ID
    	, ARCHIVO_1
		, ARCHIVO_2	
		, ARCHIVO_3	
		, ARCHIVO_4    
From (

-- 1) Consulta para cargar requisiciones.
Select PRY_ProyectoId as ID_PROY  
	, PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
    , ISNULL(OC_CodigoOC, 'OC_S/C') AS GRUPO_ID
	, REQ_CodigoRequisicion AS DOC_ID
    , REQ_CodigoRequisicion +'.pdf' AS ARCHIVO_1
	, ISNULL(REQ_ArchivoCotizacion1, 'S/D') AS ARCHIVO_2	
	, ISNULL(REQ_ArchivoCotizacion2, 'S/D') AS ARCHIVO_3	
	, ISNULL(REQ_ArchivoCotizacion3, 'S/D') AS ARCHIVO_4    
From Requisiciones
Left Join RequisicionesDetalle on REQD_REQ_RequisicionId = REQ_RequisicionId 
Left Join OrdenesCompra on REQD_OC_OrdenCompraId = OC_OrdenCompraId 
Left join Proyectos on REQD_PRY_ProyectoId = PRY_ProyectoId
Where REQ_Eliminado = 0 
Group By PRY_ProyectoId, OC_CodigoOC, PRY_CodigoEvento, REQ_CodigoRequisicion, PRY_NombreProyecto, REQ_ArchivoCotizacion1, REQ_ArchivoCotizacion2, REQ_ArchivoCotizacion3

-- 2) Consulta para cargar Ordenes de Compra.
Union all
Select PRY_ProyectoId as ID_PROY
	, PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
    , OC_CodigoOC AS GRUPO_ID
    , OC_CodigoOC AS DOC_ID
    , OC_CodigoOC +'.pdf' AS ARCHIVO_1
    , 'S/D' AS ARCHIVO_2
    , 'S/D' AS ARCHIVO_3
    , 'S/D' AS ARCHIVO_4          
From OrdenesCompra
Left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId
Where OC_Borrado = 0


-- 3) Consulta para los Recibos de Ordenes de Compra (Entradas al almacen).
Union All
Select	PRY_ProyectoId as ID_PROY
	, PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
    , OC_CodigoOC AS GRUPO_ID
    , OC_CodigoOC AS DOC_ID
    , 'Entrada OC' AS ARCHIVO_1
    , 'S/D' AS ARCHIVO_2
    , 'S/D' AS ARCHIVO_3
    , 'S/D' AS ARCHIVO_4
from OrdenesCompraRecibos
inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join Proveedores on PRO_ProveedorId = OC_PRO_ProveedorId
inner join Proyectos on PRY_ProyectoId = OC_EV_ProyectoId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId
inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId
 
-- 4) Facturas de Proveedor
Union All
Select Distinct PRY_ProyectoId as ID_PROY
	, PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
    , OC_CodigoOC AS GRUPO_ID
    , FP_CodigoFactura AS DOC_ID
    , 'Fact. a Proveedor' AS ARCHIVO_1
    ,  FP_ArchivoPdf AS ARCHIVO_2
    , FP_ArchivoXml AS ARCHIVO_3
    , 'S/D' AS ARCHIVO_4 
From FacturasProveedores 
inner join FacturasProveedoresDetalle on FP_FacturaProveedorId = FPD_FP_FacturaProveedorId
left join OrdenesCompraDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId
left join OrdenesCompra on OC_OrdenCompraId = OCD_OC_OrdenCompraId 
Left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId
Where OC_CodigoOC is not null

-- 5) Pagos a Proveedores 
Union all
Select Distinct PRY_ProyectoId as ID_PROY
	, PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
    , OC_CodigoOC AS GRUPO_ID
    , FP_CodigoFactura AS DOC_ID
    , 'Pago a Proveedor' AS ARCHIVO_1
    ,  CXPP_ArchivoPdf AS ARCHIVO_2
    , CXPP_ArchivoXml AS ARCHIVO_3
    , 'S/D' AS ARCHIVO_4 
From CXPPagos 
inner join CXPPagosDetalle on CXPPD_CXPP_CXPPagoId = CXPP_CXPPagoId
inner join FacturasProveedores on CXPPD_FP_FacturaProveedorId = FP_FacturaProveedorId
inner join FacturasProveedoresDetalle on FP_FacturaProveedorId = FPD_FP_FacturaProveedorId
left join OrdenesCompraDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId
left join OrdenesCompra on OC_OrdenCompraId = OCD_OC_OrdenCompraId
Left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId
Where OC_CodigoOC is not null

-- 6) Notas de Debito
/*
Select PRY_ProyectoId as ID_PROY
	, PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
    , OC_CodigoOC AS GRUPO_ID
    , ND_CodigoNotaDebito  AS DOC_ID
    
from NotasDebito
Inner join NotasDebitoDetalle on ND_NotaDebitoID = NDD_ND_NotaDebitoID
inner join FacturasProveedores on NDD_FP_FacturaProveedorId = FP_FacturaProveedorId 
inner join FacturasProveedoresDetalle on FP_FacturaProveedorId = FPD_FP_FacturaProveedorId
left join OrdenesCompraDetalle on FPD_OC_OrdenCompraId = OCD_PartidaId
left join OrdenesCompra on OC_OrdenCompraId = OCD_OC_OrdenCompraId 
Left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId
Where ND_Eliminado = 0
*/



) ADC

-- En caso de que se utilice el filtro de Proyecto.
-- Where ADC.ID_PROY = '665FF1CC-3086-410B-B230-08F4E5585945'

--Para el caso de que sea cualquier otro parametro el filtro es por el Codigo de la OC
Where ADC.GRUPO_ID = 'OC08617'




Select * from ControlesMaestrosMultiples Where CMM_Control = 'CMM_COC_EstadoOrdenCompra'
