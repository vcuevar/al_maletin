-- 029-A Comparativo de Costos VS Cotización.
-- Ing. Vicente Cueva R.
-- Actualizado: Miercoles 02 de Enero del 2019; Orige.
-- Actualizado: Miercoles 09 de Enero del 2019; Culmen de Consulta.

-- Declaraciones
DECLARE @OTCode nvarchar(50)
DECLARE @CodProy nvarchar(50)
DECLARE @CodArti nvarchar(50)

--Asignar Valor
Set @OTCode = 'OT1620'

-- Validar que se cargo en RBV_OT
Select * from RBV_OT Where RBV_OT.OT_CD= @OTCode

-- Carga los valores de la Cotización
--Set @CodProy = (Select PR_ID from RBV_OT Where RBV_OT.OT_CD= @OTCode)
--Set @CodArti = (Select AR_ID from RBV_OT Where RBV_OT.OT_CD= @OTCode)

Select	OT_CD AS ORDEN,
		(ART_CodigoArticulo + '  ' + ART_Nombre) AS PRODUCTO,
		AR_QT AS CANT_OV,
		CT_MP AS IMPO_MAT,
		CT_MO AS IMPO_MO,
		CT_IN AS IMPO_IN,
		(AR_QT * (Select OVR_PrecioUnitario from OrdenesVentaReq
		Where OVR_OVDetalleId = OVD_ID) * (Select OV_MONP_Paridad from OrdenesVenta
		where OV_OrdenVentaId = OV_ID) * CT_UT) AS IMPO_UTIL,
		CT_UT AS PORC_UTIL,	
		(AR_QT * (Select OVR_PrecioUnitario from OrdenesVentaReq
		Where OVR_OVDetalleId = OVD_ID) * (Select OV_MONP_Paridad from OrdenesVenta
		where OV_OrdenVentaId = OV_ID)) AS IMPO_OV,		

		-- Materiales Teoricos LDM
		ISNULL((Select	(SUM(EAR_CantidadEnsamble * COM.ART_CostoMaterialEstandar) * AR_QT) 
		from EstructurasArticulos 
		inner join Articulos PAD on EAR_ART_ArticuloPadreId = PAD.ART_ArticuloId 
		inner join Articulos COM on EAR_ART_ComponenteId = COM.ART_ArticuloId 
		Where PAD.ART_CodigoArticulo =AR_CD),0) AS IMPO_TEO,

		-- Mano de Obra Teorico
		ISNULL((Select SUM(RUOD_TiempoManoObra) from RutasOperacion
		inner join RutasOperacionDetalle on RUO_RutasOperacionId = RUOD_RUO_RutasOperacionId
		Where RUO_ART_ArticuloId = AR_ID and RUO_Borrado = 0),0) AS TIME_TEO,

		-- Detalle de Surtimiento
		(Select	SUM(OTSE_Cantidad * -1 * ART1.ART_CostoMaterialEstandar) 
		from OrdenesTrabajoSurtimiento 
		inner join OrdenesTrabajoSurtimientoDetalle on OTSU_OrdenTrabajoSurtimientoId  = OTSE_OTSU_OrdenTrabajoSurtimientoId
		inner join OrdenesTrabajo on OT_OrdenTrabajoId = OTSU_OT_OrdenTrabajoId 
		inner join Articulos ART1 on OTSE_ART_ArticuloId = ART1.ART_ArticuloId
		Where  OT_Codigo = @OTCode) AS COSTO_REAL,
		
		-- Detalle de Seguimiento.
		(Select  SUM((CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,1,2))*24*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,4,2))*60 + CONVERT(decimal(10,2), SUBSTRING(OTSD_TiempoTotal,7,2)))/60)  
		FROM OrdenesTrabajoSeguimiento
		inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
		inner join OrdenesTrabajoSeguimientoDetalle on OTSD_OTSO_OrdenTrabajoSeguimientoOperacionId = OTSO_OrdenTrabajoSeguimientoOperacionId
		inner join OrdenesTrabajo on  OTS_OT_OrdenTrabajoId = OT_OrdenTrabajoId
		where OT_Codigo = @OTCode) AS TIME_REAL,

		-- Estatus de OT
		(Select CMM_Valor from ControlesMaestrosMultiples
		Where CMM_ControllId = (Select OT_CMM_Status from OrdenesTrabajo
		Where OT_OrdenTrabajoId = OT_ID)) AS ESTADO
from RBV_OT
inner join Articulos on ART_ArticuloId = AR_ID
Where RBV_OT.OT_CD= @OTCode



--Select * from RBV_OT Where RBV_OT.OT_CD= @OTCode



