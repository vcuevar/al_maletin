-- Reportes de Excepciones
-- Desarrollo Ing. Vicente Cueva Ramirez.
-- Inicio: 13 de Octubre del 2017
-- Modificacion: 09 de Diciembre del 2017


-- Validar que los sub ensambles tengan lista de partes.
-- Validar que los sub ensambles no cuenten con otro sub ensamble.

--anidar sub ensambles en macro de LDM

--Que los Sub Ensambles cuenten con Lista de Materiales.
Select	ART_CodigoArticulo,
		ART_Nombre, 		
		(Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = ART_ATP_TipoId ) AS TIP_MAT,
		EAR_ART_ComponenteId AS REG		 
From Articulos
Left Join EstructurasArticulos on ART_ArticuloId = EAR_ART_ArticuloPadreId
Where (ART_ATP_TipoId = '56B66D49-FE82-4414-A7E8-43F3916572D3'
or ART_ATP_TipoId = 'EF2269C7-EE46-433B-A4F5-69ADD76EC016')
AND EAR_ART_ComponenteId is null


-- Sub-Ensambles que tengan otro sub-ensamble.
Select	A3.ART_CodigoArticulo AS COD_PADR,
		A3.ART_Nombre AS NOM_PADR, 		
		(Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = A3.ART_ATP_TipoId ) AS TIP_PADR,
		
		A1.ART_CodigoArticulo AS COD_COMP,
		A1.ART_Nombre AS NOM_COMP,
		(Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = A1.ART_ATP_TipoId ) AS TIP_COMP
		
From EstructurasArticulos
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId
inner join Articulos A3 on EAR_ART_ArticuloPadreId = A3.ART_ArticuloId
Where (Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = A3.ART_ATP_TipoId ) Like 'Sub%'
AND (Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = A1.ART_ATP_TipoId ) Like 'Sub%'





SELECT * FROM EstructurasArticulos

-- Las Materias Primas deben tener Almacen de Entrada por Omision A-GRAL (Definido asi no usar A-INCO) 15/Nov/17 (Julio).
	Select	'007 ? ALMACEN DIF. A-GRAL' as REPORTE,
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
	ALI.ALM_CodigoAlmacen <> 'A-GRAL' and ALI.ALM_CodigoAlmacen <> 'A-METALMX'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre

-- Las Materias Primas deben tener Almacen de Salida por Omision A-WIP, LOC_01.1. Definido 15/Nov/17 Julio.
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
	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 and
	ALO.ALM_CodigoAlmacen <> 'A-WIP' and ALO.ALM_CodigoAlmacen <> 'A-METALMX'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
	
-- Producto Terminado deben tener Almacen de Salida por Omision A-TERM, Definido 15/NOV/17.
	Select	'039 ? ALMA. PT DIF. A-TERM' as REPORTE,
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
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 and
	ALO.ALM_CodigoAlmacen <> 'A-TERM'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
	
-- Maximos y Minimos deben estar capturados Materias Primas y no ser Especiales (15/NOVIEMBRE/2017) JULIO C.
	Select	'055 ? MP MAX. Y MIN. FALT' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO,
			A1.ART_Nombre as NOMBRE, 
			UM.CMUM_Nombre as UM_INV,
			A1.ART_CantMaximaOrden AS MAXIMO,
			A1.ART_CantMinimaOrden as MINIMO,
			SC.CMM_Valor as SUB_CAT
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	inner join Localidades LOO on A1.ART_LOC_LocPredSalidasId = LOO.LOC_LocalidadId 
	inner join Almacenes ALO on LOO.LOC_ALM_AlmacenId = ALO.ALM_AlmacenId
	left join ControlesMaestrosMultiples SC on A1.ART_SubCategoriaId = SC.CMM_ControllId
	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 
	and A1.ART_CantMaximaOrden = 1 AND A1.ART_SubCategoriaId = '77DE38CC-B6D6-46B9-9D6F-C6701DF8E0E2'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
	

-- Las Materias Primas deben tener tiempo de entrega por parte del proveedor o dias de abastecimiento.
	Select	'039 ? SIN TIEMPOS DE ENTREGA' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO,
			A1.ART_Nombre as NOMBRE, 
			UM.CMUM_Nombre as UM_INV,
			A1.ART_NoDiasAbastecimiento AS LEADTIME
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	inner join Localidades LOO on A1.ART_LOC_LocPredSalidasId = LOO.LOC_LocalidadId 
	inner join Almacenes ALO on LOO.LOC_ALM_AlmacenId = ALO.ALM_AlmacenId
	where AF.AFAM_Nombre NOT like 'PT%' and  A1.ART_Activo  <> 0 and
	--A1.ART_CodigoArticulo = '0998'
	A1.ART_NoDiasAbastecimiento = 1
	order by A1.ART_Nombre
	
	
