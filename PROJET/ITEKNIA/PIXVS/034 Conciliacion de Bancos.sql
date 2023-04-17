-- 034 Conciliación de Bancos. 
-- Objetivo: Realizar Estado de Cuenta Conciliado y pendiente a conciliar de las cuentas de Bancos.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Martes 25 de Junio del 2019; Inicio del reporte.
-- Actualizado: Lunes 17 de Junio del 2019; Culmen del Reporte.

Use iteknia
--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)

Declare @xNomMon as nvarchar(30)
Declare @ProveCod as nvarchar(30) 

Set @FechaIS = CONVERT (DATE, '2016-12-31', 102)
Set @FechaFS = CONVERT (DATE, '2019-06-20', 102) 

Set @xNomMon = 'Pesos'
Set @ProveCod = 'P178'



Select * from Bancos

Select * from BancosCuentas

Select * from BancosTransferencias

Select * from CXPPagos Where CXPP_IdentificacionPago Like '%9479%'

'%LUIS FDO%'

