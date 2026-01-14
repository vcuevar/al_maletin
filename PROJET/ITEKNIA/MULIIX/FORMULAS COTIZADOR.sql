-- Formulas para asignar al Cotizador de Invtek
-- Elaboro: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 26 de noviembre del 2025; Origen.

-- Declaración de Variables.

DECLARE @ancho as decimal(16,3)
DECLARE @alto AS decimal(16,3)
DECLARE @numeroHojas AS decimal(16,3)
DECLARE @anchoTela AS decimal(16,3)

SET @ancho = 6.8
SET @alto = 3.5
SET @numeroHojas = 1
SET @anchoTela = 2.80

-- Calculo de Tela

--SELECT CEILING((@alto + 0.45) *  CEILING((@ancho * 2) / @anchoTela)) AS resultado

--SELECT CEILING(CEILING((@ancho * 2) / @anchoTela) * (@alto + 0.45)) AS resultado

-- Calcula Metros de Riel
/*
SELECT  CEILING(@ancho) AS resultado

-- Calculo de Correderas y Ganchos

SELECT  CEILING(@ancho) * 12 AS resultado

-- Numero Fijo de piezas (2 piezas por cortinero)

SELECT 2 AS resultado


-- Confeccion de Cortinas, Mano de obra

SELECT CEILING(@ancho * 2 / @anchoTela) * @anchoTela * (CASE 
		WHEN @alto BETWEEN 0.01 and 3 THEN 1.0
		WHEN @alto BETWEEN 3.01 and 4 THEN 1.5
		WHEN @alto BETWEEN 4.01 and 5 THEN 2.0
		WHEN @alto BETWEEN 5.01 and 6 THEN 2.5
		WHEN @alto BETWEEN 6.01 and 7 THEN 3.0
		WHEN @alto BETWEEN 7.01 and 8 THEN 3.5
		WHEN @alto BETWEEN 8.01 and 9 THEN 4.0
		WHEN @alto > 9.01 THEN 4.5 ELSE 2 END) AS resultado

		
-- Calculo de ganchos para Ripplefold al 60%
		
SELECT  CEILING(CEILING(@ancho)/0.0655) AS resultado
		
		
-- Calculo de cinta con broche
SELECT  CEILING(CEILING(@ancho)/0.0655)*0.1079 AS resultado
			
		
Cuando ponemos que por cada Hoja 1 pieza nos arroja dos. Checar
			
*/


		
-- Calculo de Bridas o Soportes
SELECT  CEILING(@ancho/1.5)*2 - 1 AS resultado

SELECT  CEILING(@ancho -1) AS resultado

SELECT  CEILING(@ancho/1.5) + 2 AS resultado

SELECT  CEILING(@ancho) AS resultado

SELECT (CASE 
		WHEN @ancho BETWEEN 0.01 and 1.5 THEN 2.0
		WHEN @ancho BETWEEN 1.51 and 3.0 THEN 3.0
		WHEN @ancho BETWEEN 3.01 and 4.5 THEN 4.0
		WHEN @ancho BETWEEN 4.51 and 6.0 THEN 5.0
		WHEN @ancho BETWEEN 6.01 and 7.5 THEN 6.0
		WHEN @ancho BETWEEN 7.51 and 9.0 THEN 7.0
		WHEN @ancho BETWEEN 9.01 and 10.5 THEN 8.0
		WHEN @ancho > 10.51 THEN 9.0 ELSE 2 END) AS resultado


