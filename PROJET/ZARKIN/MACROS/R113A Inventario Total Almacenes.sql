-- Nombre: 113 Inventario Total por fecha.
-- Uso: Inventario Total por almacenes y cortado a una Fecha.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Sabado 30 de agosto del 2025; Origen

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date

Set @FechaIS = CONVERT (DATE, '2025-08-03', 102)
Set @FechaFS = CONVERT (DATE, '2025-08-30', 102)

-- Inventario a la fecha de corte.

Select	INV.ALM_EXI AS CODEALMA
		, OWHS.WhsName AS NOMBALMA
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, INV.VAL_EXI as EXISTENCIA
		, ITM1.Price as LIST_10
		, INV.VAL_EXI * ITM1.Price AS IMPORTE
		, OITM.U_TipoMat AS TIPOMAT
		, OITM.U_VS AS VS
		, OITM.U_VS * INV.VAL_EXI AS TVS
		, UFD1.Descr as LINEA
		, T1.Descr AS GRUPPLAN
		, (OITM.U_Minimo/5) AS KxDia
from OITM 
Inner Join (Select OINM.ItemCode AS COD_EXI, SUM(OINM.InQty)-SUM(OINM.OutQty) AS VAL_EXI
	, OINM.Warehouse AS ALM_EXI from OINM where OINM.CreateDate < @FechaFS Group by OINM.ItemCode, OINM.Warehouse
	HAVING (SUM(OINM.InQty)-SUM(OINM.OutQty)) <> 0) INV on INV.COD_EXI = OITM.ItemCode
inner join OWHS on OWHS.WhsCode = INV.ALM_EXI 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 
inner join UFD1 on OITM.U_Linea= UFD1.FldValue and UFD1.TableID='OITM'and UFD1.FieldID=7
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Order by OWHS.WhsName, OITM.U_TipoMat, OITM.ItemName 










/*
Select OITM.ItemCode
	, OITM.ItemName
	, OITM.InvntryUom
	, OITM.U_TipoMat
	, OITM.U_Linea
	, INIC.SalInic
	, KD.Entradas
	, KD.Salidas
	, ITM1.Price 
from OITM 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10


left join (

Select INICIO.ItemCode
	, (SUM(INICIO.InQty)-SUM(INICIO.OutQty)) as SalInic 
From (
Select OINM.ItemCode
	, OINM.InQty
	, OINM.OutQty 
	, OINM.Warehouse
from OINM 
where OINM.CreateDate < @FechaIS --and OINM.Warehouse='AMP-CC'
) INICIO 
Group by INICIO.ItemCode, OINM.Warehouse

) INIC on INIC.ItemCode = OITM.ItemCode 

Group by KDX.ItemCode ) KD on KD.ItemCode= OITM.ItemCode 
Order by OITM.U_TipoMat, OITM.Itemname

Select OINM.ItemCode
	, SUM(OINM.InQty)-SUM(OINM.OutQty) AS EXISTENCIA
	, OINM.Warehouse
from OINM

where OINM.CreateDate < '2025-08-30'

Group by OINM.ItemCode, OINM.Warehouse
HAVING (SUM(OINM.InQty)-SUM(OINM.OutQty)) <> 0
*/