-- Metodo para Asignar seguimiento de Version de Macros
-- Elaboro: Ing. Vicente Cueva Ram�rez
-- Actualizado: Viernes 26 de Marzo del 2021; Origen para Zarkin.

-- Consulta los Reportes ya Asignados.

Select * from SIZ_RBEV 
--Where CodeRepo = 'GZ-VMA-2307-135' 
Order By NombRepo

-- Modificar un Reporte a su Nueva Version

Update SIZ_RBEV set NumeVers = 'VMA240508A' Where CodeRepo = 'GZ-VMA-2302-134'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'GZ-VMA-2408-010'
Set @Nomb = 'Back Order Costeado.'
Set @Vers = 'VMA240816A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


