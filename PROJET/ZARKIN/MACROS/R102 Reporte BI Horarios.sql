-- Macro R102 Reporte BI Horarios
-- Presentar la produccion capturada por cada dos horas.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: 16/Octubre/2015; Origen.
-- Actualizado: Jueves 30/Agosto/2018; Estandariza RBV y Realiza Multiplicacion por Cantidades.
-- Actualizado: Viernes 19 de Febrero del 2021; Cambio a Thengel.

-- Parametros
-- Fecha Inicial.
-- Fecha Final se toma la misma.

-- Variables
Declare @FechaIS as nvarchar(30)
Declare @FechaFS as nvarchar(30)

Set @FechaIS = '2022/08/25'
Set @FechaFS = '2022/08/25'


Select BIHR.AREA
	, BIHR.RUTA
	, SUM(BIHR.CT01) as CT1
	, SUM(BIHR.VS01) as VS1
	, SUM(BIHR.CT02) as CT2
	, SUM(BIHR.VS02) as VS2
	, SUM(BIHR.CT03) as CT3
	, SUM(BIHR.VS03) as VS3
	, SUM(BIHR.CT04) as CT4
	, SUM(BIHR.VS04) as VS4
	, SUM(BIHR.CT05) as CT5
	, SUM(BIHR.VS05) as VS5
	, SUM(BIHR.CT06) as CT6
	, SUM(BIHR.VS06) as VS6
	, SUM(BIHR.CANT) as CTT
	, SUM(BIHR.VS) as VST 
from ( 

Select  [@CP_LOGOF].U_DocEntry as OP
	, [@CP_LOGOF].U_CT as AREA
	, RUT.Name AS RUTA
	, CAST([@CP_LOGOF].U_FechaHora as DATE) as Fecha
	, CAST([@CP_LOGOF].U_FechaHora as TIME) as Hora
	, OP.ItemCode as CODIGO
	, A3.ItemName as ARTICULO
	, [@CP_LOGOF].U_Cantidad as CANT
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) < = CAST('10:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT01
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('10:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('12:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT02
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('12:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('14:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT03
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('14:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('16:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT04
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('16:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT05
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT06
	
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) < = CAST('10:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS  else 0 end as VS01, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('10:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('12:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS02
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('12:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('14:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS03
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('14:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('16:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS04
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('16:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS05
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS06
	, [@CP_LOGOF].U_Cantidad * A3.U_VS as VS  
from [@CP_LOGOF] 
inner join OWOR OP on [@CP_LOGOF].U_DocEntry = OP.DocEntry 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
inner join [@PL_RUTAS] RUT on RUT.Code=[@CP_LOGOF].U_CT 
where  Cast([@CP_LOGOF].U_FechaHora as Date) BETWEEN @FechaIS and @FechaIS ) BIHR 
Group by  BIHR.AREA, BIHR.RUTA 
order by BIHR.AREA 


-- Detalle del Reporte.
Select  [@CP_LOGOF].U_DocEntry as OP
	, [@CP_LOGOF].U_CT as AREA
	, RUT.Name AS RUTA
	, convert(varchar,[@CP_LOGOF].U_FechaHora,9) as Fecha
	, CAST([@CP_LOGOF].U_FechaHora as TIME) as Hora
	, OP.ItemCode as CODIGO
	, A3.ItemName as ARTICULO
	, [@CP_LOGOF].U_Cantidad as CANT
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) < = CAST('10:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT01
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('10:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('12:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT02
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('12:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('14:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT03
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('14:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('16:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT04
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('16:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT05
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT06
	
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) < = CAST('10:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS  else 0 end as VS01, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('10:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('12:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS02
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('12:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('14:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS03
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('14:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('16:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS04
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('16:10' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS05
	, CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('18:10' as TIME) then [@CP_LOGOF].U_Cantidad * A3.U_VS else 0 end as VS06
	, [@CP_LOGOF].U_Cantidad * A3.U_VS as VS  
from [@CP_LOGOF] 
inner join OWOR OP on [@CP_LOGOF].U_DocEntry = OP.DocEntry 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
inner join [@PL_RUTAS] RUT on RUT.Code=[@CP_LOGOF].U_CT 
where  Cast([@CP_LOGOF].U_FechaHora as Date) BETWEEN @FechaIS and @FechaIS and  [@CP_LOGOF].U_CT = '175'
order by AREA, Hora 


/*
select CONVERT(varchar, U_FechaHora,109) as HORA
	, CONVERT(varchar, getdate(),112) as FOLIO,  * from [@CP_LOGOF] HIS 
where HIS.U_DocEntry = 24100 and U_CT = 175
Order by HORA
*/






 