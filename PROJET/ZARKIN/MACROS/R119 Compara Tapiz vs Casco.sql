-- Nombre Reporte: R119 Comparativo de Cascos VS Fundas.
-- Solicito: Nadie Propuesta para generar programa de cascos.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Enero del 2015; Origen.
-- Actualizado: Martes 15 de Junio del 2021; Mover a SAP 10

-- Variables: Estaciones de Fundas.
Declare @EstIni nvarchar(10)
Declare @EstFin nvarchar(10)
Set @EstIni = '151'		-- Kiting
Set @EstFin = '175'		-- Inspeccion Final

-- Calculo Comparativo Existencia de Casco contra fundas de Kittin a Inspeccion Final. 
Select	CASC.ART_CODE, CASC.ART_NOMBRE, CASC.UDM
	, SUM(CASC.EXISTENCIA) AS EXIST
	, SUM(CASC.NEC_TAPIZ) AS NECES
From (

Select OITM.ItemCode AS ART_CODE
	, OITM.ItemName AS ART_NOMBRE
	, OITM.InvntryUom AS UDM
	, OITW.OnHand AS EXISTENCIA
	, CONVERT(int, '0') AS NEC_TAPIZ
from OITW 
inner join OITM on OITM.ItemCode = OITW.ItemCode 
inner join OWHS on OWHS.WhsCode = OITW.WhsCode and OITW.WhsCode = 'APG-ST'
where OITW.OnHand > 0 and OITM.U_TipoMat = 'CA'

Union All

Select	 WOR1.ItemCode AS ART_CODE
		, OITM.ItemName AS ART_NOMBRE
		, OITM.InvntryUom AS UDM
		, CONVERT(int, '0') AS EXISTENCIA
		, SUM((WOR1.PlannedQty	- WOR1.IssuedQty)) AS NEC_TAPIZ
From OWOR
INNER JOIN WOR1 ON WOR1.DocEntry = OWOR.DocEntry 
INNER JOIN OITM ON OITM.ItemCode = WOR1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (OITM.U_TipoMat = 'CA')
and CP.U_CT BETWEEN @EstIni and @EstFin 
Group By WOR1.ItemCode, OITM.ItemName, OITM.InvntryUom 
) CASC
Group By CASC.ART_CODE, CASC.ART_NOMBRE, CASC.UDM
Order by CASC.ART_NOMBRE 