-- Relación de Productos Terminados con Existencia y Sin Costo Estandar.
	Select	'091 ? PT SIN COSTO STANDAR' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO, 
			A1.ART_Nombre as NOMBRE, 
			AF.AFAM_Nombre as FAMILIA,  
			UM.CMUM_Nombre as UM_Inv, 
			A1.ART_CantidadAMano as EXISTENCIA,
			A1.ART_CostoMaterialEstandar as ESTANDAR  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 and 
	A1.ART_CantidadAMano > 0 and A1.ART_CostoMaterialEstandar < 0.001
	order by  a1.ART_CodigoArticulo, A1.ART_Nombre
	
-- Todos los Articulos que no son Consigancion deben tener Tipo de Costo "Estandar" Definido 09/Dic/17 Eduardo M.
	Select	'105 ? COSTO NO ESTANDAR' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO,
			A1.ART_Nombre as NOMBRE, 
			UM.CMUM_Nombre as UM_INV,
			CM.CMM_Valor as TIPO_COS,
			A1.ART_CostoMaterialEstandar as COS_EST,
			A1.ART_UltimoCostoPromedio as COS_PRO,
			A1.ART_UltimoCostoUltimo as COS_ULT
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join ControlesMaestrosMultiples CM on A1.ART_CMM_TipoCostoId = CM.CMM_ControllId and CM.CMM_Control = 'CMM_CDA_TiposCosto'
	where   A1.ART_Activo  <> 0
	and CM.CMM_Valor = 'Promedio'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
	
-- Relación de Productos Terminados con Punto de Reorden = 0
	Select	'122 ? PT CON PUNTO DE REORDEN' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO, 
			A1.ART_Nombre as NOMBRE, 
			AF.AFAM_Nombre as FAMILIA,  
			UM.CMUM_Nombre as UM_Inv, 
			A1.ART_CantidadAMano as EXISTENCIA,
			A1.ART_CostoMaterialEstandar as ESTANDAR,
			A1.ART_CantPuntoOrden as P_REORDEN
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 and 
	A1.ART_CantPuntoOrden > 0 
	order by  a1.ART_CodigoArticulo, A1.ART_Nombre
	
-- Producto Terminado deben tener Almacen de Entrada por Omision A-TERM, Definido 15/NOV/17.
	Select	'138 ? ALMA. PT DIF. A-TERM' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO,
			A1.ART_Nombre as NOMBRE, 
			UM.CMUM_Nombre as UM_INV,
			ALO.ALM_CodigoAlmacen as ALM_OU,
			LOO.LOC_CodigoLocalidad as LOC_OU
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	inner join Localidades LOO on A1.ART_LOC_LocPredEntradasId = LOO.LOC_LocalidadId 
	inner join Almacenes ALO on LOO.LOC_ALM_AlmacenId = ALO.ALM_AlmacenId
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 and
	ALO.ALM_CodigoAlmacen <> 'A-TERM'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre
	
-- Pendiente Hacer almacen de Salida PT A-TERM	
	
	
	
-- Relación de Materias Primas sin Imagenes
	Select	'154 ? MP SIN IMAGENES' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO, 
			A1.ART_Nombre as NOMBRE, 
			AF.AFAM_Nombre as FAMILIA,
			SC.CMM_Valor as SUB_CAT,  
			UM.CMUM_Nombre as UM_Inv, 
			A1.ART_Imagen as IMAGEN
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join ControlesMaestrosMultiples SC on A1.ART_SubCategoriaId = SC.CMM_ControllId
	where AF.AFAM_Nombre not like 'PT%' and  A1.ART_Activo  <> 0 and 
	--A1.ART_CodigoArticulo = '1904'
	A1.ART_Imagen = 'default.jpg' and SC.CMM_Valor = 'LINEA'
	order by  AF.AFAM_Nombre, A1.ART_Nombre

