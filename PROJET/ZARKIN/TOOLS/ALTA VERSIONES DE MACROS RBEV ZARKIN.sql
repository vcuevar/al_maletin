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

Update SIZ_RBEV set NumeVers = 'VMA250811A' Where CodeRepo = 'GZ-VMA-2508-144'
Update SIZ_RBEV set NombRepo = 'Confiabilidad de Proveedores (Incoming)' Where CodeRepo = 'GZ-VMA-2508-143'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'GZ-VMA-2508-144'
Set @Nomb = 'Incoming Calificacioón de Proveedores.'
Set @Vers = 'VMA250811A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


