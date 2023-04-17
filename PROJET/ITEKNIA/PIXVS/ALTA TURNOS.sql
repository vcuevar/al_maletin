
/* select * from Turnos
TUR_TurnoId	uniqueidentifier	Unchecked
TUR_Nombre	nvarchar(20)	Checked
TUR_HoraEntrada	datetime	Unchecked
TUR_HoraSalida	datetime	Unchecked
*/

INSERT INTO [dbo].[Turnos]
           ([TUR_TurnoId]
           ,[TUR_Nombre]
           ,[TUR_HoraEntrada]
           ,[TUR_HoraSalida])
     VALUES
			(NEWID(),'COMPLETO',GETDATE(),GETDATE()),
           (NEWID(),'MATUTINO',GETDATE(),GETDATE()),
           (NEWID(),'VESPERTINO',GETDATE(),GETDATE()),
           (NEWID(),'NOCTURNO',GETDATE(),GETDATE()),
           (NEWID(),'MIXTO',GETDATE(),GETDATE())
           
GO



