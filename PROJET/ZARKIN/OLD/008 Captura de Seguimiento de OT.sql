-- Consulta para Capturas de Ordenes de Trabajo.
-- Ing. Vicente Cueva R.
-- Martes 17 de Abril del 2018

DECLARE @FechaIS date
DECLARE @FechaFS date

--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = CONVERT (DATE, '2018-04-16', 102)
Set @FechaFS = CONVERT (DATE, '2018-04-16', 102) 

Select 	Empleados.EMP_CodigoEmpleado AS CODE_OP,
		(EMPLEADOS.EMP_Nombre + ' ' + Empleados.EMP_PrimerApellido + ' ' + Empleados.EMP_SegundoApellido) AS NAME_OP,
		Cast(OTSD_FechaDetalleOperacion AS DATE) AS F_CAPTURA,
		OTSD_TiempoInicio AS T_INI,
		OTSD_TiempoFin AS T_FIN,
		OTSD_TiempoTotal AS TIME_TL,
		CET_Codigo AS CODE_CET,
		CET_Nombre AS NAME_CET, 
		OT_Codigo AS NO_OT,
		ART_CodigoArticulo AS CODE_ART,
		ART_Nombre AS ARTICULO,
		EV_CodigoEvento AS COD_PROY,
		EV_Descripcion AS PROYECTO
from OrdenesTrabajoSeguimientoDetalle
inner join OrdenesTrabajoSeguimientoOperacion on OTSD_OTSO_OrdenTrabajoSeguimientoOperacionId = OTSO_OrdenTrabajoSeguimientoOperacionId
inner join OrdenesTrabajoSeguimiento on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTS_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTS_ART_ArticuloId
inner join CentrosTrabajo on OTSD_CET_CentroTrabajoId = CET_CentroTrabajoId
inner join Empleados on OTSD_EMP_Operador = EMP_EmpleadoId
left join Eventos on OT_EV_EventoId = EV_EventoId
where Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS 
Order by OTSD_FechaDetalleOperacion, NAME_OP

