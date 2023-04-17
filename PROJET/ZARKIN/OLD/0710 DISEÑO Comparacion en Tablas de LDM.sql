
--Registro estan en Mayo y en Junio fueron Borrados.
Select  Mayo_ITT1.Father  AS COD_PADRE,
		Mayo_ITT1.ChildNum AS NUM_CHI,	
		Mayo_ITT1.Code AS CODIGO, 
		Mayo_ITT1.Quantity AS CANTIDAD,  
		Mayo_ITT1.Price AS PRECIO,
		Mayo_ITT1.PriceList AS LIST_PREC,
		Mayo_ITT1.Warehouse AS ALMACEN,
		Junio_ITT1.Father AS VALIDO
FROM Mayo_ITT1
left join Junio_ITT1 on Mayo_ITT1.Father =Junio_ITT1.Father and Mayo_ITT1.ChildNum = Junio_ITT1.ChildNum and 
Mayo_ITT1.Code = Junio_ITT1.Code
Where Junio_ITT1.Father is null  

-- Registros que estan en Junio y que en mayo no estaban (Nuevos)
Select  Mayo_ITT1.Father  AS COD_PADRE,
		Mayo_ITT1.ChildNum AS NUM_CHI,	
		Mayo_ITT1.Code AS CODIGO, 
		Mayo_ITT1.Quantity AS CANTIDAD,  
		Mayo_ITT1.Price AS PRECIO,
		Mayo_ITT1.PriceList AS LIST_PREC,
		Mayo_ITT1.Warehouse AS ALMACEN,
		Junio_ITT1.Father AS VALIDO
FROM Mayo_ITT1
Right join Junio_ITT1 on Mayo_ITT1.Father =Junio_ITT1.Father and Mayo_ITT1.ChildNum = Junio_ITT1.ChildNum and 
Mayo_ITT1.Code = Junio_ITT1.Code
Where Junio_ITT1.Father is null  


--Registro estan en los dos meses buscar diferencias CAMBIO DE CODIGO
Select  Mayo_ITT1.Father  AS COD_PADRE,
		Mayo_ITT1.ChildNum AS NUM_CHI,	
		Mayo_ITT1.Code AS CODIGO, 
		Mayo_ITT1.Quantity AS CANTIDAD,  
		Mayo_ITT1.Price AS PRECIO,
		Mayo_ITT1.PriceList AS LIST_PREC,
		Mayo_ITT1.Warehouse AS ALMACEN,
		Junio_ITT1.Code AS Code_B
FROM Mayo_ITT1
inner join Junio_ITT1 on Mayo_ITT1.Father =Junio_ITT1.Father and Mayo_ITT1.ChildNum = Junio_ITT1.ChildNum and 
Mayo_ITT1.Code = Junio_ITT1.Code
Where Mayo_ITT1.Code <> Junio_ITT1.Code

--Registro estan en los dos meses buscar diferencias en CANTIDAD
Select  Mayo_ITT1.Father  AS COD_PADRE,
		Mayo_ITT1.ChildNum AS NUM_CHI,	
		Mayo_ITT1.Code AS CODIGO, 
		Mayo_ITT1.Quantity AS CANT_MAY,  
		Mayo_ITT1.Price AS PRECIO,
		Mayo_ITT1.PriceList AS LIST_PREC,
		Mayo_ITT1.Warehouse AS ALMACEN,
		Junio_ITT1.Quantity AS CANT_JUN
FROM Mayo_ITT1
inner join Junio_ITT1 on Mayo_ITT1.Father =Junio_ITT1.Father and Mayo_ITT1.ChildNum = Junio_ITT1.ChildNum and 
Mayo_ITT1.Code = Junio_ITT1.Code
Where Mayo_ITT1.Quantity <> Junio_ITT1.Quantity


--Registro estan en los dos meses buscar diferencias en ALMACEN
Select  Mayo_ITT1.Father  AS COD_PADRE,
		Mayo_ITT1.ChildNum AS NUM_CHI,	
		Mayo_ITT1.Code AS CODIGO, 
		Mayo_ITT1.Quantity AS CANT_MAY,  
		Mayo_ITT1.Price AS PRECIO,
		Mayo_ITT1.PriceList AS LIST_PREC,
		Mayo_ITT1.Warehouse AS ALMACEN,
		Junio_ITT1.Warehouse AS LIST_JUN
FROM Mayo_ITT1
inner join Junio_ITT1 on Mayo_ITT1.Father =Junio_ITT1.Father and Mayo_ITT1.ChildNum = Junio_ITT1.ChildNum and 
Mayo_ITT1.Code = Junio_ITT1.Code
Where Mayo_ITT1.Warehouse <> Junio_ITT1.Warehouse





