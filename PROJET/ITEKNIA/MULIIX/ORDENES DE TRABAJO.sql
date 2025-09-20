-- Consultas para Ordenes de Trabajo.
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: 17 de septiembre del 2025; Ubicar las cerradas parcialmente.

-- Tabla de Estatus para las Ordenes de Trabajo.
3C843D99-87A6-442C-8B89-1E49322B265A	Abierta
3887AF19-EA11-4464-A514-8FA6030E5E93	Cerrada Por Usuario
46B96B9F-3A45-4CF9-9775-175C845B6198	Cerrada y Costeada Material
7246798D-137A-4E94-9404-1D80B777EE09	Cerrada y Costeada Material Parcial
3E35C727-DAEE-47FE-AA07-C50EFD93B25F	Cerrado Y Costeado
A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B	En Producción
F860806C-B1EC-4047-AA95-EDAD406DE10E	Recibo Completo
213ED3B9-12B3-41C9-8C6E-230DC86BBF90	Recibo Parcial



-- Ordenes Cerradas Parciales.
Select OT_Codigo AS OT
	, Cast(OT_FechaOT as date) AS FECHOT
	, CMM_Valor AS ESTATUS
	, OT_CMM_Estatus AS IDESTADO
From OrdenesTrabajo
Inner Join ControlesMaestrosMultiples on OT_CMM_Estatus = CMM_ControlId
Where OT_CMM_Estatus = '3C843D99-87A6-442C-8B89-1E49322B265A'
Order By OT

- Estatus en las Ordenes de Trabajo.
Select Distinct OT_CMM_Estatus AS IDESTADO 
	, CMM_Valor AS ESTATUS
From OrdenesTrabajo
Inner Join ControlesMaestrosMultiples on OT_CMM_Estatus = CMM_ControlId
Order By ESTATUS

Update OrdenesTrabajo Set OT_CMM_Estatus = 'F860806C-B1EC-4047-AA95-EDAD406DE10E' Where OT_Codigo = 'OT01641'



Select OT_Codigo AS OT
	, Cast(OT_FechaOT as date) AS FECHOT
	, CMM_Valor AS ESTATUS
	, OT_CMM_Estatus AS IDESTADO
From OrdenesTrabajo
Inner Join ControlesMaestrosMultiples on OT_CMM_Estatus = CMM_ControlId
Where OT_Codigo = 'OT04165'
Order By OT


Select * From ControlesMaestrosMultiples

select * from OrdenesTrabajoReferencia
Where OTRE_OT_OrdenTrabajoId = '13B4C36B-0F7E-46B4-8D6E-CE42BAB574CE'







select OT_CMM_Estatus, * from OrdenesTrabajo WHERE OT_Codigo = 'OT03727'

Select * From OrdenesTrabajo WHERE OT_CMM_Estatus = '213ED3B9-12B3-41C9-8C6E-230DC86BBF90' 

CMM_ControlId	CMM_Control	CMM_Valor
3C843D99-87A6-442C-8B89-1E49322B265A	CMM_OT_Estatus	Abierta
3887AF19-EA11-4464-A514-8FA6030E5E93	CMM_OT_Estatus	Cerrada Por Usuario
46B96B9F-3A45-4CF9-9775-175C845B6198	CMM_OT_Estatus	Cerrada y Costeada Material
7246798D-137A-4E94-9404-1D80B777EE09	CMM_OT_Estatus	Cerrada y Costeada Material Parcial
3E35C727-DAEE-47FE-AA07-C50EFD93B25F	CMM_OT_Estatus	Cerrado Y Costeado
A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B	CMM_OT_Estatus	En Producción
F860806C-B1EC-4047-AA95-EDAD406DE10E	CMM_OT_Estatus	Recibo Completo
213ED3B9-12B3-41C9-8C6E-230DC86BBF90	CMM_OT_Estatus	Recibo Parcial


update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' WHERE OT_Codigo = 'OT01935'
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' WHERE OT_Codigo = 'OT03950'
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' WHERE OT_Codigo = 'OT01935'
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' WHERE OT_Codigo = 'OT01935'








OT_CMM_Estatus
3887AF19-EA11-4464-A514-8FA6030E5E93

select * from ControlesMaestrosMultiples Where CMM_Control = 'CMM_OT_Estatus'

select * from OrdenesTrabajoAsignacionRecursosArticulos

select * from OrdenesTrabajoAsignacionRecursosDetalle
select * from OrdenesTrabajoReferencia (Relacion de la OV -> OT)

select * from OrdenesTrabajoAsignacionRecursosEmpleados
select * from OrdenesTrabajoDetalleArticulos


select * from OrdenesTrabajoSeguimiento
select * from OrdenesTrabajoSeguimientoOperacion
select * from OrdenesTrabajoSeguimientoOperacionDetalle (Esta es donde se captan los tiempos posiblemente si se pueda poner el empleado.)


select * from OrdenesTrabajoSurtimiento
select * from OrdenesTrabajoSurtimientoDetalle
select * from OrdenesTrabajoSurtimientoRecibos




-- Tablas vacias al parecer no se estan usando --

select * from OrdenesTrabajoAsignacionRecursos

select * from OrdenesTrabajoDetalleOVR

select * from OrdenesTrabajoEntregas

select * from OrdenesTrabajoGastos
select * from OrdenesTrabajoGastosDetalle
select * from OrdenesTrabajoRecibo
select * from OrdenesTrabajoReciboDetalle

select * from OrdenesTrabajoSeguimientoDetalle (Vacia)
select * from OrdenesTrabajoSeguimientoDetalleArticulo (Vacia)
select * from OrdenesTrabajoSeguimientoGastos (Vacia)
select * from OrdenesTrabajoSeguimientoGastosDetalle (Vacia)
select * from OrdenesTrabajoSeguimientoGastosOperacion (Vacia)
select * from OrdenesTrabajoSeguimientoOperacionEmpleados (Vacia)
select * from OrdenesTrabajoSurtimientoCostosH (Vacia)
select * from OrdenesTrabajoSurtimientoPartida (Vacia)

