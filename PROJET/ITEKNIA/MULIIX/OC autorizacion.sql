-- Proyecto 221207-4 Autorizacion de OC en Muliix.
-- Desarrollo: Ing. Vicente Cueva R.
-- Actualizado: Lunes 01 de Abril del 2024; Origen.

--Parametros Ninguno

-- Estatus de las OC.

Select * from ControlesMaestrosMultiples 
Where CMM_Control = 'CMM_EstadoOC'


-- Relacion de Empleados por Monto autorizado de compras.

Select EMP_CodigoEmpleado AS CODIGO 
	, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE
	, EMP_PresupuestoAutorizado AS NIVEL_AUT 
from Empleados 
Where EMP_Activo = 1 and EMP_PresupuestoAutorizado > 0
Order By EMP_PresupuestoAutorizado 


Select top(10) * from OrdenesCompra 




