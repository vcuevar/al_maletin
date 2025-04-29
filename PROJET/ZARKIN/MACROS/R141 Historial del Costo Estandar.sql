-- Nombre: 141 Historial del Costo Estandar.
-- Uso: Llevar Historial de Cambios de Lista de Precios 7 y pendientes a Estandar.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 30 de Octubre del 2024; Origen.

-- Select * from SIZ_HistoryEstandar Where HE_ItemCode = '11224'

/* ------------------------------------------------------------------------------------------------
|  Para llenar reporte del historial de los costos estandar.                                       |
--------------------------------------------------------------------------------------------------*/

Select	OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM	
		, OITM.OnHand AS EXISTENCIA
		, Cast(ITM1.Price as Decimal(16,4)) AS STD_ACTUAL
		, ITM1.Currency AS MON
		, Cast(HE.HE_PrecioEstandar as Decimal(16,4)) AS STD_OLD
		, HE.HE_PrecioNew AS P_COMP
		, Isnull(HE.HE_Moneda, 'NEL') AS M_COMP
		, HE.HE_TipoCambio AS TDC
		, Cast((HE.HE_PrecioNew * HE.HE_TipoCambio) as decimal(16,4)) AS P_NSTD
		, HE.HE_FechaCambio AS F_MODIF
		, HE.HE_NotasCambio AS NOTAS
		, T1.Descr AS GRUPPLAN
		, OITM.UpdateDate AS ACTUAL
From OITM
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Left Join SIZ_HistoryEstandar HE on HE.HE_ItemCode = OITM.ItemCode
Where OITM.U_TipoMat = 'MP' and OITM.QryGroup32 = 'N'
and OITM.U_GrupoPlanea = '7' and OITM.frozenFor = 'N'
Order By OITM.ItemName, HE.HE_FechaCambio desc 

/* ------------------------------------------------------------------------------------------------
|  Realizar Auditoria y presenta los que esten en +- 10%.                                         |
--------------------------------------------------------------------------------------------------*/


--Declare @FechaIS as Date

--Set @FechaIS = CONVERT (DATE, '2024-12-16', 102)

/*
Select  OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, Cast(ITM1.Price as decimal(18,4)) AS PRE_7
	, ITM1.Currency AS MON_7
	, ITM1.PriceList AS LISTA

	, (SELECT CONVERT(varchar,T1.Price) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 1) ULT0_PC

	, OITM.NumInBuy AS FACTOR

	, (SELECT CONVERT(varchar,T1.Currency) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 1) MON0_PC

	, ISNULL((SELECT CONVERT(varchar,T1.Rate) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 1), 1) TDC0_PC

	, Cast((SELECT CONVERT(varchar,T1.ActDelDate) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 1) as date) FECHA

	, (SELECT 'Ult-2 ' +CONVERT(varchar,T1.ActDelDate,3) + ' ' + CONVERT(varchar,T1.Price) + ' ' + CONVERT(varchar,T1.Currency) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 2) COMP_1

	, (SELECT 'Ult-3 ' +CONVERT(varchar,T1.ActDelDate,3) + ' ' + CONVERT(varchar,T1.Price) + ' ' + CONVERT(varchar,T1.Currency) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 3) COMP_2

	, (SELECT 'Ult-4 ' +CONVERT(varchar,T1.ActDelDate,3) + ' ' + CONVERT(varchar,T1.Price) + ' ' + CONVERT(varchar,T1.Currency) FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency, P.Rate From PDN1 P Where ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 4) COMP_3

From OITM
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=7 
Where OITM.U_TipoMat = 'MP' and OITM.QryGroup32 = 'N'
Order By DESCRIPCION


-- PARA BORRAR UN REGISTRO 



Select * from SIZ_HistoryEstandar Where HE_ItemCode = '18411'
and HE_FechaCambio = '2024-10-09'

Delete SIZ_HistoryEstandar Where HE_ItemCode = '18151' and HE_FechaCambio = '2024-10-09'

Update SIZ_HistoryEstandar set HE_PrecioNew = 363 Where HE_ItemCode = '18411' and HE_FechaCambio = '2024-10-09'



20558
1.- 09/12/24	6.142200	USD	20.196300
2.- 02/12/24	5.329300	USD	20.417300
3.- 02/12/24	6.142200	USD	20.417300


-- Para sacar las ultimas compras segun el registro.

SELECT CONVERT(varchar,T1.ActDelDate,3) FECHA_COMPRA
	, CONVERT(varchar,T1.Price) PRECIO_COMPRA
	, T1.Currency AS MONEDA_COMPRA
	, (Case When T1.Rate <> 0 then T1.Rate else 1 end)  AS TDC
FROM (
SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry
	, P.ItemCode
	, P.Price
	, P.ActDelDate
	, P.Currency 
	, P.Rate
From PDN1 P 
Where ItemCode = '13600') T1 
WHERE T1.NumReng = 1

SELECT CONVERT(varchar,T1.Price) PRECIO_COMPRA
FROM (
SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
	, P.DocEntry
	, P.ItemCode
	, P.Price
	, P.ActDelDate
	, P.Currency 
	, P.Rate
From PDN1 P 
Where ItemCode = '13600') T1 
WHERE T1.NumReng = 1

13600
1.- 10/12/24	0.302800	MXP	1.000000
2.- 25/10/24	0.302800	MXP	1.000000
3.- 02/09/24	0.302800	MXP	1.000000


) AS ULT_1, (SELECT CONVERT(varchar,T1.ActDelDate,3) + '  Se compro a: ' + CONVERT(varchar,T1.Price) + ' ' + T1.Currency FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng
, P.DocEntry
, P.ItemCode
, P.Price, P.ActDelDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1 
WHERE T1.NumReng = 2) AS ULT_2, 

Select Convert(varchar,PDN1.ActDelDate,3) AS FECHA
	, Convert(varchar,PDN1.Price) AS PRECIO
	, Convert(varchar, PDN1.Currency) AS MONEDA
From PDN1
WHERE PDN1.ItemCode = '13600'
ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine

--OITM.ItemCode 
ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine

) as decimal(16,4)) AS U_COMP

*/




