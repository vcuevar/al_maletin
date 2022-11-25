-- Guia de comandos para SQL
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 02 de Diciembre del 2020; Reorganizar Guia.

--BASICOS
Use SALOTTO						-- Nombre de la Base de Datos que se utiliza
Select *						-- Comando para seleccion y que campos va a traer * Todos
from OITM						-- Nombre de la Tabla donde Traera la Informcion
Where OITM.U_TipoMat = 'MP'		-- Utiliza para filtra de acuerdo a una condición
Order By OITM.ItemName			-- Ordena la consulta de forma ascendente por el campo ItemName

Select Distinct *				-- Presenta los registros que son diferentes de acuerdo a campos definidos

Group By						-- Se utiliza para generar grupos en las consultas
Having							-- Equivale a Where pero despues de un Grupo de datos.

--Declaracion para fechas, Se declara variable en fecha y se asigna el valor del dia con formato 102 aaaa-mm-dd
DECLARE @FechaIS date
Set @FechaIS = CONVERT (DATE, '2018-08-29', 102)

-- Ejemplo De un listado hacerlo un solo registro, cuando se tienen multiples resultados y se quiere presentar en un solo registro. 
Select STUFF ((Select distinct ' ' + A4.ItemName  
from OWOR
INNER JOIN ITT1 on OWOR.ItemCode = ITT1.Father
INNER JOIN OITM A3 on OWOR.ItemCode = A3.ItemCode
INNER JOIN OITM A4 on A3.U_Modelo = A4.ItemCode
where (OWOR.Status='R' or OWOR.Status  = 'P') and ITT1.Code = @Material 
FOR XML PATH ('')), 1, 0, '') as MOD_OWOR


-- Uso del like para filtrar
Select * from [@TC_ATB] where U_AtbName like '%BORRAR%'

select * from [@TC_ATB] where U_AtbName not like '%BORRAR%'


-- Uso de Between y formato para fecha ('aaa/dd/mm') segun el tipo de tabla 
Where OINM.DocDate between ('2013/01/07') and ('2013/07/07')

-- Uso de Case When para realizar una toma de descicion.
Case When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('10:00' as TIME) then
 [@CP_LOGOF].U_Cantidad Else 0 End as CT02,

-- Uso del Case when Para hacer que en una sola columna se presenten la opciones.
Select ODLN.DocEntry, ODLN.DocDate,
case 
	when datediff(day,ODLN.DocDate, getdate()) < 9 then 'A-08 dias' 
	when datediff(day,ODLN.DocDate, getdate()) >  8 and datediff(day,ODLN.DocDate, getdate()) < 16 then 'A-15 dias'
	when datediff(day,ODLN.DocDate, getdate()) > 15 and datediff(day,ODLN.DocDate, getdate()) < 31 then 'A-30 dias'
	when datediff(day,ODLN.DocDate, getdate()) > 30 and datediff(day,ODLN.DocDate, getdate()) < 61 then 'A-60 dias'
	when datediff(day,ODLN.DocDate, getdate()) > 60 and datediff(day,ODLN.DocDate, getdate()) < 91 then 'A-90 dias' 
	when datediff(day,ODLN.DocDate, getdate()) > 90 then 'A-MAS dias'
End as Grupo,
ODLN.CardCode, ODLN.CardName, DLN1.ItemCode, DLN1.Dscription, DLN1.Quantity, 
OITM.AvgPrice, OITM.U_VS, OITM.U_TipoMat, ODLN.Comments 
from ODLN 
inner join DLN1 on ODLN.DocEntry=DLN1.DocEntry left join OITM on DLN1.ItemCode=OITM.ItemCode 
where ODLN.DocStatus= 'O' and DLN1.TreeType <> 'S' and DLN1.LineStatus='O' order by ODLN.DocEntry 

