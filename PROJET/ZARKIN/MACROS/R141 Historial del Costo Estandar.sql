-- Nombre: 141 Historial del Costo Estandar.
-- Uso: Llevar Historial de Cambios de Lista de Precios 7 y pendientes a Estandar.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 30 de Octubre del 2024; Origen.


-- Select * from SIZ_HistoryEstandar


-- Consulta para llenar el Reporte
Select	OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.PurPackMsr AS UDC
		, Cast(OITM.NumInBuy as Decimal(14,0)) AS FACTOR
		, OITM.InvntryUom AS UDM	
		, OITM.OnHand AS EXISTENCIA
		, Cast(HE.HE_PrecioEstandar as Decimal(16,4)) AS STD_OLD
		, ITM1.Currency AS MON

		, HE.HE_PrecioNew AS P_COMP
		, HE.HE_Moneda AS M_COMP
		, HE.HE_TipoCambio AS TDC
		, Cast((HE.HE_PrecioNew * HE.HE_TipoCambio) as decimal(16,4)) AS P_NSTD
		, HE.HE_FechaCambio AS F_MODIF
		, HE.HE_NotasCambio AS NOTAS
From OITM 
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Left Join SIZ_HistoryEstandar HE on HE.HE_ItemCode = OITM.ItemCode
Where OITM.U_TipoMat = 'MP' and OITM.QryGroup32 = 'N'
and OITM.ItemCode = '20549'
Order By OITM.ItemName, HE.HE_FechaCambio desc 


-- Asignar un Nuevo Registro al Historia de Cambios
/*
Declare @CodArt as nvarchar(15)
Declare @FecCam as date
Declare @NuePre as decimal(16,4)
Declare @Moneda as nvarchar(3)
Declare @TipoCa as decimal(16,4)
Declare @PreStd as decimal(16,4)
Declare @NotCam as nvarchar(120)

Set @CodArt = '20549'
Set @FecCam = CONVERT (DATE, '2023/01/20', 102)
Set @NuePre = 227.00
Set @Moneda = 'MXP'
Set @TipoCa = 1.00
Set @PreStd = 227.00
Set @NotCam	= 'FIJAR ESTANDAR, DAVID ZARKIN'

Insert Into [dbo].SIZ_HistoryEstandar
			( [HE_ItemCode], [HE_FechaCambio], [HE_PrecioNew], [HE_Moneda], [HE_TipoCambio], [HE_PrecioEstandar], [HE_NotasCambio])
		Values
			(@CodArt, @FecCam, @NuePre, @Moneda, @TipoCa, @PreStd, @NotCam)
*/



-- Agregar campos que me faltaron en la creacion de la tabla [dbo].SIZ_HistoryEstandar
/*

Alter Table SIZ_HistoryEstandar
	ADD HE_PrecioNew decimal(19,6) NOT NULL,
		HE_TipoCambio decimal(19,6) NOT NULL;
*/
