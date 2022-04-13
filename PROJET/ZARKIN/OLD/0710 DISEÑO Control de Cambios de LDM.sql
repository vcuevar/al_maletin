-- Consulta para Tabla de las LDM, llevar un control de Cambios.
-- Ing. Vicente Cueva R.
-- Solicitado: Viernes 29 de Junio del 2018.
-- Inicio: Martes 10 de Julio del 2018.
-- Actualizado: Martes 10 de julio del 2018. 

DECLARE @FechaIS date
DECLARE @FechaFS date
DECLARE @Grupo nvarchar(20)

--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = CONVERT (DATE, '2018-04-16', 102)
Set @FechaFS = CONVERT (DATE, '2018-04-16', 102) 
Set @Grupo  = '7'

-- Extraer Tabla completa de las Listas de Materiales.
-- Total de Registros 427,152

SELECT	ITT1.Father + LTRIM(STR(ITT1.ChildNum, 3)) + ITT1.Code AS CODE_UNIC, 
		ITT1.Father AS COD_PADRE,
		ITT1.ChildNum AS NUM_CHI,	
		A3.ItemName AS ESTRUCTURA,
		ITT1.Code AS CODIGO, 
		A1.ItemName AS MATERIAL,  
		A1.InvntryUom AS UM,
		ITT1.Quantity AS CANTIDAD,  
		ITT1.Price AS PRECIO,
		ITT1.PriceList AS LIST_PREC,
		ITT1.Warehouse AS ALMACEN
FROM ITT1  
INNER JOIN OITM A3 ON ITT1.Father = A3.ItemCode
INNER JOIN OITM A1 ON ITT1.Code = A1.ItemCode 
Order by ESTRUCTURA, MATERIAL



--Esquema de Comparacion de Tablas

SELECT
       (SELECT TOP 1
           name
      FROM TestDB2.sys.schemas WHERE
           schema_id
           =
           D1O.schema_id) AS Schema_Name,
       D1O.name AS Object_Name
  FROM
       TestDB2.sys.syscomments D1C
       INNER JOIN TestDB2.sys.objects D1O
       ON
       D1O.object_id
       =
       D1C.id
       INNER JOIN TestDB.sys.objects D2O
       ON
       D1O.name
       =
       D2O.name
       INNER JOIN TestDB.sys.syscomments D2C
       ON
       D2O.object_id
       =
       D2C.id
WHERE
       D1C.text
       <>
       D2C.text;