-- Uso del Case When para de una columna se presente de diferentes columnas.
Select OP,NOMBRE, VS, U_Entrega_Piel,
case when datediff(day,U_Entrega_Piel, getdate()) < 9 then VS else 0 end as Dias_8,
case when datediff(day,U_Entrega_Piel, getdate()) > 8 and datediff(day,U_Entrega_Piel, getdate()) < 16 then VS else 0 end as Dias_15,
case when datediff(day,U_Entrega_Piel, getdate()) > 15 and datediff(day,U_Entrega_Piel, getdate()) < 31 then VS else 0 end as Dias_30,
case when datediff(day,U_Entrega_Piel, getdate()) > 30 and datediff(day,U_Entrega_Piel, getdate()) < 61 then VS else 0 end as Dias_60,
case when datediff(day,U_Entrega_Piel, getdate()) > 60 and datediff(day,U_Entrega_Piel, getdate()) < 91 then VS else 0 end as Dias_90,
case when datediff(day,U_Entrega_Piel, getdate()) > 90 then VS else 0 end as Dias_120
FROM VW_SimilarControl005
ORDER BY NOMBRE asc


-- Uso de TOP presenta cuantos primeros registros, Segun como se ordenes la tabla
SELECT TOP (1) U_CT  FROM dbo.[@CP_OF] WHERE (U_DocEntry = OW.DocNum) ORDER BY U_CT DESC


-- Insertar Nuevos registros a una tabla
INSERT INTO Store_Information (Store_Name, Sales, Txn_Date)
VALUES ('Los Angeles', 900, '10-Jan-1999')

Insert Into CPDES (CODE01, CODE02, PAG_TAP2) 
Values ('3754-07','02','C') 

--Uso de Numero de Semana del tipo Europeo.
Select DATEPART(ISO_Week, '2017/10/04') As Lunes, DATEPART(ISO_Week, '2017/11/04') As Martes,  
DATEPART(ISO_Week, '2017/12/04') As Miercoles, DATEPART(ISO_Week, '2017/13/04') As Jueves,
DATEPART(ISO_Week, '2017/14/04') As Viernes, DATEPART(ISO_Week, '2017/15/04') As Sabado,
DATEPART(ISO_Week, '2017/16/04') As Domingo, DATEPART(ISO_Week, '2017/17/04') As Lunes      


uSO DEL if VALIDAR.
if P1.existencia is null then 0 else P1.existencia end as Disponible,

-- GETDATE Devuelve la fecha con hora del sistema.Devuelve un valor datetime que contiene la fecha y hora del equipo
-- en el que la instancia de SQL Server se está ejecutando. El ajuste de zona horaria no está incluido.
select GETDATE(),* from [@CP_LOGOF] where U_DocEntry=48784 order by U_CT

Este artículo se tradujo de forma manual. Mueva el puntero sobre las frases del artículo para ver el texto original. Más información.
Traducción Original
GETDATE (Transact-SQL)

SQL Server 2014 Otras versiones 
Devuelve la marca de tiempo del sistema de base de datos actual como un valor datetime sin 
el ajuste de zona horaria de la base de datos. Este valor se deriva del sistema operativo del
equipo donde la instancia de SQL Server se está ejecutando.
Nota Nota

SYSDATETIME y SYSUTCDATETIME tienen más precisión de fracciones de segundo que
 GETDATE y GETUTCDATE. SYSDATETIMEOFFSET incluye el ajuste de zona horaria del sistema. 
 SYSDATETIME, SYSUTCDATETIME y SYSDATETIMEOFFSET pueden asignarse a una variable de cualquier 
 tipo de fecha y hora.
P
ara obtener información general acerca de todos los tipos de datos y funciones de fecha y hora 
de Transact-SQL, vea Tipos de datos y funciones de fecha y hora (Transact-SQL).

Se aplica a: SQL Server (SQL Server 2008 a versión actual), Windows Azure SQL Database 
(Versión inicial a versión actual).
Icono de vínculo a temas Convenciones de sintaxis de Transact-SQL
Sintaxis

 GETDATE ( )
Tipo de valor devuelto
datetime
Comentarios
Las instrucciones Transact-SQL pueden hacer referencia a GETDATE en cualquier parte desde
 la que puedan hacer referencia a una expresión datetime.
