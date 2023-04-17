select EMP_Nombre, EMP_PrimerApellido, * from Transferencias
inner join Empleados on TRA_EMP_ModificadoPor = EMP_EmpleadoId

where TRA_CodigoTransferencia = 'TR1519'


select * from Localidades

--select * from Empleados


select EMP_Nombre, EMP_PrimerApellido, * from Articulos
inner join Empleados on ART_EMP_ModificadoPor = EMP_EmpleadoId
where ART_CodigoArticulo = '0310'