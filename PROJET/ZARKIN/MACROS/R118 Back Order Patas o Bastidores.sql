-- Nombre Reporte: R118 Back Order Patas y Bastidores.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 22 de Abril del 2021; Origen a SAP 10.


--Consulta para obtener el reporte.Procedimiento para Agrupar por Grupo de Cadenas de Distribución.
    
Select	OWOR.U_OT
		, OWOR.DocEntry
		, OWOR.DueDate
		, OWOR.ItemCode
		, OITM.ItemName
		, OWOR.PlannedQty-owor.CmpltQty As Cantidad
		, OITM.U_VS
		,(OWOR.PlannedQty-owor.CmpltQty) * OITM.U_VS as Total
		, OWOR.Status 
		, OWOR.U_Status
		--, OWOR.U_Starus
		, UFD1.Descr 
from OWOR 
inner join OITM on OWOR.ItemCode=OITM.ItemCode 
left join UFD1 on OWOR.U_Status=UFD1.FldValue and UFD1.TableID='OWOR' and UFD1.FieldID=7
where OITM.U_TipoMat='CA' and OWOR.PlannedQty-owor.CmpltQty > 0 and OWOR.Status = 'P' 
Order by OWOR.DueDate, OITM.ItemName, OWOR.DocEntry 

 select * from  vw_SofPatasBastidores where proceso > 0 or  poriniciar > 0 order by duedate, U_OT, ItemName 












 SELECT        ItemCode, ItemName, U_VS, U_OT, DocNum, U_Entrega_Piel, SUM(INVENTARIO) AS inventario, SUM(PlannedQty) AS Planeado, SUM(CmpltQty) AS Completado, CASE WHEN SUM(Casco.Pendientes) IS NULL 
                         THEN 0 ELSE SUM(Casco.Pendientes) END AS Proceso, SUM(PlannedQty - CmpltQty) - CASE WHEN SUM(Casco.Pendientes) IS NULL THEN 0 ELSE SUM(Casco.Pendientes) END AS PorIniciar, 
                         CASE WHEN SUM(Casco.Habilitado) IS NULL THEN 0 ELSE SUM(Casco.Habilitado) END AS Habilitado, CASE WHEN SUM(Casco.Armado) IS NULL THEN 0 ELSE SUM(Casco.Armado) END AS Armado, 
                         CASE WHEN SUM(Casco.Preparado) IS NULL THEN 0 ELSE SUM(Casco.Preparado) END AS Preparado, CASE WHEN SUM(Casco.Inspeccion) IS NULL THEN 0 ELSE SUM(Casco.Inspeccion) END AS Inspeccion, 
                         DueDate
