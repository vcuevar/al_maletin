--  Consulta para Calculara el Back Order Costeado.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 22 de Febrero del 2022

-- Cargada a la Macro Back Order Costeado.

Select BO.OP
	, BO.Pedido 
	, BO.FechaPedido
	, BO.OC
	, BO.Codigo_Cliente
	, BO.CLIENTE
	, BO.CODIGO
	, BO.Descripcion
	, BO.Cantidad
	, (Select Top (1 ) RDR1.LineNum from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS LINEA
	, (Select Top (1 ) RDR1.Price from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS PRICE
	, (Select Top (1 ) RDR1.Currency from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS MONEDA
	, (Select ORDR.U_Prioridad from ORDR Where ORDR.DocNum =  BO.Pedido ) AS PRIOR
	, (Select top 1 RDR1.Price from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as PrecGbl
	, (Select top 1 RDR1.Currency from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as MonGbl
	, BO.VS
	, (Select top 1 OITM.U_VS from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode inner join OITM on OITM.ItemCode = ITT1.Father where ITT1.Code = BO.CODIGO) as VSGbl
	, BO.Funda
	, BO.U_Starus AS U_Status
from Vw_BackOrderExcel BO 
Where BO.Pedido = '1761' 
Order By BO.Descripcion, BO.OP  


/*

Select RDR1.DocEntry, RDR1.LineNum, RDR1.ItemCode, RDR1.Dscription, RDR1.Quantity, RDR1.Price, RDR1.Currency, RDR1.TreeType, RDR1.BaseCard,   *
From RDR1
Where RDR1.DocEntry = '696' --and RDR1.LineNum = 9
Order By RDR1.DocEntry, RDR1.LineNum

Select *
from ORDR
--inner join RDR1 on ORDR.DocEntry = RDR1.DocEntry
Where ORDR.DocEntry = '696'


Select OWOR.LineDirty, *
from OWOR
Where OWOR.OriginNum = '696' and OWOR.LineDirty = 7
Order By OWOR.ItemCode

Select * 
from WOR1
Where WOR1.DocEntry = 12806

Select  RDR1.Price,  * from ITT1
inner join RDR1 on ITT1.Father = RDR1.ItemCode 
where ITT1.Code = '3718-36-P0471'


Select *
from Vw_BackOrderExcel


Select * from ITT1
where ITT1.Code = '3718-39-P0471'



*/