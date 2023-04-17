--Consulta para completar informacion de Precios a las Relaciones OV-OT
--Actualizado: Martes 09 de Abril del 2019.


Select * from RBV_OT

--RBV_OT = 1,177 Registros. 1075 ok
--RBV_OT Falta Precio 102

select RBV_ID, OV_CD, OV_CodigoOV, OV_MON_MonedaId, OV_MONP_Paridad , ART_CostoMaterialEstandar, 
(ART_CostoMaterialEstandar / OV_MONP_Paridad) AS PRECIO
--, AR_ID, OVD_ART_ArticuloId,
--ART_CodigoArticulo, ART_Nombre
from RBV_OT
inner join OrdenesVenta on OV_OrdenVentaId = RBV_OT.OV_ID
left join OrdenesVentaDetalle on OVD_OVDetalleId = OVD_ID
left join OrdenesVentaReq on OVR_OVDetalleId = OVD_ID
Inner Join Articulos on ART_ArticuloId = AR_ID
Where PRE_OV is null


Select * from Articulos


Select * from OrdenesVenta

Select * from OrdenesVentaReq
 
 Update RBV_OT Set PRE_OV = 0, TCA_OV = 0, MON_OV = 'x' Where RBV_ID = 'e'

 Update RBV_OT Set PRE_OV = 6269, TCA_OV =10, MON_OV = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' Where RBV_ID = '0A68E842-6D16-49BA-B295-E0B6FDC28389'
Update RBV_OT Set PRE_OV = 6269, TCA_OV =1, MON_OV = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' Where RBV_ID = '0A68E842-6D16-49BA-B295-E0B6FDC28389'
