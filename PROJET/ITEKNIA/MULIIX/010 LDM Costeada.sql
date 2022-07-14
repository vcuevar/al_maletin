-- Consulta para Lista de Materiales costeadas.
-- Ing. Vicente Cueva R.
-- Viernes 27 de Abril del 2018
-- Actualizado: Martes 21 de Junio del 2022; Actualizar para Muliix.

--Parametros Codigo del Producto
DECLARE @CODPT nvarchar(50)

--Set @CODPT = '1693.3-01'
Set @CODPT = 'PLA-EMP-GRL'

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
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId and A1.ART_Activo = 1
left join ControlesMaestrosUM on A1.ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
Inner Join ArticulosFactoresConversion on A1.ART_ArticuloId = AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
Left Join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1

Where A3.ART_CodigoArticulo = @CODPT 
Order by MATERIAL 

-- Consulta EXC para ver los articulos que tienen SubEnsambles y esta Activos.

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
inner join Articulos A3 on EAR_ART_ArticuloPadreId = A3.ART_ArticuloId and A3.ART_Activo = 1 
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId and A1.ART_Activo = 1 
left join ControlesMaestrosUM on A1.ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
Inner Join ArticulosFactoresConversion on A1.ART_ArticuloId = AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
Left Join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
-- SubEnsambles y PT Fabricados
Where A1.ART_ATP_TipoId = '56B66D49-FE82-4414-A7E8-43F3916572D3' or A1.ART_ATP_TipoId = '0D0B9D8A-C779-4D11-8CF6-C1DA16E4334C'
Order by COD_PADRE, MATERIAL 


--ART_Activo
--false



--Select * from Articulos where ART_Eliminado = 1 and ART_Activo = 1

--Select * from Articulos where ART_Eliminado = 1 and ART_Activo = 0




--update Articulos Set ART_Activo = 0 where ART_Eliminado = 1 and ART_Activo = 1
