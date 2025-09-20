-- Inventario de Equipo para realizar Mantenimiento
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 16 de Junio del 2021; Origen.
-- Actualizado: Viernes 22 de agosto del 2025; Para Actualizar.

--Relacion de Equipos para programa de Mantinimiento.

SELECT numero_equipo AS ID
		, nombre_equipo AS CODIGO
		, (marca + '  ' + modelo+ '  ' + procesador) AS EQUIPO
		, nombre_usuario AS ASIGNADO
		, ubicacion AS UBICADO
		, area AS AREA
		, correo AS EMAIL
		, tipo_equipo AS TIPO
		, so AS OS
		, ofimatica AS OFFICE_LIC
FROM Siz_Inventario
where obsoleto = 1

--Update Siz_Inventario set obsoleto = 1 Where numero_equipo = 92