FROM            (SELECT        dbo.OITM.ItemCode, dbo.OITM.U_VS, dbo.OITM.ItemName, 0 AS INVENTARIO, dbo.OWOR.PlannedQty, dbo.OWOR.CmpltQty, dbo.OWOR.U_OT, dbo.OWOR.DocNum, dbo.OWOR.U_Entrega_Piel, 
                                                    dbo.OWOR.DueDate,
                                                        (SELECT        SUM(dbo.[@CP_OF].U_Recibido) - SUM(dbo.[@CP_OF].U_Procesado) AS Pendientes
                                                          FROM            dbo.[@CP_OF] INNER JOIN
                                                                                    dbo.OWOR AS OW ON OW.DocNum = dbo.[@CP_OF].U_DocEntry
                                                          WHERE        (dbo.[@CP_OF].U_CT = 403 OR
                                                                                    dbo.[@CP_OF].U_CT = 406 OR
                                                                                    dbo.[@CP_OF].U_CT = 415 OR
                                                                                    dbo.[@CP_OF].U_CT = 418) AND (OW.Status = 'R') AND (dbo.[@CP_OF].U_DocEntry = dbo.OWOR.DocNum)
                                                          GROUP BY dbo.[@CP_OF].U_DocEntry) AS Pendientes,
                                                        (SELECT        SUM([@CP_OF_4].U_Recibido) - SUM([@CP_OF_4].U_Procesado) AS Pendientes
                                                          FROM            dbo.[@CP_OF] AS [@CP_OF_4] INNER JOIN
                                                                                    dbo.OWOR AS OW ON OW.DocNum = [@CP_OF_4].U_DocEntry
                                                          WHERE        ([@CP_OF_4].U_CT = 403) AND (OW.Status = 'R') AND ([@CP_OF_4].U_DocEntry = dbo.OWOR.DocNum)
                                                          GROUP BY [@CP_OF_4].U_DocEntry, [@CP_OF_4].U_CT) AS Habilitado,
                                                        (SELECT        SUM([@CP_OF_3].U_Recibido) - SUM([@CP_OF_3].U_Procesado) AS Pendientes
                                                          FROM            dbo.[@CP_OF] AS [@CP_OF_3] INNER JOIN
                                                                                    dbo.OWOR AS OW ON OW.DocNum = [@CP_OF_3].U_DocEntry
                                                          WHERE        ([@CP_OF_3].U_CT = 406) AND (OW.Status = 'R') AND ([@CP_OF_3].U_DocEntry = dbo.OWOR.DocNum)
                                                          GROUP BY [@CP_OF_3].U_DocEntry, [@CP_OF_3].U_CT) AS Armado,
                                                        (SELECT        SUM([@CP_OF_2].U_Recibido) - SUM([@CP_OF_2].U_Procesado) AS Pendientes
                                                          FROM            dbo.[@CP_OF] AS [@CP_OF_2] INNER JOIN
                                                                                    dbo.OWOR AS OW ON OW.DocNum = [@CP_OF_2].U_DocEntry
                                                          WHERE        ([@CP_OF_2].U_CT = 415) AND (OW.Status = 'R') AND ([@CP_OF_2].U_DocEntry = dbo.OWOR.DocNum)
                                                          GROUP BY [@CP_OF_2].U_DocEntry, [@CP_OF_2].U_CT) AS Preparado,
                                                        (SELECT        SUM([@CP_OF_1].U_Recibido) - SUM([@CP_OF_1].U_Procesado) AS Pendientes
                                                          FROM            dbo.[@CP_OF] AS [@CP_OF_1] INNER JOIN
                                                                                    dbo.OWOR AS OW ON OW.DocNum = [@CP_OF_1].U_DocEntry
                                                          WHERE        ([@CP_OF_1].U_CT = 418) AND (OW.Status = 'R') AND ([@CP_OF_1].U_DocEntry = dbo.OWOR.DocNum)
                                                          GROUP BY [@CP_OF_1].U_DocEntry, [@CP_OF_1].U_CT) AS Inspeccion
                          FROM            dbo.OWOR INNER JOIN
                                                    dbo.OITM ON dbo.OITM.ItemCode = dbo.OWOR.ItemCode
                          WHERE        (dbo.OWOR.Status = 'R') AND (dbo.OITM.QryGroup31 = 'Y')
                          UNION ALL
                          SELECT        OITM_1.ItemCode, OITM_1.U_VS, OITM_1.ItemName, SUM(dbo.OITW.OnHand) AS Inventario, 0 AS ot, 0 AS Planeado, 0 AS Completado, 0 AS Proceso, 0 AS Habilitado, 0 AS Armado, 0 AS Preparado, 
                                                   0 AS Inspeccion, 0 AS docnum, 0 AS u_Entrega_PIel, 0 AS duedate
                          FROM            dbo.OITW INNER JOIN
                                                   dbo.OITM AS OITM_1 ON OITM_1.ItemCode = dbo.OITW.ItemCode
                          WHERE        (OITM_1.QryGroup31 = 'Y')
                          GROUP BY OITM_1.ItemCode, OITM_1.U_VS, OITM_1.ItemName
                          HAVING        (SUM(dbo.OITW.OnHand) > 0)) AS Casco
GROUP BY ItemCode, ItemName, U_VS, U_OT, DocNum, U_Entrega_Piel, DueDate