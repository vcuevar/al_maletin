-- Consulta para cargar Alerta de Lineas duplicadas en LDM
-- Solicito: Jorge Ortiz (Diseño).
-- Fecha: Lunes 13 de Agosto del 2018; Origen.
-- Realizo: Ing. Vicente Cueva
-- Actualizado: Martes 14 de Agosto del 2018




Select T0.Father, T0.Code  from ITT1 T0
where T0.Father = '3738-03-P0806'



SELECT ITT1.Father as PT, o1.ItemName as Modelo, ITT1.Code as Codigo, o2.ItemName as Descripcion, count(Code) as repetido
from dbo.ITT1
left join OITM o1 on o1.ItemCode = Father
left join OITM o2 on o2.ItemCode = Code
group by Father, Code, o1.ItemName, o2.ItemName
having count(Code) > 1