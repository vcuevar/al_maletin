-- Reporte: 014-C Completa información para el ajuste en sistema.
-- Objetivo: Completar informacion para el ajuste, de la toma fisica de inventario.
-- Desarrollo: Ing. Vicente Cueva R.
-- Actualizado: Miercoles 20 de Febrero del 2019; Origen.

--Declaraciónes:
Declare @CodeMate as VarChar(30)

Set @CodeMate = '10544'

Select	ART_CodigoArticulo as CODIGO,
		ART_Nombre as NOMBRE,
		CMUM_Nombre as UM_Inv,
		CMM_Valor as TIPO_COS,
		Convert(Decimal(28,10), ART_CostoMaterialEstandar) as COS_EST
From Articulos
inner join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
left join ControlesMaestrosMultiples on ART_CMM_TipoCostoId = CMM_ControllId and CMM_Control = 'CMM_CDA_TiposCosto'
Where  ART_CodigoArticulo = @CodeMate

