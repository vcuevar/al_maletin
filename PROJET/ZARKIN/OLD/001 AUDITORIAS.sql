-- Auditoria para Validar Base de SAP 10
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 06 de Mayo del 2021.


--Temporal Numero de LDM en SAP 8 17,247
--	Lunes 10 de Mayo del 2021		237
--	Martes 11 de Mayo del 2021		258		(21)
--  Jueves 13 de Mayo del 2021		358		(100)
-- Viernes 14 de Mayo del 2021		421		(63)
-- Lunes 17 de Mayo del 2021		450		(29) 	213 Semana 42 por dia
-- Martes 18 de Mayo del 2021		511			
--Jueves 20 de Mayo del 2021		574		(124)  Sem 41 por dia
--Viernes 21 de Mayo del 2021		627
-- Lunes 24 de Mayo del 2021		676		
-- Miercoles 26 de Mayo del 2021	749

Select DISTINCT Father from ITT1

-- Articulos con Metodo Promedio Ponderado, hay 16 con este error.

Select '001 ARTICULO METODO NO ESTANDAR' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, OITM.AvgPrice AS COSTO
From OITM
Where OITM.EvalSystem <> 'S' and OITM.ItemCode <> '19076' and OITM.ItemCode <> '19089'
and OITM.ItemCode <> '19090' and OITM.ItemCode <> '19091' and OITM.ItemCode <> '19092'
and OITM.ItemCode <> '19107' and OITM.ItemCode <> '19108' and OITM.ItemCode <> '19110'
and OITM.ItemCode <> '19111' and OITM.ItemCode <> '19112' and OITM.ItemCode <> '19755'
and OITM.ItemCode <> '19756' and OITM.ItemCode <> '19757' and OITM.ItemCode <> '19822'
 and OITM.ItemCode <> '19833' and OITM.ItemCode <> '3831-58-L0001'

-- Validar que no tenga ceros en listas de Precios 10 ESTANDAR.
Select	'005 LISTA PRECIOS 10' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Where ITM1.Price = 0  and OITM.EvalSystem = 'S'
Order By OITM.ItemName 

-- Validar que no tenga ceros en listas de Precios 09 A-COMPRAS.
Select	'010 LISTA PRECIOS 09' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=9 
Where ITM1.Price = 0  and OITM.EvalSystem = 'S'
Order By OITM.ItemName 

-- Validar que no tenga ceros en listas de Precios 01 DISEÑO.
Select	'015 LISTA PRECIOS 01' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=1
Where ITM1.Price = 0  and OITM.EvalSystem = 'S'
Order By OITM.ItemName 


-- Validar que no tenga ceros en listas de Precios 02 VENTAS.
Select	'020 LISTA PRECIOS 02' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=2
Where ITM1.Price = 0  and OITM.EvalSystem = 'S'
Order By OITM.ItemName 


-- Validar que no tenga ceros en Costo Estandar Usar Revalorizacion de Inventarios.
-- Realizar Cargas de 50 para que no truene la carga en la WEB.
-- Al Martes 18 de Mayo faltan 9,838 registros.

Select top (100) '025 COSTO ESTANDAR' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, OITM.AvgPrice AS PRECIO
		, ITM1.Price AS PRECIO_10
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where OITM.AvgPrice = 0 and OITM.EvalSystem = 'S' and ITM1.Price <> 0 and OITM.InvntItem = 'Y'
and OITM.OnHand > 0
Order By OITM.ItemName 


-- Validar que no haya diferencia entre costo Estandar 10
-- Usar Revalorizacion de Inventarios..Hacer comparacion a 4 decimales?
Select 	'025 COSTO ESTANDAR' AS REPORTE
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, round(OITM.AvgPrice, 4) AS PRECIO
		, round(ITM1.Price, 4) AS PRECIO_10
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where round(OITM.AvgPrice, 4) <> round(ITM1.Price, 4) and OITM.InvntItem = 'Y' and OITM.AvgPrice <> 0
--and OITM.OnHand > 0
Order By OITM.ItemName 

-- Que no esten con Costo Estandar en ce
