DECLARE @FechaIS as DATE
DECLARE @FechaFS as DATE
Declare @nAjusSema as int

SET @FechaIS = '20260202'
SET @FechaFS = '20260228'
Set @nAjusSema = 1


SELECT 
	BAS.AREA
	, BAS.NUM_NOM
	, BAS.NOMBRE
	, BAS.OPERA
	, BAS.BONO
	, V_META.META
	, BAS.SEMANA
	, SUM(BAS.PRO_UNID) AS PRO_UNID
	, SUM(BAS.REC_UNID) AS REC_UNID
FROM (

SELECT 
	CASE
		WHEN SCL.CHK_area_inspeccionada between 109 and 118 then '1 CORTE'
	    WHEN SCL.CHK_area_inspeccionada between 121 and 139 then '2 COSTURA'
        WHEN SCL.CHK_area_inspeccionada between 140 and 146 then '3 COJINERIA'
        WHEN SCL.CHK_area_inspeccionada between 148 and 169 then '4 TAPICERIA'
		WHEN SCL.CHK_area_inspeccionada between 403 and 418 then '6 CARPINTERIA' 
        else 'NO DEFINIDA' END AS AREA
	, OHEM.U_EmpGiro AS NUM_NOM
	, OHEM.firstName + ' ' + OHEM.lastName AS NOMBRE
	, OHEM.jobTitle AS OPERA
	, ISNULL(OHEM.Pager, '') AS BONO
	, DATEPART(ISO_WEEK, SIP.IPR_fechaInspeccion) - @nAjusSema AS SEMANA
    , 0 AS PRO_UNID
	, SIP.IPR_cantInspeccionada AS REC_UNID
FROM Siz_InspeccionProceso SIP
INNER JOIN Siz_InspeccionProcesoDetalle IPD on SIP.IPR_id = IPD.IPD_iprId
INNER JOIN Siz_Checklist SCL on SCL.CHK_id = IPD.IPD_chkId
INNER JOIN OHEM on IPD.IPD_empID = OHEM.empID
WHERE CAST(SIP.IPR_fechaInspeccion as date) between @FechaIS and @FechaFS
and IPD.IPD_estado = 'N' and IPD.IPD_borrado = 'N'
and OHEM.U_EmpGiro IS NOT NULL
and OHEM.jobTitle <> '0.0 VIRTUAL' and OHEM.dept <> 5

UNION ALL

SELECT 
	CASE 
		WHEN CP.U_CT between 109 and 118 then '1 CORTE'
        WHEN CP.U_CT between 121 and 139 then '2 COSTURA'
        WHEN CP.U_CT between 140 and 146 then '3 COJINERIA'
        WHEN CP.U_CT between 148 and 175 then '4 TAPICERIA'
		WHEN CP.U_CT between 403 and 418 then '6 CARPINTERIA' 
        else 'NO DEFINIDA' END AS AREA
	, OHEM.U_EmpGiro AS NUM_NOM
	, OHEM.firstName + ' ' + OHEM.lastName AS NOMBRE
	, OHEM.jobTitle AS OPERA
	, ISNULL(OHEM.Pager, '') AS BONO
	, DATEPART(ISO_WEEK, CP.U_FechaHora) - @nAjusSema AS SEMANA 
	, CP.U_Cantidad AS PRO_UNID
	, 0 AS REC_UNID
FROM [@CP_LOGOF] CP
INNER JOIN OWOR on OWOR.DocEntry = CP.U_DocEntry
INNER JOIN OHEM on CP.U_idEmpleado = OHEM.empID
WHERE CAST(CP.U_FechaHora as date) between @FechaIS and @FechaFS
and OHEM.jobTitle <> '0.0 VIRTUAL' and OHEM.dept <> 5
and OHEM.U_EmpGiro IS NOT NULL
) BAS
Inner Join (Select U_Tipo AS ID
					,Case
						WHEN U_Tipo = 1 then '1 CORTE'
                        WHEN U_Tipo = 2 then '2 COSTURA'
                        WHEN U_Tipo = 3 then '3 COJINERIA'
                        WHEN U_Tipo = 4 then '6 CARPINTERIA'
						WHEN U_Tipo = 5 then '4 TAPICERIA' 
						WHEN U_Tipo = 6 then '5 EMPAQUE' 
                        else 'NO DEFINIDA'
                        END AS AREA
				, Cast(U_Cuota as decimal(16,3))/100 AS META
				FROM [@PL_RUTAS]
				Group By U_Tipo, U_Cuota ) V_META on V_META.AREA = BAS.AREA
WHERE BAS.AREA <> 'NO DEFINIDA'
GROUP BY BAS.AREA, BAS.NUM_NOM, BAS.NOMBRE, BAS.OPERA, BAS.BONO, BAS.SEMANA, V_META.META
ORDER BY BAS.AREA, BAS.NOMBRE, BAS.SEMANA





/*
' Tabla de las Metas por Areas.
Select U_Tipo AS ID
	,Case
		WHEN U_Tipo = 1 then '1 CORTE'
        WHEN U_Tipo = 2 then '2 COSTURA'
        WHEN U_Tipo = 3 then '3 COJINERIA'
        WHEN U_Tipo = 4 then '6 CARPINTERIA'
		WHEN U_Tipo = 5 then '4 TAPICERIA' 
		WHEN U_Tipo = 6 then '5 EMPAQUE' 
        else 'NO DEFINIDA'
        END AS AREA
, Cast(U_Cuota as decimal(16,3))/100 AS META
FROM [@PL_RUTAS]
Group By U_Tipo, U_Cuota 
Order By AREA
*/