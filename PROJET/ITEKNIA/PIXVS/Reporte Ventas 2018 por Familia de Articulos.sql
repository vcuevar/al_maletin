-- PIXVS Consulta Reporte de Articulos Vendidos por Familia.
-- Desarrolo: Ing. Vicente Cueva R.
-- Solicitado: Lic. Claudia Castañeda.
-- Actualizado: Sabado 29 de Junio del 2019; Inicio.

--Parametros Fecha Inicial y Fecha Final
Declare @FechaIS as nvarchar(30) 
Declare @FechaFS as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2019-01-01', 102)
Set @FechaFS = CONVERT (DATE, '2019-12-31', 102) 

-- Desarrollo del Reporte

Select	Cast(OV_FechaOV AS DATE) AS FECHA,
		OVD_CodigoOV as OV,
		ART_CodigoArticulo as CODIGO,
		ART_Nombre as NOMBRE,
		AFAM_Nombre as FAMILIA,
		OVR_CantidadRequerida as CANT,
		Convert(Decimal(28,10), ART_CostoMaterialEstandar) as ESTANDAR,
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = OV_EV_EventoId ) AS PROYECTO
from OrdenesVenta 
inner join OrdenesVentaDetalle on OVD_OrdenVentaId = OV_OrdenVentaId 
inner join OrdenesVentaReq on OVD_OVDetalleId =  OVR_OVDetalleId 
inner Join Clientes on CLI_ClienteId = OV_CLI_ClienteId 
Inner Join Articulos on ART_ArticuloId = OVD_ART_ArticuloId 
left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId
Where Cast(OV_FechaOV AS DATE) BETWEEN @FechaIS and @FechaFS 
