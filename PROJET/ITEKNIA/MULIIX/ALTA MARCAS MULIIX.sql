Select * from ArticulosMarcas
--UPDATE ArticulosMarcas SET ARTM_Nombre = 'ITEKNIA' WHERE ARTM_MarcaId = 'C019779F-54B1-4F8E-A837-EA05AAE3E48B'
--UPDATE ArticulosMarcas SET ARTM_EMP_ModificadoPorId = '6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1' WHERE ARTM_MarcaId = 'C019779F-54B1-4F8E-A837-EA05AAE3E48B'

INSERT INTO [dbo].[ArticulosMarcas]
           ([ARTM_MarcaId]
           ,[ARTM_Codigo]
           ,[ARTM_Nombre]
           ,[ARTM_FechaUltimaModificacion]
		   ,[ARTM_EMP_ModificadoPorId])
  VALUES
           (NEWID() , '2', 'GENÉRICO' , GETDATE(), '6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1'),
		   (NEWID() , '3', 'BRUNO COEL' , GETDATE(), '6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1'),
		   (NEWID() , '4', 'AZARET' , GETDATE(), '6F98CBE4-AFDE-46B2-9D2E-0C51AF5B11B1')
GO
  