-- Consulta para obtener los periodos autorizados por contabilidad
-- Para implementar en los reportes donde se solicitan Semanas o Meses.
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 15 de septiembre del 2025; Origen.
-- Actualizado: Lunes 22 de septiembre del 2025; Generar Vista, para relacionar 
-- la fecha y obtener numero de mes y nombre del mes.

-- Metodo para determinar una fecha a que mes pertenece.
Declare @Fecha as Date
Set @Fecha = CONVERT (DATE, '2025-12-29', 102)

Select * From Siz_Calendario_Cierre

Where @Fecha between CAST(FEC_INI AS DATE) and CAST(FEC_FIN AS DATE)


-- Metodo para saber los limites de una semana
Declare @nCiclo nVarchar(4) = '2025'
Declare @nSem Int = 53

Select Cast(Cast((Cast(OFPR.F_RefDate as float)+((@nSem-1)*7)) as datetime) as date) AS FEC_LUN
	, Cast(Cast((Cast(OFPR.F_RefDate as float)+((@nSem-1)*7)+6) as datetime) as date) AS FEC_DOM
From OFPR
Where OFPR.Code = @nCiclo + '-01';



-- Metodo para saber los limites de un Año
Declare @nCiclo nVarchar(4) = '2025'

Select Cast(SCC.FEC_INI as date) AS FEC_INI
From Siz_Calendario_Cierre SCC
Where SCC.PERIODO = @nCiclo + '-01'

Select Cast(SCC.FEC_FIN as date) AS FEC_FIN
From Siz_Calendario_Cierre SCC
Where SCC.PERIODO = @nCiclo + '-12'


-- Metodo convertir una fecha a Numero de Semana
Declare @Fecha as Date
Set @Fecha = CONVERT (DATE, '2025-12-29', 102)

Select DATEPART(ISO_WEEK, @Fecha) AS SEMANA

/*
/* ============================================================================
|       Informaciónde la Tabla de Periodos en SAP (OFPR)                       |
==============================================================================*/
Select OFPR.Code AS PERIODO
	, Substring(OFPR.Code, 1,4) AS CICLO
	, Substring(OFPR.Code, 6,2) AS MES
	, Case 
		when Substring(OFPR.Code, 6,2) = '01' then 'ENERO' 
		when Substring(OFPR.Code, 6,2) = '02' then 'FEBRERO' 
		when Substring(OFPR.Code, 6,2) = '03' then 'MARZO' 
		when Substring(OFPR.Code, 6,2) = '04' then 'ABRIL' 
		when Substring(OFPR.Code, 6,2) = '05' then 'MAYO' 
		when Substring(OFPR.Code, 6,2) = '06' then 'JUNIO' 
		when Substring(OFPR.Code, 6,2) = '07' then 'JULIO' 
		when Substring(OFPR.Code, 6,2) = '08' then 'AGOSTO' 
		when Substring(OFPR.Code, 6,2) = '09' then 'SEPTIEMBRE' 
		when Substring(OFPR.Code, 6,2) = '10' then 'OCTUBRE' 
		when Substring(OFPR.Code, 6,2) = '11' then 'NOVIEMBRE' 
		when Substring(OFPR.Code, 6,2) = '12' then 'DICIEMBRE' 
	End AS NOM_MES
	, Case 
		when Substring(OFPR.Code, 6,2) = '01' then 'ENE' 
		when Substring(OFPR.Code, 6,2) = '02' then 'FEB' 
		when Substring(OFPR.Code, 6,2) = '03' then 'MAR' 
		when Substring(OFPR.Code, 6,2) = '04' then 'ABR' 
		when Substring(OFPR.Code, 6,2) = '05' then 'MAY' 
		when Substring(OFPR.Code, 6,2) = '06' then 'JUN' 
		when Substring(OFPR.Code, 6,2) = '07' then 'JUL' 
		when Substring(OFPR.Code, 6,2) = '08' then 'AGO' 
		when Substring(OFPR.Code, 6,2) = '09' then 'SEP' 
		when Substring(OFPR.Code, 6,2) = '10' then 'OCT' 
		when Substring(OFPR.Code, 6,2) = '11' then 'NOV' 
		when Substring(OFPR.Code, 6,2) = '12' then 'DIC' 
	End AS NOM_CTO
	, Cast(OFPR.F_RefDate as date) AS FEC_INI
	, Cast(OFPR.T_RefDate as date) AS FEC_FIN
	--, DatePart(iso_week, Cast(OFPR.F_RefDate as date)) AS SEM_INI
	--, DatePart(iso_week, Cast(OFPR.T_RefDate as date)) AS SEM_FIN
	--, DatePart(iso_week, GetDate()) AS SEM_HOY
	--, DATEFROMPARTS(Substring(OFPR.Code, 1,4), 1, 1) AS SABE	   	  
From OFPR
Where Code  Like '2025%'

/* ============================================================================
|           250922 Generación de Vista Siz_Calendario_Cierre                  |
=============================================================================*/

Create View Siz_Calendario_Cierre
as
Select  OFPR.Code AS PERIODO
	, Substring(OFPR.Code, 1,4) AS CICLO
	, Substring(OFPR.Code, 6,2) AS MES
	, Cast(OFPR.F_RefDate as date) AS FEC_INI
	, Cast(OFPR.T_RefDate as date) AS FEC_FIN	  
From OFPR;

/* ============================================================================
|       50922 Modificacion de la Vista Anexar el nombre del Mes               |
=============================================================================*/

Alter View Siz_Calendario_Cierre
as
Select OFPR.Code AS PERIODO
	, Substring(OFPR.Code, 1,4) AS CICLO
	, Substring(OFPR.Code, 6,2) AS MES
	, Case 
		when Substring(OFPR.Code, 6,2) = '01' then 'ENERO' 
		when Substring(OFPR.Code, 6,2) = '02' then 'FEBRERO' 
		when Substring(OFPR.Code, 6,2) = '03' then 'MARZO' 
		when Substring(OFPR.Code, 6,2) = '04' then 'ABRIL' 
		when Substring(OFPR.Code, 6,2) = '05' then 'MAYO' 
		when Substring(OFPR.Code, 6,2) = '06' then 'JUNIO' 
		when Substring(OFPR.Code, 6,2) = '07' then 'JULIO' 
		when Substring(OFPR.Code, 6,2) = '08' then 'AGOSTO' 
		when Substring(OFPR.Code, 6,2) = '09' then 'SEPTIEMBRE' 
		when Substring(OFPR.Code, 6,2) = '10' then 'OCTUBRE' 
		when Substring(OFPR.Code, 6,2) = '11' then 'NOVIEMBRE' 
		when Substring(OFPR.Code, 6,2) = '12' then 'DICIEMBRE' 
	End AS NOM_MES
	, Cast(OFPR.F_RefDate as date) AS FEC_INI
	, Cast(OFPR.T_RefDate as date) AS FEC_FIN
From OFPR;

*/

