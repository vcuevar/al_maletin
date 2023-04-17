-- 012 Costo de Produccion por O.T.
-- Ing. Vicente Cueva R.
-- Sabado 12 de Mayo del 2018

DECLARE @OT_Code nvarchar(50)
DECLARE @COD_ART nvarchar(50)
DECLARE @OT_CANT INT
DECLARE @FechaIS date
DECLARE @FechaFS date

--Parametros Fecha Inicial, Fecha Final y Orden 
Set @OT_Code = 'OT1683'
Set @FechaIS = CONVERT (DATE, '2018-04-16', 102)
Set @FechaFS = CONVERT (DATE, '2018-04-16', 102) 

-- Relacion de Ordenes Abiertas

--Relacionar mediante el Evento las OT + el Articulo
/*
select EV_EventoId, EV_CodigoEvento, EV_Descripcion, OT_Codigo, OV_CodigoOV
from Eventos
left join OrdenesTrabajo on EV_EventoId = OT_EV_EventoId
left join OrdenesVenta on EV_EventoId = OV_EV_EventoId


SELECT 
	STATUS_OV,
	OV_CodigoOV AS ORD_VEN,
	EV_CodigoEvento AS COD_PROY, 
	EV_Descripcion AS PROYECTO,
	ART_CodigoArticulo AS CODIGO,
	ART_Nombre AS NOM_ART, 
	OVR_CantidadRequerida AS CANTIDAD,
	ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_EMBARCADA , 
	OVR_CantidadRequerida - ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_POR_EMBARCAR
FROM (
 		SELECT 	OV_CodigoOV , 
				ESTADO_OV.CMM_Valor AS STATUS_OV ,
				OV_CMM_EstadoOVId ,
				EV_CodigoEvento , 
				EV_Descripcion , 
				ART_CodigoArticulo , 				
				ART_Nombre , 
				OVR_CantidadRequerida , 
				ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_EMBARCADA , 
				OVR_CantidadRequerida - ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_POR_EMBARCAR
		FROM OrdenesVenta 
		INNER JOIN OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OrdenVentaId 
		INNER JOIN OrdenesVentaReq ON OVR_OVDetalleId = OVD_OVDetalleId AND OV_OrdenVentaId = OVD_OrdenVentaId 
		LEFT JOIN Articulos ON OVD_ART_ArticuloId = ART_ArticuloId 
		INNER JOIN ControlesMaestrosMultiples ESTADO_OV ON OV_CMM_EstadoOVId = ESTADO_OV.CMM_ControllId 
		LEFT JOIN Eventos ON EV_EventoId = OV_EV_EventoId 
		--INNER JOIN Empleados ON EMP_EmpleadoId = OV_EMP_ModificadoPor 
		--LEFT JOIN ControlesMaestrosMultiples EMBARQUEOV ON OV_CMM_MetodoEmbarque = EMBARQUEOV.CMM_ControllId 
		--LEFT JOIN ControlesMaestrosMultiples LIBREABORDO ON OV_CMM_LibreABordo = LIBREABORDO.CMM_ControllId 
		--LEFT JOIN ControlesMaestrosDSC ON CMDSC_CodigoId = OV_CMDSC_CodigoId 
		--LEFT JOIN Cotizaciones ON COT_CotizacionId = OV_COT_CotizacionId 
		--left join ControlesMaestrosMultiples MM4 on CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId
		--left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
		LEFT JOIN ( SELECT EMBD_OVR_OVREQUERIDAID, SUM( EMBD_CantidadEmbarcada ) AS CANTIDAD_EMBARCADA 
					FROM EmbarquesDetalle 
					INNER JOIN Embarques ON EMBD_EMBARQUEID = EMB_EMBARQUEID 
					GROUP BY EMBD_OVR_OVREQUERIDAID ) AS Embarques ON OVR_OVRequeridaId = EMBD_OVR_OVREQUERIDAID 
		
		--LEFT JOIN (	SELECT FTRR_ReferenciaId, SUM(FTRR_CantidadRequerida) AS CANTIDAD_FACTURADA 
			--		FROM Facturas 
				--	INNER JOIN FacturasReq ON FTR_FacturaId = FTRR_FTR_FacturaId 
					--WHERE FTR_Eliminado = 0 
					--GROUP BY FTRR_ReferenciaId) AS Facturas ON OVR_OVRequeridaId = FTRR_ReferenciaId  
					--WHERE OV_Borrado = 0
		) AS TEMP					 
WHERE CANTIDAD_POR_EMBARCAR != 0  AND OV_CMM_EstadoOVId <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA' 
ORDER BY OV_CodigoOV, ART_CodigoArticulo




--REALIZAR eJERCICIO SI POR ORDENES DE PRODUCCION PUEDO SACAR LO DEL BACK ORDER
Select	OT_Codigo,
		OT_OrdenTrabajoId,
		Cast(OT_FechaRegistro AS date) AS F_REG, 
		Cast(OT_FechaRequeridaOV AS date) AS F_REQ,
		CMM_Valor,

(Select SUM(OTRD_CantidadRecibo) from OrdenesTrabajoRecibo left join OrdenesTrabajoReciboDetalle on OTR_OrdenTrabajoReciboId = OTRD_OTR_OrdenTrabajoReciboId Where OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId) AS TERMINADOS

 from OrdenesTrabajo
inner join ControlesMaestrosMultiples on OT_CMM_Status = CMM_ControllId
inner join OrdenesTrabajoRecibo on OT_OrdenTrabajoId = OTR_OT_OrdenTrabajoId

order by F_REG



*/







