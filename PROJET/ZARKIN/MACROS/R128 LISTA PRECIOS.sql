-- Obtener Lista de Precios Estandar para cargar a 5 Precios Pablo.
-- Solicito: Pablo Flores y Mary Pardo.
-- Tarea: Tener un precio para que Pablo Muestre el precio de los que cuesta el articulo con gastos de Exportacion, sin afectar.
-- el costo de la compra con el proveedor.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 10 de Octubre del 2022; Origen.



Select  OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, Cast(L5.Price as decimal(16,4)) AS PRE_STD
		, L5.Currency AS Mon_STD
		, L5.PriceList AS LISTA
		, Cast(L10.Price as decimal(16,4)) AS Pre_7
		, L10.Currency AS Mon_7
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITM1 L10 on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
inner join ITM1 L5 on OITM.ItemCode = L5.ItemCode and L5.PriceList = 5
Where L10.Price > 0 and L5.Price = 0
Order By DESCRIPCION


-- Comparativos de Lista de Precios.
Select OITM.ItemCode AS CODE, OITM.ItemName AS NOMBRE, OITM.InvntryUom AS UDM, Cast(L9.Price as decimal(16,4)) AS PRECIO_COMPRAS
	, L9.Currency AS MONEDA_COMPRAS, Cast(L10.Price as decimal(16,4)) AS PRECIO_STANDAR, L10.Currency AS MONEDA_STANDAR
	, Cast(L1.Price as decimal(16,4)) AS PRECIO_DISEÑO, L1.Currency AS MONEDA_DISEÑO, Cast(L7.Price as decimal(16,4)) AS PRECIO_COSTOS
	, L7.Currency AS MONEDA_COSTOS, Cast(L2.Price as decimal(16,4)) AS PRECIO_VENTAS
	, L2.Currency AS MONEDA_VENTAS, (T1.Descr + ' - ' + OITM.U_Linea) AS GRUPPLAN 
From OITM 
INNER JOIN ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 1 
INNER JOIN ITM1 L2 on OITM.ItemCode = L2.ItemCode and L2.PriceList = 2 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 5 
INNER JOIN ITM1 L9 on OITM.ItemCode = L9.ItemCode and L9.PriceList = 9 
INNER JOIN ITM1 L10 on OITM.ItemCode = L10.ItemCode and L10.PriceList=10 
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where U_TipoMat = 'MP' and OITM.frozenFor = 'N' 
Order By OITM.ItemName 
