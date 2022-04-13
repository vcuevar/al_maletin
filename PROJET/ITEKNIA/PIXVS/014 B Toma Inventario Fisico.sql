-- Reporte: 014-B Reporte para Toma de Inventario Fisico, Por Almacen y Localidad.
-- Objetivo: Sacar formato del Inventario para la toma fisica y presentar
-- reporte de diferencias para solicitar ajuste.
-- Desarrollo: Ing. Vicente Cueva R.
-- Actualizado: Sabado 09 de Febrero del 2019; Origen.

--Delcaraciones:
Declare @xAlmaCode nvarchar(30)
Declare @xAlmaId uniqueidentifier
Declare @xLocalidad nvarchar(30)
Declare @xLocaId uniqueidentifier

Set @xAlmaCode = 'A-LACA'
Set @xAlmaId = '7E37E177-0ADA-4CFA-B81C-209902CA3DB9'
Set @xLocalidad = 'LOC_40.1' 
Set @xLocaId = 'FF130591-5635-4318-A609-3C446549741B'

/*
--Consulta para Seleccionar Almacen del Listado.
Select	ALM_AlmacenId AS ID_ALMA,
		ALM_CodigoAlmacen AS COD_ALMA,
		ALM_Nombre AS NOMB_ALMA
from Almacenes
Where ALM_Borrado = 0 AND ALM_CodigoAlmacen <> 'ALMGRAL'
AND ALM_CodigoAlmacen <> '001'
Order By NOMB_ALMA

--Consulta obtener información del Almacen.
Select	ALM_AlmacenId AS ID_ALMA,
		ALM_CodigoAlmacen AS COD_ALMA,
		ALM_Nombre AS NOMB_ALMA
from Almacenes
Where ALM_CodigoAlmacen = @xAlmaCode


--Consulta para Seleccionar Localidad del listado del Almacen.
Select	LOC_LocalidadId,
		LOC_CodigoLocalidad, 
		LOC_Nombre
from Localidades
Where LOC_Borrado = 0 and LOC_ALM_AlmacenId = @xAlmaId 
and LOC_Nombre Not Like '%Genera%'

--Consulta para Seleccionar Localidad por Codigo y Almacen.
Select	LOC_LocalidadId AS ID_LOCA,
		LOC_CodigoLocalidad AS COD_LOCA, 
		LOC_Nombre AS NOMB_LOCA
from Localidades
Where LOC_CodigoLocalidad = @xLocalidad and LOC_ALM_AlmacenId = @xAlmaId 
*/
--Consulta para Imprimir Reporte
 Select	AFAM_Nombre as FAMILIA,	
		ART_CodigoArticulo as CODIGO, 
		ART_Nombre as NOMBRE, 
		UM.CMUM_Nombre as UM_Inv, 
		Convert(Decimal(28,5),LOCA_Cantidad) as EXISTE
from LocalidadesArticulo  
inner join Articulos on ART_ArticuloId = LOCA_ART_ArticuloId
inner join ControlesMaestrosUM UM on ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId 
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
Where LOCA_Cantidad <> 0 and LOCA_LOC_LocalidadId = @xLocaId
Order By FAMILIA, ART_Nombre


 /*
 --Consulta para calcular Diferencias
 Select  AL.ALM_CodigoAlmacen as ALMACEN, LO.LOC_CodigoLocalidad as LOCALIDAD, LO.LOC_Nombre as NOM_LOCAL, A1.ART_CodigoArticulo as CODIGO, A1.ART_Nombre as NOMBRE, UM.CMUM_Nombre as UM_Inv, EX.LOCA_Cantidad as EXISTE, CM.CMM_Valor as TIPO_COS,
  Convert(Decimal(28,10), A1.ART_CostoMaterialEstandar) as COS_EST, A1.ART_UltimoCostoPromedio as COS_PRO, A1.ART_UltimoCostoUltimo as COS_ULT, AF.AFAM_Nombre as FAMILIA, AC.ACAT_Nombre as CATEGORIA, AT.ATP_Descripcion as TIPO from LocalidadesArticulo EX inner join Articulos A1 on A1.ART_ArticuloId = EX.LOCA_ART_ArticuloId inner join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId Inner join Localidades LO on EX.LOCA_LOC_LocalidadId = LO.LOC_LocalidadId Inner join Almacenes AL on LO.LOC_ALM_AlmacenId = AL.ALM_AlmacenId left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId left join ArticulosCategorias AC on A1.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId 
 left join ArticulosTipos AT on A1.ART_ATP_TipoId = AT.ATP_TipoId left join ControlesMaestrosMultiples CM on A1.ART_CMM_TipoCostoId = CM.CMM_ControllId and CM.CMM_Control = 'CMM_CDA_TiposCosto' Where EX.LOCA_Cantidad <> 0 Order By Al.ALM_CodigoAlmacen, LO.LOC_CodigoLocalidad, A1.ART_Nombre
 */