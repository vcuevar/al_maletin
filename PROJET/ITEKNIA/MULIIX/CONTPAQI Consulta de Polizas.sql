-- Consulta de Polizas de Contpaqi
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 17 de Marzo del 2021; Origen.

-- Parametros; Para la busqueda de la Poliza se realiza mediante.
-- Ejercicio + Periodo + TipoPol + Folio 
-- Internamente maneja un Id que es unico.

--Parametros Fecha Inicial y Fecha Final

DECLARE @FechaIS date;
DECLARE @FechaFS date

Set @FechaIS = CONVERT (DATE, '2023-03-01', 102)
Set @FechaFS = CONVERT (DATE, '2023-03-15', 102)

--DECLARE @FechaIS as date = CONVERT (DATE, '2023-01-01', 102);
--DECLARE @FechaFS as date = CONVERT (DATE, '2023-04-15', 102);

-- Consulta:

Select  Polizas.Ejercicio
        , Polizas.Periodo
        , Polizas.TipoPol
        , Polizas.Folio
        , Cast(Polizas.Fecha as Date) AS Fecha
        , TiposPolizas.Nombre AS Tipo
        , Polizas.Folio AS Numero
        , Polizas.Concepto AS Concepto
        , NumMovto AS Num
        , Referencia AS Referencia
        , Cuentas.Codigo AS Cuenta
        , Cuentas.Nombre AS Nombre
        , Case When MovimientosPoliza.TipoMovto = 0 then Importe else 0 end AS Cargos
        , Case When MovimientosPoliza.TipoMovto = 1 then Importe else 0 end As Abonos 
from Polizas
inner join MovimientosPoliza on Polizas.Id = MovimientosPoliza.IdPoliza
inner join Cuentas on Cuentas.Id = MovimientosPoliza.IdCuenta
inner Join TiposPolizas on TiposPolizas.Id = Polizas.TipoPol
Where Cast(Polizas.Fecha as Date) Between @FechaIS and @FechaFS
--Where Polizas.Id = 5430
Order By Polizas.Id, NumMovto


/*
Select *
from Polizas
inner join MovimientosPoliza on Polizas.Id = MovimientosPoliza.IdPoliza
--inner join Cuentas on Cuentas.Id = MovimientosPoliza.IdCuenta
Where Polizas.Id = 5430


Select Distinct TipoPol from Polizas

Select * from TiposPolizas

Select * from Cuentas 

Select * from MovimientosPoliza where Referencia = 'F-4352'

Select * from Polizas

 --where id = 4352
where Cast(Fecha as Date)= '2021-01-04'
--where Guid like '4f87534%'


Where Folio = 4352

Select * from Polizas


Select * from MovimientosPoliza where Referencia = 'F-4352'


Select * from TiposDocumentos

*/