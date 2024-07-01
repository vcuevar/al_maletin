



Select  Top(1) EMP_CodigoEmpleado AS CODIGO 
	, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE
	, EMP_PresupuestoAutorizado AS NIVEL_AUT 
from Empleados 
Where EMP_Activo = 1 and EMP_PresupuestoAutorizado > 10600 
Order By EMP_PresupuestoAutorizado 