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

Update SIZ_RBEV set NumeVers = 'VMA251124A' Where CodeRepo = 'GZ-VMA-2510-147'

Update SIZ_RBEV set NombRepo = 'Devolucion de Piel y Tela' Where CodeRepo = 'GZ-VMA-2508-144'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'GZ-VMA-2510-147'
Set @Nomb = 'Inspeccion de Calidad.'
Set @Vers = 'VMA251031A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


