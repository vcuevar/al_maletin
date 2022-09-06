-- Informe de ültimo Precios de Compra.
-- Objetivo: Consultar por articulo las compras que ha tenido el articulo
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Septiembre del 2022; Origen

-- Parametros
Declare @FechaIS nvarchar(30)
Declare @CodeArti as nvarchar(10)

Set @FechaIS = CONVERT (DATE, '2019/01/01', 102)
Set @CodeArti = '10002'

-- Desarrollo de la consulta

Select OITM.ItemCode AS CODIGO
		, OITM.ItemName AS MATERIAL
		, OITM.InvntryUom AS UDM
		, PDN1.BaseRef AS ORDEN_C
		, OPDN.DocNum AS COMPRA
		, Convert(varchar, OPDN.DocDueDate, 6) AS FECHAF 
		, (OPDN.CardCode + '  ' + OPDN.CardName) AS PROVEEDOR
		, FORMAT(PDN1.Price,'C4','es-MX') AS PRECIOF
		, PDN1.Currency AS MONEDA
From PDN1
Inner Join OPDN on OPDN.DocEntry = PDN1.DocEntry
Inner Join OITM on OITM.ItemCode = PDN1.ItemCode
Where PDN1.ItemCode = @CodeArti and Cast(OPDN.DocDueDate as date) > Cast(@FechaIS as date)
Order By PDN1.DocEntry desc


--, ('$  ' + CONVERT(VARCHAR, CONVERT(VARCHAR, CAST(PDN1.Price  AS MONEY), 1))) AS PRECIO