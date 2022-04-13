-- Reporte: Reporte 032 Surtimiento a la OT por dia.
-- Objetivo: Obtener lo reportado por los supervisores, por dia. de lo que se le carga a las OT.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 21 de Junio del 2019; Inicio.

Use iteknia
--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2019-06-20', 102)
Set @FechaFS = CONVERT (DATE, '2019-06-21', 102) 

-- Consulta de materiales cargados por dia.
Select	OTSE_FechaSurtimiento as FECHA,
		OT_Codigo AS N_OT, 
		ST.CMM_Valor AS ESTATUS, 
		A3.ART_CodigoArticulo AS C_PT, 
		A3.ART_Nombre AS P_TERMINADO, 
		OTDA_Cantidad AS PEDIDOS, 
		ART1.ART_CodigoArticulo AS C_MP, 
		ART1.ART_Nombre AS MATERIAL, 
		UM.CMUM_Nombre AS UM, 
		AFAM.AFAM_Nombre AS FAMILIA, 
		OTSE_Cantidad * -1 AS CANTIDAD, 
		ART1.ART_CostoMaterialEstandar AS C_ESTANDAR, 
		(OTSE_Cantidad * -1) * ART1.ART_CostoMaterialEstandar as IMPORTE
from OrdenesTrabajoSurtimiento  
inner join OrdenesTrabajoSurtimientoDetalle on OTSU_OrdenTrabajoSurtimientoId  = OTSE_OTSU_OrdenTrabajoSurtimientoId 
inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTSU_OT_OrdenTrabajoId 
inner join OrdenesTrabajoDetalleArticulos on  OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId 
inner join Articulos A3 on OTDA_ART_ArticuloId = A3.ART_ArticuloId 
inner join Articulos ART1 on OTSE_ART_ArticuloId = ART1.ART_ArticuloId 
left join ControlesMaestrosUM UM on ART1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId 
Inner Join ArticulosFamilias AFAM on ART1.ART_AFAM_FamiliaId = AFAM.AFAM_FamiliaId 
Inner Join ControlesMaestrosMultiples ST on OT_CMM_Status = ST.CMM_ControllId 
where cast(OTSE_FechaSurtimiento as date) BETWEEN @FechaIS and @FechaFS  
Order by cast(OTSE_FechaSurtimiento as date), FAMILIA, MATERIAL




/* Script para Macro 32 Surtimiento de Ordenes de Produccion

Select	OTSE_FechaSurtimiento as FECHA, OT_Codigo AS N_OT, ST.CMM_Valor AS ESTATUS, A3.ART_CodigoArticulo AS C_PT, A3.ART_Nombre AS P_TERMINADO, OTDA_Cantidad AS PEDIDOS, ART1.ART_CodigoArticulo AS C_MP, ART1.ART_Nombre AS MATERIAL, UM.CMUM_Nombre AS UM, AFAM.AFAM_Nombre AS FAMILIA, OTSE_Cantidad * -1 AS CANTIDAD, ART1.ART_CostoMaterialEstandar AS C_ESTANDAR, (OTSE_Cantidad * -1) * ART1.ART_CostoMaterialEstandar as IMPORTE from OrdenesTrabajoSurtimiento  inner join OrdenesTrabajoSurtimientoDetalle on OTSU_OrdenTrabajoSurtimientoId  = OTSE_OTSU_OrdenTrabajoSurtimientoId inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTSU_OT_OrdenTrabajoId inner join OrdenesTrabajoDetalleArticulos on  OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId 
inner join Articulos A3 on OTDA_ART_ArticuloId = A3.ART_ArticuloId inner join Articulos ART1 on OTSE_ART_ArticuloId = ART1.ART_ArticuloId left join ControlesMaestrosUM UM on ART1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId Inner Join ArticulosFamilias AFAM on ART1.ART_AFAM_FamiliaId = AFAM.AFAM_FamiliaId Inner Join ControlesMaestrosMultiples ST on OT_CMM_Status = ST.CMM_ControllId where cast(OTSE_FechaSurtimiento as date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'  Order by cast(OTSE_FechaSurtimiento as date), FAMILIA, MATERIAL

*/