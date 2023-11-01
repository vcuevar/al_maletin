-- Manejo de Menú en Muliix.
-- Desarrollo: Ing. Luis Alberto Jimenez Medina.
-- Actualizado: Miercoles 31 de mayo del 2023; Origen.

-- Parametros, definr Sub-Menu que se quiere ver

Declare @Nodo_Padre uniqueidentifier

-- Set @Nodo_Padre = '0A1BEDD1-0AF2-427D-9119-F9342D22CF31'   	-- 1	VENTAS
-- Set @Nodo_Padre = 'ED9E6A70-1756-4279-A1B4-8F881B5D2671'     -- 1    VENTAS / 3   ORDENES DE VENTA
-- Set @Nodo_Padre = '041870EB-9C9B-4EAF-8AF5-5B844288E184' 	-- 1    VENTAS / 7   REPORTES
-- Set @Nodo_Padre = '4D1B8753-3A4C-4D2D-A11D-57116CBFA44A'        -- 3    FINANZAS
-- Set @Nodo_Padre = '1AF47AEF-D1FB-438A-91AE-6E99DDF91371'        -- 3    FINANZAS / 11 REPORTES 
 Set @Nodo_Padre = 'BB5521C9-E44C-46B9-A8A6-951CCAF166B9'          --3 FINANZAS / TESORERIA

-- 1.- Conocer los nodos principales del Menú.
--  Si conocemos el Id (MPC_NodoId) podemos conocer los subnodos, para conocer los nodos principales
--  del Menu ejecutamos, Donde los nodos principales no tienen un nodo “padre”:
/*
select * 
from MenuPrincipalConfiguracion
WHERE MPC_NodoPadreId IS NULL
ORDER BY MPC_Orden
*/
-- 2.- Saber los sub-enlaces de un nodo 
--  A la consulta le pasamos el Id (MPC_NodoId) del enlace del que queremos conocer los sub-enlaces
--  Los registros pueden ser de 2 tipos ENACE o NODO (MPC_TipoNodo)
--  Si un registro es de TIPO “nodo” entonces puede contener sub-enlaces
--  En el siguiente ejemplo buscamos el 


select * 
from MenuPrincipalConfiguracion
WHERE MPC_NodoPadreId = @Nodo_Padre
ORDER BY MPC_Orden


/*
select * 
from MenuPrincipalConfiguracion
WHERE MPC_NodoPadreId = '041870EB-9C9B-4EAF-8AF5-5B844288E184' --REPORTE
ORDER BY MPC_Orden


-- 3.- Escogiendo el registro
--  Siguiendo pasos 1 y 2 podemos ubicar el nodo que queremos Editar 
--  Escoger un registro nos permite Editarlo o Eliminarlo usando su Id (MPC_NodoId) en el WHERE.
--  Editarlo
--  En este Ejemplo editamos el orden del elemento dentro del subMenu, pero podríamos editar 
--  otros otros campos como el nombre o la ruta del enlace.

-- Cambiar el orden de la posicion del menú.
UPDATE MenuPrincipalConfiguracion
SET MPC_Orden = 8
WHERE MPC_NodoId = '1A2BC928-D454-4B8E-9F69-8086953B41A7' --registro de DiarioBancos

-- Ocultar un Items del Menú.
UPDATE MenuPrincipalConfiguracion
SET MPC_Activo = 0
WHERE MPC_NodoId = '28B65EDB-AC4D-4761-B7D8-778A72194750'

-- Cambiar de descripcion al Items seleccionado.
UPDATE MenuPrincipalConfiguracion
SET MPC_NombreNodo = 'X Preembarques'
WHERE MPC_NodoId = 'FF7DABB5-ABF4-42BF-9CE2-1B1405AE4148'

-- Eliminarlo Para eliminar un registro deberíamos poner ACTIVO en cero

UPDATE MenuPrincipalConfiguracion
SET MPC_Orden = 8
WHERE MPC_Activo = 1  --registro de DiarioBancos

-- 4.- Crear un registro nuevo
--  Siguiendo pasos 1 y 2 podemos ubicar el “Nodo Padre” donde queremos insertar el nuevo Enlace.

INSERT [dbo].[MenuPrincipalConfiguracion] 
([MPC_NodoId], 
[MPC_NombreClase], 
[MPC_Nivel], 
[MPC_Orden], 
[MPC_NodoPadreId], 
[MPC_Activo], 
[MPC_NombreNodo], 
[MPC_Ruta], 
[MPC_Argumentos], 
[MPC_TipoNodo]) VALUES
(NEWID(), 
NULL, 
2, 
8, 
N'BB5521C9-E44C-46B9-A8A6-951CCAF166B9', 
1, 
'Diario de Bancos', 
'#tesoreria/movimientos-bancos', 
NULL, 
'Enlace')

--  El nivel Nos indica que profundidad tiene el nodo dentro del Menu.
--  El nodo Padre es importante porque determina donde ubicamos el nodo
--  El ultimo campo es el tipo, si es Enlace deberá llevar una ruta, pero si es nodo entonces nos indica que queremos incluir nodos por debajo.


-- Esta consulta las genere yo.
Select * from MenuPrincipalConfiguracion where MPC_NombreNodo like '%impri%'


Select * from MenuPrincipalConfiguracion where MPC_NodoId = '0E9550F7-8764-42CD-B52D-0F2A8334D304'

--Update MenuPrincipalConfiguracion set MPC_NombreNodo = 'NA Imprimir Traspasos' where MPC_NodoId = '0E9550F7-8764-42CD-B52D-0F2A8334D304'

-- Vacias  Select * from MenuPrincipalEtiquetas
-- Vacias  Select * from MenuPrincipalPermisos

-- Tabla con los Grupos de Permisos.
Select * from Permisos

-- No entendi
Select * from PermisosDetalle
PERD_PermisoDetalleId	PERD_PER_PermisoId	PERD_MPC_NodoId
Tiene 2,011

-- Vacias Select * from PermisosUsuario
-- Vacias Select * from PermisosRegistros
-- Vacias Select * from PermisosComponentes
-- Vacias Select * from PermisosAccesos

*/


-- Reporte de Pagos, Conciliación De Bancos, Reposicion Caja Chica se ocultan por no funcionar y quedan cubiertos con el reporte de
-- movimiento de bancos. Se checo con Sharon el 27 de Septiembre del 2023.

-- UPDATE MenuPrincipalConfiguracion SET MPC_Activo = 0 WHERE MPC_NodoId = '28B65EDB-AC4D-4761-B7D8-778A72194750'
-- UPDATE MenuPrincipalConfiguracion SET MPC_Activo = 0 WHERE MPC_NodoId = '10558871-8E1F-4754-8039-C4FF8DFFC7A9'
-- UPDATE MenuPrincipalConfiguracion SET MPC_Activo = 0 WHERE MPC_NodoId = '22DD0F42-726E-4169-B45F-58D204902BBB'

-- Reporte de Flujo de Efectivo de Muliix se cambia por el de Programa de Pagos de Beto.
UPDATE MenuPrincipalConfiguracion SET MPC_Activo = 0 WHERE MPC_NodoId = '9A41060A-A991-4E6E-AA0B-DBAFC310ADDA'

