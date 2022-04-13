-- 022 Relacion de OT contra OV (OT Activas)
-- Tener una relacion de las OT generadas y comparar contra las OV para que no falte ninguna, o que sobren.
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 24 de Noviembre del 2020; Origen.

-- Parametros: Ninguno.

-- Desarrollo de la Consulta Version 1.

Select  OT_Codigo as OT,
        (Select ART_CodigoArticulo + '  ' + ART_Nombre from Articulos Where ART_ArticuloId = OTDA_ART_ArticuloId) as ART_OT,
        OTDA_Cantidad as CANT_OT,
        
        OV_CodigoOV as OV,
        OV_ReferenciaOC as REF_OC,
        (Select ART_CodigoArticulo + '  ' + ART_Nombre from Articulos Where ART_ArticuloId = OVD_ART_ArticuloId) as ART_OV,
        OVD_CantidadRequerida as CANT_OV


        --OrdenesVentaDetalle.* 
        --OrdenesTrabajoDetalleArticulos.*
        
from OrdenesTrabajoReferencia
inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId and OT_Eliminado = 0
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesVentaDetalle on OV_OrdenVentaId = OVD_OV_OrdenVentaId and OTDA_ART_ArticuloId = OVD_ART_ArticuloId
Order By OV_CodigoOV, OT_Codigo



-- Desarrollo Consulta Version 2

Select OT_Codigo, OT_FechaOT, 
        ART_CodigoArticulo,
        ART_Nombre,
        OTDA_Cantidad,
        (Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UM,
        OV_CodigoOV, 
        OV_ReferenciaOC,
        (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes where CLI_ClienteId = OV_CLI_ClienteId) AS CLIENTE,
        (Select CCON_Nombre from ClientesContactos where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
        (Select PRY_CodigoEvento + '  ' + PRY_NombreProyecto from Proyectos where PRY_ProyectoId = OV_PRO_ProyectoId) AS PROYECTO
from OrdenesTrabajo
inner join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId 
Where OT_Eliminado = 0 
-- and OT_Codigo = 'OT00711' 
and OV_CodigoOV = 'OV00604'
Order By OV_CodigoOV, OT_Codigo


 OT_Codigo = 'OT00205'

select * from OrdenesTrabajo

select * from OrdenesVenta where OV_CodigoOV = 'OV00604'





/*
Select  top (50) OV_CodigoOV as OV,
        OV_ReferenciaOC as OC,
        ART_CodigoArticulo as CODE,
        ART_Nombre as DESCRIPCION,
        --OVD_Concepto as DESCRIPCION_OV,
        OVD_CMUM_Nombre as UDM,
        OVD_CantidadRequerida as CANT_OV,
        OT_Codigo as OT,
        ART_ArticuloId,
        OTDA_ART_ArticuloId,
        OTDA_Cantidad
from OrdenesVenta
inner join OrdenesVentaDetalle on OV_OrdenVentaId = OVD_OV_OrdenVentaId
inner join Articulos on ART_ArticuloId = OVD_ART_ArticuloId
right join OrdenesTrabajoReferencia on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId

Where OV_Eliminado = 0
Order By OV_CodigoOV

left join 

(select  OT_Codigo as REFE_OT,
        OTDA_ART_ArticuloId as REFE_ARTICULO,
        OTDA_Cantidad as REFE_CANT_OT,
        OTRE_OV_OrdenVentaId as REFE_OV
from OrdenesTrabajoReferencia 
left join OrdenesTrabajo on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
Where OT_Eliminado = 0 and RF.OTRE_OV_OrdenVentaId = OV_OrdenVentaId and RF.OTDA_ART_ArticuloId = ART_AticuloId
*/


        --(select  OT_Codigo from OrdenesTrabajoReferencia 
         --       left join OrdenesTrabajo on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
          --      inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
--Where OT_Eliminado = 0 and OTRE_OV_OrdenVentaId = OV_OrdenVentaId and OTDA_ART_ArticuloId = ART_AticuloId) as OT
        




 --select * from OrdenesVentaDetalle
 
--select * from OrdenesTrabajoDetalleArticulos

--select * from OrdenesTrabajo
--select * from OrdenesTrabajoDetalle

/*
(Relacion de la OV -> OT)
select * from OrdenesTrabajoReferencia 
inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Where OT_Codigo = 'OT00520'
*/

 --select * from Articulos



Select * from usuarios where USU_Nombre = '851'

update Usuarios set USU_Contrasenia = 'victoria' where USU_UsuarioId = '2482576F-DDFE-448B-A242-09CA2D571315'




-- Validacion para Cerrar OV ya sea por Usuario o por Completa.

Select OT_Codigo, 
        ART_CodigoArticulo,
        ART_Nombre,
        OTDA_Cantidad
from OrdenesTrabajo
inner join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId 
Where OT_Eliminado = 0 and (OT_CMM_Estatus <> '3C843D99-87A6-442C-8B89-1E49322B265A' or OT_CMM_Estatus <> 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B' )
and OV_CodigoOV = 'OV00505'
Order By OV_CodigoOV, OT_Codigo


select * from OrdenesTrabajo where OT_Codigo = 'OT00710'

