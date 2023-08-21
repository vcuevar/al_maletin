-- Macro Planeacion del Gurú.
-- Objetivo: Validar la planeacion en funcion a los Sub-Ensambles.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 27 de Julio del 2023; Origen.

-- ================================================================================================
-- |     Back Order de Fundas, Para base del Programa.                                            |
-- ================================================================================================

Select Ltrim(Str(OP)) +  Left(codigo1,4) + Right(codigo1,2) + (codigo3) AS ID
	, OP
	, Left(codigo1,4) + '-' + Right(codigo1,2) + '-' + (codigo3) AS CODIGO
	, Descripcion
	, Cant
	, VSind
	, VS
	, ISNULL(prefunda, ('0' + U_Starus)) AS FUNDA
	, SEMANA3 
from SIZ_View_ReporteBO 
Order By FUNDA Desc, SEMANA3 Asc

-- ================================================================================================
-- |     Back Order convertido en Casco.                                                          |
-- ================================================================================================

Select Ltrim(Str(OP)) +  Left(codigo1,4) + Right(codigo1,2) + (codigo3) AS ID
	, OP
	, ISNULL(CASCO.COD_CASCO, 'N/A') AS CODIGO
	, ISNULL(CASCO.NOM_CASCO, 'NO LLEVA CASCO') AS DESCRIPCION
	, Cant
	, VSind
	, VS
	, ISNULL(prefunda, ('0' + U_Starus)) AS FUNDA
	, SEMANA3 
from SIZ_View_ReporteBO 
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
) CASCO ON CASCO.COD_PADRE = Left(codigo1,4) + '-' + Right(codigo1,2) + '-' + (codigo3)
Order By FUNDA Desc, SEMANA3 Asc

-- ================================================================================================
-- |     EXISTENCIA CASCO EN CARPINTERIA.                                                         |
-- ================================================================================================

Select B0.ItemCode AS CODIGO
	, B0.ItemName AS DESCRIPCION
	, B0.InvntryUom AS UDM
	, B1.OnHand as EXISTENCIA
	, '420 EXIT. CARPINTERIA' AS ESTATUS
From OITM B0
inner join OITW B1 on B0.ItemCode = B1.ItemCode 
Where B1.WhsCode = 'APT-PA' and B1.OnHand > 1 and B0.U_TipoMat = 'CA'
Order by ESTATUS, DESCRIPCION


-- ================================================================================================
-- |     EXISTENCIA CASCO EN ALMACEN DE PARTES.                                                   |
-- ================================================================================================

Select B0.ItemCode AS CODIGO
	, B0.ItemName AS DESCRIPCION
	, B0.InvntryUom AS UDM
	, B1.OnHand as EXISTENCIA
	, '430 EXIT. ALM. PARTES' AS ESTATUS
From OITM B0
inner join OITW B1 on B0.ItemCode = B1.ItemCode 
Where B1.WhsCode = 'APP-ST' and B1.OnHand > 1 and B0.U_TipoMat = 'CA'
Order by ESTATUS, DESCRIPCION


-- ================================================================================================
-- |     ORDENES EN PROCESO ESTACION 418 ENTREGA DE CASCO.                                        |
-- ================================================================================================

Select C0.DocEntry AS OC 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	, C1.InvntryUom AS UDM
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD
	, ' 418 ENTREGA CASCO' AS ESTATUS	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Where C1.U_TipoMat='CA' and C0.PlannedQty-C0.CmpltQty > 0 and C0.Status = 'R' 
and (CP.U_Recibido-CP.U_Entregado) > 0 and U_CT = 418 
Order by DESCRIPCION 

-- ================================================================================================
-- |     ORDENES EN PROCESO ESTACION 415 PEGADO DE HULE ESPUMA.                                     |
-- ================================================================================================

Select C0.DocEntry AS OC 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	, C1.InvntryUom AS UDM
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD
	, ' 415 PEGADO HE' AS ESTATUS	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Where C1.U_TipoMat='CA' and C0.PlannedQty-C0.CmpltQty > 0 and C0.Status = 'R' 
and (CP.U_Recibido-CP.U_Entregado) > 0 and U_CT = 415 
Order by DESCRIPCION 

-- ================================================================================================
-- |     ORDENES EN PROCESO ESTACION 406 ARMADO DE CASCO.                                         |
-- ================================================================================================

Select C0.DocEntry AS OC 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	, C1.InvntryUom AS UDM
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD
	, ' 406 ARMADO' AS ESTATUS	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Where C1.U_TipoMat='CA' and C0.PlannedQty-C0.CmpltQty > 0 and C0.Status = 'R' 
and (CP.U_Recibido-CP.U_Entregado) > 0 and U_CT = 406 
Order by DESCRIPCION 


-- ================================================================================================
-- |     ORDENES EN PROCESO ESTACION 403 HABILITADO.                                              |
-- ================================================================================================

Select C0.DocEntry AS OC 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	, C1.InvntryUom AS UDM
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD
	, ' 403 HABILITADO' AS ESTATUS	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Where C1.U_TipoMat='CA' and C0.PlannedQty-C0.CmpltQty > 0 and C0.Status = 'R' 
and (CP.U_Recibido-CP.U_Entregado) > 0 and U_CT = 403 
Order by DESCRIPCION 

-- ================================================================================================
-- |     ORDENES EN PROCESO ESTACION 400 PLANEACION.                                              |
-- ================================================================================================

Select C0.DocEntry AS OC 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	, C1.InvntryUom AS UDM
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD
	, ' 400 PLANEACION R' AS ESTATUS	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Where C1.U_TipoMat='CA' and C0.PlannedQty-C0.CmpltQty > 0 and C0.Status = 'R' 
and (CP.U_Recibido-CP.U_Entregado) > 0 and U_CT = 400 
Order by DESCRIPCION 


-- ================================================================================================
-- |     ORDENES EN PROCESO ESTACION 400 PLANEACION.                                              |
-- ================================================================================================

Select C0.DocEntry AS OC 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	, C1.InvntryUom AS UDM
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD
	, ' 400 PLANEACION P' AS ESTATUS	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Where C1.U_TipoMat='CA' and C0.PlannedQty-C0.CmpltQty > 0 and C0.Status = 'P' 
and (CP.U_Recibido-CP.U_Entregado) > 0 and U_CT = 400 
Order by DESCRIPCION 