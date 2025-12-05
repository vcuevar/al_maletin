-- Nombre Reporte: R119 Comparativo de Cascos VS Fundas.
-- Solicito: Nadie Propuesta para generar programa de cascos.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Enero del 2015; Origen.
-- Actualizado: Martes 15 de Junio del 2021; Mover a SAP 10

-- Variables: Estaciones de Fundas.
Declare @EstIni nvarchar(10)
Declare @EstFin nvarchar(10)
Set @EstIni = '154'		-- Enfundado Tapiceria
Set @EstFin = '175'		-- Inspeccion Final

-- Calculo Comparativo Existencia de Casco contra fundas de Enfundado a Inspeccion Final. 
Select	CASC.ART_CODE
	, CASC.ART_NOMBRE
	, CASC.UDM
	, CASC.VS
	, SUM(CASC.EXISTENCIA) AS EXIST
	, SUM(CASC.NEC_TAPIZ) AS NECES
	, A3.IsCommited AS COMPOMISO
	, ITM1.Price AS PRECIO
From (

-- Inventario de Casco en al almacen del WIP VIRTUAL.
Select OITM.ItemCode AS ART_CODE
	, OITM.ItemName AS ART_NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.U_VS AS VS
	, OITW.OnHand AS EXISTENCIA
	, CONVERT(int, '0') AS NEC_TAPIZ
from OITW 
inner join OITM on OITM.ItemCode = OITW.ItemCode 
inner join OWHS on OWHS.WhsCode = OITW.WhsCode and OITW.WhsCode = 'APG-ST'
where OITW.OnHand > 0 and OITM.U_TipoMat = 'CA'

Union All

-- Necesidades de Ordenes de Produccion don de se encuentra el casco en primer nivel.
Select	 WOR1.ItemCode AS ART_CODE
		, OITM.ItemName AS ART_NOMBRE
		, OITM.InvntryUom AS UDM
		, OITM.U_VS AS VS
		, CONVERT(int, '0') AS EXISTENCIA
		, SUM((WOR1.PlannedQty	- WOR1.IssuedQty)) AS NEC_TAPIZ
From OWOR
Inner Join WOR1 ON WOR1.DocEntry = OWOR.DocEntry 
Inner Join OITM ON OITM.ItemCode = WOR1.ItemCode and OITM.U_TipoMat = 'CA'
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
WHERE OWOR.Status <> 'C' and OWOR.Status <> 'L' 
and CP.U_CT BETWEEN @EstIni and @EstFin 
Group By WOR1.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_VS

Union All

-- Necesidades de Casco en OP dentro de Subensambles
Select	OITM.ItemCode AS ART_CODE
		, OITM.ItemName AS ART_NOMBRE
		, OITM.InvntryUom AS UDM
		, OITM.U_VS AS VS
		, CONVERT(int, '0') AS EXISTENCIA
		, SUM((WOR1.PlannedQty	- WOR1.IssuedQty)) AS NEC_TAPIZ
From OWOR
Inner Join WOR1 ON WOR1.DocEntry = OWOR.DocEntry and WOR1.ItemCode like '%ESTRUCT%'
Inner Join ITT1 on WOR1.ItemCode = ITT1.Father 
Inner Join OITM ON OITM.ItemCode = ITT1.Code and OITM.U_TipoMat = 'CA'
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
WHERE OWOR.Status <> 'C' and OWOR.Status <> 'L' 
and CP.U_CT BETWEEN @EstIni and @EstFin 
Group By OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_VS 

) CASC
inner join ITM1 on ITM1.ItemCode = CASC.ART_CODE and ITM1.PriceList=10
Inner Join OITM A3 on CASC.ART_CODE = A3.ItemCode
Group By CASC.ART_CODE, CASC.ART_NOMBRE, CASC.UDM, ITM1.Price, CASC.VS, A3.IsCommited
Order by CASC.ART_NOMBRE 




