-- Reporte 003 Auditoria de Costos Estandar MULIIX.
-- Objetivo: Presentar las informacion de los costos Ultimo, Promedio y Estandar, para definir
-- si se actualiza en costo estandar.
-- Desarrollado: 12/Febrero/2018; Ing. Vicente Cueva Ramirez
-- Actualizado:  Miercoles 18 de Julio del 2018

Select  (Select ATP_Descripcion from ArticulosTipos Where ATP_TipoId = ART_ATP_TipoId) AS REPORTE,
		ART_ATP_TipoId AS COD_TIPO,
		ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE, 
		AF.AFAM_Nombre as FAMILIA, 
		CMM_Valor as SUB_CAT,
		UM.CMUM_Nombre as UM_Inv, 
		ISNULL(Convert(Decimal(28,10), ART_CantidadAMano),0) as EXISTENCIA,  
		ISNULL(Convert(Decimal(28,10), ART_CostoMaterialEstandar),0) as ESTANDAR, 
		ART_UltimoCostoPromedio as PROMEDIO, 
		ART_UltimoCostoUltimo as U_COMPRA 
from Articulos 
left join ArticulosFamilias AF on ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ControlesMaestrosUM UM on ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId 
left join ControlesMaestrosMultiples on ART_CMM_SubcategoriaId = CMM_ControlId 
where  ART_Activo  <> 0 and ART_ATP_TipoId  = '8418208F-EC34-41E8-9802-83B4404764DA'
order by  ART_Nombre











Select (Select ATP_Descripcion from ArticulosTipos Where ATP_TipoId = ART_ATP_TipoId) AS REPORTE, ART_ATP_TipoId AS COD_TIPO, ART_CodigoArticulo as CODIGO, ART_Nombre as NOMBRE, AF.AFAM_Nombre as FAMILIA, CMM_Valor as SUB_CAT, UM.CMUM_Nombre as UM_Inv, ISNULL(Convert(Decimal(28,10), ART_CantidadAMano),0) as EXISTENCIA,  ISNULL(Convert(Decimal(28,10), ART_CostoMaterialEstandar),0) as ESTANDAR, ART_UltimoCostoPromedio as PROMEDIO, ART_UltimoCostoUltimo as U_COMPRA from Articulos left join ArticulosFamilias AF on ART_AFAM_FamiliaId = AF.AFAM_FamiliaId left join ControlesMaestrosUM UM on ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId left join ControlesMaestrosMultiples on ART_CMM_SubcategoriaId = CMM_ControlId where  ART_Activo  <> 0 and ART_ATP_TipoId  = '8418208F-EC34-41E8-9802-83B4404764DA' order by  ART_Nombre