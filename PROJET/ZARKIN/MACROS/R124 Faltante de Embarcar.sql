-- Consultas para Faltante de Embarcar
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizada: Jueves 27 de Mayo del 2021.

-- Consultar 
select * from FaltanteEmbarcar 
--where ID = 3304
Where ItemCode LIKE '3831-43-B0085%'
3745-37-P0322	BAZZTA, -1R-, PIEL 0322 LATTE.
  
--Articulo 3703-41-P0615, Cliente C0202, Pedido 3
update FaltanteEmbarcar set Cantidad = 13, CantidadA = 13 Where ID = 1058        

-- Cambiar parte de la Informacion.

update FaltanteEmbarcar set 
	ItemCode = '3819-39-P0310' 
	, Dscription = 'KIRSH 1B, -1RBD-, PIEL 0310 BROWN.'
	, Cantidad = 1
	, CantidadA = 1
Where ID = 3996
 
 
update FaltanteEmbarcar set Dscription = 'BURANO, -T- CUILTEADO, PIEL 0523 CHAMPAGNE  / TELA ZARKS TERCIOPELO BEIGE.'
Where ID = 1087


--Alta solicitada por Andrea 210927
update FaltanteEmbarcar set ItemCode = '3839-13-P0713', Dscription = 'BIANCA, -2BI USA-, PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4123
update FaltanteEmbarcar set ItemCode = '3839-22-P0713', Dscription = 'BIANCA, -CHBD USA-, PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4124
update FaltanteEmbarcar set ItemCode = 'ZAR0515', Dscription = 'BIANCA (PROTO) -1SB- PIEL 0713 MACADAMIA', Cantidad = 2, CantidadA = 2 Where ID = 4125
update FaltanteEmbarcar set ItemCode = 'ZAR0516', Dscription = 'BIANCA (PROTO) -EMX- PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4126
update FaltanteEmbarcar set ItemCode = 'ZAR0517', Dscription = 'BIANCA (PROTO) -TMX- PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4127
update FaltanteEmbarcar set ItemCode = 'ZAR0582', Dscription = 'ZULU, (PROTO)-3BI-, PIEL 0302 GRAYSH', Cantidad = 1, CantidadA = 1 Where ID = 4128
update FaltanteEmbarcar set ItemCode = 'ZAR0584', Dscription = 'ZULU, (PROTO)-CHBD-, PIEL 0302 GRAYSH', Cantidad = 1, CantidadA = 1 Where ID = 4129
update FaltanteEmbarcar set ItemCode = 'ZAR0695', Dscription = 'ZAPU (PROTO) -1- PIEL 0801 WENGE.', Cantidad = 2, CantidadA = 2 Where ID = 4130

--Alta solicitada por Andrea 210929
update FaltanteEmbarcar set ItemCode = '3680-02-P0301', Dscription = 'ZIAMO, -2-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 4156
update FaltanteEmbarcar set ItemCode = '3680-03-P0301', Dscription = 'ZIAMO, -3-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 4157
update FaltanteEmbarcar set ItemCode = '3755-18-P0471', Dscription = 'IZZOLA NEW, -1BBI-, PIEL 0471 VAPOR.', Cantidad = 1, CantidadA = 1 Where ID = 4158
update FaltanteEmbarcar set ItemCode = '3755-19-P0471', Dscription = 'IZZOLA NEW, -1BBD-, PIEL 0471 VAPOR.', Cantidad = 1, CantidadA = 1 Where ID = 4159



Select * from FaltanteEmbarcar Where ItemCode = '3814-01-P0433' and Npedido = '3'
Select * from FaltanteEmbarcar Where Cast(FECHAALMACEN as date) < Cast('2021/01/18' as Date)

Update FaltanteEmbarcar set FECHAALMACEN = FECHAMOVIMIENTO  Where Cast(FECHAALMACEN as date) < Cast('2021/01/18' as Date)
Update FaltanteEmbarcar set FECHARFACT = null where ID = 2
Update FaltanteEmbarcar set FECHARFACT = '2021/05/27' where ID =278



Select ItemCode, ItemName
from OITM Where ItemCode = '3819-39-P0310'


-- Consulta para Obtener Devoluciones y cargar a Faltante de Embarcar.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizada: Jueves 21 de Octubre del 2021.
DECLARE @Devolu integer
Set @Devolu = 159

