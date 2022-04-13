-- Proceso de Borado de Tablas relacionadas a clientes.
-- Desarrollado: Ing. Vicente Cueva Ramirez
-- Actualizado: Martes 04 de Diciembre del 2018

-- Borrado Tabla de Clientes Prospectos (3 Registros)
Select * from ClientesProspectos

--Delete ClientesProspectos

-- Borrado de tabla de Cotizaciónes (Un Registro).
Select * from Cotizaciones

-- Delete Cotizaciones

-- Borrado de Tabla Clientes Direcciones de Embarques. (3 Registros)
-- Tiene relacion con la table Cotizaciones.
Select * from ClientesDireccionesEmbarques

--Delete ClientesDireccionesEmbarques

-- Borrado de Tabla Criterios Administracion del Cliente (32 Registros)
Select * from ClientesCriteriosAdmon

--Delete ClientesCriteriosAdmon

-- Borrado de Tabla Coordenadas del Clientes (4 Registros)
Select * from ClientesCoordenadas

--Delete ClientesCoordenadas

-- Borrado de Tabla Contactos de los Clientes (24 Registros).
Select * from ClientesContactos

--Delete ClientesContactos

-- Borrado de Tabla Contactos de los Clientes (32 Registros)
Select * from Clientes

--Delete Clientes

