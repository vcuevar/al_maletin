--  Consulta para obtener Articulos que no tienen lista de precios.
-- Elaborado: Ing. Vicente Cueva R.
-- Actualizado: Martes 23 de Julio del 2019; Inicio.


Select	ART_CodigoArticulo as CODIGO,
		ART_Nombre as MATERIAL,

		ISNULL((Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = (
		Select top 1 LPC_CMUM_UnidadMedidaId from ListaPreciosCompra
		Where LPC_ART_ArticuloId = ART_ArticuloId)), 'SIN UM_LC') as UM_LC,
		
		(Select top 1 LPC_PrecioCompra from ListaPreciosCompra
		Where LPC_ART_ArticuloId = ART_ArticuloId) as COSTO,

		(Select MON_Nombre from Monedas Where  MON_MonedaId = (
		Select top 1 LPC_MON_MonedaId from ListaPreciosCompra
		Where LPC_ART_ArticuloId = ART_ArticuloId)) as MONEDA,
		
		ISNULL((Select PRO_Nombre from Proveedores Where  PRO_ProveedorId = (
		Select top 1 LPC_PRO_ProveedorId from ListaPreciosCompra
		Where LPC_ART_ArticuloId = ART_ArticuloId)), 'FALTA COSTO') as PROVEEDOR
from Articulos
Where ART_Eliminado = 0 and ART_Activo = 1
and ART_ATP_TipoId = '8418208F-EC34-41E8-9802-83B4404764DA'




--Select * from Articulos
--Select * from ListaPreciosCompra
--select * from ControlesMaestrosUM
--select * from ArticulosCategorias
--select * from ArticulosTipos


		select * from ListaPreciosCompra
		where LPC_FechaVigencia is null
		order by LPC_FechaVigencia
