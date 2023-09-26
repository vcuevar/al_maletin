-- 018 Catalogo de Proveedores MULIIX.
-- Solicito: Para ayudar hacer comparativo de Capturas. 19 de Julio del 2018.
-- Ing. Vicente Cueva R.
-- Inicio: Sabado 21 de Julio del 2018
-- Actualizado Sabado 21 de Julio del 2018


Select	
		PRO_CodigoProveedor AS CODIGO, 
		PRO_Proveedorid as ID,
		PRO_Nombre AS NOMBRE,
		PRO_NombreComercial AS COMERCIAL,
		PRO_RFC AS REG_FC,
		PRO_Activo AS ACTIVO,
		PRO_Eliminado  AS ELIMINADO
from Proveedores
Where PRO_Activo = 0 and PRO_Eliminado = 0
AND PRO_CodigoProveedor = 'P0523'
Order by CODIGO

UPDATE Proveedores set PRO_Activo = 0 where PRO_CodigoProveedor = 'PRO01972'

UPDATE Proveedores set PRO_Eliminado = 0 WHERE PRO_Proveedorid = 'CF7A7F07-6DB3-4EA6-AC18-1B55FC7A3AA2'

Select	PRO_ProveedorId  AS ID
		, PRO_CodigoProveedor AS CODIGO 
		, PRO_Nombre AS NOMBRE
		, PRO_NombreComercial AS COMERCIAL
		, PCON_Nombre AS CONTACTO
		, PCON_ContactoDefault AS OMISION
from Proveedores
left join ProveedoresContactos on PCON_PRO_ProveedorId = PRO_ProveedorId and PCON_Eliminado = 0
Where PRO_Activo = 1 and PRO_Eliminado = 0
--and PRO_CodigoProveedor = 'P0021'
Order by PRO_Nombre 


Select * from Proveedores where PRO_CodigoProveedor = 'P0023'

UPDATE Proveedores set PRO_Activo = 0 where PRO_CodigoProveedor = 'P0023'


/*
Select PRO_CodigoProveedor from Proveedores where PRO_ProveedorId = '2EF1BE8C-D63B-4319-AA29-2D05A474368A'

update Proveedores set PRO_CodigoProveedor = 'P0018' where PRO_ProveedorId = '2F27E87B-BE6D-4FE6-AC11-3EAA117C2219'

*/

