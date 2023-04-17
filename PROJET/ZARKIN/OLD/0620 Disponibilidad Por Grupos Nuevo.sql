-- Consulta para Sacar Disponible de Materiales segun la Prioridades.
-- Ing. Vicente Cueva R.
-- Solicitado: Miercoles 20 de Junio del 2018.
-- Inicio: Martes 26 de Junio del 2018.
-- Detenido MP: Viernes 29 de Junio del 2018. 

DECLARE @FechaIS date
DECLARE @FechaFS date
DECLARE @Grupo nvarchar(20)

--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = CONVERT (DATE, '2018-04-16', 102)
Set @FechaFS = CONVERT (DATE, '2018-04-16', 102) 
Set @Grupo  = '7'

 -- Catalogo de Grupos de Planeación
-- select * from UFD1 where UFD1.TableID='OITM' and UFD1.FieldID=19 and UFD1.FldValue = '7'
-- Piel 9, Metales 7, Tornillos 17

SELECT	OITM.U_GrupoPlanea AS GPO_PLN,	
		OITM.U_Linea AS LINEA,
		OITM.ItemCode AS CODIGO, 
		OITM.ItemName AS DESCRIPCION,  
		OITM.InvntryUom AS UM,
		OITW.OnHand AS EXISTENCIA, 
		CONVERT(int, '0') AS PEDIDO,
		CONVERT(int, '0') AS PRIO_01, 
		CONVERT(int, '0') AS PRIO_03, 
		CONVERT(int, '0') AS PRIO_06, 
		CONVERT(int, '0') AS PROVEEDOR, 
		OITM.LeadTime AS LEADTIME
FROM OITM  
INNER JOIN OITW ON OITW.ItemCode = OITM.ItemCode 
Where OITW.OnHand <> 0 and (OITW.WhsCode = 'AMP-ST' or OITW.WhsCode = 'AMP-CC' or OITW.WhsCode = 'APG-PA'
or OITW.WhsCode = 'AMP-BL' or OITW.WhsCode = 'ARF-ST' or OITW.WhsCode = 'AMP-TR') and OITM.U_GrupoPlanea = @Grupo

-- Para Calculo de los Materiales en los Pedidos

SELECT	OITM_3.U_GrupoPlanea AS GPO_PLN,	
		OITM_3.U_Linea AS LINEA,
		OITM_3.ItemCode AS CODIGO, 
		OITM_3.ItemName AS DESCRIPCION,  
		OITM_3.InvntryUom AS UM,
		CONVERT(INT, '0') AS EXISTENCIA, 
		RDR1.OpenQty * ITT1.Quantity AS PEDIDO,
		CONVERT(int, '0') AS PRIO_01, 
		CONVERT(int, '0') AS PRIO_03, 
		CONVERT(int, '0') AS PRIO_06, 
		CONVERT(int, '0') AS PROVEEDOR, 
		OITM_3.LeadTime AS LEADTIME	
FROM ORDR 
INNER JOIN RDR1 ON RDR1.DocEntry = ORDR.DocEntry 
INNER JOIN ITT1 ON ITT1.Father = RDR1.ItemCode 
INNER JOIN OITM OITM_3 ON OITM_3.ItemCode = ITT1.Code 
Where (dbo.ORDR.U_Procesado = 'N') AND (dbo.ORDR.CANCELED = 'N') AND (RDR1.TreeType <> 'S') AND (RDR1.LineStatus = 'O') 
and OITM_3.U_GrupoPlanea = @Grupo and RDR1.OpenQty * ITT1.Quantity > 0 





Order By DESCRIPCION

--INNER JOIN dbo.OBTN ON dbo.OIBT.BatchNum = dbo.OBTN.DistNumber AND dbo.OBTN.ItemCode = dbo.OIBT.ItemCode 
--LEFT OUTER JOIN (SELECT ItemCode, SUM(OnHand) AS ONHAND FROM dbo.OITW AS OITW_5 WHERE (WhsCode = 'AMP-ST') OR
--(WhsCode = 'AMP-CC') OR (WhsCode = 'APT-FX') OR (WhsCode = 'ATG-FX') GROUP BY ItemCode) AS ALMACENES ON dbo.OITM.ItemCode = ALMACENES.ItemCode
--WHERE  (dbo.OITM.ItmsGrpCod = 113) AND (dbo.OIBT.Quantity > 0) and dbo.oitm.ItemCode = '10015'


