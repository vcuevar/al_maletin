-- R147 Inspección de Calidad.
-- ID: 250417-261
--TAREA: Desarrollar e implementar un sistema digital para calidad.
--VISION: Una aplicación que permita llevar a cabo inspecciones de forma digital y ligada a la
--información de SAP y que se obtenga la información de control requerida.
--SOLICITADO: Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 31 de Octubre del 2025; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date

Declare @Estacion nVarchar(3)
Declare @nCiclo nVarchar(7) 
Declare @Articulo nVarchar(5)
Declare @xNomArea nVarchar(15)
Declare @nProcesI Int
Declare @nProcesF Int

Set @Estacion = '221'
Set @nCiclo = '2025'
Set @Articulo = '20649'

Set @FechaIS = CONVERT (DATE, '2025-11-01', 102)
Set @FechaFS = CONVERT (DATE, '2025-11-28', 102)

-- Calcula el Principio y final del Año.
--Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
--Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')


-- Calcula el Principio y final de cada mes.
--Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-11')
--Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-11')


-- Tablas Claves de la Inspeccion
-- Select * from Siz_InspeccionProceso
-- Select * from Siz_InspeccionProcesoDetalle
-- Select * from Siz_InspeccionProcesoImagen
-- Select * from Siz_Checklist
-- Select * from Siz_Calendario_Cierre

/* ============================================================================
|  Reporte de Inspecion en proceso por areas. HOJA 2 DE MACRO 147             |
=============================================================================*/
/*

Select	Cast(SIP.IPR_fechaInspeccion as date) AS FECHA
	, SCC.MES AS MES
	, DATEPART(ISO_WEEK, SIP.IPR_fechaInspeccion) AS SEMANA
	, SIP.IPR_centroInspeccion AS ESTACION	
	, Case 
		When SIP.IPR_centroInspeccion = 136 then 'CORTE/COSTURA'
		When SIP.IPR_centroInspeccion = 146 then 'COJINERIA'
		When SIP.IPR_centroInspeccion = 169 then 'TAPICERIA'
		When SIP.IPR_centroInspeccion = 175 then 'EMPAQUE'
		When SIP.IPR_centroInspeccion = 418 then 'CARPINTERIA' else 'ESTACION NO DEFINIDA'
	  End AS ESTACION
	, Case
		WHEN EST.Code between 109 and 118 then 'CORTE'
		WHEN EST.Code between 121 and 139 then 'COSTURA'
		WHEN EST.Code between 140 and 146 then 'COJINERIA'
		WHEN EST.Code between 140 and 146 then 'COJINERIA'
		WHEN EST.Code between 148 and 169 then 'TAPICERIA'
		WHEN EST.Code between 172 and 175 then 'EMPAQUE'
		WHEN EST.Code between 403 and 415 then 'CARPINTERIA' else 'AREA NO DEFINIDA'
	End AS AREA 
	, EST.Name AS PROCESO
	, SIP.IPR_op AS OP
	, SIP.IPR_codArticulo AS CODIGO
	, A3.ItemName AS MODELO
	, A3.U_VS AS VS
	, IPD.IPD_empID AS NOMINA
	, OHEM.firstName + ' ' + OHEM.lastName AS PERSONA

	, Cast(SCL.CHK_id as varchar) + ' ' + SCL.CHK_descripcion AS DEFECTIVO
	, IPD.IPD_estado AS CUMPLE
	, SIP.IPR_estado AS RESULTADO
	, SIP.IPR_nomInspector AS INSPECTOR 
From Siz_InspeccionProceso SIP
Inner Join Siz_InspeccionProcesoDetalle IPD on SIP.IPR_id = IPD.IPD_iprId
Inner Join Siz_Calendario_Cierre SCC on CAST(SIP.IPR_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Inner Join Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
Inner Join [@PL_RUTAS] EST on SCL.CHK_area_inspeccionada =  EST.Code
Inner Join OITM A3 on A3.ItemCode = SIP.IPR_codArticulo 
Inner Join OHEM on OHEM.empID = IPD.IPD_empID
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_borrado = 'N'
Order By AREA, OP, PROCESO

*/


/* ============================================================================
|  Reporte de Top 3 Defectivos. HOJA 3 DE MACRO 147                           |
=============================================================================*/
-- Rango de las Areas
-- CORTE		109 a 118
-- COSTURA		121 a 139
-- COJINERIA	140 a 146
-- TAPICERIA	148 a 169
-- EMPAQUE		172 A 175
-- CARPINTERIA 	403 a 415

Set @xNomArea = 'COSTURA'
Set @nProcesI = 121
Set @nProcesF = 139

Select TOP(3)TP3.AREA AS AREA
	, TP3.DEFECTIVO AS DEFECTIVO
	, Count(TP3.RECHAZOS) AS CONTEO
From (
Select  @xNomArea AS AREA	
	, SIP.IPR_docEntry AS OP
	, Cast(IPD.IPD_chkId as varchar) + ' ' + SCL.CHK_descripcion AS DEFECTIVO
	, Count(IPD.IPD_chkId) RECHAZOS
From Siz_InspeccionProcesoDetalle IPD
Inner Join Siz_InspeccionProceso SIP on SIP.IPR_id = IPD.IPD_iprId
Inner Join Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
Inner Join [@PL_RUTAS] PROCES on SCL.CHK_area_inspeccionada = PROCES.Code
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_borrado = 'N'
and PROCES.Code between @nProcesI and @nProcesF
Group By SIP.IPR_docEntry, IPD.IPD_chkId, SCL.CHK_descripcion ) TP3
Group By TP3.AREA, TP3.DEFECTIVO
Order By CONTEO