GETDATE es una función no determinista. 
Las vistas y las expresiones que hacen referencia a esta función en una columna no se pueden indizar.

Usar SWITCHOFFSET con la función GETDATE() puede hacer que la consulta se ejecute lentamente debido
a que el optimizador de consultas no puede obtener estimaciones de cardinalidad precisas para el valor
de GETDATE. Se recomienda calcular previamente el valor de GETDATE y después especificar el valor
en la consulta como se muestra en el ejemplo siguiente.

Además, se debe usar la sugerencia de consulta OPTION (RECOMPILE) para obligar al optimizador de
consultas a que vuelva a compilar un plan de consulta la próxima vez que se ejecute la misma consulta. 
De este modo, el optimizador tendrá estimaciones de cardinalidad precisas para GETDATE() y generará
un plan de consulta más eficaz.

DECLARE @dt datetimeoffset = switchoffset (CONVERT(datetimeoffset, GETDATE()), '-04:00'); 
SELECT * FROM t  
WHERE c1 > @dt OPTION (RECOMPILE);

Ejemplos
Los ejemplos siguientes usan las seis funciones de sistema de SQL Server que devuelven la fecha y hora
actuales para devolver la fecha, la hora o ambas. Los valores se devuelven en serie; por consiguiente,
sus fracciones de segundo podrían ser diferentes.
A.Obtener la fecha y hora actuales del sistema

SELECT SYSDATETIME()
    ,SYSDATETIMEOFFSET()
    ,SYSUTCDATETIME()
    ,CURRENT_TIMESTAMP
    ,GETDATE()
    ,GETUTCDATE();
El conjunto de resultados es el siguiente.
SYSDATETIME() 2007-04-30 13:10:02.0474381
SYSDATETIMEOFFSET()2007-04-30 13:10:02.0474381 -07:00
SYSUTCDATETIME() 2007-04-30 20:10:02.0474381
CURRENT_TIMESTAMP 2007-04-30 13:10:02.047
GETDATE() 2007-04-30 13:10:02.047
GETUTCDATE() 2007-04-30 20:10:02.047

B.Obtener la fecha actual del sistema
SELECT CONVERT (date, SYSDATETIME())
    ,CONVERT (date, SYSDATETIMEOFFSET())
    ,CONVERT (date, SYSUTCDATETIME())
    ,CONVERT (date, CURRENT_TIMESTAMP)
    ,CONVERT (date, GETDATE())
    ,CONVERT (date, GETUTCDATE());
El conjunto de resultados es el siguiente.
SYSDATETIME() 2007-05-03
SYSDATETIMEOFFSET() 2007-05-03
SYSUTCDATETIME() 2007-05-04
CURRENT_TIMESTAMP 2007-05-03
GETDATE() 2007-05-03
GETUTCDATE() 2007-05-04

C.Obtener la hora actual del sistema
SELECT CONVERT (time, SYSDATETIME())
    ,CONVERT (time, SYSDATETIMEOFFSET())
    ,CONVERT (time, SYSUTCDATETIME())
    ,CONVERT (time, CURRENT_TIMESTAMP)
    ,CONVERT (time, GETDATE())
    ,CONVERT (time, GETUTCDATE());
El conjunto de resultados es el siguiente.
SYSDATETIME() 13:18:45.3490361
SYSDATETIMEOFFSET()13:18:45.3490361
SYSUTCDATETIME() 20:18:45.3490361
CURRENT_TIMESTAMP 13:18:45.3470000
GETDATE() 13:18:45.3470000
GETUTCDATE() 20:18:45.3470000



-- Para Dar formato de Moneda o comas a numeros.

FORMAT(value, format, culture)

SELECT FORMAT(123456789, '##-##-#####')

Para moneda se utiliza

Select FORMAT(25000,'C','En-Us')    Resultado: = $25,000.00
Select FORMAT(25000,'C4','En-Us')   Resultado: = $25,000.0000





