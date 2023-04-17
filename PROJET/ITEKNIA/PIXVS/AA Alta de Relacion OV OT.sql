
/* Procedimiento para Insertar Relacion de OV - OT
Elaborado por: Vicente Cueva R.
Fecha Actualizado: Miercoles 22 de Agosto del 2018; Origen. 
 
Select * from OrdenesTrabajoDetalleOVR

	OTDO_OrdenTrabajoDetalleOVRId	uniqueidentifier	Unchecked
	OTDO_OT_OrdenTrabajoId			uniqueidentifier	Unchecked
	OTDO_OVR_OVRequeridaId			uniqueidentifier	Unchecked
	OTDO_Cantidad					decimal(28, 10)		Unchecked

Ocuparías insertar un registro en la tabla de OrdenesTrabajoDetalleOVR en la cual 
Tendrías que agregar lo siguiente:
OTDO_OT_OrdenTrabajoId -> Hace referencia a la OT
OTDO_OVR_OVRequerida -> Hace referencia a la partida requerida de la tabla de OrdenesVentaReq
OTDO_Cantidad -> Cantidad Requerida

Select * from OrdenesTrabajoDetalleOVR
inner join OrdenesTrabajo on OTDO_OT_OrdenTrabajoId = OT_OrdenTrabajoId
order by OT_FechaRegistro

	
*/

INSERT INTO [dbo].[OrdenesTrabajoDetalleOVR]
           ([OTDO_OT_OrdenTrabajoId]
           ,[OTDO_OVR_OVRequeridaId]
           ,[OTDO_Cantidad])
     VALUES
          (NEWID(),'1','ANALISTA COTIZACIONES','EMPLEADO ADMINISTRATIVO')
		  
		  
          -- (NEWID(),'2','AUXILIAR ADMINISTRATIVO','EMPLEADO ADMINISTRATIVO'),
          -- (NEWID(),'3','COORDINADOR','EMPLEADO ADMINISTRATIVO'),
          -- (NEWID(),'4','ENCARGADO DE AREA','EMPLEADO ADMINISTRATIVO'),
           
GO







