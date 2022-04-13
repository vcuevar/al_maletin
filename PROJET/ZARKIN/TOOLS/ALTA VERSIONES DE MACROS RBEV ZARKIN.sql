-- Metodo para Asignar seguimiento de Version de Macros
-- Elaboro: Ing. Vicente Cueva Ram�rez
-- Actualizado: Viernes 26 de Marzo del 2021; Origen para Zarkin.

-- Consulta los Reportes ya Asignados.

Select * from SIZ_RBEV Order By NombRepo

-- Modificar un Reporte a su Nueva Version

Update SIZ_RBEV set NumeVers = 'VMA220218A' Where CodeRepo = 'SA-RBV-2103-110'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'SA-VMA-2203-126'
Set @Nomb = 'Requisicion Punto Reorden.'
Set @Vers = 'VMA220314A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


