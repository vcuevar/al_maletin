-- Macro R144 Devoluciones de Piel.
-- Presentar las devoluciones de piel registradas en el sistema SAP, por ordenes de producci�n.
-- Solicitado : Ing. Elias Garcia; Jefe de Producci�n.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 12 de septiembre del 2025; Origen

--NOTAS:
--Emisi�n para producci�n ( Es lo que carga almacen a las OP)
--Issue for Production (Es lo que se consume de la OP)
--Recibo de producci�n (Es las devoluciones o las entregas de producto de la OP)


/* ========================================
*   Tabla de Tipos de Movimientos         *
===========================================
TransType			Nombre
13			Facturas clientes
14			Notas de cr�dito clientes 
15			Entregas 
16			Devoluciones 
18			Fact.proveedores 
20			Pedido de entrada de mercanc�as
21			Devoluci�n de mercanc�as 
59			Entrada de mercanc�as / Recibo de producci�n
60			Salida de mercanc�as / Emisi�n para producci�n
67			Traslados 
162			Revalorizaci�n de inventario
*/


-- Parametros

Declare @FechaIS as Date
Declare @FechaFS as Date

Set @FechaIS = CONVERT (DATE, '2025-09-01', 102)
Set @FechaFS = CONVERT (DATE, '2025-09-12', 102)

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
and OINM.JrnlMemo Like 'Recib%'
Order By FEC_MOV, NOM_MAT ,OP
  

  /*
    ,OINM.CardName, OINM.BASE_REF, OINM.AppObjAbs, OINM.DocDate, OINM.CreateDate
	, OINM.JrnlMemo	, ITM1.Price as COST01
	, OINM.Price as COSTO_H
	, OINM.RevalTotal
	, OINM.UserSign, OUSR.U_NAME
	, OITM.U_VS, OINM.Comments
	, OITM.U_TipoMat, OINM.DocTime 
	*/

/*
Emisi�n para producci�n
Issue for Production
Recibo de producci�n

	Select Distinct OINM.JrnlMemo AS dato 
	from OINM 
	Where OINM.JrnlMemo like 'Devolu%'
	and OINM.JrnlMemo not like 'Entrada%'
	and OINM.JrnlMemo not like 'Entrega%'
	and OINM.JrnlMemo not like 'Fact%'
	and OINM.JrnlMemo not like 'Notas%'
	and OINM.JrnlMemo not like 'Pedido%'
	and OINM.JrnlMemo not like 'Salida%'
	Order By OINM.JrnlMemo

*/
