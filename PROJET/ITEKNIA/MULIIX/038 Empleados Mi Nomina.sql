-- Consulta para Macro 038 Empleados para Mi Nomina.
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Sabado 06 de Febrero del 2021; Origen.
-- Actualizado: Viernes 03 de enero del 2025; Cambiar a check de Mi Nomina en lugar de Like <> NO NOMINA

-- Parametros.
-- Valido = true

-- Consulta anterior.

Select  EMP_CodigoEmpleado as NUM_NOMINA
        ,  EMP_PrimerApellido + '  ' + EMP_SegundoApellido + ';  ' +  EMP_Nombre as EMPLEADO
        , EMP_CheckNomina
        , EMP_DefinidoPorUsuario1
from Empleados
Where EMP_Activo = 1 and EMP_Comentarios not like '%NO NOMINA%'
--and EMP_CodigoEmpleado = '743' 
Order by EMPLEADO


-- Nueva consulta con Parametro Mi Nomina = 1
Select  EMP_DefinidoPorUsuario1 as NUM_NOMINA
        ,  EMP_PrimerApellido + '  ' + EMP_SegundoApellido + ';  ' +  EMP_Nombre as EMPLEADO
        , EMP_CodigoEmpleado COD_MUL
from Empleados
Where EMP_Activo = 1 and EMP_CheckNomina = 1
Order by EMPLEADO







-- Empleados para APP Embarques


Select  EMP_CodigoEmpleado as NUM_NOMINA
        ,  EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido as EMPLEADO
        , USU_Contrasenia
from Empleados
inner join Usuarios on EMP_EmpleadoId = USU_EMP_EmpleadoId
Where EMP_Activo = 1 and USU_Activo = 1 
Order by EMPLEADO




Select * from Usuarios






