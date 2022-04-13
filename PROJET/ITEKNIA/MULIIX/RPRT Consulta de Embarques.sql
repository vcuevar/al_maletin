-- Reporte de Embarques.
-- Ing. Vicente Cueva R.
-- Actualizado 01 de Octubre del 2019; Origen.

-- Reporte de Embarque de las OV.
--EMBB00106 del 18-Ago-21
Select * from  EmbarquesBultos Where EMBB_EmbarqueBultoId = 'BF0BB06E-5F48-4C1B-8F40-889DDAC896CC' and EMBB_Eliminado = 0

-- 14 Articulos en el Embarque todos con cantidad de 1 pza
Select * from EmbarquesBultosDetalle Where EMBBD_EMBB_EmbarqueBultoId = 'BF0BB06E-5F48-4C1B-8F40-889DDAC896CC' and EMBBD_Eliminado = 0

Select * from PreembarqueBultoDetalle Where PREBD_PreembarqueBultoDetalleId = '9EB669CE-C172-4698-A830-5650ED24BD63' and PREBD_Eliminado = 0

Select * from BultosDetalle Where BULD_BultoDetalleId = '07FB0F51-B9F6-433B-BBC3-91D1BF131238' and BULD_Eliminado = 0

Select * from OrdenesTrabajoReferencia Where OTRE_OT_OrdenTrabajoId = '841E6BDD-B327-43D0-8FD6-02B1B5DDF2D1'

Select * from OrdenesVenta Where OV_OrdenVentaId = 'F825865A-19B6-4A2A-B386-4DEDAC84E55C' and OV_Eliminado = 0

Select * from OrdenesVentaDetalle Where OVD_OV_OrdenVentaId = 'F825865A-19B6-4A2A-B386-4DEDAC84E55C' and OVD_ART_ArticuloId = '51E3FEDC-AC2D-4983-BF62-2E12063D1DC5'


-- Resumen de Embarcados.

Select OV_CodigoOV AS OV
       , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes where CLI_ClienteId = OV_CLI_ClienteId) AS CLIENTE
       , (Select PRY_CodigoEvento + '  ' + PRY_NombreProyecto from Proyectos Where PRY_ProyectoId = OV_PRO_ProyectoId) AS PROYECTO
       ,  EMBB_CodigoEmbarqueBulto AS COD_EMBARQUE
       , SUM(BULD_Cantidad * OVD_PrecioUnitario) AS EMBARCADO
from EmbarquesBultosDetalle
Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId and PREBD_Eliminado = 0
Inner Join BultosDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId and BULD_Eliminado = 0
Inner Join OrdenesTrabajoReferencia on BULD_OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Inner Join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OTRE_OV_OrdenVentaId and OVD_ART_ArticuloId = BULD_ART_ArticuloId
Inner Join OrdenesVenta on OVD_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join EmbarquesBultos on EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId
Where EMBBD_Eliminado = 0  and OV_CodigoOV = 'OV00616'
Group By OV_CodigoOV, OV_CLI_ClienteId, OV_PRO_ProyectoId, EMBB_CodigoEmbarqueBulto
