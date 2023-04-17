-- Consulta para Comparas los tres tipos de costo.
-- Desarrollado Ing. Vicente Cueva Ramirez.
-- Creación: 16 de Octubre del 2017
-- Modificado: 16 de Diciembre del 2017
-- Ajustar para que sea reporte de Claudia Castañeda Auditoria.

Select	'ARTICULO' as REPORTE,
		A1.ART_CodigoArticulo as CODIGO, 
		A1.ART_Nombre as NOMBRE, 
		AF.AFAM_Nombre as FAMILIA, 
		SC.CMM_Valor as SUB_CAT, 
		UM.CMUM_Nombre as UM_Inv, 
		A1.ART_CantidadAMano as EXISTENCIA,
		A1.ART_CostoMaterialEstandar as ESTANDAR, 
		A1.ART_UltimoCostoPromedio as PROMEDIO, 
		A1.ART_UltimoCostoUltimo as U_COMPRA  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join ControlesMaestrosMultiples SC on A1.ART_SubCategoriaId = SC.CMM_ControllId
	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0  
	order by  A1.ART_Nombre
 
Select	'PROD. TERM.' as REPORTE,
		A1.ART_CodigoArticulo as CODIGO, 
		A1.ART_Nombre as NOMBRE, 
		AF.AFAM_Nombre as FAMILIA,
		SC.CMM_Valor as SUB_CAT,   
		UM.CMUM_Nombre as UM_Inv, 
		A1.ART_CantidadAMano as EXISTENCIA,
		A1.ART_CostoMaterialEstandar as ESTANDAR, 
		A1.ART_UltimoCostoPromedio as PROMEDIO, 
		A1.ART_UltimoCostoUltimo as U_COMPRA  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join ControlesMaestrosMultiples SC on A1.ART_SubCategoriaId = SC.CMM_ControllId
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 
	order by  A1.ART_Nombre







 A1.ART_FechaCreacion, 
 
 
 /*
Select	*  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 
	and A1.ART_CostoMaterialEstandar <> A1.ART_UltimoCostoUltimo and A1.ART_CodigoArticulo = '0022'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
 */