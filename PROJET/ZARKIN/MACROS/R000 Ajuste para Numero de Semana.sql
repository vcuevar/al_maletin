-- R000-A DETERMINAR EL NUMERO DE SEMANA SEGUN EL AÑO.
-- ID: 260113
-- TAREA: Hacer una consulta que pueda determinar el numero de la semana en funcion al año.
-- VISION: 
-- SOLICITADO: 
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 13 de enero del 2025; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @nCiclo nVarchar(7) 
Declare @nNumSem as integer
Declare @nAjuSem as integer

Declare @Fecha_Lunes as date
Declare @Fecha_Martes as date
Declare @Fecha_Miercoles as date
Declare @Fecha_Jueves as date
Declare @Fecha_Viernes as date
Declare @Fecha_Sabado as date
Declare @Fecha_Domingo as date

Print @nCiclo
-- Calcula el numero de semanas del Año solicitado.
Set @nNumSem = (Select SUM(SCC.SEMXMES) AS SEMANAS from Siz_Calendario_Cierre SCC Where SCC.CICLO = @nCiclo )

Print @nNumSem

--Set @nCiclo = '2004'
--Print @nCiclo

-- Calcula el Principio y final del Año.
Set @nCiclo = '2024'
Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
Set @nCiclo = '2023'
Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')

Set @nAjuSem = (Select Case When @nNumSem=52 then 0 else 1 end)
Print @nAjuSem
/*
Select @FechaIS AS FECH_INC
	, DATEPART(ISO_WEEK, @FechaIS) AS SEMANAI
	, DATEPART(ISO_WEEK, @FechaIS) - @nAjuSem AS SEM_INI
	, DATEPART(week, @FechaIS) - @nAjuSem AS SEM_IN2
	, @FechaFS AS FECH_FIN
	, DATEPART(ISO_WEEK, @FechaFS) AS SEMANAF
	, DATEPART(ISO_WEEK, @FechaFS)  - @nAjuSem AS SEM_FIN
	, DATEPART(week, @FechaIS) - @nAjuSem AS SEM_INI
*/
-- Ver esta posibilidad calcular el numero de semanas del año anterior y si son 53 en el año actual 
-- Ajuste es - 1 si fue 52 ajuste es 0

-- Si la fecha del Ciclo Actual menos uno termina en dia 1 al 4 del Ciclo Actual ajuste seria 1 y si es cero
-- con el ajuste sera numero 53
-- Si de la fecha Inicial el miercoles corresponde al ciclo anterio entonces Ajuste 1 y si no 0

-- Fecha Creacion Nuevo Documento aaaa/mm/dd
Set @Fecha_Lunes =		CONVERT (DATE, '2025/12/29', 102)
Set @Fecha_Martes =		CONVERT (DATE, '2025/12/30', 102)
Set @Fecha_Miercoles =	CONVERT (DATE, '2025/12/31', 102)
Set @Fecha_Jueves =		CONVERT (DATE, '2026/01/01', 102)
Set @Fecha_Viernes =	CONVERT (DATE, '2026/01/02', 102)
Set @Fecha_Sabado =		CONVERT (DATE, '2026/01/03', 102)
Set @Fecha_Domingo =	CONVERT (DATE, '2026/01/04', 102)



Select CONVERT(varchar, @FechaFS, 13) AS FECH_CREA
	, DATENAME(dw, @FechaFS) DIA_SEM
	, DATEPART(iso_week, @FechaFS) AS NO_SEM
	, DATEPART(iso_week, @FechaFS) - @nAjuSem AS SEM_AJUST
Union All


Select CONVERT(varchar, @FechaIS, 13) AS FECH_CREA
	, DATENAME(dw, @FechaIS) DIA_SEM
	, DATEPART(iso_week, @FechaIS) AS NO_SEM
	, DATEPART(iso_week, @FechaIS) - @nAjuSem AS SEM_AJUST
Union All




Select CONVERT(varchar,@Fecha_Lunes,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Lunes) DIA_SEM
	, DATEPART(iso_week,@Fecha_Lunes) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Lunes) - @nAjuSem AS SEM_AJUST
Union All
Select CONVERT(varchar,@Fecha_Martes,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Martes) DIA_SEM
	, DATEPART(iso_week,@Fecha_Martes) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Martes) - @nAjuSem AS SEM_AJUST
Union All
Select CONVERT(varchar,@Fecha_Miercoles,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Miercoles) DIA_SEM
	, DATEPART(iso_week,@Fecha_Miercoles) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Miercoles) - @nAjuSem AS SEM_AJUST
Union All
Select CONVERT(varchar,@Fecha_Jueves,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Jueves) DIA_SEM
	, DATEPART(iso_week,@Fecha_Jueves) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Jueves) - @nAjuSem AS SEM_AJUST
Union All
Select CONVERT(varchar,@Fecha_Viernes,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Viernes) DIA_SEM
	, DATEPART(iso_week,@Fecha_Viernes) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Viernes) - @nAjuSem AS SEM_AJUST	
Union All
Select CONVERT(varchar,@Fecha_Sabado,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Sabado) DIA_SEM
	, DATEPART(iso_week,@Fecha_Sabado) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Sabado) - @nAjuSem AS SEM_AJUST	
Union All
Select CONVERT(varchar,@Fecha_Domingo,13) AS FECH_CREA
	, DATENAME(dw,@Fecha_Domingo) DIA_SEM
	, DATEPART(iso_week,@Fecha_Domingo) AS NO_SEM
	, DATEPART(iso_week,@Fecha_Domingo) - @nAjuSem AS SEM_AJUST	



	--Select * from Siz_Calendario_Cierre Where CICLO = @nCiclo




