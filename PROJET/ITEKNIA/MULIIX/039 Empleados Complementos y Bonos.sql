-- Consulta para Macro 039 Empleados para Bonos y Complementeos de Nomina.
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 12 de Marzo del 2021; Origen.
-- Actualizado: Martes 23 de Marzo del 2021; Agregar Empresas Azaret, Metalmex.

-- Parametros.
-- Valido = true

-- Consulta

Select  (Case When DEP_Nombre = 'AZARET' then 'Z' 
        When DEP_Nombre = 'METALMEX' then 'M' else (
        Case When CMM_Valor = 'Producción' then 'P' else 'A' end) end) as ID
        
        , EMP_CodigoEmpleado as NUM_NOMINA
        , EMP_PrimerApellido + '  ' + EMP_SegundoApellido + ';  ' +  EMP_Nombre as EMPLEADO
        , DEP_Nombre
from Empleados
inner join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId
inner join ControlesMaestrosMultiples on CMM_ControlId = DEP_CMM_TipoDeptoId
Where EMP_Activo = 1 and EMP_Comentarios not like '%NO NOMINA%' 
Order by EMPLEADO



Select * from Usuarios
Where --USU_Nombre = '005'
 USU_PER_PermisoId = 'EBEF7BB0-784C-45E6-9876-327B3360FF67' and USU_Activo = 1


823
