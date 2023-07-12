-- Consultas relacionadas a Almacen Digital para modulo de Compras.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 07 de Junio del 2021; Origen.
-- Actualizado: Miercoles 12 de Enero del 2021; Modificacion para Requisiciones.
/*
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

Where OC_Borrado = 0 --and OC_CodigoOC = 'OC05391'

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
-- Modificaciones 5 de Julio del 2023

-- Tabla de los Indices del Almacen Digital de Reportik.
Select * from RPT_AlmacenDigitalIndice 

--Universo de Proyectos Abiertos
Select PRY_ProyectoId AS ID_PRY
		, PRY_CodigoEvento  AS CODIGO 
		, PRY_NombreProyecto  AS PROYECTO
from Proyectos  
Where PRY_CMM_EstatusId  = 'DF14DEDB-9879-49F7-AE2C-64A9A05A4152' and PRY_NombreProyecto like '%CIRCU%'
Order By PRY_CodigoEvento 

-- Determinar los Proyecto Activos a Seleccionar.
Select DISTINCT(PRY_ProyectoId) AS ID_PRY
		, PRY_CodigoEvento  AS CODIGO 
		, PRY_NombreProyecto  AS PROYECTO
from Proyectos 
Inner Join OrdenesVenta on OV_PRO_ProyectoId = PRY_ProyectoId and OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5' 
Where PRY_CMM_EstatusId  = 'DF14DEDB-9879-49F7-AE2C-64A9A05A4152' 
--AND PRY_ProyectoId = '665FF1CC-3086-410B-B230-08F4E5585945'
Order By PRY_CodigoEvento 

DF14DEDB-9879-49F7-AE2C-64A9A05A4152	CMM_EstatusProyecto	Abierto
4771CB7D-E9CD-4593-AA76-D049086742F9	CMM_EstatusProyecto	Cerrado


Select * from OrdenesVenta Where OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5'

3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5	CMM_VEN_EstadoOV	(092) Abierta
2209C8BF-8259-4D8C-A0E9-389F52B33B46	CMM_VEN_EstadoOV	Cerrada Por Usuario
D528E9EC-83CF-49BE-AEED-C3751A3B0F27	CMM_VEN_EstadoOV	Embarque Completo
3C387542-8DFC-42CC-8C49-5B6D32092C0C	CMM_VEN_EstadoOV	Embarque Parcial
90CAC435-DE6B-4148-BD20-16BCE3112936	CMM_VEN_EstadoOV	Facturado Completo
C580C240-44D7-4CE7-9EED-339F2DA967F5	CMM_VEN_EstadoOV	Facturado Parcial

Select * from ControlesMaestrosMultiples Where CMM_Control = 'CMM_EstatusProyecto'
Select * from ControlesMaestrosMultiples Where CMM_ControlId = 'DF14DEDB-9879-49F7-AE2C-64A9A05A4152'
*/
-- ---------------------------------------------------------------------------------------------------------------
-- Actualizado: Martes 11 de Julio del 2023; Para Nuevo almacen Digital en Muliix.
-- 230706: Consultas para Almacen Digital de Compras.
-- Estoy usando el Proyecto 1677.7  MOBILIARIO TORRE KOTS II UNIDAD 2BR SUITE LOFT (3320CA17-1483-4EE8-A4DD-490241F2D594)
-- y el 2092.1  MOBILIARIO CIRCULACIONES VERTICALES DE EAST  CABOS

-- Consulta para cargar requisiciones.
Select  PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
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
and (REQD_PRY_ProyectoId = '665FF1CC-3086-410B-B230-08F4E5585945')
Group By OC_CodigoOC, PRY_CodigoEvento, REQ_CodigoRequisicion, PRY_NombreProyecto, REQ_ArchivoCotizacion1, REQ_ArchivoCotizacion2, REQ_ArchivoCotizacion3

-- Consulta para cargar Ordenes de Compra.
Union all
Select  PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
        , OC_CodigoOC AS GRUPO_ID
        , OC_CodigoOC AS DOC_ID
        , OC_CodigoOC +'.pdf' AS ARCHIVO_1
        , 'S/D' AS ARCHIVO_2
        , 'S/D' AS ARCHIVO_3
        , 'S/D' AS ARCHIVO_4          
From OrdenesCompra
Left join Proyectos on OC_EV_ProyectoId = PRY_ProyectoId
Where OC_Borrado = 0
and (OC_EV_ProyectoId = '665FF1CC-3086-410B-B230-08F4E5585945')

/*
-- Consulta para las OC Recibidas
Union ALL 

Select	PRY_CodigoEvento + '  ' + PRY_NombreProyecto AS PROYECTO
, OC_CodigoOC AS GRUPO_ID
        , OC_CodigoOC AS DOC_ID
OC_CodigoOC as OC,
		OCRC_FechaRecibo as FECH_RECIBO,
		PRO_CodigoProveedor as COD_PROV,
		PRO_Nombre as RAZON_SOC,
		PRY_CodigoEvento as COD_PRY,
		PRY_NombreProyecto as NOM_PRY,
		
		ISNULL((Select ART_CodigoArticulo from Articulos Where ART_ArticuloId = OCD_ART_ArticuloId),'Miscelaneo') as COD_ART,
		ISNULL((Select ART_Nombre from Articulos Where ART_ArticuloId = OCD_ART_ArticuloId),OCD_DescripcionArticulo) as ARTICULO,
		
		OCRC_CantidadRecibo as CANT_REC,
		OCD_CMUM_UMCompras as UMC,
		ISNULL(OCD_AFC_FactorConversion, 1) as FACT_CONV,
		
		(Select MON_Abreviacion from Monedas where MON_MonedaId = OC_MON_MonedaId) as MONEDA,
		OCRC_TipoCambio as TIP_CA,
		OCFR_PrecioUnitario as PRECIO,
		OCD_CMIVA_PorcentajeIVA as IVA,
		OCFR_PorcentajeDescuento as DESCU,
		ISNULL(OCD_CMUM_UMInventario,OCD_CMUM_UMCompras)  as UMI
from OrdenesCompraRecibos
inner join OrdenesCompra on OC_OrdenCompraId = OCRC_OC_OrdenCompraId
inner join Proveedores on PRO_ProveedorId = OC_PRO_ProveedorId
inner join Proyectos on PRY_ProyectoId = OC_EV_ProyectoId
inner join OrdenesCompraFechasRequeridas on OCFR_FechaRequeridaId = OCRC_OCFR_FechaRequeridaId
inner join OrdenesCompraDetalle on OCD_PartidaId = OCFR_OCD_PartidaId
where Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 

*/




/*

select top (5) * from FacturasProveedores Order BY FP_FechaFactura desc

select top (5) * from FacturasProveedoresDetalle Order BY FP_FechaFactura desc

select top (5) * from OrdenesCompraDetalle 

select top (5) * from OrdenesCompra
inner JOIN OrdenesCompraDetalle on OCD_OC_OrdenCompraId = OC_OrdenCompraId
Where OC_CodigoOC = 'OC02055'



Select * from RPT_AlmacenDigitalIndice Where GRUPO_ID = 'OV00747' and DOC_ID = 'FAC00805'

*/