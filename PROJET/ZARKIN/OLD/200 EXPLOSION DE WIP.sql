
-- Calculo del WIP en proceso falta conciderar lo consumido y solo de ordenes liberadas.



Select WIP.CODIGO, WIP.MATERIAL, WIP.UDM,  WIP.COSTO, SUM(WIP.ExPg) as S_ExPg
	, SUM(WIP.WIP) AS S_WIP From (

Select   WOR1.ItemCode as CODIGO, A1.ItemName as MATERIAL, A1.InvntryUom as UDM
, L10.Price AS COSTO, 0 as ExPg, WOR1.BaseQty * (OWOR.PlannedQty - OWOR.CmpltQty) as WIP 
from WOR1 
inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList= 10 
inner join OWOR on OWOR.DocEntry = WOR1.DocEntry 

Where OWOR.Status ='R' and OWOR.CmpltQty < OWOR.PlannedQty 
and A1.ItmsGrpCod <> 113 and A1.U_TipoMat <> 'CA' and  A1.InvntItem = 'Y' 

Union all Select   OITW.ItemCode as CODIGO, OITM.ItemName as MATERIAL, OITM.InvntryUom as UDM, L10.Price AS COSTO, 
    OITW.OnHand as ExPg, 0 as WIP from OITW inner join OITM on OITM.ItemCode = OITW.ItemCode inner join ITM1 L10 on OITM.ItemCode= L10.ItemCode and L10.PriceList= 10 Where OITW.OnHand > 0 and OITW.WhsCode = 'APG-ST' and OITM.U_TipoMat <> 'PT' and OITM.U_TipoMat <> 'CA' and OITM.InvntItem = 'Y') WIP Group by WIP.CODIGO, WIP.MATERIAL, WIP.COSTO, WIP.UDM Order by  WIP.MATERIAL 
 
    