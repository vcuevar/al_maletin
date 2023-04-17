SELECT OT_Codigo AS OT,
       ART_CodigoArticulo AS ARTICULO,
       ART_Nombre AS PRODUCTO,
       Cast(OVD_CantidadRequerida AS decimal(16, 2)) AS CANT,
       CMUM_Nombre AS UNIDAD,
       ART_Comentarios AS DESCRIPCION,

  (SELECT AET_Valor
   FROM ArticulosEspecificaciones
   WHERE AET_ART_ArticuloId = ART_ArticuloId
     AND AET_CMM_ArticuloEspecificaciones = 'CADE29BF-1459-4C9E-9A66-DA478E96D5E7') AS MEDIDA,

  (SELECT AET_Valor
   FROM ArticulosEspecificaciones
   WHERE AET_ART_ArticuloId = ART_ArticuloId
     AND AET_CMM_ArticuloEspecificaciones = 'CE6EB5D1-7298-432E-94E5-2EB23D431C78') AS AREA,

  (SELECT AET_Valor
   FROM ArticulosEspecificaciones
   WHERE AET_ART_ArticuloId = ART_ArticuloId
     AND AET_CMM_ArticuloEspecificaciones = '2ACE7D3D-734B-4603-B7C9-48E32FA7312E') AS ACABADOS,

  (SELECT AET_Valor
   FROM ArticulosEspecificaciones
   WHERE AET_ART_ArticuloId = ART_ArticuloId
     AND AET_CMM_ArticuloEspecificaciones = '0DDB36A5-E60A-447A-8F22-D65C08886E8F') AS TELAS ,
       ART_Imagen AS IMAGEN,
       PRY_NombreProyecto AS PROYECTO,
       Cast(OT_FechaOT AS date) AS FECHA_DE_ENTREGA,
       'PROCESO' AS PROCESO,
       Cast(((OVD_PrecioUnitario * OVD_CantidadRequerida) / 5000) AS decimal(16, 3)) AS PUNTOS,
       OV_CodigoOV AS OV,
       Cast((OVD_PrecioUnitario) AS decimal(16, 2)) AS PRECIO_U,
       Cast(OV_FechaOV AS date) AS FECH_OV,
       SOT_Estacion +' - ' + SCO.SCR_NombreOrigen AREA_CP,
       sot_recibido - SOT_Entregado CANT_CP
       --COALESCE( AreaDestino.cantidad_entregado, 0) AreaDestino_cantidad_entregado 
FROM OrdenesTrabajo
      
INNER JOIN OrdenesTrabajoDetalleArticulos ON OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
INNER JOIN Articulos ON ART_ArticuloId = OTDA_ART_ArticuloId
INNER JOIN ControlesMaestrosUM ON ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
INNER JOIN OrdenesTrabajoReferencia ON OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
INNER JOIN OrdenesVenta ON OV_OrdenVentaId = OTRE_OV_OrdenVentaId
INNER JOIN OrdenesVentaDetalle ON OVD_OV_OrdenVentaId =OV_OrdenVentaId
AND OTDA_ART_ArticuloId = OVD_ART_ArticuloId
INNER JOIN OrdenesVentaReq ON OVR_OVD_DetalleId = OVD_DetalleId
INNER JOIN Proyectos ON OV_PRO_ProyectoId = PRY_ProyectoId
INNER JOIN Clientes ON OV_CLI_ClienteId = CLI_ClienteId
INNER JOIN RPT_Seguimiento_OT sot ON OT_OrdenTrabajoId = SOT_OT_OrdenTrabajoId
LEFT JOIN RPT_Seguimiento_ConfiguracionRutas SCO on SCO.SCR_Origen = sot.SOT_Estacion
left join (
SELECT SOF_OT_OrdenTrabajoId OrdenTrabajoId, sCR.SCR_Origen, f.item estacion_destino, SUM(sof.SOF_Cantidad) cantidad_entregado
  FROM RPT_Seguimiento_ConfiguracionRutas SCR
  CROSS APPLY dbo.SplitStrings(scr.SCR_Destino, ',') as f
  inner join RPT_Seguimiento_OTF sof on sof.SOf_Estacion = f.item
  group by SOF_OT_OrdenTrabajoId, sCR.SCR_Origen, f.item 
) AreaDestino on AreaDestino.OrdenTrabajoId = SOT_OT_OrdenTrabajoId
AND AreaDestino.SCR_Origen = sot.SOT_Estacion
WHERE (OT_CMM_Estatus = '3C843D99-87A6-442C-8B89-1E49322B265A'
       OR OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B'
       OR OT_CMM_Estatus = '213ED3B9-12B3-41C9-8C6E-230DC86BBF90')
  AND OT_Eliminado = 0
  AND SOT_Activo = 1
  AND sot_recibido - (SOT_Entregado + COALESCE( AreaDestino.cantidad_entregado, 0)) > 0
  AND OT_Codigo = 'OT02911' -- FILTRO POR OT
  AND SCO.SCR_BO = 'FUNDAS' -- FILTRO BO 'CARPINTERIA'
  --AND SCO.SCR_Origen = '150' -- FILTRO POR ESTACION
   GROUP BY OT_Codigo, ART_CodigoArticulo, ART_Nombre, OVD_CantidadRequerida, CMUM_Nombre, ART_Comentarios, ART_Imagen, PRY_NombreProyecto, OT_FechaOT, OV_CodigoOV, OVD_PrecioUnitario, sot_recibido, SOT_Entregado, ART_ArticuloId, OV_FechaOV, SOT_Estacion, SCO.SCR_NombreOrigen
   , AreaDestino.cantidad_entregado
ORDER BY OT_FechaOT,
         OT_Codigo
