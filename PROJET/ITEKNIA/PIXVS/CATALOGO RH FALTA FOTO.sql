
-- Para ver cual Empleado le falta Fotografia.
Select 	EMP_CodigoEmpleado AS CODIGO,
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		EMP_Fotografia,
		EMP_Activo,
		EMP_Eliminado
from Empleados
Where EMP_FechaEgreso is null and EMP_Eliminado = 0 and EMP_Activo = 1
Order by NOMBRE


Select 	EMP_CodigoEmpleado AS CODIGO,
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		SEX.CMM_Valor AS SEXO,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO,
		ISNULL (PUE_NombrePuesto, 'SIN PUESTO...') AS PUESTO,
		(EMP_Calle + ' No. ' + EMP_NoExterior + ' - ' + EMP_NoInterior) AS DOMICILIO,
		EMP_CodigoPostal AS CP,
		CIUC_Nombre AS COLONIA,
		CIU_Nombre AS CIUDAD,
		EST_Nombre AS ESTADO,
		PAI_Nombre AS PAIS,
		EMP_CorreoElectronico AS CORREO,
		EMP_TelefonoCelular AS TEL_CEL,
		EMP_TelefonoCasa AS TEL_CAS,
		TSAN.CMM_Valor AS T_SANG,
		EMP_ContactoEmergencias AS NOM_CONT,
		EMP_TelefonoContacto AS TEL_CONT,
		EMP_RelacionContacto AS PAR_CONT,
		Cast(EMP_FechaNacimiento AS DATE) AS F_NAC,
		EMP_NSS AS N_IMSS,
		EMP_RFC AS RFC,
		EMP_CURP AS CURP,
		Cast(EMP_FechaIngreso AS DATE) AS F_ALTA,
		Cast(EMP_FechaEgreso AS DATE) AS F_EGRE
from Empleados
left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId
left join Puestos	on PUE_PuestoId = EMP_PUE_PuestoId
inner join ControlesMaestrosMultiples SEX on SEX.CMM_ControlId = EMP_CMM_SexoId
inner join CiudadesColonias on CIUC_Coloniaid = EMP_Colonia
inner join Ciudades on CIU_CiudadId = EMP_CIU_CiudadId
inner join Estados on EST_EstadoId = EMP_EST_EstadoId
inner join Paises on PAI_PaisId = EMP_PAI_PaisId
inner join ControlesMaestrosMultiples TSAN on TSAN.CMM_ControlId = EMP_CMM_TipoSanguineoId
--Where EMP_FechaEgreso is null --and EMP_Eliminado = 0 and EMP_Activo = 1
Order by NOMBRE


