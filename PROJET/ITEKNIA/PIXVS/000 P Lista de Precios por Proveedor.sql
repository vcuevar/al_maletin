-- Consulta para --- Lista de Precios por Proveedor.
-- Objetivo: Presentar Relacion de Articulos que no son PT.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 21 de Abril del 2018; Origen
-- Actualizado: Sabado 03 de Noviembre del 2018; Cambio a MULIIX

-- DESARROLLO DE LA CONSULTA.

--registros 1975
Select	PRO_CodigoProveedor AS CODPROV, 
		PRO_Nombre AS NOMBPROV,
		ART_CodigoArticulo AS CODARTI, 
		ART_Nombre AS NOMBARTI, 
		(Select CMUM_Nombre from ControlesMaestrosUM 
		where ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId) AS UDM,
		LPC_PlazoEntrega AS PLAENTR,
		LPC_PorcReparto AS PORREPA,
		LPC_PrecioCompra AS PRECOMP,
		(Select MON_Nombre from Monedas
		Where LPC_MON_MonedaId = MON_MonedaId ) AS MONEDA,
		(Select CMIVA_Descripcion from ControlesMaestrosIVA
		Where LPC_CMIVA_CodigoId = CMIVA_CodigoId) AS IVA
from ListaPreciosCompra
Inner join Proveedores on LPC_PRO_ProveedorId = PRO_ProveedorId
inner join Articulos on LPC_ART_ArticuloId = ART_ArticuloId
Order By NOMBPROV, NOMBARTI 
