-- Macro Entradas y Salidas.
-- Presentar un Kardex sobre los materiales.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 04 de Febrero del 2022

-- Parametros
-- Fecha Inicial.
-- Fecha Final.
-- Codigo Articulo
-- Lista de Precios

-- Variables
Declare @FechaIS as nvarchar(30)
Declare @FechaFS as nvarchar(30)
Declare @Articulo as nvarchar(30)
Declare @nLista as Int

Set @nLista = 10
Set @FechaIS = '2025/09/01'
Set @FechaFS = '2025/09/12'
Set @Articulo = '10077'

/*
Select	OINM.ItemCode AS CODIGO
		, OINM.Dscription AS DESCRIPCION
		,Cast(OINM.CreateDate as date) AS FEC_CREA
		, Substring(OINM.JrnlMemo, 1, 15) AS DOCUMENTO
		, OINM.Warehouse AS ALM_ORG

		, Isnull(Case When (OINM.Warehouse = 'AXL-TC' or OINM.Warehouse = 'AMP-CC' or OINM.Warehouse = 'AMP-KU'
		or OINM.Warehouse = 'ARF-ST' or OINM.Warehouse = 'AMP-BL' or OINM.Warehouse = 'APG-PA'
		or OINM.Warehouse = 'AMP-CO' or OINM.Warehouse = 'AMP-FE' or OINM.Warehouse = 'AMP-ST'
		or OINM.Warehouse = 'AGN-RE' or OINM.Warehouse = 'APT-FX') Then 
		SUM(OINM.InQty-OINM.OutQty) end, 0) as ALMACEN

		
		, Isnull(Case When (OINM.Warehouse = 'APG-ST' or OINM.Warehouse = 'ATL-DS' or OINM.Warehouse = 'APT-SE'
		or OINM.Warehouse = 'APT-PR' or OINM.Warehouse = 'APT-PA' or OINM.Warehouse = 'APP-ST') Then 
		SUM(OINM.InQty-OINM.OutQty) end, 0) as WIP

		, Isnull(Case When (OINM.Warehouse = 'APT-ST' or OINM.Warehouse = 'AXL-CI' or OINM.Warehouse = 'AXL-CA'
		or OINM.Warehouse = 'APT-CO') Then 
		SUM(OINM.InQty-OINM.OutQty) end, 0) as PT
from OINM  
inner join OUSR on OINM.UserSign=OUSR.USERID 
inner join OITM on OINM.ItemCode=OITM.ItemCode 
left join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
inner join ITM1 on OINM.ItemCode= ITM1.ItemCode and ITM1.PriceList = @nLista 
Where Cast (OINM.CreateDate as DATE) between  @FechaIS and @FechaFS 
and OINM.ItemCode = @Articulo
Group By OINM.ItemCode, OINM.Dscription, SubString(OINM.JrnlMemo,1,15),  OINM.Warehouse  , OINM.CreateDate
order by Cast(OINM.CreateDate as date), SubString(OINM.JrnlMemo,1,15)
*/

-- Modificacion realizada el 07 de Noviembre para poder usar costo Historico 
-- y el Precio de la lista actualizado.

  Select OINM.CardName, OINM.BASE_REF, OINM.AppObjAbs, OINM.DocDate, OINM.CreateDate
	, OINM.JrnlMemo, OINM.ItemCode, OINM.Dscription
	, ITM1.Price as COST01
	, OINM.Price as COSTO_H
	, OINM.RevalTotal,(OINM.InQty-OINM.OutQty) as Movimiento
	, OINM.UserSign, OUSR.U_NAME, OINM.Warehouse AS ALM_ORG
	, ISNULL(OINM.Ref2, 'N/A') AS ALM_DES, OITM.U_VS, OINM.Comments
	, OITM.U_TipoMat, OINM.DocTime, OWOR.ItemCode as OPModelo 
from OINM  inner join OUSR on OINM.UserSign=OUSR.USERID 
inner join OITM on OINM.ItemCode=OITM.ItemCode 
left join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
inner join ITM1 on OINM.ItemCode= ITM1.ItemCode and ITM1.PriceList = @nLista 
Where Cast (OINM.CreateDate as DATE) between  @FechaIS and @FechaFS 
and OINM.ItemCode = @Articulo
--and ITM1.PriceList = " & nLista & "  
--Where Cast (OINM.CreateDate as DATE) between  '" & FechaIS & "' and '" & FechaFS & "' 
order by OINM.AppObjAbs, OINM.TransNum 
  


/*

Select OINM.CardName, OINM.BASE_REF, OINM.AppObjAbs, OINM.DocDate, OINM.CreateDate
		, OINM.JrnlMemo, OINM.ItemCode, OINM.Dscription, ITM1.Price as COST01, OINM.RevalTotal
		,(OINM.InQty-OINM.OutQty) as Movimiento, OINM.UserSign, OUSR.U_NAME, OINM.Warehouse AS ALM_ORG
		, ISNULL(OINM.Ref2, 'N/A') AS ALM_DES, OITM.U_VS, OINM.Comments, OITM.U_TipoMat, OINM.DocTime
		, OWOR.ItemCode as OPModelo 
from OINM  
inner join OUSR on OINM.UserSign=OUSR.USERID 
inner join OITM on OINM.ItemCode=OITM.ItemCode 
left join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
inner join ITM1 on OINM.ItemCode= ITM1.ItemCode and ITM1.PriceList = @nLista 
Where Cast (OINM.CreateDate as DATE) between  @FechaIS and @FechaFS 
and OINM.ItemCode = @Articulo
order by CreateDate, OINM.AppObjAbs, OINM.TransNum    
*/