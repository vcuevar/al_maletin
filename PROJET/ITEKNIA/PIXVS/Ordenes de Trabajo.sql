/*
Select * from OrdenesTrabajo
C98AAF89-6245-4207-A0E2-988D28E80FB3


Select * from OrdenesTrabajoDetalleArticulos OTDA
where OTDA.OTDA_OT_OrdenTrabajoId = 'C98AAF89-6245-4207-A0E2-988D28E80FB3'

Select * from OrdenesTrabajoDetalleOVR

Select * from OrdenesTrabajoSurtimiento OTSU 
Where OTSU.OTSU_OT_OrdenTrabajoId = 'C98AAF89-6245-4207-A0E2-988D28E80FB3'

Select * from OrdenesTrabajoSurtimientoDetalle OTSE
Where OTSE.OTSE_OTSU_OrdenTrabajoSurtimientoId = 'F67C72AE-D394-40D3-8054-7EC518A347DC'

Select * 
from OrdenesTrabajoSurtimiento OT
inner join OrdenesTrabajoSurtimientoDetalle OD on OT.OTSU_OrdenTrabajoSurtimientoId  = OD.OTSE_OTSU_OrdenTrabajoSurtimientoId
inner join OrdenesTrabajo OW on OW.OT_OrdenTrabajoId = OT.OTSU_OT_OrdenTrabajoId
Where OW.OT_Codigo = 'OT0441' 

select * from ControlesMaestrosMultiples ST
where ST.CMM_ControllId = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B'
OT.OT_CMM_Status
A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B
*/

Select	OTSE.*,
		OT.OT_Codigo AS N_OT,
		ST.CMM_Valor AS ESTATUS,
		ART3.ART_CodigoArticulo AS C_PT,
		ART3.ART_Nombre AS P_TERMINADO,
		OTDA.OTDA_Cantidad AS PEDIDOS,	   
		ART1.ART_CodigoArticulo AS C_MP,
		ART1.ART_Nombre AS MATERIAL,
		UM.CMUM_Nombre AS UM,
		AFAM.AFAM_Nombre AS FAMILIA,
		OTSE.OTSE_Cantidad AS CANTIDAD,
		ART1.ART_CostoMaterialEstandar AS C_ESTANDAR  
from OrdenesTrabajoSurtimiento OTSU
inner join OrdenesTrabajoSurtimientoDetalle OTSE on OTSU.OTSU_OrdenTrabajoSurtimientoId  = OTSE.OTSE_OTSU_OrdenTrabajoSurtimientoId
inner join OrdenesTrabajo OT on OT.OT_OrdenTrabajoId = OTSU.OTSU_OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos OTDA on  OT.OT_OrdenTrabajoId = OTDA.OTDA_OT_OrdenTrabajoId
inner join Articulos ART3 on OTDA.OTDA_ART_ArticuloId = ART3.ART_ArticuloId
inner join Articulos ART1 on OTSE.OTSE_ART_ArticuloId = ART1.ART_ArticuloId
left join ControlesMaestrosUM UM on ART1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
Inner Join ArticulosFamilias AFAM on ART1.ART_AFAM_FamiliaId = AFAM.AFAM_FamiliaId
Inner Join ControlesMaestrosMultiples ST on OT.OT_CMM_Status = ST.CMM_ControllId
Where ART1.ART_CodigoArticulo= '4712.2-15'  --ST.CMM_Valor = 'En Producción' --  OT.OT_Codigo = 'OT0441' 



--Select OT.OT_Codigo AS N_OT, ST.CMM_Valor AS ESTATUS, ART3.ART_CodigoArticulo AS C_PT, ART3.ART_Nombre AS P_TERMINADO, OTDA.OTDA_Cantidad AS PEDIDOS, ART1.ART_CodigoArticulo AS C_MP, ART1.ART_Nombre AS MATERIAL, UM.CMUM_Nombre AS UM, AFAM.AFAM_Nombre AS FAMILIA, OTSE.OTSE_Cantidad AS CANTIDAD, ART1.ART_CostoMaterialEstandar AS C_ESTANDAR from OrdenesTrabajoSurtimiento OTSU inner join OrdenesTrabajoSurtimientoDetalle OTSE on OTSU.OTSU_OrdenTrabajoSurtimientoId  = OTSE.OTSE_OTSU_OrdenTrabajoSurtimientoId inner join OrdenesTrabajo OT on OT.OT_OrdenTrabajoId = OTSU.OTSU_OT_OrdenTrabajoId inner join OrdenesTrabajoDetalleArticulos OTDA on  OT.OT_OrdenTrabajoId = OTDA.OTDA_OT_OrdenTrabajoId
--inner join Articulos ART3 on OTDA.OTDA_ART_ArticuloId = ART3.ART_ArticuloId inner join Articulos ART1 on OTSE.OTSE_ART_ArticuloId = ART1.ART_ArticuloId left join ControlesMaestrosUM UM on ART1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId Inner Join ArticulosFamilias AFAM on ART1.ART_AFAM_FamiliaId = AFAM.AFAM_FamiliaId Inner Join ControlesMaestrosMultiples ST on OT.OT_CMM_Status = ST.CMM_ControllId Where ST.CMM_Valor = 'En Producción' 

