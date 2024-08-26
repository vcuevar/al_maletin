-- 136 Reporte Calcula consumos no incurridos.
-- Tratar de adivitar que se debio haber consumido y no se consumio.
-- Modificado por: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 18 de Octubre del 2023; Origen.

-- Que hace crecer el WIP virtual
-- Diferencias entre Precio 10 y sus componentes de LDM Sub-ensambles Patas y Casco 
-- Cambios de Estructuras despues de generadas las OP


-- Para Evitar siga creciendo cada mes recortar de acuerdo al avance $$$ mas un 77%
--de donde sale el 77% al tanteo que corresponderia al material que tienen fisico para poderse usar en 
-- otras ordenes o el que se esta por cargar a las OP.

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date

Set @FechaIS = CONVERT (DATE, '2023-10-02', 102)
Set @FechaFS = CONVERT (DATE, '2023-10-17', 102)

-- Calcular el Consumo.

Select convert(varchar,OWOR.CloseDate,6) AS FECH_CIERRE
	, OWOR.DocEntry
	, OWOR.ItemCode
	, OITM.ItemName
	, OITM.U_VS
	, OITM.U_TipoMat
	
	, WOR1.*
	--, (
	--Select SUM(LOP.IssuedQty*P10.Price) AS IMP 
	--from WOR1 LOP 
	--inner join ITM1 P10 on LOP.ItemCode= P10.ItemCode and P10.PriceList = 10 
	--inner join OITM AP1 on P10.ItemCode = AP1.ItemCode and AP1.ItmsGrpCod  <> 113 
	--Where LOP.DocEntry = OWOR.DocEntry) AS IMPO_OP
	
	--, (
	--Select SUM(LET.Quantity * L10.Price) AS IMPO 
	--from ITT1 LET 
	--inner join ITM1 L10 on LET.Code = L10.ItemCode and L10.PriceList = 10 
	--inner join OITM AP2 on L10.ItemCode = AP2.ItemCode and AP2.ItmsGrpCod <> 113 
	--Where LET.Father = OWOR.ItemCode ) * OWOR.CmpltQty AS IMPO_LT 
	
from OWOR 
inner join OITM on OWOR.ItemCode = OITM.ItemCode 
inner join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Where Cast(OWOR.CloseDate as date) between @FechaIS and @FechaFS 
and OWOR.DocEntry = 37105
Order by OWOR.CloseDate, OITM.ItemName