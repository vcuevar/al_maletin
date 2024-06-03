-- Macro 139 Defectivos Calidad.
-- Objetivo: Reporte de los defectivos capturados eb SIZ, Captura de defectivos.
-- Solicitado: Sr. Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 10 de Mayo del 2024; Origen.
-- Actualizado: 


/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2024-01-01', 102)
Set @FechaFS = CONVERT (DATE, '2024-01-19', 102)
Set @xCodProd =  '17871' 

/* ==============================================================================================
|  Reporte Defectivos rango de fecha.                                                           |
============================================================================================== */

Select cde_id AS ID
	, CAST(cde_fecha as Date) AS FECHA
	, DATENAME(month, cde_fecha) AS MES
	, DATEPART(month, cde_fecha) AS MES2
	, Case When 
		DATEPART(month, cde_fecha) = 1 Then 'ENERO'
		DATEPART(month, cde_fecha) = 2 Then 'FEBRERO'
		DATEPART(month, cde_fecha) = 3 Then 'ENERO'
	, *

From SIZ_Calidad_Defectivos_Estadistico



Select *
From SIZ_Calidad_Defectivos_Estadistico


-- Catalogo de Defectivos por Area.

Select *
From SIZ_Calidad_Defectivos





