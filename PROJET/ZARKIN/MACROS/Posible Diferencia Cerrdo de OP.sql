-- Nombre Reporte: R119 - B Comparativo de Cascos VS Fundas.
-- Solicito: Nadie Propuesta para generar programa de cascos.
-- Modificacion para Propuesta de Programa de Casco.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Enero del 2015; Origen.
-- Actualizado: Martes 15 de Junio del 2021; Mover a SAP 10
-- Actualizado: Viernes 02 de Septiembre del 2022; Propuesta de Cambio.

-- ================================================================================================
-- |               PARAMETROS GENERALES PARA EXCEPCIONES.                                         |
-- ================================================================================================
Declare @FechaIS nvarchar(30)
Declare @FechaFS nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2024/07/10', 102)
Set @FechaFS = CONVERT (DATE, '2024/07/10', 102)

-- ================================================================================================
-- |               DESARROLLO DEL PROCESO.                                                        |
-- ================================================================================================

Select OWOR.CloseDate
	, OWOR.DocEntry
	, OWOR.ItemCode
	, OITM.ItemName
	, OWOR.CmpltQty AS CANT
	, OITM.U_VS
	, OITM.U_TipoMat
	, ITM1.Price as LIST_10
	, (
	Select SUM(LOP.IssuedQty*P10.Price) AS IMP 
	from WOR1 LOP 
	inner join ITM1 P10 on LOP.ItemCode= P10.ItemCode and P10.PriceList=10 
	inner join OITM AP1 on P10.ItemCode = AP1.ItemCode and AP1.ItmsGrpCod  <> 113 
	Where LOP.DocEntry = OWOR.DocEntry
	) AS IMPO_OP
	, (
	Select SUM(LET.Quantity * L10.Price) AS IMPO 
	from ITT1 LET 
	inner join ITM1 L10 on LET.Code = L10.ItemCode and L10.PriceList = 10  
	inner join OITM AP2 on L10.ItemCode = AP2.ItemCode and AP2.ItmsGrpCod <> 113 
	Where LET.Father = OWOR.ItemCode 
	) * OWOR.CmpltQty AS IMPO_LT 
from OWOR 
inner join OITM on OWOR.ItemCode = OITM.ItemCode 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 

Where Cast(OWOR.CloseDate as date) between @FechaIS and @FechaFS 
Order by OWOR.CloseDate, OITM.ItemName 
   