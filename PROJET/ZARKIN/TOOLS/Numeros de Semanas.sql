-- Determinar Numero de Semana

Declare @Fecha_Lunes as date
Declare @Fecha_Martes as date
Declare @Fecha_Miercoles as date
Declare @Fecha_Jueves as date
Declare @Fecha_Viernes as date
Declare @Fecha_Sabado as date
Declare @Fecha_Domingo as date

-- Fecha Creacion Nuevo Documento aaaa/mm/dd
Set @Fecha_Lunes = CONVERT (DATE, '2025/12/29', 102)
Set @Fecha_Martes = CONVERT (DATE, '2025/12/30', 102)
Set @Fecha_Miercoles = CONVERT (DATE, '2025/12/31', 102)
Set @Fecha_Jueves = CONVERT (DATE, '2026/01/01', 102)
Set @Fecha_Viernes = CONVERT (DATE, '2026/01/02', 102)
Set @Fecha_Sabado = CONVERT (DATE, '2026/01/03', 102)
Set @Fecha_Domingo = CONVERT (DATE, '2026/01/04', 102)

/*
Set @Fecha_Lunes = CONVERT (DATE, '2026/01/05', 102)
Set @Fecha_Martes = CONVERT (DATE, '2026/01/06', 102)
Set @Fecha_Miercoles = CONVERT (DATE, '2026/01/07', 102)
Set @Fecha_Jueves = CONVERT (DATE, '2026/01/08', 102)
Set @Fecha_Viernes = CONVERT (DATE, '2026/01/09', 102)
Set @Fecha_Sabado = CONVERT (DATE, '2026/01/10', 102)
Set @Fecha_Domingo = CONVERT (DATE, '2026/01/11', 102)

*/


Select CONVERT(varchar,@Fecha_Lunes,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Lunes) DIA_SEM
	, DATEPART(iso_week,@Fecha_Lunes) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Lunes)-1 AS NO_SEM_PAGO
Union All
Select CONVERT(varchar,@Fecha_Martes,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Martes) DIA_SEM
	, DATEPART(iso_week,@Fecha_Martes) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Martes)-1 AS NO_SEM_PAGO
Union All
Select CONVERT(varchar,@Fecha_Miercoles,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Miercoles) DIA_SEM
	, DATEPART(iso_week,@Fecha_Miercoles) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Miercoles)-1 AS NO_SEM_PAGO
Union All
Select CONVERT(varchar,@Fecha_Jueves,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Jueves) DIA_SEM
	, DATEPART(iso_week,@Fecha_Jueves) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Jueves)-1 AS NO_SEM_PAGO
Union All
Select CONVERT(varchar,@Fecha_Viernes,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Viernes) DIA_SEM
	, DATEPART(iso_week,@Fecha_Viernes) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Viernes)-1 AS NO_SEM_PAGO	
Union All
Select CONVERT(varchar,@Fecha_Sabado,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Sabado) DIA_SEM
	, DATEPART(iso_week,@Fecha_Sabado) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Sabado)-1 AS NO_SEM_PAGO	
Union All
Select CONVERT(varchar,@Fecha_Domingo,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Domingo) DIA_SEM
	, DATEPART(iso_week,@Fecha_Domingo) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Domingo)-1 AS NO_SEM_PAGO	


