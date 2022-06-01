-- 012-D Lista de Materiales, completo.
-- Ing. Vicente Cueva R.
-- Actualizado: Viernes 11 de Enero del 2019; Sacar Materiales de Sub-Ensamble.
-- Actualizado: Martes 31 de Mayo del 2022; Adaptar a Muliix.

-- Declaraciones
DECLARE @OT_Code nvarchar(50)
DECLARE @IdedArt nvarchar(50)
DECLARE @CodPro nvarchar(50)

-- Asignar Valores a Variables
Set @OT_Code = 'OT02449'

--Set @IdedArt = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OTCode)

Select	ART_CodigoArticulo AS COD_MAT
		, ART_Nombre AS MATERIAL
		, EAR_CantidadEnsamble AS CANTIDAD
		, ISNULL((LPC_PrecioCompra / AFC_FactorConversion), 0) AS COSTO
		, EAR_CantidadEnsamble * ISNULL((LPC_PrecioCompra / AFC_FactorConversion), 0) AS IMPORTE
		, (Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = (Select ART_ATP_TipoId from Articulos
		Where ART_ArticuloId = EAR_ART_ComponenteId)) AS TIP_MAT
from EstructurasArticulos 
inner join Articulos on EAR_ART_ComponenteId = ART_ArticuloId 
inner join ArticulosFactoresConversion on ART_ArticuloId =AFC_ART_ArticuloId and ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
left join ListaPreciosCompra on ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
Where EAR_ART_ArticuloPadreId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)
Order by MATERIAL 

-- Importe total del la LDM
Select	@OT_Code AS OT
		,  Convert(Decimal(16,3), SUM(EAR_CantidadEnsamble * ISNULL((LPC_PrecioCompra / AFC_FactorConversion), 0))) AS IMPORTE
from EstructurasArticulos 
inner join Articulos on EAR_ART_ComponenteId = ART_ArticuloId 
inner join ArticulosFactoresConversion on ART_ArticuloId =AFC_ART_ArticuloId and ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
left join ListaPreciosCompra on ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
Where EAR_ART_ArticuloPadreId = (Select OTDA_ART_ArticuloId from OrdenesTrabajo Inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId Where OT_Codigo = @OT_Code)




