-- Nombre: Compara STD y Compra de Articulos.
-- Solicito: Sr. Arie Zarkin.
-- Tarea: Realizar una comparacion entre el precio de compra y comparar con el costo estandar.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 20 de Octubre del 2022; Origen.

-- ================================================================================================
-- |               PARAMETROS GENERALES PARA EXCEPCIONES.                                         |
-- ================================================================================================
Declare @FechaIS nvarchar(30)
Declare @FechaFS nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2025/07/03', 102)
Set @FechaFS = CONVERT (DATE, '2025/07/03', 102)

-- ================================================================================================
-- |               DESARROLLO DEL PROCESO.                                                        |
-- ================================================================================================

/*
Select *
From PDN1
inner join OPDN on OPDN.DocEntry = PDN1.DocEntry 
Where Cast(OPDN.DocDate as DATE) Between @FechaIS and @FechaFS 
Order by PDN1.DocEntry 
*/



Select OPDN.CardCode as PROVCOD
	, OPDN.CardName as PROVEEDOR
	, PDN1.DocEntry as CONSECUTIVO
	, OPDN.DocNum as N_ENTRADA
	, Cast(OPDN.DocDate as DATE) as F_COMPRA
	, OITM.U_TipoMat as TIPOMAT
	, T1.Descr as NOM_GRUPO
	, PDN1.ItemCode as CODE_MAT
	, OITM.ItemName as DESCRIPCION
	, OITM.InvntryUom as UDM
	, PDN1.Quantity as CANTIDAD
	, PDN1.NumPerMsr as X_PAQ
	, (PDN1.Quantity*PDN1.NumPerMsr) as Q_INV, (PDN1.Price / PDN1.NumPerMsr) as PREC_UNIT
	, PDN1.LineTotal as IMPORTE
	--, OITM.AvgPrice as COSTOESTANDAR
	, L10.Price as COSTOESTADAR
	, ITM1.Price as LIS_COMPRA
	, ITM1.Currency as M_L
	, PDN1.Currency as M_C
	, PDN1.Rate as TIPOCAMBIO
	, (Select ORTT.Rate from ORTT Where CAST(ORTT.RateDate as DATE)= Cast(OPDN.DocDate as DATE) and ORTT.Currency= 'USD') as TC_USD
	, (Select ORTT.Rate from ORTT Where CAST(ORTT.RateDate as DATE)= Cast(OPDN.DocDate as DATE) and ORTT.Currency= 'EUR') as TC_EUR
	, (Select ORTT.Rate from ORTT Where CAST(ORTT.RateDate as DATE)= Cast(OPDN.DocDate as DATE) and ORTT.Currency= 'CAN') as TC_CAN 
From PDN1 
inner join OPDN on OPDN.DocEntry = PDN1.DocEntry 
left join OITM on PDN1.ItemCode = OITM.ItemCode 
left join ITM1 on PDN1.ItemCode = ITM1.ItemCode and ITM1.PriceList= 9 
left join ITM1 L10 on PDN1.ItemCode = L10.ItemCode and L10.PriceList= 10 
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where OITM.ItemCode is not null AND  OITM.U_TipoMat <> 'GF' AND Cast(OPDN.DocDate as DATE) Between @FechaIS and @FechaFS 
Order by PDN1.DocEntry 


