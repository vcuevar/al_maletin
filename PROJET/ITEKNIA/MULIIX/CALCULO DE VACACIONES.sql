-- Calculo de Vacaciones Correrspondientes por Años Cumplidos.
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Jueves 15 de Septiembre del 2022.

Select EMP_EmpleadoId AS ID
        , EMP_CodigoEmpleado AS CODIGO
	, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE
        , (Case When EMP_CMM_SexoId = '0BFD0EF6-5B78-4909-9CD2-6368288ECF41' then
	'FEMENINO' Else 'MASCULINO' End) AS SEXO
	, Cast(EMP_FechaIngreso as date) AS F_INGRESO 
	, DATEDIFF(year, EMP_FechaIngreso, GETDATE()) AS SERVICIO
	
	, Case 
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 1 then 0
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 1 then 6
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 2 then 8
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 3 then 10
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 4 then 12
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 4 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 10 then 14
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 9 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 15 then 16
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 14 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 20 then 18
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 19 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 25 then 20
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 24 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 30 then 22
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 29 then 24
	End as VACACIONES	
from Empleados 
Where EMP_FechaEgreso is null and EMP_Activo = 1
Order by NOMBRE


-- Base de Datos de Usuarios
--Select top (10) * from Empleados

--select top (10) * from Usuarios  Where USU_Nombre = '836'

-- Select top (10) * from Permisos
/*
                        1 año	– 	 6 días.
			2 años 	–	 8 días.
			3 años 	– 	10 días.
			4 años 	– 	12 días.
			5 a 9 años – 	14 días.
			10 a 14 años – 	16 días.
			15 a 19 años – 	18 días.
			20 a 24 años – 	20 días.
			
*/