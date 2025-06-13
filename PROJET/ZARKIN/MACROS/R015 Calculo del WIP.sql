-- Nombre: 015 Calculo del WIP.
-- Uso: Calcular el Importe que se tendria en WIP si todas las OP en proceso tubieran todos los materiales.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 05 de junio del 2025; Mejoras.

/* ------------------------------------------------------------------------------------------------
|  Para Calcular el Valor Sala en Proceso.                                                         |
--------------------------------------------------------------------------------------------------*/

Select SUM(A3.U_VS) AS TVS
from OWOR 
inner join OITM A3 on A3.ItemCode = OWOR.ItemCode 
Where OWOR.Status ='R' and OWOR.CmpltQty < OWOR.PlannedQty 
and OWOR.U_Starus = '06' 
and A3.U_TipoMat = 'PT' 

/* ------------------------------------------------------------------------------------------------
|  Para Calcular los materiales para el WIP.                                                       |
--------------------------------------------------------------------------------------------------*/

Select WIP.CODIGO
	, WIP.MATERIAL AS DESCRIPCION
	, WIP.UDM
	, SUM(WIP.WIP) AS  COMPROMETIDO
	, WIP.COSTO AS PRECIO
	, SUM(WIP.WIP) * WIP.COSTO AS IMPORTE
From (

Select WOR1.ItemCode AS CODIGO
	, A1.ItemName as MATERIAL
	, A1.InvntryUom as UDM
	, L10.Price AS COSTO
	, WOR1.BaseQty * (OWOR.PlannedQty - OWOR.CmpltQty) as WIP
from WOR1 
inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList= 10 
inner join OWOR on OWOR.DocEntry = WOR1.DocEntry 
inner join OITM A3 on A3.ItemCode = OWOR.ItemCode 
Where OWOR.Status ='R' and OWOR.CmpltQty < OWOR.PlannedQty 
and OWOR.U_Starus = '06' 
and A3.U_TipoMat = 'PT' 

and A1.ItmsGrpCod <> 113 
and A1.ItmsGrpCod <> 114 
and A1.U_TipoMat <> 'CA'
and A1.U_TipoMat <> 'HB'
) WIP 
Group by WIP.CODIGO, WIP.MATERIAL, WIP.COSTO, WIP.UDM
Order by WIP.MATERIAL 






/*

Select OWOR.DocEntry AS OP
	, A3.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION 
	, A3.U_VS AS VS
from OWOR 
inner join OITM A3 on A3.ItemCode = OWOR.ItemCode 
Where OWOR.Status ='R' and OWOR.CmpltQty < OWOR.PlannedQty 
and OWOR.U_Starus = '06' 
and A3.U_TipoMat = 'PT' 
and A3.ItemCode like '3754-50%'

11 375450



 Select WIP.CODIGO, WIP.MATERIAL AS DESCRIPCION, WIP.UDM, 'APG-ST' AS ALMACEN, SUM(WIP.ExPg) as IN_STOCK
	, SUM(WIP.WIP) AS  COMPROMETIDO, (SUM(WIP.ExPg) -SUM(WIP.WIP)) AS NECESIDAD
	, WIP.COSTO AS PRECIO, (SUM(WIP.ExPg) - SUM(WIP.WIP)) * WIP.COSTO AS IMPORTE, '501-200-000' AS CC
	, WIP.LIN AS LINEA 
From (

Select WOR1.ItemCode AS CODIGO, A1.ItemName as MATERIAL, A1.InvntryUom as UDM, L10.Price AS COSTO, 0 as ExPg
	, WOR1.BaseQty * (OWOR.PlannedQty - OWOR.CmpltQty) as WIP
	, A1.U_Linea AS LIN 
from WOR1 
inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList= 10 
inner join OWOR on OWOR.DocEntry = WOR1.DocEntry 
inner join OITM A3 on A3.ItemCode = OWOR.ItemCode 
Where OWOR.Status ='R' and OWOR.CmpltQty < OWOR.PlannedQty 
and A1.ItmsGrpCod <> 113 
and A1.ItmsGrpCod <> 114 
and OWOR.U_Starus = '06' 
and A1.InvntItem = 'Y' and A3.U_TipoMat = 'PT' 
and OWOR.DocEntry = 64799



Union all 

Select OITW.ItemCode as CODIGO, OITM.ItemName as MATERIAL, OITM.InvntryUom as UDM, LPS.Price AS COSTO
	, OITW.OnHand as ExPg, 0 as WIP, OITM.U_Linea AS LIN 
from OITW 
inner join OITM on OITM.ItemCode = OITW.ItemCode 
inner join ITM1 LPS on OITM.ItemCode= LPS.ItemCode and LPS.PriceList= 10 
Where OITW.OnHand > 0 and OITW.WhsCode = 'APG-ST' 
and OITM.U_TipoMat <> 'PT' and OITM.InvntItem = 'Y'

) WIP 

Group by WIP.CODIGO, WIP.MATERIAL, WIP.COSTO, WIP.UDM, WIP.LIN Order by WIP.MATERIAL 
   






Select WOR1.ItemCode AS CODIGO, A1.ItemName as MATERIAL, A1.InvntryUom as UDM, L10.Price AS COSTO, 0 as ExPg
	, WOR1.BaseQty * (OWOR.PlannedQty - OWOR.CmpltQty) as WIP
	, A1.U_Linea AS LIN 
from WOR1 
inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList= 10 
inner join OWOR on OWOR.DocEntry = WOR1.DocEntry 
inner join OITM A3 on A3.ItemCode = OWOR.ItemCode 
Where OWOR.Status ='R' and OWOR.CmpltQty < OWOR.PlannedQty 
and A1.ItmsGrpCod <> 113 
and A1.ItmsGrpCod <> 114 
and OWOR.U_Starus = '06' 
and A1.InvntItem = 'Y' and A3.U_TipoMat = 'PT' 
and OWOR.DocEntry = 64799


*/