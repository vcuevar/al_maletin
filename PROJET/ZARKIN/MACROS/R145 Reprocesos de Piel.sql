-- Macro R145 Reprocesos de Piel.
-- Presentar las entregas de Piel a las ordenes de producción.
-- Solicitado : Edgar Mejia.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 17 de septiembre del 2025; Origen

/* ========================================
*   Tabla de Tipos de Movimientos         *
===========================================
TransType			Nombre
13			Facturas clientes
14			Notas de crédito clientes 
15			Entregas 
16			Devoluciones 
18			Fact.proveedores 
20			Pedido de entrada de mercancías
21			Devolución de mercancías 
59			Entrada de mercancías / Recibo de producción
60			Salida de mercancías / Emisión para producción
67			Traslados 
162			Revalorización de inventario
*/

-- Parametros

Declare @FechaIS as Date
Declare @FechaFS as Date

Set @FechaIS = CONVERT (DATE, '2025-09-15', 102)
Set @FechaFS = CONVERT (DATE, '2025-09-19', 102)

Select Cast(OINM.CreateDate as DATE) AS FEC_MOV
	, OINM.BASE_REF AS DOC
	, OINM.AppObjAbs AS OP
	, OWOR.ItemCode AS COD_PT
	, A3.ItemName AS MUEBLE
	, OINM.ItemCode AS COD_MAT
	, OINM.Dscription AS NOM_MAT
	, A1.InvntryUom AS UDM
	, OINM.Warehouse AS ALM_REC
	, OINM.OutQty AS ENTREGADO
	, OINM.InQty AS DEVOLUCION
	, L10.Price AS COSTO
	, ITT1.Quantity AS LDM
	, OINM.Comments AS NOTAS
From OINM
Inner Join OITM A1 on A1.ItemCode = OINM.ItemCode
Inner Join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10
Left Join OWOR on OINM.AppObjAbs = OWOR.DocEntry
Left Join OITM A3 on A3.ItemCode  = OWOR.ItemCode
Left Join ITT1 on ITT1.Father = A3.ItemCode and ITT1.Code = OINM.ItemCode
Where Cast (OINM.CreateDate as DATE) between  @FechaIS and @FechaFS 
and OINM.AppObjAbs > -1
and A1.ItmsGrpCod = '113'
and (OINM.TransType = 59 or OINM.TransType = 60)
Order By OP, FEC_MOV, NOM_MAT
  



