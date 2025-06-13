-- Metodo para Asignar seguimiento de Version de Macros
-- Elaboro: Ing. Vicente Cueva Ramírez
-- Actualizado: Viernes 26 de Marzo del 2021; Origen para Zarkin.

-- Consulta los Reportes ya Asignados.

Select RIGHT(CodeRepo, 3) AS ID 
	, CodeRepo
	, NombRepo
	, NumeVers
from SIZ_RBEV 
Order By ID 

-- Modificar un Reporte a su Nueva Version

Update SIZ_RBEV set NumeVers = 'VMA250609A' Where CodeRepo = 'SA-RBV-2104-113'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'GZ-VMA-2506-016'
Set @Nomb = 'Inventario de Materiales en OP (WIP).'
Set @Vers = 'VMA250606A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


