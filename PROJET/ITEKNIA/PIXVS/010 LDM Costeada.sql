-- Consulta para Lista de Materiales costeadas.
-- Ing. Vicente Cueva R.
-- Viernes 27 de Abril del 2018

DECLARE @CODPT nvarchar(50)

--Parametros Fecha Inicial y Fecha Final
--Set @CODPT = 'PLA-LAC-NIT'
Set @CODPT = 'PLA-EMP-GRL'
--Set @CODPT = 'PLA-CAR-FRE'
--Set @CODPT = 'PLA-LAC-PUL'
--Set @CODPT = '5250.2-5'


 Select		A3.ART_CodigoArticulo AS COD_PADRE,
			A3.ART_Nombre  AS MUEBLE, 
			A3.ART_CostoMaterialEstandar AS PRECIO, 
			
			A1.ART_CodigoArticulo AS COD_COMPONE, 
			A1.ART_Nombre AS MATERIAL, 
			CMUM_Nombre AS PAD_UM, 
			EAR_CantidadEnsamble AS CANTIDAD, 
			A1.ART_CostoMaterialEstandar AS ESTANDAR,
			(EAR_CantidadEnsamble * A1.ART_CostoMaterialEstandar) AS IMPORTE,
			
			(Select ATP_Descripcion from ArticulosTipos
			Where ATP_TipoId = (Select ART_ATP_TipoId from Articulos
			Where ART_ArticuloId = EAR_ART_ComponenteId)) AS TIP_MAT
			
from EstructurasArticulos 
inner join Articulos A3 on EAR_ART_ArticuloPadreId = A3.ART_ArticuloId 
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId 
left join ControlesMaestrosUM on A1.ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
Where A3.ART_CodigoArticulo = @CODPT 
Order by MATERIAL 



