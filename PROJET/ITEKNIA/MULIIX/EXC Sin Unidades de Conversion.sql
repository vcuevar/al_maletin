-- Excepcion para Validar los articulos sin Unidades de Conversion.
-- Elaborado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 22 de Mayo del 2020; Origen.

Declare @Code VARCHAR(50)
Declare @IdCode uniqueidentifier 
Declare @IdUdM uniqueidentifier
Declare @User uniqueidentifier

Set @Code = '04673'

Set @IdUdM = '70723AED-7F6A-4D9F-BD31-A74584B19A6A' -- Unidad Piezas
Set @User =  'D117CCA7-7114-4B55-9EEB-9F8553BF6179' -- Empleado Vicente 777

Set @IdCode = (select ART_ArticuloId from Articulos where ART_CodigoArticulo = @Code)

select * from ArticulosFactoresConversion
where AFC_ART_ArticuloId =  @IdCode



-- Para Realizar el Ingreso de los registros.

Insert Into [dbo].[ArticulosFactoresConversion]
           ([AFC_FactorConversionId],
            [AFC_ART_ArticuloId],
            [AFC_CMUM_UnidadMedidaId],
            [AFC_FactorConversion],
            [AFC_FechaUltimaModificacion],
            [AFC_FactorDefault],
            [AFC_FechaCreacion],
            [AFC_EMP_ModificadoPorId])
     Values
            (NEWID(),
            @IdCode,
            @IdUdM,
            1,
            GetDate(),
            1,
            GetDate(),
            @User)
Go                 
