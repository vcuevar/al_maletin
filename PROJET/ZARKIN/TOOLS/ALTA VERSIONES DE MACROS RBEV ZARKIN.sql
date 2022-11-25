-- Metodo para Asignar seguimiento de Version de Macros
-- Elaboro: Ing. Vicente Cueva Ramírez
-- Actualizado: Viernes 26 de Marzo del 2021; Origen para Zarkin.

-- Consulta los Reportes ya Asignados.

Select * from SIZ_RBEV Order By NombRepo

-- Modificar un Reporte a su Nueva Version

Update SIZ_RBEV set NumeVers = 'VMA221010A' Where CodeRepo = 'SA-RBV-2210-128'

-- Asignar un Nuevo Registro

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'SA-RBV-2210-129'
Set @Nomb = 'Compara STD y Compra de Articulo.'
Set @Vers = 'VMA221020A'

Insert Into [dbo].[SIZ_RBEV]
			( [CodeRepo], [NombRepo], [NumeVers])
		Values
			(@Code, @Nomb, @Vers)
Go


