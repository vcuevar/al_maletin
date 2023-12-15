-- Catalogo de Articulos para Migrar a Odoo
-- Desarrollado por: Ing. Vicente Cueva R.
-- Actualizado: Miercoles 29 de Noviembre del 2023; Origen.

Select ART_CodigoArticulo as default_code
	, ART_Nombre AS name
	, 1 AS sale_ok
	, 1 AS purchase_ok
	, cmm.CMM_Valor AS SUB_CATEGORIA
	, am.ARTM_Nombre AS MARCA
	, at2.ATP_Descripcion AS TIPO
	, ac.ACAT_Nombre AS CATEGORIA
	, af.AFAM_Nombre AS FAMILIA
	, cmu.CMUM_Nombre AS UDM
	
	, ART_Precio AS list_price
	, 'Almacenable' AS detailed_type	
	, 'CORTINEROS / CUBRETEX' AS categ_id
	, ART_Comentarios AS Notas
From Articulos 
Inner Join ControlesMaestrosMultiples cmm on  cmm.CMM_ControlId = ART_CMM_SubcategoriaId 
Inner Join ArticulosMarcas am on ART_ARTM_MarcaId = am.ARTM_MarcaId 
Inner Join ArticulosTipos at2 on at2.ATP_TipoId = ART_ATP_TipoId 
Inner Join ArticulosCategorias ac on ac.ACAT_CategoriaId  = ART_ACAT_CategoriaId
Inner Join ArticulosFamilias af on af.AFAM_FamiliaId = ART_AFAM_FamiliaId
Inner Join ControlesMaestrosUM cmu on cmu.CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId
Where ART_Activo = 1
Order by name 

