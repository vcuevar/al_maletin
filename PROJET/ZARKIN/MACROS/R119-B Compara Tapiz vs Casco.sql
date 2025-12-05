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
Set @EstIni = '151'		-- Kitting
Set @EstFin = '175'		-- Inspeccion Final

--Registros con este WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (A3.U_TipoMat = 'PT')
-- 2563 Contra el Back Order no se precentan las refacciones pero estas no llevan casco.

-- Con el cambio que hizo diseño de poner ESTRUCTURA eso genera que no se vea el casco en el primer nivel.
-- Lo dejo por la paz alcabo no lo solicito planeacion y ademas esta muy 


-- Consulta activa al 27 de octubre del 2025
Select  CASC.ART_CODE
	, CASC.ART_NOMBRE
	, CASC.UDM
	, CASC.VS
	, SUM(CASC.EXISTENCIA) AS EXIST
	, SUM(CASC.NEC_TAPIZ) AS NECES
	, A3.IsCommited AS COMPOMISO
	, ITM1.Price AS PRECIO 
From (

Select OITM.ItemCode AS ART_CODE
	, OITM.ItemName AS ART_NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.U_VS AS VS
	, OITW.OnHand AS EXISTENCIA
	, CONVERT(int, '0') AS NEC_TAPIZ 
From OITW 
inner join OITM on OITM.ItemCode = OITW.ItemCode 
inner join OWHS on OWHS.WhsCode = OITW.WhsCode and OITW.WhsCode = 'APG-ST' 
where OITW.OnHand > 0 and OITM.U_TipoMat = 'CA' 

Union All 

Select   WOR1.ItemCode AS ART_CODE
	, OITM.ItemName AS ART_NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.U_VS AS VS
	, CONVERT(int, '0') AS EXISTENCIA
	, SUM((WOR1.PlannedQty  - WOR1.IssuedQty)) AS NEC_TAPIZ 
From OWOR 
Inner Join WOR1 ON WOR1.DocEntry = OWOR.DocEntry 
Inner Join OITM ON OITM.ItemCode = WOR1.ItemCode and OITM.U_TipoMat = 'CA' 
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
WHERE OWOR.Status <> 'C' and OWOR.Status <> 'L' 
and CP.U_CT BETWEEN @EstIni and @EstFin 
Group By WOR1.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_VS 

Union All 

Select   WOR1.ItemCode AS ART_CODE
	, OITM.ItemName AS ART_NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.U_VS AS VS
	, CONVERT(int, '0') AS EXISTENCIA
	, SUM((WOR1.PlannedQty  - WOR1.IssuedQty)) AS NEC_TAPIZ 
From OWOR 
Inner Join WOR1 ON WOR1.DocEntry = OWOR.DocEntry and WOR1.ItemCode like '%ESTRUCT%' 
Inner Join ITT1 on WOR1.ItemCode = ITT1.Father 
Inner Join OITM ON OITM.ItemCode = ITT1.Code and OITM.U_TipoMat = 'CA'
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
WHERE OWOR.Status <> 'C' and OWOR.Status <> 'L' 
and CP.U_CT BETWEEN @EstIni and @EstFin 
Group By WOR1.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_VS  

) CASC
inner join ITM1 on ITM1.ItemCode = CASC.ART_CODE and ITM1.PriceList=10 
Inner Join OITM A3 on CASC.ART_CODE = A3.ItemCode 
Group By CASC.ART_CODE, CASC.ART_NOMBRE, CASC.UDM, ITM1.Price, CASC.VS, A3.IsCommited 
Order by CASC.ART_NOMBRE 
