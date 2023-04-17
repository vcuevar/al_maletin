-- Ordenes de Trabajo
-- 
-- Actualizado: Sabado 21 de Sepriembre del 2019.

--Desarrollo Completo

select	OT_OrdenTrabajoId as ID_OT,
		OT_Codigo as OT,
		OT_FechaOT as FEC_OT,
		OT_FechaCreacion as FEC_CR,
		OT_FechaRequeridaOV as FEC_RE,
		ART_CodigoArticulo as COD_ART,
		ART_Nombre as DES_ART,
		OTDA_Cantidad as CANTIDAD,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) as ESTATUS,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Prioridad) as PRIORIDAD
		
		--(Select PRY_CodigoEvento + '   ' + PRY_NombreProyecto from Proyectos Where PRY_ProyectoId =(
		--Select OTRE_PRY_ProyectoId from OrdenesTrabajoReferencia Where OTRE_OT_OrdenTrabajoId = OT_OrdenTrabajoId)) as PROYECTO,
		
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
where OT_Activo = 1 and (OT_OrdenTrabajoId = '5D7D3E58-0F99-4EAF-BB29-560F2589A85A'
or OT_OrdenTrabajoId = 'E997A01E-3AA9-4DB2-B2B1-A58E65C2383C')

Select OTRE_PRY_ProyectoId, * from OrdenesTrabajoReferencia 
Where OTRE_OT_OrdenTrabajoId = 'E997A01E-3AA9-4DB2-B2B1-A58E65C2383C'

-- Tablas Individuales.
select * from OrdenesTrabajo
Select * from OrdenesTrabajoAsignacionRecursos
Select * from OrdenesTrabajoAsignacionRecursosArticulos
Select * from OrdenesTrabajoAsignacionRecursosDetalle
Select * from OrdenesTrabajoAsignacionRecursosEmpleados
select * from OrdenesTrabajoDetalleArticulos
select * from OrdenesTrabajoDetalleOVR
Select * from OrdenesTrabajoEntregas
Select * from OrdenesTrabajoGastos
Select * from OrdenesTrabajoGastosDetalle
Select * from OrdenesTrabajoRecibo
Select * from OrdenesTrabajoReciboDetalle
Select * from OrdenesTrabajoReferencia
Select * from OrdenesTrabajoSeguimiento
Select * from OrdenesTrabajoSeguimientoDetalle
Select * from OrdenesTrabajoSeguimientoDetalleArticulo
Select * from OrdenesTrabajoSeguimientoGastos
Select * from OrdenesTrabajoSeguimientoGastosDetalle
Select * from OrdenesTrabajoSeguimientoGastosOperacion
Select * from OrdenesTrabajoSeguimientoOperacion
Select * from OrdenesTrabajoSurtimiento
Select * from OrdenesTrabajoSurtimientoCostosH
Select * from OrdenesTrabajoSurtimientoDetalle
Select * from OrdenesTrabajoSurtimientoPartida
Select * from OrdenesTrabajoSurtimientoRecibos