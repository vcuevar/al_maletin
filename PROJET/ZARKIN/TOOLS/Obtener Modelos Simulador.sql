-- Nombre: Consulta para Activar el Simulador.
-- Solicito: Sr. Arie Zarkin (Facilitar la validacion de los modelos y tomar otros colores de piel).
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 05 de Septiembre del 2022; Origen.

-- Variables: 
Declare @Modelo as Varchar(10)

-- Seleccionar los Modelos

Select OITM.ItemCode AS CODIGO
		, OITM.ItemName AS MODELO
From OITM
Where OITM.U_Linea = '01' and OITM.U_IsModel = 'S'
Order By OITM.ItemName

-- Pieles distinatas por modelo
Set @Modelo = '3688'

Select MODEL.ACABADO
		, MODEL.PIEL
		, SUM(MODEL.NUMERO) AS MUEBLES
From (
Select  1 AS NUMERO
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS MUEBLE
		, Left(OITM.Itemcode, 4) AS MODELO
		, Left(Right(OITM.ItemCode, 8), 2) AS COMPOSICION 
		, Right(OITM.ItemCode, 5) AS ACABADO
		, A1.ItemCode AS CODE
		, A1.ItemName AS PIEL
from OITM
Inner Join ITT1 on ITT1.Father = OITM.ItemCode  
Inner Join OITM A1 on A1.ItemCode = ITT1.Code and A1. ItmsGrpCod = 113 
Where OITM.ItemCode like  '3688%'
and OITM.frozenFor = 'N'
and OITM.U_Linea = '01' 
and A1.U_Linea = '01' 
and OITM.U_IsModel = 'N' 
and OITM.U_TipoMat = 'PT'
and OITM.InvntItem = 'Y') MODEL
Group by MODEL.MODELO, MODEL.ACABADO, MODEL.PIEL
Order By MODEL.PIEL

-- Detalle de la Tabla para validar
Select  1 AS NUMERO
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS MUEBLE
		, Left(OITM.Itemcode, 4) AS MODELO
		, Left(Right(OITM.ItemCode, 8), 2) AS COMPOSICION 
		, Right(OITM.ItemCode, 5) AS ACABADO
		, A1.ItemCode AS CODE
		, A1.ItemName AS PIEL
from OITM
Inner Join ITT1 on ITT1.Father = OITM.ItemCode  
Inner Join OITM A1 on A1.ItemCode = ITT1.Code and A1. ItmsGrpCod = 113 
Where OITM.ItemCode like  '3688%'
and OITM.frozenFor = 'N'
and OITM.U_Linea = '01' 
and A1.U_Linea = '01' 
and OITM.U_IsModel = 'N' 
and OITM.U_TipoMat = 'PT'
and OITM.InvntItem = 'Y'
Order by  A1.ItemName 
