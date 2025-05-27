
Select * 
from Articulos
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
and ART_SeguimientoLotMult = 0

Update Articulos set ART_SeguimientoLotMult = 1
from Articulos
left join ArticulosTipos on ART_ATP_TipoId = ATP_TipoId 
where ART_Activo = 1 and ART_Eliminado = 0
and ATP_Descripcion = 'Materia prima'
and ART_SeguimientoLotMult = 0



and ART_CrearLocAlmacenaje = 0
and ART_SeguimientoLocMult = 0
and ART_PermitirCambioAlmacen = 0
and ART_OcultarLocsCantCero = 0
				
1	1	1	1	1

Select * from LocalidadesArticulo


Select * from LotesLocalidades
where LOTL_LOT_LoteId = '8820AA76-3476-4646-9951-9DF3B6F61FE0'


LOT_LoteId


Select * from Lotes
where LOT_CodigoLote = '70003621709A'

Select top(10) * from Articulos



E6FD8AA4-62FA-4B67-BCCE-D549C9E3BABF





