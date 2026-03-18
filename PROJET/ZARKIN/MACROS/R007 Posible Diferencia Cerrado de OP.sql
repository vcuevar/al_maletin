-- R147-F Inspección de Calidad (RESUMEN DE INCENTIVOS).
-- Modulo 1 Hoja 2
-- ID: 200423
-- TAREA: Realizar una comparacion de las ordenes cerradas lista de la OP y la LDM
-- VISION: Calcular los posibles no consumos que se realizaron en el periodo.
-- SOLICITADO: David Zarkin.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Sabado 21 de febrero del 2026; Origen (GAZTAMBIDE).

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @nCiclo nVarchar(7) 

Set @nCiclo = '2025-12'

--Set @FechaIS = CONVERT (DATE, '2025-01-05', 102)
--Set @FechaFS = CONVERT (DATE, '2025-02-01', 102)

-- Define las fechas del Mes,
Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo )
Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo )


/* ============================================================================
|  Reporte de Variaciones. Hoja 2 de la Macro 007                             |
=============================================================================*/

Select Cast(OWOR.CloseDate as date) AS FEC_CIERRE
	, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName
	, OITM.U_TipoMat AS T_ART
	, 

(Select SUM(LOP.IssuedQty*P10.Price) AS IMP 
from WOR1 LOP 
inner join ITM1 P10 on LOP.ItemCode= P10.ItemCode and P10.PriceList=10 
inner join OITM AP1 on P10.ItemCode = AP1.ItemCode and AP1.ItmsGrpCod  <> 113 
Where LOP.DocEntry = OWOR.DocEntry) AS IMPO_OP, 

(Select SUM(LET.Quantity * L10.Price) AS IMPO 
from ITT1 LET 
inner join ITM1 L10 on LET.Code = L10.ItemCode and L10.PriceList = 10 
inner join OITM AP2 on L10.ItemCode = AP2.ItemCode and AP2.ItmsGrpCod <> 113 Where LET.Father = OWOR.ItemCode ) * OWOR.CmpltQty AS IMPO_LT 

from OWOR 
inner join OITM on OWOR.ItemCode = OITM.ItemCode 
Where Cast (OWOR.CloseDate as DATE)  between @FechaIS and @FechaFS 
Order by OWOR.CloseDate, OITM.ItemName 



