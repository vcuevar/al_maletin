-- 030-A Catalogo de Clientes.
-- Ing. Vicente Cueva R.
-- Actualizado: Jueves 07 de Febrero del 2019; Origen.

-- Declaraciones

Select	
		CLI_CodigoCliente,CLI_ClienteId,
		CLI_RazonSocial,
		CLI_NombreComercial,
		CLI_RFC,
		CLI_Activo
from Clientes
Where CLI_Corporativo = 0 and CLI_Activo = 1
Order by CLI_CodigoCliente

