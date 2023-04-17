-- 031 A Consulta para Reporte de Asistencias del Personal.
-- Ing. Vicente Cueva R.
-- Actualizado Miercoles 13 de Marzo del 2019; Origen.
-- Actualizado Miercoles 20 de Marzo del 2019; Relacionar con valor numerico los empleados.
-- Actualizado: lunes 25 de marzo del 2019; Manejo con tabla de Access

-- Listado de Personal Activo en PIXVS
/*
Select	Cast(EMP_CodigoEmpleado as Int) AS CODIGO, 
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE, 
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, 
		ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO
from Empleados 
left join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId 
left join Puestos   on PUE_PuestoId = EMP_PUE_PuestoId 
Where EMP_FechaEgreso Is Null and EMP_Activo = 1 and EMP_CodigoEmpleado <> 'PIXVS2' and EMP_CodigoEmpleado <> 'ADMIN' and EMP_CodigoEmpleado <> 'PIXVS'
Order by DEPARTAMENTO, PUESTO, NOMBRE 

-- Registro de Checadas.
*/
--Parametros Fecha de Validación
Declare @FechaIS nvarchar(30)

Set @FechaIS = '2019-02-19'

Select	USERINFO.Badgenumber AS NUM_NOMINA,
		USERINFO.name AS NOMBRE,
		Cast(CHECKINOUT.CHECKTIME AS TIME) as CHECADA
from CHECKINOUT 
inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
Where Cast(CHECKTIME As Date) = @FechaIS
Order by NOMBRE










-- Registros de la Semana Completa.
/*

Declare @Fecha01 nvarchar(30), @Fecha02 nvarchar(30), @Fecha03 nvarchar(30), @Fecha04 nvarchar(30), @Fecha05 nvarchar(30), @Fecha06 nvarchar(30), @Fecha07 nvarchar(30)

--Parametros Fecha de la Semana.
Set @Fecha01 = '2019-02-18'
Set @Fecha02 = '2019-02-19'
Set @Fecha03 = '2019-02-20'
Set @Fecha04 = '2019-02-21' 
Set @Fecha05 = '2019-02-22' 
Set @Fecha06 = '2019-02-23' 
Set @Fecha07 = '2019-02-24' 

Select	CHKT.EMP_CodigoEmpleado, CHKT.NOM_PXV, MAX(CHKT.LUN_IN) AS LUN_EN, MAX(CHKT.LUN_OU) AS LUN_SA, MAX(MAR_IN) AS MAR_EN, MAX(MAR_OU) AS MAR_SA, MAX(MIE_IN) AS MIE_EN, MAX(MIE_OU) AS MIE_SA, 
		MAX(JUE_IN) AS JUE_EN, MAX(JUE_OU) AS JUE_SA, MAX(VIE_IN) AS VIE_EN, MAX(VIE_OU) AS VIE_SA, MAX(SAB_IN) AS SAB_EN, MAX(SAB_OU) AS SAB_SA, MAX(DOM_IN) AS DOM_EN, MAX(DOM_OU) AS DOM_SA
From (

Select	USERINFO.USERID AS ZKTID,
		USERINFO.Badgenumber AS NUM_NOMINA,
		EMP_CodigoEmpleado,
		USERINFO.name AS NOMBRE,
		EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' +	EMP_SegundoApellido AS NOM_PXV,
		CHECKINOUT.CHECKTIME AS REGISTRO,
		
		Case When Cast(CHECKTIME As Date) = @Fecha01 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS LUN_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha01 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS LUN_OU,
		Case When Cast(CHECKTIME As Date) = @Fecha02 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS MAR_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha02 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS MAR_OU,
		Case When Cast(CHECKTIME As Date) = @Fecha03 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS MIE_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha03 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS MIE_OU,
		Case When Cast(CHECKTIME As Date) = @Fecha04 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS JUE_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha04 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS JUE_OU,
		Case When Cast(CHECKTIME As Date) = @Fecha05 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS VIE_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha05 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS VIE_OU,
		Case When Cast(CHECKTIME As Date) = @Fecha06 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS SAB_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha06 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS SAB_OU,
		Case When Cast(CHECKTIME As Date) = @Fecha07 and Cast(CHECKTIME As Time) < CAST('12:00' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS DOM_IN,
		Case When Cast(CHECKTIME As Date) = @Fecha07 and Cast(CHECKTIME As Time) > CAST('11:59' as TIME) then  Cast(CHECKINOUT.CHECKTIME As TIME) else NULL end AS DOM_OU		 
from CHECKINOUT
inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
left Join Empleados on USERINFO.Badgenumber = EMP_CodigoEmpleado
Where Cast(CHECKTIME As Date) BETWEEN @Fecha01 and @Fecha07
and EMP_CodigoEmpleado = '026' 
) CHKT

Group By CHKT.EMP_CodigoEmpleado, CHKT.NOM_PXV
Order by NOM_PXV
*/

