-- ' Programa Requisicion por Punto de Reorden.
-- ' Desarrollado: Ing. Vicente Cueva Ramirez.
-- ' Modificado: Lunes 14 de Marzo del 2022; Origen.

-- Articulos Marcados con M&M

Select OITM.ItemCode, OITM.ItemName From OITM Where OITM.U_Metodo='M&M' Order by OITM.ItemName 

-- Consulta para Materiales asignados como Max Min. 
-- Almacenes a concidera para Existencia
-- AMP-ST  AM Almacen Materia Prima Stock
-- AMP-CC  AM Almacen Control de Calidad
-- APG-PA  AM Almacen Materia Prima Carpinteria
-- AXL-TC  AM Almacen Bodega Totoltepec

 Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, WS.EXISTE AS EXISTE
	, OITM.U_Minimo AS MINIMO
	, OITM.U_ReOrden AS PUNREO
	, OITM.U_Maximo AS MAXIMO
	, OITM.OnOrder AS EN_OC 
from OITM 
inner join ( Select OITW.ItemCode AS ITEM, SUM(OITW.OnHand) AS EXISTE
From OITW
Where (OITW.WhsCode = 'AMP-ST' OR  OITW.WhsCode = 'AXL-TC' OR OITW.WhsCode = 'AMP-CC' OR OITW.WhsCode = 'APG-PA')
Group By OITW.ItemCode) WS ON OITM.ItemCode = WS.ITEM
Where OITM.U_Metodo='M&M' AND OITM.U_Linea= 01 AND OITM.U_ReOrden > 0  AND WS.EXISTE <= OITM.U_ReOrden
Order by OITM.ItemName 