-- Detalle de Seguimiento.
SELECT 'RENGLON 28' AS REG,
 EV_CodigoEvento AS COD_PROY,
		EV_Descripcion AS PROYECTO,
		OT_Codigo AS NO_OT,
		ART_CodigoArticulo AS CODE_ART,
		ART_Nombre AS ARTICULO,
		OTDA_Cantidad AS CANT_ART,
		Empleados.EMP_CodigoEmpleado AS CODE_OP,
		(EMPLEADOS.EMP_Nombre + ' ' + Empleados.EMP_PrimerApellido + ' ' + Empleados.EMP_SegundoApellido) AS NAME_OP,
		Cast(OTSD_FechaDetalleOperacion AS DATE) AS F_CAPTURA,
		CET_Codigo AS CODE_CET,
		CET_Nombre AS NAME_CET, 
		(CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/60  AS TIME_REAL
FROM OrdenesTrabajoSeguimiento
inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajoSeguimientoDetalle on OTSD_OTSO_OrdenTrabajoSeguimientoOperacionId = OTSO_OrdenTrabajoSeguimientoOperacionId
inner join CentrosTrabajo on OTSD_CET_CentroTrabajoId = CET_CentroTrabajoId
inner join OrdenesTrabajo on  OTS_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTS_ART_ArticuloId
left join Eventos on OT_EV_EventoId = EV_EventoId
inner join Empleados on OTSD_EMP_Operador = EMP_EmpleadoId
where OT_Codigo = @OT_Code

--Detalle de Lista de Materiales.
Set @COD_ART = (select ART_CodigoArticulo from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
where OT_Codigo = @OT_Code)

Set @OT_CANT = (Select OTDA_Cantidad from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
where OT_Codigo = @OT_Code)

Select		PAD.ART_CodigoArticulo AS COD_PADRE,
			PAD.ART_Nombre  AS MUEBLE, 
			--PAD.ART_CostoMaterialEstandar AS PRECIO, 
			COM.ART_CodigoArticulo AS COD_COMPONE, 
			COM.ART_Nombre AS MATERIAL, 
			CMUM_Nombre AS PAD_UM, 
			EAR_CantidadEnsamble * @OT_CANT AS CANTIDAD, 
			COM.ART_CostoMaterialEstandar AS ESTANDAR,
			(EAR_CantidadEnsamble * COM.ART_CostoMaterialEstandar) * @OT_CANT  AS IMPORTE
from EstructurasArticulos 
inner join Articulos PAD on EAR_ART_ArticuloPadreId = PAD.ART_ArticuloId 
inner join Articulos COM on EAR_ART_ComponenteId = COM.ART_ArticuloId 
left join ControlesMaestrosUM on COM.ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId 
Where PAD.ART_CodigoArticulo = @COD_ART 
Order by MATERIAL 

-- Detalle de Surtimiento
Select	OT_Codigo AS N_OT, 
		ST.CMM_Valor AS ESTATUS, 
		A3.ART_CodigoArticulo AS C_PT, 
		A3.ART_Nombre AS P_TERMINADO,
		OTDA_Cantidad AS PEDIDOS, 
		ART1.ART_CodigoArticulo AS C_MP, 
		ART1.ART_Nombre AS MATERIAL, 
		UM.CMUM_Nombre AS UM,
		AFAM.AFAM_Nombre AS FAMILIA, 
		OTSE_Cantidad AS CANTIDAD, 
		ART1.ART_CostoMaterialEstandar AS C_ESTANDAR
from OrdenesTrabajoSurtimiento 
inner join OrdenesTrabajoSurtimientoDetalle on OTSU_OrdenTrabajoSurtimientoId  = OTSE_OTSU_OrdenTrabajoSurtimientoId
inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTSU_OT_OrdenTrabajoId 
inner join OrdenesTrabajoDetalleArticulos on  OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId 
inner join Articulos A3 on OTDA_ART_ArticuloId = A3.ART_ArticuloId 
inner join Articulos ART1 on OTSE_ART_ArticuloId = ART1.ART_ArticuloId
left join ControlesMaestrosUM UM on ART1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
Inner Join ArticulosFamilias AFAM on ART1.ART_AFAM_FamiliaId = AFAM.AFAM_FamiliaId 
Inner Join ControlesMaestrosMultiples ST on OT_CMM_Status = ST.CMM_ControllId 
Where  OT_Codigo = @OT_Code

-- Resumen de Seguimiento y Surtimiento 
SELECT  EV_CodigoEvento AS COD_PROY,
		EV_Descripcion AS PROYECTO,
		A3.ART_CodigoArticulo AS CODE_ART,
		A3.ART_Nombre AS ARTICULO,
		OT_Codigo AS NO_OT,
		OTDA_Cantidad AS CANT_ART,
		(Select	SUM(EAR_CantidadEnsamble * COM.ART_CostoMaterialEstandar) from EstructurasArticulos inner join Articulos PAD on EAR_ART_ArticuloPadreId = PAD.ART_ArticuloId inner join Articulos COM on EAR_ART_ComponenteId = COM.ART_ArticuloId Where PAD.ART_CodigoArticulo = A3.ART_CodigoArticulo) * OTDA_Cantidad AS COSTO_LDM,
		CMM_Valor AS ESTATUS,
		0 AS TIME_EST,
		(Select SUM(OTSE_Cantidad * ART1.ART_CostoMaterialEstandar)*-1 from OrdenesTrabajoSurtimiento inner join OrdenesTrabajoSurtimientoDetalle on OTSU_OrdenTrabajoSurtimientoId  = OTSE_OTSU_OrdenTrabajoSurtimientoId inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTSU_OT_OrdenTrabajoId  inner join OrdenesTrabajoDetalleArticulos on  OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId inner join Articulos ART1 on OTSE_ART_ArticuloId = ART1.ART_ArticuloId Where  OT_Codigo = @OT_Code ) AS COST_REAL,
		SUM((CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/60)  AS TIME_REAL,
		A3.ART_CostoMaterialEstandar * OTDA_Cantidad AS PREC_VENTA
FROM OrdenesTrabajoSeguimiento
inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajoSeguimientoDetalle on OTSD_OTSO_OrdenTrabajoSeguimientoOperacionId = OTSO_OrdenTrabajoSeguimientoOperacionId
inner join CentrosTrabajo on OTSD_CET_CentroTrabajoId = CET_CentroTrabajoId
inner join OrdenesTrabajo on  OTS_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join Articulos A3 on A3.ART_ArticuloId = OTS_ART_ArticuloId
left join Eventos on OT_EV_EventoId = EV_EventoId
inner join ControlesMaestrosMultiples on A3.ART_AgrupadorId = CMM_ControllId
where OT_Codigo = @OT_Code
group by EV_CodigoEvento, EV_Descripcion, ART_CodigoArticulo, ART_Nombre, OT_Codigo, OTDA_Cantidad, A3.ART_CostoMaterialEstandar, CMM_Valor

