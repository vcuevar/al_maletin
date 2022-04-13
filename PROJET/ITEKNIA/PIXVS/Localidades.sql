


select ALI.ALM_CodigoAlmacen, ALI.ALM_Nombre, LO.LOC_CodigoLocalidad, LO.LOC_Nombre 
from Localidades LO
inner join Almacenes ALI on LO.LOC_ALM_AlmacenId = ALI.ALM_AlmacenId
where ALI.ALM_CodigoAlmacen = 'A-WIP' and LO.LOC_Borrado = 0 and LO.LOC_LocalidadGeneral = 0
order by LO.LOC_CodigoLocalidad

select * from Localidades where Localidades.LOC_CodigoLocalidad = 'A-GRAL-LOC-00'


select * from Localidades where LOC_ALM_AlmacenId = 'FC79320E-5440-4C05-ADE4-3F63803FA596' and 
LOC_Borrado = 0

Select	'007 ' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO,
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
	ALI.ALM_CodigoAlmacen ='A-GRAL' and LOI.LOC_CodigoLocalidad <> 'LOC_01.1'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre	
	
	
	
	Select	'023 ? ALMACEN DIF. A-WIP' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO,
			A1.ART_Nombre as NOMBRE, 
			UM.CMUM_Nombre as UM_INV,
			ALO.ALM_CodigoAlmacen as ALM_OU,
			LOO.LOC_CodigoLocalidad as LOC_OU
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	inner join Localidades LOO on A1.ART_LOC_LocPredSalidasId = LOO.LOC_LocalidadId 
	inner join Almacenes ALO on LOO.LOC_ALM_AlmacenId = ALO.ALM_AlmacenId
	where --AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 and
	--ALO.ALM_CodigoAlmacen ='A-GRAL' and 
	LOO.LOC_CodigoLocalidad = 'LOC 08.1'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
	
	-- Cambiar almacen en Articulos para borrar ubicaciones.
select * 
from Articulos A1
inner join Localidades LO on A1.ART_LOC_LocPredSalidasId = lo.LOC_LocalidadId 
where lo.LOC_CodigoLocalidad = 'LOC_06.1'

select * 
from Articulos A1
inner join Localidades LO on A1.ART_LOC_LocPredEntradasId = lo.LOC_LocalidadId 
where lo.LOC_CodigoLocalidad = 'LOC_07.2'



	SELECT *
	FROM Localidades
	--where LOC_CodigoLocalidad like '%LOC_14%'
	where LOC_Borrado = 0 and LOC_ALM_AlmacenId = 'F0651CB9-D507-4826-94FE-CBE4E7FD2087'
	--where LOC_LocalidadId = 'F75AF9DD-5C5E-4755-8BDE-239A1AC3566F'   AD5A5CE2-2D6D-4A3F-BECC-596D43046784
	order by LOC_CodigoLocalidad 

		Update Localidades set LOC_Borrado = 0
		where LOC_LocalidadId = 'AA5177FE-5F35-40EB-90C9-AB2F5DEAD2E5'
		