--GROUP BY dbo.OITM.ItemCode, dbo.OITM.ItemName,  dbo.OITM.QryGroup7, dbo.OITM.InvntryUom,
 --dbo.OIBT.WhsCode, dbo.OIBT.BaseLinNum, dbo.OIBT.BatchNum, dbo.OBTN.MnfSerial, dbo.OBTN.LotNumber, 
 --dbo.OBTN.InDate, dbo.OITM.LeadTime, dbo.OITM.U_Linea, dbo.OITM.FrgnName, dbo.OITM.U_GrupoPlanea
 
 
 /*
 ALMACENES.ONHAND,
 select * from OITW

 select * from OITB

 
UNION ALL

SELECT	OITM_3.ItemCode, 
		OITM_3.ItemName, 
		ALMACENES_4.ONHAND, 
		OITM_3.QryGroup7, 
		OITM_3.InvntryUom, 
		CONVERT(INT, '0') AS CANTIDAD, 
		CONVERT(INT, '0') AS BASELINNUM,
		'***' AS BATCHNUM, 
		'0' AS MNFSERIAL, 
		'0' AS LOTNUMBER, 
		CONVERT(INT, '0') AS INDATE, 
		'*****' AS WHSCODE, 
		SUM(dbo.RDR1.OpenQty * dbo.ITT1.Quantity) AS EN_PEDIDO, 
        CONVERT(INT, '0') AS OC_PEDIDOS_PROVEEDOR, 
		CONVERT(INT, '0') AS FALTANTE_PROD1, 
		CONVERT(int, '0') AS FALTANTE_PROD3, 
		CONVERT(int, '0') AS FALTANTE_PROD6, 
        OITM_3.LeadTime AS TE, 
		OITM_3.U_Linea, 
		OITM_3.FrgnName
FROM dbo.ORDR 
INNER JOIN dbo.RDR1 ON dbo.RDR1.DocEntry = dbo.ORDR.DocEntry 
INNER JOIN dbo.ITT1 ON dbo.ITT1.Father = dbo.RDR1.ItemCode 
INNER JOIN dbo.OITM AS OITM_3 ON OITM_3.ItemCode = dbo.ITT1.Code 
LEFT OUTER JOIN dbo.OITB ON OITM_3.ItmsGrpCod = dbo.OITB.ItmsGrpCod
LEFT OUTER JOIN (SELECT ItemCode, SUM(OnHand) AS ONHAND FROM dbo.OITW AS OITW_4 WHERE (WhsCode = 'AMP-ST') OR
(WhsCode = 'AMP-CC') OR (WhsCode = 'APT-FX') OR (WhsCode = 'ATG-FX')
GROUP BY ItemCode) AS ALMACENES_4 ON OITM_3.ItemCode = ALMACENES_4.ItemCode 
WHERE (dbo.ORDR.U_Procesado = 'N') AND (dbo.ORDR.CANCELED = 'N') AND (dbo.RDR1.TreeType <> 'S') AND (dbo.RDR1.LineStatus = 'O') AND 
(OITM_3.ItmsGrpCod = 113)
GROUP BY OITM_3.ItemCode, OITM_3.ItemName, OITM_3.InvntryUom, ALMACENES_4.ONHAND, OITM_3.QryGroup7, 
OITM_3.InvntryUom, dbo.ORDR.DocDueDate, dbo.OITB.ItmsGrpNam, dbo.ORDR.DocEntry, OITM_3.LeadTime, 
OITM_3.U_Linea, OITM_3.FrgnName
                         
UNION ALL
                          
SELECT	OITM_2.ItemCode, 
		OITM_2.ItemName, 
		ALMACENES_3.ONHAND, 
		OITM_2.QryGroup7, 
		OITM_2.InvntryUom, 
		CONVERT(INT, '0') AS CANTIDAD, 
		CONVERT(INT, '0') AS RECHAZADO, 
		CONVERT(INT, '0') AS BASELINNUM, 
		'0' AS BATCHNUM, '0' AS MNFSERIAL, 
		'0' AS LOTNUMBER, 
		CONVERT(INT, '0') AS INDATE,
		'0' AS WHSCODE, 
		CONVERT(INT, '0') AS EN_PEDIDO, 
		CONVERT(INT, '0') AS OC_PEDIDO_PROVEEDOR, 
		CASE WHEN WOR1.IssuedQty > 0 THEN 0 ELSE CASE WHEN OWOR.U_C_Orden = 'C' THEN wor1.PlannedQty ELSE 0 END END AS FALTANTE_PROD1, 
        CASE WHEN WOR1.IssuedQty > 0 THEN 0 ELSE CASE WHEN OWOR.U_C_Orden = 'S' THEN wor1.PlannedQty ELSE 0 END END AS FALTANTE_PROD3, 
        CASE WHEN WOR1.IssuedQty > 0 THEN 0 ELSE CASE WHEN OWOR.U_C_Orden = 'P' THEN wor1.PlannedQty ELSE 0 END END AS FALTANTE_PROD6,
		OITM_2.LeadTime AS te, 
		OITM_2.U_Linea, 
        OITM_2.FrgnName
FROM dbo.OWOR 
INNER JOIN dbo.WOR1 ON dbo.WOR1.DocEntry = dbo.OWOR.DocEntry 
INNER JOIN dbo.OITM AS OITM_2 ON OITM_2.ItemCode = dbo.WOR1.ItemCode 
INNER JOIN dbo.OITB AS OITB_2 ON OITM_2.ItmsGrpCod = OITB_2.ItmsGrpCod 
LEFT OUTER JOIN (SELECT ItemCode, SUM(OnHand) AS ONHAND FROM dbo.OITW AS OITW_3 WHERE (WhsCode = 'AMP-ST') OR
(WhsCode = 'AMP-CC') OR (WhsCode = 'APT-FX') OR (WhsCode = 'ATG-FX') GROUP BY ItemCode) AS ALMACENES_3 
ON OITM_2.ItemCode = ALMACENES_3.ItemCode WHERE (dbo.OWOR.Status <> 'C') AND (dbo.OWOR.Status <> 'L') AND
(OITM_2.ItmsGrpCod = 113) GROUP BY dbo.WOR1.DocEntry, dbo.WOR1.PlannedQty, dbo.WOR1.IssuedQty, OITM_2.ItemCode,
OITM_2.QryGroup7, OITM_2.ItemName, ALMACENES_3.ONHAND, OITM_2.InvntryUom, dbo.WOR1.PlannedQty, dbo.WOR1.IssuedQty,
OITM_2.LeadTime, OITM_2.U_Linea, OITM_2.FrgnName, dbo.OWOR.U_C_Orden
                          
						  
UNION ALL

SELECT	dbo.POR1.ItemCode, 
		OITM_1.ItemName, 
		ALMACENES_2.ONHAND, 
		OITM_1.QryGroup7, 
		OITM_1.InvntryUom, 
		CONVERT(INT, '0') AS Cantidad, 
		CONVERT(INT, '0') AS RECHAZADO, 
		CONVERT(INT, '0') AS BASELINNUM, 
		'0' AS BATCHNUN, '0' AS MNFSERIAL, 
		'0' AS LOTNUMBER, 
		CONVERT(INT, '0') AS INDATE, 
		'0' AS WHSCODE, 
		CONVERT(INT, '0') AS EN_PEDIDO, 
		SUM(dbo.POR1.OpenQty) AS OC_Pedido_Proveedor, 
		CONVERT(INT, '0') AS FALTANTE_PROD1, 
		CONVERT(int, '0') AS FALTANTE_PROD3, 
		CONVERT(int, '0') AS FALTANTE_PROD6, 
		OITM_1.LeadTime AS te, 
		OITM_1.U_Linea, 
        OITM_1.FrgnName
FROM dbo.OPOR 
INNER JOIN dbo.POR1 ON dbo.POR1.DocEntry = dbo.OPOR.DocEntry 
INNER JOIN dbo.OITM AS OITM_1 ON OITM_1.ItemCode = dbo.POR1.ItemCode 
INNER JOIN dbo.OITB AS OITB_1 ON OITB_1.ItmsGrpCod = OITM_1.ItmsGrpCod 
LEFT OUTER JOIN dbo.[@PL_RUTAS] ON dbo.[@PL_RUTAS].Code = OITM_1.U_estacion 
LEFT OUTER JOIN (SELECT ItemCode, SUM(OnHand) AS ONHAND FROM dbo.OITW AS OITW_2 WHERE (WhsCode = 'AMP-ST') OR
(WhsCode = 'AMP-CC') OR (WhsCode = 'APT-FX') OR (WhsCode = 'ATG-FX')                                                          GROUP BY ItemCode) AS ALMACENES_2 ON OITM_1.ItemCode = ALMACENES_2.ItemCode
WHERE (dbo.OPOR.CANCELED = 'N') AND (dbo.POR1.OpenQty > 0) AND (OITM_1.ItmsGrpCod = 113)
GROUP BY OITB_1.ItmsGrpNam, dbo.POR1.ItemCode, OITM_1.ItemName, OITM_1.InvntryUom, OITM_1.QryGroup7, 
ALMACENES_2.ONHAND, OITM_1.LeadTime, OITM_1.U_Linea, OITM_1.FrgnName
                          
UNION ALL

SELECT	I.Code AS CODIGO,
		TM.ItemName AS PIEL, 
		ALMACENES_1.ONHAND, 
		TM.QryGroup7 AS qrygroup7, 
		TM.InvntryUom AS INVNTRYUOM, 
		0 AS CANTIDAD, 
		0 AS RECHAZADO, 
		0 AS BASELINENUM,
		'---' AS BACTNUM, 
		0 AS MNFSERIAL, 
		0 AS LOTNUMBER, 
		0 AS INDATE, 
		'----' AS WHSCODE, 
		0 AS EN_PEDIDO, 
		0 AS OC_PEDIDOS_PROVEEDOR, 
		0 AS FALTANTE_PROD1, 
		0 AS FALTANTE_PROD3, 
        0 AS FALTANTE_PROD6, 
		TM.LeadTime AS TE, 
		CASE WHEN MONTH(F.Date) = 1 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS ENERO, 
		CASE WHEN MONTH(F.Date) = 2 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS FEBRERO, 
		CASE WHEN MONTH(F.Date) = 3 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS MARZO, 
		CASE WHEN MONTH(F.Date) = 4 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS ABRIL, 
		CASE WHEN MONTH(F.Date) = 5 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS MAYO, 
		CASE WHEN MONTH(F.Date) = 6 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS JUNIO,
		CASE WHEN MONTH(F.Date) = 7 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS JULIO, 
		CASE WHEN MONTH(F.Date) = 8 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS AGOSTO, 
		CASE WHEN MONTH(F.Date) = 9 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS SEPTIEMBRE, 
		CASE WHEN MONTH(F.Date) = 10 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS OCTUBRE, 
		CASE WHEN MONTH(F.Date) = 11 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS NOVIEMBRE, 
		CASE WHEN MONTH(F.Date) = 12 THEN SUM(F.Quantity * I.Quantity) ELSE 0 END AS DICIEMBRE, 
		TM.U_Linea, 
		TM.FrgnName
FROM dbo.OFCT AS O 
INNER JOIN dbo.FCT1 AS F ON O.AbsID = F.AbsID 
INNER JOIN dbo.OITM AS OI ON F.ItemCode = OI.ItemCode 
LEFT OUTER JOIN dbo.ITT1 AS I ON F.ItemCode = I.Father 
LEFT OUTER JOIN dbo.OITM AS TM ON I.Code = TM.ItemCode 
LEFT OUTER JOIN (SELECT ItemCode, SUM(OnHand) AS ONHAND FROM dbo.OITW AS OITW_1 WHERE (WhsCode = 'AMP-ST') OR
(WhsCode = 'AMP-CC') OR (WhsCode = 'APT-FX') OR (WhsCode = 'ATG-FX') GROUP BY ItemCode) AS ALMACENES_1 ON 
TM.ItemCode = ALMACENES_1.ItemCode
WHERE (TM.ItmsGrpCod = 113) AND (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, F.Date) AS varchar(4)),
 4, 1)) * 100 + MONTH(F.Date) >= CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE()) AS varchar(4)),
  4, 1)) * 100 + MONTH(GETDATE())) GROUP BY MONTH(F.Date), I.Code, TM.ItemName, F.Date, ALMACENES_1.ONHAND, 
  TM.QryGroup7, TM.InvntryUom, TM.LeadTime, TM.U_Linea, TM.FrgnName
  
  
  
) AS ALMACEN


GROUP BY U_Linea, ItemCode, ItemName, ONHAND, QryGroup7, LeadTime, InvntryUom, FrgnName
ORDER BY U_Linea, FrgnName, ItemName

*/
