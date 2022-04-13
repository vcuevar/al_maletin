-- Consultas sobre Catalogos de SAP 10
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 30 de Abril del 2021.


-- Validar Clientes.

Select	CardCode
		, CardName
from OCRD
Where CardType = 'C'


-- Validar Proveedores.

Select	CardCode
		, CardName
from OCRD
Where CardType = 'S'


-- Validar Articulos (SOLO DE LINEA)

Select	ItemCode
		, ItemName
From OITM
Where OITM.U_Linea = '01'



-- Validar Articulos (NO LINEA CON EXISTENCIA)

Select	ItemCode
		, ItemName
From OITM
Where OITM.U_Linea <> '01' AND OnHand > 0