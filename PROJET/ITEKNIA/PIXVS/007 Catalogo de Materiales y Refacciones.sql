-- Consulta para Catalogo de Articulos Materiales y Refacciones.
-- Ing. Vicente Cueva R.
-- Sabado 21 de Abril del 2018

-- DESARROLLO DE LA CONSULTA.

Select	ART_CodigoArticulo as CODIGO,
		ART_Nombre as NOMBRE,
		AFAM_Nombre as FAMILIA,
		ACAT_Nombre as CATEGORIA,
		CMM_Valor as SUB_CAT,
		ATP_Descripcion as TIPO,
		CMUM_Nombre as UM_Inv
		--CFDI_Codigo AS CODE_SAT,
		--CFDI_Descripcion AS SAT_DESC,
		--ART_Activo AS ACTIVO_1
from Articulos 
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
left join ArticulosCategorias on ART_ACAT_CategoriaId= ACAT_CategoriaId
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
left join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
left join ControlesMaestrosMultiples on ART_SubCategoriaId = CMM_ControllId
left join CfdiCatalogo on ART_CFDI_CfdiCatalogoId = CFDI_CfdiCatalogoId
where ART_Activo = 1 
--AND AFAM_Nombre not like '%PT%'
order by ART_Nombre
 