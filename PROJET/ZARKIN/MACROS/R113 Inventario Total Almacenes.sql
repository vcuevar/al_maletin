-- Consulta para obtener el inventario Total Almacenes.
-- Elaborado: Vicente Cueva Raírez.
-- Actualizado: Miercoles 07 de Abril del 2021.

/*
--Consulta Para Resumen total del Importe.

Select SUM(OITM.OnHand * ITM1.Price) as Inventario 
from OITM 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList=10
where OITM.OnHand > 0

-- Consulta para Resumen total de Cantidades

Select SUM(OITM.OnHand) as Existencia from OITM where OITM.OnHand > 0

-- Consulta para reporte de Existencias por Almacen

Select	OITW.WhsCode AS CODEALMA
		, OWHS.WhsName AS NOMBALMA
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OITW.OnHand as EXISTENCIA
		, ITM1.Price as LIST_10
		, OITW.OnHand * ITM1.Price AS IMPORTE
		, OITM.U_TipoMat AS TIPOMAT
		, OITM.U_VS AS VS
		, OITM.U_VS * OITW.OnHand AS TVS
		, UFD1.Descr as LINEA
		, T1.Descr AS GRUPPLAN
		, (OITM.U_Minimo/5) AS KxDia
from OITM 
inner join OITW on OITM.ItemCode=OITW.ItemCode 
inner join OWHS on OWHS.WhsCode=OITW.WhsCode 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 
inner join UFD1 on OITM.U_Linea= UFD1.FldValue and UFD1.TableID='OITM'and UFD1.FieldID=7
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where OITW.OnHand <> 0 
Order by OWHS.WhsName, OITM.U_TipoMat, OITM.ItemName 

-- Consulta para Calcular el Valor sala en Proceso.
Select sum(BO.VS) as TVS 
from Vw_BackOrderExcel BO where BO.U_Starus = '06'  


-- Consulta para sacar el total del Decimetros de Piel y el Importe de dicho material.
Select	sum(RVB.Entregado) as Decimetros, 
		sum(RVB.Importe) as Dineros 
from ( 
Select	OW.IssuedQty as Entregado, 
		(OW.IssuedQty * L10.Price) as Importe 
from Vw_BackOrderExcel BO 
inner join WOR1 OW on BO.OP = OW.DocEntry 
inner join OITM A1 on OW.ItemCode = A1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList=10 
where BO.U_Starus = '06' and A1.ItmsGrpCod = 113 ) RVB 

-- Consulta para completar Materiales que lleba cargados las ordenes.

Select	sum(RVB.Entregado) as Decimetros, 
		sum(RVB.Importe) as Dineros 
from ( 
Select	OW.IssuedQty as Entregado, 
		(OW.IssuedQty * L10.Price) as Importe 
from Vw_BackOrderExcel BO 
inner join WOR1 OW on BO.OP = OW.DocEntry 
inner join OITM A1 on OW.ItemCode = A1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList= 10 
where BO.U_Starus = '06' and A1.ItmsGrpCod <> 113   and OW.IssuedQty > 0) RVB 

*/

-- Calcula Valor Sala de Inventario Inicial de las Ordenes de Casco.
Select KDX.CODIGO AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(KDX.ENTRADA) AS ENTRADA 
	, SUM(KDX.SALIDA) AS SALIDA
	, SUM((KDX.ENTRADA + KDX.SALIDA) * -1) AS EX_INI
	, SUM((KDX.ENTRADA + KDX.SALIDA) * KDX.VS * -1) AS EX_INI
From (
Select OINM.ItemCode AS CODIGO
	, (OINM.OutQty -OINM.InQty) AS ENTRADA
	, 0 AS SALIDA
	, OINM.AppObjAbs
	, A3.U_VS AS VS
From OINM 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat = 'CA'
Where Cast (OINM.CreateDate as DATE) < Cast(getdate() as DATE)
and OINM.AppObjAbs <> -1 
Union All	
Select OINM.ItemCode AS CODIGO
	, 0 AS ENTRADA
	, (OINM.InQty - OINM.OutQty) AS SALIDA
	, OINM.AppObjAbs
	, A3.U_VS AS VS
From OINM  
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat = 'CA'
Where Cast(OWOR.CloseDate as DATE) < Cast(getdate() as DATE)
and OINM.AppObjAbs <> -1 
) KDX
Inner Join OITM on KDX.CODIGO = OITM.ItemCode
Inner Join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10 
Group By KDX.CODIGO, OITM.ItemName, OITM.InvntryUom, ITM1.Price, KDX.VS
Having SUM(KDX.ENTRADA + KDX.SALIDA) <> 0 
Order By ARTICULO






-- Calcula materiales cargados a las OP para CA la fecha de Corte.
Select KDX.CODIGO AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(KDX.ENTRADA) AS ENTRADA 
	, SUM(KDX.SALIDA) AS SALIDA
	, SUM(KDX.ENTRADA + KDX.SALIDA) AS EX_INI
	, SUM((KDX.ENTRADA + KDX.SALIDA) * KDX.VS * -1) AS EX_INI
	
	--, KDX.AppObjAbs AS OC
From (
Select OINM.ItemCode AS CODIGO
	, (OINM.OutQty -OINM.InQty) AS ENTRADA
	, 0 AS SALIDA
	, OINM.AppObjAbs
	, A3.U_VS AS VS
From OINM 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat = 'CA'
Where Cast (OINM.CreateDate as DATE) < Cast(getdate() as DATE)
and OINM.AppObjAbs <> -1 
Union All	
Select OINM.ItemCode AS CODIGO
	, 0 AS ENTRADA
	, (OINM.InQty - OINM.OutQty) AS SALIDA
	, OINM.AppObjAbs
	, A3.U_VS AS VS
From OINM  
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat = 'CA'
Where Cast(OWOR.CloseDate as DATE) < Cast(getdate() as DATE)
and OINM.AppObjAbs <> -1 
) KDX
Inner Join OITM on KDX.CODIGO = OITM.ItemCode
Inner Join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10 
Group By KDX.CODIGO, OITM.ItemName, OITM.InvntryUom, ITM1.Price, KDX.VS
Having SUM(KDX.ENTRADA + KDX.SALIDA) <> 0 
Order By ARTICULO

