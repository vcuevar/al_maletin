-- Consultas que se cargaron al Query Manager de SAP.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 17 de Noviembre del 2021; Origen.

-- ================================================================================================
-- |         CATEGORIA AUDITORIA                                                                  |
-- ================================================================================================

-- Materiales pendientes de pargar a las Ordenes de Produccion.
SELECT  'MATERIAL POR CARGAR' AS QRY_001, T0.UpdateDate as Fecha, T0.[DocNum] as OP,T0.[ItemCode] as Code_PT, A3.ItemName as Producto,
wor1.ItemCode as Code_MP,A1.ItemName as Material,
 WOR1.PlannedQty as Cantidad, A1.AvgPrice as Estandar, WOR1.PlannedQty*A1.AvgPrice as Importe
 FROM OWOR T0
 inner join WOR1 on WOR1.DocEntry = T0.DocEntry
 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode
 inner join OITM A3 on T0.ItemCode=A3.ItemCode
 WHERE (T0.[PlannedQty]  <=  T0.[CmpltQty] and  T0.[status] <> 'L') and
 WOR1.IssueType = 'M' and WOR1.PlannedQty > WOR1.IssuedQty  and A1.ItmsGrpCod <> 113
 and A1.ItmsGrpCod <> 114
 Order by  T0.UpdateDate, T0.DocNum

 -- Materiales pendientes a cargar en Ordenes reportadas Parcialmente.
 Select 'CARGA PARCIAL' AS QRY_002, T0.[DocEntry] , WOR1.[ItemCode] , A1.ItemName AS MATERIAL,
(T0.CmpltQty * WOR1.BaseQty) - WOR1.IssuedQty as PENDIENTE,
WOR1.BaseQty AS BASE,
  T0.[ItemCode]
from OWOR T0
inner join WOR1 on T0.DocEntry = WOR1.DocEntry
inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
LEFT JOIN OITW PV ON WOR1.ItemCode = PV.ItemCode AND PV.WhsCode = 'APG-ST'
LEFT JOIN OITW PP ON WOR1.ItemCode = PP.ItemCode AND PP.WhsCode = 'APP-ST'
LEFT JOIN OITW PA ON WOR1.ItemCode = PA.ItemCode AND PA.WhsCode = 'APT-PA'
Where T0.CmpltQty < T0.PlannedQty
AND T0.Status <> 'L'
AND (T0.CmpltQty * WOR1.BaseQty) - WOR1.IssuedQty > 0
Order By T0.[DocEntry], WOR1.[ItemCode]

-- Ordenes listas para ser cerradas.
SELECT 'PARA CERRAR' AS QRY_003, T0.[DocNum] as Orden, T0.[ItemCode] as Codigo, T1.ITEMNAME as Descripcion,
 T0.[PlannedQty] as Planeado, T0.[CmpltQty] as Terminado, VAL.Cantidad as Indicador ,T0.UpdateDate as Actualizado
 FROM OWOR T0
 INNER JOIN OITM T1 ON T0.ITEMCODE=T1.ITEMCODE 
 LEFT JOIN (SELECT OWOR.DocNum as OP,sum(WOR1.PlannedQty) as Cantidad
			FROM OWOR
			inner join WOR1 on WOR1.DocEntry = OWOR.DocEntry
			inner join OITM A1 on WOR1.ItemCode=A1.ItemCode
  			WHERE OWOR.[PlannedQty] <= OWOR.[CmpltQty] and  OWOR.[status] <> 'L' and
			WOR1.IssueType = 'M' and WOR1.IssuedQty < WOR1.PlannedQty and A1.ItmsGrpCod<> 113
			group by OWOR.DocNum ) VAL on T0.DocNum = VAL.OP
WHERE T0.[PlannedQty] <=  T0.[CmpltQty] and  T0.[status] <> 'L' and VAL.Cantidad is null
Order by T0.UpdateDate, T0.[DocNum]


-- ================================================================================================
-- |         CATEGORIA DISEÑO                                                                     |
-- ================================================================================================

-- Presenta los PT que no tienen Lista de Materiales, Sin Existencia y fueron creados mas de 30 dias.
-- 250721 Esto lo solicito Osiel, hace mas de un año que se fue y he visto como que a Luis y a Daniel eso no les interesa.
--Ademas me trae problemas con Andrea porque despues necesita codigos viejos y tengo que activarlos de nuevo.
-- Por lo que suspendo esta validación.
/*
SELECT  'INACTIVAR PT SIN LDM' AS QRY_004
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom AS UDM
	, Cast(OITM.CreateDate as date) AS CREADO
	, T1.Descr AS LINEA
	, OITB.ItmsGrpNam AS GRUPO
	, (Case When OITT.Name is null then 'SIN/LDM' else 'CON/LDM' end) AS LDM
	, ITM1.Price AS ESTANDAR
	, OITM.OnHand AS EXISTENCIA 
FROM OITM 
LEFT JOIN OITT on OITT.Code = OITM.ItemCode 
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
LEFT JOIN UFD1 T1 on T1.FldValue=OITM.U_Linea and T1.TableID='OITM' and T1.FieldID=7 
WHERE OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'Y' and OITM.U_IsModel = 'N'
AND OITB.ItmsGrpNam <> 'PT PROTOTIPOS.' AND OITT.Name is null 
and OITM.frozenFor = 'N' and OITM.OnHand = 0
and CAST(OITM.CreateDate as DATE) < DATEADD(day,-30,CAST(GETDATE() as DATE))
ORDER BY OITM.ItemName
*/

-- Consultas de la Relacion de Hules con Pesos y Precio de Diseño.
-- Solicitada por Oziel Franco
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 25 de Enero del 2022; Origen.
/*
SELECT  OITM.ItemCode AS CODIGO
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.SWeight1 AS PESO
	, ITM1.Price AS DSISEÑO
FROM OITM 
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=1 
WHERE OITM.U_TipoMat = 'MP' AND OITM.U_GrupoPlanea = 6
ORDER BY OITM.ItemName

*/
-- ================================================================================================
-- |         CATEGORIA PLANEACION                                                                     |
-- ================================================================================================

-- Materiales de Donde Usado para Lista de Materiales.
SELECT 'QUITAR LDM VRL' AS QRY_005
	, T0.[Father],T2.[ItemName] as Codigo, T0.[Code], T1.[ItemName], T0.[Quantity],T1.[invntryuom] as UM,T0.[Price], T0.[Quantity]*T0.[Price] as Consumo 
FROM ITT1 T0 
INNER JOIN OITM T1 ON T0.Code = T1.ItemCode
left join OITM T2 on  T0.father = T2.ItemCode 
WHERE T0.[Code]  = '19043'

-- Material de Donde usado para Ordenes de Produccion
select 'QUITAR OP VRL' AS QRY_006
	, V3.Status as Estatus, V3.DocEntry as OP, V3.PlannedQty as Cant, V3.ItemCode as Codigo, V4.ItemName as Mueble, 
V1.ItemCode as Material, v2.ItemName as Nombre_Material, V1.BaseQty as Cant_Mat, V1.wareHouse as Almacen
from WOR1 V1
inner join OITM V2 on V1.ItemCode=V2.ItemCode
inner join OWOR V3 on V1.DocEntry=V3.DocEntry
inner join OITM V4 on V3.ItemCode=V4.ItemCode
where V1.ItemCode = '19043' and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L'
order by V3.DocEntry