
-- Producción de Areas Costura en adelante

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date

Set @FechaIS = CONVERT (DATE, '2021-04-01', 102)
Set @FechaFS = CONVERT (DATE, '2021-05-05', 102)

Select	CAST(CP.U_FechaHora as DATE) as Fecha
		, OP.DocEntry
		, RH.firstName
		, RH.lastName
		, OP.ItemCode
		, A3.ItemName as Mueble
		, A3.U_VS 
		, Left(A3.ItemCode, 4) as U_Modelo
		, A4.ItemName 
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join OITM A4 on Left(A3.ItemCode, 4) = A4.ItemCode --and A4.U_IsModel = 'S' 
Where CP.U_FechaHora BETWEEN @FechaIS and @FechaFS --and (CP.U_CT=121) 
Order by CAST(CP.U_FechaHora as DATE), RH.firstName 

Select CAST(CP.U_FechaHora as DATE) as Fecha, OP.DocEntry, RH.firstName, RH.lastName, OP.ItemCode, A3.ItemName as Mueble, A3.U_VS ,
 Left(A3.ItemCode, 4) as U_Modelo, A4.ItemName from OWOR OP inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry inner join OHEM RH on CP.U_idEmpleado=RH.empID inner join OITM A3 on OP.ItemCode=A3.ItemCode 

inner join OITM A4 on Left(A3.ItemCode, 4) = A4.ItemCode
Where CP.U_FechaHora BETWEEN '" & FechaI & " 00:00' and '" & FechaF & " 23:59:59' and (CP.U_CT=124) 
Order by CAST(CP.U_FechaHora as DATE), RH.firstName 

     /*
Select	OWOR.DocNum
		, sum(WOR1.IssuedQty) as Usado 
		, OWOR.ItemCode 
		, OHEM.firstName AS LOGISTICA
		, OHEM.middleName AS APELLIDO  
		, (a.u_vs * OWOR.PlannedQty ) as u_vs 
		, OITM.ItmsGrpCod
		, OWOR.closedate  
		, a.itemname 
		, sum(WOR1.IssuedQty*OITM.AvgPrice) as mUsado  
		, (vwsof_pieles1.cantidad * OWOR.PlannedQty) as Teorico 
		, (vwsof_pieles1.monto * OWOR.PlannedQty) as mTeorico
		, SUBSTRING(owor.itemcode,9,5) as piel
		, (select TOP 1 OH.firstName 
from [@CP_LOGOF] LF 
INNER JOIN OHEM OH ON LF.U_idEmpleado = OH.empID WHERE (LF.U_CT =1 or LF.U_CT =106) AND LF.U_DocEntry = OWOR.DocNum ) AS firstName, LOF.FECHA,(select TOP 1 OH.middleName from [@CP_LOGOF] LF 
INNER JOIN OHEM OH ON LF.U_idEmpleado = OH.empID WHERE (LF.U_CT =1 or LF.U_CT =112) AND LF.U_DocEntry = OWOR.DocNum ) AS middleName  from WOR1 inner join OWOR on OWOR.DocEntry = WOR1.DocEntry inner join OITM on OITM.ItemCode = WOR1.ItemCode inner join OITM a on a.ItemCode = OWOR.itemcode inner join vwSof_Pieles1 on vwSof_Pieles1.father = OWOR.ItemCode
INNER JOIN (SELECT U_DocEntry , sum(U_Cantidad) as Cantidad, U_idEmpleado,  DATEADD(dd, 0, DATEDIFF(dd, 0, U_FechaHora)) AS FECHA 
FROM [@CP_LOGOF] WHERE (U_CT=106)  group by U_DocEntry , U_idEmpleado, DATEADD(dd, 0, DATEDIFF(dd, 0, U_FechaHora))  ) LOF ON LOF.U_DocEntry = OWOR.DocNum inner join OHEM on OHEM.empID =  LOF.U_idEmpleado where OITM.ItmsGrpCod = 113 and DATEADD(dd, 0, DATEDIFF(dd, 0, LOF.Fecha)) between '" & FechaI & "' and '" & FEchaF & "'  group by OITM.ItmsGrpCod ,OHEM.firstName, 
OHEM.middleName , OWOR.ItemCode , a.u_vs ,OWOR.DocNum , OWOR.closedate , a.itemname , vwsof_pieles1.cantidad, vwsof_pieles1.monto, OWOR.PlannedQty,LOF.FECHA order by LOF.FECHA, OWOR.DocNum 
*/








SSQL = "Select CAST(CP.U_FechaHora as DATE) as Fecha, OP.DocEntry, RH.firstName, RH.lastName, OP.ItemCode, A3.ItemName as Mueble, A3.U_VS , Left(A3.ItemCode, 4) as U_Modelo, A4.ItemName from OWOR OP inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry inner join OHEM RH on CP.U_idEmpleado=RH.empID inner join OITM A3 on OP.ItemCode=A3.ItemCode inner join OITM A4 on Left(A3.ItemCode, 4) = A4.ItemCode " _
& "Where CP.U_FechaHora BETWEEN '" & FechaI & " 00:00' and '" & FechaF & " 23:59:59' and (CP.U_CT=124) " _
& "Order by CAST(CP.U_FechaHora as DATE), RH.firstName "


