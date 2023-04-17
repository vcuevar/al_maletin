

-- Definir variables sobre todo fechas

Declare @FechaIS nvarchar(30)
Declare @CodeArti as nvarchar(10)

Set @FechaIS = CONVERT (DATE, '2019/01/01', 102)
Set @CodeArti = '10002'

SELECT SUBSTRING("SQL Tutorial", 5, 3) AS ExtractString;

-- Formato Moneda
 FORMAT(PDN1.Price,'C2','es-MX') AS PRECIOF  a dos decimales
 FORMAT(PDN1.Price,'C4','es-MX') AS PRECIOF a 4 decimales
 
/* Uso del like */
Select * from [@TC_ATB] where U_AtbName like '%ZO US%'

/* Uso de Between y formato para fecha ('aaa/dd/mm') */
Where OINM.DocDate between ('2013/01/07') and ('2013/07/07')

CASE When CAST([@CP_LOGOF].U_FechaHora as  TIME) > CAST('10:00' as TIME) and CAST([@CP_LOGOF].U_FechaHora as  TIME) <= CAST('12:00' as TIME) then [@CP_LOGOF].U_Cantidad else 0 end as CT02,

where  [@CP_LOGOF].U_FechaHora BETWEEN '2015/20/10 00:00' and '2015/20/10 23:59:59') BIHR  

Select DISTINCT(ItemCode) from OITM


USO DE TOP
SELECT TOP (1) U_CT  FROM dbo.[@CP_OF] WHERE (U_DocEntry = OW.DocNum) ORDER BY U_CT DESC

-- Insertar registros
INSERT INTO Store_Information (Store_Name, Sales, Txn_Date)
VALUES ('Los Angeles', 900, '10-Jan-1999');

Insert Into CPDES (CODE01, CODE02, PAG_TAP2) Values ('3754-07','02','C') 

--Uso de Numero de Semana del tipo Europeo.
Select DATEPART(ISO_Week, '2017/10/04') As Lunes, DATEPART(ISO_Week, '2017/11/04') As Martes,  
DATEPART(ISO_Week, '2017/12/04') As Miercoles, DATEPART(ISO_Week, '2017/13/04') As Jueves,
DATEPART(ISO_Week, '2017/14/04') As Viernes, DATEPART(ISO_Week, '2017/15/04') As Sabado,
DATEPART(ISO_Week, '2017/16/04') As Domingo, DATEPART(ISO_Week, '2017/17/04') As Lunes      


/* Uso del Case when */
-- Para hacer que en una sola columna se presenten la opciones.
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

-- de otra forma para hacer una columan diferente.
Select OP,NOMBRE, VS, U_Entrega_Piel,
case when datediff(day,U_Entrega_Piel, getdate()) < 9 then VS else 0 end as Dias_8,
case when datediff(day,U_Entrega_Piel, getdate()) > 8 and datediff(day,U_Entrega_Piel, getdate()) < 16 then VS else 0 end as Dias_15,
case when datediff(day,U_Entrega_Piel, getdate()) > 15 and datediff(day,U_Entrega_Piel, getdate()) < 31 then VS else 0 end as Dias_30,
case when datediff(day,U_Entrega_Piel, getdate()) > 30 and datediff(day,U_Entrega_Piel, getdate()) < 61 then VS else 0 end as Dias_60,
case when datediff(day,U_Entrega_Piel, getdate()) > 60 and datediff(day,U_Entrega_Piel, getdate()) < 91 then VS else 0 end as Dias_90,
case when datediff(day,U_Entrega_Piel, getdate()) > 90 then VS else 0 end as Dias_120
FROM VW_SimilarControl005
ORDER BY NOMBRE asc

/* Uso de Like */
Select * from [@TC_ATB] where U_AtbName like '%BORRAR%'

select * from [@TC_ATB] where U_AtbName not like '%BORRAR%'


uSO DEL if VALIDAR.
if P1.existencia is null then 0 else P1.existencia end as Disponible,

-- GETDATE Devuelve la fecha con hora del sistema.Devuelve un valor datetime que contiene la fecha y hora del equipo
-- en el que la instancia de SQL Server se está ejecutando. El ajuste de zona horaria no está incluido.
select GETDATE(),* from [@CP_LOGOF] where U_DocEntry=48784 order by U_CT

Este artículo se tradujo de forma manual. Mueva el puntero sobre las frases del artículo para ver el texto original. Más información.
Traducción Original
GETDATE (Transact-SQL)

