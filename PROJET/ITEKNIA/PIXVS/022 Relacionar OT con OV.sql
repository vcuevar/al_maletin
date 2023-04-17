-- PIXVS Consulta para 022 Procedimiento para Relacionar OT - OV.
-- Desarrollado: Ing. Vicente Cueva R.
-- Iniciado: Martes 04 de Septiembre del 2018; Origen
-- Actualizado: 

DECLARE @CodeOT AS nvarchar(50)
DECLARE @CodeOV AS nvarchar(50)
DECLARE @FechaIS date


DECLARE @ART_ID AS uniqueidentifier
Set @CodeOT = 'OT2040'
Set @CodeOV = 'OV723'
Set @FechaIS = CONVERT (DATE, '2018-09-01', 102)



Select * from RBV_OT Where OT_CD = @CodeOT

--Delete RBV_OT Where OT_CD = @CodeOT

--Select OT_CD, OV_CD from RBV_OT Where OT_CD = 'OT2040'



/*
-- Completa Información de la Orde de Trabajo y Ventas.
Select	OT_Codigo,
		OT_OrdenTrabajoid,
		OT_CLI_ClienteId,
		OTDA_ART_ArticuloId,
		OV_CodigoOV,
		OV_OrdenVentaId,
		OV_CLI_ClienteId,
		OVD_ART_ArticuloId,
		ART_CodigoArticulo,
		OVD_ART_Nombre,
		OTDA_Cantidad,
		OVD_OVDetalleId,
		OV_EV_EventoId, 
		EV_CodigoEvento,
		EV_Descripcion
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join OrdenesVentaDetalle on OVD_ART_ArticuloId = OTDA_ART_ArticuloId 
inner join OrdenesVenta on  OV_OrdenVentaId = OVD_OrdenVentaId and OV_CodigoOV = @CodeOV
inner join Eventos on EV_EventoId = OV_EV_EventoId
inner join Articulos on OTDA_ART_ArticuloId = ART_ArticuloId
Where OT_Codigo = @CodeOT


-- Completa Información de la Orde de Trabajo Sin Detalles de OV.
Select	OT_Codigo,
		OT_OrdenTrabajoid,
		OT_CLI_ClienteId,
		OTDA_ART_ArticuloId,
		@CodeOV AS OV_CodigoOV,
		(Select OV_OrdenVentaId from OrdenesVenta Where OV_CodigoOV = @CodeOV) AS OV_OrdenVentaId,
		(Select OV_CLI_ClienteId from OrdenesVenta Where OV_CodigoOV = @CodeOV) AS OV_CLI_ClienteId,
		ART_ArticuloId AS OVD_ART_ArticuloId,
		ART_CodigoArticulo,
		ART_Nombre AS OVD_ART_Nombre,
		OTDA_Cantidad,
		(select OVD_OVDetalleId from OrdenesVentaDetalle where OVD_CodigoOV = @CodeOV and OVD_ART_ArticuloId = OTDA_ART_ArticuloId) AS OVD_OVDetalleId,
		OT_EV_EventoId AS OV_EV_EventoId, 
		EV_CodigoEvento,
		EV_Descripcion,
		(Select OV_MON_MonedaId from OrdenesVenta Where OV_CodigoOV = @CodeOV) AS MONEDA,
		(Select OV_MONP_Paridad from OrdenesVenta Where OV_CodigoOV = @CodeOV) AS PARIDAD,
		ART_CostoMaterialEstandar AS PRECIO
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join Eventos on EV_EventoId = OT_EV_EventoId
inner join Articulos on OTDA_ART_ArticuloId = ART_ArticuloId
Where OT_Codigo = @CodeOT
*/
/*

-- Valida que no exista relacion en Base RBV_OT
Select * From RBV_OT Where OT_CD = @CodeOT and OV_CD = @CodeOV

-- Cambiar ID Detalle, sufrio cambios. Actualizado 02 de Abril del 2019

Update RBV_OT Set OVD_ID = '6BE75303-1C61-4D54-93F8-40FC5BF75506' Where RBV_ID = 'B358DCD0-FA35-458D-8621-EBDD9520F3AA'



-- Carga Informacion a la Base de Datos RBV_OT
Insert Into [dbo].[RBV_OT]
           ([RBV_ID],
           [OT_ID],
		   [OT_CD],
           [AR_ID],
		   [AR_CD],
		   [AR_QT],
		   [OV_ID],
		   [OV_CD],
		   [OVD_ID],
		   [PR_ID],
		   [PR_CD])
     VALUES
          (NEWID(),
		  'Dato5', 
		  'Dato4','Dato7', 
		  'Dato12','Dato14','Dato9','Dato8', 'Dato15', 'Dato16', 'Dato17')	
GO


-- Establecer Ordenes de Trabajo que no estan en la Relacion, tomando en 
--cuenta la no borradas y las que sean mayores del 15 de Enero del 2018.

Select	Cast(OT_FechaRegistro AS DATE) AS F_REGISTRO,	
		OT_Codigo, 
		ART_CodigoArticulo,
		ART_Nombre,
		OTDA_Cantidad,
		ISNULL(OV_CD,'SIN RELACION') AS OV,
		(Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OT_CMM_Status) AS ESTATUS
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join Articulos on OTDA_ART_ArticuloId = ART_ArticuloId
left join RBV_OT on OT_ID = OT_OrdenTrabajoId
Where OV_CD is null and OT_Borrrado = 0 
and CAST(@FechaIS AS DATE) < Cast(OT_FechaRegistro AS DATE)
and OT_CMM_Status <> 'F860806C-B1EC-4047-AA95-EDAD406DE10E'
Order By F_REGISTRO, OT_Codigo


*/

