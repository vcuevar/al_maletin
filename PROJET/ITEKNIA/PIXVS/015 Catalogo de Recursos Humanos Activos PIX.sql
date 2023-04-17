-- PIXVS Consulta para Reporte de Recursos Humanos.
-- Ing. Vicente Cueva R.
-- Sabado 09 de Junio del 2018

--Cuenta de Empleados Activos
--Select Count(EMP_EmpleadoId)AS TOT_ACTIVOS from Empleados
--Where EMP_FechaEgreso is null

--Detalle de Catalogo de Empleados PIXVS
Select 	EMP_CodigoEmpleado AS CODIGO,
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO,
		ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO,
		EMP_Sexo AS SEXO,
		(EMP_Calle + ' No. ' + EMP_NoExterior + ' - ' + EMP_NoInterior) AS DOMICILIO,
		EMP_CodigoPostal AS CP,
		EMP_Colonia AS COLONIA,
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
left join Departamentos	on  EMP_DEP_DeptoId= DEP_DeptoId 
left join Puestos on PUE_PuestoId = EMP_PUE_PuestoId
left join Ciudades on CIU_CiudadId= EMP_CIU_CiudadId
left join Estados on EMP_EST_EstadoId= EST_EstadoId 
left join Paises on EMP_PAI_PaisId = PAI_PaisId 
left join ControlesMaestrosMultiples TSAN on TSAN.CMM_ControllId = EMP_CMM_TipoSanguineoId
Where --EMP_FechaEgreso is NOT null and 
EMP_Activo = 1 
--and EMP_Nombre like '%EDUA%'
Order by NOMBRE

-- Para Montar en Macro.
--Select EMP_CodigoEmpleado AS CODIGO, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE, EMP_Sexo AS SEXO, ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO, (EMP_Calle + ' No. ' + EMP_NoExterior + ' - ' + EMP_NoInterior) AS DOMICILIO, EMP_CodigoPostal AS CP, EMP_Colonia AS COLONIA, CIU_Nombre AS CIUDAD, EST_Nombre AS ESTADO, PAI_Nombre AS PAIS, EMP_CorreoElectronico AS CORREO, EMP_TelefonoCelular AS TEL_CEL, EMP_TelefonoCasa AS TEL_CAS, TSAN.CMM_Valor AS T_SANG, EMP_ContactoEmergencias AS NOM_CONT, EMP_TelefonoContacto AS TEL_CONT, EMP_RelacionContacto AS PAR_CONT, Cast(EMP_FechaNacimiento AS DATE) AS F_NAC,
--EMP_NSS AS N_IMSS, EMP_RFC AS RFC, EMP_CURP AS CURP, Cast(EMP_FechaIngreso AS DATE) AS F_ALTA from Empleados left join Departamentos	on  EMP_DEP_DeptoId= DEP_DeptoId left join Puestos on PUE_PuestoId = EMP_PUE_PuestoId left join Ciudades on CIU_CiudadId= EMP_CIU_CiudadId left join Estados on EMP_EST_EstadoId= EST_EstadoId  left join Paises on EMP_PAI_PaisId = PAI_PaisId  left join ControlesMaestrosMultiples TSAN on TSAN.CMM_ControllId = EMP_CMM_TipoSanguineoId Where EMP_FechaEgreso is null Order by DEPARTAMENTO, PUESTO, NOMBRE


--Select * from Empleados
--where EMP_CodigoEmpleado = 'PIXVS'


-- Catalogo de Usuarios vigentes en PIXVS 31 Julio del 2019

select * from Empleados

select	EMP_CodigoEmpleado AS N_NOMINA,
		EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido as NOMBRE,
		EMP_Activo as ACTIVO,
		USU_Nombre as USUARIO,
		(Select DEP_Nombre from Departamentos where EMP_DEP_DeptoId = DEP_DeptoId) as DEPTO,
		(Select PUE_Nombre from Puestos Where EMP_PUE_PuestoId = PUE_PuestoId) as PUESTO
from Usuarios
inner join Empleados on USU_EMP_EmpleadoId = EMP_EmpleadoId
where USU_Activo = 1 and EMP_Activo = 1
and EMP_FechaEgreso is null
order by EMP_CodigoEmpleado






