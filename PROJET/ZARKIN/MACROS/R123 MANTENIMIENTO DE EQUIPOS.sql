-- Inventario de Equipo para realizar Mantenimiento
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 16 de Junio del 2021; Origen.

--Relacion de Equipos para programa de Mantinimiento.

SELECT numero_equipo AS ID
		, nombre_equipo AS CODIGO
		, (marca + '  ' + modelo+ '  ' + procesador) AS EQUIPO
		, nombre_usuario AS ASIGNADO
		, area AS AREA
		, correo AS EMAIL
		, tipo_equipo AS TIPO
		, Cast(Fecha_mantenimiento as date) AS ULTIMO_MTTO
		, Cast(Fecha_mttoProgramado as date) AS PROX_MTTO
FROM Siz_Inventario


