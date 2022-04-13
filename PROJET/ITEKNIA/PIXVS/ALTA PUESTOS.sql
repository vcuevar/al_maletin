

/* select * from Puestos
PUE_PuestoId	uniqueidentifier	Unchecked
PUE_Codigo	nvarchar(10)	Unchecked
PUE_Nombre	nvarchar(50)	Checked
PUE_Descripcion	nvarchar(255)	Checked
PUE_CMM_CRH_TasaPago	uniqueidentifier	Checked
		Unchecked
*/

INSERT INTO [dbo].[Puestos]
           ([PUE_PuestoId]
           ,[PUE_Codigo]
           ,[PUE_Nombre]
           ,[PUE_Descripcion])
     VALUES
          -- (NEWID(),'1','ANALISTA COTIZACIONES','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'2','AUXILIAR ADMINISTRATIVO','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'3','COORDINADOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'4','ENCARGADO DE AREA','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'5','GERENTE','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'6','SUPERVISOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'7','ALMACENISTA','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'8','AUXILIAR PRODUCCION','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'9','CARPINTERO','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'10','CHOFER','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'11','CORTADOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'12','COSTURERO','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'13','DISEÑADOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'14','INTENDENTE','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'15','LAQUEADOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'16','PREPARADOR CASCO','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'17','PULIDOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'18','SOLDADOR','EMPLEADO ADMINISTRATIVO'),
           (NEWID(),'19','TAPICERO','EMPLEADO ADMINISTRATIVO')
GO







