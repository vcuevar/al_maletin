-- Nombre Reporte: R119 - B Comparativo de Cascos VS Fundas.
-- Solicito: Nadie Propuesta para generar programa de cascos.
-- Modificacion para Propuesta de Programa de Casco.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Enero del 2015; Origen.
-- Actualizado: Martes 15 de Junio del 2021; Mover a SAP 10
-- Actualizado: Viernes 02 de Septiembre del 2022; Propuesta de Cambio.

-- Variables: Estaciones de Fundas.
Declare @EstIni nvarchar(10)
Declare @EstFin nvarchar(10)
Set @EstIni = '112'		-- Corte de Piel
Set @EstFin = '148'		-- Almacen de Partes

--Registros con este WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (A3.U_TipoMat = 'PT')
-- 2563 Contra el Back Order no se precentan las refacciones pero estas no llevan casco.

-- Con el cambio que hizo diseño de poner ESTRUCTURA eso genera que no se vea el casco en el primer nivel.
-- Lo dejo por la paz alcabo no lo solicito planeacion y ademas esta muy 

-- Back Order de Fundas de Corte de Piel al Almacen de Partes.
Select	OWOR.DocEntry
		, A3.ItemCode AS MUEBLE
		, A3.ItemName AS NOM_MUEBLE
		, (OWOR.PlannedQty - OWOR.CmpltQty) AS CANTIDAD
		, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS VS_ORDEN
		, (UFD1.FldValue +  '  ' + UFD1.Descr) AS ESTATUS
		, A1.ItemCode AS COD_CASC
		, A1.ItemName AS CASCO
		, (Select top(1) RT.Name from [@CP_OF] CP Inner join [@PL_RUTAS] RT on RT.Code = CP.U_CT Where CP.U_DocEntry = OWOR.DocEntry 
		Order By CP.U_CT desc) AS FUNDA

		--, A1.ItemCode AS ART_CODE
		--, A1.ItemName AS ART_NOMBRE
		--, SUM((WOR1.PlannedQty	- WOR1.IssuedQty)) AS FUNDAS
		
		--, SUM((WOR1.PlannedQty	- WOR1.IssuedQty))* OITM.U_VS AS VS_TOTAL
		--, CONVERT(int, '0') AS EXISTENCIA	
From OWOR
--INNER JOIN WOR1 ON WOR1.DocEntry = OWOR.DocEntry 
--INNER JOIN OITM A1 ON A1.ItemCode = WOR1.ItemCode -- and A1.U_TipoMat = 'CA'
Inner Join OITM A3 ON A3.ItemCode = OWOR.ItemCode 
Inner join UFD1 on OWOR.U_Starus = UFD1.FldValue and UFD1.TableID='OWOR'and UFD1.FieldID=2
Inner Join ITT1 on OWOR.ItemCode = ITT1.Father
Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.U_TipoMat = 'CA'


--Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
--Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (A3.U_TipoMat = 'PT')

--AND OWOR.U_Starus = '06' 
--and CP.U_CT BETWEEN @EstIni and @EstFin 
--Group By WOR1.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_VS 





/*
-- Calculo Comparativo Existencia de Casco contra fundas de Corte de Piel a Almacen de Partes. 
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

*/