SQL Server 2014 Otras versiones 
Devuelve la marca de tiempo del sistema de base de datos actual como un valor datetime sin el ajuste de zona horaria de la base de datos. Este valor se deriva del sistema operativo del equipo donde la instancia de SQL Server se está ejecutando.
Nota Nota
SYSDATETIME y SYSUTCDATETIME tienen más precisión de fracciones de segundo que GETDATE y GETUTCDATE. SYSDATETIMEOFFSET incluye el ajuste de zona horaria del sistema. SYSDATETIME, SYSUTCDATETIME y SYSDATETIMEOFFSET pueden asignarse a una variable de cualquier tipo de fecha y hora.
Para obtener información general acerca de todos los tipos de datos y funciones de fecha y hora de Transact-SQL, vea Tipos de datos y funciones de fecha y hora (Transact-SQL).
Se aplica a: SQL Server (SQL Server 2008 a versión actual), Windows Azure SQL Database (Versión inicial a versión actual).
Icono de vínculo a temas Convenciones de sintaxis de Transact-SQL
Sintaxis
 GETDATE ( )
Tipo de valor devuelto
datetime
Comentarios
Las instrucciones Transact-SQL pueden hacer referencia a GETDATE en cualquier parte desde la que puedan
hacer referencia a una expresión datetime.
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

-- Para dar formato a un campo de Fecha/Hora
SELECT convert(varchar,getdate())    -- Mar 15 2018 10:35AM
SELECT convert(varchar,getdate(),0)  -- Mar 15 2018 10:35AM
SELECT convert(varchar,getdate(),1)  -- 03/15/18
SELECT convert(varchar,getdate(),2)  -- 18.03.15
SELECT convert(varchar,getdate(),3)  -- 15/03/18
SELECT convert(varchar,getdate(),4)  -- 15.03.18
SELECT convert(varchar,getdate(),5)  -- 15-03-18
SELECT convert(varchar,getdate(),6)  -- 15 Mar 18
SELECT convert(varchar,getdate(),7)  -- Mar 15, 18
SELECT convert(varchar,getdate(),8)  -- 10:39:39
SELECT convert(varchar,getdate(),9)  -- Mar 15 2018 10:39:48:373AM
SELECT convert(varchar,getdate(),10) -- 03-15-18
SELECT convert(varchar,getdate(),11) -- 18/03/15
SELECT convert(varchar,getdate(),15) -- 180315
SELECT convert(varchar,getdate(),13) -- 15 Mar 2018 10:41:07:590
SELECT convert(varchar,getdate(),14) -- 10:41:25:903
SELECT convert(varchar,getdate(),20) -- 2018-03-15 10:43:56
SELECT convert(varchar,getdate(),21) -- 2018-03-15 10:44:04.950
SELECT convert(varchar,getdate(),22) -- 03/15/18 10:44:50 AM
SELECT convert(varchar,getdate(),23) -- 2018-03-15
SELECT convert(varchar,getdate(),24) -- 10:45:45
SELECT convert(varchar,getdate(),25) -- 2018-03-15 10:46:11.263
 
-- T-SQL with century (YYYY or CCYY) datetime styles (formats)
SELECT convert(varchar, getdate(), 100) -- Oct 23 2016 10:22AM (or PM)
SELECT convert(varchar, getdate(), 101) -- 10/23/2016
SELECT convert(varchar, getdate(), 102) -- 2016.10.23
SELECT convert(varchar, getdate(), 103) -- 23/10/2016
SELECT convert(varchar, getdate(), 104) -- 23.10.2016
SELECT convert(varchar, getdate(), 105) -- 23-10-2016
SELECT convert(varchar, getdate(), 106) -- 23 Oct 2016
SELECT convert(varchar, getdate(), 107) -- Oct 23, 2016
SELECT convert(varchar, getdate(), 108) -- 09:10:34
SELECT convert(varchar, getdate(), 109) -- Oct 23 2016 11:10:33:993AM (or PM)
SELECT convert(varchar, getdate(), 110) -- 10-23-2016
SELECT convert(varchar, getdate(), 111) -- 2016/10/23
SELECT convert(varchar, getdate(), 112) -- 20161023
SELECT convert(varchar, getdate(), 113) -- 23 Oct 2016 06:10:55:383
SELECT convert(varchar, getdate(), 114) -- 06:10:55:383(24h)
SELECT convert(varchar, getdate(), 120) -- 2016-10-23 06:10:55(24h)
SELECT convert(varchar, getdate(), 121) -- 2016-10-23 06:10:55.383
SELECT convert(varchar, getdate(), 126) -- 2016-10-23T06:10:55.383
