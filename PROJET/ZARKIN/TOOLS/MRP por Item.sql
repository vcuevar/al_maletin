-- Consulta para ver el detalle de un material calculado en el MRP
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 16 de febrero del 2024; Origen.

Select BO.OP AS OP
	, BO.Pedido AS PEDIDO
	, BO.CODIGO AS CODE
	, BO.Descripcion AS MUEBLE
	, BO.Cant AS CANTIDAD
	, BO.VS AS VALOR
	, BO.SEMANA3 AS SEMANA
	, Isnull(BO.prefunda, BO.U_Starus) AS ESTATUS
	, WOR1.ItemCode AS CODIGO
	, WOR1.ItemName AS MATERIAL
	, ITT1.Quantity AS LDM
	, WOR1.PlannedQty AS PLANEADO
	, WOR1.IssuedQty AS CONSUMIDO
	, WOR1.IssuedQty - ITT1.Quantity AS FALTANTE
From SIZ_View_ReporteBO BO
Inner Join WOR1 on BO.OP = WOR1.DocEntry
Inner Join ITT1 on BO.CODIGO  = ITT1.Father and  WOR1.ItemCode = ITT1.Code
Where WOR1.ItemCode = '19600'
Order By BO.SEMANA3

--Select top(10) * from ITT1

--select * from SIZ_View_ReporteBO









