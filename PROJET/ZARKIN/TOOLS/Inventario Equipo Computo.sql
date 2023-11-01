-- Consulta para Ver Inventarios de Equipos de Computo.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 03 de Octubre del 2023; Origen.


--Despliega Informacion por Equipo.
Select * from Siz_Inventario
Where obsoleto = 1 
Order By numero_equipo

-- Para activar un equipo que se paso a Obsoleto.
Update Siz_Inventario set obsoleto = 1 Where numero_equipo= 92

-- Para Cambiar el ID
Update Siz_Inventario Set numero_equipo = 93 Where nombre_equipo = 'ZARKIN-093'


Select * from Siz_Inventario Where nombre_equipo = 'ZARKIN-093'