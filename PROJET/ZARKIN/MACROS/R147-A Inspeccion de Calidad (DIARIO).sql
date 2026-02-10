-- R147-A Inspección de Calidad (DIARIO).
-- Hoja 2 
-- ID: 250417-261
-- TAREA: Desarrollar e implementar un sistema digital para calidad.
-- VISION: Una aplicación que permita llevar a cabo inspecciones de forma digital y ligada a la
-- información de SAP y que se obtenga la información de control requerida.
-- SOLICITADO: Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 31 de octubre del 2025; Origen.
-- Actualizado: Viernes 09 de enero del 2026; Agregar la cantidad del rechazo.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @nCiclo nVarchar(7) 

Set @nCiclo = '2025'
Set @FechaIS = CONVERT (DATE, '2026-01-05', 102)
Set @FechaFS = CONVERT (DATE, '2026-01-11', 102)

/* ============================================================================
|  Reporte de Inspecion en proceso por areas. HOJA 2 DE MACRO 147             |
=============================================================================*/

Select	Cast(SIP.IPR_fechaInspeccion as date) AS FECHA
	, IPR_id AS N_INSP
	, SCC.MES AS MES
	, DATEPART(ISO_WEEK, SIP.IPR_fechaInspeccion) AS SEMANA
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
	, SIP.IPR_cantInspeccionada AS CAN_RECHAZO
	, A3.U_VS * SIP.IPR_cantInspeccionada AS VS
	, OHEM.U_EmpGiro AS NOMINA
	, OHEM.firstName + ' ' + OHEM.lastName AS PERSONA
	, Cast(SCL.CHK_id as varchar) + ' ' + SCL.CHK_descripcion AS DEFECTIVO
	, SIP.IPR_nomInspector AS INSPECTOR 
	, IPD_observacion AS COMENTARIO
	, IPD.IPD_estado AS CUMPLE
	, SIP.IPR_estado AS RESULTADO
From Siz_InspeccionProceso SIP
Inner Join Siz_InspeccionProcesoDetalle IPD on SIP.IPR_id = IPD.IPD_iprId
Inner Join Siz_Calendario_Cierre SCC on CAST(SIP.IPR_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Inner Join Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
Inner Join [@PL_RUTAS] EST on SCL.CHK_area_inspeccionada =  EST.Code
Inner Join OITM A3 on A3.ItemCode = SIP.IPR_codArticulo 
Left Join OHEM on OHEM.empID = IPD.IPD_empID
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_estado = 'N'
and IPD.IPD_borrado = 'N'
Order By AREA, OP, PROCESO





--Select * From Siz_InspeccionProceso SIP Where IPR_op = 50426

--Delete  Siz_InspeccionProceso where IPR_id = 925





