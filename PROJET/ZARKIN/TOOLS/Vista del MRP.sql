-- Vista que parece corresponde al MRP de SIZ Martes 20 de agosto 2024 

-- SE CAMBIA OWOR.DueDate para usar U_FCompras,para semana de compras (11/05/2021 ALBERTO MEDINA)
-- SUBSTRING(CAST(year(COALESCE (OWOR.DueDate, DATEADD(day, 90, CAST(GETDATE() AS DATE)))/*Se agregan 90 dias si la fecha es NULL*/ ) AS nvarchar(5)), 3, 2) * 100 + datepart(iso_week,COALESCE (OWOR.DueDate,DATEADD(day, 90, CAST(GETDATE() AS DATE)))AS semana_c,

Select * From (
SELECT OWOR.PlannedQty
	/*Se agregan 90 dias si la fecha es NULL*/
	, SUBSTRING(CAST(year(COALESCE (OWOR.U_FCompras, DATEADD(day, 90, CAST(GETDATE() AS DATE)))
	   ) AS nvarchar(5)), 3, 2) * 100 + datepart(iso_week, COALESCE (OWOR.U_FCompras, DATEADD(day, 90, 
	   CAST(GETDATE() AS DATE)))) AS semana_c
	, SUBSTRING(CAST(year(COALESCE (OWOR.U_FProduccion, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) 
       AS nvarchar(5)), 3, 2) * 100 + datepart(iso_week, COALESCE (OWOR.U_FProduccion, DATEADD(day, 90, 
	   CAST(GETDATE() AS DATE)))) AS semana_p
	, CASE WHEN OITM.ItmsGrpCod <> 113 THEN ITT1.Quantity WHEN OITM.ItmsGrpCod = 113 AND (ITT1.Quantity -
       (SELECT SUM(IssuedQty) FROM WOR1 WHERE DocEntry = OWOR.DocEntry AND WOR1.ItemCode = itt1.Code
       GROUP BY ItemCode)) > 0 THEN (ITT1.Quantity - (SELECT SUM(IssuedQty) FROM WOR1 WHERE DocEntry = OWOR.DocEntry 
	   AND WOR1.ItemCode = itt1.Code GROUP BY ItemCode)) ELSE 0 END AS Cantidad
	, dbo.OWOR.DocEntry
	, dbo.OWOR.U_C_Orden
	, 'P' AS Father
	, 'P' AS hijo
	, dbo.OWOR.Status
	, dbo.ITT1.Code AS ItemCode
	, dbo.OITM.ItemName
FROM dbo.ITT1 
INNER JOIN dbo.OWOR ON dbo.OWOR.ItemCode = dbo.ITT1.Father 
INNER JOIN dbo.OITM a3 ON a3.ItemCode = dbo.ITT1.Father 
INNER JOIN dbo.OITM ON OITM.ItemCode = dbo.ITT1.Code
WHERE (dbo.OWOR.Status = 'P' OR dbo.OWOR.Status = 'R') 
AND (dbo.OWOR.PlannedQty > dbo.OWOR.CmpltQty) 
AND dbo.OITM.QryGroup29 = 'N' 
AND dbo.OITM.QryGroup30 = 'N' 
AND dbo.OITM.QryGroup31 = 'N' 
AND dbo.OITM.QryGroup32 = 'N' 
AND a3.QryGroup29 = 'N' 
AND a3.QryGroup30 = 'N' 
AND a3.QryGroup31 = 'N' 
AND a3.QryGroup32 = 'N'

UNION

SELECT t2.PlannedQty
	, SUBSTRING(CAST(year(COALESCE (t2.U_FCompras, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) AS nvarchar(5)), 3, 2) *
	   100 + datepart(iso_week, COALESCE (t2.U_FCompras, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) AS semana_c
	, SUBSTRING(CAST(year(COALESCE (t2.U_FProduccion, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) AS nvarchar(5)), 
       3, 2) * 100 + datepart(iso_week, COALESCE (t2.U_FProduccion, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) AS semana_p
	, t1.Quantity * t2.Cantidad AS Cantidad
	, t2.DocEntry
	, t2.U_C_Orden
	, t1.Father
	, 'H' AS hijo
	, t2.Status
	, t1.ItemCode
	, t1.ItemName
FROM (
SELECT dbo.ITT1.Father
	, OITM_5.ItemCode
	, OITM_5.ItemName
	, dbo.ITT1.Quantity
FROM dbo.ITT1 
INNER JOIN dbo.OITM AS OITM_5 ON OITM_5.ItemCode = dbo.ITT1.Code
WHERE (OITM_5.QryGroup29 = 'N') 
AND (OITM_5.QryGroup30 = 'N') 
AND (OITM_5.QryGroup31 = 'N') 
AND (OITM_5.QryGroup32 = 'N')) AS t1 
INNER JOIN (
SELECT dbo.ITT1.Code
	, OWOR.DueDate
	, OWOR.PlannedQty
	, OWOR.U_FCompras
	, OWOR.U_FProduccion
	, CASE WHEN OITM.ItmsGrpCod <> 113 THEN ITT1.Quantity 
	   WHEN OITM.ItmsGrpCod = 113 AND (ITT1.Quantity - (SELECT sum(IssuedQty)
                                                               FROM            WOR1
                                                               WHERE        DocEntry = OWOR.DocEntry AND WOR1.ItemCode = itt1.Code
                                                               GROUP BY ItemCode)) > 0 THEN (ITT1.Quantity -
                                                             (SELECT        sum(IssuedQty)
                                                               FROM            WOR1
                                                               WHERE        DocEntry = OWOR.DocEntry AND WOR1.ItemCode = itt1.Code
                                                               GROUP BY ItemCode)) ELSE 0 END AS Cantidad, OWOR.U_C_Orden, OWOR.DocEntry, OWOR.Status
                               FROM            ITT1 INNER JOIN
                                                         OWOR ON OWOR.ItemCode = ITT1.Father INNER JOIN
                                                         dbo.OITM a3 ON a3.ItemCode = dbo.ITT1.Father INNER JOIN
                                                         OITM ON OITM.ItemCode = ITT1.Code
                               WHERE        (dbo.OWOR.Status = 'P' OR
                                                         dbo.OWOR.Status = 'R') AND (dbo.OWOR.PlannedQty > dbo.OWOR.CmpltQty) AND ((dbo.OITM.QryGroup29 = 'Y') OR
                                                         (dbo.OITM.QryGroup30 = 'Y') OR
                                                         (dbo.OITM.QryGroup31 = 'Y') OR
                                                         (dbo.OITM.QryGroup32 = 'Y')) AND a3.QryGroup29 = 'N' AND a3.QryGroup30 = 'N' AND a3.QryGroup31 = 'N' AND a3.QryGroup32 = 'N') AS t2 ON t2.Code = t1.Father
UNION
SELECT        OWOR.PlannedQty, SUBSTRING(CAST(year(COALESCE (OWOR.U_FCompras, DATEADD(day, 90, CAST(GETDATE() AS DATE)))/*Se agregan 90 dias si la fecha es NULL*/ ) AS nvarchar(5)), 3, 2) 
                         * 100 + datepart(iso_week, COALESCE (OWOR.U_FCompras, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) AS semana_c, SUBSTRING(CAST(year(COALESCE (OWOR.U_FProduccion, DATEADD(day, 90, 
                         CAST(GETDATE() AS DATE)))) AS nvarchar(5)), 3, 2) * 100 + datepart(iso_week, COALESCE (OWOR.U_FProduccion, DATEADD(day, 90, CAST(GETDATE() AS DATE)))) AS semana_p, 
                         mitabla1.Cantidad * mitabla2.Quantity, mitabla1.DocEntry, owor.U_C_Orden, mitabla1.Father, mitabla2.father, mitabla1.Status, mitabla2.ItemCode, mitabla2.ItemName
FROM            /*inicia mitabla1*/ (SELECT        t1.Quantity * t2.Cantidad AS Cantidad, t2.DocEntry, t1.Father, t2.Status, t1.ItemCode, t1.ItemName
                                                                  FROM            /*inicia t1         */ (SELECT        dbo.ITT1.Father, OITM_5.ItemCode, OITM_5.ItemName, dbo.ITT1.Quantity
                                                                                                                                 FROM            dbo.ITT1 INNER JOIN
                                                                                                                                                           dbo.OITM AS OITM_5 ON OITM_5.ItemCode = dbo.ITT1.Code
                                                                                                                                 WHERE        (OITM_5.QryGroup29 = 'Y') OR
                                                                                                                                                           (OITM_5.QryGroup30 = 'Y') OR
                                                                                                                                                           (OITM_5.QryGroup31 = 'Y') OR
                                                                                                                                                           (OITM_5.QryGroup32 = 'Y')) AS t1 INNER JOIN
                                                                                               /*inicia t2*/ (SELECT        dbo.ITT1.Code, CASE WHEN OITM.ItmsGrpCod <> 113 THEN ITT1.Quantity WHEN OITM.ItmsGrpCod = 113 AND (ITT1.Quantity -
                                                                                                                                                        (SELECT        sum(IssuedQty)
                                                                                                                                                          FROM            WOR1
                                                                                                                                                          WHERE        DocEntry = OWOR.DocEntry AND WOR1.ItemCode = itt1.Code
                                                                                                                                                          GROUP BY ItemCode)) > 0 THEN (ITT1.Quantity -
                                                                                                                                                        (SELECT        sum(IssuedQty)
                                                                                                                                                          FROM            WOR1
                                                                                                                                                          WHERE        DocEntry = OWOR.DocEntry AND WOR1.ItemCode = itt1.Code
                                                                                                                                                          GROUP BY ItemCode)) ELSE 0 END AS Cantidad, OWOR.DocEntry, OWOR.Status
                                                                                                                          FROM            ITT1 INNER JOIN
                                                                                                                                                    OWOR ON OWOR.ItemCode = ITT1.Father INNER JOIN
                                                                                                                                                    dbo.OITM a3 ON a3.ItemCode = dbo.ITT1.Father INNER JOIN
                                                                                                                                                    OITM ON OITM.ItemCode = ITT1.Code
                                                                                                                          WHERE        (dbo.OWOR.Status = 'P' OR
                                                                                                                                                    dbo.OWOR.Status = 'R') AND (dbo.OWOR.PlannedQty > dbo.OWOR.CmpltQty) AND ((dbo.OITM.QryGroup29 = 'Y') OR
                                                                                                                                                    (dbo.OITM.QryGroup30 = 'Y') OR
                                                                                                                                                    (dbo.OITM.QryGroup31 = 'Y') OR
                                                                                                                                                    (dbo.OITM.QryGroup32 = 'Y')) AND a3.QryGroup29 = 'N' AND a3.QryGroup30 = 'N' AND a3.QryGroup31 = 'N' AND a3.QryGroup32 = 'N') AS t2 ON 
                                                                                           t2.Code = t1.Father) AS mitabla1 LEFT JOIN
                             (SELECT        ITT1_1.Father, OITM_1.ItemCode, OITM_1.ItemName, ITT1_1.Quantity
                               FROM            dbo.ITT1 AS ITT1_1 LEFT OUTER JOIN
                                                         dbo.OITM AS OITM_1 ON OITM_1.ItemCode = ITT1_1.Code
                               WHERE        (OITM_1.QryGroup29 = 'N') AND (OITM_1.QryGroup30 = 'N') AND (OITM_1.QryGroup31 = 'N') AND (OITM_1.QryGroup32 = 'N')) AS mitabla2 ON mitabla1.ItemCode = mitabla2.Father LEFT JOIN
                         OWOR ON OWOR.DocEntry = mitabla1.DocEntry

) TEST
Where TEST.ItemCode = '16590'
Order By TEST.DocEntry