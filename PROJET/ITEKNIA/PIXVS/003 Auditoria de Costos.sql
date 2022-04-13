-- 003 Consulta para Catalogo de Auditoria de Costos. 
-- Objetivo: Realizar comparativo de los difeentes costos para determinar costo Estandar.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Martes 18 de Junio del 2019; Pasar a Reportik.


-- Consulta Reporte Completo.

Select	ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE, 
		AFAM_Nombre as FAMILIA, 
		CMM_Valor as SUB_CAT, 
		CMUM_Nombre as UDM, 
		ART_CantidadAMano as EXISTENCIA, 
		Convert(Decimal(28,10), ART_CostoMaterialEstandar) as ESTANDAR, 
		ART_UltimoCostoPromedio as PROMEDIO, 
		ART_UltimoCostoUltimo as U_COMPRA 
from Articulos
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
left join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
left join ControlesMaestrosMultiples on ART_SubCategoriaId = CMM_ControllId 
where AFAM_Nombre NOT like 'PT%' and  ART_Activo  <> 0 
order by  ART_Nombre




-- Consulta Solo Estandar en Ceros.

Select	ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE, 
		AFAM_Nombre as FAMILIA, 
		CMM_Valor as SUB_CAT, 
		CMUM_Nombre as UDM, 
		ART_CantidadAMano as EXISTENCIA, 
		Convert(Decimal(28,10), ART_CostoMaterialEstandar) as ESTANDAR, 
		ART_UltimoCostoPromedio as PROMEDIO, 
		ART_UltimoCostoUltimo as U_COMPRA 
from Articulos
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
left join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
left join ControlesMaestrosMultiples on ART_SubCategoriaId = CMM_ControllId 
where AFAM_Nombre NOT like 'PT%' and  ART_Activo  <> 0 
and ART_CostoMaterialEstandar = 0
order by  ART_Nombre
