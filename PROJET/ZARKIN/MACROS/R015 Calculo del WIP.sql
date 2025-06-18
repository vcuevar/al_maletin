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
|  Para Calcular los materiales para el WIP, EXPLOSION WIP TOTAL (SIN CA, TELA Y PIEL).            |
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

/* ------------------------------------------------------------------------------------------------
|  Compara WIP VS Comprometido en SAP.                                                             |
--------------------------------------------------------------------------------------------------*/

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName as DESCRIPCION
	, OITM.InvntryUom as UDM
	, OITW.OnHand as IN_STOCK
	, OITM.IsCommited AS COMPROMETIDO
	, OITW.OnHand - OITM.IsCommited as NECESIDAD
	, ITM1.Price as PRECIO
	, (OITW.OnHand - OITM.IsCommited) * ITM1.Price AS IMPORTE
	, OITM.U_Linea AS LINEA
	, OITM.U_TipoMat AS TM
	, ISNULL((Select Top (1) A3.ItemName AS K1 from ITT1 Inner Join OITM A1 ON ITT1.Code = A1.ItemCode 
		Left Join OITM A3 on  ITT1.father = A3.ItemCode where ITT1.Code = OITM.ItemCode and A3.QryGroup32 = 'N'
		Order By A3.ItemName ), 'SIN_REGISTRO')AS POR_OP
	, ISNULL((Select Top (1) A3.ItemName AS K2 from ITT1 Inner Join OITM A1 ON ITT1.Code = A1.ItemCode 
		Left Join OITM A3 on  ITT1.father = A3.ItemCode where ITT1.Code = OITM.ItemCode and A3.QryGroup32 = 'Y' 
		and A3.U_TipoMat = 'SP' Order By A3.ItemName), 'SIN_REGISTRO') AS SIN_OP 
from OITM 
inner join OITW on OITM.ItemCode=OITW.ItemCode and OITW.WhsCode = 'APG-ST' 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 
where OITW.OnHand > 0 
order by IMPORTE DESC, DESCRIPCION




Select A3.ItemName AS K1 
from ITT1 
Inner Join OITM A1 ON ITT1.Code = A1.ItemCode 
Left Join OITM A3 on  ITT1.father = A3.ItemCode 
where ITT1.Code = '17774' 
--and A3.QryGroup32 = 'N'
Order By A3.ItemName 

