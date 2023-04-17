

select	EMP_EmpleadoId AS CODIGO,
		USU_Nombre AS USUARIO,
		EMP_Activo AS VALIDO,
		EMP_Nombre AS NOMBRE,
		EMP_PrimerApellido AS PRIM_APELL,
		EMP_SegundoApellido AS SEGU_APELL,
		DEP_Nombre		
from Usuarios
inner join Empleados on USU_EMP_EmpleadoId = EMP_EmpleadoId
left join Departamentos on EMP_DEP_DeptoId = DEP_DeptoId
Where EMP_Activo = 1