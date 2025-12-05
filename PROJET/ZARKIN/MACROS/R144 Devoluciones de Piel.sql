-- Macro R144 Devoluciones de Piel.
-- Presentar las devoluciones de piel registradas en el sistema SAP, por ordenes de producción.
-- Solicitado : Ing. Elias Garcia; Jefe de Producción.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 12 de septiembre del 2025; Origen

--NOTAS:
--Emisión para producción ( Es lo que carga almacen a las OP)
--Issue for Production (Es lo que se consume de la OP)
--Recibo de producción (Es las devoluciones o las entregas de producto de la OP)


/* ========================================
|   Tabla de Tipos de Movimientos         |
|           OINM.TransType                |
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
Set @FechaFS = CONVERT (DATE, '2025-09-22', 102)

Select Cast(OINM.CreateDate as DATE) AS FEC_MOV
	, OINM.BASE_REF AS DOC
	, OINM.AppObjAbs AS OP
	, OINM.ItemCode AS COD_MAT
	, OINM.Dscription AS NOM_MAT
	, OITM.InvntryUom AS UDM
	,(OINM.InQty-OINM.OutQty) AS CANTIDAD
	, OINM.Warehouse AS ALM_REC
	, OINM.Comments AS NOTAS
From OINM
Inner Join OITM on OINM.ItemCode = OITM.ItemCode 
Where Cast (OINM.CreateDate as DATE) between  @FechaIS and @FechaFS 
and  OINM.Warehouse <> 'APT-ST' and  OINM.Warehouse <> 'APT-PA'
and OITM.U_TipoMat = 'MP' and OITM.QryGroup32 = 'N'
and OINM.TransType = 59 and OINM.AppObjAbs > -1
Order By FEC_MOV, NOM_MAT ,OP
  