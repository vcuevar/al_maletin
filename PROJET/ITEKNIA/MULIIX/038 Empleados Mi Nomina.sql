-- Consulta para Macro 038 Empleados para Mi Nomina.
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Sabado 06 de Febrero del 2021; Origen.

-- Parametros.
-- Valido = true

-- Consulta

Select  EMP_CodigoEmpleado as NUM_NOMINA
        ,  EMP_PrimerApellido + '  ' + EMP_SegundoApellido + ';  ' +  EMP_Nombre as EMPLEADO
from Empleados
Where EMP_Activo = 1 and EMP_Comentarios not like '%NO NOMINA%' 
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