-- Reporte de Materiales Capturados en OT
-- Ing. Vicente Cueva Ramírez
-- Actualizado: Viernes 16 de Octubre del 2020; Inicio.
-- Actualizado: Viernes 05 de Febrero del 2021; Agregar Estatus de la OT.


--Parametros Fecha Inicial y Fecha Final (aaaa-mm-dd)

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)

Set @FechaIS = '2021-02-01'
Set @FechaFS = '2021-02-05' 

-- Consulta de Marteriales Cargados a la OT

Select  OT_Codigo as OT, 
        A3.ART_CodigoArticulo as CODE,
        A3.ART_Nombre as DESCRIPCION,       
        OTDA_Cantidad as CANT,
        ACAT_Nombre as CATEGORIA,
        A1.ART_CodigoArticulo as CODIGO,
        A1.ART_Nombre as MATERIAL,       
        CMUM_Nombre as UDM,
        OTARA_Cantidad as CONSUMO,
        ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0) as COSTO_P,
        (OTARA_Cantidad * (LPC_PrecioCompra / AFC_FactorConversion)) as IMPORTE,
        ISNULL((Select (EMP_CodigoEmpleado + '  ' + EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido) from Empleados Where EMP_EmpleadoId = OTARA_EMP_AsignadoPorId), 'S/E') as ELABORO,
        OTARA_FechaAsignacion as FE_ASIG, 
        (select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) as ESTATUS
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoAsignacionRecursosArticulos on OT_OrdenTrabajoId = OTARA_OT_OrdenTrabajoId
inner join Articulos A1 on A1.ART_ArticuloId = OTARA_ART_ArticuloId
inner join ControlesMaestrosUM on CMUM_UnidadMedidaId = A1.ART_CMUM_UMInventarioId
inner join ArticulosCategorias on ACAT_CategoriaId = A1.ART_ACAT_CategoriaId
left join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion on A1.ART_ArticuloId =AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
Where  Cast(OTARA_FechaAsignacion As Date) BETWEEN @FechaIS and @FechaFS 
Order By Cast(OTARA_FechaAsignacion As Date), ACAT_Nombre, OT_Codigo

