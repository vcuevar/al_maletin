-- Consulta para posibles rompimientos Dinamica por Deptos.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Sabado 05 de Junio del 2021; Origen.

-- Status de la Ordenes de Produccion (OWOR.Status).
--		P	Planificadas
--		R	Liberadas
--		L	Cerrada
--		C	Cancelada

-- Articulos Inventariables (A1.InvntItem = 'Y').
-- Material surtido por notificacion (WOR1.IssueType = 'B'). 

-- Variables: Estacion Inicial, Estacion Final.
DECLARE @EstIni varchar(10)
DECLARE @EstFin varchar(10)

Set @EstIni = '151'
Set @EstFin = '175'

Select	ROMPE.CODIGO
		, ROMPE.MATERIAL
		, ROMPE.UDM
		, ROMPE.ALMACEN
		, ROMPE.WIP_STOCK
		, ROMPE.WIP_STOCK - (SUM(ROMPE.PLANEADO) - SUM(ROMPE.CONSUMIDO)) AS NECESIDAD
		, ROMPE.PRECIO
		, (ROMPE.WIP_STOCK - (SUM(ROMPE.PLANEADO) - SUM(ROMPE.CONSUMIDO))) * ROMPE.PRECIO AS IMPORTE
		, ROMPE.CUENTA 
from (
Select	ISNULL(RT.Name, '000 Orden Planificada') AS ESTACION
		, WOR1.DocEntry AS OP
		, OWOR.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, WOR1.ItemCode AS CODIGO
		, A1.ItemName AS MATERIAL
		, A1.InvntryUom as UDM
		, E3.WhsCode AS ALMACEN
		, E3.OnHand as WIP_STOCK
		, WOR1.PlannedQty AS PLANEADO
		, WOR1.IssuedQty AS CONSUMIDO
		, ITM1.Price AS PRECIO
		, '501-200-000' AS CUENTA
From WOR1 
Inner Join OITM A1 on WOR1.ItemCode=A1.ItemCode 
Inner Join OITW E3 on A1.ItemCode=E3.ItemCode and E3.WhsCode='APG-ST' 
Inner Join ITM1 on A1.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Inner Join OWOR on  WOR1.DocEntry = OWOR.DocEntry
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode 

Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
where CP.U_CT BETWEEN @EstIni and @EstFin and A1.InvntItem = 'Y' and WOR1.IssueType = 'B' and OWOR.Status = 'R'
) ROMPE 
Group By ROMPE.CODIGO, ROMPE.MATERIAL, ROMPE.UDM, ROMPE.ALMACEN, ROMPE.WIP_STOCK, 
ROMPE.PRECIO, ROMPE.CUENTA 
Having (ROMPE.WIP_STOCK - (SUM(ROMPE.PLANEADO) - SUM(ROMPE.CONSUMIDO))) < 0
Order By ROMPE.MATERIAL


-- Detalle de las Ordenes en el area.

Select	ISNULL(RT.Name, '000 Orden Planificada') AS ESTACION
		, WOR1.DocEntry AS OP
		, OWOR.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, WOR1.ItemCode AS CODIGO
		, A1.ItemName AS MATERIAL
		, A1.InvntryUom as UDM
		, E3.WhsCode AS ALMACEN
		, E3.OnHand as WIP_STOCK
		, WOR1.PlannedQty AS PLANEADO
		, WOR1.IssuedQty AS CONSUMIDO
		, ITM1.Price AS PRECIO
		, '501-200-000' AS CUENTA
From WOR1 
Inner Join OITM A1 on WOR1.ItemCode=A1.ItemCode 
Inner Join OITW E3 on A1.ItemCode=E3.ItemCode and E3.WhsCode='APG-ST' 
Inner Join ITM1 on A1.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Inner Join OWOR on  WOR1.DocEntry = OWOR.DocEntry
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
where CP.U_CT BETWEEN @EstIni and @EstFin and A1.InvntItem = 'Y' and WOR1.IssueType = 'B' and OWOR.Status = 'R'
Order By ESTACION, OP, MATERIAL





--Select * from [@PL_RUTAS]

