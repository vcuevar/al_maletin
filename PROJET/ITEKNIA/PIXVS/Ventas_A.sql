
--Ejercicio para sacar consulta de VENTAS

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
Set @FechaIS = '2018-02-05'
Set @FechaFS = '2018-02-15' 

Select  Cast(OV.OV_FechaOV as date) as F_ORDEN, Case When OV.OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV.OV_FechaOV) END AS SEMANA, OV.OV_CodigoOV AS ORD_VEN, CL.CLI_CodigoCliente AS COD_CLI, CL.CLI_NombreComercial AS CLIENTE, PY.EV_Nombre AS PROYECTO, OV.OV_ReferenciaOC AS ORD_COM, IT.ART_GLN AS INSUMO, SUBSTRING(IT.ART_GLN,8,20) AS COD, IT.ART_CodigoArticulo AS CODIGO, OD.OVD_ART_Nombre AS PRODUCTO, IT.ART_Comentarios AS DESCRIPCION, OD.OVD_CMUM_Nombre AS UNIDAD, OVR.OVR_CantidadRequerida AS CANTIDAD, MN.MON_Nombre AS MONEDA, OVR.OVR_PrecioUnitario AS PRE_UNIT, OV.OV_MONP_Paridad AS TIP_CAMBIO, MM4.CMM_Valor AS TIP_CLIENTE, AF.AFAM_Nombre as FAMILIA, AC.ACAT_Nombre as CATEGORIA, OVR.OVR_FechaRequerida AS F_ENTREGA, OV.OV_Comentarios AS OBSERV 
from OrdenesVenta OV inner join Clientes CL on OV.OV_CLI_ClienteId = CL.CLI_ClienteId inner join OrdenesVentaDetalle OD on OV.OV_OrdenVentaId = OD.OVD_OrdenVentaId inner join OrdenesVentaReq OVR on OD.OVD_OVDetalleId = OVR.OVR_OVDetalleId inner join Articulos IT on OD.OVD_ART_ArticuloId = IT.ART_ArticuloId left join ClientesContactos CC on OV_CCON_ContactoId = CC.CCON_ContactoId left join Eventos PY on OV.OV_EV_EventoId = PY.EV_EventoId inner join Monedas MN on OV.OV_MON_MonedaId = MN.MON_MonedaId left join ControlesMaestrosMultiples MM1 on OV.OV_CMM_EstadoOVId = MM1.CMM_ControllId left join ControlesMaestrosMultiples MM2 on OV.OV_CMM_TipoOrdenVenta = MM2.CMM_ControllId left join ControlesMaestrosMultiples MM3 on OV.OV_CMM_EstatusSolicitud = MM3.CMM_ControllId 
left join ControlesMaestrosMultiples MM4 on CL.CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId left join ArticulosFamilias AF on IT.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId  left join ArticulosCategorias AC on IT.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId 
where Cast(OV.OV_FechaOV As Date) BETWEEN @FechaIS and @FechaFS
--where Cast(OV.OV_FechaOV as date) BETWEEN '2018-02-05' and '2018-02-15' 
Order By OV.OV_FechaOV, OV.OV_CodigoOV 

--where Cast(OV.OV_FechaOV As Date) BETWEEN Cast(@FechaIS as Date) and Cast(@FechaFS as date) 
--where OV.OV_FechaOV BETWEEN @FechaIS and @FechaFS 
