-- R138 Seguimiento de Consumos de Telas.
-- ID: 240110-1
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 12 de Febrero del 2024; Origen.

-- Parametros Fecha Inicial y Final
Declare @FechaIS date
Declare @FechaFS date
Declare @EstaTra integer

Set @FechaIS = CONVERT(DATE, '2024-01-01', 102)
Set @FechaFS = CONVERT(DATE, '2024-01-02', 102)
Set @EstaTra = 118 -- Preparado para Costura

/*
select  OWOR.DocNum, sum(WOR1.IssuedQty) as Usado ,OWOR.ItemCode 
	, OHEM.firstName AS LOGISTICA,OHEM.middleName AS APELLIDO  
	, (a.u_vs * OWOR.PlannedQty ) as u_vs ,OITM.ItmsGrpCod, OWOR.closedate  , a.itemname ,  sum(WOR1.IssuedQty*OITM.AvgPrice) as mUsado  , (vwsof_pieles1.cantidad * OWOR.PlannedQty) as Teorico , (vwsof_pieles1.monto * OWOR.PlannedQty) as mTeorico
	, SUBSTRING(owor.itemcode,9,5) as piel
	, (select TOP 1 OH.firstName 
from [@CP_LOGOF] LF 
INNER JOIN OHEM OH ON LF.U_idEmpleado = OH.empID 
WHERE (LF.U_CT =1 or LF.U_CT =112) AND LF.U_DocEntry = OWOR.DocNum ) AS firstName
	, LOF.FECHA,(select TOP 1 OH.middleName 
from [@CP_LOGOF] LF 
INNER JOIN OHEM OH ON LF.U_idEmpleado = OH.empID 
WHERE (LF.U_CT =1 or LF.U_CT =112) AND LF.U_DocEntry = OWOR.DocNum ) AS middleName  
from WOR1 
inner join OWOR on OWOR.DocEntry = WOR1.DocEntry 
inner join OITM on OITM.ItemCode = WOR1.ItemCode 
inner join OITM a on a.ItemCode = OWOR.itemcode 
inner join vwSof_Pieles1 on vwSof_Pieles1.father = OWOR.ItemCode 
 INNER JOIN (SELECT U_DocEntry , sum(U_Cantidad) as Cantidad, U_idEmpleado,  DATEADD(dd, 0, DATEDIFF(dd, 0, U_FechaHora)) AS FECHA
 FROM [@CP_LOGOF] 
 WHERE (U_CT = 3 or U_CT=115)  
 group by U_DocEntry , U_idEmpleado, DATEADD(dd, 0, DATEDIFF(dd, 0, U_FechaHora))) LOF ON LOF.U_DocEntry = OWOR.DocNum inner join OHEM on OHEM.empID =  LOF.U_idEmpleado where OITM.ItmsGrpCod = 113 and DATEADD(dd, 0, DATEDIFF(dd, 0, LOF.Fecha)) between '" & FechaIS & "' and '" & FechaFS & "'  group by OITM.ItmsGrpCod ,OHEM.firstName, 
 OHEM.middleName , OWOR.ItemCode , a.u_vs ,OWOR.DocNum , OWOR.closedate , a.itemname , vwsof_pieles1.cantidad, vwsof_pieles1.monto, OWOR.PlannedQty,LOF.FECHA order by LOF.FECHA, OWOR.DocNum 
 */

Select OWOR.CardCode AS CLIENTE  
	, OCRD.CardName AS NOMB_CLIENTE
	, Cast(REPRO.U_FechaHora as DATE) AS FEC_PREP
	, REPRO.U_DocEntry AS NUM_ORDEN
	, OWOR.OriginNum AS PEDIDO
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS MODELO
	, A3.U_VS AS VS
	, OWOR.PlannedQty AS CANTIDAD
	, A3.U_VS * OWOR.PlannedQty AS TOTAL_VS
	, OITB.ItmsGrpNam AS GPO_ART
	, WOR1.ItemCode AS COD_TELA
	, A1.ItemName AS NOM_TELA
	, WOR1.PlannedQty AS REQUERIDA
	, WOR1.IssuedQty AS CONSUMIDA
	, WOR1.PlannedQty - WOR1.IssuedQty AS DIFERENCIA
	, ITM1.Price AS PRECIO
	, WOR1.PlannedQty * ITM1.Price AS IMP_TEORICO
	, WOR1.IssuedQty * ITM1.Price AS IMP_REAL
	, OWOR.Status AS ESTATUS
	, OWOR.U_Starus AS AVANCE
	, ISNULL((Select Top(1) RT.Name from [@CP_OF] CP Inner Join [@PL_RUTAS] RT on CP.U_CT = RT.Code
		Where CP.U_DocEntry = REPRO.U_DocEntry),'SIN AVANCE') AS UBICAR
From [@CP_LOGOF] REPRO
Inner Join OWOR on REPRO.U_DocEntry = OWOR.DocNum
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join OCRD ON OWOR.CardCode = OCRD.CardCode
Inner Join OITB on A3.ItmsGrpCod = OITB.ItmsGrpCod
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode and A1.U_GrupoPlanea = 11
Inner Join ITM1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList = 10
Where Cast(REPRO.U_FechaHora as DATE) Between @FechaIS and @FechaFS and REPRO.U_CT = @EstaTra
Order By  Cast(REPRO.U_FechaHora as DATE), REPRO.U_DocEntry 



