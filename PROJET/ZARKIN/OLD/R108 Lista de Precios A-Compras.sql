-- Nombre Reporte: R108 Lista de Precios Compras.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 17 de Diciembre del 2018; Origen.
-- Actualizado: Miercoles 30 de Diciembre del 2020; Cambio de Base de Datos.

-- Consulta

Select	OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		--, OITB.ItmsGrpNam AS GRUPO
		--, OITM.InvntryUom AS UDM
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
		--, OITM.AvgPrice AS SYSTEMA_E
		--, OITM.LastPurPrc AS ULT_PRE
		--, OITM.LastPurCur AS ULT_MON
		--, OITM.LastPurDat AS ULT_FEC
From OITM 
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Where ITM1.Price <> 0  --and OITM.U_TipoMat = 'MP' 
Order By OITM.ItemName 