/*
/* ------------------------------------------------------------------------------------------------
|  Asignar un Nuevo Registro al Historial de Cambios                                               |
--------------------------------------------------------------------------------------------------*/

Declare @CodArt as nvarchar(15)
Declare @FecCam as date
Declare @NuePre as decimal(16,4)
Declare @Moneda as nvarchar(3)
Declare @TipoCa as decimal(16,4)
Declare @PreStd as decimal(16,4)
Declare @NotCam as nvarchar(120)

Set @CodArt = '20387'
Set @FecCam = CONVERT (DATE, '2023/01/20', 102)
Set @NuePre =  2220.0000 
Set @Moneda = 'MXP'
Set @TipoCa = 1.00
Set @PreStd = 2610.0000 
Set @NotCam	= 'PRIMER AJUSTE  AUTORIZADO DAVID ZARKIN'

Insert Into [dbo].SIZ_HistoryEstandar
			( [HE_ItemCode], [HE_FechaCambio], [HE_PrecioNew], [HE_Moneda], [HE_TipoCambio], [HE_PrecioEstandar], [HE_NotasCambio])
		Values
			(@CodArt, @FecCam, @NuePre, @Moneda, @TipoCa, @PreStd, @NotCam)
*/

/*
/* ------------------------------------------------------------------------------------------------
|  Para llenar reporte de las compras con variaciones de mas 10% o menos 10% sobre el estandar.    |
--------------------------------------------------------------------------------------------------*/
-- Variables
Declare @FechaIS as nvarchar(30)
Declare @FechaFS as nvarchar(30)
Declare @Articulo as nvarchar(30)
Declare @nLista as Int

Set @FechaIS = '2024/11/03'
Set @FechaFS = '2024/11/27'
Set @Articulo = '20649'
Set @nLista = 10


Select *
From PDN1
Where Cast (PDN1.DocDate as DATE) between  @FechaIS and @FechaFS 
and PDN1.ItemCode = @Articulo


Select CP.ItemCode AS CODIGO
	, CP.Dscription AS DESCRIPCION
	, CP.unitMsr AS UDM

From PDN1 CP
Where Cast (CP.DocDate as DATE) between  @FechaIS and @FechaFS 
and CP.ItemCode = @Articulo
*/



/*
/* ------------------------------------------------------------------------------------------------
| Agregar campos que me faltaron en la creacion de la tabla [dbo].SIZ_HistoryEstandar              |
--------------------------------------------------------------------------------------------------*/

Alter Table SIZ_HistoryEstandar
	ADD HE_PrecioNew decimal(19,6) NOT NULL,
		HE_TipoCambio decimal(19,6) NOT NULL;
*/

/*
/* ------------------------------------------------------------------------------------------------
| Para borrar tabla completa del Historial del Costo Estandar.                                     |
--------------------------------------------------------------------------------------------------*/

Delete SIZ_HistoryEstandar 

*/

/* ------------------------------------------------------------------------------------------------
| Para sacar grupos que deben tener el mismo costo.                                                |
--------------------------------------------------------------------------------------------------*/

Select  OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, Cast(ITM1.Price as decimal(18,4)) AS PRE_7
	, ITM1.Currency AS MON_7
	, ITM1.PriceList AS LISTA

	, Cast(0.5286 as Decimal(16,4)) AS PRE_COMPRA
	, 'MXP' AS MON_COM
	, 1.00 AS TIP_CAMB
	, Cast(0.5286 as Decimal(16,4)) AS NEW_STAD
	, .10 AS VAR
	, Cast ('2025/04/24'as DATE) AS FEC_COM
	, 'COMPRA_01' AS COMP1
	, 'COMPRA_02' AS COMP2
	, 'COMPRA_03' AS COMP3
	, 'VAR X COP+GRUPO' AS NOTA
	, 'POR ACTUALIZAR' AS ACCION
From OITM
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=7 
Where ItemName like 'HILO A 1.2%'
Order By DESCRIPCION









