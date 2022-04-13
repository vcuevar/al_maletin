-- Consulta para Reporte de Recursos Humanos.
-- Ing. Vicente Cueva R.
-- Jueves 26 de Abril del 2018

Select 	EMP_CodigoEmpleado AS CODIGO,
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO,
		ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO,
		EMP_FechaEgreso AS ESTATUS
from Empleados
left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId
left join Puestos	on PUE_PuestoId = EMP_PUE_PuestoId
Where EMP_FechaEgreso is null
Order by DEPARTAMENTO, PUESTO, NOMBRE
