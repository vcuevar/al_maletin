-- R147-C Inspección de Calidad (SEMANAL).
-- Hoja 4
-- ID: 250417-261
-- TAREA: Desarrollar e implementar un sistema digital para calidad.
-- VISION: Una aplicación que permita llevar a cabo inspecciones de forma digital y ligada a la
-- información de SAP y que se obtenga la información de control requerida.
-- SOLICITADO: Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 16 de diciembre del 2025; Origen.
-- Actualizado: Viernes 09 de enero del 2026; Agregar la cantidad rechazada.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCiclo as nVarchar(4) 
--Declare @xMes as nVarchar(2)
Declare @nAjusSema as int

Set @xCiclo = '2026'
--Set @xMes = '01'
Set @nAjusSema = 1

--Set @FechaIS = CONVERT (DATE, '2026-01-05', 102)
--Set @FechaFS = CONVERT (DATE, '2026-01-11', 102)

-- Calcula el Principio y final del Mes.
--Set @FechaIS = (Select SCC.FEC_INI AS FI From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @xCiclo + '-' + @xMes )
--Set @FechaFS = (Select SCC.FEC_FIN AS FF From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @xCiclo + '-' + @xMes )

-- Calcula el Principio y final del Año.
Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @xCiclo + '-01')
Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @xCiclo + '-12')

/* ============================================================================
|  Reporte de Indicadores por semana. Hoja 4 de la Macro 147-C                |
=============================================================================*/

-- Calcula el numero de semanas del Año solicitado.
--Select SUM(SCC.SEMXMES) AS SEMANAS from Siz_Calendario_Cierre SCC Where SCC.CICLO = @nCiclo 

-- Presenta por mes las semanas.
--Select SCC.MES, SCC.NOM_MES, SCC.SEMXMES AS SEMANAS from Siz_Calendario_Cierre SCC Where SCC.CICLO = @nCiclo Order By SCC.MES

-- Para llenar el reporte de la Hoja 4 con Produccion y Rechazos.

Select BAS.MES 
	, BAS.SEMANA
	, BAS.AREA
	, SUM(BAS.PRO_UNID) AS PRO_TCANT
	, SUM(BAS.PRO_VS) AS PRO_TVS
	, SUM(BAS.REC_UNID) AS REC_TCANT
	, SUM(BAS.REC_VS) AS REC_TVS
From ( 
Select	SCC.MES AS MES
	, DATEPART(ISO_WEEK, SIP.IPR_fechaInspeccion) - @nAjusSema AS SEMANA
	, Case
		WHEN SCL.CHK_area_inspeccionada between 109 and 118 then '1 CORTE'
		WHEN SCL.CHK_area_inspeccionada between 121 and 139 then '2 COSTURA'
		WHEN SCL.CHK_area_inspeccionada between 140 and 146 then '3 COJINERIA'
		WHEN SCL.CHK_area_inspeccionada between 148 and 169 then '4 TAPICERIA'
		WHEN SCL.CHK_area_inspeccionada between 172 and 175 then '5 EMPAQUE'
		WHEN SCL.CHK_area_inspeccionada between 403 and 418 then '6 CARPINTERIA' else '7 NO DEFINIDA'
	End AS AREA 
	, SIP.IPR_op AS OP
	, 0 AS PRO_UNID
	, 0 AS PRO_VS
	, SIP.IPR_cantInspeccionada AS REC_UNID
	, A3.U_VS * SIP.IPR_cantInspeccionada AS REC_VS
From Siz_InspeccionProceso SIP
Inner Join Siz_InspeccionProcesoDetalle IPD on SIP.IPR_id = IPD.IPD_iprId
Inner Join Siz_Calendario_Cierre SCC on CAST(SIP.IPR_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Inner Join Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
Inner Join OITM A3 on A3.ItemCode = SIP.IPR_codArticulo 
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_estado = 'N'
and IPD.IPD_borrado = 'N'
Union All
Select SCC.MES AS MES
	, DATEPART(ISO_WEEK, CP.U_FechaHora) - @nAjusSema AS SEMANA
	, Case
		WHEN CP.U_CT = 118 then '1 CORTE'
		WHEN CP.U_CT = 139 then '2 COSTURA'
		WHEN CP.U_CT = 146 then '3 COJINERIA'
		WHEN CP.U_CT = 175 then '4 TAPICERIA'
		WHEN CP.U_CT = 175 then '5 EMPAQUE'
		WHEN CP.U_CT = 418 then '6 CARPINTERIA' else '7 NO DEFINIDA'
	End AS AREA 
	, CP.U_DocEntry AS OP
	, CP.U_Cantidad AS PRO_UNID
	, A3.U_VS * CP.U_Cantidad AS PRO_VS
	, 0 AS REC_UNID
	, 0 AS REC_VS
from [@CP_LOGOF] CP
inner join OWOR on OWOR.DocEntry = CP.U_DocEntry 
Inner Join Siz_Calendario_Cierre SCC on CAST(CP.U_FechaHora as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Inner Join OITM A3 on A3.ItemCode = OWOR.ItemCode
Where Cast(CP.U_FechaHora as date) between  @FechaIS and @FechaFS 
) BAS
Group By BAS.MES, BAS.SEMANA, BAS.AREA 
Order By BAS.AREA, BAS.SEMANA 



Select MAX(DATEPART(ISO_WEEK, SIP.IPR_fechaInspeccion) - @nAjusSema) AS SEMANA
From Siz_InspeccionProceso SIP
Inner Join Siz_InspeccionProcesoDetalle IPD on SIP.IPR_id = IPD.IPD_iprId
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_estado = 'N'
and IPD.IPD_borrado = 'N'
