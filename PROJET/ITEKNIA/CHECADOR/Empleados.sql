--Reporte de Tiempos del Reloj Checador.
-- Actualizado al 9 de Agosto del 2023; Origen

Declare @FechaIni nvarchar(30)
Declare @FechaFin nvarchar(30)

Set @FechaIni = CONVERT (DATE, '2023/08/07', 102)
--Set @FechaFin = CONVERT (DATE, '2023/08/07', 102)
Set @FechaFin = (SELECT DATEADD(dd, +7, @FechaIni))

Select pe.emp_code AS NOMINA
	, pe.first_name + '  ' + pe.last_name  AS NOMBRE
	, convert(varchar,it.punch_time ,6) AS FECHA
	, convert(varchar,it.punch_time ,8) AS HORA
	
	-- si es checada antes igual de 8:00 Llegada a Tiempo
	-- si es checada despues de 8:00 a 8:14 Retardo en 15
	-- si es checada despues de 8:15 Retardo mas 15
	
	-- si es checada entre
	
	-- si es checada despues de 17:59 y antes de las 18:59 Salida en Tiempo
	-- si es checada despues de 18:59 Tiempo Extra
	
	--Validar su calendario de incidencias para definir si hay motivo para la llegada tarde.
	
from personnel_employee pe 
inner join iclock_transaction it on it.emp_code = pe.emp_code 
Where Cast(it.punch_time as date) Between @FechaIni and @FechaFin   
Order by pe.emp_code, it.punch_time 



