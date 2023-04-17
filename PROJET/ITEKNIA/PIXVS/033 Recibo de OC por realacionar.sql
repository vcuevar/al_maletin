--  032 Recibo de Ordenes de Compra por Relacionar.
--  OBJETIVO: Tener una relacion de todas las compras que no se han relacionada a una Factura.
--  Desarrollo: Ing. Vicente Cueva R.
--  Actualizado: Viernes 29 de marzo del 2019; Origen.

--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)

Set @FechaIS = '2019-03-25'
Set @FechaFS = '2019-03-29'
 
-- Consulta

-- Orden Compra
-- Moneda
-- Articulo
-- Factura
-- Fecha Requisicion
-- Cantidad Requerida
-- Recibido
-- Relacionado
-- Cantidad por Relacionar
-- Fecha OC


Select	OC_CodigoOC as ORDEN, 
		OCRC_FechaRecibo AS F_RECIBO,
		OCRC_FechaRequerida AS F_REQUERIDA,
		OCRC_CantidadRecibo AS C_RECIBIDA,


		OrdenesCompraRecibos.*

		
		
from OrdenesCompraRecibos 
inner join OrdenesCompra on OCRC_OC_OrdenCompraId = OC_OrdenCompraId 
and Cast(OCRC_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 



