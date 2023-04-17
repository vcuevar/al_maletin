-- Nombre: Incidencias de los Empleados en Nomimpaq.
-- Objetivo: Tener la Informacion para llenar tablas de control de Gestion de Recursos Humanos.
-- Siistema: Nomimpaq (SQL)
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 06 de Octubre del 2022; Origen.

-- Parámetros 
Declare @Anual as Integer
Declare @Semana as Integer
Declare @NumEmpl as Integer
Declare @FechaIS as nvarchar(30)

Set @Anual = 2022
Set @Semana = 39
Set @NumEmpl = 34
Set @FechaIS = CONVERT (DATE, '2022/09/26', 102)


-- Relacion de los documentos de Marketing.












SELECT * FROM NOM10000          -- Datos de la Empresa

SELECT idempleado, codigoempleado, nombre, apellidopaterno, apellidomaterno, sueldodiario, sueldointegrado, fechaalta 
FROM NOM10001        
where codigoempleado = '994'

--idempleado = 536

SELECT * FROM NOM10002          -- Periodos Key idperiodo
WHERE ejercicio = 2022 and numeroperiodo = 39

SELECT * FROM NOM10003          -- Departamentos  Key iddepartamento
where iddepartamento = 12

SELECT * FROM NOM10004          -- Conceptos  Key idconcepto

SELECT idempleado, N5.idconcepto, tipoconcepto, descripcion, formulaimportetotal 
FROM NOM10005 N5
inner join NOM10004 N4 on N5.idconcepto = N4.idconcepto
where idempleado = 536



Select * from NOM10007
 where idperiodo=370 and idempleado = 536
 
 Periodo 39 = id 370
 

Select NOM10001.codigoempleado
        , NOM10001.nombre
        , NOM10001.apellidopaterno
        , NOM10001.apellidomaterno
        , NOM10001.fechaalta 
        , NOM10034.cidperiodo 
        , NOM10034.sueldodiario
        , NOM10034.sueldointegrado
        , NOM10034.cdiastrabajados
        , NOM10034.cdiaspagados
        , NOM10034.cdiascotizados
        , NOM10034.cdiasvacaciones
From NOM10001
Inner Join NOM10034 on NOM10001.idempleado = NOM10034.idempleado        
Where cidperiodo = 371  --codigoempleado = '994'


idempleado, 
 
Inner Join NOM10001 on NOM10001.ideempleado = NOM100034.idempleado and NOMI10034.cidperiodo = 370 
 
 
Select * from NOM10008

Where idempleado = 536 and cidperiodo = 370

where codigoempleado = '994'

