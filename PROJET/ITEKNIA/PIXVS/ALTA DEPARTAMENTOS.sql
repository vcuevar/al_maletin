INSERT INTO [dbo].[Departamentos]
           ([DEP_DeptoId]
           ,[DEP_Codigo]
           ,[DEP_Nombre]
           ,[DEP_EMP_Responsable])
     VALUES
           (NEWID()
           ,'3' -- Agregar el codigo del departamento tiene que ser único
           ,'DISEÑO' -- Agregar el nombre del departamento.
           ,'C3F53904-B68B-4F2C-B264-59190667A4B9') ,-- id ING. EDUARDO de la tabla de empleados de la persona encargada del departamento)

		(NEWID(), '4' ,'PLANEACION Y COSTOS', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '5' ,'SERVICIO A CLIENTES', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '6' ,'PRODUCCION', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '7' ,'COMPRAS', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '8' ,'METALES', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '9' ,'DIRECCION', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '10' ,'CENTRO DE SERVICIO VTA.', 'C3F53904-B68B-4F2C-B264-59190667A4B9'),
		(NEWID(), '11' ,'TECN. DE LA INFORMACION', 'C3F53904-B68B-4F2C-B264-59190667A4B9')
GO
