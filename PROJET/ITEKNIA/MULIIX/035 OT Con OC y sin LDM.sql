-- 035 Reporte de Ordenes de Compras con OT y sin LDM.
-- Obtener las Ordenes de compra que tienen referencia de OT y no cuenta con LDM.
-- Desarrollo: Ing. Vicente Cueva R.
-- Actualizado: Viernes 16 de Octubre del 2020; Origen.
-- Actualizado: Jueves 03 de Diciembre del 2020; Agregar columna de CATEGORIA. 

--Parametros Ninguno

-- Desarrollo de la Consulta.
-- Si la cantidad en Null significa que no existe LDM para el articulo.

select  OC_CodigoOC as OC,  
        Cast(OC_FechaOC as Date) as FEC_OC, 
        A1.ART_CodigoArticulo as CODE, 
        A1.ART_Nombre as MATERIAL, 
        (Select ACAT_Descripcion from ArticulosCategorias  Where ACAT_CategoriaId = A1.ART_ACAT_CategoriaId) as CATEGORIA,
        OCFR_CantidadRequerida as CANT_OC,
        OT_Codigo as OT,
        A3.ART_CodigoArticulo as COD_PT, 
        A3.ART_Nombre as PRODUCTO,
        (select top(1) EAR_CantidadEnsamble from EstructurasArticulos Where EAR_ART_ArticuloPadreId = A3.ART_ArticuloId and EAR_ART_ComponenteId = A1.ART_ArticuloId) AS LDM
from OrdenesCompraDetalle
inner join OrdenesCompra on OCD_OC_OrdenCompraId = OC_OrdenCompraId
inner join Articulos A1 on OCD_ART_ArticuloId = A1.ART_ArticuloId
inner join OrdenesTrabajo on OCD_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join Articulos A3 on OTDA_ART_ArticuloId = A3.ART_ArticuloId
left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId 
where OC_Borrado = 0  
--and (select top(1) EAR_CantidadEnsamble from EstructurasArticulos Where EAR_ART_ArticuloPadreId = A3.ART_ArticuloId and EAR_ART_ComponenteId = A1.ART_ArticuloId) = 0
Order by OC_CodigoOC

select top (10)* from Articulos



Select * from ControlesMaestrosMultiples 
Where CMM_Control = 'CMM_EstadoOC'
CMM_Control like 'Abiert%' 

CMM_ControlId = 'D35984E5-4B40-4643-9F2F-4AABA4293794'




-- select  OC_CodigoOC as OC, Cast(OC_FechaOC as Date) as FEC_OC, A1.ART_CodigoArticulo as CODE, A1.ART_Nombre as MATERIAL, OCFR_CantidadRequerida as CANT_OC, OT_Codigo as OT, A3.ART_CodigoArticulo as COD_PT, A3.ART_Nombre as PRODUCTO, (select top(1) EAR_CantidadEnsamble from EstructurasArticulos Where EAR_ART_ArticuloPadreId = A3.ART_ArticuloId and EAR_ART_ComponenteId = A1.ART_ArticuloId) AS LDM from OrdenesCompraDetalle inner join OrdenesCompra on OCD_OC_OrdenCompraId = OC_OrdenCompraId inner join Articulos A1 on OCD_ART_ArticuloId = A1.ART_ArticuloId inner join OrdenesTrabajo on OCD_OT_OrdenTrabajoId = OT_OrdenTrabajoId inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId inner join Articulos A3 on OTDA_ART_ArticuloId = A3.ART_ArticuloId left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId where OC_Borrado = 0 and (select top(1) EAR_CantidadEnsamble from EstructurasArticulos Where EAR_ART_ArticuloPadreId = A3.ART_ArticuloId and EAR_ART_ComponenteId = A1.ART_ArticuloId) = 0 Order by OC_CodigoOC
