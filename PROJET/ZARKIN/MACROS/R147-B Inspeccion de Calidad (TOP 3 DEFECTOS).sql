-- R147-B Inspección de Calidad (TOP 3 DEFECTOS).
-- Hoja 3
-- ID: 250417-261
-- TAREA: Desarrollar e implementar un sistema digital para calidad.
-- VISION: Una aplicación que permita llevar a cabo inspecciones de forma digital y ligada a la
-- información de SAP y que se obtenga la información de control requerida.
-- SOLICITADO: Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 31 de Octubre del 2025; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date

--Declare @Estacion nVarchar(3)
Declare @nCiclo nVarchar(7) 
--Declare @Articulo nVarchar(5)
Declare @xNomArea nVarchar(15)
Declare @nProcesI Int
Declare @nProcesF Int

--Set @Estacion = '221'
Set @nCiclo = '2026'
--Set @Articulo = '20649'

--Set @FechaIS = CONVERT (DATE, '2025-12-01', 102)
--Set @FechaFS = CONVERT (DATE, '2025-12-30', 102)

-- Calcula el Principio y final del Año.
Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')


-- Calcula el Principio y final de cada mes.
--Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
--Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')


-- Tablas Claves de la Inspeccion
-- Select * from Siz_InspeccionProceso Where IPR_docEntry = 63512 Order By IPR_creadoEn

-- Select * from Siz_InspeccionProcesoDetalle
-- Select * from Siz_InspeccionProcesoImagen
-- Select * from Siz_Checklist
-- Select * from Siz_Calendario_Cierre

/* ============================================================================
|  Reporte de Top 3 Defectivos. HOJA 3 DE MACRO 147                           |
=============================================================================*/
-- Rango de las Areas
-- CORTE		109 a 118
-- COSTURA		121 a 139
-- COJINERIA	140 a 146
-- TAPICERIA	148 a 175
-- EMPAQUE		172 A 175
-- CARPINTERIA 	403 a 418

/*

Set @xNomArea = 'CARPINTERIA'
Set @nProcesI = 403
Set @nProcesF = 415

Select TOP(3)TP3.AREA AS AREA
	, TP3.DEFECTIVO AS DEFECTIVO
	, SUM(TP3.RECHAZOS) AS CONTEO
From (
Select  @xNomArea AS AREA	
	, SIP.IPR_docEntry AS OP
	, Cast(IPD.IPD_chkId as varchar) + ' ' + SCL.CHK_descripcion AS DEFECTIVO
	, SUM(IPR_cantInspeccionada) AS RECHAZOS
From Siz_InspeccionProcesoDetalle IPD
Inner Join Siz_InspeccionProceso SIP on SIP.IPR_id = IPD.IPD_iprId
Inner Join Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
Inner Join [@PL_RUTAS] PROCES on SCL.CHK_area_inspeccionada = PROCES.Code
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_estado = 'N'
and IPD.IPD_borrado = 'N' 
and PROCES.Code between @nProcesI and @nProcesF
Group By SIP.IPR_docEntry, IPD.IPD_chkId, SCL.CHK_descripcion
) TP3
Group By TP3.AREA, TP3.DEFECTIVO
Order By CONTEO DESC

*/




Select Max(DatePart(MONTH, SIP.IPR_fechaInspeccion)) AS MES
From Siz_InspeccionProcesoDetalle IPD
Inner Join Siz_InspeccionProceso SIP on SIP.IPR_id = IPD.IPD_iprId
Inner Join Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
Inner Join [@PL_RUTAS] PROCES on SCL.CHK_area_inspeccionada = PROCES.Code
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_estado = 'N'
and IPD.IPD_borrado = 'N' 

