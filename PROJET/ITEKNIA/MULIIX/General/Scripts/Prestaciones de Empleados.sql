-- Para reporte Constancia de Vacaciones.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 21 de Agosto de 2024; Origen

-- Parametros
Declare @Periodo as varchar(30)
Declare @NumEmpl as varchar(30)

Set @Periodo = '2024'
Set @NumEmpl = '021' -- ABRAHAM.

-- Datos del empleado en Mulix
SELECT EMP_CodigoEmpleado AS CODIGO 
	, (EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS NOMBRE 
	, EMP_SueldoBase AS SUE_BASE
from Empleados 
Where EMP_CodigoEmpleado  = @NumEmpl

-- Tabla de modificacion Salarial
SELECT RPT_ECS_CodigoEmpleado  AS CODIGO 
	, RPT_ECS_Fecha AS FECHA
	, RTP_ECS_MontoMensual AS IMP_MENSUAL
	, RPT_ECS_Motivo AS MOTIVO 
	, RPT_ECS_Eliminado AS ESTATUS 
FROM RPT_EmpleadoCambioSalarial 
WHERE RPT_ECS_CodigoEmpleado = @NumEmpl

-- Datos del Empleado Cabecera del Reporte.
exec SP_RPT_VAC_VACACIONES_XEMPLEADO @NumEmpl

-- Datos de toda la informacion del Kardex de Vacaciones.
exec SP_RPT_VAC_VACACIONES_KARDEX @NumEmpl

-- Kardex a partir del perido especifico.
exec SP_RPT_VAC_VACACIONES_KARDEX_XANIO @NumEmpl, @Periodo






