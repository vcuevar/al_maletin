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
Where USU_Nombre = '836'
 USU_PER_PermisoId = 'EBEF7BB0-784C-45E6-9876-327B3360FF67' and USU_Activo = 1


823


Select  EMP_EmpleadoId AS EMP_IDI_IdiomaId 
		, EMP_CodigoEmpleado as NUM_NOMINA
        , EMP_PrimerApellido + '  ' + EMP_SegundoApellido + ';  ' +  EMP_Nombre as EMPLEADO
        --, DEP_Nombre AS DEPTO
        , EMP_Activo AS ACTIVO
        , EMP_FechaEgreso AS BAJA
        , EMP_Eliminado AS ELIMINADO
        
from Empleados
--inner join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId
--inner join ControlesMaestrosMultiples on CMM_ControlId = DEP_CMM_TipoDeptoId
Where EMP_Activo = 0 and EMP_Eliminado = 0 
Order by EMP_CodigoEmpleado


Select *
from Empleados
--inner join AlmacenDigitalCHIndice on EMP_EmpleadoId = ADCH_EMP_EmpeadoID
--Where EMP_Eliminado = 0 and EMP_CodigoEmpleado = '788'
Where EMP_CodigoEmpleado = '013'
Order by EMP_CodigoEmpleado

select * from AlmacenDigitalCHIndice 


UPDATE Empleados SET EMP_CodigoEmpleado = '004' WHERE EMP_EmpleadoId = 'D3D607F5-DC0C-4A0A-840C-755EB17D2B6D'

UPDATE Empleados SET EMP_CodigoEmpleado = '009' WHERE EMP_EmpleadoId = '18B102D7-6E59-435D-917D-A4ACB046B8F1'

UPDATE Empleados SET EMP_CodigoEmpleado = '019' WHERE EMP_EmpleadoId = 'D4F1B0CB-6CAA-4942-BED8-7A06855CF87E'

UPDATE Empleados SET EMP_CodigoEmpleado = '011' WHERE EMP_EmpleadoId = '43851227-0436-4190-A056-40229CE0A539'
UPDATE Empleados SET EMP_CodigoEmpleado = '208' WHERE EMP_EmpleadoId = 'B542BED9-13B3-4A5B-A592-20FEDA461FF6'
UPDATE Empleados SET EMP_CodigoEmpleado = '732' WHERE EMP_EmpleadoId = 'B5711313-04AC-4D2F-8C9A-CB2C2B7C5628'
UPDATE Empleados SET EMP_CodigoEmpleado = '733' WHERE EMP_EmpleadoId = 'BFE9BA77-D607-4579-A948-83E3B39A47C8'
UPDATE Empleados SET EMP_CodigoEmpleado = '734' WHERE EMP_EmpleadoId = '42C43BA1-B2DB-4FEF-8A39-6036B1BF5CC4'

UPDATE Empleados SET EMP_CodigoEmpleado = '025' WHERE EMP_EmpleadoId = '611E469E-BD69-47B6-B5CE-7D8FC0153B3A'

UPDATE Empleados SET EMP_CodigoEmpleado = '735' WHERE EMP_EmpleadoId = '072BB403-2576-4F38-926F-A9C0C5E1B185'
UPDATE Empleados SET EMP_CodigoEmpleado = '736' WHERE EMP_EmpleadoId = '7101E652-CE68-4088-B46B-D4CF7A7A6F76'




-- Generar Reporte de Hijos con respectivas edades.

Select  EMP_CodigoEmpleado AS NUM_NOMINA
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS EMPLEADO
        , FAM_NombreFamiliar AS FAMILIAR
        , CMM_Valor AS PARIENTE
        , Cast(FAM_FechaNacimiento as date) AS F_NACIM  
        , DATEDIFF(YEAR, FAM_FechaNacimiento, GETDATE()) AS EDAD
from Empleados
inner join RPT_EmpleadoFamiliares on FAM_EMP_EmpleadoId = EMP_EmpleadoId and FAM_Eliminado = 0
inner join ControlesMaestrosMultiples on CMM_ControlId = FAM_CMM_ParentescoId
Where EMP_Activo = 1 and EMP_Eliminado = 0 
Order by EMPLEADO 


