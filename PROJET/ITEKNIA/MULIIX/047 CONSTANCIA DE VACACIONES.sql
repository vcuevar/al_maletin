-- 047 CONSTANCIA DE VACACIONES.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actuallizado: Lunes 01 de Julio del 2024; Origen.

-- Parámetros 
Declare @Periodo as Integer
Declare @NumEmpl as varchar(30)

Set @Periodo = 2024
--Set @NumEmpl = '00021' -- ABRAHAM.
--Set @NumEmpl = '00806' -- MARIBEL.
Set @NumEmpl = '00047' -- ELIZABETH.

--SELECT * FROM Empleados WHERE EMP_CodigoEmpleado Like Right(@NumEmpl,3)

-- Datos del Empleado.
Select EMP_CodigoEmpleado AS CODIGO
	, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido 
	, Cast(EMP_FechaIngreso as date) AS F_INGRESO
From Empleados 
Where EMP_CodigoEmpleado = @NumEmpl
--Where EMP_CodigoEmpleado Like Right(@NumEmpl,3)

-- Datos del Empleado Cabecera del Reporte.
-- exec SP_RPT_VAC_VACACIONES_XEMPLEADO @NumEmpl Este es el procedimiento almacenado.

SELECT EMP_CodigoEmpleado
	,EMP_FechaIngreso
	,EMP_Nombre
	,EMP_PrimerApellido 
	,EMP_SegundoApellido
	,EMP_anios
	,EMP_anios_decimal
	,CASE
		WHEN COALESCE(EMP_anios, 0) = 0 THEN '0'
		WHEN EMP_anios = 1 THEN '12'
		WHEN EMP_anios = 2 THEN '14'
		WHEN EMP_anios = 3 THEN '16'
		WHEN EMP_anios = 4 THEN '18'
		WHEN EMP_anios = 5 THEN '20'
		WHEN EMP_anios BETWEEN 6 AND 10 THEN '22'
		WHEN EMP_anios BETWEEN 11 AND 15 THEN '24'
		WHEN EMP_anios BETWEEN 16 AND 20 THEN '26'
		WHEN EMP_anios BETWEEN 21 AND 25 THEN '28'
		WHEN EMP_anios BETWEEN 26 AND 30 THEN '30'
		WHEN EMP_anios > 30 THEN '32'
	END VAC_dias_calculo
	,COALESCE(VAC_Derecho, 0) AS VAC_Derecho
	,COALESCE(VAC_tomadas, 0) AS VAC_tomadas	
FROM(

SELECT EMP_CodigoEmpleado --Numero Nomina Empleados.EMP_CodigoEmpleado
	,Empleados.EMP_FechaIngreso--Fecha de Ingreso Empleados.EMP_FechaIngreso
	,Empleados.EMP_Nombre --Nombre Empleados.EMP_Nombre
	,EMP_PrimerApellido --Primer Apellido EMP_PrimerApellido
	,EMP_SegundoApellido--Segundo Apellido EMP_SegundoApellido
	,FLOOR(DATEDIFF(MONTH,  CONVERT(DATE , EMP_FechaIngreso), GetDate()) / 12.0) EMP_anios --Años Cumplidos Fecha de Ingreso al día de hoy, sin decimales.
	,DATEDIFF(MONTH,  CONVERT(DATE , EMP_FechaIngreso), GetDate()) / 12.0 EMP_anios_decimal--Años Proporcional Fecha de Ingreso al día de hoy, con decimales. 
	,SUM(VAC.VAC_Derecho) VAC_Derecho
	,SUM(VAC.VAC_Tomadas) VAC_tomadas
	--Días tomados Registros de forma manual o mediante interfaces.
FROM Empleados
LEFT JOIN RPT_VACACIONES VAC on
 	RIGHT('000' + CONVERT(varchar, VAC.VAC_EMP_EmpleadoId), 4) = RIGHT('000' + CONVERT(varchar, EMP_CodigoEmpleado), 4)
	AND VAC.VAC_Eliminado = 0
WHERE RIGHT('000' + CONVERT(varchar, EMP_CodigoEmpleado), 4) = RIGHT('000' +  @NumEmpl, 4)
GROUP BY EMP_CodigoEmpleado, EMP_FechaIngreso, EMP_Nombre, EMP_PrimerApellido, EMP_SegundoApellido
) RS


-- Kardex a partir del perido especifico.
exec SP_RPT_VAC_VACACIONES_KARDEX_XANIO @NumEmpl, @Periodo







