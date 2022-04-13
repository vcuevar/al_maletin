-- Consulta para Destajos de Corte de Piel.
-- Ing. Vicente Cueva R.
-- Lunes 13 de Abril del 2018
-- ****************** DESARROLLO DEL REPORTE ***************************

--Asignar valores a cargar. 
DECLARE @FechaIS date
DECLARE @FechaFS date

--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = CONVERT (DATE, '2018-04-09', 102)
Set @FechaFS = CONVERT (DATE, '2018-04-15', 102) 

-- Consulta para el Detalle
/*
Select CAST(CP.U_FechaHora as DATE) as Fecha, OP.DocEntry, RH.firstName, RH.lastName, 
OP.ItemCode, A3.ItemName as Mueble, A3.U_VS , A3.U_Modelo, (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) AS TEORICO from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join CPDES on SUBSTRING(OP.ItemCode,1,7) = CPDES.CODE01 
Where Cast (CP.U_FechaHora as DATE) BETWEEN  @FechaIS and @FechaFS  and CP.U_CT=112
Order by RH.firstName, RH.lastName, CAST(CP.U_FechaHora as DATE) 
*/


-- Consulta para Resumen del Destajo
Select DET.U_EmpGiro, DET.firstName, DET.lastName, SUM(DET.TEOR_01) AS TEORIA_01, 
SUM(DET.TEOR_02) AS TEORIA_02, SUM(DET.TEOR_03) AS TEORIA_03, SUM(DET.TEOR_04) AS TEORIA_04, 
SUM(DET.TEOR_05) AS TEORIA_05, SUM(DET.TEOR_06) AS TEORIA_06, SUM(DET.TEOR_07) AS TEORIA_07
from (
Select CAST(CP.U_FechaHora as DATE) as Fecha, OP.DocEntry, RH.U_EmpGiro, RH.firstName, RH.lastName, 
OP.ItemCode, A3.ItemName as Mueble, A3.U_VS , A3.U_Modelo,
Case When CAST(CP.U_FechaHora as DATE) = @FechaIS then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_01, 
Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 1, @FechaIS) then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_02,
Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 2, @FechaIS) then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_03,
Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 3, @FechaIS) then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_04,
Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 4, @FechaIS) then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_05,
Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 5, @FechaIS) then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_06,
Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 6, @FechaIS) then
 (Select SUM(ITT1.Quantity)
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_07
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join CPDES on SUBSTRING(OP.ItemCode,1,7) = CPDES.CODE01 
Where Cast (CP.U_FechaHora as DATE) BETWEEN  @FechaIS and @FechaFS  and CP.U_CT=112) DET
Group by DET.U_EmpGiro, DET.firstName, DET.lastName
Order by DET.firstName, DET.lastName



Select DET.U_EmpGiro, DET.firstName, DET.lastName, SUM(DET.TEOR_01) AS TEORIA_01, SUM(DET.TEOR_02) AS TEORIA_02, SUM(DET.TEOR_03) AS TEORIA_03, SUM(DET.TEOR_04) AS TEORIA_04, SUM(DET.TEOR_05) AS TEORIA_05, SUM(DET.TEOR_06) AS TEORIA_06, SUM(DET.TEOR_07) AS TEORIA_07 from ( Select CAST(CP.U_FechaHora as DATE) as Fecha, OP.DocEntry, RH.U_EmpGiro, RH.firstName, RH.lastName, OP.ItemCode, A3.ItemName as Mueble, A3.U_VS , A3.U_Modelo, Case When CAST(CP.U_FechaHora as DATE) = " & FechaI & " then (Select SUM(ITT1.Quantity) from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and ITT1.Father = OP.ItemCode) else 0 end AS TEOR_01, Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 1, " & FechaI & ") then (Select SUM(ITT1.Quantity) 
from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and ITT1.Father = OP.ItemCode) else 0 end AS TEOR_02, Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 2, " & FechaI & ") then (Select SUM(ITT1.Quantity) from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and ITT1.Father = OP.ItemCode) else 0 end AS TEOR_03, Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 3, " & FechaI & ") then (Select SUM(ITT1.Quantity) from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and ITT1.Father = OP.ItemCode) else 0 end AS TEOR_04, Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 4, " & FechaI & ") then (Select SUM(ITT1.Quantity) from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and 
ITT1.Father = OP.ItemCode) else 0 end AS TEOR_05, Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 5, " & FechaI & ") then (Select SUM(ITT1.Quantity) from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and ITT1.Father = OP.ItemCode) else 0 end AS TEOR_06, Case When CAST(CP.U_FechaHora as DATE) =  DATEADD(day, 6, " & FechaI & ") then (Select SUM(ITT1.Quantity) from ITT1 inner join OITM on ITT1.Code = OITM.ItemCode Where OITM.ItmsGrpCod = 113 and ITT1.Father = OP.ItemCode) else 0 end AS TEOR_07 from OWOR OP inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry inner join OHEM RH on CP.U_idEmpleado=RH.empID inner join OITM A3 on OP.ItemCode=A3.ItemCode left join CPDES on SUBSTRING(OP.ItemCode,1,7) = CPDES.CODE01 Where Cast (CP.U_FechaHora as DATE) BETWEEN " & FechaI & " and " & FechaF & " and CP.U_CT=112) DET 
Group by DET.U_EmpGiro, DET.firstName, DET.lastName Order by DET.firstName, DET.lastName 