-- Relación de Productos Terminados sin Imagenes
	Select	'154 ? PP SIN IMAGENES' as REPORTE,
			A1.ART_CodigoArticulo as CODIGO, 
			A1.ART_Nombre as NOMBRE, 
			AF.AFAM_Nombre as FAMILIA,
			SC.CMM_Valor as SUB_CAT,  
			UM.CMUM_Nombre as UM_Inv, 
			A1.ART_Imagen as IMAGEN
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join ControlesMaestrosMultiples SC on A1.ART_SubCategoriaId = SC.CMM_ControllId
	where AF.AFAM_Nombre like 'PT%' and  A1.ART_Activo  <> 0 
	and   A1.ART_Imagen = 'default.jpg'  --A1.ART_Imagen is null and SC.CMM_Valor = 'LINEA'
	order by  AF.AFAM_Nombre, A1.ART_Nombre


-- Validar que todas las ordenes de Venta esten con Embarques Parciales.
Select OV_CodigoOV, OV_Comentarios, OV_EmbarqueParcial 
from OrdenesVenta
Where OV_EmbarqueParcial = 0 



--Validar que tengan codigo de servicios. Que no se use 01010101	
	


/*
--movimiento en tabla de MULIIX 19 de Mayo del 2018

select * from ControlesMaestrosMultiples
where CMM_Control = 'CMM_RH_TipoEmpleado' and CMM_ControlId ='590E9D38-6B1E-436B-9E90-FE0130E2A9ED'

--Estaba como Normal
update ControlesMaestrosMultiples set CMM_Valor = 'Base'
where CMM_Control = 'CMM_RH_TipoEmpleado' and CMM_ControlId ='590E9D38-6B1E-436B-9E90-FE0130E2A9ED'


CMM_ControlId	CMM_Control	CMM_Valor	CMM_ValorPredeterminado	CMM_FechaUltimaModificacion	CMM_EMP_ModificadoPor	CMM_Requerido	CMM_Etiqueta	CMM_Sistema	CMM_Eliminado	CMM_Referencia	CMM_DefinidoPorUsuario1	CMM_DefinidoPorUsuario2	CMM_DefinidoPorUsuario3	CMM_DefinidoPorUsuario4	CMM_DefinidoPorUsuario5
8BF95A46-DA94-4491-8925-F6CB1190DB13	CMM_RH_TipoEmpleado	A Prueba	0	2015-06-29 13:55:35.100	NULL	0	NULL	0	0	NULL	NULL	NULL	NULL	NULL	NULL
590E9D38-6B1E-436B-9E90-FE0130E2A9ED	CMM_RH_TipoEmpleado	Base	0	2015-06-29 13:55:35.100	NULL	0	NULL	0	0	NULL	NULL	NULL	NULL	NULL	NULL
44DFE131-EC6F-4184-93B3-639D268D4496	CMM_RH_TipoEmpleado	Capacitación Inicial	0	2015-06-29 13:55:35.100	NULL	0	NULL	0	0	NULL	NULL	NULL	NULL	NULL	NULL
0AFC4627-25A9-4DC8-80FD-1CA15A6223F5	CMM_RH_TipoEmpleado	Eventual	0	2015-06-29 13:55:35.100	NULL	0	NULL	0	0	NULL	NULL	NULL	NULL	NULL	NULL
D7BCB040-B221-4B31-86FC-3FB3A6F7C6A8	CMM_RH_TipoEmpleado	Foráneo	0	2015-06-29 13:55:35.100	NULL	0	NULL	0	0	NULL	NULL	NULL	NULL	NULL	NULL
3A3D9CC6-4D67-4FE5-BB29-ED5ECB33ABF2	CMM_RH_TipoEmpleado	Permanente	0	2015-06-29 13:55:35.100	NULL	0	NULL	0	0	NULL	NULL	NULL	NULL	NULL	NULL

--Eliminar el de Permanente

select * from ControlesMaestrosMultiples
where CMM_Control = 'CMM_RH_TipoEmpleado' and CMM_ControlId ='3A3D9CC6-4D67-4FE5-BB29-ED5ECB33ABF2'


delete from ControlesMaestrosMultiples
where CMM_Control = 'CMM_RH_TipoEmpleado' and CMM_ControlId ='3A3D9CC6-4D67-4FE5-BB29-ED5ECB33ABF2'

--Tabla donde vienen las sucursales
	select * from Departamentos
	where DEP_DeptoId = '2EC25E28-47DE-57C1-4407-70D3DCA7AF70'

update Departamentos set DEP_Nombre = 'ITEKNIA PLANTE GDL'
where DEP_DeptoId = '2EC25E28-47DE-57C1-4407-70D3DCA7AF70'


update Departamentos set DEP_Nombre = 'ITEKNIA VALLARTA'
where DEP_DeptoId = '9911E73B-1223-CD6D-4A2C-260B797438AD'

*/
