-- 000 Relacion de Contactos de Ventas 
-- Macro para tener relacion de Contactos de clientes, agrupados por Corporativos y Clientes.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 20 de Noviembre del 2020; Origen 

-- Parametros que no este eliminado el contacto.

-- Desarrollo de la Consulta

Select  --CCON_ContactoId as ID_CONTACTO,
        (Select CLI_RazonSocial from Clientes Where CLI_ClienteId = (Select X.CLI_CorporativoId from Clientes X Where X.CLI_ClienteId = CCON_CLI_ClienteId)) as CORPORATIVO,
        (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes where CLI_ClienteId = CCON_CLI_ClienteId) as CLIENTE,
        CCON_Nombre as COMPRADOR,
        CCON_Puesto as PUESTO,
        CCON_Departamento as DEPARTAMENTO,
        CCON_Telefono as TELEFONO,
        CCON_Extension as EXTENCION,
        CCON_Email as EMAIL,
        CCON_Celular as CELULAR,
        CCON_Calle as CALLE,
        (CCON_NoExt + '  ' + CCON_NoInt) as NUMERO,
        CCON_CodigoPostal as COD_POS,
        (Select CIUC_Nombre from CiudadesColonias Where CIUC_ColoniaId = CCON_CIUC_ColoniaId) as COLONIA,
        (Select CIU_Nombre from Ciudades Where CIU_CiudadId = CCON_CIU_CiudadId) as CIUDAD,
        (Select EST_Nombre from Estados Where EST_EstadoId = CCON_EST_EstadoId) as ESTADO,
        (Select PAI_Nombre from Paises Where PAI_PaisId = CCON_PAI_PaisId) as PAIS
from ClientesContactos
Where CCON_Eliminado = 0
Order By CORPORATIVO, CLIENTE, COMPRADOR



--Select * from ClientesContactos where CCON_Eliminado = 0


-- CCON_CorporativoId = '65FB46DB-60C1-4A12-AFFE-9AC675751E05'




-- Select * from Clientes where CLI_RazonSocial like '%PRUE%'
-- Select * from ClientesContactos 

--select * from ClientesContactos where CCON_Nombre like '%CELE%'

--update ClientesContactos set CCON_Eliminado = 0 where CCON_ContactoId = '71442953-955F-4661-98E5-EE01A28867E6'
