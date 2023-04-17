-- Consulta para Capturas de Ordenes de Trabajo.
-- Ing. Vicente Cueva R.
-- Martes 17 de Abril del 2018

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2018-04-13'
Set @FechaFS = '2018-04-13' 

Select 
		Cast(OTSD_FechaDetalleOperacion AS DATE) AS F_CAPTURA,
		Empleados.EMP_CodigoEmpleado AS CODE_OP,
		(EMPLEADOS.EMP_Nombre + ' ' + Empleados.EMP_PrimerApellido + ' ' + Empleados.EMP_SegundoApellido) AS NAME_OP,
		OTSD_TiempoTotal AS TIME_TL,
		CET_Codigo AS CODE_CET,
		CET_Nombre AS NAME_CET, 

* from OrdenesTrabajoSeguimientoDetalle
inner join OrdenesTrabajoSeguimientoOperacion on OTSD_OTSO_OrdenTrabajoSeguimientoOperacionId = OTSO_OrdenTrabajoSeguimientoOperacionId
inner join CentrosTrabajo on OTSD_CET_CentroTrabajoId = CET_CentroTrabajoId
inner join Empleados on OTSD_EMP_Operador = EMP_EmpleadoId
where Cast(OTSD_FechaDetalleOperacion as DATE)  BETWEEN @FechaIS and @FechaFS 
Order by OTSD_FechaDetalleOperacion, NAME_OP

