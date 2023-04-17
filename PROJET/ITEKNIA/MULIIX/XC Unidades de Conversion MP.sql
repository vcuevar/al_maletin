-- Excepcion para Validar las Unidades de Conversion de los Articulos.
-- Elaborado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 14 de Septiembre; Origen.


-- Catalogo con Unidade de Inventario diferente a la de Compras.

Select	ART_Articuloid as ID,
		ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE,
		 
		(Select CMUM_Nombre from ControlesMaestrosUM where ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId) as UM_INV,
		(Select CMUM_Nombre from ControlesMaestrosUM where ART_CMUM_UMConversionOCId = CMUM_UnidadMedidaId) as UM_COM,
		
		(select AFC_FactorConversion from ArticulosFactoresConversion Where AFC_ART_ArticuloId = ART_Articuloid and ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId) as FC_COM, 
		(Select CMUM_Nombre from ControlesMaestrosUM where ART_CMUM_UMConversionOVId = CMUM_UnidadMedidaId) as UM_VEN,
		
		AFAM_Nombre as FAMILIA, 
		ACAT_Nombre as CATEGORIA, 
		SBC.CMM_Valor as SUB_CAT, 
		ATP_Descripcion as TIPO
		
		
from Articulos 
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
left join ArticulosCategorias on ART_ACAT_CategoriaId= ACAT_CategoriaId 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
left join ControlesMaestrosMultiples SBC on ART_CMM_SubcategoriaId = SBC.CMM_ControlId 
left join ControlesMaestrosMultiples CFI on ART_CMM_ClaveProductoId = CFI.CMM_ControlId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
order by ART_Nombre 
 
 