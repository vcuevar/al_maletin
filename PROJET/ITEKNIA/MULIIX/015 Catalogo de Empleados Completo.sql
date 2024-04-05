

-- Consulta para Reporte No. 015 Catalogo de Empleados Completo.
-- Actualizado: al 30 de Marzo del 2020.


Select	EMP_CodigoEmpleado AS CODIGO, 
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE, 
		(Case When EMP_CMM_SexoId = '0BFD0EF6-5B78-4909-9CD2-6368288ECF41' then
		'FEMENINO' Else 'MASCULINO' End) AS SEXO, 
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, 
		ISNULL (PUE_NombrePuesto, 'SIN PUESTO...') AS PUESTO, 
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
		EMP_FechaNacimiento AS F_NAC,
		EMP_NSS AS N_IMSS, 
		EMP_RFC AS RFC, 
		EMP_CURP AS CURP, 
		EMP_FechaIngreso AS F_ALTA 
from Empleados 
left join Departamentos on  EMP_DEP_DeptoId = DEP_DeptoId 
left join Puestos on PUE_PuestoId = EMP_PUE_PuestoId 
left join Ciudades on CIU_CiudadId = EMP_CIU_CiudadId 
left join Estados on EMP_EST_EstadoId = EST_EstadoId  
left join Paises on EMP_PAI_PaisId = PAI_PaisId  
left join ControlesMaestrosMultiples TSAN on TSAN.CMM_ControlId = EMP_CMM_TipoSanguineoId 
Where EMP_FechaEgreso is null 
Order by NOMBRE


-- Base de Datos de Usuarios
Select * from Empleados -- Where EMP_CodigoEmpleado = '0836'
Where EMP_CMM_TipoEmpleadoId <> 'E646B375-C7AD-494E-8F6B-8BDF540DBEEB' Diferente Tipo Virtual

select top (10) * from Usuarios  Where USU_Nombre = '788'

Select top (10) * from Permisos

--Generar esto para Excepcioones de ITK
select EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , USU_Contrasenia AS CONTRASEÑA
        , PER_CodigoPermiso AS COD_PERMISO	
        , PER_TipoPermiso AS TIPO_PERMISO
from Usuarios
Inner Join Empleados on EMP_EmpleadoId = USU_EMP_EmpleadoId
Inner Join Permisos on PER_PermisoId = USU_PER_PermisoId
--where USU_Activo = 1 and EMP_Activo = 0
where EMP_CodigoEmpleado like '%10%'
order by EMP_CodigoEmpleado