/*
-- Registros del Dia para validar checadas y asistencia.

--Parametros Fecha de Validación
Declare @FechaIS nvarchar(30)

Set @FechaIS = '2019-02-19'

-- Personal Activo en PIXVS contra Reloj Checador.

Select	EMP_CodigoEmpleado AS CODIGO, 
		EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE, 
		ISNULL (DEP_Nombre, 'SIN DEPTO...') AS DEPARTAMENTO, 
		ISNULL (PUE_Nombre, 'SIN PUESTO...') AS PUESTO,
		
		(Select TOP 1 Cast(CHECKINOUT.CHECKTIME AS TIME) 
		from CHECKINOUT
		inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
		Where Cast(CHECKTIME As Date) = @FechaIS and Cast(USERINFO.Badgenumber as Int) = Cast(EMP_CodigoEmpleado as Int) and Cast(CHECKTIME As Time) < CAST('08:01' as TIME) Order by CHECKINOUT.CHECKTIME) as ENTRADA,

		(Select TOP 1 Cast(CHECKINOUT.CHECKTIME as TIME) 
		from CHECKINOUT
		inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
		Where Cast(CHECKTIME As Date) = @FechaIS and Cast(USERINFO.Badgenumber as Int) = Cast(EMP_CodigoEmpleado as Int) and Cast(CHECKTIME As Time) > CAST('08:01' as TIME)
		and Cast(CHECKTIME As Time) < CAST('14:00' as TIME) Order by CHECKINOUT.CHECKTIME) 
		as RETARDO,

		(Select TOP 1 Cast(CHECKINOUT.CHECKTIME as TIME) 
		from CHECKINOUT
		inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
		Where Cast(CHECKTIME As Date) = @FechaIS and Cast(USERINFO.Badgenumber as Int) = Cast(EMP_CodigoEmpleado as Int) and Cast(CHECKTIME As Time) > CAST('14:00' as TIME)
		Order by CHECKINOUT.CHECKTIME) as SALIDA
from Empleados 
left join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId 
left join Puestos   on PUE_PuestoId = EMP_PUE_PuestoId 
Where EMP_FechaEgreso Is Null and EMP_Activo = 1 and EMP_CodigoEmpleado <> 'PIXVS2' and EMP_CodigoEmpleado <> 'ADMIN' and EMP_CodigoEmpleado <> 'PIXVS'
Order by DEPARTAMENTO, PUESTO, NOMBRE 

-- Personal Que Checa pero no esta ligado a PIXVS.

Select ASI.NUM_NOMINA, ASI.NOMBRE, 'SIN DEPTO...' AS DEPARTAMENTO, 'SIN PUESTO...' AS PUESTO, MAX(ASI.ENTRADA) as ENTRADA, 
		MAX(ASI.RETARDO) AS RETARDO, MAX(ASI.SALIDA) AS SALIDA, ASI.EMP_CodigoEmpleado AS COD_PX
from (
Select	USERINFO.Badgenumber AS NUM_NOMINA,
		USERINFO.name AS NOMBRE,
		Case When Cast(CHECKTIME As Time) < CAST('08:01' as TIME) then Cast(CHECKINOUT.CHECKTIME AS TIME) else CAST('00:00' as TIME) end as ENTRADA,
		Case When Cast(CHECKTIME As Time) >= CAST('08:01' as TIME) and Cast(CHECKTIME As Time) < CAST('14:00' as TIME) 
		then Cast(CHECKINOUT.CHECKTIME AS TIME) else CAST('00:00' as TIME) end as RETARDO,
		Case When Cast(CHECKTIME As Time) >= CAST('14:00' as TIME) then Cast(CHECKINOUT.CHECKTIME AS TIME) else CAST('00:00' as TIME) end as SALIDA,
		EMP_CodigoEmpleado
from CHECKINOUT
inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
left Join Empleados on Cast(USERINFO.Badgenumber as Int) = Cast(EMP_CodigoEmpleado as Int)
Where Cast(CHECKTIME As Date) = @FechaIS and EMP_CodigoEmpleado <> 'PIXVS2' and EMP_CodigoEmpleado <> 'ADMIN' and EMP_CodigoEmpleado <> 'PIXVS') ASI
Group By ASI.NUM_NOMINA, ASI.NOMBRE, ASI.EMP_CodigoEmpleado
Having ASI.EMP_CodigoEmpleado is Null
Order By ASI.NOMBRE


-- Presentar ultima actualización
Select top 1 CHECKINOUT.CHECKTIME from CHECKINOUT Order by CHECKINOUT.CHECKTIME DESC


Declare @Fecha01 nvarchar(30), @Fecha02 nvarchar(30), @Fecha03 nvarchar(30), @Fecha04 nvarchar(30), @Fecha05 nvarchar(30), @Fecha06 nvarchar(30), @Fecha07 nvarchar(30)

--Parametros Fecha de la Semana.
Set @Fecha01 = '2019-02-18'
Set @Fecha02 = '2019-02-19'
Set @Fecha03 = '2019-02-20'
Set @Fecha04 = '2019-02-21' 
Set @Fecha05 = '2019-02-22' 
Set @Fecha06 = '2019-02-23' 
Set @Fecha07 = '2019-02-24' 



Select	USERINFO.USERID AS ZKTID,
		USERINFO.Badgenumber AS NUM_NOMINA,
		EMP_CodigoEmpleado,
		USERINFO.name AS NOMBRE,
		EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' +	EMP_SegundoApellido AS NOM_PXV,
		CHECKINOUT.CHECKTIME AS REGISTRO
		
from CHECKINOUT
inner join USERINFO on CHECKINOUT.USERID = USERINFO.USERID 
left Join Empleados on USERINFO.Badgenumber = EMP_CodigoEmpleado
Where Cast(CHECKTIME As Date) = @Fecha01
and EMP_CodigoEmpleado = '026' 
Order by CHECKINOUT.CHECKTIME

*/
