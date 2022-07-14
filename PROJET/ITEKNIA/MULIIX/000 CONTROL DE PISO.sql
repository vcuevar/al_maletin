-- Consultas Para el Control de Piso
-- Desarrollada: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 03 de Mayo del 2022; Origen.

-- NOTA: SOBRE UN REGISTRO 330 ENSAMBLES
-- Se realizo un cambio en la tabla de los centros de trabajo ya que en la vista de Estructura Operacional no se visualiza para
-- eliminar el centro de trabajo 330 ENSAMBLES que no debe existir.
-- Select * from CentrosTrabajo Where CET_CentroTrabajoId = 'D1D432B1-91D2-2C95-0345-FC83B1DB043E'
-- Update CentrosTrabajo Set CET_Activo = 0, CET_Borrado = 1 Where CET_CentroTrabajoId = 'D1D432B1-91D2-2C95-0345-FC83B1DB043E'

-- OT:02410
-- Articulo: 1174.4-07
-- Descripcion: FUNDA COJIN ASIENTO
-- Fecha: 03/MAY/2022 

--Parametros
Declare @CodeOT as nvarchar(30)
Declare @Id_ART as uniqueidentifier
Declare @CatiOT as Int

Set @CodeOT = 'OT02410'

-- Selecciona el Articulo de acuerdo a la Orden de Trabajo
Set @Id_ART = (Select OTDA_ART_ArticuloId
From OrdenesTrabajo
Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
--Inner Join RPT_Seguimiento_OTI on OT_OrdenTrabajoId = SOI_OT 
Where OT_Codigo = @CodeOT
and ( OT_CMM_Estatus = '3C843D99-87A6-442C-8B89-1E49322B265A'           -- Abiertas
      or OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B'        -- Produccion
      or OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B'))       -- Recibo Parcial

-- Cargar cantidad de la OT
Set @CatiOT = (Select OTDA_Cantidad
From OrdenesTrabajo
Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
--Inner Join RPT_Seguimiento_OTI on OT_OrdenTrabajoId = SOI_OT 
Where OT_Codigo = @CodeOT
and ( OT_CMM_Estatus = '3C843D99-87A6-442C-8B89-1E49322B265A'           -- Abiertas
      or OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B'        -- Produccion
      or OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B'))       -- Recibo Parcial


-- Consulta para definir Estaciones del Articulo(Ruta)
Select ART_CodigoArticulo AS CODIGO
        , ART_Nombre AS ARTICULO
        , @CatiOT AS CANT_OT
        , CET_Codigo AS COD_CET
        , CET_Nombre AS CENTRO
        , DEP_Codigo AS COD_DEP
        , DEP_Nombre AS DEPARTAMENTO 
From Fabricacion
Inner Join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId and FAE_Eliminado = 0
Inner Join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId and FAD_Eliminado = 0
Inner Join Articulos ON FAB_ART_ArticuloId = ART_ArticuloId
Left Join CentrosTrabajo on CET_CentroTrabajoId=FAD_ReferenciaId
Left Join Departamentos on DEP_DeptoId = CET_DEP_DeptoId and DEP_Eliminado = 0 and DEP_Activo = 1
Where FAB_Eliminado = 0 
and ART_ArticuloId = @Id_ART
and CET_Codigo is not null
Order By CET_Codigo



 /*

-- Consulta para Mostrar todas las Estaciones de Trabajo
Select CET_Codigo AS COD_CET
        , CET_Nombre AS CENTRO
        , DEP_Codigo AS COD_DEP
        , DEP_Nombre AS DEPARTAMENTO 
From CentrosTrabajo
Inner Join Departamentos on DEP_DeptoId = CET_DEP_DeptoId and DEP_Eliminado = 0 and DEP_Activo = 1
Where CET_Activo = 1 and CET_Borrado = 0
Order By CET_Codigo



Select * from ControlesMaestrosMultiples Where CMM_ControlId = '3C843D99-87A6-442C-8B89-1E49322B265A'
Select * from ControlesMaestrosMultiples Where CMM_Control = 'CMM_OT_Estatus'

-- Consulta enviada por Jorge Molina
Select * FROM Fabricacion
INNER JOIN FabricacionEstructura ON FAB_FabricacionId = FAE_FAB_FabricacionId AND FAE_Eliminado = 0
INNER JOIN FabricacionDetalle ON FAE_EstructuraId = FAD_FAE_EstructuraId AND FAD_Eliminado = 0
left Join CentrosTrabajo on CET_CentroTrabajoId=FAD_ReferenciaId
INNER JOIN Articulos ON FAB_ART_ArticuloId = ART_ArticuloId
WHERE FAB_Eliminado = 0 and ART_ArticuloId = '29181790-2B2C-433B-BB6D-6B82A82A258F' and CET_Codigo is not null




-- Tabla de RPT_Seguimiento_OT
-- Se controla las cantidades que se tienen en cada Estacion

Select *
From RPT_Seguimiento_OT


-- Cargar un Registro a RPT_Seguimiento_OT

INSERT INTO [dbo].[RPT_Seguimiento_OT]
                ([SOT_ID]
                ,[SOT_OT]
                ,[SOT_Empleado]
                ,[SOT_Estacion]
				,[SOT_Cantidad]
				,[SOT_Recibido]
				,[SOT_Entregado])
VALUES
        ('2'
        , '41DE070A-56A3-44BE-AF04-1013F7CFD55E'
        , '6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1'
        , '220'
        , 10
		, 4
		, 0)
GO

Update RPT_Seguimiento_OT set SOT_Entregado = 4 Where SOT_ID = '1'


SOT_ID	nvarchar(50)
SOT_OT	uniqueidentifier
SOT_Empleado	uniqueidentifier
SOT_Estacion	nvarchar(50)
SOT_Cantidad	int
SOT_Recibido	int
SOT_Entregado	int
	


-- Tabla de RPT_Seguimiento_OTF
-- Se lleva el historial del las OT que se han producido.

Select *
From RPT_Seguimiento_OTF





-- Tabla de RPT_Seguimiento_OTI
-- Se lleva el Inicio de cuando la autorizan para Produccion.

Select * From RPT_Seguimiento_OTI Where SOI_OT = '41DE070A-56A3-44BE-AF04-1013F7CFD55E'

*/



/*
-- Cargar un Registro a RPT_Seguimiento_OTI

INSERT INTO [dbo].[RPT_Seguimiento_OTI]
                ([SOI_ID]
                ,[SOI_OT]
                ,[SOI_Empleado]
                ,[SOI_Estacion]
	        ,[SOI_Eliminado]
	        ,[SOI_FechaHora])
VALUES
        ('1'
        , '41DE070A-56A3-44BE-AF04-1013F7CFD55E'
        , '6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1'
        , '100'
        , 0
        , GETDATE())
GO
*/

Select * from RPT_Seguimiento_OTF

-- Relacion de Informacion entre OT y OV
Select OT_Codigo AS OT
        , ART_CodigoArticulo AS PT
        , ART_Nombre AS DESCRIPCION
        , OTDA_Cantidad AS CANT_OT
        , OV_CodigoOV AS OV
        , PRY_CodigoEvento AS COD_PROY
        , PRY_NombreProyecto AS NOM_PROY
        , CLI_CodigoCliente AS COD_CLIE
        , CLI_RazonSocial AS NOM_CLI
from OrdenesTrabajo 
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesVenta on OTRE_OV_OrdenVentaId = OV_OrdenVentaId
inner join Proyectos on OV_PRO_ProyectoId = PRY_ProyectoId
inner join Clientes on OV_CLI_ClienteId = CLI_ClienteId
Where OT_Codigo = 'OT02430'
--Where OT_OrdenTrabajoId = '41DE070A-56A3-44BE-AF04-1013F7CFD55E'




select * from Clientes
