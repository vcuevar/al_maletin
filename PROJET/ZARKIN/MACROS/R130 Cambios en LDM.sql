-- Macro R130 Cambios en LDM
-- Consulta para Macro de Cambios en LDM
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Martes 22 de Noviembre del 2022; Origen.

-- Declaraciones
Declare @Material nvarchar(30)
Declare @Factor Float

Set @Material = '20211'
Set @Factor = 0.95
--Set @Factor = 1.057143

-- Definir el Material a Buscar.
Select OITM.ItemCode AS COD, OITM.ItemName AS NAM From OITM Where OITM.ItemCode = @Material 

Select * from ITT1 Where ITT1.Father = '19970'

-- Consulta Materiales de Donde Usado para Lista de Materiales.
Select ITT1.Father AS CODE
		, A3.ItemName AS MUEBLE
		, ITT1.Code AS CODIGO
		, A1.ItemName AS MATERIAL
		, A1.invntryuom AS UDM
		, Cast(ITT1.Quantity as Decimal(16,4)) AS CANTIDAD
		, Cast(@Factor as Decimal(16,4)) AS FACTOR
		, ITT1.ChildNum AS ID
		, Cast(ITT1.Quantity * @Factor as decimal(16,4)) AS NEW_CANT
		, 'POR ACTUALIZAR' AS ACCION
From ITT1  
Inner Join OITM A1 on ITT1.Code = A1.ItemCode
left join OITM A3 on  ITT1.father = A3.ItemCode 
WHERE ITT1.Code  = @Material

Select ITT1.Father AS CODE
	, A3.ItemName AS MUEBLE
	, ITT1.Code AS CODIGO
	, A1.ItemName AS MATERIAL
	, A1.invntryuom AS UDM
	, ITT1.ChildNum AS ID_COMPONENTE
	, Cast(ITT1.Quantity as Decimal(16,4)) AS CANTIDAD
	, 'POR ACTUALIZAR' AS ACCION 
	, x.ID 
From ITT1 
Inner Join OITM A1 on ITT1.Code = A1.ItemCode 
left join OITM A3 on  ITT1.father = A3.ItemCode 
left join ( 
Select  ITT1.Code AS CODIGO, ITT1.Father
	, ITT1.ChildNum AS ID_COMPONENTE
	, ROW_NUMBER() OVER(PARTITION BY ITT1.Father ORDER BY ITT1.Father
	, ChildNum ASC ) - 1 AS ID From ITT1 ) x on x.CODIGO = ITT1.Code AND x.Father = Itt1.Father 
WHERE ITT1.Code = @Material


