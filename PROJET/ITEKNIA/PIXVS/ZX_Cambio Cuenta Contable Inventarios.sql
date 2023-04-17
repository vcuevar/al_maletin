-- Consulta para Cambiar de Cuenta contable de Tener Varias Cuentas solo cargar a una ya sea MP
-- o la de Producto Terminado.

-- Materias Primas Para Cambiar Cuenta Contable 110-800-103
Select	ART_CodigoArticulo as CODIGO,
		ART_Nombre as NOMBRE,
		AFAM_Nombre as FAMILIA,
		ART_CMM_CtaInventarioId AS C_INVENTARIO
from Articulos
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
where AFAM_Nombre NOT like 'PT%' and  ART_Activo  <> 0 
order by ART_Nombre

-- Cambiarian a ...
 Select * from CuentasContables
 where CC_CodigoCuenta = '110-800-103'

Select CMM_ControllId, * from ControlesMaestrosMultiples 
Where CMM_Valor = '849C1D88-4644-4842-9373-1E279948AF5C'

-- Cambiar Toda la Materia Prima a Esta Cuenta Contable que corresponde a la 
-- 110-800-103 del Catalogo de Cuentas.
-- Update Articulos set ART_CMM_CtaInventarioId = '8F6F9775-83C7-4F04-B38E-397F21DB34E1'
-- from Articulos
-- left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
-- where AFAM_Nombre NOT like 'PT%' and  ART_Activo  <> 0 


-- Producto Terminado Cambiar a Cuenta Contable de 110-800-003
Select	ART_CodigoArticulo as CODIGO,
		ART_Nombre as NOMBRE,
		AFAM_Nombre as FAMILIA,
		ART_CMM_CtaInventarioId AS C_INVENTARIO
from Articulos
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
where AFAM_Nombre like 'PT%' and  ART_Activo  <> 0 
order by ART_Nombre

-- Cambiarian a ...
 Select * from CuentasContables
 where CC_CodigoCuenta = '110-800-003'

Select CMM_ControllId, * from ControlesMaestrosMultiples 
Where CMM_Valor = 'BA253A99-6DE9-4F42-A163-22C1F0A283EA'

-- Cambiar Todo el Producto Terminado a Esta Cuenta Contable que corresponde a la 
-- 110-800-003 del Catalogo de Cuentas.
-- Update Articulos set ART_CMM_CtaInventarioId = '92A6F668-E67F-44AB-91A4-0714D4DF99F9'
-- from Articulos
-- left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
-- where AFAM_Nombre like 'PT%' and  ART_Activo  <> 0 


