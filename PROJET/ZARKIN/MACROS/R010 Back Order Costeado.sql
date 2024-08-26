--  Consulta para Calculara el Back Order Costeado.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 22 de Febrero del 2022
-- Actualizado: Viernes 16 de Agosto del 2024; Quitar los costos a los subproductos. Solo deja PT

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
	, (Select Top (1 ) RDR1.Price from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS PRICE
	, (Select Top (1 ) RDR1.Currency from RDR1 Where RDR1.DocEntry = BO.Pedido  and RDR1.ItemCode = BO.CODIGO) AS MONEDA
	, (Select OITM.U_TipoMat from OITM Where OITM.ItemCode = CODIGO) AS T_MAT
	, (Select top (1) RDR1.Price from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode 
	where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente and DocEntry = BO.Pedido) as PrecGbl
	, (Select top (1) RDR1.Currency from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode
	where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente) as MonGbl
	, BO.VS
	, (Select Top (1) OITM.U_VS from ITT1 inner join RDR1 on ITT1.Father = RDR1.ItemCode 
	inner join OITM on OITM.ItemCode = ITT1.Father where ITT1.Code = BO.CODIGO and RDR1.BaseCard = BO.Codigo_Cliente
	and RDR1.DocEntry = BO.Pedido) as VSGbl
	, BO.Funda
	, BO.U_Starus AS U_Status
from Vw_BackOrderExcel BO 
--Where BO.Pedido = '2358' 
Order By BO.Descripcion, BO.OP  
