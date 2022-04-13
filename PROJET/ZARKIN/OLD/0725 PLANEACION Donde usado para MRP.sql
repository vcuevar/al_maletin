-- Consulta para Completar el MRP con que PT llevan los materiales en el Back Order.
-- Ing. Vicente Cueva R.
-- Solicitado Daniel Monroy (Arie): Miercoles 25 de Julio del 2018.
-- Inicio: Miercoles 25 de Julio del 2018.
-- Actualizado: Viernes 27 Julio del 2018. 

--Parametros
DECLARE @Material nvarchar(20)
Set @Material  = '15323'

-- Donde Usado en Ordenes de Produccion Activas 
Select STUFF ((Select distinct ' ' + A4.ItemName  
from OWOR
INNER JOIN ITT1 on OWOR.ItemCode = ITT1.Father
INNER JOIN OITM A3 on OWOR.ItemCode = A3.ItemCode
INNER JOIN OITM A4 on A3.U_Modelo = A4.ItemCode
where (OWOR.Status='R' or OWOR.Status  = 'P') and ITT1.Code = @Material 
FOR XML PATH ('')), 1, 0, '') as MOD_OWOR

-- Donde Usado en LDM
--Select  STUFF ((SELECT distinct ' ' + T4.ItemName
--FROM ITT1  
--INNER JOIN OITM T3 ON Father = T3.ItemCode  
--INNER JOIN OITM T4 on  T3.U_Modelo = T4.ItemCode 
--WHERE Code  =@Material FOR XML PATH ('')), 1, 0, '') as Modelos
