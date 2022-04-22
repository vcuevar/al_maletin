-- Metodo para Asignar seguimiento de Versiones de Macros
-- Elaboro: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 15 de Enero del 2021; Origen.

-- Consulta los Reporte ya asignados.

Select * from RBEV Order By NombRepo

-- Modificar un Reporte a su nueva Version.

Update RBEV set NumeVers = 'VMA211222A' Where CodeRepo = 'IT-VMA-2111-040'

-- Asignar un nuevo registro.

Declare @Code as nvarchar(15)
Declare @Nomb as nvarchar(50)
Declare @Vers as nvarchar(10)

Set @Code = 'IT-VMA-2204-042'
Set @Nomb = '042 FACTURA DE ANTICIPOS.'
Set @Vers = 'VMA220420A'

INSERT INTO [dbo].[RBEV]
           ([CodeRepo], [NombRepo], [NumeVers])
     VALUES
           (@Code, @Nomb, @Vers)
GO
