-- MULIIX Macro 009 Consulta para Reporte de Recursos Humanos.
-- Ing. Vicente Cueva R.
-- Viernes 08 de Junio del 2018

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
		Cast(EMP_FechaIngreso AS DATE) AS F_ALTA
from Empleados
left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId
left join Puestos	on PUE_PuestoId = EMP_PUE_PuestoId
inner join ControlesMaestrosMultiples SEX on SEX.CMM_ControlId = EMP_CMM_SexoId
inner join CiudadesColonias on CIUC_Coloniaid = EMP_Colonia
inner join Ciudades on CIU_CiudadId = EMP_CIU_CiudadId
inner join Estados on EST_EstadoId = EMP_EST_EstadoId
inner join Paises on PAI_PaisId = EMP_PAI_PaisId
inner join ControlesMaestrosMultiples TSAN on TSAN.CMM_ControlId = EMP_CMM_TipoSanguineoId
Where EMP_FechaEgreso is null
Order by DEPARTAMENTO, PUESTO, NOMBRE

-- Consulta para los empleado dados de baja.
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
		Cast(EMP_FechaEgreso AS DATE) AS F_BAJA
from Empleados
left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId
left join Puestos	on PUE_PuestoId = EMP_PUE_PuestoId
inner join ControlesMaestrosMultiples SEX on SEX.CMM_ControlId = EMP_CMM_SexoId
inner join CiudadesColonias on CIUC_Coloniaid = EMP_Colonia
inner join Ciudades on CIU_CiudadId = EMP_CIU_CiudadId
inner join Estados on EST_EstadoId = EMP_EST_EstadoId
inner join Paises on PAI_PaisId = EMP_PAI_PaisId
inner join ControlesMaestrosMultiples TSAN on TSAN.CMM_ControlId = EMP_CMM_TipoSanguineoId
Where EMP_FechaEgreso is not null
Order by DEPARTAMENTO, PUESTO, NOMBRE


Select 	EMP_CodigoEmpleado AS CODIGO,
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO,
		ISNULL (PUE_NombrePuesto, 'SIN PUESTO...') AS PUESTO,
		Cast(EMP_FechaEgreso AS DATE) as FEC_BAJA,
		EMP_Activo as ESTATUS,
		ISNULL (EMP_Fotografia, 'SIN FOTO') as FOTO
		, Empleados.*
from Empleados
left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId
left join Puestos	on PUE_PuestoId = EMP_PUE_PuestoId
where EMP_Eliminado = 0 and EMP_CodigoEmpleado = '972'
Order by DEPARTAMENTO, PUESTO, NOMBRE

Select * from Usuarios
Where USU_Nombre = '803'



Select 	EMP_CodigoEmpleado AS CODIGO,
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO
from Empleados
left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId
where EMP_Eliminado = 0 and EMP_LIP_LineaProduccionId = '3FFD5508-8EA0-4577-A405-5B2BBE2A449A'

3FFD5508-8EA0-4577-A405-5B2BBE2A449A


-- Script para Macro 13 de Julio del 2019.
--Select 	EMP_CodigoEmpleado AS CODIGO, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE, ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, ISNULL (PUE_NombrePuesto, 'SIN PUESTO...') AS PUESTO, Cast(EMP_FechaEgreso AS DATE) as FEC_BAJA, EMP_Activo as ESTATUS, ISNULL (EMP_Fotografia, 'SIN FOTO') as FOTO from Empleados left join Departamentos	on DEP_DeptoId = EMP_DEP_DeptoId left join Puestos	on PUE_PuestoId = EMP_PUE_PuestoId where EMP_Eliminado = 0 Order by DEPARTAMENTO, PUESTO, NOMBRE


--Select 	EMP_CodigoEmpleado AS CODIGO,
--		(EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS NOMBRE,
--		 EMP_EmpleadoId
--		 ,*
--from Empleados
--Where EMP_DEP_SucursalId <> '3E0B577E-B731-40DD-BAE0-D1CE37D5F9DA'
--Where EMP_DEP_SucursalId is null
--where EMP_CodigoEmpleado = '0001'


--Se puso sucursal GDL a
--	13 nulos
--	465 que tenial otra Sucursal
--	16 No se modificaron (OK)

--update Empleados set EMP_Corporativo = 1
--Where EMP_Corporativo <> 1



--0001	Admin Admin Admin	3A2D4A67-BB29-493B-BFB1-3A1A03310372
-- 123	Omar Anaya Barajas	0614CE61-3DB7-4A94-97F2-6262C650953E
-- 0007	VICENTE CUEVA RAMIREZ	6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1
-- 015	MARTIN  ESTRADA  GALVAN	D02A4BE7-B411-42A1-985D-A4EBAC9AB70B
-- 083	MAURICIO HARO GONZALEZ	0294469F-B440-4053-B768-33D74725789B
-- 118	ALFREDO BEJARANO VERA	F668B68E-41B5-442D-BC20-AF4D4A1CD3F6
-- 996	GILBERTO CRUZ RAMIREZ	5A1ACD8A-A18D-4AC7-942F-F5326E1C50AF