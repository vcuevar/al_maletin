-- S Back Order Costeado.
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 4 de Septiembre del 2023; Relacion de Juegos con Problema.
-- Dado que se generqaron muchos juegos y eso genero abiguedad.

/*
-- Consulta Original.
Select BO.OP, BO.Pedido, BO.FechaPedido, BO.OC, BO.Codigo_Cliente, BO.CLIENTE, BO.CODIGO, BO.Descripcion, BO.Cantidad
	, (Select Top (1 ) RDR1.LineNum from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS LINEA
	, (Select Top (1 ) RDR1.Price from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS PRICE
	, (Select Top (1 ) RDR1.Currency from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS MONEDA
	, (Select ORDR.U_Prioridad from ORDR Where ORDR.DocNum =  BO.Pedido ) AS PRIOR
	, (Select top 1 RDR1.Price from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as PrecGbl
	, (Select top 1 RDR1.Currency from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as MonGbl
	, BO.VS 
	, (Select OITM.U_VS from OITM Where OITM.ItemCode = (Select top 1 RDR1.ItemCode from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente)) AS VSGbl
	, BO.Funda
	, BO.U_Starus AS U_Status 
from Vw_BackOrderExcel BO 
Where BO.Pedido = '1747'
Order By BO.Descripcion, BO.OP 
*/


-- 230904 Consulta a Mejorar la relacion.

Select BO.OP
	, BO.Pedido
	, BO.FechaPedido
	, BO.OC
	, BO.Codigo_Cliente
	, BO.CLIENTE
	, BO.CODIGO
	, BO.Descripcion
	, BO.Cantidad
	, RDR1.Price  
	--, (Select Top (1 ) RDR1.LineNum from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS LINEA
	--, (Select Top (1 ) RDR1.Price from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS PRICE
	--, (Select Top (1 ) RDR1.Currency from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS MONEDA
	--, (Select ORDR.U_Prioridad from ORDR Where ORDR.DocNum =  BO.Pedido ) AS PRIOR
	--, (Select top 1 RDR1.Price from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as PrecGbl
	--, (Select top 1 RDR1.Currency from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as MonGbl
	, BO.VS 
	--, (Select OITM.U_VS from OITM Where OITM.ItemCode = (Select top 1 RDR1.ItemCode from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente)) AS VSGbl
	, BO.Funda
	, BO.U_Starus AS U_Status 
from RDR1
Left join Vw_BackOrderExcel BO on BO.Pedido = RDR1.DocEntry and BO.CODIGO = RDR1.ItemCode
Where BO.Pedido = '1747'
Order By BO.Descripcion, BO.OP 

Select Pedido, CODIGO, Descripcion, Cantidad, VS from Vw_BackOrderExcel BO
Where BO.Pedido = '1747'

Select BO.OP
	, BO.Pedido
	, BO.FechaPedido
	, BO.OC
	, BO.Codigo_Cliente
	, BO.CLIENTE
	, BO.CODIGO
	, BO.Descripcion
	, BO.Cantidad
	, RDR1.Price 
	, BO.VS 
	, BO.Funda
	, BO.U_Starus AS U_Status 
from RDR1 
left join Vw_BackOrderExcel BO on BO.Pedido = RDR1.DocEntry and BO.CODIGO = RDR1.ItemCode
Where DocEntry = '1747' 
Order By Descripcion






Select RDR1.Price, * from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode where ITT1.Code = '3827-39-P0301' and RDR1.BaseCard = 'C0327' -- Pedido = '1747'


Select * 
from ITT1 
inner join RDR1 on ITT1.Father = RDR1.ItemCode 
where ITT1.Code = '3827-38-P0301' and RDR1.BaseCard = 'C0327' -- Pedido = '1747'

3827-38-P0301

PrecGbl	MonGbl	VS
69327.010000	USD	0.2200000000


Select * from RDR1 where DocEntry = '1747'

Select * from RDR1 where DocEntry = '1747' and RDR1.ItemCode = '3827-39-P0301'

Select * from OWOR where DocEntry = '39851'

*/