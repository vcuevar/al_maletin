-- Nombre: Modelo con casco asignado.
-- Solicito: Osiel Franco.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Enero del 2015; Origen.

-- Variables: Ninguna.

-- Back Order Completo
Select	OWOR.DocEntry AS ORDEN
		, A3.ItemCode AS MUEBLE
		, A3.ItemName AS NOM_MUEBLE
		, (OWOR.PlannedQty - OWOR.CmpltQty) AS CANTIDAD

		, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS VS_ORDEN
		, ISNULL(RT.Name, UFD1.Descr)  AS ESTACION
		, ISNULL(T_CAS.COD02, T_CA3.COD03) AS CASCO1
		, ISNULL(T_CAS.CASC02, T_CA3.CASC03) AS CASCO1_NOMB
From OWOR
Inner Join OITM A3 ON A3.ItemCode = OWOR.ItemCode 
Inner Join UFD1 on OWOR.U_Starus = UFD1.FldValue and UFD1.TableID='OWOR'and UFD1.FieldID=2
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left Join [@PL_RUTAS] RT on RT.Code = CP.U_CT 

Left Join (
Select ITT1.Father AS MODELO, A2.ItemCode AS COD02, A2.ItemName AS CASC02 
From ITT1
Inner Join OITM A2 on A2.ItemCode = ITT1.Code and A2.U_TipoMat = 'CA') T_CAS on T_CAS.MODELO = A3.ItemCode

Left Join (
Select ITT1.Father AS MODEL3, A2.ItemCode AS COD03, A2.ItemName AS CASC03 
From ITT1
Inner Join OITM A2 on A2.ItemCode = ITT1.Code and A2.U_TipoMat = 'CA') T_CA3 on T_CA3.MODEL3 = (SUBSTRING(A3.ItemCode, 1, 4)+
 SUBSTRING(A3.ItemCode, 6, 2)+'-ESTRUCTURA')
 
WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF')
Order By OWOR.U_Starus desc, CP.U_CT desc


