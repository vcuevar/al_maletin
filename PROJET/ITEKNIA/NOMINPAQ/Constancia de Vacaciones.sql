-- Nombre: Constancia de Vacaciones por Periodo.
-- Objetivo: Presentarinformacion para realizar comprobante Constancia de Vacaciónes.
-- Sistema: Nomimpaq (SQL)
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 17 de Julio del 2024; Origen.
-- Actualozado: Miercoles 24 de Julio del 2024; Terminada.

-- Parámetros 
Declare @Anual as Integer
Declare @NumEmpl as varchar(30)

Set @Anual = 2024
Set @NumEmpl = '00021' -- ABRAHAM.
--Set @NumEmpl = '00806' -- MARIBEL.

-- Derecho de Vacaciones antes del Periodo.
Select NOM10001.codigoempleado, NOM10001.nombrelargo, SUM(Cast((Case When NOM10007.IdConcepto = 21 then (NOM10007.Valor)/.25 else 0 end) as Decimal(16,2))) AS VAC_Derecho
from nom10007 
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Inner Join NOM10002 on NOM10002.idperiodo = NOM10007.idperiodo  
where NOM10002.ejercicio < @Anual 
--and NOM10001.codigoempleado = @NumEmpl
and NOM10007.IdConcepto = 21
Group by NOM10001.codigoempleado, NOM10001.nombrelargo

-- Vacaciones Tomadas
Select NOM10001.codigoempleado, NOM10001.nombrelargo, SUM(Cast((Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2))) AS VAC_TOMADAS
from nom10007 
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Inner Join NOM10002 on NOM10002.idperiodo = NOM10007.idperiodo  
where NOM10002.ejercicio < @Anual 
--and NOM10001.codigoempleado = @NumEmpl
and NOM10007.IdConcepto = 20
Group by NOM10001.codigoempleado, NOM10001.nombrelargo
-- Datos del Periodo Actual. 

Select NOM10001.codigoempleado AS CODE_EMPLEADO
	, NOM10001.nombre + ' ' + NOM10001.apellidopaterno  + ' ' + NOM10001.apellidomaterno AS NOMBRE
	, Cast(NOM10002.ejercicio as varchar(4)) + '-'+ (
	Case When NOM10002.numeroperiodo < 10 then '0' + Cast(NOM10002.numeroperiodo as varchar(2))
	else Cast(NOM10002.numeroperiodo as varchar(2)) end ) AS PERIODO
	, NOM10001.sueldodiario  AS SUELDO_DIA	
	, Cast(NOM10001.fechasueldodiario as date) AS FEC_SDIA
	, Cast(NOM10001.fechareingreso as date)  AS FEC_INGRESO
	, 0 AS VAC_Derecho
	, 0 AS IMPO_PRIMA
	, Cast((Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS VAC_TOMADAS
	, Cast(NOM10007.importetotal as Decimal(16,2)) AS IMPO_TOMADAS
from nom10007 
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Inner Join NOM10002 on NOM10002.idperiodo = NOM10007.idperiodo  
where NOM10002.ejercicio = @Anual and 
NOM10001.codigoempleado = @NumEmpl
and NOM10007.IdConcepto = 20
Union All
Select NOM10001.codigoempleado AS CODE_EMPLEADO
	, NOM10001.nombre + ' ' + NOM10001.apellidopaterno  + ' ' + NOM10001.apellidomaterno AS NOMBRE
	, Cast(NOM10002.ejercicio as varchar(4)) + '-'+ (
	Case When NOM10002.numeroperiodo < 10 then '0' + Cast(NOM10002.numeroperiodo as varchar(2))
	else Cast(NOM10002.numeroperiodo as varchar(2)) end ) AS PERIODO
	, NOM10001.sueldodiario  AS SUELDO_DIA	
	, NOM10001.fechasueldodiario AS FEC_SDIA
	, NOM10001.fechareingreso  AS FEC_INGRESO
	, Cast((Case When NOM10007.IdConcepto = 21 then (NOM10007.Valor)/.25 else 0 end) as Decimal(16,2)) AS VAC_Derecho
	, Cast(NOM10007.importetotal as Decimal(16,2)) AS IMPO_PRIMA
	, 0 AS VAC_Tomadas
	, 0 AS IMP_Tomadas
from nom10007 
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Inner Join NOM10002 on NOM10002.idperiodo = NOM10007.idperiodo  
where NOM10002.ejercicio = @Anual and 
NOM10001.codigoempleado = @NumEmpl
and NOM10007.IdConcepto = 21 -- Vacaciones Derecho

Order By PERIODO  


Select NOM10001.codigoempleado AS CODE_EMPLEADO
	, NOM10001.nombre + ' ' + NOM10001.apellidopaterno  + ' ' + NOM10001.apellidomaterno AS NOMBRE
	, NOM10001.sueldodiario  AS SUELDO_DIA	
	, Cast(NOM10001.fechasueldodiario as date) AS FEC_SDIA
	, Cast(NOM10001.fechaalta  as date) AS FEC_INGRESO
from nom10001
where NOM10001.codigoempleado = @NumEmpl


-- Vacaciones Tomadas
-- Ver en donde estan las fechas de vacaciones.
Select NOM10001.codigoempleado
	, NOM10001.nombrelargo
	--, SUM(Cast((Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2))) AS VAC_TOMADAS
	, Cast((Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS VAC_TOMADAS
	, NOM10007.*
from nom10007 
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Inner Join NOM10002 on NOM10002.idperiodo = NOM10007.idperiodo  
where NOM10002.ejercicio = @Anual 
and NOM10001.codigoempleado = @NumEmpl
and NOM10007.IdConcepto = 20

-- Kardex vacaciones y derecho con fechas.
Select NOM10001.codigoempleado AS COD_EMPL
	, NOM10001.nombrelargo AS NOMBRE
	, (NOM10014.diasprimavacacional)/0.25  AS DERECHO
	, NOM10014.diasvacaciones AS TOMADAS
	, Cast (NOM10014.fechapago as date) AS FEC_PAG
	, Cast(NOM10014.fechainicio as date) AS FEC_INICIA
	, Cast(NOM10014.fechafin as date) AS FEC_FIN
from NOM10014 
Inner Join NOM10001 on NOM10001.idempleado = NOM10014.idempleado 
--Inner Join NOM10002 on NOM10002.idperiodo = NOM10014.ejercicio 
Where NOM10001.codigoempleado = @NumEmpl
and NOM10014.ejercicio  = @Anual
Order By NOM10014.fechainicio 

