-- Consulta para Capturas de Ordenes de Trabajo.
-- Ing. Vicente Cueva R.
-- Martes 17 de Abril del 2018

DECLARE @FechaIS date
DECLARE @FechaFS date

--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = CONVERT (DATE, '2019-01-01', 102)
Set @FechaFS = CONVERT (DATE, '2019-01-19', 102) 

Select 	Empleados.EMP_CodigoEmpleado AS CODE_OP,
		(EMPLEADOS.EMP_Nombre + ' ' + Empleados.EMP_PrimerApellido + ' ' + Empleados.EMP_SegundoApellido) AS NAME_OP,
		Cast(OTSD_FechaDetalleOperacion AS DATE) AS F_CAPTURA,
		OTSD_TiempoInicio AS T_INI,
		OTSD_TiempoFin AS T_FIN,
		OTSD_TiempoTotal AS TIME_TL,
		(CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/60  AS HORAS,
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




-- Reporte de Plantillas

Select	EMP_EmpleadoId AS ID,
		EMP_CodigoEmpleado AS CODIGO, 
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO, 
		EMP_FechaEgreso AS ESTATUS,
		(Select SUM((Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + 
		Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60  + 
		Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/ 60)  AS TIME_TL
		from OrdenesTrabajoSeguimientoDetalle
		where Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS
		and OTSD_EMP_Operador = EMP_EmpleadoId) AS TIEMPO
From Empleados 
left join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId 
left join Puestos   on PUE_PuestoId = EMP_PUE_PuestoId 
Where (EMP_FechaEgreso is null and EMP_Activo = 1 and  
DEP_Nombre = 'PRODUCCION' and PUE_Nombre <> 'ALMACENISTA' and PUE_Nombre <> 'GERENTE' ) OR
(EMP_FechaEgreso is null and EMP_Activo = 1 and  
DEP_Nombre = 'DISEÑO' and PUE_Nombre = 'TAPICERO') OR
(EMP_FechaEgreso is null and EMP_Activo = 1 and  
DEP_Nombre = 'CENTRO DE SERVICIO VTA.' and PUE_Nombre = 'TAPICERO')
Order by DEPARTAMENTO, PUESTO, NOMBRE


/*
(Select SUM((Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + 
Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60  + 
Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/ 60)  AS TIME_TL
from OrdenesTrabajoSeguimientoDetalle
where Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS
and OTSD_EMP_Operador = '3DD43573-ED37-4175-BC5B-069DACA5CA91') AS TIEMPO







-- Reporte de Plantillas
Select PL_TILLA.CODIGO, PL_TILLA.NOMBRE, PL_TILLA.DEPARTAMENTO,  PL_TILLA.PUESTO, SUM(PL_TILLA.TIME_TL) AS TIEMPO
From
(Select	EMP_CodigoEmpleado AS CODIGO, 
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE,
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO, 
		EMP_FechaEgreso AS ESTATUS,
		(Select (Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + 
		Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60  + 
		Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/ 60 )  AS TIME_TL
From Empleados 
left join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId 
left join Puestos   on PUE_PuestoId = EMP_PUE_PuestoId 
LEFT JOIN OrdenesTrabajoSeguimientoDetalle on EMP_EmpleadoId =  OTSD_EMP_Operador
Where EMP_FechaEgreso is null and DEP_Nombre = 'PRODUCCION' 
and PUE_Nombre <> 'ALMACENISTA' and PUE_Nombre <> 'GERENTE' and
Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS ) AS PL_TILLA
Group by PL_TILLA.CODIGO, PL_TILLA.NOMBRE, PL_TILLA.DEPARTAMENTO,  PL_TILLA.PUESTO
Order by PL_TILLA.DEPARTAMENTO, PL_TILLA.PUESTO, PL_TILLA.NOMBRE

--from OrdenesTrabajoSeguimientoDetalle
--where Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS )

--(Select (CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/60)
	--	from OrdenesTrabajoSeguimientoDetalle where Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS and
		--EMP_EmpleadoId = OTSD_EMP_Operador)) AS TIME_TL


--(CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/60)



		
(Select (Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + 
Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60  + 
Convert(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/ 60 AS TIME_TL, *
from OrdenesTrabajoSeguimientoDetalle
where Cast(OTSD_FechaDetalleOperacion as DATE) BETWEEN @FechaIS and @FechaFS and
		EMP_EmpleadoId = OTSD_EMP_Operador)  
		





*/