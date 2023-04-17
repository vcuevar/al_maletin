
-- Resumen de Registros
Select COUNT(LOCA_Cantidad) as Num_Registro from LocalidadesArticulo EX
Where EX.LOCA_Cantidad > 0

--Consulta para inventario por Localidades.

Select	AL.ALM_CodigoAlmacen as ALMACEN,
		LO.LOC_CodigoLocalidad as LOCALIDAD,
		LO.LOC_Nombre as NOM_LOCAL,
		AF.AFAM_Nombre as FAMILIA,
		AC.ACAT_Nombre as CATEGORIA,
		AT.ATP_Descripcion as TIPO,
		'CLA_VE' as CLAVE,
		A1.ART_CodigoArticulo as CODIGO,
		A1.ART_Nombre as NOMBRE,
		UM.CMUM_Nombre as UM_Inv,
		EX.LOCA_Cantidad as EXISTE,
		CM.CMM_Valor as TIPO_COS,
		A1.ART_CostoMaterialEstandar as COS_EST,
		A1.ART_UltimoCostoPromedio as COS_PRO,
		A1.ART_UltimoCostoUltimo as COS_ULT	
from LocalidadesArticulo EX
inner join Articulos A1 on A1.ART_ArticuloId = EX.LOCA_ART_ArticuloId
inner join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
Inner join Localidades LO on EX.LOCA_LOC_LocalidadId = LO.LOC_LocalidadId
Inner join Almacenes AL on LO.LOC_ALM_AlmacenId = AL.ALM_AlmacenId
left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
left join ArticulosCategorias AC on A1.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
left join ArticulosTipos AT on A1.ART_ATP_TipoId = AT.ATP_TipoId 
left join ControlesMaestrosMultiples CM on A1.ART_CMM_TipoCostoId = CM.CMM_ControllId and CM.CMM_Control = 'CMM_CDA_TiposCosto'
Where EX.LOCA_Cantidad > 0 
Order By Al.ALM_CodigoAlmacen, LO.LOC_CodigoLocalidad, A1.ART_Nombre


--select ART_CMM_TipoCostoId, * from Articulos
--where Articulos.ART_CodigoArticulo = '0100'

-- Tipo Estandar FBFD42DD-413D-4504-A370-FFC5DB4614A9
-- Tipo Promedio 0FA4FF4C-538C-4FDF-B77C-F0F034B67440
-- Tipo U.Compra 2D9FD4EC-3C77-4E44-B001-5058891A71F3



--select * from ControlesMaestrosMultiples where CMM_Control like '%Costo%'