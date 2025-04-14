-- Proyecto 221207-4 Autorizacion de OC en Muliix.
-- Desarrollo: Ing. Vicente Cueva R.
-- Actualizado: Lunes 01 de Abril del 2024; Origen.

--Parametros Ninguno

-- Estatus de las OC.

Select * from ControlesMaestrosMultiples 
Where CMM_ControlId = '4C9DCE78-3461-4499-A579-8DDD5179B941'
Where CMM_Control = 'CMM_EstadoOC'

"CMM_ControlId",						"CMM_Control",	"CMM_Valor"
59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C,	CMM_EstadoOC,	Abierta
CFD16CB6-91DD-423F-AF53-5CAA86701D7F,	CMM_EstadoOC,	Completa
545CF84B-BBBA-46FE-ADEC-586AEEF4ED78,	CMM_EstadoOC,	Correspondida Completa
1C086C08-E99B-4166-895C-FFDEE5D8437D,	CMM_EstadoOC,	Correspondida Parcial
F005FA77-8026-472F-A288-8680DFD711C0,	CMM_EstadoOC,	Parcial
C801F991-979A-4C36-BC5C-F0BA88D05826,	CMM_EstadoOC,	CANCELADA
C845EF49-4729-416C-9E7B-288B11BCDF47,	CMM_EstadoOC,	Por Aprobar

-- Relacion de Empleados por Monto autorizado de compras.

Select EMP_CodigoEmpleado AS CODIGO 
	, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE
	, EMP_PresupuestoAutorizado AS NIVEL_AUT 
from Empleados 
Where EMP_Activo = 1 and EMP_PresupuestoAutorizado > 0
Order By EMP_PresupuestoAutorizado 


Select top(10) * from OrdenesCompra 


Select OC_CodigoOC, OC_CMM_EstadoOC 
From OrdenesCompra 
Where OC_CodigoOC = 'OC11545'
-- Marcar como completada la orden de compra.
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11545'


-- Cambio efectuado el 15 de enero para ajustar la OC que no se estaba actualizando correctamente. 
-- Al momento de Autorizar ponia un estatus equivocado.

Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11312'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11319'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11320'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11321'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11322'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11323'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11325'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11326'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11333'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11337'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11338'
