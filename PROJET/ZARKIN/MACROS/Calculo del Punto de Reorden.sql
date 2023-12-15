-- Macro: Calculo del Punto de Reorden.
-- Objetivo: Calculo del Punto de Reorde, el Maximo y minimo por cada material.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 09 de Noviembre del 2023; Calcular solo MP y del almacen AMP-ST.

-- ================================================================================================
-- |     P A R A M E T R O S .                                                                    |
-- ================================================================================================
Declare @FechaIS nvarchar(30)
Declare @FechaFS nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2022/11/09', 102)
Set @FechaFS = CONVERT (DATE, '2023/11/08', 102)

-- ================================================================================================
-- |     Calculo del Punto de ReordenBack Order de Fundas.                                        |
-- ================================================================================================

select WTR1.ItemCode AS Codigo
	, WTR1.Dscription AS Nombre
	, SUM(WTR1.Quantity) AS Consumo 
	, (SUM(WTR1.Quantity)/12)/20 AS XDia
	, OITM.LeadTime 
	, OITM.AvgPrice
	, OITM.U_Linea
	, OITM.U_Metodo
 from OWTR 
 inner join WTR1 on OWTR.DocEntry = WTR1.DocEntry 
 inner join OITM on WTR1.ItemCode = OITM.ItemCode 
 where Cast(OWTR.DocDate as date) between @FechaIS and @FechaFS 
 and OWTR.ToWhsCode = 'APG-ST'
 group by WTR1.ItemCode, WTR1.Dscription, OITM.LeadTime, OITM.AvgPrice, OITM.U_Linea, OITM.U_Metodo
 Order by Nombre

-- ================================================================================================
-- |     Original de la Macro al 231109: Calculo del Punto de ReordenBack Order de Fundas.        |
-- ================================================================================================
/*
Select KSUMO.Codigo, KSUMO.Nombre, SUM(KSUMO.Consumo) as Konsumo, (SUM(KSUMO.Consumo)/3)/20 as XDia
	, MP1.LeadTime, MP1.AvgPrice, MP1.U_Linea , MP1.U_Metodo 

 from (
 select WTR1.ItemCode as Codigo, WTR1.Dscription as Nombre, (SUM(WTR1.Quantity)) as Consumo 
 from OWTR 
 inner join WTR1 on OWTR.DocEntry = WTR1.DocEntry 
 where Cast(OWTR.DocDate as date) between @FechaIS and @FechaFS and 
 (WTR1.WhsCode = 'APP-ST' or WTR1.WhsCode = 'APT-PA') 
 group by WTR1.ItemCode, WTR1.Dscription, WTR1.WhsCode 
 
 Union All 

select WTR1.ItemCode as Codigo, WTR1.Dscription as Nombre, (SUM(WTR1.Quantity)) as Consumo 
from OWTR 
inner join WTR1 on OWTR.DocEntry = WTR1.DocEntry 
where Cast(OWTR.DocDate as date) between  @FechaIS and @FechaFS and WTR1.WhsCode = 'APG-ST' 
group by WTR1.ItemCode, WTR1.Dscription, WTR1.WhsCode 

Union All 

Select B2.Codigo, B2.Nombre, SUM(B2.Cantidad) as Consumo 
From (

Select IGE1.DocEntry, OIGE.CreateDate,IGE1.ItemCode as Codigo, A1.ItemName as Nombre,IGE1.Quantity as Cantidad
	, IGE1.WhsCode, OIGE.JrnlMemo 
from IGE1 
inner join OITM A1 on IGE1.ItemCode=A1.ItemCode 
inner join OIGE on IGE1.DocEntry=OIGE.DocEntry 
where Cast(OIGE.CreateDate as date) between @FechaIS and @FechaFS and A1.ItmsGrpCod='113' and OIGE.JrnlMemo like '%Emisi%') B2 
group by B2.Codigo, B2.Nombre
) KSUMO 
inner join OITM MP1 on KSUMO.Codigo=MP1.ItemCode 
Group by KSUMO.Codigo, KSUMO.Nombre, MP1.LeadTime, MP1.AvgPrice, MP1.U_Linea, MP1.U_Metodo 
Order By KSUMO.Nombre 
*/

-- EOF