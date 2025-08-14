-- Nombre: 017 Inventario Comparacion a dos preciso.
-- Uso: Identifiacar los articulos que requierem ser cambiados, por revalorizacion.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 24 de junio del 2025; Origen.

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xLista1 as Integer
Declare @xLista2 as Integer

Set @FechaIS = CONVERT (DATE, '2021-04-01', 102)
Set @FechaFS = CONVERT (DATE, '2021-05-05', 102)

Set @xLista1 = 10
Set @xLista2 = 7

/* ------------------------------------------------------------------------------------------------
|  Reporte comparacion con dos precios a existencias Globales.                                     |
--------------------------------------------------------------------------------------------------*/
/*
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, OITM.OnHand as EXISTENCIA
	, L1.Price as LIST_01
	, OITM.OnHand * L1.Price AS IMPO_1
	, L2.Price as LIST_02
	, OITM.OnHand * L2.Price AS IMPO_2
	, OITM.QryGroup32 AS PROP_32
	, OITM.U_TipoMat AS TIPOMAT
	, UFD1.Descr as LINEA
	, (OITM.U_Minimo/5) AS KxDia
	, T1.Descr AS GRUPPLAN 
from OITM 
inner join ITM1 L1 on OITM.ItemCode= L1.ItemCode and L1.PriceList = @xLista1 
inner join ITM1 L2 on OITM.ItemCode= L2.ItemCode and L2.PriceList = @xLista2 
inner join UFD1 on OITM.U_Linea= UFD1.FldValue and UFD1.TableID = 'OITM' and UFD1.FieldID=7 
left join UFD1 T1 on OITM.U_GrupoPlanea = T1.FldValue and T1.TableID = 'OITM' and T1.FieldID=9 
Where OITM.OnHand <> 0 Order by OITM.U_TipoMat, OITM.ItemName 

*/
/* ------------------------------------------------------------------------------------------------
|  Reporte comparacion con dos precios a existencias por Almacen.                                  |
--------------------------------------------------------------------------------------------------*/

Select	OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OITW.WhsCode AS CODEALMA
		, L1.Price as LIST_01
		, OITW.OnHand as EXISTENCIA	
		, L2.Price as LIST_02	
from OITM 
inner join OITW on OITM.ItemCode=OITW.ItemCode 
inner join OWHS on OWHS.WhsCode=OITW.WhsCode 
inner join ITM1 L1 on OITM.ItemCode= L1.ItemCode and L1.PriceList = @xLista1 
inner join ITM1 L2 on OITM.ItemCode= L2.ItemCode and L2.PriceList = @xLista2 
Where OITW.OnHand <> 0 and L1.Price <> L2.Price
and OITM.U_TipoMat = 'MP' and OITM.QryGroup32 = 'N'
Order by OITM.ItemName, OWHS.WhsName


