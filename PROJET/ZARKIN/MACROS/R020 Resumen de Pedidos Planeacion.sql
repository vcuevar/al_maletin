-- Nombre: 020 Resumen de Pedidos Planeacion.
-- Uso: Presentar Pedido para programar en planeación.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 30 de Agosto del 2018; Origen
-- Actualizado: Jueves 28 de agosto del 2025; Cargar Orden de Compra.

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date

Set @FechaIS = CONVERT (DATE, '2025-08-20', 102)
Set @FechaFS = CONVERT (DATE, '2025-08-20', 102)

-- Resumen de Pedidos.

Select ORDR.DocEntry AS PEDIDO
	, Cast(ORDR.DocDate as date) AS FEC_PEDIDO
	, ORDR.NumAtCard AS OC
	, ORDR.CardCode AS COD_CLIENTE
	, ORDR.CardName AS NOMBRE_CLI
	, RDR1.ItemCode  AS COD_ARTI
	, OITM.ItemName AS ARTICULO
	, RDR1.Quantity AS CANTIDAD
	, (RDR1.Quantity * OITM.U_VS) AS VST
	, ORDR.DocDueDate AS FEC_ENTREGA
	, ORDR.CANCELED AS CANCELADO
	, CASE WHEN ORDR.U_Prioridad=3 THEN '6' ELSE ORDR.U_Prioridad END AS PRIORIDAD 
From ORDR
Inner Join RDR1 on ORDR.DocNum = RDR1.DocEntry
Inner Join OITM on RDR1.ItemCode = OITM.ItemCode
Where ORDR.DocDate between @FechaIS and @FechaFS and OITM.U_TipoMat = 'PT' and RDR1.TreeType <> 'I'
Order By FEC_PEDIDO, PEDIDO, OC

/*
-- Consulta Original del Reporte
Select ordr.DocEntry 
	,ORDR.DocDate
	, ORDR.DocDueDate 
	, ORDR.CardCode
	, ORDR.CardName 
	, RDR1.ItemCode 
	, oitm.ItemName
	, RDR1.Quantity as Cantidad
	, CASE RDR1.TreeType  when 'S' then  Padre.VS * RDR1.Quantity  else SUM(oitm.u_vs * RDR1.Quantity)  end as VS  
	, RDR1.Price  
	, (rdr1.Quantity * RDR1.Price ) as Importe
	, ordr.DiscPrcnt as DescuentoGeneral
	, ORDR.CANCELED
	, CASE WHEN ORDR.U_Prioridad=3 THEN '6' ELSE ORDR.U_Prioridad END AS U_Prioridad 
From ((ORDR 
inner join RDR1 on ORDR.DocNum = RDR1.DocEntry) 
inner join oitm on RDR1.ItemCode = OITM.ItemCode)
left join (select Father , sum(oitm.U_VS  * ITT1.Quantity ) as VS from ITT1 inner join OITM on ITT1.Code  = OITM.ItemCode
	where  OITM.U_TipoMat = 'PT' group by ITT1.Father) as Padre on RDR1.ItemCode = Padre.Father 
where (RDR1.TreeType <> 'I' ) and ORDR.DocDate between @FechaIS and @FechaFS
and OITM.U_TipoMat = 'PT' 
group by  ORDR.CardCode , ORDR.CardName , ORDR.DocEntry, ORDR.DocDate, ORDR.DocDueDate , RDR1.ItemCode , OITM.ItemName
, RDR1.Quantity, RDR1.Price, ORDR.DiscPrcnt, RDR1.TreeType, Padre.VS, ordr.canceled, ORDR.U_Prioridad 
order by ORDR.DocEntry, oitm.ItemName asc 

*/
-- between '" & FechaIS & "' and '" & FechaFS & "'

