-- Consulta para cargar Devoluciones al faltante de embarcar.
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 07 de Octubre del 2021; Origen.

DECLARE @Devolu integer
--DECLARE @Pedido integer

Set @Devolu = 187
--Set @Pedido = 3

/*
Select id, docentry, linenum, itemcode, dscription, BASEREF, LINESTATUS,
cantidad, cantidada, precio, currency, rate, tipo, fechapedido, npedido, cardcode
, cardname, fechaalmacen, fechamovimiento

	, usact
	, PRIORIDAD
	, ORIGEN
	, whscode 
from FaltanteEmbarcar
where ID = 3304


Select * from ORDN
Where DocEntry = 45

Select * from RDN1
Where DocEntry = 45

 Select * from FaltanteEmbarcar Where npedido= '3' and CardCode = 'C0202'

select TOP(10) * from FaltanteEmbarcar 
where ID = 4314

*/

Select (Select max(convert(int, id)) + 1 from FaltanteEmbarcar) AS ID 
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
	, RDN1.Rate AS Rate
	, 'D' AS Tipo
	, 0 AS Facturado
	, 'C0202' AS CardCode
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
from ORDN
Inner Join RDN1 on RDN1.DocEntry = ORDN.DocEntry
Where ORDN.DocNum = @Devolu Order by  RDN1.Dscription 

--Select * from ORDR Where DocNum = @Pedido


/*
INSERT INTO FALTANTEEMBARCAR (ID, DocEntry, LinNum, BaseRef, LineStatus, ItemCode, Dscription, Cantidad, CantidadA, Precio, Currency, Rate, Tipo, Facturado, CardCode, CardName, Npedido, fechapedido, FECHAMOVIMIENTO, FECHAALMACEN, Actualizando, usact, Prioridad, DetCredito, Origen, WhsCode)
values(   )

Id --max +1 de la misma tabla, es decir numero consecutivo. select max(convert(int,id)) + 1 as id from FaltanteEmbarcar
docentry
linenum
itemcode
dscription
BASEref --en caso nulo "S"
LINESTATUS
QUANTITY
OPENQTY
PRICE
CURRENCY. --en caso nulo "S"
RATE. --en caso nulo "I"
'I'
fecha_pedido
pedido --en caso de nulo "I"
cardcode  --en caso nulo "S"
cardname --en caso nulo "S"
fechaentrada
getdate() -- fecha actual
clveus --num empleado
PRIORIDAD --cuando es nulo este campo se deja NULL
 ORIGEN
whscode

*/

