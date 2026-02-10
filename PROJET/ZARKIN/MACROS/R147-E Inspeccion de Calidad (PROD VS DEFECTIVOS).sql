-- R147-E Inspección de Calidad (PROD VS DEFECTIVOS POR PERSONA).
-- Modilo 5 Hoja 5
-- ID: 250417-261
-- TAREA: Desarrollar e implementar un sistema digital para calidad.
-- VISION: Una aplicación que permita llevar a cabo inspecciones de forma digital y ligada a la
-- información de SAP y que se obtenga la información de control requerida.
-- SOLICITADO: Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de enero del 2026; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @nCiclo as nVarchar(7) 
Declare @xNomMes as nVarchar(25)
Declare @xNumMes as nVarchar(2) 
Declare @nSemanas as Int
Declare @nAjusSema as int
Declare @nSemIni as int

--Declare @Articulo nVarchar(5)
--Declare @xNomArea nVarchar(15)
--Declare @nProcesI Int
--Declare @nProcesF Int
--Declare @Estacion nVarchar(3)
--Set @Estacion = '221'
--Set @Articulo = '20649'

Set @nCiclo = '2026'
Set @xNomMes = 'ENERO'
Set @nAjusSema = 1

/* ============================================================================
|  Reporte de Indicadores por semana. Hoja 5 de la Macro 147-F                |
=============================================================================*/

-- Determina numero de semanas del mes y numero de semanas de acuerdo al periodo (nCiclo).
Set @xNumMes = (Select MES from Siz_Calendario_Cierre SCC Where SCC.CICLO = @nCiclo and NOM_MES = @xNomMes)
Set @nSemanas = (Select SEMXMES from Siz_Calendario_Cierre SCC Where SCC.CICLO = @nCiclo and NOM_MES = @xNomMes)

-- Determina Inicio y Fin del Mes 
Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-' + @xNumMes )
Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-' + @xNumMes)

-- Select SCC.FEC_INI AS FI
--	, DATEPART(ISO_WEEK, SCC.FEC_INI) - @nAjusSema AS SEMINI
--	, NOM_CTO, NOM_MES, SEMXMES 
-- From Siz_Calendario_Cierre SCC 
-- Where SCC.PERIODO = @nCiclo + '-' + @xNumMes

Print 'Numero de Mes ' + @xNumMes;
Print 'Numero de Semanas ' + Cast(@nSemanas as Varchar);
Print 'FI ' + Cast(@FechaIS as Varchar);
Print 'FF ' + Cast(@FechaFS as Varchar);

-- Calcula el Principio y final del Año.
-- Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
-- Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')

-- Para llenar el reporte de la Hoja 5 con Produccion y Rechazos por Operario.


Set @nSemIni = (Select MIN(DATEPART(ISO_WEEK, CP.U_FechaHora) - @nAjusSema) AS SEMANA
from [@CP_LOGOF] CP
Where Cast(CP.U_FechaHora as date) between  @FechaIS and @FechaFS)

Print 'La Semana en que inicia es: ' + Str(@nSemIni)

Select BAS2.AREA
	, BAS2.NUM_NOM
	, BAS2.NOMBRE
	, BAS2.OPERA
	, SUM(BAS2.PRCAN_A) PRCAN_1
	, SUM(BAS2.RECAN_A) RECAN_1
	, SUM(BAS2.PRVS_A) PRVS_1
	, SUM(BAS2.REVS_A) REVS_1
	, SUM(BAS2.PRCAN_B) PRCAN_2
	, SUM(BAS2.RECAN_B) RECAN_2
	, SUM(BAS2.PRVS_B) PRVS_2
	, SUM(BAS2.REVS_B) REVS_2
	, SUM(BAS2.PRCAN_C) PRCAN_3
	, SUM(BAS2.RECAN_C) RECAN_3
	, SUM(BAS2.PRVS_C) PRVS_3
	, SUM(BAS2.REVS_C) REVS_3
	, SUM(BAS2.PRCAN_D) PRCAN_4
	, SUM(BAS2.RECAN_D) RECAN_4
	, SUM(BAS2.PRVS_D) PRVS_4
	, SUM(BAS2.REVS_D) REVS_4
	, SUM(BAS2.PRCAN_E) PRCAN_5
	, SUM(BAS2.RECAN_E) RECAN_5
	, SUM(BAS2.PRVS_E) PRVS_5
	, SUM(BAS2.REVS_E) REVS_5
