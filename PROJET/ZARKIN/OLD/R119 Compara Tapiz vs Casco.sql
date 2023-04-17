-- Nombre Reporte: R119 Compara Tapiz vs Casco.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 22 de Abril del 2021; Origen a SAP 10.

--Consulta para obtener el reporte comparativo de Tapiz vs Casco.
-- Fundas deben estar en las estacion > 151 (De Enfundado hasta Empaque)
-- Existencia del Casco que esta en APG-ST

Select OITW.WhsCode AS ALM_CODE
	, OWHS.WhsName AS ALM_NOMBRE
	, OITM.U_TipoMat AS GRUPO
	, OITM.ItemCode AS ART_CODE
	, OITM.ItemName AS ART_NOMBRE
	, OITM.InvntryUom AS UDM
	, OITW.OnHand AS EXISTENCIA
	, OITM.U_VS AS VS
	, (OITW.OnHand * OITM.U_VS) AS TVS
	, ITM1.Price AS LIST_10
	, ISNULL(TPZ.CANT, 0) as NEC_TAPIZ 
from OITW 
inner join OITM on OITM.ItemCode = OITW.ItemCode 
inner join OWHS on OWHS.WhsCode = OITW.WhsCode 
inner join ITM1 on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 10 
left join (

Select	SCASC.CASCO
		, SUM(SCASC.CANT) as CANT 
from (

Select	CODIGO
		, SUM(Cantidad) as CANT
		, (
		
Select	Code 
from ITT1 
Where Father = CODIGO and LEN(Code) = 6 ) as CASCO 
from Vw_BackOrderExcel 
where CodFunda > 151 and CodFunda < 176 
Group by CODIGO 
) SCASC 

Group by SCASC.CASCO) as TPZ on TPZ.CASCO = OITM.ItemCode 
where OITW.OnHand > 0 and OITM.U_TipoMat = 'CA' and OITW.WhsCode = 'APG-ST' 
order by  OITW.WhsCode, OITM.ItemName 









Esto es vw BackOrderExcel


SELECT        TOP (100) PERCENT BK.U_Ubicacion AS METAL, BK.Pedido, BK.FechaPedido, BK.OC, CASE WHEN BK.U_Entrega_Piel IS NULL THEN DATEDIFF(DAY, GETDATE(), GETDATE()) ELSE DATEDIFF(DAY, 
                         U_Entrega_Piel, GETDATE()) END AS D_PROC, BK.OP, BK.U_NoSerie AS NO_SERIE, BK.Nombre AS CLIENTE, BK.Codigo_Articulo AS CODIGO, BK.Descripcion, BK.Cantidad, BK.VSInd, BK.VS, BK.SEMANA2, 
                         BK.SEMANA3, BK.Funda, BK.U_Grupo, BK.FENTREGA, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, BK.FechaEntregaPedido) AS varchar(4)), 4, 1)) * 100 + DATEPART(ISO_WEEK, BK.FechaEntregaPedido) 
                         - 1 AS SEMANA7, BK.FechaEntregaPedido, CASE WHEN BK.U_C_Orden = 'C' THEN '1' ELSE CASE WHEN BK.U_C_Orden = 'S' THEN '3' ELSE CASE WHEN BK.U_C_Orden = 'P' THEN '6' END END END AS Prioridad,
                          BK.DESV, BK.Comments, BK.U_Especial, BK.U_FProduccion, BK.U_AteEspecial, BK.U_PrioridadCte, BK.GroupName, dbo.OITM.ItemName AS Modelo, BK.CodFunda, BK.U_Entrega_Piel, BK.U_Status, 
                         SUBSTRING(BK.Codigo_Articulo, 1, 4) AS codigo1, SUBSTRING(BK.Codigo_Articulo, 6, 2) AS codigo2, SUBSTRING(BK.Codigo_Articulo, 9, 7) AS codigo3, CASE WHEN CHARINDEX('PIEL', BK.Descripcion) 
                         = 0 THEN 'NA' ELSE SUBSTRING(BK.Descripcion, CHARINDEX('PIEL', BK.Descripcion) + 5, 2) END AS CatPiel, CASE WHEN CHARINDEX('PIEL', BK.Descripcion) = 0 THEN 'NA' ELSE SUBSTRING(BK.Descripcion, 
                         CHARINDEX('PIEL', BK.Descripcion) + 7, 2) END AS ColorPiel, BK.DEstacion, BK.Status, DATEDIFF(DAY, BK.FechaPedido, GETDATE()) AS DiasDesdePedido, BK.Secue, BK.SecOT
FROM            dbo.VwBackOrderProgramadoOP AS BK LEFT OUTER JOIN
                         dbo.OITM ON dbo.OITM.ItemCode = SUBSTRING(BK.Codigo_Articulo, 1, 4)
ORDER BY BK.SEMANA2, NO_SERIE, BK.Descripcion, BK.Pedido, BK.OP