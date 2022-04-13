-- Reporte de Bultos.
-- Objetivo: Conocer los contenidos de los bultos elaborados en Empaque.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 03 de Noviembre del 2020; Origen.
-- Actualizado: Domingo 22 de Mayo del 201; Completar Información.
-- Actualizado: Miercoles 02 de Junio del 2021; Reporte detallado.


Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BUL_PRINC
        , IsNull(BUL_Complemento, '0000') AS BUL_COMPL
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , BUL_X
        , BUL_Y
        , BUL_Z
        , BUL_W
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 and BUL_CMM_TipoBultoId = 'CDBBF4F2-3A62-475B-A0AB-B235496DFE7D'
Union All
Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_Complemento AS BUL_PRINC
        , BUL_NumeroBulto AS BUL_COMPL
        , 'N/A' AS CODE
        , BUL_Contenido AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , 1   as CANTIDAD
        , BUL_X
        , BUL_Y
        , BUL_Z
        , BUL_W
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'
Order By BUL_PRINC, BUL_COMPL

