-- Consulta para resablecer los permisos de Usuarios

-- Relacion de Grupos de Permisos
Select PER_CodigoPermiso
        , PER_TipoPermiso
        , PER_Eliminado
        , Cast(PER_FechaCreacion as date) AS FECHCREACION
from Permisos
Where PER_Eliminado = 0

--
Select * from PermisosDetalle
PERD_PermisoDetalleId	PERD_PER_PermisoId	PERD_MPC_NodoId

Select * from Usuarios
USU_UsuarioId	USU_EMP_EmpleadoId	USU_Nombre	USU_Contrasenia	USU_Activo	USU_Timestamp	USU_PER_PermisoId

Select * from MenuPrincipalConfiguracion
MPC_NodoId	MPC_NombreClase	MPC_Nivel	MPC_Orden	MPC_NodoPadreId	MPC_Activo	MPC_NombreNodo	MPC_Ruta	MPC_Argumentos	MPC_TipoNodo	MPC_Movil




select * from RPT_Seguimiento_OT