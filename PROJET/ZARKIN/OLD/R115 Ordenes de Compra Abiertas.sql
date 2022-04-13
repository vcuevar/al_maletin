-- Nombre Reporte: R115 Ordenes de Compra Abiertas.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 13 de Abril del 2021; Cambio a SAP-10.

-- Parametros Ninguno

-- Desarrollo de la Consulta


    
Select	OPOR.DocNum as NumOC, 
		OPOR.DocDate as FechOC, 
		OPOR.CardCode as CodeProv, 
		OPOR.CardName as NombProv, 
		POR1.ItemCode as Codigo, 
		POR1.Dscription as Descrip, 
		POR1.Quantity as CantTl, 
		POR1.OpenQty as CantPend, 
		POR1.ShipDate as FechEnt, 
		OSLP.SlpName as Elaboro, 
		'ARTICULOS' as TipoOC, 
		UFD1.Descr as Comprador, 
		case when datediff(day,POR1.ShipDate, getdate()) >  0 and datediff(day,POR1.ShipDate, getdate()) < 9 then 'A-08 dias' 
			when datediff(day,POR1.ShipDate, getdate()) >  8 and datediff(day,POR1.ShipDate, getdate()) < 16 then 'A-15 dias' 
			when datediff(day,POR1.ShipDate, getdate()) > 15 and datediff(day,POR1.ShipDate, getdate()) < 31 then 'A-30 dias' 
			when datediff(day,POR1.ShipDate, getdate()) > 30 and datediff(day,POR1.ShipDate, getdate()) < 61 then 'A-60 dias' 
			when datediff(day,POR1.ShipDate, getdate()) > 60 and datediff(day,POR1.ShipDate, getdate()) < 91 then 'A-90 dias' 
			when datediff(day,POR1.ShipDate, getdate()) > 90 then 'A-MAS dias' End as Grupo, 
		1 as QtyMat, 
		OPOR.Comments, 
		POR1.Price, 
		POR1.Currency 
From OPOR 
INNER JOIN POR1 ON OPOR.DocEntry = POR1.DocEntry 
LEFT JOIN OITM ON POR1.ItemCode = OITM.ItemCode 
INNER JOIN OSLP on OSLP.SlpCode= POR1.SlpCode 
LEFT JOIN UFD1 on OITM.U_Comprador= UFD1.FldValue and UFD1.TableID='OITM' and UFD1.FieldID=10 
WHERE POR1.LineStatus <> 'C' and POR1.ItemCode is not null 

Union all 

Select	OPOR.DocNum as NumOC
		, OPOR.DocDate as FechOC
		, OPOR.CardCode as CodeProv
		, OPOR.CardName as NombProv
		, Isnull(POR1.ItemCode, 'N/A') as Codigo
		, POR1.Dscription as Descrip
		, POR1.Quantity as CantTl
		, POR1.OpenQty as CantPend
		, OPOR.DocDueDate as FechEnt
		, OSLP.SlpName as Elaboro
		, 'SERVICIOS' as TipoOC
		, 'Libre' as Comprador
		, Case when datediff(day,OPOR.DocDueDate, getdate()) >  0 and datediff(day,OPOR.DocDueDate, getdate()) < 9 then 'A-08 dias' 
			when datediff(day,OPOR.DocDueDate, getdate()) >  8 and datediff(day,OPOR.DocDueDate, getdate()) < 16 then 'A-15 dias' 
			when datediff(day,OPOR.DocDueDate, getdate()) > 15 and datediff(day,OPOR.DocDueDate, getdate()) < 31 then 'A-30 dias' 
			when datediff(day,OPOR.DocDueDate, getdate()) > 30 and datediff(day,OPOR.DocDueDate, getdate()) < 61 then 'A-60 dias' 
			when datediff(day,OPOR.DocDueDate, getdate()) > 60 and datediff(day,OPOR.DocDueDate, getdate()) < 91 then 'A-90 dias' 
			when datediff(day,OPOR.DocDueDate, getdate()) > 90 then 'A-MAS dias' End as Grupo
		, 1 as QtyMat
		, OPOR.Comments
		, POR1.Price
		, POR1.Currency 
From OPOR 
INNER JOIN POR1 ON OPOR.DocEntry = POR1.DocEntry 
LEFT JOIN OITM ON POR1.ItemCode = OITM.ItemCode 
INNER JOIN OSLP on OSLP.SlpCode= POR1.SlpCode 
Where POR1.LineStatus <> 'C' and POR1.ItemCode is null 

Order By FechEnt, NombProv, Descrip 









