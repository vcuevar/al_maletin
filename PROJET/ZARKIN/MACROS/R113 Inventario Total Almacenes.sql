-- Consulta para obtener el inventario Total Almacenes.
-- Elaborado: Vicente Cueva Raírez.
-- Actualizado: Miercoles 07 de Abril del 2021.


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


