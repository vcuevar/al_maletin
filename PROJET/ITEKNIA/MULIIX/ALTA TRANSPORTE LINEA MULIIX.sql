-- Grabar en Tabla Transporte Unidades Linea
-- Base de Datos MULIIX

INSERT INTO [dbo].[TransportesUnidadesLineas]
           ([TUL_TransporteUnidadLineaId]
           ,[TUL_CMM_MarcaTransporteId]
           ,[TUL_Linea]
           ,[TUL_Version])
     VALUES
           (NEWID()
           ,'1E2381BE-4704-4CAE-8BEB-FC2C88D562D6' 
           ,'PRIUS'
           ,'4 PTS') 
GO