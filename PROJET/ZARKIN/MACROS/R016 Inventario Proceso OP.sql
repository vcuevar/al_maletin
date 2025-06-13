-- Nombre: 016 Inventario Proceso OP.
-- Uso: Inventario de todos los materiales cargados a las OP que se encuentren liberadas,
-- Dividiendo en Materiales, Tela y Piel.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 06 de junio del 2025; Desvincular a BackOrder y traer todas las OP.

/* ------------------------------------------------------------------------------------------------
|  Metodos Para Calcular las Ordenes en Proceso.                                                         |
--------------------------------------------------------------------------------------------------*/
/*
-- Mediante la vista del Back Order 
Select BOR.U_TipoMat, SUM(BOR.VS) AS TVS
From (
Select BO.OP
	, BO.CODIGO
	, BO.Descripcion
	, BO.Cantidad
	, BO.VS
	, BO.U_Starus
	, A3.U_TipoMat
From Vw_BackOrderExcel BO
Inner Join OITM A3 on BO.CODIGO = A3.ItemCode
Where BO.U_Starus = '06'
) BOR
Group By BOR.U_TipoMat


-- Mediante Ordenes clasificadas por Tipo de Material PT

Select WOR.TM, WOR.ESTATUS, SUM(WOR.CANTIDAD) AS CANTIDAD, SUM(WOR.U_VS) AS TVS
From (

Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, OWOR.PlannedQty-OWOR.CmpltQty AS CANTIDAD
	, A3.U_VS AS U_VS
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and OWOR.Status = 'R'

--and OWOR.U_Starus = '04'
--and A3.U_TipoMat = 'PT'

) WOR
Group By WOR.TM,  WOR.ESTATUS
Order By WOR.TM, WOR.ESTATUS

*/

/* ------------------------------------------------------------------------------------------------
|  Calcular los materiales cargados a las OP segun si TM (TELA GRUPO 114)                          |
--------------------------------------------------------------------------------------------------*/

-- Tela de Tapiceria Grupo 114 RESUMEN

Select SUM(WOR.TVS) AS TVS, SUM(WOR.CARGADO) AS CANTIDAD, SUM(WOR.IMPORTE) AS IMPORTE 
From (
Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, WOR1.ItemCode AS ID_MP
	, A1.ItemName AS MATERIAL
	, OWOR.PlannedQty AS PLANEADO
	, OWOR.CmpltQty AS CUMPLIDA
	, A3.U_VS AS U_VS
	, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS TVS
	, WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) AS CARGADO
	,  L10.Price AS PRECIO
	, (WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty)) * L10.Price as IMPORTE
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) > 0
and OWOR.Status = 'R'
and WOR1.IssuedQty > 0
and A1.ItmsGrpCod = 114
and A1.U_GrupoPlanea = 11
) WOR
Group By WOR.TM,  WOR.ESTATUS
Order By WOR.TM, WOR.ESTATUS

-- Tela de Tapiceria Grupo 114 DETALLE
/*
Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, WOR1.ItemCode AS ID_MP
	, A1.ItemName AS MATERIAL
	, OWOR.PlannedQty AS PLANEADO
	, OWOR.CmpltQty AS CUMPLIDA
	, A3.U_VS AS U_VS
	, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS TVS
	, WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) AS CARGADO
	,  L10.Price AS PRECIO
	, (WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty)) * L10.Price as IMPORTE
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) > 0
and OWOR.Status = 'R'
and WOR1.IssuedQty > 0
and A1.ItmsGrpCod = 114
and A1.U_GrupoPlanea = 11
Order By A1.ItemName, OWOR.DocEntry
*/

/* ------------------------------------------------------------------------------------------------
|  Calcular los materiales cargados a las OP segun si TM (PIEL GRUPO 113)                          |
--------------------------------------------------------------------------------------------------*/

-- Piel de Tapiceria Grupo 113 RESUMEN

