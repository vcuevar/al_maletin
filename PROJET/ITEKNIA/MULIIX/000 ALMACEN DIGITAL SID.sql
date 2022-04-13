-- Almacen digital SID
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 16 de Febrero del 2022; Origen.


-- Selecciona Area

Select DEP_Codigo AS CODIGO
        , DEP_Nombre AS AREA
from departamentos
Where DEP_Eliminado = 0 and CONVERT(NUMERIC(10,2),DEP_Codigo) > 100
Order by DEP_Codigo



-- Validar OT
-- Que no este cerrada y que exista la OT
Select OT_Codigo AS OT 
        , ART_CodigoArticulo AS COD_ARTICULO
        , ART_Nombre AS NOB_ARTICULO
        , OV_CodigoOV AS OV
        , PRY_CodigoEvento AS COD_PROY
        , PRY_NombreProyecto AS PROYECTO
from OrdenesTrabajo
inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner Join Articulos on OTDA_ART_ArticuloId = ART_ArticuloId
inner Join OrdenesVenta on  OTRE_OV_OrdenVentaId = OV_OrdenVentaId
inner Join Proyectos on OV_PRO_ProyectoId = PRY_ProyectoId
Where OT_Eliminado = 0 
and OT_CMM_Estatus <> '3887AF19-EA11-4464-A514-8FA6030E5E93'
and OT_CMM_Estatus <> '46B96B9F-3A45-4CF9-9775-175C845B6198'
and OT_CMM_Estatus <> '7246798D-137A-4E94-9404-1D80B777EE09'
and OT_CMM_Estatus <> '3E35C727-DAEE-47FE-AA07-C50EFD93B25F'
and OT_Codigo = 'OT02129'

--Que exista la OT 
Select OT_Codigo AS OT 
        , ART_CodigoArticulo AS COD_ARTICULO
        , ART_Nombre AS NOB_ARTICULO
        , OV_CodigoOV AS OV
        , PRY_CodigoEvento AS COD_PROY
        , PRY_NombreProyecto AS PROYECTO
from OrdenesTrabajo
inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner Join Articulos on OTDA_ART_ArticuloId = ART_ArticuloId
inner Join OrdenesVenta on  OTRE_OV_OrdenVentaId = OV_OrdenVentaId
inner Join Proyectos on OV_PRO_ProyectoId = PRY_ProyectoId
Where OT_Eliminado = 0 
and OT_Codigo = 'OT02129'





Select * from RPT_AlmacenDigitalIndice
Where LLAVE_ID = 'SIDOT02129DEP700'
DOC_ID = 'OT02129'



Select * from ControlesMaestrosMultiples
--Where CMM_ControlId = '3C843D99-87A6-442C-8B89-1E49322B265A'
Where CMM_Control = 'CMM_OT_Estatus'