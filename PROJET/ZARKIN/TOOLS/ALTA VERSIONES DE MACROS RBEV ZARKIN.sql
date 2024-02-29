-- Metodo para Asignar seguimiento de Version de Macros
-- Elaboro: Ing. Vicente Cueva Ramírez
-- Actualizado: Viernes 26 de Marzo del 2021; Origen para Zarkin.

-- Consulta los Reportes ya Asignados.

Select * from SIZ_RBEV Where CodeRepo = 'GZ-VMA-2307-135' Order By NombRepo

-- Modificar un Reporte a su Nueva Version

Update SIZ_RBEV set NumeVers = 'VMA230727A' Where CodeRepo = 'GZ-VMA-2307-135'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'GZ-VMA-2402-138'
Set @Nomb = 'Seguimiento Consumo de Telas.'
Set @Vers = 'VMA240223A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