Select SUM(WOR.TVS) AS TVS, SUM(WOR.CARGADO) AS CANTIDAD, SUM(WOR.IMPORTE) AS IMPORTE 
From (
Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, WOR1.ItemCode AS ID_MP
	, A1.ItemName AS MATERIAL
	, OWOR.PlannedQty AS PLANEADO
	, OWOR.CmpltQty AS CUMPLIDA
	, A3.U_VS AS U_VS
	, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS TVS
	, WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) AS CARGADO
	,  L10.Price AS PRECIO
	, (WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty)) * L10.Price as IMPORTE
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) > 0
and OWOR.Status = 'R'
and WOR1.IssuedQty > 0
and A1.ItmsGrpCod = 113
) WOR
Group By WOR.TM,  WOR.ESTATUS
Order By WOR.TM, WOR.ESTATUS

-- Piel de Tapiceria Grupo 113 DETALLE
/*
Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, WOR1.ItemCode AS ID_MP
	, A1.ItemName AS MATERIAL
	, OWOR.PlannedQty AS PLANEADO
	, OWOR.CmpltQty AS CUMPLIDA
	, A3.U_VS AS U_VS
	, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS TVS
	, WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) AS CARGADO
	,  L10.Price AS PRECIO
	, (WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty)) * L10.Price as IMPORTE
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) > 0
and OWOR.Status = 'R'
and WOR1.IssuedQty > 0
and A1.ItmsGrpCod = 113
Order By A1.ItemName, OWOR.DocEntry
*/

/* ------------------------------------------------------------------------------------------------
|  Calcular los materiales cargados a las OP segun si TM (MATERIALES EN GENERAL)                   |
--------------------------------------------------------------------------------------------------*/

-- Materiales en General RESUMEN

Select SUM(WOR.TVS) AS TVS, SUM(WOR.CARGADO) AS CANTIDAD, SUM(WOR.PRECIO * WOR.CARGADO) AS IMPORTE 
From (
Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, WOR1.ItemCode AS ID_MP
	, A1.ItemName AS MATERIAL
	, OWOR.PlannedQty AS PLANEADO
	, OWOR.CmpltQty AS CUMPLIDA
	, A3.U_VS AS U_VS
	, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS TVS
	, WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) AS CARGADO
	,  L10.Price AS PRECIO
	, (WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty)) * L10.Price as IMPORTE
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) > 0
and OWOR.Status = 'R'
and WOR1.IssuedQty > 0
and A1.ItmsGrpCod <> 113
and A1.ItmsGrpCod <> 114
and A1.U_GrupoPlanea <> 11
) WOR


-- Varios Materiales DETALLES
/*
Select OWOR.DocEntry AS OP
	, OWOR.ItemCode AS CODIGO
	, A3.ItemName AS DESCRIPCION
	, WOR1.ItemCode AS ID_MP
	, A1.ItemName AS MATERIAL
	, OWOR.PlannedQty AS PLANEADO
	, OWOR.CmpltQty AS CUMPLIDA
	, A3.U_VS AS U_VS
	, (OWOR.PlannedQty - OWOR.CmpltQty) * A3.U_VS AS TVS
	, WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) AS CARGADO
	,  L10.Price AS PRECIO
	, (WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty)) * L10.Price as IMPORTE
	, OWOR.U_Starus AS ESTATUS
	, OWOR.Status AS ESTADO
	, A3.U_TipoMat AS TM
From OWOR
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Where OWOR.PlannedQty-owor.CmpltQty > 0 
and WOR1.IssuedQty - (WOR1.BaseQty * OWOR.CmpltQty) > 0
and OWOR.Status = 'R'
and WOR1.IssuedQty > 0
and A1.ItmsGrpCod <> 113
and A1.ItmsGrpCod <> 114
and A1.U_GrupoPlanea <> 11
Order By A1.ItemName, OWOR.DocEntry
*/








