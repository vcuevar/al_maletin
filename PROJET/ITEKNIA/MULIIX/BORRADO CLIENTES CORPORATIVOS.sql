-- Borrado de Clientes Corporativos.
-- Ing. Vicente Cueva R.
-- Actualizado: Martes 07 de Mayo del 2019; Inicio.

-- Declaraciones
DECLARE @CorpID nvarchar(50)

-- Asignar Valores a Variables

--Clientes Corporativo a Borrar.
-- CORPORATIVO 1
--Set @CorpID = 'AFC90630-46A1-4BE9-99FD-3862CE156A2F'
-- C M M S CLUB MED MANAGEMENT SERVICES INC
--Set @CorpID = '3AD2E226-76BF-4B07-9710-2150CB96D176'
-- EDIFICADORA DE INMUEBLES TURISTICOS SA DE CV
--Set @CorpID = '372709F6-D599-4006-B2C5-0B527A757CFB'
-- C M M S CLUB MED MANAGEMENT SERVICES INC
Set @CorpID = 'E5CC7BF3-BC2F-4503-A849-F764C23635E7'

-- Clientes con Nombre BORRAR
--Set @CorpID = '781EDF81-ACED-4C21-B4E0-4E39A7F95202'
--Set @CorpID = '65D5990E-46CF-4E4A-9D86-4E3B76CD530D'
--Set @CorpID = '38DE8235-3477-4728-84A0-F33F38232DAF'
--Set @CorpID = '7C4E37A4-54F1-4000-A438-7518FB179F99'


Select 'CLIENTES' as REPORTE, * from clientes
Where CLI_CorporativoId = @CorpID

--Where CLI_Corporativo = 1
--where CLI_ClienteId = @CorpID

--Delete clientes where CLI_ClienteId = @CorpID

select 'ARTICULOS' as REPORTE, * from ClientesCodigosArticulos
where CCA_CLI_ClienteId = @CorpID

Select 'CONTACTOS' as REPORTE, * from ClientesContactos
where CCON_CLI_ClienteId = @CorpID

Select 'COORDENADAS', * from ClientesCoordenadas
where CC_CLI_ClienteId = @CorpID

select 'CRITERIO' as REPORTE, * from ClientesCriteriosAdmon 
where CCA_CLI_ClienteId = @CorpID
--Delete ClientesCriteriosAdmon where CCA_CLI_ClienteId = @CorpID

select 'DIRECCIONES' as REPORTE, * from ClientesDireccionesEmbarques
where CDE_CLI_ClienteId = @CorpID

--select 'FACTURA' as REPORTE, * from ClientesFacturasTerceros
--select 'M' as REPORTE, * from ClientesM
--select 'PROSPECTO' as REPORTE, * from ClientesProspectos
--select 'SUCURSAL' as REPORTE, * from ClientesSucursalesEvaluacion
--select 'CEDI' as REPORTE, * from ClientesVentasCedi
--select * from ClientesVisitas
--select * from ClientesVisitasDetalle

select 'OV' as REPORTE, * from OrdenesVenta
where OV_CLI_ClienteId = @CorpID

select 'COTIZACION' as REPORTE, * from Cotizaciones
where COT_CLI_ClienteId = @CorpID

