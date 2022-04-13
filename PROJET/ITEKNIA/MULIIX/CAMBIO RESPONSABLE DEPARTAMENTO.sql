-- METODO PARA ASIGNAR NUEVO RESPONSABLE A DEPARTAMENTO



Select * from Empleados
where EMP_CodigoEmpleado like '%810%'

-- 083 MAURICIO HARO ID:  0294469F-B440-4053-B768-33D74725789B
-- 055 EDUARDO MACIAS ID: 12ECA1A3-0C27-44B8-B898-93BABCADD30F


-- Para cambiar Encargado de Departamento
Select * from Departamentos
Where DEP_Codigo like '105%'

--Update Departamentos set DEP_EMP_EncargadoId =  '12ECA1A3-0C27-44B8-B898-93BABCADD30F'
--Where DEP_DeptoId = 'FAF1D496-EECE-4840-8820-C35BADBBEE61'




Update Empleados set EMP_Activo = 1, EMP_Eliminado = 0 Where EMP_EmpleadoId = 'F9173217-E60C-4194-A046-BF934D22F5B0'
