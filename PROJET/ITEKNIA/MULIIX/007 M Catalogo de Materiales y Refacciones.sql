-- Consulta para 007 Catalogo de Articulos Materiales y Refacciones.
-- Objetivo: Presentar Relacion de Articulos que no son PT.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 21 de Abril del 2018; Origen
-- Actualizado: Sabado 03 de Noviembre del 2018; Cambio a MULIIX

-- DESARROLLO DE LA CONSULTA.

Select	top (10) ART_Articuloid as ID,
		ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE, 
		AFAM_Nombre as FAMILIA, 
		ACAT_Nombre as CATEGORIA, 
		SBC.CMM_Valor as SUB_CAT, 
		ATP_Descripcion as TIPO, 
		CMUM_Nombre as UM_Inv,
		Convert(Decimal(28,10), ART_CostoMaterialEstandar) AS ESTANDAR, 
		Convert(Decimal(28,10), ART_UltimoCostoUltimo) AS ULT_COMPRA, 
		CFI.CMM_DefinidoPorUsuario1 AS CODE_SAT, 
		CFI.CMM_Valor AS SAT_DESC, 
		ART_Activo As ACTIVO_1 
		, ART_ARTM_MarcaId
		, ATP_TipoId
from Articulos 
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
left join ArticulosCategorias on ART_ACAT_CategoriaId= ACAT_CategoriaId 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
left join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
left join ControlesMaestrosMultiples SBC on ART_CMM_SubcategoriaId = SBC.CMM_ControlId 
left join ControlesMaestrosMultiples CFI on ART_CMM_ClaveProductoId = CFI.CMM_ControlId 
where ART_Activo = 1 and ART_Eliminado = 0
AND ATP_Descripcion = 'P.T Fabricado' 
and ART_CodigoArticulo = '0075.5-15'
order by ART_Nombre 



--Select * from ArticulosMarcas

-- Consulta para pasar un articulo a Inactivo.

Select ART_CodigoArticulo, ART_Nombre, ART_Activo, ART_Eliminado
From Articulos
Where ART_CodigoArticulo = '09970'


Update Articulos Set ART_Activo = 0 Where ART_CodigoArticulo = '09970'


/*

--Select *
--from Articulos 
--Where ART_ATP_TipoId <> '56B66D49-FE82-4414-A7E8-43F3916572D3' --   Subensamble fabricado
--and ART_CodigoArticulo LIKE 'PLA%'



--Select *
--from Articulos 
--Where ART_CodigoArticulo LIKE 'PLA-EM%'
--AND ART_ATP_TipoId = '56B66D49-FE82-4414-A7E8-43F3916572D3' --   Subensamble fabricado


--Select * from Articulos Where ART_ArticuloId = '1F3D04BD-D675-4B3C-8055-10F60281E54A'

 --Los SUB (PLANTILLAS) Materias Primas se cambio a PT 30/mar/19 
--Update Articulos Set	ART_ATP_TipoId = '56B66D49-FE82-4414-A7E8-43F3916572D3',
--						ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF',
--						ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF',
--						ART_AFAM_FamiliaId = '53BD82CE-5F59-4CBA-85F7-ACD7C65603A5',
--						ART_ACAT_CategoriaId = 'B55DA558-AA83-4D0F-8A55-9415FDCAADF1',
--						ART_CMM_SubcategoriaId = '89A1F41F-B4D6-49D2-8179-4CF1EC64D7E4'
--Where ART_ATP_TipoId = '56B66D49-FE82-4414-A7E8-43F3916572D3' --   Subensamble fabricado
--and ART_CodigoArticulo LIKE 'PLA%'




-- Para Borrar un articulo hay que ponerle Activo 1 y Eliminado 1
--Select *
--from Articulos 
--Where ART_ArticuloId = '1CD93D1B-8790-4F54-B14A-2DE778CE42DA'

--Update Articulos set ART_Activo = 0, ART_Eliminado = 1 Where ART_ArticuloId = '1CD93D1B-8790-4F54-B14A-2DE778CE42DA'


-- Para cambio de Codigo de Aticulos 


Select	--ART_Articuloid as ID,
		ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE,
		ATP_Descripcion as TIPO,
		ART_FechaCreacion as CREADO,
		ART_SeguimientoLocMult as LOTES
from Articulos 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
AND ATP_Descripcion = 'Materia prima'
and ART_SeguimientoLocMult = 0
--and ART_CodigoArticulo = '12046'
order by ART_CodigoArticulo 


-- MATERIA PRIMA (PARA HACER EXCEPCION DE QUE SOLO SE USEN ESTOS DOS)
--AND ATP_Descripcion = 'Materia prima'
--and ATP_Descripcion = 'Consignado valor no contable'


-- PRODUCTO TERMINADO (PARA HACER EXCEPCIONES)
--and ATP_Descripcion = 'P.T Fabricado'
--and ATP_Descripcion = 'Subensamble fabricado'



--Select ART_CodigoArticulo from Articulos where ART_ArticuloId = '723B9737-AA30-41D7-A82F-661FD6EB39B1'
--update Articulos set ART_CodigoArticulo = 'C0075' where ART_ArticuloId = 'ACE8B2BF-34C0-47DE-8BFF-9BDD0E20179C'


*/