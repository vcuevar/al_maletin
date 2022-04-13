--Consulta para Entregas Costeadas V3
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 10 de Junio del 2021; Relacionar a documento siguiente.

/* Typo de Documentos
Select Distinct TransType,  LineMemo FROM JDT1 
NUMERO	DOCUMENTO
13	Facturas clientes
14	Notas de crédito clientes
15	Entregas
16	Devoluciones
18	Fact.proveedores
19	Notas de crédito acreedores
20	Pedido de entrada de mercancías
21	Devolución de mercancías
24	Pagos recibidos
30	MIGRACION A SAP 10
46	Pagos efectuados
59	Entrada de mercancías
59	Recibo de producción
60	Emisión para producción
67	Traslados -
162	Revalorización de inventario
202	Production Order
321	Transacción de reconciliación manual
*/

DECLARE @FechaIS nvarchar(20)
DECLARE @FechaFS nvarchar(20)

Set @FechaIS = '2021-05-01'
Set @FechaFS = '2021-06-10'

-- Consulta para Entregas sin Facturar.
 Select ODLN.DocNum, ODLN.NumAtCard, ODLN.DocDate ,ODLN.CardName ,DLN1.ItemCode , DLN1.Dscription , dln1.OpenQty AS quantity, DLN1.Price , (dln1.OpenQty * DLN1.Price) as linetotal , OITM.U_VS, VS.VS, DLN1.TreeType, OITM.AvgPrice, CASE WHEN DLN1.BaseType = -1 THEN 'Directa' else CASE WHEN DLN1.BaseType = 17 THEN ' De Pedido' else '' end end as EntregaViene, DLN1.BaseRef 
from odln inner join DLN1 on ODLN.DocEntry = DLN1.DocEntry inner join OITM on OITM.ItemCode = DLN1.ItemCode LEFT JOIN (SELECT FATHER, SUM(OITM.U_VS) AS VS 
FROM ITT1 INNER JOIN OITM ON ITT1.CODE = OITM.ItemCode GROUP BY ITT1.Father  ) VS ON DLN1.ItemCode = VS.Father where dln1.linestatus = 'O'  and
(Cast(odln.docdate as date) between @FechaIS and @FechaFS) 
order by ODLN.DocNum , DLN1.LineNum 


-- Consulta para Entregar ya Facturadas o Cerradas.

Select ODLN.DocNum ,ODLN.NumAtCard, ODLN.DocDate ,ODLN.CardName ,DLN1.ItemCode , DLN1.Dscription , dln1.Quantity, DLN1.Price , DLN1.LineTotal , OITM.U_VS, VS.VS , DLN1.TreeType , OITM.AvgPrice, CASE WHEN DLN1.TargetType = 16 THEN 'Devolucion' ELSE CASE WHEN DLN1.TargetType = 13 THEN 'Facturado' ELSE CASE WHEN DLN1.TargetType = -1 THEN 'Manual' ELSE '' END END END CerradoCon, CASE WHEN DLN1.TargetType = 16 THEN (Select Top (1) ORDN.DocNum from ORDN Where ORDN.DocEntry = DLN1.TrgetEntry) ELSE CASE WHEN DLN1.TargetType = 13 THEN (Select Top (1) DocNum from OINV Where OINV.DocEntry = DLN1.TrgetEntry) ELSE CASE WHEN DLN1.TargetType = -1 THEN 0 ELSE 0 END END END TrgetEntry from ODLN inner join DLN1 on ODLN.DocEntry = DLN1.DocEntry inner join OITM on OITM.ItemCode = DLN1.ItemCode LEFT JOIN (SELECT FATHER, SUM(OITM.U_VS) AS VS FROM ITT1 INNER JOIN OITM ON ITT1.CODE = OITM.ItemCode 
GROUP BY ITT1.Father  ) VS ON DLN1.ItemCode = VS.Father where DLN1.Price > 0  and odln.docstatus = 'C' and (Cast(odln.docdate as date) between @FechaIS and @FechaFS)  
 





