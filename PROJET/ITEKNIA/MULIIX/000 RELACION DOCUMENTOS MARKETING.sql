-- Nombre: Relación documentos Marketing.
-- Objetivo: Formar un Mapa de Relaciones.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 05 de Septiembre del 2022; Origen.

-- Parámetros 
Declare @FechaIS as nvarchar(30)
Declare @FechaFS as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2021/09/07', 102)
Set @FechaFS = CONVERT (DATE, '2022/09/07', 102)

-- Relacion de los documentos de Marketing.

Select  Convert(varchar, OV_FechaOV, 6) AS FECH_OV
        , OV_CodigoOV AS OV
	, OV_ReferenciaOC AS OC
	, PRY_CodigoEvento AS C_PROYECTO
	, PRY_NombreProyecto AS PROYECTO
	, OT_Codigo AS OT
	, ART_CodigoArticulo AS CODIGO
	, ART_Nombre AS PRODUCTO
	, OTDA_Cantidad AS CANTIDAD
From OrdenesVenta
Inner Join Proyectos on OV_PRO_ProyectoId = PRY_ProyectoId
Inner Join OrdenesTrabajoReferencia on OTRE_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join OrdenesTrabajo on OTRE_OT_OrdenTrabajoId = OT_OrdenTrabajoId
Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
Inner Join Articulos on OTDA_ART_ArticuloId = ART_ArticuloId 
Where Cast(OV_FechaOV as date) BETWEEN @FechaIS and @FechaFS 
Order By OV_FechaOV desc, OV_CodigoOV desc

