-- Determinar Numero de Semana

Declare @Fecha_Lunes as date
Declare @Fecha_Martes as date
Declare @Fecha_Miercoles as date
Declare @Fecha_Jueves as date
Declare @Fecha_Viernes as date
Declare @Fecha_Sabado as date
Declare @Fecha_Domingo as date

-- Fecha Creacion Nuevo Documento aaaa/mm/dd
Set @Fecha_Lunes = CONVERT (DATE, '2023/02/20', 102)
Set @Fecha_Martes = CONVERT (DATE, '2023/02/21', 102)
Set @Fecha_Miercoles = CONVERT (DATE, '2023/02/22', 102)
Set @Fecha_Jueves = CONVERT (DATE, '2023/02/23', 102)
Set @Fecha_Viernes = CONVERT (DATE, '2023/02/24', 102)
Set @Fecha_Sabado = CONVERT (DATE, '2023/02/25', 102)
Set @Fecha_Domingo = CONVERT (DATE, '2023/02/26', 102)


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
	, DATEPART(iso_week,@Fecha_Viernes) AS NO_SEM_PAGO	
Union All
Select CONVERT(varchar,@Fecha_Sabado,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Sabado) DIA_SEM
	, DATEPART(iso_week,@Fecha_Sabado) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Sabado) AS NO_SEM_PAGO	
Union All
Select CONVERT(varchar,@Fecha_Domingo,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Domingo) DIA_SEM
	, DATEPART(iso_week,@Fecha_Domingo) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Domingo) AS NO_SEM_PAGO	