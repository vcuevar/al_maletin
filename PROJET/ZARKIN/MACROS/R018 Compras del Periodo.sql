-- Nombre: 018 Compras del Periodo.
-- Uso: Reporte de las compras realizadas y las devoluciones a Proveedores, en un rango de fecha.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 01 de julio del 2025; Modificar Costo Estandar por LP-10.

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xLista1 as Integer
Declare @xLista2 as Integer

Set @FechaIS = CONVERT (DATE, '2025-07-02', 102)
Set @FechaFS = CONVERT (DATE, '2025-07-29', 102)

Set @xLista1 = 10
Set @xLista2 = 7

-- Compras del Periodo.

Select OPDN.CardCode as PROVCOD
	, OPDN.CardName as PROVEEDOR
	,  PDN1.DocEntry as CONSECUTIVO
	, OPDN.DocNum as N_ENTRADA
	, Cast(OPDN.DocDate as DATE) as F_COMPRA
	, OITM.U_TipoMat as TIPOMAT
	, T1.Descr as NOM_GRUPO
	, PDN1.ItemCode as CODE_MAT
	, OITM.ItemName as DESCRIPCION
	, OITM.InvntryUom as UDM
	, PDN1.Quantity as CANTIDAD
	, PDN1.NumPerMsr as X_PAQ
	, (PDN1.Quantity*PDN1.NumPerMsr) as Q_INV
	, (PDN1.Price / PDN1.NumPerMsr) as PREC_UNIT
	, PDN1.Currency as M_C
	, PDN1.Rate as TIPOCAMBIO
	, PDN1.LineTotal as IMPORTE
	, ITM1.Price as PRECIO_L10
	, ITM1.Currency as MONEDA_L10
From PDN1 
inner join OPDN on OPDN.DocEntry = PDN1.DocEntry 
left join OITM on PDN1.ItemCode = OITM.ItemCode 
left join ITM1 on PDN1.ItemCode = ITM1.ItemCode and ITM1.PriceList= 10 
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where OITM.ItemCode is not null AND Cast(OPDN.DocDate as DATE) Between @FechaIS and @FechaFS  
Order by PDN1.DocEntry 


-- Where OITM.ItemCode is not null AND Cast(OPDN.DocDate as DATE) Between '" & FechaIS & "' and '" & FechaFS & "' 

-- Devolucion a los proveedores en el periodo
/*
Select ORPD.CardCode as ProvCod
	, ORPD.CardName as Proveedor
	, ORPD.DocNum as N_Entrada
	, RPD1.DocEntry as CONSECUTIVO
	, ORPD.DocDate as F_Compra
	, OITM.U_TipoMat as TipoMat
	, T1.Descr as Nom_Grupo
	, RPD1.ItemCode as Code_Mat
	, OITM.ItemName Descripcion
	, OITM.InvntryUom as UdM
	, RPD1.Quantity as Cantidad
	, RPD1.NumPerMsr as X_Paq
	, (RPD1.Quantity*RPD1.NumPerMsr) as Q_Inv
	, (RPD1.Price/ RPD1.NumPerMsr) as Prec_Unit
	, RPD1.Rate as TIPOCAMBIO
	, RPD1.LineTotal as Importe
	, ITM1.Price as PRECIO_L10
	, ITM1.Currency as MONEDA_L10
From RPD1 
inner join ORPD on ORPD.DocEntry = RPD1.DocEntry 
left join OITM on RPD1.ItemCode = OITM.ItemCode 
left join ITM1 on RPD1.ItemCode = ITM1.ItemCode and ITM1.PriceList= 10 
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where OITM.ItemCode is not null and Cast(ORPD.DocDate as DATE) Between @FechaIS and @FechaFS  
Order by RPD1.DocEntry 

*/