-- Consulta para Validar Completado de ordenes.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Modificación: 09 de Abril del 2018
-- ****************** DESARROLLO DEL REPORTE ***************************

--Asignar valores a cargar. 
DECLARE @FechaIS date
DECLARE @FechaFS date

--Parametros Fecha Inicial y Fecha Final (aaaa-mm-dd)
Set @FechaIS = CONVERT (DATE, '2024-01-01', 102)
Set @FechaFS = CONVERT (DATE, '2024-02-04', 102) 

-- Contador de Ordenes Cerradas.
Select COUNT(CIERRE.ItemCode) as Cerrados
from (Select OWOR.DocEntry, OWOR.ItemCode, OWOR.CloseDate
from OWOR
Where Cast (OWOR.CloseDate as DATE) between @FechaIS and @FechaFS) CIERRE

-- Resumen de Rompimientos
Select	COUNT(ROMPER.ItemCode) as RENGLONES,  
		ROMPER.ItemCode, 
		ROMPER.Dscription, 
SUM(ROMPER.Movimiento) AS CANTIDAD, ROMPER.InvntryUom, SUM(ROMPER.IMPORTE) AS IMPORTE
From 
( Select OINM.CardName, OINM.BASE_REF, OINM.AppObjAbs, OINM.DocDate, OINM.CreateDate, 
OINM.JrnlMemo, OINM.ItemCode, OINM.Dscription, ITM1.Price as COST01, OINM.RevalTotal,
(OINM.InQty-OINM.OutQty) as Movimiento, (OINM.InQty-OINM.OutQty)*ITM1.Price as IMPORTE, OINM.UserSign, OUSR.U_NAME, OINM.Warehouse,
 OITM.U_VS, OINM.Comments, OITM.U_TipoMat, OINM.DocTime, OWOR.ItemCode as OPModelo,
 OITM.InvntryUom
 from OINM 
 inner join OUSR on OINM.UserSign=OUSR.USERID 
 inner join OITM on OINM.ItemCode=OITM.ItemCode 
 left join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
 inner join ITM1 on OINM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10
 Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS AND
 (OINM.JrnlMemo LIKE 'Emi%' or OINM.JrnlMemo LIKE 'Issu%')  and OUSR.U_NAME Like 'VICENTE%') ROMPER
 Group by ROMPER.ItemCode, ROMPER.Dscription, ROMPER.InvntryUom
  order by COUNT(ROMPER.ItemCode) DESC, ROMPER.Dscription
  
-- Detalle del Rompimiento
Select	Cast(OINM.CreateDate as  DATE) AS FECHA,
		OINM.AppObjAbs AS NO_OP,
		OWOR.ItemCode as MODELO,
		A3.ItemName AS MUEBLE,
		OINM.JrnlMemo AS DOCUMENTO, 
		OINM.ItemCode AS COD_ART, 
		OITM.ItemName AS MATERIAL,  
		OITM.InvntryUom AS UDM,
		(OINM.InQty-OINM.OutQty) AS CANTIDAD, 
		OITM.U_TipoMat AS TIP_MAT
 From OINM 
 inner join OUSR on OINM.UserSign=OUSR.USERID 
 inner join OITM on OINM.ItemCode=OITM.ItemCode 
 left join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
 inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
 inner join ITM1 on OINM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10
 Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS AND
 OINM.JrnlMemo LIKE 'Emi%' and OUSR.U_NAME Like 'VICENTE%'
 ORDER BY OINM.CreateDate