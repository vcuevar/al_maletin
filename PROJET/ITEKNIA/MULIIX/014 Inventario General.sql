-- Consulta para obtener Inventarios Generales de Planta


Select	AL.ALM_CodigoAlmacen as ALMACEN, 
        LOC_CodigoLocalidad as LOCALIDAD, 
        LOC_Nombre as NOM_LOCAL, 
        --AF.AFAM_Nombre as FAMILIA, 
        AC.ACAT_Nombre as CATEGORIA, 
        --AT.ATP_Descripcion as TIPO, 
        --'CLA_VE' as CLAVE, 
        ART_CodigoArticulo as CODIGO, 
        ART_Nombre as NOMBRE, 
        UM.CMUM_Nombre as UM_Inv, 
        Convert(Decimal(28,4),LOCA_Cantidad) as EXISTE, 
        Convert(Decimal(28,4), ART_Precio) as COSTO 
from LocalidadesArticulo 
inner join Articulos on ART_ArticuloId = LOCA_ART_ArticuloId 
inner join ControlesMaestrosUM UM on ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId 
Inner join Localidades on LOCA_LOC_LocalidadId = LOC_LocalidadId 
Inner join Almacenes AL on LOC_ALM_AlmacenId = AL.ALM_AlmacenId 
left join ArticulosFamilias AF on ART_AFAM_FamiliaId = AF.AFAM_FamiliaId
left join ArticulosCategorias AC on ART_ACAT_CategoriaId= AC.ACAT_CategoriaId 
left join ArticulosTipos AT on ART_ATP_TipoId = AT.ATP_TipoId 
Where LOCA_Cantidad > 0 
Order By LOC_Nombre, AC.ACAT_Nombre, ART_Nombre 