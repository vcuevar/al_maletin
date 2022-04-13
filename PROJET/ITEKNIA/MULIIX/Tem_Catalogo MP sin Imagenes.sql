
-- Objetivo: Catalogo de Materias Primas validar que tenga todas las imagenes.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 27 de Agosto del 2019; Origen.


/*
Select	-- ART_Articuloid as ID,
		ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE,
		ATP_Descripcion as TIPO,
		ISNULL(ART_Imagen, 'SIN IMAGEN') AS IMAGEN
from Articulos 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
AND ATP_Descripcion = 'Materia prima'
--and ATP_Descripcion = 'P.T Fabricado'
--and ATP_Descripcion <> 'Consignado valor no contable'
--and ATP_Descripcion <> 'Subensamble fabricado'

and ART_CMM_SubcategoriaId = 'BBB10439-9178-456C-9530-3C7AD574E84C' -- Especial
--and ART_CMM_SubcategoriaId = '27BC3A6A-D075-4C6C-AFDF-1DEE95B23DC1' --Linea
order by ART_CodigoArticulo 
*/

Select	'CON FOTO' AS REPORTE,
		COUNT(ART_CodigoArticulo) as CODIGOS
from Articulos 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
--and ART_CMM_SubcategoriaId = '27BC3A6A-D075-4C6C-AFDF-1DEE95B23DC1' --Linea
and (ART_Imagen not like '%defa%' or ART_Imagen is not null) 

UNION ALL

Select	'FOTO DEFAULT' AS REPORTE,
		COUNT(ART_CodigoArticulo) as CODIGOS
from Articulos 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
--and ART_CMM_SubcategoriaId = '27BC3A6A-D075-4C6C-AFDF-1DEE95B23DC1' --Linea
and ART_Imagen like '%defa%' 

UNION ALL

Select	'FALTA FOTO' AS REPORTE,
		COUNT(ART_CodigoArticulo) as CODIGOS
from Articulos 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
--and ART_CMM_SubcategoriaId = '27BC3A6A-D075-4C6C-AFDF-1DEE95B23DC1' --Linea
and ART_Imagen IS NULL 

UNION ALL

Select	'TOTAL PT' AS REPORTE,
		COUNT(ART_CodigoArticulo) as CODIGOS
from Articulos 
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
--and ART_CMM_SubcategoriaId = '27BC3A6A-D075-4C6C-AFDF-1DEE95B23DC1' --Linea