From (
Select BAS.MES 
	, BAS.SEMANA
	, BAS.AREA
	, BAS.NUM_NOM
	, BAS.NOMBRE
	, BAS.OPERA
	, Case When BAS.SEMANA = @nSemIni then SUM(BAS.PRO_UNID) else 0 end AS PRCAN_A
	, Case When BAS.SEMANA = @nSemIni then SUM(BAS.REC_UNID) else 0 end AS RECAN_A
	, Case When BAS.SEMANA = @nSemIni then SUM(BAS.PRO_VS) else 0 end AS PRVS_A
	, Case When BAS.SEMANA = @nSemIni then SUM(BAS.REC_VS) else 0 end AS REVS_A
	, Case When BAS.SEMANA = @nSemIni + 1 then SUM(BAS.PRO_UNID) else 0 end AS PRCAN_B
	, Case When BAS.SEMANA = @nSemIni + 1 then SUM(BAS.REC_UNID) else 0 end AS RECAN_B
	, Case When BAS.SEMANA = @nSemIni + 1 then SUM(BAS.PRO_VS) else 0 end AS PRVS_B
	, Case When BAS.SEMANA = @nSemIni + 1 then SUM(BAS.REC_VS) else 0 end AS REVS_B
	, Case When BAS.SEMANA = @nSemIni + 2 then SUM(BAS.PRO_UNID) else 0 end AS PRCAN_C
	, Case When BAS.SEMANA = @nSemIni + 2 then SUM(BAS.REC_UNID) else 0 end AS RECAN_C
	, Case When BAS.SEMANA = @nSemIni + 2 then SUM(BAS.PRO_VS) else 0 end AS PRVS_C
	, Case When BAS.SEMANA = @nSemIni + 2 then SUM(BAS.REC_VS) else 0 end AS REVS_C
	, Case When BAS.SEMANA = @nSemIni + 3 then SUM(BAS.PRO_UNID) else 0 end AS PRCAN_D
	, Case When BAS.SEMANA = @nSemIni + 3 then SUM(BAS.REC_UNID) else 0 end AS RECAN_D
	, Case When BAS.SEMANA = @nSemIni + 3 then SUM(BAS.PRO_VS) else 0 end AS PRVS_D
	, Case When BAS.SEMANA = @nSemIni + 3 then SUM(BAS.REC_VS) else 0 end AS REVS_D
	, Case When BAS.SEMANA = @nSemIni + 4 then SUM(BAS.PRO_UNID) else 0 end AS PRCAN_E
	, Case When BAS.SEMANA = @nSemIni + 4 then SUM(BAS.REC_UNID) else 0 end AS RECAN_E
	, Case When BAS.SEMANA = @nSemIni + 4 then SUM(BAS.PRO_VS) else 0 end AS PRVS_E
	, Case When BAS.SEMANA = @nSemIni + 4 then SUM(BAS.REC_VS) else 0 end AS REVS_E
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
	, OHEM.U_EmpGiro AS NUM_NOM
	, OHEM.firstName + ' ' + OHEM.lastName AS NOMBRE 
	, OHEM.jobTitle AS OPERA
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
Left Join OHEM on OHEM.empID = IPD.IPD_empID
Where Cast(SIP.IPR_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and IPD.IPD_estado = 'N'
and IPD.IPD_borrado = 'N'
and OHEM.jobTitle <> '0.0 VIRTUAL' and OHEM.dept <> 5
Union All
Select SCC.MES AS MES
	, DATEPART(ISO_WEEK, CP.U_FechaHora) - @nAjusSema AS SEMANA
	, Case
		WHEN CP.U_CT between 109 and 118 then '1 CORTE'
		WHEN CP.U_CT between 121 and 139 then '2 COSTURA'
		WHEN CP.U_CT between 140 and 146 then '3 COJINERIA'
		WHEN CP.U_CT between 148 and 169 then '4 TAPICERIA'
		WHEN CP.U_CT between 172 and 175 then '5 EMPAQUE'
		WHEN CP.U_CT between 403 and 418 then '6 CARPINTERIA' else '7 NO DEFINIDA'
	End AS AREA 
	, OHEM.U_EmpGiro AS NUM_NOM
	, OHEM.firstName + ' ' + OHEM.lastName AS NOMBRE 
	, OHEM.jobTitle AS OPERA
	, CP.U_DocEntry AS OP
	, CP.U_Cantidad AS PRO_UNID
	, A3.U_VS * CP.U_Cantidad AS PRO_VS
	, 0 AS REC_UNID
	, 0 AS REC_VS
from [@CP_LOGOF] CP
inner join OWOR on OWOR.DocEntry = CP.U_DocEntry 
Inner Join Siz_Calendario_Cierre SCC on CAST(CP.U_FechaHora as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Inner Join OITM A3 on A3.ItemCode = OWOR.ItemCode
Left join OHEM on CP.U_idEmpleado = OHEM.empID
Where Cast(CP.U_FechaHora as date) between  @FechaIS and @FechaFS 
and OHEM.jobTitle <> '0.0 VIRTUAL' and OHEM.dept <> 5
) BAS
Group By BAS.MES, BAS.SEMANA, BAS.AREA, BAS.NUM_NOM, BAS.NOMBRE, BAS.OPERA 
) BAS2
Group By BAS2.AREA, BAS2.NUM_NOM, BAS2.NOMBRE, BAS2.OPERA
Order By BAS2.AREA, BAS2.OPERA, BAS2.NOMBRE


