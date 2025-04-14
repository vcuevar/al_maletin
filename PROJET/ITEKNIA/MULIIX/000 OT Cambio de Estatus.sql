-- Metodo para cambiar Status de la OT para que no se vea en PISO
-- Desarrolló: Ing. Vicente Cueva Rámirez.
-- Actualizado: Miercoes 21 de Octubre del 2020; Origen.

-- Parametros
-- OT
-- Nuevo Estatus

-- Relacion de Estatus para OT

Select * from ControlesMaestrosMultiples Where CMM_ControlId	='3887AF19-EA11-4464-A514-8FA6030E5E93'

--  CMM_ControlId	                        CMM_Valor
-- 3C843D99-87A6-442C-8B89-1E49322B265A	Abierta                                         Aparece en Movil
-- 3887AF19-EA11-4464-A514-8FA6030E5E93	Cerrada Por Usuario                             Aparece en Movil
-- 46B96B9F-3A45-4CF9-9775-175C845B6198	Cerrada y Costeada Material                     Aparece en Movil
-- 7246798D-137A-4E94-9404-1D80B777EE09	Cerrada y Costeada Material Parcial
-- 3E35C727-DAEE-47FE-AA07-C50EFD93B25F	Cerrado Y Costeado                              Aparece en Movil
-- A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B	En Producción                                   Aparece en Movil
-- F860806C-B1EC-4047-AA95-EDAD406DE10E	Recibido                                        Aparece en Movil

Select OT_Codigo, CMM_Valor
from OrdenesTrabajo
inner join ControlesMaestrosMultiples on CMM_ControlId	= OT_CMM_Estatus
Where OT_Codigo like 'OT02818'
Order by OT_Codigo

update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT02586'
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT02818'


update OrdenesTrabajo set OT_CMM_Estatus = '3E35C727-DAEE-47FE-AA07-C50EFD93B25F' Where OT_Codigo = 'OT00005' -- Cerrado y Costeado
update OrdenesTrabajo set OT_CMM_Estatus = '46B96B9F-3A45-4CF9-9775-175C845B6198' Where OT_Codigo = 'OT00006' -- Cerrada y Costeada Material
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT00014' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '7246798D-137A-4E94-9404-1D80B777EE09' Where OT_Codigo = 'OT00015' -- Cerrada y Costeada Material Parcial
update OrdenesTrabajo set OT_CMM_Estatus = 'F860806C-B1EC-4047-AA95-EDAD406DE10E' Where OT_Codigo = 'OT00016' -- Recibido
update OrdenesTrabajo set OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B' Where OT_Codigo = 'OT00017' -- En Produccion

46B96B9F-3A45-4CF9-9775-175C845B6198

--Se cambio estatus a cerradas por Usuario ya que tenian Recibo Parcial
-- Lunes 04 de Diciembre del 2023
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03640' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03381' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03163' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03164' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03003' -- Cerrada por Usuario

update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03637' -- Cerrada por Usuario

-- VIernes 19 de Enero del 2024 (Ceradas Parcial, se cambio a cerradas por Usuario)
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03854' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03862' -- Cerrada por Usuario
update OrdenesTrabajo set OT_CMM_Estatus = '3887AF19-EA11-4464-A514-8FA6030E5E93' Where OT_Codigo = 'OT03939' -- Cerrada por Usuario


