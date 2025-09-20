-- Consulta para obtener los periodos autorizados por contabilidad
-- Para implementar en los reportes donde se solicitan Semanas o Meses.
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 15 de septiembre del 2025; Origen.


-- Informaciónde la Tabla de Periodos en SAP (OFPR)
Select OFPR.Code AS PERIODO
	, Substring(OFPR.Code, 1,4) AS CICLO
	, Substring(OFPR.Code, 6,2) AS MES
	, Cast(OFPR.F_RefDate as date) AS FEC_INI
	, Cast(OFPR.T_RefDate as date) AS FEC_FIN
	, DatePart(iso_week, Cast(OFPR.F_RefDate as date)) AS SEM_INI
	, DatePart(iso_week, Cast(OFPR.T_RefDate as date)) AS SEM_FIN
	, DatePart(iso_week, GetDate()) AS SEM_HOY
	, DATEFROMPARTS(Substring(OFPR.Code, 1,4), 1, 1) AS SABE	   	  
From OFPR
Where Code  Like '2025%'


-- Metodo para saber los limites de una semana
Select Cast(OFPR.F_RefDate as date) AS FEC_INI
	, Cast(OFPR.F_RefDate as int) AS NUM_INI
	,  DatePart(iso_week, GetDate()) AS SEM_HOY
	, Cast(Cast((Cast(OFPR.F_RefDate as float)+((38-1)*7)) as datetime) as date) AS FEC_LUN
	, Cast(Cast((Cast(OFPR.F_RefDate as float)+((38-1)*7)+6) as datetime) as date) AS FEC_DOM
From OFPR
Where OFPR.Code = '2025-01'


-- Metodo para saber los limites de una semana
Declare @nCiclo nVarchar(4) = '2025'
Declare @nSem Int = 38

Select Cast(Cast((Cast(OFPR.F_RefDate as float)+((@nSem-1)*7)) as datetime) as date) AS FEC_LUN
	, Cast(Cast((Cast(OFPR.F_RefDate as float)+((@nSem-1)*7)+6) as datetime) as date) AS FEC_DOM
	, Cast(OFPR.F_RefDate as float) AS NUMERO
From OFPR
Where OFPR.Code = @nCiclo + '-01'


