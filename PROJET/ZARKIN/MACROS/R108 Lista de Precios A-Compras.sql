-- Nombre Reporte: R108 Lista de Precios Compras.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 17 de Diciembre del 2018; Origen.
-- Actualizado: Miercoles 30 de Diciembre del 2020; Cambio de Base de Datos.

-- Consulta

Select	OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.PurPackMsr AS UDC
		, Cast(OITM.NumInBuy as Decimal(14,0)) AS FACTOR
		, OITM.InvntryUom AS UDM	
		, OITM.OnHand AS EXISTENCIA
		, Cast(ITM1.Price as Decimal(14,4)) AS PRECIO
		, ITM1.Currency AS MON
		, HE.HE_PrecioEstandar
		, HE.HE_Moneda
		, HE.HE_FechaCambio
		, HE.HE_NotasCambio
From OITM 
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Inner Join SIZ_HistoryEstandar HE on HE.HE_ItemCode = OITM.ItemCode
Where 
OITM.U_TipoMat = 'MP' and OITM.QryGroup32 = 'N'
Order By OITM.ItemName 

--Select * from SIZ_HistoryEstandar


