-- Consulta para comparativo de Cotizaciones
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 24 de Mayo del 2022; Origen

-- Parametros
Declare @OT_Code as nvarchar(30)
Declare @OT_Inic as nvarchar(30)
Declare @OT_Tope as nvarchar(30)

Set @OT_Code = 'OT02449'
Set @OT_Inic = 'OT02482'
Set @OT_Tope = 'OT02491'


/* -- Consulta de OT
Select OT_Codigo
		, ART_CodigoArticulo
		, ART_Nombre
		, OTDA_Cantidad AS CANT
		, ISNULL(OT_COT_MAT, 0) AS MAT
		, ISNULL(OT_COT_MOB, 0) AS MOB
		, ISNULL(OT_COT_IND, 0) AS IND
		, ISNULL(OT_COT_VEN, 0) AS VEN
		, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) AS ESTATUS
 from OrdenesTrabajo
 Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
 Inner Join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
 Where OT_Codigo BETWEEN @OT_Inic AND @OT_Tope 
 --Where ART_CodigoArticulo = '1693.3-02'
 Order By OT_Codigo

 -- Subir Informacion a Muliix
 --Update OrdenesTrabajo Set OT_COT_MAT = 300, OT_COT_MOB = 25000, OT_COT_IND = 400, OT_COT_VEN = 55000 Where OT_Codigo = 'OT02449'

*/


-- Consulta de Marteriales Cargados a la OT (REAL)

Select  OT_Codigo as OT
        , Convert(Decimal(16,3), SUM((OTARA_Cantidad * (LPC_PrecioCompra / AFC_FactorConversion)))) AS IMPORTE 
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join OrdenesTrabajoAsignacionRecursosArticulos on OT_OrdenTrabajoId = OTARA_OT_OrdenTrabajoId
inner join Articulos A1 on A1.ART_ArticuloId = OTARA_ART_ArticuloId
left join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion on A1.ART_ArticuloId =AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
Where  OT_Codigo = @OT_Code
Group By OT_Codigo

-- Consulta de Tiempos por Rango de Fecha

Select  OT_Codigo as OT 
        --ART_CodigoArticulo as CODE,
        --ART_Nombre as DESCRIPCION,       
        --OTDA_Cantidad as CANT,
        --CET_Codigo + '  ' + CET_Nombre + '  ' + MAQ_Nombre as AREA,
        --(Select (EMP_Nombre+'  '+EMP_PrimerApellido+'  '+EMP_SegundoApellido) from Empleados Where  EMP_EmpleadoId = OTSOD_EMP_OperadorId) as PERSONAL,
        --OTSOD_FechaRegistroInicio as FEC_INC, 
        --OTSOD_FechaRegistroFin as FEC_FIN,
        --, SUM(Convert(Decimal(16,3), OTSOD_TiempoTotal)) as HORAS
        --, DATEPART(SECOND, [OTSOD_TiempoTotal])  AS SEGUNDOS
        --, (60 * DATEPART(MINUTE, [OTSOD_TiempoTotal])) AS MIN_A_SEG
        --, (3600 * DATEPART(HOUR, [OTSOD_TiempoTotal])) AS HR_A_SEG 
        
        , SUM((DATEPART(SECOND, [OTSOD_TiempoTotal])) + 
                                 (60 * DATEPART(MINUTE, [OTSOD_TiempoTotal])) +
                                 (3600 * DATEPART(HOUR, [OTSOD_TiempoTotal]))) AS TOTAL_SEC 
      
        --, Convert(Decimal(16,3), (DATEPART(SECOND, [OTSOD_TiempoTotal])) + (60 * DATEPART(MINUTE, [OTSOD_TiempoTotal])) + (3600 * DATEPART(HOUR, [OTSOD_TiempoTotal])) / 3600) AS TOTAL_HR 
        
        --OTSOD_FechaCreacion as FEC_ELA,
        --(EMP_Nombre+'  '+EMP_PrimerApellido+'  '+EMP_SegundoApellido) as MODIFICADO
        --, (select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) as ESTATUS
        --, OrdenesTrabajoSeguimientoOperacionDetalle.*
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoSeguimiento on OT_OrdenTrabajoId = OTS_OT_OrdenTrabajoId
inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajoSeguimientoOperacionDetalle on OTSO_OrdenTrabajoSeguimientoOperacionId = OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId
inner join Maquinas on MAQ_MaquinaId = OTSOD_MAQ_MaquinaId
inner join CentrosTrabajo on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
inner join Empleados on EMP_EmpleadoId = OTSOD_EMP_ModificadoPorId
Where  OT_Codigo = @OT_Code
Group By OT_Codigo