Select	(Select max(convert(int, id)) + 1 from FaltanteEmbarcar) AS ID
		, ORDN.DocNum AS DocEntry
		, RDN1.LineNum AS LinNum
		, RDN1.BaseRef AS BaseRef
		, RDN1.LineStatus AS LineStatus
		, RDN1.ItemCode AS ItemCode
		, RDN1.Dscription AS Dscription
		, RDN1.Quantity AS Cantidad
		, RDN1.Quantity AS CantidadA
		, RDN1.Price AS Precio
		, RDN1.Currency AS Currency
		, RDN1.Rate AS Rate, 'D' AS Tipo
		, 0 AS Facturado, 'C0202' AS CardCode
		, 'STOCK DISPONIBLE SALAS' AS CardName
		, '3' AS Npedido
		, Cast(DocDueDate as date) AS fechapedido
		, Cast(DocDueDate as date) AS FECHAMOVIMIENTO
		, Cast(DocDueDate as date) AS FECHAALMACEN
		, 0 AS Actualizando
		, '1023' AS usact
		, 'S' AS Prioridad
		, 'N' AS DetCredito
		, 'P' AS Origen
		, RDN1.WhsCode AS WhsCode
From ORDN
Inner Join RDN1 on RDN1.DocEntry = ORDN.DocEntry 
Where ORDN.DocNum = @Devolu 
Order by  RDN1.Dscription 


INSERT INTO FALTANTEEMBARCAR (ID, DocEntry, LinNum, BaseRef, LineStatus, ItemCode, Dscription, Cantidad, CantidadA, Precio, Currency, Rate, Tipo, Facturado, CardCode, CardName, Npedido, fechapedido, FECHAMOVIMIENTO, FECHAALMACEN, Actualizando, usact, Prioridad, DetCredito, Origen, WhsCode)
values(   )

GO


-- Consulta para Obtener Notas de Credito y cargar a Faltante de Embarcar.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizada: Jueves 21 de Octubre del 2021.
DECLARE @NotaCred integer
Set @NotaCred = 1201

Select	(Select max(convert(int, id)) + 1 from FaltanteEmbarcar) AS ID
		, ORIN.DocNum AS DocEntry
		, RIN1.LineNum AS LinNum
		, RIN1.BaseRef AS BaseRef
		, RIN1.LineStatus AS LineStatus
		, RIN1.ItemCode AS ItemCode
		, RIN1.Dscription AS Dscription
		, RIN1.Quantity AS Cantidad
		, RIN1.Quantity AS CantidadA
		, RIN1.Price AS Precio
		, RIN1.Currency AS Currency
		, RIN1.Rate AS Rate, 'D' AS Tipo
		, 0 AS Facturado, 'C0202' AS CardCode
		, 'STOCK DISPONIBLE SALAS' AS CardName
		, '3' AS Npedido
		, Cast(DocDueDate as date) AS fechapedido
		, Cast(DocDueDate as date) AS FECHAMOVIMIENTO
		, Cast(DocDueDate as date) AS FECHAALMACEN
		, 0 AS Actualizando
		, '1023' AS usact
		, 'S' AS Prioridad
		, 'N' AS DetCredito
		, 'P' AS Origen
		, RIN1.WhsCode AS WhsCode
From ORIN
Inner Join RIN1 on RIN1.DocEntry = ORIN.DocEntry 
Where ORIN.DocNum = @NotaCred 
Order by  RIN1.Dscription 

GO

Insert Into FaltanteEmbarcar(ID, DocEntry, LineNum, BaseRef, LineStatus
, ItemCode, Dscription, Cantidad, CantidadA, Precio, Currency
, Rate, Tipo, Facturado, CardCode, CardName, Npedido, fechapedido
, FECHAMOVIMIENTO, FECHAALMACEN, Actualizando, usact, Prioridad
, DetCredito, Origen, WhsCode) 

values('4765'
	, 1201
	, 0 
	, 5993 
	, 'C'
, '3738-09-B0169'
, 'TAZZO, -PIE DE CAMA KS-, TELA MONTY NUBE'
, 1.00

, 1.00

, 4834.08

, 'MXP'
, 0
, 'D'
, 0
, 'C0202'
, 'STOCK DISPONIBLE SALAS'
, 3
, '2021-10-19'
, '2021-10-19'
, '2021-10-19'
, 0
, '1023'
, 'S'
, 'N'
, 'P'
, 'AXL-CA')

GO
      


