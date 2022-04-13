-- COMPILACION DE REPORTES DE EXCEPCIONES FINANCIEROS
-- OBJETIVO: Mantener al dia algunos de los elementos claves para el area de Finanzas.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: 26 de Septiembre del 2018; Origen.
-- Actualizado: Viernes 23 de Julio del 2021; SAP 10

-- Validacion del Tipo de Cambio, Si es nulo y no da resultados es Urgente se capture el tipo de cambio para Mañana.	
	--NOTA: NO FUNCIONAN BIEN VER COMO MEJORAR ESTA ACTIVIDAD.
-- Alarma para Tipo de Cambio, correr a las 5:00 PM si es que no hay tres tipos de cambio hoy mas dos.
-- Avidar a Marcos, Pablo, Areli, Martin, Vicente, Mary, Mara (cancelado).
-- Si es nulo y no da resultados es Urgente se capture el tipo de cambio para Mañana.

--intentar jugar con un when que si trae valor presente null y si trae null presente valor 'SIN TC'
	Select '005 HOY SIN TC' AS REPORTE_005, CAST(ORTT.RateDate as DATE) as Fecha, ORTT.Currency, ORTT.Rate, CAST(GETDATE() as DATE) as HOY
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,1,CAST(GETDATE() as DATE)) 
	
-- Si es nulo y no da resultados es Recomendable que se capture el tipo de cambio para pasado Mañana.
	Select '010 MAÑANA SIN TC' AS REPORTE_010, CAST(ORTT.RateDate as DATE) as Fecha, ORTT.Currency, ORTT.Rate, CAST(GETDATE() as DATE) as HOY
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,2,CAST(GETDATE() as DATE)) 


--< EOF > EXCEPCIONES PARA EL AREA DE FINANZAS.