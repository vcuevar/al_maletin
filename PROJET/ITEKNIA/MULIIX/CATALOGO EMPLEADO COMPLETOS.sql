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
Where USU_Nombre = '972'

Select * From Permisos
Where PER_PermisoId  = 'AA46530F-DD30-4014-873B-E8A571B06472'	--DIRECCION

836, 0836, 00836 = reymar200116 Jazzmin Reynso
118 = reymar200116 Alfredo para que use Jazz para vallarta.



 USU_PER_PermisoId = 'EBEF7BB0-784C-45E6-9876-327B3360FF67' and USU_Activo = 1


823


Select  EMP_EmpleadoId AS EMP_IDI_IdiomaId 
		, EMP_CodigoEmpleado as NUM_NOMINA
        , EMP_PrimerApellido + '  ' + EMP_SegundoApellido + ';  ' +  EMP_Nombre as EMPLEADO
        --, DEP_Nombre AS DEPTO
        --, EMP_Activo AS ACTIVO
        --, EMP_FechaEgreso AS BAJA
        --, EMP_Eliminado AS ELIMINADO
from Empleados
--inner join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId
--inner join ControlesMaestrosMultiples on CMM_ControlId = DEP_CMM_TipoDeptoId
Where EMP_Activo = 1 and EMP_Eliminado = 0 
Order by EMP_CodigoEmpleado


Select *
from Empleados
inner join AlmacenDigitalCHIndice on EMP_EmpleadoId = ADCH_EMP_EmpleadoID
--Where EMP_Eliminado = 0 and EMP_CodigoEmpleado = '788'
Where EMP_CodigoEmpleado = '777'
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

Cambio para que solo sean numeros
UPDATE Empleados SET EMP_CodigoEmpleado = '020' WHERE EMP_EmpleadoId = '3354345E-E15A-451D-8D2F-BAF9087AECAC'
UPDATE Empleados SET EMP_CodigoEmpleado = '022' WHERE EMP_EmpleadoId = '0D467F3F-36A3-46C6-8F5D-298F0C70BC9F'
UPDATE Empleados SET EMP_CodigoEmpleado = '027' WHERE EMP_EmpleadoId = '503849DB-460E-4997-9963-EBF5D4C1FE2D'
UPDATE Empleados SET EMP_CodigoEmpleado = '028' WHERE EMP_EmpleadoId = 'ADBB7EAB-06C8-4888-A71E-718A86A4FFDC'
UPDATE Empleados SET EMP_CodigoEmpleado = '029' WHERE EMP_EmpleadoId = '0915CA90-451A-44DC-8EC4-388FB9BB9417'
UPDATE Empleados SET EMP_CodigoEmpleado = '031' WHERE EMP_EmpleadoId = '8396B115-A8E2-4B8E-A0CE-E49595B5D5BF'
UPDATE Empleados SET EMP_CodigoEmpleado = '039' WHERE EMP_EmpleadoId = '569224F9-796B-40C2-8709-8C45B136DF62'
UPDATE Empleados SET EMP_CodigoEmpleado = '045' WHERE EMP_EmpleadoId = '77541B19-14C7-48F8-8065-B39AD7EF3D29'
UPDATE Empleados SET EMP_CodigoEmpleado = '049' WHERE EMP_EmpleadoId = '45051216-D2E3-4E0C-B6AC-F5C901688AA3'
UPDATE Empleados SET EMP_CodigoEmpleado = '051' WHERE EMP_EmpleadoId = 'C2AF7E33-3723-4CD1-8A32-6BC7690FEBC2'
UPDATE Empleados SET EMP_CodigoEmpleado = '054' WHERE EMP_EmpleadoId = 'E7C1FF96-2C37-47CC-83CF-8B5837E40B20'
UPDATE Empleados SET EMP_CodigoEmpleado = '056' WHERE EMP_EmpleadoId = 'B9A76EB1-128D-4E57-8C3E-AD3A639D6450'
UPDATE Empleados SET EMP_CodigoEmpleado = '057' WHERE EMP_EmpleadoId = 'CE52F7ED-0D2A-4EAF-94B0-C277AC9440B7'


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


-- Carga de fechas de Vencimiento de los INE
-- Actualizados al 11 de diciembre del 2024.

Select EMP_EmpleadoId
	, EMP_CodigoEmpleado 
	, EMP_Nombre
	, ADCH_INEValido
from AlmacenDigitalCHIndice
inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID
Where EMP_CodigoEmpleado = '381'


Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '381'

Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '055'



Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1018'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '992'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '976'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '771'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '211'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '981'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '978'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '977'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2025-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '14'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1023'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2034-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1010'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '784'

Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2026-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '372'

Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '988'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '823'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '831'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1007'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2026-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1002'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '044'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1005'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '283'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '753'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2030-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '076'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '919'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '363'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '838'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '093'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '169'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2026-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '041'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2030-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '880'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '270'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '822'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '830'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '766'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '806'

Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '047'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '173'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '749'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '741'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '999'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '021'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '811'

Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '998'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '765'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '965'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2026-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '755'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '768'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '079'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2026-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '023'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '796'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2026-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '037'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '757'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '33'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '005'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '836'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '013'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '756'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2023-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '365'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '990'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2025-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '391'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '110'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2031-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '015'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '118'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '026'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '244'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2030-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '947'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '905'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '951'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2034-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '948'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '067'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2027-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '916'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '761'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2030-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '235'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2032-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '762'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '922'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2025-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '926'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2034-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '904'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2029-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '808'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '989'

Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2028-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '972'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2024-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1022'
Update AlmacenDigitalCHIndice Set ADCH_INEValido = Cast('2033-12-31' as date) from AlmacenDigitalCHIndice inner join Empleados  on EMP_EmpleadoId = ADCH_EMP_EmpleadoID Where EMP_CodigoEmpleado = '1017'


