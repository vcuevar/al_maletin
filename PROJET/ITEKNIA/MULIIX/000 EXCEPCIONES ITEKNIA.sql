-- Reporte de Excepciones
-- ITEKNIA EQUIPAMIENTO, S.A. de C.V.
-- Desarrollo: Ing. Vicente Cueva Ramírez
-- Actualizado: 07 de Enero del 2022; Origen.

--Validar Usuario Vigentes y con Empleado NO ACTIVO, Actividad Dar de Baja Usuario.
select '001 DAR BAJA USUARIO' AS REPORTE
        , EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , USU_Contrasenia AS CONTRASEÑA
        , PER_CodigoPermiso AS COD_PERMISO	
        , PER_TipoPermiso AS TIPO_PERMISO
from Usuarios
Inner Join Empleados on EMP_EmpleadoId = USU_EMP_EmpleadoId
Inner Join Permisos on PER_PermisoId = USU_PER_PermisoId
Where EMP_CodigoEmpleado = '002'
--where USU_Activo = 1 and EMP_Activo = 0


select * from empleados where EMP_CodigoEmpleado = '002'
select * from empleados where EMP_EmpleadoId = '3A2D4A67-BB29-493B-BFB1-3A1A03310372' --Este es el 0001 y el 002 es el 75

select * from usuarios where USU_EMP_EmpleadoId = '8EDFC690-978A-4112-B61C-1999CD0C71F5'
select * from usuarios where USU_Nombre = '002'

update Usuarios set USU_EMP_EmpleadoId = '8EDFC690-978A-4112-B61C-1999CD0C71F5' where USU_Nombre = '002'

-- Determinar Materiales que no tienen tiempo de Entrega
Select	ART_CodigoArticulo as CODIGO
        , ART_Nombre as NOMBRE
        , Convert(Decimal(28,2), ART_NoDiasAbastecimiento) AS DIA_ABS   
from Articulos
Where ART_Activo = 1 and (ART_NoDiasAbastecimiento = 0 or ART_NoDiasAbastecimiento is null)



