-- COMPILACION DE REPORTES DE EXCEPCIONES FINANCIEROS
-- OBJETIVO: Mantener al dia algunos de los elementos claves para el area de Finanzas.
-- Desarrollo: Ing. Vicente Cueva Ram�rez.
-- Actualizado: 26 de Septiembre del 2018; Origen.
-- Actualizado: Viernes 23 de Julio del 2021; SAP 10

-- Validacion del Tipo de Cambio, Si es nulo y no da resultados es Urgente se capture el tipo de cambio para Ma�ana.	
	--NOTA: NO FUNCIONAN BIEN VER COMO MEJORAR ESTA ACTIVIDAD.
-- Alarma para Tipo de Cambio, correr a las 5:00 PM si es que no hay tres tipos de cambio hoy mas dos.
-- Avidar a Marcos, Pablo, Areli, Martin, Vicente, Mary, Mara (cancelado).
-- Si es nulo y no da resultados es Urgente se capture el tipo de cambio para Ma�ana.

--intentar jugar con un when que si trae valor presente null y si trae null presente valor 'SIN TC'
/*
	Select '005 HOY SIN TC' AS REPORTE_005, CAST(ORTT.RateDate as DATE) as Fecha, ORTT.Currency, ORTT.Rate, CAST(GETDATE() as DATE) as HOY
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,1,CAST(GETDATE() as DATE)) 
	
-- Si es nulo y no da resultados es Recomendable que se capture el tipo de cambio para pasado Ma�ana.
	Select '010 MA�ANA SIN TC' AS REPORTE_010, CAST(ORTT.RateDate as DATE) as Fecha, ORTT.Currency, ORTT.Rate, CAST(GETDATE() as DATE) as HOY
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,2,CAST(GETDATE() as DATE)) and ORTT.Currency = 'USD'

	
	-- Validar que en sistema se tenga el tipo de cambio 

	Select * from SIZ_TipoCambio Order By TC_date desc
*/

-- Si es nulo y no da resultados es Recomendable que se capture el tipo de cambio para pasado Ma�ana.

Select Case When ( 
	COALESCE((Select ORTT.Currency
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,1,CAST(GETDATE() as DATE)) and ORTT.Currency = 'USD' ),'NEL')) = 'NEL' Then
	'DIA HOY SIN TC' else
''
	end AS HOY_SIN_TC

Select Case When ( 
	COALESCE((Select ORTT.Currency
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,2,CAST(GETDATE() as DATE)) and ORTT.Currency = 'USD' ),'NEL')) = 'NEL' Then
	'DIA DOS SIN TC' else
''
	end AS MA�ANA_SIN_TC



Select Case When ( 
	COALESCE((Select ORTT.Currency
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,3,CAST(GETDATE() as DATE)) and ORTT.Currency = 'USD' ),'NEL')) = 'NEL' Then
	'DIA TRES SIN TC' else
''
	end AS DIA_3_TC

	
Select Case When ( 
	COALESCE((Select ORTT.Currency
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,4,CAST(GETDATE() as DATE)) and ORTT.Currency = 'USD' ),'NEL')) = 'NEL' Then
	'DIA CUATRO SIN TC' else
''
	end AS DIA_4_TC

-- Tipo de Cambio autorizados

Select * from SIZ_TipoCambio Order By TC_date desc

-- Para realizar nuevo registro de Tipos de Cambio.
/*
-- 14/Feb/2024 David Zarkin me dijo que este seria el tipo de cambio en Dolares, los otros dos los deje 
-- como venian del a�o pasado.

-- 21/Octubre/24 Al no definir el cambio de Estandar y con tantos ajustes no autorizados, cambie el 
-- tipo de cambio con los siguientes datos, registrados en SAP.

Declare @FechaCrea as date
Declare @TC_USD as decimal(10,4)
Declare @TC_CAN as decimal(10,4)
Declare @TC_EUR as decimal(10,4)

Set @FechaCrea = GETDATE()
Set @TC_USD = 19.95
Set @TC_CAN = 14.50
Set @TC_EUR = 21.51

Insert Into [dbo].SIZ_TipoCambio
			( [TC_date], [TC_can], [TC_usd], [TC_eur])
		Values
			(@FechaCrea, @TC_CAN, @TC_USD, @TC_EUR)
Go

*/

--< EOF > EXCEPCIONES PARA EL AREA DE FINANZAS.