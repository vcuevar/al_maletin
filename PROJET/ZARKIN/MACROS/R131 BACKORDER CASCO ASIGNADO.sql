-- Nombre: Modelo con casco asignado.
-- Solicito: Osiel Franco.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 02 de Enero del 2015; Origen.

-- Variables: Ninguna.

-- Back Order Completo
/*
Select	OWOR.DocEntry AS ORDEN
		, OWOR.U_OT AS SEC_OT
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
Inner Join OITM A2 on A2.ItemCode = ITT1.Code and A2.U_TipoMat = 'CA'


) T_CAS on T_CAS.MODELO = A3.ItemCode

Left Join (
Select ITT1.Father AS MODEL3, A2.ItemCode AS COD03, A2.ItemName AS CASC03 
From ITT1
Inner Join OITM A2 on A2.ItemCode = ITT1.Code and A2.U_TipoMat = 'CA'

) T_CA3 on T_CA3.MODEL3 = (SUBSTRING(A3.ItemCode, 1, 4)+
 SUBSTRING(A3.ItemCode, 6, 2)+'-ESTRUCTURA')
 
WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF')

and A3.ItemCode like  '3892-12%'
Order By OWOR.U_Starus desc, CP.U_CT desc
*/

--2735 filas Totales
-- 2,391 filas PT
--    343 filas SP

Select	OWOR.DocEntry AS ORDEN
		, OWOR.U_OT AS SEC_OT
		, A3.ItemCode AS MUEBLE
		, A3.ItemName AS NOM_MUEBLE
		, (OWOR.PlannedQty - OWOR.CmpltQty) AS CANTIDAD
		, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS VS_ORDEN
		, ISNULL(RT.Name, UFD1.Descr)  AS ESTACION
		, CASCO.COD_CASCO AS COD_CASCO
		, CASCO.NOM_CASCO AS NOM_CASCO
		--, ISNULL(T_CAS.COD02, T_CA3.COD03) AS CASCO1
		--, ISNULL(T_CAS.CASC02, T_CA3.CASC03) AS CASCO1_NOMB
From OWOR
Inner Join OITM A3 ON A3.ItemCode = OWOR.ItemCode 
Inner Join UFD1 on OWOR.U_Starus = UFD1.FldValue and UFD1.TableID='OWOR'and UFD1.FieldID=2
Left Join [@CP_OF] CP  on CP.U_DocEntry = OWOR.DocEntry 
Left Join [@PL_RUTAS] RT on RT.Code = CP.U_CT 
Left Join (
Select T2.ItemCode AS COD_PADRE
	, T2.U_TipoMat AS TIPO_2
	, T1.ItemCode AS COD_CASCO
	, T1.ItemName AS NOM_CASCO 
	, T1.U_TipoMat AS TIPO_1
FROM ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode
Inner join OITM T2 ON  T0.father = T2.ItemCode 
WHERE T1.U_TipoMat = 'CA' and T2.U_TipoMat = 'PT' 

Union All

Select U2.ItemCode AS COD_PADRE
	, U2.U_TipoMat AS TIPO_2
	, SUB1.COD_CASCO AS COD_CASCO
	, SUB1.NOM_CASCO AS NOM_CASCO 
	, SUB1.TIPO_1 AS TIPO_1
FROM ITT1 U0 
Inner Join OITM U1 ON U0.Code = U1.ItemCode
Inner join OITM U2 ON  U0.father = U2.ItemCode 
Inner Join (
Select V2.ItemCode AS COD_PADRE
	, V2.U_TipoMat AS TIPO_2
	, V1.ItemCode AS COD_CASCO
	, V1.ItemName AS NOM_CASCO 
	, V1.U_TipoMat AS TIPO_1
FROM ITT1 V0 
Inner Join OITM V1 ON V0.Code = V1.ItemCode
Inner join OITM V2 ON  V0.father = V2.ItemCode 
Where V1.U_TipoMat = 'CA' and V2.U_TipoMat = 'SP') SUB1 ON SUB1.COD_PADRE = U1.ItemCode 
Where U2.U_TipoMat = 'PT' 

Union All

Select W2.ItemCode AS COD_PADRE
	, W2.U_TipoMat AS TIPO_2
	, SUB2.COD_CASCO AS COD_CASCO
	, SUB2.NOM_CASCO AS NOM_CASCO
	, SUB2.TIPO_1 AS TIPO_1
From ITT1 W0
Inner Join OITM W1 ON W0.Code = W1.ItemCode
Inner join OITM W2 ON  W0.father = W2.ItemCode 
Inner Join (
Select U2.ItemCode AS COD_PADRE
	, U2.U_TipoMat AS TIPO_2
	, SUB1.COD_CASCO AS COD_CASCO
	, SUB1.NOM_CASCO AS NOM_CASCO 
	, U1.U_TipoMat AS TIPO_1
FROM ITT1 U0 
Inner Join OITM U1 ON U0.Code = U1.ItemCode
Inner join OITM U2 ON  U0.father = U2.ItemCode 
Inner Join (
Select V2.ItemCode AS COD_PADRE
	, V2.U_TipoMat AS TIPO_2
	, V1.ItemCode AS COD_CASCO
	, V1.ItemName AS NOM_CASCO 
	, V1.U_TipoMat AS TIPO_1
FROM ITT1 V0 
Inner Join OITM V1 ON V0.Code = V1.ItemCode
Inner join OITM V2 ON  V0.father = V2.ItemCode 
Where V1.U_TipoMat = 'CA' and V2.U_TipoMat = 'SP') SUB1 ON SUB1.COD_PADRE = U1.ItemCode 
Where U2.U_TipoMat = 'SP') SUB2 ON SUB2.COD_PADRE = W1.ItemCode 
) CASCO ON CASCO.COD_PADRE = A3.ItemCode

WHERE (OWOR.Status <> 'C') AND (OWOR.Status <> 'L') AND (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF')
--and A3.ItemCode = '3892-12-B0315'


