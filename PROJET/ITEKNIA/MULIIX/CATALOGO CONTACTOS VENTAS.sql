

SELECT * from ClientesContactos
Select * from Clientes 


Select Distinct CLI_CodigoCliente, CLI_RazonSocial, CCON_Nombre,	CCON_Puesto
From ClientesCOntactos
inner join Clientes on CCON_CLI_ClienteId = CLI_ClienteId
Where CLI_Eliminado = 0
Order by CCON_Nombre
