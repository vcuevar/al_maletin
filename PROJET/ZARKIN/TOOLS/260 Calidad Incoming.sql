-- Nombre: 260 INCOMING CONTROL DE CALIDAD.
-- Identificar: 250417-260
-- Uso: Sistema de Incoming Calidad.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 18 de julio del 2025; Origen

-- Parametros
Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @nAlbaran as Integer

Set @FechaIS = CONVERT (DATE, '2025-06-02', 102)
Set @FechaFS = CONVERT (DATE, '2025-06-29', 102)

--Set @nAlbaran = 19994
Set @nAlbaran = 20005

Select OPDN.DocNum AS NOTA_ENTRADA
	, Cast(OPDN.DocDueDate as date) AS FEC_REC
	, OPDN.CardCode AS COD_PROV
	, OPDN.CardName AS NOMB_PROV
	, OPDN.NumAtCard AS N_FACT
	, PDN1.ItemCode AS COD_ART
	, PDN1.Dscription AS MATERIAL
	, PDN1.unitMsr2 AS UDM
	, PDN1.InvQty AS CANTIDAD
	, ISNULL((Select Top (1) OIBT.BatchNum from OIBT Where OIBT.ItemCode = PDN1.ItemCode and OIBT.BaseEntry = OPDN.DocEntry), 'N/A') AS LOTE
	, 'CANTIDAD INSPECCIONADA' AS CAN_INSP
	, 'CANTIDAD RECHAZADA' AS CAN_RECH 
	, OITM.ItmsGrpCod AS GRUPO
From OPDN
Inner Join PDN1 on OPDN.DocEntry = PDN1.DocEntry 
Inner Join OITM on PDN1.ItemCode = OITM.ItemCode
Where OPDN.DocNum = @nAlbaran
Order By MATERIAL

