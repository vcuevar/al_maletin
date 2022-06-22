-- Consulta para Lista de Materiales costeadas.
-- Ing. Vicente Cueva R.
-- Viernes 27 de Abril del 2018
-- Actualizado: Martes 21 de Junio del 2022; Actualizar para Muliix.

--Parametros Codigo del Producto
DECLARE @CODPT nvarchar(50)

Set @CODPT = '1693.3-01'

 Select	A3.ART_CodigoArticulo AS COD_PADRE
	, A3.ART_Nombre  AS MUEBLE
	, A3.ART_Precio AS PRECIO
			
	, A1.ART_CodigoArticulo AS COD_COMPONE
	, A1.ART_Nombre AS MATERIAL
	, CMUM_Nombre AS PAD_UM 
	, Convert(Decimal(16,3), EAR_CantidadEnsamble ) AS CANTIDAD 
	, Convert(Decimal(16,3), ISNULL(LPC_PrecioCompra / AFC_FactorConversion, 0)) AS ESTANDAR
	, Convert(Decimal(16,3), ISNULL(EAR_CantidadEnsamble * (LPC_PrecioCompra / AFC_FactorConversion), 0)) AS IMPORTE
			
	, (Select ATP_Descripcion from ArticulosTipos Where ATP_TipoId = (Select ART_ATP_TipoId from Articulos Where ART_ArticuloId = EAR_ART_ComponenteId)) AS TIP_MAT
			
from EstructurasArticulos 
inner join Articulos A3 on EAR_ART_ArticuloPadreId = A3.ART_ArticuloId 
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId 
left join ControlesMaestrosUM on A1.ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
Inner Join ArticulosFactoresConversion on A1.ART_ArticuloId = AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
Left Join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1

Where A3.ART_CodigoArticulo = @CODPT 
Order by MATERIAL 

--Select * from Articulos Where ART_CodigoArticulo = '1693.3-01'

