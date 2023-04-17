USE [SBO_Salotto]
GO

/****** Object:  View [dbo].[BackOrderPT]    Script Date: 12/08/2022 02:53:24 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BackOrderPT]
AS
SELECT     TOP (100) PERCENT dbo.ORDR.DocNum AS Pedido, dbo.ORDR.DocDate AS FechaPedido, dbo.ORDR.NumAtCard AS OC, dbo.OWOR.DocNum AS OP, 
                      dbo.ORDR.CardCode AS CODIGO_CLIENTE, dbo.ORDR.CardName AS NOMBRE, dbo.OWOR.ItemCode AS CODIGO_ARTICULO, dbo.OITM.ItemName AS DESCRIPCION, 
                      dbo.OITM.U_VS AS VS, dbo.ORDR.U_Prioridad AS PRIORIDAD, dbo.OWOR.DueDate AS FENTREGA, DATEPART(YY, dbo.OWOR.DueDate) AS ANIO, DATEPART(WK, 
                      dbo.OWOR.DueDate) AS SEMANA, dbo.OWOR.RlsDate AS FLIBERADO, dbo.OWOR.U_NoSerie, '*' + dbo.OWOR.ItemCode + '*' AS EtiquetaItemcode, 
                      '*' + CAST(dbo.OWOR.DocNum AS varchar(10)) + '*' AS EtiquetaOP, '*' + dbo.ORDR.CardCode + '*' AS EtiquetaCliente, '*' + CAST(dbo.ORDR.DocNum AS varchar(10)) 
                      + '*' AS EtiquetaPedido, dbo.OWOR.U_cc AS Complejo
FROM         dbo.ORDR INNER JOIN
                      dbo.OWOR ON dbo.ORDR.DocNum = dbo.OWOR.OriginNum INNER JOIN
                      dbo.OITM ON dbo.OWOR.ItemCode = dbo.OITM.ItemCode
WHERE     (dbo.OWOR.Status <> 'C') AND (dbo.OITM.U_TipoMat = 'PT') and (dbo.OWOR.DocEntry = 21210)
ORDER BY Pedido

GO

