-- Catalogo de Articulos.
-- MATERIAS PRIMAS.

/*
	use iteknia
	Select COUNT(A1.ART_CodigoArticulo) AS MAT_PRIMAS
	Select *
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 and A1.ART_CodigoArticulo = '0005'
*/

	--select * from ControlesMaestrosMultiples
	--where CMM_ControllId =    '5AD70E1B-E5F2-4CDA-8A49-0A6CA28A1498'

	--Select * from Controles
	--where CMA_Control like '%Espec%'

	Select A1.ART_CodigoArticulo as CODIGO,
	 A1.ART_Nombre as NOMBRE,
	  AF.AFAM_Nombre as FAMILIA,
	   AC.ACAT_Nombre as CATEGORIA,
	   SC.CMM_Valor as SUB_CAT,
	AT.ATP_Descripcion as TIPO,
	 UM.CMUM_Nombre as UM_Inv,
	  A1.ART_Activo ACTIVO_1,
	   IV.CMIVA_Descripcion as IVA,
	A1.ART_PermitirCambioAlmacen as CAMBIOS_ALMACEN,
	 A1.ART_SeguimientoLocMult as LOCAL_MULT,
	  A1.ART_CrearLocAlmacenaje as CREA_LOCAL,
	A1.ART_OcultarLocsCantCero as OCULTA_CEROS,
	A1.ART_InspeccionOC as INSPECCION_OC, A1.ART_InspeccionOT as INSPECCION_OT, 
	A1.ART_CMM_TipoCostoId, A1.ART_CostoMaterialEstandar as ESTANDAR, A1.ART_UltimaModificacionCostoPromedio as PROMEDIO, a1.ART_UltimoCostoUltimo as U_COMPRA,
	A1.ART_FechaCreacion,
	(EM.EMP_Nombre + ' ' + EM.EMP_PrimerApellido) as MODIFICADO  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ArticulosCategorias AC on A1.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
	left join ArticulosTipos AT on A1.ART_ATP_TipoId = AT.ATP_TipoId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join Empleados EM on A1.ART_EMP_ModificadoPor = EM.EMP_EmpleadoId 
	left join ControlesMaestrosIVA IV on A1.ART_CMM_IVAPredeterminadoId = IV.CMIVA_CodigoId
	left join ControlesMaestrosMultiples SC on A1.ART_SubCategoriaId = SC.CMM_ControllId
	where A1.ART_CodigoArticulo = '4712.2-15'
	--AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 
	-- and ART_CMM_IVAPredeterminadoId <> 1
	-- and ART_CMM_IVAPredeterminadoId is null
	-- and A1.ART_SeguimientoLocMult <> 1
	-- and A1.ART_CrearLocAlmacenaje <> 1
	-- and A1.ART_OcultarLocsCantCero <> 1
	-- and ART_InspeccionOC <> 1
	-- and A1.ART_InspeccionOC <> 1
	-- and AT.ATP_Descripcion <> 'Materia prima'
	
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
 

 /*
-- completar validacion de almacenes y luego la de costos

Select	A1.ART_CodigoArticulo as CODIGO,
		A1.ART_Nombre as NOMBRE
from Articulos A1
left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0
order by  A1.ART_FechaCreacion, A1.ART_Nombre



-- Validacion de Almacen de Entrada y Salidas
Select	A1.ART_CodigoArticulo as CODIGO,
		A1.ART_Nombre as NOMBRE, 
		UM.CMUM_Nombre as UM_INV,
		ALI.ALM_CodigoAlmacen as ALM_IN,
		LOI.LOC_CodigoLocalidad as LOC_IN
from Articulos A1
left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
inner join Localidades LOI on A1.ART_LOC_LocPredEntradasId = LOI.LOC_LocalidadId 
inner join Almacenes ALI on LOI.LOC_ALM_AlmacenId = ALI.ALM_AlmacenId
where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 and
ALI.ALM_CodigoAlmacen <> 'A-GRAL'
order by  A1.ART_FechaCreacion, A1.ART_Nombre


/*
Para Borrar almacenes despues de que no este en ningun articulo...
select * from Almacenes
where ALM_AlmacenId = '283005D2-C1FD-4E33-BF43-418075A8AACF'

update Almacenes set ALM_Borrado = 1
where ALM_AlmacenId = '283005D2-C1FD-4E33-BF43-418075A8AACF'
*/




	Select * from Articulos A1 left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 and A1.ART_CodigoArticulo = '0005'

select * from LocalidadesArticulo
select * from Localidades
select * from Almacenes



/*
-- Articulos de PT y Sub-Productos
	Select A1.ART_CodigoArticulo as CODIGO, A1.ART_Nombre as NOMBRE, AF.AFAM_Nombre as FAMILIA, AC.ACAT_Nombre as CATEGORIA,
	AT.ATP_Descripcion as TIPO, UM.CMUM_Nombre as UM_Inv, A1.ART_Activo ACTIVO_1, IV.CMIVA_Descripcion as IVA,
	A1.ART_PermitirCambioAlmacen as CAMBIOS_ALMACEN, A1.ART_SeguimientoLocMult as LOCAL_MULT, A1.ART_CrearLocAlmacenaje as CREA_LOCAL,
	A1.ART_OcultarLocsCantCero as OCULTA_CEROS,
	A1.ART_InspeccionOC as INSPECCION_OC, A1.ART_InspeccionOT as INSPECCION_OT, 
	--A1.ART_CMM_TipoCostoId,
	A1.ART_FechaCreacion,
	(EM.EMP_Nombre + ' ' + EM.EMP_PrimerApellido) as MODIFICADO  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ArticulosCategorias AC on A1.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
	left join ArticulosTipos AT on A1.ART_ATP_TipoId = AT.ATP_TipoId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join Empleados EM on A1.ART_EMP_ModificadoPor = EM.EMP_EmpleadoId 
	left join ControlesMaestrosIVA IV on A1.ART_CMM_IVAPredeterminadoId = IV.CMIVA_CodigoId
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 
	-- and ART_CMM_IVAPredeterminadoId <> 1
	-- and ART_CMM_IVAPredeterminadoId is null
	-- and A1.ART_SeguimientoLocMult <> 1
	-- and A1.ART_CrearLocAlmacenaje <> 1
	 and A1.ART_OcultarLocsCantCero <> 1
	-- and ART_InspeccionOC = 0
	-- and AT.ATP_Descripcion <> 'Materia prima'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
 */
 
 /*
 
	Select A3.ART_CodigoArticulo as CODIGO, A3.ART_Nombre as NOMBRE, AF.AFAM_Nombre as FAMILIA,
	COUNT(LDM.EAR_CantidadEnsamble) as LDM
	from Articulos A3
	left join ArticulosFamilias AF on A3.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join EstructurasArticulos LDM on A3.ART_ArticuloId = LDM.EAR_ART_ArticuloPadreId
	where AF.AFAM_Nombre like 'PT%' and  A3.ART_Activo  <> 0  --and a3.ART_CodigoArticulo = '3840.1-11'
	group by A3.ART_CodigoArticulo, A3.ART_Nombre, AF.AFAM_Nombre 
	order by A3.ART_Nombre
	
	 
	 Select * from EstructurasArticulos
	
	
*/
*/
