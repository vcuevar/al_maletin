

-- Para requerir el material se compara con el punto de reorden y las existencia de los almacenes de Materia 
-- Prima y WIP que son de Almacen.

Select	--AL.ALM_CodigoAlmacen as ALMACEN, 
        --LOC_CodigoLocalidad as LOCALIDAD, 
        --LOC_Nombre as NOM_LOCAL, 
        --AF.AFAM_Nombre as FAMILIA, 
        --AC.ACAT_Nombre as CATEGORIA, 
        AT.ATP_Descripcion as TIPO, 
        --'CLA_VE' as CLAVE, 
        ART_CodigoArticulo as CODIGO, 
        ART_Nombre as NOMBRE, 
        UM.CMUM_Nombre as UM_Inv, 
        Convert(Decimal(28,4),LOCA_Cantidad) as EXISTE, 
        Convert(Decimal(28,4),ART_CantMinimaOrden) as MINIMO, 
        Convert(Decimal(28,4),ART_CantPuntoOrden) as P_REORDEN, 
        Convert(Decimal(28,4),ART_CantMaximaOrden) as MAXIMO
        , Convert(Decimal(28,2), ART_NoDiasAbastecimiento) AS DIA_ABS
        
       -- Convert(Decimal(28,4), ART_Precio) as COSTO 
       ,  Articulos.*
from LocalidadesArticulo 
inner join Articulos on ART_ArticuloId = LOCA_ART_ArticuloId 
inner join ControlesMaestrosUM UM on ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId 
Inner join Localidades on LOCA_LOC_LocalidadId = LOC_LocalidadId 
Inner join Almacenes AL on LOC_ALM_AlmacenId = AL.ALM_AlmacenId 
left join ArticulosFamilias AF on ART_AFAM_FamiliaId = AF.AFAM_FamiliaId
left join ArticulosCategorias AC on ART_ACAT_CategoriaId= AC.ACAT_CategoriaId 
left join ArticulosTipos AT on ART_ATP_TipoId = AT.ATP_TipoId 

Where --LOC_Nombre = '1 ALMACEN MATERIAS PRIMAS' 
--and   LOCA_Cantidad <=  ART_CantPuntoOrden
--ART_CantPuntoOrden > 0
--and AT.ATP_Descripcion = 'Materia prima'
--and ART_CMM_SubcategoriaId <> 'BBB10439-9178-456C-9530-3C7AD574E84C'

 ART_CodigoArticulo = '01457'
Order By ART_Nombre 




/*
Select * from ControlesMaestrosMultiples Where CMM_Control like '%articu%'

CMM_CCXP_TipoRegistroCXPCMM_ControlId = 'F4C2C87A-EDB3-4A2B-B70E-F683A81FDFB4'

*/