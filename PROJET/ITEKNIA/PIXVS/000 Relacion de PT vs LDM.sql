-- Catalogo de Productos Terminados Segun su LDM.
-- PRODUCTO TERMINADO VS LDM.
	--use iteknia
	Select COUNT(A1.ART_CodigoArticulo) AS MAT_PRIMAS
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 
	
	--Detalle del Catalogo.
	Select A3.ART_CodigoArticulo as CODIGO, A3.ART_Nombre as NOMBRE, AT.ATP_Descripcion as TIPO, AF.AFAM_Nombre as FAMILIA,
	AC.ACAT_Nombre as CATEGORIA, AG.CMM_Valor AS ESTATUS,
	COUNT(LDM.EAR_CantidadEnsamble) as LDM
	from Articulos A3
	left join ArticulosFamilias AF on A3.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join EstructurasArticulos LDM on A3.ART_ArticuloId = LDM.EAR_ART_ArticuloPadreId
	left join ArticulosTipos AT on A3.ART_ATP_TipoId = AT.ATP_TipoId 
	left join ArticulosCategorias AC on A3.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
	left join ControlesMaestrosMultiples AG on A3.ART_AgrupadorId = AG.CMM_ControllId 
	where AF.AFAM_Nombre like 'PT%' and  A3.ART_Activo  <> 0 
	group by A3.ART_CodigoArticulo, A3.ART_Nombre,  AT.ATP_Descripcion, AF.AFAM_Nombre, AC.ACAT_Nombre, AG.CMM_Valor 
	order by A3.ART_Nombre
